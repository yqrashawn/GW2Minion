-- Handles Looting, Gathering and so on

-- Gather Task
mc_ai_Gather = inheritsFrom(ml_task)
mc_ai_Gather.name = "Gathering"
function mc_ai_Gather.Create()
    --ml_log("combatAttack:Create")
	local newinst = inheritsFrom(mc_ai_Gather)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {} 
	newinst.tPos = {}
    return newinst
end
function mc_ai_Gather:Init()
	
	self:add(ml_element:create( "AoELoot", c_AoELoot, e_AoELoot, 175 ), self.process_elements)
	
	-- Aggro
	-- Cant add aggro since gather task is also in reactive queue like aggro
	
	-- Resting
	self:add(ml_element:create( "Resting", c_resting, e_resting, 145 ), self.process_elements)
	
	-- Deposit Items
	self:add(ml_element:create( "DepositingItems", c_deposit, e_deposit, 120 ), self.process_elements)	
	
	-- Re-Equip Gathering Tools
	self:add(ml_element:create( "EquippingGatherTool", c_GatherToolsCheck, e_GatherToolsCheck, 110 ), self.process_elements)
		
	-- Gathering
	self:add(ml_element:create( "Gathering", c_Gathering, e_Gathering, 65 ), self.process_elements)
		
    self:AddTaskCheckCEs()
end
function mc_ai_Gather:task_complete_eval()	
	if ( c_dead:evaluate() or c_downed:evaluate() or ( c_Aggro:evaluate() and Player.health.percent < 95) ) then 
		Player:StopMovement()
		return true
	end
	return false
end
function mc_ai_Gather:task_complete_execute()
   self.completed = true
end

------------
c_gatherTask = inheritsFrom( ml_cause )
e_gatherTask = inheritsFrom( ml_effect )
c_gatherTask.throttle = 2500
function c_gatherTask:evaluate()
   -- ml_log("c_gatherTask")
    return (gGather == "1" and Inventory.freeSlotCount > 0 and TableSize(GadgetList("onmesh,shortestpath,gatherable,maxpathdistance=2000")) > 0)
end
function e_gatherTask:execute()
	ml_log("e_gatherTask")
	Player:StopMovement()
	local newTask = mc_ai_Gather.Create()
	local GList = GadgetList("onmesh,shortestpath,gatherable,maxpathdistance=2000")
	if ( TableSize(GList)>0) then
		local id,gatherable = next(GList)
		if ( gatherable ) then
			newTask.tPos = gatherable.pos
		else
			ml_error("gatherable not in list..")
		end
	else
		ml_error("Bug: GList in e_gatherTask is empty!?")
	end
	ml_task_hub:Add(newTask.Create(), REACTIVE_GOAL, TP_ASAP)
	return ml_log(true)	
end


c_deposit = inheritsFrom( ml_cause )
e_deposit = inheritsFrom( ml_effect )
c_deposit.LastCount = nil
c_deposit.RandomCount = math.random(10,20)
function c_deposit:evaluate()
	if ( gDepositItems == "1" ) then
		if ( Inventory.freeSlotCount <= c_deposit.RandomCount ) then
			if ( c_deposit.LastCount == nil or c_deposit.LastCount ~= Inventory.freeSlotCount ) then			
				return true
			else
				return false
			end
		else
			c_deposit.LastCount = 0
		end
	end
	return false
end
function e_deposit:execute()
	ml_log( "e_deposit" )
	c_deposit.LastCount = Inventory.freeSlotCount
	ml_log(Inventory:DepositCollectables())
	c_deposit.RandomCount = math.random(10,20)
end

------------
c_AoELoot = inheritsFrom( ml_cause )
e_AoELoot = inheritsFrom( ml_effect )
c_AoELoot.lastused = 0
function c_AoELoot:evaluate()
    if ( mc_global.now - c_AoELoot.lastused >1050 and Inventory.freeSlotCount > 0) then
		c_AoELoot.lastused = mc_global.now
		Player:AoELoot()
	end
	return false
end
function e_AoELoot:execute()
	ml_log("e_AoELoot")
	c_AoELoot.lastused = mc_global.now
	return ml_log(Player:AoELoot())
end


-- Loot Task
mc_ai_Looting = inheritsFrom(ml_task)
mc_ai_Looting.name = "Looting"
function mc_ai_Looting.Create()
    --ml_log("combatAttack:Create")
	local newinst = inheritsFrom(mc_ai_Looting)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {} 
	
    return newinst
