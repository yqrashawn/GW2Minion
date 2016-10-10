local tbl = 
{
	class = "BehaviorTree",
	nodes = 
	{
		
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
						info = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if (ml_global_information.Player_HealthState == GW2.HEALTHSTATE.Downed ) then\n\t\tcontext.downedstate = true\n\t\tcontext.combat_target = nil\n\t\tcontext.combat_targetid = nil\n\t\tcontext.combat_moveintocombatrange = false\n\t\tcontext.combat_onmeshcheck = false\n\n\t\tif ( ml_global_information.Player_IsMoving == true ) then\n\t\t\tPlayer:StopMovement()\n\t\tend\n\n\t\t-- Heal \n\t\tif(Player.castinfo.slot == GW2.SKILLBARSLOT.Slot_4) then\n\t\t\t\tml_global_information.Wait(500)\n\t\t\t\tself:running()\n\t\t\t\treturn\n\t\tend\n\n\t\tlocal healskill = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_4)\n\t\tif(healskill and healskill.cooldown == 0) then\n\t\t\t\tPlayer:CastSpell(GW2.SKILLBARSLOT.Slot_4)\n\t\t\t\tml_global_information.Wait(500)\n\t\t\t\tself:running()\n\t\t\t\treturn\n\t\tend\n\n\t\t-- Attack nearby target\n\t\tlocal target = gw2_common_functions.GetBestDownstateTarget()\n\t\tif (table.valid(target)) then\n\t\t\t\tcontext.combat_targetid = target.id\n\t\t\t\tself:fail()\n\t\t\t\treturn\n\t\tend \n\n\t\tself:running()\nelseif(context.downedstate) then\n\t\t-- Make sure to force reset the running combat tree\n\t\tcontext.downedstate = false\n\t\tcontext.combat_targetid = nil\n\t\tcontext.combat_target = nil\n\t\tcontext.combat_onmeshcheck = nil\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
						startcode = "",
						xposoffset = 0,
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
							variables = 
							{
								finishcode = "",
								info = "",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
								runcode = "if (context.downedstate and ml_global_information.Player_HealthState == GW2.HEALTHSTATE.Downed ) then\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
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
								moveintocombatrange = false,
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
				info = "",
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.runningTask or 'None'))",
				xposoffset = 0,
			},
		},
	},
	variables = 
	{
		expanded = true,
		filename = "DownedHandler.st",
		finishcode = "",
		info = "Downed Handler",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
		xposoffset = 0,
	},
}



return tbl