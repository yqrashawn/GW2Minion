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
						info = "",
						monitorcode = "",
						runcode = "if(table.valid(context.emotes)) then\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
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
						monitorcode = "",
						runcode = "context.current_emote = nil\ncontext.target = nil\nfor _,emote in ipairs(context.emotes) do\n\t\tif(emote.useat == \"Self\") then\n\t\t\t\tif((emote.useonce and not emote.used) or (not emote.useonce and emote.used)) then\n\t\t\t\t\t\tcontext.current_emote = emote\n\t\t\t\t\t\tbreak\n\t\t\t\tend\n\t\telseif(emote.useat == \"Target\" and emote.target > 0) then\n\t\t\tlocal targets = gw2_common_functions.GetAllTargets(\"maxpathdistance=9999999,selectable,onmesh,contentid=\"..emote.target)\n\n\t\t\tif(table.valid(targets)) then\n\t\t\t\t\ttable.sort(targets, function(a,b) return a.pathdistance < b.pathdistance end)\n\n\t\t\t\t\tfor _,target in ipairs(targets) do\n\t\t\t\t\t\t\tif(emote.oncepertarget == false or not context.exclude[target.id]) then\n\t\t\t\t\t\t\t\t\tcontext.target = target.id\n\t\t\t\t\t\t\t\t\tbreak;\n\t\t\t\t\t\t\tend\n\t\t\t\t\tend\n\t\t\t\t\tif(context.target) then\n\t\t\t\t\t\t\tcontext.current_emote = emote\n\t\t\t\t\t\t\tbreak\n\t\t\t\t\tend\n\t\t\tend\n\t\tend\nend\n\nif(table.valid(context.current_emote)) then\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
						startcode = "",
					},
				},
				
				{
					class = "PrioritySelector",
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
										info = "",
										monitorcode = "",
										runcode = "if(context.current_emote.useat == \"Self\") then\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
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
										monitorcode = "",
										runcode = "SendChatMsg(GW2.CHATCHANNEL.Say, [[/]]..context.current_emote.index)\ncontext.current_emote.lastused = ml_global_information.Now\ncontext.current_emote.used = true\nself:success()",
										startcode = "",
									},
								},
								
								{
									class = "Wait",
									nodes = 
									{
									},
									settings = 
									{
										duration = 5000,
									},
									variables = 
									{
										monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) if ( self.starttime ) then\tif ( self:getState() == 'success' ) then GUI:Text('Passed Time: '..tostring(round(self.settings.duration/1000))..' s') else GUI:Text('Passed Time: '..tostring(round(GetTickCount() - self.starttime,2 ))..' s') end else GUI:Text('Passed Time: 0 ms') end",
									},
								},
							},
							settings = 
							{
							},
							variables = 
							{
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.actualTask or 'None'))",
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
										monitorcode = "",
										runcode = "if(context.current_emote.useat == \"Target\" and context.target) then\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
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
												monitorcode = "",
												runcode = "if(context.target) then\n\t\tlocal target = CharacterList:Get(context.target) or GadgetList(context.target)\n\t\tif(table.valid(target)) then\n\t\t\t\tcontext.moveto_position = target.pos\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\nend\nself:fail()",
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
												stoppingdistance = 200,
												stoppingidstancemaxrange = 300,
												usewaypoints = false,
											},
											variables = 
											{
												filename = "MoveTo.st",
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
												monitorcode = "",
												runcode = "Player:StopMovement()\nself:success()",
												startcode = "",
											},
										},
										
										{
											class = "Wait",
											nodes = 
											{
											},
											settings = 
											{
												duration = 1000,
											},
											variables = 
											{
												monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) if ( self.starttime ) then\tif ( self:getState() == 'success' ) then GUI:Text('Passed Time: '..tostring(round(self.settings.duration/1000))..' s') else GUI:Text('Passed Time: '..tostring(round(GetTickCount() - self.starttime,2 ))..' s') end else GUI:Text('Passed Time: 0 ms') end",
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
												monitorcode = "",
												runcode = "local target = CharacterList:Get(context.target) or GadgetList(context.target)\nif(table.valid(target)) then\n\t\tPlayer:SetTarget(target.id)\n\t\tcontext.exclude[target.id] = true\n\n\t\tSendChatMsg(GW2.CHATCHANNEL.Say, [[/]]..context.current_emote.index..[[ @]])\n\t\tcontext.current_emote.lastused = ml_global_information.Now\n\t\tcontext.current_emote.used = true\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
												startcode = "",
											},
										},
										
										{
											class = "Wait",
											nodes = 
											{
											},
											settings = 
											{
												duration = 5000,
											},
											variables = 
											{
												monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) if ( self.starttime ) then\tif ( self:getState() == 'success' ) then GUI:Text('Passed Time: '..tostring(round(self.settings.duration/1000))..' s') else GUI:Text('Passed Time: '..tostring(round(GetTickCount() - self.starttime,2 ))..' s') end else GUI:Text('Passed Time: 0 ms') end",
											},
										},
									},
									settings = 
									{
									},
									variables = 
									{
										monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.actualTask or 'None'))",
									},
								},
							},
							settings = 
							{
							},
							variables = 
							{
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
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.actualTask or 'None'))",
			},
		},
	},
	settings = 
	{
	},
	variables = 
	{
		filename = "tm_Emote.st",
		finishcode = "",
		info = "",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "context.emotes = context.emotes or {}\ncontext.exclude = context.exclude or {}\nif(not table.valid(context.emotes) and table.valid(self.settings.emotes)) then\n\t\tfor _,emotedetails in ipairs(self.settings.emotes) do\n\t\t\t\tlocal emote = table.shallowcopy(emotedetails)\n\t\t\t\temote.used = false\n\t\t\t\temote.lastused = 0\n\t\t\t\ttable.insert(context.emotes, emote)\n\t\tend\nend",
		subtreeuicode = "if(self.settings.emotes == nil) then self.settings.emotes = {} end\n\nself.selectedcomboindex = self.selectedcomboindex or 1\nlocal useat = {[1] = \"Self\"; [2] = \"Target\"; }\n\nlocal emotescombo = {}\nlocal emotessorted = {}\nlocal emotes = {\n\t\t[\"beckon\"] = GetString(\"Beckon\");\n\t\t[\"bow\"] = GetString(\"Bow\");\n\t\t[\"cheer\"] = GetString(\"Cheer\");\n\t\t[\"cower\"] = GetString(\"Cower\");\n\t\t[\"crossarms\"] = GetString(\"Crossarms\");\n\t\t[\"cry\"] = GetString(\"Cry\");\n\t\t[\"dance\"] = GetString(\"Dance\");\n\t\t[\"facepalm\"] = GetString(\"Facepalm\");\n\t\t[\"upset\"] = GetString(\"Upset\");\n\t\t[\"kneel\"] = GetString(\"Kneel\");\n\t\t[\"laugh\"] = GetString(\"Laugh\");\n\t\t[\"no\"] = GetString(\"No\");\n\t\t[\"point\"] = GetString(\"Point\");\n\t\t[\"ponder\"] = GetString(\"Ponder\");\n\t\t[\"sad\"] = GetString(\"Sad\");\n\t\t[\"salute\"] = GetString(\"Salute\");\n\t\t[\"shrug\"] = GetString(\"Shrug\");\n\t\t[\"sit\"] = GetString(\"Sit\");\n\t\t[\"sleep\"] = GetString(\"Sleep\");\n\t\t[\"surprised\"] = GetString(\"Surprised\");\n\t\t[\"talk\"] = GetString(\"Talk\");\n\t\t[\"thanks\"] = GetString(\"Thanks\");\n\t\t[\"ty\"] = GetString(\"Ty\");\n\t\t[\"thx\"] = GetString(\"Thx\");\n\t\t[\"threaten\"] = GetString(\"Threaten\");\n\t\t[\"menace\"] = GetString(\"Menace\");\n\t\t[\"wave\"] = GetString(\"Wave\");\n\t\t[\"yes\"] = GetString(\"Yes\");\n}\n\nfor k,v in pairs(emotes) do\n\t\ttable.insert(emotessorted, {realindex = k; emote = v})\nend\ntable.sort(emotessorted, function(a,b) return a.emote < b.emote end)\n\nfor i,v in pairs(emotessorted) do\n\t\temotescombo[i] = v.emote\nend\n\nself.selectedcomboindex = GUI:Combo(GetString(\"Emote\"), self.selectedcomboindex, emotescombo)\nif(GUI:Button(GetString(\"Add emote\"))) then\n\t\tlocal realindex = emotessorted[self.selectedcomboindex].realindex\n\t\ttable.insert(self.settings.emotes, {index = realindex, useat = \"Self\", useatindex = 1; target = 0; useonce = true; oncepertarget = true;})\nend\n\nGUI:Separator()\nGUI:Separator()\n\nGUI:Columns(3)\nGUI:Text(GetString(\"Emote\")) GUI:NextColumn()\nGUI:Text(GetString(\"Use at\")) GUI:NextColumn() GUI:NextColumn()\nGUI:Separator()\nif(table.valid(self.settings.emotes)) then\n\t\tfor i,emote in pairs(self.settings.emotes) do\n\t\t\t\tif(emotes[emote.index]) then\n\t\t\t\t\t\tGUI:Text(emotes[emote.index]) GUI:NextColumn()\n\t\t\t\t\t\temote.useatindex = GUI:Combo(\"##\"..i, emote.useatindex, useat)\n\t\t\t\t\t\t\n\t\t\t\t\t\tif(useat[emote.useatindex] ~= emote.useat) then\n\t\t\t\t\t\t\t\temote.useat = useat[emote.useatindex]\n\t\t\t\t\t\tend\n\n\t\t\t\t\t\tif(useat[emote.useatindex] == \"Self\") then\n\t\t\t\t\t\t\t\temote.useonce = GUI:Checkbox(GetString(\"Use once\")..\"##\"..i, emote.useonce)\n\t\t\t\t\t\t\t\temote.target = 0\n\t\t\t\t\t\telseif(useat[emote.useatindex] == \"Target\") then\n\t\t\t\t\t\t\t\temote.target = GUI:InputInt(\"##\"..i, emote.target, 0)\n\t\t\t\t\t\t\t\tif(GUI:Button(GetString(\"Update target\")..\"##\"..i)) then\n\t\t\t\t\t\t\t\t\t\tlocal target = Player:GetTarget()\n\t\t\t\t\t\t\t\t\t\tif(target and (target.ischaracter or target.isgadget)) then\n\t\t\t\t\t\t\t\t\t\t\t\temote.target = target.contentid\n\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\temote.oncepertarget = GUI:Checkbox(GetString(\"Use once per target\")..\"##\"..i, emote.oncepertarget)\n\t\t\t\t\t\tend\n\t\t\t\t\t\tGUI:NextColumn()\n\t\t\t\t\t\tif(GUI:Button(GetString(\"Delete\")..\"##\"..i)) then\n\t\t\t\t\t\t\t\ttable.remove(self.settings.emotes, i)\n\t\t\t\t\t\tend\n\t\t\t\t\t\tGUI:NextColumn()\n\t\t\t\t\t\tGUI:Separator()\n\t\t\t\tend\n\t\tend\nend\n\nGUI:Columns(1)",
	},
}



return tbl