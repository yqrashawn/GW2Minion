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
				finishcode = "",
				info = "",
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
				runcode = "if ( table.valid ( context.moveto_position )) then \n\tlocal dist = Distance3DT(context.moveto_position, ml_global_information.Player_Position )\n\t-- Calculate the stoppingdistance, take the target radius into account\n\tlocal targetradius = self.targetradius or 25\n\n\t-- We reached the targetposition already?\n\tlocal stopdist = self.lowerstoppingdistance or context.moveto_stoppingdistance \n\t\n\t-- we did not yet encounted a -7 error on MoveTo, else we'll ignore targetradius\n\tif ( not self.ignoretargetradius ) then\n\n\t\t-- Get correct target radius and update our MoveTo targetposition\n\t\tif ( context.moveto_targetid ) then \n\t\t\tif ( context.moveto_targettype == \"character\" or context.moveto_targettype == \"gadget\" ) then\n\t\t\t\tlocal target = CharacterList:Get(context.moveto_targetid) or GadgetList:Get(context.moveto_targetid)\n\t\t\t\tif ( target ~= nil and (self.targetoffmeshtime == 0 or TimeSince(self.targetoffmeshtime) < 10000)) then\n\t\t\t\t\tif (target.onmesh) then\n\t\t\t\t\t\tcontext.moveto_position = target.pos\n\t\t\t\t\t\tself.targetradius = target.radius\n\t\t\t\t\t\tself.targetoffmeshtime = ml_global_information.Now\n\t\t\t\t\telseif (self.targetoffmeshtime == 0) then\n\t\t\t\t\t\tself.targetoffmeshtime = ml_global_information.Now\n\t\t\t\t\tend\n\t\t\t\telse\n\t\t\t\t\td(\"[Move To Position] - Target is Gone or not on mesh for 10 seconds.\")\n\t\t\t\t\tself:fail()\n\t\t\t\t\treturn\n\t\t\t\tend\n\n\t\t\telseif ( context.moveto_targettype == \"event\" ) then\n\t\t\t\tlocal eID = tonumber(context.moveto_targetid) or 0\n\t\t\t\tlocal evList = MapMarkerList(\"nearest,onmesh,eventID=\"..eID..\",exclude_eventid=\"..ml_blacklist.GetExcludeString(GetString(\"event\")))\n\t\t\t\tif ( evList ) then\n\t\t\t\t\tlocal i,event = next(evList)\n\t\t\t\t\tif ( i and event ) then\n\t\t\t\t\t\tcontext.moveto_position = event.pos\n\t\t\t\t\tend\n\t\t\t\telse\n\t\t\t\t\td(\"[Move To Position] - Update Eventdata failed, no event with targetID found!\")\n\t\t\t\t\tself:fail()\n\t\t\t\t\treturn\n\t\t\t\tend\n\n\t\t\tend\n\n\t\tend\n\n\t\tif ( stopdist < targetradius ) then \n\t\t\tstopdist = targetradius\n\t\tend\n\tend\n\n\tif ( dist <= stopdist) then\n\t\td(\"[Move To Position] - Target Position reached\")\n\t\tself:success()\n\t\treturn\n\t\n\telse\n\t\t-- Waypoint Usage\n\t\tif (context.moveto_useWaypoints == true and ml_global_information.Player_InCombat == false and ml_global_information.Player_HealthState == GW2.HEALTHSTATE.Alive and dist > 15000 and Inventory:GetInventoryMoney() > 500) then\n\t\t\tlocal waypoint = gw2_common_functions.GetClosestWaypointToPos(ml_global_information.CurrentMapID,context.moveto_position)\n\t\t\tif (ValidTable(waypoint)) then\n\t\t\t\tlocal wDist = Distance2D(waypoint.pos.x,waypoint.pos.y, context.moveto_position.x, context.moveto_position.y)\n\t\t\t\tif (wDist < (dist/2)) then\n\t\t\t\t\tPlayer:StopMovement()\n\t\t\t\t\tPlayer:TeleportToWaypoint(waypoint.id)\n\t\t\t\t\tml_global_information.Wait(5000)\n\t\t\t\t\tcontext.moveto_useWaypoints = false\n\t\t\t\t\tself:running()\n\t\t\t\t\treturn\n\t\t\t\tend\n\t\t\tend\n\t\t\tcontext.moveto_useWaypoints = false\n\t\tend\n\n\t\t-- HandleStuck\n\t\tif ( not gw2_unstuck.HandleStuck() ) then\n\t\t\tlocal newnodecount = NavigationManager:MoveTo(context.moveto_position.x,context.moveto_position.y,context.moveto_position.z,stopdist,context.moveto_follownavsystem,context.moveto_randomMovement,context.moveto_smoothturns)\n\n\t\t\tif ( newnodecount < 0 ) then\n\t\t\t\tif ( newnodecount == -1 ) then\n\t\t\t\t\td(\"[Move To Position] - Player not on Navmesh or no Navmesh loaded\")\n\t\t\t\telseif ( newnodecount == -2 ) then\n\t\t\t\t\td(\"[Move To Position] - TargetPosition not on Navmesh\")\n\t\t\t\telseif ( newnodecount == -7 ) then\n\t\t\t\t\td(\"[Move To Position] - Targetposition < stoppingthreshold\") -- try to lower the targetRadius & stoppingDistance\n\t\t\t\t\t\n\t\t\t\t\tif ( targetradius > 0 and not self.ignoretargetradius ) then\n\t\t\t\t\t\tself.ignoretargetradius = true\n\t\t\t\t\t\tself:running()\n\t\t\t\t\t\treturn\n\t\t\t\t\telseif ( self.ignoretargetradius and not self.lowerstoppingdistance ) then\n\t\t\t\t\t\tself.lowerstoppingdistance = 10\n\t\t\t\t\t\tself:running()\n\t\t\t\t\t\treturn\n\t\t\t\t\telseif ( self.ignoretargetradius and self.lowerstoppingdistance ) then\n\t\t\t\t\t\td(\"gw2_task_moveto: Distance Playerpos-Targetpos < stoppingthreshold : \"..tostring(newnodecount))\n\t\t\t\t\t\tself:fail()\n\t\t\t\t\t\treturn\n\t\t\t\t\telse\n\t\t\t\t\t\td(\"[Move To Position] - No Valid Path Found, Result: \"..tostring(newnodecount)..\" To:\"..tostring(math.floor(context.moveto_position.x))..\"/\"..tostring(math.floor(context.moveto_position.y))..\"/\"..tostring(math.floor(context.moveto_position.z)))\n\t\t\t\t\t\tml_log(\"gw2_task_moveto: No Valid Path : \"..tostring(newnodecount))\n\n\t\t\t\t\t\tif ( self.failedcounter < 10 ) then\n\t\t\t\t\t\t\tself.failedcounter = self.failedcounter + 1\n\t\t\t\t\t\t\tself:running()\n\t\t\t\t\t\t\treturn\n\t\t\t\t\t\telse\n\t\t\t\t\t\t\td(\"[Move To Position] - 10 x No Valid Path Found, MoveTo Failed\")\n\t\t\t\t\t\t\tself:fail()\n\t\t\t\t\t\t\treturn\n\t\t\t\t\t\tend\n\t\t\t\t\tend\n\t\t\t\tend\n\t\t\tend\n\t\tend\n\tend\n\tself:success()\nelse\n\td(\"[Move To Position] - Invalid context.moveto_position !\")\n\tself:fail()\nend",
				startcode = "self.failedcounter = 0\nself.targetoffmeshtime = 0",
				xposoffset = 0,
			},
		},
	},
	variables = 
	{
		expanded = true,
		filename = "MoveTo.st",
		finishcode = "",
		info = "Move to Position. \nRequired input argument: context.moveto_position\nOptional arguments:\ncontext.moveto_targetid - ID of the character / gadget we want to move to.\ncontext.moveto_targettype - \"character\" or \"gadget\" or \"event\"\n",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)\n",
		randomMovement = true,
		runcode = "-- Setting the custom subtree settings in the context, which gets passed down to childnodes\ncontext.moveto_stoppingdistance = self.variables.stoppingdistance\ncontext.moveto_randomMovement = self.variables.randomMovement\ncontext.moveto_smoothturns = self.variables.smoothturns\ncontext.moveto_usewaypoints = self.variables.usewaypoints\ncontext.moveto_follownavsystem = false",
		smoothturns = true,
		startcode = "",
		stoppingdistance = 25,
		subtreeuicode = "if ( self.variables.stoppingdistance == nil ) then self.variables.stoppingdistance = 25 end\nself.variables.stoppingdistance = GUI:InputInt(\"Stopping Distance\", self.variables.stoppingdistance, 1, GUI.InputTextFlags_CharsDecimal)\n\nif ( self.variables.randomMovement == nil ) then self.variables.randomMovement = true end\nself.variables.randomMovement = GUI:Checkbox( \"RandomMovement\", self.variables.randomMovement )\n\nif ( self.variables.smoothturns == nil ) then self.variables.smoothturns = true end\nself.variables.smoothturns = GUI:Checkbox( \"Smooth Turns\", self.variables.smoothturns )\n\nif ( self.variables.usewaypoints == nil ) then self.variables.usewaypoints = false end\nself.variables.usewaypoints = GUI:Checkbox( \"Use Waypoints\", self.variables.usewaypoints )\nif ( GUI:IsItemHovered() ) then GUI:SetTooltip( \"When enabled, MoveTo will use waypoints if they are closer to the targetposition.\" ) end",
		usewaypoints = false,
		xposoffset = 0,
	},
}



return tbl