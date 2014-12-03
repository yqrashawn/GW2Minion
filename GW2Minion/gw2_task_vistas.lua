-- This task is for the TaskManager and will try to discover vistas
gw2_task_vistas = inheritsFrom(ml_task)
gw2_task_vistas.name = GetString("taskVista")

function gw2_task_vistas.Create()
	local newinst = inheritsFrom(gw2_task_vistas)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}
	
	-- General fields	
	newinst.startTime = ml_global_information.Now

    return newinst
end

function gw2_task_vistas:Init()

			
	-- Normal elements
	-- Revive Downed/Dead Partymember
	self:add(ml_element:create( "RevivePartyMember", c_RezzPartyMember, e_RezzPartyMember, 375 ), self.process_elements)	-- creates subtask: moveto
	-- Revive other Players
	self:add(ml_element:create( "RevivePlayer", c_reviveDownedPlayersInCombat, e_reviveDownedPlayersInCombat, 350 ), self.process_elements)	-- creates subtask: moveto
	-- FightAggro
	self:add(ml_element:create( "FightAggro", c_FightAggro, e_FightAggro, 325 ), self.process_elements) --creates immediate queue task for combat
	
	-- Resting / Wait to heal
	self:add(ml_element:create( "Resting", c_waitToHeal, e_waitToHeal, 300 ), self.process_elements)
	
	-- Normal Looting & chests
	self:add(ml_element:create( "Looting", c_Looting, e_Looting, 275 ), self.process_elements)

	-- SMoveToVista
	self:add(ml_element:create( "MoveToVista", c_MoveToVista, e_MoveToVista, 125 ), self.process_elements)

	-- ViewVista
	self:add(ml_element:create( "ViewVista", c_ViewVista, e_ViewVista, 100 ), self.process_elements)
	

	self:AddTaskCheckCEs()
end
function gw2_task_vistas:task_complete_eval()
	-- Check for nearby unfinished HQs
	if ( ml_task_hub:CurrentTask().started == true ) then
		
		local dist = Distance3D(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z)		
		if ( dist < 8000 ) then
			local evList = MapMarkerList("nearest,onmesh,isvista,contentID="..GW2.MAPMARKER.Vista)
			if ( evList ) then 
				local i,event = next(evList)
				if ( i and event ) then
					return false
				end				
			end
			-- We are close to the startpoint of the Vista but no unfinished HQ was found
			d("No undiscovered Vista nearby found, I guess we are done here.")
			ml_task_hub:CurrentTask().completed = true
			return true
			
		else
			ml_log("Distance to Vista: "..tostring(dist))
			
		end
	end
	return false
end

function gw2_task_vistas:UIInit()	
	return true
end
function gw2_task_vistas:UIDestroy()
	
end

function gw2_task_vistas.ModuleInit()
	d("gw2_task_vistas:ModuleInit")

	-- Setup Debug fields
	local dw = WindowManager:GetWindow(gw2minion.DebugWindow.Name)
	if ( dw ) then		
		dw:NewField("Duration","dbVistaDuration","Task_Vista")		
	end
	
	ml_task_mgr.AddTaskType(GetString("taskVista"), gw2_task_vistas) -- Allow this task to be selectable in TaskManager
end

-- TaskManager functions
function gw2_task_vistas:UIInit_TM()

end
-- TaskManager function: Checks for custom conditions to start this task, this is checked before the task is selected to be enqueued/created
function gw2_task_vistas.CanTaskStart_TM()	
	return true
end
-- TaskManager function: Checks for custom conditions to keep this task running, this is checked during the task is actively running
function gw2_task_vistas.CanTaskRun_TM()
		
	-- since this is called independent of the tasksystem, it 
	if ( ml_task_hub:CurrentTask().startTime ~= nil ) then
		dbVistaDuration = tostring(math.floor((ml_global_information.Now-ml_task_hub:CurrentTask().startTime)/1000))
	end		
	return true
end

c_MoveToVista = inheritsFrom( ml_cause )
e_MoveToVista = inheritsFrom( ml_effect )
e_MoveToVista.targetPos = nil
function c_MoveToVista:evaluate()
	if ( ml_task_hub:CurrentTask().pos ~= nil ) then
		local startPos = ml_task_hub:CurrentTask().pos
		local dist = Distance3D(startPos.x,startPos.y,startPos.z,ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z)
				
		if ( dist > 100 ) then
			e_MoveToVista.targetPos = startPos
			return true		
		end
		
	else
		ml_error("c_MoveToVista no valid task position")
	end
	e_MoveToVista.targetPos = nil
	return false
end
function e_MoveToVista:execute()
	ml_log("e_MoveToVista ")
	if ( e_MoveToVista.targetPos ~= nil ) then
		local newTask = gw2_task_moveto.Create()
		newTask.name = "e_MoveToVista "..ml_task_hub:CurrentTask().mytask.name.." StartPosition"
		newTask.targetPos = e_MoveToVista.targetPos				
		ml_task_hub:CurrentTask():AddSubTask(newTask)
		return ml_log(true)
		
	else
		ml_error("e_MoveToVista no valid task position")
	end		
	return ml_log(false)
end

-- Interact with stuff than we should interact with 
c_ViewVista = inheritsFrom( ml_cause )
e_ViewVista = inheritsFrom( ml_effect )
e_ViewVista.marker = nil
function c_ViewVista:evaluate()
	-- we should be near a vista now..
	local MList = MapMarkerList("nearest,onmesh,isvista,contentID="..GW2.MAPMARKER.Vista)
	if ( MList ) then 
		local i,marker = next(MList)
		if ( i and marker ) then
			e_ViewVista.marker = marker
			return true			
		end				
	end
	e_ViewVista.marker = nil
	return false
end
function e_ViewVista:execute()
	ml_log("e_ViewVista ")
	if ( e_ViewVista.marker ~= nil ) then
				
		if ( e_ViewVista.marker.distance < 100 ) then
			local vista = Player:GetInteractableTarget()
			if ( vista ) then 
				if ( Player:GetCurrentlyCastedSpell() == 17 ) then					
					Player:Interact(vista.id)	
					ml_global_information.Wait(1500)
				end
			end
			e_ViewVista.marker = nil
			return ml_log(true)
		else
			
			local ePos = e_ViewVista.marker.pos
			if ( not gw2_unstuck.HandleStuck() ) then
				local navResult = tostring(Player:MoveTo(ePos.x,ePos.y,ePos.z,50,false,false,false))		
				if (tonumber(navResult) < 0) then					
					d("MoveToVista result: "..tonumber(navResult))
				else
					return ml_log(true)
				end
			end
		end
	end
	return ml_log(false)
end


RegisterEventHandler("Module.Initalize",gw2_task_vistas.ModuleInit)