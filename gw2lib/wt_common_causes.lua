-- common causes uses by the system
-- those can easily be used in compound cause objects to check
-- for multiple causes at once

--**********************************************
-- Death Check
--**********************************************
c_died = inheritsFrom( wt_cause )
e_died = inheritsFrom( wt_effect )
function c_died:evaluate()
	if ( not wt_core_taskmanager.behavior == "default" ) then
		wt_core_taskmanager:SetDefaultBehavior()
	end
	if ( Player.alive ~= true ) then
		return true
	end
	return false
end
function e_died:execute()
	wt_core_controller.requestStateChange( wt_core_state_dead )
end



--***********************************************************
-- QuickLoot Cause & Effect (looting just the things that are in range already, this we can do while beeing infight)
--***********************************************************
c_quickloot = inheritsFrom( wt_cause )
e_quickloot = inheritsFrom( wt_effect )
function c_quickloot:evaluate()
	if ( ItemList.freeSlotCount > 0 ) then
		c_quickloot.EList = CharacterList( "nearest,lootable,onmesh,maxdistance=120" )
		NextIndex, LootTarget = next( c_quickloot.EList )
		if ( NextIndex ~= nil ) then
			if ( NextIndex == Player:GetInteractableTarget() ) then
				return true
			end
		end
		--stupidcheck since some enemies are not marked as lootable but they are lootable
		local e = Player:GetInteractableTarget()
		if ( e ~= nil ) then
			etable = CharacterList:Get( e )
			if ( etable ~= nil ) then
				if ( etable.healthstate == GW2.HEALTHSTATE.Defeated and ( etable.attitude == GW2.ATTITUDE.Hostile or etable.attitude == GW2.ATTITUDE.Neutral ) and etable.isMonster ) then
					return true
				end
			end
		end
	end
	return false
end
e_quickloot.n_index = nil
e_quickloot.throttle = math.random( 50, 450 )
e_quickloot.delay = math.random( 50, 250 )
function e_quickloot:execute()
 	local NextIndex = 0
	local LootTarget = nil
	if (c_quickloot.EList ~= nil ) then
		NextIndex, LootTarget = next( c_quickloot.EList )
		if ( NextIndex ~= nil and NextIndex == Player:GetInteractableTarget() ) then
			if ( e_quickloot.n_index  ~= NextIndex ) then
				e_quickloot.n_index  = NextIndex
				wt_debug( "QuickLooting" )
			end
			Player:Interact( NextIndex )
		else
			local e = Player:GetInteractableTarget()
			if ( e ~= nil ) then
				etable = CharacterList:Get( e )
				if ( etable ~= nil ) then
					if ( etable.healthstate == GW2.HEALTHSTATE.Defeated and ( etable.attitude == GW2.ATTITUDE.Hostile or etable.attitude == GW2.ATTITUDE.Neutral ) and etable.isMonster ) then
						if ( e_quickloot.n_index  ~= e ) then
							e_quickloot.n_index  = e
							wt_debug( "QuickLooting" )
						end
						Player:Interact( e )
						return
					end
				end
			end
		end
	end
	wt_error( "No Target to Quick-Loot" )
end





--********************************************************************
-- QuickLoot Chests Cause & Effect (looting just the things that are in range already, this we can do while beeing infight)
--********************************************************************
c_quicklootchest = inheritsFrom( wt_cause )
e_quicklootchest = inheritsFrom( wt_effect )
function c_quicklootchest:evaluate()
	if ( ItemList.freeSlotCount > 0 ) then
		c_quicklootchest.EList = GadgetList("nearest,onmesh,contentID=198260" ) --contentID=198260
		NextIndex, LootTarget = next( c_quicklootchest.EList )
		if ( NextIndex ~= nil ) then
			if ( NextIndex == Player:GetInteractableTarget() ) then
				return true
			end
		end
	end
	return false
