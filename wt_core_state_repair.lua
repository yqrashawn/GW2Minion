-- The vendoring State
-- Walking towards nearest Merchant n sell and buy stuff

-- We inherit from wt_core_state, which gives us: function wt_core_state:run(), function wt_core_state:add( kelement ) and function wt_core_state:register()
wt_core_state_repair = inheritsFrom( wt_core_state )
wt_core_state_repair.name = "Repairing"
wt_core_state_repair.kelement_list = { }
wt_core_state_repair.repaired = false
wt_core_state_repair.repaircount = 0

------------------------------------------------------------------------------
-- Search for RepairMerchant Cause & Effect
local c_revendorcheck = inheritsFrom(wt_cause)
local e_revendor = inheritsFrom( wt_effect )

function c_revendorcheck:evaluate()
	if ( wt_global_information.RepairMerchant == 0 ) then
		c_revendorcheck.objects = MapObjectList( "onmesh,nearest,type="..GW2.MAPOBJECTTYPE.RepairMerchant )
		if ( TableSize(c_revendorcheck.objects) > 0 ) then
			return true
		else
			wt_global_information.RepairMerchant = nil
		end
	end
	return false
end

function e_revendor:execute()
	if ( TableSize( c_revendorcheck.objects) > 0 ) then
		nextMerchant, E  = next( c_revendorcheck.objects )
		if (nextMerchant ~= nil) then
			wt_debug( "Repair: New RepairMerchant found..ID: "..E.characterID )
			wt_global_information.RepairMerchant = nextMerchant
		end
	end
end

------------------------------------------------------------------------------
-- VendorCheck Cause & Effect
local c_renovendorcheck = inheritsFrom( wt_cause )
local e_renovendor = inheritsFrom( wt_effect )

function c_renovendorcheck:evaluate()
	if ( wt_global_information.RepairMerchant == nil ) then
		return true
	end
	return false
end

function e_renovendor:execute()
	wt_debug( "Repair: WARNING:No RepairMerchant on the NavMesh !" )
	wt_core_state_repair.repaircount = 0
	wt_core_controller.requestStateChange( wt_core_state_idle )
end

------------------------------------------------------------------------------
-- MoveTo Vendor Cause & Effect
local c_removetovendorcheck = inheritsFrom( wt_cause )
local e_removetovendor = inheritsFrom( wt_effect )
local e_removetovendor_index = nil -- debug index, no reason to print debug message over and over unless you are debugging it
local debug_removetovendor = false -- true == active running debugging on this specific code

function c_removetovendorcheck:evaluate()
	if ( wt_global_information.RepairMerchant ~= nil and wt_global_information.RepairMerchant ~= 0 ) then

		local vendor = MapObjectList:Get( wt_global_information.RepairMerchant )
		if ( vendor ~= nil ) then
			e_removetovendor.vpos = vendor.pos
			local ppos = Player.pos
			distance =  Distance3D( e_removetovendor.vpos.x, e_removetovendor.vpos.y, e_removetovendor.vpos.z, ppos.x, ppos.y, ppos.z )
			if ( not debug_removetovendor and e_removetovendor_index == nil ) then
				e_removetovendor_index = vendor.characterID
				wt_debug( "Repair: Vendordist : "..distance )
			elseif ( debug_removetovendor and e_removetovendor_index ~= nil ) then
				wt_debug( "Repair: Vendordist : "..distance )
			end
			if ( distance >= 80 ) then
				return true
			end
		else
			wt_global_information.RepairMerchant = nil
		end
	end
	return false
end
e_removetovendor.throttle = 250
function e_removetovendor:execute()
	if ( wt_global_information.RepairMerchant ~= nil and wt_global_information.RepairMerchant ~= 0 ) then
		Player:MoveTo( e_removetovendor.vpos.x, e_removetovendor.vpos.y, e_removetovendor.vpos.z, 40 )
	else
		wt_global_information.RepairMerchant = 0
	end
end

------------------------------------------------------------------------------
-- Open Vendor Cause & Effect
local c_reopenvendor = inheritsFrom( wt_cause )
local e_reopenvendor = inheritsFrom( wt_effect )

function c_reopenvendor:evaluate()
	if ( wt_global_information.RepairMerchant ~= nil and wt_global_information.RepairMerchant ~= 0 ) then
		local vendor = MapObjectList:Get( wt_global_information.RepairMerchant )
		if ( vendor ~= nil ) then
			e_removetovendor.vpos = vendor.pos
			local ppos = Player.pos
			distance =  Distance3D( e_removetovendor.vpos.x, e_removetovendor.vpos.y, e_removetovendor.vpos.z, ppos.x, ppos.y, ppos.z )
			if ( distance < 80 ) then
				Player:StopMoving()
				if( Player:GetTarget() ~= vendor.characterID ) then
					Player:SetTarget(vendor.characterID)
				end
				if ( not Player:IsConversationOpen() ) then
					return true
				end
			end
		else
			wt_global_information.RepairMerchant = nil
		end
	end
	return false
end

