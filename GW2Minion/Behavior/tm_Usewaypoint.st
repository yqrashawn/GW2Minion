local tbl = 
{
	class = "SubTree",
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
				filename = "tm_Usewaypoint",
				finishcode = "",
				info = "",
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
				runcode = "if(context.usewaypoint_id and context.usewaypoint_id > 0) then\n\t\tlocal wp = WaypointList:Get(context.usewaypoint_id)\n\t\t\n\t\tif(table.valid(wp)) then\n\t\t\t\tif(Inventory:GetInventoryMoney() > (139*math.log10(ml_global_information.Player_Level))*2) then\n\t\t\t\t\t\tif(wp.distance > 250 and Player:TeleportToWaypoint(context.usewaypoint_id)) then\n\t\t\t\t\t\t\t\tself:success()\n\t\t\t\t\t\t\t\treturn\n\t\t\t\t\t\tend\n\t\t\t\telse\n\t\t\t\t\t\td(\"[UseWaypoint]: Not enough gold\")\n\t\t\t\tend\n\t\tend\nend\nself:fail()",
				startcode = "",
			},
		},
	},
	settings = 
	{
	},
	variables = 
	{
		filename = "tm_Usewaypoint.st",
		finishcode = "",
		info = "",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "context.usewaypoint_id = self.settings.waypointid",
		startcode = "",
		subtreeuicode = "self.settings.waypointid = GUI:InputInt(\"Waypoint ID\", self.settings.waypointid or 0)\n\nif(GUI:Button(\"Select nearest\")) then\n\t\tlocal WPList = WaypointList(\"onmesh,nearest\")\n\t\tif(table.valid(WPList)) then\n\t\t\t\tlocal _,wp = next(WPList)\n\t\t\t\tif(table.valid(wp)) then\n\t\t\t\t\t\tself.settings.waypointid = wp.id\n\t\t\t\tend\n\t\telse\n\t\t\t\td(\"No waypoints found\")\n\t\tend\nend",
	},
}



return tbl