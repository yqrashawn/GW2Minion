-- Salvaging + Settings
gw2_task_buy = inheritsFrom(ml_task)
gw2_task_buy.name = GetString("salvage")

function gw2_task_buy.Create()
	local newinst = inheritsFrom(gw2_task_buy)
	
	--ml_task members
	newinst.valid = true
	newinst.completed = false
	newinst.subtask = nil
	newinst.process_elements = {}
	newinst.overwatch_elements = {}
	
	return newinst
end

function gw2_task_buy:Init()
	-- ml_log("gw2_task_buy:Init")
	
	self:add(ml_element:create("Salvage",c_vendorbuy,e_vendorbuy,100),self.process_elements)
	self:add(ml_element:create("Salvage",c_quickvendorbuy,e_quickvendorbuy,110),self.process_elements)
	
	self:AddTaskCheckCEs()
end
function gw2_task_buy:task_complete_eval()
	if (c_vendorbuy:evaluate() == false and c_quickvendorbuy:evaluate() == false) then
		return true
	end
	return false
end

function gw2_task_buy:UIInit()
	d("gw2_task_buy:UIInit")
	return true
end
function gw2_task_buy:UIDestroy()
	d("gw2_task_buy:UIDestroy")
end

function gw2_task_buy:RegisterDebug()
    d("gw2_task_buy:RegisterDebug")
end

c_vendorbuy = inheritsFrom( ml_cause )
e_vendorbuy = inheritsFrom( ml_effect )
c_vendorbuy.buying = false
function c_vendorbuy:evaluate()
	if (BuyManager_Active == "1" and ((gw2_buy_manager.NeedToBuySalvageKits() or gw2_buy_manager.NeedToBuyGatheringTools()) or c_vendorbuy.buying)) then
		return true
	end
	return false
end
function e_vendorbuy:execute()
	ml_log("e_need_salvage")
	local merchantMarker = gw2_buy_manager.getClosestBuyMarker()
	if (merchantMarker and merchantMarker.characterID) then
		if (gw2_buy_manager.buyAtMerchant(merchantMarker)) then
			c_vendorbuy.buying = true
			return true
		end
	end
	c_vendorbuy.buying = false
	return ml_log(false)
end

c_quickvendorbuy = inheritsFrom( ml_cause )
e_quickvendorbuy = inheritsFrom( ml_effect )
c_quickvendorbuy.buying = false
function c_quickvendorbuy:evaluate()
	if (BuyManager_Active == "1" and ((gw2_buy_manager.NeedToBuySalvageKits(true) or gw2_buy_manager.NeedToBuyGatheringTools(true)) or c_quickvendorbuy.buying)) then
		return true
	end
	return false
end
function e_quickvendorbuy:execute()
	ml_log("e_need_salvage")
	local merchantMarker = gw2_buy_manager.getClosestBuyMarker(true)
	if (merchantMarker and merchantMarker.characterID) then
		if (gw2_buy_manager.buyAtMerchant(merchantMarker)) then
			c_quickvendorbuy.buying = true
			return true
		end
	end
	c_quickvendorbuy.buying = false
	return ml_log(false)
end