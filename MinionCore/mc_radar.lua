-- Main config file of GW2Minion

mc_radar = {}
mc_radar.MainWindow = { Name = "Radar", x=250, y=200 , width=200, height=200 }
mc_radar.visible = false

function mc_radar.OnUpdate( event, tickcount )
    
end

-- Module Event Handler
function mc_radar.HandleInit()	
    GUI_SetStatusBar("Initalizing GW2 Radar...")
        
    if ( Settings.MinionCore.gRadar == nil ) then
        Settings.MinionCore.gRadar = "0"
    end		
    if ( Settings.MinionCore.g2dRadar == nil ) then
        Settings.MinionCore.g2dRadar = "0"
    end	
    if ( Settings.MinionCore.g3dRadar == nil ) then
        Settings.MinionCore.g3dRadar = "0"
    end	
    if ( Settings.MinionCore.g2dRadarFullScreen == nil ) then
        Settings.MinionCore.g2dRadarFullScreen = "0"
    end	
    if ( Settings.MinionCore.gRadarShowNode == nil ) then
        Settings.MinionCore.gRadarShowNode = "0"
    end		
    if ( Settings.MinionCore.gRadarShowPlayers == nil ) then
        Settings.MinionCore.gRadarShowPlayers = "0"
    end	
    if ( Settings.MinionCore.gRadarShowBattleNPCs == nil ) then
        Settings.MinionCore.gRadarShowBattleNPCs = "0"
    end	
    if ( Settings.MinionCore.gRadarShowEventNPCs == nil ) then
        Settings.MinionCore.gRadarShowEventNPCs = "0"
    end	
    if ( Settings.MinionCore.gRadarShowEventObjs == nil ) then
        Settings.MinionCore.gRadarShowEventObjs = "0"
    end
	if ( Settings.MinionCore.gRadarZoom == nil ) then
        Settings.MinionCore.gRadarZoom = "10"
    end	
    if ( Settings.MinionCore.gRadarX == nil ) then
        Settings.MinionCore.gRadarX = 5
    end		
    if ( Settings.MinionCore.gRadarY == nil ) then
        Settings.MinionCore.gRadarY = 5
    end	
    
    GUI_NewWindow(mc_radar.MainWindow.Name,mc_radar.MainWindow.x,mc_radar.MainWindow.y,mc_radar.MainWindow.width,mc_radar.MainWindow.height)	
    GUI_NewCheckbox(mc_radar.MainWindow.Name,mc_getstring("enableRadar"),"gRadar","Radar" );
    GUI_NewCheckbox(mc_radar.MainWindow.Name,mc_getstring("enable2DRadar"),"g2dRadar","Radar" );
    GUI_NewCheckbox(mc_radar.MainWindow.Name,mc_getstring("enable3DRadar"),"g3dRadar","Radar" );
    GUI_NewCheckbox(mc_radar.MainWindow.Name,mc_getstring("fullscreenRadar"),"g2dRadarFullScreen","Radar" );
	GUI_NewNumeric(mc_radar.MainWindow.Name,"Zoom","gRadarZoom","Radar","1","200");
    GUI_NewCheckbox(mc_radar.MainWindow.Name,mc_getstring("showNodes"),"gRadarShowNode","RadarSettings" );
    GUI_NewCheckbox(mc_radar.MainWindow.Name,mc_getstring("showPlayers"),"gRadarShowPlayers","RadarSettings" );
    GUI_NewCheckbox(mc_radar.MainWindow.Name,mc_getstring("showBattleNPCs"),"gRadarShowBattleNPCs","RadarSettings" );
        
    GUI_NewNumeric(mc_radar.MainWindow.Name,mc_getstring("xPos"),"gRadarX","RadarSettings" );
    GUI_NewNumeric(mc_radar.MainWindow.Name,mc_getstring("yPos"),"gRadarY","RadarSettings" );
    
    gRadar = Settings.MinionCore.gRadar
    g2dRadar = Settings.MinionCore.g2dRadar
    g3dRadar = Settings.MinionCore.g3dRadar
    g2dRadarFullScreen = Settings.MinionCore.g2dRadarFullScreen
	gRadarZoom = Settings.MinionCore.gRadarZoom
    gRadarShowNode = Settings.MinionCore.gRadarShowNode
    gRadarShowPlayers = Settings.MinionCore.gRadarShowPlayers
    gRadarShowBattleNPCs = Settings.MinionCore.gRadarShowBattleNPCs
    gRadarShowEventNPCs = Settings.MinionCore.gRadarShowEventNPCs
    gRadarShowEventObjs = Settings.MinionCore.gRadarShowEventObjs
    gRadarX = Settings.MinionCore.gRadarX
    gRadarY = Settings.MinionCore.gRadarY
    
    if ( gRadar == "0") then HackManager:SetRadarSettings("gRadar",false) else HackManager:SetRadarSettings("gRadar",true) end
    if ( g2dRadar == "0") then HackManager:SetRadarSettings("g2dRadar",false) else HackManager:SetRadarSettings("g2dRadar",true) end
    if ( g3dRadar == "0") then HackManager:SetRadarSettings("g3dRadar",false) else HackManager:SetRadarSettings("g3dRadar",true) end
    if ( g2dRadarFullScreen == "0") then HackManager:SetRadarSettings("g2dRadarFullScreen",false) else HackManager:SetRadarSettings("g2dRadarFullScreen",true) end
	if ( gRadarZoom == "0") then HackManager:SetRadarSettings("gRadarZoom","5") end	
    if ( gRadarShowNode == "0") then HackManager:SetRadarSettings("gRadarShowNode",false) else HackManager:SetRadarSettings("gRadarShowNode",true) end
    if ( gRadarShowPlayers == "0") then HackManager:SetRadarSettings("gRadarShowPlayers",false) else HackManager:SetRadarSettings("gRadarShowPlayers",true) end
    if ( gRadarShowBattleNPCs == "0") then HackManager:SetRadarSettings("gRadarShowBattleNPCs",false) else HackManager:SetRadarSettings("gRadarShowBattleNPCs",true) end
    if ( gRadarShowEventNPCs == "0") then HackManager:SetRadarSettings("gRadarShowEventNPCs",false) else HackManager:SetRadarSettings("gRadarShowEventNPCs",true) end
    if ( gRadarShowEventObjs == "0") then HackManager:SetRadarSettings("gRadarShowEventObjs",false) else HackManager:SetRadarSettings("gRadarShowEventObjs",true) end
    if ( tonumber(gRadarX) ~= nil) then HackManager:SetRadarSettings("gRadarX",tonumber(gRadarX)) end
    if ( tonumber(gRadarY) ~= nil) then HackManager:SetRadarSettings("gRadarY",tonumber(gRadarY)) end
    
	GUI_NewButton(mc_radar.MainWindow.Name,"Cant See Radar? Press Me","Dev.ChangeMDepth")
	
    GUI_WindowVisible(mc_radar.MainWindow.Name,false)
