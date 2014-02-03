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
	mc_log( "e_deposit" )
	c_deposit.LastCount = Inventory.freeSlotCount
	Inventory:DepositCollectables()	
end

------------
c_AoELoot = inheritsFrom( ml_cause )
e_AoELoot = inheritsFrom( ml_effect )
function c_AoELoot:evaluate()
    --mc_log("c_AoELoot")
    return Inventory.freeSlotCount > 0 and TableSize(CharacterList("nearest,lootable,maxdistance=900")) > 0
end
function e_AoELoot:execute()
	mc_log("e_AoELoot")
	return Player:AoELoot()
end

------------
c_Loot = inheritsFrom( ml_cause )
e_Loot = inheritsFrom( ml_effect )
function c_Loot:evaluate()
   -- mc_log("c_Loot")
    return Inventory.freeSlotCount > 0 and TableSize(CharacterList("nearest,lootable,onmesh")) > 0
end
function e_Loot:execute()
	mc_log("e_Loot")
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
						mc_error("e_Loot.MoveIntoCombatRange result: "..tonumber(navResult))					
					end
					mc_log("MoveToLootable..")
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
						mc_log("Looting..")
						mc_global.Wait(1000)
						return true
					end	
				end
			end
		end
	end
	return mc_log(false)	
end

c_LootChests = inheritsFrom( wt_cause )
e_LootChests = inheritsFrom( wt_effect )
function c_LootChests:evaluate()
	--mc_log("c_LootChests")
	if ( Inventory.freeSlotCount > 0 ) then
		local GList = GadgetList("onmesh,lootable,maxdistance=4000")
		if ( TableSize( GList ) > 0 ) then			
			local index, LT = next( GList )
			while ( index ~= nil and LT~=nil ) do
				if ( LT.selectable and (LT.contentID == 17698 or LT.contentID == 198260 or LT.contentID == 232192 or LT.contentID == 232193 or LT.contentID == 232194 or LT.contentID == 262863 or LT.contentID == 236384)) then --or LT.contentID == 41638
					d("CHEST: "..tostring(LT.name).." "..tostring(LT.distance).." "..tostring(LT.contentID).." "..tostring(LT.lootable).." "..tostring(index))
					return mc_log(true)
				end
				index, LT = next( GList,index )
			end
		end	
	end
	return mc_log(false)
end
e_LootChests.throttle = 500
function e_LootChests:execute()
	mc_log("e_lootchest")
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
							mc_error("e_lootchest.MoveIntoRange result: "..tonumber(navResult))					
						end
						mc_log("MoveToLootChest..")
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
							mc_log("Looting..")
							mc_global.Wait(1000)
							return true
						end	
					end
				end				
			end
			index, LT = next( GList,index )
		end
	end
	return mc_log(false)
end


------------fck that, I'm lazy
c_Gathering = inheritsFrom( ml_cause )
e_Gathering = inheritsFrom( ml_effect )
function c_Gathering:evaluate()
	return mc_log(Inventory.freeSlotCount > 0 and TableSize(GadgetList("onmesh,gatherable,maxdistance=4000")) > 0)
end
function e_Gathering:execute()
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
						mc_error("mc_ai_gathering.MoveIntoCombatRange result: "..tonumber(navResult))					
					end
					mc_log("MoveToGatherable..")
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
						mc_log("Gathering..")
						mc_global.Wait(1000)
						return true
					end	
				end			
			end
		end
	end
	return mc_log(false)
end

