-------------------------------------------
--Marker Stuff
-------------------------------------------
function mm.UpdateMarkerList()
    -- setup markers
    local markers = "None"
    for tag, posList in pairs(mm.MarkerList) do
        for key, pos in pairs(posList) do
            markers = markers..","..key
        end
    end

    gSelectedMarker_listitems = markers
    gMarkerName = ""
    gMarkerMinLevel = "1"
    gMarkerMaxLevel = "80"
    gSelectedMarker = "None"
        
end

function mm.GetMarkerInfo(markerName)
    for tag, list in pairs(mm.MarkerList) do
        for key, info in pairs(list) do
            if (key == markerName) then
                return info
            end
        end
    end
    
    return nil
end

function mm.SetMarkerData(markerName, data)
    for tag, list in pairs(mm.MarkerList) do
        for key, info in pairs(list) do
            if (key == markerName) then
                info.data = data
                mm.WriteMarkerList(gmeshname)
                return true
            end
        end
    end
    
    return false
end

function mm.SetMarkerTime(markerName, time)
    for tag, list in pairs(mm.MarkerList) do
        for key, info in pairs(list) do
            if (key == markerName) then
                info.time = time
                mm.WriteMarkerList(gmeshname)
                return true
            end
        end
    end
    
    return false
end

function mm.GetMarkerType(marker)
    for tag, posList in pairs(mm.MarkerList) do
        if posList[marker] ~= nil then
            return tag
        end
    end
end

function mm.SelectClosestMarker()
    local closestDistance = 999999999
    local closestMarker = nil
    local closestTag = nil
    for tag, posList in pairs(mm.MarkerList) do
        for key, pos in pairs(posList) do
            local myPos = Player.pos
            local distance = Distance2D(myPos.x, myPos.z, pos.x, pos.z)
            if (closestMarker == nil or distance < closestDistance) then
                closestMarker = key
                closestDistance = distance
                closestTag = tag
            end
        end
    end
    
    if (closestMarker ~= nil) then
        mm.SelectMarker(closestMarker)
    end
    
    return false
end

function mm.SelectMarker(markerName)
    if (markerName ~= nil and markerName ~= "") then
        gSelectedMarker = markerName
        gMarkerName = markerName
        local info = mm.GetMarkerInfo(markerName)
        gMarkerMinLevel = tostring(info.minlevel)
        gMarkerMaxLevel = tostring(info.maxlevel)
        return true
    end
    
    if (markerName == "None") then
        gMarkerName = ""
        gMarkerLevel = ""
    end
    return false
end

function mm.MoveToMarker()
    local info = mm.GetMarkerInfo(gMarkerName)
    if (info ~= nil and info ~= 0) then
        local pos = {x = info.x, y = info.y, z = info.z}
        if (NavigationManager:GetPointToMeshDistance(pos)<=3) then
            Player:MoveTo(pos.x,pos.y,pos.z)
        else
            d("Currently selected marker is not on the currently loaded NavMesh or no mesh is loaded")
        end
    end
end

