gw2_common_cne = {}


-- Handle Death by waiting for rezz & respawn at nearest Waypoint
c_Dead = inheritsFrom( ml_cause )
e_Dead = inheritsFrom( ml_effect )
c_Dead.lastHealth = nil
c_Dead.deadTmr = 0
function c_Dead:evaluate()
	if ( ml_global_information.Player_Alive == false ) then
		return true
	end
	c_Dead.deadTmr = 0
	return false
end
function e_Dead:execute()
	ml_log("e_Dead")
	-- check for partymember who can raise us
	local party = ml_global_information.Player_Party
	local found = false	
	if ( TableSize(party) > 1 ) then		
		local idx,pmember = next(party)	
		while (idx and pmember) do
			if ( pmember.id ~= 0 ) then
				local char = CharacterList:Get(pmember.id)
				if ( char ) then
					local cPos = char.pos
					if ( cPos and Distance2D ( ml_global_information.Player_Position.x, ml_global_information.Player_Position.y, cPos.x, cPos.y) < 4000 and char.dead == false) then
						found = true
						break
					end
				end
			end
			idx,pmember=next(party,idx)
		end
	end	
	-- Check for nearby Players who can rezz us
	if ( found == false ) then
		if ( TableSize(CharacterList("nearest,alive,friendly,player,maxdistance=1200"))>0 ) then
			found = true
		end
	end
	
		if ( ( not found and TimeSince(c_Dead.deadTmr) > 5000) or TimeSince(c_Dead.deadTmr) > 30000 ) then -- wait a bit longer for other ppl to rezz us if they are around
			
			if ( c_Dead.deadTmr == 0 or c_Dead.lastHealth == nil or c_Dead.lastHealth < ml_global_information.Player_Health.current ) then
				c_Dead.lastHealth = ml_global_information.Player_Health.current
				c_Dead.deadTmr = ml_global_information.Now

				if (c_Dead.lastHealth ~= 0) then
					c_Dead.deadTmr = ml_global_information.Now + 10000
				end
				ml_log( "Dead: We are beeing revived...waiting a bit longer " )
				
			elseif ( c_Dead.deadTmr ~= 0 and c_Dead.lastHealth ~= nil ) then
				c_Dead.lastHealth = nil
				c_Dead.deadTmr = 0
				d( "Dead: RESPAWN AT NEAREST WAYPOINT " )
				d( Player:RespawnAtClosestWaypoint() )
				ml_global_information.Stop()
				ml_global_information.Reset() -- clear queues here ?
			end
		end
end


-- Handle Downed state, heal and attack nearby aggro targets
c_Downed = inheritsFrom( ml_cause )
e_Downed = inheritsFrom( ml_effect )
function c_Downed:evaluate()
	return Player.healthstate == GW2.HEALTHSTATE.Downed
end
function e_Downed:execute()
	ml_log("e_Downed")
	
	if ( ml_global_information.Player_IsMoving ) then Player:StopMovement() end 
	
	if ( Player:IsSpellOnCooldown( GW2.SKILLBARSLOT.Slot_4 ) ) then
		-- Try to Fight
		local TList = ( CharacterList("lowesthealth,attackable,aggro,alive,los,maxdistance="..ml_global_information.AttackRange) )
		
		if ( TableSize( TList ) == 0 ) then
			TList = ( GadgetList("attackable,alive,aggro,los,maxdistance="..ml_global_information.AttackRange) )
		end
		
		if ( TableSize( TList ) > 0 ) then
			local id, E  = next( TList )
			if ( id ~= nil and id ~= 0 and E ~= nil ) then
				
				local target = Player:GetTarget()
				if ( not target or target.id ~= id ) then
					Player:SetTarget(id)
					return ml_log(true)				
				else
					return ml_log(gw2_skill_manager.Attack( target ))
				end			
			end
		end
		
	else 
		-- Heal
		if ( Player.castinfo.duration == 0 ) then
			Player:CastSpell( GW2.SKILLBARSLOT.Slot_4 )
			ml_global_information.Wait(500)
		end
	end	
end


