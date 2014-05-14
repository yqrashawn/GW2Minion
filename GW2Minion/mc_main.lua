mc_global = { }
mc_global.window = { name="MinionBot", x=50, y=50, width=200, height=300 }
mc_global.advwindow = { name="AdvandedSettings", x=250, y=200 , width=200, height=170 }
mc_global.advwindowvisible = false
mc_global.path = GetStartupPath()
mc_global.now = 0
mc_global.lasttick = 0
mc_global.running = false
mc_global.BotModes = {}

mc_global.WorldMarkerType = 24 -- enum for "in current map", changes on larger patches sometimes


function mc_global.moduleinit()
	
	if ( Settings.GW2Minion.gPulseTime == nil ) then
		Settings.GW2Minion.gPulseTime = "150"
	end
	if ( Settings.GW2Minion.gBotMode == nil ) then
        Settings.GW2Minion.gBotMode = GetString("grindMode")
    end
	if ( Settings.GW2Minion.gDepositItems == nil ) then
        Settings.GW2Minion.gDepositItems = "1"
    end
	if ( Settings.GW2Minion.gDoEvents == nil ) then
        Settings.GW2Minion.gDoEvents = "1"
    end
	if ( Settings.GW2Minion.gAutostartbot == nil ) then
		Settings.GW2Minion.gAutostartbot = "0"
	end
	if ( Settings.GW2Minion.gGuestServer == nil ) then
		Settings.GW2Minion.gGuestServer = "None"
	end
	if ( Settings.GW2Minion.gSkipCutscene == nil ) then
		Settings.GW2Minion.gSkipCutscene = "None"
	end
	if ( Settings.GW2Minion.gGather == nil ) then
		Settings.GW2Minion.gGather = "1"
	end
	if ( Settings.GW2Minion.gRevive == nil ) then
		Settings.GW2Minion.gRevive = "1"
	end	
	if ( Settings.GW2Minion.dDisableRender == nil ) then
		Settings.GW2Minion.dDisableRender = "0"
	end	
	
	-- MAIN WINDOW
	GUI_NewWindow(mc_global.window.name,mc_global.window.x,mc_global.window.y,mc_global.window.width,mc_global.window.height)
	GUI_NewButton(mc_global.window.name,GetString("startStop"),"mc_global.startStop")
		
	GUI_NewButton(mc_global.window.name,GetString("showradar"),"Radar.toggle")
	RegisterEventHandler("mc_global.startStop", mc_global.eventhandler)
	GUI_NewCheckbox(mc_global.window.name,GetString("botEnabled"),"gBotRunning",GetString("botStatus"))
	GUI_NewCheckbox(mc_global.window.name,GetString("autoStartBot"),"gAutostartbot",GetString("botStatus"))
	GUI_NewComboBox(mc_global.window.name,GetString("botMode"),"gBotMode",GetString("botStatus"),"None")
	-- Debug fields
	--GUI_NewField(mc_global.window.name,"Task","dTrace",GetString("botStatus"))
	GUI_NewField(mc_global.window.name,"AttackRange","dAttackRange",GetString("botStatus"))
	GUI_NewCheckbox(mc_global.window.name,GetString("disabledrawing"),"dDisableRender",GetString("botStatus"))
		
	GUI_NewNumeric(mc_global.window.name,GetString("pulseTime"),"gPulseTime",GetString("settings"),"10","10000")

	GUI_NewCheckbox(mc_global.window.name,GetString("depositItems"),"gDepositItems",GetString("settings"))	
	GUI_NewCheckbox(mc_global.window.name,GetString("doEvents"),"gDoEvents",GetString("settings"))
	GUI_NewComboBox(mc_global.window.name,GetString("guestserver"),"gGuestServer",GetString("settings"),"None")	
	GUI_NewCheckbox(mc_global.window.name,GetString("skipcutscene"),"gSkipCutscene",GetString("settings"))
	GUI_NewCheckbox(mc_global.window.name,GetString("gatherMode"),"gGather",GetString("settings"))
	GUI_NewCheckbox(mc_global.window.name,GetString("revivecharacters"),"gRevive",GetString("settings"))

	
	GUI_NewButton(mc_global.window.name, GetString("advancedSettings"), "AdvancedSettings.toggle")
	RegisterEventHandler("AdvancedSettings.toggle", mc_global.ToggleAdvMenu)
	
	-- ADVANCED SETTINGS WINDOW
	GUI_NewWindow(mc_global.advwindow.name,mc_global.advwindow.x,mc_global.advwindow.y,mc_global.advwindow.width,mc_global.advwindow.height,true)
	GUI_NewButton(mc_global.advwindow.name, GetString("multibotmanager"), "MultiBotManager.toggle")
	GUI_NewButton(mc_global.advwindow.name, GetString("blacklistManager"), "bToggleBlacklistMgr")
	RegisterEventHandler("bToggleBlacklistMgr", mc_blacklist.ToggleMenu)
	GUI_NewButton(mc_global.advwindow.name, GetString("questManager"), "QuestManager.toggle")	
	GUI_NewButton(mc_global.advwindow.name, GetString("skillManager"), "SkillManager.toggle")
	GUI_NewButton(mc_global.advwindow.name, GetString("maprotation"), "MapRotation.toggle")
	GUI_NewButton(mc_global.advwindow.name, GetString("meshManager"), "ToggleMeshmgr")
		
	GUI_WindowVisible(mc_global.advwindow.name,false)
	
	-- setup bot mode
    local botModes = "None"
    if ( TableSize(mc_global.BotModes) > 0) then
        local i,entry = next ( mc_global.BotModes )
        while i and entry do
            botModes = botModes..","..i
            i,entry = next ( mc_global.BotModes,i)
        end
    end
	
	-- GuestServer
	local newserverlist = "None"
	local homeserverid = GetHomeServer()
	local serverlist = {}	
	if ( homeserverid > 1000 and homeserverid < 2000 ) then
		serverlist = mc_datamanager.ServersUS
	elseif ( homeserverid > 2000 and homeserverid < 3000 ) then
		serverlist = mc_datamanager.ServersEU
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
    
    gBotMode_listitems = botModes    
    gBotMode = Settings.GW2Minion.gBotMode	
	mc_global.UpdateMode()
	
	gBotRunning = "0"
	gPulseTime = Settings.GW2Minion.gPulseTime	
	gDepositItems = Settings.GW2Minion.gDepositItems	
	gDoEvents = Settings.GW2Minion.gDoEvents	
	gAutostartbot = Settings.GW2Minion.gAutostartbot
	gSkipCutscene = Settings.GW2Minion.gSkipCutscene
	gGather = Settings.GW2Minion.gGather
	gRevive = Settings.GW2Minion.gRevive
	dDisableRender = Settings.GW2Minion.dDisableRender
	GUI_UnFoldGroup(mc_global.window.name,GetString("botStatus") );		