end
e_quicklootchest.n_index = nil
e_quicklootchest.throttle = math.random( 150, 450 )
function e_quicklootchest:execute()
 	local NextIndex = 0
	local LootTarget = nil
	if (c_quicklootchest.EList ~= nil ) then
		NextIndex, LootTarget = next( c_quicklootchest.EList )
		if ( NextIndex ~= nil and NextIndex == Player:GetInteractableTarget() ) then
			if ( e_quicklootchest.n_index  ~= NextIndex ) then
				e_quicklootchest.n_index  = NextIndex
				wt_debug( "QuickLootingChest" )
			end
			Player:Use( NextIndex )
		else
			local e = Player:GetInteractableTarget()
			if ( e ~= nil ) then
				local gadget = GadgetList:Get( e )
				if ( gadget ~= nil ) then
					if ( gadget.contentID == 198260) then --198260 is pve loot chest/box
						if ( e_quicklootchest.n_index  ~= e ) then
							e_quicklootchest.n_index  = e
							wt_debug( "QuickLootingChest" )
						end
						Player:Use( e )
						return
					end
				end
			end
		end
	end
	wt_error( "No Chest to Quick-Loot" )
end



--*************************************************************
-- Aggro Cause & Effect
--*************************************************************
c_aggro = inheritsFrom( wt_cause )
e_aggro = inheritsFrom( wt_effect )
function c_aggro:evaluate()
	-- For Groupbotting
	if (gMinionEnabled == "1" and MultiBotIsConnected( ) and wt_global_information.LeaderID ~= nil and Player.characterID ~= nil) then
		if ( wt_global_information.LeaderID == Player.characterID ) then -- We Lead			
			-- Kill all PartyAggroTargets in range of leader first
			if ( TableSize( wt_global_information.PartyAggroTargets ) > 0 ) then
				local nextTarget
				nextTarget, nChar = next( wt_global_information.PartyAggroTargets )
				if ( nextTarget ~= nil and nextTarget ~= 0) then
					local ntarget = CharacterList:Get(tonumber(nextTarget))
					if ( ntarget ~= nil and ntarget.distance < 4000 and ntarget.alive and ntarget.onmesh) then
						c_aggro.TargetList[tonumber(nextTarget)] = nChar
						return true
					else 
						table.remove(wt_global_information.PartyAggroTargets,tonumber(nextTarget))
					end
				end
			end
			
			-- Search for new FocusTarget
			c_aggro.TargetList = ( CharacterList( "nearest,attackable,alive,noCritter,onmesh,maxdistance="..wt_global_information.MaxAggroDistanceFar ) )
			if ( TableSize( c_aggro.TargetList ) > 0 ) then
				return true
			end
			c_aggro.TargetList = ( CharacterList( "nearest,los,attackable,incombat,alive,noCritter,onmesh,maxdistance="..wt_global_information.MaxAggroDistanceClose ) )
			if ( TableSize( c_aggro.TargetList ) > 0 ) then
				return true
			end			
			
		else -- We follow
			-- kill focus target
			if ( wt_global_information.FocusTarget ~= nil and wt_core_controller.state ~= nil and wt_core_controller.state == wt_core_state_minion) then
				local target = CharacterList:Get(tonumber(wt_global_information.FocusTarget))
				if ( target ~= nil and target.distance < 4000 and target.alive and target.onmesh) then
					return true
				end
			end
			wt_global_information.FocusTarget = nil
			
			-- close range aggro targets
			c_aggro.TargetList = ( CharacterList( "nearest,los,attackable,alive,noCritter,onmesh,maxdistance="..wt_global_information.MaxAggroDistanceClose ) )
			if ( TableSize( c_aggro.TargetList ) > 0 ) then
				nextTarget, E  = next( c_aggro.TargetList )
				if ( nextTarget ~= nil ) then
					return true
				end
			end
		end
		return false		
	end
	
	-- For Solo botting	
	if ( Player.inCombat ) then
		c_aggro.TargetList = ( CharacterList( "nearest,attackable,alive,incombat,noCritter,onmesh,maxdistance="..wt_global_information.MaxAggroDistanceFar ) )
		if ( TableSize( c_aggro.TargetList ) > 0 ) then
			nextTarget, E  = next( c_aggro.TargetList )
			if ( nextTarget ~= nil ) then
				return true
			end
		end
	end

	c_aggro.TargetList = ( CharacterList( "nearest,los,attackable,alive,noCritter,onmesh,maxdistance="..wt_global_information.MaxAggroDistanceClose ) )
	if ( TableSize( c_aggro.TargetList ) > 0 ) then
		return true
	end
	return false
