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
						info = "",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(table.valid(context.tm_moveto_targetpos)) then\n\t\tif(Distance3DT(context.tm_moveto_targetpos, ml_global_information.Player_Position) > 50) then\n\t\t\t\tcontext.moveto_position = context.tm_moveto_targetpos\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\nend\nself:fail()\n",
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
						randomizestoppingdistance = false,
						smoothturns = true,
						stoppingdistance = 50,
						stoppingidstancemaxrange = 50,
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
		filename = "tm_MoveTo.st",
		finishcode = "",
		info = "",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "context.tm_moveto_targetpos = self.settings.targetpos",
		startcode = "",
		subtreeuicode = "local pos = self.settings.targetpos\nif(pos == nil) then pos = {x = 0; y = 0; z = 0;} end\n\nlocal x,y,z,changed = GUI:InputFloat3(\"Position\", pos.x,pos.y,pos.z,2)\nif(changed) then\n\t\tself.settings.targetpos = {x = x; y = y; z = z;}\nend\n\nif(not ml_global_information.Player_OnMesh) then\n\t\tGUI:Text(\"Player not on mesh\")\nend\n\nif(GUI:Button(\"Update position\")) then\n\t\tself.settings.targetpos = ml_global_information.Player_Position\nend",
	},
}



return tbl