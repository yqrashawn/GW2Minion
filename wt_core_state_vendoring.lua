-- The vendoring State
-- Walking towards nearest Merchant n sell and buy stuff

-- We inherit from wt_core_state, which gives us: function wt_core_state:run(), function wt_core_state:add( kelement ) and function wt_core_state:register()
wt_core_state_vendoring = inheritsFrom(wt_core_state)
wt_core_state_vendoring.name = "Vendoring"
wt_core_state_vendoring.kelement_list = { }
wt_core_state_vendoring.junksold = false 


-- Search for Vendor Cause & Effect
local c_vendorcheck = inheritsFrom(wt_cause)
local e_vendor = inheritsFrom(wt_effect)

function c_vendorcheck:evaluate()
	if (wt_global_information.CurrentVendor == 0) then
		c_vendorcheck.objects = MapObjectList("onmesh,nearest,type="..GW2.MAPOBJECTTYPE.Merchant)
		if ( TableSize(c_vendorcheck.objects) > 0 ) then
			return true
		else
			wt_global_information.CurrentVendor = nil
		end
	end
	return false
end

function e_vendor:execute()
	if ( TableSize(c_vendorcheck.objects) > 0 ) then
		nextMerchant , E  = next(c_vendorcheck.objects)		
		if (nextMerchant ~= nil) then			
			wt_debug("New Merchant found..ID: "..E.characterID)			
			wt_global_information.CurrentVendor = E
		end
	end
end

-- VendorCheck Cause & Effect
local c_novendorcheck = inheritsFrom(wt_cause)
local e_novendor = inheritsFrom(wt_effect)

function c_novendorcheck:evaluate()
	if (wt_global_information.CurrentVendor == nil) then		
		return true		
	end
	return false
end

function e_novendor:execute()
	wt_debug("WARNING:No Vendor on the NavMesh and Inventory full!!")
	wt_core_controller.requestStateChange(wt_core_state_idle)
end

-- MoveTo Vendor Cause & Effect
local c_movetovendorcheck = inheritsFrom(wt_cause)
local e_movetovendor = inheritsFrom(wt_effect)

function c_movetovendorcheck:evaluate()
	if (wt_global_information.CurrentVendor ~= nil and wt_global_information.CurrentVendor ~= 0) then			
		e_movetovendor.vpos = wt_global_information.CurrentVendor.pos
		local ppos = Player.pos
		distance =  Distance3D(e_movetovendor.vpos.x,e_movetovendor.vpos.y,e_movetovendor.vpos.z,ppos.x,ppos.y,ppos.z)
		wt_debug("Vendordist : "..distance)
		if (distance >= 80) then
			return true	
		end		
	end
	return false
end
e_movetovendor.throttle = 250
function e_movetovendor:execute()
	wt_debug("MoveToVendor.. "..wt_global_information.CurrentVendor.characterID)	
	if ( wt_global_information.CurrentVendor ~= nil and wt_global_information.CurrentVendor ~= 0) then
		Player:MoveTo(e_movetovendor.vpos.x,e_movetovendor.vpos.y,e_movetovendor.vpos.z,80)
	else 
		wt_global_information.CurrentVendor = 0
	end
end

-- Open Vendor Cause & Effect
local c_openvendor = inheritsFrom(wt_cause)
local e_openvendor = inheritsFrom(wt_effect)

function c_openvendor:evaluate()	
	if (wt_global_information.CurrentVendor ~= nil and wt_global_information.CurrentVendor ~= 0) then			
		local vpos = wt_global_information.CurrentVendor.pos
		local ppos = Player.pos
		distance =  Distance3D(vpos.x,vpos.y,vpos.z,ppos.x,ppos.y,ppos.z)
		if (distance < 80) then
			Player:StopMoving()
			if( Player:GetTarget() ~= wt_global_information.CurrentVendor.characterID) then
				Player:SetTarget(wt_global_information.CurrentVendor.characterID)
			end			
			if (not Inventory:IsVendorOpened() and  not Player:IsConversationOpen()) then
				return true	
			end
		end		
	end
	return false
end

e_openvendor.throttle = 1000
function e_openvendor:execute()
	wt_debug("Opening Vendor.. ")
	c_vendorcheck.objects = MapObjectList("onmesh,nearest,type="..GW2.MAPOBJECTTYPE.Merchant)
	if ( TableSize(c_vendorcheck.objects) > 0 ) then
		nextMerchant , E  = next(c_vendorcheck.objects)		
		if (nextMerchant ~= nil) then
			Player:Interact(E.characterID) 			
		end
	else
		wt_core_state_vendoring.junksold = false
		wt_global_information.CurrentVendor = 0
		wt_core_controller.requestStateChange(wt_core_state_idle)
	end
