gw2_radar = {}
gw2_radar.open = false
gw2_radar.unfolded = true
if ( Settings.GW2Minion.Radar2D_Enabled == nil) then Settings.GW2Minion.Radar2D_Enabled = HackManager.g2dRadar end
if ( Settings.GW2Minion.Radar3D_Enabled == nil) then Settings.GW2Minion.Radar3D_Enabled = HackManager.g3dRadar end
if ( Settings.GW2Minion.Radar2DFullscreen_Enabled == nil) then Settings.GW2Minion.Radar2DFullscreen_Enabled = HackManager.g2dRadarFullScreen end
if ( Settings.GW2Minion.Radar_ShowPlayers == nil) then Settings.GW2Minion.Radar_ShowPlayers = HackManager.gRadarShowPlayers end
if ( Settings.GW2Minion.Radar_ShowNPCs == nil) then Settings.GW2Minion.Radar_ShowNPCs = HackManager.gRadarShowNPCs end
if ( Settings.GW2Minion.Radar_ShowEnemies == nil) then Settings.GW2Minion.Radar_ShowEnemies = HackManager.gRadarShowOnlyEnemies end
if ( Settings.GW2Minion.Radar_ShowNodes == nil) then Settings.GW2Minion.Radar_ShowNodes = HackManager.gRadarShowNode end
if ( Settings.GW2Minion.Radar_Zoom == nil) then Settings.GW2Minion.Radar_Zoom = HackManager.gRadarZoom end
if ( Settings.GW2Minion.Radar_PosX == nil) then Settings.GW2Minion.Radar_PosX = HackManager.gRadarX end
if ( Settings.GW2Minion.Radar_PosY == nil) then Settings.GW2Minion.Radar_PosY = HackManager.gRadarY end

function gw2_radar.Init()
	HackManager.g2dRadar = Settings.GW2Minion.Radar2D_Enabled
	HackManager.g3dRadar = Settings.GW2Minion.Radar3D_Enabled
	HackManager.g2dRadarFullScreen = Settings.GW2Minion.Radar2DFullscreen_Enabled
	HackManager.gRadarShowPlayers = Settings.GW2Minion.Radar_ShowPlayers
	HackManager.gRadarShowNPCs = Settings.GW2Minion.Radar_ShowNPCs
	HackManager.gRadarShowOnlyEnemies = Settings.GW2Minion.Radar_ShowEnemies
	HackManager.gRadarShowNode = Settings.GW2Minion.Radar_ShowNodes
	HackManager.gRadarZoom = Settings.GW2Minion.Radar_Zoom
	HackManager.gRadarX = Settings.GW2Minion.Radar_PosX
	HackManager.gRadarY = Settings.GW2Minion.Radar_PosY
	
end
RegisterEventHandler("Module.Initalize",gw2_radar.Init)

