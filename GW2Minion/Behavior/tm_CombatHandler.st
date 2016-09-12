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
						runcode = "if(table.valid(context.combat_targets)) then\n\t\tlocal characterfilter = \"\"\n\t\tlocal gadgetfilter = \"\"\n\t\td(\"Aaaaa\")\n\t\tfor _,target in pairs(context.combat_targets) do\n\t\t\t\tif(target.character) then\n\t\t\t\t\t\tcharacterfilter = target.contentid..\";\"..characterfilter\n\t\t\t\telse\n\t\t\t\t\t\tgadgetfilter = target.contentid..\";\"..gadgetfilter\n\t\t\t\tend\n\t\tend\n\t\t\n\t\tif(string.valid(characterfilter)) then\n\t\t\t\tlocal CList = CharacterList(\"onmesh,nearest,attackable,contentid=\"..characterfilter)\n\t\t\t\tif(table.valid(CList)) then\n\t\t\t\t\t\tlocal _,target = next(CList)\n\t\t\t\t\t\tif(table.valid(target) and (target.alive or target.downed)) then\n\t\t\t\t\t\t\t\tcontext.combat_targetid = target.id\n\t\t\t\t\t\t\t\tcontext.combat_target = target\n\t\t\t\t\t\t\t\tself:success()\n\t\t\t\t\t\t\t\treturn\n\t\t\t\t\t\tend\n\t\t\t\tend\n\t\tend\n\n\t\tif(string.valid(gadgetfilter)) then\n\t\t\t\tlocal GList = GadgetList(\"onmesh,nearest,attackable,alive,contentid=\"..gadgetfilter)\n\t\t\t\tif(table.valid(GList)) then\n\t\t\t\t\t\tlocal _,target = next(GList)\n\t\t\t\t\t\tif(table.valid(target)) then\n\t\t\t\t\t\t\t\tcontext.combat_targetid = target.id\n\t\t\t\t\t\t\t\tcontext.combat_target = target\n\t\t\t\t\t\t\t\tself:success()\n\t\t\t\t\t\t\t\treturn\n\t\t\t\t\t\tend\n\t\t\t\tend\t\t\n\t\tend\nend\nself:fail()",
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
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.actualTask or 'None'))",
				xposoffset = 0,
			},
		},
	},
	variables = 
	{
		expanded = true,
		filename = "tm_CombatHandler.st",
		finishcode = "",
		info = "TM Combat subtask",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "context.combat_targets = self.variables.targets ",
		startcode = "",
		subtreeuicode = "local targets = self.variables.targets or {}\nlocal changed = false\n\nif(table.valid(targets)) then\n\t\tfor i,target in pairs(targets) do\n\t\t\t\tGUI:InputInt(\"ContentID##tmcombat\"..i,target.contentid)\n\t\t\t\tif(GUI:IsItemHovered()) then\n\t\t\t\t\t\tGUI:SetTooltip(target.name or \"Unknown\")\n\t\t\t\tend\n\t\t\t\tGUI:SameLine()\n\t\t\t\tif(GUI:Button(\"Delete##tmcombat\"..i)) then\n\t\t\t\t\t\ttable.remove(targets,i)\n\t\t\t\t\t\tchanged = true\n\t\t\t\tend\n\t\tend\nend\n\nif(GUI:Button(\"Add target##tmcombat\")) then\n\t\tlocal target = Player:GetTarget()\n\t\tif(table.valid(target)) then\n\t\t\t\ttable.insert(targets, {contentid = target.contentid; name = target.name; gadget = target.isgadget; character = target.ischaracter})\n\t\t\t\tchanged = true\n\t\telse\n\t\t\t\td(\"No target selected\")\n\t\tend\nend\n\nif(changed) then\n\t\tself.variables.targets = targets\nend",
		targets = 
		{
		},
		xposoffset = 0,
	},
}



return tbl