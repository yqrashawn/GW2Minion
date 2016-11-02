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
						info = "Find Target and Set the aggro context.combat_targetid",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "local target = gw2_common_functions.GetBestCharacterTarget( 9999 ) \nif (table.valid(target) and not gw2_blacklistmanager.CheckBlacklistEntry(GetString(\"Monsters\"),target.contentid)) then\n\tlocal pdist = target.pathdistance\n\tif ( pdist < 9999999 ) then\n\t\tcontext.combat_targetid = target.id\n\t\tself:success()\n\t\treturn\n\telse\n\t\tgw2_blacklistmanager.AddBlacklistEntry(GetString(\"Monsters\"), target.contentid, target.name, ml_global_information.Now + 90000)\n\tend\nend\nself:fail()",
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
						filename = "CombatHandler.st",
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
				filename = "HandleAggro",
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
		filename = "AttackTargets.st",
		finishcode = "",
		info = "Find and Attack Enemies",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
	},
}



return tbl