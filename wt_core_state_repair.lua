-- The vendoring State
-- Walking towards nearest Merchant n sell and buy stuff

-- We inherit from wt_core_state, which gives us: function wt_core_state:run(), function wt_core_state:add( kelement ) and function wt_core_state:register()
wt_core_state_repair = inheritsFrom(wt_core_state)
wt_core_state_repair.name = "Repairing"
wt_core_state_repair.kelement_list = { }
wt_core_state_repair.repaired = false 
wt_core_state_repair.repaircount = 0

-- Search for RepairMerchant Cause & Effect
local c_vendorcheck = inheritsFrom(wt_cause)
local e_vendor = inheritsFrom(wt_effect)

function c_vendorcheck:evaluate()
	if (wt_global_information.RepairMerchant == 0) then
		c_vendorcheck.objects = MapObjectList("onmesh,nearest,type="..GW2.MAPOBJECTTYPE.RepairMerchant)
		if ( TableSize(c_vendorcheck.objects) > 0 ) then
			return true
		else
			wt_global_information.RepairMerchant = nil
		end
	end
	return false
end

function e_vendor:execute()
	if ( TableSize(c_vendorcheck.objects) > 0 ) then
		nextMerchant , E  = next(c_vendorcheck.objects)		
		if (nextMerchant ~= nil) then			
			wt_debug("New RepairMerchant found..ID: "..E.characterID)			
			wt_global_information.RepairMerchant = E
		end
	end
end


-- VendorCheck Cause & Effect
local c_novendorcheck = inheritsFrom(wt_cause)
local e_novendor = inheritsFrom(wt_effect)

function c_novendorcheck:evaluate()
	if (wt_global_information.RepairMerchant == nil) then		
		return true		
	end
	return false
end

function e_novendor:execute()
	wt_debug("WARNING:No RepairMerchant on the NavMesh !")
	wt_core_state_repair.repaircount = 0
	wt_core_controller.requestStateChange(wt_core_state_idle)
end

-- MoveTo Vendor Cause & Effect
local c_movetovendorcheck = inheritsFrom(wt_cause)
local e_movetovendor = inheritsFrom(wt_effect)

function c_movetovendorcheck:evaluate()
	if (wt_global_information.RepairMerchant ~= nil and wt_global_information.RepairMerchant ~= 0) then			
		distance =  Distance3D(wt_global_information.RepairMerchant.pos.x,wt_global_information.RepairMerchant.pos.y,wt_global_information.RepairMerchant.pos.z,Player.pos.x,Player.pos.y,Player.pos.z)
		wt_debug("Vendordist : "..distance)
		if (distance >= 80) then
			return true	
		end		
	end
	return false
end
e_movetovendor.throttle = 250
function e_movetovendor:execute()
	wt_debug("MoveToVendor.. "..wt_global_information.RepairMerchant.characterID)	
	if ( wt_global_information.RepairMerchant ~= nil and wt_global_information.RepairMerchant ~= 0) then
		Player:MoveTo(wt_global_information.RepairMerchant.pos.x,wt_global_information.RepairMerchant.pos.y,wt_global_information.RepairMerchant.pos.z,80)
	else 
		wt_global_information.RepairMerchant = 0
	end
end

-- Open Vendor Cause & Effect
local c_openvendor = inheritsFrom(wt_cause)
local e_openvendor = inheritsFrom(wt_effect)

function c_openvendor:evaluate()	
	if (wt_global_information.RepairMerchant ~= nil and wt_global_information.RepairMerchant ~= 0) then			
		distance =  Distance3D(wt_global_information.RepairMerchant.pos.x,wt_global_information.RepairMerchant.pos.y,wt_global_information.RepairMerchant.pos.z,Player.pos.x,Player.pos.y,Player.pos.z)
		if (distance < 80) then
			Player:StopMoving()
			if( Player:GetTarget() ~= wt_global_information.RepairMerchant.characterID) then
				Player:SetTarget(wt_global_information.RepairMerchant.characterID)
			end			
			if ( not Player:IsConversationOpen()) then
				return true	
			end
		end		
	end
	return false
end

