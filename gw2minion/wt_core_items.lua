-- contentIDs for vendor purchase items (key = rarity, value = contentID)
wt_core_items = {}
wt_core_items.itemBlacklist = {}
wt_core_items.foragingToolIDs = 
{
	[0] = 91433,
	[1] = 25389,
	[2] = 188002,
	[3] = 234459,
	[4] = 226329,
	[5] = 60920
}
wt_core_items.loggingToolIDs = 
{
	[0] = 91435,
	[1] = 25393,
	[2] = 25400,
	[3] = 188003,
	[4] = 234463,
	[5] = 60921
}
wt_core_items.miningToolIDs = 
{
	[0] = 91437,
	[1] = 25394,
	[2] = 25401,
	[3] = 188004,
	[4] = 226330,
	[5] = 60923
}
wt_core_items.salvageKitIDs = 
{
	[0] = 25403,
	[1] = 25406,
	[2] = 25408,
	[3] = 25410,
	[4] = 25412
}

wt_core_items.lastticks = 0
wt_core_items.interval = 1000

function wt_core_items:GetItemStock(contentID)
	local myStock = ItemList("contentID="..contentID)
	local myStacks = 0
	if (myStock ~= nil) then
		id, item = next(myStock)
		while (id ~= nil) do
			myStacks = myStacks + 1
			id,item = next(myStock, id)
		end
	end
	return myStacks
end

function wt_core_items:NeedGatheringTools()
	local toolQuality
	if (gGatheringToolQuality ~= "") then
		toolQuality = tonumber(gGatheringToolQuality)
	end
	local forageToolID = tonumber(wt_core_items.foragingToolIDs[toolQuality])
	return 	(wt_core_items:GetItemStock(wt_core_items.foragingToolIDs[toolQuality]) == 0 and gGatherForaging == "1") or 
			(wt_core_items:GetItemStock(wt_core_items.loggingToolIDs[toolQuality]) == 0 and gGatherLogging == "1") or
			(wt_core_items:GetItemStock(wt_core_items.miningToolIDs[toolQuality]) == 0 and gGatherMining == "1")
end

function wt_core_items:NeedSalvageKits()
	local kitQuality
	if (gSavlageKitQuality ~= "") then
		kitQuality = tonumber(gSalvageKitQuality)
	end
	return 	wt_core_items:GetItemStock(wt_core_items.salvageKitIDs[kitQuality]) <= 1
end

function wt_core_items.EquipGatheringTools()
    local foragingtool = Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.ForagingTool)
    if not foragingtool and gGatherForaging == "1" then
		local ftools = ItemList("contentID="..tostring(wt_core_items.foragingToolIDs[tonumber(gGatheringToolQuality)]))
		local id, ftool = next(ftools)
		if ftool and not Player.inCombat then
			ftool:Equip(GW2.EQUIPMENTSLOT.ForagingTool)
			return
		end
    end
		

    local loggingtool = Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.LoggingTool)
    if not loggingtool and gGatherLogging == "1" then
        local ltools = ItemList("contentID="..tostring(wt_core_items.loggingToolIDs[tonumber(gGatheringToolQuality)]))
		local id, ltool = next(ltools)
		if ltool and not Player.inCombat then
			ltool:Equip(GW2.EQUIPMENTSLOT.LoggingTool)
			return
		end
    end
    
    local miningtool = Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.MiningTool)
    if not miningtool and gGatherMining == "1" then
        local mtools = ItemList("contentID="..wt_core_items.miningToolIDs[tonumber(gGatheringToolQuality)])
		local id, mtool = next(mtools)
		if mtool and not Player.inCombat then
			mtool:Equip(GW2.EQUIPMENTSLOT.MiningTool)
			return
		end
    end
end

--********************************************************************************?************
-- Handler
-- Your mama wears combat boots
--********************************************************************************?************

function wt_core_items.OnUpdateHandler( Event, ticks )
    if ( ticks - wt_core_items.lastticks > wt_core_items.interval ) then
		if ( wt_core_controller.shouldRun ) then
			wt_core_items.EquipGatheringTools()
		end
		wt_core_items.lastticks = ticks
    end
end

RegisterEventHandler("Gameloop.Update",wt_core_items.OnUpdateHandler)