c_RezzPartyMember = inheritsFrom( ml_cause )
e_RezzPartyMember = inheritsFrom( ml_effect )
e_RezzPartyMember.target = nil
function c_RezzPartyMember:evaluate()
	local party = ml_global_information.Player_Party
	if ( TableSize(party) >0 ) then
		local idx,pmember = next(party)	
		while (idx and pmember) do
			if ( pmember.id ~= 0 ) then
				local char = CharacterList:Get(pmember.id)
				if ( char ) then
					if ( char.onmesh and (char.downed == true or char.dead == true) and ml_global_information.Player_Health.percent > 50 and char.pathdistance < 4000) then
						e_RezzPartyMember.target = char
						return true
					end
				end
			end
			idx,pmember=next(party,idx)
		end
	end
	e_RezzPartyMember.target = nil
	return false
end
function e_RezzPartyMember:execute()
	ml_log("e_RezzPartyMember")	
	
	if ( e_RezzPartyMember.target ) then
		if (not e_RezzPartyMember.target.isInInteractRange) then
			-- MoveIntoInteractRange
			local tPos = e_RezzPartyMember.target.pos
			if ( tPos ) then
				
				local newTask = gw2_task_moveto.Create()
				newTask.targetPos = tPos
				newTask.targetID = e_RezzPartyMember.target.id
				newTask.targetType = "character"
				newTask.name = "MoveToRezz"
				ml_task_hub:CurrentTask():AddSubTask(newTask)					
				ml_log("MoveToDownedPartyMember..")
				return ml_log(true)
			end
		else
			-- Grab that thing
			if ( ml_global_information.Player_IsMoving == true ) then Player:StopMovement() end 
			
			if (Player.profession == 8 ) then -- Necro, leave shroud
				local deathshroud = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_13)
				if ( deathshroud ~= nil and deathshroud.skillID == 10585 and Player:CanCast() and Player:GetCurrentlyCastedSpell() == 17) then
					Player:CastSpell(GW2.SKILLBARSLOT.Slot_13)
					ml_global_information.Wait(500)
					return
				end
			end
					
			local t = Player:GetTarget()
			if ( not t or t.id ~= e_RezzPartyMember.target.id ) then
				Player:SetTarget( e_RezzPartyMember.target.id )
			else		
				ml_log("Rezzing PartyMember..")
				Player:Interact( e_RezzPartyMember.target.id )
				ml_global_information.Wait(1000)
				return ml_log(true)
			end
		end
		
	else	
		ml_error("There should be a downed/dead partymember but we cant find him!")
	end
end
-- used for example in task_grind Overwatch when running a subtask moveto which brings the player to the target that should be rezzed
c_RezzOverWatchCheck = inheritsFrom( ml_cause )
e_RezzOverWatchCheck = inheritsFrom( ml_effect )
function c_RezzOverWatchCheck:evaluate()
	if ( ml_task_hub:CurrentTask() ~= nil and ml_task_hub:CurrentTask().name == "MoveToRezz" and ml_task_hub:CurrentTask().targetPos ~= nil and ml_task_hub:CurrentTask().targetID ~= nil ) then
		local character = CharacterList:Get(ml_task_hub:CurrentTask().targetID)
		if ( character ~= nil and character.alive) then
			return true
		end
	end
	return false
end
function e_RezzOverWatchCheck:execute()
	-- the subtask moveto should be automatically be deleted once we are here, so we do nothing..
	ml_log("e_RezzOverWatchCheck")
end

c_reviveDownedPlayersInCombat = inheritsFrom( ml_cause )
e_reviveDownedPlayersInCombat = inheritsFrom( ml_effect )
e_reviveDownedPlayersInCombat.target = nil
function c_reviveDownedPlayersInCombat:evaluate()
	if ( gRevivePlayers == "1" and ml_global_information.Player_Health.percent > 50 ) then
		local CList = CharacterList("shortestpath,selectable,interactable,downed,friendly,player,onmesh,maxdistance=2000")
		if ( TableSize( CList ) > 0 ) then 
			local id,entity = next (CList)
			if ( id and entity ) then
				e_reviveDownedPlayersInCombat.target = entity
				return true
			end
		end
	end
	e_reviveDownedPlayersInCombat.target = nil
	return false
