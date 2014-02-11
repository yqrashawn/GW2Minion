mc_sellmanager = {}
-- sellManager for adv. sell customization
mc_sellmanager.mainwindow = { name = GetString("sellmanager"), x = 350, y = 50, w = 250, h = 350}
mc_sellmanager.editwindow = { name = GetString("selleditor"), w = 250, h = 350}
mc_sellmanager.filterList = {}
mc_sellmanager.visible = false


function mc_sellmanager.ModuleInit()
	
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
	
	
	-- MANAGER WINDOW
	GUI_NewButton(mc_global.window.name, GetString("sellGroup"), "sellManager.toggle",GetString("vendorSettings"))
	GUI_NewNumeric(mc_global.window.name,GetString("repairDamaged"),"gRepairDamageLimit",mc_getstring("vendorSettings"),"0","15");
	GUI_NewNumeric(mc_global.window.name,GetString("repairBroken"),"gRepairBrokenLimit",mc_getstring("vendorSettings"),"0","15");
	
	-- SELL SETTINGS
	GUI_NewWindow(mc_sellmanager.mainwindow.name,mc_sellmanager.mainwindow.x,mc_sellmanager.mainwindow.y,mc_sellmanager.mainwindow.w,mc_sellmanager.mainwindow.h)
	GUI_NewCheckbox(mc_sellmanager.mainwindow.name,GetString("active"),"SellManager_Active",GetString("sellGroup"))
	GUI_NewField(mc_sellmanager.mainwindow.name,GetString("newfiltername"),"SellManager_NewFilterName",GetString("sellGroup"))
	GUI_NewButton(mc_sellmanager.mainwindow.name,GetString("newfilter"),"SellManager_NewFilter",GetString("sellGroup"))
	RegisterEventHandler("SellManager_NewFilter",mc_sellmanager.filterWindow)
	
	GUI_SizeWindow(mc_sellmanager.mainwindow.name,mc_sellmanager.mainwindow.w,mc_sellmanager.mainwindow.h)
	GUI_UnFoldGroup(mc_sellmanager.mainwindow.name,GetString("sellGroup"))
	GUI_WindowVisible(mc_sellmanager.mainwindow.name,false)
	
	GUI_UnFoldGroup(mc_sellmanager.mainwindow.name,GetString("sellfilters"))
	
	-- EDITOR WINDOW
	GUI_NewWindow(mc_sellmanager.editwindow.name,mc_sellmanager.mainwindow.x+mc_sellmanager.mainwindow.w,mc_sellmanager.mainwindow.y,mc_sellmanager.editwindow.w,mc_sellmanager.editwindow.h)
	GUI_NewField(mc_sellmanager.editwindow.name,GetString("name"),"SellManager_Name",GetString("filterdetails"))
	GUI_NewComboBox(mc_sellmanager.editwindow.name,GetString("soulbound"),"SellManager_Soulbound",GetString("filterdetails"),"true,false,either")
	GUI_NewComboBox(mc_sellmanager.editwindow.name,GetString("itemtype"),"SellManager_Itemtype",GetString("filterdetails"),"")
	GUI_NewComboBox(mc_sellmanager.editwindow.name,GetString("rarity"),"SellManager_Rarity",GetString("filterdetails"),GetString("rarityNone")..","..GetString("rarityJunk")..","..GetString("rarityCommon")..","..GetString("rarityFine")..","..GetString("rarityMasterwork")..","..GetString("rarityRare")..","..GetString("rarityExotic"));
	GUI_NewComboBox(mc_sellmanager.editwindow.name,GetString("weapontype"),"SellManager_Weapontype",GetString("filterdetails"),"")
	GUI_NewField(mc_sellmanager.editwindow.name,GetString("itemid"),"SellManager_ItemID",GetString("filterdetails"))
	GUI_NewButton(mc_sellmanager.editwindow.name,GetString("delete"),"SellManager_DeleteFilter")
	RegisterEventHandler("SellManager_DeleteFilter",mc_sellmanager.deleteFilter)
	
	GUI_SizeWindow(mc_sellmanager.editwindow.name,mc_sellmanager.editwindow.w,mc_sellmanager.editwindow.h)
	GUI_UnFoldGroup(mc_sellmanager.editwindow.name,GetString("filterdetails"))
	GUI_WindowVisible(mc_sellmanager.editwindow.name,false)

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
	mc_sellmanager.filterList = Settings.GW2Minion.SellManager_FilterList
	gRepairDamageLimit = Settings.GW2Minion.gRepairDamageLimit
	gRepairBrokenLimit = Settings.GW2Minion.gRepairBrokenLimit
	
	mc_sellmanager.refreshFilterlist()
end

--Create filtered Itemlist
function mc_sellmanager.createItemList()
	local items = Inventory("")
	local filteredItems = {}
	if (items) then
		local id, item = next(items)
		while (id and item) do
			local addItem = false
			local _, filter = next(mc_sellmanager.filterList)
			while (filter) do
				if (mc_sellmanager.validFilter(filter)) then
					if ((filter.rarity == "None" or filter.rarity == nil or GW2.ITEMRARITY[filter.rarity] == item.rarity) and
					(filter.itemtype == "None" or filter.itemtype == nil or GW2.ITEMTYPE[filter.itemtype] == item.itemtype) and
					(filter.weapontype == "None" or filter.weapontype == nil or GW2.WEAPONTYPE[filter.weapontype] == item.weapontype) and
					(filter.itemID == "None" or filter.itemID == nil or tonumber(filter.itemID) == item.itemID) and
					(filter.soulbound == "either" or (filter.soulbound == nil and item.soulbound == false) or filter.soulbound == tostring(item.soulbound))) then
						addItem = true
					end
				end
				_, filter = next(mc_sellmanager.filterList, _)
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

