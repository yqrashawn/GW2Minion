-- The Minion's Minion State ;)

wt_core_state_minion = inheritsFrom(wt_core_state)
wt_core_state_minion.name = "Beeing a Minion"
wt_core_state_minion.kelement_list = { } 
wt_core_state_minion.LeaderID = nil
wt_core_state_minion.FocusTarget = nil
wt_core_state_minion.PartyAggroTargets = {}
wt_core_state_minion.MinionNeedsVendor = false


------------------------------------------------------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Check the Multibot-Serverconnection Cause & Effect
local c_server = inheritsFrom( wt_cause )
local e_server = inheritsFrom( wt_effect )

function c_server:evaluate()
	if ( gMinionEnabled == "1" and not MultiBotIsConnected( ) ) then		
		return true
	end	
	return false
end
e_server.throttle = 1000
function e_server:execute()
	wt_debug("Trying to connect to MultibotComServer....")
	if ( not MultiBotConnect( gIP , tonumber(gPort) , gPw) ) then
		wt_debug("Cannot reach MultibotComServer... Make sure you have started the MultibotComServer.exe and the correct password!")
	else
		if ( not MultiBotJoinChannel( "gw2minion" ) ) then
			wt_debug("Cannot join gw2minion channel...bug?")
		end
	end	
end


------------------------------------------------------------------------------
-- Set this clients role Cause & Effect
local c_setrole = inheritsFrom( wt_cause )
local e_setrole = inheritsFrom( wt_effect )
c_setrole.askedCounter = 0

function c_setrole:evaluate()
	if ( MultiBotIsConnected( ) and wt_core_state_minion.LeaderID == nil ) then	
		return true
	end	
	return false
end
e_setrole.throttle = 1000
function e_setrole:execute()	
	if ( c_setrole.askedCounter < 3 ) then
		wt_debug("Asking for our Role..")
		c_setrole.askedCounter = c_setrole.askedCounter + 1
		MultiBotSend( "1;none","gw2minion" )
	else
		wt_debug("Setting our Role to Leader & telling others..")
		c_setrole.askedCounter = 0
		wt_core_state_minion.LeaderID = Player.characterID
		MultiBotSend( "2;"..Player.characterID,"gw2minion" )
	end
end

-- Aggro is in wt_common_causes

------------------------------------------------------------------------------
-- DepositItems Cause & Effect
local c_deposit = inheritsFrom( wt_cause )
local e_deposit = inheritsFrom( wt_effect )

function c_deposit:evaluate()
	if ( ItemList.freeSlotCount <= 2 ) then
		if ( wt_global_information.InventoryFull == 0 ) then
			return true
		else
			return false -- already tried to deposit stuff, still have 0 space in inventory -> vendoringcheck will jump in
		end
	else
		wt_global_information.InventoryFull = 0
	end
	return false
end
e_deposit.throttle = 500
function e_deposit:execute()
	wt_debug( "Idle: Deposing Collectables.." )
	wt_global_information.InventoryFull = 1
	Inventory:DepositCollectables()
end

 ------------------------------------------------------------------------------
-- Vendoring Check Cause & Effect
local c_vendorcheck = inheritsFrom( wt_cause )
local e_vendorcheck = inheritsFrom( wt_effect )

function c_vendorcheck:evaluate()
	if ( ((ItemList.freeSlotCount <= 2 and wt_global_information.InventoryFull == 1) or (wt_core_state_minion.MinionNeedsVendor)) and wt_global_information.HasVendor ) then
		c_vendorcheck.EList = MapObjectList( "onmesh,nearest,type="..GW2.MAPOBJECTTYPE.Merchant )
		if ( TableSize( c_vendorcheck.EList ) > 0 ) then
			local nextTarget
			nextTarget, E = next( c_vendorcheck.EList )
			if ( nextTarget ~= nil and nextTarget ~= 0 ) then
				if ( gMinionstick == "1" and wt_core_state_minion.LeaderID ~= nil and wt_core_state_minion.LeaderID ~= Player.characterID ) then 
					-- we are follower, Tell leader we need to vendor
					MultiBotSend( "10;none","gw2minion" )
					return true
				else -- we are leader
					return true
				end
			else
				wt_global_information.HasVendor = false
			end
		end
	end
	return false
end

function e_vendorcheck:execute()
	if ( TableSize( c_vendorcheck.EList ) > 0 ) then
		local nextTarget
		nextTarget, E  = next( c_vendorcheck.EList )
		if ( nextTarget ~=nil and nextTarget ~= 0 ) then
			wt_debug( "Merchant on NavMesh found.." )
			wt_core_state_vendoring.setTarget( nextTarget )
			wt_core_controller.requestStateChange( wt_core_state_vendoring )
		end
	end
