-- Takes care of Buying and Selling of Items/Tools logic
mc_vendormanager = {}
mc_vendormanager.sellmainwindow = { name = GetString("sellmanager"), x = 350, y = 50, w = 250, h = 350}
mc_vendormanager.selleditwindow = { name = GetString("selleditor"), w = 250, h = 350}
mc_vendormanager.filterList = {}
mc_vendormanager.sellwindowVisible = false

mc_vendormanager.buymainwindow = { name = GetString("buymanager"), x = 350, y = 50, w = 250, h = 350}
mc_vendormanager.buywindowvisible = false
mc_vendormanager.tools = {
	 -- sickles 0= lowest quality , 5 = orichalcum
	 [0] = 
	 {
	  [1] = 23029,
	  [2] = 22992,
	  [3] = 23004,
	  [4] = 23005,
	  [5] = 23008,
	  [6] = 22997,
	  [7] = 44876, -- Jack-in-the-Box Scythe
	  [8] = 42594 -- Consortium Harvesting Sickle
	 },
	 -- logging 0= lowest quality , 5 = orichalcum
	 [1] = 
	 {
	  [1] = 23030,
	  [2] = 22994,
	  [3] = 23002,
	  [4] = 23006,
	  [5] = 23009,
	  [6] = 23000,
	  [7] = 48955, -- DreamCleaver Logging Axe
	  [8] = 42931 -- Chop-It-All Logging Axe
	 },
	 -- mining 0= lowest quality , 5 = orichalcum
	 [2] =
	 {
	  [1] = 23031,
	  [2] = 22995,
	  [3] = 23003,
	  [4] = 23007,
	  [5] = 23010,
	  [6] = 23001,
	  [7] = 43527, -- Bone Pick
	  [8] = 41807 -- Molten Alliance Mining Pick
	 },
	 -- salvagingkits 0= lowest quality 
	 [3] = 
	 {
	  [0] = 23038,
	  [1] = 23040,
	  [2] = 23041,
	  [3] = 23042,
	  [4] = 23043
	 }
 }

