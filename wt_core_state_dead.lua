-- Dead State for all professions
-- Fights downed and respawns at nearby waypoint

wt_core_state_dead = inheritsFrom(wt_core_state)
wt_core_state_dead.name = "Dead"
wt_core_state_dead.kelement_list = { }
wt_core_state_dead.CurrentTarget = 0


------------------------------------------------------------------------------
-- Alive again Check
local cd_check_alive = inheritsFrom(wt_cause)
local ed_alive = inheritsFrom(wt_effect)

function cd_check_alive:evaluate()
	if ( Player.alive == true ) then
		if ( downed_lastslot ~= nil ) then
			downed_lastslot = nil
		end
		return true
	end
	return false
end

function ed_alive:execute()
	wt_core_controller.requestStateChange(wt_core_state_idle)
end

------------------------------------------------------------------------------
-- Downed Combat Check
local c_downed_combat = inheritsFrom( wt_cause )
local e_downed_combat = inheritsFrom( wt_effect )
local downed_str_format = "Downed: %s - Slot_%u (%s) - Casting: %s"
local downed_lastslot = nil -- debug index, no reason to print debug message over and over unless you are debugging it
local debug_downed = false -- true == active running debugging on this specific code

function c_downed_combat:evaluate()
	if ( Player.healthstate == GW2.HEALTHSTATE.Downed ) then
		return true
	end
	return false
end

