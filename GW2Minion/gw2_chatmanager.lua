gw2_chatmanager = {}
gw2_chatmanager.MainWindow = { Name=GetString("checkChat"), x=50, y=50, width=220, height=200 }
gw2_chatmanager.lastTick = 0

function gw2_chatmanager.ModuleInit()
	if ( Settings.GW2Minion.gChatAlert == nil ) then
		Settings.GW2Minion.gChatAlert = {
			Whisper = "0",
			Say = "0",
			Info = "0",
			God = "0",
			Guild = "0",
			Party = "0",
		}
	end
	
	cw = WindowManager:NewWindow(gw2_chatmanager.MainWindow.Name,gw2_chatmanager.MainWindow.x,gw2_chatmanager.MainWindow.y,gw2_chatmanager.MainWindow.width,gw2_chatmanager.MainWindow.height)
	if ( cw ) then
		cw:NewCheckBox("Whisper","gChatAlertWhisper",GetString("settings"))
		cw:NewCheckBox("Say","gChatAlertSay",GetString("settings"))
		cw:NewCheckBox("Party","gChatAlertParty",GetString("settings"))
		cw:NewCheckBox("Guild","gChatAlertGuild",GetString("settings"))		
		cw:NewCheckBox("Info","gChatAlertInfo",GetString("settings"))
		cw:NewCheckBox("God","gChatAlertGod",GetString("settings"))
		cw:UnFold(GetString("settings") )
		cw:Hide()
	end
	
	gChatAlertWhisper = Settings.GW2Minion.gChatAlert.Whisper
	gChatAlertSay = Settings.GW2Minion.gChatAlert.Say
	gChatAlertInfo = Settings.GW2Minion.gChatAlert.Info
	gChatAlertGod = Settings.GW2Minion.gChatAlert.God
	gChatAlertGuild = Settings.GW2Minion.gChatAlert.Guild
	gChatAlertParty = Settings.GW2Minion.gChatAlert.Party
	gw2minion.MainWindow.ChildWindows[gw2_chatmanager.MainWindow.Name] = gw2_chatmanager.MainWindow.Name
end

function gw2_chatmanager.GUIVarUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		if ( k == "gChatAlertWhisper") then Settings.GW2Minion.gChatAlert.Whisper = v Settings.GW2Minion.gChatAlert = Settings.GW2Minion.gChatAlert
			elseif ( k == "gChatAlertSay") then Settings.GW2Minion.gChatAlert.Say = v Settings.GW2Minion.gChatAlert = Settings.GW2Minion.gChatAlert
			elseif ( k == "gChatAlertInfo") then Settings.GW2Minion.gChatAlert.Info = v Settings.GW2Minion.gChatAlert = Settings.GW2Minion.gChatAlert
			elseif ( k == "gChatAlertGod") then Settings.GW2Minion.gChatAlert.God = v Settings.GW2Minion.gChatAlert = Settings.GW2Minion.gChatAlert
			elseif ( k == "gChatAlertGuild") then Settings.GW2Minion.gChatAlert.Guild = v Settings.GW2Minion.gChatAlert = Settings.GW2Minion.gChatAlert
			elseif ( k == "gChatAlertParty") then Settings.GW2Minion.gChatAlert.Party = v Settings.GW2Minion.gChatAlert = Settings.GW2Minion.gChatAlert
		end
	end
end

function gw2_chatmanager.ToggleMenu()
	local mainWindow = WindowManager:GetWindow(gw2_chatmanager.MainWindow.Name)
	if (mainWindow) then		
		if ( mainWindow.visible ) then			
			mainWindow:Hide()
		else
			local wnd = WindowManager:GetWindow(gw2minion.MainWindow.Name)
			if ( wnd ) then
				mainWindow:SetPos(wnd.x+wnd.width,wnd.y)
				mainWindow:Show()
			end
		end
	end
end

