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
						info = "Find Aggro Target and Set the aggro context.combat_targetid",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "local target = gw2_common_functions.GetBestAggroTarget()\nif (table.valid(target) and not gw2_blacklistmanager.CheckBlacklistEntry(GetString(\"monsters\"),target.contentID)) then\n\tlocal pdist = target.pathdistance\n\tif ( pdist > 0 ) then\n\t\tif(context.combat_targetid ~= target.id) then\n\t\t\t\tPlayer:StopMovement()\n\t\tend\n\t\tcontext.combat_targetid = target.id\n\t\tcontext.combat_moveintocombatrange = true\n\t\tself:success()\n\t\treturn\n\tend\nend\nself:fail()\n",
						startcode = "",
						xposoffset = 0,
					},
				},
				
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
								info = "Aggro CombatOverWatch - updates context.combat_target ",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
								runcode = "if ( context.combat_targetid ) then\n\tlocal target = CharacterList:Get(context.combat_targetid) or GadgetList:Get(context.combat_targetid)\n\tif (table.valid(target) and not gw2_blacklistmanager.CheckBlacklistEntry(GetString(\"monsters\"),target.contentID) and target.isAggro and target.attackable and target.alive and target.onmesh) then\n\t\tcontext.combat_target = target\n\t\tcontext.combat_targetid = target.id\n\t\tcontext.combat_targetpos = target.pos\n\n\t\t-- switch aggro target if a better one was found\n\t\tlocal bettertarget = gw2_common_functions.GetBestAggroTarget()\n\t\tif (table.valid(bettertarget) and bettertarget.id ~= target.id and not gw2_blacklistmanager.CheckBlacklistEntry(GetString(\"monsters\"),bettertarget.contentID)) then\n\t\t\tlocal pdist = target.pathdistance\n\t\t\tif ( pdist > 0 ) then\n\t\t\t\tcontext.combat_target = bettertarget\n\t\t\t\tcontext.combat_targetid = bettertarget.id\n\t\t\t\tcontext.combat_targetpos = bettertarget.pos\n\t\t\tend\n\t\tend\n\t\t\n\telse\n\t\td(\"[HandleAggro] - Aggro Target is dead or gone\")\n\t\tcontext.combat_targetid = nil\n\t\tcontext.combat_target = nil\n\t\tcontext.combat_targetpos = nil\n\tend\nend\nself:fail()",
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
						expanded = true,
						info = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.runningTask or 'None'))",
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
		filename = "HandleAggro.st",
		finishcode = "",
		info = "Handle Aggro",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
		xposoffset = 0,
	},
}



return tbl