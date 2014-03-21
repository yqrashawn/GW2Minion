mc_meshrotation = {}
mc_meshrotation.mainwindow = { name = GetString("maprotation"), x = 350, y = 50, w = 250, h = 350}
mc_meshrotation.editwindow = { name = GetString("addnewmap"), x = 350, y = 50, w = 250, h = 250}
mc_meshrotation.visible = false
mc_meshrotation.currentlyeditedmap = nil
mc_meshrotation.mapList = {}
mc_meshrotation.currentMapIndex = 1
mc_meshrotation.currentMapTime = 0
mc_meshrotation.currentSwitchTime = nil

function mc_meshrotation.ModuleInit()
	
	
	if (Settings.GW2Minion.Maprotation_Active == nil ) then
		Settings.GW2Minion.Maprotation_Active = "0"
	end
	if (Settings.GW2Minion.Maprotation_MapList == nil ) then
		Settings.GW2Minion.Maprotation_MapList = {}
	end
	
	-- MANAGER WINDOW
	GUI_NewWindow(mc_meshrotation.mainwindow.name,mc_meshrotation.mainwindow.x,mc_meshrotation.mainwindow.y,mc_meshrotation.mainwindow.w,mc_meshrotation.mainwindow.h,true)
	GUI_NewCheckbox(mc_meshrotation.mainwindow.name,GetString("active"),"Maprotation_Active",GetString("generalSettings"))
	GUI_NewField(mc_meshrotation.mainwindow.name,GetString("botStatus"),"gMaprotationStatus",GetString("generalSettings"))
	GUI_NewButton(mc_meshrotation.mainwindow.name,GetString("addnewmap"),"Maprotation_AddNewMap")
	RegisterEventHandler("Maprotation_AddNewMap",mc_meshrotation.addMap)				
	
	GUI_SizeWindow(mc_meshrotation.mainwindow.name,mc_meshrotation.mainwindow.w,mc_meshrotation.mainwindow.h)
	GUI_UnFoldGroup(mc_meshrotation.mainwindow.name,GetString("generalSettings"))
	GUI_WindowVisible(mc_meshrotation.mainwindow.name,false)
	
	
	-- EDITOR WINDOW
	GUI_NewWindow(mc_meshrotation.editwindow.name,mc_meshrotation.mainwindow.x+mc_meshrotation.mainwindow.w,mc_meshrotation.mainwindow.y,mc_meshrotation.editwindow.w,mc_meshrotation.editwindow.h,true)
	GUI_NewField(mc_meshrotation.editwindow.name,GetString("name"),"MapRota_Name",GetString("addnewmap"))
	GUI_NewField(mc_meshrotation.editwindow.name,GetString("mapid"),"MapRota_MapID",GetString("addnewmap"))
	GUI_NewField(mc_meshrotation.editwindow.name,GetString("waypoint"),"MapRota_WPName",GetString("addnewmap"))
	GUI_NewField(mc_meshrotation.editwindow.name,GetString("waypointid"),"MapRota_WPID",GetString("addnewmap"))	
	GUI_NewNumeric(mc_meshrotation.editwindow.name,GetString("switchTimer"),"MapRota_SwitchTime",GetString("addnewmap"),"1","1440")
	GUI_NewButton(mc_meshrotation.editwindow.name,GetString("deletemap"),"Maprotation_DeleteMap")
	RegisterEventHandler("Maprotation_DeleteMap",mc_meshrotation.deleteMap)
	GUI_NewButton(mc_meshrotation.editwindow.name,GetString("lblsave"),"Maprotation_SaveMap")
	RegisterEventHandler("Maprotation_SaveMap",mc_meshrotation.saveMap)
	GUI_NewButton(mc_meshrotation.editwindow.name,GetString("getWaypoint"),"Maprotation_GetWaypoint")
	RegisterEventHandler("Maprotation_GetWaypoint",mc_meshrotation.getclosestWP)
	
	GUI_SizeWindow(mc_meshrotation.editwindow.name,mc_meshrotation.editwindow.w,mc_meshrotation.editwindow.h)
	GUI_UnFoldGroup(mc_meshrotation.editwindow.name,GetString("addnewmap"))
	GUI_WindowVisible(mc_meshrotation.editwindow.name,false)

	
	Maprotation_Active = Settings.GW2Minion.Maprotation_Active		
	mc_meshrotation.mapList = Settings.GW2Minion.Maprotation_MapList

	mc_meshrotation.updateMaprotationList()	
end