function mc_vendormanager.ModuleInit()
	
	-- SELLING
	if (Settings.GW2Minion.SellManager_FilterList == nil) then
		Settings.GW2Minion.SellManager_FilterList = {
		{
			itemID = "None",
			itemtype = "Weapon",
			name = "Weapons_Junk",
			rarity = "Junk",
			soulbound = "false",
			weapontype = "None",
		},
		
		{
			itemID = "None",
			itemtype = "Weapon",
			name = "Weapons_Common",
			rarity = "Common",
			soulbound = "false",
			weapontype = "None",
		},
		
		{
			itemID = "None",
			itemtype = "Weapon",
			name = "Weapons_Masterwork",
			rarity = "Masterwork",
			soulbound = "false",
			weapontype = "None",
		},
		
		{
			itemID = "None",
			itemtype = "Weapon",
			name = "Weapons_Fine",
			rarity = "Fine",
			soulbound = "false",
			weapontype = "None",
		},
		
		{
			itemID = "None",
			itemtype = "Armor",
			name = "Armor_Junk",
			rarity = "Junk",
			soulbound = "false",
			weapontype = "None",
		},
		
		{
			itemID = "None",
			itemtype = "Armor",
			name = "Armor_Common",
			rarity = "Common",
			soulbound = "false",
			weapontype = "None",
		},
		
		{
			itemID = "None",
			itemtype = "Armor",
			name = "Armor_Masterwork",
			rarity = "Masterwork",
			soulbound = "false",
			weapontype = "None",
		},
		
		{
			itemID = "None",
			itemtype = "Armor",
			name = "Armor_Fine",
			rarity = "Fine",
			soulbound = "false",
			weapontype = "None",
		},
		
		}
	end
	if (Settings.GW2Minion.SellManager_Active == nil ) then
		Settings.GW2Minion.SellManager_Active = "1"
	end
	if (Settings.GW2Minion.gRepairDamageLimit == nil ) then
		Settings.GW2Minion.gRepairDamageLimit = "5" -- Repair when more than 5 damaged items
	end
	if (Settings.GW2Minion.gRepairBrokenLimit == nil ) then
		Settings.GW2Minion.gRepairBrokenLimit = "2" -- Repair when more than 5 broken items
	end
		
	-- SELLMANAGER WINDOW
	GUI_NewButton(mc_global.window.name, GetString("sellGroup"), "sellManager.toggle",GetString("vendorSettings"))
	GUI_NewNumeric(mc_global.window.name,GetString("repairDamaged"),"gRepairDamageLimit",mc_getstring("vendorSettings"),"0","15");
	GUI_NewNumeric(mc_global.window.name,GetString("repairBroken"),"gRepairBrokenLimit",mc_getstring("vendorSettings"),"0","15");	
	-- SELL SETTINGS
	GUI_NewWindow(mc_vendormanager.sellmainwindow.name,mc_vendormanager.sellmainwindow.x,mc_vendormanager.sellmainwindow.y,mc_vendormanager.sellmainwindow.w,mc_vendormanager.sellmainwindow.h)
	GUI_NewCheckbox(mc_vendormanager.sellmainwindow.name,GetString("active"),"SellManager_Active",GetString("sellGroup"))
	GUI_NewField(mc_vendormanager.sellmainwindow.name,GetString("newfiltername"),"SellManager_NewFilterName",GetString("sellGroup"))
	GUI_NewButton(mc_vendormanager.sellmainwindow.name,GetString("newfilter"),"SellManager_NewFilter",GetString("sellGroup"))
	RegisterEventHandler("SellManager_NewFilter",mc_vendormanager.filterWindow)	
	GUI_SizeWindow(mc_vendormanager.sellmainwindow.name,mc_vendormanager.sellmainwindow.w,mc_vendormanager.sellmainwindow.h)
	GUI_UnFoldGroup(mc_vendormanager.sellmainwindow.name,GetString("sellGroup"))
	GUI_WindowVisible(mc_vendormanager.sellmainwindow.name,false)	
	GUI_UnFoldGroup(mc_vendormanager.sellmainwindow.name,GetString("sellfilters"))	
	-- SELLEDITOR WINDOW
	GUI_NewWindow(mc_vendormanager.selleditwindow.name,mc_vendormanager.sellmainwindow.x+mc_vendormanager.sellmainwindow.w,mc_vendormanager.sellmainwindow.y,mc_vendormanager.selleditwindow.w,mc_vendormanager.selleditwindow.h)
	GUI_NewField(mc_vendormanager.selleditwindow.name,GetString("name"),"SellManager_Name",GetString("filterdetails"))
	GUI_NewComboBox(mc_vendormanager.selleditwindow.name,GetString("soulbound"),"SellManager_Soulbound",GetString("filterdetails"),"true,false,either")
	GUI_NewComboBox(mc_vendormanager.selleditwindow.name,GetString("itemtype"),"SellManager_Itemtype",GetString("filterdetails"),"")
	GUI_NewComboBox(mc_vendormanager.selleditwindow.name,GetString("rarity"),"SellManager_Rarity",GetString("filterdetails"),GetString("rarityNone")..","..GetString("rarityJunk")..","..GetString("rarityCommon")..","..GetString("rarityFine")..","..GetString("rarityMasterwork")..","..GetString("rarityRare")..","..GetString("rarityExotic"));
	GUI_NewComboBox(mc_vendormanager.selleditwindow.name,GetString("weapontype"),"SellManager_Weapontype",GetString("filterdetails"),"")
	GUI_NewField(mc_vendormanager.selleditwindow.name,GetString("itemid"),"SellManager_ItemID",GetString("filterdetails"))
	GUI_NewButton(mc_vendormanager.selleditwindow.name,GetString("delete"),"SellManager_DeleteFilter")
	RegisterEventHandler("SellManager_DeleteFilter",mc_vendormanager.deleteFilter)	
	GUI_SizeWindow(mc_vendormanager.selleditwindow.name,mc_vendormanager.selleditwindow.w,mc_vendormanager.selleditwindow.h)
	GUI_UnFoldGroup(mc_vendormanager.selleditwindow.name,GetString("filterdetails"))
	GUI_WindowVisible(mc_vendormanager.selleditwindow.name,false)

	local i,_ = next(GW2.ITEMTYPE)
	local list = "None"
	while (i ~= nil) do
		list = list .. "," .. i
		i,_ = next(GW2.ITEMTYPE, i)
	end
	SellManager_Itemtype_listitems = list
	local i,_ = next(GW2.WEAPONTYPE)
	local list = "None"
	while (i ~= nil) do
		list = list .. "," .. i
		i,_ = next(GW2.WEAPONTYPE, i)
	end
	SellManager_Weapontype_listitems = list
		
	SellManager_Active = Settings.GW2Minion.SellManager_Active
	mc_vendormanager.filterList = Settings.GW2Minion.SellManager_FilterList
	gRepairDamageLimit = Settings.GW2Minion.gRepairDamageLimit
	gRepairBrokenLimit = Settings.GW2Minion.gRepairBrokenLimit
	
	mc_vendormanager.refreshFilterlist()
	
	--********
	-- BUYING
	--********
	if (Settings.GW2Minion.BuyManager_Active == nil ) then
		Settings.GW2Minion.BuyManager_Active = "1"
	end
	
	if (Settings.GW2Minion.BuyManager_buyAllKits == nil ) then
		Settings.GW2Minion.BuyManager_buyAllKits = "0"
	end
	
	if (Settings.GW2Minion.BuyManager_sCommon == nil ) then
		Settings.GW2Minion.BuyManager_sCommon = "1"
	end
	
	if (Settings.GW2Minion.BuyManager_sFine == nil ) then
		Settings.GW2Minion.BuyManager_sFine = "1"
	end
	
	if (Settings.GW2Minion.BuyManager_sMasterwork == nil ) then
		Settings.GW2Minion.BuyManager_sMasterwork = "1"
	end
	
	if (Settings.GW2Minion.BuyManager_sRare == nil ) then
		Settings.GW2Minion.BuyManager_sRare = "1"
	end
	
	if (Settings.GW2Minion.BuyManager_sExotic == nil ) then
		Settings.GW2Minion.BuyManager_sExotic = "1"
	end
	
	if (Settings.GW2Minion.BuyManager_sStacks == nil ) then
		Settings.GW2Minion.BuyManager_sStacks = 2
	end
	
	if (Settings.GW2Minion.BuyManager_copperTools == nil ) then
		Settings.GW2Minion.BuyManager_copperTools = "1"
	end
	
	if (Settings.GW2Minion.BuyManager_ironTools == nil ) then
		Settings.GW2Minion.BuyManager_ironTools = "1"
	end
	
	if (Settings.GW2Minion.BuyManager_steelTools == nil ) then
		Settings.GW2Minion.BuyManager_steelTools = "1"
	end
	
	if (Settings.GW2Minion.BuyManager_darksteelTools == nil ) then
		Settings.GW2Minion.BuyManager_darksteelTools = "1"
	end
	
	if (Settings.GW2Minion.BuyManager_mithrilTools == nil ) then
		Settings.GW2Minion.BuyManager_mithrilTools = "1"
	end
	
	if (Settings.GW2Minion.BuyManager_orichalcumTools == nil ) then
		Settings.GW2Minion.BuyManager_orichalcumTools = "1"
	end
	
	if (Settings.GW2Minion.BuyManager_toolStacks == nil ) then
		Settings.GW2Minion.BuyManager_toolStacks = 2
	end
	
	-- BUYMANAGER WINDOW
	GUI_NewButton(mc_global.window.name, GetString("buyGroup"), "buymanager.toggle",GetString("vendorSettings"))
	
	-- BUY SETTINGS
	GUI_NewWindow(mc_vendormanager.buymainwindow.name,mc_vendormanager.buymainwindow.x,mc_vendormanager.buymainwindow.y,mc_vendormanager.buymainwindow.w,mc_vendormanager.buymainwindow.h)
	GUI_NewCheckbox(mc_vendormanager.buymainwindow.name,GetString("active"),"BuyManager_Active",GetString("buyGroup"))
	GUI_NewCheckbox(mc_vendormanager.buymainwindow.name,GetString("buyAllKits"),"BuyManager_buyAllKits",GetString("buyGroup"))
	
	GUI_NewCheckbox(mc_vendormanager.buymainwindow.name,GetString("rarityCommon"),"BuyManager_sCommon",GetString("salvageKits"))
	GUI_NewCheckbox(mc_vendormanager.buymainwindow.name,GetString("rarityFine"),"BuyManager_sFine",GetString("salvageKits"))
	GUI_NewCheckbox(mc_vendormanager.buymainwindow.name,GetString("rarityMasterwork"),"BuyManager_sMasterwork",GetString("salvageKits"))
	GUI_NewCheckbox(mc_vendormanager.buymainwindow.name,GetString("rarityRare"),"BuyManager_sRare",GetString("salvageKits"))
	GUI_NewCheckbox(mc_vendormanager.buymainwindow.name,GetString("rarityExotic"),"BuyManager_sExotic",GetString("salvageKits"))
	GUI_NewNumeric(mc_vendormanager.buymainwindow.name,GetString("kitStock"),"BuyManager_sStacks",GetString("salvageKits"),"1","100")
	
	GUI_NewCheckbox(mc_vendormanager.buymainwindow.name,GetString("copperTools"),"BuyManager_copperTools",GetString("gatherTools"))
	GUI_NewCheckbox(mc_vendormanager.buymainwindow.name,GetString("ironTools"),"BuyManager_ironTools",GetString("gatherTools"))
	GUI_NewCheckbox(mc_vendormanager.buymainwindow.name,GetString("steelTools"),"BuyManager_steelTools",GetString("gatherTools"))
	GUI_NewCheckbox(mc_vendormanager.buymainwindow.name,GetString("darksteelTools"),"BuyManager_darksteelTools",GetString("gatherTools"))
	GUI_NewCheckbox(mc_vendormanager.buymainwindow.name,GetString("mithrilTools"),"BuyManager_mithrilTools",GetString("gatherTools"))
	GUI_NewCheckbox(mc_vendormanager.buymainwindow.name,GetString("orichalcumTools"),"BuyManager_orichalcumTools",GetString("gatherTools"))
	GUI_NewNumeric(mc_vendormanager.buymainwindow.name,GetString("toolStock"),"BuyManager_toolStacks",GetString("gatherTools"),"1","100")
	
	GUI_SizeWindow(mc_vendormanager.buymainwindow.name,mc_vendormanager.buymainwindow.w,mc_vendormanager.buymainwindow.h)
	GUI_UnFoldGroup(mc_vendormanager.buymainwindow.name,GetString("buyGroup"))
	GUI_WindowVisible(mc_vendormanager.buymainwindow.name,false)
	
	BuyManager_Active = Settings.GW2Minion.BuyManager_Active
	BuyManager_buyAllKits = Settings.GW2Minion.BuyManager_buyAllKits
	BuyManager_sCommon = Settings.GW2Minion.BuyManager_sCommon
	BuyManager_sFine = Settings.GW2Minion.BuyManager_sFine
	BuyManager_sMasterwork = Settings.GW2Minion.BuyManager_sMasterwork
	BuyManager_sRare = Settings.GW2Minion.BuyManager_sRare
	BuyManager_sExotic = Settings.GW2Minion.BuyManager_sExotic
	BuyManager_sStacks = Settings.GW2Minion.BuyManager_sStacks
	BuyManager_sStacks = Settings.GW2Minion.BuyManager_sStacks
	
	BuyManager_copperTools = Settings.GW2Minion.BuyManager_copperTools
	BuyManager_ironTools = Settings.GW2Minion.BuyManager_ironTools
	BuyManager_steelTools = Settings.GW2Minion.BuyManager_steelTools
	BuyManager_darksteelTools = Settings.GW2Minion.BuyManager_darksteelTools
	BuyManager_mithrilTools = Settings.GW2Minion.BuyManager_mithrilTools
	BuyManager_orichalcumTools = Settings.GW2Minion.BuyManager_orichalcumTools
	BuyManager_toolStacks = Settings.GW2Minion.BuyManager_toolStacks
	
