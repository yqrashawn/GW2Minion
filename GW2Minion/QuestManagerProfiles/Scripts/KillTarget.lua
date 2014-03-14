-- Goto Position x,y,z script for QuestManager
script = inheritsFrom( ml_task )
script.name = "KillTarget"
script.Data = {}

--******************
-- ml_quest_mgr Functions
--******************
function script:UIInit( identifier )
	-- You need to create the ScriptUI Elements exactly like you see here, the "event" needs to start with "tostring(identifier).." and the group needs to be GetString("questStepDetails")
	GUI_NewField(ml_quest_mgr.stepwindow.name,"Target Name",tostring(identifier).."TargetName",GetString("questStepDetails"))
	GUI_NewField(ml_quest_mgr.stepwindow.name,"Target contentID",tostring(identifier).."TargetcontentID",GetString("questStepDetails"))
	GUI_NewButton(ml_quest_mgr.stepwindow.name,"Set Current Target",tostring(identifier).."SetTarget",GetString("questStepDetails"))
	GUI_NewNumeric(ml_quest_mgr.stepwindow.name,"Waiting Time for Target to Spawn",tostring(identifier).."_TargetSpawnTime",GetString("questStepDetails"),"0","999");
	
end

function script:SetData( identifier, tData )
	-- Save the data in our script-"instance" aka global variables and set the UI elements
	if ( identifier and tData ) then		
		--d("script:SetData: "..tostring(identifier))
				
		self.Data = tData
		
		-- Update the script UI (make sure the Data assigning to a _G is NOT nil! else crashboooombang!)
		if ( self.Data["TargetName"] ) then _G[tostring(identifier).."TargetName"] = self.Data["TargetName"] end
		if ( self.Data["TargetcontentID"] ) then _G[tostring(identifier).."TargetcontentID"] = self.Data["TargetcontentID"] end
		if ( self.Data["_TargetSpawnTime"] ) then _G[tostring(identifier).."_TargetSpawnTime"] = self.Data["_TargetSpawnTime"] end
	end
end

function script:EventHandler( identifier, event, value )
	-- for extended UI event handling, gets called when a scriptUI element is pressed	
	if ( event == "SetTarget" ) then
		local target = Player:GetTarget()
		if ( target ) then
			-- Set Data
			self.Data["TargetName"] = target.name
			self.Data["TargetcontentID"] = target.contentID
			-- Update UI fields
			_G[tostring(identifier).."TargetName"] = target.name
			_G[tostring(identifier).."TargetcontentID"] = target.contentID
		end
	end
	
end

--******************
-- ml_Task Functions
--******************
script.valid = true
script.completed = false
script.subtask = nil
script.process_elements = {}
script.overwatch_elements = {} 

function script:Init()
    -- Add Cause&Effects here
	-- Dead?
	self:add(ml_element:create( "Dead", c_dead, e_dead, 225 ), self.process_elements)
	
	-- Downed
	self:add(ml_element:create( "Downed", c_downed, e_downed, 200 ), self.process_elements)
	
	-- AoELooting Characters
	self:add(ml_element:create( "AoELoot", c_AoELoot, e_AoELoot, 175 ), self.process_elements)
			
	-- Normal Chests	
	self:add(ml_element:create( "LootingChest", c_LootChests, e_LootChests, 155 ), self.process_elements)
	
	-- Resting
	self:add(ml_element:create( "Resting", c_resting, e_resting, 145 ), self.process_elements)	

	-- Normal Looting
	self:add(ml_element:create( "Looting", c_LootCheck, e_LootCheck, 130 ), self.process_elements)

	-- Deposit Items
	self:add(ml_element:create( "DepositingItems", c_deposit, e_deposit, 120 ), self.process_elements)	
	
	-- Find Target
	self:add(ml_element:create( "FindTarget", self.c_findtarget, self.e_findtarget, 110 ), self.process_elements)
	
	-- Get into Combat Range
	self:add(ml_element:create( "MovingIntoCombatRange", c_MoveIntoCombatRange, e_MoveIntoCombatRange, 100 ), self.process_elements)
	
	-- Kill Target
	self:add(ml_element:create( "KillTarget", c_KillTarget, e_KillTarget, 90 ), self.process_elements)
	
	-- Done?
	self:add(ml_element:create( "Done", c_done, e_done, 50 ), self.process_elements)
	
	self:AddTaskCheckCEs()
end


function script:task_complete_eval()		
	return false
end
function script:task_complete_execute()
   self.completed = true
end



-- Cause&Effect
script.c_findtarget = inheritsFrom( ml_cause )
script.e_findtarget = inheritsFrom( ml_effect )
script.kTarget = nil
script.kTargetTmr = 0
function script.c_findtarget:evaluate() 
	if (ml_task_hub:CurrentTask().Data["TargetName"] ~= nil and
		ml_task_hub:CurrentTask().Data["TargetcontentID"] ~= nil and
		kTarget == nil) then
		return true
	elseif (kTarget == nil) then
		ml_error("Quest KillTarget Step has no Target set!")
		ml_task_hub:CurrentTask().completed = true
	end
	return false
end
function script.e_findtarget:execute()
	ml_log("e_killtarget")
	if (kTarget == nil) then
		local targets = ( CharacterList("shortestpath,attackable,alive,onmesh,maxpathdistance=4000") )
		if (targets) then
			local id,target = next(targets)
			while (id and target) do
				if (tonumber(ml_task_hub:CurrentTask().Data["TargetcontentID"]) == target.contentID ) then
					kTarget = target
					Player:SetTarget(target.id)
					script.kTargetTmr = mc_global.now
					break
				end
				id,target = next(targets, id)
			end
		end
	else
		-- timer
		if ( script.kTargetTmr == 0 ) then 
			script.kTargetTmr = mc_global.now
		elseif ( mc_global.now - script.kTargetTmr > tonumber(ml_task_hub:CurrentTask().Data["_TargetSpawnTime"])*1000 ) then
			d("No enemy found in 30 seconds, ending step")
			ml_task_hub:CurrentTask().completed = true
		end
	end
	return ml_log(false)
end

script.c_done = inheritsFrom( ml_cause )
script.e_done = inheritsFrom( ml_effect )
function script.c_done:evaluate() 
	local targets = ( CharacterList("shortestpath,attackable,alive,onmesh,maxpathdistance=4000") )
	if (targets) then
		local id,target = next(targets)
		while (id and target) do
			if (tonumber(ml_task_hub:CurrentTask().Data["TargetcontentID"]) == target.contentID and target.alive ) then
				script.kTargetTmr = mc_global.now
				return false
			end
			id,target = next(targets, id)
		end	
	end
	-- timer
	if ( script.kTargetTmr == 0 ) then 
		script.kTargetTmr = mc_global.now
	elseif ( mc_global.now - script.kTargetTmr > tonumber(ml_task_hub:CurrentTask().Data["_TargetSpawnTime"])*1000 ) then
		d("No enemies found in 30 seconds, ending step")
		ml_task_hub:CurrentTask().completed = true
	end
	return true
end
function script.e_done:execute()
	ml_task_hub:CurrentTask().completed = true
end


return script