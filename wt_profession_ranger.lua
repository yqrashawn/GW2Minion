-- This file contains ranger specific combat routines

-- load routine only if player is a ranger
if ( 4 ~= Player.profession ) then
	return
end
-- The following values have to get set ALWAYS for ALL professions!!
wt_profession_ranger  =  inheritsFrom( nil )
wt_profession_ranger.professionID = 4 -- needs to be set
wt_profession_ranger.professionRoutineName = "Ranger"
wt_profession_ranger.professionRoutineVersion = "1.2"
wt_profession_ranger.RestHealthLimit = 70
Pet_Heal_Threshold = 50
Ranger_Heal_Threshold = 50
SkillBar = { s1 = {}, s2 = {}, s3 = {}, s4 = {}, s5 = {} }

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
local debug_slot, debug_tid = nil, nil
local debug_attack, debug_move, debug_heal = true, true, true

local debug_attack_msg_format	= ": Use %s (Slot_%u) on %s(%u) - Dist:%.1f - MaxRng:%u"
-- local skill_str_format			= "%s TID:%u - Dist:%.1f - Rng:%u - bar_slot_%u (%s)"
local debug_move_msg_format		= ": Move to %s (%u) - Dist %.f"
local debug_heal_msg_format		= ": Use %s (Slot_%u) - %u"

function GetClass()
	for k, v in pairs( GW2.CHARCLASS ) do
		if ( v == Player.profession ) then
			return tostring( k )
		end
	end
end

function debug_msg( tid, t, slot, name, maxRange )
	local n = tostring( name )
	if ( n == "" ) then
		n = "?"
	end
	if ( slot ~= nil ) then
		if ( debug_attack  and tid ~= nil ) then
			if ( debug_slot ~= slot ) then
				wt_debug( GetClass() .. string.format( debug_attack_msg_format, n or "", slot, t.name or "?", tid, t.distance, maxRange or 0 ) )
				debug_slot = slot
			end
		elseif ( debug_heal and tid == nil ) then
			if ( debug_slot ~= slot ) then
				if ( t ~= nil ) then
					wt_debug( GetClass() .. string.format(  debug_heal_msg_format, n or "", slot, Player:GetPet().health.percent ).."% pet health" )
				else
					wt_debug( GetClass() .. string.format(  debug_heal_msg_format, n or "", slot, Player.health.percent ).."% health" )
				end
				debug_slot = slot
			end
		end
		if ( debug_tid ~= tid ) then
			debug_tid = tid
		end
	else
		if ( debug_move ) then
			if ( debug_tid ~= tid ) then
				wt_debug( GetClass() .. string.format( debug_move_msg_format, t.name or "?", tid, t.distance ) )
				debug_tid = tid
			end
		end
		debug_slot = nil
	end
end

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--[[
--Human weapon information
-- name			=	{	skill_slot_x = maxRange_y									}
mainhand		=	{
	Sword		=	{	s1 = 130,	s2 = 130,	s3 = 130							}
	Longbow		=	{	s1 = 1200,	s2 = 1200,	s3 = 1200,	s4 = 750,	s5 = 1200	}
	Shortbow	=	{	s1 = 1200,	s2 = 1200,	s3 = 1200,	s4 = 1200,	s5 = 1200	}
	Axe			=	{	s1 = 900,	s2 = 900,	s3 = 900							}
	Greatsword	=	{	s1 = 150,	s2 = 150,	s3 = 1100,	s4 = 300,	s5 = 300	}
	Spear		=	{	s1 = 150,	s2 = 150,	s3 = 900,	s4 = 240,	s5 = 150	}
	HarpoonGun	=	{	s1 = 1200,	s2 = 1200,	s3 = 1200,	s4 = 1200,	s5 = 1200	}
}
offhand			=	{
	Axe			=	{	s4 = 900,	s5 = 150	}
	Dagger		=	{	s4 = 250,	s5 = 900	}
	Torch		=	{	s4 = 900,	s5 = 120	}
	Warhorn		=	{	s4 = 900,	s5 = 600	}
}
]]--

