-- Repair
gw2_task_repair = inheritsFrom(ml_task)
gw2_task_repair.name = GetString("vendorEnabled") -- == Sell Items

function gw2_task_repair.Create()
	local newinst = inheritsFrom(gw2_task_repair)

	--ml_task members
	newinst.valid = true
	newinst.completed = false
	newinst.subtask = nil
	newinst.process_elements = {}
	newinst.overwatch_elements = {}

	return newinst
end

function gw2_task_repair:Init()
	-- ml_log("gw2_task_repair:Init")
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
	self:add(ml_element:create("VendorSell",c_vendorrepair,e_vendorrepair,100),self.process_elements)
	self:add(ml_element:create("QuickVendorSell",c_quickvendorrepair,e_quickvendorrepair,110),self.process_elements)
	--self:add(ml_element:create("MoveToVendorMarker",c_MoveToVendorMarker,e_MoveToVendorMarker,50),self.process_elements)


	self:AddTaskCheckCEs()
end
function gw2_task_repair:task_complete_eval()
	if (c_vendorrepair:evaluate() == false and c_quickvendorrepair:evaluate() == false) then
		return true
	end
	return false
end

function gw2_task_repair:UIInit()
	d("gw2_task_repair:UIInit")
	return true
end
function gw2_task_repair:UIDestroy()
	d("gw2_task_repair:UIDestroy")
end
function gw2_task_repair:RegisterDebug()
    d("gw2_task_repair:RegisterDebug")
end


-- Check for creating a VendorTask
c_createVendorRepairTask = inheritsFrom( ml_cause )
e_createVendorRepairTask = inheritsFrom( ml_effect )
c_createVendorRepairTask.throttle = 5000
function c_createVendorRepairTask:evaluate()
	if (gw2_repair_manager.NeedToRepair() and (TableSize(gw2_repair_manager.getClosestRepairMarker())>0 or gw2_common_functions.GetNextVendorMarker())) then
		return true
	end

	if (gw2_repair_manager.getClosestRepairMarker(true) and (TableSize(gw2_repair_manager.getClosestRepairMarker(true))>0 or gw2_common_functions.GetNextVendorMarker())) then
		return true
	end
	return false
end
function e_createVendorRepairTask:execute()
	ml_log("e_createRepairTask")

	local newTask = gw2_task_repair.Create()
	ml_task_hub:Add(newTask.Create(), REACTIVE_GOAL, TP_ASAP)

	return ml_log(true)
end


c_vendorrepair = inheritsFrom( ml_cause )
e_vendorrepair = inheritsFrom( ml_effect )
function c_vendorrepair:evaluate()
	if (gw2_repair_manager.NeedToRepair() and TableSize(gw2_repair_manager.getClosestRepairMarker()) > 0) then
		return true
	end
	return false
end
function e_vendorrepair:execute()
	ml_log("e_vendorrepair")
	local repairMarker = gw2_repair_manager.getClosestRepairMarker()
	if (repairMarker and repairMarker.characterID) then
		if (gw2_repair_manager.RepairAtVendor(repairMarker)) then
			return true
		end
	end
	return ml_log(false)
end

c_quickvendorrepair = inheritsFrom( ml_cause )
e_quickvendorrepair = inheritsFrom( ml_effect )
function c_quickvendorrepair:evaluate()
	if (gw2_repair_manager.NeedToRepair(true) and TableSize(gw2_repair_manager.getClosestRepairMarker(true)) > 0) then
		return true
	end
	return false
end
function e_quickvendorrepair:execute()
	ml_log("e_quickvendorrepair")
	local repairMarker = gw2_repair_manager.getClosestRepairMarker(true)
	if (repairMarker and repairMarker.characterID) then
		if (gw2_repair_manager.RepairAtVendor(repairMarker)) then
			return true
		end
	end
	return ml_log(false)
end
---------
-- Moves player towards the current vendor marker
c_MoveToVendorMarker = inheritsFrom( ml_cause )
e_MoveToVendorMarker = inheritsFrom( ml_effect )
c_MoveToVendorMarker.markerreachedfirsttime = false
c_MoveToVendorMarker.markerreached = false
function c_MoveToVendorMarker:evaluate()
	-- Get a new/next Marker if we need one ( no marker , out of level, time up )
	if (ml_task_hub:CurrentTask().currentMarker == nil or ml_task_hub:CurrentTask().currentMarker == false 
		or ( ml_task_hub:CurrentTask().filterLevel and ml_task_hub:CurrentTask().currentMarker:GetMinLevel() and ml_task_hub:CurrentTask().currentMarker:GetMaxLevel() and (ml_global_information.Player_Level < ml_task_hub:CurrentTask().currentMarker:GetMinLevel() or ml_global_information.Player_Level > ml_task_hub:CurrentTask().currentMarker:GetMaxLevel())) 
		or ( ml_task_hub:CurrentTask().currentMarker:GetTime() and ml_task_hub:CurrentTask().currentMarker:GetTime() ~= 0 and TimeSince(ml_task_hub:CurrentTask().markerTime) > ml_task_hub:CurrentTask().currentMarker:GetTime() * 1000 )) then
		-- TODO: ADD TIMEOUT FOR MARKER
		ml_task_hub:CurrentTask().currentMarker = ml_marker_mgr.GetNextMarker(GetString("vendorMarker"), ml_task_hub:CurrentTask().filterLevel)
		
		-- disable the levelfilter in case we didnt find any other marker
		if (ml_task_hub:CurrentTask().currentMarker == nil) then
			ml_task_hub:CurrentTask().filterLevel = false
			ml_task_hub:CurrentTask().currentMarker = ml_marker_mgr.GetNextMarker(GetString("vendorMarker"), ml_task_hub:CurrentTask().filterLevel)
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
				newTask.name = "MoveTo VendorMarker(REPAIR)"
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
