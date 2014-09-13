gw2minion = {}
gw2minion.MainWindow = { Name="MainMenu", x=50, y=50, width=220, height=350 }
gw2minion.CharacterSelectWindow = { Name="CharacterSelect", x=100, y=100 , width=250, height=150 }


function gw2minion.ModuleInit()
	--Init GUI first
	gw2minion.ResetGUI()
	
	Settings.GW2Minion.gPulseTime = Settings.GW2Minion.gPulseTime or "150"
	Settings.GW2Minion.gBotMode = Settings.GW2Minion.gBotMode or GetString("grindMode")
	Settings.GW2Minion.gGuestServer = Settings.GW2Minion.gGuestServer or "None"
	Settings.GW2Minion.dDisableRender = Settings.GW2Minion.dDisableRender or "0"
	
	if ( RenderManager ) then RenderManager:ToggleRendering(tonumber(dDisableRender)) end
	
    gBotMode = Settings.GW2Minion.gBotMode	
	gw2minion.SwitchMode(gBotMode)	
	gPulseTime = Settings.GW2Minion.gPulseTime

	
	-- Setup marker manager callbacks and vars
	if ( ml_marker_mgr ) then
		ml_marker_mgr.GetPosition = 	function () return ml_global_information.Player_Position end
		ml_marker_mgr.GetLevel = 		function () return ml_global_information.Player_Level end
		ml_marker_mgr.DrawMarker =		ml_global_information.DrawMarker
		ml_marker_mgr.parentWindow = { Name="MainMenu" }
		ml_marker_mgr.markerPath = ml_global_information.Path.. [[\Navigation\]]		
	end
	
	-- setup meshmanager
	if ( ml_mesh_mgr ) then
		ml_mesh_mgr.parentWindow.Name = "MainMenu"
		ml_mesh_mgr.GetMapID = function () return ml_global_information.CurrentMapID end
		ml_mesh_mgr.GetMapName = function () return ml_global_information.CurrentMapName end
		ml_mesh_mgr.GetPlayerPos = function () return ml_global_information.Player_Position end
		ml_mesh_mgr.averagegameunitsize = 50
		
		-- Set default meshes SetDefaultMesh(mapid, filename)
		ml_mesh_mgr.SetDefaultMesh(17,"Harathi Hinterlands")
			
		ml_mesh_mgr.SetDefaultMesh(19,"PlainsOfAshford")
		ml_mesh_mgr.SetDefaultMesh(20,"BlazzeridgeSteppes")
		ml_mesh_mgr.SetDefaultMesh(22,"FireHeartRise")
				
		ml_mesh_mgr.SetDefaultMesh(25,"IronMarches")
		ml_mesh_mgr.SetDefaultMesh(26,"Dredgehaunt Cliffs")
		ml_mesh_mgr.SetDefaultMesh(27,"LonarsPass")
		ml_mesh_mgr.SetDefaultMesh(28,"Wayfarer Foothills")		
		ml_mesh_mgr.SetDefaultMesh(29,"TimberlineFalls")
		ml_mesh_mgr.SetDefaultMesh(30,"FrostGorge Sound")
		ml_mesh_mgr.SetDefaultMesh(31,"Snowden Drifts")		
		ml_mesh_mgr.SetDefaultMesh(32,"DiessaPlateau")
		ml_mesh_mgr.SetDefaultMesh(34,"Caledon Forest")
		ml_mesh_mgr.SetDefaultMesh(35,"MetricaProvince")
		ml_mesh_mgr.SetDefaultMesh(39,"MountMaelstrom")
		
		ml_mesh_mgr.SetDefaultMesh(53,"Sparkfly Fen")
		ml_mesh_mgr.SetDefaultMesh(54,"Brisban Wildlands")
		ml_mesh_mgr.SetDefaultMesh(73,"BloodtideCoast")
				
		-- Setup the marker types we wanna use
		   --[[ local mapMarker = ml_marker:Create("MapMarker")
			mapMarker:SetType(GetString("mapMarker"))
			mapMarker:SetMinLevel(1)
			mapMarker:SetMaxLevel(50)
			mapMarker:AddField("int", "Target MapID", 0)			
			ml_marker_mgr.AddMarkerTemplate(mapMarker)			
			
			local vendorMarker = ml_marker:Create("vendorTemplate")
			vendorMarker:SetType(GetString("vendorMarker"))
			vendorMarker:SetMinLevel(1)
			vendorMarker:SetMaxLevel(50)
			ml_marker_mgr.AddMarkerTemplate(vendorMarker)--]]
			
			
			-- refresh the manager with the new templates
			ml_marker_mgr.RefreshMarkerTypes()
			ml_marker_mgr.RefreshMarkerNames()
				
		ml_mesh_mgr.InitMarkers() -- Update the Markers-group in the mesher UI
	end
	
	-- Setup blacklists
	if ( ml_blacklist_mgr ) then
		ml_blacklist_mgr.parentWindow = { Name="MainMenu" }
		ml_blacklist_mgr.path = GetStartupPath() .. [[\LuaMods\GW2Minion\blacklist.info]]
		ml_blacklist_mgr.ReadBlacklistFile(ml_blacklist_mgr.path)
		if not ml_blacklist.BlacklistExists(GetString("monsters")) then
			ml_blacklist.CreateBlacklist(GetString("monsters"))
		end		
		if not ml_blacklist.BlacklistExists(GetString("vendors")) then
			ml_blacklist.CreateBlacklist(GetString("vendors"))
		end
		
	end
end

