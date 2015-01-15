-- Big Thanks to Jorith!!
script = inheritsFrom( ml_task )
script.name = "FarmCommander"
script.Data = {}

--******************
-- ml_quest_mgr Functions
--******************
function script:UIInit( identifier )
	-- You need to create the ScriptUI Elements exactly like you see here, the "event" needs to start with "tostring(identifier).." and the group needs to be GetString("questStepDetails")
	
end

function script:SetData( identifier, tData )
	-- Save the data in our script-"instance" aka global variables and set the UI elements
	if ( identifier and tData ) then
		--d("script:SetData: "..tostring(identifier))
		self.Data = tData
		
		-- Update the script UI (make sure the Data assigning to a _G is NOT nil! else crashboooombang!)
		
	end
end

function script:EventHandler( identifier, event, value )
	-- for extended UI event handling, gets called when a scriptUI element is pressed	
	
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
	
	-- Salvaging
	self:add(ml_element:create( "Salvaging", c_salvage, e_salvage, 110 ), self.process_elements)
	
	-- Repair & Vendoring
	self:add(ml_element:create( "SellItems", c_vendorsell, e_vendorsell, 100 ), self.process_elements)
	self:add(ml_element:create( "BuyItems", c_vendorbuy, e_vendorbuy, 90 ), self.process_elements)
	self:add(ml_element:create( "RepairItems", c_vendorrepair, e_vendorrepair, 80 ), self.process_elements)
	
	-- Goto Commander
	self:add(ml_element:create( "GoToCommander", self.c_gotoComm, self.e_gotoComm, 70 ), self.process_elements)
	
	-- Goto Commander no Aggro comm dist > 750
	self:add(ml_element:create( "GoToCommander", self.c_gotoCommNoAggro, self.e_gotoComm, 60 ), self.process_elements)
	
	--Revive Other Players
	self:add(ml_element:create( "ReviveNPC", c_commFarmRevive, e_revive, 55 ), self.process_elements)
	
	-- Defend
	self:add(ml_element:create( "Aggro", c_Aggro, e_Aggro, 50 ), self.process_elements) --reactive queue
		
	self:AddTaskCheckCEs()
end


function script:task_complete_eval()
	return false
end
function script:task_complete_execute()
   self.completed = true
end



-- Cause&Effect
script.c_gotoComm = inheritsFrom( ml_cause )
script.c_gotoCommNoAggro = inheritsFrom( ml_cause )
script.e_gotoComm = inheritsFrom( ml_effect )
script.commanderReached = false
function script.c_gotoComm:evaluate()
	local commList = MapMarkerList("iscommander,onmesh,nearest")
	local id, commander = next(commList)
	if (id and commander and (commander.distance > 2500 or script.commanderReached == false)) then
		script.commanderReached = false
		return true
	end
	return false
end
function script.c_gotoCommNoAggro:evaluate()
	local aggrolist = TableSize(CharacterList("nearest,alive,aggro,attackable,maxdistance=1200,onmesh")) > 0 and ( Inventory.freeSlotCount > 0 or ( Inventory.freeSlotCount == 0 and not mc_ai_vendor.NeedToSell() or TableSize(mc_ai_vendor.GetClosestVendorMarker()) == 0 ))
	if (aggrolist == false) then
		mc_ai_unstuck.idlecounter = 0
		local commList = MapMarkerList("iscommander,onmesh,nearest")
		id, commander = next(commList)
		if (id and commander and (commander.distance > 750 or script.commanderReached == false)) then
			script.commanderReached = false
			return true
		end
	end
	return false
end
function script.e_gotoComm:execute()
	ml_log("c_gotoComm")
	if (not mc_skillmanager.HealMe()) then
		local commList = MapMarkerList("iscommander,onmesh,nearest")
		local id, commander = next(commList)
		if (id and commander and commander.distance > 250) then
			-- Player:MoveTo(x,y,z,stoppingdistance,navsystem(normal/follow),navpath(straight/random),smoothturns)
			Player:MoveTo(commander.pos.x, commander.pos.y, commander.pos.z, 35, false, false, true)
		elseif (commander.distance < 250) then
			script.commanderReached = true
		end
	end
end

script.c_commFarmRevive = inheritsFrom( ml_cause )
function script.c_commFarmRevive:evaluate()
	local players = (CharacterList("alive,player,maxdistance=1000"))
	local dead = (CharacterList("dead,player,maxdistance=1000"))
	if (TableSize(players) > 8 and Player.health.percent > 80) then
		return true
	end
	return false
end


return script