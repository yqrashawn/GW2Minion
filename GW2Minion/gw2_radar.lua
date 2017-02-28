--[[
	MMOMINION GW2 RADAR.
	Created by: Jorith
	
	Add type to track to rader:
	
	local player_friend = {
		name		= "Player Friend", -- Name of this type.
		groupName	= "player", -- Name of the group it belongs to.
		list		= "CharacterList", -- What entity list to check for this type.
		variables	= { -- default set of variables. More can be added, but use would have to programmed in.
			radar2D	= {guiType = "Checkbox",	name = "radar 2D",	value = false,}, -- guiType specifies the kind of gui element. (only "Checkbox" and "ColorEdit4" are supported atm, let me know if you need more.)
			radar3D	= {guiType = "Checkbox",	name = "radar 3D",	value = false,},
			color	= {guiType = "ColorEdit4",	name = "Color",		value = 2516647680,},
		},
		filter = { -- The filters for this type. Each line is a seperate filter, entity only has to match one complete filter.
			{["isplayer"] = true, ["attitude"] = GW2.ATTITUDE.Friendly, ["alive"] = true,}, -- filter for "player == true" AND "attitude" == GW2.ATTITUDE.Friendly AND "alive" == true
			{["isplayer"] = true, ["attitude"] = GW2.ATTITUDE.Friendly, ["alive"] = false,}, -- filter for "player == true" AND "attitude" == GW2.ATTITUDE.Friendly AND "alive" == false
		},
	}
	gw2_radar.addType(player_friend) -- add the created entry to the radar.
	

]]
-- Create radar variable.
gw2_radar = {}

-- gw2_radar variables.
gw2_radar.mainWindow		= {name = "Radar", open = false, visible = false}
gw2_radar.ticks				= 0
gw2_radar.tickDelay			= 0 -- can be ajusted to better performance. (will make radar more "choppy") (20 == 50fps, abouts.)
gw2_radar.compassData		= {}
gw2_radar.miniMapData		= {}
gw2_radar.radar2DActive		= false
gw2_radar.radar3DActive		= false
gw2_radar.radarTypes		= {}
gw2_radar.trackEntities		= {}


function gw2_radar.Init()
	gw2_radar.updateCompassData()
	gw2_radar.updateMiniMapData()
	
	Settings.gw2_radar.radar2DActive = Settings.gw2_radar.radar2DActive or false
	gw2_radar.radar2DActive = Settings.gw2_radar.radar2DActive
	
	Settings.gw2_radar.radar3DActive = Settings.gw2_radar.radar3DActive or false
	gw2_radar.radar3DActive = Settings.gw2_radar.radar3DActive
	
	gw2_radar.loadSettings()
	
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
			end
			
			gw2_radar.drawSettings()
			
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

function gw2_radar.loadSettings()
	for name,radarType in pairs(gw2_radar.radarTypes) do
		for attribute,guiItem in pairs(radarType.variables) do
			gw2_radar.radarTypes[name].variables[attribute].value = Settings.gw2_radar[radarType.name .. "_" .. attribute] or gw2_radar.radarTypes[name].variables[attribute].value
		end
	end
end

function gw2_radar.drawSettings()
	local drawGroups = {}
	for _,radarType in pairs(gw2_radar.radarTypes) do
		if (table.valid(radarType)) then
			drawGroups[radarType.groupName] = drawGroups[radarType.groupName] or {}
			drawGroups[radarType.groupName][radarType.name] = radarType
		end
	end
	
	for groupName,group in pairs(drawGroups) do
		GUI:BeginGroup()
			if (GUI:CollapsingHeader(groupName)) then
				GUI:Indent()
					GUI:BeginGroup()
						for _,setting in pairs(group) do
							if (GUI:CollapsingHeader(setting.name)) then
								GUI:Separator()
									for attribute,guiItem in pairs(setting.variables) do
										GUI:BeginGroup()
											GUI:AlignFirstTextHeightToWidgets()
											GUI:Text(guiItem.name)
										GUI:EndGroup()
										GUI:SameLine(100)
										GUI:BeginGroup()
											gw2_radar.radarTypes[setting.name].variables[attribute].value = gw2_radar.drawGUI(setting,guiItem) -- TODO: function that creates specified gui item.
											Settings.gw2_radar[setting.name .. "_" .. attribute] = guiItem.value
										GUI:EndGroup()
									end
								GUI:Separator()
							end
						end
					GUI:EndGroup()
				GUI:Unindent()
			end
		GUI:EndGroup()
	end