function e_downed_combat:execute()
--	wt_debug("e_downed_combat ")
	local s1, s2, s3, s4 = nil, nil, nil, nil
	if ( Player.inCombat ) then
		TargetList = ( CharacterList( "lowesthealth,nearest,attackable,incombat,alive,maxdistance=1200" ) )
		if ( TableSize( TargetList ) > 0 ) then
			targetID, E  = next( TargetList )
			if ( targetID ~= nil ) then
				if ( Player:GetTarget() ~= targetID ) then
					Player:SetTarget( targetID )
				else
					if ( not Player:IsSpellOnCooldown( GW2.SKILLBARSLOT.Slot_4 ) ) then
						if ( s4 == nil or tostring( s4.name ) == "" ) then
							s4 = Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_4 )
						end
						-- Ranger: Bandage
						if ( not debug_downed and downed_lastslot ~= 4) then
							downed_lastslot = 4
							wt_debug( string.format( downed_str_format, tostring( s4.name ) or "nil", "4", GW2.SKILLBARSLOT.Slot_4, tostring( Player:IsCasting( GW2.SKILLBARSLOT.Slot_4 ) ) ) )
						elseif ( debug_downed and downed_lastslot == 4) then
							wt_debug( string.format( downed_str_format, tostring( s4.name ) or "nil", "4", GW2.SKILLBARSLOT.Slot_4, tostring( Player:IsCasting( GW2.SKILLBARSLOT.Slot_4 ) ) ) )
						end
						Player:CastSpell( GW2.SKILLBARSLOT.Slot_4, targetID )

					elseif ( not Player:IsSpellOnCooldown( GW2.SKILLBARSLOT.Slot_3 ) and not Player:IsCasting( GW2.SKILLBARSLOT.Slot_3 ) and ( Player.profession ~= 4 ) ) then
						-- Ranger skill slot_3 is disabled until pet attack (F1) have been fixed
						if ( s3 == nil or tostring( s3.name ) == "" ) then
							s3 = Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_3 )
						end
						-- Ranger: Lick Wounds
						if ( not debug_downed and downed_lastslot ~= 3) then
							downed_lastslot = 3
							wt_debug( string.format( downed_str_format, tostring( s3.name ) or "nil", "3", GW2.SKILLBARSLOT.Slot_3, tostring( Player:IsCasting( GW2.SKILLBARSLOT.Slot_3 ) ) ) )
						elseif ( debug_downed and downed_lastslot == 3) then
							wt_debug( string.format( downed_str_format, tostring( s3.name ) or "nil", "3", GW2.SKILLBARSLOT.Slot_3, tostring( Player:IsCasting( GW2.SKILLBARSLOT.Slot_3 ) ) ) )
						end
						Player:CastSpell( GW2.SKILLBARSLOT.Slot_3, targetID )

					elseif ( not Player:IsSpellOnCooldown( GW2.SKILLBARSLOT.Slot_2 ) and not Player:IsCasting( GW2.SKILLBARSLOT.Slot_2 ) ) then
						if ( s2 == nil or tostring( s2.name ) == "" ) then
							s2 = Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_2 )
						end
						-- Ranger: Thunderclap
						if ( not debug_downed and downed_lastslot ~= 2) then
							downed_lastslot = 2
							wt_debug( string.format( downed_str_format, tostring( s2.name ) or "nil", "2", GW2.SKILLBARSLOT.Slot_2, tostring( Player:IsCasting( GW2.SKILLBARSLOT.Slot_2 ) ) ) )
						elseif ( debug_downed and downed_lastslot == 2) then
							wt_debug( string.format( downed_str_format, tostring( s2.name ) or "nil", "2", GW2.SKILLBARSLOT.Slot_2, tostring( Player:IsCasting( GW2.SKILLBARSLOT.Slot_2 ) ) ) )
						end
						Player:CastSpell( GW2.SKILLBARSLOT.Slot_2, targetID )

					elseif ( not Player:IsSpellOnCooldown( GW2.SKILLBARSLOT.Slot_1 ) and not Player:IsCasting( GW2.SKILLBARSLOT.Slot_1 ) ) then
						if ( s1 == nil or tostring( s1.name ) == "" ) then
							s1 = Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_1 )
						end
						-- Ranger: Throw Dirt
						if ( not debug_downed and downed_lastslot ~= 1) then
							downed_lastslot = 1
							wt_debug( string.format( downed_str_format, tostring( s1.name ) or "nil", "1", GW2.SKILLBARSLOT.Slot_1, tostring( Player:IsCasting( GW2.SKILLBARSLOT.Slot_1 ) ) ) )
						elseif ( debug_downed and downed_lastslot == 1) then
							wt_debug( string.format( downed_str_format, tostring( s1.name ) or "nil", "1", GW2.SKILLBARSLOT.Slot_1, tostring( Player:IsCasting( GW2.SKILLBARSLOT.Slot_1 ) ) ) )
						end
						Player:CastSpell( GW2.SKILLBARSLOT.Slot_1, targetID )
					end
				end
			end
		end
	else
		if ( not Player:IsSpellOnCooldown( GW2.SKILLBARSLOT.Slot_4 ) ) then
			if ( s4 == nil or tostring( s4.name ) == "" ) then
				s4 = Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_4 )
			end
			-- Ranger: Bandage
			if ( not debug_downed and downed_lastslot ~= 4) then
				downed_lastslot = 4
				wt_debug( string.format( downed_str_format, tostring( s4.name ) or "nil", "4", GW2.SKILLBARSLOT.Slot_4, tostring( Player:IsCasting( GW2.SKILLBARSLOT.Slot_4 ) ) ) )
			elseif ( debug_downed and downed_lastslot == 4) then
				wt_debug( string.format( downed_str_format, tostring( s4.name ) or "nil", "4", GW2.SKILLBARSLOT.Slot_4, tostring( Player:IsCasting( GW2.SKILLBARSLOT.Slot_4 ) ) ) )
			end
			Player:CastSpell( GW2.SKILLBARSLOT.Slot_4, targetID )
		end
	end
end

------------------------------------------------------------------------------
-- Dead Check
local cd_dead_check = inheritsFrom( wt_cause )
local ed_dead = inheritsFrom( wt_effect )

function cd_dead_check:evaluate()
	if ( Player.healthstate == GW2.HEALTHSTATE.Defeated ) then
		return true
	end
	return false
end

ed_dead.delay = math.random( 5000, 10000 )
ed_dead.throttle = math.random( 8000, 16000 )
function ed_dead:execute()
	--TODO: Add check for contested!
	wt_debug( "Downed: RESPAWN AT NEAREST WAYPOINT " )
	wt_debug( Player:RespawnAtClosestResShrine() )
end

------------------------------------------------------------------------------
function wt_core_state_dead:initialize()

		local ke_alive = wt_kelement:create( "Alive", cd_check_alive, ed_alive, 1000 )
		wt_core_state_dead:add( ke_alive )

		local ke_dead = wt_kelement:create( "Respawn", cd_dead_check, ed_dead, 200 )
		wt_core_state_dead:add( ke_dead )

		local ke_downed_combat = wt_kelement:create( "DownedCombat", c_downed_combat, e_downed_combat, 150 )
		wt_core_state_dead:add( ke_downed_combat )

end

wt_core_state_dead:initialize()
wt_core_state_dead:register()
