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
						runcode = "if(gw2_repair_manager.NeedToRepair(context.repair_nearby)) then\n\t\tlocal marker = gw2_repair_manager.getClosestRepairMarker(context.repair_nearby)\n\t\tif(table.valid(marker)) then\n\t\t\t\tcontext.repair_marker_characterid = marker.characterid\n\t\t\t\tself:success()\n\t\t\t\treturn\n\t\tend\nend\ncontext.repair_marker_characterid = nil\nself:fail()",
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
								info = "Check repair status",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
								runcode = "if(context.repair_marker_characterid) then\n\t\tif(gw2_blacklistmanager.CheckBlacklistEntry(GetString(\"Vendor repair\"),context.repair_marker_characterid)) then\n\t\t\t\td(\"[Repair]: Vendor blacklisted\")\n\t\t\t\tcontext.repair_marker_characterid = nil\n\t\tend\nend\n\nif(not gw2_repair_manager.NeedToRepair(context.repair_nearby)) then\n\t\tcontext.repair_marker_characterid = nil\nend\n\nself:fail()",
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
								runcode = "context.repair_marker = nil\nif(context.repair_marker_characterid) then\n\t\tlocal MList = MapMarkerList(\"onmesh,agentID=\"..context.repair_marker_characterid)\n\t\tif(table.valid(MList)) then\n\t\t\t\tlocal _,marker = next(MList)\n\t\t\t\tif(table.valid(marker)) then\n\t\t\t\t\t\tcontext.repair_marker = marker\n\t\t\t\t\t\tself:fail()\n\t\t\t\t\t\treturn\n\t\t\t\tend\n\t\tend\n\n\t\tif(not table.valid(context.repair_marker)) then\n\t\t\t\td(\"[Repair]: Vendor missing or not on mesh\")\n\t\t\t\tgw2_blacklistmanager.AddBlacklistEntry(GetString(\"Vendor repair\"), context.repair_marker_characterid, \"Missing vendor\", ml_global_information.Now + 50000)\n\t\tend\nend\ncontext.repair_marker_characterid = nil\nself:fail()",
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
								info = "Repair",
								monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
								runcode = "if(table.valid(context.repair_marker)) then\n\t\tlocal marker = context.repair_marker\n\t\tif(marker.distance > 1500) then\n\t\t\t\tself:fail()\n\t\t\t\treturn\n\t\tend\n\t\t\n\t\tlocal vendor = CharacterList:Get(marker.characterid) or GadgetList:Get(marker.characterid)\n\t\t\n\t\tif(table.valid(vendor)) then\n\t\t\tif(vendor.interactable and vendor.selectable) then\n\t\t\t\tif(vendor.distance > 130 or not vendor.isininteractrange) then\n\t\t\t\t\t\t\tself:fail()\n\t\t\t\t\t\t\treturn\n\t\t\t\tend\n\t\t\t\t\n\t\t\t\tPlayer:StopMovement()\n\n\t\t\t\tlocal target = Player:GetTarget()\n\t\t\t\tif(target == nil or target.id ~= vendor.id) then\n\t\t\t\t\t\tPlayer:SetTarget(vendor.id)\n\t\t\t\t\t\tself:running()\n\t\t\t\t\t\treturn\n\t\t\t\tend\n\n\t\t\t\tif(gw2_repair_manager.RepairAtVendor(vendor)) then\n\t\t\t\t\t\tself:running()\n\t\t\t\t\t\treturn\n\t\t\t\tend\n\t\t\telse\n\t\t\t\t\td(\"[Repair]: Vendor not interactable or not selectable.\")\n\t\t\t\t\tgw2_blacklistmanager.AddBlacklistEntry(GetString(\"Vendor repair\"), vendor.id, vendor.name, ml_global_information.Now + 1200000)\n\t\t\tend\n\t\telse\n\t\t\t\td(\"[Repair]: Vendor not found.\")\n\t\t\t\tgw2_blacklistmanager.AddBlacklistEntry(GetString(\"Vendor repair\"), marker.characterid, \"Vendor not found\", ml_global_information.Now + 1200000)\n\t\tend\nend\ncontext.repair_marker = nil\nself:fail()",
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
										info = "Move to repair marker",
										monitorcode = "GUI:Text('Last State: '..tostring(self:getState()))",
										runcode = "if(table.valid(context.repair_marker)) then\n\t\tcontext.moveto_position = context.repair_marker.pos\n\t\tself:success()\nelse\n\t\tself:fail()\nend",
										startcode = "",
									},
								},
								
								{
									class = "BehaviorTree",
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
								info = "Move to repair marker",
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
		filename = "Repair.st",
		finishcode = "",
		info = "Repair\nOptional parameter:\ncontext.repair_nearby = true/false",
		menucode = "",
		monitorcode = "GUI:Text('Last State: '..tostring(self:getState())) GUI:Text('Filename: '..self.variables.filename) GUI:Text('Filepath: '..self.filepath)",
		runcode = "",
		startcode = "",
		subtreeuicode = "",
	},
}



return tbl