function mm.AddMarker(arg)
    local markerType = ""
    local markerData = {"None"}
    if (arg == "addGrindSpotEvent") then
        markerType = "grindSpot"
        markerData = {""}    
    elseif (arg == "addNavSpotEvent") then
        markerType = "navSpot"
        markerData = {""}	
    end
    
    -- all markers are accessed using MESH ONLY movement functions
    -- allowing them to be created off mesh is not only useless its an invitation for bugs and user confusion
    if(1==1) then
        if (gMarkerName ~= "" and gMarkerName ~= "None") then
            p = Player.pos
            
            local newInfo = { 	x=tonumber(string.format("%.2f", p.x)), 
                                y=tonumber(string.format("%.2f", p.y)), 
                                z=tonumber(string.format("%.2f", p.z)), 
                                h=tonumber(string.format("%.3f", p.hx)), 
                                minlevel=tonumber(gMarkerMinLevel),
                                maxlevel=tonumber(gMarkerMaxLevel), 
                                time=math.random(900,1800), --default to 15-30mins for markers 
                                data=markerData }
            local key = gMarkerName
            local found = false
            
            -- enforce unique marker names
            for tag, list in pairs(mm.MarkerList) do
                for name, info in pairs(list) do
                    if (key == name) then
                        found = true
                        if (tag == markerType) then
                            if (mm.MarkerRenderList[key]) then
                                RenderManager:RemoveObject(mm.MarkerRenderList[key])
                            end
                            mm.MarkerRenderList[key] = mm.DrawMarker( p, markerType )
                            list[key] = newInfo
                        else
                            d("This marker name cannot be used as it conflicts with another marker of a different type")
                        end
                    end
                end
            end
            
            if (not found) then
                local list = mm.MarkerList[markerType]
                
                -- First time we are creating this marker, so we create a new object to be drawn here
                if ( list[key] == nil )	then
                    mm.MarkerRenderList[key] = mm.DrawMarker( p, markerType )
                end
                list[key] = newInfo
            end
            
        else
            d("Must provide a name for marker")
        end
        
        mm.WriteMarkerList(gmeshname)
        mm.UpdateMarkerList()
    else
        mc_error("Current player position is not on a valid NavMesh or current NavMesh has not been saved. If you are building a new NavMesh please save the mesh and try again.")
    end 
end

function mm.DeleteMarker()
    -- since marker names are unique we can simply delete this marker wherever it exists
    for tag, posList in pairs(mm.MarkerList) do
        if (posList[gMarkerName] ~= nil) then            
            posList[gMarkerName] = nil
            --d("REMOVE MARKER ID "..tostring(mm.MarkerRenderList[gMarkerName]))
            RenderManager:RemoveObject(mm.MarkerRenderList[gMarkerName])
            mm.MarkerRenderList[gMarkerName] = nil
            mm.WriteMarkerList(gmeshname)
            mm.UpdateMarkerList()
            return true
        end
    end
   
    return false
end

function mm.ReadMarkerList(meshname)
    -- clear old lists for previous mesh
    for tag, list in pairs(mm.MarkerList) do
        mm.MarkerList[tag] = {}
    end
    
    -- helper functions located in ml_utility.lua
    local lines = LinesFrom(mm.navmeshfilepath..meshname..".info")
    local version = 0
    if ( TableSize(lines) > 0) then
        for i, line in pairs(lines) do
			
		
            local sections = {}
            for section in StringSplit(line,":") do
                table.insert(sections, section)
            end
            local tag = nil
            local key = nil
            local mark = string.find(sections[1], "=")
            if (mark ~= nil) then
                tag = sections[1]:sub(0,mark-1)
                key = sections[1]:sub(mark+1)
            end
            if ( tag == "MapID" ) then
                mm.mapID = tonumber(key)
            elseif (tag == "evacPoint") then
                local posTable = {}
                for coord in StringSplit(key,",") do
                    table.insert(posTable, tonumber(coord))
                end
                if (TableSize(posTable) == 3) then
                    mm.evacPoint = { x = tonumber(posTable[1]), y = tonumber(posTable[2]), z = tonumber(posTable[3]) }
                end	
            elseif (tag == "version") then
                version = tonumber(key)
            else
                local posTable = {}
                for coord in StringSplit(sections[2],",") do
                    table.insert(posTable, tonumber(coord))
                end
                local i = 4
                local markerMinLevel = 1
                local markerMaxLevel = 50
                if (version == 1) then
                    markerMinLevel = tonumber(sections[3])
                    markerMaxLevel = tonumber(sections[4])
                    i = 5
                else
                    markerMinLevel = tonumber(sections[3])
                    markerMaxLevel = tonumber(sections[3])
                end
                
                local markerTime = tonumber(sections[i])
                local dataTable = {}
                for data in StringSplit(sections[i+1],",") do
                    table.insert(dataTable, data)
                end
                
                -- add the marker to the list
                local list = mm.MarkerList[tag]
                -- Remove old Marker
                if (mm.MarkerRenderList[key]) then
                    RenderManager:RemoveObject(mm.MarkerRenderList[key])
                end
                -- Draw this Marker
                mm.MarkerRenderList[key] = mm.DrawMarker( {x=tonumber(posTable[1]),y=tonumber(posTable[2]),z=tonumber(posTable[3])}, tag )
                
                list[key] = {x=posTable[1],y=posTable[2],z=posTable[3],h=posTable[4],minlevel=markerMinLevel,maxlevel=markerMaxLevel,time=markerTime,data=dataTable}
                                
            end
        end
    else
        d("NO INFO FILE FOR THAT MESH EXISTS")
    end
    
    -- Update the markerlist regardless so we clear the gather marker info in the gathermanager
    mm.UpdateMarkerList()
