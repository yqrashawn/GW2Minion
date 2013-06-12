-- Map & Meshmanager
mm = { }
mm.version = "v1.2";
mm.navmeshfilepath = tostring(GetStartupPath()) .. [[\Navigation\]];
mm.mainwindow = { name = "MeshManager", x = 350, y = 100, w = 220, h = 250}
mm.meshfiles = {}
mm.currentmapdata = {}
mm.visible = false
mm.Zones = {
	[15] = "Queensdale",
	[17] = "HarathiHinterlands",
	[18] = "DivinitysReach",
	[19] = "PlainsofAshford",
	[20] = "BlazeridgeSteppes",
	[21] = "FieldsofRuin",
	[22] = "FireheartRise",
	[23] = "KessexHills",
	[24] = "GendarranFields",
	[25] = "IronMarches",
	[26] = "DredgehauntCliffs",
	[27] = "LornarsPass",
	[28] = "WayfarerFoothills",
	[29] = "TimberlineFalls",
	[30] = "FrostgorgeSound",
	[31] = "SnowdenDrifts",
	[32] = "DiessaPlateau",
	[33] = "AscalonianCatacombs(Story)",
	[34] = "CaledonForest",
	[35] = "MetricaProvince",
	[36] = "AscalonianCatacombs(Explo)",
	[38] = "EternalBattlegrounds",
	[39] = "MountMaelstrom",
	[50] = "LionsArch",
	[51] = "StraitsOfDevastation",
	[53] = "SparkflyFen",
	[54] = "BrisbanWildlands",
	[62] = "CursedShore",
	[65] = "MalchorsLeap",
	[66] = "CitadelOfFlames(Story)",
	[69] = "CitadelOfFlames(Exploration)",
	[73] = "BloodtideCoast",
	[91] = "TheGrove",
	[94] = "BlueGreenRedBorderlands1",
	[95] = "BlueGreenRedBorderlands2",
	[96] = "BlueGreenRedBorderlands3",
	[139] = "RataSum",
	[218] = "BlackCitadel",
	[326] = "Hoelbrak",
	[873] = "SouthsunCove",
}

function mm.ModuleInit() 	
	if (Settings.GW2MINION.Zones == nil) then
		Settings.GW2MINION.Zones = {}
	end
	if (mm.Zones) then
		local id,name = next(mm.Zones)
		while id~=nil and name~=nil do
			if (Settings.GW2MINION.Zones[tostring(id)] == nil) then
				wt_debug("ADD")
				Settings.GW2MINION.Zones[tostring(id)] = { mapname=tostring(name), meshname="none", waypointid="none"}
			end
			id,name = next(mm.Zones,id)
		end
		Settings.GW2MINION.Zones = Settings.GW2MINION.Zones
	end
	
	if (Settings.GW2MINION.gMeshMGR == nil) then
		Settings.GW2MINION.gMeshMGR = "1"
	end
	
	local wnd = GUI_GetWindowInfo("GW2Minion")
	GUI_NewWindow(mm.mainwindow.name,wnd.x+wnd.width,wnd.y,mm.mainwindow.w,mm.mainwindow.h)
	GUI_NewCheckbox(mm.mainwindow.name,"Activated","gMeshMGR","General Settings")
	GUI_NewField(mm.mainwindow.name,"Mapname","gmapname","General Settings")
	GUI_NewComboBox(mm.mainwindow.name,"Navmesh","gmeshname","General Settings","");
	--GUI_NewField(mm.mainwindow.name,"Navmesh","gmeshname","General Settings")
	GUI_NewField(mm.mainwindow.name,"Waypoint","gwaypointid","General Settings")
	
	-- Grab all meshfiles in our Navigation directory
	local count = 0
	local meshlist = "none"
	for meshfile in io.popen('dir /b "' .. mm.navmeshfilepath ..'*.obj"'):lines() do
		meshfile = string.gsub(meshfile, ".obj", "")		
		if (io.open(mm.navmeshfilepath..tostring(meshfile)..".obj")) then
			local file = io.open(mm.navmeshfilepath..tostring(meshfile)..".obj", "r")
			if ( file ) then					
				table.insert(mm.meshfiles, meshfile)
				file:flush()
				file:close()
					
				meshlist = meshlist..","..tostring(meshfile)								
				count = count + 1
			end
		end
	end
		
	gMeshEditor = "0"
	if (Settings.GW2MINION.gnewmeshname == nil) then
		Settings.GW2MINION.gnewmeshname = ""
	end
	GUI_NewCheckbox(mm.mainwindow.name,"Show Mesh","gMeshEditor","Editor")
	GUI_NewField(mm.mainwindow.name,"New MeshName","gnewmeshname","Editor")
	GUI_NewButton(mm.mainwindow.name,"New Mesh","newMeshEvent","Editor")
	GUI_NewComboBox(mm.mainwindow.name,"RecordMode","grecMode","Editor","Mouse,Player");	
	GUI_NewButton(mm.mainwindow.name,"Optimize Mesh","optimizeMeshEvent","Editor")
	GUI_NewButton(mm.mainwindow.name,"Save Mesh","saveMeshEvent","Editor")
	
	
	RegisterEventHandler("newMeshEvent",mm.CreateNewMesh)
	RegisterEventHandler("optimizeMeshEvent",mm.OptimizeMesh)
	RegisterEventHandler("saveMeshEvent",mm.SaveMesh)
			
	gmeshname_listitems = meshlist
	gmapname = ""
	gwaypointid = ""	
	gnewmeshname = ""
	gMeshMGR = Settings.GW2MINION.gMeshMGR
	