end
function e_aggro:execute()
	-- For Groupbotting
	if (gMinionEnabled == "1" and MultiBotIsConnected( ) and wt_global_information.LeaderID ~= nil ) then
		if ( wt_global_information.LeaderID == Player.characterID ) then -- We Lead		
			if ( TableSize( c_aggro.TargetList ) > 0 ) then
				nextTarget, E  = next( c_aggro.TargetList )
				if ( nextTarget ~= nil ) then
					wt_debug( "Begin Combat, Possible aggro target found" )
					MultiBotSend( "5;"..nextTarget,"gw2minion" )
					wt_core_state_combat.setTarget( nextTarget )
					wt_core_controller.requestStateChange( wt_core_state_combat )
				end
			end
		else -- We Follow
			if ( wt_global_information.FocusTarget ~= nil and wt_core_controller.state ~= nil and wt_core_controller.state == wt_core_state_minion) then
				local target = CharacterList:Get(tonumber(wt_global_information.FocusTarget))
				if ( target ~= nil and target.distance < 4000 and target.alive and target.onmesh) then
					wt_debug( "Attacking Focustarget" )
					wt_core_state_combat.setTarget( wt_global_information.FocusTarget )
					wt_core_controller.requestStateChange( wt_core_state_combat )
					return
				end
			end
			if ( TableSize( c_aggro.TargetList ) > 0 ) then
				nextTarget, E  = next( c_aggro.TargetList )
				if ( nextTarget ~= nil ) then
					wt_debug( "Begin Combat, Possible aggro target found" )
					--TODO: Inform leader about our aggro target
					MultiBotSend( "6;"..nextTarget,"gw2minion" )					
					wt_core_state_combat.setTarget( nextTarget )
					wt_core_controller.requestStateChange( wt_core_state_combat )
				end
			end
		end
		return false
	end
	
	--For Solo botting
	if ( TableSize( c_aggro.TargetList ) > 0 ) then
		nextTarget, E  = next( c_aggro.TargetList )
		if ( nextTarget ~= nil ) then
			wt_debug( "Begin Combat, Possible aggro target found" )
			wt_core_state_combat.setTarget( nextTarget )
			wt_core_controller.requestStateChange( wt_core_state_combat )
		end
	end
end



--************************************************************
-- Rest Cause & Effect
--************************************************************
c_rest = inheritsFrom( wt_cause )
e_rest = inheritsFrom( wt_effect )
function c_rest:evaluate()
	local HP = Player.health.percent
	if ( HP < wt_global_information.Currentprofession.RestHealthLimit ) then
		return true
	end
	if (gMinionEnabled == "1" and MultiBotIsConnected( ) and wt_global_information.LeaderID ~= nil and wt_global_information.LeaderID == Player.characterID ) then -- We Lead	
		local party = Player:GetPartyMembers()
		if (party ~= nil) then
			local index, player  = next( party )
			while ( index ~= nil and player ~= nil ) do			
				if (player.distance < 4000 and player.alive and player.onmesh and player.health.percent < wt_global_information.Currentprofession.RestHealthLimit ) then					
					return true
				end
				index, player  = next( party,index )
			end		
		end		
	end
	return false
