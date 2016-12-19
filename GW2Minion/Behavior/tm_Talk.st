local tbl = 
{
	class = "SubTree",
	nodes = 
	{
		
		{
			class = "PrioritySelector",
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
						monitorcode = "",
						runcode = "context.talksteps_blacklist = context.talksteps_blacklist or {}\n\nif(not table.valid(context.talksteps) or not table.valid(context.talkagent)) then\n\t\t\t\tcontext.talktarget = nil\n\t\t\t\tcontext.talkagent = nil\nend\n\nif(Player.castinfo.skillid ~= 0) then\n\t\td(\"[Talk]: Channeling?\")\n\t\tself:running()\n\t\treturn\nend\n\nif(table.size(context.talksteps_blacklist) >= table.size(context.talksteps)) then\n\t\t\t\tcontext.talktarget = nil\n\t\t\t\tcontext.talkagent = nil\nend\n\nself:fail()",
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
								runcode = "context.talkagent_blacklist = context.talkagent_blacklist or {}\nif(table.valid(context.talkagent) and context.talkagent.contentid and context.talkagent.contentid > 0) then\n\t\tlocal TList = nil\n\t\tif(context.talkagent.character) then\n\t\t\t\tTList = CharacterList(\"onmesh,interactable,maxpathdistance=4000,contentid=\"..context.talkagent.contentid)\n\t\telse\n\t\t\t\tTList = GadgetList(\"onmesh,interactable,maxpathdistance=4000,contentid=\"..context.talkagent.contentid)\n\t\tend\n\t\t\n\t\tif(table.valid(TList)) then\n\t\t\t\tlocal nearest = nil\n\t\t\t\tfor _,target in pairs(TList) do\n\t\t\t\t\t\tif(not context.talkagent_blacklist[target.id]) then\n\t\t\t\t\t\t\t\tif(nearest == nil or nearest.distance > target.distance) then\n\t\t\t\t\t\t\t\t\t\tnearest = target\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\tend\n\t\t\t\tend\n\n\t\t\t\tif(table.valid(nearest)) then\n\t\t\t\t\t\tcontext.talktarget = nearest.id\n\t\t\t\t\t\tself:success()\n\t\t\t\t\t\treturn\n\t\t\t\tend\n\t\tend\nend\ncontext.talktarget = nil\nself:fail()\n",
								startcode = "",
							},
						},
						
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
								runcode = "context.talksteps_blacklist = context.talksteps_blacklist or {}\nif(context.talktarget) then\n\t\tlocal talktarget = CharacterList:Get(context.talktarget) or GadgetList:Get(context.talktarget)\n\t\tif(table.valid(talktarget) and talktarget.interactable) then\n\t\t\t\tif(talktarget.distance > 150 or not talktarget.isininteractrange) then\n\t\t\t\t\t\tcontext.moveto_position = talktarget.pos\n\t\t\t\t\t\tself:success()\n\t\t\t\t\t\treturn\n\t\t\t\tend\n\n\t\t\t\tPlayer:StopMovement()\n\n\t\t\t\tif(talktarget.selectable) then\n\t\t\t\t\t\tlocal pTarget = Player:GetTarget()\n\t\t\t\t\t\tif(pTarget == nil or pTarget.id ~= talktarget.id) then\n\t\t\t\t\t\t\t\tPlayer:SetTarget(talktarget.id)\n\t\t\t\t\t\tend\n\t\t\t\tend\n\t\t\t\t\n\t\t\t\tPlayer:SetFacing(talktarget.pos.x,talktarget.pos.y,talktarget.pos.z)\n\t\t\t\t\n\t\t\t\tlocal dialogOpen = Player:IsConversationOpen()\n\t\t\t\tif(not dialogOpen or talktarget.dead) then\n\t\t\t\t\t\tPlayer:Interact(talktarget.id)\n\t\t\t\t\t\tml_global_information.Wait(750,1450)\n\t\t\t\t\t\tself:running()\n\t\t\t\t\t\treturn\n\t\t\t\tend\n\t\t\t\t\n\t\t\t\tif(dialogOpen) then\n\t\t\t\t\t\tfor i,step in ipairs(context.talksteps) do\n\t\t\t\t\t\t\t\tif(not context.talksteps_blacklist[i]) then\n\t\t\t\t\t\t\t\t\t\tif(context.talktype == \"Index\") then\n\t\t\t\t\t\t\t\t\t\t\t\tPlayer:SelectConversationOptionByIndex(step)\n\t\t\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\t\t\t\tPlayer:SelectConversationOption(step)\n\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\t\t\tml_global_information.Wait(750,1600)\n\t\t\t\t\t\t\t\t\t\tcontext.talksteps_blacklist[i] = true\n\t\t\t\t\t\t\t\t\t\tself:running()\n\t\t\t\t\t\t\t\t\t\treturn\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\tend\n\t\t\t\tend\n\t\tend\n\t\tcontext.talkagent_blacklist[context.talktarget] = true\nend\ncontext.talktarget = nil\ncontext.talksteps_blacklist = nil\nself:fail()",
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
				monitorcode = "",
			},
		},
	},
	settings = 
	{
	},
	variables = 
	{
		filename = "tm_Talk.st",
		finishcode = "",
		info = "Talk",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "context.talktype = self.settings.talktype\ncontext.talksteps = self.settings.talksteps\ncontext.talkagent = self.settings.talkagent",
		subtreeuicode = "self.settings.talktype = self.settings.talktype or \"Index\"\nself.settings.talksteps = self.settings.talksteps or {}\nself.settings.talkagent = self.settings.talkagent or {contentid = 0; name = \"\"; character = false; gadget = false;}\n\nlocal talktypes = {\"Index\", \"Type\"}\nlocal selectedtype = 1\nfor i,type in pairs(talktypes) do\n\t\tif(self.settings.talktype == type) then\n\t\t\t\tselectedtype = i\n\t\t\t\tbreak\n\t\tend\nend\n\nself.settings.talkagent.contentid = GUI:InputInt(\"Content ID##tmtalk\", self.settings.talkagent.contentid)\n\nif(GUI:Button(\"Update target##tmtalk\")) then\n\t\tlocal target = Player:GetTarget()\n\t\tif(table.valid(target) and target.interactable and (target.ischaracter or target.isgadget)) then\n\t\t\t\tself.settings.talkagent = {contentid = target.contentid; name = target.name; character = target.ischaracter; gadget = target.isgadget}\n\t\telse\n\t\t\t\td(\"No valid interactable target selected.\")\n\t\tend\nend\n\nlocal index, changed = GUI:Combo(\"Talk type##tmtalk\", selectedtype, talktypes)\nif(changed) then\n\t\tself.settings.talktype = talktypes[index]\nend\n\nif(self.settings.talktype == \"Index\") then\n\t\tGUI:Text(\"Talk indexes:\")\nelse\n\t\tGUI:Text(\"Talk types:\")\nend\n\nfor i,step in ipairs(self.settings.talksteps) do\n\t\tself.settings.talksteps[i] = GUI:InputInt(\"##tmtalk\"..i, step)\n\t\tGUI:SameLine()\n\t\tif(GUI:Button(\"Delete step##tmtalk\"..i)) then\n\t\t\t\ttable.remove(self.settings.talksteps, i)\n\t\tend\nend\n\nif(GUI:Button(\"Add talk step\")) then\n\t\ttable.insert(self.settings.talksteps, 0)\nend \n",
	},
}



return tbl