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
					variables = 
					{
						finishcode = "",
						info = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(table.valid(context.movetomultiple_positions)) then\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
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
						runcode = "if(context.movetomultiple_repeatpositions) then\n\t\tlocal visited = 0\n\t\tfor _,pos in ipairs(context.movetomultiple_positions) do\n\t\t\t\tif(pos.visited) then\n\t\t\t\t\t\tvisited = visited + 1\n\t\t\t\tend\n\t\tend\n\n\t\tif(visited == table.size(context.movetomultiple_positions)) then\n\t\t\t\t\tfor _,pos in ipairs(context.movetomultiple_positions) do\n\t\t\t\t\t\t\tpos.visited = false\n\t\t\t\t\tend\n\t\tend\nend\nself:success()",
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
						runcode = "\nlocal pos = context.movetomultiple_activepos\n\nif(pos == nil) then\n\t\tif(context.movetomultiple_random) then\n\t\t\t\t\n\t\telse\n\t\t\t\tlocal i,nextpos = next(context.movetomultiple_positions)\n\t\t\t\twhile i and nextpos and not pos do\n\t\t\t\t\t\tif(not nextpos.visited) then\n\t\t\t\t\t\t\t\tpos = nextpos\n\t\t\t\t\t\tend\n\t\t\t\t\t\ti,nextpos = next(context.movetomultiple_positions,i)\n\t\t\t\tend\n\t\tend\nend\n\nif(table.valid(pos)) then\n\t\tcontext.movetomultiple_activepos = pos\n\t\tcontext.moveto_position = pos\n\t\tself:success()\n\t\treturn\nend\n\nself:fail()",
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
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)\n",
						randomMovement = true,
						runcode = "-- Setting the custom subtree settings in the context, which gets passed down to childnodes\ncontext.moveto_stoppingdistance = self.variables.stoppingdistance\ncontext.moveto_randomMovement = self.variables.randomMovement\ncontext.moveto_smoothturns = self.variables.smoothturns\ncontext.moveto_usewaypoints = self.variables.usewaypoints\ncontext.moveto_follownavsystem = false",
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
		filename = "tm_MoveToMultiple.st",
		finishcode = "",
		info = "",
		loop = false,
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		positions = 
		{
		},
		random = false,
		randomitem = false,
		randommovement = false,
		randompos = false,
		repeatpositions = false,
		runcode = "",
		startcode = "",
		subtreeuicode = "if(self.variables.repeatpositions == nil) then self.variables.repeatpositions = false end\nif(self.variables.randompos == nil) then self.variables.randompos = false end\nif(self.variables.randommovement == nil) then self.variables.randommovement = false end\nif(self.variables.usewaypoints == nil) then self.variables.usewaypoints = false end\n\nself.variables.repeatpositions = GUI:Checkbox(\"Repeat\", self.variables.repeatpositions)\nself.variables.randompos = GUI:Checkbox(\"Random\", self.variables.randompos)\nself.variables.randommovement = GUI:Checkbox(\"Random movement\", self.variables.randommovement)\nself.variables.usewaypoints = GUI:Checkbox(\"Use waypoints\", self.variables.usewaypoints)\n\nself.variables.positions = self.variables.positions or {}\nlocal maxW = GUI:GetContentRegionAvailWidth()\nfor i,pos in ipairs(self.variables.positions) do\n\tlocal x,y,z,changed = GUI:InputFloat3(\"##position\",pos.x,pos.y,pos.z,2)\n\tif(changed) then\n\t\t\tself.variables.positions[i] = {x = x; y = y; z = z;}\n\tend\n\tGUI:SameLine()\n\tif(GUI:Button(\"Delete##Moveto_position_\"..i)) then\n\t\ttable.remove(self.variables.positions, i)\n\tend\nend\n\nif(GUI:Button(\"Add position\")) then\n\ttable.insert(self.variables.positions, ml_global_information.Player_Position)\nend",
		usewaypoints = false,
		xposoffset = 0,
	},
}



return tbl