-- This file contains functions which are called on each pulse when the bot is active n running

gw2_common_tasks = {}

function gw2_common_tasks.OnUpdate( tickcount )
	
	gw2_common_tasks.DepositItems(tickcount)
	gw2_common_tasks.AoELoot(tickcount)
	gw2_common_tasks.SalvageItems(tickcount)
	gw2_common_tasks.SwimUp(tickcount)
	gw2_common_tasks.HealnBuff(tickcount) -- we have to see if this is a working solution for every botmode 
	gw2_common_tasks.ClaimRewards(tickcount)
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

gw2_common_tasks.salvageItemsLastUsed = 0
function gw2_common_tasks.SalvageItems(tickcount)
	if( TimeSince(gw2_common_tasks.salvageItemsLastUsed) > 1050 and c_salvage:evaluate() ) then
		gw2_common_tasks.salvageItemsLastUsed = tickcount + math.random(500,1500)
		e_salvage:execute()
	end
end


gw2_common_tasks.swimUpLastUsed = 0
gw2_common_tasks.swimUp = false
function gw2_common_tasks.SwimUp(tickcount)
	if( TimeSince(gw2_common_tasks.swimUpLastUsed) > 1000 ) then
		gw2_common_tasks.swimUpLastUsed = tickcount + math.random(50,500)
		if ( ml_global_information.Player_SwimState == GW2.SWIMSTATE.Diving ) then
			gw2_common_tasks.swimUp = true
			Player:SetMovement(GW2.MOVEMENTTYPE.SwimUp)
		elseif( gw2_common_tasks.swimUp == true ) then
			gw2_common_tasks.swimUp = false
			Player:UnSetMovement(GW2.MOVEMENTTYPE.SwimUp)
		end		
	end
end

gw2_common_tasks.healnBuffLastUsed = 0
function gw2_common_tasks.HealnBuff(tickcount)
	if( TimeSince(gw2_common_tasks.healnBuffLastUsed) > 1500 and ml_global_information.Player_IsMoving and Player.castinfo.duration == 0) then
		gw2_common_tasks.healnBuffLastUsed = tickcount + math.random(500,2000)
		gw2_skill_manager.Heal()
	end
end

gw2_common_tasks.claimRewardsLastUsed = 0
function gw2_common_tasks.ClaimRewards(tickcount)
	if( TimeSince(gw2_common_tasks.claimRewardsLastUsed) > 15000 and ml_global_information.Player_Alive and ml_global_information.Player_Inventory_SlotsFree > 2) then
		gw2_common_tasks.claimRewardsLastUsed = tickcount + math.random(5000,15000)
		if ( Player:CanClaimReward() ) then
			Player:ClaimRewards()
		end
	end
end