end

--Create filtered Sell-Itemlist of Items we can sell
function mc_vendormanager.createItemList()
	local items = Inventory("")
	local filteredItems = {}
	if (items) then
		local id, item = next(items)
		while (id and item) do
			local addItem = false
			local _, filter = next(mc_vendormanager.filterList)
			while (filter) do
				if (mc_vendormanager.validFilter(filter)) then
					if ((filter.rarity == "None" or filter.rarity == nil or GW2.ITEMRARITY[filter.rarity] == item.rarity) and
					(filter.itemtype == "None" or filter.itemtype == nil or GW2.ITEMTYPE[filter.itemtype] == item.itemtype) and
					(filter.weapontype == "None" or filter.weapontype == nil or GW2.WEAPONTYPE[filter.weapontype] == item.weapontype) and
					(filter.itemID == "None" or filter.itemID == nil or tonumber(filter.itemID) == item.itemID) and
					(filter.soulbound == "either" or (filter.soulbound == nil and item.soulbound == false) or filter.soulbound == tostring(item.soulbound))) then
						addItem = true
					end
				end
				_, filter = next(mc_vendormanager.filterList, _)
			end
			if (addItem) then
				table.insert(filteredItems, item)
			end
			id, item = next(items, id)
		end
		if (filteredItems) then
			return filteredItems
		end
	end
	return false
