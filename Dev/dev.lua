dev = {}
dev.open = false
dev.unfolded = true
dev.equipitemidx = 1
dev.equipitemlist = { [1] = "Back",[2] = "Chest",[3] = "Boots",[4] = "Gloves",[5] = "Headgear",[6] = "Leggings",[7] = "Shoulders", }
dev.teleportpos = { x =0,y =0, z =0, }
dev.noclip = false
dev.movementtype = { [0] = "Forward", [1] ="Backward", [2] ="Left", [3] ="Right", [4] ="TurnLeft", [5] ="TurnRight",[6] ="Evade",[7] ="AutoRunToggle", [8] ="WalkToggle", [9] ="Jump", [10] ="SwimUp", [11] ="SwimDown", [12] ="About_Face", [13] ="ForwardLeft", [14] ="ForwardRight", [15] ="BackwardLeft", [16] ="BackwardRight",}
dev.movementtypeidx = 0
dev.chatchannel = 0


function dev.Init()
	-- Register Button	
	ml_gui.ui_mgr:AddSubMember({ id = "GW2MINION##DEV_1", name = "Dev-Monitor", onClick = function() dev.open = not dev.open end, tooltip = "Open the Dev monitor.", texture = GetStartupPath().."\\GUI\\UI_Textures\\api.png"},"GW2MINION##MENU_HEADER","GW2MINION##MENU_ADDONS")	
end
RegisterEventHandler("Module.Initalize",dev.Init)