end

function mc_global.onupdate( event, tickcount )
	mc_global.now = tickcount
	
	if ( mc_global.running ) then		
		if ( tickcount - mc_global.lasttick > tonumber(gPulseTime) ) then
			mc_global.lasttick = tickcount
			
			-- Update global variables
			mc_global.UpdateGlobals()
			
			
			-- Let the bot tick ;)
			if ( mc_global.BotModes[gBotMode] ) then
												
				if( ml_task_hub:CurrentTask() ~= nil) then
					ml_log(ml_task_hub:CurrentTask().name.." :")
				end
				
				if ( ml_task_hub.shouldRun ) then
					if ( (gBotMode == GetString("grindMode") or gBotMode == GetString("exploreMode")) and mc_meshrotation.Update() == true) then
						
					end
					
					if (not ml_task_hub:Update() ) then
						ml_error("No task queued, please select a valid bot mode in the Settings drop-down menu")
					end
				end
				
				-- Unstuck OnUpdate
				mc_ai_unstuck:OnUpdate( tickcount )
											
				GUI_SetStatusBar(ml_GetTraceString())
			end
		end
	
	elseif ( mc_global.running == false and gAutostartbot == "1" ) then
		mc_global.togglebot(1)
	else
		GUI_SetStatusBar("BOT: Not Running")
	end
	
	-- Mesher OnUpdate
	mm.OnUpdate( tickcount )
		
	-- SkillManager OnUpdate
	mc_skillmanager.OnUpdate( tickcount )
	
	-- PartyManager OnUpdate
	mc_multibotmanager.OnUpdate( tickcount )
	
	-- BlackList OnUpdate
	mc_blacklist.OnUpdate( tickcount )
	
	-- FollowBot OnUpdate
	mc_followbot.OnUpdate( tickcount )
end

mc_global.Charscreen_lastrun = 0
function mc_global.OnUpdateCharSelect(event, tickcount )
	GUI_SetStatusBar("In Characterscreen...Autostart Bot: "..tostring(gAutostartbot).. ", (Guest)Server: "..tostring(gGuestServer))
	mc_global.now = tickcount
	if (mc_global.Charscreen_lastrun == 0) then
		mc_global.Charscreen_lastrun = tickcount
	elseif ( gAutostartbot == "1" and tickcount - mc_global.Charscreen_lastrun > 2500) then
		mc_global.Charscreen_lastrun = tickcount
		
		
		if ( gGuestServer ~= nil and gGuestServer ~= "None" ) then
			local serverlist = {}
			local homeserverid = GetHomeServer()
			if ( homeserverid > 1000 and homeserverid < 2000 ) then
				serverlist = mc_datamanager.ServersUS
			elseif ( homeserverid > 2000 and homeserverid < 3000 ) then
				serverlist = mc_datamanager.ServersEU
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
			--gGuestServer_listitems = newserverlist
			--gGuestServer = Settings.GW2Minion.gGuestServer
			
		end		
		d("Pressing PLAY")
		PressKey("RETURN")				
	end
end

