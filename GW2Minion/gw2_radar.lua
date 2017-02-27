-- Create radar variable.
gw2_radar = {}

-- gw2_radar variables.
gw2_radar.mainWindow		= {name = "Radar", open = false, visible = false}
gw2_radar.ticks				= 0
gw2_radar.tickDelay			= 0
gw2_radar.compassData		= {}
gw2_radar.miniMapData		= {}
gw2_radar.radar2DActive		= false
gw2_radar.radar3DActive		= false
gw2_radar.objects			= {}


function gw2_radar.Init()
	gw2_radar.updateCompassData()
	gw2_radar.updateMiniMapData()
	
	Settings.gw2_radar.radar2DActive = Settings.gw2_radar.radar2DActive or false
	gw2_radar.radar2DActive = Settings.gw2_radar.radar2DActive
	
	Settings.gw2_radar.radar3DActive = Settings.gw2_radar.radar3DActive or false
	gw2_radar.radar3DActive = Settings.gw2_radar.radar3DActive
	
	-- Player settings.
	Settings.gw2_radar.playerFriend = Settings.gw2_radar.playerFriend or {
		active			= false,
		color			= 2516647680,
		list			= {},
	}
	gw2_radar.playerFriend = Settings.gw2_radar.playerFriend
	
	Settings.gw2_radar.playerFoe = Settings.gw2_radar.playerFoe or {
		active			= false,
		color			= 2533294335,
		list			= {},
	}
	gw2_radar.playerFoe = Settings.gw2_radar.playerFoe
	
	-- Npc settings.
	Settings.gw2_radar.npcFriend = Settings.gw2_radar.npcFriend or {
		active			= false,
		color			= 2533359360,
		list			= {},
	}
	gw2_radar.npcFriend = Settings.gw2_radar.npcFriend
	
	Settings.gw2_radar.npcNeutral = Settings.gw2_radar.npcNeutral or {
		active			= false,
		color			= 2516647935,
		list			= {},
	}
	gw2_radar.npcNeutral = Settings.gw2_radar.npcNeutral
	
	Settings.gw2_radar.npcFoe = Settings.gw2_radar.npcFoe or {
		active			= false,
		color			= 2516582655,
		list			= {},
	}
	gw2_radar.npcFoe = Settings.gw2_radar.npcFoe
	
	
	-- Ore settings.
	Settings.gw2_radar.ore = Settings.gw2_radar.ore or {
		active			= false,
		color			= 2519411499,
		list			= {},
	}
	gw2_radar.ore = Settings.gw2_radar.ore
	
	Settings.gw2_radar.plant = Settings.gw2_radar.plant or {
		active			= false,
		color			= 2523070252,
		list			= {},
	}
	gw2_radar.plant = Settings.gw2_radar.plant
	
	Settings.gw2_radar.wood = Settings.gw2_radar.wood or {
		active			= false,
		color			= 2518495047,
		list			= {},
	}
	gw2_radar.wood = Settings.gw2_radar.wood
	
end

