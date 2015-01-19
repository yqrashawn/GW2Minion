gw2minion = {}
gw2minion.MainWindow = { Name="MainMenu", x=50, y=50, width=220, height=310, ChildWindows = {} }
gw2minion.CinemaWindow = { Name="CinemaMenu", x=100, y=100 , width=250, height=100 }
gw2minion.CharacterWindow = { Name="CharacterMenu", x=100, y=100 , width=250, height=100 }
gw2minion.DebugWindow = { Name="DebugInfo", x=100, y=350 , width=200, height=350 }

function gw2minion.ModuleInit()
	--Init MainMenu Window
	mw = WindowManager:NewWindow(gw2minion.MainWindow.Name,gw2minion.MainWindow.x,gw2minion.MainWindow.y,gw2minion.MainWindow.width,gw2minion.MainWindow.height)
	if ( mw ) then
		mw:NewComboBox(GetString("botMode"),"gBotMode",GetString("botStatus"),"")
		mw:UnFold(GetString("botStatus") )
		
		mw:NewCheckBox(GetString("depositItems"),"gDepositItems",GetString("settings"))
		
		mw:NewCheckBox(GetString("combatMovement"),"gDoCombatMovement",GetString("settings"))
		
		mw:NewCheckBox(GetString("reviveplayers"),"gRevivePlayers",GetString("settings"))
		mw:NewCheckBox(GetString("revivecharacters"),"gRevive",GetString("settings"))
		mw:NewCheckBox(GetString("gatherMode"),"gGather",GetString("settings"))
		mw:NewCheckBox(GetString("disabledrawing"),"gDisableRender",GetString("settings"))
		mw:NewCheckBox(GetString("taskAllowTeleports"),"gAllowTeleport",GetString("settings"))
		
		
		local b = mw:NewButton(GetString("startBot"),"gw2minion.evBotstartStop")
		b:SetToggleState(false)
		b:SetSize(25,30)
		RegisterEventHandler("gw2minion.evBotstartStop", gw2minion.ToggleBot)
		RegisterEventHandler("GW2MINION.toggle", gw2minion.ToggleBot)
		
		local bd = mw:NewButton("D","gw2minion.evToggleDebugWindow")
		bd:Dock(0)
		bd:SetSize(15,14)
		bd:SetPos(180,0)
		RegisterEventHandler("gw2minion.evToggleDebugWindow", gw2minion.ShowDebug)
		
		mw:NewButton(GetString("showradar"),"gw2minion.evToggleRadar",GetString("advancedSettings"))
		local rm = mw:NewButton("R","gw2minion.evToggleRadar")
		rm:Dock(0)
		rm:SetSize(18,14)
		rm:SetPos(100,0)
		RegisterEventHandler("gw2minion.evToggleRadar", gw2_radar.ToggleMenu)
		
		mw:NewButton(GetString("skillManager"),"gw2minion.evToggleSkillManager",GetString("advancedSettings"))
		local sm = mw:NewButton("SM","gw2minion.evToggleSkillManager")
		sm:Dock(0)
		sm:SetSize(18,14)
		sm:SetPos(120,0)
		RegisterEventHandler("gw2minion.evToggleSkillManager", gw2_skill_manager.ToggleMenu)
		
		mw:NewButton(GetString("meshManager"),"ToggleMeshManager",GetString("advancedSettings"))
		local mm = mw:NewButton("ME","ToggleMeshManager")
		mm:Dock(0)
		mm:SetSize(18,14)
		mm:SetPos(140,0)		
		
		mw:NewButton(GetString("markerManager"),"ToggleMarkerMgr",GetString("advancedSettings"))
		local mm = mw:NewButton("MA","ToggleMarkerMgr")
		mm:Dock(0)
		mm:SetSize(18,14)
		mm:SetPos(160,0)
		
		mw:NewButton(GetString("sellmanager"),"ToggleSellMgr",GetString("advancedSettings"))
		RegisterEventHandler("ToggleSellMgr", gw2_sell_manager.ToggleMenu)
		
		mw:NewButton(GetString("buymanager"),"ToggleBuyMgr",GetString("advancedSettings"))
		RegisterEventHandler("ToggleBuyMgr", gw2_buy_manager.ToggleMenu)
		
		mw:NewButton(GetString("salvagemanager"),"ToggleSalvageMgr",GetString("advancedSettings"))
		RegisterEventHandler("ToggleSalvageMgr", gw2_salvage_manager.ToggleMenu)

		mw:NewButton(GetString("checkChat"),"gw2minion.evToggleChatManager",GetString("advancedSettings"))
		
		mw:NewButton(GetString("blacklistManager"),"ToggleBlacklistMgr",GetString("advancedSettings"))
		
		mw:NewButton(GetString("multibotmanager"),"MultiBotManager.toggle",GetString("advancedSettings"))
		
	end	
	-- Setup default bot modes
	gw2minion.UpdateBotModes()
	
	Settings.GW2Minion.gPulseTime = Settings.GW2Minion.gPulseTime or "150"
	Settings.GW2Minion.gBotMode = Settings.GW2Minion.gBotMode or GetString("grindMode")
	Settings.GW2Minion.gBotRunning = Settings.GW2Minion.gBotRunning or "0"	
	Settings.GW2Minion.gGuestServer = Settings.GW2Minion.gGuestServer or "None"
	Settings.GW2Minion.gDisableRender = Settings.GW2Minion.gDisableRender or "0"
	Settings.GW2Minion.gAllowTeleport = Settings.GW2Minion.gAllowTeleport or "0"
	Settings.GW2Minion.gDepositItems = Settings.GW2Minion.gDepositItems or "1"	
	Settings.GW2Minion.gDoCombatMovement = Settings.GW2Minion.gDoCombatMovement or "1"	
	Settings.GW2Minion.gRevivePlayers = Settings.GW2Minion.gRevivePlayers or "1"
	Settings.GW2Minion.gRevive = Settings.GW2Minion.gRevive or "1"	
	Settings.GW2Minion.gGather = Settings.GW2Minion.gGather or "1"
	
    gBotMode = Settings.GW2Minion.gBotMode
	gBotRunning	= Settings.GW2Minion.gBotRunning
	gPulseTime = Settings.GW2Minion.gPulseTime
	gDepositItems = Settings.GW2Minion.gDepositItems	
	gDoCombatMovement = Settings.GW2Minion.gDoCombatMovement		
	gRevivePlayers = Settings.GW2Minion.gRevivePlayers
	gRevive = Settings.GW2Minion.gRevive
	gDisableRender = Settings.GW2Minion.gDisableRender
	gAllowTeleport = Settings.GW2Minion.gAllowTeleport
	gGather = Settings.GW2Minion.gGather
	
	if ( RenderManager ) then RenderManager:ToggleRendering(tonumber(gDisableRender)) end
	
	-- CinemaWindow	
	Settings.GW2Minion.gSkipCutscene = Settings.GW2Minion.gSkipCutscene or "0"
	local cw = WindowManager:NewWindow(gw2minion.CinemaWindow.Name,gw2minion.CinemaWindow.x,gw2minion.CinemaWindow.y,gw2minion.CinemaWindow.width,gw2minion.CinemaWindow.height)
	cw:NewCheckBox(GetString("skipcutscene"),"gSkipCutscene",GetString("settings"))
	cw:UnFold(GetString("settings") )
	gSkipCutscene = Settings.GW2Minion.gSkipCutscene
	
	-- CharacterWindow
	Settings.GW2Minion.gGuestServer = Settings.GW2Minion.gGuestServer or "None"
	Settings.GW2Minion.gAutostartbot = Settings.GW2Minion.gAutostartbot or "0"
	local caw = WindowManager:NewWindow(gw2minion.CharacterWindow.Name,gw2minion.CharacterWindow.x,gw2minion.CharacterWindow.y,gw2minion.CharacterWindow.width,gw2minion.CharacterWindow.height)
	caw:NewComboBox(GetString("guestserver"),"gGuestServer",GetString("settings"),"None")
	caw:NewCheckBox(GetString("autoStartBot"),"gAutostartbot",GetString("settings"))
	caw:UnFold(GetString("settings") )
	-- Setup GuestServerList
	gw2minion.UpdateGuestServers()
	gGuestServer = Settings.GW2Minion.gGuestServer
	gAutostartbot = Settings.GW2Minion.gAutostartbot
	
	
	-- DebugWindow
	local dw = WindowManager:NewWindow(gw2minion.DebugWindow.Name,gw2minion.DebugWindow.x,gw2minion.DebugWindow.y,gw2minion.DebugWindow.width,gw2minion.DebugWindow.height,true)
		dw:NewField("AttackRange","dAttackRange","Global")		
		dw:NewCheckBox("LogEnabled","gEnableLog","Global")
		dw:NewCheckBox("LogCNE","gLogCNE","Global")
		dw:NewNumeric("PulseTime","gPulseTime","Global",100,9999)		
		dw:Hide()
		gLogCNE = "0"
		gEnableLog = "0"
		gPulseTime = Settings.GW2Minion.gPulseTime
		
	gw2minion.MainWindow.ChildWindows[gw2minion.DebugWindow.Name] = gw2minion.DebugWindow.Name
	gw2minion.MainWindow.ChildWindows[ml_mesh_mgr.mainwindow] = ml_mesh_mgr.mainwindow
	gw2minion.MainWindow.ChildWindows[ml_task_mgr.mainWindow.name] = ml_task_mgr.mainWindow.name
	gw2minion.MainWindow.ChildWindows[ml_task_mgr.editWindow.name] = ml_task_mgr.editWindow.name
	
	-- Setup marker manager callbacks and vars
	if ( ml_marker_mgr ) then
		ml_marker_mgr.GetPosition = 	function () return ml_global_information.Player_Position end
		ml_marker_mgr.GetLevel = 		function () return ml_global_information.Player_Level end
		ml_marker_mgr.DrawMarker =		ml_global_information.DrawMarker
		ml_marker_mgr.parentWindow = { Name=gw2minion.MainWindow.Name}
		ml_marker_mgr.markerPath = ml_global_information.Path.. [[\Navigation\]]		
	end
	
	-- setup meshmanager
	if ( ml_mesh_mgr ) then
		ml_mesh_mgr.parentWindow.Name = gw2minion.MainWindow.Name
		ml_mesh_mgr.GetMapID = function () return ml_global_information.CurrentMapID end
		ml_mesh_mgr.GetMapName = function () return ml_global_information.CurrentMapName end
		ml_mesh_mgr.GetPlayerPos = function () return ml_global_information.Player_Position end
		ml_mesh_mgr.averagegameunitsize = 50
		
		-- Set worldnavigation data
		ml_mesh_mgr.navData = persistence.load(ml_global_information.Path..[[\LuaMods\GW2Minion\]].."worldnav_data.lua")
		if ( not ValidTable(ml_mesh_mgr.navData)) then 
			ml_mesh_mgr.navData = {} 
		else
			ml_mesh_mgr.SetupNavNodes()
		end
		
		-- Set default meshes SetDefaultMesh(mapid, filename)
		ml_mesh_mgr.SetDefaultMesh(15,"Queensdale")
		ml_mesh_mgr.SetDefaultMesh(17,"Harathi Hinterlands")
		ml_mesh_mgr.SetDefaultMesh(18,"Divinitys Reach")	
		ml_mesh_mgr.SetDefaultMesh(19,"PlainsOfAshford")
		ml_mesh_mgr.SetDefaultMesh(20,"BlazzeridgeSteppes")
		ml_mesh_mgr.SetDefaultMesh(21,"Fields of Ruin")
		ml_mesh_mgr.SetDefaultMesh(22,"FireHeartRise")		
		ml_mesh_mgr.SetDefaultMesh(23,"Kessex Hills")		
		ml_mesh_mgr.SetDefaultMesh(24,"Gendarran Fields")
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
		
		ml_mesh_mgr.SetDefaultMesh(50,"Lions Arch")		
		ml_mesh_mgr.SetDefaultMesh(51,"Straits of Devastation")
		ml_mesh_mgr.SetDefaultMesh(53,"Sparkfly Fen")
		ml_mesh_mgr.SetDefaultMesh(54,"Brisban Wildlands")
		
		ml_mesh_mgr.SetDefaultMesh(62,"CursedShore")
		ml_mesh_mgr.SetDefaultMesh(65,"Malchors Leap")
		ml_mesh_mgr.SetDefaultMesh(73,"BloodtideCoast")
		
		ml_mesh_mgr.SetDefaultMesh(91,"The Grove")
		ml_mesh_mgr.SetDefaultMesh(139,"Rata Sum")
		ml_mesh_mgr.SetDefaultMesh(218,"Black Citadel")
		ml_mesh_mgr.SetDefaultMesh(326,"Hoelbrak")
		ml_mesh_mgr.SetDefaultMesh(350,"Heart of the Mists")
		ml_mesh_mgr.SetDefaultMesh(968,"EdgeOfTheMist")
		ml_mesh_mgr.SetDefaultMesh(988,"Dry Top")
		
		-- Setup the marker types we wanna use
		    local grindMarker = ml_marker:Create("grindMarker")
			grindMarker:SetType(GetString("grindMarker"))
			grindMarker:SetMinLevel(1)
			grindMarker:SetMaxLevel(80)
			grindMarker:SetTime(300)
			grindMarker:AddField("int", GetString("maxRange"), 15000)
			ml_marker_mgr.AddMarkerTemplate(grindMarker)			
			
			local gatherMarker = ml_marker:Create("gatherMarker")
			gatherMarker:SetType(GetString("gatherMarker"))
			gatherMarker:SetMinLevel(1)
			gatherMarker:SetMaxLevel(80)			
			gatherMarker:AddField("int", GetString("maxRange"), 15000)
			ml_marker_mgr.AddMarkerTemplate(gatherMarker)
			
			local vendorMarker = ml_marker:Create("vendorTemplate")
			vendorMarker:SetType(GetString("vendorMarker"))
			vendorMarker:SetMinLevel(1)
			vendorMarker:SetMaxLevel(80)
			ml_marker_mgr.AddMarkerTemplate(vendorMarker)
			
			
			-- refresh the manager with the new templates
			ml_marker_mgr.RefreshMarkerTypes()
			ml_marker_mgr.RefreshMarkerNames()
				
		ml_mesh_mgr.InitMarkers() -- Update the Markers-group in the mesher UI
	end
	
	-- Setup blacklists
	if ( ml_blacklist_mgr ) then
		ml_blacklist_mgr.parentWindow = { Name=gw2minion.MainWindow.Name }
		ml_blacklist_mgr.path = GetStartupPath() .. [[\LuaMods\GW2Minion\blacklist.info]]
		ml_blacklist_mgr.ReadBlacklistFile(ml_blacklist_mgr.path)
		if not ml_blacklist.BlacklistExists(GetString("event")) then
			ml_blacklist.CreateBlacklist(GetString("event"))
		end
		if not ml_blacklist.BlacklistExists(GetString("mapobjects")) then
			ml_blacklist.CreateBlacklist(GetString("mapobjects"))
		end
		if not ml_blacklist.BlacklistExists(GetString("monsters")) then
			ml_blacklist.CreateBlacklist(GetString("monsters"))
		end
		if not ml_blacklist.BlacklistExists(GetString("partymember")) then
			ml_blacklist.CreateBlacklist(GetString("partymember"))
		end
		if not ml_blacklist.BlacklistExists(GetString("salvageItems")) then
			ml_blacklist.CreateBlacklist(GetString("salvageItems"))
		end
		if not ml_blacklist.BlacklistExists(GetString("vendors")) then
			ml_blacklist.CreateBlacklist(GetString("vendors"))
		end
		if not ml_blacklist.BlacklistExists(GetString("vendorsbuy")) then
			ml_blacklist.CreateBlacklist(GetString("vendorsbuy"))
		end
		
	end
	
	gw2minion.SwitchMode(gBotMode)
	if ( gBotRunning == "1" ) then		
		gw2minion.ToggleBot("GW2MINION.toggle")
	end				
