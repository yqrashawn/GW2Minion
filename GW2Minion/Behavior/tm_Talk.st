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
						info = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "context.talksteps_blacklist = context.talksteps_blacklist or {}\n\nif(table.valid(context.talksteps) and table.valid(context.talkagent)) then\n\t\tif(table.size(context.talksteps_blacklist) < table.size(context.talksteps)) then\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\nend\nself:fail()",
						startcode = "",
						xposoffset = 0,
					},
				},
				
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
						runcode = "context.talkagent_blacklist = context.talkagent_blacklist or {}\n\nif(context.talkagent.contentid and context.talkagent.contentid > 0) then\n\t\tlocal TList = nil\n\t\tif(context.talkagent.character) then\n\t\t\t\tTList = CharacterList(\"onmesh,interactable,contentid=\"..context.talkagent.contentid)\n\t\telse\n\t\t\t\tTList = GadgetList(\"onmesh,interactable,contentid=\"..context.talkagent.contentid)\n\t\tend\n\t\t\n\t\tif(table.valid(TList)) then\n\t\t\t\tlocal nearest = nil\n\t\t\t\tfor _,target in pairs(TList) do\n\t\t\t\t\t\tif(not context.talkagent_blacklist[target.id]) then\n\t\t\t\t\t\t\t\tif(target.pathdistance > 0 and (nearest == nil or nearest.distance > target.distance)) then\n\t\t\t\t\t\t\t\t\t\tnearest = target\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\tend\n\t\t\t\tend\n\n\t\t\t\tif(table.valid(nearest)) then\n\t\t\t\t\t\tcontext.talktarget = nearest\n\t\t\t\t\t\tself:success()\n\t\t\t\t\t\treturn\n\t\t\t\tend\n\t\tend\nend\ncontext.talktarget = nil\nself:fail()\n",
						startcode = "",
						xposoffset = 0,
					},
				},
				
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
						runcode = "context.talksteps_blacklist = context.talksteps_blacklist or {}\nif(context.talktarget) then\n\t\tif(context.talktarget.distance > 150 or not context.talktarget.isininteractrange) then\n\t\t\t\tcontext.moveto_position = context.talktarget.pos\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\n\n\t\tPlayer:StopMovement()\n\n\t\tif(context.talktarget.selectable) then\n\t\t\t\tlocal pTarget = Player:GetTarget()\n\t\t\t\tif(pTarget == nil or pTarget.id ~= context.talktarget.id) then\n\t\t\t\t\t\tPlayer:SetTarget(context.talktarget.id)\n\t\t\t\tend\n\t\tend\n\t\t\n\t\tPlayer:SetFacing(context.talktarget.pos.x,context.talktarget.pos.y,context.talktarget.pos.z)\n\t\t\n\t\tlocal dialogOpen = Player:IsConversationOpen()\n\t\tif(not dialogOpen or context.talktarget.dead) then\n\t\t\t\tPlayer:Interact(context.talktarget.id)\n\t\t\t\tml_global_information.Wait(750,1450)\n\t\t\t\tself:running()\n\t\t\t\treturn\n\t\tend\n\t\t\n\t\tif(dialogOpen) then\n\t\t\t\tfor i,step in ipairs(context.talksteps) do\n\t\t\t\t\t\tif(not context.talksteps_blacklist[i]) then\n\t\t\t\t\t\t\t\tif(context.talktype == \"Index\") then\n\t\t\t\t\t\t\t\t\t\tPlayer:SelectConversationOptionByIndex(step)\n\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\t\tPlayer:SelectConversationOption(step)\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\tml_global_information.Wait(750,1600)\n\t\t\t\t\t\t\t\tcontext.talksteps_blacklist[i] = true\n\t\t\t\t\t\t\t\tself:running()\n\t\t\t\t\t\t\t\treturn\n\t\t\t\t\t\tend\n\t\t\t\tend\n\t\tend\n\t\tcontext.talkagent_blacklist[context.talktarget.id] = true\nend\ncontext.talktarget = nil\ncontext.talksteps_blacklist = nil\nself:fail()",
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
		filename = "tm_Talk.st",
		finishcode = "",
		info = "Talk",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "context.talktype = self.variables.talktype\ncontext.talksteps = self.variables.talksteps\ncontext.talkagent = self.variables.talkagent",
		startcode = "",
		subtreeuicode = "self.variables.talktype = self.variables.talktype or \"Index\"\nself.variables.talksteps = self.variables.talksteps or {}\nself.variables.talkagent = self.variables.talkagent or {contentid = 0; name = \"\"; character = false; gadget = false;}\n\nlocal talktypes = {\"Index\", \"Type\"}\nlocal selectedtype = 1\nfor i,type in pairs(talktypes) do\n\t\tif(self.variables.talktype == type) then\n\t\t\t\tselectedtype = i\n\t\t\t\tbreak\n\t\tend\nend\n\nself.variables.talkagent.contentid = GUI:InputInt(\"Content ID##tmtalk\", self.variables.talkagent.contentid)\n\nif(GUI:Button(\"Update target##tmtalk\")) then\n\t\tlocal target = Player:GetTarget()\n\t\tif(table.valid(target) and target.interactable) then\n\t\t\t\tself.variables.talkagent = {contentid = target.contentid; name = target.name; character = target.ischaracter; gadget = target.isgadget}\n\t\telse\n\t\t\t\td(\"No valid interactable target selected.\")\n\t\tend\nend\n\nlocal index, changed = GUI:Combo(\"Talk type##tmtalk\", selectedtype, talktypes)\nif(changed) then\n\t\tself.variables.talktype = talktypes[index]\nend\n\nif(self.variables.talktype == \"Index\") then\n\t\tGUI:Text(\"Talk indexes:\")\nelse\n\t\tGUI:Text(\"Talk types:\")\nend\n\nfor i,step in ipairs(self.variables.talksteps) do\n\t\tself.variables.talksteps[i] = GUI:InputInt(\"##tmtalk\"..i, step)\n\t\tGUI:SameLine()\n\t\tif(GUI:Button(\"Delete step##tmtalk\"..i)) then\n\t\t\t\ttable.remove(self.variables.talksteps, i)\n\t\tend\nend\n\nif(GUI:Button(\"Add talk step\")) then\n\t\ttable.insert(self.variables.talksteps, 0)\nend \n",
		talkagent = 
		{
			character = true,
			contentid = 0,
			gadget = false,
			name = "Milton Book",
		},
		talkcontentid = 0,
		talksteps = 
		{
		},
		talktype = "Index",
		xposoffset = 0,
	},
}



return tbl