function gw2minion.ResetGUI()
	
	GUI_DeleteGroup(gw2minion.MainWindow.Name, GetString("botStatus"))
	
	GUI_NewWindow(gw2minion.MainWindow.Name,gw2minion.MainWindow.x,gw2minion.MainWindow.y,gw2minion.MainWindow.width,gw2minion.MainWindow.height)
	GUI_NewComboBox(gw2minion.MainWindow.Name,GetString("botMode"),"gBotMode",GetString("botStatus"),"None")
	
	GUI_UnFoldGroup(gw2minion.MainWindow.Name,GetString("botStatus") );
	
	-- Setup default bot modes
	gw2minion.UpdateBotModes()
	-- Setup GuestServerList
	gw2minion.UpdateGuestServers()
end

function gw2minion.OnUpdate(event, tickcount )
	ml_global_information.Now = tickcount
	if ( TimeSince(ml_global_information.Lasttick) > tonumber(gPulseTime) ) then
		ml_global_information.Lasttick = tickcount
		
		-- Call all OnUpdate()
		ml_global_information.OnUpdate()			
		-- Mesher OnUpdate
		ml_mesh_mgr.OnUpdate( tickcount )
		-- BlackList OnUpdate		
		ml_blacklist_mgr.UpdateEntryTime()
		ml_blacklist_mgr.UpdateEntries(tickcount)
		
		
		GUI_SetStatusBar(ml_GetLogString())
	end
end

function gw2minion.OnUpdateCharSelect(event, tickcount )
	ml_global_information.Now = tickcount
	if ( TimeSince(ml_global_information.Lasttick) > tonumber(gPulseTime) ) then
		ml_global_information.Lasttick = tickcount
		
	end
end

function gw2minion.OnUpdateCutscene(event, tickcount )
	ml_global_information.Now = tickcount
	if ( TimeSince(ml_global_information.Lasttick) > tonumber(gPulseTime) ) then
		ml_global_information.Lasttick = tickcount
		
	end
end

function gw2minion.GUIVarUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		if ( k == "gBotMode" ) then
			ml_global_information.Stop()
			gw2minion.SwitchMode(v)
			Settings.GW2Minion[tostring(k)] = v
		end
	end
end

function ml_global_information.Reset()
    ml_task_hub:ClearQueues()
	if (gBotMode ~= "None") then
		local task = ml_global_information.BotModes[gBotMode]
		if (task ~= nil) then
			ml_task_hub:Add(task.Create(), LONG_TERM_GOAL, TP_ASAP)
		end
    end
end

function ml_global_information.Stop()
    if (Player:IsMoving()) then
        Player:Stop()
    end
end

-- To add a task to the BotMode Dropdown
function ml_global_information.AddBotMode( botmode, task )
	if ( ml_global_information.BotModes and ml_global_information.BotModes[botmode] == nil) then
		ml_global_information.BotModes[botmode] = task
		gw2minion.UpdateBotModes()
	end
end
-- Rebuilds the BotMode Dropdown field
function gw2minion.UpdateBotModes()
    local botModes = "None"
    if ( ValidTable(ml_global_information.BotModes) ) then
        local i,entry = next ( ml_global_information.BotModes )
        while i and entry do
            botModes = botModes..","..i
            i,entry = next ( ml_global_information.BotModes,i)
        end
    end
	gBotMode_listitems = botModes
end

function gw2minion.UpdateGuestServers()
	local newserverlist = "None"
	local homeserverid = GetHomeServer()
	local serverlist = {}	
	if ( homeserverid > 1000 and homeserverid < 2000 ) then
		serverlist = ml_global_information.ServersUS
	elseif ( homeserverid > 2000 and homeserverid < 3000 ) then
		serverlist = ml_global_information.ServersEU
	end	
	if ( TableSize(serverlist) > 0) then
		local i,entry = next ( serverlist)
		while i and entry do			
			newserverlist = newserverlist..","..entry.name
			i,entry = next ( serverlist,i)
		end
	end
	gGuestServer_listitems = newserverlist
	gGuestServer = Settings.GW2Minion.gGuestServer
end

function gw2minion.SwitchMode(mode)	
	ml_global_information.Reset()
	
	local newtask = ml_global_information.BotModes[mode]
    if (newtask ~= nil) then
		
		if (gBotRunning == "1") then
			ml_task_hub.ToggleRun()
		end
	
		-- ResetUI
		if (Settings.GW2Minion["gBotMode"] == nil ) then
			newtask:UIInit()
		elseif (Settings.GW2Minion["gBotMode"] ~= mode and ml_global_information.BotModes[Settings.GW2Minion["gBotMode"]] ~= nil) then
			ml_global_information.BotModes[Settings.GW2Minion["gBotMode"]]:UIDestroy()
			newtask:UIInit()			
		end		
		
		--Set marker type to the appropriate type.
		if (gBotMode == GetString("grindMode")) then
			ml_marker_mgr.SetMarkerType(GetString("grindMarker"))
		end
		
		--Setup default options.
		if (gBotMode == GetString("grindMode")) then
			
		end
		
	else
		if ( Settings.GW2Minion["gBotMode"] ~= nil and ml_global_information.BotModes[Settings.GW2Minion["gBotMode"]] ~= nil ) then
			ml_global_information.BotModes[Settings.GW2Minion["gBotMode"]]:UIDestroy()
		end
		d("No Valid BotMode selected")
	end
end


RegisterEventHandler("Module.Initalize",gw2minion.ModuleInit)
RegisterEventHandler("GUI.Update",gw2minion.GUIVarUpdate)
RegisterEventHandler("Gameloop.Update",gw2minion.OnUpdate)
RegisterEventHandler("Gameloop.CharSelectUpdate",gw2minion.OnUpdateCharSelect)
RegisterEventHandler("Gameloop.CutsceneUpdate",gw2minion.OnUpdateCutscene)