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
						info = "Check for gather tools",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(self.lasttoolcheck == nil or TimeSince(self.lasttoolcheck) > 2000) then\t\t\n\t\tself.lasttoolcheck = ml_global_information.Now\n\t\tlocal fTool = table.valid(Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.ForagingTool))\n\t\tlocal lTool = table.valid(Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.LoggingTool))\n\t\tlocal mTool = table.valid(Inventory:GetEquippedItemBySlot(GW2.EQUIPMENTSLOT.MiningTool))\n\t\tif(not fTool or not lTool or not mTool) then\n\t\t\t\tself.lasttoolcheckfailed = true\n\t\t\t\td(\"[Gather]: One or more gather tools not equipped!\")\n\t\t\t\td(string.format(\"[Gather]: ftool=%s, ltool=%s, mtool=%s\", tostring(fTool), tostring(lTool), tostring(mTool)))\n\t\telse\n\t\t\t\tself.lasttoolcheckfailed = false\n\t\tend\nend\n\nif(self.lasttoolcheckfailed) then\n\t\tself:fail()\nelse\n\t\tself:success()\nend",
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
						info = "Find gatherable",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(context.gather_targetid) then\n\t\tself:success()\n\t\treturn\nelseif(context.gather_targetid == nil) then\n\t\tlocal filter = \"shortestpath,onmesh,gatherable,interactable,selectable\"\n\t\t\n\t\tif(context.gather_maxdistance) then\n\t\t\t\tfilter = filter .. \",maxdistance=\"..context.gather_maxdistance\n\t\tend\n\t\t\n\t\tlocal GList = GadgetList(filter)\n\n\t\tif(table.valid(GList)) then\n\t\t\t\tlocal _,gatherable = next(GList)\n\t\t\t\tif(table.valid(gatherable)) then\n\t\t\t\t\t\td(\"[Gather]: New gatherable found\")\n\t\t\t\t\t\tcontext.gather_targetid = gatherable.id\n\t\t\t\t\t\tcontext.gather_position = gatherable.pos\n\t\t\t\t\t\tcontext.moveto_position = gatherable.pos\n\t\t\t\t\t\tcontext.moveto_targettype = \"gadget\"\n\t\t\t\t\t\tcontext.moveto_targetid = gatherable.id\n\t\t\t\t\t\t\n\t\t\t\t\t\tself:success()\n\t\t\t\t\t\treturn\n\t\t\t\tend\n\t\tend\nend\nself:fail()\n\n",
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
								info = "Gather",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
								runcode = "if(context.gather_targetid) then\n\t\tlocal dist = Distance3DT(ml_global_information.Player_Position,context.moveto_position)\n\t\tif(dist < 1500) then\n\t\t\t\tlocal target = GadgetList:Get(context.gather_targetid)\n\t\t\n\t\t\t\tif(target and target.gatherable and target.interactable) then\n\t\t\t\t\t\tif(target.isininteractrange and dist < 150) then\n\t\t\t\t\t\t\t\tlocal pTarget = Player:GetTarget()\n\t\t\t\t\t\t\t\tif(not pTarget or pTarget.id ~= target.id) then\n\t\t\t\t\t\t\t\t\t\tPlayer:SetTarget(target.id)\t\t\t\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\tif(ml_global_information.Player_IsMoving) then\n\t\t\t\t\t\t\t\t\t\tPlayer:StopMovement()\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\tgw2_common_functions.NecroLeaveDeathshroud()\n\t\t\t\t\t\t\t\tPlayer:SetFacing(target.pos.x,target.pos.y,target.pos.z)\n\t\t\t\t\t\t\t\tif ( Player:GetCurrentlyCastedSpell() == ml_global_information.MAX_SKILLBAR_SLOTS ) then\n\t\t\t\t\t\t\t\t\t\tPlayer:Interact(target.id)\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\tself:running()\n\t\t\t\t\t\t\t\treturn\n\t\t\t\t\t\tend\n\t\t\t\telse\n\t\t\t\t\t\tcontext.gather_targetid = nil\n\t\t\t\t\t\tself:fail()\n\t\t\t\t\t\treturn\n\t\t\t\tend\n\t\tend\nend\n\nself:success()",
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
								runcode = "if(context.gather_targetid and table.valid(context.moveto_position)) then\n\t\tif(Distance3DT(ml_global_information.Player_Position,context.moveto_position) > 100) then\n\t\t\t\tself:success()\n\t\telse\n\t\t\t\tself:fail()\n\t\tend\nend",
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
				info = "",
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.actualTask or 'None'))",
				xposoffset = 0,
			},
		},
	},
	variables = 
	{
		expanded = true,
		filename = "Gather.st",
		finishcode = "",
		info = "Gather",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)\nif(context and context.gather_targetid and context.gather_position) then\n\t\tGUI:Text(\"Distance to gatherable: \" .. math.ceil(Distance3DT(ml_global_information.Player_Position,context.gather_position)))\nend",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
		xposoffset = 0,
	},
}



return tbl