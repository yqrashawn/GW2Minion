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
						runcode = "if(Settings.GW2Minion.revivepartymember) then\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
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
						info = "Finds a dead/downed Partymember and sets the id to the context.revive_partymemberid",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if (table.valid(ml_global_information.Player_Party)) then\n\tif(ml_global_information.Player_Health.percent > 35) then\n\t\t\tlocal nearest = nil\n\t\t\tlocal nearestdist = nil\n\t\t\t\n\t\t\tfor _,pMember in pairs(ml_global_information.Player_Party) do\n\t\t\t\t\tif(pMember.id ~= ml_global_information.Player_ID) then\n\t\t\t\t\t\t\tlocal target = CharacterList:Get(pMember.id)\n\t\t\t\t\t\t\tif (table.valid(target) and target.onmesh and (target.downed == true or target.dead == true) and target.pathdistance < 9999999) then\n\t\t\t\t\t\t\t\t\tlocal pdist = target.pathdistance\n\t\t\t\t\t\t\t\t\tif(nearest == nil or nearestdist > pdist) then\t\t\t\t\n\t\t\t\t\t\t\t\t\t\t\tif ( pdist > 0 and pdist < 2500) then\n\t\t\t\t\t\t\t\t\t\t\t\t\tnearestdist = pdist\n\t\t\t\t\t\t\t\t\t\t\t\t\tnearest = target\n\t\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\tend\n\t\t\t\t\tend\n\t\t\tend\n\t\t\t\n\t\t\tif(table.valid(nearest)) then\n\t\t\t\t\tcontext.revivepartymember_id = nearest.id\n\t\t\t\t\tcontext.revivepartymember_pos = nearest.pos\n\t\t\t\t\tself:success()\n\t\t\t\t\treturn\t\t\t\n\t\t\tend\n\tend\nend\ncontext.revivepartymember_id = nil\ncontext.revivepartymember_pos = nil\nself:fail()",
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
						runcode = "if(context.revivepartymember_id) then\n\t\tcontext.revive_targetid = context.revivepartymember_id\n\t\tcontext.revive_position = context.revivepartymember_pos\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
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
		filename = "RevivePartyMember.st",
		finishcode = "",
		info = "Revives a downed / dead Partymember.",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
	},
}



return tbl