end
function mc_ai_Looting:Init()
	
	self:add(ml_element:create( "AoELoot", c_AoELoot, e_AoELoot, 175 ), self.process_elements)
			
	self:add(ml_element:create( "Looting", c_Loot, e_Loot, 65 ), self.process_elements)
		
    self:AddTaskCheckCEs()
end
function mc_ai_Looting:task_complete_eval()	
	if ( c_dead:evaluate() or c_downed:evaluate() or c_Loot:evaluate() == false) then 
		Player:StopMovement()
		return true
	end
	return false
end
function mc_ai_Looting:task_complete_execute()
   self.completed = true
end

------------
c_LootCheck = inheritsFrom( ml_cause )
e_LootCheck = inheritsFrom( ml_effect )
function c_LootCheck:evaluate()
   -- ml_log("c_Loot")
    return Inventory.freeSlotCount > 0 and TableSize(CharacterList("nearest,lootable,onmesh,maxdistance=2500")) > 0
end
function e_LootCheck:execute()
	ml_log("e_LootCheck")
	Player:StopMovement()
	local newTask = mc_ai_Looting.Create()
	ml_task_hub:Add(newTask.Create(), REACTIVE_GOAL, TP_ASAP)
	return ml_log(true)	
end


------------
c_Loot = inheritsFrom( ml_cause )
e_Loot = inheritsFrom( ml_effect )
function c_Loot:evaluate()
   -- ml_log("c_Loot")
    return Inventory.freeSlotCount > 0 and TableSize(CharacterList("nearest,lootable,onmesh")) > 0
end
function e_Loot:execute()
	ml_log("e_Loot")
	local CharList = CharacterList("lootable,shortestpath,onmesh")
	if ( TableSize(CharList) > 0 ) then
		local id,entity = next (CharList)
		if ( id and entity ) then
			
			if (not entity.isInInteractRange) then
				-- MoveIntoInteractRange
				local tPos = entity.pos
				if ( tPos ) then
					if ( c_DestroyGadget:evaluate() ) then e_DestroyGadget:execute() end
					MoveOnlyStraightForward()
					local navResult = tostring(Player:MoveTo(tPos.x,tPos.y,tPos.z,35,false,true,true))		
					if (tonumber(navResult) < 0) then
						d("e_Loot.MoveIntoCombatRange result: "..tonumber(navResult))					
					end
					ml_log("MoveToLootable..")
					return ml_log(true)
				end
			else
				-- Grab that thing
				Player:StopMovement()
				local t = Player:GetTarget()
				if ( not t or t.id ~= id ) then
					Player:SetTarget( id )
				else
					-- yeah I know, but this usually doesnt break ;)
					if ( Player:GetCurrentlyCastedSpell() == 18 ) then								
						Player:Interact( id )
						ml_log("Looting..")
						mc_global.Wait(1000)
						return ml_log(true)
					end	
				end
			end
		end
	end
	return ml_log(false)	
end
	

c_LootChests = inheritsFrom( ml_cause )
e_LootChests = inheritsFrom( ml_effect )
function c_LootChests:evaluate()
	--ml_log("c_LootChests")
	if ( Inventory.freeSlotCount > 0 ) then
		local GList = GadgetList("onmesh,lootable,maxdistance=2500")
		if ( TableSize( GList ) > 0 ) then			
			local index, LT = next( GList )
			while ( index ~= nil and LT~=nil ) do
				if ( LT.selectable and (LT.contentID == 17698 or LT.contentID == 198260 or LT.contentID == 232192 or LT.contentID == 232193 or LT.contentID == 232194 or LT.contentID == 262863 or LT.contentID == 236384)) then --or LT.contentID == 41638
					--d("CHEST: "..(LT.name).." "..tostring(LT.distance).." "..tostring(LT.contentID).." "..tostring(LT.lootable).." "..tostring(index))
					return true
				end
				index, LT = next( GList,index )
			end
		end	
	end
	return false