function gw2_radar.Draw(_, ticks )
	if (ml_global_information.GameState == GW2.GAMESTATE.GAMEPLAY) then
		if (gw2_radar.mainWindow.open) then
			GUI:SetNextWindowSize(250,400,GUI.SetCond_FirstUseEver)
			gw2_radar.mainWindow.visible, gw2_radar.mainWindow.open = GUI:Begin(gw2_radar.mainWindow.name, gw2_radar.mainWindow.open)
			if (gw2_radar.mainWindow.visible) then
				GUI:BeginGroup()
					if (GUI:CollapsingHeader("settings")) then
						GUI:Indent()
							GUI:BeginGroup()
								GUI:Separator()
									GUI:BeginGroup()
										GUI:AlignFirstTextHeightToWidgets()
										GUI:Text("minimap")
										GUI:AlignFirstTextHeightToWidgets()
										GUI:Text("3dradar")
									GUI:EndGroup()
									GUI:SameLine(0)
									GUI:BeginGroup()
										gw2_radar.radar2DActive = GUI:Checkbox("###minimap", gw2_radar.radar2DActive)
										Settings.gw2_radar.radar2DActive = gw2_radar.radar2DActive
										gw2_radar.radar3DActive = GUI:Checkbox("###3dradar", gw2_radar.radar3DActive)
										Settings.gw2_radar.radar3DActive = gw2_radar.radar3DActive
									GUI:EndGroup()
								GUI:Separator()
							GUI:EndGroup()
						GUI:Unindent()
					end
				GUI:EndGroup()
				
				GUI:BeginGroup()
					if (GUI:CollapsingHeader("player")) then
						GUI:Indent()
							GUI:BeginGroup()
								GUI:Separator()
									local changed = gw2_radar.drawCharacterSettings(gw2_radar.playerFriend, "friend", "playerFriend")
									if (changed) then
										local saveData = table.deepcopy(gw2_radar.playerFriend)
										saveData.list = {}
										Settings.gw2_radar.playerFriend = saveData
									end
									local changed = gw2_radar.drawCharacterSettings(gw2_radar.playerFoe, "foe", "playerFoe")
									if (changed) then
										local saveData = table.deepcopy(gw2_radar.playerFoe)
										saveData.list = {}
										Settings.gw2_radar.playerFoe = saveData
									end
								GUI:Separator()
							GUI:EndGroup()
						GUI:Unindent()
					end
				GUI:EndGroup()
				
				GUI:BeginGroup()
					if (GUI:CollapsingHeader("npc")) then
						GUI:Indent()
							GUI:BeginGroup()
								GUI:Separator()
									local changed = gw2_radar.drawCharacterSettings(gw2_radar.npcFriend, "friend", "npcFriend")
									if (changed) then
										local saveData = table.deepcopy(gw2_radar.npcFriend)
										saveData.list = {}
										Settings.gw2_radar.npcFriend = saveData
									end
									local changed = gw2_radar.drawCharacterSettings(gw2_radar.npcNeutral, "neutral", "npcNeutral")
									if (changed) then
										local saveData = table.deepcopy(gw2_radar.npcNeutral)
										saveData.list = {}
										Settings.gw2_radar.npcNeutral = saveData
									end
									local changed = gw2_radar.drawCharacterSettings(gw2_radar.npcFoe, "foe", "npcFoe")
									if (changed) then
										local saveData = table.deepcopy(gw2_radar.npcFoe)
										saveData.list = {}
										Settings.gw2_radar.npcFoe = saveData
									end
								GUI:Separator()
							GUI:EndGroup()
						GUI:Unindent()
					end
				GUI:EndGroup()
				
				GUI:BeginGroup()
					if (GUI:CollapsingHeader("gatherable")) then
						GUI:Indent()
							GUI:BeginGroup()
								GUI:Separator()
									local changed = gw2_radar.drawGadgetSettings(gw2_radar.ore, "ore", "gadgetOre")
									if (changed) then
										local saveData = table.deepcopy(gw2_radar.ore)
										saveData.list = {}
										Settings.gw2_radar.ore = saveData
									end
									local changed = gw2_radar.drawGadgetSettings(gw2_radar.plant, "plant", "gadgetPlant")
									if (changed) then
										local saveData = table.deepcopy(gw2_radar.plant)
										saveData.list = {}
										Settings.gw2_radar.plant = saveData
									end
									local changed = gw2_radar.drawGadgetSettings(gw2_radar.wood, "wood", "gadgetWood")
									if (changed) then
										local saveData = table.deepcopy(gw2_radar.wood)
										saveData.list = {}
										Settings.gw2_radar.wood = saveData
									end
								GUI:Separator()
							GUI:EndGroup()
						GUI:Unindent()
					end
				GUI:EndGroup()
			end
			GUI:End()
		end
		-- if (ml_global_information.GameState == GW2.GAMESTATE.GAMEPLAY) then -- waiting on map open.closed check.
			-- -- 3D radar
			gw2_radar.draw3DRadar(ticks)
			-- -- 2D radar
			gw2_radar.draw2DRadar(ticks)
		-- end
	end
end

