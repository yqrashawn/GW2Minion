-- Map & Meshmanager
mm = { }
mm.navmeshfilepath = GetStartupPath() .. [[\Navigation\]];
mm.mainwindow = { name = mc_getstring("meshManager"), x = 350, y = 100, w = 250, h = 400}
mm.meshfiles = {}
mm.visible = false
mm.lasttick = 0
mm.mapID = 0
mm.reloadMeshPending = false
mm.reloadMeshTmr = 0
mm.reloadMeshName = ""
mm.OMC = 0

function mm.ModuleInit() 	
        
    if (Settings.MinionCore.gMeshMGR == nil) then
        Settings.MinionCore.gMeshMGR = "1"
    end
	
    if (Settings.MinionCore.Maps == nil) then
        Settings.MinionCore.Maps = {
			[15] = mc_getstring("queensdale"),
			[17] = mc_getstring("harathiHinterlands"),
			[18] = mc_getstring("divinitysReach"),
			[19] = mc_getstring("plainsOfAshford"),
			[20] = mc_getstring("blazeridgeSteppes"),
			[21] = mc_getstring("fieldsOfRuin"),
			[22] = mc_getstring("fireheartRise"),
			[23] = mc_getstring("kessexHills"),
			[24] = mc_getstring("gendarranFields"),
			[25] = mc_getstring("ironMarches"),
			[26] = mc_getstring("dredgehauntCliffs"),
			[27] = mc_getstring("lornarsPass"),
			[28] = mc_getstring("wayfarerFoothills"),
			[29] = mc_getstring("timberlineFalls"),
			[30] = mc_getstring("frostgorgeSound"),
			[31] = mc_getstring("snowdenDrifts"),
			[32] = mc_getstring("diessaPlateau"),
			[33] = mc_getstring("ascalonianCatacombsStory"),
			[34] = mc_getstring("caledonForest"),
			[35] = mc_getstring("metricaProvince"),
			[36] = mc_getstring("ascalonianCatacombsExp"),
			[38] = mc_getstring("eternalBattlegrounds"),
			[39] = mc_getstring("mountMaelstrom"),
			[50] = mc_getstring("lionsArch"),
			[51] = mc_getstring("straightsOfDevastation"),
			[53] = mc_getstring("sparkflyFen"),
			[54] = mc_getstring("brisbanWildlands"),
			[62] = mc_getstring("cursedShore"),
			[65] = mc_getstring("malchorsLeap"),
			[66] = mc_getstring("citadelOfFlamesStory"),
			[69] = mc_getstring("citadelOfFlamesExp"),
			[73] = mc_getstring("bloodtideCoast"),
			[91] = mc_getstring("theGrove"),
			[94] = mc_getstring("borderlands1"),
			[95] = mc_getstring("borderlands2"),
			[96] = mc_getstring("borderlands3"),
			[139] = mc_getstring("rataSum"),
			[218] = mc_getstring("blackCitadel"),
			[326] = mc_getstring("hoelbrak"),
			[795] = mc_getstring("legacyofthefoefire"),
			[873] = mc_getstring("southsunCove"),
			[894] = mc_getstring("spiritwatch"),
			[929] = "Pavillion",
		}
    end
    
    local wnd = GUI_GetWindowInfo("MinionBot")
    GUI_NewWindow(mm.mainwindow.name,wnd.x+wnd.width,wnd.y,mm.mainwindow.w,mm.mainwindow.h)
    GUI_NewCheckbox(mm.mainwindow.name,mc_getstring("activated"),"gMeshMGR",mc_getstring("generalSettings"))
    GUI_NewComboBox(mm.mainwindow.name,mc_getstring("navmesh"),"gmeshname",mc_getstring("generalSettings"),"")
    GUI_NewCheckbox(mm.mainwindow.name,mc_getstring("showrealMesh"),"gShowRealMesh",mc_getstring("generalSettings"))
    GUI_NewCheckbox(mm.mainwindow.name,mc_getstring("showPath"),"gShowPath",mc_getstring("generalSettings"))
    --Grab all meshfiles in our Navigation directory
    local count = 0
    local meshlist = "none"
    local meshfilelist = dirlist(mm.navmeshfilepath,".*obj")
    if ( TableSize(meshfilelist) > 0) then
        local i,meshname = next ( meshfilelist)
        while i and meshname do
            meshname = string.gsub(meshname, ".obj", "")
            table.insert(mm.meshfiles, meshname)
            meshlist = meshlist..","..meshname
            i,meshname = next ( meshfilelist,i)
        end
    end
        
    if (Settings.MinionCore.gnewmeshname == nil) then
        Settings.MinionCore.gnewmeshname = ""
    end
    GUI_NewCheckbox(mm.mainwindow.name,mc_getstring("showMesh"),"gShowMesh",mc_getstring("editor"))
    GUI_NewField(mm.mainwindow.name,mc_getstring("newMeshName"),"gnewmeshname",mc_getstring("editor"))
    GUI_NewButton(mm.mainwindow.name,mc_getstring("newMesh"),"newMeshEvent",mc_getstring("editor"))
    GUI_NewCheckbox(mm.mainwindow.name,mc_getstring("recmesh"),"gMeshrec",mc_getstring("editor"))
    GUI_NewComboBox(mm.mainwindow.name,mc_getstring("recAreaType"),"gRecAreaType",mc_getstring("editor"),"Road,Lowdanger,Highdanger")-- enum 1,2,3
    GUI_NewNumeric(mm.mainwindow.name,mc_getstring("recAreaSize"),"gRecAreaSize",mc_getstring("editor"),"1","500")
    GUI_NewCheckbox(mm.mainwindow.name,mc_getstring("changeMesh"),"gMeshChange",mc_getstring("editor"))
    GUI_NewComboBox(mm.mainwindow.name,mc_getstring("changeAreaType"),"gChangeAreaType",mc_getstring("editor"),"Delete,Road,Lowdanger,Highdanger")
    GUI_NewNumeric(mm.mainwindow.name,mc_getstring("changeAreaSize"),"gChangeAreaSize",mc_getstring("editor"),"1","10")	
    GUI_NewButton(mm.mainwindow.name,mc_getstring("addOffMeshSpot"),"offMeshSpotEvent",mc_getstring("editor"))
    RegisterEventHandler("offMeshSpotEvent", mm.AddOMC)
    GUI_NewButton(mm.mainwindow.name,mc_getstring("delOffMeshSpot"),"deleteoffMeshEvent",mc_getstring("editor"))
    RegisterEventHandler("deleteoffMeshEvent", mm.DeleteOMC)
    GUI_NewCheckbox(mm.mainwindow.name,mc_getstring("biDirOffMesh"),"gBiDirOffMesh",mc_getstring("editor"))
    GUI_NewButton(mm.mainwindow.name,"CreateSingleCell","createSingleCell",mc_getstring("editor"))
	RegisterEventHandler("createSingleCell", mm.CreateSingleCell)
    
    
    gShowMesh = "0"
    gShowRealMesh = "0"
    gShowPath = "0"
    gMeshrec = "0"
    gRecAreaType = "Lowdanger"
    gRecAreaSize = "20"
    gMeshChange = "0"
    gChangeAreaType = "Road"
    gChangeAreaSize = "5"
    gBiDirOffMesh = "0"
        
    MeshManager:SetRecordingArea(2)
    MeshManager:RecSize(gRecAreaSize)
    MeshManager:SetChangeToArea(1)
    MeshManager:SetChangeToRadius(gChangeAreaSize)
    MeshManager:SetChangeAreaMode(false)
    MeshManager:Record(false)
    
    GUI_NewButton(mm.mainwindow.name,mc_getstring("saveMesh"),"saveMeshEvent",mc_getstring("editor"))
    
    
    RegisterEventHandler("newMeshEvent",mm.ClearNavMesh)	
    RegisterEventHandler("saveMeshEvent",mm.SaveMesh)

    gmeshname_listitems = meshlist
    gnewmeshname = ""
    gMeshMGR = Settings.MinionCore.gMeshMGR 
    
    
	GUI_NewButton(mm.mainwindow.name,"ChangeMeshRenderDepth","Dev.ChangeMDepth")
	    
    GUI_SizeWindow(mm.mainwindow.name,mm.mainwindow.w,mm.mainwindow.h)
    GUI_WindowVisible(mm.mainwindow.name,false)
