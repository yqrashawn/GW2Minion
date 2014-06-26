-- Goto Position x,y,z script for QuestManager
script = inheritsFrom( ml_task )
script.name = "KillTargetEx"
script.Data = {}

--******************
-- ml_quest_mgr Functions
--******************
function script:UIInit( identifier )
	-- You need to create the ScriptUI Elements exactly like you see here, the "event" needs to start with "tostring(identifier).." and the group needs to be GetString("questStepDetails")
	GUI_NewField(ml_quest_mgr.stepwindow.name,"Target Name",tostring(identifier).."TargetName",GetString("questStepDetails"))
	GUI_NewField(ml_quest_mgr.stepwindow.name,"Target contentID",tostring(identifier).."TargetcontentID",GetString("questStepDetails"))
	GUI_NewButton(ml_quest_mgr.stepwindow.name,"Set Current Target",tostring(identifier).."SetTarget",GetString("questStepDetails"))
	GUI_NewNumeric(ml_quest_mgr.stepwindow.name,"KillCount",tostring(identifier).."_TargetKillCount",GetString("questStepDetails"),"0","9999");
	GUI_NewNumeric(ml_quest_mgr.stepwindow.name,"Waiting Time for Target to Spawn",tostring(identifier).."_TargetSpawnTime",GetString("questStepDetails"),"0","9999");
	GUI_NewNumeric(ml_quest_mgr.stepwindow.name,"Target HP >",tostring(identifier).."_TargetHPMax",GetString("questStepDetails"),"0","100");
	GUI_NewNumeric(ml_quest_mgr.stepwindow.name,"Target HP <",tostring(identifier).."_TargetHPMin",GetString("questStepDetails"),"0","100");
end

function script:SetData( identifier, tData )
	-- Save the data in our script-"instance" aka global variables and set the UI elements
	if ( identifier and tData ) then		
		--d("script:SetData: "..tostring(identifier))
				
		self.Data = tData
		
		-- Update the script UI (make sure the Data assigning to a _G is NOT nil! else crashboooombang!)
		if ( self.Data["TargetName"] ) then _G[tostring(identifier).."TargetName"] = self.Data["TargetName"] end
		if ( self.Data["TargetcontentID"] ) then _G[tostring(identifier).."TargetcontentID"] = self.Data["TargetcontentID"] end
		if ( self.Data["_TargetKillCount"] ) then _G[tostring(identifier).."_TargetKillCount"] = self.Data["_TargetKillCount"] end
		if ( self.Data["_TargetSpawnTime"] ) then _G[tostring(identifier).."_TargetSpawnTime"] = self.Data["_TargetSpawnTime"] end
		if ( self.Data["_TargetHPMax"] ) then _G[tostring(identifier).."_TargetHPMax"] = self.Data["_TargetHPMax"] end
		if ( self.Data["_TargetHPMin"] ) then _G[tostring(identifier).."_TargetHPMin"] = self.Data["_TargetHPMin"] end
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

	-- Normal Looting
	self:add(ml_element:create( "Looting", c_LootCheck, e_LootCheck, 150 ), self.process_elements)
	
	-- Aggro
	self:add(ml_element:create( "Aggro", c_Aggro, e_Aggro, 145 ), self.process_elements) --reactive queue

	-- Deposit Items
	self:add(ml_element:create( "DepositingItems", c_deposit, e_deposit, 140 ), self.process_elements)
	
	-- Resting
	self:add(ml_element:create( "Resting", c_resting, e_resting, 135 ), self.process_elements)	
	
	-- Salvaging
	self:add(ml_element:create( "Salvaging", c_salvage, e_salvage, 111 ), self.process_elements)
	
	-- Find Target
	self:add(ml_element:create( "FindTarget", self.c_findtarget, self.e_findtarget, 110 ), self.process_elements)
	
	-- Get into Combat Range
	self:add(ml_element:create( "MovingIntoCombatRange", c_MoveIntoCombatRange, e_MoveIntoCombatRange, 100 ), self.process_elements)
		
	-- Kill Target
	self:add(ml_element:create( "KillTarget", c_KillTarget, e_KillTarget, 90 ), self.process_elements)
	
	self:AddTaskCheckCEs()