--Refreshes editorwindow fields
mc_meshrotation.RegisteredEventHandler = {}
function mc_meshrotation.updateMaprotationList()
	GUI_Delete(mc_meshrotation.mainwindow.name,GetString("maprotation"))
	if ( TableSize(mc_meshrotation.mapList)>0 ) then
		local i, v = next(mc_meshrotation.mapList)
		while (i and v) do
			GUI_NewButton(mc_meshrotation.mainwindow.name, mc_meshrotation.mapList[i].name, "Maprotation_Map" .. i,GetString("maprotation"))
			if ( mc_meshrotation.RegisteredEventHandler["Maprotation_Map" .. i] == nil ) then
				mc_meshrotation.RegisteredEventHandler["Maprotation_Map" .. i] = 1
				RegisterEventHandler("Maprotation_Map" .. i ,mc_meshrotation.editorWindow)
			end
			i, v = next(mc_meshrotation.mapList, i)
		end
	end
	MapRota_Name = ""
	MapRota_MapID = ""
	MapRota_WPID = ""
	MapRota_WPName = ""
	MapRota_SwitchTime = 0
	GUI_WindowVisible(mc_meshrotation.editwindow.name,false)
	GUI_UnFoldGroup(mc_meshrotation.mainwindow.name,GetString("maprotation"))
end

--New filter/Load filter.
function mc_meshrotation.editorWindow(filterNumber)
	if (string.find(filterNumber, "Maprotation_Map")) then
		filterNumber = string.gsub(filterNumber, "Maprotation_Map", "")
		filterNumber = tonumber(filterNumber)
	end
	if (mc_meshrotation.mapList[filterNumber] == nil) then
		filterNumber = TableSize(mc_meshrotation.mapList) + 1
		mc_meshrotation.mapList[filterNumber] = {name = mc_datamanager.GetMapName( Player:GetLocalMapID() ), mapid = Player:GetLocalMapID(), wpid = "None", wpname = "None", switchtime = 0}
		mc_meshrotation.updateMaprotationList()
		Settings.GW2Minion.Maprotation_MapList = mc_meshrotation.mapList
	end
	if (mc_meshrotation.mapList[filterNumber] ~= nil) then
		MapRota_Name = mc_meshrotation.mapList[filterNumber].name or "None"
		MapRota_MapID = mc_meshrotation.mapList[filterNumber].mapid or "None"
		MapRota_WPID = mc_meshrotation.mapList[filterNumber].wpid or "None"
		MapRota_WPName = mc_meshrotation.mapList[filterNumber].wpname or "None"
		MapRota_SwitchTime = mc_meshrotation.mapList[filterNumber].switchtime or 0
		GUI_WindowVisible(mc_meshrotation.editwindow.name,true)
	end
	mc_meshrotation.currentlyeditedmap = filterNumber
end

--Add new Map.
function mc_meshrotation.addMap()
	GUI_MoveWindow( mc_meshrotation.editwindow.name, mc_meshrotation.mainwindow.x+mc_meshrotation.mainwindow.w,mc_meshrotation.mainwindow.y) 	
	mc_meshrotation.editorWindow("Maprotation_Map"..tostring(TableSize(mc_meshrotation.mapList) + 1))	
	mc_meshrotation.getclosestWP()
end

--Delete Map.
function mc_meshrotation.deleteMap()
	table.remove(mc_meshrotation.mapList, mc_meshrotation.currentlyeditedmap)
	Settings.GW2Minion.Maprotation_MapList = mc_meshrotation.mapList
	mc_meshrotation.updateMaprotationList()
end

function mc_meshrotation.saveMap()
	mc_meshrotation.updateMaprotationList()
end

--GetClosest WP Data
function mc_meshrotation.getclosestWP()
	local id,wp = next(WaypointList("nearest,onmesh,samezone"))
	if (id and wp ) then
		mc_meshrotation.mapList[mc_meshrotation.currentlyeditedmap].name = mc_datamanager.GetMapName( Player:GetLocalMapID() ).."_"..wp.name.."("..wp.id..")"
		MapRota_Name = mc_datamanager.GetMapName( Player:GetLocalMapID() ).."_"..wp.name.."("..wp.id..")"
		mc_meshrotation.mapList[mc_meshrotation.currentlyeditedmap].wpid = wp.id
		MapRota_WPID = wp.id
		mc_meshrotation.mapList[mc_meshrotation.currentlyeditedmap].wpname = wp.name
		MapRota_WPName = wp.name		
	else
		ml_error("No Waypoint on Navmesh found!")
	end
end


