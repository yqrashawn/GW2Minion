local tbl = 
{
	class = "BehaviorTree",
	nodes = 
	{
		
		{
			class = "Action",
			nodes = 
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
				xposoffset = 0,
			},
		},
	},
	variables = 
	{
		expanded = true,
		filename = "tm_HeartQuest.st",
		finishcode = "",
		hqid = 0,
		info = "",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "",
		subtreeuicode = "self.variables.hqid = self.variables.hqid or 0\n\nself.variables.hqid = GUI:InputInt(\"Region id##tmhq\", self.variables.hqid)\n\nif(GUI:Button(\"Update region id##tmhq\")) then\n\t\tlocal MList = MapMarkerList(\"nearest,issubregion\")\n\t\tif(table.valid(MList)) then\n\t\t\t\t\tlocal _,marker = next(MList)\n\t\t\t\t\t\tif(table.valid(marker)) then\n\t\t\t\t\t\t\t\tself.variables.hqid = marker.subregionid\n\t\t\t\t\t\tend\n\t\tend\nend",
		xposoffset = 0,
	},
}



return tbl