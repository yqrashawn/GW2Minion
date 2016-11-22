local tbl = 
{
	class = "SubTree",
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
				info = "Death Handler",
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))\nif (self.deadtime and self.totaldeadtime) then\n\tlocal total = math.ceil(TimeSince(self.totaldeadtime)/1000)\n\tlocal lastcheck = math.ceil(TimeSince(self.deadtime)/1000)\n\tlocal maxtime = math.ceil(self.respawncheck*0.75)\n\tGUI:Text('Time since death: '..tostring(total)..'s')\n\tGUI:Text('Time since last check: '..tostring(lastcheck)..'s')\n\tGUI:Text('Max respawn time: '..tostring(maxtime)..'s')\nelse\n\tGUI:Text('Time Since Death: 0')\nend",
				runcode = "if ( ml_global_information.Player_HealthState == GW2.HEALTHSTATE.Defeated ) then\n\t\tself.totaldeadtime = self.totaldeadtime or ml_global_information.Now\n\t\tself.deadtime = self.deadtime or ml_global_information.Now\n\t\tself.respawncheck = self.respawncheck or math.random(30,50)\n\t\tself.respawncount = self.respawncount or 0\n\t\t\n\t\t-- Reset some common stuff\n\t\tcontext.gather_targetid = nil\n\t\tcontext.movetorandom_randompoint = nil\n\t\tcontext.movetorandom_randompointreached = false\n\n\t\tif (TimeSince(self.deadtime) > self.respawncheck*100 ) then \n\t\t\t\t-- Checking for nearby partymembers\n\t\t\t\tlocal found = false\n\t\t\t\tif(table.valid(ml_global_information.Player_Party)) then\n\t\t\t\t\t\tlocal idx,pmember = next(ml_global_information.Player_Party)\n\t\t\t\t\t\twhile (idx and pmember) do\n\t\t\t\t\t\t\t\tif ( pmember.id ~= 0 and pmember.id ~= ml_global_information.Player_ID ) then\n\t\t\t\t\t\t\t\t\t\tlocal char = CharacterList:Get(pmember.id)\n\t\t\t\t\t\t\t\t\t\tif ( char ) then\n\t\t\t\t\t\t\t\t\t\t\t\tlocal cPos = char.pos\n\t\t\t\t\t\t\t\t\t\t\t\tif ( cPos and Distance3DT ( ml_global_information.Player_Position, cPos) < 2500 and char.alive) then\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tfound = true\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tbreak\n\t\t\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\tidx,pmember=next(ml_global_information.Player_Party,idx)\n\t\t\t\t\t\tend\n\t\t\t\tend\n\n\t\t\t\t-- Check for nearby Players who can rezz us\n\t\t\t\tif ( found == false ) then\n\t\t\t\t\t\tif (table.size(CharacterList(\"nearest,alive,friendly,player,maxdistance=1200\")) > 0) then\n\t\t\t\t\t\t\t\tfound = true\n\t\t\t\t\t\tend\n\t\t\t\tend\n\n\t\t\t\tif ( not found or TimeSince(self.deadtime) > (self.respawncheck*0.75)*1000 ) then\n\t\t\t\t\t\td(\"[DeathHandler]: We are dead.\" )\n\t\t\t\t\t\tif (ml_global_information.Player_LastHealth == nil or ml_global_information.Player_LastHealth < ml_global_information.Player_Health.current ) then\n\t\t\t\t\t\t\t\tml_global_information.Player_LastHealth = ml_global_information.Player_Health.current\n\t\t\t\t\t\t\t\tif(found) then\n\t\t\t\t\t\t\t\t\t\tself.deadtime = ml_global_information.Now + 10000\n\t\t\t\t\t\t\t\t\t\td(\"[DeathHandler]: We are beeing revived... waiting a bit longer\" )\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\telseif ( ml_global_information.Player_LastHealth ~= nil ) then\n\t\t\t\t\t\t\t\tself.deadtime = ml_global_information.Now\n\t\t\t\t\t\t\t\td(\"[DeathHandler]: Respawn at nearest waypoint.\" )\n\t\t\t\t\t\t\t\tlocal respawn = Player:RespawnAtClosestWaypoint()\n\t\t\t\t\t\t\t\tif(not respawn) then\n\t\t\t\t\t\t\t\t\t\tself.respawncount = self.respawncount + 1\n\t\t\t\t\t\t\t\t\t\td(\"[DeathHandler]: Failed to respawn at waypoint (\"..self.respawncount..\")\")\n\t\t\t\t\t\t\t\t\t\tif(self.respawncount > 6) then\n\t\t\t\t\t\t\t\t\t\t\t\td(\"[DeathHandler]: Falling back to raw waypoint selection.\")\n\t\t\t\t\t\t\t\t\t\t\t\tlocal WPList = WaypointList(\"nearest,notcontested,onmesh,samezone\")\n\t\t\t\t\t\t\t\t\t\t\t\tif(table.valid(WPList)) then\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tlocal _,wp  = next(WPList)\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tif(table.valid(wp)) then\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tPlayer:TeleportToWaypoint(wp.id)\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\t\t\telseif(self.respawncount > 3) then\n\t\t\t\t\t\t\t\t\t\t\t\td(\"[DeathHandler]: Falling back to filtered waypoint selection.\")\n\t\t\t\t\t\t\t\t\t\t\t\tlocal wp = gw2_common_functions.GetClosestWaypointToPos(ml_global_information.CurrentMapID,ml_global_information.Player_Position)\n\t\t\t\t\t\t\t\t\t\t\t\tif(table.valid(wp)) then\n\t\t\t\t\t\t\t\t\t\t\t\t\tPlayer:TeleportToWaypoint(wp.id)\n\t\t\t\t\t\t\t\t\t\t\t\tend\n\n\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\n\t\t\t\t\t\t\t\tml_global_information.Stop()\n\t\t\t\t\t\tend\n\t\t\t\tend\n\t\tend\n\t\tself:running()\nelse\n\t\tml_global_information.Player_LastHealth = ml_global_information.Player_Health.current\n\t\tself:fail()\n\t\tself.totaldeadtime = nil\n\t\tself.deadtime = nil\n\t\tself.respawncheck = nil\n\t\tself.respawncount = 0\nend",
				startcode = "",
			},
		},
	},
	settings = 
	{
	},
	variables = 
	{
		filename = "DeathHandler.st",
		finishcode = "",
		info = "Death Handler",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)\n",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
	},
}



return tbl