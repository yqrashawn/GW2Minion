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
						filename = "",
						finishcode = "",
						info = "",
						menucode = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(table.valid(context.deliver_items)) then\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
						startcode = "",
						subtreeuicode = "",
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
								filename = "",
								finishcode = "",
								info = "",
								menucode = "",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
								runcode = "local IList = Inventory(\"\")\nif(table.valid(IList)) then\n\t\tfor _,iitem in pairs(IList) do\n\t\t\t\tfor _,item in pairs(context.deliver_items) do\n\t\t\t\t\t\tif(item.itemid == iitem.itemid) then\n\t\t\t\t\t\t\t\tself:success()\n\t\t\t\t\t\t\t\treturn\n\t\t\t\t\t\tend\n\t\t\t\tend\n\t\tend\nend\n\nself:fail()",
								startcode = "",
								subtreeuicode = "",
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
								filename = "",
								finishcode = "",
								info = "",
								menucode = "",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
								runcode = "local mergedList = gw2_common_functions.GetAllTargets(\"onmesh,interactable\")\nlocal validTargets = {}\nif(table.valid(mergedList)) then\n\t\tfor _,target in pairs(mergedList) do\n\t\t\t\tfor _,item in pairs(context.deliver_items) do\n\t\t\t\t\t\tif(item.charactercontentid and item.charactercontentid > 0 and item.charactercontentid == target.contentid and target.pathdistance < 99999) then\n\t\t\t\t\t\t\t\ttable.insert(validTargets, {item = item, target = target})\n\t\t\t\t\t\tend\n\t\t\t\tend\n\t\tend\n\t\t\n\t\tif(table.valid(validTargets)) then\n\t\t\t\ttable.sort(validTargets, function(a,b) return a.target.pathdistance < b.target.pathdistance end)\n\t\t\t\tlocal _,nearest = next(validTargets)\n\n\t\t\t\tif(target) then\n\t\t\t\t\t\tcontext.deliver_target = nearest.target\n\t\t\t\t\t\tcontext.deliver_item = nearest.item\n\t\t\t\t\t\tself:success()\n\t\t\t\t\t\treturn\n\t\t\t\tend\n\n\t\tend\nend\nself:fail()",
								startcode = "",
								subtreeuicode = "",
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
								runcode = "if(table.valid(context.deliver_target) and table.valid(context.deliver_item)) then\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
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
												runcode = "-- Interact\nif(context.deliver_item.delivertype == 2) then\n\t\tcontext.tm_interact_targetid = context.deliver_target.id\n\t\tcontext.tm_interact_targetpos = context.deliver_target.pos\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
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
											},
											variables = 
											{
												filename = "tm_Interact.st",
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
												filename = "",
												finishcode = "",
												info = "",
												menucode = "",
												monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
												runcode = "-- Talk\nif(context.deliver_item.delivertype == 1) then\n\t\tcontext.talktarget = context.deliver_target.id\n\t\tcontext.talksteps = context.deliver_item.steps\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
												startcode = "",
												subtreeuicode = "",
											},
										},
										
										{
											class = "SubTree",
											nodes = 
											{
											},
											settings = 
											{
												talkagent = 
												{
													character = false,
													contentid = 0,
													gadget = false,
													name = "",
												},
												talksteps = 
												{
												},
												talktype = "Index",
											},
											variables = 
											{
												filename = "tm_Talk.st",
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
		filename = "tm_Deliver.st",
		finishcode = "context.deliver_items = nil",
		info = "",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "context.deliver_items = self.settings.itemlist",
		subtreeuicode = "if(self.settings.itemlist == nil) then self.settings.itemlist = {} end\n\nlocal combolist, itemlist = {}, {}\n\nlocal delivertypes = {\"Talk\", \"Interact\"}\n\nlocal IList = Inventory(\"\")\nif(table.valid(IList)) then\n\n\t\tfor _,item in pairs(IList) do\n\t\t\t\tif(not self.settings.itemlist[item.itemid]) then\n\t\t\t\t\t\ttable.insert(itemlist, {name = item.name; id = item.itemid})\n\t\t\t\tend\n\t\tend\n\n\t\ttable.sort(itemlist, function(a,b) return a.name < b.name end)\n\n\t\tfor _,item in ipairs(itemlist) do\n\t\t\t\ttable.insert(combolist, item.name)\n\t\tend\n\n\t\tlocal index,changed = GUI:Combo(\"Itemlist\", self.selectedindex or 1, combolist)\n\t\tself.selectedindex = index\n\t\tif(GUI:Button(\"Add item\")) then\n\t\t\t\tlocal item = itemlist[index]\n\t\t\t\tif(item) then\n\t\t\t\t\t\titem.delivertype = 1\n\t\t\t\t\t\titem.charactercontentid = 0\n\t\t\t\t\t\tself.settings.itemlist[item.id] = item\n\t\t\t\tend\n\t\tend\n\n\t\tGUI:NewLine()\n\t\tGUI:Text(\"Items:\")\n\t\tGUI:Columns(4, \"itemlist\", false)\n\t\tGUI:Text(\"Name\") GUI:NextColumn()\n\t\tGUI:Text(\"Deliver to\") GUI:NextColumn()\n\t\tGUI:Text(\"Type\") GUI:NextColumn() GUI:NextColumn()\n\t\t\n\t\tlocal target = Player:GetTarget()\n\n\t\tfor itemid,item in pairs(self.settings.itemlist) do\n\t\t\t\tlocal changed = false\n\n\t\t\t\tGUI:Text(item.name)\n\t\t\t\tGUI:NextColumn()\n\n\t\t\t\tlocal num, changed = GUI:InputInt(\"##CharacterContentID\"..itemid, item.charactercontentid or 0,0)\n\t\t\t\tif(changed) then\n\t\t\t\t\t\tself.settings.itemlist[itemid].charactercontentid = num\n\t\t\t\tend\n\n\t\t\t\tif(target and target.interactable and target.pathdistance < 99999 and (target.ischaracter or target.isgadget)) then\n\t\t\t\t\t\tif(GUI:Button(\"Update target##\"..itemid)) then\t\t\t\t\t\t\n\t\t\t\t\t\t\t\tself.settings.itemlist[itemid].charactercontentid = target.contentid\n\t\t\t\t\t\tend\n\t\t\t\telse\n\t\t\t\t\t\tGUI:Text(GetString(\"No interactable target selected\")) \n\t\t\t\t\t\tGUI:Text(GetString(\"No valid path to target\"))\n\t\t\t\tend\n\n\t\t\t\tGUI:NextColumn()\n\t\t\t\tnum,changed = GUI:Combo(\"##delivertype\"..itemid, item.delivertype or 1, delivertypes)\n\t\t\t\tif(changed) then\n\t\t\t\t\t\tself.settings.itemlist[itemid].delivertype = num\n\t\t\t\tend\n\t\t\t\tGUI:NextColumn()\n\n\t\t\t\tif(GUI:Button(\"Remove##\"..itemid)) then\n\t\t\t\t\t\tself.settings.itemlist[itemid] = nil\n\t\t\t\tend\n\t\t\t\tGUI:NextColumn()\n\t\tend\n\t\tGUI:Columns(1)\nend",
	},
}



return tbl