end

--Check if Sellfilter is valid: 
function mc_vendormanager.validFilter(filter)
	if (filter.itemtype ~= "None" and filter.itemtype ~= nil and
	filter.rarity ~= "None" and filter.rarity ~= nil) then
		return true
	elseif (filter.itemID ~= "None" and filter.itemID ~= nil) then
		return true
	end
	return false
end

--New Sellfilter/Load Sellfilter.
function mc_vendormanager.filterWindow(filterNumber)
	if (mc_vendormanager.filterList[filterNumber] == nil and not mc_vendormanager.filterExcists() and SellManager_NewFilterName ~= nil and SellManager_NewFilterName ~= "") then
		filterNumber = TableSize(mc_vendormanager.filterList) + 1
		mc_vendormanager.filterList[filterNumber] = {name = SellManager_NewFilterName, soulbound = "false", rarity = "None", itemtype = "None", weapontype = "None", itemID = "None"}
		mc_vendormanager.refreshFilterlist()
		Settings.GW2Minion.SellManager_FilterList = mc_vendormanager.filterList
	end
	if (string.find(filterNumber, "SellManager_Filter")) then
		filterNumber = string.gsub(filterNumber, "SellManager_Filter", "")
		filterNumber = tonumber(filterNumber)
	end
	if (mc_vendormanager.filterList[filterNumber] ~= nil) then
		SellManager_Name = mc_vendormanager.filterList[filterNumber].name or "None"
		SellManager_Soulbound = mc_vendormanager.filterList[filterNumber].soulbound or "false"
		SellManager_Rarity = mc_vendormanager.filterList[filterNumber].rarity or "None"
		SellManager_Itemtype = mc_vendormanager.filterList[filterNumber].itemtype or "None"
		SellManager_Weapontype = mc_vendormanager.filterList[filterNumber].weapontype or "None"
		SellManager_ItemID = mc_vendormanager.filterList[filterNumber].itemID or "None"
		GUI_WindowVisible(mc_vendormanager.selleditwindow.name,true)
	end
	SellManager_CurFilter = filterNumber
