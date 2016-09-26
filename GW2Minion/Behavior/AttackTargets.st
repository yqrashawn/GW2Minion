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
					variables = 
					{
						finishcode = "",
						info = "Find Target and Set the aggro context.combat_targetid",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "local target = gw2_common_functions.GetBestCharacterTarget( 9999 ) \nif (ValidTable(target) and not ml_blacklist.CheckBlacklistEntry(GetString(\"monsters\"),target.contentID)) then\n\tlocal pdist = target.pathdistance\n\tif ( pdist > 0 ) then\n\t\tcontext.combat_targetid = target.id\n\t\tself:success()\n\t\treturn\n\tend\nend\nself:fail()",
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
						expanded = true,
						filename = "CombatHandler.st",
						finishcode = "",
						info = "Handle combat\ncontext.combat_targetid\ncontext.combat_target",
						menucode = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
						moveintocombatrange = true,
						runcode = "context.combat_moveintocombatrange = context.combat_moveintocombatrange == nil and true or context.combat_moveintocombatrange",
						startcode = "",
						subtreeuicode = "",
						xposoffset = 0,
					},
				},
			},
			variables = 
			{
				filename = "HandleAggro",
				info = "",
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.actualTask or 'None'))",
				xposoffset = 0,
			},
		},
	},
	variables = 
	{
		filename = "AttackTargets.st",
		finishcode = "",
		info = "Find and Attack Enemies",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
		xposoffset = 0,
	},
}



return tbl