end

function gw2minion.OnUpdate(event, tickcount )
	ml_global_information.Now = tickcount
	
	-- OMC Handler
	ml_mesh_mgr.OMC_Handler_OnUpdate( tickcount )
	
	if ( TimeSince(ml_global_information.Lasttick) > tonumber(gPulseTime) ) then
		ml_global_information.Lasttick = tickcount		
		gw2minion.SwitchUIForGameState()
		
		-- Call all OnUpdate()
		ml_global_information.OnUpdate()			
		-- Mesher OnUpdate
		ml_mesh_mgr.OnUpdate( tickcount )
		-- BlackList OnUpdate		
		ml_blacklist_mgr.UpdateEntryTime()
		ml_blacklist_mgr.UpdateEntries(tickcount)
		-- SkillManager OnUpdate
		gw2_skill_manager.OnUpdate(tickcount)
		-- MultiBotManager OnUpdate
		gw2_multibot_manager.OnUpdate(tickcount)
						
		if ( ml_global_information.Running ) then		
			
			-- Common Tasks (AoE loot, deposit items etc. )
			gw2_common_tasks.OnUpdate( tickcount )
			
			-- FollowMode OnUpdate
			gw2_task_follow.OnUpdate( tickcount)
			
			-- ChatAlert OnUpdate
			gw2_chatmanager.ChatMonitor( tickcount )
			
			-- BotMode OnUpdate
			if( ml_task_hub:CurrentTask() ~= nil) then
				ml_log(ml_task_hub:CurrentTask().name.." :")
			end
				
			if ( ml_task_hub.shouldRun ) then
				if (not ml_task_hub:Update() ) then
					if ( not ml_global_information.Reset() ) then
						ml_error("No task queued, please select a valid bot mode in the Settings drop-down menu")
					end
				end
			end
				
		end
		GUI_SetStatusBar(ml_GetLogString())
	end