end


-- Do Conversation with Vendor Cause & Effect
local c_conversation = inheritsFrom(wt_cause)
local e_conversation = inheritsFrom(wt_effect)

function c_conversation:evaluate()		
	if (wt_global_information.CurrentVendor ~= nil and wt_global_information.CurrentVendor ~= 0 and Player:IsConversationOpen() and not wt_core_state_vendoring.junksold ) then	
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
		while (nextOption ~=nil) do
			if(entry.type == GW2.CONVERSATIONOPTIONS.Sell) then
				Player:SelectConversationOption(GW2.CONVERSATIONOPTIONS.Sell)
			elseif(entry.type == GW2.CONVERSATIONOPTIONS.Continue) then
				Player:SelectConversationOption(GW2.CONVERSATIONOPTIONS.Continue)
			end
			nextOption,entry = next(object,nextOption)			
		end		
	end
end

-- Selling Items To Vendor Cause & Effect
local c_selltovendor = inheritsFrom(wt_cause)
local e_selltovendor = inheritsFrom(wt_effect)

function c_selltovendor:evaluate()		
	if (wt_global_information.CurrentVendor ~= nil and wt_global_information.CurrentVendor ~= 0 and Inventory:IsVendorOpened() and not wt_core_state_vendoring.junksold ) then	
		return true
	end
	return false
end

e_selltovendor.throttle = 1500
function e_selltovendor:execute()		
	wt_debug("Selling Junk...")
	if ( Inventory:IsVendorOpened()) then				
		Inventory:SellJunk()
		wt_core_state_vendoring.junksold = true
	end
end

-- VendorDone Cause & Effect
local c_vendordone = inheritsFrom(wt_cause)
local e_vendordone = inheritsFrom(wt_effect)

function c_vendordone:evaluate()		
	if (wt_global_information.CurrentVendor ~= nil and wt_global_information.CurrentVendor ~= 0 and wt_core_state_vendoring.junksold ) then
		return true
	end
	return false
end

function e_vendordone:execute()		
	if ( ItemList.freeSlotCount == 0 )then
		wt_debug("WARNING: NO FREE SPACE AFTER SELLING OUR JUNK!!")	
		
	end
	wt_core_state_vendoring.junksold = false
	wt_global_information.CurrentVendor = 0
	wt_core_controller.requestStateChange(wt_core_state_idle)
end

-------------------------------------------------------------

function wt_core_state_vendoring:initialize()

	local ke_died = wt_kelement:create("Died",c_died,e_died, wt_effect.priorities.interrupt )
	wt_core_state_vendoring:add(ke_died)
		
	local ke_aggro = wt_kelement:create("AggroCheck",c_aggro,e_aggro, 100 )
	wt_core_state_vendoring:add(ke_aggro)
	
	local ke_rest = wt_kelement:create("Rest",c_rest,e_rest,75)
	wt_core_state_vendoring:add(ke_rest)
			
	local ke_vendorsearch = wt_kelement:create("Vendorsearch",c_vendorcheck,e_vendor,60)
	wt_core_state_vendoring:add(ke_vendorsearch)
	
	local ke_novendor = wt_kelement:create("NoVendorFound",c_novendorcheck,e_novendor,50)
	wt_core_state_vendoring:add(ke_novendor)
		
	local ke_movetovendor = wt_kelement:create("MoveToVendor",c_movetovendorcheck,e_movetovendor,40)
	wt_core_state_vendoring:add(ke_movetovendor)
	
	local ke_openvendor = wt_kelement:create("OpenVendor",c_openvendor,e_openvendor,30)
	wt_core_state_vendoring:add(ke_openvendor)
	
	local ke_doconversation = wt_kelement:create("Conversation",c_conversation,e_conversation,25)
	wt_core_state_vendoring:add(ke_doconversation)
	
	local ke_selltovendor = wt_kelement:create("SellItems",c_selltovendor,e_selltovendor,20)
	wt_core_state_vendoring:add(ke_selltovendor)
	
	local ke_vendordone = wt_kelement:create("VendorDone",c_vendordone,e_vendordone,10)
	wt_core_state_vendoring:add(ke_vendordone)
	
end

-- setup kelements for the state
wt_core_state_vendoring:initialize()
-- register the State with the system
wt_core_state_vendoring:register()
