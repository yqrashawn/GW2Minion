-- SalvageManager
gw2_salvage_manager = {}
gw2_salvage_manager.mainWindow = { name = GetString("salvagemanager"), x = 350, y = 50, w = 250, h = 350}
gw2minion.MainWindow.ChildWindows[gw2_salvage_manager.mainWindow.name] = gw2_salvage_manager.mainWindow.name
gw2_salvage_manager.filterList = {}
gw2_salvage_manager.currentFilter = nil
gw2_salvage_manager.kitlist = {
	-- normal kits
	[23038] = {name = GetString("buyCrude"),		rarity = 0,},	-- Crude Salvage Kit (rarity 1)
	[23040] = {name = GetString("buyBasic"),		rarity = 1,},	-- Basic Salvage Kit (rarity 1)
	[23041] = {name = GetString("buyFine"),			rarity = 2,},	-- Fine (rarity 2)
	[23042] = {name = GetString("buyJourneyman"),	rarity = 3,},	-- Journeyman (rarity 3)
	[23043] = {name = GetString("buyMaster"),		rarity = 4,},	-- Master (rarity 4)
	-- special kits
	[23045] = {name = GetString("mysticKit"),		rarity = 4,},	-- Mystic Kit (rarity 4)
	[44602] = {name = GetString("copperFedKit"),	rarity = 1,},	-- Copper-Fed Kit (rarity 1)
	[67027] = {name = GetString("silverFedKit"),	rarity = 4,},	-- Silver-Fed Kit (rarity 4)
	[19986] = {name = GetString("blackLionKit"), 	rarity = 5,},	--Black Lion Kit (Rarity 5)
}


function gw2_salvage_manager.ModuleInit()
	if (Settings.GW2Minion.SalvageManager_Active == nil ) then
		Settings.GW2Minion.SalvageManager_Active = "1"
	end
	
	if (Settings.GW2Minion.SalvageManager_ItemIDInfo == nil ) then
		Settings.GW2Minion.SalvageManager_ItemIDInfo = {}
	end
	
	if (Settings.GW2Minion.SalvageManager_FilterList == nil) then
		Settings.GW2Minion.SalvageManager_FilterList = {
			{
				itemtype = "Weapon",
				name = "Weapons_Junk",
				rarity = "Junk",
				preferedKit = "None",
			},
			{
				itemtype = "Weapon",
				name = "Weapons_Common",
				rarity = "Common",
				preferedKit = "None",
			},
			{
				itemtype = "Weapon",
				name = "Weapons_Masterwork",
				rarity = "Masterwork",
				preferedKit = "None",
			},
			{
				itemtype = "Weapon",
				name = "Weapons_Fine",
				rarity = "Fine",
				preferedKit = "None",
			},
			{
				itemtype = "Armor",
				name = "Armor_Junk",
				rarity = "Junk",
				preferedKit = "None",
			},
			{
				itemtype = "Armor",
				name = "Armor_Common",
				rarity = "Common",
				preferedKit = "None",
			},
			{
				itemtype = "Armor",
				name = "Armor_Masterwork",
				rarity = "Masterwork",
				preferedKit = "None",
			},
			{
				itemtype = "Armor",
				name = "Armor_Fine",
				rarity = "Fine",
				preferedKit = "None",
			},
		}
	end
		
	gw2_salvage_manager.filterList = Settings.GW2Minion.SalvageManager_FilterList
	
	-- Init Main Window
	local mainWindow = WindowManager:NewWindow(gw2_salvage_manager.mainWindow.name,gw2_salvage_manager.mainWindow.x,gw2_salvage_manager.mainWindow.y,gw2_salvage_manager.mainWindow.w,gw2_salvage_manager.mainWindow.h,false)
	if (mainWindow) then
		mainWindow:NewButton(GetString("newfilter"),"SalvageManager_NewFilter")
		RegisterEventHandler("SalvageManager_NewFilter",gw2_salvage_manager.CreateDialog)
		mainWindow:NewCheckBox(GetString("active"),"SalvageManager_Active",GetString("salvage"))
		mainWindow:UnFold(GetString("salvage"))
		
		mainWindow:NewComboBox(GetString("salvageByIDtems"),"SalvageManager_ItemToSalvage",GetString("salvageByID"),"None")
		SalvageManager_ItemToSalvage = "None"
		local list = GetString("rarityNone")..","..GetString("buyCrude")..","..GetString("buyBasic")..","..GetString("buyFine")..","..GetString("buyJourneyman")..","..GetString("buyMaster")..","..GetString("mysticKit")..","..GetString("unlimitedKit")
		mainWindow:NewComboBox(GetString("preferedKit"),"SalvageManager_SingleKit",GetString("salvageByID"),list)
		SalvageManager_SingleKit = GetString("rarityNone")
		mainWindow:NewButton(GetString("salvageByIDAddItem"),"SalvageManager_AdditemID",GetString("salvageByID"))
		RegisterEventHandler("SalvageManager_AdditemID",gw2_salvage_manager.AddItemID)
		mainWindow:NewComboBox(GetString("salvageItemList"),"SalvageManager_ItemIDList",GetString("salvageByID"),"None")
		SalvageManager_ItemIDList = "None"
		mainWindow:NewButton(GetString("salvageByIDRemoveItem"),"SalvageManager_RemoveitemID",GetString("salvageByID"))
		RegisterEventHandler("SalvageManager_RemoveitemID",gw2_salvage_manager.RemoveItemID)
		
		mainWindow:Hide()
	end
	
	SalvageManager_Active = Settings.GW2Minion.SalvageManager_Active
	SalvageManager_ItemIDInfo = Settings.GW2Minion.SalvageManager_ItemIDInfo
	
	if (Player) then
		gw2_salvage_manager.UpdateComboBox(Inventory("salvagable"),"SalvageManager_ItemToSalvage",SalvageManager_ItemIDInfo)
		gw2_salvage_manager.UpdateComboBox(SalvageManager_ItemIDInfo,"SalvageManager_ItemIDList")
		gw2_salvage_manager.refreshFilterlist()
	end
	