function gw2_radar.drawCharacterSettings(settings, name, guiID)
	local activeChanged,colorChanged = false,false
	
	if (table.valid(settings) and string.valid(name)) then
		GUI:BeginGroup()
			GUI:AlignFirstTextHeightToWidgets()
			GUI:Text(name)
		GUI:EndGroup()
		GUI:SameLine(50)
		GUI:BeginGroup()
			settings.active,activeChanged = GUI:Checkbox("###" .. name .. "_" .. guiID, settings.active)
		GUI:EndGroup()
		GUI:SameLine(0)
		GUI:BeginGroup()
			local r,g,b,a
			r,g,b,a,colorChanged = GUI:ColorEdit4("###rgb_" .. guiID, GUI:ColorConvertU32ToFloat4(settings.color))
			settings.color = GUI:ColorConvertFloat4ToU32(r,g,b,a)
		GUI:EndGroup()
	end
	
	return activeChanged == true or colorChanged == true or false
end

function gw2_radar.drawGadgetSettings(settings, name, guiID)
	local activeChanged,colorChanged = false,false
	
	if (table.valid(settings) and string.valid(name)) then
		GUI:BeginGroup()
			GUI:AlignFirstTextHeightToWidgets()
			GUI:Text(name)
		GUI:EndGroup()
		GUI:SameLine(50)
		GUI:BeginGroup()
			settings.active,activeChanged = GUI:Checkbox("###" .. name .. "_" .. guiID, settings.active)
		GUI:EndGroup()
		GUI:SameLine(0)
		GUI:BeginGroup()
			local r,g,b,a
			r,g,b,a,colorChanged = GUI:ColorEdit4("###rgb_" .. guiID, GUI:ColorConvertU32ToFloat4(settings.color))
			settings.color = GUI:ColorConvertFloat4ToU32(r,g,b,a)
		GUI:EndGroup()
	end
	
	return activeChanged == true or colorChanged == true or false
end

function gw2_radar.draw3DRadar(ticks)
	if (gw2_radar.radar3DActive) then
		-- 3D Radar
		GUI:SetNextWindowSize(GUI:GetScreenSize())
		GUI:PushStyleColor(GUI.Col_WindowBg, 0, 0, 0, 0)
		GUI:Begin("Vision DrawSpace", true, GUI.WindowFlags_NoInputs + GUI.WindowFlags_NoBringToFrontOnFocus + GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoCollapse)
		GUI:PopStyleColor(1)
		
		-- Draw Player-Friend.
		gw2_radar.drawGroup3D(gw2_radar.playerFriend)
		
		-- Draw Player-Foe.
		gw2_radar.drawGroup3D(gw2_radar.playerFoe)
		
		-- Draw Npc-Friend.
		gw2_radar.drawGroup3D(gw2_radar.npcFriend)
		
		-- Draw Npc-Neutral.
		gw2_radar.drawGroup3D(gw2_radar.npcNeutral)
		
		-- Draw Npc-Foe.
		gw2_radar.drawGroup3D(gw2_radar.npcFoe)
		
		GUI:End()
		
	end
end

function gw2_radar.drawGroup3D(group)
	for _,entity in pairs(group.list) do
		local sPos = entity.sPos
		if (table.valid(sPos)) then
			-- TODO: add race, profession, speciliztion image.
			-- GUI:AddImage(gw2_radar.parent.path .. gw2_radar.parent.files.path .. [[\Asura_tango_icon_200px.png]], sPos.x + 15, sPos.y + 15, sPos.x - 15, sPos.y - 15)
			
			local text = "["..entity.name.."]["..tostring(round(entity.distance,1)).."]"
			local textSizeX, textSizeY = GUI:CalcTextSize(text)
			GUI:AddText(sPos.x - (textSizeX/2), sPos.y+textSizeY, group.color, text)
			
			if (table.valid(entity.health)) then
				-- GUI:AddRect(sPos.x - 70, sPos.y - 120, sPos.x + 70, sPos.y + 50, GUI:ColorConvertFloat4ToU32(1, 0, 0, 1)) -- TODO: this a good idea? rezise on distance and charsize?
				GUI:AddRect(sPos.x-50, sPos.y + 30, sPos.x + 50, sPos.y + 40, GUI:ColorConvertFloat4ToU32(1,1,1,1))
				GUI:AddRectFilled(sPos.x - 48, sPos.y + 32, (sPos.x + (50 * (entity.health.percent/100)) - 2), sPos.y + 38, GUI:ColorConvertFloat4ToU32(math.abs((-100+entity.health.percent)/100), entity.health.percent/100, 0, 1))
				GUI:AddText(sPos.x + 52, sPos.y + 28, GUI:ColorConvertFloat4ToU32(1,1,1,1), tostring(entity.health.percent).."%")
			end
		end
	end
