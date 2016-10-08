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
						info = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(Settings.GW2Minion.revivenpcs) then\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
						startcode = "",
						xposoffset = 0,
					},
				},
				
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
						runcode = "if(context.revivenpc_id and ml_global_information.Player_Health.percent > 20) then\n\t\tlocal target = CharacterList:Get(context.revivenpc_id)\n\t\tif(table.valid(target) and not target.alive and target.onmesh and target.interactable) then\n\t\t\t\tcontext.revive_targetid = target.id\n\t\t\t\tcontext.revive_position = target.pos\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\nelseif((self.lastrevivecheck == nil or TimeSince(self.lastrevivecheck) > 15000) and ml_global_information.Player_Health.percent > 40) then\n\t\tself.lastrevivecheck = ml_global_information.Now\n\t\tlocal CList = CharacterList(\"friendly,npc,interactable,nearest,dead,onmesh,maxpathdistance=2000\")\n\t\tif(table.valid(CList)) then\n\t\t\t\tlocal _,target = next(CList)\n\t\t\t\tif(table.valid(target)) then\n\t\t\t\t\t\tcontext.revivenpc_id = target.id\n\t\t\t\t\t\tcontext.revivenpc_pos = target.pos\n\t\t\t\t\t\tcontext.revive_targetid = target.id\n\t\t\t\t\t\tcontext.revive_position = target.pos\n\t\t\t\t\t\tself:success()\n\t\t\t\t\t\treturn\n\t\t\t\tend\n\t\tend\nend\ncontext.revivenpc_id = nil\ncontext.revivenpc_pos = nil\nself:fail()",
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
						filename = "ReviveActionHandler.st",
						finishcode = "",
						info = "Revive action\ncontext.revive_position\ncontext.revive_targetid",
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
				info = "",
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.actualTask or 'None'))",
				xposoffset = 0,
			},
		},
	},
	variables = 
	{
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
}



return tbl