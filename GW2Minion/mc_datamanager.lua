-- Map & Itemdata manager
mc_datamanager = { }
mc_datamanager.path = GetStartupPath().. [[\LuaMods\GW2Minion\maps.data]]
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
			d(TableSize(mc_datamanager.mapData[mapid]))
			name = mc_datamanager.mapData[mapid]["map_name"]			
			d(mc_datamanager.mapData[mapid]["map_name"])
		end
	end	
	return name
end

function mc_datamanager.GetLocalMapData( mapid )
	mdata = nil
	if ( TableSize(mc_datamanager.mapData) > 0 and tonumber(mapid)~=nil) then
		d(TableSize(mc_datamanager.mapData[mapid]))
		if ( TableSize(mc_datamanager.mapData[mapid]) > 0 ) then
			mdata = mc_datamanager.mapData[mapid]
			d(TableSize(mdata))
		end
	end	
	return mdata
end

 --*         recalc_coords([[9856,11648],[13440,14080]], [[-43008,-27648],[43008,30720]], [9835,-17597])
 --*         -> [12058, 13661] 
function mc_helper.recalc_coords(continent_rect, map_rect, coords)
	--return [
	--	Math.round(continent_rect[0][0]+(continent_rect[1][0]-continent_rect[0][0])*(coords[0]-map_rect[0][0])/(map_rect[1][0]-map_rect[0][0])),
	--	Math.round(continent_rect[0][1]+(continent_rect[1][1]-continent_rect[0][1])*(1-(coords[1]-map_rect[0][1])/(map_rect[1][1]-map_rect[0][1])))
	--]
end

RegisterEventHandler("Module.Initalize",mc_datamanager.ModuleInit)