end

--Delete Sellfilter.
function mc_vendormanager.deleteFilter()
	table.remove(mc_vendormanager.filterList, SellManager_CurFilter)
	Settings.GW2Minion.SellManager_FilterList = mc_vendormanager.filterList
	mc_vendormanager.refreshFilterlist()
end

--Check if Sellfilter name excists.
function mc_vendormanager.filterExcists()
	local i,v = next(mc_vendormanager.filterList)
	while (i and v) do
		if (SellManager_NewFilterName == v.name) then
			return true
		end
		i,v = next(mc_vendormanager.filterList, i)
	end
	return false
end

--Refresh Sellfilters.
function mc_vendormanager.refreshFilterlist()
	GUI_Delete(mc_vendormanager.sellmainwindow.name,GetString("sellfilters"))
	local i, v = next(mc_vendormanager.filterList)
	while (i and v) do
		GUI_NewButton(mc_vendormanager.sellmainwindow.name, mc_vendormanager.filterList[i].name, "SellManager_Filter" .. i,GetString("sellfilters"))
		RegisterEventHandler("SellManager_Filter" .. i ,mc_vendormanager.filterWindow)
		i, v = next(mc_vendormanager.filterList, i)
	end
	SellManager_Name = nil
	SellManager_Soulbound = nil
	SellManager_Rarity = nil
	SellManager_Itemtype = nil
	SellManager_Weapontype = nil
	SellManager_ItemID = nil
	GUI_WindowVisible(mc_vendormanager.selleditwindow.name,false)
	GUI_UnFoldGroup(mc_vendormanager.sellmainwindow.name,GetString("sellfilters"))
