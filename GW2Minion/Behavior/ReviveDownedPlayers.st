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
					},
					variables = 
					{
						finishcode = "",
						info = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(Settings.GW2Minion.revivedownedplayers) then\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
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
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(not context.revive_targetid) then\n\tcontext.revivedownedplayer_id = nil\nend\n\nif(context.revivedownedplayer_id and ml_global_information.Player_Health.percent > 30) then\n\t\tlocal target = CharacterList:Get(context.revivedownedplayer_id)\n\t\tif(table.valid(target) and not target.alive and target.onmesh and target.interactable and target.selectable and target.pathdistance < 9999999) then\n\t\t\t\tcontext.revive_targetid = target.id\n\t\t\t\tcontext.revive_position = target.pos\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\nelseif((self.lastrevivecheck == nil or TimeSince(self.lastrevivecheck) > 15000) and ml_global_information.Player_Health.percent > 40) then\n\t\tself.lastrevivecheck = ml_global_information.Now\n\t\t\n\t\tlocal targetlowhealth = false\n\t\t\n\t\tlocal ptarget = Player:GetTarget()\n\t\tif(ptarget and ptarget.attackable and ptarget.health and ptarget.health.percent < 15) then\n\t\t\ttargetlowhealth = true\n\t\tend\n\t\t\n\t\tif(not targetlowhealth) then\n\t\t\t\tlocal CList = CharacterList(\"player,friendly,interactable,nearest,downed,onmesh,maxpathdistance=2500\")\n\t\t\t\tif(table.valid(CList)) then\n\t\t\t\t\t\tlocal _,target = next(CList)\n\t\t\t\t\t\tif(table.valid(target) and target.pathdistance < 9999999) then\n\t\t\t\t\t\t\t\tcontext.revivedownedplayer_id = target.id\n\t\t\t\t\t\t\t\tcontext.revivedownedplayer_pos = target.pos\n\t\t\t\t\t\t\t\tcontext.revive_targetid = target.id\n\t\t\t\t\t\t\t\tcontext.revive_position = target.pos\n\t\t\t\t\t\t\t\tself:success()\n\t\t\t\t\t\t\t\treturn\n\t\t\t\t\t\tend \n\t\t\t\tend\n\t\tend\nend\ncontext.revivedownedplayer_id = nil\ncontext.revivedownedplayer_pos = nil\nself:fail()",
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
					},
					variables = 
					{
						filename = "ReviveActionHandler.st",
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
		filename = "ReviveDownedPlayers.st",
		finishcode = "",
		info = "Revive downed players",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
	},
}



return tbl