end

-- SINGLE ITEM STUFF HERE
-- Update singe-item drop-down list.
function gw2_salvage_manager.UpdateComboBox(iTable,global,excludeTable,setToName)
	if (iTable and global) then
		local list = "None"
		for _,item in pairs(iTable) do
			if (ValidString(item.name) and StringContains(list, item.name) == false)then
				local name = item.name 
				if (ValidTable(excludeTable)) then
					for _,eItem in pairs(excludeTable) do
						if (eItem.name == item.name) then
							name = ""
						end
					end
				end
				list = (ValidString(name) == true and list .. "," .. name or list)
			end
		end
		_G[global] = (setToName == false and _G[global] or ValidString(setToName) and setToName or "None")
		_G[global .. "_listitems"] = list
	end
end

-- Add Single-Item to itemIDlist.
function gw2_salvage_manager.AddItemID()
	if (ValidString(SalvageManager_ItemToSalvage) and SalvageManager_ItemToSalvage ~= "None") then
		-- Make sure this item is not already in our SellList
		for _,item in pairs(SalvageManager_ItemIDInfo) do
			if (SalvageManager_ItemToSalvage == item.name) then
				return
			end
		end
		-- Find Item by Name in Inventory
		for _,item in pairs(Inventory("")) do
			if (ValidString(item.name) and item.name == SalvageManager_ItemToSalvage)then
				table.insert(SalvageManager_ItemIDInfo, {name = item.name, itemID = item.itemID, preferedKit = SalvageManager_SingleKit})
				gw2_salvage_manager.UpdateComboBox(SalvageManager_ItemIDInfo,"SalvageManager_ItemIDList",nil,item.name)
				break
			end
		end
		Settings.GW2Minion.SalvageManager_ItemIDInfo = SalvageManager_ItemIDInfo
		gw2_salvage_manager.UpdateComboBox(Inventory("salvagable"),"SalvageManager_ItemToSalvage",SalvageManager_ItemIDInfo)
	end
	return false
end

