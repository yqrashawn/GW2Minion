dev = {}
dev.open = false
dev.unfolded = true
dev.equipitemidx = 1
dev.equipitemlist = { [1] = "Back",[2] = "Chest",[3] = "Boots",[4] = "Gloves",[5] = "Headgear",[6] = "Leggings",[7] = "Shoulders", }
dev.teleportpos = { x =0,y =0, z =0, }
dev.noclip = false
dev.movementtype = { [0] = "Forward", [1] ="Backward", [2] ="Left", [3] ="Right", [4] ="TurnLeft", [5] ="TurnRight",[6] ="Evade",[7] ="AutoRunToggle", [8] ="WalkToggle", [9] ="Jump", [10] ="SwimUp", [11] ="SwimDown", [12] ="About_Face", [13] ="ForwardLeft", [14] ="ForwardRight", [15] ="BackwardLeft", [16] ="BackwardRight",}
dev.movementtypeidx = 0
dev.navtype = 1
dev.movetype = 1
dev.rndpointradius = 500
dev.avoidanceareasize = 50
dev.avoidanceareas = { }
dev.lastNavResult = 0
dev.chatchannel = 0


function dev.Init()
	-- Register Button	
	ml_gui.ui_mgr:AddSubMember({ id = "GW2MINION##DEV_1", name = "Dev-Monitor", onClick = function() dev.open = not dev.open end, tooltip = "Open the Dev monitor."},"GW2MINION##MENU_HEADER","GW2MINION##MENU_ADDONS")	
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
								for id, e in pairs(c) do
									if ( GUI:TreeNode(tostring(id)) ) then
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
								for id, e in pairs(c) do
									if ( GUI:TreeNode(tostring(id)) ) then
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
								for id, e in pairs(c) do
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
						local blist = Player.buffs
						if ( table.valid(blist) )then
							GUI:PushItemWidth(250)
							for id, b in pairs(blist) do
								if ( GUI:TreeNode(tostring(id).."-"..b.name)) then
									GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##devb0",tostring(string.format( "%X",b.ptr)))
									GUI:BulletText("ID") GUI:SameLine(200) GUI:InputText("##devb1",tostring(b.id))
									GUI:BulletText("ContentID") GUI:SameLine(200) GUI:InputText("##devb2",tostring(b.contentid))
									GUI:BulletText("Stacks") GUI:SameLine(200) GUI:InputText("##devb3",tostring(b.stacks))
									GUI:BulletText("Name") GUI:SameLine(200) GUI:InputText("##devb4",tostring(b.name))
									GUI:BulletText("Description") GUI:SameLine(200) GUI:InputText("##devb5",tostring(b.description))
									GUI:BulletText("Timeleft") GUI:SameLine(200) GUI:InputText("##devb6",tostring(b.timeleft))
									GUI:BulletText("MaxDuration") GUI:SameLine(200) GUI:InputText("##devb7",tostring(b.maxduration))
									GUI:BulletText("Active") GUI:SameLine(200) GUI:InputText("##devb8",tostring(b.active))									
									GUI:TreePop()
								end
							end							
							GUI:PopItemWidth()
						else
							GUI:Text("No Buffs found.") 
						end
						GUI:TreePop()				
					end
					
					if ( GUI:TreeNode("Inventory") ) then
						local list = Inventory("")
						if ( table.valid(list) )then
							GUI:PushItemWidth(250)
							for id, b in pairs(list) do
								if ( GUI:TreeNode(tostring(id).."-"..b.name)) then
									GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##devi0",tostring(string.format( "%X",b.ptr)))
									GUI:BulletText("ID") GUI:SameLine(200) GUI:InputText("##devi1",tostring(b.itemid))
									GUI:BulletText("Stackcount") GUI:SameLine(200) GUI:InputText("##devi2",tostring(b.stackcount))
									GUI:BulletText("Rarity") GUI:SameLine(200) GUI:InputText("##devi3",tostring(b.rarity))
									GUI:BulletText("Itemtype") GUI:SameLine(200) GUI:InputText("##devi4",tostring(b.itemtype))
									GUI:BulletText("Weapontype") GUI:SameLine(200) GUI:InputText("##devi5",tostring(b.weapontype))
									GUI:BulletText("Durability") GUI:SameLine(200) GUI:InputText("##devi6",tostring(b.durability))
									GUI:BulletText("Soulbound") GUI:SameLine(200) GUI:InputText("##devi7",tostring(b.soulbound))
									GUI:BulletText("Salvagable") GUI:SameLine(200) GUI:InputText("##devi8",tostring(b.salvagable))
									GUI:BulletText("IsMailable") GUI:SameLine(200) GUI:InputText("##devi9",tostring(b.ismailable))
									GUI:BulletText("CanSellToTP") GUI:SameLine(200) GUI:InputText("##devi10",tostring(b.canselltotp))
									
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
						GUI:BulletText("IsVendorOpened") GUI:SameLine(200) GUI:InputText("##devv0",tostring(Inventory:IsVendorOpened()))	
						local list = VendorItemList("")
						if ( table.valid(list) )then
							GUI:PushItemWidth(250)
							for id, b in pairs(list) do
								if ( GUI:TreeNode(tostring(id).."-"..b.name)) then
									GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##devv1",tostring(string.format( "%X",b.ptr)))
									GUI:BulletText("ID") GUI:SameLine(200) GUI:InputText("##devv2",tostring(b.itemid))									
									GUI:BulletText("Rarity") GUI:SameLine(200) GUI:InputText("##devv3",tostring(b.rarity))
									GUI:BulletText("Itemtype") GUI:SameLine(200) GUI:InputText("##devv4",tostring(b.itemtype))
									GUI:BulletText("Weapontype") GUI:SameLine(200) GUI:InputText("##devv5",tostring(b.weapontype))
									GUI:BulletText("Price") GUI:SameLine(200) GUI:InputText("##devv6",tostring(b.price))
									GUI:BulletText("Quantity") GUI:SameLine(200) GUI:InputText("##devi7",tostring(b.quantity))
									
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
						GUI:BulletText("IsConversationOpen") GUI:SameLine(200) GUI:InputText("##devc1",tostring(Player:IsConversationOpen()))
						local clist = Player:GetConversationOptions()
						if (table.valid(clist)) then 
							for cid,b in pairs(clist) do
								if ( GUI:TreeNode(tostring(cid))) then
									GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##devc2",tostring(string.format( "%X",b.ptr)))
									GUI:BulletText("Listindex") GUI:SameLine(200) GUI:InputText("##devsk1",tostring(b.index))
									GUI:BulletText("ID") GUI:SameLine(200) GUI:InputText("##devsk1",tostring(b.id))
									GUI:BulletText("Type") GUI:SameLine(200) GUI:InputText("##devsk1",tostring(b.type))									
									if (GUI:Button("SelectConverrsationByType",150,15) ) then d("Result: "..tostring(Player:SelectConversationOptionByIndex(b.type))) end
									if (GUI:Button("SelectConversationOption",150,15) ) then d("Result: "..tostring(Player:SelectConversationOption(b.index))) end
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
								for id, b in pairs(list) do
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
								for id, b in pairs(list) do
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
							for id, b in pairs(list) do
								if ( GUI:TreeNode(tostring(id).."-"..b.name)) then
									GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##devw0",tostring(string.format( "%X",b.ptr)))
									GUI:BulletText("ID") GUI:SameLine(200) GUI:InputText("##devw1",tostring(b.id))									
									GUI:BulletText("Name") GUI:SameLine(200) GUI:InputText("##devw8",b.name)
									local p = b.pos
									GUI:BulletText("Position") GUI:SameLine(200)  GUI:InputFloat3( "##devw2", p.x, p.y, p.z, 2, GUI.InputTextFlags_ReadOnly)
									GUI:BulletText("Distance") GUI:SameLine(200) GUI:InputFloat("##devw3", b.distance,0,0,2)
									GUI:BulletText("PathDistance") GUI:SameLine(200) GUI:InputFloat("##devw4", b.pathdistance,0,0,2)	
									GUI:BulletText("OnMesh") GUI:SameLine(200) GUI:InputText("##devw5",tostring(b.onmesh))
									GUI:BulletText("Contested") GUI:SameLine(200) GUI:InputText("##devw6",tostring(b.contested))
									GUI:BulletText("SameZone") GUI:SameLine(200) GUI:InputText("##devw7",tostring(b.samezone))																
									
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
						GUI:BulletText("IsInPvPLobby") GUI:SameLine(200) GUI:InputText("##devp1",tostring(PvPManager:IsInPvPLobby()))
						GUI:BulletText("IsInMatch") GUI:SameLine(200) GUI:InputText("##devp2",tostring(PvPManager:IsInMatch()))
						GUI:BulletText("IsArenaQueued") GUI:SameLine(200) GUI:InputText("##devp3",tostring(PvPManager:IsArenaQueued()))
						GUI:BulletText("IsMatchAvailable") GUI:SameLine(200) GUI:InputText("##devp4",tostring(PvPManager:IsMatchAvailable()))
						GUI:BulletText("IsMatchStarted") GUI:SameLine(200) GUI:InputText("##devp5",tostring(PvPManager:IsMatchStarted()))
						GUI:BulletText("IsMatchFinished") GUI:SameLine(200) GUI:InputText("##devp6",tostring(PvPManager:IsMatchFinished()))
						GUI:BulletText("MatchDuration") GUI:SameLine(200) GUI:InputText("##devp7",tostring(PvPManager:GetMatchDuration()))
						
						if (GUI:Button("Join PvP Lobby",150,15) ) then d("Join PvP Lobby: "..tostring(PvPManager:JoinPvPLobby())) end GUI:SameLine()
						if (GUI:Button("Leave PvP Lobby",150,15) ) then d("Leave PvP Lobby: "..tostring(PvPManager:LeavePvPLobby())) end
						if (GUI:Button("Join Unranked Queue",150,15) ) then d("Join Unranked Queue: "..tostring(PvPManager:JoinArenaQueue(1))) end
						if (GUI:Button("Leave Unranked Queue",150,15) ) then d("Leave Unranked Queue: "..tostring(PvPManager:LeaveArenaQueue())) end
						if (GUI:Button("Set Ready",150,15) ) then d("Set Ready: "..tostring(PvPManager:SetReady())) end
						
						GUI:BulletText("CanJoinTeamRED") GUI:SameLine(200) GUI:InputText("##devp7",tostring(PvPManager:CanJoinTeam(1)))
						GUI:BulletText("CanJoinTeamBLUE") GUI:SameLine(200) GUI:InputText("##devp7",tostring(PvPManager:CanJoinTeam(2)))
					
						if (GUI:Button("Join Red",150,15) ) then d("JoinRed Result: "..tostring(PvPManager:JoinTeam(1))) end GUI:SameLine()
						if (GUI:Button("Join Blue",150,15) ) then d("JoinRed Result: "..tostring(PvPManager:JoinTeam(2))) end
						
						GUI:TreePop()				
					end
					
					if ( GUI:TreeNode("Party") ) then
						local list = Player:GetParty()
						if ( table.valid(list) )then
							GUI:PushItemWidth(250)
							for id, b in pairs(list) do
								if ( GUI:TreeNode(tostring(id).."-"..b.name)) then
									GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##devp0",tostring(string.format( "%X",b.ptr)))
									GUI:BulletText("ID") GUI:SameLine(200) GUI:InputText("##devp1",tostring(b.id))									
									GUI:BulletText("MapID") GUI:SameLine(200) GUI:InputText("##devp2", tostring(b.mapid))
									GUI:BulletText("HomeServerID") GUI:SameLine(200) GUI:InputText("##devp3", tostring(b.homeserverid))
									GUI:BulletText("CurrentServerID") GUI:SameLine(200) GUI:InputText("##devp4",tostring(b.currentserverid))
									GUI:BulletText("InstanceServerID") GUI:SameLine(200) GUI:InputText("##devw5",tostring(b.instanceserverid))
									GUI:BulletText("ConnectStatus") GUI:SameLine(200) GUI:InputText("##devw6",tostring(b.connectstatus))
									GUI:BulletText("InviteStatus") GUI:SameLine(200) GUI:InputText("##devw6",tostring(b.invitestatus))
									GUI:BulletText("HasParty") GUI:SameLine(200) GUI:InputText("##devw6",tostring(b.hasparty))
									GUI:BulletText("Profession") GUI:SameLine(200) GUI:InputText("##devw6",tostring(b.profession))
									GUI:BulletText("Level") GUI:SameLine(200) GUI:InputText("##devw6",tostring(b.level))
									GUI:BulletText("Unknown0") GUI:SameLine(200) GUI:InputText("##devw6",tostring(b.isunknown0))
									GUI:BulletText("Unknown1") GUI:SameLine(200) GUI:InputText("##devw6",tostring(b.isunknown1))																		
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
						GUI:BulletText("IsCasting") GUI:SameLine(200) GUI:InputText("##devs1",tostring(Player:IsCasting()))
						GUI:BulletText("CanCast") GUI:SameLine(200) GUI:InputText("##devs2",tostring(Player:CanCast()))
						GUI:BulletText("IsSkillPending") GUI:SameLine(200) GUI:InputText("##devs3",tostring(Player:IsSkillPending()))
						GUI:BulletText("CurrentSpell") GUI:SameLine(200) GUI:InputText("##devs4",tostring(Player:GetCurrentlyCastedSpell()))
						GUI:BulletText("CurrentWeaponSetID") GUI:SameLine(200) GUI:InputText("##devs5",tostring(Player:GetCurrentWeaponSet()))
						GUI:BulletText("CurrentTransformID") GUI:SameLine(200) GUI:InputText("##devs6",tostring(Player:GetTransformID()))
						GUI:BulletText("CanSwapWeaponSet") GUI:SameLine(200) GUI:InputText("##devs7",tostring(Player:CanSwapWeaponSet()))
						if (GUI:Button("SwapWeaponSet",150,15) ) then d("SwapWeaponSet Result: "..tostring(Player:SwapWeaponSet())) end
						GUI:PushItemWidth(250)
						for i=0,20 do
							local b = Player:GetSpellInfo(i)
							if (table.valid(b)) then 
								if ( GUI:TreeNode(tostring(i).."-"..b.name)) then
									GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##devsk0",tostring(string.format( "%X",b.ptr)))
									GUI:BulletText("Slot") GUI:SameLine(200) GUI:InputText("##devsk1",tostring(b.slot))
									GUI:BulletText("ID") GUI:SameLine(200) GUI:InputText("##devsk2",tostring(b.skillid))
									GUI:BulletText("ContentID") GUI:SameLine(200) GUI:InputText("##devsk3", tostring(b.contentid))
									GUI:BulletText("Cooldown") GUI:SameLine(200) GUI:InputText("##devsk4", tostring(b.cooldown))
									GUI:BulletText("CooldownMax") GUI:SameLine(200) GUI:InputText("##devsk5",tostring(b.cooldownmax))									
									GUI:BulletText("MinRange") GUI:SameLine(200) GUI:InputText("##devsk6",tostring(b.minrange))
									GUI:BulletText("MaxRange") GUI:SameLine(200) GUI:InputText("##devsk7",tostring(b.maxrange))									
									GUI:BulletText("Radius") GUI:SameLine(200) GUI:InputText("##devsk8",tostring(b.radius))
									GUI:BulletText("Skilltype") GUI:SameLine(200) GUI:InputText("##devsk9",tostring(b.skilltype))
									GUI:BulletText("Power") GUI:SameLine(200) GUI:InputText("##devsk10",tostring(b.power))	
									GUI:BulletText("IsGroundTargeted") GUI:SameLine(200) GUI:InputText("##devsk11",tostring(b.isgroundtargeted))
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
						GUI:BulletText("CanSwitchPet") GUI:SameLine(200) GUI:InputText("##devp1",tostring(Player:CanSwitchPet()))
						GUI:BulletText("HasPet") GUI:SameLine(200) GUI:InputText("##devp2",tostring(Player:GetPet() ~=nil))
						if (GUI:Button("Switch Pet",150,15) ) then d("Switch Pet Result: "..tostring(Player:SwitchPet())) end						
						GUI:PopItemWidth()
						GUI:TreePop()					
					end

					if ( GUI:TreeNode("Instances") ) then
						GUI:PushItemWidth(250)
						GUI:BulletText("IsInstanceDialogShown") GUI:SameLine(200) GUI:InputText("##devin1",tostring(Player:IsInstanceDialogShown()))
						local dInfo = Player:GetInstanceInfo()
						if (dInfo) then
							GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##devin16",tostring(string.format( "%X",dInfo.ptr)))
							GUI:BulletText("Ptr2") GUI:SameLine(200) GUI:InputText("##devin15",tostring(string.format( "%X",dInfo.ptr2)))
							GUI:BulletText("EntryID") GUI:SameLine(200) GUI:InputText("##devin2",tostring(dInfo.instanceEntryID))
							GUI:BulletText("ModeID") GUI:SameLine(200) GUI:InputText("##devin3",tostring(dInfo.instanceModeID))
							GUI:BulletText("ModeID2") GUI:SameLine(200) GUI:InputText("##devin4",tostring(dInfo.instanceMode2ID))
							GUI:BulletText("InstanceID") GUI:SameLine(200) GUI:InputText("##devin5",tostring(dInfo.instanceID))
							GUI:BulletText("IsRegistered") GUI:SameLine(200) GUI:InputText("##devin6",tostring(dInfo.isInstanceRegistered))
							GUI:BulletText("Unknown0") GUI:SameLine(200) GUI:InputText("##devin7",tostring(dInfo.isunknown0))
							GUI:BulletText("Unknown1") GUI:SameLine(200) GUI:InputText("##devin8",tostring(dInfo.isunknown1))
							GUI:BulletText("Unknown2") GUI:SameLine(200) GUI:InputText("##devin9",tostring(dInfo.isunknown2))
							GUI:BulletText("Unknown3") GUI:SameLine(200) GUI:InputText("##devin10",tostring(dInfo.isunknown3))
							GUI:BulletText("Unknown4") GUI:SameLine(200) GUI:InputText("##devin11",tostring(dInfo.isunknown4))
							GUI:BulletText("Unknown5") GUI:SameLine(200) GUI:InputText("##devin12",tostring(dInfo.isunknown5))
							GUI:BulletText("Unknown6") GUI:SameLine(200) GUI:InputText("##devin13",tostring(dInfo.isunknown6))
							if (GUI:Button("StartNewInstance",150,15) ) then d("StartNewInstance Result: "..tostring(Player:OpenInstance())) end
							GUI:SameLine()
							if (GUI:Button("JoinInstance",150,15) ) then d("JoinInstance Result: "..tostring(Player:JoinInstance())) end
							if (GUI:Button("LeaveInstance",150,15) ) then d("LeaveInstance Result: "..tostring(Player:LeaveInstance())) end
							GUI:SameLine()
							if (GUI:Button("ResetInstance",150,15) ) then d("ResetInstance Result: "..tostring(Player:ResetInstance())) end							
							
						end						
						GUI:BulletText("CanClaimReward") GUI:SameLine(200) GUI:InputText("##devin14",tostring(Player:CanClaimReward()))						
						if (GUI:Button("ClaimReward",150,15) ) then d("ClaimReward Result: "..tostring(Player:ClaimReward())) end
						
						GUI:PopItemWidth()
						GUI:TreePop()					
					end					
					
					if ( GUI:TreeNode("Quests") ) then
						GUI:PushItemWidth(250)
						local qm = QuestManager:GetActiveQuest()
						if ( table.valid(qm) ) then
							GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##devqe0",tostring(string.format( "%X",qm.ptr)))
							GUI:BulletText("Ptr2") GUI:SameLine(200) GUI:InputText("##devqe1",tostring(string.format( "%X",qm.ptr2)))
							GUI:BulletText("StoryName") GUI:SameLine(200) GUI:InputText("##devq0",qm.storyname)
							GUI:BulletText("StoryID") GUI:SameLine(200) GUI:InputText("##devq1",tostring(qm.storyid))
							GUI:BulletText("Ptr3") GUI:SameLine(200) GUI:InputText("##devqe2",tostring(string.format( "%X",qm.ptr3)))
							GUI:BulletText("QuestName") GUI:SameLine(200) GUI:InputText("##devq2",qm.questname)
							GUI:BulletText("QuestID") GUI:SameLine(200) GUI:InputText("##devq3",tostring(qm.questid))							
							GUI:BulletText("QuestComplete") GUI:SameLine(200) GUI:InputText("##devq4",tostring(qm.isquestcomplete))
							GUI:BulletText("Ptr4") GUI:SameLine(200) GUI:InputText("##devqe3",tostring(string.format( "%X",qm.ptr4)))
							GUI:BulletText("QuestGoalName") GUI:SameLine(200) GUI:InputText("##devq5",qm.questgoalname)
							GUI:BulletText("QuestGoalID") GUI:SameLine(200) GUI:InputText("##devq6",tostring(qm.questgoalid))
							GUI:BulletText("QuestStepCurrent") GUI:SameLine(200) GUI:InputText("##devq7",tostring(qm.stepcurrent))
							GUI:BulletText("QuestStepMax") GUI:SameLine(200) GUI:InputText("##devq8",tostring(qm.stepmax))
							GUI:BulletText("QuestStepName") GUI:SameLine(200) GUI:InputText("##devq9",qm.stepname)
							GUI:BulletText("QuestStepUnknown1") GUI:SameLine(200) GUI:InputText("##devq10",tostring(qm.stepu1))
							GUI:BulletText("QuestStepUnknown2") GUI:SameLine(200) GUI:InputText("##devq11",tostring(qm.stepu2))
							GUI:BulletText("QuestStepUnknown3") GUI:SameLine(200) GUI:InputText("##devq12",tostring(qm.stepu3))
							GUI:BulletText("QuestStepUnknown4") GUI:SameLine(200) GUI:InputText("##devq13",tostring(qm.stepu4))
							GUI:BulletText("QuestStepUnknown5") GUI:SameLine(200) GUI:InputText("##devq14",tostring(qm.stepu5))
							GUI:BulletText("RewardCount") GUI:SameLine(200) GUI:InputText("##devq14",tostring(qm.questrewardcount))
							local qmr = QuestManager:GetActiveQuestRewardList()
							if ( table.valid(qmr) ) then
								for qid,q in pairs(qmr) do
									if ( GUI:TreeNode(tostring(qid).."-"..q.name)) then
										GUI:BulletText("Ptr5") GUI:SameLine(200) GUI:InputText("##devqe4",tostring(string.format( "%X",qm.ptr5)))
										GUI:BulletText("Ptr6") GUI:SameLine(200) GUI:InputText("##devqe5",tostring(string.format( "%X",qm.ptr6)))
										GUI:BulletText("RewardItemID") GUI:SameLine(200) GUI:InputText("##devq15"..tostring(qid),tostring(q.itemid))
										GUI:BulletText("RewardCount") GUI:SameLine(200) GUI:InputText("##devq16"..tostring(qid),tostring(q.count))
										GUI:BulletText("RewardSelectable") GUI:SameLine(200) GUI:InputText("##devq17"..tostring(qid),tostring(q.selectable))
										GUI:BulletText("RewardUnknown") GUI:SameLine(200) GUI:InputText("##devq18"..tostring(qid),tostring(q.isunknown1))									
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
							for line,tx in pairs(txt) do
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
						GUI:BulletText("CanMove") GUI:SameLine(200) GUI:InputText("##devmm1",tostring(Player:CanMove()))
						GUI:BulletText("IsMoving") GUI:SameLine(200) GUI:InputText("##devmm2",tostring(Player:IsMoving()))
						GUI:BulletText("MovementState") GUI:SameLine(200) GUI:InputText("##devmm3",tostring(Player:GetMovementState()))
						local movstr = ""
						local movdirs = Player:GetMovement()
						if (movdirs.forward) then movstr = "forward" end
						if (movdirs.left) then movstr = movstr.." left" end
						if (movdirs.right) then movstr = movstr.." right" end
						if (movdirs.backward) then movstr = movstr.." backward" end
						GUI:BulletText("MovementDirection") GUI:SameLine(200) GUI:InputText("##devmm4",movstr)						
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
					
					if ( GUI:TreeNode("Navigation") ) then
						GUI:PushItemWidth(250)						
						GUI:BulletText("TargetPosition") GUI:SameLine(200)  GUI:InputFloat3( "##devnav1", dev.teleportpos.x, dev.teleportpos.y, dev.teleportpos.z, 2, GUI.InputTextFlags_ReadOnly)
						if (GUI:Button("UseCurrentPos",150,15) ) then dev.teleportpos = Player.pos end 
						GUI:SameLine() if (GUI:Button("GetRandomPoint",150,15) ) then 
							local tpos = NavigationManager:GetRandomPoint()
							if (table.size(tpos) > 0 ) then
								dev.teleportpos.x = tpos.x
								dev.teleportpos.y = tpos.y
								dev.teleportpos.z = tpos.z
							end
						end 
						
						GUI:BulletText("NavigationType") GUI:SameLine(200) dev.navtype = GUI:Combo("##devnav2", dev.navtype, { [1] = "Normal", [2] = "Follow" })
						GUI:BulletText("MovementType") GUI:SameLine(200) dev.movetype = GUI:Combo("##devnav3", dev.movetype, { [1] = "Straight", [2] = "Random" })
						if (GUI:Button("NavigateTo",150,15) ) then
							dev.lastNavResult = NavigationManager:MoveTo(dev.teleportpos.x, dev.teleportpos.y, dev.teleportpos.z,25,dev.navtype==2,dev.movetype==2,true)						
						end						
						GUI:SameLine(200) if (GUI:Button("Stop Navigation",150,15) ) then Player:StopMovement() end
						GUI:Text("Path Result:") GUI:SameLine() GUI:InputText("##devmm66",tostring(dev.lastNavResult))
						if ( GUI:TreeNode("Path Details") ) then
							if (GUI:Button("Get Path",150,15) ) then 
								local ppos = Player.pos
								dev.lastpath = NavigationManager:GetPath(ppos.x,ppos.y,ppos.z,dev.teleportpos.x, dev.teleportpos.y, dev.teleportpos.z)
							end
							if ( table.valid(dev.lastpath)) then
								local psize = table.size(dev.lastpath)
								GUI:BulletText("Path Nodes") GUI:SameLine(200) GUI:InputText("##devmm4",tostring(psize))
								GUI:BulletText("Path Info") GUI:SameLine(200) GUI:InputText("##devmm5",tostring(dev.lastpath[psize-1].type))
								for i,n in pairs(dev.lastpath) do
									if ( GUI:TreeNode("Node- "..tostring(i)) ) then
										GUI:BulletText("Type") GUI:SameLine(200) GUI:InputText("##devmm6"..tostring(i),tostring(n.type))
										GUI:BulletText("Position") GUI:SameLine(200) GUI:InputFloat3( "##devmm7..tostring(i)", n.x, n.y, n.z, 2, GUI.InputTextFlags_ReadOnly)									
										GUI:TreePop()
									end
								end								
							end								
							GUI:TreePop()					
						end
						
						GUI:Separator()
						GUI:BulletText("AvoidanceAreaSize") GUI:SameLine(200) dev.avoidanceareasize = GUI:InputInt("##devmm8",dev.avoidanceareasize,1,10)
						if (GUI:Button("Add AvoidanceArea",150,15) ) then 
							local pPos = Player.pos
							if ( pPos ) then
								table.insert(dev.avoidanceareas, { x=pPos.x, y=pPos.y, z=pPos.z, r=tonumber(dev.avoidanceareasize) })
								NavigationManager:SetAvoidanceAreas(dev.avoidanceareas)
							end
						end
						if (GUI:Button("Clear AvoidanceAreas",150,15) ) then 
							dev.avoidanceareas = {}
							NavigationManager:ClearAvoidanceAreas()
						end
						
						GUI:PopItemWidth()
						GUI:TreePop()					
					end
					
					if ( GUI:TreeNode("Functions & Other Infos") ) then
						GUI:PushItemWidth(250)
						GUI:BulletText("Local MapID") GUI:SameLine(200) GUI:InputText("##devff1",tostring(Player:GetLocalMapID()))
						
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
	GUI:BulletText("CharPtr") GUI:SameLine(200) GUI:InputText("##dev0",tostring(string.format( "%X",c.ptr)))
	GUI:BulletText("AgentPtr") GUI:SameLine(200) GUI:InputText("##dev1",tostring(string.format( "%X",c.ptr2)))
	GUI:BulletText("ID") GUI:SameLine(200) GUI:InputText("##dev2",tostring(c.id))
	GUI:BulletText("ContentID") GUI:SameLine(200) GUI:InputText("##dev3",tostring(c.contentid))
	GUI:BulletText("Name") GUI:SameLine(200) GUI:InputText("##dev6",c.Name)
	local h = c.health
	GUI:BulletText("Health") GUI:SameLine(200)  GUI:InputFloat3( "##dev7", h.current, h.max, h.percent, 2, GUI.InputTextFlags_ReadOnly)
	local p = c.pos
	GUI:BulletText("Position") GUI:SameLine(200)  GUI:InputFloat3( "##dev9", p.x, p.y, p.z, 2, GUI.InputTextFlags_ReadOnly)
	GUI:BulletText("Heading") GUI:SameLine(200)  GUI:InputFloat3( "##dev10", p.hx, p.hy, p.hz, 2, GUI.InputTextFlags_ReadOnly)
	GUI:BulletText("Height/Radius") GUI:SameLine(200)  GUI:InputFloat2( "##dev11", c.height, c.radius, 2, GUI.InputTextFlags_ReadOnly)	
	GUI:BulletText("Distance") GUI:SameLine(200) GUI:InputFloat("##dev12", c.distance,0,0,2)
	GUI:BulletText("PathDistance") GUI:SameLine(200) GUI:InputFloat("##dev13", c.pathdistance,0,0,2)	
	GUI:BulletText("LoS") GUI:SameLine(200) GUI:InputText("##dev14", tostring(c.los))
	GUI:BulletText("OnMesh") GUI:SameLine(200) GUI:InputText("##dev15", tostring(c.onmesh))
	GUI:BulletText("OnMeshExact") GUI:SameLine(200) GUI:InputText("##dev16", tostring(c.onmeshexact))	
	GUI:BulletText("Attitude") GUI:SameLine(200) GUI:InputText("##dev23", tostring(c.attitude))
	GUI:BulletText("MovementState") GUI:SameLine(200) GUI:InputText("##dev17", tostring(c.movementstate))
	GUI:BulletText("SwimmingState") GUI:SameLine(200) GUI:InputText("##dev17", tostring(c.swimming))	
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
	GUI:BulletText("IsPlayerFacingTarget") GUI:SameLine(200) GUI:InputText("##dev68", mifacet)
	GUI:BulletText("Speed") GUI:SameLine(200) GUI:InputFloat("##dev18", c.speed,0,0,2)	
	GUI:BulletText("Profession") GUI:SameLine(200) GUI:InputText("##dev19", tostring(c.profession))
	GUI:BulletText("Level") GUI:SameLine(200) GUI:InputText("##dev23", tostring(c.level))
	GUI:BulletText("IsInInteractRange") GUI:SameLine(200) GUI:InputText("##dev20", tostring(c.isininteractrange))
	GUI:BulletText("Interactable") GUI:SameLine(200) GUI:InputText("##dev21", tostring(c.interactable))
	GUI:BulletText("Selectable") GUI:SameLine(200) GUI:InputText("##dev22", tostring(c.selectable))
	GUI:BulletText("Attackable") GUI:SameLine(200) GUI:InputText("##dev23", tostring(c.attackable))
	GUI:BulletText("Lootable") GUI:SameLine(200) GUI:InputText("##dev23", tostring(c.lootable))
	GUI:BulletText("Has Pet") GUI:SameLine(200) GUI:InputText("##dev23", tostring(c.haspet))
	GUI:BulletText("Alive") GUI:SameLine(200) GUI:InputText("##dev23", tostring(c.alive))
	GUI:BulletText("Downed") GUI:SameLine(200) GUI:InputText("##dev23", tostring(c.downed))
	GUI:BulletText("Dead") GUI:SameLine(200) GUI:InputText("##dev23", tostring(c.dead))
	GUI:BulletText("Aggro") GUI:SameLine(200) GUI:InputText("##dev23", tostring(c.isaggro))
	GUI:BulletText("AggroPercent") GUI:SameLine(200) GUI:InputText("##dev23", tostring(c.aggropercent))
	GUI:BulletText("InCombat") GUI:SameLine(200) GUI:InputText("##dev23", tostring(c.incombat))	
	local castinfo = c.castinfo
	if ( TableSize(castinfo) > 0 ) then
		GUI:BulletText("AttackedTargetPtr") GUI:SameLine(200) GUI:InputText("##dev24",tostring(string.format( "%X",castinfo.ptr)))
		GUI:BulletText("AttackedTargetID") GUI:SameLine(200) GUI:InputText("##dev25", tostring(castinfo.targetID))
		GUI:BulletText("Current SpellID") GUI:SameLine(200) GUI:InputText("##dev26", tostring(castinfo.skillID))
		GUI:BulletText("Last SpellID") GUI:SameLine(200) GUI:InputText("##dev27", tostring(castinfo.lastSkillID))
		GUI:BulletText("Skill Slot") GUI:SameLine(200) GUI:InputText("##dev28", tostring(castinfo.slot))
		GUI:BulletText("Skill Duration") GUI:SameLine(200) GUI:InputText("##dev29", tostring(castinfo.duration))		
	else
		GUI:BulletText("castinfo MISSING!")
	end
	GUI:BulletText("IsControlled") GUI:SameLine(200) GUI:InputText("##dev30", tostring(c.iscontrolled))	
	GUI:BulletText("IsPlayer") GUI:SameLine(200) GUI:InputText("##dev31", tostring(c.isplayer))	
	GUI:BulletText("IsPet") GUI:SameLine(200) GUI:InputText("##dev32", tostring(c.ispet))
	GUI:BulletText("HasOwner") GUI:SameLine(200) GUI:InputText("##dev32", tostring(c.hasowner))
	GUI:BulletText("IsMonster") GUI:SameLine(200) GUI:InputText("##dev33", tostring(c.ismonster))	
	GUI:BulletText("IsClone") GUI:SameLine(200) GUI:InputText("##dev34", tostring(c.isclone))	
	GUI:BulletText("IsCritter") GUI:SameLine(200) GUI:InputText("##dev35", tostring(c.iscritter))	
	GUI:BulletText("IsEventNPC") GUI:SameLine(200) GUI:InputText("##dev36", tostring(c.iseventnpc))	
	GUI:BulletText("IsElite") GUI:SameLine(200) GUI:InputText("##dev37", tostring(c.iselite))
	GUI:BulletText("IsChampion") GUI:SameLine(200) GUI:InputText("##dev38", tostring(c.ischampion))
	GUI:BulletText("IsVeteran") GUI:SameLine(200) GUI:InputText("##dev39", tostring(c.isveteran))
	GUI:BulletText("IsLegendary") GUI:SameLine(200) GUI:InputText("##dev40", tostring(c.islegendary))
	GUI:BulletText("IsGathering") GUI:SameLine(200) GUI:InputText("##dev41", tostring(c.isgathering))
	GUI:BulletText("IsMiniature") GUI:SameLine(200) GUI:InputText("##dev42", tostring(c.isminiature))
	GUI:BulletText("IsMesmerClone") GUI:SameLine(200) GUI:InputText("##dev43", tostring(c.ismesmerclone))
	GUI:BulletText("HasDialog") GUI:SameLine(200) GUI:InputText("##dev44", tostring(c.hasdialog))
	GUI:BulletText("IsTurret") GUI:SameLine(200) GUI:InputText("##dev45", tostring(c.isturret))
	GUI:BulletText("HasSpeechBubble") GUI:SameLine(200) GUI:InputText("##dev46", tostring(c.hasspeechbubble))
	GUI:BulletText("ScriptIsIdle") GUI:SameLine(200) GUI:InputText("##dev47", tostring(c.scriptisidle))
	GUI:BulletText("IsHeartQuestGiver") GUI:SameLine(200) GUI:InputText("##dev48", tostring(c.isheartquestgiver))
	GUI:BulletText("Unknown2") GUI:SameLine(200) GUI:InputText("##dev49", tostring(c.isunknown2))
	GUI:BulletText("Unknown3") GUI:SameLine(200) GUI:InputText("##dev50", tostring(c.isunknown3))
	GUI:BulletText("Unknown6") GUI:SameLine(200) GUI:InputText("##dev51", tostring(c.isunknown6))
	GUI:BulletText("Unknown10") GUI:SameLine(200) GUI:InputText("##dev52", tostring(c.isunknown10))
	
	
	GUI:PopItemWidth()
