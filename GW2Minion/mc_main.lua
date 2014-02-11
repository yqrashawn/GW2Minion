mc_global = { }
mc_global.window = { name="MinionBot", x=50, y=50, width=200, height=350 }
mc_global.path = GetStartupPath()
mc_global.now = 0
mc_global.lasttick = 0
mc_global.running = false
mc_global.BotModes = {}


function mc_global.moduleinit()
	
	if ( Settings.GW2Minion.gPulseTime == nil ) then
		Settings.GW2Minion.gPulseTime = "150"
	end
	if ( Settings.GW2Minion.gBotMode == nil ) then
        Settings.GW2Minion.gBotMode = mc_getstring("grindMode")
    end
	if ( Settings.GW2Minion.gDepositItems == nil ) then
        Settings.GW2Minion.gDepositItems = "1"
    end
	
	
	GUI_NewWindow(mc_global.window.name,mc_global.window.x,mc_global.window.y,mc_global.window.width,mc_global.window.height)
	GUI_NewButton(mc_global.window.name,mc_getstring("startStop"),"mc_global.startStop")
	
	GUI_NewButton(mc_global.window.name, mc_getstring("blacklistManager"), "bToggleBlacklistMgr")
	RegisterEventHandler("bToggleBlacklistMgr", mc_blacklist.ToggleMenu)
	
	GUI_NewButton(mc_global.window.name,mc_getstring("radar"),"Radar.toggle")
	RegisterEventHandler("mc_global.startStop", mc_global.eventhandler)
	GUI_NewCheckbox(mc_global.window.name,mc_getstring("botEnabled"),"gBotRunning",mc_getstring("botStatus"));
	GUI_NewComboBox(mc_global.window.name,mc_getstring("botMode"),"gBotMode",mc_getstring("botStatus"),"None");
	-- Debug fields
	GUI_NewField(mc_global.window.name,"Task","dTrace",mc_getstring("botStatus"));
	GUI_NewField(mc_global.window.name,"AttackRange","dAttackRange",mc_getstring("botStatus"));
	
	
	GUI_NewNumeric(mc_global.window.name,mc_getstring("pulseTime"),"gPulseTime",mc_getstring("settings"),"10","10000");

	GUI_NewCheckbox(mc_global.window.name,mc_getstring("depositItems"),"gDepositItems",mc_getstring("settings"));
	
	
	GUI_NewButton(mc_global.window.name, GetString("questManager"), "QuestManager.toggle")
	GUI_NewButton(mc_global.window.name, mc_getstring("skillManager"), "SkillManager.toggle")
	GUI_NewButton(mc_global.window.name, mc_getstring("meshManager"), "ToggleMeshmgr")


	
	-- setup bot mode
    local botModes = "None"
    if ( TableSize(mc_global.BotModes) > 0) then
        local i,entry = next ( mc_global.BotModes )
        while i and entry do
            botModes = botModes..","..i
            i,entry = next ( mc_global.BotModes,i)
        end
    end
    
    gBotMode_listitems = botModes    
    gBotMode = Settings.GW2Minion.gBotMode	
	mc_global.UpdateMode()
	
	gBotRunning = "0"
	gPulseTime = Settings.GW2Minion.gPulseTime	
	gDepositItems = Settings.GW2Minion.gDepositItems	
	
	GUI_UnFoldGroup(mc_global.window.name,mc_getstring("botStatus") );		
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
				
				if (not ml_task_hub:Update() and ml_task_hub.shouldRun) then
					ml_error("No task queued, please select a valid bot mode in the Settings drop-down menu")
				end
				dTrace = ml_GetTraceString()
			end
		end
	end
	
	-- Mesher OnUpdate
	mm.OnUpdate( tickcount )
		
	-- SkillManager OnUpdate
	mc_skillmanager.OnUpdate( tickcount )
	
	-- BlackList OnUpdate
	mc_blacklist.OnUpdate( tickcount )
end


function mc_global.eventhandler(arg)
	if ( arg == "mc_global.startStop" ) then
		if ( gBotRunning == "1" ) then
			mc_global.togglebot("0")			
		else
			mc_global.togglebot("1")
		end
	end
end

	
function mc_global.guivarupdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		if (k == "gEnableLog" or
			k == "gDepositItems" or
			k == "sMmode" or 
			k == "sMtargetmode" or
			k == "gSalvage" or
			k == "gMaxSalvageRarity" or
			k == "gSalvageTrophies" or 
			k == "gRepairBrokenLimit" or
			k == "gRepairDamageLimit")			
		then
			Settings.GW2Minion[tostring(k)] = v
		
		elseif ( k == "gBotRunning" ) then
			mc_global.togglebot(v)			
		elseif ( k == "gBotMode") then        
			Settings.GW2Minion[tostring(k)] = v
			mc_global.UpdateMode()
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
		mc_ai_vendor.isSelling = false
		mc_ai_vendor.isBuying = false
		gBotRunning = "0"
		Player:StopMovement()
		ml_task_hub:ClearQueues()
		mc_global.UpdateMode()
	else
		d("Starting Bot..")
		mc_global.running = true
		ml_task_hub.shouldRun = true
		gBotRunning = "1"
	end
end

function mc_global.UpdateGlobals()
	mc_global.AttackRange = mc_skillmanager.GetAttackRange()
	
	
	
	-- Update Debug fields	
	dAttackRange = mc_global.AttackRange	
end

mc_global.stuckpos = {}
function mc_global.stuckhandler()
	d("We are stuck!?")
	mc_global.stuckpos = Player.pos
	--TODO: add proper antistuck handler
	d(Player:StopMovement())
	d(Player:SetMovement(2))
	

end

function mc_global.Wait( seconds ) 
	mc_global.lasttick = mc_global.lasttick + seconds
end

--test
function mc_global.test()
	local path = GetStartupPath() .. [[\LuaMods\GW2Minion\maps.data]]
	local data = persistence.load(path)
	d(TableSize(data))
end

RegisterEventHandler("Module.Initalize",mc_global.moduleinit)
RegisterEventHandler("Gameloop.Update",mc_global.onupdate)
RegisterEventHandler("Gameloop.Stuck",mc_global.stuckhandler)
RegisterEventHandler("GUI.Update",mc_global.guivarupdate)
