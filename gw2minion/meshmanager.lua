-- Map & Meshmanager
mm = { }
mm.version = "v1.2";
mm.navmeshfilepath = tostring(GetStartupPath()) .. [[\Navigation\]];
mm.mainwindow = { name = strings[gCurrentLanguage].meshManager, x = 350, y = 100, w = 220, h = 250}
mm.meshfiles = {}
mm.currentmapdata = {} 
mm.visible = false
mm.Zones = {
	[15] = strings[gCurrentLanguage].queensdale,
	[17] = strings[gCurrentLanguage].harathiHinterlands,
	[18] = strings[gCurrentLanguage].divinitysReach,
	[19] = strings[gCurrentLanguage].plainsOfAshford,
	[20] = strings[gCurrentLanguage].blazeridgeSteppes,
	[21] = strings[gCurrentLanguage].fieldsOfRuin,
	[22] = strings[gCurrentLanguage].fireheartRise,
	[23] = strings[gCurrentLanguage].kessexHills,
	[24] = strings[gCurrentLanguage].gendarranFields,
	[25] = strings[gCurrentLanguage].ironMarches,
	[26] = strings[gCurrentLanguage].dredgehauntCliffs,
	[27] = strings[gCurrentLanguage].lornarsPass,
	[28] = strings[gCurrentLanguage].wayfarerFoothills,
	[29] = strings[gCurrentLanguage].timberlineFalls,
	[30] = strings[gCurrentLanguage].frostgorgeSound,
	[31] = strings[gCurrentLanguage].snowdenDrifts,
	[32] = strings[gCurrentLanguage].diessaPlateau,
	[33] = strings[gCurrentLanguage].ascalonianCatacombsStory,
	[34] = strings[gCurrentLanguage].caledonForest,
	[35] = strings[gCurrentLanguage].metricaProvince,
	[36] = strings[gCurrentLanguage].ascalonianCatacombsExp,
	[38] = strings[gCurrentLanguage].eternalBattlegrounds,
	[39] = strings[gCurrentLanguage].mountMaelstrom,
	[50] = strings[gCurrentLanguage].lionsArch,
	[51] = strings[gCurrentLanguage].straightsOfDevastation,
	[53] = strings[gCurrentLanguage].sparkflyFen,
	[54] = strings[gCurrentLanguage].brisbanWildlands,
	[62] = strings[gCurrentLanguage].cursedShore,
	[65] = strings[gCurrentLanguage].malchorsLeap,
	[66] = strings[gCurrentLanguage].citadelOfFlamesStory,
	[69] = strings[gCurrentLanguage].citadelOfFlamesExp,
	[73] = strings[gCurrentLanguage].bloodtideCoast,
	[91] = strings[gCurrentLanguage].theGrove,
	[94] = strings[gCurrentLanguage].borderlands1,
	[95] = strings[gCurrentLanguage].borderlands2,
	[96] = strings[gCurrentLanguage].borderlands3,
	[139] = strings[gCurrentLanguage].rataSum,
	[218] = strings[gCurrentLanguage].blackCitadel,
	[326] = strings[gCurrentLanguage].hoelbrak ,
	[873] = strings[gCurrentLanguage].southsunCove,
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
	GUI_NewCheckbox(mm.mainwindow.name,strings[gCurrentLanguage].activated,"gMeshMGR",strings[gCurrentLanguage].generalSettings)
	GUI_NewField(mm.mainwindow.name,strings[gCurrentLanguage].mapName,"gmapname",strings[gCurrentLanguage].generalSettings)
	GUI_NewComboBox(mm.mainwindow.name,strings[gCurrentLanguage].navmesh ,"gmeshname",strings[gCurrentLanguage].generalSettings,"");
	--GUI_NewField(mm.mainwindow.name,strings[gCurrentLanguage].navmesh ,"gmeshname",strings[gCurrentLanguage].generalSettings)
	GUI_NewField(mm.mainwindow.name,strings[gCurrentLanguage].waypoint,"gwaypointid",strings[gCurrentLanguage].generalSettings)
	
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
	GUI_NewButton(mm.mainwindow.name,"Build NAVMesh","buildMeshEvent","Editor")
	
	
	RegisterEventHandler("newMeshEvent",mm.CreateNewMesh)
	RegisterEventHandler("optimizeMeshEvent",mm.OptimizeMesh)
	RegisterEventHandler("saveMeshEvent",mm.SaveMesh)
	RegisterEventHandler("buildMeshEvent",mm.BuildMesh)
	
			
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
			mm.SaveMesh()
			mm.ChangeNavMesh(gmeshname)
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
	if (gmeshname ~= nil and tostring(gmeshname) ~= "" and tostring(gmeshname) ~= "none") then
		wt_debug("Result: "..tostring(NavigationManager:SaveNavMesh(towstring(gmeshname))))
	else
		wt_error("gmeshname is empty!?")
	end	
end

function mm.BuildMesh()
	wt_debug("Building NAV-Meshfile...")
	if (gmeshname ~= nil and tostring(gmeshname) ~= "" and tostring(gmeshname) ~= "none") then
		wt_debug("Result: "..tostring(NavigationManager:LoadNavMesh(towstring(gmeshname))))
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
					local path = GetStartupPath().."\\Navigation\\"..tostring(gmeshname)
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
	wt_debug("Loading Navmesh: " ..tostring(filename))
	local path = GetStartupPath().."\\Navigation\\"..tostring(filename)
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

