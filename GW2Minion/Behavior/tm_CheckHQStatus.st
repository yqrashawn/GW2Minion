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
						info = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(self.hqmarkercheck) then\n\t\tself:success()\nend",
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
					class = "Action",
					nodes = 
					{
					},
					variables = 
					{
						finishcode = "",
						info = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "self:success()",
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
						runcode = "self:success()",
						startcode = "",
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
		hqid = 0,
		hqpos = 
		{
			x = 7035.3701171875,
			y = -10543.900390625,
			z = -320.79510498047,
		},
		info = "",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "context.hqid = self.variables.hqid\ncontext.hqpos = self.variables.hqpos",
		startcode = "",
		subtreeuicode = "self.variables.hqid = self.variables.hqid or 0\nself.variables.hqpos = self.variables.hqpos or {x=0;y=0;z=0}\n\nself.variables.hqid = GUI:InputInt(\"Sub region id##tmhqstatus\", self.variables.hqid)\nif(GUI:Button(\"Update##tmhqstatus\")) then\n\t\tlocal MList = MapMarkerList(\"nearest,issubregion\")\n\t\tif(table.valid(MList)) then\n\t\t\t\tlocal _,marker = next(MList)\n\t\t\t\tif(table.valid(marker)) then\n\t\t\t\t\t\tself.variables.hqid = marker.subregionid\n\t\t\t\t\t\tself.variables.hqpos = marker.pos\n\t\t\t\tend\n\t\tend\nend",
		xposoffset = 0,
	},
}



return tbl