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
					variables = 
					{
						finishcode = "",
						info = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(ml_global_information.Player_Alive) then\n\t\tself:fail()\nelse\n\t\tself:success()\nend",
						startcode = "",
						xposoffset = 0,
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
									variables = 
									{
										finishcode = "",
										info = "",
										monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
										runcode = "if(ml_global_information.Player_OnMesh) then\n\t\tif (context.movetorandom_randompoint == nil) then\n\t\t\t\t-- Walk to Random Point in our levelrange\n\t\t\t\tif (table.valid(gw2_datamanager.levelmap)) then\n\t\t\t\t\t\tlocal pos = gw2_datamanager.GetRandomPositionInLevelRange( ml_global_information.Player_Level )\n\n\t\t\t\t\t-- make sure the position can be reached\n\t\t\t\t\tif (table.valid(pos) and table.valid(NavigationManager:GetPath(ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z,pos.x,pos.y,pos.z))) then\n\t\t\t\t\t\td(\"[MoveToRandom]: Random point found\")\n\t\t\t\t\t\tcontext.movetorandom_randompoint = pos\n\t\t\t\t\t\tcontext.movetorandom_randompointreached = false\n\t\t\t\t\t\tcontext.movetorandom_randompointdistance = math.random(750,3000)\n\t\t\t\t\telse\n\t\t\t\t\t\td(\"[MoveToRandom]: Random point not found\")\n\t\t\t\t\tend\n\t\t\tend\n\t\tend\n\n\t\t-- 2nd attempt to find a random point\n\t\tif (context.movetorandom_randompoint == nil) then\n\t\t\t\tlocal pos = NavigationManager:GetRandomPoint(5000) -- 5000 beeing mindistance to player\n\t\t\t\tif (table.valid(pos) and table.valid(NavigationManager:GetPath(ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z,pos.x,pos.y,pos.z))) then\n\t\t\t\t\td(\"[MoveToRandom]: Random point found (2nd try)\")\n\t\t\t\t\tcontext.movetorandom_randompoint = pos\n\t\t\t\t\tcontext.movetorandom_randompointreached = false\n\t\t\t\t\tcontext.movetorandom_randompointdistance = math.random(750,2000)\n\t\t\t\tend\n\t\tend\nend\n\nif(table.valid(context.movetorandom_randompoint)) then\n\t\tself:success()\nelse\n\t\tself:running()\nend",
										startcode = "",
										xposoffset = 0,
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
											variables = 
											{
												finishcode = "",
												info = "",
												monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
												runcode = "if(table.valid(context.movetorandom_randompoint)) then\n\t\tif(Distance3DT(context.movetorandom_randompoint,ml_global_information.Player_Position) < context.movetorandom_randompointdistance) then\n\t\t\t\tcontext.movetorandom_randompoint = nil\n\t\t\t\tcontext.movetorandom_randompointreached = true\n\t\tend\nend\nself:fail()",
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
												runcode = "if(table.valid(context.movetorandom_randompoint)) then\n\t\tcontext.moveto_position = context.movetorandom_randompoint\nend\nself:fail()",
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
														runcode = "if(table.valid(context.movetorandom_randompoint)) then\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
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
														monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)\nif(context) then\n\t\tif(table.valid(context.moveto_position)) then\n\t\t\t\tGUI:Text(\"Distance:\"..round(Distance3DT(context.moveto_position,ml_global_information.Player_Position),2))\n\t\tend\n\t\tGUI:Text(\"Use waypoints: \"..tostring(context.moveto_usewaypoints))\nend",
														randomMovement = true,
														runcode = "-- Setting the custom subtree settings in the context, which gets passed down to childnodes\ncontext.moveto_stoppingdistance = self.variables.stoppingdistance\ncontext.moveto_randomMovement = self.variables.randomMovement\ncontext.moveto_smoothturns = self.variables.smoothturns\ncontext.moveto_usewaypoints = self.variables.usewaypoints\ncontext.moveto_follownavsystem = false ",
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
										monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.runningTask or 'None'))",
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
						info = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
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
		filename = "MoveToRandom.st",
		finishcode = "",
		info = "Move to random",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
		xposoffset = 0,
	},
}



return tbl