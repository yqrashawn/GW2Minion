mc_global = { }
mc_global.window = { name="MinionBot", x=50, y=50, width=200, height=200 }
mc_global.path = GetStartupPath()
mc_global.now = 0
mc_global.lasttick = 0
mc_global.running = false

function mc_global.moduleinit()
	
	if ( Settings.MinionCore.gPulseTime == nil ) then
		Settings.MinionCore.gPulseTime = "150"
	end
	
	GUI_NewWindow(mc_global.window.name,mc_global.window.x,mc_global.window.y,mc_global.window.width,mc_global.window.height)
	GUI_NewButton(mc_global.window.name,mc_getstring("startStop"),"mc_global.startStop")
	GUI_NewButton(mc_global.window.name,mc_getstring("radar"),"Radar.toggle")
	RegisterEventHandler("mc_global.startStop", mc_global.eventhandler)
	GUI_NewCheckbox(mc_global.window.name,mc_getstring("botEnabled"),"gBotRunning",mc_getstring("botStatus"));
	GUI_NewNumeric(mc_global.window.name,mc_getstring("pulseTime"),"gPulseTime",mc_getstring("settings"),"10","2000");	
	GUI_NewButton(mc_global.window.name, mc_getstring("meshManager"), "ToggleMeshmgr")
	
	gBotRunning = "0"
	gPulseTime = Settings.MinionCore.gPulseTime
	
	GUI_UnFoldGroup(mc_global.window.name,mc_getstring("botStatus") );
	
	
	mc_global.ai_grind = mc_core.TreeWalker:new("MainBot",nil,    
					mc_core.PrioritySelector:new(	
							-- we have a target
							mc_core.Decorator:new( function() return Player:GetTarget() ~= 0 end, mc_global.Attack ),							
							
							-- try to get a new target					
							mc_core.Decorator:new( function() return Player:GetTarget() == 0 end, mc_global.PickNewTarget )
							-- move on to the next marker/spot
							
						)
				)
	
end

function mc_global.PickNewTarget()	
	local TList = ( CharacterList( "attackable,alive,noCritter,nearest,los,onmesh,maxdistance="..wt_global_information.MaxAggroDistanceFar ) )
	if ( TableSize( TList ) > 0 ) then
		local id, E  = next( TList )
		if ( id ~= nil and id ~= 0 and E ~= nil ) then
			d("New Target: "..tostring(E.name).." "..tostring(id))
			return Player:SetTarget(id)			
		end		
	end
	return false
end

function mc_global.hastarget()
	d("Hastarget check")
	
	return Player:GetTarget() ~= 0
end
function mc_global.Attack()
	d("ATTACK")
	return false
end	
function mc_global.Waiting()
	d("Wait")
	return true
end	

function mc_global.Waitover()
	d("Wait is overrr")
	return false
end	


function mc_global.onupdate( event, tickcount )
	
	if ( mc_global.running ) then
	
		if ( tickcount - mc_global.lasttick > tonumber(gPulseTime) ) then
			mc_global.lasttick = tickcount
		
			--d("Pulsing...")
			mc_global.ai_grind:Tick()
			 --d("ticknum:"..mc_global.bht.ticknum)
		end
	end
	
	-- Mesherupdate
	mm.OnUpdate(tickcount)
	
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
			Settings.FFXIVMINION[tostring(k)] = v
		
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
	else
		mc_global.running = true
		gBotRunning = "1"
	end
end

RegisterEventHandler("Module.Initalize",mc_global.moduleinit)
RegisterEventHandler("Gameloop.Update",mc_global.onupdate)
RegisterEventHandler("GUI.Update",mc_global.guivarupdate)