end

function dev.DrawGadgetDetails(c)
	GUI:PushItemWidth(250)
	GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##devg0",tostring(string.format( "%X",c.ptr)))
	GUI:BulletText("ID") GUI:SameLine(200) GUI:InputText("##devg1",tostring(c.id))
	GUI:BulletText("ContentID") GUI:SameLine(200) GUI:InputText("##devg2",tostring(c.contentid))
	GUI:BulletText("ContentID2") GUI:SameLine(200) GUI:InputText("##devg3",tostring(c.contentid2))
	GUI:BulletText("Type") GUI:SameLine(200) GUI:InputText("##devg4",tostring(c.contentid2))
	GUI:BulletText("Type2") GUI:SameLine(200) GUI:InputText("##devg5",tostring(c.contentid2))
	GUI:BulletText("Name") GUI:SameLine(200) GUI:InputText("##devg6",c.Name)
	GUI:BulletText("Status") GUI:SameLine(200) GUI:InputText("##devg7",c.status)
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
	GUI:BulletText("LoS") GUI:SameLine(200) GUI:InputText("##devg14", tostring(c.los))
	GUI:BulletText("OnMesh") GUI:SameLine(200) GUI:InputText("##devg15", tostring(c.onmesh))
	GUI:BulletText("OnMeshExact") GUI:SameLine(200) GUI:InputText("##devg16", tostring(c.onmeshexact))	
	GUI:BulletText("Attitude") GUI:SameLine(200) GUI:InputText("##devg17", tostring(c.attitude))	
	GUI:BulletText("IsInInteractRange") GUI:SameLine(200) GUI:InputText("##devg18", tostring(c.isininteractrange))
	GUI:BulletText("Interactable") GUI:SameLine(200) GUI:InputText("##devg21", tostring(c.interactable))
	GUI:BulletText("Selectable") GUI:SameLine(200) GUI:InputText("##devg22", tostring(c.selectable))
	GUI:BulletText("Attackable") GUI:SameLine(200) GUI:InputText("##devg23", tostring(c.attackable))
	GUI:BulletText("Lootable") GUI:SameLine(200) GUI:InputText("##devg24", tostring(c.lootable))
	GUI:BulletText("Gatherable") GUI:SameLine(200) GUI:InputText("##devg25", tostring(c.gatherable))
	GUI:BulletText("RessourceType") GUI:SameLine(200) GUI:InputText("##degv26", tostring(c.resourcetype))
	GUI:BulletText("Alive") GUI:SameLine(200) GUI:InputText("##devg27", tostring(c.alive))
	GUI:BulletText("Dead") GUI:SameLine(200) GUI:InputText("##devg28", tostring(c.dead))
	GUI:BulletText("IsCombatant") GUI:SameLine(200) GUI:InputText("##devg29", tostring(c.iscombatant))
	GUI:BulletText("IsOurs") GUI:SameLine(200) GUI:InputText("##devg30", tostring(c.isours))
	GUI:BulletText("IsTurret") GUI:SameLine(200) GUI:InputText("##devg45", tostring(c.isturret))
	GUI:BulletText("Unknown0") GUI:SameLine(200) GUI:InputText("##devg31", tostring(c.isunknown0))
	GUI:BulletText("Unknown1") GUI:SameLine(200) GUI:InputText("##devg32", tostring(c.isunknown1))
	GUI:BulletText("Unknown2") GUI:SameLine(200) GUI:InputText("##devg33", tostring(c.isunknown2))
	GUI:BulletText("Unknown3") GUI:SameLine(200) GUI:InputText("##devg34", tostring(c.isunknown3))
	GUI:BulletText("Unknown4") GUI:SameLine(200) GUI:InputText("##devg35", tostring(c.isunknown4))
	GUI:BulletText("Unknown5") GUI:SameLine(200) GUI:InputText("##devg36", tostring(c.isunknown5))
	GUI:BulletText("Unknown6") GUI:SameLine(200) GUI:InputText("##devg37", tostring(c.isunknown6))
	GUI:BulletText("Unknown7") GUI:SameLine(200) GUI:InputText("##devg38", tostring(c.isunknown7))
	GUI:BulletText("Unknown8") GUI:SameLine(200) GUI:InputText("##devg39", tostring(c.isunknown8))
	GUI:BulletText("Unknown9") GUI:SameLine(200) GUI:InputText("##devg40", tostring(c.isunknown9))
	GUI:BulletText("Unknown10") GUI:SameLine(200) GUI:InputText("##devg41", tostring(c.isunknown10))
	GUI:BulletText("Unknown11") GUI:SameLine(200) GUI:InputText("##devg42", tostring(c.isunknown11))
	GUI:BulletText("Unknown12") GUI:SameLine(200) GUI:InputText("##devg43", tostring(c.isunknown12))
	GUI:BulletText("Unknown13") GUI:SameLine(200) GUI:InputText("##devg44", tostring(c.isunknown13))
	GUI:PopItemWidth()

