local tbl = 
{
	class = "SubTree",
	nodes = 
	{
		
		{
			class = "Sequence",
			nodes = 
			{
				
				{
					class = "Action",
					nodes = 
					{
					},
					settings = 
					{
					},
					variables = 
					{
						finishcode = "",
						info = "Set up interact target",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(context.tm_interact_targetid) then\n\t\tif(context.tm_interact_blacklist[context.tm_interact_targetid]) then\n\t\t\t\tcontext.tm_interact_targetid = nil\n\t\t\t\tcontext.tm_interact_targetpos = nil\n\t\t\t\tPlayer:StopMovement()\n\t\t\t\tself:running()\n\t\t\t\treturn\n\t\telse\n\t\t\t\tself:success()\n\t\t\t\treturn \n\t\tend\n\t\nelseif(table.valid(context.tm_interact_targets)) then\n\t\tlocal gadgetfilter = \"\"\n\t\tlocal characterfilter = \"\"\n\t\tlocal excludefilter = \"\"\n\n\t\tfor _,target in ipairs(context.tm_interact_targets) do\n\t\t\t\tif(target.character) then\n\t\t\t\t\t\tcharacterfilter = target.contentid .. \";\" .. characterfilter\n\t\t\t\telse\n\t\t\t\t\t\tgadgetfilter =  target.contentid .. \";\" .. gadgetfilter\n\t\t\t\tend\n\t\tend\n\t\t\n\t\tif(string.valid(characterfilter)) then\n\t\t\t\tlocal CList = CharacterList(\"interactable,onmesh,contentID=\"..characterfilter)\n\t\t\t\tlocal nearest = nil\n\t\t\t\tif(table.valid(CList)) then\n\t\t\t\t\t\tfor _,target in pairs(CList) do\n\t\t\t\t\t\t\t\tif(not context.tm_interact_blacklist[target.id]) then\n\t\t\t\t\t\t\t\t\t\tif(nearest == nil or target.distance < nearest.distance) then\n\t\t\t\t\t\t\t\t\t\t\t\tnearest = target\n\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\tend\n\t\t\t\t\t\t\n\t\t\t\t\t\tif(table.valid(nearest)) then\n\t\t\t\t\t\t\t\tcontext.tm_interact_targetid = nearest.id\n\t\t\t\t\t\t\t\tcontext.tm_interact_targetpos = nearest.pos\n\t\t\t\t\t\tend\n\t\t\t\tend\n\t\tend\n\n\t\tif(not context.tm_interact_targetid and string.valid(gadgetfilter)) then\n\t\t\t\tlocal GList = GadgetList(\"interactable,onmesh,contentID=\"..gadgetfilter)\n\t\t\t\tif(table.valid(GList)) then\n\t\t\t\t\t\tlocal nearest = nil\n\t\t\t\t\t\tfor _,target in pairs(GList) do\n\t\t\t\t\t\t\t\tif(not context.tm_interact_blacklist[target.id]) then\n\t\t\t\t\t\t\t\t\t\tif(nearest == nil or target.distance < nearest.distance) then\n\t\t\t\t\t\t\t\t\t\t\t\tnearest = target\n\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\tend\n\t\t\t\t\t\t\n\t\t\t\t\t\tif(table.valid(nearest)) then\n\t\t\t\t\t\t\t\tcontext.tm_interact_targetid = nearest.id\n\t\t\t\t\t\t\t\tcontext.tm_interact_targetpos = nearest.pos\n\t\t\t\t\t\tend\n\t\t\t\tend\n\t\tend\n\t\t\n\t\tif(context.tm_interact_targetid) then\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\nend\nself:fail()",
						startcode = "",
					},
				},
				
				{
					class = "Sequence",
					nodes = 
					{
						
						{
							class = "Action",
							nodes = 
							{
							},
							settings = 
							{
							},
							variables = 
							{
								finishcode = "",
								info = "",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
								runcode = "if(context.tm_interact_targetid and not context.tm_interact_blacklist[context.tm_interact_targetid]) then\n\t\tlocal dist = math.distance3d(context.tm_interact_targetpos,ml_global_information.Player_Position)\n\t\tif(dist > 150) then\n\t\t\t\tcontext.moveto_position = context.tm_interact_targetpos\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\n\t\t\n\t\tif(context.tm_interact_interacting) then\n\t\t\t\tif(TimeSince(context.tm_interact_interacting) > 15000) then\n\t\t\t\t\t\td(\"[Interact]: This is taking too long. Blacklisting.\")\n\t\t\t\t\t\tcontext.tm_interact_blacklist[context.tm_interact_targetid] = true\n\t\t\t\t\t\tcontext.tm_interact_targetid = nil\t\t\t\t\n\t\t\t\telseif(Player.castinfo.skillid == 0) then\n\t\t\t\t\t\td(\"[Interact]: Ended\")\n\t\t\t\t\t\tcontext.tm_interact_blacklist[context.tm_interact_targetid] = true\n\t\t\t\t\t\tcontext.tm_interact_targetid = nil\n\t\t\t\telse\n\t\t\t\t\t\td(\"[Interact]: Waiting...\")\n\t\t\t\t\t\tself:running()\n\t\t\t\t\t\treturn\n\t\t\t\tend\n\t\tend\n\t\t\n\t\tif(context.tm_interact_targetid) then\n\t\t\t\tlocal target = CharacterList:Get(context.tm_interact_targetid) or GadgetList:Get(context.tm_interact_targetid)\n\t\t\t\tif(table.valid(target) and target.interactable) then\n\t\t\t\t\t\tif(not target.isininteractrange) then\n\t\t\t\t\t\t\t\tcontext.moveto_position = target.pos\n\t\t\t\t\t\t\t\tself:success()\n\t\t\t\t\t\t\t\treturn\n\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\tPlayer:StopMovement()\n\t\t\t\t\t\t\t\tlocal pTarget = Player:GetTarget()\n\t\t\t\t\t\t\t\tif(target.selectable and (pTarget == nil or pTarget.id ~= target.id)) then\n\t\t\t\t\t\t\t\t\t\tPlayer:SetTarget(target.id)\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\tPlayer:SetFacing(target.pos.x,target.pos.y,target.pos.z)\n\t\t\t\t\t\t\t\tPlayer:Interact(target.id)\n\t\t\t\t\t\t\t\tcontext.tm_interact_interacting = ml_global_information.Now\n\t\t\t\t\t\t\t\td(\"[Interact]: Interacting\")\n\t\t\t\t\t\t\t\tml_global_information.Wait(math.random(750,1300))\n\t\t\t\t\t\t\t\tself:running()\n\t\t\t\t\t\t\t\treturn\n\t\t\t\t\t\tend\n\t\t\t\telse\n\t\t\t\t\tcontext.tm_interact_blacklist[context.tm_interact_targetid] = true\n\t\t\t\tend\n\t\tend\nend\ncontext.tm_interact_interacting = nil\ncontext.moveto_position = nil\ncontext.moveto_targetid = nil\nself:fail()",
								startcode = "",
							},
						},
						
						{
							class = "SubTree",
							nodes = 
							{
							},
							settings = 
							{
								randomMovement = true,
								randomizestoppingdistance = false,
								smoothturns = true,
								stoppingdistance = 110,
								stoppingidstancemaxrange = 50,
								usewaypoints = false,
							},
							variables = 
							{
								filename = "MoveTo.st",
							},
						},
					},
					settings = 
					{
					},
					variables = 
					{
						info = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.actualTask or 'None'))",
					},
				},
			},
			settings = 
			{
			},
			variables = 
			{
				info = "",
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.actualTask or 'None'))",
			},
		},
	},
	settings = 
	{
	},
	variables = 
	{
		filename = "tm_Interact.st",
		finishcode = "context.tm_interact_interacting = nil",
		info = "",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "context.tm_interact_targets = self.settings.targets\ncontext.tm_interact_blacklist = context.tm_interact_blacklist or {}  ",
		startcode = "",
		subtreeuicode = "local targets = self.settings.targets or {}\nlocal changed = false\n\nfor i,target in ipairs(targets) do\n\t\tGUI:InputInt(\"ContentID\", target.contentid)\n\t\tif(GUI:IsItemHovered()) then\n\t\t\t\tGUI:SetTooltip(target.name or \"Unknown\")\n\t\tend\n\t\tGUI:SameLine()\n\t\tif(GUI:Button(\"Delete##tminteract\"..i)) then\n\t\t\t\ttable.remove(targets, i)\n\t\t\t\tchanged = true\n\t\tend\n\t\tGUI:Separator()\nend\n\nif(GUI:Button(\"Add target##tminteract\")) then\n\t\tlocal target = Player:GetTarget()\n\n\t\tif(table.valid(target) and target.interactable) then\n\t\t\t\ttable.insert(targets, {contentid = target.contentid, name = target.name, character = target.ischaracter, gadget = target.isgadget})\n\t\t\t\tchanged = true\n\t\telse\n\t\t\t\td(\"[Interact]: No target selected or target not interactable\")\n\t\tend\nend\nif(changed) then\n\t\tself.settings.targets = targets\nend",
	},
}



return tbl