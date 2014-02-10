-- Handles Selling,Buying,Repairing
-- UI is in mc_Sellmanager.lua
mc_ai_vendor = {}

-- SELLING 
mc_ai_vendor.isSelling = false
function mc_ai_vendor.NeedToSell()	
	if ( mc_ai_vendor.isSelling ) then return true end

	return mc_sellmanager.canSell()
end
function mc_ai_vendor.GetClosestVendorMarker()	
	if ( mc_ai_vendor.isSelling ) then return true end
	local mList = MapMarkerList("worldmarkertype=23,nearest,onmesh,type="..GW2.MAPMARKERTYPE.Merchant..",exclude_characterid="..mc_blacklist.GetExcludeString(GetString("vendors"))) 
	if ( TableSize(mList) > 0 )  then
		local i,marker = next (mList)
		if ( i and marker) then
			return marker
		end
	end
	return nil
end

-- BUY TOOLS
mc_ai_vendor.isBuying = false
function mc_ai_vendor.NeedToBuyGatheringTools()	
	if ( mc_ai_vendor.isBuying ) then return true end
	
	
	return false
end
function mc_ai_vendor.GetClosestBuyVendorMarker()	
	if ( mc_ai_vendor.isSelling ) then return true end
	local mList = MapMarkerList("worldmarkertype=23,nearest,onmesh,type="..GW2.MAPMARKERTYPE.Merchant..",exclude_characterid="..mc_blacklist.GetExcludeString(GetString("vendorsbuy"))) 
	if ( TableSize(mList) > 0 )  then
		local i,marker = next (mList)
		if ( i and marker) then
			return marker
		end
	end
	return nil
end

-- REPAIR
mc_ai_vendor.isRepairing = false
function mc_ai_vendor.NeedToRepair()	
	
	local damaged = 0
	local broken = 0
	for i=1 ,24 ,1  do 
		if ( i < 8 or i > 18 ) then
			local eqItem = Inventory:GetEquippedItemBySlot( i )
			if ( eqItem ~= nil ) then
				local dur = eqItem.durability 
				if ( dur == GW2.ITEMDURABILITY.Broken) then broken = broken + 1 end
				if ( dur == GW2.ITEMDURABILITY.Damaged) then damaged = damaged + 1 end
			end
		end
	end
	--TODO ADD 2 numerics for these 2 and 5
	return broken > 2 or damaged > 5
end
function mc_ai_vendor.GetClosestRepairVendorMarker()	
	if ( mc_ai_vendor.isSelling ) then return true end
	local mList = MapMarkerList("worldmarkertype=23,nearest,onmesh,type="..GW2.MAPMARKERTYPE.RepairMerchant..",exclude_characterid="..mc_blacklist.GetExcludeString(GetString("vendors"))) 
	if ( TableSize(mList) > 0 )  then
		local i,marker = next (mList)
		if ( i and marker) then
			return marker
		end
	end
	return nil
end


function mc_ai_vendor.OpenSellWindow()
	
		ml_log( " Chatting with Vendor.." )							
		local options = Player:GetConversationOptions()
		nextOption, entry  = next( options )
		local found = false
		while ( nextOption ~= nil ) do
			if( entry == GW2.CONVERSATIONOPTIONS.Shop ) then
				Player:SelectConversationOption( GW2.CONVERSATIONOPTIONS.Shop )
				mc_global.Wait(math.random(150,400))
				found = true
				break
			elseif( entry == GW2.CONVERSATIONOPTIONS.KarmaShop ) then
				Player:SelectConversationOption( GW2.CONVERSATIONOPTIONS.KarmaShop )
				mc_global.Wait(math.random(150,400))
				found = true
				break
			elseif( entry == 23 ) then
				Player:SelectConversationOption( 23 )
				mc_global.Wait(math.random(150,400))
				found = true
				break
			elseif( entry == 13 ) then
				Player:SelectConversationOption( 23 )
				mc_global.Wait(math.random(150,400))
				found = true
				break
			end			
			nextOption, entry  = next( options, nextOption )
		end
		if ( not found ) then
			nextOption, entry  = next( options )
			while ( nextOption ~=nil ) do
				if( entry == GW2.CONVERSATIONOPTIONS.Continue ) then
					Player:SelectConversationOption( GW2.CONVERSATIONOPTIONS.Continue )
					mc_global.Wait(math.random(150,400))
					found = true
					break
				elseif( entry == GW2.CONVERSATIONOPTIONS.Story ) then
					Player:SelectConversationOption( GW2.CONVERSATIONOPTIONS.Story )
					mc_global.Wait(math.random(150,400))
					found = true
					break
				end
				nextOption, entry  = next( options, nextOption )
			end
		end
		
		if ( not found ) then
			return false
		end	
	return true