end
e_LootChests.throttle = 500
function e_LootChests:execute()
	ml_log("e_lootchest")
	local GList = GadgetList("onmesh,lootable,shortestpath")
	if ( TableSize( GList ) > 0 ) then
		local index, LT = next( GList )		
		while ( index ~= nil and LT~=nil ) do
			if ( LT.selectable and (LT.contentID == 17698 or LT.contentID == 198260 or LT.contentID == 232192 or LT.contentID == 232193 or LT.contentID == 232194 or LT.contentID == 262863 or LT.contentID == 236384)) then --or LT.contentID == 41638 
				
				if (not LT.isInInteractRange) then					
					-- MoveIntoInteractRange
					local tPos = LT.pos
					if ( tPos ) then
						MoveOnlyStraightForward()
						local navResult = tostring(Player:MoveTo(tPos.x,tPos.y,tPos.z,35,false,true,true))		
						if (tonumber(navResult) < 0) then
							d("e_lootchest.MoveIntoRange result: "..tonumber(navResult))					
						end
						ml_log("MoveToLootChest..")
						return true
					end
				else
					-- Grab that thing
					Player:StopMovement()
					local t = Player:GetTarget()
					if ( not t or t.id ~= id ) then
						Player:SetTarget( id )
					else
						-- yeah I know, but this usually doesnt break ;)
						if ( Player:GetCurrentlyCastedSpell() == 18 ) then								
							Player:Interact( id )
							ml_log("Looting..")
							mc_global.Wait(1000)
							return true
						end	
					end
				end				
			end
			index, LT = next( GList,index )
		end
	end
	return ml_log(false)
end




------------fck that, I'm lazy and this works like a god
c_Gathering = inheritsFrom( ml_cause )
e_Gathering = inheritsFrom( ml_effect )
function c_Gathering:evaluate()
		
	if ( TableSize(ml_task_hub:CurrentTask().tPos) == 0 ) then
		local _,gadget = next(GadgetList("onmesh,nearest,gatherable,maxdistance=2000"))
		if (gadget) then
			ml_task_hub:CurrentTask().tPos = gadget.pos			
		end
	else		
		return true
	end
	
	-- no gatherable nearby and our current one is gathered, ending task
	ml_task_hub:CurrentTask().completed = true
	return false
end

e_Gathering.tmr = 0
e_Gathering.threshold = 500
function e_Gathering:execute()
	ml_log("e_Gathering")
	if ( TableSize(ml_task_hub:CurrentTask().tPos) > 0 ) then
		local pPos = Player.pos
		local tPos = ml_task_hub:CurrentTask().tPos
		local dist = Distance3D(tPos.x, tPos.y, tPos.z, pPos.x, pPos.y, pPos.z)
		if (dist > 200) then
			-- MoveIntoInteractRange
			if ( tPos ) then
				if ( c_DestroyGadget:evaluate() ) then e_DestroyGadget:execute() end
				MoveOnlyStraightForward()
				local navResult = tostring(Player:MoveTo(tPos.x,tPos.y,tPos.z,35,false,true,true))
				if (tonumber(navResult) < 0) then
					d("mc_ai_gathering.MoveIntoRange result: "..tonumber(navResult))
				end
				if ( mc_global.now - e_Gathering.tmr > e_Gathering.threshold ) then
					e_Gathering.tmr = mc_global.now
					e_Gathering.threshold = math.random(1000,3000)
					mc_skillmanager.HealMe()
				end
				ml_log("MoveToGatherable..")
				return true
			end
		else
			-- Grab that thing			
			local GList = GadgetList("onmesh,nearest,gatherable,maxdistance=750")
			if ( TableSize(GList)>0) then
				local _,gadget = next(GList)
				local t = Player:GetTarget()
				if (gadget) then
					if ( gadget.selectable and (not t or t.id ~= gadget.id )) then
						Player:SetTarget( gadget.id )
						return ml_log(true)
					else
						if ( gadget.isInInteractRange ) then
							Player:StopMovement()
							if ( Player.profession == 8 ) then -- Necro, leave shroud
								local deathshroud = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_13)
								if ( deathshroud ~= nil and deathshroud.skillID == 10585 and Player:CanCast() and Player:GetCurrentlyCastedSpell() == 18 ) then
									Player:CastSpell(GW2.SKILLBARSLOT.Slot_13)
									mc_global.Wait(500)
									return
								end
							end
							-- yeah I know, but this usually doesnt break ;)
							if ( Player:GetCurrentlyCastedSpell() == 18 ) then
								Player:Interact( gadget.id )
								ml_log("Gathering..")
								mc_global.Wait(1000)
								return
							end
							return ml_log(true)
						else
							local tPos = gadget.pos
							if ( tPos ) then
								ml_task_hub:CurrentTask().tPos = tPos
								local navResult = tostring(Player:MoveTo(tPos.x,tPos.y,tPos.z,35,false,true,true))
								if (tonumber(navResult) < 0) then
									d("mc_ai_gathering.MoveToGatherableInteractRange result: "..tonumber(navResult))
								end
								ml_log("MoveToGatherableInteractRange..")
								return ml_log(true)
							else
								ml_error("Gatherable Pos is nil")
								ml_task_hub:CurrentTask().tPos = {}
								return ml_log(true)
							end
						end
					end
				else
					d("No gadget nearby anymore, finishing gathertask")
					ml_task_hub:CurrentTask().tPos = {}
					return ml_log(true)
				end
			else
				d("No gadget nearby anymore, finishing gather task")
				ml_task_hub:CurrentTask().tPos = {}
				return ml_log(true)
			end
		end
	end
	ml_error("Bug in e_Gathering() , no case that handled our situation")
	ml_task_hub:CurrentTask().tPos = {}
	return ml_log(false)
