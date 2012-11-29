-- The Idle State
-- Check for Buffs/Debuffs
-- Check for Full Inventory
-- Check for Goals
-- ...

-- We inherit from wt_core_state, which gives us: function wt_core_state:run(), function wt_core_state:add( kelement ) and function wt_core_state:register()
wt_core_state_idle = inheritsFrom(wt_core_state)
wt_core_state_idle.name = "Idle"
wt_core_state_idle.kelement_list = { }
wt_core_state_idle.selectedMarkerList = { }
wt_core_state_idle.selectedMarkerIndex = 0

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
	if ( ItemList.freeSlotCount == 0 and wt_global_information.InventoryFull == 1 and wt_global_information.CurrentVendor ~= nil ) then
		return true
	end
	return false
end

function e_vendorcheck:execute()
	wt_core_controller.requestStateChange( wt_core_state_vendoring )
end

------------------------------------------------------------------------------
-- NeedRepair Check Cause & Effect
local c_repaircheck = inheritsFrom( wt_cause )
local e_repaircheck = inheritsFrom( wt_effect )
-- IsEquippmentDamaged() is defined in /gw2lib/wt_utility.lua
function c_repaircheck:evaluate()
	if ( gEnableRepair == "1" and wt_global_information.RepairMerchant ~= nil and IsEquippmentDamaged() ) then
		if ( MapObjectList( "onmesh,nearest,maxdistance=5000,type="..GW2.MAPOBJECTTYPE.RepairMerchant ) ) then
			return true
		end
	end
	return false
end

function e_repaircheck:execute()
	wt_core_controller.requestStateChange( wt_core_state_repair )
end

------------------------------------------------------------------------------
-- Search for Reviveable Targets Cause & Effect
local c_check_revive = inheritsFrom( wt_cause )
local e_revive = inheritsFrom( wt_effect )
local e_revive_move_index = nil -- debug index, no reason to print debug message over and over unless you are debugging it
local e_revive_index = nil -- debug index, no reason to print debug message over and over unless you are debugging it
local debug_e_revive = false -- true == active running debugging on this specific code

function c_check_revive:evaluate()
	local TID = Player:GetInteractableTarget()
	if ( TID ~= nil ) then
		local T = CharacterList:Get( TID )
		if ( T ~= nil ) then
			if ( T.distance < 600 and T.attitude == GW2.ATTITUDE.Friendly and T.healthstate == GW2.HEALTHSTATE.Defeated and T.pos.onmesh ) then
				return true
			end
		end
	end
	if ( e_revive_move_index ~= nil ) then
		e_revive_move_index = nil
	end
	if ( e_revive_index ~= nil ) then
		e_revive_index = nil
	end
	return false
end

function e_revive:execute()
 	local TID = Player:GetInteractableTarget()
	if ( TID ~= nil ) then
		local T = CharacterList:Get( TID )
		if ( T ~= nil ) then
			if ( T.healthstate == GW2.HEALTHSTATE.Defeated and T.attitude == GW2.ATTITUDE.Friendly and T.pos.onmesh ) then
				if ( T.distance > 100 ) then
					if ( not debug_e_revive and e_revive_move_index == nil ) then
						e_revive_move_index = TID
						wt_debug( "Idle: moving to reviveable target..." ..T.distance )
					elseif ( debug_e_revive and e_revive_move_index ~= nil ) then
						wt_debug( "Idle: moving to reviveable target..." ..T.distance )
					end
					Player:MoveTo( T.pos.x, T.pos.y,T.pos.z , 80 )
				elseif( T.distance < 100 ) then
					Player:StopMoving()
					if ( Player:GetCurrentlyCastedSpell() == 17 ) then
						if ( not debug_e_revive and e_revive_index == nil ) then
							e_revive_index = TID
							wt_debug( "Idle: reviving..." )
						elseif ( debug_e_revive and e_revive_index ~= nil ) then
							wt_debug( "Idle: reviving..." )
						end
						Player:Interact( TID )
					end
				end
			end
		end
	else
		wt_error( "Idle: No Target to revive" )
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
		c_check_loot.EList = CharacterList( "nearest,lootable,onmesh,maxdistance=1200" )
		if ( TableSize( c_check_loot.EList ) > 0 ) then
			return true
		end
	end
	return false