-- Remove Single-Item from itemIDlist.
function gw2_salvage_manager.RemoveItemID()
	if ( ValidString(SalvageManager_ItemIDList) and SalvageManager_ItemIDList ~= "None") then
		for id,item in pairs(SalvageManager_ItemIDInfo) do
			if (item.name == SalvageManager_ItemIDList) then
				table.remove(SalvageManager_ItemIDInfo, id)
				break
			end
		end
		Settings.GW2Minion.SalvageManager_ItemIDInfo = SalvageManager_ItemIDInfo
		gw2_salvage_manager.UpdateComboBox(SalvageManager_ItemIDInfo,"SalvageManager_ItemIDList")
		gw2_salvage_manager.UpdateComboBox(Inventory("salvagable"),"SalvageManager_ItemToSalvage",SalvageManager_ItemIDInfo)
	end
end

-- FILTER STUFF HERE
--Refresh filters.
function gw2_salvage_manager.refreshFilterlist()
	local mainWindow = WindowManager:GetWindow(gw2_salvage_manager.mainWindow.name)
	if (mainWindow) then
		mainWindow:DeleteGroup(GetString("salvagefilters"))
		for id,filter in pairs(gw2_salvage_manager.filterList) do
			mainWindow:NewButton(gw2_salvage_manager.filterList[id].name, "SalvageManager_Filter" .. id,GetString("salvagefilters"))
			RegisterEventHandler("SalvageManager_Filter" .. id ,gw2_salvage_manager.CreateDialog)
		end
		mainWindow:UnFold(GetString("salvagefilters"))
	end
end

-- Create New Filter Dialog.
function gw2_salvage_manager.CreateDialog(filterID)
	if (filterID:find("SalvageManager_Filter")) then
		filterID = string.gsub(filterID, "SalvageManager_Filter", "")
		filterID = tonumber(filterID)
		gw2_salvage_manager.currentFilter = filterID
	end
	local dialog = gw2_dialog_manager:GetDialog(GetString("newsalvagefilter"))
	if (dialog == nil) then
		dialog = gw2_dialog_manager:NewDialog(GetString("newsalvagefilter"))
		dialog:NewField(GetString("name"),"SalvageManager_Name")
		local list = "None"
		for name,_ in pairs(GW2.ITEMTYPE) do list = list .. "," .. name end
		dialog:NewComboBox(GetString("itemtype"),"SalvageManager_Itemtype",list)
		list = GetString("rarityNone")..","..GetString("rarityJunk")..","..GetString("rarityCommon")..","..GetString("rarityFine")..","..GetString("rarityMasterwork")..","..GetString("rarityRare")..","..GetString("rarityExotic")
		dialog:NewComboBox(GetString("rarity"),"SalvageManager_Rarity",list)
		list = GetString("rarityNone")..","..GetString("buyCrude")..","..GetString("buyBasic")..","..GetString("buyFine")..","..GetString("buyJourneyman")..","..GetString("buyMaster")..","..GetString("mysticKit")..","..GetString("copperFedKit")..","..GetString("silverFedKit")
		dialog:NewComboBox(GetString("preferedKit"),"SalvageManager_Kit",list)
		dialog:SetOkFunction(function()
			local saveFilter = {name = SalvageManager_Name,itemtype = SalvageManager_Itemtype,rarity = SalvageManager_Rarity,preferedKit = SalvageManager_Kit}
			if (ValidString(saveFilter.name) == false) then
				return "Please enter a filter name before saving."
			elseif (gw2_salvage_manager.validFilter(saveFilter)) then -- check if filter is valid.
				if (type(filterID) ~= "number") then -- new filter, making sure name is not in use.
					for _,filter in pairs(gw2_salvage_manager.filterList) do
						if (saveFilter.name == filter.name) then
							return "Filter with this name already exists, please change the name."
						end
					end
					table.insert(gw2_salvage_manager.filterList, saveFilter)
				else
					gw2_salvage_manager.filterList[filterID] = saveFilter
				end
				Settings.GW2Minion.SalvageManager_FilterList = gw2_salvage_manager.filterList
				gw2_salvage_manager.refreshFilterlist()
				return true
			else
				return "Filter Not Valid. Filter needs to have both type and rarity set. Junk rarity can be set without any type."
			end
		end)
		dialog:SetDeleteFunction(function()
			table.remove(gw2_salvage_manager.filterList, gw2_salvage_manager.currentFilter)
			Settings.GW2Minion.SalvageManager_FilterList = gw2_salvage_manager.filterList
			gw2_salvage_manager.refreshFilterlist()
			return true
		end)
	end
	if (dialog) then
		local tType = (type(filterID) == "number")
		dialog:Show(tType)
		SalvageManager_Name = (tType and gw2_salvage_manager.filterList[filterID].name or "")
		SalvageManager_Itemtype = (tType and gw2_salvage_manager.filterList[filterID].itemtype or "None")
		SalvageManager_Rarity = (tType and gw2_salvage_manager.filterList[filterID].rarity or GetString("rarityNone"))
		SalvageManager_Kit = (tType and gw2_salvage_manager.filterList[filterID].preferedKit or GetString("rarityNone"))
	end
