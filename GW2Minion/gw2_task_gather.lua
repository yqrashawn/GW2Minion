-- Gather
gw2_task_gather = inheritsFrom(ml_task)
gw2_task_gather.name = GetString("gatherMode")

function gw2_task_gather.Create()
	local newinst = inheritsFrom(gw2_task_gather)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}
	
	-- custom fields
	newinst.maxGrindTmr = nil
	newinst.markerTime = 0
	newinst.currentMarker = false
	newinst.filterLevel = true
	newinst.targetPos = nil
	newinst.targetID = nil
	
	-- TaskManager fields
	newinst.maxGather = 0 -- Amount of Gatherables to collect before task is completed, gets set by TaskManager Custom Conditions
	newinst.currentGather = 0 -- Counter of current task
	newinst.lastTargetID = nil -- set this value on each gather, this is used to determine if we gathered one or not 
		
    return newinst
end

function gw2_task_gather:Init()

	-- ProcessOverWatch() elements
	
	-- Handle Dead
	self:add(ml_element:create( "Dead", c_Dead, e_Dead, 500 ), self.overwatch_elements)	
	-- Handle Downed
	self:add(ml_element:create( "Downed", c_Downed, e_Doened, 450 ), self.overwatch_elements)
	-- Handle Rezz-Target is alive again or gone, deletes the subtask moveto in case it is needed
	self:add(ml_element:create( "RevivePartyMemberOverWatch", c_RezzOverWatchCheck, e_RezzOverWatchCheck, 400 ), self.overwatch_elements)
	
	
	-- FightAggro
	self:add(ml_element:create( "FightAggro", c_HandleAggro, e_HandleAggro, 250 ), self.overwatch_elements) --creates immediate queue task for combat
	
	
	-- Normal elements	
	self:add(ml_element:create( "RevivePartyMember", c_RezzPartyMember, e_RezzPartyMember, 350 ), self.process_elements)	-- creates subtask: moveto
	
	self:add(ml_element:create( "Quickvendorsell", c_quickvendorsell, e_quickvendorsell, 335 ), self.process_elements)
	self:add(ml_element:create( "Vendor-Sell", c_vendorsell, c_vendorsell, 330 ), self.process_elements)
	
	
	-- Revive other Players
	self:add(ml_element:create( "RevivePlayer", c_reviveDownedPlayersInCombat, e_reviveDownedPlayersInCombat, 300 ), self.process_elements)	-- creates subtask: moveto
	
	
	-- Resting / Wait to heal
	self:add(ml_element:create( "Resting", c_waitToHeal, e_waitToHeal, 200 ), self.process_elements)
	
	-- Normal Looting & chests
	self:add(ml_element:create( "Looting", c_Looting, e_Looting, 150 ), self.process_elements)	
	
	-- ReviveNPCs
	self:add(ml_element:create( "ReviveNPC", c_reviveNPC, e_reviveNPC, 200 ), self.process_elements) -- creates subtask: moveto
	
	-- Fight in a smaller radius towards the current marker ( this takes care of reaching it and also when running outside the markerradius and we need to move back to marker)
	-- Only for GatherMarkers...is this wanted ?
	self:add(ml_element:create( "FightTowardsGatherMarker", c_FightToGatherMarker, e_FightToGatherMarker, 125 ), self.process_elements)--creates immediate queue task for combat
	
	-- Pick the next/new Marker and makes sure we are staying near the current Marker
	self:add( ml_element:create( "NextMarker", c_MoveToGatherMarker, e_MoveToGatherMarker, 75 ), self.process_elements) -- creates subtask moveto

	-- Re-Equip Gathering Tools
	--self:add(ml_element:create( "EquippingGatherTool", c_GatherToolsCheck, e_GatherToolsCheck, 110 ), self.process_elements)
	
	
	-- TODO: Add a check CnE here for aggro when we are close to our gather node to gather 
	
	-- Check for gatherable Target
	self:add(ml_element:create( "GetNextGatherable", c_Gathering, e_Gathering, 50 ), self.process_elements) -- creates subtask moveto 
		
	-- Move to a Randompoint if there is nothing to fight around us
	self:add( ml_element:create( "movetorandom", c_movetorandom, e_movetorandom, 25 ), self.process_elements)
	

	self:AddTaskCheckCEs()