end

------------------------------------------------------------------------------
-- NeedRepair Check Cause & Effect
local c_repaircheck = inheritsFrom( wt_cause )
local e_repaircheck = inheritsFrom( wt_effect )
-- IsEquippmentDamaged() is defined in /gw2lib/wt_utility.lua
function c_repaircheck:evaluate()
	if ( gEnableRepair == "1" and wt_global_information.HasRepairMerchant and IsEquippmentDamaged() ) then
		c_repaircheck.EList = MapObjectList( "onmesh,maxdistance=5000,type="..GW2.MAPOBJECTTYPE.RepairMerchant )
		if ( TableSize( c_repaircheck.EList ) > 0 ) then
			local nextTarget
			nextTarget, E = next( c_repaircheck.EList )
			if ( nextTarget ~= nil and nextTarget ~= 0 ) then
				return true
			else
				wt_global_information.HasRepairMerchant = false
			end
		end
	end
	return false
end

function e_repaircheck:execute()
	if ( TableSize( c_repaircheck.EList ) > 0 ) then
		local nextTarget
		nextTarget, E  = next( c_repaircheck.EList )
		if (nextTarget ~= nil and nextTarget ~= 0 ) then
			wt_debug( "RepairMerchant on NavMesh found.." )
			wt_core_state_repair.setTarget( nextTarget )
			wt_core_controller.requestStateChange( wt_core_state_repair )
		end
	end
end


------------------------------------------------------------------------------
-- Search for Reviveable Partymembers Cause & Effect
local c_check_revivep = inheritsFrom( wt_cause )
local e_revivep = inheritsFrom( wt_effect )
c_check_revivep.ID = nil

function c_check_revivep:evaluate()
	local party = Player:GetPartyMembers()
	if (party ~= nil and wt_core_state_minion.LeaderID ~= nil) then
		local index, player  = next( party )
		while ( index ~= nil and player ~= nil ) do			
			if (player.distance < 3000 and player.healthstate == GW2.HEALTHSTATE.Defeated and player.onmesh) then
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
			if ( T.healthstate == GW2.HEALTHSTATE.Defeated and T.onmesh ) then
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
  
  
 ------------------------------------------------------------------------------
-- Search for Reviveable Targets Cause & Effect
local c_check_revive = inheritsFrom( wt_cause )
local e_revive = inheritsFrom( wt_effect )

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


---------------------------------------------------------------------
-- Rest(party) Cause & Effect
local c_restp = inheritsFrom( wt_cause )
local e_restp = inheritsFrom( wt_effect )

function c_restp:evaluate()
	local HP = Player.health.percent
	if ( HP < wt_global_information.Currentprofession.RestHealthLimit ) then
		return true
	end
	-- leader checks on minions
	if (wt_core_state_minion.LeaderID ~= nil and wt_core_state_minion.LeaderID == Player.characterID ) then 
		local party = Player:GetPartyMembers()
		if (party ~= nil) then
			local index, player  = next( party )
			while ( index ~= nil and player ~= nil ) do			
				if (player.distance < 3500 and player.alive and player.onmesh and player.health.percent < wt_global_information.Currentprofession.RestHealthLimit ) then					
					return true
				end
				index, player  = next( party,index )
			end		
		end
	end
	return false
end

e_restp.throttle = math.random( 500, 2500 )
function e_restp:execute()
	local HP = Player.health.percent
	if ( HP < wt_global_information.Currentprofession.RestHealthLimit ) then
		local s6 = Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_6 )
		if( Player:GetCurrentlyCastedSpell() == 17 and Player.health.percent < 65 and not Player:IsSpellOnCooldown( GW2.SKILLBARSLOT.Slot_6 ) ) then
			if ( c_rest_heal ) then
				c_rest_heal = not c_rest_heal
				if ( s6 ~= nil ) then
					wt_debug( "Using "..tostring( s6.name ).." to heal ("..Player.health.percent.."%)" )
				end
			end
			Player:CastSpell( GW2.SKILLBARSLOT.Slot_6 )
		end
	end
	if (wt_core_state_minion.LeaderID ~= nil and wt_core_state_minion.LeaderID == Player.characterID ) then 
		local party = Player:GetPartyMembers()
		if (party ~= nil) then
			local index, player  = next( party )
			while ( index ~= nil and player ~= nil ) do			
				if (player.distance > 1000 and player.alive and player.onmesh and player.health.percent < wt_global_information.Currentprofession.RestHealthLimit ) then					
					local pos = player.pos
					Player:MoveTo(pos.x,pos.y,pos.z,math.random( 20, 100 ))
				end
				index, player  = next( party,index )
			end		
		end
	end
	return
