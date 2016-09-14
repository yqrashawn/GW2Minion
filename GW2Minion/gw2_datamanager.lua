-- Map & Itemdata manager
gw2_datamanager = { }
gw2_datamanager.path = GetStartupPath().. [[\LuaMods\GW2Minion\map_data.lua]]
gw2_datamanager.mapData = {}
gw2_datamanager.levelmap = {} -- Create a "2D - Levelmap/Table" which provides us an avg. level for all other entries in the zone, also for random navigation


function gw2_datamanager.ModuleInit() 	

	gw2_datamanager.mapData = persistence.load(gw2_datamanager.path)
	d("Mapdata loaded, "..tostring(table.size(gw2_datamanager.mapData)).." entries found")
	
end

function gw2_datamanager.GetMapName( mapid )
	local name = "Unknown ID:"..tostring(mapid)
	if ( table.size(gw2_datamanager.mapData) > 0 and tonumber(mapid)~=nil) then
		if ( table.size(gw2_datamanager.mapData[mapid]) > 0 ) then
			name = gw2_datamanager.mapData[mapid]["map_name"]	
		end
	end	
	return name
end

function gw2_datamanager.GetLocalMapData( mapid )
	mdata = nil
	if ( table.size(gw2_datamanager.mapData) > 0 and tonumber(mapid)~=nil) then
		if ( table.size(gw2_datamanager.mapData[mapid]) > 0 ) then
			mdata = gw2_datamanager.mapData[mapid]
		end
	end	
	return mdata
end

function gw2_datamanager.GetLocalWaypointList( mapid )
	wdata = {}
	if (table.valid(gw2_datamanager.mapData) and tonumber(mapid)) then
		local mapData = gw2_datamanager.mapData[mapid]
		if (table.valid(mapData) and table.valid(mapData["floors"]) and table.valid(mapData["floors"])) then
			local _,floorData = next(mapData["floors"])
			if (table.valid(floorData)) then
				local poiData = floorData["points_of_interest"]
				if (table.valid(poiData)) then
					for id,data in pairs(poiData) do
						local wInfo = WaypointList:Get(id)
						if (table.valid(data) and table.valid(wInfo) and data["type"] == "waypoint") then
							local pos = {
								x = gw2_datamanager.recalc_coords(mapData["continent_rect"],mapData["map_rect"],data["coord"])[1],
								y = gw2_datamanager.recalc_coords(mapData["continent_rect"],mapData["map_rect"],data["coord"])[2],
								z = 0,
							}
							local newWdata = {
								id = id,
								name = data["name"],
								pos = (table.valid(wInfo.pos) and wInfo.pos or pos),
								discovered = table.valid(wInfo),
								contested =  wInfo.contested == true,
								onmesh = not (wInfo.onmesh == false),
								distance = wInfo.distance or nil
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

function gw2_datamanager.GetLocalWaypointListByDistance(mapID,pos)
	pos = pos ~= nil and pos or ml_global_information.Player_Position
	mapID = mapID ~= nil and mapID or ml_global_information.CurrentMapID
	local mapData = gw2_datamanager.GetLocalWaypointList(mapID)
	
	if (table.valid(mapData)) then
		for _,waypoint in pairs(mapData) do
			waypoint.distance2D = Distance2D(waypoint.pos.x,waypoint.pos.y,pos.x,pos.y)
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
	local mdata = gw2_datamanager.GetLocalMapData( Player:GetLocalMapID() )
	if ( table.size(mdata) > 0 and table.size(mdata["floors"]) > 0 and table.size(mdata["floors"][0]) > 0) then
		local data = mdata["floors"][0]
		-- tasks & sectors have 2D Map coords and level info
		local sectors = mdata["floors"][0]["sectors"]
		local tasks = mdata["floors"][0]["tasks"]		
		
		gw2_datamanager.levelmap = {} -- Create a "2D - Levelmap/Table" which provides us an avg. level for all other entries in the zone
		local id,entry = next (sectors)
		while id and entry do			
			local realpos = gw2_datamanager.recalc_coords(mdata["continent_rect"], mdata["map_rect"], entry["coord"])
			local position = { x=realpos[1], y=realpos[2], z=-2500}			
			table.insert(gw2_datamanager.levelmap, { pos=position, level = entry["level"] } )			
			id,entry = next(sectors,id)
		end
		
		-- HEARTQUESTS
		local id,entry = next (tasks)
		while id and entry do			
			local realpos = gw2_datamanager.recalc_coords(mdata["continent_rect"], mdata["map_rect"], entry["coord"])
			local position = { x=realpos[1], y=realpos[2], z=-2500}
			table.insert(gw2_datamanager.levelmap, { pos=position , level = entry["level"] } )			
			id,entry = next(tasks,id)
		end
		d("Generated LevelMap with "..table.size(gw2_datamanager.levelmap).. " Entries")
	end
end

-- picks a random point of interest in the map within levelrange +/-2, tries to get the z axis by a mesh check 
function gw2_datamanager.GetRandomPositionInLevelRange( level )
	local pPos = Player.pos
	if ( table.size(gw2_datamanager.levelmap) > 0 and table.size(pPos) > 0) then
		local possiblelocations = {}		
		local id,entry = next (gw2_datamanager.levelmap)
		while id and entry do
			if ( entry.level <= level + 2 and Distance2D(entry.pos.x, entry.pos.y, pPos.x, pPos.y) > 2500 ) then
				local pos3D = NavigationManager:GetClosestPointOnMeshFrom2D( entry.pos )
				if ( pos3D and pos3D.x ~= 0 and pos3D.y ~= 0 ) then
					table.insert(possiblelocations, pos3D )
				end
			end
			id,entry = next(gw2_datamanager.levelmap,id)
		end
		
		if ( table.size(possiblelocations) > 0 ) then
			local i = math.random(1,table.size(possiblelocations))
			return possiblelocations[i]
		else
			d("No possible random locations to goto found")
		end
	else
		d("gw2_datamanager.levelmap is empty!")
	end
	return nil
end

RegisterEventHandler("Module.Initalize",gw2_datamanager.ModuleInit)
RegisterEventHandler("Gameloop.MeshReady",gw2_datamanager.UpdateLevelMap)
