-- Handles Death, respawn and downed fighting
mc_ai_salvaging = {}
mc_ai_needToSalvage = false

c_salvage = inheritsFrom( ml_cause )
e_salvage = inheritsFrom( ml_effect )
function c_salvage:evaluate()
	if (SalvageManager_Active == "1" and (Inventory.freeSlotCount < 10 or mc_ai_needToSalvage == true) and Inventory.freeSlotCount >= 2
	and TableSize(Inventory("itemtype="..GW2.ITEMTYPE.SalvageTool))>0 and TableSize(mc_salvagemanager.createItemList())>0 ) then
		mc_ai_needToSalvage = true
		return true
	end
	return false
end
	 -- salvagingkits 0= lowest quality 
e_salvage.kitlist = 
	 {
	  [23038] = GetString("buyCrude"), -- Crude Salvage Kit (rarity 1)
	  [23040] = GetString("buyBasic"), -- Basic Salvage Kit (rarity 1)
	  [23041] = GetString("buyFine"), -- Fine (rarity 2)
	  [23042] = GetString("buyJourneyman"), -- Journeyman (rarity 3)
	  [23043] = GetString("buyMaster"),  -- Master (rarity 4)
	  [23045] = GetString("mysticKit"), -- Mystic Kit (rarity 4)
	 }
		
function e_salvage:execute()
	ml_log("e_need_salvage")

	local TList = Inventory("itemtype="..GW2.ITEMTYPE.SalvageTool)
	local IList = mc_salvagemanager.createItemList()

	
	if ((mc_ai_needToSalvage == true and TableSize(TList)==0 or TableSize(IList)==0 )
	or (Inventory.freeSlotCount <= 2)) then
		mc_ai_needToSalvage = false
	end
	local slowdown = math.random(0,3)
	if ( TList and IList and mc_ai_needToSalvage == true and slowdown == 0 ) then 
		local tid , tool = next(TList)	
		local id , item = next(IList)
		while id and item do 
		
			-- try to get the prefered tool setup in the filters first (what a bs!)
			while tid and tool do
				local _, filter = next(mc_salvagemanager.filterList)
				while (filter) do
					if (mc_salvagemanager.validFilter(filter)) then
						if ((filter.rarity == "None" or filter.rarity == nil or GW2.ITEMRARITY[filter.rarity] == item.rarity) and
						(filter.itemtype == "None" or filter.itemtype == nil or GW2.ITEMTYPE[filter.itemtype] == item.itemtype) and 
						(filter.preferedKit ~= nil and filter.preferedKit ~= "None")) then 
						
							-- unlimited kit	 
							if (filter.preferedKit == GetString("unlimitedKit") and tool.rarity == 1 and tool.weapontype == 1) then
								-- Salvage
								if ( Player:GetCurrentlyCastedSpell() == 17 ) then
									d("Salvaging "..item.name.." with "..tool.name)
									tool:Use(item)				
								end
								return ml_log(true)
							end
							
							-- other kits 
							local idx,kitid = next ( mc_vendormanager.tools[3] )
							while idx and kitid do
								if ( kitid == tool.itemID and e_salvage.kitlist[kitid] == filter.preferedKit ) then
									-- Salvage
									if ( Player:GetCurrentlyCastedSpell() == 17 ) then
										d("Salvaging "..item.name.." with "..tool.name)
										tool:Use(item)				
									end
									return ml_log(true)							
								end						
								idx,kitid = next ( mc_vendormanager.tools[3], idx )
							end
						end
					end
					_, filter = next(mc_salvagemanager.filterList, _)
				end
				tid , tool = next(TList,tid)	
			end
		
			-- try to get a tool with the same raritylevel
			local itemrarity = item.itemrarity
			local besttool = nil
			tid , tool = next(TList)
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
