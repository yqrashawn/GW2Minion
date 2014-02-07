-- Handles Death, respawn and downed fighting
mc_ai_salvaging = {}

mc_ai_salvaging.Rarity = {
	[mc_getstring("rarityJunk")] = 0,
	[mc_getstring("rarityCommon")] = 1,
	[mc_getstring("rarityFine")] = 2,
	[mc_getstring("rarityMasterwork")] = 3,
	[mc_getstring("rarityRare")] = 4,
	[mc_getstring("rarityExotic")] = 5,
}
	
function mc_ai_salvaging.moduleinit()
	if ( Settings.GW2Minion.gSalvage == nil ) then
		Settings.GW2Minion.gSalvage = "0"
	end
	if ( Settings.GW2Minion.gMaxSalvageRarity == nil ) then
		Settings.GW2Minion.gMaxSalvageRarity = "Fine"
	end

	
	GUI_NewCheckbox(mc_global.window.name,mc_getstring("enableSalvage"),"gSalvage",mc_getstring("salvageSettings"))
	GUI_NewComboBox(mc_global.window.name,mc_getstring("rarityMax"),"gMaxSalvageRarity",mc_getstring("salvageSettings"),mc_getstring("rarityJunk")..","..mc_getstring("rarityCommon")..","..mc_getstring("rarityFine")..","..mc_getstring("rarityMasterwork")..","..mc_getstring("rarityRare")..","..mc_getstring("rarityExotic"));
	GUI_NewCheckbox(mc_global.window.name,mc_getstring("salvageTrophy"),"gSalvageTrophies",mc_getstring("salvageSettings"))
	
	
	gSalvage = Settings.GW2Minion.gSalvage
	gMaxSalvageRarity = Settings.GW2Minion.gMaxSalvageRarity

end


function mc_ai_salvaging.CanSalvage()	
	local rarity = mc_ai_salvaging.Rarity[gMaxSalvageRarity]
	if ( tonumber(rarity) ) then
		local TList = Inventory("itemtype="..GW2.ITEMTYPE.SalvageTool)
		if ( TableSize (TList) > 0 ) then
			local IList = Inventory("salvagable,notsoulbound,maxrarity="..rarity..",exclude_contentid="..mc_blacklist.GetExcludeString(mc_getstring("salvageItems")))
			if ( TableSize ( IList ) > 0 ) then
				local id,item = next ( IList ) 
				while id and item do
					if (item.itemtype == GW2.ITEMTYPE.Armor or item.itemtype == GW2.ITEMTYPE.Weapon or gSalvageTrophies == "1" and item.itemtype == GW2.ITEMTYPE.Trophy) then
						return true	
					end
					id,item = next ( IList,id )
				end
			end
		end
	end
	return false
end


c_salvage = inheritsFrom( ml_cause )
e_salvage = inheritsFrom( ml_effect )
function c_salvage:evaluate()
	return (gSalvage == "1" and Inventory.freeSlotCount < 5 and Inventory.freeSlotCount > 0 and mc_ai_salvaging.CanSalvage() )
end
function e_salvage:execute()
	ml_log("e_need_salvage")
	local rarity = mc_ai_salvaging.Rarity[gMaxSalvageRarity]
	if ( tonumber(rarity) ) then
		local TList = Inventory("itemtype="..GW2.ITEMTYPE.SalvageTool)
		local IList = Inventory("salvagable,notsoulbound,maxrarity="..rarity..",exclude_contentid="..mc_blacklist.GetExcludeString(mc_getstring("salvageItems")))
		
		if ( TList and IList ) then 
			local tid , tool = next(TList)	
			local id , item = next(IList)
			while id and item do 
				-- try to get a tool with the same raritylevel
				local itemrarity = item.itemrarity
				local besttool = nil
				while tid and tool do 
					if ( tool.rarity == itemrarity ) then
						-- Salvage
						if ( Player:GetCurrentlyCastedSpell() == 17 ) then
							d("Salvaging "..item.name.." with "..tool.name)
							tool:Use(item)				
						end
						return ml_log(true)
					end
					if ( not besttool or besttool.rarity < tool.rarity ) then
						besttool = tool
					end
					tid , tool = next(TList,tid)	
				end
				
				-- seems we couldnt find a tool with the same rarity as our item
				if ( besttool ) then
					-- Salvage
					if ( Player:GetCurrentlyCastedSpell() == 17 ) then
						d("Salvaging "..item.name.." with "..besttool.name)
						besttool:Use(item)
					end
					return ml_log(true)
				end			
				id , item = next(IList, id)
			end	
		end
	end
	return ml_log(false)
end

	
RegisterEventHandler("Module.Initalize",mc_ai_salvaging.moduleinit)