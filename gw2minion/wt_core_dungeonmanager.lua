
wt_core_dungeonmanager = { }
wt_core_dungeonmanager.wnd = { name = "DungeonManager", x = 350, y = 100, w = 250, h = 200}
wt_core_dungeonmanager.lasttick = 0
wt_core_dungeonmanager.visible = false
wt_core_dungeonmanager.doublecheck = false
wt_core_dungeonmanager.ContestedTmr = 0
wt_core_dungeonmanager.ANetFuckUpCounter = 0
wt_core_dungeonmanager.CurrentDungeon = {
	["Active"] = nil,
	["MapID_Outside"] = nil,
	["MapID_Inside"] = nil,
	["PortalWPID"] = nil,
	["PortalNeedsNavMesh"] = false,
	["PortalPosition"] = {x = nil, y = nil, z = nil},
	["PortalReadyPosition"] = {x = nil, y = nil, z = nil},
	["DungeonLevel"] = 0,
		

}

wt_core_dungeonmanager.Instances = {
	[69] = "CitadelOfFlames(Exploration)",
}

RegisterEventHandler("Module.Initalize",
	function (DMGR)				
		if (Settings.GW2MINION.dPartysize == nil) then
			Settings.GW2MINION.dPartysize = "0"
		end
		
		local wnd = GUI_GetWindowInfo("GW2Minion")
		GUI_NewWindow(wt_core_dungeonmanager.wnd.name,wnd.x+wnd.width,wnd.y+180,wt_core_dungeonmanager.wnd.w,wt_core_dungeonmanager.wnd.h)
		GUI_NewField(wt_core_dungeonmanager.wnd.name,"Status","dStatus","General Settings")
		GUI_NewField(wt_core_dungeonmanager.wnd.name,"Set PartySize","dPartysize","General Settings")	
		GUI_NewSeperator(wt_core_dungeonmanager.wnd.name)
		if (wt_core_dungeonmanager.Instances) then
		local id,name = next(wt_core_dungeonmanager.Instances)
			while id~=nil and name~=nil do
				GUI_NewButton(wt_core_dungeonmanager.wnd.name, tostring(name),tostring(id),"Dungeons")
				RegisterEventHandler(tostring(id),wt_core_dungeonmanager.ButtonHandler)
				id,name = next(wt_core_dungeonmanager.Instances,id)
			end
		end
		GUI_NewSeperator(wt_core_dungeonmanager.wnd.name)
		GUI_NewButton(wt_core_dungeonmanager.wnd.name, "Leave Dungeon","wt_core_dungeonmanager.Leave")
		GUI_NewButton(wt_core_dungeonmanager.wnd.name, "Reset Dungeon","wt_core_dungeonmanager.Reset")
		GUI_NewButton(wt_core_dungeonmanager.wnd.name, "Stop DungeonManager","wt_core_dungeonmanager.Stop")
		dPartysize = Settings.GW2MINION.dPartysize
		dStatus = "                                "
		GUI_WindowVisible(wt_core_dungeonmanager.wnd.name,false)
	end
)

RegisterEventHandler("DungeonManager.toggle", 
	function ()
		if (wt_core_dungeonmanager.visible) then
		GUI_WindowVisible(wt_core_dungeonmanager.wnd.name,false)	
		wt_core_dungeonmanager.visible = false
		else
			local wnd = GUI_GetWindowInfo("GW2Minion")	
			GUI_MoveWindow( wt_core_dungeonmanager.wnd.name, wnd.x+wnd.width,wnd.y+180) 
			GUI_WindowVisible(wt_core_dungeonmanager.wnd.name,true)	
			wt_core_dungeonmanager.visible = true
		end
	end
)

RegisterEventHandler("GUI.Update",
	function(DEvent, DNewVals, DOldVals)
		for k,v in pairs(DNewVals) do
			if ( k == "dPartysize" )then Settings.GW2MINION[tostring(k)] = v
				
			end
		end
		GUI_RefreshWindow(wt_core_dungeonmanager.wnd.name)
	end
)

