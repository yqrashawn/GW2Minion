-- Map & Itemdata manager
gw2_datamanager = { }
gw2_datamanager.path = GetStartupPath().. [[\LuaMods\GW2Minion\map_data.lua]]
gw2_datamanager.mapData = {}
gw2_datamanager.levelmap = {} -- Create a "2D - Levelmap/Table" which provides us an avg. level for all other entries in the zone, also for random navigation


function gw2_datamanager.ModuleInit()
	if(FileExists(gw2_datamanager.path)) then
		local mdata = FileLoad(gw2_datamanager.path)
		if(table.valid(mdata)) then
			d("Map data loaded: "..tostring(table.size(mdata)).." entries found")
			gw2_datamanager.mapData = mdata
		end
	end
end

function gw2_datamanager.GetLocalMapData(mapid)
	local mdata = nil
	mapid = tonumber(mapid)

	if(table.valid(gw2_datamanager.mapData) and mapid) then
		if(table.valid(gw2_datamanager.mapData[mapid])) then
			mdata = gw2_datamanager.mapData[mapid]
		end
	end
	return mdata
end

function gw2_datamanager.GetMapName(mapid)
	local mdata = gw2_datamanager.GetLocalMapData(mapid)
	local name = "Unknown ID: "..tostring(mapid)

	if (table.valid(mdata) and string.valid(mdata["map_name"])) then
		name = mdata["map_name"]
	end

	return name
end

function gw2_datamanager.GetMapNameList(nav, sort)
	nav = nav == nil and true or false
	sort = sort == nil and true or false

	local maplist = {}
	local mapnamelist = {}

	for mapID,map in pairs(gw2_datamanager.mapData) do
		if(not nav or ml_nav_manager.GetNode(mapID)) then
			local mname = string.valid(map.map_name) and string.gsub(map.map_name,"^%s","") or "Unknown"
			local name = mname.." ("..mapID..")"

			table.insert(maplist, {id = mapID, name = name})
		end
	end

	if(table.valid(maplist)) then
		if(sort) then
			table.sort(maplist, function(a,b) return a.name < b.name end)
		end

		for i=1,#maplist do
			table.insert(mapnamelist, maplist[i].name)
		end
	end

	return maplist, mapnamelist
end

function gw2_datamanager.GetLocalWaypointList(mapid)
	local wdata = {}
	local mdata = gw2_datamanager.GetLocalMapData(mapid)

	if (table.valid(mdata) and table.valid(mdata["floors"]) and table.valid(mdata["floors"])) then
		for _,floorData in pairs(mdata["floors"]) do
			if (table.valid(floorData)) then
				local poiData = floorData["points_of_interest"]
				if (table.valid(poiData)) then
					for id,data in pairs(poiData) do
						local wInfo = WaypointList()[id]
						if (not table.valid(wInfo)) then
							wInfo = WorldMap:WaypointList()[id]
						end
						if (table.valid(data) and table.valid(wInfo) and data["type"] == "waypoint") then

							local pos = table.valid(wInfo.pos) and wInfo.pos or {
								x = gw2_datamanager.recalc_coords(mdata["continent_rect"],mdata["map_rect"],data["coord"])[1],
								y = gw2_datamanager.recalc_coords(mdata["continent_rect"],mdata["map_rect"],data["coord"])[2],
								z = 0,
							}

							local newWdata = {
								id = id,
								name = data["name"],
								pos = pos,
								discovered = table.valid(wInfo),
								unlocked = table.valid(wInfo) and wInfo.unlocked == true or false,
								contested =  wInfo.contested == true,
								onmesh = not (wInfo.onmesh == false),
								distance = wInfo.distance or nil,
								mapid = mapid
							}

							table.insert(wdata,newWdata)
						end
					end
				end
			end
		end
	end

	return table.valid(wdata) and wdata or nil
end

