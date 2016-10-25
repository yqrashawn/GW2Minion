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
			settings = 
			{
				xposoffset = 0,
			},
			variables = 
			{
				finishcode = "",
				info = "",
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
				runcode = "if(type(context.wait_duration) == \"number\") then\n\t\tcontext.wait_start = context.wait_start or ml_global_information.Now\n\t\tcontext.wait_elapsed = math.ceil(TimeSince(context.wait_start)/1000)\n\t\tif(TimeSince(context.wait_start) < context.wait_duration*1000) then\n\t\t\t\tself:running()\n\t\t\t\treturn\n\t\tend\nend\nself:fail()",
				startcode = "",
			},
		},
	},
	settings = 
	{
	},
	variables = 
	{
		filename = "Wait.st",
		finishcode = "",
		info = "",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "context.wait_duration = self.settings.duration",
		startcode = "",
		subtreeuicode = "self.settings.duration = GUI:InputInt(\"Duration (s)\", self.settings.duration or 0)",
	},
}



return tbl