end

 ------------------------------------------------------------------------------
-- Loot Cause & Effect
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

e_loot.throttle = math.random( 500, 1500 )
e_loot.delay = math.random( 100, 500 )
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
-- Gatherbale Cause & Effect
local c_check_gatherable = inheritsFrom( wt_cause )
local e_gather = inheritsFrom( wt_effect )

function c_check_gatherable:evaluate()
	if ( ItemList.freeSlotCount > 0 ) then
		if (wt_core_state_minion.LeaderID ~= nil and wt_core_state_minion.LeaderID == Player.characterID ) then
			c_check_gatherable.EList = GadgetList( "onmesh,shortestpath,gatherable,maxdistance="..wt_global_information.MaxGatherDistance )
		else
			c_check_gatherable.EList = GadgetList( "onmesh,shortestpath,gatherable,maxdistance=850" )
		end
		if ( TableSize( c_check_gatherable.EList ) > 0 ) then
			local nextTarget
			nextTarget, GatherTarget = next( c_check_gatherable.EList )
			if ( nextTarget ~= nil and nextTarget ~= 0 ) then
				return true
			end
		end
	end
	return false
end

e_gather.throttle = 250
function e_gather:execute()
	if ( TableSize( c_check_gatherable.EList ) > 0 ) then
		local nextTarget
		nextTarget, E  = next( c_check_gatherable.EList )
		if ( nextTarget ~= nil and nextTarget ~= 0 ) then
			wt_debug( "Gatherable Target found.." )
			wt_core_state_gathering.setTarget( nextTarget )
			wt_core_controller.requestStateChange( wt_core_state_gathering )
		end
	end
end

------------------------------------------------------------------------------
-- NoLeader Cause & Effect
local c_noleader = inheritsFrom( wt_cause )
local e_noleader = inheritsFrom( wt_effect )

function c_noleader:evaluate()
	if (wt_core_state_minion.LeaderID ~= nil and wt_core_state_minion.LeaderID ~= Player.characterID) then
		local party = Player:GetPartyMembers()
		if (party ~= nil) then
			local leader = party[tonumber(wt_core_state_minion.LeaderID)]
			if (leader == nil) then
				return true
			end		
		end	
	end
	return false
end

e_noleader.throttle = math.random( 1000, 3000 )
function e_noleader:execute()
	wt_debug( "Leader is not in the same map right now?" )
	wt_debug( "Resetting leader.." )
	wt_core_state_minion.LeaderID = nil
	wt_core_controller.requestStateChange( wt_core_state_idle )
end

------------------------------------------------------------------------------
-- Follow Leader Cause & Effect
local c_followLead = inheritsFrom( wt_cause )
local e_followLead = inheritsFrom( wt_effect )

function c_followLead:evaluate()
	if (wt_core_state_minion.LeaderID ~= nil and wt_core_state_minion.LeaderID ~= Player.characterID) then
		local party = Player:GetPartyMembers()
		if (party ~= nil) then
			local leader = party[tonumber(wt_core_state_minion.LeaderID)]
			if (leader ~= nil) then
				if ((leader.distance > math.random( 50, 500 ) or leader.los~=true) and leader.onmesh) then
					return true
				end				
			else
				wt_debug( "YOU ARE NOT IN A PARTY WITH THE LEADER! JOIN A PARTY!" )
			end		
		end
	end
	return false
end

e_followLead.throttle = math.random( 250, 1000 )
function e_followLead:execute()
	local party = Player:GetPartyMembers()
	if (party ~= nil and wt_core_state_minion.LeaderID ~= nil) then
		local leader = party[tonumber(wt_core_state_minion.LeaderID)]
		if (leader ~= nil) then
			local pos = leader.pos
			--TODO: Getmovementstate of leader, adopt range accordingly
			Player:MoveTo(pos.x,pos.y,pos.z,math.random( 20, 350 ))
		end
	end
end
 
------------------------------------------------------------------------------
-- Lead Group Cause & Effect
local c_lead = inheritsFrom( wt_cause )
local e_lead = inheritsFrom( wt_effect )