end

function mm.CreateNewMesh()
	wt_debug("Creating NEW MESH")
	-- Unload old Mesh
	if (NavigationManager:IsNavMeshLoaded()) then
		wt_debug("Unloading old NavMesh...")
		wt_debug("Result: "..tostring(NavigationManager:UnloadNavMesh()))
	end
	
	if ( gnewmeshname ~= nil and gnewmeshname ~= "" ) then
		-- Make sure file doesnt exist
		local found = false
		for meshfile in io.popen('dir /b "' .. mm.navmeshfilepath ..'*.obj"'):lines() do
			meshfile = string.gsub(meshfile, ".obj", "")		
			if (tostring(meshfile) == tostring(gnewmeshname)) then
				wt_error("Mesh with that Name exists already...")
				found = true
				break
			end			
		end
		if (not found) then
			-- Setup everything for new mesh
			gmeshname_listitems = gmeshname_listitems..","..tostring(gnewmeshname)
			gmeshname = tostring(gnewmeshname)
			
		end
	else
		wt_error("Enter a new MeshName first!")
	end
end

function mm.OptimizeMesh()
	wt_debug("Optimizing Mesh...")
	wt_debug("Result: "..tostring(NavigationManager:OptimizeMesh()))
end

function mm.SaveMesh()
	wt_debug("Saving NavMesh...")
	if (gmeshname ~= nil and tostring(gmeshname) ~= "") then
		wt_debug("Result: "..tostring(NavigationManager:SaveNavMesh(towstring(gmeshname))))
	else
		wt_error("gmeshname is empty!?")
	end	
end

function mm.ChangeNavMesh(newmesh)			
	-- Set the new mesh for the local map
	local mapID = Player:GetLocalMapID()
	if ( Settings.GW2MINION.Zones[tostring(mapID)] == nil) then
		if (mm.Zones[mapID] == nil) then
			Settings.GW2MINION.Zones[tostring(mapID)] = { mapname="unknown", meshname=tostring(newmesh), waypointid="none" } 
			gmapname = "Unknown"
			gwaypointid = "none"
		else
			Settings.GW2MINION.Zones[tostring(mapID)] = { mapname=tostring(mm.Zones[mapID]), meshname=tostring(newmesh), waypointid="none" } 
			gmapname = tostring(mm.Zones[mapID])
			gwaypointid = "none"
		end
	else	
		if (tostring(Settings.GW2MINION.Zones[tostring(mapID)].meshname) ~= tostring(newmesh)) then
			mm.currentmapdata.mapID = nil -- make it reload the navmesh since it changed
		end
		Settings.GW2MINION.Zones[tostring(mapID)].meshname = tostring(newmesh)		
		gmapname = Settings.GW2MINION.Zones[tostring(mapID)].mapname
		if (Settings.GW2MINION.Zones[tostring(mapID)].waypointid == nil) then
			Settings.GW2MINION.Zones[tostring(mapID)].waypointid = "none"
			gwaypointid = "none"			
		else
			gwaypointid = tostring(Settings.GW2MINION.Zones[tostring(mapID)].waypointid)
		end
	end	
	gmeshname = tostring(newmesh)	
	Settings.GW2MINION.Zones = Settings.GW2MINION.Zones -- save settings
	
	gMeshMGR = "1"
end