end
e_rest.throttle = math.random( 500, 2500 )
function e_rest:execute()
	if (Player.profession == 8 ) then -- Necro, leave shroud
		local deathshroud = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_13)
		if (not Player.inCombat and deathshroud ~= nil and deathshroud.skillID == 10585) then
			Player:CastSpell(GW2.SKILLBARSLOT.Slot_13)
			return
		end
	end
	local HP = Player.health.percent
	if ( HP < wt_global_information.Currentprofession.RestHealthLimit ) then
		local s6 = Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_6 )
		if( Player:GetCurrentlyCastedSpell() == 17 and not Player:IsSpellOnCooldown( GW2.SKILLBARSLOT.Slot_6 ) ) then
			if ( c_rest_heal ) then
				c_rest_heal = not c_rest_heal
				if ( s6 ~= nil ) then
					wt_debug( "Using "..tostring( s6.name ).." to heal ("..Player.health.percent.."%)" )
				end
			end
			Player:CastSpell( GW2.SKILLBARSLOT.Slot_6 )
		end
	end
	if (gMinionEnabled == "1" and MultiBotIsConnected( ) and wt_global_information.LeaderID ~= nil and wt_global_information.LeaderID == Player.characterID ) then -- We Lead	
		local party = Player:GetPartyMembers()
		if (party ~= nil) then
			local index, player  = next( party )
			while ( index ~= nil and player ~= nil ) do			
				if (player.distance > 3500 and player.alive and player.onmesh and player.health.percent < wt_global_information.Currentprofession.RestHealthLimit ) then					
					local pos = player.pos
					Player:MoveTo(pos.x,pos.y,pos.z,math.random( 20, 100 ))
				end
				index, player  = next( party,index )
			end		
		end
	end
	return
end




--************************************************************
-- Revive PartyMember in Groupbotting
--************************************************************
c_check_revivep = inheritsFrom( wt_cause )
e_revivep = inheritsFrom( wt_effect )
c_check_revivep.ID = nil

function c_check_revivep:evaluate()
	local party = Player:GetPartyMembers()
	if (party ~= nil and wt_core_state_leader.LeaderID ~= nil) then
		local index, player  = next( party )
		while ( index ~= nil and player ~= nil ) do			
			if (player.distance < 4000 and ((player.healthstate == GW2.HEALTHSTATE.Defeated and not Player.inCombat) or (player.healthstate == GW2.HEALTHSTATE.Downed)) and player.onmesh) then
				c_check_revivep.ID = index
				return true
			end
			index, player  = next( party,index )
		end		
	end
	return false
end

function e_revivep:execute()
	if (c_check_revivep.ID ~= nil and c_check_revivep.ID ~= 0 ) then
		local T = CharacterList:Get( c_check_revivep.ID )
		if ( T ~= nil ) then
			if ( ((player.healthstate == GW2.HEALTHSTATE.Defeated and not Player.inCombat) or (player.healthstate == GW2.HEALTHSTATE.Downed)) and T.onmesh ) then
				if ( T.distance > 100 ) then
					local TPOS = T.pos
					Player:MoveTo( TPOS.x, TPOS.y, TPOS.z , 50 )
				elseif( T.distance <= 100 ) then
					Player:StopMoving()
					if ( Player:GetCurrentlyCastedSpell() == 17 ) then
						Player:Interact( c_check_revivep.ID )
						return
					end
				end
			end
		end
	end
end



--****************************************************
-- Revive Nearby NPCs
--****************************************************
c_check_revive = inheritsFrom( wt_cause )
e_revive = inheritsFrom( wt_effect )
function c_check_revive:evaluate()
	local TID = Player:GetInteractableTarget()
	if ( TID ~= nil ) then
		local T = CharacterList:Get( TID )
		if ( T ~= nil ) then
			if ( T.distance < wt_global_information.MaxReviveDistance and T.attitude == GW2.ATTITUDE.Friendly and T.healthstate == GW2.HEALTHSTATE.Defeated and T.onmesh ) then
				if ( wt_core_state_idle.DebugModes.Revive.Master ) then
					if ( T.distance > 100 and wt_core_state_idle.DebugModes.state ~= "Move" ) then
						wt_core_state_idle.DebugModes.state = "Move"
						if ( wt_core_state_idle.DebugModes.Revive.TID ~= nil ) then wt_core_state_idle.DebugModes.Revive.TID = nil end
					elseif ( T.distance < 100 and wt_core_state_idle.DebugModes.state ~= "Revive" ) then
						wt_core_state_idle.DebugModes.state = "Revive"
						if ( wt_core_state_idle.DebugModes.Revive.TID ~= nil ) then wt_core_state_idle.DebugModes.Revive.TID = nil end
					end
					if ( wt_core_state_idle.DebugModes.Revive.Move or wt_core_state_idle.DebugModes.Revive.Revive ) then
						-- if ( wt_core_state_idle.DebugModes.Revive.TID ~= nil ) then wt_core_state_idle.DebugModes.Revive.TID = nil end
					end
				end
				return true
			end
		end
	end
	if ( wt_core_state_idle.DebugModes.Revive.Master ) then
		if ( wt_core_state_idle.DebugModes.state ~= false ) then wt_core_state_idle.DebugModes.state = false end
		if ( wt_core_state_idle.DebugModes.Revive.TID ~= nil ) then wt_core_state_idle.DebugModes.Revive.TID = nil end
	end
	return false
