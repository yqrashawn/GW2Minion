-- Handles Death and respawn
-----------
c_dead = inheritsFrom( ml_cause )
e_dead = inheritsFrom( ml_effect )
c_dead.lastHealth = nil
c_dead.deadTmr = 0
function c_dead:evaluate()
	if ( Player.dead ) then
		return true
	end
	c_dead.deadTmr = 0
	return false
end
function e_dead:execute()

	ml_log("e_dead")
	if (mc_global.now - c_dead.deadTmr > 5000) then
		local pHealth = Player.health
		if ( c_dead.deadTmr == 0 or c_dead.lastHealth == nil or c_dead.lastHealth < pHealth.current ) then
			c_dead.lastHealth = pHealth.current
			c_dead.deadTmr = mc_global.now

			if (c_dead.lastHealth ~= 0) then
				c_dead.deadTmr = mc_global.now + 10000
			end
			d( "Dead: Are we being revived? If so wait to respawn.. " )
		elseif ( c_dead.deadTmr ~= 0 and c_dead.lastHealth ~= nil ) then
			c_dead.lastHealth = nil
			c_dead.deadTmr = 0
			d( "Dead: RESPAWN AT NEAREST WAYPOINT " )
			d( Player:RespawnAtClosestWaypoint() )
			mc_global.ResetBot()
			mc_ai_unstuck.Reset()
		end
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
	Player:StopMovement()
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
