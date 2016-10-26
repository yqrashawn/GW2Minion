local tbl = 
{
	class = "BehaviorTree",
	nodes = 
	{
		
		{
			class = "Selector",
			nodes = 
			{
				
				{
					class = "Action",
					nodes = 
					{
					},
					settings = 
					{
						xposoffset = 0,
					},
					variables = 
					{
						finishcode = "",
						info = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(ml_global_information.Player_Alive) then\n\t\tself:fail()\nelse\n\t\tself:success()\nend",
						startcode = "",
					},
				},
				
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
										xposoffset = 0,
									},
									variables = 
									{
										finishcode = "",
										info = "",
										monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
										runcode = "if(ml_global_information.Player_OnMesh) then\n\t\tif (context.movetorandom_randompoint == nil) then\n\t\t\t\t-- Walk to Random Point in our levelrange\n\t\t\t\tif (table.valid(gw2_datamanager.levelmap)) then\n\t\t\t\t\t\tlocal pos = gw2_datamanager.GetRandomPositionInLevelRange( ml_global_information.Player_Level )\n\n\t\t\t\t\t-- make sure the position can be reached\n\t\t\t\t\tif (table.valid(pos) and table.valid(NavigationManager:GetPath(ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z,pos.x,pos.y,pos.z))) then\n\t\t\t\t\t\td(\"[MoveToRandom]: Random point found\")\n\t\t\t\t\t\tcontext.movetorandom_randompoint = pos\n\t\t\t\t\t\tcontext.movetorandom_randompointreached = false\n\t\t\t\t\t\tcontext.movetorandom_randompointdistance = math.random(750,3000)\n\t\t\t\t\telse\n\t\t\t\t\t\td(\"[MoveToRandom]: Random point not found\")\n\t\t\t\t\tend\n\t\t\tend\n\t\tend\n\n\t\t-- 2nd attempt to find a random point\n\t\tif (context.movetorandom_randompoint == nil) then\n\t\t\t\tlocal pos = NavigationManager:GetRandomPoint(5000) -- 5000 beeing mindistance to player\n\t\t\t\tif (table.valid(pos) and table.valid(NavigationManager:GetPath(ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z,pos.x,pos.y,pos.z))) then\n\t\t\t\t\td(\"[MoveToRandom]: Random point found (2nd try)\")\n\t\t\t\t\tcontext.movetorandom_randompoint = pos\n\t\t\t\t\tcontext.movetorandom_randompointreached = false\n\t\t\t\t\tcontext.movetorandom_randompointdistance = math.random(750,2000)\n\t\t\t\tend\n\t\tend\nend\n\nif(table.valid(context.movetorandom_randompoint)) then\n\t\tself:success()\nelse\n\t\tself:running()\nend",
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
												xposoffset = 0,
											},
											variables = 
											{
												finishcode = "",
												info = "",
												monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
												runcode = "if(table.valid(context.movetorandom_randompoint)) then\n\t\tif(Distance3DT(context.movetorandom_randompoint,ml_global_information.Player_Position) < context.movetorandom_randompointdistance) then\n\t\t\t\tcontext.movetorandom_randompoint = nil\n\t\t\t\tcontext.movetorandom_randompointreached = true\n\t\tend\nend\nself:fail()",
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
												xposoffset = 0,
											},
											variables = 
											{
												finishcode = "",
												info = "",
												monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
												runcode = "if(table.valid(context.movetorandom_randompoint)) then\n\t\tcontext.moveto_position = context.movetorandom_randompoint\nend\nself:fail()",
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
														xposoffset = 0,
													},
													variables = 
													{
														finishcode = "",
														info = "",
														monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
														runcode = "if(table.valid(context.movetorandom_randompoint)) then\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
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
														expanded = true,
														randomMovement = true,
														smoothturns = true,
														stoppingdistance = 50,
														usewaypoints = false,
														xposoffset = 0,
													},
													variables = 
													{
														filename = "MoveTo.st",
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
										monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.runningTask or 'None'))",
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
						xposoffset = 0,
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
		filename = "MoveToRandom.st",
		finishcode = "",
		info = "Move to random",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
	},
}



return tbl