end

function dev.DrawAgentDetails(c)
	
	GUI:PushItemWidth(250)
	GUI:BulletText("AgentPtr") GUI:SameLine(200) GUI:InputText("##deva0",tostring(string.format( "%X",c.ptr)))
	GUI:BulletText("ID") GUI:SameLine(200) GUI:InputText("##deva2",tostring(c.id))
	GUI:BulletText("Type") GUI:SameLine(200) GUI:InputText("##deva3",tostring(c.type))
	GUI:BulletText("Category") GUI:SameLine(200) GUI:InputText("##deva6",tostring(c.category))
	GUI:BulletText("IsCharacter") GUI:SameLine(200) GUI:InputText("##deva7",tostring(c.ischaracter))
	GUI:BulletText("IsEntity") GUI:SameLine(200) GUI:InputText("##deva25",tostring(c.isentity))
	GUI:BulletText("IsDynamic") GUI:SameLine(200) GUI:InputText("##deva8",tostring(c.isdynamic))
	local p = c.pos
	GUI:BulletText("Position") GUI:SameLine(200)  GUI:InputFloat3( "##deva9", p.x, p.y, p.z, 2, GUI.InputTextFlags_ReadOnly)
	GUI:BulletText("Heading") GUI:SameLine(200)  GUI:InputFloat3( "##deva10", p.hx, p.hy, p.hz, 2, GUI.InputTextFlags_ReadOnly)
	GUI:BulletText("Height/Radius") GUI:SameLine(200)  GUI:InputFloat2( "##deva11", c.height, c.radius, 2, GUI.InputTextFlags_ReadOnly)	
	GUI:BulletText("Distance") GUI:SameLine(200) GUI:InputFloat("##deva12", c.distance,0,0,2)
	GUI:BulletText("PathDistance") GUI:SameLine(200) GUI:InputFloat("##deva13", c.pathdistance,0,0,2)	
	GUI:BulletText("LoS") GUI:SameLine(200) GUI:InputText("##deva14", tostring(c.los))
	GUI:BulletText("OnMesh") GUI:SameLine(200) GUI:InputText("##deva15", tostring(c.onmesh))
	GUI:BulletText("OnMeshExact") GUI:SameLine(200) GUI:InputText("##deva16", tostring(c.onmeshexact))	
	GUI:BulletText("Alive") GUI:SameLine(200) GUI:InputText("##deva23", tostring(c.alive))
	GUI:BulletText("IsInInteractRange") GUI:SameLine(200) GUI:InputText("##deva20", tostring(c.isininteractrange))
	GUI:BulletText("Interactable") GUI:SameLine(200) GUI:InputText("##deva21", tostring(c.interactable))
	GUI:BulletText("Selectable") GUI:SameLine(200) GUI:InputText("##deva22", tostring(c.selectable))	
	GUI:BulletText("Lootable") GUI:SameLine(200) GUI:InputText("##deva23", tostring(c.lootable))	
	GUI:PopItemWidth()