end

e_loot.throttle = math.random( 500, 1500 )
e_loot.delay = math.random( 100, 500 )
function e_loot:execute()
	if ( e_loot_t_size ~= TableSize( c_check_loot.EList ) ) then
		e_loot_t_size = TableSize( c_check_loot.EList )
		wt_debug( "Idle: loottable size " .. TableSize( c_check_loot.EList ) )
	end
	local NextIndex = 0
	local LootTarget = nil
	NextIndex, LootTarget = next( c_check_loot.EList )
	if ( NextIndex ~= nil ) then
		if ( LootTarget.distance > 130 ) then
			if ( e_loot_n_index ~= NextIndex ) then
				e_loot_n_index = NextIndex
				wt_debug( "Idle: moving to loot" )
			end
			Player:MoveTo( LootTarget.pos.x, LootTarget.pos.y, LootTarget.pos.z , 0 )
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
			Player:MoveToStraight( LootTarget.pos.x, LootTarget.pos.y, LootTarget.pos.z , 0 )
		end
	else
		wt_error( "Idle: No Target to Loot" )
	end
end

------------------------------------------------------------------------------
-- Gatherbale Cause & Effect
local c_check_gatherable = inheritsFrom( wt_cause )
local e_gather = inheritsFrom( wt_effect )
c_check_gatherable.GatherTargetTime = 0
local e_gather_d_index = nil -- debug index, no reason to print debug message over and over unless you are debugging it
local e_gather_d = false -- true == active running debugging on this specific code

function c_check_gatherable:evaluate()

	if ( c_check_gatherable.GatherTargetID ~= nil and wt_global_information.Now - c_check_gatherable.GatherTargetTime < 2000 ) then
		return true
	end

	if ( ItemList.freeSlotCount > 0 ) then
		c_check_gatherable.EList = GadgetList( "onmesh,shortestpath,gatherable,maxdistance=4000" )
		if ( TableSize( c_check_gatherable.EList ) > 0 ) then
			local GatherTarget = nil
			local resourceType = nil
			c_check_gatherable.GatherTargetID, GatherTarget = next( c_check_gatherable.EList )
			return true
		else
			c_check_gatherable.GatherTargetID = nil
		end
	end
	return false
end

e_gather.throttle = 250
function e_gather:execute()
	local NextIndex = c_check_gatherable.GatherTargetID
	local GatherTarget = GadgetList:Get( c_check_gatherable.GatherTargetID )
	if ( GatherTarget ~= nil ) then

		if ( not e_gather_d and e_gather_d_index ~= c_check_gatherable.GatherTargetID ) then
			wt_debug( "Idle: found target to gather" )
		elseif ( e_gather_d and e_gather_d_index == c_check_gatherable.GatherTargetID ) then
			wt_debug( "Idle: found target to gather" )
		end


		if ( GatherTarget.distance > 100 ) then
			if ( not e_gather_d and e_gather_d_index ~= c_check_gatherable.GatherTargetID ) then
				wt_debug( "Idle: moving to gatherable..." ..GatherTarget.distance )
			elseif ( e_gather_d and e_gather_d_index == c_check_gatherable.GatherTargetID ) then
				wt_debug( "Idle: moving to gatherable..." ..GatherTarget.distance )
			end
			Player:MoveTo( GatherTarget.pos.x, GatherTarget.pos.y, GatherTarget.pos.z ,50 )
		elseif ( GatherTarget.distance <= 100 ) then
			Player:StopMoving()
			if ( Player:GetCurrentlyCastedSpell() == 17 ) then
				wt_debug( "Idle: gathering..." )
				Player:Use( NextIndex )
			end
		end
		e_gather_d_index = c_check_gatherable.GatherTargetID
	else
		c_check_gatherable.GatherTargetID = nil
		wt_error( "Idle: No Target to gather" )
	end