RegisterEventHandler("Gameloop.Update",
	function ( DMGR, tick )
		if ( tick - wt_core_dungeonmanager.lasttick > 1000 ) then
			wt_core_dungeonmanager.lasttick = tick
			if (wt_core_dungeonmanager.CurrentDungeon["Active"] ~= nil) then
				if ( gMinionEnabled == "1" ) then
					if ( MultiBotIsConnected( ) )then
						local MyMapID = Player:GetLocalMapID()
						if (tonumber(MyMapID) ~= nil ) then
							if ( tonumber(MyMapID) == wt_core_dungeonmanager.CurrentDungeon["MapID_Outside"] ) then
								if (not wt_core_dungeonmanager.CurrentDungeon["PortalNeedsNavMesh"] or NavigationManager:IsNavMeshLoaded()) then
									--if ( TableSize(Player:GetPartyMembers()) == tonumber(dPartysize)-1 ) then	
										local mypos = Player.pos
										if (TableSize(mypos) > 0) then
											local distance =  Distance3D( tonumber(wt_core_dungeonmanager.CurrentDungeon["PortalPosition"].x), tonumber(wt_core_dungeonmanager.CurrentDungeon["PortalPosition"].y), tonumber(wt_core_dungeonmanager.CurrentDungeon["PortalPosition"].z), mypos.x, mypos.y, mypos.z )
											if ( (not Player:IsInstanceDialogShown() and distance >= 50) or wt_core_dungeonmanager.CurrentDungeon["Ready"] == false ) then
											
												if ( not wt_core_dungeonmanager.IsContested() ) then													
													-- walk away from portal first													
													if(wt_core_dungeonmanager.CurrentDungeon["Ready"] == false) then
														-- first time we start it 
														local dist = Distance3D( tonumber(wt_core_dungeonmanager.CurrentDungeon["PortalReadyPosition"].x), tonumber(wt_core_dungeonmanager.CurrentDungeon["PortalReadyPosition"].y), tonumber(wt_core_dungeonmanager.CurrentDungeon["PortalReadyPosition"].z), mypos.x, mypos.y, mypos.z )
														if ( dist > 50 ) then
															dStatus = "Moving to PortalReadyPosition"
															Player:MoveToStraight(tonumber(wt_core_dungeonmanager.CurrentDungeon["PortalReadyPosition"].x), tonumber(wt_core_dungeonmanager.CurrentDungeon["PortalReadyPosition"].y), tonumber(wt_core_dungeonmanager.CurrentDungeon["PortalReadyPosition"].z),35)
														else
															wt_core_dungeonmanager.CurrentDungeon["Ready"] = true
															if (Player:GetRole() == 1 ) then
																wt_core_dungeonmanager.lasttick = wt_core_dungeonmanager.lasttick + 4000
															else
																wt_core_dungeonmanager.lasttick = wt_core_dungeonmanager.lasttick + 8000
															end
														end
													else														
														if ( wt_core_dungeonmanager.CurrentDungeon["PortalNeedsNavMesh"] ) then
															Player:MoveTo(tonumber(wt_core_dungeonmanager.CurrentDungeon["PortalPosition"].x), tonumber(wt_core_dungeonmanager.CurrentDungeon["PortalPosition"].y), tonumber(wt_core_dungeonmanager.CurrentDungeon["PortalPosition"].z),25)
															dStatus = "Navigating to Portal"
														else
															if ( distance < 4000 ) then
																Player:MoveToStraight(tonumber(wt_core_dungeonmanager.CurrentDungeon["PortalPosition"].x), tonumber(wt_core_dungeonmanager.CurrentDungeon["PortalPosition"].y), tonumber(wt_core_dungeonmanager.CurrentDungeon["PortalPosition"].z),25)
																dStatus = "Moving to Portal"
															else															
																dStatus = "BUG:We are not near the PortalWaypoint.."
															end
														end
													end
												else
													Player:StopMoving()
													dStatus = "Dungeon is contested?..Waiting.."
												end
											elseif( not Player:IsInstanceDialogShown() and distance < 50 ) then
												Player:StopMoving()
												dStatus = "Error:PortalDialog not shown?"
											elseif( Player:IsInstanceDialogShown() ) then
												if (Player:GetRole() == 1 ) then
													if ( TableSize(Player:GetPartyMembers()) == tonumber(dPartysize)-1 ) then
														dStatus = "Leader:Opening Instance.."
														wt_core_dungeonmanager.lasttick = wt_core_dungeonmanager.lasttick + 5000
														Player:OpenInstance(tonumber(wt_core_dungeonmanager.CurrentDungeon["DungeonLevel"]))
													else
														dStatus = "Waiting for Partymemebers.."
													end
												else
													wt_core_partymanager.leaderMapID = nil
													wt_core_dungeonmanager.lasttick = wt_core_dungeonmanager.lasttick + 5000
													if ( not Player:JoinInstance()) then
														dStatus = "Waiting for Leader to Open Instance.."
														if (wt_core_dungeonmanager.ANetFuckUpCounter < 2) then
															wt_core_dungeonmanager.ANetFuckUpCounter = wt_core_dungeonmanager.ANetFuckUpCounter + 1
															wt_core_dungeonmanager.CurrentDungeon["Ready"] = false
														else
															dStatus = "Problem while joining, resetting party..."
															wt_core_dungeonmanager.ANetFuckUpCounter = 0
															wt_core_partymanager.RebuildParty()
														end
													end
												end										
											else 
												dStatus = "Error:PortalDialog..no valid case"
											end
										end
									--else
									--	dStatus = "Waiting for Partymemebers.."
									--end
								else
									dStatus = "Error: Outside, NoMeshLoaded!"
								end
								
							elseif ( tonumber(MyMapID) == wt_core_dungeonmanager.CurrentDungeon["MapID_Inside"] ) then
								if ( TableSize(Player:GetPartyMembers()) == Player:GetPartySize() ) then
								
									-- TODO: Add some flexible thingy here for other dungeons..																						
									if (tonumber(MyMapID) == 69) then
										wt_core_dungeonmanager.Play_COF_Path1()
									end
								else
									dStatus = "Partymember is missing.."
									
								end
								
							elseif ( tonumber(wt_core_dungeonmanager.CurrentDungeon["PortalWPID"]) ~= nil ) then 						
								-- to catch hickups in the mapID
								if (wt_core_dungeonmanager.doublecheck == false) then
									wt_debug("We need to port to DungeonEntry.")
									dStatus = "We need to port to DungeonEntry..?"
									wt_core_dungeonmanager.lasttick = wt_core_dungeonmanager.lasttick + 5000
									wt_core_dungeonmanager.doublecheck = true
								else
									wt_debug("Porting to DungeonEntry")
									dStatus = "Porting to DungeonEntry.."
									wt_core_dungeonmanager.doublecheck = false
									wt_core_dungeonmanager.lasttick = wt_core_dungeonmanager.lasttick + 5000
									Player:TeleportToWaypoint(tonumber(wt_core_dungeonmanager.CurrentDungeon["PortalWPID"]))									
								end								
							else
								dStatus = "MyMapID error"
							end
						else
							dStatus = "MyMapID == nil"
						end
					else
						dStatus = tostring("No Connection to Multibotserver.(DNG).")
					end
				else
					dStatus = tostring("Groupbotting Disabled.(DNG).")
				end						
			else
				dStatus = "Not Running"
			end			
		end
	end
)

