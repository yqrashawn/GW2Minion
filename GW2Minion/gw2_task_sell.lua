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
	self:add(ml_element:create("MoveToVendorMarker",c_MoveToVendorMarker,e_MoveToVendorMarker,50),self.process_elements)


	self:AddTaskCheckCEs()
end
function gw2_task_sell:task_complete_eval()
	c_MoveToVendorMarker.vendormanager = SellManager_Active
	if (c_vendorsell:evaluate() == false and c_quickvendorsell:evaluate() == false and c_MoveToVendorMarker:evaluate() == false) then
		return true
	end
	c_MoveToVendorMarker.vendormanager = SellManager_Active
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
		if ((gw2_sell_manager.needToSell() or c_vendorsell.selling) and ( TableSize(gw2_sell_manager.getClosestSellMarker())>0 or gw2_marker_manager.GetNextVendorMarker())) then
			return true
		end

		if ((gw2_sell_manager.needToSell(true) or c_quickvendorsell.selling) and ( TableSize(gw2_sell_manager.getClosestSellMarker(true))>0 or gw2_marker_manager.GetNextVendorMarker())) then
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
	if (SellManager_Active == "1" and ( c_vendorsell.selling or gw2_sell_manager.needToSell() ) and TableSize(gw2_sell_manager.getClosestSellMarker())>0 ) then
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
	if (SellManager_Active == "1" and (c_quickvendorsell.selling or gw2_sell_manager.needToSell(true)) and TableSize(gw2_sell_manager.getClosestSellMarker(true))>0) then
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

---------
-- Moves player towards the current vendor marker
c_MoveToVendorMarker = inheritsFrom( ml_cause )
e_MoveToVendorMarker = inheritsFrom( ml_effect )
c_MoveToVendorMarker.markerreachedfirsttime = false
c_MoveToVendorMarker.markerreached = false
c_MoveToVendorMarker.vendormanager = false
function c_MoveToVendorMarker:evaluate()

	-- Get a new/next Marker if we need one ( no marker , out of level, time up )
	if (ml_task_hub:CurrentTask().currentMarker == nil or ml_task_hub:CurrentTask().currentMarker == false
		or ( ml_task_hub:CurrentTask().filterLevel and ml_task_hub:CurrentTask().currentMarker:GetMinLevel() and ml_task_hub:CurrentTask().currentMarker:GetMaxLevel() and (ml_global_information.Player_Level < ml_task_hub:CurrentTask().currentMarker:GetMinLevel() or ml_global_information.Player_Level > ml_task_hub:CurrentTask().currentMarker:GetMaxLevel()))
		or ( ml_task_hub:CurrentTask().currentMarker:GetTime() and ml_task_hub:CurrentTask().currentMarker:GetTime() ~= 0 and TimeSince(ml_task_hub:CurrentTask().markerTime) > ml_task_hub:CurrentTask().currentMarker:GetTime() * 1000 )
		) and (c_MoveToVendorMarker.vendormanager == "1" and ( c_vendorsell.selling or gw2_sell_manager.needToSell())) then
		-- TODO: ADD TIMEOUT FOR MARKER

		ml_task_hub:CurrentTask().currentMarker = gw2_marker_manager.GetClosestVendorMarker()

		-- disable the levelfilter in case we didnt find any other marker
		if (ml_task_hub:CurrentTask().currentMarker == nil) then
			ml_task_hub:CurrentTask().filterLevel = false
			ml_task_hub:CurrentTask().currentMarker = gw2_marker_manager.GetNextMarker(GetString("vendorMarker"), ml_task_hub:CurrentTask().filterLevel)
		end

		-- we found a new marker, setup vars
		if ( ml_task_hub:CurrentTask().currentMarker ~= nil ) then
			d("New VendorMarker Marker set!")
			ml_task_hub:CurrentTask().markerTime = ml_global_information.Now -- Are BOTH needed to get updated ?
			ml_global_information.MarkerTime = ml_global_information.Now     -- This needs to be global else we cannot access the stuff in parent or subtasks
			ml_global_information.MarkerMinLevel = ml_task_hub:CurrentTask().currentMarker:GetMinLevel()
			ml_global_information.MarkerMaxLevel = ml_task_hub:CurrentTask().currentMarker:GetMaxLevel()
			c_MoveToVendorMarker.markerreached = false
			c_MoveToVendorMarker.markerreachedfirsttime = false
		end
	end

	-- We have a valid current vendorMarker
    if (ml_task_hub:CurrentTask().currentMarker ~= false and ml_task_hub:CurrentTask().currentMarker ~= nil) then

		-- Reset the Markertime until we actually reached the marker the first time and then let it count down
		if (c_MoveToVendorMarker.markerreachedfirsttime == false ) then
			ml_task_hub:CurrentTask().markerTime = ml_global_information.Now
			ml_global_information.MarkerTime = ml_global_information.Now
		end

		-- Debug info
		if ( ml_global_information.ShowDebug ) then dbCurrMarker = ml_task_hub:CurrentTask().currentMarker:GetName() or "" end

		-- We haven't reached the currentMarker or ran outside its radius
		if ( c_MoveToVendorMarker.markerreached == false) then
			return true
		else
			-- the other CnEs should pick up a vendor before we reach our marker..if we are here then it means no vendor nearby, so lets pick a next marker
			d("No Vendor nearby, Trying next VendorMarker...")
			ml_task_hub:CurrentTask().currentMarker = nil
		end
	end

    return false
end
function e_MoveToVendorMarker:execute()
	ml_log(" e_MoveToVendorMarker ")
	-- Move to our current marker
	if (ml_task_hub:CurrentTask().currentMarker ~= nil and ml_task_hub:CurrentTask().currentMarker ~= false) then

		local pos = ml_task_hub:CurrentTask().currentMarker:GetPosition()
		local dist = Distance2D(ml_global_information.Player_Position.x, ml_global_information.Player_Position.y, pos.x, pos.y)


		if  ( dist < 200) then
			-- We reached our Marker
			c_MoveToVendorMarker.markerreached = true
			c_MoveToVendorMarker.markerreachedfirsttime = true
			d("Reached current VendorMarker...")
			return ml_log(true)
		else
			-- We need to reach our Marker yet
			-- make sure the next marker is reachable & onmesh
			if ( ValidTable(NavigationManager:GetPath(ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z,pos.x,pos.y,pos.z))) then

				local newTask = gw2_task_moveto.Create()
				newTask.name = "MoveTo VendorMarker(" .. ml_task_hub:CurrentTask().name .. ")"
				newTask.targetPos = pos
				ml_task_hub:CurrentTask():AddSubTask(newTask)
				return ml_log(true)

			else
				d("WARNING: Cannot reach next VendorMarker, trying to pick another one...")
				ml_task_hub:CurrentTask().currentMarker = nil
				-- Debug info
				if ( ml_global_information.ShowDebug ) then dbCurrMarker = "" end
			end
		end
	end
	return ml_log(false)
end
