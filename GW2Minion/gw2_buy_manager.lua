gw2_buy_manager = {}
gw2_buy_manager.mainWindow = { name = GetString("buymanager"), x = 350, y = 50, w = 250, h = 350}
gw2minion.MainWindow.ChildWindows[gw2_buy_manager.mainWindow.name] = gw2_buy_manager.mainWindow.name
gw2_buy_manager.availableOnMap = {
	lastMap = 0,
	salvage = {[1] = true, [2] = true, [3] = true, [4] = true, [5] = true,},
	gathering = {[1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true,},
}
 gw2_buy_manager.LevelRestrictions = {
	[1] = 0,
	[2] = 10, -- lvl10
	[3] = 20, -- lvl20
	[4] = 30, -- lvl30
	[5] = 45, -- lvl45
	[6] = 60, -- lvl60	
}
gw2_buy_manager.tools = {
	["foraging"] = {
		[1] = 23029,
		[2] = 22992, -- lvl10
		[3] = 23004, -- lvl20
		[4] = 23005, -- lvl30
		[5] = 23008, -- lvl45
		[6] = 22997, -- lvl60
	},
	["logging"] = {
		[1] = 23030,
		[2] = 22994,
		[3] = 23002,
		[4] = 23006,
		[5] = 23009,
		[6] = 23000,
	},
	["mining"] = {
		[1] = 23031,
		[2] = 22995,
		[3] = 23003,
		[4] = 23007,
		[5] = 23010,
		[6] = 23001,
	},
	["salvage"] = {
		[1] = 23038, -- Crude Salvage Kit (rarity 1)
		[2] = 23040, -- Basic Salvage Kit (rarity 1)
		[3] = 23041, -- Fine (rarity 2)
		[4] = 23042, -- Journeyman (rarity 3)
		[5] = 23043,  -- Master (rarity 4)
	},
}

function gw2_buy_manager.ModuleInit()
	if (Settings.GW2Minion.BuyManager_Active == nil) then
		Settings.GW2Minion.BuyManager_Active = "1"
	end
	
	if (Settings.GW2Minion.BuyManager_Crudekit == nil) then
		Settings.GW2Minion.BuyManager_Crudekit = 0
	end
	
	if (Settings.GW2Minion.BuyManager_Basickit == nil) then
		Settings.GW2Minion.BuyManager_Basickit = 0
	end
	
	if (Settings.GW2Minion.BuyManager_Finekit == nil) then
		Settings.GW2Minion.BuyManager_Finekit = 0
	end
	
	if (Settings.GW2Minion.BuyManager_Journeymankit == nil) then
		Settings.GW2Minion.BuyManager_Journeymankit = 0
	end
	
	if (Settings.GW2Minion.BuyManager_Masterkit == nil) then
		Settings.GW2Minion.BuyManager_Masterkit = 0
	end
	
	if (Settings.GW2Minion.BuyManager_toolStacks == nil) then
		Settings.GW2Minion.BuyManager_toolStacks = 1
	end
	
	if (Settings.GW2Minion.BuyManager_GarheringTool == nil) then
		Settings.GW2Minion.BuyManager_GarheringTool = "None"
	end
	
	local mainWindow = WindowManager:NewWindow(gw2_buy_manager.mainWindow.name,gw2_buy_manager.mainWindow.x,gw2_buy_manager.mainWindow.y,gw2_buy_manager.mainWindow.w,gw2_buy_manager.mainWindow.h,false)
	if (mainWindow) then
		mainWindow:NewCheckBox(GetString("active"),"BuyManager_Active",GetString("buyGroup"))
		mainWindow:UnFold(GetString("buyGroup"))
		
		mainWindow:NewNumeric(GetString("buyCrude"),"BuyManager_Crudekit",GetString("salvageKits"),0,100)
		mainWindow:NewNumeric(GetString("buyBasic"),"BuyManager_Basickit",GetString("salvageKits"),0,100)
		mainWindow:NewNumeric(GetString("buyFine"),"BuyManager_Finekit",GetString("salvageKits"),0,100)
		mainWindow:NewNumeric(GetString("buyJourneyman"),"BuyManager_Journeymankit",GetString("salvageKits"),0,100)
		mainWindow:NewNumeric(GetString("buyMaster"),"BuyManager_Masterkit",GetString("salvageKits"),0,100)
		
		mainWindow:NewNumeric(GetString("toolStock"),"BuyManager_toolStacks",GetString("gatherTools"),0,100)
		mainWindow:NewComboBox(GetString("gatherTools"),"BuyManager_GarheringTool",GetString("gatherTools"),"None,Copper,Iron,Steel,Darksteel,Mithrill,Orichalcum")
		BuyManager_GarheringTool = BuyManager_GarheringTool
		
		mainWindow:Hide()
		
		BuyManager_Active = Settings.GW2Minion.BuyManager_Active
	
		BuyManager_Crudekit = Settings.GW2Minion.BuyManager_Crudekit
		BuyManager_Basickit = Settings.GW2Minion.BuyManager_Basickit
		BuyManager_Finekit = Settings.GW2Minion.BuyManager_Finekit
		BuyManager_Journeymankit = Settings.GW2Minion.BuyManager_Journeymankit
		BuyManager_Masterkit = Settings.GW2Minion.BuyManager_Masterkit
		
		BuyManager_toolStacks = Settings.GW2Minion.BuyManager_toolStacks
		BuyManager_GarheringTool = Settings.GW2Minion.BuyManager_GarheringTool
	end
end

-- Working stuff here.
function gw2_buy_manager.vendorSellsCheck()
	local vendorSalvageItems = VendorItemList("itemtype="..GW2.ITEMTYPE.SalvageTool)
	local vendorGatheringItems = VendorItemList("itemtype="..GW2.ITEMTYPE.Gathering)
	if (ValidTable(vendorSalvageItems) and ValidTable(vendorGatheringItems)) then
		if (gw2_buy_manager.availableOnMap.lastMap ~= ml_global_information.CurrentMapID) then
			gw2_buy_manager.availableOnMap.lastMap = ml_global_information.CurrentMapID
			gw2_buy_manager.setMapAvailablity(vendorSalvageItems,vendorGatheringItems)
		end
		return true
	end
	return false
end

function gw2_buy_manager.setMapAvailablity(salvageItems,gatheringItems)
	for key=1,5 do
		gw2_buy_manager.availableOnMap.salvage[key] = false
	end
	for _,item in pairs(salvageItems) do
		for key=1,5 do
			if (item.itemID == gw2_buy_manager.tools["salvage"][key]) then gw2_buy_manager.availableOnMap.salvage[key] = true end
		end
	end
	
	for key=1,6 do
		gw2_buy_manager.availableOnMap.gathering[key] = false
	end
	for _,item in pairs(gatheringItems) do
		for key=1,6 do
			if (item.itemID == gw2_buy_manager.tools["foraging"][key]) then gw2_buy_manager.availableOnMap.gathering[key] = true end
		end
	end
end

function gw2_buy_manager.NeedToBuySalvageKits(nearby)
	local neededKits = gw2_buy_manager.GetNeededSalvageKitList()
	for itemID,count in pairs(neededKits) do
		if (nearby == true and count > 0) then
			return true
		elseif (nearby ~= true) then
			if (itemID == gw2_buy_manager.tools["salvage"][1] and count == tonumber(BuyManager_Crudekit)) or
			(itemID == gw2_buy_manager.tools["salvage"][2] and count == tonumber(BuyManager_Basickit)) or
			(itemID == gw2_buy_manager.tools["salvage"][3] and count == tonumber(BuyManager_Finekit)) or
			(itemID == gw2_buy_manager.tools["salvage"][4] and count == tonumber(BuyManager_Journeymankit)) or
			(itemID == gw2_buy_manager.tools["salvage"][5] and count == tonumber(BuyManager_Masterkit)) then
				return true
			end
		end
	end
	return false
end

function gw2_buy_manager.GetNeededSalvageKitList()
	local neededKits = {}
	if (tonumber(BuyManager_Crudekit) > 0 and gw2_buy_manager.availableOnMap.salvage[1]) then neededKits[gw2_buy_manager.tools["salvage"][1]] = tonumber(BuyManager_Crudekit) end
	if (tonumber(BuyManager_Basickit) > 0 and gw2_buy_manager.availableOnMap.salvage[2]) then neededKits[gw2_buy_manager.tools["salvage"][2]] = tonumber(BuyManager_Basickit) end
	if (tonumber(BuyManager_Finekit) > 0 and gw2_buy_manager.availableOnMap.salvage[3]) then neededKits[gw2_buy_manager.tools["salvage"][3]] = tonumber(BuyManager_Finekit) end
	if (tonumber(BuyManager_Journeymankit) > 0 and gw2_buy_manager.availableOnMap.salvage[4]) then neededKits[gw2_buy_manager.tools["salvage"][4]] = tonumber(BuyManager_Journeymankit) end
	if (tonumber(BuyManager_Masterkit) > 0 and gw2_buy_manager.availableOnMap.salvage[5]) then neededKits[gw2_buy_manager.tools["salvage"][5]] = tonumber(BuyManager_Masterkit) end
	local ownedKits = Inventory("itemtype=" .. GW2.ITEMTYPE.SalvageTool)
	for _,kit in pairs(ownedKits) do
		if (neededKits[kit.itemID]) then
			neededKits[kit.itemID] = neededKits[kit.itemID] - 1
		end
	end
	return neededKits
end

function gw2_buy_manager.NeedToBuyGatheringTools(nearby)
	local neededTools = gw2_buy_manager.GetNeededGatheringToolList()
	for itemID,count in pairs(neededTools) do
		if (nearby == true and count > 0) then
			return true
		elseif (nearby ~= true and count == tonumber(BuyManager_toolStacks)) then
			return true
		end
	end
	return false
end

function gw2_buy_manager.toolNameToKey(name)
	return (
		name == "Copper" and 1 or
		name == "Iron" and 2 or
		name == "Steel" and 3 or
		name == "Darksteel" and 4 or
		name == "Mithrill" and 5 or
		name == "Orichalcum" and 6 or nil
	)
end

function gw2_buy_manager.checkForInfTools(tool)
	return (tool and tool.rarity == 4 and tool.stackcount == 0 and true or false)
end

function gw2_buy_manager.GetNeededGatheringToolList()
	local key = gw2_buy_manager.toolNameToKey(BuyManager_GarheringTool)
	local neededTools = {}
	local wantedCount = tonumber(BuyManager_toolStacks)
	if (wantedCount > 0 and gw2_buy_manager.availableOnMap.gathering[key] and gw2_buy_manager.LevelRestrictions[key] <= ml_global_information.Player_Level) then
		local fTool = Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.ForagingTool)
		local lTool = Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.LoggingTool)
		local mTool = Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.MiningTool)
		if (gw2_buy_manager.checkForInfTools(fTool) == false) then
			neededTools[gw2_buy_manager.tools["foraging"][key]] = wantedCount
		end
		if (gw2_buy_manager.checkForInfTools(lTool) == false) then
			neededTools[gw2_buy_manager.tools["logging"][key]] = wantedCount
		end
		if (gw2_buy_manager.checkForInfTools(mTool) == false) then
			neededTools[gw2_buy_manager.tools["mining"][key]] = wantedCount
		end
		local ownedKits = Inventory("itemtype=" .. GW2.ITEMTYPE.Gathering)
		for _,tool in pairs(ownedKits) do
			if (neededTools[tool.itemID]) then
				neededTools[tool.itemID] = neededTools[tool.itemID] - 1
			end
		end
	end
	return neededTools
