mc_global = { }
mc_global.window = { name="MinionBot", x=50, y=50, width=200, height=200 }
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
	
	GUI_NewWindow(mc_global.window.name,mc_global.window.x,mc_global.window.y,mc_global.window.width,mc_global.window.height)
	GUI_NewButton(mc_global.window.name,mc_getstring("startStop"),"mc_global.startStop")
	GUI_NewButton(mc_global.window.name,mc_getstring("radar"),"Radar.toggle")
	RegisterEventHandler("mc_global.startStop", mc_global.eventhandler)
	GUI_NewCheckbox(mc_global.window.name,mc_getstring("botEnabled"),"gBotRunning",mc_getstring("botStatus"));
	GUI_NewComboBox(mc_global.window.name,mc_getstring("botMode"),"gBotMode",mc_getstring("botStatus"),"None");
	GUI_NewNumeric(mc_global.window.name,mc_getstring("pulseTime"),"gPulseTime",mc_getstring("settings"),"10","2000");	
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
	
	gBotRunning = "0"
	gPulseTime = Settings.GW2Minion.gPulseTime
	
	
	
	
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
				d(mc_global.BotModes[gBotMode]:Tick())
			end
		end
	end
	
	-- Mesher OnUpdate
	mm.OnUpdate( tickcount )
	
	-- SkillManager OnUpdate
	mc_skillmanager.OnUpdate( tickcount )
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
		if (k == "gEnableLog" )			
		then
			Settings.GW2Minion[tostring(k)] = v
		
		elseif ( k == "gBotRunning" ) then
			mc_global.togglebot(v)			
		end
	end
	GUI_RefreshWindow(mc_global.window.name)
end

function mc_global.togglebot(arg)
	if arg == "0" then	
		mc_global.running = false
		gBotRunning = "0"
		Player:StopMovement()
	else
		mc_global.running = true
		gBotRunning = "1"
	end
end


function mc_global.UpdateGlobals()
	mc_global.AttackRange = mc_skillmanager.GetAttackRange()
	

end

-- Just some test functions for the BT

function mc_global.PickNewTarget()	
	local TList = ( CharacterList( "attackable,alive,noCritter,nearest,los" ) )
	if ( TableSize( TList ) > 0 ) then
		local id, E  = next( TList )
		if ( id ~= nil and id ~= 0 and E ~= nil ) then
			d("New Target: "..tostring(E.name).." "..tostring(id))
			return Player:SetTarget(id)			
		end		
	end
	return false
end

function mc_global.Attack()
	d("ATTACK")
	return false
end	
function mc_global.Waiting()
	d("Wait")
	return false
end	

function mc_global.Waitover()
	d("Wait is overrr")
	return false
end	

function mc_global.Something()
	d("Doing Something")
	return true
end	


RegisterEventHandler("Module.Initalize",mc_global.moduleinit)
RegisterEventHandler("Gameloop.Update",mc_global.onupdate)
RegisterEventHandler("GUI.Update",mc_global.guivarupdate)
