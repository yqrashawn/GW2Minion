gw2_multibot_manager = { }
gw2_multibot_manager.mainwindow = { name = GetString("multibotmanager"), x = 350, y = 100, w = 250, h = 300}
gw2_multibot_manager.visible = false
gw2_multibot_manager.lasttick = 0

gw2_multibot_manager.multiBotIsConnected = false


gw2_multibot_manager.leadername = ""
gw2_multibot_manager.leaderserverID = 0
gw2_multibot_manager.leaderWPID = 0
gw2_multibot_manager.leaderMapID = nil
gw2_multibot_manager.leaderBotMode = nil
gw2_multibot_manager.leaderTMProfile = nil
gw2_multibot_manager.leaderTMTaskID = nil

function gw2_multibot_manager.ModuleInit() 	
	
	if (Settings.GW2Minion.gMultiBotEnabled == nil) then
		Settings.GW2Minion.gMultiBotEnabled = "0"
	end
	
   	if (Settings.GW2Minion.gRole == nil) then
		Settings.GW2Minion.gRole = "Party Member"
	end
	
	if (Settings.GW2Minion.Party == nil) then
		Settings.GW2Minion.Party = {}
		for idx=1,4 do
			if (Settings.GW2Minion.Party[idx] == nil) then
				Settings.GW2Minion.Party[idx] = ""
			end				
		end
		Settings.GW2Minion.Party = Settings.GW2Minion.Party
	end	
	
	
	if ( Settings.GW2Minion.MBSGroup == nil ) then
		Settings.GW2Minion.MBSGroup = "Group1"
	end
	if ( Settings.GW2Minion.gMultiIP == nil ) then
		Settings.GW2Minion.gMultiIP = "127.0.0.1"
	end
	if ( Settings.GW2Minion.gMultiPort == nil ) then
		Settings.GW2Minion.gMultiPort = "7777"
	end
	if ( Settings.GW2Minion.gMultiPw == nil ) then
		Settings.GW2Minion.gMultiPw = "minionpw"
	end
	    
	local wnd = GUI_GetWindowInfo("MainMenu")
    if (wnd) then
		GUI_NewWindow(gw2_multibot_manager.mainwindow.name,wnd.x+wnd.width,wnd.y,gw2_multibot_manager.mainwindow.w,gw2_multibot_manager.mainwindow.h,true)
		GUI_NewCheckbox(gw2_multibot_manager.mainwindow.name,GetString("activated"),"gMultiBotEnabled",GetString("generalSettings"))
		GUI_NewField(gw2_multibot_manager.mainwindow.name,GetString("status"),"dPartyStatus",GetString("generalSettings"))
		GUI_NewField(gw2_multibot_manager.mainwindow.name,GetString("partyrole"),"gRole",GetString("generalSettings"))
		GUI_NewField(gw2_multibot_manager.mainwindow.name,GetString("member1"),"dMember1",GetString("groupInfo"))
		GUI_NewField(gw2_multibot_manager.mainwindow.name,GetString("member2"),"dMember2",GetString("groupInfo"))
		GUI_NewField(gw2_multibot_manager.mainwindow.name,GetString("member3"),"dMember3",GetString("groupInfo"))
		GUI_NewField(gw2_multibot_manager.mainwindow.name,GetString("member4"),"dMember4",GetString("groupInfo"))
		GUI_NewButton(gw2_multibot_manager.mainwindow.name,GetString("usecurrentparty"), "bcopyParty",GetString("groupInfo"))
		RegisterEventHandler("bcopyParty", gw2_multibot_manager.CopyParty)
		
		GUI_NewField(gw2_multibot_manager.mainwindow.name,GetString("MBSGroup"),"MBSGroup",GetString("serverInfo"))
		GUI_NewField(gw2_multibot_manager.mainwindow.name,GetString("MBSIP"),"gMultiIP",GetString("serverInfo"))
		GUI_NewField(gw2_multibot_manager.mainwindow.name,GetString("MBSPort"),"gMultiPort",GetString("serverInfo"))
		GUI_NewField(gw2_multibot_manager.mainwindow.name,GetString("MBSPW"),"gMultiPw",GetString("serverInfo"))
	
						
		gPartyMGR = Settings.GW2Minion.gPartyMGR
		dPartyStatus = "Connecting to MultibotServer."
		gRole = "None"
		dMember1 = Settings.GW2Minion.Party[1]
		dMember2 = Settings.GW2Minion.Party[2]
		dMember3 = Settings.GW2Minion.Party[3]
		dMember4 = Settings.GW2Minion.Party[4]
		gMultiBotEnabled = Settings.GW2Minion.gMultiBotEnabled
		
		MBSGroup = Settings.GW2Minion.MBSGroup
		gMultiIP = Settings.GW2Minion.gMultiIP
		gMultiPort = Settings.GW2Minion.gMultiPort
		gMultiPw = Settings.GW2Minion.gMultiPw
				
		GUI_UnFoldGroup(gw2_multibot_manager.mainwindow.name,GetString("generalSettings"))		
		GUI_UnFoldGroup(gw2_multibot_manager.mainwindow.name,GetString("groupInfo"))
		
		GUI_WindowVisible(gw2_multibot_manager.mainwindow.name,false)
	end
			
	-- fix for getting the proper leader/minion role on reload lua	
	if (gMultiBotEnabled == "1" and MultiBotIsConnected() ) then
		MultiBotJoinChannel(MBSGroup)
	end
	
	local dw = WindowManager:GetWindow(gw2minion.DebugWindow.Name)
	if ( dw ) then
		dw:NewField("LeaderName","gMBLName","MultibotInfo")
		dw:NewField("LeaderServerID","gMBLSID","MultibotInfo")
		dw:NewField("LeaderMapID","gMBLMapID","MultibotInfo")
		dw:NewField("LeaderWPID","gMBLWPID","MultibotInfo")
		dw:NewField("LeaderBotMode","gMBLBotMode","MultibotInfo")
		dw:NewField("LeaderTMProfile","gMBLTMP","MultibotInfo")
		dw:NewField("LeaderTMTaskID","gMBLTMID","MultibotInfo")
	end