------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- PetNeedHeal Check
c_heal_pet_action = inheritsFrom( wt_cause )
e_heal_pet_action = inheritsFrom( wt_effect )

function c_heal_pet_action:evaluate()
	local pet = Player:GetPet()
	if ( pet ~= nil ) then
		if ( not pet.alive ) then
			return true
		else
			return ( pet.health.percent < Pet_Heal_Threshold )
		end
	else
		return false
	end
end

e_heal_pet_action.usesAbility = true

function e_heal_pet_action:execute()
	local s6 = Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_6 )
	if ( not Player:IsSpellOnCooldown( GW2.SKILLBARSLOT.Slot_6 ) ) then
--		wt_debug( "e_heal_pet_action" )
		if ( Player:IsCasting( GW2.SKILLBARSLOT.Slot_6 ) and  Player:GetCurrentlyCastedSpell() == GW2.SKILLBARSLOT.Slot_6 ) then
			debug_msg( nil, true, 6, s6.name )
		end
		Player:CastSpell( GW2.SKILLBARSLOT.Slot_6 )
	elseif ( Player:IsSpellOnCooldown( GW2.SKILLBARSLOT.Slot_6 ) and Player:CanSwitchPet() and not Player:IsCasting( GW2.SKILLBARSLOT.Slot_6 ) ) then
			-- Temp Pet Health soultion until pet health can be checked
			Player:SwitchPet()
			wt_debug( "Ranger: Switching Pet" )
	end
end
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- NeedHeal Check
wt_profession_ranger.c_heal_action = inheritsFrom( wt_cause )
wt_profession_ranger.e_heal_action = inheritsFrom( wt_effect )

function wt_profession_ranger.c_heal_action:evaluate()
	return ( Player.health.percent < Ranger_Heal_Threshold and not Player:IsSpellOnCooldown( GW2.SKILLBARSLOT.Slot_6 ) )
end
wt_profession_ranger.e_heal_action.usesAbility = true

function wt_profession_ranger.e_heal_action:execute()
	local s6 = Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_6 )
	if ( not Player:IsSpellOnCooldown( GW2.SKILLBARSLOT.Slot_6 ) ) then
--		wt_debug( "e_heal_action" )
		if ( Player:IsCasting( GW2.SKILLBARSLOT.Slot_6 ) and Player:GetCurrentlyCastedSpell() == GW2.SKILLBARSLOT.Slot_6 ) then
			debug_msg( nil, nil, 6, s6.name )
		end
		Player:CastSpell( GW2.SKILLBARSLOT.Slot_6 )
	end
end

------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Move Closer to Target Check
wt_profession_ranger.c_MoveCloser = inheritsFrom( wt_cause )
wt_profession_ranger.e_MoveCloser = inheritsFrom( wt_effect )

function wt_profession_ranger.c_MoveCloser:evaluate()
	if ( wt_core_state_combat.CurrentTarget ~= 0 ) then
		local T = CharacterList:Get( wt_core_state_combat.CurrentTarget )
		local Distance = T ~= nil and T.distance or 0
		local LOS = T~= nil and T.los or false
		if ( Distance >= wt_global_information.AttackRange or LOS ~= true ) then
			return true
		else
			if ( Player:GetTarget() ~= wt_core_state_combat.CurrentTarget ) then
				Player:SetTarget( wt_core_state_combat.CurrentTarget )
			end
		end
	end
	return false
end

function wt_profession_ranger.e_MoveCloser:execute()
	local TID = wt_core_state_combat.CurrentTarget
	local T = CharacterList:Get( TID )
	if ( T ~= nil ) then
		debug_msg( TID, T, nil)
		Player:MoveTo( T.pos.x, T.pos.y, T.pos.z, 120 ) -- the last number is the distance to the target where to stop
	end