e_openvendor.throttle = 1000
function e_openvendor:execute()
	wt_debug("Opening Vendor.. ")
	c_vendorcheck.objects = MapObjectList("onmesh,nearest,type="..GW2.MAPOBJECTTYPE.RepairMerchant)
	if ( TableSize(c_vendorcheck.objects) > 0 ) then
		nextMerchant , E  = next(c_vendorcheck.objects)		
		if (nextMerchant ~= nil) then
			Player:Interact(E.characterID) 			
		end
	else
		wt_core_state_repair.repaired = false
		wt_global_information.RepairMerchant = 0
		wt_core_state_repair.repaircount = 0
		wt_core_controller.requestStateChange(wt_core_state_idle)
	end
end


-- Do Conversation with Vendor Cause & Effect
local c_conversation = inheritsFrom(wt_cause)
local e_conversation = inheritsFrom(wt_effect)

function c_conversation:evaluate()	
-- IsEquippmentDamaged() is defined in /gw2lib/wt_utility.lua
	if ( not IsEquippmentDamaged() ) then
		wt_core_state_repair.repaired = true
	end
	if (wt_global_information.RepairMerchant ~= nil and wt_global_information.RepairMerchant ~= 0 and Player:IsConversationOpen() and not wt_core_state_repair.repaired ) then	
		return true
	end
	return false
end

e_conversation.throttle = 2000
function e_conversation:execute()		
	wt_debug("Chatting with Vendor...")
	if ( Player:IsConversationOpen()) then						
		local options = Player:GetConversationOptions()
		nextOption , entry  = next(options)		
		while (nextOption ~=nil and wt_core_state_repair.repaircount < 3) do
			if(entry == GW2.CONVERSATIONOPTIONS.Repair) then
				wt_debug("TWO")
				wt_core_state_repair.repaircount = wt_core_state_repair.repaircount + 1
				Player:SelectConversationOption(GW2.CONVERSATIONOPTIONS.Repair)				
			elseif(entry == GW2.CONVERSATIONOPTIONS.Continue) then
				Player:SelectConversationOption(GW2.CONVERSATIONOPTIONS.Continue)
			end
			nextOption,entry = next(options,nextOption)			
		end		
	end
end


-- VendorDone Cause & Effect
local c_vendordone = inheritsFrom(wt_cause)
local e_vendordone = inheritsFrom(wt_effect)

function c_vendordone:evaluate()		
	if (wt_global_information.RepairMerchant ~= nil and wt_global_information.RepairMerchant ~= 0 and ( wt_core_state_repair.repaired or wt_core_state_repair.repaircount > 2)) then
		return true
	end
	return false
end

function e_vendordone:execute()	
	if ( IsEquippmentDamaged() == true )then
		wt_debug("WARNING: Equipment was not repaired..bug?")	
		
	end
	wt_core_state_repair.repaired = false
	wt_global_information.RepairMerchant = 0
	wt_core_controller.requestStateChange(wt_core_state_idle)
end


function wt_core_state_repair:initialize()

	local ke_died = wt_kelement:create("Died",c_died,e_died, wt_effect.priorities.interrupt )
	wt_core_state_repair:add(ke_died)
		
	local ke_aggro = wt_kelement:create("AggroCheck",c_aggro,e_aggro, 100 )
	wt_core_state_repair:add(ke_aggro)
	
	local ke_rest = wt_kelement:create("Rest",c_rest,e_rest,75)
	wt_core_state_repair:add(ke_rest)
			
	local ke_vendorsearch = wt_kelement:create("Vendorsearch",c_vendorcheck,e_vendor,60)
	wt_core_state_repair:add(ke_vendorsearch)
	
	local ke_novendor = wt_kelement:create("NoVendorFound",c_novendorcheck,e_novendor,50)
	wt_core_state_repair:add(ke_novendor)
		
	local ke_movetovendor = wt_kelement:create("MoveToVendor",c_movetovendorcheck,e_movetovendor,40)
	wt_core_state_repair:add(ke_movetovendor)
	
	local ke_openvendor = wt_kelement:create("OpenVendor",c_openvendor,e_openvendor,30)
	wt_core_state_repair:add(ke_openvendor)
	
	local ke_doconversation = wt_kelement:create("Conversation",c_conversation,e_conversation,25)
	wt_core_state_repair:add(ke_doconversation)
	
	local ke_vendordone = wt_kelement:create("VendorDone",c_vendordone,e_vendordone,10)
	wt_core_state_repair:add(ke_vendordone)
	
end

-- setup kelements for the state
wt_core_state_repair:initialize()
-- register the State with the system
wt_core_state_repair:register()