end

------------------------------------------------------------------------------
-- Search for Targets Cause & Effect
local c_check_target = inheritsFrom( wt_cause )
local e_targetsearch = inheritsFrom( wt_effect )

function c_check_target:evaluate()
	local TargetID = Player:GetTarget()
	local Target = nil
	if ( TargetID ~= 0 ) then
		Target = CharacterList:Get( TargetID )
	end
	if ( Target == nil or not Target.alive ) then
		c_check_target.TargetList = ( CharacterList( "shortestpath,onmesh,noCritter,attackable,alive,maxdistance=2000,maxlevel="..( Player.level + wt_global_information.AttackEnemiesLevelMaxRangeAbovePlayerLevel ) ) )
		return TableSize( c_check_target.TargetList ) > 0
	end
	return false
end

function e_targetsearch:execute()
	nextTarget, E  = next( c_check_target.TargetList )
	if ( nextTarget ~= nil ) then
		wt_debug( "Idle: Begin Combat, Found target "..nextTarget )
		e_marker_d_index = nil
		Player:StopMoving()
		wt_core_state_combat.setTarget( nextTarget )
		wt_core_controller.requestStateChange( wt_core_state_combat )
	end
end

------------------------------------------------------------------------------
-- Search for NextMarker Cause & Effect
local c_marker = inheritsFrom( wt_cause )
local e_marker = inheritsFrom( wt_effect )
local e_marker_d_index = nil -- debug index, no reason to print debug message over and over unless you are debugging it
local e_marker_d = false -- true == active running debugging on this specific code

function c_marker:evaluate()
	if ( wt_global_information.CurrentMarkerList == nil or MarkersNeedUpdate() ) then
		wt_debug( "Idle: Updating MarkerList" )
		wt_global_information.CurrentMarkerList = MarkerList()
		wt_global_information.SelectedMarker = nil
		wt_core_state_idle.selectedMarkerList = nil
	end
	local distance = 0

	if ( wt_global_information.SelectedMarker ~= nil ) then
		distance =  Distance3D( wt_global_information.SelectedMarker.x, wt_global_information.SelectedMarker.y, wt_global_information.SelectedMarker.z, Player.pos.x, Player.pos.y, Player.pos.z )
		if ( distance <= 150 ) then
			wt_global_information.SelectedMarker = nil
		end
	end
	return ( TableSize( wt_global_information.CurrentMarkerList ) > 0 and ( wt_global_information.SelectedMarker == nil or distance > 150 ) )
end

function e_marker:execute()
	UpdateNextMarker()
	if ( wt_global_information.SelectedMarker ~= nil ) then
		if ( not e_marker_d and e_marker_d_index ~= wt_global_information.SelectedMarker ) then
			wt_debug( "Idle: Walking towards Next Marker ".. tostring( wt_core_state_idle.selectedMarkerList[wt_core_state_idle.selectedMarkerIndex].name ) )
		elseif ( e_marker_d and e_marker_d_index == wt_global_information.SelectedMarker ) then
				wt_debug( "Idle: Walking towards Next Marker ".. tostring( wt_core_state_idle.selectedMarkerList[wt_core_state_idle.selectedMarkerIndex].name ) )
		end
		e_marker_d_index = wt_global_information.SelectedMarker
		Player:MoveTo( wt_global_information.SelectedMarker.x, wt_global_information.SelectedMarker.y, wt_global_information.SelectedMarker.z, 150 )
	end
end

