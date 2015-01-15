mc_ai_exploration = inheritsFrom(ml_task)
mc_ai_exploration.name = "Exploration"

function mc_ai_exploration.Create()
	local newinst = inheritsFrom(mc_ai_exploration)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}
    newinst.targetPosition = {}        
    return newinst
end

function mc_ai_exploration:Init()
	
	-- Dead?
	self:add(ml_element:create( "Dead", c_dead, e_dead, 225 ), self.process_elements)
	
	-- Downed
	self:add(ml_element:create( "Downed", c_downed, e_downed, 200 ), self.process_elements)
	
	-- AoELooting Characters
	self:add(ml_element:create( "AoELoot", c_AoELoot, e_AoELoot, 175 ), self.process_elements)
		
	-- AoELooting Gadgets/Chests needed ?
		
	-- Partymember Downed/Dead
	self:add(ml_element:create( "RevivePartyMember", c_memberdown, e_memberdown, 172 ), self.process_elements)	
	
	-- Revive Players
	self:add(ml_element:create( "RevivePlayer", c_reviveDownedPlayersInCombat, e_reviveDownedPlayersInCombat, 170 ), self.process_elements)
		
	-- Aggro
	self:add(ml_element:create( "Aggro", c_Aggro, e_Aggro, 165 ), self.process_elements) --reactive queue
	
	-- Dont Dive lol
	self:add(ml_element:create( "SwimUP", c_SwimUp, e_SwimUp, 160 ), self.process_elements)
	
	-- Normal Chests	
	self:add(ml_element:create( "LootingChest", c_LootChests, e_LootChests, 155 ), self.process_elements)
		
	-- Resting
	self:add(ml_element:create( "Resting", c_resting, e_resting, 145 ), self.process_elements)	

	-- Normal Looting
	self:add(ml_element:create( "Looting", c_LootCheck, e_LootCheck, 130 ), self.process_elements)

	-- Deposit Items
	self:add(ml_element:create( "DepositingItems", c_deposit, e_deposit, 120 ), self.process_elements)	
	
	-- Re-Equip Gathering Tools
	self:add(ml_element:create( "EquippingGatherTool", c_GatherToolsCheck, e_GatherToolsCheck, 110 ), self.process_elements)	
	
	-- Quick-Repair & Vendoring (when a vendor is nearby)	
	self:add(ml_element:create( "QuickSellItems", c_quickvendorsell, e_quickvendorsell, 100 ), self.process_elements)
	self:add(ml_element:create( "QuickBuyItems", c_quickbuy, e_quickbuy, 99 ), self.process_elements)
	self:add(ml_element:create( "QuickRepairItems", c_quickrepair, e_quickrepair, 98 ), self.process_elements)
	
	-- Repair & Vendoring
	self:add(ml_element:create( "SellItems", c_vendorsell, e_vendorsell, 90 ), self.process_elements)	
	self:add(ml_element:create( "BuyItems", c_vendorbuy, e_vendorbuy, 89 ), self.process_elements)
	self:add(ml_element:create( "RepairItems", c_vendorrepair, e_vendorrepair, 88 ), self.process_elements)
	
	-- Salvaging
	self:add(ml_element:create( "Salvaging", c_salvage, e_salvage, 75 ), self.process_elements)

	-- DoEvents
	self:add(ml_element:create( "DoEvent", c_doEvents, e_doEvents, 72 ), self.process_elements)
		
	-- ReviveNPCs
	self:add(ml_element:create( "ReviveNPC", c_reviveNPC, e_reviveNPC, 70 ), self.process_elements)	
	
	-- Gathering
	self:add(ml_element:create( "Gathering", c_gatherTask, e_gatherTask, 65 ), self.process_elements)
	
	-- Kill Stuff Nearby
	self:add(ml_element:create( "SearchAndKillNearby", c_SearchAndKillNearby, e_SearchAndKillNearby, 45 ), self.process_elements)
	
	-- GotoPosition
	self:add(ml_element:create( "GotoRandomPosition", c_goToPosition, e_goToPosition, 30 ), self.process_elements)	
	
	self:AddTaskCheckCEs()