end

---------
--Mesh
---------


function mm.ClearNavMesh()
    -- Unload old Mesh
    if (NavigationManager:GetNavMeshName() ~= "") then
        d("Unloading ".. NavigationManager:GetNavMeshName() .." NavMesh.")        
    end
	d("Result: "..tostring(NavigationManager:UnloadNavMesh()))
    -- Remove Renderdata
    --RenderManager:RemoveAllObjects()
    --for key,e in pairs(mm.MarkerRenderList) do	
     ----   if ( key ~= nil ) then			
     --       mm.MarkerRenderList[key] = nil
    --    end
    --end
    -- Delete Markers
    --for tag, list in pairs(mm.MarkerList) do
    --    mm.MarkerList[tag] = {}
   -- end
end

function mm.SaveMesh()
    d("Saving NavMesh...")
    --[[gShowRealMesh = "0"
    NavigationManager:ShowNavMesh(false)
    gShowPath = "0"
    NavigationManager:ShowNavPath(false)
    gShowMesh = "0"
    MeshManager:ShowTriMesh(false)]]
    gMeshrec = "0"
    MeshManager:Record(false)
            
    local filename = ""
    -- If a new Meshname is given, create a new file and save it in there
    if ( gnewmeshname ~= nil and gnewmeshname ~= "" ) then
        -- Make sure file doesnt exist
        local found = false		
        local meshfilelist = dirlist(mm.navmeshfilepath,".*obj")
        if ( TableSize(meshfilelist) > 0) then
            local i,meshname = next ( meshfilelist)
            while i and meshname do
                meshname = string.gsub(meshname, ".obj", "")
                if (meshname == gnewmeshname) then
                    d("Mesh with that Name exists already...")
                    found = true
                    break
                end
                i,meshname = next ( meshfilelist,i)
            end
        end
        if ( not found) then
            -- add new file to list
            gmeshname_listitems = gmeshname_listitems..","..gnewmeshname			
        end
        filename = gnewmeshname		
        
    -- Else we save it under the selected name
    elseif (gmeshname ~= nil and gmeshname ~= "" and gmeshname ~= "none") then
        filename = gmeshname		
    end	
    if ( filename ~= "" and filename ~= "none" ) then
        d("SAVING UNDER: "..tostring(filename))
        d("Result: "..tostring(NavigationManager:SaveNavMesh(filename)))
        mm.reloadMeshPending = true
        mm.reloadMeshTmr = mm.lasttick
        mm.reloadMeshName = filename	
        gnewmeshname = ""
        gmeshname = filename
    else
        mc_error("Enter a proper Navmesh name!")
    end