end
function e_revive:execute()
 	local TID = Player:GetInteractableTarget()
	if ( TID ~= nil ) then
		local T = CharacterList:Get( TID )
		if ( T ~= nil ) then
			if ( T.healthstate == GW2.HEALTHSTATE.Defeated and T.attitude == GW2.ATTITUDE.Friendly and T.onmesh ) then
				if ( T.distance > 100 ) then
					if ( wt_core_state_idle.DebugModes.Revive.TID ~= TID and wt_core_state_idle.DebugModes.Revive.Master ) then wt_core_state_idle.DebugModes.Revive.TID = TID wt_debug( string.format( "Idle: moving to reviveable target %s Dist: %u", tostring( T.name ), T.distance ) ) end
					local TPOS = T.pos
					Player:MoveTo( TPOS.x, TPOS.y, TPOS.z , 80 )
				elseif( T.distance < 100 ) then
					Player:StopMoving()
					if ( Player:GetCurrentlyCastedSpell() == 17 ) then
						if ( wt_core_state_idle.DebugModes.Revive.TID ~= TID and wt_core_state_idle.DebugModes.Revive.Master ) then wt_core_state_idle.DebugModes.Revive.TID = TID wt_debug( string.format( "Idle: reviving target %s", tostring( T.name ) ) ) end
						Player:Interact( TID )
						return
					end
				end
			end
		end
	else
		if ( wt_core_state_idle.DebugModes.Revive.NoTarget and wt_core_state_idle.DebugModes.Revive.Master ) then wt_error( "Idle: No Target to revive" ) end
	end
end



--*********************************************************
-- Loot Cause & Effect
--*********************************************************
local c_check_loot = inheritsFrom( wt_cause )
local e_loot = inheritsFrom( wt_effect )
local e_loot_t_size = 0
local e_loot_n_index = nil

function c_check_loot:evaluate()
	if ( ItemList.freeSlotCount > 0 ) then
		c_check_loot.EList = CharacterList( "nearest,lootable,onmesh,maxdistance=" .. wt_global_information.MaxLootDistance )
		if ( TableSize( c_check_loot.EList ) > 0 ) then
			if ( wt_core_state_idle.DebugModes.Loot.Master ) then
				local index, LT = next( c_check_loot.EList )
				if ( index ~= nil ) then
					if ( wt_core_state_idle.DebugModes.Loot.index == index or wt_core_state_idle.DebugModes.Loot.state == false ) then
						if ( LT.distance > 130 and wt_core_state_idle.DebugModes.Loot.state ~= "Moving" and wt_core_state_idle.DebugModes.Loot.Move ) then
							wt_core_state_idle.DebugModes.Loot.state = "Moving"
							if ( wt_core_state_idle.DebugModes.Loot.index == index ) then wt_core_state_idle.DebugModes.Loot.index = nil end
						elseif ( LT.distance < 100 and wt_core_state_idle.DebugModes.Loot.state ~= "Looting" ) then
							wt_core_state_idle.DebugModes.Loot.state = "Looting"
							if ( wt_core_state_idle.DebugModes.Loot.index == index ) then wt_core_state_idle.DebugModes.Loot.index = nil end
						elseif ( LT.distance < 150 and wt_core_state_idle.DebugModes.Loot.state ~= "DirectMoving" ) then
							wt_core_state_idle.DebugModes.Loot.state = "DirectMoving"
							if ( wt_core_state_idle.DebugModes.Loot.index == index ) then wt_core_state_idle.DebugModes.Loot.index = nil end
						end
					end
					if ( wt_core_state_idle.DebugModes.Loot.Size ~= TableSize( c_check_loot.EList ) and wt_core_state_idle.DebugModes.Loot.TSize ) then wt_core_state_idle.DebugModes.Loot.Size = TableSize( c_check_loot.EList ) end
					return true
				end
			end
			return true
		end
		if ( wt_core_state_idle.DebugModes.Loot.Master ) then
			if ( wt_core_state_idle.DebugModes.Loot.Size ~= TableSize( c_check_loot.EList ) ) then wt_core_state_idle.DebugModes.Loot.Size = TableSize( c_check_loot.EList ) end
			if ( wt_core_state_idle.DebugModes.Loot.state ~= false ) then wt_core_state_idle.DebugModes.Loot.state = false end
		end
	end
	return false
