gw2_radar = {}
gw2_radar.open = false
gw2_radar.unfolded = true
gw2_radar.overlayopen = true
gw2_radar.overlaywindow = {}
gw2_radar.ishovered = false

if ( Settings.GW2Minion.Radar2D_Enabled == nil) then Settings.GW2Minion.Radar2D_Enabled = HackManager.g2dRadar end
if ( Settings.GW2Minion.Radar3D_Enabled == nil) then Settings.GW2Minion.Radar3D_Enabled = HackManager.g3dRadar end
if ( Settings.GW2Minion.Radar2DFullscreen_Enabled == nil) then Settings.GW2Minion.Radar2DFullscreen_Enabled = HackManager.g2dRadarFullScreen end
if ( Settings.GW2Minion.Radar_ShowPlayers == nil) then Settings.GW2Minion.Radar_ShowPlayers = HackManager.gRadarShowPlayers end
if ( Settings.GW2Minion.Radar_ShowNPCs == nil) then Settings.GW2Minion.Radar_ShowNPCs = HackManager.gRadarShowNPCs end
if ( Settings.GW2Minion.Radar_ShowEnemies == nil) then Settings.GW2Minion.Radar_ShowEnemies = HackManager.gRadarShowOnlyEnemies end
if ( Settings.GW2Minion.Radar_ShowNodes == nil) then Settings.GW2Minion.Radar_ShowNodes = HackManager.gRadarShowNode end
if ( Settings.GW2Minion.Radar_ShowOre == nil) then Settings.GW2Minion.Radar_ShowOre = HackManager.gRadarShowOre end
if ( Settings.GW2Minion.Radar_ShowPlants == nil) then Settings.GW2Minion.Radar_ShowPlants = HackManager.gRadarShowPlants end
if ( Settings.GW2Minion.Radar_ShowWood == nil) then Settings.GW2Minion.Radar_ShowWood = HackManager.gRadarShowWood end
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
	HackManager.gRadarShowOre = Settings.GW2Minion.Radar_ShowOre
	HackManager.gRadarShowPlants = Settings.GW2Minion.Radar_ShowPlants
	HackManager.gRadarShowWood = Settings.GW2Minion.Radar_ShowWood
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
			if ( Settings.GW2Minion.Radar_ShowNodes ) then
				if ( GUI:TreeNode(GetString("nodesettings")) ) then
					local k = false
					GUI:BulletText(GetString("all")) GUI:SameLine() k,c = GUI:Checkbox("##radar14", not Settings.GW2Minion.Radar_ShowOre and not Settings.GW2Minion.Radar_ShowPlants and not Settings.GW2Minion.Radar_ShowWood) GUI:SameLine()
					if ( c and k ) then 
						Settings.GW2Minion.Radar_ShowOre = false
						Settings.GW2Minion.Radar_ShowPlants = false 
						Settings.GW2Minion.Radar_ShowWood = false
						HackManager.gRadarShowOre = Settings.GW2Minion.Radar_ShowOre
						HackManager.gRadarShowPlants = Settings.GW2Minion.Radar_ShowPlants
						HackManager.gRadarShowWood = Settings.GW2Minion.Radar_ShowWood
					end
					GUI:BulletText(GetString("ore")) GUI:SameLine() Settings.GW2Minion.Radar_ShowOre,c = GUI:Checkbox("##radar12",Settings.GW2Minion.Radar_ShowOre)
					if ( c ) then HackManager.gRadarShowOre = Settings.GW2Minion.Radar_ShowOre end GUI:SameLine()
					GUI:BulletText(GetString("plants")) GUI:SameLine() Settings.GW2Minion.Radar_ShowPlants,c = GUI:Checkbox("##radar13",Settings.GW2Minion.Radar_ShowPlants)
					if ( c ) then HackManager.gRadarShowPlants = Settings.GW2Minion.Radar_ShowPlants end GUI:SameLine()
					GUI:BulletText(GetString("wood")) GUI:SameLine() Settings.GW2Minion.Radar_ShowWood,c = GUI:Checkbox("##radar15",Settings.GW2Minion.Radar_ShowWood)
					if ( c ) then HackManager.gRadarShowWood = Settings.GW2Minion.Radar_ShowWood end					
					GUI:TreePop()
				end
			end
		end
		GUI:End()
		
		
		-- Draw an invisible overlay window over the 2d radar, so we can move and zoom with the mouse
		if ( Settings.GW2Minion.Radar2D_Enabled and Settings.GW2Minion.Radar2DFullscreen_Enabled == false and GetGameState() == GW2.GAMESTATE.GAMEPLAY) then
								
			GUI:SetNextWindowSize( 300, 300, GUI.SetCond_Always)
			GUI:PushStyleVar(GUI.StyleVar_Alpha, 0.1)
			if (GUI:Begin("##YouCantSeeMe", gw2_radar.overlayopen, GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoScrollbar+GUI.WindowFlags_NoTitleBar+GUI.WindowFlags_NoResize)) then				
				--Handle dragging radar
				local wx,wy = GUI:GetWindowPos()				
				if ( table.size(gw2_radar.overlaywindow ) == 0 ) then 
					gw2_radar.overlaywindow.wx = wx
					gw2_radar.overlaywindow.wy = wy
					gw2_radar.overlaywindow.shiftx = 0
					gw2_radar.overlaywindow.shifty = 0
				end			 				 
				if ( GUI:IsMouseHoveringWindow() ) then
					gw2_radar.ishovered = true
					if (  GUI:IsMouseDragging(0) ) then -- Dragging the BTree with right mouse button
						local q,w = GUI:GetMouseDragDelta(0)
						gw2_radar.overlaywindow.shiftx = q
						gw2_radar.overlaywindow.shifty = w
					elseif (GUI:IsMouseReleased(0)) then
						gw2_radar.overlaywindow.wx = gw2_radar.overlaywindow.wx + gw2_radar.overlaywindow.shiftx 
						gw2_radar.overlaywindow.wy = gw2_radar.overlaywindow.wy + gw2_radar.overlaywindow.shifty
						gw2_radar.overlaywindow.shiftx = 0
						gw2_radar.overlaywindow.shifty = 0
					else							
						gw2_radar.overlaywindow.wx = wx
						gw2_radar.overlaywindow.wy = wy
					end
				else
					gw2_radar.ishovered = false
				end
				GUI:SetWindowPos(gw2_radar.overlaywindow.wx+gw2_radar.overlaywindow.shiftx, gw2_radar.overlaywindow.wy+gw2_radar.overlaywindow.shifty, GUI.SetCond_Always)				
				Settings.GW2Minion.Radar_PosX = gw2_radar.overlaywindow.wx+gw2_radar.overlaywindow.shiftx
				Settings.GW2Minion.Radar_PosY = gw2_radar.overlaywindow.wy+gw2_radar.overlaywindow.shifty
				HackManager.gRadarX = Settings.GW2Minion.Radar_PosX
				HackManager.gRadarY = Settings.GW2Minion.Radar_PosY
				
			end
			GUI:End()
			GUI:PopStyleVar()
		end
	end