end


function mm.ChangeNavMesh(newmesh)			
    -- Set the new mesh for the local map	
    if ( NavigationManager:GetNavMeshName() ~= newmesh and NavigationManager:GetNavMeshName() ~= "") then
        d("Unloading current Navmesh: "..tostring(NavigationManager:UnloadNavMesh()))		
        --RenderManager:RemoveAllObjects()
        --for key,e in pairs(mm.MarkerRenderList) do	
        --    if ( key ~= nil ) then
        --        mm.MarkerRenderList[key] = nil
       --     end
        --end
        mm.reloadMeshPending = true
        mm.reloadMeshTmr = mm.lasttick
        mm.reloadMeshName = newmesh
        return
    else
        -- Load the mesh for our Map
        if (newmesh ~= nil and newmesh ~= "" and newmesh ~= "none") then				
            d("Loading Navmesh " ..newmesh)
            if (not NavigationManager:LoadNavMesh(mm.navmeshfilepath..newmesh)) then
                d("Error loading Navmesh: "..path)
            else
                mm.reloadMeshPending = false
               -- mm.ReadMarkerList(newmesh)				
                local mapid = Player:GetLocalMapID()
                if ( mapid ~= nil and mapid~=0 ) then
                    d("Setting default Mesh for this Zone..(ID :"..tostring(mapid).." Meshname: "..newmesh)
                    Settings.MinionCore.Maps[mapid] = newmesh
                    mm.mapID = mapid
                end				
            end
        end
    end
    gmeshname = newmesh
    Settings.MinionCore.gmeshname = newmesh
    gMeshMGR = "1"
end


function mm.ToggleMenu()
    if (mm.visible) then
        GUI_WindowVisible(mm.mainwindow.name,false)	
        mm.visible = false
    else
        local wnd = GUI_GetWindowInfo("MinionBot")	
        GUI_MoveWindow( mm.mainwindow.name, wnd.x+wnd.width,wnd.y) 
        GUI_WindowVisible(mm.mainwindow.name,true)	
        mm.visible = true
    end
end


function mm.GUIVarUpdate(Event, NewVals, OldVals)
    for k,v in pairs(NewVals) do		
        if ( k == "gmeshname") then
            mm.ChangeNavMesh(v)
            mm.ReadMarkerList(v)
        elseif( k == "gShowRealMesh") then
            if (v == "1") then
                NavigationManager:ShowNavMesh(true)
            else
                NavigationManager:ShowNavMesh(false)
            end
        elseif( k == "gShowPath") then
            if (v == "1") then
                NavigationManager:ShowNavPath(true)
            else
                NavigationManager:ShowNavPath(false)
            end			
        elseif( k == "gShowMesh") then
            if (v == "1") then
                MeshManager:ShowTriMesh(true)
            else
                MeshManager:ShowTriMesh(false)
            end				
        elseif( k == "gMeshrec") then
            if (v == "1") then
                MeshManager:Record(true)
            else
                MeshManager:Record(false)
            end
        elseif( k == "gRecAreaType") then
            if (v == "Road") then
                MeshManager:SetRecordingArea(1)
            elseif (v == "Lowdanger") then
                MeshManager:SetRecordingArea(2)
            elseif (v == "Highdanger") then
                MeshManager:SetRecordingArea(3)
            end
        elseif( k == "gRecAreaSize") then
            MeshManager:RecSize(tonumber(gRecAreaSize))
        elseif( k == "gMeshChange") then
            if (v == "1") then
                MeshManager:SetChangeAreaMode(true)
            else
                MeshManager:SetChangeAreaMode(false)
            end
        elseif( k == "gChangeAreaType") then
            if (v == "Road") then
                MeshManager:SetChangeToArea(1)
            elseif (v == "Lowdanger") then
                MeshManager:SetChangeToArea(2)
            elseif (v == "Highdanger") then
                MeshManager:SetChangeToArea(3)
            elseif (v == "Delete") then	
                MeshManager:SetChangeToArea(255)
            end
        elseif( k == "gChangeAreaSize") then
            MeshManager:SetChangeToRadius(tonumber(gChangeAreaSize))
        elseif( k == "gMeshMGR" or k == "gnewmeshname" ) then
            Settings.MinionCore[tostring(k)] = v    
        end
    end
    GUI_RefreshWindow(mm.mainwindow.name)
