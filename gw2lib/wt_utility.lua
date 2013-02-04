-- All gw2 utility stuff

function IsEquippmentDamaged( )
	local chest = Inventory:GetEquippedItemBySlot( GW2.EQUIPMENTSLOT.Chest )
	local boots = Inventory:GetEquippedItemBySlot( GW2.EQUIPMENTSLOT.Boots )
	local gloves = Inventory:GetEquippedItemBySlot( GW2.EQUIPMENTSLOT.Gloves )
	local headgear = Inventory:GetEquippedItemBySlot( GW2.EQUIPMENTSLOT.Headgear )
	local leggings = Inventory:GetEquippedItemBySlot( GW2.EQUIPMENTSLOT.Leggings )
	local shoulders = Inventory:GetEquippedItemBySlot( GW2.EQUIPMENTSLOT.Shoulders )
	
	if ( ( chest ~= nil and chest.durability ~= 0 ) or
		( boots ~= nil and boots.durability ~= 0 ) or
		( gloves ~= nil and gloves.durability ~= 0 ) or
		( headgear ~= nil and headgear.durability ~= 0 ) or
		( leggings ~= nil and leggings.durability ~= 0 ) or
		( shoulders ~= nil and shoulders.durability ~= 0 ) ) then
		return true
	end
	return false
end

-- takes in a % number and gives back a random number near that value, for randomizing skill usage at x% hp
function randomize(val)
	if ( val <= 100 and val > 0) then
		local high,low
		if ( (val + 15) > 100) then
			high = 100			
		else
			high = val + 15
		end
		if ( (val - 15) <= 0) then
			low = 1			
		else
			low = val - 15
		end
		return math.random(low,high)
	end
	return 0
end