end

function mc_radar.GUIVarUpdate(Event, NewVals, OldVals)
    for k,v in pairs(NewVals) do
        if (k == "gRadar" or
            k == "g2dRadar" or 			
            k == "g3dRadar" or
            k == "g2dRadarFullScreen" or
            k == "gRadarShowNode" or
            k == "gRadarShowPlayers" or
            k == "gRadarShowBattleNPCs" or			
            k == "gRadarShowEventNPCs" or
            k == "gRadarShowEventObjs" or			
            k == "gRadarShowAetherytes")
        then
            Settings.MinionCore[tostring(k)] = v
            if ( v == "0") then
                HackManager:SetRadarSettings(k,false)
            else
                HackManager:SetRadarSettings(k,true)
            end
        end
        if ( k == "gRadarX" and tonumber(v) ~= nil) then
            Settings.MinionCore[tostring(k)] = v*10
            HackManager:SetRadarSettings(k,tonumber(v*10))
        end
        if ( k == "gRadarY" and tonumber(v) ~= nil) then
            Settings.MinionCore[tostring(k)] = v*10
            HackManager:SetRadarSettings(k,tonumber(v*10))
        end
		if ( k == "gRadarZoom" and tonumber(v) ~= nil) then
            Settings.MinionCore[tostring(k)] = v
            HackManager:SetRadarSettings(k,tonumber(v))
        end
		
    end
    GUI_RefreshWindow(mc_radar.MainWindow.Name)
end

function mc_radar.ToggleMenu()
    if (mc_radar.visible) then
        GUI_WindowVisible(mc_radar.MainWindow.Name,false)	
        mc_radar.visible = false
    else		 
        GUI_WindowVisible(mc_radar.MainWindow.Name,true)	
        mc_radar.visible = true
    end
end

-- Register Event Handlers
RegisterEventHandler("Module.Initalize",mc_radar.HandleInit)
RegisterEventHandler("Radar.toggle", mc_radar.ToggleMenu)
RegisterEventHandler("GUI.Update",mc_radar.GUIVarUpdate)