------------------------------------------------------------------------------
-- Marker-Navigation Logic
function UpdateNextMarker()
	if ( wt_global_information.SelectedMarker == nil or Distance3D( wt_global_information.SelectedMarker.x, wt_global_information.SelectedMarker.y, wt_global_information.SelectedMarker.z, Player.pos.x, Player.pos.y, Player.pos.z ) < 450 ) then
		if ( wt_core_state_idle.selectedMarkerList == nil or ( #wt_core_state_idle.selectedMarkerList <= wt_core_state_idle.selectedMarkerIndex ) or ( wt_core_state_idle.selectedMarkerList[wt_core_state_idle.selectedMarkerIndex] ~= nil and Player.level > wt_core_state_idle.selectedMarkerList[wt_core_state_idle.selectedMarkerIndex].maxlevel ) ) then
			wt_debug( "Idle: Generating new MarkerList for our Level" )
			if ( wt_global_information.CurrentMarkerList ~= nil ) then
				wt_core_state_idle.selectedMarkerList = { }
				nextMarker, v = next( wt_global_information.CurrentMarkerList )
				while ( nextMarker ~= nil ) do
					if ( v ~= wt_global_information.SelectedMarker and Distance3D( v.x, v.y, v.z, Player.pos.x, Player.pos.y, Player.pos.z ) > 250 and ( Player.level >= v.minlevel and Player.level <= v.maxlevel ) ) then
						table.insert( wt_core_state_idle.selectedMarkerList, v )
					end
				   nextMarker, v = next( wt_global_information.CurrentMarkerList, nextMarker )
				end
				wt_core_state_idle.selectedMarkerIndex = 0
			else
				wt_error( "Idle: CurrentMarkerList is empty!" )
			end
		else
			if ( #wt_core_state_idle.selectedMarkerList > wt_core_state_idle.selectedMarkerIndex ) then
				wt_debug( "Idle: Selecting next Marker" )
				wt_core_state_idle.selectedMarkerIndex = wt_core_state_idle.selectedMarkerIndex + 1
				wt_global_information.SelectedMarker = wt_core_state_idle.selectedMarkerList[wt_core_state_idle.selectedMarkerIndex]
				if ( e_marker_d ) then
					wt_debug( wt_core_state_idle.selectedMarkerList[wt_core_state_idle.selectedMarkerIndex] )
				end
			end
		end
	end
end



function wt_core_state_idle:initialize()

	local ke_died = wt_kelement:create( "Died", c_died, e_died, wt_effect.priorities.interrupt )
	wt_core_state_idle:add( ke_died )

	local ke_quickloot = wt_kelement:create( "QuickLoot", c_quickloot, e_quickloot, 110 )
	wt_core_state_idle:add( ke_quickloot )

	local ke_aggro = wt_kelement:create( "AggroCheck", c_aggro, e_aggro, 100 )
	wt_core_state_idle:add( ke_aggro )

	local ke_deposit = wt_kelement:create( "DepositItems", c_deposit, e_deposit, 90 )
	wt_core_state_idle:add( ke_deposit )

	local ke_vendorcheck = wt_kelement:create( "VendoringCheck", c_vendorcheck, e_vendorcheck, 88 )
	wt_core_state_idle:add( ke_vendorcheck )

	local ke_repaircheck = wt_kelement:create( "RepairCheck", c_repaircheck, e_repaircheck, 86 )
	wt_core_state_idle:add( ke_repaircheck )

	local ke_revive = wt_kelement:create( "Revive", c_check_revive, e_revive, 85 )
	wt_core_state_idle:add( ke_revive )

	local ke_rest = wt_kelement:create( "Rest", c_rest, e_rest, 75 )
	wt_core_state_idle:add( ke_rest )

	local ke_loot = wt_kelement:create(" Loot", c_check_loot, e_loot, 50 )
	wt_core_state_idle:add( ke_loot )

	local ke_gather = wt_kelement:create( "Gather", c_check_gatherable, e_gather, 40 )
	wt_core_state_idle:add( ke_gather )

	local ke_targetsearch = wt_kelement:create( "Targetsearch", c_check_target, e_targetsearch, 30 )
	wt_core_state_idle:add( ke_targetsearch )

	local ke_marker= wt_kelement:create( "Marker", c_marker, e_marker, 20 )
	wt_core_state_idle:add( ke_marker )

end

-- setup kelements for the state
wt_core_state_idle:initialize()
-- register the State with the system
wt_core_state_idle:register()