end

function gw2_task_gather:UIInit()
	local mw = WindowManager:GetWindow(gw2minion.MainWindow.Name)
	if ( mw ) then
		mw:NewCheckBox(GetString("doEvents"),"gDoEvents",GetString("gatherMode"))		
		mw:UnFold( GetString("gatherMode") );
	end
	
	Settings.GW2Minion.gDoEvents = Settings.GW2Minion.gDoEvents or "1"
	
	gDoEvents = Settings.GW2Minion.gDoEvents
	return true
end
function gw2_task_gather:UIDestroy()
	d("gw2_task_gather:UIDestroy")
	GUI_DeleteGroup(gw2minion.MainWindow.Name, GetString("gatherMode"))
end

function gw2_task_gather.ModuleInit()
	d("gw2_task_gather:ModuleInit")

	-- Setup Debug fields
	local dw = WindowManager:GetWindow(gw2minion.DebugWindow.Name)
	if ( dw ) then
		dw:NewField("TargetID","dbCurrGatherTargetID","Task_Gather")
		dw:NewField("TargetDist","dbCurrGatherTargetDist","Task_Gather")
		dw:NewField("GatherCount","dbGatherCount","Task_Gather")		
	end
	
	ml_task_mgr.AddTaskType(GetString("gatherMode"), gw2_task_gather) -- Allow this task to be selectable in TaskManager
end

-- TaskManager functions
function gw2_task_gather:UIInit_TM()
	ml_task_mgr.NewNumeric("Max Gatherables", "maxGather")
	
end
-- TaskManager function: Checks for custom conditions to start this task
function gw2_task_gather.CanTaskStart_TM()
	return true
end
-- TaskManager function: Checks for custom conditions to keep this task running
function gw2_task_gather.CanTaskRun_TM()
	
	-- Check the maxgather counter
	if ( ml_task_hub:CurrentTask().maxGather ~= nil and tonumber(ml_task_hub:CurrentTask().maxGather) ~= nil ) then
		
		if ( ml_global_information.ShowDebug ) then 
			dbGatherCount = tostring(ml_task_hub:CurrentTask().currentGather).."/"..tostring(ml_task_hub:CurrentTask().maxGather).." Kills"
		end
		
		ml_log(" "..tostring(ml_task_hub:CurrentTask().currentGather).."/"..tostring(ml_task_hub:CurrentTask().maxGather).." Gathered")
		-- We gathered enough		
		if ( tonumber(ml_task_hub:CurrentTask().maxGather) <=  ml_task_hub:CurrentTask().currentGather ) then return false end 
		
		-- Check if a targeted gatherable got collected meanwhile
		if ( ml_task_hub:CurrentTask().lastTargetID ~= nil and tonumber(ml_task_hub:CurrentTask().lastTargetID) ~= nil) then
			local target = GadgetList:Get(tonumber(ml_task_hub:CurrentTask().lastTargetID))
			if ( not target or not target.interactable ) then
				ml_task_hub:CurrentTask().currentGather = tonumber(ml_task_hub:CurrentTask().currentGather) + 1
				ml_task_hub:CurrentTask().lastTargetID = nil
			end
		end
	end	
	return true
end