end

------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Update Weapon Data
wt_profession_ranger.c_update_weapons = inheritsFrom( wt_cause )
wt_profession_ranger.e_update_weapons = inheritsFrom( wt_effect )

function wt_profession_ranger.c_update_weapons:evaluate()
	wt_profession_ranger.MHweapon = Inventory:GetEquippedItemBySlot( GW2.EQUIPMENTSLOT.MainHandWeapon )
	wt_profession_ranger.OHweapon = Inventory:GetEquippedItemBySlot( GW2.EQUIPMENTSLOT.OffHandWeapon )
	return false
end

function wt_profession_ranger.e_update_weapons:execute()
end

function IsCastingUpdate()
	if ( Player:IsCasting( GW2.SKILLBARSLOT.Slot_1 ) ) then
		return true
	elseif ( Player:IsCasting( GW2.SKILLBARSLOT.Slot_2 ) ) then
		return true
	elseif ( Player:IsCasting( GW2.SKILLBARSLOT.Slot_3 ) ) then
		return true
	elseif ( Player:IsCasting( GW2.SKILLBARSLOT.Slot_4 ) ) then
		return true
	elseif ( Player:IsCasting( GW2.SKILLBARSLOT.Slot_5 ) ) then
		return true
	elseif ( Player:IsCasting( GW2.SKILLBARSLOT.Slot_6 ) ) then
		return true
	elseif ( Player:IsCasting( GW2.SKILLBARSLOT.Slot_7 ) ) then
		return true
	elseif ( Player:IsCasting( GW2.SKILLBARSLOT.Slot_8 ) ) then
		return true
	elseif ( Player:IsCasting( GW2.SKILLBARSLOT.Slot_9 ) ) then
		return true
	elseif ( Player:IsCasting( GW2.SKILLBARSLOT.Slot_10 ) ) then
		return true
	end
	return false
end
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Combat Default Attack
wt_profession_ranger.c_attack_default = inheritsFrom( wt_cause )
wt_profession_ranger.e_attack_default = inheritsFrom( wt_effect )

function wt_profession_ranger.c_attack_default:evaluate()
	  return wt_core_state_combat.CurrentTarget ~= 0
end