end
e_loot.throttle = math.random( 250, 500 )
-- A Note to "e_loot:execute()" after the introduction of QuickLoot, "e_loot:Execute()" never seem to reach past "Idle: moving to loot" if QuickLoot is present in state.
function e_loot:execute()
	local NextIndex, LootTarget = 0, nil
	NextIndex, LootTarget = next( c_check_loot.EList )
	if ( NextIndex ~= nil ) then
		if ( wt_core_state_idle.DebugModes.Loot.Master and wt_core_state_idle.DebugModes.Loot.Size > 0 and wt_core_state_idle.DebugModes.Loot.index ~= NextIndex ) then wt_debug( "Idle: loottable size " .. TableSize( c_check_loot.EList ) ) end
		if ( LootTarget.distance > 130 ) then
			if ( wt_core_state_idle.DebugModes.Loot.Master and wt_core_state_idle.DebugModes.Loot.index ~= NextIndex and wt_core_state_idle.DebugModes.Loot.state == "Moving" ) then wt_core_state_idle.DebugModes.Loot.index = NextIndex wt_debug( "Idle: moving to loot" ) end
			local TPOS = LootTarget.pos
			Player:MoveTo( TPOS.x, TPOS.y, TPOS.z , 0 )
		elseif ( LootTarget.distance < 100 and NextIndex == Player:GetInteractableTarget() ) then
			Player:StopMoving()
			if ( Player:GetCurrentlyCastedSpell() == 17 ) then
				if ( e_loot_n_index ~= NextIndex ) then
					e_loot_n_index = NextIndex
					wt_debug( "Idle: looting" )
				end
				Player:Interact( NextIndex )
			end
		elseif ( LootTarget.distance < 150 ) then
			if ( e_loot_n_index ~= NextIndex ) then
				e_loot_n_index = NextIndex
				wt_debug( "Idle: directly moving to loot" )
			end
			local TPOS = LootTarget.pos
			Player:MoveToStraight( TPOS.x, TPOS.y, TPOS.z , 0 )
		end
	else
		wt_error( "Idle: No Target to Loot" )
	end
end


------------------------------------------------------------------------------
-- LootChests Cause & Effect
c_lootchest = inheritsFrom( wt_cause )
e_lootchest = inheritsFrom( wt_effect )
e_lootchest_t_size = 0
e_lootchest_n_index = nil

