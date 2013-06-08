-- Kill gadget combat state

wt_core_state_gcombat = inheritsFrom( wt_core_state )
wt_core_state_gcombat.name = "GCombat"
wt_core_state_gcombat.kelement_list = { }
wt_core_state_gcombat.CurrentTarget = 0
wt_core_state_gcombat.RestHealthLimit = math.random(60,75)
wt_core_state_gcombat.MovementTmr = 0

-- Thanks Havoc
function OkToMove()
    return Player.movementstate ~= GW2.MOVEMENTSTATE.GroundNotMoving
        or Player:GetCurrentlyCastedSpell() == GW2.SKILLBARSLOT.Slot_1
        or not Player:IsCasting()
end

--/////////////////////////////////////////////////////
-- Combat over Check
local c_combat_over = inheritsFrom( wt_cause )
local e_combat_over = inheritsFrom( wt_effect )
function c_combat_over:evaluate()
	--local CurrentTarget = Player:GetTarget()
	if ( wt_core_state_gcombat.CurrentTarget == nil or wt_core_state_gcombat.CurrentTarget == 0 ) then
		return true
	else
		local T = GadgetList:Get( wt_core_state_gcombat.CurrentTarget )
		if ( T == nil or not T.onmesh or T.attitude == 0 or T.attitude == 3 ) then
			Player:ClearTarget()
			return true
		end
	end
	return false
end
function e_combat_over:execute()
	wt_debug( "Combat finished" )
	wt_core_state_gcombat.CurrentTarget = 0
	Player:ClearTarget()
	wt_core_controller.requestStateChange( wt_core_state_idle )
	return
end

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-- NeedHeal Check
local c_heal_action = inheritsFrom(wt_cause)
local e_heal_action = inheritsFrom(wt_effect)
function c_heal_action:evaluate()
	return (Player.health.percent < wt_core_state_gcombat.RestHealthLimit and not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_6))
		-- CRASHES LIKE SHIT, DONT KNOW WHY
		--[[if (gMinionEnabled == "1" and MultiBotIsConnected( ) ) then
		end]]
end
e_heal_action.usesAbility = true
function e_heal_action:execute()
	--wt_debug("e_heal_action")
	Player:CastSpell(GW2.SKILLBARSLOT.Slot_6)
end

------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Move Closer to Target Check
local c_MoveCloser = inheritsFrom(wt_cause)
local e_MoveCloser = inheritsFrom(wt_effect)
function c_MoveCloser:evaluate()
	if ( wt_core_state_gcombat.CurrentTarget ~= nil and wt_core_state_gcombat.CurrentTarget ~= 0 ) then
		local T = GadgetList:Get(wt_core_state_gcombat.CurrentTarget)
		if ( T ~= nil ) then
			local Distance = T.distance or 0
			local LOS = T.los or false
			if (Distance >= wt_global_information.AttackRange) then				
				return true
			else
				if( Player:GetTarget() ~= wt_core_state_gcombat.CurrentTarget) then
					Player:SetTarget(wt_core_state_gcombat.CurrentTarget)
				end
			end
		end
	end
	return false;
end
function e_MoveCloser:execute()
	wt_debug("move")
	if ( wt_core_state_gcombat.CurrentTarget ~= nil and wt_core_state_gcombat.CurrentTarget ~= 0 ) then
		local T = GadgetList:Get(wt_core_state_gcombat.CurrentTarget)
		if ( T ~= nil ) then
			local Tpos = T.pos
			Player:MoveTo(Tpos.x,Tpos.y,Tpos.z,120) -- the last number is the distance to the target where to stop
		end
	end
end

------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Hit Shit
local c_DefaultAttack = inheritsFrom(wt_cause)
local e_DefaultAttack = inheritsFrom(wt_effect)
function c_DefaultAttack:evaluate()
	return wt_core_state_gcombat.CurrentTarget ~= 0
end
function e_DefaultAttack:execute()
	wt_debug("attack")
	TID = wt_core_state_gcombat.CurrentTarget
	if ( TID ~= nil and TID ~= 0 ) then
		local T = GadgetList:Get(TID)
		if ( T ~= nil ) then		
			--wt_debug("attacking " .. wt_core_state_combat.CurrentTarget .. " Distance " .. T.distance)
			local TPos = T.pos
			Player:SetFacing(TPos.x, TPos.y, TPos.z)
			local s1 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_1)
			if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_1) and s1~=nil and T.distance < s1.maxRange) then
				Player:CastSpell(GW2.SKILLBARSLOT.Slot_1,TID)
			end
		end
	end
end


--/////////////////////////////////////////////////////
-- Sets our target for this combatstate
function wt_core_state_gcombat.setTarget( CurrentTarget )
	if ( CurrentTarget ~= nil and CurrentTarget ~= 0 ) then
		wt_core_state_gcombat.CurrentTarget = CurrentTarget
		Player:StopMoving()
	else
		wt_core_state_gcombat.CurrentTarget = 0
	end
end

function


--/////////////////////////////////////////////////////
function wt_core_state_gcombat:initialize()

		local ke_died = wt_kelement:create( "Died", c_died, e_died, wt_effect.priorities.interrupt )
		wt_core_state_gcombat:add( ke_died )

		local ke_combat_over = wt_kelement:create( "combat_over", c_combat_over, e_combat_over, 150 )
		wt_core_state_gcombat:add( ke_combat_over )

		local ke_quickloot = wt_kelement:create( "QuickLoot", c_quickloot, e_quickloot, 145 )
		wt_core_state_gcombat:add( ke_quickloot )
		
		local ke_quicklootchest = wt_kelement:create( "QuickLootChest", c_quicklootchest, e_quicklootchest, 144 )
		wt_core_state_gcombat:add( ke_quicklootchest )	
		
		local ke_revivparty = wt_kelement:create( "ReviveParty", c_revivep, e_revivep, 130 )
		wt_core_state_gcombat:add( ke_revivparty )	
		
		--groupbotting, focustargetbroadcast @ prio 126
		
		local ke_heal_action = wt_kelement:create("heal_action",c_heal_action,e_heal_action, 100 )
		wt_core_state_gcombat:add(ke_heal_action)
		
		local ke_MoveClose_action = wt_kelement:create("Move closer",c_MoveCloser,e_MoveCloser, 75 )
		wt_core_state_gcombat:add(ke_MoveClose_action)
		
		local ke_Attack_default = wt_kelement:create("Attack",c_DefaultAttack,e_DefaultAttack, 45 )
		wt_core_state_gcombat:add(ke_Attack_default)
end

-- setup kelements for the state
wt_core_state_gcombat:initialize()
-- register the State with the system
wt_core_state_gcombat:register()
