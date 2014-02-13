-- Handles Looting, Gathering and so on

c_deposit = inheritsFrom( ml_cause )
e_deposit = inheritsFrom( ml_effect )
c_deposit.LastCount = nil
function c_deposit:evaluate()
	if ( gDepositItems == "1" ) then
		if ( Inventory.freeSlotCount <= 3 ) then
			if ( not c_deposit.LastCount or c_deposit.LastCount ~= Inventory.freeSlotCount ) then			
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
end

------------
c_AoELoot = inheritsFrom( ml_cause )
e_AoELoot = inheritsFrom( ml_effect )
c_AoELoot.lastused = 0
function c_AoELoot:evaluate()
    --ml_log("c_AoELoot")
    return ( mc_global.now - c_AoELoot.lastused >1000 and Inventory.freeSlotCount > 0 and TableSize(CharacterList("nearest,lootable,maxdistance=900")) > 0)
end
function e_AoELoot:execute()
	ml_log("e_AoELoot")
	c_AoELoot.lastused = mc_global.now
	return ml_log(Player:AoELoot())
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
					local navResult = tostring(Player:MoveTo(tPos.x,tPos.y,tPos.z,50,false,true,true))		
					if (tonumber(navResult) < 0) then
						ml_error("e_Loot.MoveIntoCombatRange result: "..tonumber(navResult))					
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
					if ( Player:GetCurrentlyCastedSpell() == 17 ) then								
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

c_LootChests = inheritsFrom( wt_cause )
e_LootChests = inheritsFrom( wt_effect )
function c_LootChests:evaluate()
	--ml_log("c_LootChests")
	if ( Inventory.freeSlotCount > 0 ) then
		local GList = GadgetList("onmesh,lootable,maxdistance=4000")
		if ( TableSize( GList ) > 0 ) then			
			local index, LT = next( GList )
			while ( index ~= nil and LT~=nil ) do
				if ( LT.selectable and (LT.contentID == 17698 or LT.contentID == 198260 or LT.contentID == 232192 or LT.contentID == 232193 or LT.contentID == 232194 or LT.contentID == 262863 or LT.contentID == 236384)) then --or LT.contentID == 41638
					d("CHEST: "..tostring(LT.name).." "..tostring(LT.distance).." "..tostring(LT.contentID).." "..tostring(LT.lootable).." "..tostring(index))
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
						local navResult = tostring(Player:MoveTo(tPos.x,tPos.y,tPos.z,50,false,true,true))		
						if (tonumber(navResult) < 0) then
							ml_error("e_lootchest.MoveIntoRange result: "..tonumber(navResult))					
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
						if ( Player:GetCurrentlyCastedSpell() == 17 ) then								
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
	return (Inventory.freeSlotCount > 0 and TableSize(GadgetList("onmesh,gatherable,maxdistance=4000")) > 0)
end
function e_Gathering:execute()
	ml_log("e_Gathering")
	local GatherableList = GadgetList( "gatherable,shortestpath,onmesh")
	if ( GatherableList ) then
		local id,node = next (GatherableList)
		if ( id and node ) then
			
			if (not node.isInInteractRange) then
				-- MoveIntoInteractRange
				local tPos = node.pos
				if ( tPos ) then
					local navResult = tostring(Player:MoveTo(tPos.x,tPos.y,tPos.z,50,false,true,true))		
					if (tonumber(navResult) < 0) then
						ml_error("mc_ai_gathering.MoveIntoCombatRange result: "..tonumber(navResult))					
					end
					ml_log("MoveToGatherable..")
					return true
				end
			else
				-- Grab that thing
				Player:StopMovement()
				local t = Player:GetTarget()
				if ( node.selectable and (not t or t.id ~= id )) then
					Player:SetTarget( id )
				else
					-- yeah I know, but this usually doesnt break ;)
					if ( Player:GetCurrentlyCastedSpell() == 17 ) then	
						Player:Interact( id )
						ml_log("Gathering..")
						mc_global.Wait(1000)
						return true
					end	
				end			
			end
		end
	end
	return ml_log(false)
end

c_GatherToolsCheck = inheritsFrom( ml_cause )
e_GatherToolsCheck = inheritsFrom( ml_effect )
function c_GatherToolsCheck:evaluate()
	local toolList = mc_vendormanager.GetGatheringToolsCount()
	return ((Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.ForagingTool) == nil and toolList[1] > 0 ) or 
		(Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.LoggingTool) == nil  and toolList[1] > 0) or 
		(Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.MiningTool) == nil   and toolList[1] > 0))
end
function e_GatherToolsCheck:execute()
	ml_log("e_GatherToolsCheck")
	local tSlot = nil
	if (Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.ForagingTool) == nil) then tSlot = 0 end
	if (Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.LoggingTool) == nil) then tSlot = 1 end
	if (Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.MiningTool) == nil) then tSlot = 2 end
	
	if ( tSlot ~= nil) then
		local sTools = Inventory("itemtype=" .. GW2.ITEMTYPE.Gathering)
		if (sTools) then
			local id,item = next(sTools)
			while (id and item) do
				local itemID = item.itemID
				for invTools = 1, 8, 1 do				
					if (itemID == mc_vendormanager.tools[tSlot][invTools]) then 
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
	else
		ml_error("e_GatherToolsCheck -> tType ==nil!")
	end	
	return ml_log(false)
end