end

function dev.DrawMapMarkerDetails(id,b)
	if ( GUI:TreeNode(tostring(id).."-"..b.name)) then
		GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##devm0",tostring(string.format( "%X",b.ptr)))
		GUI:BulletText("Ptr2") GUI:SameLine(200) GUI:InputText("##devm1",tostring(string.format( "%X",b.ptr2)))
		GUI:BulletText("Name") GUI:SameLine(200) GUI:InputText("##devm2",b.name)
		GUI:BulletText("ContentID") GUI:SameLine(200) GUI:InputText("##devm8",tostring(b.contentid))
		GUI:BulletText("MarkerType") GUI:SameLine(200) GUI:InputText("##devm4",tostring(b.markertype))
		GUI:BulletText("WorldMarkerType") GUI:SameLine(200) GUI:InputText("##devm5",tostring(b.worldmarkertype))
		GUI:BulletText("EventID") GUI:SameLine(200) GUI:InputText("##devm6",tostring(b.eventid))
		GUI:BulletText("CharacterID") GUI:SameLine(200) GUI:InputText("##devm7",tostring(b.characterid))		
		GUI:BulletText("SubregionID") GUI:SameLine(200) GUI:InputText("##devm9",tostring(b.subregionid))
		local p = b.pos
		GUI:BulletText("Position") GUI:SameLine(200)  GUI:InputFloat3( "##devm10", p.x, p.y, p.z, 2, GUI.InputTextFlags_ReadOnly)
		GUI:BulletText("OnMesh") GUI:SameLine(200) GUI:InputText("##devm11", tostring(b.onmesh))
		GUI:BulletText("Distance") GUI:SameLine(200) GUI:InputFloat("##devm12", b.distance,0,0,2)
		GUI:BulletText("PathDistance") GUI:SameLine(200) GUI:InputFloat("##devm13", b.pathdistance,0,0,2)
		local einfo = b.eventinfo
		if ( table.valid(einfo) ) then
			if ( GUI:TreeNode("EventDetais") ) then
				GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##deve0",tostring(string.format( "%X",einfo.ptr)))
				GUI:BulletText("Level") GUI:SameLine(200) GUI:InputText("##deve1",tostring(einfo.level))
				GUI:BulletText("InRange") GUI:SameLine(200) GUI:InputText("##deve2",tostring(einfo.inrange))
				GUI:BulletText("ObjectiveCount") GUI:SameLine(200) GUI:InputText("##deve3",tostring(einfo.objectivecount))
				GUI:BulletText("Unknown0") GUI:SameLine(200) GUI:InputText("##deve4",tostring(einfo.isdungeonevent))
				GUI:BulletText("Unknown1") GUI:SameLine(200) GUI:InputText("##deve5",tostring(einfo.A))
				GUI:BulletText("Unknown2") GUI:SameLine(200) GUI:InputText("##deve6",tostring(einfo.B))
				GUI:BulletText("Unknown3") GUI:SameLine(200) GUI:InputText("##deve7",tostring(einfo.C))
				GUI:BulletText("Unknown4") GUI:SameLine(200) GUI:InputText("##deve8",tostring(einfo.D))
				GUI:BulletText("Unknown5") GUI:SameLine(200) GUI:InputText("##deve9",tostring(einfo.E))
				GUI:BulletText("Unknown6") GUI:SameLine(200) GUI:InputText("##deve10",tostring(einfo.F))
				GUI:BulletText("Unknown7") GUI:SameLine(200) GUI:InputText("##deve11",tostring(einfo.G))
				local eo = b.eventobjectivelist
				if ( table.valid(eo) ) then
					if ( GUI:TreeNode("ObjectiveDetails") ) then
						for eid,ee in pairs(eo) do
														if ( GUI:TreeNode("ID: "..tostring(eid) )) then
															GUI:BulletText("Ptr") GUI:SameLine(200) GUI:InputText("##deveo0",tostring(string.format( "%X",ee.ptr)))
															GUI:BulletText("Value1") GUI:SameLine(200) GUI:InputText("##deveo1",tostring(ee.value1))
															GUI:BulletText("Value2") GUI:SameLine(200) GUI:InputText("##deveo1",tostring(ee.value2))
															GUI:BulletText("Value3") GUI:SameLine(200) GUI:InputText("##deveo1",tostring(ee.value3))
															GUI:BulletText("Value4") GUI:SameLine(200) GUI:InputText("##deveo1",tostring(ee.value4))
															GUI:BulletText("Value5") GUI:SameLine(200) GUI:InputText("##deveo1",tostring(ee.value5))															
															GUI:TreePop()
														end	
													end
													GUI:TreePop()
												end												
				end
				GUI:TreePop()
			end
		end
		GUI:BulletText("IsWorldPortal") GUI:SameLine(200) GUI:InputText("##devm14",tostring(b.isworldportal))
		GUI:BulletText("IsWaypoint") GUI:SameLine(200) GUI:InputText("##devm15",tostring(b.iswaypoint))
		GUI:BulletText("IsQuest") GUI:SameLine(200) GUI:InputText("##devm16",tostring(b.isquest))
		GUI:BulletText("IsSubregion") GUI:SameLine(200) GUI:InputText("##devm17",tostring(b.issubregion))
		GUI:BulletText("IsVista") GUI:SameLine(200) GUI:InputText("##devm18",tostring(b.isvista))
		GUI:BulletText("IsCommander") GUI:SameLine(200) GUI:InputText("##devm19",tostring(b.iscommander))
		GUI:BulletText("IsPoi") GUI:SameLine(200) GUI:InputText("##devm20",tostring(b.ispoi))
		GUI:BulletText("IsHeroPoint") GUI:SameLine(200) GUI:InputText("##devm34",tostring(b.isheropoint))
		GUI:BulletText("Unknown0") GUI:SameLine(200) GUI:InputText("##devm21",tostring(b.isunknown0))
		GUI:BulletText("Unknown1") GUI:SameLine(200) GUI:InputText("##devm22",tostring(b.isunknown1))
		GUI:BulletText("Unknown2") GUI:SameLine(200) GUI:InputText("##devm23",tostring(b.isunknown2))	
		GUI:BulletText("Unknown4") GUI:SameLine(200) GUI:InputText("##devm25",tostring(b.isunknown4))
		GUI:BulletText("Unknown5") GUI:SameLine(200) GUI:InputText("##devm26",tostring(b.isunknown5))
		GUI:BulletText("Unknown6") GUI:SameLine(200) GUI:InputText("##devm27",tostring(b.isunknown6))
		GUI:BulletText("Unknown7") GUI:SameLine(200) GUI:InputText("##devm28",tostring(b.isunknown7))
		GUI:BulletText("Unknown8") GUI:SameLine(200) GUI:InputText("##devm29",tostring(b.isunknown8))
		GUI:BulletText("Unknown9") GUI:SameLine(200) GUI:InputText("##devm30",tostring(b.isunknown9))
		GUI:BulletText("Unknown10") GUI:SameLine(200) GUI:InputText("##devm31",tostring(b.isunknown10))
		GUI:BulletText("Unknown11") GUI:SameLine(200) GUI:InputText("##devm32",tostring(b.isunknown11))
		GUI:BulletText("Unknown12") GUI:SameLine(200) GUI:InputText("##devm33",tostring(b.isunknown12))		
		
		GUI:TreePop()
	end
end


