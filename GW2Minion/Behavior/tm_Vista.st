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
						filename = "",
						finishcode = "",
						info = "Check viewing status",
						menucode = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(table.valid(MapMarkerList(\"contentid=31309,agentid=\"..ml_global_information.Player_ID))) then\n\t\td(\"[Vista]: Player marked as viewing vista. Waiting.\")\n\t\tcontext.vista_marker = nil\n\t\tcontext.vista_playerviewing = true\n\t\tml_global_information.Wait(1500)\n\t\tself:running()\nelseif(context.vista_playerviewing) then\n\t\td(\"[Vista]: Waiting for the marker to update.\")\n\t\tcontext.vista_playerviewing = false\n\t\tml_global_information.Wait(2500)\n\t\tself:running()\nelse\n\t\tself:fail()\nend",
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
						info = "Update marker",
						menucode = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "local MList = MapMarkerList(\"maxdistance=2000,nearest,isvista,contentid=\"..GW2.MAPMARKER.Vista)\nif(table.valid(MList)) then\n\t\t\t\tlocal _,vista = next(MList)\n\t\t\t\tif(table.valid(vista)) then\n\t\t\t\t\t\tcontext.vista_marker = vista\n\t\t\t\tend\nend\n\nself:fail()",
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
								runcode = "if(context.vista_marker) then\n\t\tlocal vista = context.vista_marker\n\t\tlocal pos = vista.pos\n\t\tif(not vista.onmesh) then\n\t\t\t\tpos = NavigationManager:GetClosestPointOnMesh(vista.pos)\n\t\tend\n\t\t\n\t\tif(pos) then\n\t\t\t\tif(Distance3DT(pos,ml_global_information.Player_Position) > 130) then\n\t\t\t\t\t\t\tcontext.moveto_position = pos\n\t\t\t\t\t\t\tself:success()\n\t\t\t\t\t\t\treturn\n\t\t\t\tend\n\t\telse\n\t\t\t\tcontext.vista_marker = nil\n\t\tend\nend\n\nself:fail()",
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
								randomMovement = false,
								smoothturns = true,
								stoppingdistance = 130,
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
						info = "Move to vista",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.actualTask or 'None'))",
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
						info = "Interact with vista",
						menucode = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(context.vista_marker) then\n\t\tlocal vista = Player:GetInteractableTarget()\n\t\tif(vista) then\n\t\t\t\tif(Player:GetCurrentlyCastedSpell() == ml_global_information.MAX_SKILLBAR_SLOTS) then\n\t\t\t\t\t\td(\"[Vista]: Interacting with vista\")\n\t\t\t\t\t\tPlayer:StopMovement()\n\t\t\t\t\t\tPlayer:SetFacing(vista.pos.x,vista.pos,y,vista.pos.z)\n\t\t\t\t\t\tPlayer:Interact(vista.id)\n\t\t\t\t\t\tml_global_information.Wait(1500)\n\t\t\t\t\t\tself:running()\n\t\t\t\t\t\treturn\n\t\t\t\tend\n\t\tend\nend\n\nself:fail()",
						startcode = "",
						subtreeuicode = "",
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
		filename = "tm_Vista.st",
		finishcode = "context.vista_marker = nil\ncontext.vista_playerviewing = nil",
		info = "",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
	},
}



return tbl