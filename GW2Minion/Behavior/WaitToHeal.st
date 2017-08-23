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
						finishcode = "",
						info = "",
						interruptcode = "",
						monitorcode = "",
						runcode = "if(not ml_global_information.Player_InCombat) then\n\t\tself:success()\nelse\n\t\tcontext.waittoheal_starttime = nil\n\t\tself:fail()\nend",
						startcode = "",
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
						interruptcode = "",
						monitorcode = "",
						runcode = "if(context.waittoheal_starttime == nil or TimeSince(context.waittoheal_starttime) < 20000) then\n\t\tself:success()\nelse\n\t\tcontext.waittoheal_starttime = nil\n\t\tself:fail()\nend",
						startcode = "",
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
						interruptcode = "",
						monitorcode = "",
						runcode = "context.waittoheal_starttime = context.waittoheal_starttime or ml_global_information.Now\n\nif(ml_global_information.Player_Health.percent < context.waittoheal_minhp) then\n\t\t-- If necro check for deathshroud.\n\t\tgw2_common_functions.NecroLeaveDeathshroud()\n\n\t\t-- Stop Player movement.\n\t\tif ( ml_global_information.Player_IsMoving ) then Player:StopMovement() end\n\n\t\tself:success()\nelse\n\t\tcontext.waittoheal_starttime = nil\n\t\tcontext.waittoheal_minhp = nil\n\t\tself:fail()\nend",
						startcode = "",
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
		filename = "WaitToHeal.st",
		finishcode = "",
		info = "",
		interruptcode = "",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "context.waittoheal_minhp = context.waittoheal_minhp or math.random(70,85)",
		subtreeuicode = "",
	},
}



return tbl