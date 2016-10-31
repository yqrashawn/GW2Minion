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
					settings = 
					{
						expanded = false,
						xposoffset = 0,
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
								expanded = false,
								xposoffset = 0,
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
								expanded = false,
								xposoffset = 0,
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
										expanded = false,
										xposoffset = 0,
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
									class = "BehaviorTree",
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
										xposoffset = 0,
									},
									variables = 
									{
										filename = "tm_Talk.st",
									},
								},
							},
							settings = 
							{
								expanded = true,
								xposoffset = 0,
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
						expanded = true,
						xposoffset = 0,
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
				expanded = true,
				xposoffset = 0,
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
		subtreeuicode = "",
	},
}



return tbl