end

gw2minion.Charscreen_lastrun = 0
function gw2minion.OnUpdateCharSelect(event, tickcount )
	ml_global_information.Now = tickcount	
	if ( TimeSince(ml_global_information.Lasttick) > tonumber(gPulseTime) ) then
		ml_global_information.Lasttick = tickcount
		gw2minion.SwitchUIForGameState()
		
		if ( TimeSince(gw2minion.Charscreen_lastrun) > 3000 ) then 
			gw2minion.Charscreen_lastrun = ml_global_information.Now
			if ( gGuestServer ~= nil and gGuestServer ~= "None" ) then
				
				local serverlist = {}
				local homeserverid = GetHomeServer()
				if ( homeserverid > 1000 and homeserverid < 2000 ) then
					serverlist = ml_global_information.ServersUS
				elseif ( homeserverid > 2000 and homeserverid < 3000 ) then
					serverlist = ml_global_information.ServersEU
				end	
				if ( TableSize(serverlist) > 0) then
					local i,entry = next ( serverlist)
					while i and entry do			
						if ( gGuestServer == entry.name ) then
							SetServer(entry.id)
							d("Selecting Guestserver: "..(entry.name) .." ID: ".. tostring(entry.id))
							break
						end
						i,entry = next ( serverlist,i)
					end
				end			
			end	
			if ( gAutostartbot == "1" ) then
				GUI_ToggleConsole(false)
				d("Pressing PLAY")
				PressKey("RETURN")
			end
		end
	end
