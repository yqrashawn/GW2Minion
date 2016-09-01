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
						info = "Finds a dead/downed Partymember and sets the id to the context.revive_partymemberid",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if (table.valid(ml_global_information.Player_Party)) then\n\tfor _,pMember in pairs(ml_global_information.Player_Party) do\n\t\tif(pMember.id ~= Player.id) then\n\t\t\tlocal target = CharacterList:Get(pMember.id)\n\t\t\tif (table.valid(target) and target.onmesh and (target.downed == true or target.dead == true) and ml_global_information.Player_Health.percent > 35 ) then\n\t\t\t\tlocal pdist = target.pathdistance\n\t\t\t\tif ( pdist > 0 and pdist < 2500) then\n\t\t\t\t\tcontext.moveto_position = target.pos\n\t\t\t\t\tcontext.moveto_targetid = target.id\n\t\t\t\t\tcontext.moveto_targettype = \"character\"\n\t\t\t\t\tself:success()\n\t\t\t\t\treturn\n\t\t\t\tend\n\t\t\tend\n\t\tend\n\tend\nend\nself:fail()",
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
				
				{
					class = "Action",
					nodes = 
					{
					},
					variables = 
					{
						finishcode = "",
						info = "We are at the downed/dead partymember, revive him",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if ( context.moveto_targetid ) then\n\tlocal target = CharacterList:Get(context.moveto_targetid)\n\tif (table.valid(target) and target.onmesh and (target.downed == true or target.dead == true) and ml_global_information.Player_Health.percent > 35 ) then\n\t\tlocal pdist = target.pathdistance\n\t\tif ( ml_global_information.Player_IsMoving == true ) then Player:StopMovement() end\n\t\tgw2_common_functions.NecroLeaveDeathshroud()\n\t\tlocal t = Player:GetTarget()\n\t\tif ( not t or t.id ~= target.id ) then\n\t\t\tPlayer:SetTarget(target.id)\n\t\telse\n\t\t\tml_log(\"[Revive Partyymember] - Reviving...\")\n\t\t\tPlayer:Interact(target.id)\n\t\t\tml_global_information.Wait(1000)\n\t\t\tself:running()\n\t\t\treturn\n\t\tend\n\tend\t\nend\nself:fail()",
						startcode = "",
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
		filename = "RevivePartyMember.st",
		finishcode = "",
		info = "Revives a downed / dead Partymember.",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
		xposoffset = 0,
	},
}



return tbl