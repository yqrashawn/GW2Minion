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
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))\nlocal vendorcheck = 0\nif(self.vendorcheck) then\n\t\tlocal remaining = 5000-TimeSince(self.vendorcheck)\n\t\tif(remaining > 0) then\n\t\t\t\tvendorcheck = math.ceil(remaining/1000)\n\t\tend\nend\nGUI:Text(\"Next vendor check: \"..vendorcheck..\"s\")\n",
						runcode = "if(context.buy_marker or context.sell_marker or context.repair_marker) then\n\t\tself:success()\n\t\treturn\nend\n\nif(self.vendorcheck == nil or TimeSince(self.vendorcheck) > 5000) then\n\t\tself.vendorcheck = ml_global_information.Now\n\t\tself:success()\n\t\treturn\nend\n\nself:fail()",
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
						runcode = "if(gw2_sell_manager.active) then\n\t\tif(gw2_sell_manager.needToSell(true) and table.valid(gw2_sell_manager.getClosestSellMarker(true))) then\n\t\t\t\tcontext.sell_nearby = true\n\t\telse\n\t\t\t\tcontext.sell_nearby = false\n\t\tend\nend\n\nif(gw2_repair_manager.NeedToRepair(true) and table.valid(gw2_repair_manager.getClosestRepairMarker(true))) then\n\t\tcontext.repair_nearby = true\nelse\n\t\tcontext.repair_nearby = false\nend\n\nif((gw2_buy_manager.NeedToBuySalvageKits(true) or gw2_buy_manager.NeedToBuyGatheringTools(true)) and table.valid(gw2_buy_manager.getClosestBuyMarker(true))) then\n\t\tcontext.buy_nearby = true\nelse\n\t\tcontext.buy_nearby = false\nend\n\nself:success()",
						startcode = "",
						xposoffset = 0,
					},
				},
				
				{
					class = "Selector",
					nodes = 
					{
						
						{
							class = "BehaviorTree",
							nodes = 
							{
							},
							variables = 
							{
								expanded = true,
								filename = "Repair.st",
								finishcode = "",
								info = "Repair\nOptional parameter:\ncontext.repair_nearby = true/false",
								menucode = "",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
								runcode = "",
								startcode = "",
								subtreeuicode = "",
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
								filename = "Sell.st",
								finishcode = "",
								info = "Sell\nOptional parameter:\ncontext.sell_nearby = true/false",
								menucode = "",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
								runcode = "",
								startcode = "",
								subtreeuicode = "",
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
								filename = "Buy.st",
								finishcode = "",
								info = "Buy\nOptional parameter:\ncontext.buy_nearby = true/false",
								menucode = "",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
								runcode = "",
								startcode = "",
								subtreeuicode = "",
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
		filename = "VendorHandler.st",
		finishcode = "",
		info = "",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
		xposoffset = 6,
	},
}



return tbl