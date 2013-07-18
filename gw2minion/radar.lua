-- Main config file of GW2Minion

wt_radar = {}
wt_radar.path = GetStartupPath()
wt_radar.Currentprofession = nil
wt_radar.Now = 0
wt_radar.MainWindow = { Name = "Radar", x=250, y=250 , width=200, height=200 }


function wt_radar.OnUpdate( event, tickcount )
	
end

-- Module Event Handler
function wt_radar.HandleInit()	
	GUI_SetStatusBar("Initalizing gw2 Radar...")
		
	if ( Settings.GW2MINION.g2DRadar == nil ) then
		Settings.GW2MINION.g2DRadar = "0"
	end		
	if ( Settings.GW2MINION.g2DZoom == nil ) then
		Settings.GW2MINION.g2DZoom = 0
	end	
	if ( Settings.GW2MINION.g2DHostile == nil ) then
		Settings.GW2MINION.g2DHostile = "0"
	end	
	if ( Settings.GW2MINION.g2DNeutral == nil ) then
		Settings.GW2MINION.g2DNeutral = "0"
	end	
	if ( Settings.GW2MINION.g2DFriendly == nil ) then
		Settings.GW2MINION.g2DFriendly = "0"
	end		
	if ( Settings.GW2MINION.g2DPlayerOnly == nil ) then
		Settings.GW2MINION.g2DPlayerOnly = "0"
	end	
	if ( Settings.GW2MINION.g3DRadar == nil ) then
		Settings.GW2MINION.g3DRadar = "0"
	end	
	if ( Settings.GW2MINION.g2DAmbi == nil ) then
		Settings.GW2MINION.g2DAmbi = "0"
	end	
	if ( Settings.GW2MINION.g3DHostile == nil ) then
		Settings.GW2MINION.g3DHostile = "0"
	end	
	if ( Settings.GW2MINION.g3DNeutral == nil ) then
		Settings.GW2MINION.g3DNeutral = "0"
	end	
	if ( Settings.GW2MINION.g3DFriendly == nil ) then
		Settings.GW2MINION.g3DFriendly = "0"
	end		
	if ( Settings.GW2MINION.g3DFriendly == nil ) then
		Settings.GW2MINION.g3DFriendly = "0"
	end		
	if ( Settings.GW2MINION.g3DPlayerOnly == nil ) then
		Settings.GW2MINION.g3DPlayerOnly = "0"
	end	
	
	GUI_NewWindow(wt_radar.MainWindow.Name,wt_radar.MainWindow.x,wt_radar.MainWindow.y,wt_radar.MainWindow.width,wt_radar.MainWindow.height)	
	GUI_NewCheckbox(wt_radar.MainWindow.Name,"Enabled","g2DRadar","2D Radar" );
	GUI_NewNumeric(wt_radar.MainWindow.Name,"Zoom","g2DZoom","2D Radar" );
	GUI_NewCheckbox(wt_radar.MainWindow.Name,"Ambilight","g2DAmbi","2D Radar" );
	GUI_NewCheckbox(wt_radar.MainWindow.Name,"Show Hostile","g2DHostile","2D Radar" );
	GUI_NewCheckbox(wt_radar.MainWindow.Name,"Show Neutral","g2DNeutral","2D Radar" );
	GUI_NewCheckbox(wt_radar.MainWindow.Name,"Show Friendly","g2DFriendly","2D Radar" );
	GUI_NewCheckbox(wt_radar.MainWindow.Name,"Show only Player","g2DPlayerOnly","2D Radar" );
		
	GUI_NewCheckbox(wt_radar.MainWindow.Name,"Enabled","g3DRadar","3D Radar" );	
	GUI_NewCheckbox(wt_radar.MainWindow.Name,"Show Hostile","g3DHostile","3D Radar" );
	GUI_NewCheckbox(wt_radar.MainWindow.Name,"Show Neutral","g3DNeutral","3D Radar" );
	GUI_NewCheckbox(wt_radar.MainWindow.Name,"Show Friendly","g3DFriendly","3D Radar" );
	GUI_NewCheckbox(wt_radar.MainWindow.Name,"Show only Player","g3DPlayerOnly","3D Radar" );
	
	g2DRadar = Settings.GW2MINION.g2DRadar
	g2DZoom = Settings.GW2MINION.g2DZoom
	g2DAmbi = Settings.GW2MINION.g2DAmbi
	g2DHostile = Settings.GW2MINION.g2DHostile
	g2DNeutral = Settings.GW2MINION.g2DNeutral
	g2DFriendly = Settings.GW2MINION.g2DFriendly
	g2DPlayerOnly = Settings.GW2MINION.g2DPlayerOnly
		
	g3DRadar = Settings.GW2MINION.g3DRadar	
 	g3DHostile = Settings.GW2MINION.g3DHostile
	g3DNeutral = Settings.GW2MINION.g3DNeutral
	g3DFriendly = Settings.GW2MINION.g3DFriendly
	g3DPlayerOnly = Settings.GW2MINION.g3DPlayerOnly

	--[[if ( g2DRadar == "0") then SetRadarSettings("g2DRadar",false) else SetRadarSettings("g2DRadar",true) end
	if ( tonumber(g2DZoom) ~= nil) then SetRadarSettings("g2DZoom",tonumber(g2DZoom)) end
	if ( g2DAmbi == "0") then SetRadarSettings("g2DAmbi",false) else SetRadarSettings("g2DAmbi",true) end
	if ( g2DHostile == "0") then SetRadarSettings("g2DHostile",false) else SetRadarSettings("g2DHostile",true) end
	if ( g2DNeutral == "0") then SetRadarSettings("g2DNeutral",false) else SetRadarSettings("g2DNeutral",true) end
	if ( g2DFriendly == "0") then SetRadarSettings("g2DFriendly",false) else SetRadarSettings("g2DFriendly",true) end
	if ( g2DPlayerOnly == "0") then SetRadarSettings("g2DPlayerOnly",false) else SetRadarSettings("g2DPlayerOnly",true) end
	if ( g3DRadar == "0") then SetRadarSettings("g3DRadar",false) else SetRadarSettings("g3DRadar",true) end
	if ( g3DHostile == "0") then SetRadarSettings("g3DHostile",false) else SetRadarSettings("g3DHostile",true) end
	if ( g3DNeutral == "0") then SetRadarSettings("g3DNeutral",false) else SetRadarSettings("g3DNeutral",true) end
	if ( g3DFriendly == "0") then SetRadarSettings("g3DFriendly",false) else SetRadarSettings("g3DFriendly",true) end
	if ( g3DPlayerOnly == "0") then SetRadarSettings("g3DPlayerOnly",false) else SetRadarSettings("g3DPlayerOnly",true) end]]
	
end

function wt_radar.GUIVarUpdate(Event, NewVals, OldVals)
	d(v)
	d(tonumber(v))
	for k,v in pairs(NewVals) do
		if (k == "g2DRadar" or 			
			k == "g2DAmbi" or
			k == "g2DHostile" or
			k == "g2DNeutral" or
			k == "g2DFriendly" or
			k == "g2DPlayerOnly" or			
			k == "g3DRadar" or
			k == "g3DHostile" or
			k == "g3DNeutral" or
			k == "g3DFriendly" or
			k == "g3DPlayerOnly" )
		then
			Settings.GW2MINION[tostring(k)] = v
			if ( v == "0") then
				SetRadarSettings(k,false)
			else
				SetRadarSettings(k,true)
			end
		end
		if ( k == "g2DZoom" and tonumber(v) ~= nil) then
			SetRadarSettings(k,tonumber(v))
		end
	end
	GUI_RefreshWindow(wt_radar.MainWindow.Name)
end


-- Register Event Handlers
RegisterEventHandler("Module.Initalize",wt_radar.HandleInit)
RegisterEventHandler("Gameloop.Update",wt_radar.OnUpdate)
RegisterEventHandler("GUI.Update",wt_radar.GUIVarUpdate)