wt_profession_ranger.e_attack_default.usesAbility = true
function wt_profession_ranger.e_attack_default:execute()
	Player:StopMoving()
	TID = wt_core_state_combat.CurrentTarget
	if ( TID ~= 0 ) then
		local T = CharacterList:Get( TID )
		if ( T ~= nil ) then
			if ( T.los == false and debug_attack ) then
				wt_debug("LOS " .. tostring( T.los ) )
			end
			Player:SetFacing( T.pos.x-Player.pos.x, T.pos.z-Player.pos.z, T.pos.y-Player.pos.y )
			if ( wt_profession_ranger.MHweapon ~= nil and wt_profession_ranger.OHweapon == nil ) then
				if ( wt_profession_ranger.MHweapon.weapontype == GW2.WEAPONTYPE.Sword ) then
					if ( SkillBar.s1.maxRange ~= nil ) then
						wt_global_information.AttackRange = SkillBar.s1.maxRange or 130
					elseif ( SkillBar.s1.radius ~= nil ) then
						wt_global_information.AttackRange = SkillBar.s1.radius or 130
					end
				elseif ( wt_profession_ranger.MHweapon.weapontype == GW2.WEAPONTYPE.Longbow ) then
					if ( SkillBar.s1.maxRange ~= nil ) then
						wt_global_information.AttackRange = SkillBar.s1.maxRange or 1200
					elseif ( SkillBar.s1.radius ~= nil ) then
						wt_global_information.AttackRange = SkillBar.s1.radius or 1200
					end
				elseif ( wt_profession_ranger.MHweapon.weapontype == GW2.WEAPONTYPE.Shortbow ) then
					if ( SkillBar.s1.maxRange ~= nil ) then
						wt_global_information.AttackRange = SkillBar.s1.maxRange or 1200
					elseif ( SkillBar.s1.radius ~= nil ) then
						wt_global_information.AttackRange = SkillBar.s1.radius or 1200
					end
				elseif ( wt_profession_ranger.MHweapon.weapontype == GW2.WEAPONTYPE.Axe ) then
					if ( SkillBar.s1.maxRange ~= nil ) then
						wt_global_information.AttackRange = SkillBar.s1.maxRange or 900
					elseif ( SkillBar.s1.radius ~= nil ) then
						wt_global_information.AttackRange = SkillBar.s1.radius or 900
					end
				elseif ( wt_profession_ranger.MHweapon.weapontype == GW2.WEAPONTYPE.Greatsword ) then
					if ( SkillBar.s1.maxRange ~= nil ) then
						wt_global_information.AttackRange = SkillBar.s1.maxRange or 150
					elseif ( SkillBar.s1.radius ~= nil ) then
						wt_global_information.AttackRange = SkillBar.s1.radius or 150
					end
				elseif ( wt_profession_ranger.MHweapon.weapontype == GW2.WEAPONTYPE.Spear ) then
					if ( SkillBar.s1.maxRange ~= nil ) then
						wt_global_information.AttackRange = SkillBar.s1.maxRange or 150
					elseif ( SkillBar.s1.radius ~= nil ) then
						wt_global_information.AttackRange = SkillBar.s1.radius or 150
					end
				elseif ( wt_profession_ranger.MHweapon.weapontype == GW2.WEAPONTYPE.HarpoonGun ) then
					if ( SkillBar.s1.maxRange ~= nil ) then
						wt_global_information.AttackRange = SkillBar.s1.maxRange or 1200
					elseif ( SkillBar.s1.radius ~= nil ) then
						wt_global_information.AttackRange = SkillBar.s1.radius or 1200
					end
				end
			elseif ( wt_profession_ranger.MHweapon ~= nil and wt_profession_ranger.OHweapon ~= nil ) then
				if ( wt_profession_ranger.MHweapon.weapontype == GW2.WEAPONTYPE.Sword ) then
					if ( wt_profession_ranger.OHweapon.weapontype == GW2.WEAPONTYPE.Axe ) then
						if ( SkillBar.s1.maxRange ~= nil ) then
							wt_global_information.AttackRange = SkillBar.s1.maxRange or 130
						elseif ( SkillBar.s1.radius ~= nil ) then
							wt_global_information.AttackRange = SkillBar.s1.radius or 130
						end
					elseif ( wt_profession_ranger.OHweapon.weapontype == GW2.WEAPONTYPE.Dagger ) then
						if ( SkillBar.s1.maxRange ~= nil ) then
							wt_global_information.AttackRange = SkillBar.s1.maxRange or 130
						elseif ( SkillBar.s1.radius ~= nil ) then
							wt_global_information.AttackRange = SkillBar.s1.radius or 130
						end
					elseif ( wt_profession_ranger.OHweapon.weapontype == GW2.WEAPONTYPE.Torch ) then
						if ( SkillBar.s1.maxRange ~= nil ) then
							wt_global_information.AttackRange = SkillBar.s1.maxRange or 130
						elseif ( SkillBar.s1.radius ~= nil ) then
							wt_global_information.AttackRange = SkillBar.s1.radius or 130
						end
					elseif ( wt_profession_ranger.OHweapon.weapontype == GW2.WEAPONTYPE.Warhorn ) then
						if ( SkillBar.s1.maxRange ~= nil ) then
							wt_global_information.AttackRange = SkillBar.s1.maxRange or 130
						elseif ( SkillBar.s1.radius ~= nil ) then
							wt_global_information.AttackRange = SkillBar.s1.radius or 130
						end
					end
				elseif ( wt_profession_ranger.MHweapon.weapontype == GW2.WEAPONTYPE.Axe ) then
					if ( wt_profession_ranger.OHweapon.weapontype == GW2.WEAPONTYPE.Axe ) then
						if ( SkillBar.s1.maxRange ~= nil ) then
							wt_global_information.AttackRange = SkillBar.s1.maxRange or 900
						elseif ( SkillBar.s1.radius ~= nil ) then
							wt_global_information.AttackRange = SkillBar.s1.radius or 900
						end
					elseif ( wt_profession_ranger.OHweapon.weapontype == GW2.WEAPONTYPE.Dagger ) then
						if ( SkillBar.s1.maxRange ~= nil ) then
							wt_global_information.AttackRange = SkillBar.s1.maxRange or 900
						elseif ( SkillBar.s1.radius ~= nil ) then
							wt_global_information.AttackRange = SkillBar.s1.radius or 900
						end
					elseif ( wt_profession_ranger.OHweapon.weapontype == GW2.WEAPONTYPE.Torch ) then
						if ( SkillBar.s1.maxRange ~= nil ) then
							wt_global_information.AttackRange = SkillBar.s1.maxRange or 900
						elseif ( SkillBar.s1.radius ~= nil ) then
							wt_global_information.AttackRange = SkillBar.s1.radius or 900
						end
					elseif ( wt_profession_ranger.OHweapon.weapontype == GW2.WEAPONTYPE.Warhorn ) then
						if ( SkillBar.s1.maxRange ~= nil ) then
							wt_global_information.AttackRange = SkillBar.s1.maxRange or 900
						elseif ( SkillBar.s1.radius ~= nil ) then
							wt_global_information.AttackRange = SkillBar.s1.radius or 900
						end
					end
				end
			end

			-- Skill Bar Slot 5
			if ( not Player:IsSpellOnCooldown( GW2.SKILLBARSLOT.Slot_5 ) and not IsCastingUpdate() ) then
				if ( ( SkillBar.s5.name ~= Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_5 ).name and SkillBar.s5.skillID == Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_5 ).skillID ) or SkillBar.s5.skillID ~= Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_5 ).skillID ) then
					SkillBar.s5 = Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_5 )
					-- wt_debug( tostring( SkillBar.s5.name ) )
					if ( type( SkillBar.s5.maxRange ) == "number" ) then
						-- wt_debug( "G: " .. tostring( wt_global_information.AttackRange ) .. " B: " .. tostring( SkillBar.s5.maxRange ) )
						if ( wt_global_information.AttackRange < SkillBar.s5.maxRange ) then
							wt_global_information.AttackRange = SkillBar.s5.maxRange
						end
					end
				end
				if ( not Player:IsCasting( GW2.SKILLBARSLOT.Slot_5 ) and ( T.distance < wt_global_information.AttackRange ) ) then
					if ( T.distance < SkillBar.s5.maxRange ) then
						Player:CastSpell( GW2.SKILLBARSLOT.Slot_5, TID )
