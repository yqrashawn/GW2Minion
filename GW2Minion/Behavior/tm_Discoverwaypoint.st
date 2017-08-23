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
				finishcode = "",
				info = "",
				interruptcode = "",
				monitorcode = "",
				runcode = "self:success()",
				startcode = "",
			},
		},
	},
	settings = 
	{
	},
	variables = 
	{
		filename = "tm_Discoverwaypoint.st",
		finishcode = "",
		info = "",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "context.waypoint_id = self.settings.waypointid",
		startcode = "",
		subtreeuicode = "self.settings.waypointid = GUI:InputInt(\"Waypoint id\", self.settings.waypointid or 0, 0)\n\nif(self.settings.waypointid) then\n\t\tlocal wp = WaypointList:Get(self.settings.waypointid)\n\t\tif(table.valid(wp) and wp.distance) then\n\t\t\t\tGUI:Text(\"Distance to waypoint \" .. tostring(math.round(wp.distance,2)))\n\t\t\t\tif(not wp.onmesh or wp.pathdistance > 999999) then\n\t\t\t\t\t\tGUI:Text(\"Waypoint not on mesh or no valid path found\")\n\t\t\t\tend\n\t\telse\n\t\t\t\tGUI:Text(\"Waypoint not found, are you in the right map?\")\n\t\tend\nend\n\nif(GUI:Button(\"Select nearest waypoint\")) then\n\t\tlocal WPList = WaypointList(\"nearest\")\n\n\t\tif(table.valid(WPList)) then\n\t\t\t\tlocal _,wp = next(WPList)\n\t\t\t\tif(wp) then self.settings.waypointid = wp.id end\n\t\telse\n\t\t\t\tGUI:Text(\"No waypoint found\")\n\t\tend\nend",
	},
}



return tbl