-- parses the chat in order to play a warning signal when a whisper etc comes in
gw2_chatmanager.whispers = {}
function gw2_chatmanager.ChatMonitor( tickcount )
	if ( tickcount - gw2_chatmanager.lastTick > 5000 ) then
		gw2_chatmanager.lastTick = tickcount
		if ( gChatAlertWhisper == "1" ) then
			local NewWhisper = GetChatMsg(GW2.CHATCHANNEL.Whisper, 100)
			if ( TableSize(NewWhisper) > 0 ) then
				if ( gw2_chatmanager.whispers[GW2.CHATCHANNEL.Whisper] ~= nil and gw2_chatmanager.whispers[GW2.CHATCHANNEL.Whisper] ~= NewWhisper[1]) then
					PlaySound(ml_global_information.Path.."\\MinionFiles\\Sounds\\Alarm1.wav")
				end
				gw2_chatmanager.whispers[GW2.CHATCHANNEL.Whisper] = NewWhisper[1]
			end
		end
		if ( gChatAlertSay == "1" ) then
			local NewWhisper = GetChatMsg(GW2.CHATCHANNEL.Say, 100)
			if ( TableSize(NewWhisper) > 0 ) then
				if ( gw2_chatmanager.whispers[GW2.CHATCHANNEL.Say] ~= nil and gw2_chatmanager.whispers[GW2.CHATCHANNEL.Say] ~= NewWhisper[1]) then
					PlaySound(ml_global_information.Path.."\\MinionFiles\\Sounds\\Alarm1.wav")
				end
				gw2_chatmanager.whispers[GW2.CHATCHANNEL.Say] = NewWhisper[1]
			end
		end
		if ( gChatAlertInfo == "1" ) then
			local NewWhisper = GetChatMsg(GW2.CHATCHANNEL.Info, 100)
			if ( TableSize(NewWhisper) > 0 ) then
				if ( gw2_chatmanager.whispers[GW2.CHATCHANNEL.Info] ~= nil and gw2_chatmanager.whispers[GW2.CHATCHANNEL.Info] ~= NewWhisper[1]) then
					PlaySound(ml_global_information.Path.."\\MinionFiles\\Sounds\\Alarm1.wav")
					d("Info Alert!")
				end
				gw2_chatmanager.whispers[GW2.CHATCHANNEL.Info] = NewWhisper[1]
			end
		end	
		if ( gChatAlertGod == "1" ) then
			local NewWhisper = GetChatMsg(GW2.CHATCHANNEL.God, 100)
			if ( TableSize(NewWhisper) > 0 ) then
				if ( gw2_chatmanager.whispers[GW2.CHATCHANNEL.God] ~= nil and gw2_chatmanager.whispers[GW2.CHATCHANNEL.God] ~= NewWhisper[1]) then
					PlaySound(ml_global_information.Path.."\\MinionFiles\\Sounds\\Alarm1.wav")
					d("God Alert!")
				end
				gw2_chatmanager.whispers[GW2.CHATCHANNEL.God] = NewWhisper[1]
			end
		end	
		if ( gChatAlertGuild == "1" ) then
			local NewWhisper = GetChatMsg(GW2.CHATCHANNEL.Guild, 100)
			if ( TableSize(NewWhisper) > 0 ) then
				if ( gw2_chatmanager.whispers[GW2.CHATCHANNEL.Guild] ~= nil and gw2_chatmanager.whispers[GW2.CHATCHANNEL.Guild] ~= NewWhisper[1]) then
					PlaySound(ml_global_information.Path.."\\MinionFiles\\Sounds\\Alarm1.wav")					
				end
				gw2_chatmanager.whispers[GW2.CHATCHANNEL.Guild] = NewWhisper[1]
			end
		end	
		if( gChatAlertParty == "1" ) then
			local NewWhisper = GetChatMsg(GW2.CHATCHANNEL.Party, 100)
			if ( TableSize(NewWhisper) > 0 ) then
				if ( gw2_chatmanager.whispers[GW2.CHATCHANNEL.Party] ~= nil and gw2_chatmanager.whispers[GW2.CHATCHANNEL.Party] ~= NewWhisper[1]) then
					PlaySound(ml_global_information.Path.."\\MinionFiles\\Sounds\\Alarm1.wav")
				end
				gw2_chatmanager.whispers[GW2.CHATCHANNEL.Party] = NewWhisper[1]
			end
		end	
	end
end

RegisterEventHandler("GUI.Update",gw2_chatmanager.GUIVarUpdate)
RegisterEventHandler("Module.Initalize",gw2_chatmanager.ModuleInit)

