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
								runcode = "self:success()",
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
								runcode = "self:success()",
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
										runcode = "self:success()",
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
		subtreeuicode = "if(self.settings.itemlist == nil) then self.settings.itemlist = {} end\n\nlocal combolist, itemlist = {}, {}\n\nlocal delivertypes = {\"Talk\", \"Interact\"}\n\nlocal IList = Inventory(\"\")\nif(table.valid(IList)) then\n\n\t\tfor _,item in pairs(IList) do\n\t\t\t\tif(not self.settings.itemlist[item.itemid]) then\n\t\t\t\t\t\ttable.insert(itemlist, {name = item.name; id = item.itemid})\n\t\t\t\tend\n\t\tend\n\n\t\ttable.sort(itemlist, function(a,b) return a.name < b.name end)\n\n\t\tfor _,item in ipairs(itemlist) do\n\t\t\t\ttable.insert(combolist, item.name)\n\t\tend\n\n\t\tlocal index,changed = GUI:Combo(\"Itemlist\", self.selectedindex or 1, combolist)\n\t\tself.selectedindex = index\n\t\tif(GUI:Button(\"Add item\")) then\n\t\t\t\tlocal item = itemlist[index]\n\t\t\t\tif(item) then\n\t\t\t\t\t\titem.delivertype = 1\n\t\t\t\t\t\titem.charactercontentid = 0\n\t\t\t\t\t\tself.settings.itemlist[item.id] = item\n\t\t\t\tend\n\t\tend\n\n\t\tGUI:NewLine()\n\t\tGUI:Text(\"Items:\")\n\t\tGUI:Columns(4, \"itemlist\", false)\n\t\tGUI:Text(\"Name\")\n\t\tGUI:NextColumn()\n\t\tGUI:Text(\"Deliver to\")\n\t\tGUI:NextColumn()\n\t\tGUI:Text(\"Type\")\n\t\t\n\t\tfor itemid,item in pairs(self.settings.itemlist) do\n\t\t\t\tlocal changed = false\n\t\t\t\tGUI:Columns(4, \"itemlist\", false)\n\t\t\t\tGUI:Text(item.name)\n\t\t\t\tGUI:NextColumn()\n\t\t\t\tlocal num, changed = GUI:InputInt(\"##CharacterContentID\"..itemid, item.characterid or 0)\n\t\t\t\tif(changed) then\n\t\t\t\t\t\tself.settings.itemlist[itemid].charactercontentid = num\n\t\t\t\tend\n\t\t\t\tif(GUI:Button(\"Update target##\"..itemid)) then\n\t\t\t\t\t\t\tlocal target = Player:GetTarget()\n\t\t\t\t\t\t\tif(target and target.interactable and (target.ischaracter or target.isgadget)) then\n\t\t\t\t\t\t\t\t\tself.settings.itemlist[itemid].charactercontentid = num\n\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\td(\"No character selected or not interactable\")\n\t\t\t\t\t\t\tend\n\t\t\t\tend\n\t\t\t\tGUI:NextColumn()\n\t\t\t\tlocal index,changed = GUI:Combo(\"##delivertype\"..itemid, item.delivertype or 1, delivertypes)\n\t\t\t\tif(changed) then\n\t\t\t\t\t\tself.settings.itemlist[itemid] = index\n\t\t\t\tend\n\t\t\t\tGUI:NextColumn()\n\t\t\t\tif(GUI:Button(\"Remove##\"..itemid)) then\n\t\t\t\t\t\tself.settings.itemlist[itemid] = nil\n\t\t\t\tend\n\n\t\tend\n\t\tGUI:Columns(1)\nend",
	},
}



return tbl