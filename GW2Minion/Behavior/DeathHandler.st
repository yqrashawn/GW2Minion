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
				filename = "DeathHandler",
				finishcode = "",
				info = "Death Handler",
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))\nif ( self.deadtime ) then\n\tGUI:Text('Time Since Death: '..tostring(TimeSince(self.deadtime)))\n\tGUI:Text('Max respawn time: '..tostring(math.ceil((self.respawncheck*0.75)*1000)))\nelse\n\tGUI:Text('Time Since Death: 0')\nend",
				runcode = "if ( ml_global_information.Player_HealthState == GW2.HEALTHSTATE.Defeated ) then\t\n\tif(not self.deadtime) then self.deadtime = ml_global_information.Now end\n\tif(not self.respawncheck) then self.respawncheck = math.random(30,70) end\n\t\n\tif (TimeSince(self.deadtime) > self.respawncheck*100 ) then \n\t\t-- Checking for nearby partymembers\n\t\tlocal party = ml_global_information.Player_Party\n\t\tlocal found = false\n\t\tif ( table.size(party) > 1 ) then\n\t\t\tlocal idx,pmember = next(party)\n\t\t\twhile (idx and pmember) do\n\t\t\t\tif ( pmember.id ~= 0 and pmember.id ~= Player.id ) then\n\t\t\t\t\tlocal char = CharacterList:Get(pmember.id)\n\t\t\t\t\tif ( char ) then\n\t\t\t\t\t\tlocal cPos = char.pos\n\t\t\t\t\t\tif ( cPos and Distance3DT ( ml_global_information.Player_Position, cPos) < 2500 and char.alive) then\n\t\t\t\t\t\t\tfound = true\n\t\t\t\t\t\t\tbreak\n\t\t\t\t\t\tend\n\t\t\t\t\tend\n\t\t\t\tend\n\t\t\t\tidx,pmember=next(party,idx)\n\t\t\tend\n\t\tend\n\n\t\t-- Check for nearby Players who can rezz us\n\t\tif ( found == false ) then\n\t\t\tif (table.size(CharacterList(\"nearest,alive,friendly,player,maxdistance=1200\")) > 0) then\n\t\t\t\tfound = true\n\t\t\tend\n\t\tend\n\t\t\n\t\tif ( not found or TimeSince(self.deadtime) > (self.respawncheck*0.75)*1000 ) then\n\t\t\tif ( ml_global_information.Player_LastHealth == nil or ml_global_information.Player_LastHealth < ml_global_information.Player_Health.current ) then\n\t\t\t\tml_global_information.Player_LastHealth = ml_global_information.Player_Health.current\t\t\n\t\t\t\tself.deadtime = ml_global_information.Now + 10000\n\t\t\t\td( \"[Player]: We are beeing revived...waiting a bit longer\" )\n\t\t\telseif ( ml_global_information.Player_LastHealth ~= nil ) then\n\t\t\t\tself.deadtime = ml_global_information.Now\n\t\t\t\td( \"[Player]: Respawn at nearest waypoint.\" )\n\t\t\t\td( Player:RespawnAtClosestWaypoint() )\n\t\t\t\tml_global_information.Stop()\n\t\t\tend\n\t\tend\n\tend\n\tself:running()\nelse\n\tml_global_information.Player_LastHealth = ml_global_information.Player_Health.current\n\tself:fail()\n\tself.deadtime = nil\n\tself.respawncheck = math.random(30,70)\nend",
				startcode = "",
				xposoffset = 0,
			},
		},
	},
	variables = 
	{
		filename = "DeathHandler.st",
		finishcode = "",
		info = "Death Handler",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
		xposoffset = 0,
	},
}



return tbl