end


--*************
--BUY FUNCTIONS
--*************

-- Need to buy kits
function mc_vendormanager.needKits()
	-- itemtype = GW2.ITEMTYPE.SalvalteTool = 13
	local kitsOwned = {[1]=0,[2]=0,[3]=0,[4]=0,[5]=0}
	local buyList = {}
	local sKits = Inventory("itemtype=" .. GW2.ITEMTYPE.SalvageTool)
	if (sKits) then
		local id,item = next(sKits)
		while (id and item) do
			kitsOwned[item.rarity] = (kitsOwned[item.rarity] + 1)
			if (item.itemID == 44602) then kitsOwned[1] = false end
			id,item = next(sKits, id)
		end
		if (BuyManager_sCommon == "0") then kitsOwned[1] = false end
		if (BuyManager_sFine == "0") then kitsOwned[2] = false end
		if (BuyManager_sMasterwork == "0") then kitsOwned[3] = false end
		if (BuyManager_sRare == "0") then kitsOwned[4] = false end
		if (BuyManager_sExotic == "0") then kitsOwned[5] = false end
		for rarity = #kitsOwned, 1, -1 do
			if (kitsOwned[rarity] ~= false and kitsOwned[rarity] < 1) then
				table.insert(buyList, {count = tonumber(BuyManager_sStacks) - kitsOwned[rarity], itemID = mc_vendormanager.tools[3][rarity - 1]})
			elseif (BuyManager_buyAllKits == "0") then
				table.insert(buyList, {count = false, itemID = mc_vendormanager.tools[3][rarity - 1]})
			end
		end
		if (ValidTable(buyList)) then
			return buyList
		end
	end
	return false
end

function mc_vendormanager.needTools()
	-- itemtype = GW2.ITEMTYPE.Gathering = 6
	local buyList = {[1]={},[2]={},[3]={}}
	for set = 1, 3, 1 do
		for _,v in pairs(mc_vendormanager.tools[set]) do
			buyList[set][v] = 0
		end
	end
	local fTool = nil
	local lTool = nil
	local mTool = nil
	if (Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.ForagingTool)) then fTool = Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.ForagingTool).itemID else fTool = 0 end
	if (Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.LoggingTool)) then lTool = Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.LoggingTool).itemID else lTool = 0 end
	if (Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.MiningTool)) then mTool = Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.MiningTool).itemID else mTool = 0 end
	local toolsInUse = {
						[1] = fTool,
						[2] = lTool,
						[3] = mTool
	}
	-- Check for unlimited tools -> we dont need to buy these
	for invTools = 7, 8, 1 do
		if (toolsInUse[1] == mc_vendormanager.tools[0][invTools]) then buyList[1] = false end
		if (toolsInUse[2] == mc_vendormanager.tools[1][invTools]) then buyList[2] = false end
		if (toolsInUse[3] == mc_vendormanager.tools[2][invTools]) then buyList[3] = false end
	end
	
	-- Count our remaining gatheringtools
	local gTools = Inventory("itemtype=" .. GW2.ITEMTYPE.Gathering)
	if ( TableSize(gTools)>0) then
		local id, item = next(gTools)
		while (id and item) do
			for set = 1, 3, 1 do
				if (buyList[set] and buyList[set][item.itemID]) then buyList[set][item.itemID] = buyList[set][item.itemID] + 1 end
			end
			id, item = next(gTools, id)
		end
	end
	
	mc_vendormanager.checkBuyFilters(buyList)
	for set = 1, 3, 1 do
		if (buyList[set]) then
			for key, owned in pairs(buyList[set]) do
				if type(buyList[set][key]) == "number" then
					buyList[set][key] = BuyManager_toolStacks - buyList[set][key]
				end
			end
		end
	end
	if (buyList[1] or buyList[2] or buyList[3]) then
		return buyList
	end
	return false
end

