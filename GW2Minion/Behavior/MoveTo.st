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
					class = "BehaviorTree",
					nodes = 
					{
					},
					settings = 
					{
						expanded = true,
						xposoffset = 0,
					},
					variables = 
					{
						filename = "SwimHandler.st",
					},
				},
				
				{
					class = "Action",
					nodes = 
					{
					},
					settings = 
					{
						xposoffset = 0,
					},
					variables = 
					{
						finishcode = "",
						info = "test",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if ( table.valid ( context.moveto_position )) then \n\t\tlocal dist = Distance3DT(context.moveto_position, ml_global_information.Player_Position )\n\t\t-- Calculate the stoppingdistance, take the target radius into account\n\t\tlocal targetradius = self.targetradius or 25\n\t\tlocal stopdist = self.lowerstoppingdistance or 25\n\t\t\n\t\t-- We reached the targetposition already?\n\t\tstopdist = context.moveto_stoppingdistance or stopdist\n\n\t\t-- we did not yet encounted a -7 error on MoveTo, else we'll ignore targetradius\n\t\tif ( not self.ignoretargetradius ) then\n\t\t\t\t-- Get correct target radius and update our MoveTo targetposition\n\t\t\t\tif ( context.moveto_targetid ) then \n\t\t\t\t\t\tif ( context.moveto_targettype == \"character\" or context.moveto_targettype == \"gadget\" ) then\n\t\t\t\t\t\t\tif(self.lasttarget == nil or self.lasttarget ~= context.moveto_targetid) then\n\t\t\t\t\t\t\t\t\tself.targetoffmeshtime = nil\n\t\t\t\t\t\t\t\t\tself.lasttarget = context.moveto_targetid\n\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\n\t\t\t\t\t\t\tlocal target = CharacterList:Get(context.moveto_targetid) or GadgetList:Get(context.moveto_targetid)\n\t\t\t\t\t\t\tif ( target ~= nil and (self.targetoffmeshtime == nil or TimeSince(self.targetoffmeshtime) < 10000)) then\n\t\t\t\t\t\t\t\t\tif (target.onmesh) then\n\t\t\t\t\t\t\t\t\t\t\tcontext.moveto_position = target.pos\n\t\t\t\t\t\t\t\t\t\t\tself.targetradius = target.radius\n\t\t\t\t\t\t\t\t\t\t\tself.targetoffmeshtime = ml_global_information.Now\n\t\t\t\t\t\t\t\t\telseif (self.targetoffmeshtime == nil) then\n\t\t\t\t\t\t\t\t\t\t\tself.targetoffmeshtime = ml_global_information.Now\n\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\td(\"[Move To Position] - Target is Gone or not on mesh for 10 seconds.\")\n\t\t\t\t\t\t\t\t\tcontext.moveto_targettype = nil\n\t\t\t\t\t\t\t\t\tcontext.moveto_targetid = nil\n\t\t\t\t\t\t\t\t\tself:fail()\n\t\t\t\t\t\t\t\t\treturn\n\t\t\t\t\t\t\tend\n\t\t\t\t\t\telseif ( context.moveto_targettype == \"event\" ) then\n\t\t\t\t\t\t\tlocal eID = tonumber(context.moveto_targetid) or 0\n\t\t\t\t\t\t\tlocal evList = MapMarkerList(\"nearest,onmesh,eventID=\"..eID..\",exclude_eventid=\"..gw2_blacklistmanager.GetExcludeString(GetString(\"Event\")))\n\t\t\t\t\t\t\tif ( evList ) then\n\t\t\t\t\t\t\t\t\tlocal i,event = next(evList)\n\t\t\t\t\t\t\t\t\tif ( i and event ) then\n\t\t\t\t\t\t\t\t\t\tcontext.moveto_position = event.pos\n\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\td(\"[Move To Position] - Update Eventdata failed, no event with targetID found!\")\n\t\t\t\t\t\t\t\t\tcontext.moveto_targettype = nil\n\t\t\t\t\t\t\t\t\tcontext.moveto_targetid = nil\n\t\t\t\t\t\t\t\t\tself:fail()\n\t\t\t\t\t\t\t\t\treturn\n\t\t\t\t\t\t\tend\n\t\t\t\t\t\tend\n\t\t\t\tend\n\n\t\t\t\tif ( stopdist < targetradius ) then \n\t\t\t\t\t\tstopdist = targetradius\n\t\t\t\tend\n\t\tend\n\n\tif ( dist <= stopdist) then\n\t\t\td(\"[Move To Position] - Target Position reached\")\n\t\t\tcontext.moveto_targettype = nil\n\t\t\tcontext.moveto_targetid = nil\n\t\t\tself:success()\n\t\t\treturn\n\telse\n\n\t\t\t-- Waypoint Usage\n\t\t\tif (context.moveto_usewaypoints == true and ml_global_information.Player_InCombat == false and ml_global_information.Player_Alive and dist > 15000 and Inventory:GetInventoryMoney() > 500) then\t\t\t\t\n\t\t\t\t\tlocal waypoint = gw2_common_functions.GetClosestWaypointToPos(ml_global_information.CurrentMapID,context.moveto_position)\n\t\t\t\t\tif (table.valid(waypoint)) then\n\t\t\t\t\t\tlocal wDist = Distance2D(waypoint.pos.x,waypoint.pos.y, context.moveto_position.x, context.moveto_position.y)\n\n\t\t\t\t\t\tif (wDist < (dist/2)) then\n\t\t\t\t\t\t\t\t\tPlayer:StopMovement()\n\t\t\t\t\t\t\t\t\tPlayer:TeleportToWaypoint(waypoint.id)\n\t\t\t\t\t\t\t\t\tml_global_information.Wait(5000)\n\t\t\t\t\t\t\t\t\tcontext.moveto_usewaypoints = false\n\t\t\t\t\t\t\t\t\tself:running()\n\t\t\t\t\t\t\t\t\treturn\n\t\t\t\t\t\t\tend\n\t\t\t\t\tend\n\t\t\t\t\tcontext.moveto_usewaypoints = false\n\t\t\tend\n\n\t\t\t-- HandleStuck\n\t\t\tif ( not gw2_unstuck.HandleStuck(context.unstuck_mode) ) then\n\t\t\t\t\tlocal newnodecount = NavigationManager:MoveTo(context.moveto_position.x,context.moveto_position.y,context.moveto_position.z,stopdist,context.moveto_follownavsystem,context.moveto_randomMovement,context.moveto_smoothturns)\n\n\t\t\t\t\tif ( newnodecount < 0 ) then\n\t\t\t\t\t\t\tif ( newnodecount == -1 ) then\n\t\t\t\t\t\t\t\t\td(\"[Move To Position] - Player not on Navmesh or no Navmesh loaded\")\n\t\t\t\t\t\t\telseif ( newnodecount == -2 ) then\n\t\t\t\t\t\t\t\t\td(\"[Move To Position] - TargetPosition not on Navmesh\")\n\t\t\t\t\t\t\telseif ( newnodecount == -7 ) then\n\t\t\t\t\t\t\t\t\td(\"[Move To Position] - Targetposition < stoppingthreshold\") -- try to lower the targetRadius & stoppingDistance\n\t\t\t\t\t\t\t\t\t\n\t\t\t\t\t\t\t\t\tif ( targetradius > 0 and not self.ignoretargetradius ) then\n\t\t\t\t\t\t\t\t\t\t\tself.ignoretargetradius = true\n\t\t\t\t\t\t\t\t\t\t\tself:running()\n\t\t\t\t\t\t\t\t\t\t\treturn\n\t\t\t\t\t\t\t\t\telseif ( self.ignoretargetradius and not self.lowerstoppingdistance ) then\n\t\t\t\t\t\t\t\t\t\t\tself.lowerstoppingdistance = 10\n\t\t\t\t\t\t\t\t\t\t\tself:running()\n\t\t\t\t\t\t\t\t\t\t\treturn\n\t\t\t\t\t\t\t\t\telseif ( self.ignoretargetradius and self.lowerstoppingdistance ) then\n\t\t\t\t\t\t\t\t\t\t\td(\"gw2_task_moveto: Distance Playerpos-Targetpos < stoppingthreshold : \"..tostring(newnodecount))\n\t\t\t\t\t\t\t\t\t\t\tself:fail()\n\t\t\t\t\t\t\t\t\t\t\treturn\n\t\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\t\t\td(\"[Move To Position] - No Valid Path Found, Result: \"..tostring(newnodecount)..\" To:\"..tostring(math.floor(context.moveto_position.x))..\"/\"..tostring(math.floor(context.moveto_position.y))..\"/\"..tostring(math.floor(context.moveto_position.z)))\n\t\t\t\t\t\t\t\t\t\t\tml_log(\"gw2_task_moveto: No Valid Path : \"..tostring(newnodecount))\n\n\t\t\t\t\t\t\t\t\t\t\tif ( self.failedcounter < 10 ) then\n\t\t\t\t\t\t\t\t\t\t\t\t\tself.failedcounter = self.failedcounter + 1\n\t\t\t\t\t\t\t\t\t\t\t\t\tself:running()\n\t\t\t\t\t\t\t\t\t\t\t\t\treturn\n\t\t\t\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\t\t\t\t\td(\"[Move To Position] - 10 x No Valid Path Found, MoveTo Failed\")\n\t\t\t\t\t\t\t\t\t\t\t\t\tself:fail()\n\t\t\t\t\t\t\t\t\t\t\t\t\treturn\n\t\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\tend\n\t\t\t\t\tend\n\t\t\tend\n\tend\n\tself:running()\nelse\n\t\td(\"[Move To Position] - Invalid context.moveto_position !\")\n\t\tcontext.moveto_targettype = nil\n\t\tcontext.moveto_targetid = nil\n\t\tself:fail()\nend",
						startcode = "",
					},
				},
			},
			settings = 
			{
				expanded = true,
				xposoffset = 0,
			},
			variables = 
			{
				info = "",
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.runningTask or 'None'))",
			},
		},
	},
	settings = 
	{
	},
	variables = 
	{
		filename = "MoveTo.st",
		finishcode = "context.moveto_position = nil\ncontext.moveto_targettype = nil\ncontext.moveto_targetid = nil",
		info = "Move to Position. \nRequired input argument: context.moveto_position\nOptional arguments:\ncontext.moveto_targetid - ID of the character / gadget we want to move to.\ncontext.moveto_targettype - \"character\" or \"gadget\" or \"event\" ",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)\n",
		runcode = "",
		startcode = "-- Setting the custom subtree settings in the context, which gets passed down to childnodes\ncontext.moveto_stoppingdistance = self.settings.stoppingdistance or 25\ncontext.moveto_randomMovement = self.settings.randomMovement or false\ncontext.moveto_smoothturns = self.settings.smoothturns or false\ncontext.moveto_usewaypoints = self.settings.usewaypoints or false\ncontext.moveto_follownavsystem = false",
		subtreeuicode = "if ( self.settings.stoppingdistance == nil ) then self.settings.stoppingdistance = 25 end\nself.settings.stoppingdistance = GUI:InputInt(\"Stopping Distance\", self.settings.stoppingdistance, 1, GUI.InputTextFlags_CharsDecimal)\n\nif ( self.settings.randomMovement == nil ) then self.settings.randomMovement = true end\nself.settings.randomMovement = GUI:Checkbox( \"RandomMovement\", self.settings.randomMovement )\n\nif ( self.settings.smoothturns == nil ) then self.settings.smoothturns = true end\nself.settings.smoothturns = GUI:Checkbox( \"Smooth Turns\", self.settings.smoothturns )\n\nif ( self.settings.usewaypoints == nil ) then self.settings.usewaypoints = false end\nself.settings.usewaypoints = GUI:Checkbox( \"Use Waypoints\", self.settings.usewaypoints )\nif ( GUI:IsItemHovered() ) then GUI:SetTooltip( \"When enabled, MoveTo will use waypoints if they are closer to the targetposition.\" ) end",
	},
}



return tbl