end


function script:task_complete_eval()		
	if ( ml_task_hub:CurrentTask().Data["_TargetKillCount"] ~= nil and tonumber(script.kTargetCount)~=nil ) then
		ml_log("_"..tostring(script.kTargetCount).."_of_"..tostring(ml_task_hub:CurrentTask().Data["_TargetKillCount"]).."_killed_")
		if (tonumber(script.kTargetCount) >= tonumber(ml_task_hub:CurrentTask().Data["_TargetKillCount"] )) then
			return true
		end
	end
	return false
end
function script:task_complete_execute()
   self.completed = true
end

-- Cause&Effect
script.c_findtarget = inheritsFrom( ml_cause )
script.e_findtarget = inheritsFrom( ml_effect )
script.kTargetID = nil
script.kLastTargetID = nil
script.kTargetTmr = 0
script.kTargetCount = 0
function script.c_findtarget:evaluate() 
	if (ml_task_hub:CurrentTask().Data["TargetName"] ~= nil and	ml_task_hub:CurrentTask().Data["TargetcontentID"] ~= nil ) then
		local targ = Player:GetTarget()
		if ( targ == nil ) then			
			return true		
		end
	else
		ml_error("Quest KillTarget Step has no Target set!")
		ml_task_hub:CurrentTask().completed = true
	end
	return false
end
function script.e_findtarget:execute()
	
	-- Check if we got a new target, raise counter
	if ( script.kTargetID ~= nil ) then 		
		if ( script.kLastTargetID == nil ) then 
			script.kLastTargetID = script.kTargetID
		elseif ( script.kLastTargetID ~= script.kTargetID ) then
			script.kLastTargetID = script.kTargetID
			script.kTargetCount = script.kTargetCount + 1
		end
	end
	-- Get a new target with contentID we want 
	local targets = CharacterList("shortestpath,attackable,alive,onmesh,maxpathdistance=4000,contentID="..ml_task_hub:CurrentTask().Data["TargetcontentID"])
	if (targets) then
		local id,target = next(targets)
		if (id and target) then
			script.kTargetTmr = mc_global.now
			script.kTargetID = target.id
			Player:SetTarget(target.id)
			mc_global.Wait(250)
			return ml_log(true)
		end	
	end
	-- timer
	if ( script.kTargetTmr == 0 ) then 
		script.kTargetTmr = mc_global.now
		return ml_log(false)
	elseif ( mc_global.now - script.kTargetTmr > tonumber(ml_task_hub:CurrentTask().Data["_TargetSpawnTime"])*1000 ) then
		d("No enemies found in 30 seconds, ending step")		
		ml_task_hub:CurrentTask().completed = true
	end
	ml_log("_Waiting: "..tostring(mc_global.now - script.kTargetTmr).."Seconds_")
	return ml_log(false)
end

script.c_KillTargetEx = inheritsFrom( ml_cause )
function c_KillTargetEx:evaluate()
	
	if ( ml_task_hub:CurrentTask().Data["_TargetHPMax"] ~= nil and ml_task_hub:CurrentTask().Data["_TargetHPMin"] ~= nil ) then
		local targ = Player:GetTarget()
		if ( targ ~= nil ) then
			local thp = targ.health
			if ( thp and thp.percent < tonumber(ml_task_hub:CurrentTask().Data["_TargetHPMax"]) and thp.percent > tonumber(ml_task_hub:CurrentTask().Data["_TargetHPMin"]) ) then
				return true
			else
				return false
			end
		end
	end
	return c_KillTarget:evaluate()
end



return script