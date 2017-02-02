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
						runcode = "if(table.valid(context.combat_targets)) then\n\t\tlocal targets = {}\n\t\t\n\t\tlocal mergedList = gw2_common_functions.GetAllTargets(\"attackable\"..gw2_blacklistmanager.GetMonsterExcludeString())\n\t\t\n\t\tif(table.valid(mergedList)) then\n\t\t\t\tfor _,target in pairs(mergedList) do\n\t\t\t\t\t\tfor _,targetinfo in pairs(context.combat_targets) do\n\t\t\t\t\t\t\t\tif(targetinfo.contentid == target.contentid) then\n\t\t\t\t\t\t\t\t\t\tif(target.pathdistance < 99999) then\n\t\t\t\t\t\t\t\t\t\t\t\tif(targetinfo.character and (target.alive or target.downed)) then\n\t\t\t\t\t\t\t\t\t\t\t\t\t\ttable.insert(targets, target)\n\t\t\t\t\t\t\t\t\t\t\t\telseif(targetinfo.gadget and target.alive) then\n\t\t\t\t\t\t\t\t\t\t\t\t\t\ttable.insert(targets, target)\n\t\t\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\t\t\t\tgw2_blacklistmanager.AddBlacklistEntry(GetString(\"Temporary Combat\"), target.id, target.name, 5000)\n\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\tend\n\t\t\t\tend\n\t\tend\n\n\t\tif(table.valid(targets)) then\n\t\t\t\ttable.sort(targets, function(a,b) return a.pathdistance < b.pathdistance end)\n\t\t\t\t\n\t\t\t\tlocal _,target = next(targets)\n\t\t\t\tif(table.valid(target)) then\n\t\t\t\t\t\tcontext.combat_targetid = target.id\n\t\t\t\t\t\tcontext.combat_targetpos = target.pos\n\t\t\t\t\t\tcontext.combat_moveintocombatrange = true\n\t\t\t\t\t\tself:success()\n\t\t\t\t\t\treturn\t\t\t\t\n\t\t\t\tend\n\t\tend\nend\nself:fail()",
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
		subtreeuicode = "local targets = self.settings.targets or {}\nlocal changed = false\n\nif(table.valid(targets)) then\n\t\tGUI:Separator()\n\t\tGUI:Columns(3)\n\t\tGUI:Text(GetString(\"Name\")) GUI:NextColumn()\n\t\tGUI:Text(GetString(\"ContentID\")) GUI:NextColumn() GUI:NextColumn()\n\n\t\tfor i,target in pairs(targets) do\n\t\t\t\tGUI:Separator()\n\t\t\t\tGUI:Text(string.valid(target.name) and target.name or \"unknown\") GUI:NextColumn()\n\t\t\t\tGUI:Text(target.contentid) GUI:NextColumn()\n\n\t\t\t\tif(GUI:Button(\"Delete##tmcombat\"..i)) then\n\t\t\t\t\t\ttable.remove(targets,i)\n\t\t\t\t\t\tchanged = true\n\t\t\t\tend\n\t\t\t\tGUI:NextColumn()\n\t\tend\n\t\tGUI:Columns(1)\n\t\tGUI:Separator()\nend\n\nlocal target = Player:GetTarget()\nif(not table.valid(target)) then\n\t\tGUI:Text(GetString(\"No target selected\"))\nelseif(not target.ischaracter and not target.isgadget) then\n\t\tGUI:Text(GetString(\"Target is not a character or a gadget\"))\nelse\n\t\tif(GUI:Button(\"Add target##tmcombat\")) then\n\t\t\n\t\t\t\tif(table.valid(target) and (target.ischaracter or target.isgadget)) then\n\t\t\t\t\t\tlocal add = true\n\t\t\t\t\t\tfor _,storedtarget in pairs(targets) do\n\t\t\t\t\t\t\t\tif(storedtarget.contentid == target.contentid) then\n\t\t\t\t\t\t\t\t\t\tadd = false\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\tend\n\n\t\t\t\t\t\tif(add) then\n\t\t\t\t\t\t\t\ttable.insert(targets, {contentid = target.contentid; name = target.name; gadget = target.isgadget; character = target.ischaracter})\n\t\t\t\t\t\t\t\tchanged = true\n\t\t\t\t\t\tend\n\t\t\t\telse\n\t\t\t\t\t\td(\"No target (character or gadget) selected\")\n\t\t\t\tend\n\t\tend\nend\n\nif(changed) then\n\t\tself.settings.targets = targets\nend",
	},
}



return tbl