end

function gw2_radar.drawGUI(group,guiItem)
	if (table.valid(guiItem)) then
		if (guiItem.guiType == "Checkbox") then
			return GUI:Checkbox("###" .. group.name .. "_" .. guiItem.name,guiItem.value)
		elseif (guiItem.guiType == "ColorEdit4") then
			local r,g,b,a,changed = GUI:ColorEdit4("###" .. group.name .. "_" .. guiItem.name,GUI:ColorConvertU32ToFloat4(guiItem.value))
			return GUI:ColorConvertFloat4ToU32(r,g,b,a),changed
		end
	end
end

function gw2_radar.draw3DRadar(ticks)
	if (gw2_radar.radar3DActive) then
		-- 3D Radar
		GUI:SetNextWindowSize(GUI:GetScreenSize())
		GUI:PushStyleColor(GUI.Col_WindowBg, 0, 0, 0, 0)
		GUI:Begin("Vision Draw Space", true, GUI.WindowFlags_NoInputs + GUI.WindowFlags_NoBringToFrontOnFocus + GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoCollapse)
		GUI:PopStyleColor(1)
		
		for _,entityList in pairs(gw2_radar.trackEntities) do
			if (table.valid(entityList)) then
				for _,entity in pairs(entityList) do
					if (table.valid(entity)) then
						local sPos = entity.sPos
						if (table.valid(sPos)) then
							-- TODO: add race, profession, speciliztion image.
							-- GUI:AddImage(gw2_radar.parent.path .. gw2_radar.parent.files.path .. [[\Asura_tango_icon_200px.png]], sPos.x + 15, sPos.y + 15, sPos.x - 15, sPos.y - 15)
							
							local text = "["..entity.name.."]["..tostring(round(entity.distance,1)).."]"
							local textSizeX, textSizeY = GUI:CalcTextSize(text)
							GUI:AddText(sPos.x - (textSizeX/2), sPos.y+textSizeY, entity.variables.color.value, text)
							
							if (table.valid(entity.health)) then
								-- GUI:AddRect(sPos.x - 70, sPos.y - 120, sPos.x + 70, sPos.y + 50, GUI:ColorConvertFloat4ToU32(1, 0, 0, 1)) -- TODO: this a good idea? rezise on distance and charsize?
								GUI:AddRect(sPos.x-50, sPos.y + 30, sPos.x + 50, sPos.y + 40, 4294967295)
								GUI:AddRectFilled(sPos.x - 48, sPos.y + 32, ((sPos.x - 48) + (96 * (entity.health.percent/100))), sPos.y + 38, GUI:ColorConvertFloat4ToU32(math.abs((-100+entity.health.percent)/100), entity.health.percent/100, 0, 1))
								GUI:AddText(sPos.x + 52, sPos.y + 28, 4294967295, tostring(entity.health.percent).."%")
							end
						end
					end
				end
			end
		end
		
		GUI:End()
		
	end
end

function gw2_radar.draw2DRadar(ticks)
	if (gw2_radar.radar2DActive) then
		-- 2D Radar / MiniMap overlay.
		GUI:SetNextWindowPos(gw2_radar.miniMapData.pos.x, gw2_radar.miniMapData.pos.y, GUI.SetCond_Always)
		GUI:SetNextWindowSize(gw2_radar.compassData.width, gw2_radar.compassData.height)
		GUI:PushStyleVar(GUI.StyleVar_WindowRounding, 0)
		GUI:PushStyleColor(GUI.Col_WindowBg, 0, 0, 0, 0)
		GUI:Begin("Vision Compass Space", true, GUI.WindowFlags_NoInputs + GUI.WindowFlags_NoBringToFrontOnFocus + GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoCollapse)
		GUI:PopStyleVar(1)
		GUI:PopStyleColor(1)
		
		for _,entityList in pairs(gw2_radar.trackEntities) do
			if (table.valid(entityList)) then
				for _,entity in pairs(entityList) do
					if (table.valid(entity)) then
						local rPos = entity.rPos
						if (table.valid(rPos)) then
							GUI:AddRectFilled(rPos.x - 5, rPos.y - 5, rPos.x + 5, rPos.y + 5, entity.variables.color.value)
							GUI:AddRect(rPos.x - 5, rPos.y - 5, rPos.x + 5, rPos.y + 5, 4294967295)
						end
					end
				end
			end
		end
		
		GUI:End()
		
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
			
			gw2_radar.updateEntities()
			gw2_radar.parseEntities()
			
		end
		
	end