end

function mc_ai_vendor.InteractWithVendor( vendor )
	--Sell, Repair, Buy
	if ( mc_ai_vendor.NeedToSell() ) then
		if ( not Inventory:IsVendorOpened() and Player:IsConversationOpen() ) then
			if ( not mc_ai_vendor.OpenSellWindow() ) then
				ml_error( "Vendoring: can't Sell at vendor, please report back to the developers" )
				ml_error("Blacklisted Vendor"..vendor.name)
				mc_blacklist.AddBlacklistEntry(GetString("vendors"), vendor.id, vendor.name, true)	
			end
		else
			-- SELL HERE
			local sList = mc_sellmanager.createItemList()
			if ( TableSize(sList) > 0 ) then
				local i,item = next (sList)
				if ( i and item ) then
					mc_ai_vendor.isSelling = true
					d("Selling :"..tostring(item.name))
					item:Sell()
					return
				end				
			else
				d("Selling finished..")
				mc_ai_vendor.isSelling = false				
			end
		end
	
	-- REPAIR
	elseif ( mc_ai_vendor.NeedToRepair() ) then
		if ( Player:IsConversationOpen() ) then
			mc_ai_vendor.isRepairing = true
			local options = Player:GetConversationOptions()
			nextOption, entry  = next( options )
			local found = false
			while ( nextOption ~= nil ) do
				if( entry == GW2.CONVERSATIONOPTIONS.Repair ) then
					Player:SelectConversationOption( GW2.CONVERSATIONOPTIONS.Repair )
					mc_global.Wait(math.random(500,1000))
					mc_ai_vendor.isSelling  = true
					mc_ai_vendor.isRepairing = false
					found = true
					break
				elseif( entry == GW2.CONVERSATIONOPTIONS.Continue ) then
					Player:SelectConversationOption( GW2.CONVERSATIONOPTIONS.Continue )
					mc_global.Wait(math.random(150,400))
					found = true
					break
				elseif( entry == GW2.CONVERSATIONOPTIONS.Return ) then
					Player:SelectConversationOption( GW2.CONVERSATIONOPTIONS.Return )
					mc_global.Wait(math.random(150,400))
					found = true
					break
					end
				nextOption, entry  = next( options, nextOption )
			end
			if ( not found ) then
				mc_ai_vendor.isRepairing = false
				ml_error( "Vendoring: can't Repair at vendor, please report back to the developers" )
				ml_error("Blacklisted RepairVendor"..vendor.name)
				mc_blacklist.AddBlacklistEntry(GetString("vendors"), vendor.id, vendor.name, true)	
			end
		end		
	
	-- BUY TOOLS
	elseif ( mc_ai_vendor.NeedToBuyGatheringTools() ) then
		if ( not Inventory:IsVendorOpened() and Player:IsConversationOpen() ) then
			if ( not mc_ai_vendor.OpenSellWindow() ) then
				ml_error( "Vendoring: can't Buy Tools at vendor.." )
				ml_error("Blacklisted BuyTools-Vendor"..vendor.name)
				mc_blacklist.AddBlacklistEntry(GetString("vendorsbuy"), vendor.id, vendor.name, true)	
			end
		else
			-- BUY TOOLS HERE
			--set mc_ai_vendor.isBuying treu/false
			
		end
	end
end