--Check if filter is valid: 
function mc_sellmanager.validFilter(filter)
	if (filter.itemtype ~= "None" and filter.itemtype ~= nil and
	filter.rarity ~= "None" and filter.rarity ~= nil) then
		return true
	elseif (filter.itemID ~= "None" and filter.itemID ~= nil) then
		return true
	end
	return false
end

--Can sell.
function mc_sellmanager.canSell()
	if (ValidTable(mc_sellmanager.createItemList())) then
		return true
	end
	return false
end


--New filter/Load filter.
function mc_sellmanager.filterWindow(filterNumber)
	if (mc_sellmanager.filterList[filterNumber] == nil and not mc_sellmanager.filterExcists() and SellManager_NewFilterName ~= nil and SellManager_NewFilterName ~= "") then
		filterNumber = TableSize(mc_sellmanager.filterList) + 1
		mc_sellmanager.filterList[filterNumber] = {name = SellManager_NewFilterName, soulbound = "false", rarity = "None", itemtype = "None", weapontype = "None", itemID = "None"}
		mc_sellmanager.refreshFilterlist()
		Settings.GW2Minion.SellManager_FilterList = mc_sellmanager.filterList
	end
	if (string.find(filterNumber, "SellManager_Filter")) then
		filterNumber = string.gsub(filterNumber, "SellManager_Filter", "")
		filterNumber = tonumber(filterNumber)
	end
	if (mc_sellmanager.filterList[filterNumber] ~= nil) then
		SellManager_Name = mc_sellmanager.filterList[filterNumber].name or "None"
		SellManager_Soulbound = mc_sellmanager.filterList[filterNumber].soulbound or "false"
		SellManager_Rarity = mc_sellmanager.filterList[filterNumber].rarity or "None"
		SellManager_Itemtype = mc_sellmanager.filterList[filterNumber].itemtype or "None"
		SellManager_Weapontype = mc_sellmanager.filterList[filterNumber].weapontype or "None"
		SellManager_ItemID = mc_sellmanager.filterList[filterNumber].itemID or "None"
		GUI_WindowVisible(mc_sellmanager.editwindow.name,true)
	end
	SellManager_CurFilter = filterNumber
end

--Delete filter.
function mc_sellmanager.deleteFilter()
	table.remove(mc_sellmanager.filterList, SellManager_CurFilter)
	Settings.GW2Minion.SellManager_FilterList = mc_sellmanager.filterList
	mc_sellmanager.refreshFilterlist()
end

--Check if filter name excists.
function mc_sellmanager.filterExcists()
	local i,v = next(mc_sellmanager.filterList)
	while (i and v) do
		if (SellManager_NewFilterName == v.name) then
			return true
		end
		i,v = next(mc_sellmanager.filterList, i)
	end
	return false
end

--Refresh filters.
function mc_sellmanager.refreshFilterlist()
	GUI_Delete(mc_sellmanager.mainwindow.name,GetString("sellfilters"))
	local i, v = next(mc_sellmanager.filterList)
	while (i and v) do
		GUI_NewButton(mc_sellmanager.mainwindow.name, mc_sellmanager.filterList[i].name, "SellManager_Filter" .. i,GetString("sellfilters"))
		RegisterEventHandler("SellManager_Filter" .. i ,mc_sellmanager.filterWindow)
		i, v = next(mc_sellmanager.filterList, i)
	end
	SellManager_Name = nil
	SellManager_Soulbound = nil
	SellManager_Rarity = nil
	SellManager_Itemtype = nil
	SellManager_Weapontype = nil
	SellManager_ItemID = nil
	GUI_WindowVisible(mc_sellmanager.editwindow.name,false)
	GUI_UnFoldGroup(mc_sellmanager.mainwindow.name,GetString("sellfilters"))
end

--Save filters.
function mc_sellmanager.GUIVarUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		if ( k == "SellManager_Active" ) then Settings.GW2Minion[tostring(k)] = v
		elseif (k == "SellManager_Name"  or
				k == "SellManager_Soulbound"  or
				k == "SellManager_Rarity" or
				k == "SellManager_Itemtype" or
				k == "SellManager_Weapontype" or
				k == "SellManager_ItemID")
		then
		mc_sellmanager.filterList[SellManager_CurFilter].soulbound = SellManager_Soulbound
		mc_sellmanager.filterList[SellManager_CurFilter].rarity = SellManager_Rarity
		mc_sellmanager.filterList[SellManager_CurFilter].itemtype = SellManager_Itemtype
		mc_sellmanager.filterList[SellManager_CurFilter].weapontype = SellManager_Weapontype
		mc_sellmanager.filterList[SellManager_CurFilter].itemID = SellManager_ItemID
		end
		Settings.GW2Minion.SellManager_FilterList = mc_sellmanager.filterList
	end
end


function mc_sellmanager.ToggleMenu()
	if (mc_sellmanager.visible) then
		GUI_WindowVisible(mc_sellmanager.mainwindow.name,false)
		mc_sellmanager.visible = false
	else
		local wnd = GUI_GetWindowInfo("MinionBot")
		GUI_MoveWindow( mc_sellmanager.mainwindow.name, wnd.x+wnd.width,wnd.y) 
		GUI_WindowVisible(mc_sellmanager.mainwindow.name,true)
		mc_sellmanager.visible = true
	end
end


RegisterEventHandler("sellManager.toggle", mc_sellmanager.ToggleMenu)
RegisterEventHandler("GUI.Update",mc_sellmanager.GUIVarUpdate)
RegisterEventHandler("Module.Initalize",mc_sellmanager.ModuleInit)