end

-- Functional Code.
-- Add track Type.
function gw2_radar.addType(radarType)
	if (table.valid(radarType)) then
		gw2_radar.radarTypes[radarType.name] = radarType
	end
end

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

-- Update entities. (hehe tities...)
function gw2_radar.updateEntities() 
	for listName,trackEntities in pairs(gw2_radar.trackEntities) do
		if (string.valid(listName) and table.valid(trackEntities)) then
			for id,trackEntity in pairs(trackEntities) do
				local entity = _G[listName]:Get(id)
				if (table.valid(entity) and (trackEntity.variables.radar2D.value or trackEntity.variables.radar3D.value) and gw2_radar.matchFilterEntity(trackEntity.filter,entity)) then
					gw2_radar.trackEntities[listName][id].pos		= entity.pos
					gw2_radar.trackEntities[listName][id].rPos		= trackEntity.variables.radar2D.value and gw2_radar.miniMapData.convertPos(entity.pos) or nil
					gw2_radar.trackEntities[listName][id].sPos		= trackEntity.variables.radar3D.value and RenderManager:WorldToScreen(entity.pos) or nil
					gw2_radar.trackEntities[listName][id].health	= entity.health
					gw2_radar.trackEntities[listName][id].distance	= entity.distance
				else
					gw2_radar.trackEntities[listName][id] = nil
				end
			end
		end
	end
end

-- Parse entities.
function gw2_radar.parseEntities()
	local data = {}
	for _,radarType in pairs(gw2_radar.radarTypes) do
		if (table.valid(radarType) and (radarType.variables.radar2D.value or radarType.variables.radar3D.value)) then
			data[radarType.list] = data[radarType.list] or {}
			table.insert(data[radarType.list],radarType)
		end
	end
	
	for listName,radarTypes in pairs(data) do
		for _,radarType in pairs(radarTypes) do
			if (table.valid(radarType)) then
				local filters = radarType.filter
				if (string.valid(listName) and table.valid(filters)) then
					local list = _G[listName]("")
					if (table.valid(list)) then
						for _,entity in pairs(list) do
							if (table.valid(entity) and (table.valid(gw2_radar.trackEntities[listName]) == false or gw2_radar.trackEntities[listName][entity.id] == nil) and gw2_radar.matchFilterEntity(filters,entity)) then
								local newEntity = {
									id			= entity.id,
									name		= entity.name,
									variables	= radarType.variables,
									filter		= radarType.filter,
									pos			= entity.pos,
									rPos		= radarType.variables.radar2D.value and gw2_radar.miniMapData.convertPos(entity.pos) or nil, -- only calculate this position if needed.
									sPos		= radarType.variables.radar3D.value and RenderManager:WorldToScreen(entity.pos) or nil, -- only calculate this position if needed.
									health		= entity.health,
									distance	= entity.distance,
								}
								gw2_radar.trackEntities[listName] = gw2_radar.trackEntities[listName] or {}
								gw2_radar.trackEntities[listName][newEntity.id] = newEntity
							end
						end
					end
				end
			end
		end
	end
end

-- Match entity.
function gw2_radar.matchFilterEntity(filters,entity)
	if (table.valid(filters) and table.valid(entity)) then
		for _,filter in pairs(filters) do
			if (table.valid(filter)) then
				local entityMatchFilter = true
				for attribute,wantedValue in pairs(filter) do
					if (string.valid(attribute) and (entity[attribute] == nil or entity[attribute] ~= wantedValue)) then
						entityMatchFilter = false
						break
					end
				end
				if (entityMatchFilter) then
					return true
				end
			end
		end
	end
	return false
end


RegisterEventHandler("Module.Initalize",gw2_radar.Init)
RegisterEventHandler("Gameloop.Draw", gw2_radar.Draw)
RegisterEventHandler("Gameloop.Update",gw2_radar.Update)
RegisterEventHandler("Radar.toggle", gw2_radar.ToggleWindow)



--- ADD ENTRIES HERE:

local player_friend = {
	name		= "Player Friend",
	groupName	= "player",
	list		= "CharacterList",
	variables	= {
		radar2D	= {guiType = "Checkbox",	name = "radar 2D",	value = false,},
		radar3D	= {guiType = "Checkbox",	name = "radar 3D",	value = false,},
		color	= {guiType = "ColorEdit4",	name = "Color",		value = 2516647680,},
	},
	filter = {
		{["isplayer"] = true, ["attitude"] = GW2.ATTITUDE.Friendly,},
	},
}
gw2_radar.addType(player_friend)