--						wt_debug( string.format( skill_str_format, tostring( SkillBar.s5.name ), TID, T.distance, SkillBar.s5.maxRange, "5", GW2.SKILLBARSLOT.Slot_5 ) )
						debug_msg( TID, T, "5", SkillBar.s5.name, SkillBar.s5.maxRange )
					end
				end
			end

			-- Skill Bar Slot 4
			if ( not Player:IsSpellOnCooldown( GW2.SKILLBARSLOT.Slot_4 ) and not IsCastingUpdate() ) then
				if ( ( SkillBar.s4.name ~= Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_4 ).name and SkillBar.s4.skillID == Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_4 ).skillID ) or SkillBar.s4.skillID ~= Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_4 ).skillID ) then
					SkillBar.s4 = Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_4 )
					-- wt_debug( tostring( SkillBar.s4.name ) )
					if ( type( SkillBar.s4.maxRange ) == "number" ) then
						-- wt_debug( "G: " .. tostring( wt_global_information.AttackRange ) .. " B: " .. tostring( SkillBar.s4.maxRange ) )
						if ( wt_global_information.AttackRange < SkillBar.s4.maxRange ) then
							wt_global_information.AttackRange = SkillBar.s4.maxRange
						end
					end
				end
				if ( not Player:IsCasting( GW2.SKILLBARSLOT.Slot_4 ) and ( T.distance < wt_global_information.AttackRange ) ) then
					if ( T.distance < SkillBar.s4.maxRange ) then
						Player:CastSpell( GW2.SKILLBARSLOT.Slot_4, TID )
