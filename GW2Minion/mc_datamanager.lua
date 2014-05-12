-- Map & Itemdata manager
mc_datamanager = { }
mc_datamanager.path = GetStartupPath().. [[\LuaMods\GW2Minion\mapdata.lua]]
mc_datamanager.mapData = {}
mc_datamanager.levelmap = {} -- Create a "2D - Levelmap/Table" which provides us an avg. level for all other entries in the zone, also for random navigation

mc_datamanager.ServersUS = {		
	{id=1010,name="Ehmry Bay"},
	{id=1018,name="Northern Shiverpeaks"},
	{id=1002,name="Borlis Pass"},
	{id=1008,name="Jade Quarry"},
	{id=1005,name="Maguuma"},
	{id=1015,name="Isle of Janthir"},
	{id=1009,name="Fort Aspenwood"},
	{id=1013,name="Sanctum of Rall"},
	{id=1007,name="Gate of Madness"},
	{id=1006,name="Sorrow's Furnace"},
	{id=1019,name="Blackgate"},
	{id=1021,name="Dragonbrand"},
	{id=1012,name="Darkhaven"},
	{id=1003,name="Yak's Bend"},
	{id=1014,name="Crystal Desert"},
	{id=1001,name="Anvil Rock"},
	{id=1011,name="Stormbluff Isle"},
	{id=1020,name="Ferguson's Crossing"},
	{id=1016,name="Sea of Sorrows"},
	{id=1022,name="Kaineng"},
	{id=1023,name="Devona's Rest"},
	{id=1017,name="Tarnished Coast"},
	{id=1024,name="Eredon Terrace"},
	{id=1004,name="Henge of Denravi"}
	}	
mc_datamanager.ServersEU = {
	{id=2012,name="Piken Square"},
	{id=2003,name="Gandara"},
	{id=2007,name="Far Shiverpeaks"},
	{id=2204,name="Abaddon's Mouth [DE]"},
	{id=2201,name="Kodash [DE]"},
	{id=2010,name="Seafarer's Rest"},
	{id=2301,name="Baruch Bay [SP]"},
	{id=2205,name="Drakkar Lake [DE]"},
	{id=2002,name="Desolation"},
	{id=2202,name="Riverside [DE]"},
	{id=2008,name="Whiteside Ridge"},
	{id=2203,name="Elona Reach [DE]"},
	{id=2206,name="Miller's Sound [DE]"},
	{id=2004,name="Blacktide"},
	{id=2207,name="Dzagonur [DE]"},
	{id=2105,name="Arborstone [FR]"},
	{id=2101,name="Jade Sea [FR]"},
	{id=2013,name="Aurora Glade"},
	{id=2103,name="Augury Rock [FR]"},
	{id=2102,name="Fort Ranik [FR]"},
	{id=2104,name="Vizunah Square [FR]"},
	{id=2009,name="Ruins of Surmia"},
	{id=2014,name="Gunnar's Hold"},
	{id=2005,name="Ring of Fire"},
	{id=2006,name="Underworld"},
	{id=2011,name="Vabbi"},
	{id=2001,name="Fissure of Woe"}
}



function mc_datamanager.ModuleInit() 	
	
	mc_datamanager.LoadMapData()
	
end

function mc_datamanager.LoadMapData()
	mc_datamanager.mapData = persistence.load(mc_datamanager.path)
	d("Mapdata loaded, "..tostring(TableSize(mc_datamanager.mapData)).." entries found")
end

--d(mc_datamanager.GetMapName(19))
function mc_datamanager.GetMapName( mapid )
	local name = "Unknown"
	if ( TableSize(mc_datamanager.mapData) > 0 and tonumber(mapid)~=nil) then
		if ( TableSize(mc_datamanager.mapData[mapid]) > 0 ) then
			name = mc_datamanager.mapData[mapid]["map_name"]	
		end
	end	
	return name
end

function mc_datamanager.GetLocalMapData( mapid )
	mdata = nil
	if ( TableSize(mc_datamanager.mapData) > 0 and tonumber(mapid)~=nil) then
		if ( TableSize(mc_datamanager.mapData[mapid]) > 0 ) then
			mdata = mc_datamanager.mapData[mapid]
		end
	end	
	return mdata
end


function mc_datamanager.recalc_coords(continent_rect, map_rect, coords)
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
	
	if ( TableSize(contrec) ~= 4 or TableSize(maprec)~=4 or TableSize(coord)~= 2) then
		d("Error in reading mapcoords!")
	end

   return {
        (coord[1]-contrec[1])/(contrec[3]-contrec[1])*(maprec[3]-maprec[1])+maprec[1],
        -((coord[2]-contrec[2])/(contrec[4]-contrec[2])*(maprec[4]-maprec[2])+maprec[2])
    }
end

function mc_datamanager.UpdateLevelMap()
	local mdata = mc_datamanager.GetLocalMapData( Player:GetLocalMapID() )
	if ( TableSize(mdata) > 0 and TableSize(mdata["floors"]) > 0 and TableSize(mdata["floors"][0]) > 0) then
		local data = mdata["floors"][0]
		
		-- tasks & sectors have 2D Map coords and level info
		local sectors = mdata["floors"][0]["sectors"]
		local tasks = mdata["floors"][0]["tasks"]		
		
		mc_datamanager.levelmap = {} -- Create a "2D - Levelmap/Table" which provides us an avg. level for all other entries in the zone
		local id,entry = next (sectors)
		while id and entry do			
			local realpos = mc_datamanager.recalc_coords(mdata["continent_rect"], mdata["map_rect"], entry["coord"])
			local position = { x=realpos[1], y=realpos[2], z=-2500}			
			table.insert(mc_datamanager.levelmap, { pos=position, level = entry["level"] } )			
			id,entry = next(sectors,id)
		end
		
		-- HEARTQUESTS
		local id,entry = next (tasks)
		while id and entry do			
			local realpos = mc_datamanager.recalc_coords(mdata["continent_rect"], mdata["map_rect"], entry["coord"])
			local position = { x=realpos[1], y=realpos[2], z=-2500}
			table.insert(mc_datamanager.levelmap, { pos=position , level = entry["level"] } )			
			id,entry = next(tasks,id)
		end
		d("Generated LevelMap with "..TableSize(mc_datamanager.levelmap).. " Entries")
	end
end


function mc_datamanager.GetRandomPositionInLevelRange( level )
	local pPos = Player.pos
	if ( TableSize(mc_datamanager.levelmap) > 0 and TableSize(pPos) > 0) then
		local possiblelocations = {}		
		local id,entry = next (mc_datamanager.levelmap)
		while id and entry do
			if ( entry.level <= level + 2 and Distance2D(entry.pos.x, entry.pos.y, pPos.x, pPos.y) > 2500 ) then
				local pos3D = NavigationManager:GetClosestPointOnMeshFrom2D( entry.pos )
				if ( pos3D and pos3D.x ~= 0 and pos3D.y ~= 0 ) then
					table.insert(possiblelocations, pos3D )
				end
			end
			id,entry = next(mc_datamanager.levelmap,id)
		end
		
		if ( TableSize(possiblelocations) > 0 ) then
			local i = math.random(1,TableSize(possiblelocations))
			return possiblelocations[i]
		else
			d("No possible random locations to goto found")
		end
	else
		d("mc_datamanager.levelmap is empty!")
	end
	return nil
end

RegisterEventHandler("Module.Initalize",mc_datamanager.ModuleInit)