function gw2_radar.DrawCall(event, ticks )
	if ( gw2_radar.open  ) then 
		GUI:SetNextWindowPosCenter(GUI.SetCond_Appearing)
		GUI:SetNextWindowSize(200,300,GUI.SetCond_FirstUseEver)
		gw2_radar.unfolded, gw2_radar.open = GUI:Begin(GetString("showradar"), gw2_radar.open)
		if ( gw2_radar.unfolded and GetGameState() == GW2.GAMESTATE.GAMEPLAY) then
			local c = false
			-- 2D Radar
			GUI:BulletText(GetString("enable2DRadar")) GUI:SameLine(150) Settings.GW2Minion.Radar2D_Enabled,c = GUI:Checkbox("##radar1",Settings.GW2Minion.Radar2D_Enabled)
			if ( c ) then HackManager.g2dRadar = Settings.GW2Minion.Radar2D_Enabled end
			if ( Settings.GW2Minion.Radar2D_Enabled ) then
				GUI:BulletText(GetString("fullscreenRadar")) GUI:SameLine(150)  Settings.GW2Minion.Radar2DFullscreen_Enabled,c = GUI:Checkbox("##radar2",Settings.GW2Minion.Radar2DFullscreen_Enabled)
				if ( c ) then HackManager.g2dRadarFullScreen = Settings.GW2Minion.Radar2DFullscreen_Enabled end
			end
			-- 3D Radar
			GUI:BulletText(GetString("enable3DRadar")) GUI:SameLine(150) Settings.GW2Minion.Radar3D_Enabled,c = GUI:Checkbox("##radar3",Settings.GW2Minion.Radar3D_Enabled)
			if ( c ) then HackManager.g3dRadar = Settings.GW2Minion.Radar3D_Enabled end
			GUI:Separator()
			
			-- Settings
			GUI:BulletText(GetString("showPlayers")) GUI:SameLine(150) Settings.GW2Minion.Radar_ShowPlayers,c = GUI:Checkbox("##radar4",Settings.GW2Minion.Radar_ShowPlayers)
			if ( c ) then HackManager.gRadarShowPlayers = Settings.GW2Minion.Radar_ShowPlayers end
			GUI:BulletText(GetString("showNPCs")) GUI:SameLine(150) Settings.GW2Minion.Radar_ShowNPCs,c = GUI:Checkbox("##radar5",Settings.GW2Minion.Radar_ShowNPCs)
			if ( c ) then HackManager.gRadarShowNPCs = Settings.GW2Minion.Radar_ShowNPCs end	
			GUI:BulletText(GetString("showOnlyEnemies")) GUI:SameLine(150) Settings.GW2Minion.Radar_ShowEnemies,c = GUI:Checkbox("##radar6",Settings.GW2Minion.Radar_ShowEnemies)
			if ( c ) then HackManager.gRadarShowOnlyEnemies = Settings.GW2Minion.Radar_ShowEnemies end	
			GUI:BulletText(GetString("showNodes")) GUI:SameLine(150) Settings.GW2Minion.Radar_ShowNodes,c = GUI:Checkbox("##radar7",Settings.GW2Minion.Radar_ShowNodes)
			if ( c ) then HackManager.gRadarShowNode = Settings.GW2Minion.Radar_ShowNodes end	
			
			GUI:BulletText(GetString("gRadarZoom")) GUI:SameLine(150) Settings.GW2Minion.Radar_Zoom,c = GUI:InputInt("##radar8", Settings.GW2Minion.Radar_Zoom, 1, 1, GUI.InputTextFlags_CharsDecimal+GUI.InputTextFlags_CharsNoBlank)
			if ( c ) then HackManager.gRadarZoom = Settings.GW2Minion.Radar_Zoom end
			GUI:BulletText(GetString("xPos")) GUI:SameLine(150) Settings.GW2Minion.Radar_PosX,c = GUI:InputInt("##radar9", Settings.GW2Minion.Radar_PosX, 10, 25, GUI.InputTextFlags_CharsDecimal+GUI.InputTextFlags_CharsNoBlank)
			if ( c ) then HackManager.gRadarX = Settings.GW2Minion.Radar_PosX end
			GUI:BulletText(GetString("yPos")) GUI:SameLine(150) Settings.GW2Minion.Radar_PosY,c = GUI:InputInt("##radar10", Settings.GW2Minion.Radar_PosY, 10, 25, GUI.InputTextFlags_CharsDecimal+GUI.InputTextFlags_CharsNoBlank)
			if ( c ) then HackManager.gRadarY = Settings.GW2Minion.Radar_PosY end
			
		
		end
		GUI:End()
	end
end
RegisterEventHandler("Gameloop.Draw", gw2_radar.DrawCall)