-- for Creating this task as subtask
c_GatherTask = inheritsFrom( ml_cause )
e_GatherTask = inheritsFrom( ml_effect )
c_GatherTask.throttle = 1500
c_GatherTask.target = nil
function c_GatherTask:evaluate()	
	if ( gGather == "1" and ml_global_information.Player_Inventory_SlotsFree > 0 ) then
		-- Find new gather target.
		if (c_GatherTask.target == nil) then
			if (gBotMode == GetString("gatherMode")) then
				c_GatherTask.target = GadgetList("onmesh,gatherable,selectable,shortestpath")
			else
				c_GatherTask.target = GadgetList("onmesh,gatherable,selectable,shortestpath,maxdistance=3500")
			end			
		end		
		return ( ValidTable(c_GatherTask.target) )		
		
	end
	c_GatherTask.target = nil	
	return false
end
function e_GatherTask:execute()	
	ml_log("e_GatherTask")
	
	if ( ml_global_information.Player_IsMoving ) then Player:StopMovement() end
	
	-- For TM Conditions
	ml_task_hub:CurrentTask().lastTargetID = c_GatherTask.target.id
	
	local newTask = gw2_task_gather.Create()
	newTask.targetPos = c_GatherTask.target.pos
	newTask.targetID = c_GatherTask.target.id
	ml_task_hub:CurrentTask():AddSubTask(newTask)
	--ml_task_hub:Add(newTask.Create(), REACTIVE_GOAL, TP_ASAP)	
end



-- Handles Aggro for gathering, doesnt fight everything basicly and tries to run towards the next gatherable instead 
c_HandleAggro = inheritsFrom( ml_cause )
e_HandleAggro = inheritsFrom( ml_effect )
c_HandleAggro.target = nil
c_HandleAggro.HealthTreshold = math.random(50,85)
function c_HandleAggro:evaluate()
	if ( ml_global_information.Player_Health.percent < c_HandleAggro.HealthTreshold or TableSize(GadgetList("onmesh,nearest,gatherable,maxdistance=500")) > 1 ) then
		local target = gw2_common_functions.GetBestAggroTarget()
		if ( target ) then
			c_HandleAggro.target = target
			return ml_global_information.Player_SwimState == GW2.SWIMSTATE.NotInWater and c_HandleAggro.target ~= nil			
		end
	end
	c_HandleAggro.target = nil
	return false
end
function e_HandleAggro:execute()
	ml_log("e_HandleAggro ")
			
	if (c_HandleAggro.target ~= nil) then
		c_HandleAggro.HealthTreshold = math.random(50,85)
		Player:StopMovement()
		-- stop the char from reviving else it doesnt do sh!t in combat task
		if ( Player.castinfo.duration ~= 0 ) then
			Player:Jump()
		end
		local newTask = gw2_task_combat.Create()
		newTask.targetID = c_HandleAggro.target.id		
		newTask.targetPos = c_HandleAggro.target.pos		
		ml_task_hub:Add(newTask.Create(), IMMEDIATE_GOAL, TP_IMMEDIATE)
		c_HandleAggro.target = nil
	else
		ml_log("e_HandleAggro found no target")
	end
	return ml_log(false)
end


--------- Creates a new IMMEDIATE_GOAL task to kill an enemy when we are fighting our way towards the current gatherMarker
c_FightToGatherMarker = inheritsFrom( ml_cause )
e_FightToGatherMarker = inheritsFrom( ml_effect )
c_FightToGatherMarker.target = nil
function c_FightToGatherMarker:evaluate()
	if ( c_MoveToGatherMarker.markerreached == false and c_MoveToGatherMarker.allowedToFight == true) then
		local target = gw2_common_functions.GetBestCharacterTarget( 1250 ) -- maxrange 2000 where enemies should be searched for
		if ( target ) then
			c_FightToGatherMarker.target = target
			return ml_global_information.Player_SwimState == GW2.SWIMSTATE.NotInWater and c_FightToGatherMarker.target ~= nil			
		end
	end
	c_FightToGatherMarker.target = nil
	return false