--						wt_debug( string.format( skill_str_format, tostring( SkillBar.s4.name ), TID, T.distance, SkillBar.s4.maxRange, "4", GW2.SKILLBARSLOT.Slot_4 ) )
						debug_msg( TID, T, "4", SkillBar.s4.name, SkillBar.s4.maxRange )
					end
				end
			end

			-- Skill Bar Slot 3
			if ( not Player:IsSpellOnCooldown( GW2.SKILLBARSLOT.Slot_3 ) and not IsCastingUpdate() ) then
				if ( ( SkillBar.s3.name ~= Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_3 ).name and SkillBar.s3.skillID == Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_3 ).skillID ) or SkillBar.s3.skillID ~= Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_3 ).skillID ) then
					SkillBar.s3 = Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_3 )
					-- wt_debug( tostring( SkillBar.s3.name ) )
					if ( type( SkillBar.s3.maxRange ) == "number" ) then
						-- wt_debug( "G: " .. tostring( wt_global_information.AttackRange ) .. " B: " .. tostring( SkillBar.s3.maxRange ) )
						if ( wt_global_information.AttackRange < SkillBar.s3.maxRange ) then
							wt_global_information.AttackRange = SkillBar.s3.maxRange
						end
					end
				end
				if ( not Player:IsCasting( GW2.SKILLBARSLOT.Slot_3 ) and ( T.distance < wt_global_information.AttackRange ) ) then
					if ( T.distance < SkillBar.s3.maxRange ) then
						Player:CastSpell( GW2.SKILLBARSLOT.Slot_3, TID )
--						wt_debug( string.format( skill_str_format, tostring( SkillBar.s3.name ), TID, T.distance, SkillBar.s3.maxRange, "3", GW2.SKILLBARSLOT.Slot_3 ) )
						debug_msg( TID, T, "3", SkillBar.s3.name, SkillBar.s3.maxRange )
					end
				end
			end

			-- Skill Bar Slot 2
			if ( not Player:IsSpellOnCooldown( GW2.SKILLBARSLOT.Slot_2 ) and not IsCastingUpdate() ) then
				if ( ( SkillBar.s2.name ~= Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_2 ).name and SkillBar.s2.skillID == Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_2 ).skillID ) or SkillBar.s2.skillID ~= Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_2 ).skillID ) then
					SkillBar.s2 = Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_2 )
					-- wt_debug( tostring( SkillBar.s2.name ) )
					if ( type( SkillBar.s2.maxRange ) == "number" ) then
						-- wt_debug( "G: " .. tostring( wt_global_information.AttackRange ) .. " B: " .. tostring( SkillBar.s2.maxRange ) )
						if ( wt_global_information.AttackRange < SkillBar.s2.maxRange ) then
							wt_global_information.AttackRange = SkillBar.s2.maxRange
						end
					end
				end
				if ( not Player:IsCasting( GW2.SKILLBARSLOT.Slot_2 ) and ( T.distance < wt_global_information.AttackRange ) ) then
					if ( T.distance < SkillBar.s2.maxRange ) then
						Player:CastSpell( GW2.SKILLBARSLOT.Slot_2, TID )