function c_lead:evaluate()
	if (wt_core_state_minion.LeaderID ~= nil and wt_core_state_minion.LeaderID == Player.characterID) then
		return true
	end
	return false
end

function e_lead:execute()
	wt_core_taskmanager:DoTask()
end
 
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- iAmMinion Cause & Effect fpr the idle state
local c_iamminion = inheritsFrom( wt_cause )
local e_iamminion = inheritsFrom( wt_effect )

function c_iamminion:evaluate()
	if (gMinionEnabled == "1") then		
		return true
	elseif (MultiBotIsConnected( )) then
		MultiBotDisconnect( )
	end	
	return false
end

function e_iamminion:execute()
	wt_debug( "Switching to GroupbottingMode" )
	wt_core_controller.requestStateChange( wt_core_state_minion )
end


---------------------------------------------------------------------
-- HandleMultiBotMessages
function HandleMultiBotMessages( event, message )
d("MBM:" .. message)
local delimiter = message:find(';')
local msgID = message:sub(0,delimiter-1)
local msg = message:sub(delimiter+1)
--d("msgID:" .. msgID)
--d("msg:" .. msg)
	if (msgID ~= nil and msg ~= nil ) then
		if( tonumber(msgID) == 1 ) then -- Ask for leader
			if ( wt_core_state_minion.LeaderID ~= nil and wt_core_state_minion.LeaderID  == Player.characterID) then
				MultiBotSend( "2;"..Player.characterID,"gw2minion" )
			end
		elseif ( tonumber(msgID) == 2 ) then -- Set Leader
			wt_debug( "New Leader is characterID : "..tonumber(msg) )
			wt_core_state_minion.LeaderID = tonumber(msg)	
		elseif ( tonumber(msgID) == 5 ) then -- Set FocusTarget
			wt_debug( "New FocusTarget is characterID : "..tonumber(msg) )
			wt_core_state_minion.FocusTarget = tonumber(msg)			
		elseif ( tonumber(msgID) == 6 ) then -- Inform leader about party-aggro-target
			local newTarget = CharacterList:Get(tonumber(msg))
			if (newTarget ~= nil and wt_core_state_minion.PartyAggroTargets ~= nil and wt_core_state_minion.PartyAggroTargets[tonumber(msg)] == nil and newTarget.distance < 2500 and newTarget.alive ) then 
				wt_debug( "Adding new PartyAggroTarget to List : "..tonumber(msg) )
				wt_core_state_minion.PartyAggroTargets[tonumber(msg)] = newTarget
			end
		elseif ( tonumber(msgID) == 10 ) then -- A minion needs to Vendor, set our Primary task accordingly
			if ( wt_core_state_minion.LeaderID ~= nil and wt_core_state_minion.LeaderID  == Player.characterID) then
				wt_debug( "Minion needs to vendor, going to Vendor" )
				wt_core_state_minion.MinionNeedsVendor = true
			end
		elseif ( tonumber(msgID) == 11 ) then -- Leader asks if a minion still needs to Vendor
			if ( wt_core_state_minion.LeaderID ~= nil and wt_core_state_minion.LeaderID  ~= Player.characterID and ItemList.freeSlotCount <= 2 and wt_global_information.InventoryFull == 1 and wt_global_information.HasVendor) then
				wt_debug( "We still need to vendor, telling leader.." )
				MultiBotSend( "10;none","gw2minion" )
			end
		end
	end
end

-------------------------------------------------------------
-------------------------------------------------------------
--Group botting general functions
function wt_core_state_minion.GUIVarUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		if ( k == "gMinionEnabled" or k == "gIP" or k == "gPort" or k == "gMinionstick" or k == "gPw") then
			Settings.GW2MINION[tostring(k)] = v
		end
	end
end

function wt_core_state_minion:HandleInit() 
	GUI_NewSeperator(wt_global_information.MainWindow.Name);
	GUI_NewLabel(wt_global_information.MainWindow.Name,"THE HOST NEEDS TO START THE","GroupBotting");
	GUI_NewLabel(wt_global_information.MainWindow.Name,"MultiBotComServer.exe!!","GroupBotting");
	GUI_NewCheckbox(wt_global_information.MainWindow.Name,"Enable","gMinionEnabled","GroupBotting");
	GUI_NewField(wt_global_information.MainWindow.Name,"MultiBotComServer IP","gIP","GroupBotting");
	GUI_NewField(wt_global_information.MainWindow.Name,"MultiBotComServer Port","gPort","GroupBotting");
	GUI_NewField(wt_global_information.MainWindow.Name,"MultiBotComServer Password","gPw","GroupBotting");
	GUI_NewSeperator(wt_global_information.MainWindow.Name);	
	GUI_NewCheckbox(wt_global_information.MainWindow.Name,"Always stick together","gMinionstick","GroupBotting");
	
	gMinionEnabled = Settings.GW2MINION.gMinionEnabled
	gIP = Settings.GW2MINION.gIP
	gPort = Settings.GW2MINION.gPort
	gPw = Settings.GW2MINION.gPw	
	gMinionstick = Settings.GW2MINION.gMinionstick
	 
	
	-- Add to other states only after all files have been loaded
	local ke_iamminion = wt_kelement:create( "GroupMinion", c_iamminion, e_iamminion, 250 )
	wt_core_state_idle:add( ke_iamminion )
	
