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
				filename = "blank",
				finishcode = "",
				info = "",
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
				runcode = "self:fail()",
				startcode = "",
				xposoffset = 0,
			},
		},
	},
	variables = 
	{
		expanded = true,
		filename = "blank.st",
		finishcode = "",
		info = "",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
		xposoffset = 0,
	},
}



return tbl