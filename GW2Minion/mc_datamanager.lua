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

RegisterEventHandler("Module.Initalize",mc_datamanager.ModuleInit)