end


function gw2_multibot_manager.ToggleMenu()
    if (gw2_multibot_manager.visible) then
        GUI_WindowVisible(gw2_multibot_manager.mainwindow.name,false)	
        gw2_multibot_manager.visible = false
    else
		local wnd = GUI_GetWindowInfo("MainMenu")
        if (wnd) then
			GUI_MoveWindow( gw2_multibot_manager.mainwindow.name, wnd.x+wnd.width,wnd.y) 
			GUI_WindowVisible(gw2_multibot_manager.mainwindow.name,true)	
			gw2_multibot_manager.visible = true
		end
    end
end

gw2_multibot_manager.multiBotConnectTmr = 0
gw2_multibot_manager.multiBotConnectAttempts = 0
function gw2_multibot_manager.OnUpdate( tickcount )
    if ( TimeSince(gw2_multibot_manager.lasttick) > 500 ) then
        gw2_multibot_manager.lasttick = tickcount
        
		-- Update main variables
		gw2_multibot_manager.multiBotIsConnected = MultiBotIsConnected()
		
		        
		if ( gw2_multibot_manager.multiBotIsConnected ) then
								
			gw2_multibot_manager.LeaderBroadCast(tickcount)
			gw2_multibot_manager.UpdatePartyStatus()					
			
		else
			
			if ( TimeSince(gw2_multibot_manager.multiBotConnectTmr) > 5000 ) then
				gw2_multibot_manager.multiBotConnectTmr = tickcount
				
				if ( gMultiBotEnabled == "1" ) then 
					if ( not MultiBotConnect( gMultiIP , tonumber(gMultiPort) , gMultiPw) ) then
						
						gw2_multibot_manager.multiBotConnectAttempts = gw2_multibot_manager.multiBotConnectAttempts + 100					
						dPartyStatus = "Start the MultibotServer.exe and/or setup the correct Password,IP and Port if you have changed them!"
						
						if ( gw2_multibot_manager.multiBotConnectAttempts > 2 ) then 
							-- Create a Dialog to inform the user
							local dialog = gw2_dialog_manager:GetDialog(GetString("serverInfo"))
							if (dialog == nil) then
								dialog = gw2_dialog_manager:NewDialog(GetString("serverInfo"))
								dialog:NewLabel(GetString("mbwarning") ) 
								--dialog:SetSize(150,50)
								dialog:SetOkFunction(
									function()
										gMultiBotEnabled = "0"
										return true
									end
								)
							end
							if (dialog) then
								dialog:Show(false,false)
							end
						end
						
					else
						gw2_multibot_manager.multiBotConnectAttempts = 0
						if (MultiBotJoinChannel(MBSGroup)) then
							d("Successfully Joined channel "..MBSGroup)
							dPartyStatus = "Connected to MultibotServer"
						else
							
							dPartyStatus = "Can't join Multibot Channel"
						end
					end
				end
			end
		end
		
		-- Update Debug Data
		if ( ml_global_information.ShowDebug ) then 
			gMBLName = gw2_multibot_manager.leadername or ""
			gMBLSID = gw2_multibot_manager.leaderserverID or 0
			gMBLMapID = gw2_multibot_manager.leaderWPID or 0
			gMBLWPID = gw2_multibot_manager.leaderMapID or 0
			gMBLBotMode = gw2_multibot_manager.leaderBotMode or ""
			gMBLTMP = gw2_multibot_manager.leaderTMProfile or ""
			gMBLTMID = gw2_multibot_manager.leaderTMTaskID or ""			
		end
    end