end
gw2minion.Cinema_lastrun = 0
function gw2minion.OnUpdateCutscene(event, tickcount )
	ml_global_information.Now = tickcount
	if ( TimeSince(ml_global_information.Lasttick) > tonumber(gPulseTime) ) then
		ml_global_information.Lasttick = tickcount
		gw2minion.SwitchUIForGameState()
		
		Player:StopMovement()
		if ( gSkipCutscene == "1" and TimeSince( gw2minion.Cinema_lastrun) > 3000 ) then
			gw2minion.Cinema_lastrun = ml_global_information.Now
			GUI_ToggleConsole(false)
			d("Skipping Cutscene...")
			PressKey("ESC")
		end
	end
end

function gw2minion.ToggleBot(arg)
	local mw = WindowManager:GetWindow(gw2minion.MainWindow.Name)
	if ( mw ) then 
		local sb = mw:GetControl(GetString("startBot"))
		if ( sb ) then
			if ( arg == "GW2MINION.toggle" ) then -- CTRL + S
				if ( sb.pressed ) then
					sb:SetToggleState(false)
				else
					sb:SetToggleState(true)
				end
			elseif (arg == "on" ) then
				sb:SetToggleState(true)
			elseif (arg == "off" ) then
				sb:SetToggleState(false)
			end
			if ( sb.pressed ) then
				d("Starting Bot..")
				ml_global_information.Running = true
				ml_task_hub.shouldRun = true
				Settings.GW2Minion.gBotRunning = "1"
				sb:SetText(GetString("stopBot"))
				gw2_unstuck.Start()
			else
				d("Stopping Bot..")
				ml_global_information.Running = false
				ml_task_hub.shouldRun = false		
				Settings.GW2Minion.gBotRunning = "0"
				ml_global_information.Stop()
				ml_global_information.Reset()				
				sb:SetText(GetString("startBot"))
			end
		end
	end
