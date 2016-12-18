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
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(table.valid(context.movetomultiple_positions)) then\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
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
						info = "Update visited status",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "local visited = context.movetomultiple_visited or {}\nif(context.movetomultiple_repeatpositions) then\n\t\tlocal n_visited = 0\n\t\tfor _,v in ipairs(visited) do\n\t\t\t\tif(v) then n_visited = n_visited + 1 end\n\t\tend\n\n\t\tif(n_visited == table.size(context.movetomultiple_positions)) then\n\t\t\t\t\tfor i,pos in ipairs(context.movetomultiple_positions) do\n\t\t\t\t\t\t\tvisited[i] = false\n\t\t\t\t\tend\n\t\tend\n\n\t\tcontext.movetomultiple_visited = visited\nend\nself:success()",
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
								runcode = "local visited = context.movetomultiple_visited or {}\n\nlocal pos = context.movetomultiple_activepos\n\nif(table.valid(pos)) then\n\t\tif(math.distance3d(pos,ml_global_information.Player_Position) < 60) then\n\t\t\t\tcontext.movetomultiple_activepos = nil\n\t\t\t\tPlayer:StopMovement()\n\t\t\t\tml_global_information.Wait(math.random(500,1000))\n\t\t\t\tself:running()\n\t\t\t\treturn\n\t\tend\nelse\n\n\t\tif(context.movetomultiple_randompos) then\n\t\t\t\t\t\tlocal i = math.random(1,table.size(context.movetomultiple_positions))\n\t\t\t\t\t\tif(context.movetomultiple_positions[i] and not visited[i]) then\n\t\t\t\t\t\t\t\tpos = context.movetomultiple_positions[i]\n\t\t\t\t\t\t\t\tvisited[i] = true\n\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\tself:running()\n\t\t\t\t\t\tend\n\t\telse\n\t\t\t\tlocal i,nextpos = next(context.movetomultiple_positions)\n\t\t\t\twhile i and nextpos and not pos do\n\t\t\t\t\t\tif(not visited[i]) then\n\t\t\t\t\t\t\t\tpos = nextpos\n\t\t\t\t\t\t\t\tvisited[i] = true\n\t\t\t\t\t\tend\n\t\t\t\t\t\ti,nextpos = next(context.movetomultiple_positions,i)\n\t\t\t\tend\n\t\tend\nend\n\ncontext.movetomultiple_visited = visited\n\nif(table.valid(pos)) then\n\t\tcontext.movetomultiple_activepos = pos\n\t\tcontext.moveto_position = pos\n\t\tcontext.moveto_randommovement = context.movetomultiple_randommovement\n\t\tself:success()\n\t\treturn\nend\n\nself:fail()",
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
								stoppingdistance = 50,
								stoppingidstancemaxrange = 50,
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
		filename = "tm_MoveToMultiple.st",
		finishcode = "",
		info = "",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "context.movetomultiple_positions = self.settings.positions\ncontext.movetomultiple_repeatpositions = self.settings.repeatpositions\ncontext.movetomultiple_randompos = self.settings.randompos\ncontext.movetomultiple_randommovement = self.settings.randommovement\ncontext.movetomultiple_usewaypoints = self.settings.usewaypoints\n",
		startcode = "",
		subtreeuicode = "if(self.settings.repeatpositions == nil) then self.settings.repeatpositions = false end\nif(self.settings.randompos == nil) then self.settings.randompos = false end\nif(self.settings.randommovement == nil) then self.settings.randommovement = false end\nif(self.settings.usewaypoints == nil) then self.settings.usewaypoints = false end\n\nself.settings.repeatpositions = GUI:Checkbox(\"Repeat\", self.settings.repeatpositions)\nself.settings.randompos = GUI:Checkbox(\"Randomize\", self.settings.randompos)\nself.settings.randommovement = GUI:Checkbox(\"Random movement\", self.settings.randommovement)\nself.settings.usewaypoints = GUI:Checkbox(\"Use waypoints\", self.settings.usewaypoints)\n\nself.settings.positions = self.settings.positions or {}\nlocal maxW = GUI:GetContentRegionAvailWidth()\nfor i,pos in ipairs(self.settings.positions) do\n\tlocal x,y,z,changed = GUI:InputFloat3(\"##position\"..i,pos.x,pos.y,pos.z,2)\n\tif(changed) then\n\t\t\tself.settings.positions[i] = {x = x; y = y; z = z;}\n\tend\n\tGUI:SameLine()\n\tif(GUI:Button(\"Delete##Moveto_position_\"..i)) then\n\t\ttable.remove(self.settings.positions, i)\n\tend\nend\n\nif(GUI:Button(\"Add position\")) then\n\ttable.insert(self.settings.positions, ml_global_information.Player_Position)\nend",
	},
}



return tbl