end

function gw2_multibot_manager.CopyParty()
	local party = ml_global_information.Player_Party	
	if ( TableSize(party) > 1 ) then		
		local pname = ml_global_information.Player_Name
		local count = 1
				
		for idx=1,4 do			
			Settings.GW2Minion.Party[idx] = "None"
			_G["dMember"..idx] = "None"			
		end
		
		local index, player  = next( party )
		while ( index ~= nil and player ~= nil ) do			
			if ( player.name ~= pname and player.name ~= "") then
				Settings.GW2Minion.Party[count] = player.name
				_G["dMember"..count] = player.name
				count = count + 1
			end
			index, player  = next( party,index )
		end
	end
	Settings.GW2Minion.Party = Settings.GW2Minion.Party
	GUI_RefreshWindow(gw2_multibot_manager.mainwindow.name)
end

gw2_multibot_manager.broadcastTmr = 0
gw2_multibot_manager.broadcastTmr2 = 0
function gw2_multibot_manager.LeaderBroadCast(tickcount)
	if ( Player:GetRole() == 1 ) then
		if ( TimeSince(gw2_multibot_manager.broadcastTmr) > 5000 ) then
			gw2_multibot_manager.broadcastTmr = tickcount
			
			-- playername
			if ( ml_global_information.Player_Name ~= nil and ml_global_information.Player_Name ~= "" ) then
				MultiBotSend( "1;"..ml_global_information.Player_Name,MBSGroup )
			end
			
			-- currentserverid
			local data = gw2_multibot_manager.GetPlayerPartyData()
			if ( data and tonumber(data.currentserverid)~=nil) then			
				MultiBotSend( "2;"..data.currentserverid,MBSGroup )
			end
			
			-- localmapid
			if ( ml_global_information.CurrentMapID ~= nil and ml_global_information.CurrentMapID ~= "" ) then
				MultiBotSend( "5;"..ml_global_information.CurrentMapID,MBSGroup )
			end
			
			-- closest WP
			local WList = WaypointList("nearest,onmesh,notcontested,samezone")
			if ( TableSize(WList) > 0 ) then
				local id,wp = next(WList)
				if (id and wp ) then
					MultiBotSend( "3;"..wp.id,MBSGroup )
				end
			end
			
			-- BotMode
			if ( gw2_multibot_manager.leaderBotMode ~= nil ) then
				MultiBotSend( "6;"..gw2_multibot_manager.leaderBotMode,MBSGroup )
			end
			
			-- TMProfile
			if ( gw2_multibot_manager.leaderTMProfile ~= nil ) then
				MultiBotSend( "7;"..gw2_multibot_manager.leaderTMProfile,MBSGroup )
			end
			
			-- TM TaskID
			if ( gw2_multibot_manager.leaderTMTaskID ~= nil ) then
				MultiBotSend( "8;"..gw2_multibot_manager.leaderTMTaskID,MBSGroup )
			end
			
		end
		
		if ( TimeSince(gw2_multibot_manager.broadcastTmr2) > 1500 ) then
			gw2_multibot_manager.broadcastTmr2 = tickcount
			-- targetID
			local t = Player:GetTarget()		
			if ( t ~= nil and TableSize(t) > 0 and t.distance < 1500 and t.selectable and t.attackable and t.dead == false) then				
				MultiBotSend( "4;"..tostring(t.id),MBSGroup )	
			end			
		end		
	end
