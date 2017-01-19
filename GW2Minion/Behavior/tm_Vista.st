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
						runcode = "if(table.valid(MapMarkerList(\"contentid=31309,agentid=\"..ml_global_information.Player_ID))) then\n\t\td(\"[Vista]: Player marked as viewing vista. Waiting.\")\n\t\tcontext.vista_marker = nil\n\t\tcontext.vista_pos = nil\n\t\tcontext.vista_playerviewing = true\n\t\tml_global_information.Wait(1500)\n\t\tself:running()\nelseif(context.vista_playerviewing) then\n\t\td(\"[Vista]: Waiting for the marker to update.\")\n\t\tcontext.vista_playerviewing = false\n\t\tml_global_information.Wait(2500)\n\t\tself:running()\nelse\n\t\tself:fail()\nend",
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
						runcode = "local MList = MapMarkerList(\"maxdistance=2000,nearest,isvista,contentid=\"..GW2.MAPMARKER.Vista)\nlocal MVista = nil\ncontext.vista_marker = nil\ncontext.vista_pos = nil\nif(table.valid(MList)) then\n\t\t\t\tlocal _,vista = next(MList)\n\t\t\t\tif(table.valid(vista) and vista.pos) then\n\t\t\t\t\t\tMVista = vista\n\t\t\t\tend\nend\n\nif(MVista) then\n\t\tcontext.vista_marker = MVista\n\t\tcontext.vista_pos = MVista.pos\nend\n\nself:fail()",
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
								runcode = "if(context.vista_marker) then\n\t\tlocal vista = context.vista_marker\n\t\tlocal pos = vista.pos\n\t\tif(not vista.onmesh) then\n\t\t\t\tpos = NavigationManager:GetClosestPointOnMesh(vista.pos)\n\t\tend\n\t\t\n\t\tif(pos) then\n\t\t\t\tif(math.distance3d(pos,ml_global_information.Player_Position) > 130) then\n\t\t\t\t\t\t\tcontext.moveto_position = table.shallowcopy(pos)\n\t\t\t\t\t\t\tself:success()\n\t\t\t\t\t\t\treturn\n\t\t\t\tend\n\t\telse\n\t \t\tcontext.vista_marker = nil\n\t\tend\nend\n\nself:fail()",
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
								randomizestoppingdistance = false,
								smoothturns = true,
								stoppingdistance = 120,
								stoppingidstancemaxrange = 260,
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
								runcode = "if(context.vista_fightaggro and ml_global_information.Player_InCombat) then\n\t\tlocal CList = CharacterList(\"aggro,maxpathdistance=99999,maxdistance=2000,attackable\"..gw2_blacklistmanager.GetMonsterExcludeString())\n\t\tif(table.valid(CList)) then\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\nend\n\nself:fail()",
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
								filename = "HandleAggro.st",
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
						runcode = "if(context.vista_pos) then\n\t\tlocal GList = GadgetList(\"interactable,maxdistance=500\")\n\t\tlocal vista = nil\n\n\t\t-- List all nearest gadgets in case something is really close to the vista\n\t\tif(table.valid(GList)) then\n\t\t\t\tlocal i,gadget = next(GList)\n\t\t\t\twhile not vista and i and gadget do\n\t\t\t\t\t\tif(math.distance3d(gadget.pos,context.vista_pos) < 5) then\n\t\t\t\t\t\t\t\tvista = gadget\n\t\t\t\t\t\tend\n\t\t\t\t\t\ti,gadget = next(GList,i)\n\t\t\t\tend\n\t\tend\n\n\t\tif(vista) then\n\t\t\t\tif(Player:GetCurrentlyCastedSpell() == ml_global_information.MAX_SKILLBAR_SLOTS) then\n\t\t\t\t\t\td(\"[Vista]: Interacting with vista\")\n\t\t\t\t\t\tPlayer:StopMovement()\n\t\t\t\t\t\tPlayer:SetTarget(vista.id)\n\t\t\t\t\t\tPlayer:SetFacing(vista.pos.x,vista.pos,y,vista.pos.z)\n\t\t\t\t\t\tPlayer:Interact(vista.id)\n\t\t\t\t\t\tml_global_information.Wait(1500)\n\t\t\t\t\t\tself:running()\n\t\t\t\t\t\treturn\n\t\t\t\tend\n\t\tend\nend\n\nself:fail()",
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
		runcode = "context.vista_fightaggro = self.settings.fightaggro or false",
		startcode = "",
		subtreeuicode = "if(self.settings.fightaggro == nil) then self.settings.fightaggro = true end\n\nself.settings.fightaggro = GUI:Checkbox(GetString(\"Fight aggro before interacting\"), self.settings.fightaggro)\n\nlocal MList = MapMarkerList(\"nearest,isvista,maxdistance=2000\")\nif(table.valid(MList)) then\n\t\t\tlocal _,vista = next(MList)\n\t\t\tif(vista) then\n\t\t\t\t\t\tif(vista.distance > 500) then\n\t\t\t\t\t\t\t\tGUI:Text(\"Nearest vista is too far away (500)\")\n\t\t\t\t\t\telseif(not vista.onmesh or vista.pathdistance < 99999) then\n\t\t\t\t\t\t\t\tGUI:Text(\"Vista not on mesh or no valid path found\")\n\t\t\t\t\t\tend\n\t\t\tend\nelse\n\t\tGUI:Text(\"No undiscovered vista nearby\")\nend",
	},
}



return tbl