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
				filename = "tm_HeartQuest",
				finishcode = "",
				info = "",
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
				runcode = "d(\"A heartquest task requires subtasks\")\nself:fail()",
				startcode = "",
			},
		},
	},
	settings = 
	{
	},
	variables = 
	{
		filename = "tm_HeartQuest.st",
		finishcode = "",
		info = "",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "",
		subtreeuicode = "self.settings.hqid = self.settings.hqid or 0\n\nself.settings.hqid = GUI:InputInt(\"Region id##tmhq\", self.settings.hqid)\n\nif(GUI:Button(\"Update region id##tmhq\")) then\n\t\tlocal MList = MapMarkerList(\"nearest,issubregion\")\n\t\tif(table.valid(MList)) then\n\t\t\t\t\tlocal _,marker = next(MList)\n\t\t\t\t\t\tif(table.valid(marker)) then\n\t\t\t\t\t\t\t\tself.settings.hqid = marker.subregionid\n\t\t\t\t\t\tend\n\t\tend\nend",
	},
}



return tbl