function mc_meshrotation.GetNextMap()
	if ( TableSize(mc_meshrotation.mapList) > 0 ) then
		
		-- Set first run switch time, no need to switch already.
		if (mc_meshrotation.currentSwitchTime == nil) then
			mc_meshrotation.currentMapIndex = mc_meshrotation.GetCurrentMapIndex()
			local timeval = tonumber(mc_meshrotation.mapList[mc_meshrotation.currentMapIndex].switchtime)*60000
			mc_meshrotation.currentSwitchTime = math.random(timeval - ((timeval/100)*15), timeval + ((timeval/100)*15))
			mc_meshrotation.currentMapTime = mc_global.now
		end
		
		if ( TableSize(mc_meshrotation.mapList[mc_meshrotation.currentMapIndex])>0 ) then
			
			-- Return the "next map" until we are actually on the next map
			if ( Player:GetLocalMapID() ~= mc_meshrotation.mapList[mc_meshrotation.currentMapIndex].mapid ) then
				gMaprotationStatus = "Switch to "..mc_meshrotation.mapList[mc_meshrotation.currentMapIndex].name
				local timeval = tonumber(mc_meshrotation.mapList[mc_meshrotation.currentMapIndex].switchtime)*60000
				mc_meshrotation.currentSwitchTime = math.random(timeval - ((timeval/100)*15), timeval + ((timeval/100)*15))
				return mc_meshrotation.mapList[mc_meshrotation.currentMapIndex]
			end
			
			-- Get the next map if timer is up
			if ( mc_global.now - mc_meshrotation.currentMapTime > mc_meshrotation.currentSwitchTime and Player.inCombat == false) then
				
				d("Time to switch to the next map...")
				mc_meshrotation.currentMapIndex = mc_meshrotation.currentMapIndex + 1
				
				if ( mc_meshrotation.currentMapIndex > TableSize(mc_meshrotation.mapList) ) then
					-- Start from top of the list
					mc_meshrotation.currentMapIndex = 1
				end
				
				mc_meshrotation.currentMapTime = mc_global.now
				
				if ( TableSize(mc_meshrotation.mapList[mc_meshrotation.currentMapIndex])>0 ) then
					local timeval = tonumber(mc_meshrotation.mapList[mc_meshrotation.currentMapIndex].switchtime)*60000
					mc_meshrotation.currentSwitchTime = math.random(timeval - ((timeval/100)*15), timeval + ((timeval/100)*15))
					return mc_meshrotation.mapList[mc_meshrotation.currentMapIndex]
				else
					ml_error("mc_meshrotation.mapList[mc_meshrotation.currentMapIndex]) is nil !?")
				end
			elseif ( mc_global.now - mc_meshrotation.currentMapTime > mc_meshrotation.currentSwitchTime and Player.inCombat == true) then
				gMaprotationStatus = "Player in combat, switching when done"
			else
				gMaprotationStatus = "Switch in " .. round(tonumber(mc_meshrotation.currentSwitchTime - (mc_global.now - mc_meshrotation.currentMapTime))/60000) .. " minutes"
			end
		end
	end
	return nil
end

function mc_meshrotation.GetCurrentMapIndex()
	local mapID = Player:GetLocalMapID()
	for index,info in pairs(mc_meshrotation.mapList) do
		if (info.mapid == mapID) then
			return index
		end
	end
	return 1
end


mc_meshrotation.nextWP = nil
function mc_meshrotation.Update()
	-- MapRotation Check
	if (Maprotation_Active == "1" ) then 
		mc_meshrotation.nextWP = mc_meshrotation.GetNextMap()
		if ( Player.inCombat == false ) then		
			if ( mc_meshrotation.nextWP ~= nil and mc_meshrotation.nextWP.mapid ~= Player:GetLocalMapID() ) then
				-- we need to switch maps
				if ( tonumber(mc_meshrotation.nextWP.wpid)~= nil and Inventory:GetInventoryMoney() > 500) then
					d("Teleporting to Waypoint "..mc_meshrotation.nextWP.name.." ID: "..tostring(mc_meshrotation.nextWP.wpid))
					if ( Player:TeleportToWaypoint(mc_meshrotation.nextWP.wpid) == false ) then
						d("Seems we cannot use the targeted waypoint to switch maps, is that waypoint explored ?")
					else
						d("Teleported to new waypoint")
						mc_global.Wait(2000)
					end				
				else
					ml_error(" The Map in your Maprotation has NO WAYPOINT setup or we are out of money")
				end	
			end
		end
	end
	return false
end


--Save UI data.
function mc_meshrotation.GUIVarUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		if ( k == "Maprotation_Active" ) then Settings.GW2Minion[tostring(k)] = v
		elseif (k == "MapRota_Name" or
				k == "MapRota_WPName" or 
				k == "MapRota_SwitchTime")
		then
			mc_meshrotation.mapList[mc_meshrotation.currentlyeditedmap].name = MapRota_Name
			mc_meshrotation.mapList[mc_meshrotation.currentlyeditedmap].wpname = MapRota_WPName
			mc_meshrotation.mapList[mc_meshrotation.currentlyeditedmap].switchtime = MapRota_SwitchTime
			
		end
		Settings.GW2Minion.Maprotation_MapList = mc_meshrotation.mapList
	end
end

function mc_meshrotation.ToggleMenu()
	if (mc_meshrotation.visible) then
		GUI_WindowVisible(mc_meshrotation.mainwindow.name,false)
		GUI_WindowVisible(mc_meshrotation.editwindow.name,false)
		mc_meshrotation.visible = false
	else
		local wnd = GUI_GetWindowInfo("MinionBot")
		GUI_MoveWindow( mc_meshrotation.mainwindow.name, wnd.x+wnd.width,wnd.y) 
		GUI_WindowVisible(mc_meshrotation.mainwindow.name,true)
		mc_meshrotation.visible = true
	end
end



RegisterEventHandler("MapRotation.toggle", mc_meshrotation.ToggleMenu)
RegisterEventHandler("GUI.Update",mc_meshrotation.GUIVarUpdate)
RegisterEventHandler("Module.Initalize",mc_meshrotation.ModuleInit)