end
function mc_ai_exploration:task_complete_eval()
	local pPos = Player.pos
	if ( TableSize(ml_task_hub:CurrentTask().targetPosition) == 0 ) then return true end
	if (pPos) then
		if ( Distance3D( ml_task_hub:CurrentTask().targetPosition.x, ml_task_hub:CurrentTask().targetPosition.y, ml_task_hub:CurrentTask().targetPosition.z,pPos.x,pPos.y,pPos.z) < 200 ) then
			return true
		end
	end
	return false
end

function mc_ai_exploration:task_complete_execute()
   self.completed = true
end


c_goToPosition = inheritsFrom( ml_cause )
e_goToPosition = inheritsFrom( ml_effect )
e_goToPosition.tmr = 0
e_goToPosition.threshold = 2000
function c_goToPosition:evaluate()	
	return true
end
function e_goToPosition:execute()
	ml_log("e_goToPosition")
	local pPos = Player.pos
	if (pPos) then
		local dist = Distance3D( ml_task_hub:CurrentTask().targetPosition.x,ml_task_hub:CurrentTask().targetPosition.y,ml_task_hub:CurrentTask().targetPosition.z,pPos.x,pPos.y,pPos.z)
		ml_log("("..tostring(math.floor(dist))..")")
		if ( dist > 500 ) then
			if ( c_DestroyGadget:evaluate() ) then e_DestroyGadget:execute() end
			MoveOnlyStraightForward()
			--d(tostring(ml_task_hub:CurrentTask().Data["GotoX"]).." "..tostring(ml_task_hub:CurrentTask().Data["GotoY"]).." "..tostring(ml_task_hub:CurrentTask().Data["GotoZ"]))
			local navResult = tostring(Player:MoveTo(ml_task_hub:CurrentTask().targetPosition.x,ml_task_hub:CurrentTask().targetPosition.y,ml_task_hub:CurrentTask().targetPosition.z,35,false,false,true))		
			if (tonumber(navResult) < 0) then					
				d("e_gotoPosition result: "..tonumber(navResult))					
			end	

			if ( mc_global.now - e_goToPosition.tmr > e_goToPosition.threshold ) then
				e_goToPosition.tmr = mc_global.now
				e_goToPosition.threshold = math.random(1500,5000)
				mc_skillmanager.HealMe()
			end			
			return ml_log(true)
		else			
			ml_task_hub:CurrentTask().completed = true
		end
	end	
	return ml_log(false)
end




-- Explore Mode
mc_ai_explore = inheritsFrom(ml_task)
mc_ai_explore.name = "ExploreMode"

function mc_ai_explore.Create()
	local newinst = inheritsFrom(mc_ai_explore)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}
            
    return newinst
end

function mc_ai_explore:Init()

end

function mc_ai_explore:Process()
	local newQ = ml_quest_mgr.GetNewQuest()
	if ( newQ ~= nil ) then
		local newTask = mc_ai_doquest.Create()
		newTask.currentQuest = newQ
		ml_task_hub:CurrentTask():AddSubTask(newTask)
	else
		-- Walk to Random Point in our levelrange
		if ( TableSize(mc_datamanager.levelmap) > 0 ) then
			local rpos = mc_datamanager.GetRandomPositionInLevelRange( Player.level )
			if (TableSize(rpos) > 0 ) then				
				local newTask = mc_ai_exploration.Create()
				newTask.targetPosition = rpos
				ml_task_hub:CurrentTask():AddSubTask(newTask)				
			
			else
				local rpos = Player:GetRandomPoint(5000)
				if ( rpos ) then
					local newTask = mc_ai_exploration.Create()
					newTask.targetPosition = rpos
					ml_task_hub:CurrentTask():AddSubTask(newTask)	
				end
			end
		end
	end
end

function mc_ai_explore:OnSleep()
	d("mc_ai_explore:OnSleep->")
end

function mc_ai_explore:OnTerminate()
	d("mc_ai_explore:OnTerminate->")
end

function mc_ai_explore:IsGoodToAbort()
	d("mc_ai_explore:IsGoodToAbort->")
end

-- Gets called after the CnEs are evaluated, if true, calls directly task_complete_execute()
function mc_ai_explore:task_complete_eval()	
	return false
end
function mc_ai_explore:task_complete_execute()
    
end

if ( mc_global.BotModes) then
	mc_global.BotModes[GetString("exploreMode")] = mc_ai_explore
end