-- Module Event Handler
function gw2_radar.HandleInit()	
            
    if ( Settings.GW2Minion.gRadar == nil ) then
        Settings.GW2Minion.gRadar = "0"
    end		
    if ( Settings.GW2Minion.g2dRadar == nil ) then
        Settings.GW2Minion.g2dRadar = "0"
    end	
    if ( Settings.GW2Minion.g3dRadar == nil ) then
        Settings.GW2Minion.g3dRadar = "0"
    end	
    if ( Settings.GW2Minion.g2dRadarFullScreen == nil ) then
        Settings.GW2Minion.g2dRadarFullScreen = "0"
    end	
    if ( Settings.GW2Minion.gRadarShowNode == nil ) then
        Settings.GW2Minion.gRadarShowNode = "0"
    end		
    if ( Settings.GW2Minion.gRadarShowPlayers == nil ) then
        Settings.GW2Minion.gRadarShowPlayers = "0"
    end	
    if ( Settings.GW2Minion.gRadarShowBattleNPCs == nil ) then
        Settings.GW2Minion.gRadarShowBattleNPCs = "0"
    end	
    if ( Settings.GW2Minion.gRadarShowOnlyEnemies == nil ) then
        Settings.GW2Minion.gRadarShowOnlyEnemies = "0"
    end		
	if ( Settings.GW2Minion.gRadarZoom == nil ) then
        Settings.GW2Minion.gRadarZoom = "10"
    end	
    if ( Settings.GW2Minion.gRadarX == nil ) then
        Settings.GW2Minion.gRadarX = 5
    end		
    if ( Settings.GW2Minion.gRadarY == nil ) then
        Settings.GW2Minion.gRadarY = 5
    end	
    
    gRadar = Settings.GW2Minion.gRadar
    g2dRadar = Settings.GW2Minion.g2dRadar
    g3dRadar = Settings.GW2Minion.g3dRadar
    g2dRadarFullScreen = Settings.GW2Minion.g2dRadarFullScreen
	gRadarZoom = Settings.GW2Minion.gRadarZoom
    gRadarShowNode = Settings.GW2Minion.gRadarShowNode
    gRadarShowPlayers = Settings.GW2Minion.gRadarShowPlayers
    gRadarShowBattleNPCs = Settings.GW2Minion.gRadarShowBattleNPCs
	gRadarShowOnlyEnemies = Settings.GW2Minion.gRadarShowOnlyEnemies
    gRadarX = Settings.GW2Minion.gRadarX
    gRadarY = Settings.GW2Minion.gRadarY
    
	if ( HackManager ) then
		if ( gRadar == "0") then HackManager:SetRadarSettings("gRadar",false) else HackManager:SetRadarSettings("gRadar",true) end
		if ( g2dRadar == "0") then HackManager:SetRadarSettings("g2dRadar",false) else HackManager:SetRadarSettings("g2dRadar",true) end
		if ( g3dRadar == "0") then HackManager:SetRadarSettings("g3dRadar",false) else HackManager:SetRadarSettings("g3dRadar",true) end
		if ( g2dRadarFullScreen == "0") then HackManager:SetRadarSettings("g2dRadarFullScreen",false) else HackManager:SetRadarSettings("g2dRadarFullScreen",true) end
		if ( gRadarZoom == "0") then HackManager:SetRadarSettings("gRadarZoom","5") end	
		if ( gRadarShowNode == "0") then HackManager:SetRadarSettings("gRadarShowNode",false) else HackManager:SetRadarSettings("gRadarShowNode",true) end
		if ( gRadarShowPlayers == "0") then HackManager:SetRadarSettings("gRadarShowPlayers",false) else HackManager:SetRadarSettings("gRadarShowPlayers",true) end
		if ( gRadarShowBattleNPCs == "0") then HackManager:SetRadarSettings("gRadarShowBattleNPCs",false) else HackManager:SetRadarSettings("gRadarShowBattleNPCs",true) end
		if ( gRadarShowOnlyEnemies == "0") then HackManager:SetRadarSettings("gRadarShowOnlyEnemies",false) else HackManager:SetRadarSettings("gRadarShowOnlyEnemies",true) end
		
		if ( tonumber(gRadarX) ~= nil) then HackManager:SetRadarSettings("gRadarX",tonumber(gRadarX)) end
		if ( tonumber(gRadarY) ~= nil) then HackManager:SetRadarSettings("gRadarY",tonumber(gRadarY)) end
    end
	
	GUI_NewButton(gw2_radar.MainWindow.Name,"Cant See Radar? Press Me","Dev.ChangeMDepth")
	GUI_UnFoldGroup(gw2_radar.MainWindow.Name,"Radar");	
    GUI_WindowVisible(gw2_radar.MainWindow.Name,false)
end

function gw2_radar.GUIVarUpdate(Event, NewVals, OldVals)
    for k,v in pairs(NewVals) do
        if (k == "gRadar" or
            k == "g2dRadar" or 			
            k == "g3dRadar" or
            k == "g2dRadarFullScreen" or
            k == "gRadarShowNode" or
            k == "gRadarShowPlayers" or
            k == "gRadarShowBattleNPCs" or	
			k == "gRadarShowOnlyEnemies")
        then
            Settings.GW2Minion[tostring(k)] = v
            if ( v == "0") then
                HackManager:SetRadarSettings(k,false)
            else
                HackManager:SetRadarSettings(k,true)
            end
        end
        if ( k == "gRadarX" and tonumber(v) ~= nil) then
            Settings.GW2Minion[tostring(k)] = v
            HackManager:SetRadarSettings(k,tonumber(v))
        end
        if ( k == "gRadarY" and tonumber(v) ~= nil) then
            Settings.GW2Minion[tostring(k)] = v
            HackManager:SetRadarSettings(k,tonumber(v))
        end
		if ( k == "gRadarZoom" and tonumber(v) ~= nil) then
            Settings.GW2Minion[tostring(k)] = v
            HackManager:SetRadarSettings(k,tonumber(v))
        end
		
    end
    GUI_RefreshWindow(gw2_radar.MainWindow.Name)
end

