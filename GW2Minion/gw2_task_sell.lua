-- Selling
gw2_task_sell = inheritsFrom(ml_task)
gw2_task_sell.name = GetString("vendorEnabled") -- == Sell Items

function gw2_task_sell.Create()
	local newinst = inheritsFrom(gw2_task_sell)

	--ml_task members
	newinst.valid = true
	newinst.completed = false
	newinst.subtask = nil
	newinst.process_elements = {}
	newinst.overwatch_elements = {}

	return newinst
end

function gw2_task_sell:Init()
	-- ml_log("gw2_task_sell:Init")
	-- ProcessOverWatch() elements

	-- Handle Dead
	self:add(ml_element:create( "Dead", c_Dead, e_Dead, 500 ), self.overwatch_elements)

	-- Downed
	self:add(ml_element:create( "Downed", c_Downed, e_DownedEmpty, 450 ), self.overwatch_elements)

	-- Handle Rezz-Target is alive again or gone, deletes the subtask moveto in case it is needed
	self:add(ml_element:create( "RevivePartyMemberOverWatch", c_RezzOverWatchCheck, e_RezzOverWatchCheck, 400 ), self.overwatch_elements)



	-- Normal elements
	-- Revive Downed/Dead Partymember
	self:add(ml_element:create( "RevivePartyMember", c_RezzPartyMember, e_RezzPartyMember, 375 ), self.process_elements)	-- creates subtask: moveto
	self:add(ml_element:create("VendorSell",c_vendorsell,e_vendorsell,100),self.process_elements)
	self:add(ml_element:create("QuickVendorSell",c_quickvendorsell,e_quickvendorsell,110),self.process_elements)
	self:add(ml_element:create("MoveToVendorMarker",c_moveToVendorMarkerSell,e_moveToVendorMarkerSell,50),self.process_elements)


	self:AddTaskCheckCEs()
end
function gw2_task_sell:task_complete_eval()
	if (c_vendorsell:evaluate() == false and c_quickvendorsell:evaluate() == false and c_moveToVendorMarkerSell:evaluate() == false) then
		return true
	end
	return false
end

function gw2_task_sell:UIInit()
	d("gw2_task_sell:UIInit")
	return true
end
function gw2_task_sell:UIDestroy()
	d("gw2_task_sell:UIDestroy")
end

function gw2_task_sell:RegisterDebug()
    d("gw2_task_sell:RegisterDebug")
end


-- Check for creating a VendorTask
c_createVendorSellTask = inheritsFrom( ml_cause )
e_createVendorSellTask = inheritsFrom( ml_effect )
c_createVendorSellTask.throttle = 5000
function c_createVendorSellTask:evaluate()
	if ( SellManager_Active ) then
		if ((gw2_sell_manager.needToSell() or c_vendorsell.selling) and ( ValidTable(gw2_sell_manager.getClosestSellMarker()) or gw2_common_functions.GetNextVendorMarker())) then
			return true
		end

		if ((gw2_sell_manager.needToSell(true) or c_quickvendorsell.selling) and ( ValidTable(gw2_sell_manager.getClosestSellMarker(true)) or gw2_common_functions.GetNextVendorMarker())) then
			return true
		end
	end
	return false
end
function e_createVendorSellTask:execute()
	ml_log("e_createVendorSellTask")

	local newTask = gw2_task_sell.Create()
	ml_task_hub:Add(newTask.Create(), REACTIVE_GOAL, TP_ASAP)

	return ml_log(true)
end


c_vendorsell = inheritsFrom( ml_cause )
e_vendorsell = inheritsFrom( ml_effect )
c_vendorsell.selling = false
function c_vendorsell:evaluate()
	if (SellManager_Active == "1" and ( c_vendorsell.selling or gw2_sell_manager.needToSell() ) and ValidTable(gw2_sell_manager.getClosestSellMarker())) then
		return true
	end
	return false
end
function e_vendorsell:execute()
	ml_log("e_vendorsell")
	local vendorMarker = gw2_sell_manager.getClosestSellMarker()
	if (vendorMarker and vendorMarker.characterID) then
		if (gw2_sell_manager.sellAtVendor(vendorMarker)) then
			c_vendorsell.selling = true
			return true
		end
	end
	c_vendorsell.selling = false
	return ml_log(false)
end

c_quickvendorsell = inheritsFrom( ml_cause )
e_quickvendorsell = inheritsFrom( ml_effect )
c_quickvendorsell.selling = false
function c_quickvendorsell:evaluate()
	if (SellManager_Active == "1" and (c_quickvendorsell.selling or gw2_sell_manager.needToSell(true)) and ValidTable(gw2_sell_manager.getClosestSellMarker(true))) then
		return true
	end
	return false
end
function e_quickvendorsell:execute()
	ml_log("e_quickvendorsell")
	local vendorMarker = gw2_sell_manager.getClosestSellMarker(true)
	if (vendorMarker and vendorMarker.characterID) then
		if (gw2_sell_manager.sellAtVendor(vendorMarker)) then
			c_quickvendorsell.selling = true
			return true
		end
	end
	c_quickvendorsell.selling = false
	return ml_log(false)
end

c_moveToVendorMarkerSell = inheritsFrom( ml_cause )
e_moveToVendorMarkerSell = inheritsFrom( ml_effect )
function c_moveToVendorMarkerSell:evaluate()
	if (SellManager_Active == "1" and gw2_sell_manager.needToSell() and c_MoveToVendorMarker:evaluate()) then
		return true
	end
	return false
end
function e_moveToVendorMarkerSell:execute()
	e_MoveToVendorMarker:execute()
end
