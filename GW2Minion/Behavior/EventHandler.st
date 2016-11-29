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
						filename = "",
						finishcode = "",
						info = "",
						menucode = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(context.doevents) then\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
						startcode = "",
						subtreeuicode = "",
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
						info = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "local EList = MapMarkerList(\"nearest,isevent,onmesh,maxpathdistance=999999,exclude_eventid=\"..gw2_blacklistmanager.GetExcludeString(GetString(\"Event\")))\nif(table.valid(EList)) then\n\t\tlocal _,event = next(EList)\n\t\tif(table.valid(event)) then\n\t\t\t\tif(table.valid(event.eventinfo)) then\n\t\t\t\t\t\tif(event.eventinfo.level < ml_global_information.Player_Level+2) then\n\t\t\t\t\t\t\t\tcontext.event_id = event.eventid\n\t\t\t\t\t\t\t\tcontext.event_reached = false\n\t\t\t\t\t\t\t\tcontext.event_inradius = false\n\t\t\t\t\t\t\t\tself:success()\n\t\t\t\t\t\t\t\treturn\n\t\t\t\t\t\tend\n\t\t\t\t\t\td(\"[Event]: Current event is above level range.\")\n\t\t\t\t\t\tgw2_blacklistmanager.AddBlacklistEntry(GetString(\"Event\"), event.eventid, event.name or \"Unknown event\", ml_global_information.Now + 1500000)\n\t\t\t\telse\n\t\t\t\t\tgw2_blacklistmanager.AddBlacklistEntry(GetString(\"Event\"), event.eventid, event.name or \"Unknown event\", ml_global_information.Now + 1500000)\n\t\t\t\tend\n\t\tend\nend\n\nself:fail()",
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
						maxduration = 900,
					},
					variables = 
					{
						filename = "Event.st",
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
		filename = "EventHandler.st",
		finishcode = "context.event_id = nil\ncontext.event_reached = false\ncontext.event_marker = nil\n",
		info = "EventHandler",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)\nif (context) then\n\tGUI:Text(\"Event ID: \"..tostring(context.event_id or 0))\n\tGUI:Text(\"Event Reaced: \"..tostring(context.event_reached or false))\n\tGUI:Text(\"Event MaxDuration: \"..tostring(context.event_maxduration or 0))\n\n\tif(context.event_start) then\n\t\t\tGUI:Text(\"Time remaining: \" .. tostring(math.ceil(900-(TimeSince(context.event_start)/1000))))\n\telse\n\t\tGUI:Text(\"No event start time set\")\n\tend\nend",
		runcode = "context.doevents = self.settings.doevents == nil and Settings.GW2Minion.doevents or self.settings.doevents",
		startcode = "",
		subtreeuicode = "",
	},
}



return tbl