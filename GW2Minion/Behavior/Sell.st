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
					settings = 
					{
					},
					variables = 
					{
						finishcode = "",
						info = "Select vendor",
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
						runcode = "if(Settings.gw2_sell_manager.active and (gw2_sell_manager.needToSell(context.sell_nearby) or context.sell_selling)) then\n\t\tlocal marker = gw2_sell_manager.getClosestSellMarker(context.sell_nearby)\n\t\tif(table.valid(marker)) then\n\t\t\t\tcontext.sell_marker_characterid = marker.characterid\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\nend\ncontext.sell_marker_characterid = nil\nself:fail()",
						startcode = "",
					},
				},
				
				{
					class = "PrioritySelector",
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
								info = "Check sell status",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
								runcode = "if(context.sell_marker_characterid) then\n\t\tif(gw2_blacklistmanager.CheckBlacklistEntry(GetString(\"Vendor sell\"),context.sell_marker_characterid)) then\n\t\t\t\td(\"[Sell]: Vendor blacklisted\")\n\t\t\t\tcontext.sell_marker_characterid = nil\n\t\tend\nend\n\nif(not context.sell_selling and not gw2_sell_manager.needToSell(context.sell_nearby)) then\n\t\tcontext.sell_marker_characterid = nil\nend\n\nself:fail()",
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
								info = "Set up marker",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
								runcode = "context.sell_marker = nil\nif(context.sell_marker_characterid) then\n\t\tlocal MList = MapMarkerList(\"onmesh,agentID=\"..context.sell_marker_characterid)\n\t\tif(table.valid(MList)) then\n\t\t\t\tlocal _,marker = next(MList)\n\t\t\t\tif(table.valid(marker)) then\n\t\t\t\t\t\tcontext.sell_marker = marker\n\t\t\t\t\t\tself:fail()\n\t\t\t\t\t\treturn\n\t\t\t\tend\n\t\tend\n\n\t\tif(not table.valid(context.sell_marker)) then\n\t\t\t\td(\"[Sell]: Vendor missing or not on mesh\")\n\t\t\t\tgw2_blacklistmanager.AddBlacklistEntry(GetString(\"Vendor sell\"), context.sell_marker_characterid, \"Missing vendor\", ml_global_information.Now + 50000)\n\t\tend\nend\ncontext.sell_marker_characterid = nil\nself:fail()",
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
								info = "Sell",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
								runcode = "if(table.valid(context.sell_marker)) then\n\t\tlocal marker = context.sell_marker\n\t\tif(marker.distance > 1500) then\n\t\t\t\tself:fail()\n\t\t\t\treturn\n\t\tend\n\t\t\n\t\tlocal vendor = CharacterList:Get(marker.characterid) or GadgetList:Get(marker.characterid)\n\t\t\n\t\tif(table.valid(vendor)) then\n\t\t\tif(vendor.interactable and vendor.selectable) then\n\t\t\t\tif(vendor.distance > 130 or not vendor.isininteractrange) then\n\t\t\t\t\t\t\tself:fail()\n\t\t\t\t\t\t\treturn\n\t\t\t\tend\n\t\t\t\t\n\t\t\t\tPlayer:StopMovement()\n\t\t\t\tlocal target = Player:GetTarget()\n\t\t\t\tif(target == nil or target.id ~= vendor.id) then\n\t\t\t\t\t\tPlayer:SetTarget(vendor.id)\n\t\t\t\t\t\tself:running()\n\t\t\t\t\t\treturn\n\t\t\t\tend\n\n\t\t\t\tif(gw2_sell_manager.sellAtVendor(vendor)) then\n\t\t\t\t\t\tcontext.sell_selling = true\n\t\t\t\t\t\tself:running()\n\t\t\t\t\t\treturn\n\t\t\t\tend\n\t\t\telse\n\t\t\t\t\td(\"[Sell]: Vendor not interactable or not selectable.\")\n\t\t\t\t\tgw2_blacklistmanager.AddBlacklistEntry(GetString(\"Vendor sell\"), vendor.id, vendor.name, ml_global_information.Now + 1200000)\n\t\t\tend\n\t\telse\n\t\t\t\td(\"[Sell]: Vendor not found.\")\n\t\t\t\tgw2_blacklistmanager.AddBlacklistEntry(GetString(\"Vendor sell\"), marker.characterid, \"Vendor not found\", ml_global_information.Now + 1200000)\n\t\tend\nend\ncontext.sell_marker = nil\ncontext.sell_selling = false\nself:fail()",
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
										info = "Move to sell marker",
										monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
										runcode = "if(table.valid(context.sell_marker)) then\n\t\tcontext.moveto_position = context.sell_marker.pos\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
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
										smoothturns = true,
										stoppingdistance = 120,
										usewaypoints = true,
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
								info = "Move to sell marker",
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
						monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Active Child: '..tostring(self.runningTask or 'None'))",
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
		filename = "Sell.st",
		finishcode = "",
		info = "Sell\nOptional parameter:\ncontext.sell_nearby = true/false",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
	},
}



return tbl