end

--connectionstatus 2 = disco/offline , 3 = connected, 4=invitation pending on player
--invitationstatus 1 = not in a party, 2 partyinvite, 4 squadinvite , 5 teaminvite
function gw2_multibot_manager.UpdatePartyStatus()
			
	if ( Player:GetRole() == 1 ) then
		-- Invite the others		
		local party = ml_global_information.Player_Party	
		if ( TableSize(party) < gw2_multibot_manager.membercount()+1 ) then
			-- Not all Members are in our party yet		
			local myname = ml_global_information.Player_Name			
			local setupparty = Settings.GW2Minion.Party
			
			local idx, pname  = next( setupparty )
			while ( idx ~= nil and pname ~= nil ) do
				if (pname ~= "None" and pname ~= "") then
					
					local found = false
					local index, player  = next( party )
					while ( index ~= nil and player ~= nil and player.name ~= "") do			
						if ( player.name == pname ) then
							found = true
							break -- this player is already in our party
						end
						index, player  = next( party,index )
					end
					
					if ( not found and mc_blacklist.IsBlacklisted(pname) == false) then	
						d("Inviting "..pname)
						dPartyStatus = "Inviting "..pname
						SendChatMsg(GW2.CHATCHANNEL.Say,"/invite "..pname)												
						mc_blacklist.AddBlacklistEntry(GetString("partymember"), idx, pname, mc_global.now + 30000)
						return 
					end
				end
				idx, pname  = next( setupparty,idx )
			end	
			dPartyStatus = "Partymember missing.."			
		else
			dPartyStatus = "Party Complete"			
		end
	
	else
		-- Wait for invitation and accept
		if ( gw2_multibot_manager.leadername ~= nil and gw2_multibot_manager.leadername ~= "" ) then 
			local party = ml_global_information.Player_Party
			if ( TableSize(party) > 0 ) then
				local pname = ml_global_information.Player_Name
				local index, player  = next( party )
				while ( index ~= nil and player ~= nil ) do	
					if ( player.name == pname and player.name ~= "") then
						-- check if we got a party invite
						if ( player.hasparty == false ) then
							if ( (player.connectstatus == 3 or player.connectstatus == 2 or player.connectstatus == 1) and player.invitestatus == 2 ) then
								d("Accepting Party invitation from "..gw2_multibot_manager.leadername)
								SendChatMsg(GW2.CHATCHANNEL.Say,"/join "..gw2_multibot_manager.leadername)
								dPartyStatus = "Joining "..gw2_multibot_manager.leadername							
								return
							else
								dPartyStatus = "Waiting for invite"
							end
						else
							dPartyStatus = "In a Party"
						end
					end
					index, player  = next( party,index )
				end
			end
		else
			dPartyStatus = "Waiting for leadername"
		end
	end		
end

function gw2_multibot_manager.membercount()
	local count = 0
	local partylist = Settings.GW2Minion.Party
	if ( TableSize(partylist) > 0 ) then
		local index, player  = next( partylist )		
		while ( index ~= nil and player ~= nil ) do			
			if (player ~= "None" and player ~= "") then
				count = count + 1
			end
			index, player  = next( partylist,index )
		end	
	end
	return count
end

function gw2_multibot_manager.GetPlayerPartyData()	
	local partylist = ml_global_information.Player_Party
	if ( TableSize(partylist) > 0 ) then
		local index, player  = next( partylist )		
		while ( index ~= nil and player ~= nil ) do
			if (player.id == Player.id) then
				return player
			end
			index, player  = next( partylist,index )
		end	
	end
	return nil
end