end

function gw2_buy_manager.getClosestBuyMarker(nearby)
	local closestLocation = nil
	local listArg = (nearby == true and ",maxdistance=4000" or "")
	local markers = MapMarkerList("onmesh,worldmarkertype=24,markertype=25,contentID="..GW2.MAPMARKER.Merchant..listArg..",exclude_characterid="..ml_blacklist.GetExcludeString(GetString("sellvendors")))
	for _,merchant in pairs(markers) do
		if (closestLocation == nil or closestLocation.distance > merchant.distance) then
			if (nearby == true and merchant.pathdistance < 4000) then
				closestLocation = merchant
			elseif (nearby ~= true) then
				closestLocation = merchant
			end
		end
	end
	return closestLocation
end

function gw2_buy_manager.buyAtMerchant(vendorMarker)
	if (vendorMarker) then
		vendor = CharacterList:Get(vendorMarker.characterID)
		if (vendor and vendor.isInInteractRange) then
			Player:StopMovement()
			local target = Player:GetTarget()
			if (not target or target.id ~= vendor.id) then
				Player:SetTarget(vendor.id)
			else
				if (Inventory:IsVendorOpened() == false and Player:IsConversationOpen() == false) then
					ml_log(" Opening Vendor.. ")
					Player:Interact(vendor.id)
					ml_global_information.Wait(1500)
					return true
				else
					local result = gw2_common_functions.handleConversation("buy")
					if (result == false) then
						d("Vendor blacklisted, cant handle opening conversation.")
						ml_blacklist.AddBlacklistEntry(GetString("sellvendors"), vendor.id, vendor.name, true)
						return false
					elseif (result == nil) then
						ml_global_information.Wait(math.random(520,1200))
						return true
					end
				end
				if (gw2_buy_manager.vendorSellsCheck() == false) then
					d("Vendor blacklisted, does not have needed tools/kits.")
					ml_blacklist.AddBlacklistEntry(GetString("sellvendors"), vendor.id, vendor.name, true)
				end
				local vendorItems = VendorItemList("")
				local slowdown = math.random(0,3)
				if (ValidTable(vendorItems) and slowdown == 0) then
					local neededKits = gw2_buy_manager.GetNeededSalvageKitList()
					local neededTools = gw2_buy_manager.GetNeededGatheringToolList()
					for _,item in pairs(vendorItems) do
						local itemID = item.itemID
						for id,count in pairs(neededKits) do
							if (id == itemID and count > 0) then
								item:Buy()
								return true
							end
						end
						for id,count in pairs(neededTools) do
							if (id == itemID and count > 0) then
								item:Buy()
								return true	
							end
						end
					end
				end
			end
		else
			local pos = vendorMarker.pos
			if ( pos ) then
				local navResult = tostring(Player:MoveTo(pos.x,pos.y,pos.z,50,false,true,true))
				ml_log("MoveToSellVendor..")
				return true
			end
		end
	end
	return false
end

-- Toggle menu.
function gw2_buy_manager.ToggleMenu()
	local mainWindow = WindowManager:GetWindow(gw2_buy_manager.mainWindow.name)
	if (mainWindow) then
		if ( mainWindow.visible ) then
			mainWindow:Hide()
		else
			local wnd = WindowManager:GetWindow(gw2minion.MainWindow.Name)
			if ( wnd ) then
				mainWindow:SetPos(wnd.x+wnd.width,wnd.y)
				mainWindow:Show()
			end
		end
	end
end

RegisterEventHandler("Module.Initalize",gw2_buy_manager.ModuleInit)