end

--switches the shown UI according to the gamestate
gw2minion.lastWindowState = {}
function gw2minion.SwitchUIForGameState(tickcount)
	local currentGameState = GetGameState()
	if ( currentGameState ~= ml_global_information.LastGameState ) then
		ml_global_information.LastGameState = currentGameState
		GUI_ToggleConsole(false)
		local wMain = WindowManager:GetWindow(gw2minion.MainWindow.Name)
		local wCine = WindowManager:GetWindow(gw2minion.CinemaWindow.Name)
		local wChar = WindowManager:GetWindow(gw2minion.CharacterWindow.Name)
		if ( wMain and wCine and wChar) then

			local manageChildWindows = function(arg)
				for name,_ in pairs(gw2minion.MainWindow.ChildWindows) do
					local wnd = WindowManager:GetWindow(name)
					if ( wnd ) then
						if ( arg ~= true ) then
							gw2minion.lastWindowState[wnd.name] = wnd.visible
							wnd:Hide()
						elseif ( gw2minion.lastWindowState[wnd.name] ) then
							wnd:Show()
						end
					end
				end
			end

			if ( currentGameState == 16 ) then --ingame
				wMain:Show()
				manageChildWindows(true)
				wCine:Hide()
				wChar:Hide()
			elseif( currentGameState == 14 or currentGameState == 10 ) then --cinematic
				wMain:Hide()
				manageChildWindows()
				wCine:Show()
				wChar:Hide()
				gw2minion.Cinema_lastrun = ml_global_information.Now
			elseif( currentGameState == 4 ) then --charscreen
				wMain:Hide()
				manageChildWindows()
				wCine:Hide()
				wChar:Show()
				gw2minion.Charscreen_lastrun = ml_global_information.Now
			end
		end	
	end