function dev.DrawCall(event, ticks )
	
	if ( dev.open  ) then 
		GUI:SetNextWindowPosCenter(GUI.SetCond_Appearing)
		GUI:SetNextWindowSize(500,400,GUI.SetCond_FirstUseEver) --set the next window size, only on first ever
		dev.unfolded, dev.open = GUI:Begin("Dev-Monitor", dev.open)
		if ( dev.unfolded ) then 
			local gamestate = GetGameState()
			
			GUI:PushStyleVar(GUI.StyleVar_FramePadding, 4, 0)
			GUI:PushStyleVar(GUI.StyleVar_ItemSpacing, 8, 2)
			
				if ( gamestate == GW2.GAMESTATE.GAMEPLAY ) then 
					if ( GUI:TreeNode("Character") ) then
						
						if ( GUI:TreeNode("Player") ) then
							local c = Player
							if ( c ) then dev.DrawCharacterDetails(c) else	GUI:Text("No Player Found") end
							GUI:TreePop()
						end
						if ( GUI:TreeNode("Target") ) then
							local c = Player:GetTarget()
							if ( c and c.ischaracter) then dev.DrawCharacterDetails(c) else	GUI:Text("No Target Found") end
							GUI:TreePop()
						end
						if ( GUI:TreeNode("Nearest") ) then
							local c = CharacterList("nearest")							
							if ( table.valid(c) ) then local id,e = next(c) dev.DrawCharacterDetails(e) else	GUI:Text("No Character Nearby") end
							GUI:TreePop()
						end
						if ( GUI:TreeNode("CharacterList") ) then							
							local c = CharacterList("")
							if ( table.valid(c) ) then 								
								for id, e in pairsByKeys(c) do
									if ( GUI:TreeNode(tostring(id).." - "..e.name) ) then
											dev.DrawCharacterDetails(e)							
										GUI:TreePop()
									end
								end
							end
							GUI:TreePop()
						end
						
						GUI:TreePop()				
					end
					
					if ( GUI:TreeNode("Gadget") ) then
						
						if ( GUI:TreeNode("Target") ) then
							local c = Player:GetTarget()
							if ( c and c.isgadget) then dev.DrawGadgetDetails(c) else	GUI:Text("No Gadget Found") end
							GUI:TreePop()
						end
						if ( GUI:TreeNode("Nearest") ) then
							local c = GadgetList("nearest")							
							if ( table.valid(c) ) then local id,e = next(c) dev.DrawGadgetDetails(e) else	GUI:Text("No Gadget Nearby") end
							GUI:TreePop()
						end
						if ( GUI:TreeNode("GadgetList") ) then							
							local c = GadgetList("")
							if ( table.valid(c) ) then 								
								for id, e in pairsByKeys(c) do
									if ( GUI:TreeNode(tostring(id).." - "..e.name) ) then
											dev.DrawGadgetDetails(e)							
										GUI:TreePop()
									end
								end
							end
							GUI:TreePop()
						end
						GUI:TreePop()				
					end
					
					if ( GUI:TreeNode("Agent") ) then
						if ( GUI:TreeNode("Target") ) then
							local c = Player:GetTarget()
							if ( c and not c.isgadget and not c.ischaracter) then dev.DrawAgentDetails(c) else GUI:Text("No Agent Found") end
							GUI:TreePop()
						end
						if ( GUI:TreeNode("Nearest") ) then
							local c = AgentList("nearest")
							if ( table.valid(c) ) then local id,e = next(c) dev.DrawAgentDetails(e) else	GUI:Text("No Agent Nearby") end
							GUI:TreePop()
						end
						if ( GUI:TreeNode("AgentList") ) then							
							local c = AgentList("")
							if ( table.valid(c) ) then 								
								for id, e in pairsByKeys(c) do
									if ( GUI:TreeNode(tostring(id)) ) then
											dev.DrawAgentDetails(e)							
										GUI:TreePop()
									end
								end
							end
							GUI:TreePop()
						end
						GUI:TreePop()				
					end
					
					if ( GUI:TreeNode("Buffs") ) then
						if ( GUI:TreeNode("Player") ) then
							local blist = Player.buffs	
							if ( table.valid(blist) )then
								GUI:PushItemWidth(250)
								for id, b in pairsByKeys(blist) do
									if ( GUI:TreeNode(tostring(id).."-"..b.name.."###buff"..id)) then
										GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##devb0",tostring(string.format( "%X",b.ptr)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
										GUI:BulletText("ID") GUI:SameLine(200) GUI:InputText("##devb1",tostring(b.id),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
										GUI:BulletText("ContentID") GUI:SameLine(200) GUI:InputText("##devb2",tostring(b.contentid),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
										GUI:BulletText("Stacks") GUI:SameLine(200) GUI:InputText("##devb3",tostring(b.stacks),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
										GUI:BulletText("Name") GUI:SameLine(200) GUI:InputText("##devb4",tostring(b.name),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
										GUI:BulletText("Description") GUI:SameLine(200) GUI:InputText("##devb5",tostring(string.gsub(b.description, "%\n", ", ")),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
										GUI:BulletText("Timeleft") GUI:SameLine(200) GUI:InputText("##devb6",tostring(b.timeleft),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
										GUI:BulletText("MaxDuration") GUI:SameLine(200) GUI:InputText("##devb7",tostring(b.maxduration),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
										GUI:BulletText("Active") GUI:SameLine(200) GUI:InputText("##devb8",tostring(b.active),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
										GUI:TreePop()
									end
								end							
								GUI:PopItemWidth()
							else
								GUI:Text("No Buffs found.") 
							end
							GUI:TreePop()						
						end
						if ( GUI:TreeNode("Target") ) then
							local t = Player:GetTarget()
							if (t) then
								local blist = t.buffs
								if ( table.valid(blist) )then
									GUI:PushItemWidth(250)
									for id, b in pairsByKeys(blist) do
										if ( GUI:TreeNode(tostring(id).."-"..b.name.."###buff"..id)) then
											GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##devb0",tostring(string.format( "%X",b.ptr)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
											GUI:BulletText("ID") GUI:SameLine(200) GUI:InputText("##devb1",tostring(b.id),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
											GUI:BulletText("ContentID") GUI:SameLine(200) GUI:InputText("##devb2",tostring(b.contentid),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
											GUI:BulletText("Stacks") GUI:SameLine(200) GUI:InputText("##devb3",tostring(b.stacks),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
											GUI:BulletText("Name") GUI:SameLine(200) GUI:InputText("##devb4",tostring(b.name),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
											GUI:BulletText("Description") GUI:SameLine(200) GUI:InputText("##devb5",tostring(string.gsub(b.description, "%\n", ", ")),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
											GUI:BulletText("Timeleft") GUI:SameLine(200) GUI:InputText("##devb6",tostring(b.timeleft),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
											GUI:BulletText("MaxDuration") GUI:SameLine(200) GUI:InputText("##devb7",tostring(b.maxduration),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
											GUI:BulletText("Active") GUI:SameLine(200) GUI:InputText("##devb8",tostring(b.active),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
											GUI:TreePop()
										end
									end							
									GUI:PopItemWidth()
								else
									GUI:Text("No Buffs found.") 
								end
							end
							GUI:TreePop()						
						end						
						GUI:TreePop()				
					end
					
					if ( GUI:TreeNode("Inventory") ) then
						local list = Inventory("")
						if ( table.valid(list) )then
							GUI:PushItemWidth(250)
							for id, b in pairsByKeys(list) do
								if ( GUI:TreeNode(tostring(id).."-"..b.name)) then
									GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##devi0",tostring(string.format( "%X",b.ptr)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("ID") GUI:SameLine(200) GUI:InputText("##devi1",tostring(b.itemid),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Stackcount") GUI:SameLine(200) GUI:InputText("##devi2",tostring(b.stackcount),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Rarity") GUI:SameLine(200) GUI:InputText("##devi3",tostring(b.rarity),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Itemtype") GUI:SameLine(200) GUI:InputText("##devi4",tostring(b.itemtype),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Weapontype") GUI:SameLine(200) GUI:InputText("##devi5",tostring(b.weapontype),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Durability") GUI:SameLine(200) GUI:InputText("##devi6",tostring(b.durability),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Soulbound") GUI:SameLine(200) GUI:InputText("##devi7",tostring(b.soulbound),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Salvagable") GUI:SameLine(200) GUI:InputText("##devi8",tostring(b.salvagable),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("IsMailable") GUI:SameLine(200) GUI:InputText("##devi9",tostring(b.ismailable),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("CanSellToTP") GUI:SameLine(200) GUI:InputText("##devi10",tostring(b.canselltotp),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									
									if (GUI:Button("Use",100,15) ) then d("Using Item Result: "..tostring(b:Use())) end
									GUI:SameLine(200)
									if (GUI:Button("Sell",100,15)) then d("Selling Item Result: "..tostring(b:Sell())) end
									
									if (GUI:Button("Equip",100,15) ) then d("Equip Item Result: "..tostring(b:Equip(dev.equipitemidx))) end
									GUI:SameLine(200) 
									dev.equipitemidx = GUI:Combo("EquipSlot", dev.equipitemidx, dev.equipitemlist)
									
									
									if (GUI:Button("SoulBind",100,15) ) then d("SoulBind Item Result: "..tostring(b:Bind())) end
									GUI:SameLine(200)
									if (GUI:Button("Salvage",100,15) ) then d("Salvage Item Result: "..tostring(b:Salvage())) end
									
									if (GUI:Button("Destroy",100,15) ) then d("Destroy Item Result: "..tostring(b:Destroy())) end
									
									GUI:TreePop()
								end
							end							
							GUI:PopItemWidth()
						else
							GUI:Text("No Inventory found.") 
						end
						GUI:TreePop()				
					end
					
					if ( GUI:TreeNode("Vendor") ) then
						GUI:BulletText("IsVendorOpened") GUI:SameLine(200) GUI:InputText("##devv0",tostring(Inventory:IsVendorOpened()),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)	
						local list = VendorItemList("")
						if ( table.valid(list) )then
							GUI:PushItemWidth(250)
							for id, b in pairsByKeys(list) do
								if ( GUI:TreeNode(tostring(id).."-"..b.name)) then
									GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##devv1",tostring(string.format( "%X",b.ptr)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("ID") GUI:SameLine(200) GUI:InputText("##devv2",tostring(b.itemid),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Rarity") GUI:SameLine(200) GUI:InputText("##devv3",tostring(b.rarity),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Itemtype") GUI:SameLine(200) GUI:InputText("##devv4",tostring(b.itemtype),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Weapontype") GUI:SameLine(200) GUI:InputText("##devv5",tostring(b.weapontype),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Price") GUI:SameLine(200) GUI:InputText("##devv6",tostring(b.price),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Quantity") GUI:SameLine(200) GUI:InputText("##devi7",tostring(b.quantity),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									
									if (GUI:Button("Buy",100,15) ) then d("Buy Item Result: "..tostring(b:Buy())) end
																		
									GUI:TreePop()
								end
							end							
							GUI:PopItemWidth()
						else
							GUI:Text("No Inventory found.") 
						end
						GUI:TreePop()				
					end
					
					if ( GUI:TreeNode("Conversation") ) then
						GUI:PushItemWidth(250)
						GUI:BulletText("IsConversationOpen") GUI:SameLine(200) GUI:InputText("##devc1",tostring(Player:IsConversationOpen()),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						local clist = Player:GetConversationOptions()
						if (table.valid(clist)) then 
							for cid,b in pairsByKeys(clist) do
								if ( GUI:TreeNode(tostring(cid))) then
									GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##devc2",tostring(string.format( "%X",b.ptr)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Listindex") GUI:SameLine(200) GUI:InputText("##devsk1",tostring(b.index),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("ID") GUI:SameLine(200) GUI:InputText("##devsk1",tostring(b.id),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Type") GUI:SameLine(200) GUI:InputText("##devsk1",tostring(b.type),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									if (GUI:Button("Select conversation by index",250,18) ) then d("Result: "..tostring(Player:SelectConversationOptionByIndex(cid))) end
									if (GUI:Button("Select conversation by type",250,18) ) then d("Result: "..tostring(Player:SelectConversationOption(b.type))) end
									GUI:TreePop()
								end
							end
						end						
						GUI:PopItemWidth()
						GUI:TreePop()					
					end
					
					if ( GUI:TreeNode("MapMarker") ) then						
						if ( GUI:TreeNode("Nearest") ) then							
							local list = MapMarkerList("nearest")
							GUI:PushItemWidth(250)
							if ( table.valid(list) ) then local id,e = next(list) dev.DrawMapMarkerDetails(id,e) else	GUI:Text("No MapMarker Nearby") end	
							GUI:PopItemWidth()
							GUI:TreePop()	
						end
						if ( GUI:TreeNode("Events") ) then
							local list = MapMarkerList("isevent")
							if ( table.valid(list) )then
								for id, b in pairsByKeys(list) do
									dev.DrawMapMarkerDetails(id,b)
								end	
							else
								GUI:Text("No Events found.") 
							end					
							GUI:TreePop()	
						end
						if ( GUI:TreeNode("List") ) then
							local list = MapMarkerList("")
							if ( table.valid(list) )then
								for id, b in pairsByKeys(list) do
									dev.DrawMapMarkerDetails(id,b)
								end	
							else
								GUI:Text("No MapMarker found.") 
							end						
							GUI:TreePop()	
						end
						GUI:TreePop()				
					end
					
					if ( GUI:TreeNode("Waypoints") ) then
						local list = WaypointList("")
						if ( table.valid(list) )then
							GUI:PushItemWidth(250)
							for id, b in pairsByKeys(list) do
								if ( GUI:TreeNode(tostring(id).."-"..b.name)) then
									GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##devw0",tostring(string.format( "%X",b.ptr)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("ID") GUI:SameLine(200) GUI:InputText("##devw1",tostring(b.id),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Name") GUI:SameLine(200) GUI:InputText("##devw8",b.name,GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									local p = b.pos
									GUI:BulletText("Position") GUI:SameLine(200)  GUI:InputFloat3( "##devw2", p.x, p.y, p.z, 2, GUI.InputTextFlags_ReadOnly)
									GUI:BulletText("Distance") GUI:SameLine(200) GUI:InputFloat("##devw3", b.distance,0,0,2)
									GUI:BulletText("PathDistance") GUI:SameLine(200) GUI:InputFloat("##devw4", b.pathdistance,0,0,2)
									GUI:BulletText("OnMesh") GUI:SameLine(200) GUI:InputText("##devw5",tostring(b.onmesh),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Contested") GUI:SameLine(200) GUI:InputText("##devw6",tostring(b.contested),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("SameZone") GUI:SameLine(200) GUI:InputText("##devw7",tostring(b.samezone),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									
									if (GUI:Button("TeleportTo",100,15) ) then d("Buy TeleportTo Result: "..tostring(Player:TeleportToWaypoint(b.id))) end
																		
									GUI:TreePop()
								end
							end							
							GUI:PopItemWidth()
						else
							GUI:Text("No Inventory found.") 
						end
						GUI:TreePop()				
					end
					
					if ( GUI:TreeNode("PvP") ) then
						GUI:BulletText("IsInPvPLobby") GUI:SameLine(200) GUI:InputText("##devp1",tostring(PvPManager:IsInPvPLobby()),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						GUI:BulletText("IsInMatch") GUI:SameLine(200) GUI:InputText("##devp2",tostring(PvPManager:IsInMatch()),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						GUI:BulletText("IsArenaQueued") GUI:SameLine(200) GUI:InputText("##devp3",tostring(PvPManager:IsArenaQueued()),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						GUI:BulletText("IsMatchAvailable") GUI:SameLine(200) GUI:InputText("##devp4",tostring(PvPManager:IsMatchAvailable()),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						GUI:BulletText("IsMatchStarted") GUI:SameLine(200) GUI:InputText("##devp5",tostring(PvPManager:IsMatchStarted()),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						GUI:BulletText("IsMatchFinished") GUI:SameLine(200) GUI:InputText("##devp6",tostring(PvPManager:IsMatchFinished()),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						GUI:BulletText("MatchDuration") GUI:SameLine(200) GUI:InputText("##devp7",tostring(PvPManager:GetMatchDuration()),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						
						if (GUI:Button("Join PvP Lobby",150,15) ) then d("Join PvP Lobby: "..tostring(PvPManager:JoinPvPLobby())) end GUI:SameLine()
						if (GUI:Button("Leave PvP Lobby",150,15) ) then d("Leave PvP Lobby: "..tostring(PvPManager:LeavePvPLobby())) end
						if (GUI:Button("Join Unranked Queue",150,15) ) then d("Join Unranked Queue: "..tostring(PvPManager:JoinArenaQueue(1))) end
						if (GUI:Button("Leave Unranked Queue",150,15) ) then d("Leave Unranked Queue: "..tostring(PvPManager:LeaveArenaQueue())) end
						if (GUI:Button("Set Ready",150,15) ) then d("Set Ready: "..tostring(PvPManager:SetReady())) end
						
						GUI:BulletText("CanJoinTeamRED") GUI:SameLine(200) GUI:InputText("##devp7",tostring(PvPManager:CanJoinTeam(1)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						GUI:BulletText("CanJoinTeamBLUE") GUI:SameLine(200) GUI:InputText("##devp7",tostring(PvPManager:CanJoinTeam(2)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
					
						if (GUI:Button("Join Red",150,15) ) then d("JoinRed Result: "..tostring(PvPManager:JoinTeam(1))) end GUI:SameLine()
						if (GUI:Button("Join Blue",150,15) ) then d("JoinRed Result: "..tostring(PvPManager:JoinTeam(2))) end
						
						GUI:TreePop()				
					end
					
					if ( GUI:TreeNode("Party") ) then
						local list = Player:GetParty()
						if ( table.valid(list) )then
							GUI:PushItemWidth(250)
							for id, b in pairsByKeys(list) do
								if ( GUI:TreeNode(tostring(id).."-"..b.name)) then
									GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##devp0",tostring(string.format( "%X",b.ptr)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("ID") GUI:SameLine(200) GUI:InputText("##devp1",tostring(b.id),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("MapID") GUI:SameLine(200) GUI:InputText("##devp2", tostring(b.mapid),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("HomeServerID") GUI:SameLine(200) GUI:InputText("##devp3", tostring(b.homeserverid),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("CurrentServerID") GUI:SameLine(200) GUI:InputText("##devp4",tostring(b.currentserverid),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("InstanceServerID") GUI:SameLine(200) GUI:InputText("##devw5",tostring(b.instanceserverid),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("ConnectStatus") GUI:SameLine(200) GUI:InputText("##devw6",tostring(b.connectstatus),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("InviteStatus") GUI:SameLine(200) GUI:InputText("##devw6",tostring(b.invitestatus),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("HasParty") GUI:SameLine(200) GUI:InputText("##devw6",tostring(b.hasparty),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Profession") GUI:SameLine(200) GUI:InputText("##devw6",tostring(b.profession),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Level") GUI:SameLine(200) GUI:InputText("##devw6",tostring(b.level),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Unknown0") GUI:SameLine(200) GUI:InputText("##devw6",tostring(b.isunknown0),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Unknown1") GUI:SameLine(200) GUI:InputText("##devw6",tostring(b.isunknown1),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:TreePop()
								end
							end							
							GUI:PopItemWidth()
						else
							GUI:Text("No Inventory found.") 
						end
						GUI:TreePop()					
					end
					
					if ( GUI:TreeNode("Skills") ) then
						GUI:BulletText("IsCasting") GUI:SameLine(200) GUI:InputText("##devs1",tostring(Player:IsCasting()),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						GUI:BulletText("CanCast") GUI:SameLine(200) GUI:InputText("##devs2",tostring(Player:CanCast()),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						GUI:BulletText("IsSkillPending") GUI:SameLine(200) GUI:InputText("##devs3",tostring(Player:IsSkillPending()),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						GUI:BulletText("CurrentSpell") GUI:SameLine(200) GUI:InputText("##devs4",tostring(Player:GetCurrentlyCastedSpell()),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						GUI:BulletText("CurrentWeaponSetID") GUI:SameLine(200) GUI:InputText("##devs5",tostring(Player:GetCurrentWeaponSet()),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						GUI:BulletText("CurrentTransformID") GUI:SameLine(200) GUI:InputText("##devs6",tostring(Player:GetTransformID()),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						GUI:BulletText("CanSwapWeaponSet") GUI:SameLine(200) GUI:InputText("##devs7",tostring(Player:CanSwapWeaponSet()),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						if (GUI:Button("SwapWeaponSet",150,15) ) then d("SwapWeaponSet Result: "..tostring(Player:SwapWeaponSet())) end
						GUI:PushItemWidth(250)
						for i=0,20 do
							local b = Player:GetSpellInfo(i)
							if (table.valid(b)) then 
								if ( GUI:TreeNode(tostring(i).."-"..b.name)) then
									GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##devsk0",tostring(string.format( "%X",b.ptr)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Slot") GUI:SameLine(200) GUI:InputText("##devsk1",tostring(b.slot),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("ID") GUI:SameLine(200) GUI:InputText("##devsk2",tostring(b.skillid),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("ContentID") GUI:SameLine(200) GUI:InputText("##devsk3", tostring(b.contentid),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Cooldown") GUI:SameLine(200) GUI:InputText("##devsk4", tostring(b.cooldown),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("CooldownMax") GUI:SameLine(200) GUI:InputText("##devsk5",tostring(b.cooldownmax),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("MinRange") GUI:SameLine(200) GUI:InputText("##devsk6",tostring(b.minrange),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("MaxRange") GUI:SameLine(200) GUI:InputText("##devsk7",tostring(b.maxrange),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Radius") GUI:SameLine(200) GUI:InputText("##devsk8",tostring(b.radius),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Skilltype") GUI:SameLine(200) GUI:InputText("##devsk9",tostring(b.skilltype),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("Power") GUI:SameLine(200) GUI:InputText("##devsk10",tostring(b.power),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									GUI:BulletText("IsGroundTargeted") GUI:SameLine(200) GUI:InputText("##devsk11",tostring(b.isgroundtargeted),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
									if (GUI:Button("Cast",150,15) ) then 
										local t = Player:GetTarget()
										if ( t ) then
											Player:CastSpell(i,t.id)
										else
											Player:CastSpell(i)
										end
									end
									GUI:TreePop()
								end
							end
						end
						GUI:PopItemWidth()
						GUI:TreePop()
					end
					
					if ( GUI:TreeNode("Pet") ) then
						GUI:PushItemWidth(250)
						GUI:BulletText("CanSwitchPet") GUI:SameLine(200) GUI:InputText("##devp1",tostring(Player:CanSwitchPet()),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						GUI:BulletText("HasPet") GUI:SameLine(200) GUI:InputText("##devp2",tostring(Player:GetPet() ~=nil),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						if (GUI:Button("Switch Pet",150,15) ) then d("Switch Pet Result: "..tostring(Player:SwitchPet())) end
						GUI:PopItemWidth()
						GUI:TreePop()
					end

					if ( GUI:TreeNode("Instances") ) then
						GUI:PushItemWidth(250)
						GUI:BulletText("IsInstanceDialogShown") GUI:SameLine(200) GUI:InputText("##devin1",tostring(Player:IsInstanceDialogShown()))
						local dInfo = Player:GetInstanceInfo()
						if (dInfo) then
							GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##devin16",tostring(string.format( "%X",dInfo.ptr)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("Ptr2") GUI:SameLine(200) GUI:InputText("##devin15",tostring(string.format( "%X",dInfo.ptr2)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("EntryID") GUI:SameLine(200) GUI:InputText("##devin2",tostring(dInfo.instanceEntryID),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("ModeID") GUI:SameLine(200) GUI:InputText("##devin3",tostring(dInfo.instanceModeID),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("ModeID2") GUI:SameLine(200) GUI:InputText("##devin4",tostring(dInfo.instanceMode2ID),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("InstanceID") GUI:SameLine(200) GUI:InputText("##devin5",tostring(dInfo.instanceID),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("IsRegistered") GUI:SameLine(200) GUI:InputText("##devin6",tostring(dInfo.isInstanceRegistered),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("Unknown0") GUI:SameLine(200) GUI:InputText("##devin7",tostring(dInfo.isunknown0),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("Unknown1") GUI:SameLine(200) GUI:InputText("##devin8",tostring(dInfo.isunknown1),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("Unknown2") GUI:SameLine(200) GUI:InputText("##devin9",tostring(dInfo.isunknown2),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("Unknown3") GUI:SameLine(200) GUI:InputText("##devin10",tostring(dInfo.isunknown3),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("Unknown4") GUI:SameLine(200) GUI:InputText("##devin11",tostring(dInfo.isunknown4),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("Unknown5") GUI:SameLine(200) GUI:InputText("##devin12",tostring(dInfo.isunknown5),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("Unknown6") GUI:SameLine(200) GUI:InputText("##devin13",tostring(dInfo.isunknown6),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							if (GUI:Button("StartNewInstance",150,15) ) then d("StartNewInstance Result: "..tostring(Player:OpenInstance())) end
							GUI:SameLine()
							if (GUI:Button("JoinInstance",150,15) ) then d("JoinInstance Result: "..tostring(Player:JoinInstance())) end
							if (GUI:Button("LeaveInstance",150,15) ) then d("LeaveInstance Result: "..tostring(Player:LeaveInstance())) end
							GUI:SameLine()
							if (GUI:Button("ResetInstance",150,15) ) then d("ResetInstance Result: "..tostring(Player:ResetInstance())) end
							
						end						
						GUI:BulletText("CanClaimReward") GUI:SameLine(200) GUI:InputText("##devin14",tostring(Player:CanClaimReward()),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						if (GUI:Button("ClaimReward",150,15) ) then d("ClaimReward Result: "..tostring(Player:ClaimReward())) end
						
						GUI:PopItemWidth()
						GUI:TreePop()					
					end					
					
					if ( GUI:TreeNode("Quests") ) then
						GUI:PushItemWidth(250)
						local qm = QuestManager:GetActiveQuest()
						if ( table.valid(qm) ) then
							GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##devqe0",tostring(string.format( "%X",qm.ptr)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("Ptr2") GUI:SameLine(200) GUI:InputText("##devqe1",tostring(string.format( "%X",qm.ptr2)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("StoryName") GUI:SameLine(200) GUI:InputText("##devq0",qm.storyname,GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("StoryID") GUI:SameLine(200) GUI:InputText("##devq1",tostring(qm.storyid),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("Ptr3") GUI:SameLine(200) GUI:InputText("##devqe2",tostring(string.format( "%X",qm.ptr3)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("QuestName") GUI:SameLine(200) GUI:InputText("##devq2",qm.questname,GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("QuestID") GUI:SameLine(200) GUI:InputText("##devq3",tostring(qm.questid),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("QuestComplete") GUI:SameLine(200) GUI:InputText("##devq4",tostring(qm.isquestcomplete),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("Ptr4") GUI:SameLine(200) GUI:InputText("##devqe3",tostring(string.format( "%X",qm.ptr4)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("QuestGoalName") GUI:SameLine(200) GUI:InputText("##devq5",qm.questgoalname,GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("QuestGoalID") GUI:SameLine(200) GUI:InputText("##devq6",tostring(qm.questgoalid),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("QuestStepCurrent") GUI:SameLine(200) GUI:InputText("##devq7",tostring(qm.stepcurrent),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("QuestStepMax") GUI:SameLine(200) GUI:InputText("##devq8",tostring(qm.stepmax),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("QuestStepName") GUI:SameLine(200) GUI:InputText("##devq9",qm.stepname,GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("QuestStepUnknown1") GUI:SameLine(200) GUI:InputText("##devq10",tostring(qm.stepu1),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("QuestStepUnknown2") GUI:SameLine(200) GUI:InputText("##devq11",tostring(qm.stepu2),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("QuestStepUnknown3") GUI:SameLine(200) GUI:InputText("##devq12",tostring(qm.stepu3),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("QuestStepUnknown4") GUI:SameLine(200) GUI:InputText("##devq13",tostring(qm.stepu4),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("QuestStepUnknown5") GUI:SameLine(200) GUI:InputText("##devq14",tostring(qm.stepu5),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							GUI:BulletText("RewardCount") GUI:SameLine(200) GUI:InputText("##devq14",tostring(qm.questrewardcount),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
							local qmr = QuestManager:GetActiveQuestRewardList()
							if ( table.valid(qmr) ) then
								for qid,q in pairsByKeys(qmr) do
									if ( GUI:TreeNode(tostring(qid).."-"..q.name)) then
										GUI:BulletText("Ptr5") GUI:SameLine(200) GUI:InputText("##devqe4",tostring(string.format( "%X",qm.ptr5 or 0)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
										GUI:BulletText("Ptr6") GUI:SameLine(200) GUI:InputText("##devqe5",tostring(string.format( "%X",qm.ptr6 or 0)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
										GUI:BulletText("RewardItemID") GUI:SameLine(200) GUI:InputText("##devq15"..tostring(qid),tostring(q.itemid),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
										GUI:BulletText("RewardCount") GUI:SameLine(200) GUI:InputText("##devq16"..tostring(qid),tostring(q.count),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
										GUI:BulletText("RewardSelectable") GUI:SameLine(200) GUI:InputText("##devq17"..tostring(qid),tostring(q.selectable),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
										GUI:BulletText("RewardUnknown") GUI:SameLine(200) GUI:InputText("##devq18"..tostring(qid),tostring(q.isunknown1),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
										GUI:TreePop()
									end
								end
							end
						end
						GUI:PopItemWidth()
						GUI:TreePop()
					end
					
					if ( GUI:TreeNode("Chat") ) then
						GUI:PushItemWidth(250)
						GUI:BulletText("Channel") GUI:SameLine(200) dev.chatchannel = GUI:InputInt("##devmm8",dev.chatchannel ,1,1)
						local txt = GetChatMsg(dev.chatchannel,100)
						if (table.valid(txt)) then 
							local text = ""
							for line,tx in pairsByKeys(txt) do
								text = text.."\n "..tx
							end
							GUI:InputTextMultiline( "##getchatstuf", text, GUI:GetWindowContentRegionWidth()-50, 200 , GUI.InputTextFlags_ReadOnly)
						end						
						GUI:PopItemWidth()
						GUI:TreePop()					
					end
					
					if ( GUI:TreeNode("Hacks") ) then
						GUI:PushItemWidth(250)						
						GUI:BulletText("Position") GUI:SameLine(200)  GUI:InputFloat3( "##devh1", dev.teleportpos.x, dev.teleportpos.y, dev.teleportpos.z, 2, GUI.InputTextFlags_ReadOnly)
						if (GUI:Button("UseCurrentPos",150,15) ) then dev.teleportpos = Player.pos end GUI:SameLine()
						if (GUI:Button("Teleport",150,15) ) then d(HackManager:Teleport(tonumber(dev.teleportpos.x),tonumber(dev.teleportpos.y),tonumber(dev.teleportpos.z))) end
						
						
						GUI:BulletText("Zoom") GUI:SameLine(150) local v, d = GUI:InputFloat("##devh9",HackManager:GetZoom(),10,100,2)
						if ( d ) then HackManager:SetZoom(tonumber(v)) end
						GUI:BulletText("Speed") GUI:SameLine(150) local v, b = GUI:InputFloat("##devh2",HackManager:GetSpeed(),1,10,2)
						if ( b ) then HackManager:SetSpeed(tonumber(v)) end
						GUI:BulletText("Gravity") GUI:SameLine(150) v, b = GUI:InputFloat("##devh3",HackManager:GetGravity(),1,10,2)
						if ( b ) then HackManager:SetGravity(tonumber(v)) end
						GUI:BulletText("MaxClimb") GUI:SameLine(150) v, b = GUI:InputFloat("##devh4",HackManager:GetCrawlHeight(),1,10,2)
						if ( b ) then HackManager:SetCrawlHeight(tonumber(v)) end

						GUI:BulletText("Hover") GUI:SameLine(150) v, b = GUI:Checkbox("##devh5",HackManager.Hover)
						if ( b ) then HackManager.Hover = v end						
						GUI:BulletText("Infinite Jump") GUI:SameLine(150) v, b = GUI:Checkbox("##devh6",HackManager.Jump)
						if ( b ) then HackManager.Jump = v end
						GUI:BulletText("ExtendGlider") GUI:SameLine(150) v, b = GUI:Checkbox("##devh7",HackManager.ExtendGlider)
						if ( b ) then HackManager.ExtendGlider = v end
						GUI:BulletText("NoClip") GUI:SameLine(150) dev.noclip, b = GUI:Checkbox("##devh8",dev.noclip)
						if ( b ) then HackManager:NoClip(dev.noclip) end

						
						GUI:PopItemWidth()
						GUI:TreePop()					
					end
					
					if ( GUI:TreeNode("Movement") ) then
						GUI:PushItemWidth(250)						
						GUI:BulletText("CanMove") GUI:SameLine(200) GUI:InputText("##devmm1",tostring(Player:CanMove()),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						GUI:BulletText("IsMoving") GUI:SameLine(200) GUI:InputText("##devmm2",tostring(Player:IsMoving()),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						GUI:BulletText("MovementState") GUI:SameLine(200) GUI:InputText("##devmm3",tostring(Player:GetMovementState()),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						local movstr = ""
						local movdirs = Player:GetMovement()
						if (movdirs.forward) then movstr = "forward" end
						if (movdirs.left) then movstr = movstr.." left" end
						if (movdirs.right) then movstr = movstr.." right" end
						if (movdirs.backward) then movstr = movstr.." backward" end
						GUI:BulletText("MovementDirection") GUI:SameLine(200) GUI:InputText("##devmm4",movstr,GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						GUI:BulletText("Direction") GUI:SameLine(200) dev.movementtypeidx = GUI:Combo("##movedir", dev.movementtypeidx, dev.movementtype)
						if (GUI:Button("Set Direction",150,15) ) then d("Moving..") Player:SetMovement(tonumber(dev.movementtypeidx)) end 
						GUI:SameLine() if (GUI:Button("UnSet Direction",150,15) ) then Player:UnSetMovement(dev.movementtypeidx) end
						if (GUI:Button("Jump",150,15) ) then Player:Jump() end  GUI:SameLine() if (GUI:Button("Evade",150,15) ) then Player:Evade(dev.movementtypeidx) end 
						if (GUI:Button("FaceTarget",150,15) ) then 
							local t = Player:GetTarget()
							if ( t ) then
								d(Player:SetFacing(t.pos.x,t.pos.y,t.pos.z))
							end
						end GUI:SameLine()
						if (GUI:Button("FaceTargetExact",150,15) ) then 
							local t = Player:GetTarget()
							if ( t ) then
								d(Player:SetFacingExact(t.pos.x,t.pos.y,t.pos.z,true))
							end
						end		
						GUI:PopItemWidth()
						GUI:TreePop()					
					end
										
					if ( GUI:TreeNode("Functions & Other Infos") ) then
						GUI:PushItemWidth(250)
						GUI:BulletText("Local MapID") GUI:SameLine(200) GUI:InputText("##devff1",tostring(Player:GetLocalMapID()),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
						
						if (GUI:Button("AoE Loot",150,15) ) then Player:AoELoot() end
						if (GUI:Button("Interact/Use",150,15) ) then 
							local t = Player:GetTarget()
							if ( t ) then
								d(Player:Interact(t.id))
							else
								d(Player:Interact())
							end
						end
						GUI:PopItemWidth()
						GUI:TreePop()
					end
					
					
				end
			GUI:PopStyleVar(2)
		end
		GUI:End()
	end
end
RegisterEventHandler("Gameloop.Draw", dev.DrawCall)

function dev.DrawCharacterDetails(c)
	
	GUI:PushItemWidth(250)
	GUI:BulletText("CharPtr") GUI:SameLine(200) GUI:InputText("##dev0",tostring(string.format( "%X",c.ptr)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("AgentPtr") GUI:SameLine(200) GUI:InputText("##dev1",tostring(string.format( "%X",c.ptr2)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("ID") GUI:SameLine(200) GUI:InputText("##dev2",tostring(c.id),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("ContentID") GUI:SameLine(200) GUI:InputText("##dev3",tostring(c.contentid),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Name") GUI:SameLine(200) GUI:InputText("##dev6",c.Name,GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	local h = c.health
	GUI:BulletText("Health") GUI:SameLine(200)  GUI:InputFloat3( "##dev7", h.current, h.max, h.percent, 2, GUI.InputTextFlags_ReadOnly)
	local p = c.pos
	GUI:BulletText("Position") GUI:SameLine(200)  GUI:InputFloat3( "##dev9", p.x, p.y, p.z, 2, GUI.InputTextFlags_ReadOnly)
	GUI:BulletText("Heading") GUI:SameLine(200)  GUI:InputFloat3( "##dev10", p.hx, p.hy, p.hz, 2, GUI.InputTextFlags_ReadOnly)
	GUI:BulletText("Height/Radius") GUI:SameLine(200)  GUI:InputFloat2( "##dev11", c.height, c.radius, 2, GUI.InputTextFlags_ReadOnly)
	GUI:BulletText("Distance") GUI:SameLine(200) GUI:InputFloat("##dev12", c.distance,0,0,2)
	GUI:BulletText("PathDistance") GUI:SameLine(200) GUI:InputFloat("##dev13", c.pathdistance,0,0,2)
	GUI:BulletText("LoS") GUI:SameLine(200) GUI:InputText("##dev14", tostring(c.los),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("OnMesh") GUI:SameLine(200) GUI:InputText("##dev15", tostring(c.onmesh),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("OnMeshExact") GUI:SameLine(200) GUI:InputText("##dev16", tostring(c.onmeshexact),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Attitude") GUI:SameLine(200) GUI:InputText("##dev23", tostring(c.attitude),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("MovementState") GUI:SameLine(200) GUI:InputText("##dev17", tostring(c.movementstate),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("SwimmingState") GUI:SameLine(200) GUI:InputText("##dev17-b", tostring(c.swimming),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	local facedir = Player:IsFacingTarget(c.id)
	local mifacet = ""
	if ( facedir == 1 ) then
		mifacet = "InFront"
	elseif( facedir == 2) then
		mifacet = "Flanking"
	elseif( facedir == 3) then
		mifacet = "Behind"
	elseif( facedir == false) then
		mifacet = "Not Facing"
	end
	GUI:BulletText("IsPlayerFacingTarget") GUI:SameLine(200) GUI:InputText("##dev68", mifacet,GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Speed") GUI:SameLine(200) GUI:InputFloat("##dev18", c.speed,0,0,2)	
	GUI:BulletText("Profession") GUI:SameLine(200) GUI:InputText("##dev19", tostring(c.profession),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Level") GUI:SameLine(200) GUI:InputText("##dev23", tostring(c.level),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsInInteractRange") GUI:SameLine(200) GUI:InputText("##dev20", tostring(c.isininteractrange),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Interactable") GUI:SameLine(200) GUI:InputText("##dev21", tostring(c.interactable),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Selectable") GUI:SameLine(200) GUI:InputText("##dev22", tostring(c.selectable),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Attackable") GUI:SameLine(200) GUI:InputText("##dev23", tostring(c.attackable),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Lootable") GUI:SameLine(200) GUI:InputText("##dev23", tostring(c.lootable),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Has Pet") GUI:SameLine(200) GUI:InputText("##dev23", tostring(c.haspet),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Alive") GUI:SameLine(200) GUI:InputText("##dev23", tostring(c.alive),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Downed") GUI:SameLine(200) GUI:InputText("##dev23", tostring(c.downed),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Dead") GUI:SameLine(200) GUI:InputText("##dev23", tostring(c.dead),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Aggro") GUI:SameLine(200) GUI:InputText("##dev23", tostring(c.isaggro),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("AggroPercent") GUI:SameLine(200) GUI:InputText("##dev23", tostring(c.aggropercent),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("InCombat") GUI:SameLine(200) GUI:InputText("##dev23", tostring(c.incombat),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	local castinfo = c.castinfo
	if ( TableSize(castinfo) > 0 ) then
		GUI:BulletText("AttackedTargetPtr") GUI:SameLine(200) GUI:InputText("##dev24",tostring(string.format( "%X",castinfo.ptr)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("AttackedTargetID") GUI:SameLine(200) GUI:InputText("##dev25", tostring(castinfo.targetID),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("Current SpellID") GUI:SameLine(200) GUI:InputText("##dev26", tostring(castinfo.skillID),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("Last SpellID") GUI:SameLine(200) GUI:InputText("##dev27", tostring(castinfo.lastSkillID),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("Skill Slot") GUI:SameLine(200) GUI:InputText("##dev28", tostring(castinfo.slot),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("Skill Duration") GUI:SameLine(200) GUI:InputText("##dev29", tostring(castinfo.duration),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	else
		GUI:BulletText("castinfo MISSING!")
	end
	GUI:BulletText("IsControlled") GUI:SameLine(200) GUI:InputText("##dev30", tostring(c.iscontrolled),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsPlayer") GUI:SameLine(200) GUI:InputText("##dev31", tostring(c.isplayer),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsPet") GUI:SameLine(200) GUI:InputText("##dev32", tostring(c.ispet),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("HasOwner") GUI:SameLine(200) GUI:InputText("##dev32", tostring(c.hasowner),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsMonster") GUI:SameLine(200) GUI:InputText("##dev33", tostring(c.ismonster),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsClone") GUI:SameLine(200) GUI:InputText("##dev34", tostring(c.isclone),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsCritter") GUI:SameLine(200) GUI:InputText("##dev35", tostring(c.iscritter),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsEventNPC") GUI:SameLine(200) GUI:InputText("##dev36", tostring(c.iseventnpc),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsElite") GUI:SameLine(200) GUI:InputText("##dev37", tostring(c.iselite),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsChampion") GUI:SameLine(200) GUI:InputText("##dev38", tostring(c.ischampion),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsVeteran") GUI:SameLine(200) GUI:InputText("##dev39", tostring(c.isveteran),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsLegendary") GUI:SameLine(200) GUI:InputText("##dev40", tostring(c.islegendary),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsGathering") GUI:SameLine(200) GUI:InputText("##dev41", tostring(c.isgathering),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsMiniature") GUI:SameLine(200) GUI:InputText("##dev42", tostring(c.isminiature),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsMesmerClone") GUI:SameLine(200) GUI:InputText("##dev43", tostring(c.ismesmerclone),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("HasDialog") GUI:SameLine(200) GUI:InputText("##dev44", tostring(c.hasdialog),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsTurret") GUI:SameLine(200) GUI:InputText("##dev45", tostring(c.isturret),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("HasSpeechBubble") GUI:SameLine(200) GUI:InputText("##dev46", tostring(c.hasspeechbubble),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("ScriptIsIdle") GUI:SameLine(200) GUI:InputText("##dev47", tostring(c.scriptisidle),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsHeartQuestGiver") GUI:SameLine(200) GUI:InputText("##dev48", tostring(c.isheartquestgiver),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Unknown2") GUI:SameLine(200) GUI:InputText("##dev49", tostring(c.isunknown2),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Unknown3") GUI:SameLine(200) GUI:InputText("##dev50", tostring(c.isunknown3),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Unknown6") GUI:SameLine(200) GUI:InputText("##dev51", tostring(c.isunknown6),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Unknown10") GUI:SameLine(200) GUI:InputText("##dev52", tostring(c.isunknown10),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	
	
	GUI:PopItemWidth()
end

function dev.DrawGadgetDetails(c)
	GUI:PushItemWidth(250)
	GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##devg0",tostring(string.format( "%X",c.ptr)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("ID") GUI:SameLine(200) GUI:InputText("##devg1",tostring(c.id),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("ContentID") GUI:SameLine(200) GUI:InputText("##devg2",tostring(c.contentid),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("ContentID2") GUI:SameLine(200) GUI:InputText("##devg3",tostring(c.contentid2),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Type") GUI:SameLine(200) GUI:InputText("##devg4",tostring(c.type),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Type2") GUI:SameLine(200) GUI:InputText("##devg5",tostring(c.type2),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Name") GUI:SameLine(200) GUI:InputText("##devg6",c.Name,GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Status") GUI:SameLine(200) GUI:InputText("##devg7",c.status,GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	local h = c.health
	if ( table.valid(h) ) then 
		GUI:BulletText("Health") GUI:SameLine(200)  GUI:InputFloat3( "##devg8", h.current, h.max, h.percent, 2, GUI.InputTextFlags_ReadOnly)
	end	
	local p = c.pos
	GUI:BulletText("Position") GUI:SameLine(200)  GUI:InputFloat3( "##devg9", p.x, p.y, p.z, 2, GUI.InputTextFlags_ReadOnly)
	GUI:BulletText("Heading") GUI:SameLine(200)  GUI:InputFloat3( "##devg10", p.hx, p.hy, p.hz, 2, GUI.InputTextFlags_ReadOnly)
	GUI:BulletText("Height/Radius") GUI:SameLine(200)  GUI:InputFloat2( "##devg11", c.height, c.radius, 2, GUI.InputTextFlags_ReadOnly)	
	GUI:BulletText("Distance") GUI:SameLine(200) GUI:InputFloat("##devg12", c.distance,0,0,2)
	GUI:BulletText("PathDistance") GUI:SameLine(200) GUI:InputFloat("##devg13", c.pathdistance,0,0,2)	
	GUI:BulletText("LoS") GUI:SameLine(200) GUI:InputText("##devg14", tostring(c.los),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("OnMesh") GUI:SameLine(200) GUI:InputText("##devg15", tostring(c.onmesh),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("OnMeshExact") GUI:SameLine(200) GUI:InputText("##devg16", tostring(c.onmeshexact),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Attitude") GUI:SameLine(200) GUI:InputText("##devg17", tostring(c.attitude),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsInInteractRange") GUI:SameLine(200) GUI:InputText("##devg18", tostring(c.isininteractrange),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Interactable") GUI:SameLine(200) GUI:InputText("##devg21", tostring(c.interactable),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Selectable") GUI:SameLine(200) GUI:InputText("##devg22", tostring(c.selectable),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Attackable") GUI:SameLine(200) GUI:InputText("##devg23", tostring(c.attackable),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Lootable") GUI:SameLine(200) GUI:InputText("##devg24", tostring(c.lootable),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Gatherable") GUI:SameLine(200) GUI:InputText("##devg25", tostring(c.gatherable),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("RessourceType") GUI:SameLine(200) GUI:InputText("##degv26", tostring(c.resourcetype),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Alive") GUI:SameLine(200) GUI:InputText("##devg27", tostring(c.alive),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Dead") GUI:SameLine(200) GUI:InputText("##devg28", tostring(c.dead),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsCombatant") GUI:SameLine(200) GUI:InputText("##devg29", tostring(c.iscombatant),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsOurs") GUI:SameLine(200) GUI:InputText("##devg30", tostring(c.isours),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsTurret") GUI:SameLine(200) GUI:InputText("##devg45", tostring(c.isturret),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Unknown0") GUI:SameLine(200) GUI:InputText("##devg31", tostring(c.isunknown0),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Unknown1") GUI:SameLine(200) GUI:InputText("##devg32", tostring(c.isunknown1),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Unknown2") GUI:SameLine(200) GUI:InputText("##devg33", tostring(c.isunknown2),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Unknown3") GUI:SameLine(200) GUI:InputText("##devg34", tostring(c.isunknown3),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Unknown4") GUI:SameLine(200) GUI:InputText("##devg35", tostring(c.isunknown4),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Unknown5") GUI:SameLine(200) GUI:InputText("##devg36", tostring(c.isunknown5),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Unknown6") GUI:SameLine(200) GUI:InputText("##devg37", tostring(c.isunknown6),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Unknown7") GUI:SameLine(200) GUI:InputText("##devg38", tostring(c.isunknown7),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Unknown8") GUI:SameLine(200) GUI:InputText("##devg39", tostring(c.isunknown8),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Unknown9") GUI:SameLine(200) GUI:InputText("##devg40", tostring(c.isunknown9),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Unknown10") GUI:SameLine(200) GUI:InputText("##devg41", tostring(c.isunknown10),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Unknown11") GUI:SameLine(200) GUI:InputText("##devg42", tostring(c.isunknown11),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Unknown12") GUI:SameLine(200) GUI:InputText("##devg43", tostring(c.isunknown12),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Unknown13") GUI:SameLine(200) GUI:InputText("##devg44", tostring(c.isunknown13),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:PopItemWidth()

end

function dev.DrawAgentDetails(c)
	
	GUI:PushItemWidth(250)
	GUI:BulletText("AgentPtr") GUI:SameLine(200) GUI:InputText("##deva0",tostring(string.format( "%X",c.ptr)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("ID") GUI:SameLine(200) GUI:InputText("##deva2",tostring(c.id),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Type") GUI:SameLine(200) GUI:InputText("##deva3",tostring(c.type),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Category") GUI:SameLine(200) GUI:InputText("##deva6",tostring(c.category),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsCharacter") GUI:SameLine(200) GUI:InputText("##deva7",tostring(c.ischaracter),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsEntity") GUI:SameLine(200) GUI:InputText("##deva25",tostring(c.isentity),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsDynamic") GUI:SameLine(200) GUI:InputText("##deva8",tostring(c.isdynamic),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	local p = c.pos
	GUI:BulletText("Position") GUI:SameLine(200)  GUI:InputFloat3( "##deva9", p.x, p.y, p.z, 2, GUI.InputTextFlags_ReadOnly)
	GUI:BulletText("Heading") GUI:SameLine(200)  GUI:InputFloat3( "##deva10", p.hx, p.hy, p.hz, 2, GUI.InputTextFlags_ReadOnly)
	GUI:BulletText("Height/Radius") GUI:SameLine(200)  GUI:InputFloat2( "##deva11", c.height, c.radius, 2, GUI.InputTextFlags_ReadOnly)	
	GUI:BulletText("Distance") GUI:SameLine(200) GUI:InputFloat("##deva12", c.distance,0,0,2)
	GUI:BulletText("PathDistance") GUI:SameLine(200) GUI:InputFloat("##deva13", c.pathdistance,0,0,2)
	GUI:BulletText("LoS") GUI:SameLine(200) GUI:InputText("##deva14", tostring(c.los),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("OnMesh") GUI:SameLine(200) GUI:InputText("##deva15", tostring(c.onmesh),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("OnMeshExact") GUI:SameLine(200) GUI:InputText("##deva16", tostring(c.onmeshexact),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Alive") GUI:SameLine(200) GUI:InputText("##deva23", tostring(c.alive),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("IsInInteractRange") GUI:SameLine(200) GUI:InputText("##deva20", tostring(c.isininteractrange),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Interactable") GUI:SameLine(200) GUI:InputText("##deva21", tostring(c.interactable),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Selectable") GUI:SameLine(200) GUI:InputText("##deva22", tostring(c.selectable),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:BulletText("Lootable") GUI:SameLine(200) GUI:InputText("##deva23", tostring(c.lootable),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
	GUI:PopItemWidth()
end

function dev.DrawMapMarkerDetails(id,b)
	local uniqid = (string.valid(b.name) and b.name or "unknown").."##"..tostring(b.characterid > 0 and b.characterid or id)..tostring(b.contentid)..tostring(b.markertype)..tostring(b.worldmarkertype)
	if ( GUI:TreeNode(uniqid)) then
		GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##devm0",tostring(string.format( "%X",b.ptr)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("Ptr2") GUI:SameLine(200) GUI:InputText("##devm1",tostring(string.format( "%X",b.ptr2)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("Name") GUI:SameLine(200) GUI:InputText("##devm2",b.name,GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("ContentID") GUI:SameLine(200) GUI:InputText("##devm8",tostring(b.contentid),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("MarkerType") GUI:SameLine(200) GUI:InputText("##devm4",tostring(b.markertype),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("WorldMarkerType") GUI:SameLine(200) GUI:InputText("##devm5",tostring(b.worldmarkertype),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("EventID") GUI:SameLine(200) GUI:InputText("##devm6",tostring(b.eventid),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("CharacterID") GUI:SameLine(200) GUI:InputText("##devm7",tostring(b.characterid),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("SubregionID") GUI:SameLine(200) GUI:InputText("##devm9",tostring(b.subregionid),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		local p = b.pos
		GUI:BulletText("Position") GUI:SameLine(200)  GUI:InputFloat3( "##devm10", p.x, p.y, p.z, 2, GUI.InputTextFlags_ReadOnly)
		GUI:BulletText("OnMesh") GUI:SameLine(200) GUI:InputText("##devm11", tostring(b.onmesh),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("Distance") GUI:SameLine(200) GUI:InputFloat("##devm12", b.distance,0,0,2)
		GUI:BulletText("PathDistance") GUI:SameLine(200) GUI:InputFloat("##devm13", b.pathdistance,0,0,2)
		local einfo = b.eventinfo
		if ( table.valid(einfo) ) then
			if ( GUI:TreeNode("EventDetais") ) then
				GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##deve0",tostring(string.format( "%X",einfo.ptr)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
				GUI:BulletText("Level") GUI:SameLine(200) GUI:InputText("##deve1",tostring(einfo.level),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
				GUI:BulletText("InRange") GUI:SameLine(200) GUI:InputText("##deve2",tostring(einfo.inrange),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
				GUI:BulletText("ObjectiveCount") GUI:SameLine(200) GUI:InputText("##deve3",tostring(einfo.objectivecount),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
				GUI:BulletText("Unknown0") GUI:SameLine(200) GUI:InputText("##deve4",tostring(einfo.isdungeonevent),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
				GUI:BulletText("Unknown1") GUI:SameLine(200) GUI:InputText("##deve5",tostring(einfo.A),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
				GUI:BulletText("Unknown2") GUI:SameLine(200) GUI:InputText("##deve6",tostring(einfo.B),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
				GUI:BulletText("Unknown3") GUI:SameLine(200) GUI:InputText("##deve7",tostring(einfo.C),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
				GUI:BulletText("Unknown4") GUI:SameLine(200) GUI:InputText("##deve8",tostring(einfo.D),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
				GUI:BulletText("Unknown5") GUI:SameLine(200) GUI:InputText("##deve9",tostring(einfo.E),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
				GUI:BulletText("Unknown6") GUI:SameLine(200) GUI:InputText("##deve10",tostring(einfo.F),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
				GUI:BulletText("Unknown7") GUI:SameLine(200) GUI:InputText("##deve11",tostring(einfo.G),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
				local eo = b.eventobjectivelist
				if ( table.valid(eo) ) then
					if ( GUI:TreeNode("ObjectiveDetails") ) then
						for eid,ee in pairsByKeys(eo) do
							if ( GUI:TreeNode("ID: "..tostring(eid) )) then
								GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##deveo0",tostring(string.format( "%X",ee.ptr)),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
								GUI:BulletText("Value1") GUI:SameLine(200) GUI:InputText("##deveo1",tostring(ee.value1),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
								GUI:BulletText("Value2") GUI:SameLine(200) GUI:InputText("##deveo1",tostring(ee.value2),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
								GUI:BulletText("Value3") GUI:SameLine(200) GUI:InputText("##deveo1",tostring(ee.value3),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
								GUI:BulletText("Value4") GUI:SameLine(200) GUI:InputText("##deveo1",tostring(ee.value4),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
								GUI:BulletText("Value5") GUI:SameLine(200) GUI:InputText("##deveo1",tostring(ee.value5),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
								GUI:TreePop()
							end	
						end
						GUI:TreePop()
					end												
				end
				GUI:TreePop()
			end
		end
		GUI:BulletText("IsWorldPortal") GUI:SameLine(200) GUI:InputText("##devm14",tostring(b.isworldportal),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("IsWaypoint") GUI:SameLine(200) GUI:InputText("##devm15",tostring(b.iswaypoint),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("IsQuest") GUI:SameLine(200) GUI:InputText("##devm16",tostring(b.isquest),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("IsSubregion") GUI:SameLine(200) GUI:InputText("##devm17",tostring(b.issubregion),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("IsVista") GUI:SameLine(200) GUI:InputText("##devm18",tostring(b.isvista),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("IsCommander") GUI:SameLine(200) GUI:InputText("##devm19",tostring(b.iscommander),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("IsPoi") GUI:SameLine(200) GUI:InputText("##devm20",tostring(b.ispoi),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("IsHeroPoint") GUI:SameLine(200) GUI:InputText("##devm34",tostring(b.isheropoint),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("Unknown0") GUI:SameLine(200) GUI:InputText("##devm21",tostring(b.isunknown0),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("Unknown1") GUI:SameLine(200) GUI:InputText("##devm22",tostring(b.isunknown1),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("Unknown2") GUI:SameLine(200) GUI:InputText("##devm23",tostring(b.isunknown2),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("Unknown4") GUI:SameLine(200) GUI:InputText("##devm25",tostring(b.isunknown4),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("Unknown5") GUI:SameLine(200) GUI:InputText("##devm26",tostring(b.isunknown5),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("Unknown6") GUI:SameLine(200) GUI:InputText("##devm27",tostring(b.isunknown6),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("Unknown7") GUI:SameLine(200) GUI:InputText("##devm28",tostring(b.isunknown7),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("Unknown8") GUI:SameLine(200) GUI:InputText("##devm29",tostring(b.isunknown8),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("Unknown9") GUI:SameLine(200) GUI:InputText("##devm30",tostring(b.isunknown9),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("Unknown10") GUI:SameLine(200) GUI:InputText("##devm31",tostring(b.isunknown10),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("Unknown11") GUI:SameLine(200) GUI:InputText("##devm32",tostring(b.isunknown11),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		GUI:BulletText("Unknown12") GUI:SameLine(200) GUI:InputText("##devm33",tostring(b.isunknown12),GUI.InputTextFlags_ReadOnly+GUI.InputTextFlags_AutoSelectAll)
		
		GUI:TreePop()
	end
end