end

function mm.WriteMarkerList(meshname)
    
    if ( meshname ~= "" and meshname ~= nil ) then
        d("Generating .info file..")
        local string2write = ""
        string2write = string2write.."version="..tostring(mm.version).."\n"
        -- Save the mapID first
        string2write = string2write.."MapID="..Player:GetLocalMapID().."\n"
        -- Write the evac point if it exists
        if (mm.evacPoint ~= nil and mm.evacPoint ~= 0) then
            local pos = mm.evacPoint
            string2write = string2write.."evacPoint="..tostring(pos.x)..","..tostring(pos.y)..","..tostring(pos.z).."\n"
        end
        for tag, posList in pairs(mm.MarkerList) do  
            if ( tag ~= "MapID" and tag ~= "version") then
                for key, pos in pairs(posList) do
                    --d(tag)
                    string2write = string2write..tag.."="..key..":"..pos.x..","..pos.y..","..pos.z..","..pos.h..":"..pos.minlevel..":"..pos.maxlevel..":"..pos.time..":"
                    for i,data in ipairs(pos.data) do
                        string2write = string2write..data
                        if (pos.data[i+1] ~= nil) then
                            string2write = string2write..","
                        else
                            string2write = string2write.."\n"
                        end
                    end
                end
            end
        end
        filewrite(mm.navmeshfilepath..meshname..".info",string2write)
    else
        d("ERROR: No Meshname!")
    end
end

function mm.GetClosestMarkerPos(startPos, tag)
    destPos = nil
    destDistance = 9999999
    if (TableSize(mm.MarkerList[tostring(tag)]) > 0) then
        for i, pos in pairs(mm.MarkerList[tostring(tag)]) do
            local distance = Distance2D(startPos.x, startPos.z, pos.x, pos.z)
            if ( distance < destDistance and distance > 2) then
                destPos = pos
                destDistance = distance
            end
        end
    end    
    return destPos
end

function mm.DrawMarker( pos, markertype )
    local color = 0
    local s = 25 -- size
    local h = 110 -- height
    if ( markertype == "grindSpot" ) then
        color = 1 -- red
    elseif ( markertype == "fishingSpot" ) then
        color = 4 --blue
    elseif ( markertype == "miningSpot" ) then
        color = 7 -- yellow	
    elseif ( markertype == "botanySpot" ) then
        color = 8 -- orange
    elseif ( markertype == "navSpot" ) then
        color = 6 -- green
    end
    --Building the vertices for the object
    local t = { 
        [1] = { pos.x-s, pos.y+s, pos.z-s-h, color },
        [2] = { pos.x+s, pos.y+s, pos.z-s-h, color  },	
        [3] = { pos.x,   pos.y-s,   pos.z-h, color  },
        
        [4] = { pos.x+s, pos.y+s, pos.z-s-h, color },
        [5] = { pos.x+s, pos.y+s, pos.z+s-h, color  },	
        [6] = { pos.x,   pos.y-s,   pos.z-h, color  },
        
        [7] = { pos.x+s, pos.y+s, pos.z+s-h, color },
        [8] = { pos.x-s, pos.y+s, pos.z+s-h, color  },	
        [9] = { pos.x,   pos.y-s,   pos.z-h, color  },
        
        [10] = { pos.x-s, pos.y+s, pos.z+s-h, color },
        [11] = { pos.x-s, pos.y+s, pos.z-s-h, color  },	
        [12] = { pos.x,   pos.y-s,   pos.z-h, color  },
    }
    
    local id = RenderManager:AddObject(t)	
    return id
end