end
function e_FightToGatherMarker:execute()
	ml_log("e_FightToGatherMarker ")
			
	if (c_FightToGatherMarker.target ~= nil) then
		Player:StopMovement()
		local newTask = gw2_task_combat.Create()
		newTask.targetID = c_FightToGatherMarker.target.id		
		newTask.targetPos = c_FightToGatherMarker.target.pos		
		ml_task_hub:Add(newTask.Create(), IMMEDIATE_GOAL, TP_IMMEDIATE)
		c_FightToGatherMarker.target = nil
	else
		ml_log("e_FightToGatherMarker found no target")
	end
	return ml_log(false)
end

---------
-- Moves player towards the current marker and makes sure we are still inside the radius around the marker, moves the player randomly around the maker to kill n find stuff
-- If Markertime is up, it will pick also the next marker
-- If there are no Maker in the current mesh, it will pick a random point and go there
c_MoveToGatherMarker = inheritsFrom( ml_cause )
e_MoveToGatherMarker = inheritsFrom( ml_effect )
c_MoveToGatherMarker.markerreachedfirsttime = false
c_MoveToGatherMarker.markerreached = false
c_MoveToGatherMarker.allowedToFight = false -- this sh*t is needed else he will go back n forth on the outer side of the marker's min radius if an enemy sits at larger-min-dist behind that radius -.-
function c_MoveToGatherMarker:evaluate()
	-- Get a new/next Marker if we need one ( no marker , out of level, time up )
	if (ml_task_hub:CurrentTask().currentMarker == nil or ml_task_hub:CurrentTask().currentMarker == false 
		or ( ml_task_hub:CurrentTask().filterLevel and ml_task_hub:CurrentTask().currentMarker:GetMinLevel() and ml_task_hub:CurrentTask().currentMarker:GetMaxLevel() and (ml_global_information.Player_Level < ml_task_hub:CurrentTask().currentMarker:GetMinLevel() or ml_global_information.Player_Level > ml_task_hub:CurrentTask().currentMarker:GetMaxLevel())) 
		or ( ml_task_hub:CurrentTask().currentMarker:GetTime() and ml_task_hub:CurrentTask().currentMarker:GetTime() ~= 0 and TimeSince(ml_task_hub:CurrentTask().markerTime) > ml_task_hub:CurrentTask().currentMarker:GetTime() * 1000 )) then
		-- TODO: ADD TIMEOUT FOR MARKER
		ml_task_hub:CurrentTask().currentMarker = ml_marker_mgr.GetNextMarker(GetString("gatherMarker"), ml_task_hub:CurrentTask().filterLevel)
		
		-- disable the levelfilter in case we didnt find any other marker
		if (ml_task_hub:CurrentTask().currentMarker == nil) then
			ml_task_hub:CurrentTask().filterLevel = false
			ml_task_hub:CurrentTask().currentMarker = ml_marker_mgr.GetNextMarker(GetString("gatherMarker"), ml_task_hub:CurrentTask().filterLevel)
		end
		
		-- we found a new marker, setup vars
		if ( ml_task_hub:CurrentTask().currentMarker ~= nil ) then
			d("New Grind Marker set!")
			ml_task_hub:CurrentTask().markerTime = ml_global_information.Now -- Are BOTH needed to get updated ?
			ml_global_information.MarkerTime = ml_global_information.Now     -- This needs to be global else we cannot access the stuff in parent or subtasks
			ml_global_information.MarkerMinLevel = ml_task_hub:CurrentTask().currentMarker:GetMinLevel()
			ml_global_information.MarkerMaxLevel = ml_task_hub:CurrentTask().currentMarker:GetMaxLevel()	
			c_MoveToGatherMarker.markerreached = false
			c_MoveToGatherMarker.markerreachedfirsttime = false
		end
	end
	
	-- We have a valid current gatherMarker
    if (ml_task_hub:CurrentTask().currentMarker ~= false and ml_task_hub:CurrentTask().currentMarker ~= nil) then
        
		-- Reset the Markertime until we actually reached the marker the first time and then let it count down
		if (c_MoveToGatherMarker.markerreachedfirsttime == false ) then
			ml_task_hub:CurrentTask().markerTime = ml_global_information.Now
			ml_global_information.MarkerTime = ml_global_information.Now
		end
		
		-- Debug info
		if ( ml_global_information.ShowDebug ) then dbCurrMarker = ml_task_hub:CurrentTask().currentMarker:GetName() or "" end
		
		-- We haven't reached the currentMarker or ran outside its radius
		if ( c_MoveToGatherMarker.markerreached == false) then			
			return true
		
		else
			-- check if we ran outside the currentMarker radius and if so, we need to walk back to the currentMarker
			local pos = ml_task_hub:CurrentTask().currentMarker:GetPosition()
			local distance = Distance2D(ml_global_information.Player_Position.x, ml_global_information.Player_Position.y, pos.x, pos.y)			
			if  (gBotMode == GetString("grindMode") and distance > ml_task_hub:CurrentTask().currentMarker:GetFieldValue(GetString("maxRange"))) then
				d("We need to move back to our current Marker!")
				c_MoveToGatherMarker.markerreached = false
				c_MoveToGatherMarker.allowedToFight = false
				return true
			end
		end		
	end
	
    return false