end
function e_reviveDownedPlayersInCombat:execute()
	ml_log("e_reviveDownedPlayersInCombat")
	if ( e_reviveDownedPlayersInCombat.target ) then
			
		if (not e_reviveDownedPlayersInCombat.target.isInInteractRange) then
			-- MoveIntoInteractRange
			local tPos = e_reviveDownedPlayersInCombat.target.pos
			if ( tPos ) then
				
				local newTask = gw2_task_moveto.Create()
				newTask.targetPos = tPos
				newTask.targetID = e_reviveDownedPlayersInCombat.target.id
				newTask.targetType = "character"
				newTask.name = "MoveToRezz" -- giving it a special name so the overwatch knows when to kick in 
				ml_task_hub:CurrentTask():AddSubTask(newTask)					
				ml_log("MoveToDownedPartyMember..")
				return ml_log(true)
			end
		else
			-- Grab that thing
			if ( ml_global_information.Player_IsMoving ) then Player:StopMovement() end
			
			local t = Player:GetTarget()
			if ( not t or t.id ~= e_reviveDownedPlayersInCombat.target.id ) then
				Player:SetTarget( e_reviveDownedPlayersInCombat.target.id )
			else
				
				-- yeah I know, but this usually doesnt break ;)											
				if ( Player.profession == 8 ) then
					local skill = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_1)
					if ( skill ~= nil ) then
						if ( skill.skillID == 10554 ) then
							Player:CastSpell(GW2.SKILLBARSLOT.Slot_13) -- Leave Death Shroud
							return
						-- add more here if needed
						end
					end
				end
				ml_log("Reviving..")
				Player:Interact( e_reviveDownedPlayersInCombat.target.id )
				ml_global_information.Wait(1000)
				return true						
			end
		end
	end
	return ml_log(false)	
end

-- Range limited to Attackrange 
c_AttackBestNearbyCharacterTarget = inheritsFrom( ml_cause )
e_AttackBestNearbyCharacterTarget = inheritsFrom( ml_effect )
c_AttackBestNearbyCharacterTarget.target = nil
function c_AttackBestNearbyCharacterTarget:evaluate()
	c_AttackBestNearbyCharacterTarget.target = gw2_common_functions.GetBestCharacterTargetForAssist()
	if ( c_AttackBestNearbyCharacterTarget.target ~= nil ) then
		return true
	end
	c_AttackBestNearbyCharacterTarget.target = nil
	return false
end
function e_AttackBestNearbyCharacterTarget:execute()
	ml_log( "AttackBestCharacterTarget" )
	gw2_skill_manager.Attack( c_AttackBestNearbyCharacterTarget.target )	
	c_AttackBestNearbyCharacterTarget.target = nil
end

--
c_FightAggro = inheritsFrom( ml_cause )
e_FightAggro = inheritsFrom( ml_effect )
c_FightAggro.target = nil
function c_FightAggro:evaluate()
	if ( c_MoveToMarker.markerreached == false and c_MoveToMarker.allowedToFight == true) then
		local target = gw2_common_functions.GetBestAggroTarget()
		if ( target ) then
			c_FightAggro.target = target
			return ml_global_information.Player_SwimState == GW2.SWIMSTATE.NotInWater and c_FightAggro.target ~= nil			
		end
	end
	c_FightAggro.target = nil
	return false
end
function e_FightAggro:execute()
	ml_log("e_FightAggro ")
			
	if (c_FightAggro.target ~= nil) then
		Player:StopMovement()
		local newTask = gw2_task_combat.Create()
		newTask.targetID = c_FightAggro.target.id		
		newTask.targetPos = c_FightAggro.target.pos		
		ml_task_hub:Add(newTask.Create(), IMMEDIATE_GOAL, TP_IMMEDIATE)
		c_FightAggro.target = nil
	else
		ml_log("e_FightAggro found no target")
	end
	return ml_log(false)
end


