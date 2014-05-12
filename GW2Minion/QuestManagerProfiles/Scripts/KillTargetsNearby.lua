-- Goto Position x,y,z script for QuestManager
script = inheritsFrom( ml_task )
script.name = "KillTargetsNearby"
script.Data = {}

--******************
-- ml_quest_mgr Functions
--******************
function script:UIInit( identifier )
	-- You need to create the ScriptUI Elements exactly like you see here, the "event" needs to start with "tostring(identifier).." and the group needs to be GetString("questStepDetails")
	GUI_NewNumeric(ml_quest_mgr.stepwindow.name,"Max Kill Time",tostring(identifier).."_TargetKillTime",GetString("questStepDetails"),"0","999");
	
end

function script:SetData( identifier, tData )
	-- Save the data in our script-"instance" aka global variables and set the UI elements
	if ( identifier and tData ) then		
		--d("script:SetData: "..tostring(identifier))
				
		self.Data = tData
		
		-- Update the script UI (make sure the Data assigning to a _G is NOT nil! else crashboooombang!)
		if ( self.Data["_TargetKillTime"] ) then _G[tostring(identifier).."_TargetKillTime"] = self.Data["_TargetKillTime"] end
	end
end

function script:EventHandler( identifier, event, value )
	
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
	
	-- Resting
	self:add(ml_element:create( "Resting", c_resting, e_resting, 140 ), self.process_elements)	

	-- Deposit Items
	self:add(ml_element:create( "DepositingItems", c_deposit, e_deposit, 120 ), self.process_elements)	
			
	-- Find Target
	self:add(ml_element:create( "FindTarget", self.c_findtarget, e_SearchTarget, 110 ), self.process_elements)
	
	-- Get into Combat Range
	self:add(ml_element:create( "MovingIntoCombatRange", c_MoveIntoCombatRange, e_MoveIntoCombatRange, 100 ), self.process_elements)
	
	-- Kill Target
	self:add(ml_element:create( "KillTarget", c_KillTarget, e_KillTarget, 90 ), self.process_elements)
		
	self:AddTaskCheckCEs()
end


function script:task_complete_eval()
	if ( script.kTargetTmr ~= nil ) then ml_log("_"..tostring(self.Data["_TargetKillTime"]*1000 -( mc_global.now - script.kTargetTmr).." seconds remaining_")) end
	if ( script.kTargetTmr ~= 0 and mc_global.now - script.kTargetTmr > self.Data["_TargetKillTime"]*1000 ) then return true end
	return false
end
function script:task_complete_execute()
   self.completed = true
end



-- Cause&Effect
script.c_findtarget = inheritsFrom( ml_cause )
script.e_findtarget = inheritsFrom( ml_effect )
script.kTargetTmr = 0
function script.c_findtarget:evaluate() 
	if (ml_task_hub:CurrentTask().Data["_TargetKillTime"] == 0 ) then
		ml_error("QuestManager: KillTargetsNearby Step has no TIME set!")
		ml_task_hub:CurrentTask().completed = true	
	end
	if ( script.kTargetTmr == 0 ) then script.kTargetTmr = mc_global.now end
	
	local target = Player:GetTarget()
	if ( TableSize( target ) > 0 ) then	
		--d("NeedValidTarget "..tostring(not target.alive and not target.attackable and not target.onmesh))
		return (Player.swimming == 0 and not target.alive or not target.attackable or not target.onmesh)
	end	
	return true
end



return script