end
function e_MoveToGatherMarker:execute()
	ml_log(" e_MoveToGatherMarker ")
	-- Move to our current marker
	if (ml_task_hub:CurrentTask().currentMarker ~= nil and ml_task_hub:CurrentTask().currentMarker ~= false) then
		
		local pos = ml_task_hub:CurrentTask().currentMarker:GetPosition()
		local dist = Distance2D(ml_global_information.Player_Position.x, ml_global_information.Player_Position.y, pos.x, pos.y)
		
		-- Allow fighting when we are far away from the "outside radius of the marker" , else the bot goes back n forth spinning trying to reach the target outside n going back inside right after
		if ( dist < ml_task_hub:CurrentTask().currentMarker:GetFieldValue(GetString("maxRange"))) then
			c_MoveToGatherMarker.allowedToFight = true
		else
			c_MoveToGatherMarker.allowedToFight = false
		end
		
		if  ( dist < 200) then
			-- We reached our Marker
			c_MoveToGatherMarker.markerreached = true
			c_MoveToGatherMarker.markerreachedfirsttime = true
			d("Reached current Marker...")
			return ml_log(true)		
		else
			-- We need to reach our Marker yet
			-- make sure the next marker is reachable & onmesh
			if ( ValidTable(NavigationManager:GetPath(ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z,pos.x,pos.y,pos.z))) then
				
				local newTask = gw2_task_moveto.Create()
				newTask.name = "MoveTo GatherMarker"
				newTask.targetPos = pos
				ml_task_hub:CurrentTask():AddSubTask(newTask)
				return ml_log(true)
				
			else
				d("WARNING: Cannot reach next Marker, trying to pick another one...")
				ml_task_hub:CurrentTask().currentMarker = nil
				-- Debug info
				if ( ml_global_information.ShowDebug ) then dbCurrMarker = "" end 
			end
		end
	end
	return ml_log(false)
end