c_vendor = inheritsFrom( ml_cause )
e_vendor = inheritsFrom( ml_effect )
function c_vendor:evaluate()
	return (SellManager_Active == "1" and ( 
		( (Inventory:IsVendorOpened() or Player:IsConversationOpen()) and ( mc_ai_vendor.isRepairing or mc_ai_vendor.isBuying or mc_ai_vendor.isSelling) )
		or
		( Inventory.freeSlotCount == 0 and mc_ai_vendor.NeedToSell() and TableSize(mc_ai_vendor.GetClosestVendorMarker()) > 0 )
		or 
		( mc_ai_vendor.NeedToBuyGatheringTools() and TableSize(mc_ai_vendor.GetClosestBuyVendorMarker()) > 0)
		or 
		( mc_ai_vendor.NeedToRepair() and TableSize(mc_ai_vendor.GetClosestRepairVendorMarker()) > 0)
		)		
	)
end
function e_vendor:execute()
	ml_log("e_vendor")
	
	-- We are already at a vendor
	if ( (Inventory:IsVendorOpened() or Player:IsConversationOpen()) and ( mc_ai_vendor.isRepairing or mc_ai_vendor.isBuying or mc_ai_vendor.isSelling) ) then
		local t = Player:GetTarget()
		if ( t ) then
			return mc_ai_vendor.InteractWithVendor( t )
		else
			ml_error("We are at a vendor but dont have him targeted!?!")
			mc_ai_vendor.isBuying = false
			mc_ai_vendor.isSelling = false
		end
	else
	
		local vMarker = nil
		if ( Inventory.freeSlotCount == 0 and mc_ai_vendor.NeedToSell() ) then vMarker = mc_ai_vendor.GetClosestVendorMarker() end
		if ( vMarker == nil and mc_ai_vendor.NeedToBuyGatheringTools() ) then vMarker = mc_ai_vendor.GetClosestBuyVendorMarker() end
		if ( vMarker == nil and mc_ai_vendor.NeedToRepair() ) then vMarker = mc_ai_vendor.GetClosestRepairVendorMarker() end
		
		if ( vMarker ~= nil ) then	
			if ( vMarker.characterID ~= nil and vMarker.characterID ~= 0 and vMarker.characterID ~= "") then			
				local char = CharacterList:Get(vMarker.characterID)
				if ( char ) then				
					-- We are close enough and the char is in CharList
					if (not char.isInInteractRange) then
						-- MoveIntoInteractRange
						local tPos = char.pos
						if ( tPos ) then
							local navResult = tostring(Player:MoveTo(tPos.x,tPos.y,tPos.z,50,false,true,true))		
							if (tonumber(navResult) < 0) then
								ml_error("mc_ai_vendoring.MoveIntoInteractRange result: "..tonumber(navResult))					
							end
							ml_log("MoveToVendor..")
							return true
						end
					else
						-- Interact
						Player:StopMovement()
						local t = Player:GetTarget()
						if ( char.selectable and (not t or t.id ~= char.id )) then
							Player:SetTarget( char.id )
						else
							
							if ( not Inventory:IsVendorOpened() and not Player:IsConversationOpen() ) then
								ml_log( " Opening Vendor.. " )
								Player:Interact( char.id )
								mc_global.Wait(1000)
								return true
							else
								return mc_ai_vendor.InteractWithVendor( char )
							end					 
						end			
					end
					
				else
					-- We are not close enought, char is not yet in Charlist
					local pos = vMarker.pos
					if ( pos ) then
						local navResult = tostring(Player:MoveTo(pos.x,pos.y,pos.z,50,false,true,true))		
						if (tonumber(navResult) < 0) then
							ml_error("mc_ai_vendoring.MoveIntovMarkerRange result: "..tonumber(navResult))					
						end
						ml_log("MoveToVendorMarker..")
						return true
					else
						ml_error("vMarker Position table of VendorMarker is empty!")
					end
				
					return char
				end
			end
		else
			ml_error("No VendorMarker found! TODO: Get Vendor from MapData List")
			
		end
	end
	return ml_log(false)		
end
