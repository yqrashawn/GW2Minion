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
						runcode = "if(context.combat_targetid) then\n\t\tself:success()\n\t\treturn\nend\n\nself:fail()",
						startcode = "",
						xposoffset = 0,
					},
				},
				
				{
					class = "PrioritySelector",
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
										runcode = "if(context.combat_moveintocombatrange == nil) then\n\t\tcontext.combat_moveintocombatrange = true\nend\n\nif (context.combat_moveintocombatrange and context.combat_targetid and context.combat_targetpos) then\n\t\tif (Distance3DT(ml_global_information.Player_Position,context.combat_targetpos) > 2500 ) then \n\t\t\t\tcontext.moveto_position = context.combat_targetpos\n\t\t\t\tcontext.moveto_targetid = context.combat_targetid\n\t\t\t\tcontext.moveto_targettype = \"character\"\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\n\n\t\tcontext.moveto_targetid = nil\n\t\tcontext.moveto_targettype = nil\nend\nself:fail()",
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
						
						{
							class = "Action",
							nodes = 
							{
							},
							variables = 
							{
								finishcode = "",
								info = "Update target",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
								runcode = "if ( context.combat_targetid ) then\n\t\tlocal onmeshcheck = context.combat_onmeshcheck == nil and true or context.combat_onmeshcheck\n\n\t\tlocal target = CharacterList:Get(context.combat_targetid) or GadgetList:Get(context.combat_targetid)\n\t\tif (table.valid(target) and target.attackable and (target.alive or target.downed) and (onmeshcheck == false or target.onmesh) and not gw2_blacklistmanager.CheckBlacklistEntry(GetString(\"monsters\"),target.contentid)) then\n\t\t\t\t-- continue in the PrioritySelector parent\n\t\t\t\tcontext.combat_target = target\n\t\t\t\tcontext.combat_targetid = target.id\n\t\t\t\tcontext.combat_targetpos = target.pos\n\t\telse\n\t\t\t\td(\"[CombatHandler]: Target is dead, not attackable or not on mesh.\")\n\t\t\t\tcontext.combat_targetid = nil\n\t\t\t\tcontext.combat_target = nil\n\t\t\t\tcontext.combat_targetpos = nil\n\t\t\t\tcontext.combat_moveintocombatrange = nil\n\t\t\t\tcontext.combat_onmeshcheck = nil\n\t\tend\nend\nself:fail()",
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
								info = "Check target health",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
								runcode = "context.combat_targetcheck = context.combat_targetcheck or {}\n\nif(context.combat_target) then\n\t\tif(context.combat_targetid ~= context.combat_targetcheck.id or context.combat_target.contentid ~= context.combat_targetcheck.contentid) then\n\t\t\t\tcontext.combat_targetcheck = {\n\t\t\t\t\t\tid = context.combat_target.id,\n\t\t\t\t\t\tcontentid = context.combat_target.contentid,\n\t\t\t\t\t\thealth = context.combat_target.health,\n\t\t\t\t\t\tlastTicks = ml_global_information.Now,\n\t\t\t\t}\n\t\telseif(TimeSince(context.combat_targetcheck.lastTicks) > 15000) then\n\t\t\t\tif (context.combat_target.health.percent >= context.combat_targetcheck.health.percent) then\n\t\t\t\t\t\td(\"[CombatHandler]: Target not losing health. Blacklisting.\")\n\t\t\t\t\t\tgw2_blacklistmanager.AddBlacklistEntry(GetString(\"monsters\"), context.combat_target.contentid, context.combat_target.name, ml_global_information.Now + 90000)\n\t\t\t\t\t\tself:success()\n\t\t\t\t\t\treturn\n\t\t\t\tend\n\t\t\t\tcontext.combat_targetcheck = {\n\t\t\t\t\t\tid = context.combat_target.id,\n\t\t\t\t\t\tcontentid = context.combat_target.contentid,\n\t\t\t\t\t\thealth = context.combat_target.health,\n\t\t\t\t\t\tlastTicks = ml_global_information.Now\n\t\t\t\t}\n\t\tend\nend\nself:fail()",
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
								info = "Check target boons",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
								runcode = "if(context.combat_target) then\n\t\tif (gw2_common_functions.HasBuffs(context.combat_target,ml_global_information.InvulnerabilityConditions)) then\n\t\t\t\td(\"[CombatHandler]: Target is invulnerable. Blacklisting.\")\n\t\t\t\tgw2_blacklistmanager.AddBlacklistEntry(GetString(\"monsters\"),context.combat_target.contentid,context.combat_target.name,ml_global_information.Now+15000)\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\nend\nself:fail()",
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
								info = "Handle combat",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
								runcode = "if ( context.combat_targetid ) then\n\t\tgw2_skill_manager:Use(context.combat_targetid)\n\t\tself:running()\n\t\treturn\nend\nself:fail()",
								startcode = "",
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
		expanded = true,
		filename = "CombatHandler.st",
		finishcode = "",
		info = "Handle combat\ncontext.combat_targetid\ncontext.combat_target",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		moveintocombatrange = false,
		runcode = "",
		startcode = "",
		subtreeuicode = "",
		xposoffset = 0,
	},
}



return tbl