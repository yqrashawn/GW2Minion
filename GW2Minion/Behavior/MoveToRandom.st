local tbl = 
{
	class = "BehaviorTree",
	nodes = 
	{
		
		{
			class = "AlwaysSucceed",
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
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
								runcode = "if(ml_global_information.Player_OnMesh) then\n\t\tif (context.movetorandom_randompoint == nil) then\n\t\t\t\tcontext.movetorandom_randompoint = gw2_common_functions.GetRandomPoint()\n\t\tend\nend\n\nif(table.valid(context.movetorandom_randompoint)) then\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
								startcode = "",
							},
						},
						
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
										monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
										runcode = "if(table.valid(context.movetorandom_randompoint) and context.moveto_stoppingdistance) then\n\t\tif(Distance3DT(context.movetorandom_randompoint,ml_global_information.Player_Position) <= context.moveto_stoppingdistance) then\n\t\t\t\tcontext.movetorandom_randompoint = nil\n\t\tend\nend\nself:fail()",
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
												runcode = "if(table.valid(context.movetorandom_randompoint)) then\n\t\tcontext.moveto_position = context.movetorandom_randompoint\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
												startcode = "",
											},
										},
										
										{
											class = "BehaviorTree",
											nodes = 
											{
											},
											settings = 
											{
												randomMovement = true,
												randomizestoppingdistance = true,
												smoothturns = true,
												stoppingdistance = 750,
												stoppingidstancemaxrange = 2000,
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
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.runningTask or 'None'))",
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
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
			},
		},
	},
	settings = 
	{
	},
	variables = 
	{
		filename = "MoveToRandom.st",
		finishcode = "",
		info = "Move to random",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)\n\nif(context) then\n\t\tif(context.movetorandom_randompoint) then\n\t\t\t\tlocal dist = Distance3DT(ml_global_information.Player_Position,context.movetorandom_randompoint)\n\t\t\t\tGUI:Text(\"Distance: \" .. tostring(round(dist,2)))\n\t\t\t\tGUI:Text(\"Stopping distance: \" .. tostring(context.moveto_stoppingdistance))\n\t\t\t\tGUI:Text(\"Distance to end pos: \" .. tostring(round(dist-context.moveto_stoppingdistance,2)))\n\t\tend\nend",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
	},
}



return tbl