end

function gw2minion.GUIVarUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		if (k == "gBotMode" ) then
			ml_global_information.Stop()
			gw2minion.SwitchMode(v)
			Settings.GW2Minion[tostring(k)] = v
		elseif ( k == "gDisableRender") then
			RenderManager:ToggleRendering(tonumber(v))
			Settings.GW2Minion[tostring(k)] = v		
		elseif ( k == "gGuestServer" or
			k == "gAutostartbot" or
			k == "gSkipCutscene" or
			k == "gDepositItems" or
			k == "gDoEvents" or
			k == "gDoCombatMovement" or
			k == "gGather" or			
			k == "gRevivePlayers" or
			k == "gRevive" or
			k == "gDisableRender" or 
			k == "gAllowTeleport" or 
			k == "SellManager_Active" or 
			k == "BuyManager_Active" or 
			k == "BuyManager_Crudekit" or
			k == "BuyManager_Basickit" or
			k == "BuyManager_Finekit" or
			k == "BuyManager_Journeymankit" or
			k == "BuyManager_Masterkit" or
			k == "BuyManager_toolStacks" or
			k == "BuyManager_GarheringTool" or 
			k == "SalvageManager_Active" or
			k == "gMultiBotEnabled"
			) then
			Settings.GW2Minion[tostring(k)] = v
					
		end
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
    local botModes = GetString("grindMode")
    if ( ValidTable(ml_global_information.BotModes) ) then
        local i,entry = next ( ml_global_information.BotModes )
        while i and entry do
            if ( GetString("grindMode") ~= i ) then
				botModes = botModes..","..i
			end
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

-- Switching BotMode and updating UI accordingly
function gw2minion.SwitchMode(mode)	
	ml_global_information.Reset()
	local newtask = ml_global_information.BotModes[mode]
    if (newtask ~= nil) then
		
		if (gBotRunning == "1") then
			ml_task_hub.ToggleRun()
		end
	
		-- Destroy old UI	
		if (Settings.GW2Minion["gBotMode"] ~= nil and ml_global_information.BotModes[Settings.GW2Minion["gBotMode"]] ~= nil) then
			ml_global_information.BotModes[Settings.GW2Minion["gBotMode"]]:UIDestroy()						
		end
		-- Create new UI
		newtask:UIInit()
		
		--Set marker type to the appropriate type.
		if (gBotMode == GetString("grindMode")) then
			ml_marker_mgr.SetMarkerType(GetString("grindMarker"))
		elseif (gBotMode == GetString("gatherMode")) then
			ml_marker_mgr.SetMarkerType(GetString("gatherMarker"))
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

-- Extra debug window with live values
function gw2minion.ShowDebug()
	local dw = WindowManager:GetWindow(gw2minion.DebugWindow.Name)
	if ( dw ) then
		if ( dw.visible ) then
			dw:Hide()
			ml_global_information.ShowDebug = false
			gEnableLog = "0"
			gLogCNE = "0"
		else
			dw:Show()
			ml_global_information.ShowDebug = true			
		end
	end
end
RegisterEventHandler("Module.Initalize",gw2minion.ModuleInit)
RegisterEventHandler("GUI.Update",gw2minion.GUIVarUpdate)
RegisterEventHandler("Gameloop.Update",gw2minion.OnUpdate)
RegisterEventHandler("Gameloop.CharSelectUpdate",gw2minion.OnUpdateCharSelect)
RegisterEventHandler("Gameloop.CutsceneUpdate",gw2minion.OnUpdateCutscene)