end

function gw2_radar.draw2DRadar(ticks)
	if (gw2_radar.radar2DActive) then
		-- 2D Radar / MiniMap overlay.
		GUI:SetNextWindowPos(gw2_radar.miniMapData.pos.x, gw2_radar.miniMapData.pos.y, GUI.SetCond_Always)
		GUI:SetNextWindowSize(gw2_radar.compassData.width, gw2_radar.compassData.height)
		GUI:PushStyleVar(GUI.StyleVar_WindowRounding, 0)
		GUI:PushStyleColor(GUI.Col_WindowBg, 0, 0, 0, 0)
		GUI:Begin("Vision Compass Space1", true, GUI.WindowFlags_NoInputs + GUI.WindowFlags_NoBringToFrontOnFocus + GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoCollapse)
		GUI:PopStyleVar(1)
		GUI:PopStyleColor(1)
		
		-- Draw Self/Center.
		GUI:AddRectFilled(gw2_radar.miniMapData.centerPos.x - 5, gw2_radar.miniMapData.centerPos.y - 5, gw2_radar.miniMapData.centerPos.x + 5, gw2_radar.miniMapData.centerPos.y + 5, GUI:ColorConvertFloat4ToU32(math.abs((-100+Player.health.percent)/100), Player.health.percent/100, 0, 1))
		GUI:AddRect(gw2_radar.miniMapData.centerPos.x - 5, gw2_radar.miniMapData.centerPos.y - 5, gw2_radar.miniMapData.centerPos.x + 5, gw2_radar.miniMapData.centerPos.y + 5, GUI:ColorConvertFloat4ToU32(1,1,1,1))
		-- Draw Player-Friend.
		gw2_radar.drawGroup2D(gw2_radar.playerFriend)
		
		-- Draw Player-Foe.
		gw2_radar.drawGroup2D(gw2_radar.playerFoe)
		
		-- Draw Npc-Friend.
		gw2_radar.drawGroup2D(gw2_radar.npcFriend)
		
		-- Draw Npc-Neutral.
		gw2_radar.drawGroup2D(gw2_radar.npcNeutral)
		
		-- Draw Npc-Foe.
		gw2_radar.drawGroup2D(gw2_radar.npcFoe)
		
		-- Draw Gatherable-Ore.
		gw2_radar.drawGroup2D(gw2_radar.ore)
		
		-- Draw Gatherable-Plant.
		gw2_radar.drawGroup2D(gw2_radar.plant)
		
		-- Draw Gatherable-Wood.
		gw2_radar.drawGroup2D(gw2_radar.wood)
			
		GUI:End()
		
	end
end

function gw2_radar.drawGroup2D(group)
	if (group.active) then
		for _,entity in pairs(group.list) do
			local rPos = entity.rPos
			if (table.valid(rPos)) then
				GUI:AddRectFilled(rPos.x - 5, rPos.y - 5, rPos.x + 5, rPos.y + 5, group.color)
				GUI:AddRect(rPos.x - 5, rPos.y - 5, rPos.x + 5, rPos.y + 5, GUI:ColorConvertFloat4ToU32(1,1,1,1))
			end
		end
	end
end

function gw2_radar.ToggleWindow()
	gw2_radar.mainWindow.open = not gw2_radar.mainWindow.open
end

-- Update Loop
function gw2_radar.Update(_,ticks)
	if (ml_global_information.GameState == GW2.GAMESTATE.GAMEPLAY and ticks - gw2_radar.ticks > gw2_radar.tickDelay) then
		gw2_radar.ticks = ticks
		
		if (gw2_radar.radar2DActive or gw2_radar.radar3DActive) then
			gw2_radar.updateCompassData()
			gw2_radar.updateMiniMapData()
			
			gw2_radar.updateCharacterLists()
			gw2_radar.parseCharacterList()
			
			gw2_radar.updateGadgetLists()
			gw2_radar.parseGadgetList()
		end
		
	end
end

-- Functional Code.
-- Update compass data.
function gw2_radar.updateCompassData()
	gw2_radar.compassData = HackManager:GetCompassData()
end

