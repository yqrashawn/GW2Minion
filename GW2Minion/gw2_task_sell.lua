-- Salvaging + Settings
gw2_task_sell = inheritsFrom(ml_task)
gw2_task_sell.name = GetString("salvage")

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
	
	self:add(ml_element:create("Salvage",c_vendorsell,e_vendorsell,100),self.process_elements)
	self:add(ml_element:create("Salvage",c_quickvendorsell,e_quickvendorsell,110),self.process_elements)
	
	self:AddTaskCheckCEs()
end
function gw2_task_sell:task_complete_eval()
	if (c_vendorsell:evaluate() == false and c_quickvendorsell:evaluate() == false) then
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

c_vendorsell = inheritsFrom( ml_cause )
e_vendorsell = inheritsFrom( ml_effect )
c_vendorsell.selling = false
function c_vendorsell:evaluate()
	if (SellManager_Active == "1" and (gw2_sell_manager.needToSell() or c_vendorsell.selling)) then
		return true
	end
	return false
end
function e_vendorsell:execute()
	ml_log("e_need_salvage")
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
	if (SellManager_Active == "1" and (gw2_sell_manager.needToSell(true) or c_quickvendorsell.selling)) then
		return true
	end
	return false
end
function e_quickvendorsell:execute()
	ml_log("e_need_salvage")
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