function mc_vendormanager.checkBuyFilters(buyList)
	for tool = 1, 3, 1 do
		local set = buyList[tool]
		if (set) then
			local itemID,_ = next(set)
			if (itemID) then
				if (BuyManager_copperTools == "0") then buyList[tool][itemID] = false end
				itemID,_ = next(set,itemID)
				if (BuyManager_ironTools == "0") then buyList[tool][itemID] = false end
				itemID,_ = next(set,itemID)
				if (BuyManager_steelTools == "0") then buyList[tool][itemID] = false end
				itemID,_ = next(set,itemID)
				if (BuyManager_darksteelTools == "0") then buyList[tool][itemID] = false end
				itemID,_ = next(set,itemID)
				if (BuyManager_mithrilTools == "0") then buyList[tool][itemID] = false end
				itemID,_ = next(set,itemID)
				if (BuyManager_orichalcumTools == "0") then buyList[tool][itemID] = false end
			end
		end
	end
	return buyList
end


function mc_vendormanager.GUIVarUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		if (k == "SellManager_Active" or 
			-- Salvage Kits
			k == "BuyManager_Active" or
			k == "BuyManager_sCommon" or
			k == "BuyManager_sFine" or
			k == "BuyManager_sMasterwork" or
			k == "BuyManager_sRare" or
			k == "BuyManager_sExotic" or
			k == "BuyManager_sStacks" or
			-- Gathering Tools
			k == "BuyManager_copperTools" or
			k == "BuyManager_ironTools" or
			k == "BuyManager_steelTools" or
			k == "BuyManager_darksteelTools" or
			k == "BuyManager_mithrilTools" or
			k == "BuyManager_orichalcumTools" or
			k == "BuyManager_toolStacks")
			then 
			Settings.GW2Minion[tostring(k)] = v
			
		elseif (k == "SellManager_Name"  or
				k == "SellManager_Soulbound"  or
				k == "SellManager_Rarity" or
				k == "SellManager_Itemtype" or
				k == "SellManager_Weapontype" or
				k == "SellManager_ItemID"
				)
		then
			mc_vendormanager.filterList[SellManager_CurFilter].soulbound = SellManager_Soulbound
			mc_vendormanager.filterList[SellManager_CurFilter].rarity = SellManager_Rarity
			mc_vendormanager.filterList[SellManager_CurFilter].itemtype = SellManager_Itemtype
			mc_vendormanager.filterList[SellManager_CurFilter].weapontype = SellManager_Weapontype
			mc_vendormanager.filterList[SellManager_CurFilter].itemID = SellManager_ItemID
		end
		Settings.GW2Minion.SellManager_FilterList = mc_vendormanager.filterList
	end
end


function mc_vendormanager.SellToggleMenu()
	if (mc_vendormanager.sellwindowVisible) then
		GUI_WindowVisible(mc_vendormanager.sellmainwindow.name,false)
		mc_vendormanager.sellwindowVisible = false
	else
		local wnd = GUI_GetWindowInfo("MinionBot")
		GUI_MoveWindow( mc_vendormanager.sellmainwindow.name, wnd.x+wnd.width,wnd.y) 
		GUI_WindowVisible(mc_vendormanager.sellmainwindow.name,true)
		mc_vendormanager.sellwindowVisible = true
	end
end


function mc_vendormanager.BuyToggleMenu()
	if (mc_vendormanager.buywindowvisible) then
		GUI_WindowVisible(mc_vendormanager.buymainwindow.name,false)
		mc_vendormanager.buywindowvisible = false
	else
		local wnd = GUI_GetWindowInfo("MinionBot")
		GUI_MoveWindow( mc_vendormanager.buymainwindow.name, wnd.x+wnd.width,wnd.y) 
		GUI_WindowVisible(mc_vendormanager.buymainwindow.name,true)
		mc_vendormanager.buywindowvisible = true
	end
end

RegisterEventHandler("sellManager.toggle", mc_vendormanager.SellToggleMenu)
RegisterEventHandler("buymanager.toggle", mc_vendormanager.BuyToggleMenu)
RegisterEventHandler("GUI.Update",mc_vendormanager.GUIVarUpdate)
RegisterEventHandler("Module.Initalize",mc_vendormanager.ModuleInit)