-- Update minimap data.
function gw2_radar.updateMiniMapData()
	local screenSizeX, screenSizeY = GUI:GetScreenSize()
	gw2_radar.miniMapData.pos = {x = screenSizeX - gw2_radar.compassData.width - 15, y = gw2_radar.compassData.topposition == 0 and screenSizeY - gw2_radar.compassData.height - 75 or 0,}
	gw2_radar.miniMapData.centerPos = {x = gw2_radar.miniMapData.pos.x + (gw2_radar.compassData.width / 2), y = gw2_radar.miniMapData.pos.y + (gw2_radar.compassData.height / 2)}
	gw2_radar.miniMapData.pPos = Player.pos
	
	local currDirection = gw2_radar.compassData.rotation == 0 and math.atan2(0,1) or math.atan2(gw2_radar.compassData.lookat.x - gw2_radar.compassData.eye.x, gw2_radar.compassData.lookat.y - gw2_radar.compassData.eye.y)
	gw2_radar.miniMapData.cosTheta = math.cos(currDirection)
	gw2_radar.miniMapData.sinTheta = math.sin(currDirection)
	
end

function gw2_radar.miniMapData.convertPos(ePos)
	local rPos = {
		x = (ePos.x - gw2_radar.miniMapData.pPos.x) * (0.0415 / (gw2_radar.compassData.zoomlevel+1)),
		y = (ePos.y - gw2_radar.miniMapData.pPos.y) * (0.0415 / (gw2_radar.compassData.zoomlevel+1)),
	}
	rPos = {
		x = (gw2_radar.miniMapData.cosTheta * rPos.x - gw2_radar.miniMapData.sinTheta * rPos.y),
		y = (gw2_radar.miniMapData.sinTheta * rPos.x + gw2_radar.miniMapData.cosTheta * rPos.y) * -1,
	}
	rPos = {
		x = gw2_radar.miniMapData.centerPos.x + rPos.x,
		y = gw2_radar.miniMapData.centerPos.y + rPos.y,
	}
	return rPos
end

-- Character List Parsing.
function gw2_radar.updateCharacterLists()
	gw2_radar.updateCharacterList(gw2_radar.playerFriend)
	gw2_radar.updateCharacterList(gw2_radar.playerFoe)
	gw2_radar.updateCharacterList(gw2_radar.npcFriend)
	gw2_radar.updateCharacterList(gw2_radar.npcNeutral)
	gw2_radar.updateCharacterList(gw2_radar.npcFoe)
end

function gw2_radar.updateCharacterList(group)
	if (group.active) then
		local characterList = group.list
		for id,savedCharData in pairs(characterList) do
			local newCharData = CharacterList:Get(savedCharData.id)
			if (table.valid(newCharData)) then
				characterList[id].pos = newCharData.pos
				characterList[id].rPos = gw2_radar.radar2DActive and gw2_radar.miniMapData.convertPos(newCharData.pos) or nil
				characterList[id].sPos = gw2_radar.radar3DActive and RenderManager:WorldToScreen(newCharData.pos) or nil
				characterList[id].health = newCharData.health
				characterList[id].distance = newCharData.distance
			else
				characterList[id] = nil
			end
		end
	else
		group.list = {}
	end
end

function gw2_radar.parseCharacterList()
	local characterList = CharacterList("")
	for _,character in pairs(characterList) do
		if (character.isplayer) then
			-- Player Friend entities. (hehe tities...)
			if (gw2_radar.playerFriend.active and character.attitude == GW2.ATTITUDE.Friendly and gw2_radar.playerFriend.list[character.id] == nil) then
				gw2_radar.playerFriend.list[character.id] = gw2_radar.createCharacterEntry(character)
			-- Player Foe entities.
			elseif (gw2_radar.playerFoe.active and character.attitude == GW2.ATTITUDE.Hostile and gw2_radar.playerFoe.list[character.id] == nil) then
				gw2_radar.playerFoe.list[character.id] = gw2_radar.createCharacterEntry(character)
			end
		else
			-- Npc friend entities.
			if (gw2_radar.npcFriend.active and character.attitude == GW2.ATTITUDE.Unattackable and gw2_radar.npcFriend.list[character.id] == nil) then
				gw2_radar.npcFriend.list[character.id] = gw2_radar.createCharacterEntry(character)
			-- Npc Neutral entities.
			elseif (gw2_radar.npcNeutral.active and character.attitude == GW2.ATTITUDE.Neutral and gw2_radar.npcNeutral.list[character.id] == nil) then
				gw2_radar.npcNeutral.list[character.id] = gw2_radar.createCharacterEntry(character)
			-- Npc Foe entities.
			elseif (gw2_radar.npcFoe.active and character.attitude == GW2.ATTITUDE.Hostile and gw2_radar.npcFoe.list[character.id] == nil) then
				gw2_radar.npcFoe.list[character.id] = gw2_radar.createCharacterEntry(character)
			end
		end
	end
