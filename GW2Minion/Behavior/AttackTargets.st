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
						info = "Find Target and Set the aggro context.combat_targetid",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "local target = gw2_common_functions.GetBestCharacterTarget( 9999 ) \nif ( table.valid( target ) and not gw2_blacklistmanager.CheckBlacklistEntry(GetString(\"Monsters\"),target.contentid) and not gw2_blacklistmanager.CheckBlacklistEntry(GetString(\"Temporary Combat\"),target.id)) then\n\tlocal pdist = target.pathdistance\n\tif ( pdist < 9999999 ) then\n\t\tcontext.combat_targetid = target.id\n\t\tcontext.combat_targetpos = target.pos\n\t\tcontext.combat_moveintocombatrange = true\n\t\tself:success()\n\t\treturn\n\telse\n\t\td(\"[AttackTargets]: No valid pathdistance. Blacklisting.\")\n\t\tgw2_blacklistmanager.AddBlacklistEntry(GetString(\"Temporary Combat\"), target.id, target.name, 5000)\n\tend\nend\nself:fail()",
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
						filename = "CombatHandler.st",
					},
				},
			},
			settings = 
			{
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
		subtreeuicode = "if ( self.settings.priorizeplayers == nil ) then self.settings.priorizeplayers = false end\nself.settings.priorizeplayers = GUI:Checkbox( \"Attack Players\", self.settings.priorizeplayers )",
	},
}



return tbl