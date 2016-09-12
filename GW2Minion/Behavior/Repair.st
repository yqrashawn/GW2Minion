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
						runcode = "if(gw2_repair_manager.NeedToRepair(context.repair_nearby) and table.valid(gw2_repair_manager.getClosestRepairMarker(context.repair_nearby))) then\n\t\tself:success()\n\t\treturn\nend\n \nself:fail()",
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
						runcode = "if(not context.repair_marker_characterid) then\n\t\tlocal marker = gw2_repair_manager.getClosestRepairMarker(context.repair_nearby)\n\t\tif(table.valid(marker)) then\n\t\t\t\tcontext.repair_marker = marker\n\t\t\t\tcontext.repair_marker_characterid = marker.characterid\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\nelseif(context.repair_marker_characterid) then\n\t\tlocal markers = gw2_repair_manager.getMarkerList()\n\t\tif(table.valid(markers)) then\n\t\t\t\tlocal i,marker = next(markers)\t\t\t\n\t\t\t\twhile i and marker and not context.repair_marker_characterid do\n\t\t\t\t\t\tif(marker.characterid == context.repair_marker_characterid) then\n\t\t\t\t\t\t\t\tcontext.repair_marker = marker\n\t\t\t\t\t\t\t\ti,marker = next(markers,i)\n\t\t\t\t\t\tend\n\t\t\t\tend\n\n\t\t\t\tif(table.valid(context.repair_marker)) then\n\t\t\t\t\t\tself:success()\n\t\t\t\t\t\treturn\n\t\t\t\tend\n\t\tend\nend\ncontext.repair_marker = nil\ncontext.repair_marker_characterid = nil\nself:fail()",
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
								runcode = "if(table.valid(context.repair_marker)) then\n\t\tif(context.repair_marker.distance > 150) then\n\t\t\t\tcontext.moveto_position = context.repair_marker.pos\n\t\t\t\tcontext.moveto_useWaypoints = context.moveto_useWaypoints == nil and true or context.moveto_useWaypoints\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\n\t\t\n\t\tif(gw2_repair_manager.RepairAtVendor(context.repair_marker)) then\n\t\t\t\tself:running()\n\t\t\t\treturn\n\t\tend\n\t\tml_global_information.Wait(math.random(1500,3000))\nend\ncontext.repair_marker = nil\ncontext.repair_marker_characterid = nil\nself:fail()",
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
		filename = "Repair.st",
		finishcode = "",
		info = "Repair\nOptional parameter:\ncontext.repair_nearby = true/false",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
		xposoffset = 0,
	},
}



return tbl