e_reopenvendor.throttle = math.random( 1500, 2500 )
e_reopenvendor.delay = math.random( 1500, 3500 )
function e_reopenvendor:execute()
	wt_debug( "Repair: Opening Vendor.. " )
	c_revendorcheck.objects = MapObjectList( "onmesh,nearest,type="..GW2.MAPOBJECTTYPE.RepairMerchant )
	if ( TableSize( c_revendorcheck.objects ) > 0 ) then
		nextMerchant , E  = next( c_revendorcheck.objects )
		if ( nextMerchant ~= nil ) then
			Player:Interact( E.characterID )
		end
	else
		wt_core_state_repair.repaired = false
		wt_global_information.RepairMerchant = 0
		wt_core_state_repair.repaircount = 0
		wt_core_controller.requestStateChange( wt_core_state_idle )
	end
end

------------------------------------------------------------------------------
-- Do Conversation with Vendor Cause & Effect
local c_reconversation = inheritsFrom( wt_cause )
local e_reconversation = inheritsFrom( wt_effect )

function c_reconversation:evaluate()
-- IsEquippmentDamaged() is defined in /gw2lib/wt_utility.lua
	if ( not IsEquippmentDamaged() ) then
		wt_core_state_repair.repaired = true
	end
	if ( wt_global_information.RepairMerchant ~= nil and wt_global_information.RepairMerchant ~= 0 and Player:IsConversationOpen() and not wt_core_state_repair.repaired ) then
		return true
	end
	return false
end

e_reconversation.throttle = math.random( 1500, 2500 )
e_reconversation.delay = math.random( 2500, 3500 )
function e_reconversation:execute()
	wt_debug( "Repair: Chatting with Vendor..." )
	if ( Player:IsConversationOpen() ) then
		local options = Player:GetConversationOptions()
		nextOption, entry  = next( options )
		while ( nextOption ~=nil and wt_core_state_repair.repaircount < 3 ) do
			if( entry == GW2.CONVERSATIONOPTIONS.Repair ) then
				wt_debug( "Repair: chosing entry " .. tostring( GW2.CONVERSATIONOPTIONS.Repair ) )
				wt_core_state_repair.repaircount = wt_core_state_repair.repaircount + 1
				Player:SelectConversationOption( GW2.CONVERSATIONOPTIONS.Repair )
				break
			elseif( entry == GW2.CONVERSATIONOPTIONS.Continue ) then
				Player:SelectConversationOption( GW2.CONVERSATIONOPTIONS.Continue )
				break
			end
			nextOption, entry  = next( options, nextOption )
		end
	end
end

------------------------------------------------------------------------------
-- VendorDone Cause & Effect
local c_revendordone = inheritsFrom( wt_cause )
local e_revendordone = inheritsFrom( wt_effect )

function c_revendordone:evaluate()
	if ( wt_global_information.RepairMerchant ~= nil and wt_global_information.RepairMerchant ~= 0 and ( wt_core_state_repair.repaired or wt_core_state_repair.repaircount > 2 ) ) then
		return true
	end
	return false
end

function e_revendordone:execute()
	if ( IsEquippmentDamaged() == true )then
		wt_debug( "Repair: WARNING: Equipment was not repaired..bug?" )

	end
	wt_core_state_repair.repaired = false
	wt_global_information.RepairMerchant = 0
	wt_core_state_repair.repaircount = 0
	wt_core_controller.requestStateChange( wt_core_state_idle )
end


function wt_core_state_repair:initialize()

	local ke_died = wt_kelement:create( "Died", c_died, e_died, wt_effect.priorities.interrupt )
	wt_core_state_repair:add(ke_died)

	local ke_aggro = wt_kelement:create( "AggroCheck", c_aggro, e_aggro, 100 )
	wt_core_state_repair:add( ke_aggro )

	local ke_rest = wt_kelement:create( "Rest", c_rest,e_rest, 75 )
	wt_core_state_repair:add( ke_rest )

	local ke_revendorsearch = wt_kelement:create( "Vendorsearch", c_revendorcheck, e_revendor, 60 )
	wt_core_state_repair:add( ke_revendorsearch )

	local ke_renovendor = wt_kelement:create( "NoVendorFound", c_renovendorcheck, e_renovendor, 50 )
	wt_core_state_repair:add( ke_renovendor )

	local ke_removetovendor = wt_kelement:create( "MoveToVendor", c_removetovendorcheck, e_removetovendor, 40 )
	wt_core_state_repair:add( ke_removetovendor )

	local ke_reopenvendor = wt_kelement:create( "OpenVendor", c_reopenvendor, e_reopenvendor, 30 )
	wt_core_state_repair:add( ke_reopenvendor )

	local ke_doconversation = wt_kelement:create( "Conversation", c_reconversation, e_reconversation, 25 )
	wt_core_state_repair:add( ke_doconversation )

	local ke_revendordone = wt_kelement:create( "VendorDone", c_revendordone, e_revendordone, 10 )
	wt_core_state_repair:add( ke_revendordone )

end

-- setup kelements for the state
wt_core_state_repair:initialize()
-- register the State with the system
wt_core_state_repair:register()
