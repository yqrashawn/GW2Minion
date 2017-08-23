local tbl = 
{
	class = "SubTree",
	nodes = 
	{
		
		{
			class = "SubTree",
			nodes = 
			{
			},
			settings = 
			{
			},
			variables = 
			{
				filename = "Buy.st",
			},
		},
	},
	settings = 
	{
	},
	variables = 
	{
		filename = "tm_Buy.st",
		finishcode = "",
		info = "",
		interruptcode = "",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "context.buy_nearby = true",
		startcode = "",
		subtreeuicode = "GUI:TextWrapped(\"Set the start position of the task close to the vendor you want to buy from\")\nGUI:Text(\"This task uses the buy manager settings\")",
	},
}



return tbl