c_Gathering = inheritsFrom( ml_cause )
e_Gathering = inheritsFrom( ml_effect )
function c_Gathering:evaluate()
	
	if ( ml_task_hub:CurrentTask().targetID ~= nil and ml_task_hub:CurrentTask().targetPos ~= nil ) then 
		-- this task is a subtask and should terminate once the targetPos is reached and no targetID nearby 
		local pPos = ml_global_information.Player_Position
		local tPos = ml_task_hub:CurrentTask().targetPos
		local dist = Distance3D(tPos.x, tPos.y, tPos.z, pPos.x, pPos.y, pPos.z)
		
		if ( ml_global_information.ShowDebug ) then 
			dbCurrGatherTargetID = ml_task_hub:CurrentTask().targetID or "" 
			dbCurrGatherTargetDist = math.floor(dist) 
		end
	
		if (dist > 1000) then
			return true
		else
			-- check if gatherable still exist
			local gadget = GadgetList:Get(ml_task_hub:CurrentTask().targetID)
			if ( gadget ~= nil ) then
				return true
			else
				-- Our gatherable is gone, finishing this subtask / getting next gatherable in next pulse
				if (gBotMode ~= GetString("gatherMode")) then
					ml_task_hub:CurrentTask().completed = true
					ml_task_hub:CurrentTask().targetID = nil
					ml_task_hub:CurrentTask().targetPos = nil
				end
				return false
			end
		end
		
	else		
		
		local GList = GadgetList("onmesh,gatherable,selectable,shortestpath")
		if ( TableSize(GList) > 0 ) then 
			local id,gadget = next(GList)
			if ( id and gadget ~= nil ) then
				ml_task_hub:CurrentTask().targetID = gadget.id
				ml_task_hub:CurrentTask().targetPos = gadget.pos
				
				if ( ml_global_information.ShowDebug ) then 
					dbCurrGatherTargetID = ml_task_hub:CurrentTask().targetID or "" 
					dbCurrGatherTargetDist = math.floor(gadget.distance) 
				end
				
				return true
			end
		end	
	end
	return false
end

e_Gathering.tmr = 0
e_Gathering.threshold = 500
e_Gathering.circling = false
function e_Gathering:execute()
	ml_log("e_Gathering")
	
	if ( ml_task_hub:CurrentTask().targetID ~= nil and ml_task_hub:CurrentTask().targetPos ~= nil ) then 
		
		local pPos = ml_global_information.Player_Position
		local tPos = ml_task_hub:CurrentTask().targetPos
		local dist = Distance3D(tPos.x, tPos.y, tPos.z, pPos.x, pPos.y, pPos.z)
		
		-- MoveIntoInteractRange
		if (dist > 1000) then
			
			local newTask = gw2_task_moveto.Create()
			newTask.targetPos = tPos
			newTask.name = "MoveTo Gatherable"
			ml_task_hub:CurrentTask():AddSubTask(newTask)
			return ml_log(true)
		
		else
			
			if (Player.isGathering) then
				ml_log(": Gathering busy.")
				if ( ml_global_information.Player_IsMoving ) then Player:StopMovement() end
				return ml_log(true)
				
			else
				local gadget = GadgetList:Get(ml_task_hub:CurrentTask().targetID)
				if ( gadget ~= nil and gadget.gatherable) then
					
					-- We are in range to gather
					if (gadget.isInInteractRange) then
						gw2_common_functions.NecroLeaveDeathshroud()
						-- Check if in water and prevent stuck.
						if (Player.swimming == GW2.SWIMSTATE.Swimming) then
							Player:SetMovement(0)
							Player:SetMovement(4)
							e_Gathering.circling = true
							ml_log(": Moving out of water.")
							
						elseif (e_Gathering.circling == true) then
							Player:UnSetMovement(0)
							Player:UnSetMovement(4)
							e_Gathering.circling = false
						end		
						
						ml_log(": Gathering starting.")
						if ( ml_global_information.Player_IsMoving ) then Player:StopMovement() end
						
						if ( Player:GetCurrentlyCastedSpell() == 17 ) then	
							Player:Interact(gadget.id)
							ml_global_information.Wait(500)
						end
						
					else
						ml_log(": Walking to Gatherable.")
						gw2_common_functions.MoveOnlyStraightForward()
						-- Moving to gadget position.
						if ( not gw2_unstuck.HandleStuck() ) then
							local tPos = gadget.pos
							Player:MoveTo(tPos.x,tPos.y,tPos.z,25,false,false,false)
						end
					end
					return ml_log(true)
					
				end
			end
		end
	end
	
	ml_task_hub:CurrentTask().targetID = nil 
	ml_task_hub:CurrentTask().targetPos = nil
	return ml_log(false)
end





ml_global_information.AddBotMode(GetString("gatherMode"), gw2_task_gather)
RegisterEventHandler("Module.Initalize",gw2_task_gather.ModuleInit)
