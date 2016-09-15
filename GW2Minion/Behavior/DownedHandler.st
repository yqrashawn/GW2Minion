local tbl = 
{
	class = "BehaviorTree",
	nodes = 
	{
		
		{
			class = "Action",
			nodes = 
			{
			},
			variables = 
			{
				filename = "DownedHandler",
				finishcode = "",
				info = "Downed Handler",
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))\nGUI:Text('Health State: '..tostring(ml_global_information.Player_HealthState))\nGUI:Text('Downed: '..tostring(ml_global_information.Player_HealthState == GW2.HEALTHSTATE.Downed))\nlocal target = gw2_common_functions.GetBestAggroTarget(true)\nif ( ValidTable(target) ) then\n\tGUI:Text('Downed Target: '..target.name)\nelse\n\tGUI:Text('Downed Target: None')\nend\nGUI:Text('Castinfo-Duration: '..tostring(Player.castinfo.duration))\n",
				runcode = "if ( ml_global_information.Player_HealthState == GW2.HEALTHSTATE.Downed ) then\n\t\tif ( ml_global_information.Player_IsMoving == true ) then\n\t\t\tPlayer:StopMovement()\n\t\tend\n\t\t\n\t\t-- Attack nearby target\n\t\tlocal target = gw2_common_functions.GetBestAggroTarget(true)\n\t\tif (table.valid(target)) then\n\t\t\t\tlocal currentTarget = Player:GetTarget()\n\t\t\t\tif (not currentTarget or currentTarget.id ~= target.id) then\n\t\t\t\t\tPlayer:SetTarget(target.id)\n\t\t\t\tend\n\t\t\t\tgw2_skill_manager:Use( target.id )\n\t\tend\t\n\n\t\t-- Heal\n\t\tif ( Player.castinfo.duration == 0 ) then\n\t\t\t\tPlayer:CastSpell( GW2.SKILLBARSLOT.Slot_4 )\n\t\t\t\tml_global_information.Wait(500)\n\t\tend\n\t\tself:running()\nelse\n\t\tself:fail()\nend",
				startcode = "",
				xposoffset = 0,
			},
		},
	},
	variables = 
	{
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