--**********************************************************
-- HandleMultiBotMessages
--**********************************************************
function HandleMultiBotMessages( event, message, channel )	
--d("MBM:" .. tostring(message) .. " chan: " .. tostring(channel))
		
	if (channel == MBSGroup ) then
		
		-- Set role of this client, multibotserver sends this info when a bot enters/leaves the channel
		if ( message:find('[[Leader]]') ~= nil) then
			Player:SetRole(1)
			gRole = "Party Leader"
			if ( gBotMode == GetString("followmode") ) then
				
				-- Resume where the old leader stopped, incase we were Minion before and are now the new leader
				if ( gw2_multibot_manager.leaderBotMode ~= nil ) then 
					gBotMode = gw2_multibot_manager.leaderBotMode
				else
					gBotMode = GetString("grindMode")
				end				
				-- Set TaskManager
				if ( gw2_multibot_manager.leaderTMProfile ~= nil and gw2_multibot_manager.leaderTMTaskID ~= nil) then					
					ml_task_mgr.profile = ml_task_mgr.InitProfile(gw2_multibot_manager.leaderTMProfile)
					ml_task_mgr.SetNextTaskByID(gw2_multibot_manager.leaderTMTaskID)
				end
				
				ml_global_information.Stop() -- this resets the bot n creates a new queue with the task
			end
			
		elseif ( message:find('[[Minion]]') ~= nil) then			
			Player:SetRole(0)
			gRole = "Party Member"
			gw2_multibot_manager.leadername = ""
			gw2_multibot_manager.leaderserverID = 0
			gw2_multibot_manager.leaderWPID = 0
			gw2_multibot_manager.leaderMapID = nil
			gw2_multibot_manager.leaderBotMode = nil
			gw2_multibot_manager.leaderTMProfile = nil
			gw2_multibot_manager.leaderTMTaskID = nil			
			gBotMode = GetString("followmode")			
			ml_global_information.Stop()
			gw2minion.SwitchMode(v)
		end	
		
		if ( gw2_multibot_manager.multiBotIsConnected ) then
			local delimiter = message:find(';')
			if (delimiter ~= nil and delimiter ~= 0) then
				
				local msgID = message:sub(0,delimiter-1)
				local msg = message:sub(delimiter+1)
				if (tonumber(msgID) ~= nil and msg ~= nil ) then
				--d("msgID:" .. msgID)
				--d("msg:" .. msg)
					
					local currentRole = Player:GetRole()
					
					-- Leader sends Minion LeaderName	
					if ( tonumber(msgID) == 1 and msg ~= "" and currentRole == 0) then
                        gw2_multibot_manager.leadername = msg
					
					-- Leader sends Minion his ServerID
					elseif ( tonumber(msgID) == 2 and msg ~= "" and tonumber(msg) and currentRole == 0) then
                        gw2_multibot_manager.leaderserverID = tonumber(msg)
					
					-- Leader sends Minion his Closest Waypoint ID
					elseif ( tonumber(msgID) == 3 and msg ~= "" and tonumber(msg) and currentRole == 0) then
                        gw2_multibot_manager.leaderWPID = tonumber(msg)
					
					-- Leader sends Minions his TargetID to attack
					elseif ( tonumber(msgID) == 4 and tonumber(msg) ~= nil and msg ~= "" and currentRole == 0) then
						mc_followbot.KilltargetID = msg
					
					-- Leader sends Minions his current MapID
					elseif ( tonumber(msgID) == 5 and msg ~= "" and tonumber(msg) and currentRole == 0) then
                        gw2_multibot_manager.leaderMapID = tonumber(msg)
						
					-- Leader sends Minions his current BotMode
					elseif ( tonumber(msgID) == 6 and msg ~= "" and currentRole == 0) then
                        gw2_multibot_manager.leaderBotMode = msg

					-- Leader sends Minions his current TMProfile
					elseif ( tonumber(msgID) == 7 and msg ~= "" and currentRole == 0) then
                        gw2_multibot_manager.leaderTMProfile = msg

					-- Leader sends Minions his current TM TaskID
					elseif ( tonumber(msgID) == 8 and msg ~= "" and tonumber(msg) and currentRole == 0) then
                        gw2_multibot_manager.leaderTMTaskID = tonumber(msg)						
					end
				end
			end
		end
	end
end


RegisterEventHandler("MultiBotManager.toggle", gw2_multibot_manager.ToggleMenu)
RegisterEventHandler("Module.Initalize",gw2_multibot_manager.ModuleInit)
RegisterEventHandler("MULTIBOT.Message",HandleMultiBotMessages)