--						wt_debug( string.format( skill_str_format, tostring( SkillBar.s2.name ), TID, T.distance, SkillBar.s2.maxRange, "2", GW2.SKILLBARSLOT.Slot_2 ) )
						debug_msg( TID, T, "2", SkillBar.s2.name, SkillBar.s2.maxRange )
					end
				end
			end

			-- Skill Bar Slot 1
			if ( not Player:IsSpellOnCooldown( GW2.SKILLBARSLOT.Slot_1 ) and not IsCastingUpdate() ) then
				if ( ( SkillBar.s1.name ~= Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_1 ).name and SkillBar.s1.skillID == Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_1 ).skillID ) or SkillBar.s1.skillID ~= Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_1 ).skillID ) then
					SkillBar.s1 = Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_1 )
					-- wt_debug( tostring( SkillBar.s1.name ) )
					if ( type( SkillBar.s1.maxRange ) == "number" ) then
						-- wt_debug( "G: " .. tostring( wt_global_information.AttackRange ) .. " B: " .. tostring( SkillBar.s1.maxRange ) )
						if ( wt_global_information.AttackRange < SkillBar.s1.maxRange ) then
							wt_global_information.AttackRange = SkillBar.s1.maxRange
						end
					end
				end
				if ( not Player:IsCasting( GW2.SKILLBARSLOT.Slot_1 ) and ( T.distance < wt_global_information.AttackRange ) ) then
					if ( T.distance < SkillBar.s1.maxRange ) then
						Player:CastSpell( GW2.SKILLBARSLOT.Slot_1, TID )
--						wt_debug( string.format( skill_str_format, tostring( SkillBar.s1.name ), TID, T.distance, SkillBar.s1.maxRange, "1", GW2.SKILLBARSLOT.Slot_1 ) )
						debug_msg( TID, T, "1", SkillBar.s1.name, SkillBar.s1.maxRange )
					end
				end
			end

		end
	end
end

-----------------------------------------------------------------------------------
-- Registration and setup of causes and effects to the different states
-----------------------------------------------------------------------------------

-- We need to check if the players current profession is ours to only add our profession specific routines
if ( wt_profession_ranger.professionID > -1 and wt_profession_ranger.professionID == Player.profession ) then

	wt_debug( "Initalizing profession routine for Ranger" )
	-- Default Causes & Effects that are already in the wt_core_state_combat for all classes:
	-- Death Check 				- Priority 10000   --> Can change state to wt_core_state_dead.lua
	-- Combat Over Check 		- Priority 500      --> Can change state to wt_core_state_idle.lua


	-- Our C & E´s for Ranger combat:
	local ke_heal_pet_action = wt_kelement:create( "heal_pet_action", c_heal_pet_action, e_heal_pet_action, 155 )
		wt_core_state_combat:add( ke_heal_pet_action )
		wt_core_state_dead:add( ke_heal_pet_action ) -- Adding this to DOWNED state

	local ke_heal_action = wt_kelement:create( "heal_action", wt_profession_ranger.c_heal_action, wt_profession_ranger.e_heal_action, 150 )
		wt_core_state_combat:add( ke_heal_action )

	local ke_MoveClose_action = wt_kelement:create( "Move closer", wt_profession_ranger.c_MoveCloser, wt_profession_ranger.e_MoveCloser, 75 )
		wt_core_state_combat:add( ke_MoveClose_action )

	local ke_Update_weapons = wt_kelement:create( "UpdateWeaponData", wt_profession_ranger.c_update_weapons, wt_profession_ranger.e_update_weapons, 55 )
		wt_core_state_combat:add( ke_Update_weapons )


	local ke_Attack_default = wt_kelement:create( "Attackdefault", wt_profession_ranger.c_attack_default, wt_profession_ranger.e_attack_default, 45 )
		wt_core_state_combat:add( ke_Attack_default )


	-- We need to set the Currentprofession to our profession , so that other parts of the framework can use it.
	wt_global_information.Currentprofession = wt_profession_ranger
	wt_global_information.AttackRange = 900
end
-----------------------------------------------------------------------------------