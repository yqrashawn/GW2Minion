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
						info = "Set up skill to use",
						monitorcode = "",
						runcode = "context.skill = {}\ncontext.spellinfo = {}\nif(table.valid(context.useskills)) then\n\t\tlocal validskills = {}\n\t\tfor _,skill in pairs(context.useskills) do\n\t\t\t\tif(skill.skillslot) then\n\t\t\t\t\t\tlocal b = Player:GetSpellInfo(skill.skillslot)\n\t\t\t\t\t\tif(b and b.skillid == skill.skillid) then\n\t\t\t\t\t\t\t\ttable.insert(validskills, {spellinfo = b, skill = skill})\n\t\t\t\t\t\tend\n\t\t\t\tend\n\t\tend\n\t\t\n\t\tif(table.valid(validskills)) then\n\t\t\t\ttable.sort(validskills, function(a,b) return a.spellinfo.cooldown < b.spellinfo.cooldown end)\n\t\t\t\tlocal _,skill = next(validskills)\n\t\t\t\tif(skill) then\n\t\t\t\t\t\tcontext.skill = skill.skill\n\t\t\t\t\t\tcontext.spellinfo = skill.spellinfo\n\t\t\t\tend\n\t\tend\t\t\n\n\t\tif(table.valid(context.skill)) then\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\nelse\n\t\td(\"[tm_UseSkill]: No skills added to task.\")\nend\n\nself:fail()",
						startcode = "",
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
							settings = 
							{
							},
							variables = 
							{
								finishcode = "",
								info = "",
								monitorcode = "",
								runcode = "if(Player.castinfo.slot ~= ml_global_information.MAX_SKILLBAR_SLOTS) then\n\t\td(\"[tm_UseSkill]: A skill is currently being cast. Waiting.\")\n\t\tself:success()\n\t\treturn\nend\n\nif(table.valid(context.spellinfo) and context.spellinfo.cooldown ~= 0) then\n\t\td(\"[tm_UseSkill]: Skill is on cooldown. Waiting.\")\n\t\tself:success()\n\t\treturn\nend\n\nself:fail()",
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
								monitorcode = "",
								runcode = "if(context.skill.useat == \"Position\") then\n\t\tif(table.valid(context.skill.pos)) then\n\t\t\t\tPlayer:SetFacing(context.skill.pos.x, context.skill.pos.y, context.skill.pos.z)\n\t\t\t\tPlayer:CastSpell(context.skill.skillslot, context.skill.pos.x, context.skill.pos.y, context.skill.pos.z)\n\t\t\t\tml_global_information.Wait(math.random(750,1000))\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\nend\n\nself:fail()",
								startcode = "",
							},
						},
						
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
										monitorcode = "",
										runcode = "if(context.skill.useat == \"Target\") then\n\t\tif(context.skill.target and context.skill.target > 0) then\n\t\t\t\tlocal mergedList = gw2_common_functions.GetAllTargets(\"onmesh,selectable,maxpathdistance=99999,contentid=\"..context.skill.target)\n\t\t\t\tif(table.valid(mergedList)) then\n\t\t\t\t\t\ttable.sort(mergedList, function(a,b) return a.pathdistance < b.pathdistance end)\n\t\t\t\t\t\tlocal target = nil\n\t\t\t\t\t\tlocal i,available = next(mergedList)\n\n\t\t\t\t\t\twhile available and not target do\n\t\t\t\t\t\t\t\tif(table.valid(context.usedtargets)) then\n\t\t\t\t\t\t\t\t\t\tlocal valid = true\n\t\t\t\t\t\t\t\t\t\tfor _,usedtarget in pairs(context.usedtargets) do\n\t\t\t\t\t\t\t\t\t\t\t\tif(available.id == usedtarget.id and context.skill.skillslot == usedtarget.slot) then\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tvalid = false\n\t\t\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\t\t\tif(valid) then\n\t\t\t\t\t\t\t\t\t\t\t\ttarget = available\n\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\t\ttarget = available\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\ti,available = next(mergedList, i)\n\t\t\t\t\t\tend\n\n\t\t\t\t\t\tlocal target = select(2, next(mergedList))\n\t\t\t\t\t\tif(table.valid(target)) then\n\t\t\t\t\t\t\t\tif(target.distance > 150 or (target.distance > 75 and not target.los)) then\n\t\t\t\t\t\t\t\t\t\tcontext.moveto_position = target.pos\n\t\t\t\t\t\t\t\t\t\tself:success()\n\t\t\t\t\t\t\t\t\t\treturn\n\t\t\t\t\t\t\t\tend\n\n\t\t\t\t\t\t\t\tif(context.skill.oncepertarget) then\n\t\t\t\t\t\t\t\t\t\ttable.insert(context.usedtargets, {slot = context.skill.skillslot, id = target.id})\n\t\t\t\t\t\t\t\tend\n\n\t\t\t\t\t\t\t\tPlayer:CastSpell(context.skill.skillslot, target.id)\n\t\t\t\t\t\t\t\tml_global_information.Wait(math.random(750,1000))\n\t\t\t\t\t\t\t\tself:running()\n\t\t\t\t\t\t\t\treturn\n\t\t\t\t\t\tend\n\t\t\t\tend\n\n\t\tend\nend\ncontext.last_target = nil\nself:fail()",
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
										randomMovement = false,
										randomizestoppingdistance = false,
										smoothturns = true,
										stoppingdistance = 50,
										stoppingidstancemaxrange = 50,
										usewaypoints = false,
									},
									variables = 
									{
										filename = "MoveTo.st",
									},
								},
							},
							settings = 
							{
							},
							variables = 
							{
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.actualTask or 'None'))",
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
								monitorcode = "",
								runcode = "if(context.skill.useat == \"Self\") then\n\t\tPlayer:CastSpell(context.skill.skillslot)\n\t\tml_global_information.Wait(math.random(750,1000))\n\t\tself:success()\n\t\treturn\nend\n\nself:fail()",
								startcode = "",
							},
						},
					},
					settings = 
					{
					},
					variables = 
					{
						monitorcode = "",
					},
				},
			},
			settings = 
			{
			},
			variables = 
			{
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.actualTask or 'None'))",
			},
		},
	},
	settings = 
	{
	},
	variables = 
	{
		filename = "tm_UseSkill.st",
		finishcode = "",
		info = "context.skill = {skillid, name, target, position, skillslot, useat}",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "context.useskills = self.settings.useskills or {}\ncontext.usedskills = context.usedskills or {}\ncontext.skill = context.skill or {}\ncontext.usedtargets = context.usedtargets or {}\n\nif(table.valid(context.useskills)) then\n\t\tfor _,skill in pairs(context.useskills) do\n\t\t\t\t-- Prevent accidentally storing this\n\t\t\t\tskill.skillslot = nil\n\t\tend\n\n\t\tfor i=0,ml_global_information.MAX_SKILLBAR_SLOTS do\n\t\t\t\tlocal b = Player:GetSpellInfo(i)\n\t\t\t\tif(table.valid(b) and context.useskills[b.skillid]) then\n\t\t\t\t\t\tcontext.useskills[b.skillid].skillslot = i\n\t\t\t\tend\n\t\tend\nend",
		startcode = "",
		subtreeuicode = "if(self.settings.useskills == nil) then self.settings.useskills = {} end\n\nself.selectedskillindex = self.selectedskillindex or 1\nlocal stored = self.settings.useskills or {}\nlocal default_values = {useat = \"Self\"; skillname = \"\"; pos = {}; target = 0, skillid = 0; oncepertarget = true;}\nlocal SList = {}\nlocal SListCombo = {}\nlocal useTargets = {\"Self\", \"Target\", \"Position\"}\n\nfor i=0,ml_global_information.MAX_SKILLBAR_SLOTS do\n\t\tlocal b = Player:GetSpellInfo(i)\n\t\tif(table.valid(b)) then\n\t\t\t\tif(not self.settings.useskills[b.skillid]) then\n\t\t\t\t\t\ttable.insert(SList, b)\n\t\t\t\t\t\ttable.insert(SListCombo, i .. \" - \" .. b.name)\n\t\t\t\tend\n\t\tend\nend\n\nself.selectedskillindex = GUI:Combo(GetString(\"Skill\"), self.selectedskillindex, SListCombo)\n\nif(GUI:Button(\"Add skill\")) then\n\t\tlocal skill = SList[self.selectedskillindex]\n\t\tif(skill) then\n\t\t\t\tlocal newtbl = table.shallowcopy(default_values)\n\t\t\t\tnewtbl.skillname = skill.name\n\t\t\t\tnewtbl.skillid = skill.skillid\n\t\t\t\tself.settings.useskills[skill.skillid] = newtbl\n\t\tend\nend\n\nif(table.valid(self.settings.useskills)) then\n\t\tGUI:Columns(4)\n\t\tGUI:Text(\"Skill name\") GUI:NextColumn()\n\t\tGUI:Text(\"Skill id\") GUI:NextColumn()\n\t\tGUI:Text(\"Target\") GUI:NextColumn()\n\t\tGUI:NextColumn()\n\t\tGUI:Separator()\n\t\tfor skillid,skill in pairs(self.settings.useskills) do\n\t\t\t\tGUI:Text(tostring(skill.skillname)) GUI:NextColumn()\n\t\t\t\tGUI:Text(tostring(skillid)) GUI:NextColumn()\n\n\t\t\t\tlocal useatindex = 1\n\t\t\t\tlocal changed = false\n\t\t\t\tfor i,useat in ipairs(useTargets) do\n\t\t\t\t\t\tif(useat == skill.useat) then \n\t\t\t\t\t\t\t\tuseatindex = i\n\t\t\t\t\t\tend\n\t\t\t\tend\n\n\t\t\t\tuseatindex,changed = GUI:Combo(\"##\"..skillid, useatindex, useTargets)\n\t\t\t\t\n\t\t\t\tif(changed) then\n\t\t\t\t\t\tskill.useat = useTargets[useatindex]\n\t\t\t\tend\n\n\t\t\t\tif(skill.useat == \"Target\") then\n\t\t\t\t\t\tskill.target = GUI:InputInt(GetString(\"ContentID\")..\"##\"..skillid, skill.target or 0, 0)\n\t\t\t\t\t\tlocal target = Player:GetTarget()\n\t\t\t\t\t\tif(table.valid(target) and (target.ischaracter or target.isgadget) and target.contentid ~= 17513) then\n\t\t\t\t\t\t\t\tif(GUI:Button(GetString(\"Update target\")..\"##\"..skillid)) then\t\t\t\t\t\t\t\t\t\t\t\t\n\t\t\t\t\t\t\t\t\t\t\t\tskill.target = target.contentid\t\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\tGUI:Text(GetString(\"No valid target selected\"))\n\t\t\t\t\t\tend\n\t\t\t\t\t\tskill.oncepertarget = GUI:Checkbox(GetString(\"Once per target\"), skill.oncepertarget or false)\n\t\t\t\telseif(skill.useat == \"Position\") then\n\t\t\t\t\t\tGUI:InputFloat3(GetString(\"Position\")..\"##\"..skillid, skill.pos.x or 0, skill.pos.y or 0, skill.pos.z or 0, 2, GUI.InputTextFlags_ReadOnly)\n\t\t\t\t\t\tif(GUI:Button(GetString(\"Update position\")..\"##\"..skillid)) then\n\t\t\t\t\t\t\t\tskill.pos = table.shallowcopy(ml_global_information.Player_Position)\n\t\t\t\t\t\tend\n\t\t\t\tend\n\n\t\t\t\tGUI:NextColumn()\n\n\t\t\t\tif(GUI:Button(GetString(\"Remove\")..\"##\"..tostring(skillid))) then\n\t\t\t\t\t\tself.settings.useskills[skillid] = nil\n\t\t\t\tend\n\t\t\t\tGUI:NextColumn()\n\n\t\t\t\tGUI:Separator()\n\t\tend\n\t\tGUI:Columns(1)\nend",
	},
}



return tbl