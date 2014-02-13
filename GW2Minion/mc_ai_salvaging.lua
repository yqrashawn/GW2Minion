-- Handles Death, respawn and downed fighting
mc_ai_salvaging = {}

c_salvage = inheritsFrom( ml_cause )
e_salvage = inheritsFrom( ml_effect )
function c_salvage:evaluate()
	return (SalvageManager_Active == "1" and Inventory.freeSlotCount < 5 and Inventory.freeSlotCount > 0 and TableSize(Inventory("itemtype="..GW2.ITEMTYPE.SalvageTool))>0 and TableSize(mc_salvagemanager.createItemList())>0 )
end
function e_salvage:execute()
	ml_log("e_need_salvage")

	local TList = Inventory("itemtype="..GW2.ITEMTYPE.SalvageTool)
	local IList = mc_salvagemanager.createItemList()
		
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
	return ml_log(false)
end
