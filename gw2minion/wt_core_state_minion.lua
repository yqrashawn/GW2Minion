-- The Minion's Minion State ;)

wt_core_state_minion = inheritsFrom(wt_core_state)
wt_core_state_minion.name = "Beeing a Minion"
wt_core_state_minion.kelement_list = { }
wt_core_state_minion.LeaderGroupIndex = nil 
 
 
------------------------------------------------------------------------------
------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Aggro Cause & Effect
local mc_aggro = inheritsFrom( wt_cause )
local me_aggro = inheritsFrom( wt_effect )

function mc_aggro:evaluate()
	mc_aggro.TargetList = ( CharacterList( "nearest,los,attackable,alive,noCritter,onmesh,maxdistance="..wt_global_information.MaxAggroDistanceClose ) )
	if ( TableSize( mc_aggro.TargetList ) > 0 ) then
		return true
	end
	
	local party = Player:GetPartyMembers()
	if (party ~= nil and gLeaderIndex ~= nil and tonumber(gLeaderIndex) <= #party) then
		leader = party[tonumber(gLeaderIndex)]
		if (leader ~= nil and leader.inCombat and leader.distance < wt_global_information.MaxAggroDistanceClose) then
			mc_aggro.TargetList = ( CharacterList( "nearest,los,attackable,alive,noCritter,onmesh,maxdistance="..wt_global_information.MaxAggroDistanceFar ) )
			if ( TableSize( mc_aggro.TargetList ) > 0 ) then
				return true
			end
		end
	end
	
	return false
end

function me_aggro:execute()
	if ( TableSize( mc_aggro.TargetList ) > 0 ) then
		nextTarget, E  = next( mc_aggro.TargetList )
		if ( nextTarget ~= nil ) then
			wt_debug( "Begin Combat, Possible aggro target found" )
			wt_core_state_combat.setTarget( nextTarget )
			wt_core_controller.requestStateChange( wt_core_state_combat )
		end
	end
end

------------------------------------------------------------------------------
-- DepositItems Cause & Effect
local c_deposit = inheritsFrom( wt_cause )
local e_deposit = inheritsFrom( wt_effect )

function c_deposit:evaluate()
	if ( ItemList.freeSlotCount == 0 ) then
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
	if ( ItemList.freeSlotCount == 0 and wt_global_information.InventoryFull == 1 and wt_global_information.HasVendor ) then
		c_vendorcheck.EList = MapObjectList( "onmesh,nearest,type="..GW2.MAPOBJECTTYPE.Merchant )
		if ( TableSize( c_vendorcheck.EList ) > 0 ) then
			local nextTarget
			nextTarget, E = next( c_vendorcheck.EList )
			if ( nextTarget ~= nil and nextTarget ~= 0 ) then
				return true
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
		c_check_gatherable.EList = GadgetList( "onmesh,shortestpath,gatherable,maxdistance=750" )
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
-- Follow Leader Cause & Effect
local c_followLead = inheritsFrom( wt_cause )
local e_followLead = inheritsFrom( wt_effect )

function c_followLead:evaluate()
	local party = Player:GetPartyMembers()
		if (party ~= nil and gLeaderIndex ~= nil and tonumber(gLeaderIndex) <= #party) then
			local leader = party[tonumber(gLeaderIndex)]
			if (leader ~= nil) then
				if ((leader.distance > 500 or leader.los~=true) and leader.onmesh) then
					return true
				elseif (leader.inCombat and not Player.inCombat and leader.distance > 200 and leader.onmesh) then
					return true
				end				
			end
		else
			wt_debug( "Leader is not in the same map right now? " )
		end		
	return false
end

e_followLead.throttle = math.random( 500, 1000 )
function e_followLead:execute()
	local party = Player:GetPartyMembers()
	if (party ~= nil and gLeaderIndex ~= nil and tonumber(gLeaderIndex) <= #party) then
		local leader = party[tonumber(gLeaderIndex)]
		if (leader ~= nil) then
			Player:MoveTo(leader.pos.x,leader.pos.y,leader.pos.z,math.random( 20, 300 ))
		end
	end
end
 
  
 
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- iAmMinion Cause & Effect fpr the idle state
local c_iamminion = inheritsFrom( wt_cause )
local e_iamminion = inheritsFrom( wt_effect )

function c_iamminion:evaluate()
	if (gMinionEnabled == "1") then
		local party = Player:GetPartyMembers()
		if (party ~= nil and gLeaderIndex ~= nil and tonumber(gLeaderIndex) <= #party) then
			member = party[tonumber(gLeaderIndex)]
			if (member ~= nil) then			
				return true
			end
		end
		wt_debug( "Can't switch to MinionMode, Leader is not in the same map?" )
	end	
	return false
end

function e_iamminion:execute()
	wt_debug( "Switching to MinionMode" )
	wt_core_controller.requestStateChange( wt_core_state_minion )
end

-------------------------------------------------------------
function wt_core_state_minion.GUIVarUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		if ( k == "gMinionEnabled" or k == "gLeaderIndex") then
			Settings.GW2MINION[tostring(k)] = v
		end
	end
end

function wt_core_state_minion:HandleInit() 
	GUI_NewSeperator(wt_global_information.MainWindow.Name);
	GUI_NewLabel(wt_global_information.MainWindow.Name,"This is an alpha version;)","GroupBotting");
	GUI_NewLabel(wt_global_information.MainWindow.Name,"Enter number 0-4 who the leader is, then press Start","GroupBotting");
	GUI_NewCheckbox(wt_global_information.MainWindow.Name,"I am a Minion","gMinionEnabled","GroupBotting");
	GUI_NewField(wt_global_information.MainWindow.Name,"Leader is Member Nr.","gLeaderIndex","GroupBotting");
	
	gMinionEnabled = Settings.GW2MINION.gMinionEnabled
	gLeaderIndex = Settings.GW2MINION.gLeaderIndex
	
	-- Add to other states only after all files have been loaded
	local ke_iamminion = wt_kelement:create( "Minion", c_iamminion, e_iamminion, 250 )
	wt_core_state_idle:add( ke_iamminion )
	
end

function wt_core_state_minion:initialize()

	-- State GUI Options
	if ( Settings.GW2MINION.gMinionEnabled == nil ) then
		Settings.GW2MINION.gMinionEnabled = "0"
	end
	if ( Settings.GW2MINION.gLeaderIndex == nil ) then
		Settings.GW2MINION.gLeaderIndex = "0"
	end

	RegisterEventHandler("Module.Initalize",wt_core_state_minion.HandleInit)
	RegisterEventHandler("GUI.Update",wt_core_state_minion.GUIVarUpdate)

	
	-- State C&E
	local ke_died = wt_kelement:create( "Died", c_died, e_died, wt_effect.priorities.interrupt )
	wt_core_state_minion:add( ke_died )

	local ke_quickloot = wt_kelement:create( "QuickLoot", c_quickloot, e_quickloot, 110 )
	wt_core_state_minion:add( ke_quickloot )

	local ke_maggro = wt_kelement:create( "AggroCheck", mc_aggro, me_aggro, 100 )
	wt_core_state_minion:add( ke_maggro )
	
	local ke_deposit = wt_kelement:create( "DepositItems", c_deposit, e_deposit, 90 )
	wt_core_state_minion:add( ke_deposit )
	
	local ke_vendorcheck = wt_kelement:create( "VendoringCheck", c_vendorcheck, e_vendorcheck, 88 )
	wt_core_state_minion:add( ke_vendorcheck )

	local ke_repaircheck = wt_kelement:create( "RepairCheck", c_repaircheck, e_repaircheck, 86 )
	wt_core_state_minion:add( ke_repaircheck )

	local ke_revive = wt_kelement:create( "Revive", c_check_revive, e_revive, 80 )
	wt_core_state_minion:add( ke_revive )

	local ke_rest = wt_kelement:create( "Rest", c_rest, e_rest, 75 )
	wt_core_state_minion:add( ke_rest )
	
	local ke_loot = wt_kelement:create("Loot", c_check_loot, e_loot, 50 )
	wt_core_state_minion:add( ke_loot )

	local ke_gather = wt_kelement:create( "Gather", c_check_gatherable, e_gather, 40 )
	wt_core_state_minion:add( ke_gather )
	
	local ke_sticktoleader = wt_kelement:create( "Follow Leader", c_followLead, e_followLead, 20 )
	wt_core_state_minion:add( ke_sticktoleader )
	
end

wt_core_state_minion:initialize()
wt_core_state_minion:register()