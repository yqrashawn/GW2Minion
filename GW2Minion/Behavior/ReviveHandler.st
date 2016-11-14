local tbl = 
{
	class = "BehaviorTree",
	nodes = 
	{
		
		{
			class = "PrioritySelector",
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
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "-- Reset targets when priority changes\nif(not context.revive_targetid) then\n\t\tcontext.revivepartymember_id = nil\n\t\tcontext.revivedownedplayer_id = nil\n\t\tcontext.revivedeadplayer_id = nil\n\t\tcontext.revivenpc_id = nil\nend\n\nif(context.revivepartymember_id) then\n\t\tcontext.revivedownedplayer_id = nil\n\t\tcontext.revivedeadplayer_id = nil\n\t\tcontext.revivenpc_id = nil\nend\n\nif(context.revivedownedplayer_id) then\n\t\tcontext.revivedeadplayer_id = nil\n\t\tcontext.revivenpc_id = nil\nend\n\nif(context.revivedeadplayer_id) then\n\t\tcontext.revivenpc_id = nil\nend\n\nself:fail()",
						startcode = "",
					},
				},
				
				{
					class = "BehaviorTree",
					nodes = 
					{
					},
					settings = 
					{
					},
					variables = 
					{
						filename = "RevivePartyMember.st",
					},
				},
				
				{
					class = "BehaviorTree",
					nodes = 
					{
					},
					settings = 
					{
					},
					variables = 
					{
						filename = "ReviveDownedPlayers.st",
					},
				},
				
				{
					class = "BehaviorTree",
					nodes = 
					{
					},
					settings = 
					{
					},
					variables = 
					{
						filename = "ReviveDeadPlayers.st",
					},
				},
				
				{
					class = "BehaviorTree",
					nodes = 
					{
					},
					settings = 
					{
					},
					variables = 
					{
						filename = "ReviveNPC.st",
					},
				},
			},
			settings = 
			{
			},
			variables = 
			{
				info = "",
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.runningTask or 'None'))",
			},
		},
	},
	settings = 
	{
	},
	variables = 
	{
		filename = "ReviveHandler.st",
		finishcode = "",
		info = "Revive dead/downed players/partymembers/npcs",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
	},
}



return tbl