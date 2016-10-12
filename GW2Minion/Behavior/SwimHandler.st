local tbl = 
{
	class = "BehaviorTree",
	nodes = 
	{
		
		{
			class = "Throttle",
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
						runcode = "if ( ml_global_information.Player_SwimState == GW2.SWIMSTATE.Diving and ml_global_information.Player_OnMesh == false) then\n\t\tml_global_information.swimUp = true\n\t\tPlayer:SetMovement(GW2.MOVEMENTTYPE.SwimUp)\n\t\tself:fail()\n\t\treturn\nelseif( ml_global_information.swimUp == true ) then\n\t\tml_global_information.swimUp = false\n\t\tPlayer:UnSetMovement(GW2.MOVEMENTTYPE.SwimUp)\n\t\tself:fail()\n\t\treturn\nend\n\nlocal skill = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_1)\n--Dont swim on the surface where we cannot fight\nif ( ml_global_information.Player_SwimState == GW2.SWIMSTATE.Swimming and ml_global_information.Player_OnMesh and (ml_global_information.Player_InCombat or not table.valid(skill))) then\n\t\tml_global_information.swimDown = true\n\t\tPlayer:SetMovement(GW2.MOVEMENTTYPE.SwimDown)\n\t\tself:fail()\n\t\treturn\nelseif( ml_global_information.swimDown == true ) then\n\t\tml_global_information.swimDown = false\n\t\tPlayer:UnSetMovement(GW2.MOVEMENTTYPE.SwimDown)\n\t\tself:fail()\n\t\treturn\nend\t\nself:fail()",
						startcode = "",
						xposoffset = 0,
					},
				},
			},
			variables = 
			{
				duration = 1000,
				info = "",
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) if ( self.lastrun ) then local tmr = self.variables.duration/1000 - (GetTickCount() - self.lastrun) if ( tmr < 0 ) then tmr = 0 end GUI:Text('Runs again in: '..tostring(round(tmr,2 ))..' s')\telse\tGUI:Text('Runs again in: '..tostring(round(self.variables.duration/1000))..' s') end",
				xposoffset = 0,
			},
		},
	},
	variables = 
	{
		expanded = true,
		filename = "SwimHandler.st",
		finishcode = "",
		info = "",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
		xposoffset = 0,
	},
}



return tbl