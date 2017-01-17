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
						info = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(table.valid(context.combat_targets)) then\n\t\tlocal characterfilter = \"\"\n\t\tlocal gadgetfilter = \"\"\n\n\t\tfor _,target in pairs(context.combat_targets) do\n\t\t\t\tif(target.character) then\n\t\t\t\t\t\tcharacterfilter = target.contentid..\";\"..characterfilter\n\t\t\t\telse\n\t\t\t\t\t\tgadgetfilter = target.contentid..\";\"..gadgetfilter\n\t\t\t\tend\n\t\tend\n\t\t\n\t\tlocal mergedList = {}\n\n\t\tif(string.valid(characterfilter)) then\n\t\t\t\tlocal CList = CharacterList(\"onmesh,nearest,attackable,contentid=\"..characterfilter..gw2_blacklistmanager.GetMonsterExcludeString())\n\t\t\t\tif(table.valid(CList)) then\n\t\t\t\t\t\tlocal _,target = next(CList)\n\t\t\t\t\t\tif(table.valid(target)) then\n\t\t\t\t\t\t\t\t\n\t\t\t\t\t\t\t\tif(target.pathdistance < 99999 and (target.alive or target.downed)) then\n\t\t\t\t\t\t\t\t\ttable.insert(mergedList, target)\n\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\t\tgw2_blacklistmanager.AddBlacklistEntry(GetString(\"Temporary Combat\"), target.id, target.name, 5000)\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\tend\n\t\t\t\tend\n\t\tend\n\n\t\tif(string.valid(gadgetfilter)) then\n\t\t\t\tlocal GList = GadgetList(\"onmesh,nearest,attackable,alive,contentid=\"..gadgetfilter..gw2_blacklistmanager.GetMonsterExcludeString())\n\t\t\t\tif(table.valid(GList)) then\n\t\t\t\t\t\tlocal _,target = next(GList)\n\t\t\t\t\t\tif(table.valid(target)) then\n\t\t\t\t\t\t\t\tif(target.pathdistance < 99999) then\n\t\t\t\t\t\t\t\t\t\ttable.insert(mergedList, target)\n\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\t\tgw2_blacklistmanager.AddBlacklistEntry(GetString(\"Temporary Combat\"), target.id, target.name, 5000)\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\tend\n\t\t\t\tend\t\t\n\t\tend\n\t\t\n\t\tif(table.valid(mergedList)) then\n\t\t\t\ttable.sort(mergedList, function(a,b) return a.pathdistance < b.pathdistance end)\n\t\t\t\t\n\t\t\t\tlocal _,target = next(mergedList)\n\t\t\t\tif(table.valid(target)) then\n\t\t\t\t\t\tcontext.combat_targetid = target.id\n\t\t\t\t\t\tcontext.combat_targetpos = target.pos\n\t\t\t\t\t\tself:success()\n\t\t\t\t\t\treturn\t\t\t\t\n\t\t\t\tend\n\t\tend\nend\nself:fail()",
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
		filename = "tm_CombatHandler.st",
		finishcode = "",
		info = "TM Combat subtask",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "context.combat_targets = self.settings.targets ",
		startcode = "",
		subtreeuicode = "local targets = self.settings.targets or {}\nlocal changed = false\n\nif(table.valid(targets)) then\n\t\tfor i,target in pairs(targets) do\n\t\t\t\tGUI:InputInt(\"ContentID##tmcombat\"..i,target.contentid)\n\t\t\t\tif(GUI:IsItemHovered()) then\n\t\t\t\t\t\tGUI:SetTooltip(target.name or \"Unknown\")\n\t\t\t\tend\n\t\t\t\tGUI:SameLine()\n\t\t\t\tif(GUI:Button(\"Delete##tmcombat\"..i)) then\n\t\t\t\t\t\ttable.remove(targets,i)\n\t\t\t\t\t\tchanged = true\n\t\t\t\tend\n\t\tend\nend\n\nif(GUI:Button(\"Add target##tmcombat\")) then\n\t\tlocal target = Player:GetTarget()\n\t\tif(table.valid(target) and (target.ischaracter or target.isgadget)) then\n\t\t\t\ttable.insert(targets, {contentid = target.contentid; name = target.name; gadget = target.isgadget; character = target.ischaracter})\n\t\t\t\tchanged = true\n\t\telse\n\t\t\t\td(\"No target (character or gadget) selected\")\n\t\tend\nend\n\nif(changed) then\n\t\tself.settings.targets = targets\nend",
	},
}



return tbl