end
RegisterEventHandler("Gameloop.Draw", gw2_radar.DrawCall)

function gw2_radar.ToggleWindow()
	gw2_radar.open = not gw2_radar.open
end
RegisterEventHandler("Radar.toggle", gw2_radar.ToggleWindow)

function gw2_radar.InputHandler(event, message, wParam, lParam)
	local message = tonumber(message)
	local lParam = tonumber(lParam)
	if ( message == ml_input_mgr.messagekeys["WM_MOUSEWHEEL"] ) then
	-- zooming the Radar
		if ( gw2_radar.ishovered and lParam and type(lParam) == "number" ) then
			if ( lParam > 0 ) then
				Settings.GW2Minion.Radar_Zoom = Settings.GW2Minion.Radar_Zoom + 1.0
			else
				Settings.GW2Minion.Radar_Zoom = Settings.GW2Minion.Radar_Zoom - 1.0
			end
			if ( Settings.GW2Minion.Radar_Zoom < 1.0 ) then Settings.GW2Minion.Radar_Zoom = 1.0 end
			if ( Settings.GW2Minion.Radar_Zoom > 50.0 ) then Settings.GW2Minion.Radar_Zoom = 50.0 end
			HackManager.gRadarZoom = Settings.GW2Minion.Radar_Zoom
		end		
	end
end
RegisterEventHandler("Gameloop.Input", gw2_radar.InputHandler)