end

function wt_core_state_minion:initialize()

	-- State GUI Options
	if ( Settings.GW2MINION.gMinionEnabled == nil ) then
		Settings.GW2MINION.gMinionEnabled = "0"
	end
	if ( Settings.GW2MINION.gIP == nil ) then
		Settings.GW2MINION.gIP = "127.0.0.1"
	end
	if ( Settings.GW2MINION.gPort == nil ) then
		Settings.GW2MINION.gPort = "7777"
	end
	if ( Settings.GW2MINION.gMinionstick == nil ) then
		Settings.GW2MINION.gMinionstick = "1"
	end
	if ( Settings.GW2MINION.gPw == nil ) then
		Settings.GW2MINION.gPw = "mypassword"
	end
	
	
	
	RegisterEventHandler("Module.Initalize",wt_core_state_minion.HandleInit)
	RegisterEventHandler("GUI.Update",wt_core_state_minion.GUIVarUpdate)
	RegisterEventHandler("MULTIBOT.Message",HandleMultiBotMessages)
	
	-- State C&E
	local ke_died = wt_kelement:create( "Died", c_died, e_died, wt_effect.priorities.interrupt )
	wt_core_state_minion:add( ke_died )
	
	local ke_checkServer = wt_kelement:create( "CheckServer", c_server, e_server, 450 )
	wt_core_state_minion:add( ke_checkServer )
	
	local ke_setRole = wt_kelement:create( "SetRole", c_setrole, e_setrole, 440 )
	wt_core_state_minion:add( ke_setRole )
		
	local ke_quickloot = wt_kelement:create( "QuickLoot", c_quickloot, e_quickloot, 110 )
	wt_core_state_minion:add( ke_quickloot )

	local ke_maggro = wt_kelement:create( "AggroCheck", c_aggro, e_aggro, 100 )
	wt_core_state_minion:add( ke_maggro )
	
	local ke_deposit = wt_kelement:create( "DepositItems", c_deposit, e_deposit, 90 )
	wt_core_state_minion:add( ke_deposit )
	
	local ke_vendorcheck = wt_kelement:create( "VendoringCheck", c_vendorcheck, e_vendorcheck, 88 )
	wt_core_state_minion:add( ke_vendorcheck )

	local ke_repaircheck = wt_kelement:create( "RepairCheck", c_repaircheck, e_repaircheck, 86 )
	wt_core_state_minion:add( ke_repaircheck )

	local ke_reviveparty = wt_kelement:create( "ReviveParty", c_check_revivep, e_revivep, 83 )
	wt_core_state_minion:add( ke_reviveparty )
	
	local ke_revive = wt_kelement:create( "Revive", c_check_revive, e_revive, 80 )
	wt_core_state_minion:add( ke_revive )

	local ke_restp = wt_kelement:create( "Rest", c_restp, e_restp, 75 )
	wt_core_state_minion:add( ke_restp )
	
	local ke_loot = wt_kelement:create("Loot", c_check_loot, e_loot, 50 )
	wt_core_state_minion:add( ke_loot )

	local ke_gather = wt_kelement:create( "Gather", c_check_gatherable, e_gather, 40 )
	wt_core_state_minion:add( ke_gather )
	
	local ke_noleader = wt_kelement:create( "NoLeader", c_noleader, e_noleader, 30 )
	wt_core_state_minion:add( ke_noleader )
	
	local ke_sticktoleader = wt_kelement:create( "Follow Leader", c_followLead, e_followLead, 20 )
	wt_core_state_minion:add( ke_sticktoleader )
	
	local ke_lead = wt_kelement:create( "Lead", c_lead, e_lead, 10 )
	wt_core_state_minion:add( ke_lead )
	
end

wt_core_state_minion:initialize()
wt_core_state_minion:register()