function c_lootchest:evaluate()
	if ( ItemList.freeSlotCount > 0 ) then
		c_lootchest.EList = GadgetList("nearest,onmesh,contentID=198260,maxdistance=" .. wt_global_information.MaxLootDistance )
		if ( TableSize( c_lootchest.EList ) > 0 ) then
			if ( wt_core_state_idle.DebugModes.LootChest.Master ) then
				local index, LT = next( c_lootchest.EList )
				if ( index ~= nil ) then
					if ( wt_core_state_idle.DebugModes.LootChest.index == index or wt_core_state_idle.DebugModes.LootChest.state == false ) then
						if ( LT.distance > 130 and wt_core_state_idle.DebugModes.LootChest.state ~= "Moving" and wt_core_state_idle.DebugModes.LootChest.Move ) then
							wt_core_state_idle.DebugModes.LootChest.state = "Moving"
							if ( wt_core_state_idle.DebugModes.LootChest.index == index ) then wt_core_state_idle.DebugModes.LootChest.index = nil end
						elseif ( LT.distance < 100 and wt_core_state_idle.DebugModes.LootChest.state ~= "Looting" ) then
							wt_core_state_idle.DebugModes.LootChest.state = "Looting"
							if ( wt_core_state_idle.DebugModes.LootChest.index == index ) then wt_core_state_idle.DebugModes.LootChest.index = nil end
						elseif ( LT.distance < 150 and wt_core_state_idle.DebugModes.LootChest.state ~= "DirectMoving" ) then
							wt_core_state_idle.DebugModes.LootChest.state = "DirectMoving"
							if ( wt_core_state_idle.DebugModes.LootChest.index == index ) then wt_core_state_idle.DebugModes.LootChest.index = nil end
						end
					end
					if ( wt_core_state_idle.DebugModes.LootChest.Size ~= TableSize( c_lootchest.EList ) and wt_core_state_idle.DebugModes.LootChest.TSize ) then wt_core_state_idle.DebugModes.LootChest.Size = TableSize( c_check_loot.EList ) end
					return true
				end
			end
			return true
		end
		if ( wt_core_state_idle.DebugModes.LootChest.Master ) then
			if ( wt_core_state_idle.DebugModes.LootChest.Size ~= TableSize( c_lootchest.EList ) ) then wt_core_state_idle.DebugModes.LootChest.Size = TableSize( c_check_loot.EList ) end
			if ( wt_core_state_idle.DebugModes.LootChest.state ~= false ) then wt_core_state_idle.DebugModes.LootChest.state = false end
		end
	end
	return false
end

e_lootchest.throttle = math.random( 500, 1500 )
e_lootchest.delay = math.random( 100, 500 )
-- A Note to "e_loot:execute()" after the introduction of QuickLoot, "e_loot:Execute()" never seem to reach past "Idle: moving to loot" if QuickLoot is present in state.
function e_lootchest:execute()
	local NextIndex, LootTarget = 0, nil
	NextIndex, LootTarget = next( c_lootchest.EList )
	if ( NextIndex ~= nil ) then
		if ( wt_core_state_idle.DebugModes.LootChest.Master and wt_core_state_idle.DebugModes.LootChest.Size > 0 and wt_core_state_idle.DebugModes.LootChest.index ~= NextIndex ) then wt_debug( "Idle: loottable size " .. TableSize( c_check_loot.EList ) ) end
		if ( LootTarget.distance > 130 ) then
			if ( wt_core_state_idle.DebugModes.LootChest.Master and wt_core_state_idle.DebugModes.LootChest.index ~= NextIndex and wt_core_state_idle.DebugModes.LootChest.state == "Moving" ) then wt_core_state_idle.DebugModes.LootChest.index = NextIndex wt_debug( "Idle: moving to loot" ) end
			local TPOS = LootTarget.pos
			Player:MoveTo( TPOS.x, TPOS.y, TPOS.z , 50 )
		elseif ( LootTarget.distance < 100 and NextIndex == Player:GetInteractableTarget() ) then
			Player:StopMoving()
			if ( Player:GetCurrentlyCastedSpell() == 17 ) then
				if ( e_loot_n_index ~= NextIndex ) then
					e_loot_n_index = NextIndex
					wt_debug( "Idle: looting chest" )
				end
				Player:Interact( NextIndex )
			end
		elseif ( LootTarget.distance < 150 ) then
			if ( e_loot_n_index ~= NextIndex ) then
				e_loot_n_index = NextIndex
				wt_debug( "Idle: directly moving to loot chest" )
			end
			local TPOS = LootTarget.pos
			Player:MoveToStraight( TPOS.x, TPOS.y, TPOS.z , 50 )
		end
	else
		wt_error( "Idle: No Chest to Loot found" )
	end
end