function mm.RefreshCurrentMapData()
	if (gMeshMGR == "1") then 
		local mapID = Player:GetLocalMapID()
		if (((mm.currentmapdata.mapID == nil and tonumber(mapID) ~= nil) or mm.currentmapdata.mapID ~= mapID) and tonumber(mapID) ~= nil and TableSize(Player.pos) >0 and tonumber(Player.pos.x) ~= nil) then			
			-- Unload old mesh first
			if (NavigationManager:IsNavMeshLoaded() and mm.currentmapdata.mapID ~= nil and mm.currentmapdata.mapID ~= mapID) then
				wt_debug("Unloading old navmesh...")
				wt_global_information.Reset()
				NavigationManager:UnloadNavMesh()
				mm.currentmapdata.mapID = nil
				return false
			end
			-- Load the mesh for our Map
			if ( tonumber(mapID) ~= nil and Settings.GW2MINION.Zones~=nil and Settings.GW2MINION.Zones[tostring(mapID)] ~= nil ) then
				gmapname = Settings.GW2MINION.Zones[tostring(mapID)].mapname
				gmeshname = tostring(Settings.GW2MINION.Zones[tostring(mapID)].meshname)
								
				if (Settings.GW2MINION.Zones[tostring(mapID)].waypointid == nil) then
					gwaypointid = "none"			
				else
					gwaypointid = tostring(Settings.GW2MINION.Zones[tostring(mapID)].waypointid)
				end			
				if (gmeshname ~= nil and tostring(gmeshname) ~= "" and tostring(gmeshname) ~= "none") then				
					local path = GetStartupPath()..L"\\Navigation\\"..towstring(gmeshname)
					if (io.open(tostring(path)..".obj")) then
						if (NavigationManager:IsNavMeshLoaded()) then
							wt_debug("Unloading Old Navmesh...")
							NavigationManager:UnloadNavMesh()
						else
							wt_debug("Auto-Loading Navmesh " ..tostring(gmeshname))
							wt_core_state_combat.StopCM()
							wt_global_information.Reset()
							wt_core_taskmanager.ClearTasks()
							if (NavigationManager:LoadNavMesh(path)) then
								mm.currentmapdata.mapID = mapID	
								GUI_CloseMarkerInspector()	
								return true
							end
						end
					else
						wt_error("ERROR: Can't open the file: "..tostring(gmeshname))
					end	
				else				
					wt_debug("Please select a NavMesh for this Zone in the MeshManager")
					gmapname = tostring(Settings.GW2MINION.Zones[tostring(mapID)].mapname)
					gmeshname = "none"
					gwaypointid = "none"
				end				
			else
				gmapname = "none"
				gmeshname = "none"
				gwaypointid	= "none"
			end	
		end
	end
	return false
end

function mm.ToggleMenu()
	if (mm.visible) then
		GUI_WindowVisible(mm.mainwindow.name,false)	
		mm.visible = false
	else
		local wnd = GUI_GetWindowInfo("GW2Minion")	
		GUI_MoveWindow( mm.mainwindow.name, wnd.x+wnd.width,wnd.y) 
		GUI_WindowVisible(mm.mainwindow.name,true)	
		mm.visible = true
	end
end


function mm.UnloadNavMesh()		
	wt_debug("Clearing Current Navmesh Data..")	
	NavigationManager:UnloadNavMesh()
end

function mm.LoadNavMesh(filename)	
	wt_debug("Loading Navmesh " ..tostring(filename))
	local path = GetStartupPath()..L"\\Navigation\\"..towstring(filename)
	if (io.open(tostring(path)..".obj")) then
		NavigationManager:LoadNavMesh(path)
		GUI_CloseMarkerInspector()
		return true
	end
	return false
end



function mm.GUIVarUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do		
		if ( k == "gmeshname") then
			mm.ChangeNavMesh(v)	
		elseif( k == "gMeshEditor") then
			if (v == "1") then
				NavigationManager:ToggleNavEditor(true)
			else
				NavigationManager:ToggleNavEditor(false)
			end
		elseif( k == "grecMode") then
			if (v == "Mouse") then
				NavigationManager:RecordMode(false)
			else
				NavigationManager:RecordMode(true)
			end
			Settings.GW2MINION[tostring(k)] = v
		elseif( k == "gMeshMGR" or k == "gnewmeshname") then
			Settings.GW2MINION[tostring(k)] = v
		end
	end
	GUI_RefreshWindow(mm.mainwindow.name)
end


function mm.GenerateInfoFile( )	
	if (gnewmeshname ~= nil and NavigationManager:IsNavMeshLoaded()) then
		if (io.open(mm.navmeshfilepath..tostring(gnewmeshname)..".obj")) then
			local file = io.open(mm.navmeshfilepath..tostring(gnewmeshname)..".info", "w")
			if file then
				wt_debug("Generating .info file..")
				local mapID = Player:GetLocalMapID()
				if (mapID ~= nil and mapID~=0) then
					file:write("mapid="..mapID.."\n")
					local wps = WaypointList("samezone,onmesh")
					if(wps~=nil) then
						local i,wp = next(wps)
						while (i~=nil and wp~=nil) do
							file:write("waypoint="..wp.contentID.."\n")
							i,wp = next(wps,i)
						end						
					end
				end				
				file:flush()
				file:close()
				mm.RefreshMeshFileList()
			end
		else
			wt_debug("NO MESHFILE WITH THAT NAME EXISTS")
		end
	else
		wt_debug("YOU NEED TO LOAD THE NAVMESH FIRST, AND LEARN TO READ LOL")
	end
end


RegisterEventHandler("NavigationManager.toggle", mm.ToggleMenu)
RegisterEventHandler("GUI.Update",mm.GUIVarUpdate)
RegisterEventHandler("Module.Initalize",mm.ModuleInit)