end

-- Check if filter is valid:
function gw2_salvage_manager.validFilter(filter)
	if (filter.itemtype ~= "None" and filter.itemtype ~= nil and
	filter.rarity ~= "None" and filter.rarity ~= nil) then
		return true
	elseif (filter.rarity == "Junk") then
		return true
	end
	return false
end

-- Working stuff here.
--Create filtered salvage item list.
function gw2_salvage_manager.createItemList()
	local items = Inventory("salvagable,exclude_contentid="..ml_blacklist.GetExcludeString(GetString("salvageItems")))
	local filteredItems = {}
	if (items) then
		for _,item in pairs(items) do
			if (item.salvagable and item.soulbound == false) then
				local addItem = false
				for _,filter in pairs(gw2_salvage_manager.filterList) do
					if (gw2_salvage_manager.validFilter(filter)) then
						if ((filter.rarity == nil or filter.rarity == "None" or GW2.ITEMRARITY[filter.rarity] == item.rarity) and
						(filter.itemtype == nil or filter.itemtype == "None" or GW2.ITEMTYPE[filter.itemtype] == item.itemtype)) then
							addItem = true
							item.preferedKit = filter.preferedKit
							break
						end
					end
				end
				-- Check single itemlist
				if (addItem == false) then
					for iID,lItem in pairs(SalvageManager_ItemIDInfo) do
						if (item.itemID == lItem.itemID) then
							addItem = true
							item.preferedKit = lItem.preferedKit
							break
						end
					end
				end
				-- Add item if found in filters.
				if (addItem) then
					table.insert(filteredItems, item)
				end
			end
		end
		if (ValidTable(filteredItems)) then
			return filteredItems
		end
	end
	return false
end

--Have Salvageable items.
function gw2_salvage_manager.haveSalvagebleItems()
	if (ValidTable(gw2_salvage_manager.createItemList())) then
		return true
	end
	return false
end

--Have Salvage tools.
function gw2_salvage_manager.haveSalvageTools()
	if (TableSize(Inventory("itemtype="..GW2.ITEMTYPE.SalvageTool))>0) then
		return true
	end
	return false
end

-- Get Best tool to salvage.
function gw2_salvage_manager.getBestTool(item)
	if (item) then
		local tList = Inventory("itemtype="..GW2.ITEMTYPE.SalvageTool)
		local returnTool = nil
		if (tList) then
			for _,tool in pairs(tList) do
				-- Search for preftool
				if (gw2_salvage_manager.kitlist[tool.itemID].name == item.preferedKit) then
					return tool
				end
				-- Search for besttool
				if (returnTool == nil or math.abs(item.rarity - gw2_salvage_manager.kitlist[tool.itemID].rarity) < math.abs(item.rarity - returnTool.rarity)) then
					returnTool = tool
				end
			end
			if (returnTool) then
				return returnTool
			end
		end
	end
end

-- Toggle menu.
function gw2_salvage_manager.ToggleMenu()
	local mainWindow = WindowManager:GetWindow(gw2_salvage_manager.mainWindow.name)
	if (mainWindow) then
		if ( mainWindow.visible ) then
			mainWindow:Hide()
		else
			local wnd = WindowManager:GetWindow(gw2minion.MainWindow.Name)
			if ( wnd ) then
				mainWindow:SetPos(wnd.x+wnd.width,wnd.y)
				mainWindow:Show()
				gw2_salvage_manager.UpdateComboBox(Inventory("salvagable"),"SalvageManager_ItemToSalvage",SalvageManager_ItemIDInfo)
			end
		end
	end
end

RegisterEventHandler("Module.Initalize",gw2_salvage_manager.ModuleInit)