end

function gw2_radar.createCharacterEntry(character)
	if (table.valid(character)) then
		return {
			id = character.id,
			name = character.name,
			pos = character.pos,
			rPos = gw2_radar.radar2DActive and gw2_radar.miniMapData.convertPos(character.pos) or nil, -- only calculate this position if needed.
			sPos = gw2_radar.radar3DActive and RenderManager:WorldToScreen(character.pos) or nil, -- only calculate this position if needed.
			health = character.health,
			distance = character.distance,
			-- los = character.los,
		}
	end
end

-- Gadget List Parsing.
function gw2_radar.updateGadgetLists()
	gw2_radar.updateGadgetList(gw2_radar.ore)
	gw2_radar.updateGadgetList(gw2_radar.plant)
	gw2_radar.updateGadgetList(gw2_radar.wood)
end

function gw2_radar.updateGadgetList(group)
	if (group.active) then
		local gadgetList = group.list
		for id,savedGadgetrData in pairs(gadgetList) do
			local newGadgetData = GadgetList:Get(savedGadgetrData.id)
			if (table.valid(newGadgetData)) then
				gadgetList[id].pos = newGadgetData.pos
				gadgetList[id].rPos = gw2_radar.radar2DActive and gw2_radar.miniMapData.convertPos(newGadgetData.pos) or nil
				gadgetList[id].sPos = gw2_radar.radar3DActive and RenderManager:WorldToScreen(newGadgetData.pos) or nil
				gadgetList[id].health = newGadgetData.health
				gadgetList[id].distance = newGadgetData.distance
			else
				gadgetList[id] = nil
			end
		end
	else
		group.list = {}
	end
end

function gw2_radar.parseGadgetList()
	local gadgetList = GadgetList("")
	for _,gadget in pairs(gadgetList) do
		if (gadget.gatherable) then
			-- Gadget Ore entities.
			if (gw2_radar.ore.active and gadget.resourceType == GW2.RESOURCETYPE.Mine and gw2_radar.ore.list[gadget.id] == nil) then
				gw2_radar.ore.list[gadget.id] = gw2_radar.createGadgetEntry(gadget)
			-- Gadget Plant entities.
			elseif (gw2_radar.plant.active and gadget.resourceType == GW2.RESOURCETYPE.Herb and gw2_radar.plant.list[gadget.id] == nil) then
				gw2_radar.plant.list[gadget.id] = gw2_radar.createGadgetEntry(gadget)
			-- Gadget Wood entities.
			elseif (gw2_radar.wood.active and gadget.resourceType == GW2.RESOURCETYPE.Wood and gw2_radar.wood.list[gadget.id] == nil) then
				gw2_radar.wood.list[gadget.id] = gw2_radar.createGadgetEntry(gadget)
			end
		end
	end
end

function gw2_radar.createGadgetEntry(gadget)
	if (table.valid(gadget)) then
		return {
			id = gadget.id,
			name = gadget.name,
			pos = gadget.pos,
			rPos = gw2_radar.radar2DActive and gw2_radar.miniMapData.convertPos(gadget.pos) or nil, -- only calculate this position if needed.
			sPos = gw2_radar.radar3DActive and RenderManager:WorldToScreen(gadget.pos) or nil, -- only calculate this position if needed.
			health = gadget.health,
			distance = gadget.distance,
			-- los = gadget.los,
		}
	end
end


RegisterEventHandler("Module.Initalize",gw2_radar.Init)
RegisterEventHandler("Gameloop.Draw", gw2_radar.Draw)
RegisterEventHandler("Gameloop.Update",gw2_radar.Update)
RegisterEventHandler("Radar.toggle", gw2_radar.ToggleWindow)