function wt_core_dungeonmanager.ButtonHandler(event)			
	wt_debug("DungeonHandlerID : "..tostring(event))
	
	if ( gMinionEnabled == "1" ) then
		if ( MultiBotIsConnected( ) )then
		
			if (wt_core_dungeonmanager.CurrentDungeon["Active"] == nil ) then
				if (tonumber(event) == 69) then
					wt_debug("Citadel Of Flame Started...")
					wt_core_dungeonmanager.CurrentDungeon["Active"] = 1
					wt_core_dungeonmanager.CurrentDungeon["Ready"] = false
					wt_core_dungeonmanager.CurrentDungeon["MapID_Outside"] = 22
					wt_core_dungeonmanager.CurrentDungeon["MapID_Inside"] = 69
					wt_core_dungeonmanager.CurrentDungeon["PortalWPID"] = 1344
					wt_core_dungeonmanager.CurrentDungeon["PortalNeedsNavMesh"] = false			
					wt_core_dungeonmanager.CurrentDungeon["PortalPosition"] = {x = 35412, y = 27721, z = -3049}
					wt_core_dungeonmanager.CurrentDungeon["PortalReadyPosition"] = {x = 34915, y = 26853, z = -2706}
					wt_core_dungeonmanager.CurrentDungeon["DungeonLevel"] = 0
					if (Player:GetRole() == 1 ) then
						MultiBotSend( "500;"..tostring(event),"gw2minion" )
					end					
				end
			end	
		else
			dStatus = tostring("No Connection to Multibotserver.(DNG).")
		end
	else
		dStatus = tostring("Groupbotting Disabled.(DNG).")
	end		
