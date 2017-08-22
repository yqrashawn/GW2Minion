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
						info = "Check timer",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(type(context.hqchecktimer) ~= \"number\") then\n\t\tself:fail()\n\t\treturn\nend\n\nif(context.lasthqmarkercheck == nil or TimeSince(context.lasthqmarkercheck) > context.hqchecktimer*1000) then\n\t\tself:success()\n\t\treturn\nend\n\nself:fail()",
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
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(context.hqid) then\n\t\tlocal MList = MapMarkerList(\"issubregion\")\n\t\tif(table.valid(MList)) then\n\t\t\t\tfor _,marker in pairs(MList) do\n\t\t\t\t\t\tif(marker.subregionid == context.hqid) then\n\t\t\t\t\t\t\t\tcontext.hqmarker = marker\n\t\t\t\t\t\t\t\tself:success()\n\t\t\t\t\t\t\t\treturn\n\t\t\t\t\t\tend\n\t\t\t\tend\n\t\tend\nend\ncontext.hq_marker = nil\nself:fail()",
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
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
								runcode = "context.hqmarker_rnddist = context.hqmarker_rnddist or math.random(150,500)\nif(context.hqmarker) then\n\t\tif(context.hqmarker.distance > context.hqmarker_rnddist) then\n\t\t\t\tcontext.moveto_position = context.hqmarker.pos\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\n\t\tml_global_information.Wait(context.hqmarker_rnddist*5)\nend\n\ncontext.hqmarker_rnddist = nil\ncontext.hqmarker = nil\ncontext.lasthqmarkercheck = ml_global_information.Now\n\nself:fail()",
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
								randomMovement = true,
								randomizestoppingdistance = true,
								smoothturns = true,
								stoppingdistance = 100,
								stoppingidstancemaxrange = 300,
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
		filename = "tm_CheckHQStatus.st",
		finishcode = "",
		info = "Move closer to a heartquest marker to check status",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "context.hqid = self.settings.hqid\ncontext.hqpos = self.settings.hqpos\ncontext.hqchecktimer = self.settings.hqchecktimer ",
		startcode = "",
		subtreeuicode = "self.settings.hqid = self.settings.hqid or 0\nself.settings.hqpos = self.settings.hqpos or {x=0;y=0;z=0}\nself.settings.hqchecktimer = self.settings.hqchecktimer or 120\n\nself.settings.hqchecktimer = GUI:InputInt(\"How often? (s)##tmhqstatus\", self.settings.hqchecktimer, 10)\n \nself.settings.hqid = GUI:InputInt(\"Region id##tmhqstatus\", self.settings.hqid, 0)\nif(GUI:Button(\"Update region id##tmhqstatus\")) then\n\t\tlocal MList = MapMarkerList(\"nearest,issubregion\")\n\t\tif(table.valid(MList)) then\n\t\t\t\tlocal _,marker = next(MList)\n\t\t\t\tif(table.valid(marker)) then\n\t\t\t\t\t\tself.settings.hqid = marker.subregionid\n\t\t\t\t\t\tself.settings.hqpos = marker.pos\n\t\t\t\tend\n\t\tend\nend",
	},
}



return tbl