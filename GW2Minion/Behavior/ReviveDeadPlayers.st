local tbl = 
{
	class = "BehaviorTree",
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
						xposoffset = 0,
					},
					variables = 
					{
						finishcode = "",
						info = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(Settings.GW2Minion.revivedeadplayers) then\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
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
						xposoffset = 0,
					},
					variables = 
					{
						finishcode = "",
						info = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(context.revivedeadplayer_id and ml_global_information.Player_Health.percent > 30) then\n\t\tlocal target = CharacterList:Get(context.revivedeadplayer_id)\n\t\tif(table.valid(target) and not target.alive and target.onmesh and target.interactable and target.pathdistance < 9999999) then\n\t\t\t\tcontext.revive_targetid = target.id\n\t\t\t\tcontext.revive_position = target.pos\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\nelseif((self.lastrevivecheck == nil or TimeSince(self.lastrevivecheck) > 15000) and ml_global_information.Player_Health.percent > 40) then\n\t\tself.lastrevivecheck = ml_global_information.Now\n\t\tlocal CList = CharacterList(\"player,friendly,interactable,nearest,dead,onmesh,maxpathdistance=2000\")\n\t\tif(table.valid(CList)) then\n\t\t\t\tlocal _,target = next(CList)\n\t\t\t\tif(table.valid(target)) then\n\t\t\t\t\t\tcontext.revivedeadplayer_id = target.id\n\t\t\t\t\t\tcontext.revivedeadplayer_pos = target.pos\n\t\t\t\t\t\tcontext.revive_targetid = target.id\n\t\t\t\t\t\tcontext.revive_position = target.pos\n\t\t\t\t\t\tself:success()\n\t\t\t\t\t\treturn \n\t\t\t\tend\n\t\tend\nend\ncontext.revivedeadplayer_id = nil\ncontext.revivedeadplayer_pos = nil\nself:fail()",
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
						expanded = true,
						xposoffset = 0,
					},
					variables = 
					{
						filename = "ReviveActionHandler.st",
					},
				},
			},
			settings = 
			{
				expanded = true,
				xposoffset = 0,
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
		filename = "ReviveDeadPlayers.st",
		finishcode = "",
		info = "Revive dead players",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
	},
}



return tbl