mc_global.Cinema_lastrun = 0
function mc_global.OnUpdateCutscene(event, tickcount )
	GUI_SetStatusBar("In Cutscene...")	
	mc_global.now = tickcount
	Player:StopMovement()
	if ( gSkipCutscene == "1" and tickcount - mc_global.Cinema_lastrun > 2000 ) then
		mc_global.Cinema_lastrun = tickcount
		d("Skipping Cutscene...")
		PressKey("ESC")
	end
end


function mc_global.eventhandler(arg)
	if ( arg == "mc_global.startStop" or arg == "GW2MINION.toggle") then
		if ( gBotRunning == "1" ) then
			gAutostartbot = "0"
			mc_global.togglebot("0")			
		else
			gAutostartbot = "1"
			mc_global.togglebot("1")
		end
	end
end

function mc_global.guivarupdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		if (k == "gEnableLog" or
			k == "gDepositItems" or
			k == "gDoEvents" or 
			k == "sMmode" or 
			k == "sMtargetmode" or
			k == "SalvageManager_Active" or
			k == "gRepairBrokenLimit" or
			k == "gRepairDamageLimit" or 
			k == "MBSGroup" or 
			k == "gMultiPort" or 
			k == "gMultiPw" or 
			k == "gMultiIP" or 			
			k == "gAutostartbot" or
			k == "gGuestServer" or
			k == "gSkipCutscene" or
			k == "gGather" or
			k == "gRevive" or 
			k == "dDisableRender")			
		then
			Settings.GW2Minion[tostring(k)] = v
		elseif (k == "dMember1") then Settings.GW2Minion.Party[1] = v Settings.GW2Minion.Party = Settings.GW2Minion.Party
		elseif (k == "dMember2") then Settings.GW2Minion.Party[2] = v Settings.GW2Minion.Party = Settings.GW2Minion.Party
		elseif (k == "dMember3") then Settings.GW2Minion.Party[3] = v Settings.GW2Minion.Party = Settings.GW2Minion.Party
		elseif (k == "dMember4") then Settings.GW2Minion.Party[4] = v Settings.GW2Minion.Party = Settings.GW2Minion.Party		
			
		elseif ( k == "gBotRunning" ) then
			mc_global.togglebot(v)			
		elseif ( k == "gBotMode") then        
			Settings.GW2Minion[tostring(k)] = v
			mc_global.UpdateMode()
			mm.NavMeshUpdate()
		elseif ( k == "gMultiBotEnabled" ) then
			if ( v == "0" ) then							
				MultiBotDisconnect()				
			end
			Settings.GW2Minion[tostring(k)] = v
		elseif ( k == "dDisableRender") then
			RenderManager:ToggleRendering(tonumber(v))		
		end
	end
	GUI_RefreshWindow(mc_global.window.name)
end

function mc_global.UpdateMode()
	if (gBotMode == "None") then	
		ml_task_hub:ClearQueues()
	else	
		local task = mc_global.BotModes[gBotMode]
		if (task ~= nil) then
			ml_task_hub:Add(task.Create(), LONG_TERM_GOAL, TP_ASAP)
		end
    end
end

function mc_global.togglebot(arg)
	if arg == "0" then	
		d("Stopping Bot..")
		mc_global.running = false
		ml_task_hub.shouldRun = false		
		gBotRunning = "0"
		mc_global.ResetBot()
		ml_task_hub:ClearQueues()
		mc_global.UpdateMode()
	else
		d("Starting Bot..")
		mc_global.running = true
		ml_task_hub.shouldRun = true
		gBotRunning = "1"
		mc_meshrotation.currentMapTime = mc_global.now
	end
end

function mc_global.UpdateGlobals()
	mc_global.AttackRange = mc_skillmanager.GetAttackRange()
	
	
	
	-- Update Debug fields	
	dAttackRange = mc_global.AttackRange	
end

function mc_global.ResetBot()
	mc_ai_vendor.isSelling = false
	mc_ai_vendor.isBuying = false
	Player:StopMovement()
	Player:ClearTarget()
end

function mc_global.Wait( seconds ) 
	mc_global.lasttick = mc_global.lasttick + seconds
end

function mc_global.ToggleAdvMenu()
    if (mc_global.advwindowvisible) then
        GUI_WindowVisible(mc_global.advwindow.name,false)	
        mc_global.advwindowvisible = false
    else
		local wnd = GUI_GetWindowInfo("MinionBot")	
        GUI_MoveWindow( mc_global.advwindow.name, wnd.x,wnd.y+wnd.height)
		GUI_WindowVisible(mc_global.advwindow.name,true)	
        mc_global.advwindowvisible = true
    end
end

RegisterEventHandler("Module.Initalize",mc_global.moduleinit)
RegisterEventHandler("Gameloop.Update",mc_global.onupdate)
RegisterEventHandler("GUI.Update",mc_global.guivarupdate)
RegisterEventHandler("Gameloop.CharSelectUpdate",mc_global.OnUpdateCharSelect)
RegisterEventHandler("Gameloop.CutsceneUpdate",mc_global.OnUpdateCutscene)
RegisterEventHandler("GW2MINION.toggle", mc_global.eventhandler)