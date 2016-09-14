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
					variables = 
					{
						finishcode = "",
						info = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "-- Reset targets when priority changes\nif(not context.revive_targetid) then\n\t\tcontext.revivepartymember_id = nil\n\t\tcontext.revivedownedplayer_id = nil\n\t\tcontext.revivedeadplayer_id = nil\n\t\tcontext.revivenpc_id = nil\nend\n\nif(context.revivepartymember_id) then\n\t\tcontext.revivedownedplayer_id = nil\n\t\tcontext.revivedeadplayer_id = nil\n\t\tcontext.revivenpc_id = nil\nend\n\nif(context.revivedownedplayer_id) then\n\t\tcontext.revivedeadplayer_id = nil\n\t\tcontext.revivenpc_id = nil\nend\n\nif(context.revivedeadplayer_id) then\n\t\tcontext.revivenpc_id = nil\nend\n\nself:fail()",
						startcode = "",
						xposoffset = 0,
					},
				},
				
				{
					class = "BehaviorTree",
					nodes = 
					{
					},
					variables = 
					{
						filename = "RevivePartyMember.st",
						finishcode = "",
						info = "Revives a downed / dead Partymember.",
						menucode = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
						runcode = "",
						startcode = "",
						subtreeuicode = "",
						xposoffset = 0,
					},
				},
				
				{
					class = "BehaviorTree",
					nodes = 
					{
					},
					variables = 
					{
						filename = "ReviveDownedPlayers.st",
						finishcode = "",
						info = "Revive downed players",
						menucode = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
						runcode = "",
						startcode = "",
						subtreeuicode = "",
						xposoffset = 0,
					},
				},
				
				{
					class = "BehaviorTree",
					nodes = 
					{
					},
					variables = 
					{
						filename = "ReviveDeadPlayers.st",
						finishcode = "",
						info = "Revive dead players",
						menucode = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
						runcode = "",
						startcode = "",
						subtreeuicode = "",
						xposoffset = 0,
					},
				},
				
				{
					class = "BehaviorTree",
					nodes = 
					{
					},
					variables = 
					{
						expanded = true,
						filename = "ReviveNPC.st",
						finishcode = "",
						info = "Revive dead NPCs",
						menucode = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
						runcode = "",
						startcode = "",
						subtreeuicode = "",
						xposoffset = 0,
					},
				},
			},
			variables = 
			{
				expanded = true,
				info = "",
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.runningTask or 'None'))",
				xposoffset = 0,
			},
		},
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
		xposoffset = 0,
	},
}



return tbl