function gw2_datamanager.GetLocalWaypointListByDistance(mapID, pos)
	pos = table.valid(pos) and pos or ml_global_information.Player_Position
	mapID = mapID ~= nil and mapID or ml_global_information.CurrentMapID
	local mapData = gw2_datamanager.GetLocalWaypointList(mapID)

	if (table.valid(mapData)) then
		for _,waypoint in pairs(mapData) do
			waypoint.distance2D = math.distance2d(waypoint.pos.x,waypoint.pos.y,pos.x,pos.y)
			-- Update distance to use input pos
			if(waypoint.distance) then
				waypoint.distance = math.distance3d(waypoint.pos,pos)
			end
		end

		table.sort(mapData, function(a,b)
			if(a.distance and b.distance) then
				return a.distance < b.distance
			else
				return a.distance2D < b.distance2D
			end
		end)
	end

	return mapData
end

-- converts the coordinates from the data file to ingame coordinates
function gw2_datamanager.recalc_coords(continent_rect, map_rect, coords)
	local contrec = {}
	for word in string.gmatch(tostring(continent_rect), '[%-]?%d+.%d+') do table.insert(contrec,word) end
	local maprec = {}
	for word in string.gmatch(tostring(map_rect), '[%-]?%d+.%d+') do table.insert(maprec,word) end
	local coord = {}
	for word in string.gmatch(tostring(coords), '[%-]?%d+.%d+') do table.insert(coord,word) end

	--[[d(continent_rect)
	d(contrec[1])
	d(contrec[2])
	d(contrec[3])
	d(contrec[4])

	d(map_rect)
	d(maprec[1])
	d(maprec[2])
	d(maprec[3])
	d(maprec[4])

	d(coords)
	d(coord[1])
	d(coord[2])]]

	if ( table.size(contrec) ~= 4 or table.size(maprec)~=4 or table.size(coord)~= 2) then
		d("Error in reading mapcoords!")
	end

   return {
        (coord[1]-contrec[1])/(contrec[3]-contrec[1])*(maprec[3]-maprec[1])+maprec[1],
        -((coord[2]-contrec[2])/(contrec[4]-contrec[2])*(maprec[4]-maprec[2])+maprec[2])
    }
end

-- Needs to be called when a new zone is beeing entered!
function gw2_datamanager.UpdateLevelMap()
	gw2_datamanager.levelmap = {}

	local mdata = gw2_datamanager.GetLocalMapData(Player:GetLocalMapID())

	if(table.valid(mdata) and table.valid(mdata["floors"])) then
		for _,floor in pairs(mdata["floors"]) do
			local sectors = floor["sectors"]
			local tasks = floor["tasks"]

			if(table.valid(sectors)) then
				for _,sector in pairs(sectors) do
					local realpos = gw2_datamanager.recalc_coords(mdata["continent_rect"], mdata["map_rect"], sector["coord"])
					local position = { x=realpos[1], y=realpos[2], z=-2500}
					table.insert(gw2_datamanager.levelmap, { pos = position, level = sector["level"] } )
				end
			end

			if(table.valid(tasks)) then
				for _,task in pairs(tasks) do
					local realpos = gw2_datamanager.recalc_coords(mdata["continent_rect"], mdata["map_rect"], task["coord"])
					local position = { x=realpos[1], y=realpos[2], z=-2500}
					table.insert(gw2_datamanager.levelmap, { pos = position, level = task["level"] } )
				end
			end
		end
	end

	d("Generated levelmap with "..table.size(gw2_datamanager.levelmap).. " entries")
end

-- picks a random point of interest in the map within levelrange +/-2, tries to get the z axis by a mesh check
function gw2_datamanager.GetRandomPositionInLevelRange(level)
	if (table.valid(gw2_datamanager.levelmap) and table.valid(ml_global_information.Player_Position)) then
		local possiblelocations = {}
		local pPos = ml_global_information.Player_Position
		for _,entry in pairs(gw2_datamanager.levelmap) do
			if (entry.level <= level + 2 and math.distance2d(entry.pos,pPos) > 2500 ) then
				local pos3D = NavigationManager:GetClosestPointOnMeshFrom2D( entry.pos )
				if ( pos3D and pos3D.x ~= 0 and pos3D.y ~= 0 ) then
					table.insert(possiblelocations, pos3D)
				end
			end
		end

		if(table.valid(possiblelocations)) then
			return table.randomvalue(possiblelocations)
		end
	end

	return nil
end

RegisterEventHandler("Module.Initalize",gw2_datamanager.ModuleInit)
RegisterEventHandler("Gameloop.MeshReady",gw2_datamanager.UpdateLevelMap)