end

function wt_core_dungeonmanager.StopDungeon()
	if (gMinionEnabled == "1" and MultiBotIsConnected( ) and Player:GetRole() == 1 ) then
		MultiBotSend( "503;none","gw2minion" )
	end
	wt_core_dungeonmanager.CurrentDungeon["Active"] = nil
	Player:StopMoving()
	wt_core_state_combat.searchBetterTarget = true
	wt_global_information.DoAggroCheck = true
	dStatus = "Stopped"
end

function wt_core_dungeonmanager.ResetDungeon()
	if (gMinionEnabled == "1" and MultiBotIsConnected( ) and Player:GetRole() == 1 ) then
		--MultiBotSend( "503;none","gw2minion" )
	end
	wt_core_dungeonmanager.CurrentDungeon["Ready"] = false	
	Player:StopMoving()
	wt_core_state_combat.searchBetterTarget = true
	wt_global_information.DoAggroCheck = true
	--Player:ResetInstance()
	wt_core_partymanager.RebuildParty()
	wt_core_dungeonmanager.LeaveDungeon()
	dStatus = "Reset Done"
end

function wt_core_dungeonmanager.IsContested() 
	-- Not sure how to check this :/
	if ( tonumber(wt_core_dungeonmanager.CurrentDungeon["MapID_Outside"]) == 22 ) then
		local myWP = WaypointList("nearest,samezone")		
		if (TableSize(myWP) == 1) then
			local id,e = next (myWP)
			if ( id ~= nil) then
				local WPstatus = WaypointList:Get(id).contested
				if ( WPstatus ) then
					return true
				end
			end
		end
	end
	return false
end

function wt_core_dungeonmanager.LeaveDungeon()
	if ( gMinionEnabled == "1" and MultiBotIsConnected( ) and Player:GetRole() == 1 )then
		MultiBotSend( "501;"..tostring(wt_core_dungeonmanager.CurrentDungeon["MapID_Inside"]),"gw2minion" )
	end
	-- Make sure we are in a dungeon, else the fucntion will crash the game ;)
	local mapID = Player:GetLocalMapID()
	if (wt_core_dungeonmanager.Instances and tonumber(mapID)~=nil) then		
		local id,name = next(wt_core_dungeonmanager.Instances)
		while id~=nil and name~=nil do
			if(tonumber(mapID) == id) then
				--wt_core_dungeonmanager.CurrentDungeon["Active"] = nil
				wt_core_dungeonmanager.CurrentDungeon["Ready"] = false
				Player:StopMoving()
				dStatus = "Stopped"
				--pause partymanager else minions may reload into dungeon
				wt_core_partymanager.lasttick = wt_core_dungeonmanager.lasttick + 20000
				wt_core_dungeonmanager.lasttick = wt_core_dungeonmanager.lasttick + 20000
				wt_core_partymanager.leaderMapID = nil
				wt_core_state_combat.searchBetterTarget = true
				wt_global_information.DoAggroCheck = true
				Player:LeaveInstance()
			end
			id,name = next(wt_core_dungeonmanager.Instances,id)
		end
	end
end

function wt_core_dungeonmanager.MapIsDungeon(mapid)
	if (wt_core_dungeonmanager.Instances and tonumber(mapid)~=nil ) then
		local id,name = next(wt_core_dungeonmanager.Instances)
		while id~=nil and name~=nil do
			if ( tonumber(id) == tonumber(mapid) ) then
				return true
			end
			id,name = next(wt_core_dungeonmanager.Instances,id)
		end
	end
	return false
end

function wt_core_dungeonmanager.Pause(seconds)
	if (tonumber(seconds)~=nil) then
		wt_core_dungeonmanager.lasttick = wt_core_dungeonmanager.lasttick + seconds
	end
end

function wt_core_dungeonmanager.Good2MoveOn()

	if (Player.inCombat) then
		return false
	end
	
	-- All teammember alive and grouped
	local party = Player:GetPartyMembers()
	if (party ~= nil ) then
		local index, player  = next( party )
		while ( index ~= nil and player ~= nil ) do	
			if (((player.healthstate == GW2.HEALTHSTATE.Defeated or player.healthstate == GW2.HEALTHSTATE.Downed) and player.onmesh) 
				or (player.distance > 4000)) then
				return false
			end
			index, player  = next( party,index )
		end		
	end	
	return true
