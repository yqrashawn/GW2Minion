-- The Idle State
-- Check for Buffs/Debuffs
-- Check for Full Inventory
-- Check for Goals
-- ...

-- We inherit from wt_core_state, which gives us: function wt_core_state:run(), function wt_core_state:add( kelement ) and function wt_core_state:register()
wt_core_state_idle = inheritsFrom(wt_core_state)
wt_core_state_idle.name = "Idle"
wt_core_state_idle.kelement_list = { }

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
		if ( MapObjectList( "onmesh,nearest,type="..GW2.MAPOBJECTTYPE.RepairMerchant ) ) then
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
			if ( T.distance < 600 and T.attitude == GW2.ATTITUDE.Friendly and T.healthstate == GW2.HEALTHSTATE.Defeated and T.onmesh ) then
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
			if ( T.healthstate == GW2.HEALTHSTATE.Defeated and T.attitude == GW2.ATTITUDE.Friendly and T.onmesh ) then
				if ( T.distance > 100 ) then
					if ( not debug_e_revive and e_revive_move_index == nil ) then
						e_revive_move_index = TID
						wt_debug( "Idle: moving to reviveable target..." ..T.distance )
					elseif ( debug_e_revive and e_revive_move_index ~= nil ) then
						wt_debug( "Idle: moving to reviveable target..." ..T.distance )
					end
					local TPOS = T.pos
					Player:MoveTo( TPOS.x, TPOS.y, TPOS.z , 80 )
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
		c_check_gatherable.EList = GadgetList( "onmesh,shortestpath,gatherable,maxdistance="..wt_global_information.MaxGatherDistance )
		if ( TableSize( c_check_gatherable.EList ) > 0 ) then			
			local nextTarget
			nextTarget, GatherTarget = next( c_check_gatherable.EList )
			if ( nextTarget ~= nil and nextTarget ~= 0) then
				return true
			end		
		end
	end
	return false
end

e_gather.throttle = 250
function e_gather:execute()
	if ( TableSize(c_check_gatherable.EList) > 0 ) then
		local nextTarget 
		nextTarget , E  = next(c_check_gatherable.EList)
		if (nextTarget ~=nil and nextTarget ~= 0) then
			wt_debug("Gatherable Target found..")
			wt_core_state_gathering.setTarget(nextTarget)
			wt_core_controller.requestStateChange(wt_core_state_gathering)
		end
	end
end


------------------------------------------------------------------------------
-- Do Tasks Cause & Effect
local c_dotask = inheritsFrom( wt_cause )
local e_dotask = inheritsFrom( wt_effect )

function c_dotask:evaluate()	
	return true
end

function e_dotask:execute()
	wt_core_taskmanager:DoTask()
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

	local ke_loot = wt_kelement:create("Loot", c_check_loot, e_loot, 50 )
	wt_core_state_idle:add( ke_loot )

	local ke_gather = wt_kelement:create( "Gather", c_check_gatherable, e_gather, 40 )
	wt_core_state_idle:add( ke_gather )

	local ke_dotasks = wt_kelement:create( "DoTask", c_dotask, e_dotask, 35 )
	wt_core_state_idle:add( ke_dotasks )
	
end

-- setup kelements for the state
wt_core_state_idle:initialize()
-- register the State with the system
wt_core_state_idle:register()
