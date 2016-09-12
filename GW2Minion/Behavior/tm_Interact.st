local tbl = 
{
	class = "BehaviorTree",
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
					variables = 
					{
						finishcode = "",
						info = "Set up interact target",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(context.tm_interact_targetid) then\n\t\tif(context.tm_interact_blacklist[context.tm_interact_targetid]) then\n\t\t\t\tcontext.tm_interact_targetid = nil\n\t\t\t\tcontext.tm_interact_targetpos = nil\n\t\t\t\tPlayer:StopMovement()\n\t\t\t\tself:running()\n\t\t\t\treturn\n\t\telse\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\n\nelseif(table.valid(context.tm_interact_targets)) then\n\t\tlocal gadgetfilter = \"\"\n\t\tlocal characterfilter = \"\"\n\t\tlocal excludefilter = \"\"\n\n\t\tfor _,target in ipairs(context.tm_interact_targets) do\n\t\t\t\tif(target.character) then\n\t\t\t\t\t\tcharacterfilter = target.contentid .. \";\" .. characterfilter\n\t\t\t\telse\n\t\t\t\t\t\tgadgetfilter =  target.contentid .. \";\" .. gadgetfilter\n\t\t\t\tend\n\t\tend\n\t\t\n\t\tif(string.valid(characterfilter)) then\n\t\t\t\tlocal CList = CharacterList(\"interactable,onmesh,contentID=\"..characterfilter)\n\t\t\t\tlocal nearest = nil\n\t\t\t\tif(table.valid(CList)) then\n\t\t\t\t\t\tfor _,target in pairs(CList) do\n\t\t\t\t\t\t\t\tif(not context.tm_interact_blacklist[target.id]) then\n\t\t\t\t\t\t\t\t\t\tif(nearest == nil or target.distance < nearest.distance) then\n\t\t\t\t\t\t\t\t\t\t\t\tnearest = target\n\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\tend\n\t\t\t\t\t\t\n\t\t\t\t\t\tif(table.valid(nearest)) then\n\t\t\t\t\t\t\t\tcontext.tm_interact_targetid = nearest.id\n\t\t\t\t\t\t\t\tcontext.tm_interact_targetpos = nearest.pos\n\t\t\t\t\t\tend\n\t\t\t\tend\n\t\tend\n\n\t\tif(not context.tm_interact_targetid and string.valid(gadgetfilter)) then\n\t\t\t\tlocal GList = GadgetList(\"interactable,onmesh,contentID=\"..gadgetfilter)\n\t\t\t\tif(table.valid(GList)) then\n\t\t\t\t\t\tlocal nearest = nil\n\t\t\t\t\t\tfor _,target in pairs(GList) do\n\t\t\t\t\t\t\t\tif(not context.tm_interact_blacklist[target.id]) then\n\t\t\t\t\t\t\t\t\t\tif(nearest == nil or target.distance < nearest.distance) then\n\t\t\t\t\t\t\t\t\t\t\t\tnearest = target\n\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\tend\n\t\t\t\t\t\t\n\t\t\t\t\t\tif(table.valid(nearest)) then\n\t\t\t\t\t\t\t\tcontext.tm_interact_targetid = nearest.id\n\t\t\t\t\t\t\t\tcontext.tm_interact_targetpos = nearest.pos\n\t\t\t\t\t\tend\n\t\t\t\tend\n\t\tend\n\t\t\n\t\tif(context.tm_interact_targetid) then\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\nend\nself:fail()",
						startcode = "",
						xposoffset = 0,
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
							variables = 
							{
								finishcode = "",
								info = "",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
								runcode = "if(context.tm_interact_targetid) then\n\t\tlocal dist = Distance3DT(context.tm_interact_targetpos,ml_global_information.Player_Position)\n\t\tif(dist > 150) then\n\t\t\t\tcontext.moveto_position = context.tm_interact_targetpos\n\t\t\t\tcontext.moveto_targetid = context.tm_interact_targetid\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\n\n\t\tlocal target = CharacterList:Get(context.tm_interact_targetid) or GadgetList:Get(context.tm_interact_targetid)\n\t\tif(table.valid(target)) then\n\t\t\t\tif(not target.isininteractrange) then\n\t\t\t\t\t\tcontext.moveto_position = target.pos\n\t\t\t\t\t\tself:success()\n\t\t\t\t\t\treturn\n\t\t\t\telse\n\t\t\t\t\t\tPlayer:StopMovement()\n\t\t\t\t\t\tlocal pTarget = Player:GetTarget()\n\t\t\t\t\t\tif(target.selectable and (pTarget == nil or pTarget.id ~= target.id)) then\n\t\t\t\t\t\t\t\tPlayer:SetTarget(target.id)\n\t\t\t\t\t\tend\n\t\t\t\t\t\tPlayer:Interact(target.id)\n\t\t\t\t\t\tml_global_information.Wait(math.random(500,1000))\n\t\t\t\t\t\tif(Player:GetCurrentlyCastedSpell() == ml_global_information.MAX_SKILLBAR_SLOTS) then\n\t\t\t\t\t\t\t\tcontext.tm_interact_blacklist[target.id] = true\t\t\t\n\t\t\t\t\t\tend\n\t\t\t\tend\n\t\tend\nend\nself:fail()",
								startcode = "",
								xposoffset = 0,
							},
						},
						
						{
							class = "BehaviorTree",
							nodes = 
							{
							},
							variables = 
							{
								expanded = true,
								filename = "MoveTo.st",
								finishcode = "",
								info = "Move to Position. \nRequired input argument: context.moveto_position\nOptional arguments:\ncontext.moveto_targetid - ID of the character / gadget we want to move to.\ncontext.moveto_targettype - \"character\" or \"gadget\" or \"event\"\n",
								menucode = "",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)\n",
								randomMovement = true,
								runcode = "-- Setting the custom subtree settings in the context, which gets passed down to childnodes\ncontext.moveto_stoppingdistance = self.variables.stoppingdistance\ncontext.moveto_randomMovement = self.variables.randomMovement\ncontext.moveto_smoothturns = self.variables.smoothturns\ncontext.moveto_usewaypoints = self.variables.usewaypoints\ncontext.moveto_follownavsystem = false",
								smoothturns = true,
								startcode = "",
								stoppingdistance = 25,
								subtreeuicode = "if ( self.variables.stoppingdistance == nil ) then self.variables.stoppingdistance = 25 end\nself.variables.stoppingdistance = GUI:InputInt(\"Stopping Distance\", self.variables.stoppingdistance, 1, GUI.InputTextFlags_CharsDecimal)\n\nif ( self.variables.randomMovement == nil ) then self.variables.randomMovement = true end\nself.variables.randomMovement = GUI:Checkbox( \"RandomMovement\", self.variables.randomMovement )\n\nif ( self.variables.smoothturns == nil ) then self.variables.smoothturns = true end\nself.variables.smoothturns = GUI:Checkbox( \"Smooth Turns\", self.variables.smoothturns )\n\nif ( self.variables.usewaypoints == nil ) then self.variables.usewaypoints = false end\nself.variables.usewaypoints = GUI:Checkbox( \"Use Waypoints\", self.variables.usewaypoints )\nif ( GUI:IsItemHovered() ) then GUI:SetTooltip( \"When enabled, MoveTo will use waypoints if they are closer to the targetposition.\" ) end",
								usewaypoints = false,
								xposoffset = 0,
							},
						},
					},
					variables = 
					{
						expanded = true,
						info = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.actualTask or 'None'))",
						xposoffset = 0,
					},
				},
			},
			variables = 
			{
				expanded = true,
				info = "",
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.actualTask or 'None'))",
				xposoffset = 0,
			},
		},
	},
	variables = 
	{
		expanded = true,
		filename = "tm_Interact.st",
		finishcode = "",
		info = "",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "context.tm_interact_targets = self.variables.targets\ncontext.tm_interact_blacklist = context.tm_interact_blacklist or {}",
		startcode = "",
		subtreeuicode = "local targets = self.variables.targets or {}\nlocal changed = false\n\nfor i,target in ipairs(targets) do\n\t\tGUI:InputInt(\"ContentID\", target.contentid)\n\t\tif(GUI:IsItemHovered()) then\n\t\t\t\tGUI:SetTooltip(target.name or \"Unknown\")\n\t\tend\n\t\tGUI:SameLine()\n\t\tif(GUI:Button(\"Delete##tminteract\"..i)) then\n\t\t\t\ttable.remove(targets, i)\n\t\t\t\tchanged = true\n\t\tend\n\t\tGUI:Separator()\nend\n\nif(GUI:Button(\"Add target##tminteract\")) then\n\t\tlocal target = Player:GetTarget()\n\n\t\tif(table.valid(target) and target.interactable) then\n\t\t\t\ttable.insert(targets, {contentid = target.contentid, name = target.name, character = target.ischaracter, gadget = target.isgadget})\n\t\t\t\tchanged = true\n\t\telse\n\t\t\t\td(\"[Interact]: No target selected or target not interactable\")\n\t\tend\nend\nif(changed) then\n\t\tself.variables.targets = targets\nend",
		targets = 
		{
		},
		xposoffset = 0,
	},
}



return tbl