end

function mm.OnUpdate( tickcount )
    if ( tickcount - mm.lasttick > 500 ) then
        mm.lasttick = tickcount
        
        if ( gMeshrec == "1") then
            -- 162 = Left CTRL + Left Mouse
            if ( MeshManager:IsKeyPressed(162) and MeshManager:IsKeyPressed(1)) then --162 is the integervalue of the virtualkeycode (hex)
                MeshManager:RecForce(true)
            else
                MeshManager:RecForce(false)
            end
			
			-- 162 = Left CTRL 
            if ( MeshManager:IsKeyPressed(162) ) then --162 is the integervalue of the virtualkeycode (hex)
                MeshManager:RecSteeper(true)
            else
                MeshManager:RecSteeper(false)
            end
			
            -- 160 = Left Shift
            if ( MeshManager:IsKeyPressed(160) ) then
                MeshManager:RecSize(2*tonumber(gRecAreaSize))
            else
                MeshManager:RecSize(tonumber(gRecAreaSize))
            end         
        end
        
        
        --18 + 2 = ALT + right mouse button to Delete Triangles under mouse
            if ( MeshManager:IsKeyPressed(18) and MeshManager:IsKeyPressed(2)) then
                local mousepos = MeshManager:GetMousePos()
                d("Deleting cell "..tostring(mousepos.x).." "..tostring(mousepos.z).. " "..tostring(mousepos.y))
                if ( TableSize(mousepos) > 0 ) then					
                    d("Deleting cell result: "..tostring(MeshManager:DeleteRasterTriangle(mousepos)))
                end
            end	
            
        --(re-)Loading Navmesh
        if (mm.reloadMeshPending and mm.lasttick - mm.reloadMeshTmr > 2000 and mm.reloadMeshName ~= "") then
            mm.reloadMeshTmr = mm.lasttick
            mm.ChangeNavMesh(mm.reloadMeshName)
        end
        
        -- Check if we switched maps
        local mapid = Player.localmapid
        if ( not mm.reloadMeshPending and mapid ~= nil and mm.mapID ~= mapid ) then			
            if (Settings.MinionCore.Maps[mapid] ~= nil) then
                d("Autoloading Navmesh for this Zone: "..Settings.MinionCore.Maps[mapid])
                mm.reloadMeshPending = true
                mm.reloadMeshTmr = mm.lasttick
                mm.reloadMeshName = Settings.MinionCore.Maps[mapid]				
            end
        end
    end
end

-- add offmesh connection
function mm.AddOMC()
    local pos = Player.pos
    
    mm.OMC = mm.OMC+1
    if (mm.OMC == 1 ) then
        mm.OMCP1 = pos
        mm.OMCP1.z = mm.OMCP1.z
    elseif (mm.OMC == 2 ) then
        mm.OMCP2 = pos
        mm.OMCP2.z = mm.OMCP2.z
        if ( gBiDirOffMesh == "0" ) then
            d(MeshManager:AddOffMeshConnection(mm.OMCP1,mm.OMCP2,false))
        else
            d(MeshManager:AddOffMeshConnection(mm.OMCP1,mm.OMCP2,true))
        end				
        mm.OMC = 0
    end	
end
-- delete offmesh connection
function mm.DeleteOMC()
    local pos = Player.pos
    MeshManager:DeleteOffMeshConnection(pos)
    mm.OMC = 0
end

function mm.CreateSingleCell()
	d("Creating a single cell outside the raster!")
	local pPos = Player.pos
	local newVertexCenter = { x=pPos.x, y=pPos.y, z=pPos.z }
	d(MeshManager:CreateSingleCell( newVertexCenter))
end


RegisterEventHandler("ToggleMeshmgr", mm.ToggleMenu)
RegisterEventHandler("GUI.Update",mm.GUIVarUpdate)
RegisterEventHandler("Module.Initalize",mm.ModuleInit)

