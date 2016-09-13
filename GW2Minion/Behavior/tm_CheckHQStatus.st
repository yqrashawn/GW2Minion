local tbl = 
{
	class = "BehaviorTree",
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
					variables = 
					{
						finishcode = "",
						info = "Check timer",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(type(context.hqchecktimer) ~= \"number\") then\n\t\tself:fail()\n\t\treturn\nend\n\nif(context.lasthqmarkercheck == nil or TimeSince(context.lasthqmarkercheck) > context.hqchecktimer*1000) then\n\t\tself:success()\n\t\treturn\nend\n\nself:fail()",
						startcode = "",
						xposoffset = 0,
					},
				},
				
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
						runcode = "if(context.hqid) then\n\t\tlocal MList = MapMarkerList(\"issubregion\")\n\t\tif(table.valid(MList)) then\n\t\t\t\tfor _,marker in pairs(MList) do\n\t\t\t\t\t\tif(marker.subregionid == context.hqid) then\n\t\t\t\t\t\t\t\tcontext.hqmarker = marker\n\t\t\t\t\t\t\t\tself:success()\n\t\t\t\t\t\t\t\treturn\n\t\t\t\t\t\tend\n\t\t\t\tend\n\t\tend\nend\ncontext.hq_marker = nil\nself:fail()",
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
								runcode = "context.hqmarker_rnddist = context.hqmarker_rnddist or math.random(150,500)\nif(context.hqmarker) then\n\t\tif(context.hqmarker.distance > context.hqmarker_rnddist) then\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\n\t\tml_global_information.Wait(context.hqmarker_rnddist*5)\nend\n\ncontext.hqmarker_rnddist = nil\ncontext.hqmarker = nil\ncontext.lasthqmarkercheck = ml_global_information.Now\n\nself:fail()",
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
				monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.actualTask or 'None'))",
				xposoffset = 0,
			},
		},
	},
	variables = 
	{
		expanded = true,
		filename = "tm_CheckHQStatus.st",
		finishcode = "",
		hqchecktimer = 120,
		hqid = 236,
		hqpos = 
		{
			x = 7035.3701171875,
			y = -10543.900390625,
			z = -320.79510498047,
		},
		info = "Move closer to a heartquest marker to check status",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "context.hqid = self.variables.hqid\ncontext.hqpos = self.variables.hqpos\ncontext.hqchecktimer = self.variables.hqchecktimer",
		startcode = "",
		subtreeuicode = "self.variables.hqid = self.variables.hqid or 0\nself.variables.hqpos = self.variables.hqpos or {x=0;y=0;z=0}\nself.variables.hqchecktimer = self.variables.hqchecktimer or 120\n\nself.variables.hqchecktimer = GUI:InputInt(\"How often? (s)##tmhqstatus\", self.variables.hqchecktimer)\n \nself.variables.hqid = GUI:InputInt(\"Region id##tmhqstatus\", self.variables.hqid)\nif(GUI:Button(\"Update region id##tmhqstatus\")) then\n\t\tlocal MList = MapMarkerList(\"nearest,issubregion\")\n\t\tif(table.valid(MList)) then\n\t\t\t\tlocal _,marker = next(MList)\n\t\t\t\tif(table.valid(marker)) then\n\t\t\t\t\t\tself.variables.hqid = marker.subregionid\n\t\t\t\t\t\tself.variables.hqpos = marker.pos\n\t\t\t\tend\n\t\tend\nend",
		xposoffset = 0,
	},
}



return tbl