local player_foe = {
	name		= "Player Foe",
	groupName	= "player",
	list		= "CharacterList",
	variables	= {
		radar2D	= {guiType = "Checkbox",	name = "radar 2D",	value = false,},
		radar3D	= {guiType = "Checkbox",	name = "radar 3D",	value = false,},
		color	= {guiType = "ColorEdit4",	name = "Color",		value = 2533294335,},
	},
	filter = {
		{["isplayer"] = true, ["attitude"] = GW2.ATTITUDE.Hostile,},
	},
}
gw2_radar.addType(player_foe)

local npc_friend = {
	name		= "Npc Friend",
	groupName	= "npc",
	list		= "CharacterList",
	variables	= {
		radar2D	= {guiType = "Checkbox",	name = "radar 2D",	value = false,},
		radar3D	= {guiType = "Checkbox",	name = "radar 3D",	value = false,},
		color	= {guiType = "ColorEdit4",	name = "Color",		value = 2533359360,},
	},
	filter = {
		{["isplayer"] = false, ["attitude"] = GW2.ATTITUDE.Friendly,},
		{["isplayer"] = false, ["attitude"] = GW2.ATTITUDE.Unattackable,},
	},
}
gw2_radar.addType(npc_friend)

local npc_foe = {
	name		= "Npc Foe",
	groupName	= "npc",
	list		= "CharacterList",
	variables	= {
		radar2D	= {guiType = "Checkbox",	name = "radar 2D",	value = false,},
		radar3D	= {guiType = "Checkbox",	name = "radar 3D",	value = false,},
		color	= {guiType = "ColorEdit4",	name = "Color",		value = 2516582655,},
	},
	filter = {
		{["isplayer"] = false, ["attitude"] = GW2.ATTITUDE.Hostile, ["alive"] = true,},
	},
}
gw2_radar.addType(npc_foe)

local npc_neutral = {
	name		= "Npc Neutral",
	groupName	= "npc",
	list		= "CharacterList",
	variables	= {
		radar2D	= {guiType = "Checkbox",	name = "radar 2D",	value = false,},
		radar3D	= {guiType = "Checkbox",	name = "radar 3D",	value = false,},
		color	= {guiType = "ColorEdit4",	name = "Color",		value = 2516647935,},
	},
	filter = {
		{["isplayer"] = false, ["attitude"] = GW2.ATTITUDE.Neutral, ["alive"] = true,},
	},
}
gw2_radar.addType(npc_neutral)

local ore_mine = {
	name		= "Ore Mine",
	groupName	= "Ore",
	list		= "GadgetList",
	variables	= {
		radar2D	= {guiType = "Checkbox",	name = "radar 2D",	value = false,},
		radar3D	= {guiType = "Checkbox",	name = "radar 3D",	value = false,},
		color	= {guiType = "ColorEdit4",	name = "Color",		value = 2519411499,},
	},
	filter = {
		{["gatherable"] = true, ["resourceType"] = GW2.RESOURCETYPE.Mine,},
	},
}
gw2_radar.addType(ore_mine)

local ore_herb = {
	name		= "Ore Herb",
	groupName	= "Ore",
	list		= "GadgetList",
	variables	= {
		radar2D	= {guiType = "Checkbox",	name = "radar 2D",	value = false,},
		radar3D	= {guiType = "Checkbox",	name = "radar 3D",	value = false,},
		color	= {guiType = "ColorEdit4",	name = "Color",		value = 2523070252,},
	},
	filter = {
		{["gatherable"] = true, ["resourceType"] = GW2.RESOURCETYPE.Herb,},
	},
}
gw2_radar.addType(ore_herb)

local ore_wood = {
	name		= "Ore Wood",
	groupName	= "Ore",
	list		= "GadgetList",
	variables	= {
		radar2D	= {guiType = "Checkbox",	name = "radar 2D",	value = false,},
		radar3D	= {guiType = "Checkbox",	name = "radar 3D",	value = false,},
		color	= {guiType = "ColorEdit4",	name = "Color",		value = 2518495047,},
	},
	filter = {
		{["gatherable"] = true, ["resourceType"] = GW2.RESOURCETYPE.Wood,},
	},
}
gw2_radar.addType(ore_wood)