end

wt_core_dungeonmanager.pickedup = false
wt_core_dungeonmanager.falling = false
function wt_core_dungeonmanager.Play_COF_Path1()	
	dStatus = "Doing COF Path 1"	
	wt_core_controller.shouldRun = true -- Always run the bot
	if ( Player:GetRole() == 1) then
		local mlist = MapMarkerList("isevent")
		if (TableSize(mlist) > 0) then
			local i,event = next(mlist)
			while (i~=nil and event~=nil) do				
				-- Talk to Mallon to start the dungeon
				if( event.eventID == 2915 and event.type == 165) then 	
					if (event.distance > 75) then
						local epos = event.pos
						Player:MoveTo(epos.x,epos.y,epos.z,50)
						dStatus = "Moving to Mallon"
					else
						Player:StopMoving()						
						if (Player:GetTarget() ~= event.characterID) then
							Player:SetTarget(event.characterID)
							dStatus = "Targeting Mallon.."
						else
							if ( not Player:IsConversationOpen() ) then
								dStatus = "Open Conversation.."
								Player:Interact( event.characterID )								
							else
								dStatus = "Do Conversation.."
								Player:SelectConversationOption(13)
								wt_core_dungeonmanager.Pause(4000)
							end
						end						
					end
					break
				-- Speak with Commander Suma
				elseif( event.eventID == 2913 and event.type == 338) then 	
					if (event.distance > 75) then
						local epos = event.pos
						Player:MoveTo(epos.x,epos.y,epos.z,50)
						dStatus = "Moving to Suma"
					else
						Player:StopMoving()	
					end					
					break
				-- Choose Path
				elseif( event.eventID == 2914 and event.type == 338) then 	
					if (event.distance > 75) then
						local epos = event.pos
						Player:MoveTo(epos.x,epos.y,epos.z,50)
						dStatus = "Moving to Suma"
					else
						Player:StopMoving()
						if (Player:GetTarget() ~= event.characterID) then
							Player:SetTarget(event.characterID)
							dStatus = "Targeting FuseClaw.."
						else
							if ( not Player:IsConversationOpen() ) then
								dStatus = "Open Conversation.."
								Player:Interact( event.characterID )								
							else
								dStatus = "Selecting Path.."
								Player:SelectConversationOptionByIndex(0)
								wt_core_dungeonmanager.Pause(6000)
							end
						end	
					end	
					break
				elseif( event.eventID == 2923 and event.type == 338) then 	
					if (event.distance > 75) then
						local epos = event.pos
						if (not Player.inCombat) then
							Player:MoveTo(epos.x,epos.y,epos.z,100)
							dStatus = "Following Ferrah"
						end
					end
					break
				elseif( event.eventID == 2923 and event.type == 328) then 	
					wt_core_state_combat.searchBetterTarget = false
					if (event.distance > 75) then
						local epos = event.pos
						if (wt_core_dungeonmanager.Good2MoveOn()) then
							Player:MoveTo(epos.x,epos.y,epos.z,100)
							dStatus = "Following Ferrah"
						end
					else
						dStatus = "Ferrah.."
					end
					break
				elseif( event.eventID == 2916 and event.type == 330) then 						
					wt_core_state_combat.searchBetterTarget = false
					local epos = event.pos
					local champ = CharacterList("nearest,isChampion,attackable,onmesh")
					if (TableSize(champ) > 0) then
						local id,e = next(champ)
						if (id ~= nil and e ~= nil and e.distance < 2500) then
							wt_debug("Setting Target to Champion..")
							wt_core_state_combat.setTarget( id )
							wt_core_taskmanager:addKillTask( id, e, 3500 )
						end
					end	
					if (event.distance > 75) then
						if (wt_core_dungeonmanager.Good2MoveOn()) then							
							Player:MoveTo(epos.x,epos.y,epos.z,100)							
						end
					end
					dStatus = "Kill Slave Driver"					
					break
				elseif( event.eventID == 2928 and event.type == 338) then
					wt_core_state_combat.searchBetterTarget = true
					if (event.distance > 75) then
						local epos = event.pos
						if (wt_core_dungeonmanager.Good2MoveOn()) then
							Player:MoveTo(epos.x,epods.y,epos.z,100)
							dStatus = "Follow Ferra"
						end
					end
					break
				elseif( event.eventID == 2917 and event.type == 173) then 
					
					wt_core_dungeonmanager.ResetDungeon()
					
					--[[if (event.distance > 75) then
						local epos = event.pos
						if (wt_core_dungeonmanager.Good2MoveOn()) then
							--Player:MoveTo(epos.x,epos.y,epos.z,200)							
							--dStatus = "Crossing Bridge"							
						end
						if (Player.movementstate == 3) then --we managed to fall of the bridge lol
							if (wt_core_dungeonmanager.falling) then
								Player:Teleport(-8976,5000,-3002)
								wt_core_dungeonmanager.falling = false
							else
								wt_core_dungeonmanager.falling = true
							end
						end
					end]]
					break
				elseif( event.eventID == 2919 and event.type == 173) then					
					wt_core_state_combat.searchBetterTarget = false
					if (Player.movementstate == 3) then
						if (wt_core_dungeonmanager.falling) then
							Player:Teleport(-4347,12368,-4688)
							wt_core_dungeonmanager.falling = false
						else
							wt_core_dungeonmanager.falling = true
						end
					end
					local acrolyts = CharacterList("nearest,contentID=43132,attackable,onmesh")
					if (TableSize(acrolyts) > 0) then
						local id,e = next(acrolyts)
						if (id ~= nil and e ~= nil and e.distance < 2500) then
							wt_core_state_combat.setTarget( id )
							wt_core_taskmanager:addKillTask( id, e, 3500 )
						end
					end	
					if (event.distance > 75) then
						local epos = event.pos
						if (wt_core_dungeonmanager.Good2MoveOn()) then
							Player:MoveTo(-4347,12368,-4688,50)
							dStatus = "Kill Acolytes"
						end
					end
					break
				elseif( event.eventID == 2925 and event.type == 340) then
					local pos1 = {x =-3812, y=7361,z=-4468} -- Pickup Fireball
					local pos2 = {x =-2301, y=7224,z=-4451} -- Drop Fireball 1
					local pos3 = {x =-2285, y=7435,z=-4381} -- Drop Fireball 2
					local pos4 = {x =-2412, y=7704,z=-4423} -- Drop Fireball 3					
					local mypos = Player.pos
					wt_core_state_combat.searchBetterTarget = true
					
					if (not wt_core_dungeonmanager.pickedup) then
						local dist1 =  Distance3D( pos1.x, pos1.y, pos1.z, mypos.x, mypos.y, mypos.z )
						if (dist1 > 50) then
							if (wt_core_dungeonmanager.Good2MoveOn()) then								
								Player:MoveTo(pos1.x, pos1.y, pos1.z,30)
								dStatus = "Enkindling Chamber"
							end
						else
							wt_core_dungeonmanager.pickedup = true
							Player:PressF()
							--Player:NoClip(true)
						end
					else						
						local dist2 =  Distance3D( pos2.x, pos2.y, pos2.z, mypos.x, mypos.y, mypos.z )
						if (dist2 > 50) then
							Player:Teleport(pos2.x,pos2.y,pos2.z)
							--Player:MoveTo(pos2.x,pos2.y,pos2.z,25)
						else
							--wt_core_dungeonmanager.pickedup = false
							Player:PressF()
							--Player:NoClip(false)
						end
					end
					break
				end	
				--local posGateController = {x =-487, y=8917,z=-4491}				
				i,event = next(mlist,i)
			end
		else
		
		end
	else
		dStatus = "COF Path 1 Minion"
		local mlist = MapMarkerList("isevent")
		if (TableSize(mlist) > 0) then
			local i,event = next(mlist)
			while (i~=nil and event~=nil) do				
				-- Selecting Path
				wt_core_state_combat.searchBetterTarget = false
				
				if( event.eventID == 2914 and event.type == 338) then 
					if ( Player:IsConversationOpen() ) then						
						dStatus = "Selecting Path.."
						Player:SelectConversationOptionByIndex(0)
						wt_core_dungeonmanager.Pause(6000)
					end
					break
				elseif( event.eventID == 2916 and event.type == 330) then 	
					wt_core_state_combat.searchBetterTarget = false
					local champ = CharacterList("nearest,isChampion,attackable,onmesh")
					if (TableSize(champ) > 0) then
						local id,e = next(champ)
						if (id ~= nil and e ~= nil and e.distance < 2500) then
							wt_debug("Setting Target to Champion..")
							wt_core_state_combat.setTarget( id )
							wt_core_taskmanager:addKillTask( id, e, 3500 )
						end
					end	
					dStatus = "Kill Slave Driver"
					break
				elseif( event.eventID == 2917 and event.type == 173) then				
					wt_core_state_combat.searchBetterTarget = true
					dStatus = "Crossing Bridge"
					--gCombatmovement = "0"
					if (Player.movementstate == 3) then
						if (wt_core_dungeonmanager.falling) then
							Player:Teleport(-8976,5000,-3002)
							wt_core_dungeonmanager.falling = false
						else
							wt_core_dungeonmanager.falling = true
						end
					end
					break
				elseif( event.eventID == 2919 and event.type == 173) then					
					wt_core_state_combat.searchBetterTarget = false
					if (Player.movementstate == 3) then
						if (wt_core_dungeonmanager.falling) then
							Player:Teleport(-4347,12368,-4688)
							wt_core_dungeonmanager.falling = false
						else
							wt_core_dungeonmanager.falling = true
						end
					end
					local acrolyts = CharacterList("nearest,contentID=43132,attackable,onmesh")
					if (TableSize(acrolyts) > 0) then
						local id,e = next(acrolyts)
						if (id ~= nil and e ~= nil and e.distance < 2500) then
							wt_core_state_combat.setTarget( id )
							wt_core_taskmanager:addKillTask( id, e, 3500 )
						end
					end	
					if (event.distance > 75) then
						local epos = event.pos
						--if (not Player.inCombat) then
						--	Player:MoveTo(-4347,12368,-4688,10)
							dStatus = "Kill Acolytes"
						--end
					end
					break
				elseif( event.eventID == 2925 and event.type == 340) then
					dStatus = "Enkindling Chamber"
					local pos1 = {x =-3812, y=7361,z=-4468}
					local pos3 = {x =-2285, y=7435,z=-4381}
					local pos4 = {x =-2412, y=7704,z=-4423}
					local mypos = Player.pos
					wt_core_state_combat.searchBetterTarget = true
					
					if (not wt_core_dungeonmanager.pickedup) then
						local dist1 =  Distance3D( pos1.x, pos1.y, pos1.z, mypos.x, mypos.y, mypos.z )
						if (dist1 > 50) then
							if (wt_core_dungeonmanager.Good2MoveOn()) then
								Player:MoveTo(pos1.x, pos1.y, pos1.z,30)
								dStatus = "Enkindling Chamber"
							end
						else
							wt_core_dungeonmanager.pickedup = true
							Player:PressF()
							--Player:NoClip(true)
						end
					else
						if (tonumber(wt_core_partymanager.GetMyListIndex()) <= 3 ) then					
							local dist3 =  Distance3D( pos3.x, pos3.y, pos3.z, mypos.x, mypos.y, mypos.z )
							if (dist3 > 50) then
								Player:Teleport(pos3.x,pos3.y,pos3.z)
								--Player:MoveTo(pos3.x,pos3.y,pos3.z,25)				
							else
								--wt_core_dungeonmanager.pickedup = false
								Player:PressF()
								--Player:NoClip(false)
							end
						else
							local dist4 =  Distance3D( pos4.x, pos4.y, pos4.z, mypos.x, mypos.y, mypos.z )
							if (dist4 > 50) then
								Player:Teleport(pos4.x,pos4.y,pos4.z)
								--Player:MoveTo(pos4.x,pos4.y,pos4.z,25)				
							else
								--wt_core_dungeonmanager.pickedup = false
								Player:PressF()
								--Player:NoClip(false)
							end
						end
					end
					break
				end
				i,event = next(mlist,i)
			end
		end
	end	
end

RegisterEventHandler("wt_core_dungeonmanager.Stop",wt_core_dungeonmanager.StopDungeon)
RegisterEventHandler("wt_core_dungeonmanager.Reset",wt_core_dungeonmanager.ResetDungeon)
RegisterEventHandler("wt_core_dungeonmanager.Leave",wt_core_dungeonmanager.LeaveDungeon)