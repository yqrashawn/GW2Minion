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
						info = "Target map check",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(not context.movetomap_targetmapid) then\n\td(\"[MoveToMap]: No target map set\")\nend\n\nif(context.movetomap_targetmapid == ml_global_information.CurrentMapID) then\n\td(\"[MoveToMap]: Target map reached\")\nend\n\nif(context.movetomap_targetmapid and context.movetomap_targetmapid ~= ml_global_information.CurrentMapID) then\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
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
						info = "Update node data",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if ( ml_global_information.CurrentMapID ~= context.movetomap_lastmapid ) then\n\tPlayer:StopMovement()\n\tcontext.movetomap_lastmapid = ml_global_information.CurrentMapID\n\tcontext.movetomap_gatereached = false\n\tcontext.movetomap_usedwaypoint = false\n\tml_global_information.Wait(2000,5000)\nend\n\nlocal nodedata = ml_nav_manager.GetNextPathPos(ml_global_information.Player_Position, ml_global_information.CurrentMapID, context.movetomap_targetmapid )\nif(table.valid(nodedata)) then\n\tcontext.movetomap_nextpathpos = nodedata\n\tcontext.moveto_position = context.movetomap_nextpathpos\n\tcontext.moveto_usewaypoints = context.movetomap_usewaypoints\n\tcontext.movetomap_gatedistance = Distance3DT(nodedata,ml_global_information.Player_Position)\n\tif(context.movetomap_gatedistance < 60) then\n\t\t\tcontext.movetomap_gatereached = true\n\tend\n\tself:success()\nelse\n\tself:fail()\nend",
						startcode = "",
						xposoffset = 0,
					},
				},
				
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
								info = "Leave instance",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
								runcode = "if (gw2_common_functions.PlayerInInstance()) then\n\t\tml_global_information.Wait(math.random(2000,6000))\n\t\tPlayer:LeaveInstance()\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
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
								info = "Use waypoint",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
								runcode = "-- Waypoint Usage\nif (context.movetomap_usewaypoints == true and not context.movetomap_usedwaypoint and Inventory:GetInventoryMoney() > (139*math.log10(ml_global_information.Player_Level))*2) then\n\tlocal waypoint = {}\n\tif (table.valid(context.movetomap_targetpos)) then\n\t\twaypoint = gw2_common_functions.GetClosestWaypointToPos(context.movetomap_targetmapid,context.movetomap_targetpos)\n\telse\n\t\tlocal wpList = gw2_datamanager.GetLocalWaypointList(context.movetomap_targetmapid)\n\t\tif (table.valid(wpList)) then\n\t\t\t\twaypoint = wpList[math.random(1,table.size(wpList))]\n\t\tend\n\tend\n\t\n\tif(table.valid(waypoint) == false) then\n\t\twaypoint = gw2_common_functions.GetClosestWaypointToMap(context.movetomap_targetmapid)\n\tend\n\tif (table.valid(waypoint) and ml_global_information.Player_InCombat == false) then\n\t\tPlayer:TeleportToWaypoint(waypoint.id)\n\t\tml_global_information.Wait(math.random(3000,8000))\n\t\tcontext.movetomap_usedwaypoint = true\n\t\tself:success()\n\t\treturn\n\telseif (table.valid(waypoint) == false) then\n\t\tcontext.movetomap_usedwaypoint = true\n\tend\nend\nself:fail()",
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
										runcode = "if(context.movetomap_gatedistance > 50 and not context.movetomap_gatereached) then\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
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
								info = "Move to portal",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
								runcode = "local nodedata = context.movetomap_nextpathpos\nif(table.valid(nodedata)) then\n\tif ( nodedata.type == \"Dungeon\" ) then\n\t\tif ( Player:IsInstanceDialogShown() ) then\n\t\t\tlocal dInfo = Player:GetInstanceInfo()\n\t\t\t\n\t\t\t-- Join/Open dungeon depending on our role\n\t\t\tif ( Player:JoinInstance() == false ) then\n\t\t\t\t-- check for available dungeonModeIDs and selected them\t\t\t\t\t\t\t\t\t\t\n\t\t\t\tlocal modeID = 0\n\t\t\t\tif ( nodedata.modeID ~= nil ) then\n\t\t\t\t\tif ( dInfo.instanceModeID == tonumber(nodedata.modeID) ) then modeID = dInfo.instanceModeID end\n\t\t\t\t\tif ( dInfo.instanceMode2ID == tonumber(nodedata.modeID) ) then modeID = dInfo.instanceMode2ID end\n\t\t\t\tend\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\n\t\t\t\tif ( nodedata.mode ~= nil and nodedata.mode == \"Exploration\" and modeID ~= 0 ) then\n\t\t\t\t\td(\"Opening new Exploration instance.\")\n\t\t\t\t\tPlayer:OpenInstance(modeID,0)\t\t\t\t\t\t\t\t\t\t\t\n\t\t\t\t\t\n\t\t\t\telseif ( nodedata.mode ~= nil and nodedata.mode == \"Story\" and modeID ~= 0 ) then\n\t\t\t\t\td(\"Opening new Story instance.\")\n\t\t\t\t\tPlayer:OpenInstance(modeID,0)\n\t\t\t\t\t\n\t\t\t\telse\n\t\t\t\t\tPlayer:OpenInstance()\n\t\t\t\t\td(\"Opening instance.\")\n\t\t\t\tend\n\t\t\t\t\n\t\t\telse\n\t\t\t\td(\"Joining Dungeon...\")\n\t\t\t\t\n\t\t\tend\t\n\t\t\tml_global_information.Wait(2000)\n\t\t\tself:success()\n\t\t\treturn\n\t\tend\n\tend\n\n\tif ( not ml_global_information.Player_IsMoving ) then\n\t\tPlayer:SetFacingH(nodedata.hx,nodedata.hy,nodedata.hz)\n\t\tPlayer:SetMovement(GW2.MOVEMENTTYPE.Forward)\n\tend\n\tself:success()\nelse\n\tself:fail()\nend",
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
				expanded = true,
				filename = "NavToMap.st",
				finishcode = "",
				info = "",
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
				runcode = "self:success()",
				startcode = "",
				xposoffset = 0,
			},
		},
	},
	variables = 
	{
		expanded = true,
		filename = "NavToMap.st",
		finishcode = "",
		info = "",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "context.movetomap_targetmapid = context.movetomap_targetmapid or self.variables.targetmapid\ncontext.movetomap_usewaypoints = context.movetomap_usewaypoints or self.variables.usewaypoints",
		startcode = "",
		subtreeuicode = "if(table.valid(gw2_datamanager.mapData)) then\n\tlocal maplist = {}\n\tlocal mapnamelist = {}\n\t\n\tfor mapID,map in pairs(gw2_datamanager.mapData) do\n\t\t\tif(ml_nav_manager.GetNode(mapID)) then\n\t\t\t\t\tlocal name = map.map_name..\" (\"..mapID..\")\"\n\t\t\t\t\ttable.insert(mapnamelist, name)\n\t\t\t\t\ttable.insert(maplist, {id = mapID, name = name})\n\t\t\tend\n\tend\n\ttable.sort(mapnamelist)\n\ttable.sort(maplist, function(a,b) return a.name < b.name end)\n\t\n\tlocal selectedIndex,changed = GUI:Combo(\"Select map\", self.variables.selectedmapindex or 1, mapnamelist)\n\tif(changed) then\n\t\t\tself.variables.selectedmapindex = selectedIndex\n\t\t\tself.variables.targetmapid = maplist[selectedIndex].id\n\tend\n\t\n\tlocal checked,pressed = GUI:Checkbox(\"Use waypoints\", self.variables.usewaypoints or false)\n\tif(pressed) then\n\t\t\tself.variables.usewaypoints = checked\n\tend\nelse\n\tGUI:Text(\"No map data available\")\nend\n",
		xposoffset = 0,
	},
}



return tbl