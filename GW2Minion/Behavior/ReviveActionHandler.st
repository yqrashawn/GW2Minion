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
						runcode = "if(context.revive_targetid and context.revive_position) then\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
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
						runcode = "local dist = Distance3DT(ml_global_information.Player_Position,context.revive_position)\nif(dist > 1500) then\n\t\tcontext.moveto_position = context.revive_position\n\t\tcontext.moveto_targetid = context.revive_targetid\n\t\tcontext.moveto_targettype = \"character\"\n\t\tself:success()\n\t\treturn\nelse\n\t\tlocal target = CharacterList:Get(context.revive_targetid)\n\t\tif(table.valid(target) and not target.alive and target.onmesh and target.pathdistance > 0) then\n\t\t\t\tif(target.distance > 130 or not target.isininteractrange) then\n\t\t\t\t\t\tcontext.moveto_position = target.pos\n\t\t\t\t\t\tcontext.moveto_targetid = context.revive_targetid\n\t\t\t\t\t\tcontext.moveto_targettype = \"character\"\n\t\t\t\t\t\tself:success()\n\t\t\t\t\t\treturn\n\t\t\t\tend\n\t\t\t\n\t\t\t\tlocal pTarget = Player:GetTarget()\n\t\t\t\tif(pTarget == nil or pTarget.id ~= target.id) then\n\t\t\t\t\t\tPlayer:SetTarget(target.id)\n\t\t\t\tend\n\t\t\t\tPlayer:SetFacing(target.pos.x,target.pos.y,target.pos.z)\n\t\t\t\tPlayer:Interact(target.id)\n\t\t\t\tml_global_information.Wait(math.random(500,900))\n\t\t\t\tself:running()\n\t\t\t\treturn\n\t\telse\n\t\t\t\td(\"[Revive]: Target alive or missing\")\n\t\tend\nend\ncontext.revive_targetid = nil\ncontext.revive_position = nil\nself:fail()",
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
		filename = "ReviveActionHandler.st",
		finishcode = "",
		info = "Revive action\ncontext.revive_position\ncontext.revive_targetid",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
		xposoffset = 0,
	},
}



return tbl