end


c_GatherToolsCheck = inheritsFrom( ml_cause )
e_GatherToolsCheck = inheritsFrom( ml_effect )
function c_GatherToolsCheck:evaluate()
	local toolList = mc_vendormanager.GetGatheringToolsCount()
	if( not Player.inCombat ) then
		
		local tSlot = nil
		if (Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.ForagingTool) == nil and toolList[1] > 0) then tSlot = 0
		elseif (Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.LoggingTool) == nil and toolList[2] > 0) then tSlot = 1
		elseif (Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.MiningTool) == nil and toolList[3] > 0) then tSlot = 2 
		end
			
		if ( tSlot ~= nil) then
			local sTools = Inventory("itemtype=" .. GW2.ITEMTYPE.Gathering)
			if (sTools) then
				local pLevel = Player.level
				local id,item = next(sTools)
				while (id and item) do						
					local itemID = item.itemID
					for invTools = 1, 6, 1 do
						--d(tostring(itemID).." / "..tostring(mc_vendormanager.tools[tSlot][invTools]))
						if (itemID == mc_vendormanager.tools[tSlot][invTools] and pLevel >= mc_vendormanager.LevelRestrictions[invTools]) then 
							-- We found a tool to equip into our empty gatherable slot								
							return ml_log(true)
						end
					end
					id,item = next(sTools, id)
				end
			end
		end	
	end
	return false
end
function e_GatherToolsCheck:execute()
	ml_log("e_GatherToolsCheck")
	local toolList = mc_vendormanager.GetGatheringToolsCount()
	local tSlot = nil
	if (Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.ForagingTool) == nil and toolList[1] > 0) then tSlot = 0
	elseif (Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.LoggingTool) == nil and toolList[2] > 0) then tSlot = 1
	elseif (Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.MiningTool) == nil and toolList[3] > 0) then tSlot = 2 
	end
	
	if ( tSlot ~= nil) then
		local sTools = Inventory("itemtype=" .. GW2.ITEMTYPE.Gathering)
		if (sTools) then
			local pLevel = Player.level
			local id,item = next(sTools)
			while (id and item) do
				
				local itemID = item.itemID
				for invTools = 1, 6, 1 do
					--d(tostring(itemID).." / "..tostring(mc_vendormanager.tools[tSlot][invTools]))
					if (itemID == mc_vendormanager.tools[tSlot][invTools] and pLevel >= mc_vendormanager.LevelRestrictions[invTools]) then 
						-- We found a tool to equip into our empty gatherable slot
						if ( tSlot == 0 ) then d("Equipping Sickle ..") item:Equip(GW2.EQUIPMENTSLOT.ForagingTool) end
						if ( tSlot == 1 ) then d("Equipping Axe ..") item:Equip(GW2.EQUIPMENTSLOT.LoggingTool) end
						if ( tSlot == 2 ) then d("Equipping Pick ..") item:Equip(GW2.EQUIPMENTSLOT.MiningTool) end						
						mc_global.Wait(750)
						return ml_log(true)					
					end
				end
				id,item = next(sTools, id)
			end
		end
		ml_error("Bug in e_GatherToolsCheck -> sTools == nil!")
	else
		ml_error("e_GatherToolsCheck -> tType == nil!")
	end	
	return ml_log(false)
end
