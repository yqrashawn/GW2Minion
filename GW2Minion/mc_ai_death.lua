-- Handles Death and respawn
-----------
c_dead = inheritsFrom( ml_cause )
e_dead = inheritsFrom( ml_effect )
c_dead.dead = false
function c_dead:evaluate()
    --ml_log("c_dead")
	if ( Player.dead ) then
		return true
	end
	return false
end
function e_dead:execute()
	ml_log("e_dead")	
	if ( c_dead.dead ) then
		c_dead.dead = true
		mc_global.Wait(3000)
	else
		c_dead.dead = false
		d( "Dead: RESPAWN AT NEAREST WAYPOINT " )
		d( Player:RespawnAtClosestWaypoint() )
		mc_global.ResetBot()
	end
end




-----------
c_downed = inheritsFrom( ml_cause )
e_downed = inheritsFrom( ml_effect )
function c_downed:evaluate()
	return Player.healthstate == GW2.HEALTHSTATE.Downed
end
function e_downed:execute()
	ml_log("e_downed")
	if ( Player:IsSpellOnCooldown( GW2.SKILLBARSLOT.Slot_4 ) ) then
		-- Fight
		local TList = ( CharacterList("lowesthealth,attackable,aggro,alive,los,maxdistance="..mc_global.AttackRange) )
		if ( TableSize( TList ) > 0 ) then
			local id, E  = next( TList )
			if ( id ~= nil and id ~= 0 and E ~= nil ) then
				--d("New Aggro Target: "..tostring(E.name).." ID:"..tostring(id))
				local t = Player:GetTarget()
				if ( not t or t.id ~= id ) then
					Player:SetTarget(id)
					return ml_log(true)				
				else
					local pos = t.pos
					if ( pos ) then
						Player:SetFacing(pos.x,pos.y,pos.z)
						return ml_log(mc_skillmanager.AttackTarget( t.id ))					
					end
				end			
			end
		end
			
		TList = ( GadgetList("attackable,alive,aggro,los,maxdistance="..mc_global.AttackRange) )
		if ( TableSize( TList ) > 0 ) then
			local id, E  = next( TList )
			if ( id ~= nil and id ~= 0 and E ~= nil ) then
				--d("New Aggro Target: "..tostring(E.name).." ID:"..tostring(id))
				local t = Player:GetTarget()
				if ( not t or t.id ~= id ) then
					Player:SetTarget(id)
					return ml_log(true)				
				else
					local pos = t.pos
					if ( pos ) then
						Player:SetFacing(pos.x,pos.y,pos.z)
						return ml_log(mc_skillmanager.AttackTarget( t.id ))					
					end
				end	
			end
		end	
	else 
		-- Heal
		Player:CastSpell( GW2.SKILLBARSLOT.Slot_4 )
		mc_global.Wait(1000)
		return
	end	
end
