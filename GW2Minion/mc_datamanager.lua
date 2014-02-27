-- Map & Itemdata manager
mc_datamanager = { }
mc_datamanager.path = GetStartupPath().. [[\LuaMods\GW2Minion\mapsdata.lua]]
mc_datamanager.mapData = {}

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


RegisterEventHandler("Module.Initalize",mc_datamanager.ModuleInit)

