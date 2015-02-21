gw2_marker_manager = {}
gw2_marker_manager.lastMarkerOfType = {}
gw2_marker_manager.tick = 0

function gw2_marker_manager.ModuleInit()
	local dw = WindowManager:GetWindow(gw2minion.DebugWindow.Name)
	if ( dw ) then
		dw:NewField("MarkerName","dbCurrentMarkerName",GetString("markers"))
		dw:NewField("MarkerType","dbMarkerType",GetString("markers"))
		dw:NewField("MarkerTime","dbCurrentMarkerTime",GetString("markers"))
		dw:NewField("MarkerTimeRemaining","dbCurrentMarkerTimeRemaining",GetString("markers"))
		dw:NewField("MarkerReached","dbCurrentMarkerReached",GetString("markers"))
		dw:NewField("MarkerReachedFirsttime","dbCurrentMarkerReachedFirst",GetString("markers"))
		dw:NewField("MarkerDistance","dbMarkerDistance",GetString("markers"))
		dw:NewField("MarkerRange","dbMarkerRange",GetString("markers"))
	end
end

function gw2_marker_manager.OnUpdateHandler(Event, ticks)
	if (ticks - gw2_marker_manager.tick > 1000)  then
		gw2_marker_manager.DebugUpdate()

		gw2_marker_manager.tick = ticks
	end
end

function gw2_marker_manager.DebugUpdate()
	if ( ml_global_information.ShowDebug and gBotRunning == "1" and ml_task_mgr.GetCurrentTask() ~= nil) then
		local marker = ml_task_mgr.GetCurrentTask().currentMarker or nil

		dbCurrentMarkerTime = "novalue"
		dbCurrentMarkerName = "novalue"
		dbCurrentMarkerTimeRemaining = "novalue"
		dbCurrentMarkerReached = "novalue"
		dbCurrentMarkerReachedFirst = "novalue"
		dbMarkerDistance = "novalue"
		dbMarkerType = "novalue"
		dbMarkerRange = "novalue"

		if(marker ~= nil) then
			if(ml_global_information.MarkerTime ~= nil and ml_global_information.MarkerTime > 0) then
				dbCurrentMarkerTime = math.floor(TimeSince(ml_global_information.MarkerTime) / 1000)
				dbCurrentMarkerTimeRemaining = math.floor(marker:GetTime() - dbCurrentMarkerTime)
			end

			local pos = marker:GetPosition()
			local dist = Distance2D(ml_global_information.Player_Position.x, ml_global_information.Player_Position.y, pos.x, pos.y)
			dbMarkerDistance = math.floor(dist)
			dbCurrentMarkerName = marker:GetName()
			dbCurrentMarkerReached = tostring(c_MoveToMarker.markerreached)
			dbCurrentMarkerReachedFirst = tostring(c_MoveToMarker.markerreachedfirsttime)
			dbMarkerType = marker:GetType()
			dbMarkerRange = marker:GetFieldValue(GetString("maxRange"))
		end
	end
end

function gw2_marker_manager.GetNextMarker(markerType, filterLevel)
	-- Reset manager marker
	ml_marker_mgr.currentMarker = gw2_marker_manager.lastMarkerOfType[markerType] or nil

	local marker = ml_marker_mgr.GetNextMarker(markerType, filterLevel)
	gw2_marker_manager.lastMarkerOfType[markerType] = marker
	return marker
end

-- Try to get the next custom VendorMarker in our map where a vendor should be nearby, used by buy and sell task
function gw2_marker_manager.GetNextVendorMarker(oldmarker)

	local filterLevel = false
	local vendormarker = gw2_marker_manager.GetNextMarker(GetString("vendorMarker"), filterLevel)

	-- get a different marker
	if (vendormarker and oldmarker ~= nil and oldmarker:GetName() == vendormarker:GetName()) then
		vendormarker = gw2_marker_manager.GetNextMarker(GetString("vendorMarker"), filterLevel)
	end

	return vendormarker
end

function gw2_marker_manager.GetClosestVendorMarker(range)
	if(range == nil) then
		range = 30000
	end

	return ml_marker_mgr.GetClosestMarker( ml_global_information.Player_Position.x, ml_global_information.Player_Position.y, ml_global_information.Player_Position.z, range, GetString("vendorMarker")) or nil
end

RegisterEventHandler("Module.Initalize",gw2_marker_manager.ModuleInit)
RegisterEventHandler("Gameloop.Update",gw2_marker_manager.OnUpdateHandler)