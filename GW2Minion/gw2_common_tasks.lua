-- This file contains functions which are called on each pulse when the bot is active n running

gw2_common_tasks = {}

function gw2_common_tasks.OnUpdate( tickcount )
	
	gw2_common_tasks.DepositItems(tickcount)
	gw2_common_tasks.AoELoot(tickcount)
	

end

gw2_common_tasks.depositLastUsed = 0
function gw2_common_tasks.DepositItems(tickcount)
	if ( TimeSince(gw2_common_tasks.depositLastUsed) > 5000 and gDepositItems == "1" and ml_global_information.Player_Inventory_SlotsFree <= 20 ) then
		gw2_common_tasks.depositLastUsed = tickcount + math.random(500,5000)
		Inventory:DepositCollectables()
	end
end

gw2_common_tasks.aoeLootLastUsed = 0
function gw2_common_tasks.AoELoot(tickcount)
	if( TimeSince(gw2_common_tasks.aoeLootLastUsed) > 1050 and ml_global_information.Player_Inventory_SlotsFree > 0) then
		gw2_common_tasks.aoeLootLastUsed = tickcount + math.random(50,500)
		Player:AoELoot()
	end
end
