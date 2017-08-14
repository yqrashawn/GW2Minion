local tbl = 
{
	class = "SubTree",
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
								runcode = "if (context.movetorandom_randompoint == nil) then\n\t\tif(ml_global_information.Player_OnMesh) then\n\t\t\t\t\t\tPlayer:StopMovement()\n\t\t\t\t\t\tcontext.movetorandom_randompoint = gw2_common_functions.GetRandomPoint()\n\t\telse\n\t\t\t\t-- Select the nearest waypoint so we at least have somewhere to go if we start offmesh\n\t\t\t\tlocal WPList = WaypointList(\"nearest,onmesh\")\n\t\t\t\tif(table.valid(WPList)) then\n\t\t\t\t\t\tlocal _,wp = next(WPList)\n\t\t\t\t\t\tif(wp and wp.pos) then\n\t\t\t\t\t\t\t\tcontext.movetorandom_randompoint = wp.pos\n\t\t\t\t\t\tend\n\t\t\t\tend\n\t\tend\nend\n\nif(table.valid(context.movetorandom_randompoint)) then\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
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
										runcode = "if(table.valid(context.movetorandom_randompoint) and context.moveto_stoppingdistance) then\n\t\tlocal dist = math.distance3d(context.movetorandom_randompoint,ml_global_information.Player_Position)\n\t\tif(dist <= context.moveto_stoppingdistance or dist < 150) then\n\t\t\t\tcontext.movetorandom_randompoint = nil\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\nend\nself:fail()",
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
											class = "SubTree",
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
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)\n\nif(context) then\n\t\tif(context.movetorandom_randompoint) then\n\t\t\t\tlocal dist = math.distance3d(ml_global_information.Player_Position,context.movetorandom_randompoint)\n\t\t\t\tGUI:Text(\"Distance: \" .. tostring(round(dist,2)))\n\t\t\t\tGUI:Text(\"Stopping distance: \" .. tostring(context.moveto_stoppingdistance))\n\t\t\t\tGUI:Text(\"Distance to end pos: \" .. tostring(round(dist-context.moveto_stoppingdistance,2)))\n\t\tend\nend",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
	},
}



return tbl