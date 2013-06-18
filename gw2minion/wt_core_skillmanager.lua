﻿-- Skillmanager for adv. skill customization
SkillMgr = { }
SkillMgr.version = "v0.4";
SkillMgr.profilepath = tostring(GetStartupPath()) .. [[\LuaMods\gw2minion\SkillManagerProfiles\]];
SkillMgr.mainwindow = { name = strings[gCurrentLanguage].skillManager, x = 450, y = 50, w = 350, h = 350}
SkillMgr.RecordSkillTmr = 0
SkillMgr.SkillMgrTmr = 0
SkillMgr.DoActionTmr = 0
SkillMgr.SwapTmr = 0
SkillMgr.SwapRTmr = 0
SkillMgr.SwapWeaponTable = {}
SkillMgr.UIRefreshTmr = 0
SkillMgr.UIneedsRefresh = false
SkillMgr.visible = false
SkillMgr.SkillSet = {}
SkillMgr.cskills = {}
SkillMgr.EngineerKits = {
	[38304] = "BombKit",
	[38472] = "FlameThrower",
	[38289] = "GrenadeKit",
	[38448] = "ToolKit",
	[38486] = "ElixirGun",
	--[240025] = "Medkit",
};
SkillMgr.ElementarAttunements = {
	["Fire"] = 12,
	["Water"] = 13,
	["Ait"] = 14,
	["Earth"] = 15,
};

SkillMgr.BuffEnum = {
		-- All Hail to Havoc :D
		--conditions 
		["Bleeding"] = 736,
		["Blind"] = 720,
		["Burning"] = 737,
		["Chilled"] = 722,
		["Confusion"] = 861,
		["Crippled"] = 721,
		["Fear"] = 791,
		["Immobilized"] = 727,
		["Vulnerability"] = 738,
		["Weakness"] = 742,
		["Poison"] = 723,
		--boons
		["Aegis"] = 743,
		["Fury"] = 725,
		["Might"] = 740,
		["Protection"] = 717,
		["Regeneration"] = 718,
		["Retaliation"] = 873,
		["Stability"] = 1122,
		["Swiftness"] = 719,
		["Vigor"] = 726,
		--effects
		["Blur"] = 10335,
		["Determined"] = 11641,
		["Distortion"] = 10371,
		["Elixir S"] = 5863,
		["Frenzy"] = 14456,
		["Haste"] = 13067,
		["Invulnerability"] = 848,
		["Mist Form Buff 1"] = 3686,
		["Mist Form Buff 2"] = 5543,
		["Petrified"] = 15090,
		["Quickening Zephyr"] = 12551,
		["Quickness"] = 1187,
		["Renewed Focus"] = 9255,
		["Revealed"] = 890,
		["Stealth"] = 13017,
		["Stun"] = 872,
		["Svanir Ice Block"] = 9636,
	};

function SkillMgr.ModuleInit() 	
	if (Settings.GW2MINION.gSMactive == nil) then
		Settings.GW2MINION.gSMactive = "0"
	end
	if (Settings.GW2MINION.gSMlastprofile == nil) then
		Settings.GW2MINION.gSMlastprofile = "None"
	end
	if (Settings.GW2MINION.gSMRecactive == nil) then
		Settings.GW2MINION.gSMRecactive = "0"
	end
	if (Settings.GW2MINION.gSMmode == nil) then
		Settings.GW2MINION.gSMmode = "Attack Everything"
	end
	if (Settings.GW2MINION.gsMtargetmode == nil) then
		Settings.GW2MINION.gsMtargetmode = "No Autotarget"
	end
	if (Settings.GW2MINION.gSMSwapA == nil) then
		Settings.GW2MINION.gSMSwapA = "1"
	end
	if (Settings.GW2MINION.gSMSwapR == nil) then
		Settings.GW2MINION.gSMSwapR = "1"
	end
	if (Settings.GW2MINION.gSMSwapCD == nil) then
		Settings.GW2MINION.gSMSwapCD = "1"
	end
	if (Settings.GW2MINION.gSMSwapRange == nil) then
		Settings.GW2MINION.gSMSwapRange = "1"
	end
	if (Settings.GW2MINION.gSMPrioKit == nil) then
		Settings.GW2MINION.gSMPrioKit = "None"
	end
	if (Settings.GW2MINION.gSMPrioAtt == nil) then
		Settings.GW2MINION.gSMPrioAtt = "Fire"
	end	
	
	local wnd = GUI_GetWindowInfo("GW2Minion")
	GUI_NewWindow(SkillMgr.mainwindow.name,SkillMgr.mainwindow.x,SkillMgr.mainwindow.y,SkillMgr.mainwindow.w,SkillMgr.mainwindow.h)
	GUI_NewCheckbox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].activated,"gSMactive",strings[gCurrentLanguage].generalSettings)
	GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].profile,"gSMprofile",strings[gCurrentLanguage].generalSettings,"");
	GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].sMtargetmode,"gsMtargetmode",strings[gCurrentLanguage].generalSettings,"No Autotarget,Autotarget Weakest,Autotarget Closest,Autotarget Biggest Crowd");
	GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].sMmode,"gSMmode",strings[gCurrentLanguage].generalSettings,"Attack Everything,Attack Players Only");
	
	GUI_NewCheckbox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].SwapA,"gSMSwapA",strings[gCurrentLanguage].AdvancedSettings)
	GUI_NewCheckbox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].SwapR,"gSMSwapR",strings[gCurrentLanguage].AdvancedSettings)
	GUI_NewCheckbox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].SwapCD,"gSMSwapCD",strings[gCurrentLanguage].AdvancedSettings)
	GUI_NewCheckbox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].SwapRange,"gSMSwapRange",strings[gCurrentLanguage].AdvancedSettings)
	
	if ( wt_global_information.Currentprofession ~= nil ) then
		if (wt_global_information.Currentprofession.professionID == 3) then
		-- Engineer
		GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].PriorizeKit,"gSMPrioKit",strings[gCurrentLanguage].AdvancedSettings,"None,BombKit,FlameThrower,GrenadeKit,ToolKit,ElixirGun")
		
		elseif( wt_global_information.Currentprofession.professionID == 6 ) then
			-- Elementalist
			GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].PriorizeAttunement,"gSMPrioAtt",strings[gCurrentLanguage].AdvancedSettings,"Fire,Water,Air,Earth")
		end
	end

	--GUI_UnFoldGroup(SkillMgr.mainwindow.name,strings[gCurrentLanguage].generalSettings) crashes still
	
	GUI_NewButton(SkillMgr.mainwindow.name,strings[gCurrentLanguage].saveProfile,"SMSaveEvent",strings[gCurrentLanguage].skillEditor)
	GUI_NewButton(SkillMgr.mainwindow.name,strings[gCurrentLanguage].refreshProfiles,"SMRefreshEvent",strings[gCurrentLanguage].skillEditor)
	GUI_NewButton(SkillMgr.mainwindow.name,strings[gCurrentLanguage].deleteProfile,"SMDeleteEvent",strings[gCurrentLanguage].skillEditor)	
	GUI_NewField(SkillMgr.mainwindow.name,strings[gCurrentLanguage].newProfileName,"gSMnewname",strings[gCurrentLanguage].skillEditor)
	GUI_NewButton(SkillMgr.mainwindow.name,strings[gCurrentLanguage].newProfile,"newSMProfileEvent",strings[gCurrentLanguage].skillEditor)
	GUI_NewCheckbox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].autoetectSkills,"gSMRecactive",strings[gCurrentLanguage].skillEditor)
	GUI_NewButton(SkillMgr.mainwindow.name,strings[gCurrentLanguage].refreshSkillList,"refreshSMSkillListEvent",strings[gCurrentLanguage].skillEditor)
	
	gSMmode = Settings.GW2MINION.gSMmode
	gsMtargetmode = Settings.GW2MINION.gsMtargetmode
	gSMSwapA = Settings.GW2MINION.gSMSwapA
	gSMSwapR = Settings.GW2MINION.gSMSwapR
	gSMSwapCD = Settings.GW2MINION.gSMSwapCD
	gSMSwapRange = Settings.GW2MINION.gSMSwapRange
	gSMPrioKit = Settings.GW2MINION.gSMPrioKit
	gSMPrioAtt = Settings.GW2MINION.gSMPrioAtt
    gSMactive = Settings.GW2MINION.gSMactive
	
	SkillMgr.UpdateProfiles()
	
	SkillMgr.UpdateCurrentProfileData()
	
	RegisterEventHandler("SMSaveEvent",SkillMgr.SaveProfile)
	RegisterEventHandler("SMRefreshEvent",SkillMgr.UpdateProfiles)
	RegisterEventHandler("SMDeleteEvent",SkillMgr.DeleteCurrentProfile)
	RegisterEventHandler("newSMProfileEvent",SkillMgr.CreateNewProfile)
	RegisterEventHandler("refreshSMSkillListEvent",SkillMgr.RefreshCurrentSkillList)
    
end

function SkillMgr.GUIVarUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		--d(tostring(k).." = "..tostring(v))
		if ( k == "gSMactive" or k == "gSMmode" or k == "gsMtargetmode" or k == "gSMSwapA" or k == "gSMSwapR" or k == "gSMSwapCD" or k == "gSMPrioKit") then			
			Settings.GW2MINION[tostring(k)] = v
		elseif ( k == "gSMprofile" ) then	
			gSMactive = "0"
			gSMRecactive = "0"
			SkillMgr.RefreshCurrentSkillList()
			Settings.GW2MINION.gSMlastprofile = tostring(v)
		end
	end
	GUI_RefreshWindow(SkillMgr.mainwindow.name)
end

function SkillMgr.OnUpdate( event, tick )
	if ( gSMRecactive == "1" ) then
		if (SkillMgr.RecordSkillTmr == 0 ) then
			SkillMgr.RecordSkillTmr = tick
		else
			if ( tick - SkillMgr.RecordSkillTmr > 60000 or gSMprofile == nil or tostring(gSMprofile) == "None" or tostring(gSMprofile) == "") then -- max record 60seconds, to compensate smart users who leave it on -.-
				SkillMgr.RecordSkillTmr = 0
				gSMRecactive = "0"
			elseif ( tick - SkillMgr.SkillMgrTmr > 500 ) then
				SkillMgr.SkillMgrTmr = tick
				SkillMgr.CheckForNewSkills()
			end
		end	
	end
	if ( gSMactive == "1" ) then		
		if	( tick - SkillMgr.DoActionTmr > 250 ) then
			SkillMgr.DoActionTmr = tick
			if ( Player.healthstate == GW2.HEALTHSTATE.Defeated ) then return end
			SkillMgr.SelectTarget()
			SkillMgr.SwapWeaponCheck("Pulse")
			SkillMgr.DoAction()
		end
	end
	if ( SkillMgr.UIneedsRefresh ) then	-- Needed because the UI cant handle clearing + rebuilding of all stuff in the same frame
		if ( SkillMgr.UIRefreshTmr == 0 ) then
			SkillMgr.UIRefreshTmr = tick
		elseif( tick - SkillMgr.UIRefreshTmr > 250 ) then
			--d("Refreshing SkillList...")
			SkillMgr.UIRefreshTmr = 0			
			SkillMgr.UpdateCurrentProfileData()
			SkillMgr.UIneedsRefresh = false
		end
	end
end

--**** UI FUNCTIONS ****

function SkillMgr.CreateNewProfile()
	if ( gSMnewname ~= nil and tostring(gSMnewname) ~= "" and tostring(gSMnewname) ~= "None") then
		-- Delete existing Skills
		SkillMgr.ClearCurrentSkills()
		-- Make sure Profile doesnt exist		
		local profile = io.open(SkillMgr.profilepath ..tostring(gSMnewname)..".lua")
		if ( profile ~= nil ) then				
			wt_error("Profile with that Name exists already...")
		else
			-- Setup everything for new mesh
			gSMprofile_listitems = gSMprofile_listitems..","..tostring(gSMnewname)
			gSMprofile = tostring(gSMnewname)	
			-- Create new profile-file
			local file = io.open(SkillMgr.profilepath..tostring(gSMnewname)..".lua", "w")
			if file then
				wt_debug("Creating Profile file..")	
								
				file:flush()
				file:close()
			else
				wt_debug("Error creating new Profile file..")					
			end
		end			
	end
end

function SkillMgr.UpdateProfiles()
	-- Grab all Profiles and enlist them in the dropdown field
	local profiles = "None"
	local found = "None"
	local profilelist = io.popen("dir /b ".. SkillMgr.profilepath .."*.lua")
	if ( profilelist ~= nil ) then
		for profile in profilelist:lines() do
			profile = string.gsub(profile, ".lua", "")		
			profiles = profiles..","..tostring(profile)			
			if ( tostring(Settings.GW2MINION.gSMlastprofile) ~= nil and tostring(Settings.GW2MINION.gSMlastprofile) == tostring(profile) ) then
				d("Last Profile found : "..tostring(profile))
				found = profile
			end
		end
		profilelist:close()
	end
	wt_debug("ALL PROFILES: "..tostring(profiles))
	gSMprofile_listitems = profiles
	gSMprofile = tostring(found)
end

function SkillMgr.SaveProfile()
	-- Save current Profiledata into the Profile-file
	if (gSMprofile ~= nil and tostring(gSMprofile) ~= "None" and tostring(gSMprofile) ~= "") then
		local profile = io.open(SkillMgr.profilepath ..tostring(gSMprofile)..".lua", "w")
		if ( profile ~= nil ) then	
			d("Saving Profile Data into File: "..tostring(gSMprofile))
			
			local skID,skill = next (SkillMgr.SkillSet)
			while skID and skill do
				--d("Saving SkillID :"..tostring(skID))				
				if (_G["SKM_NAME_"..tostring(skID)] ) then profile:write("SKM_NAME_"..tostring(skID).."="..tostring(_G["SKM_NAME_"..tostring(skID)]).."\n") end
				if (_G["SKM_ID_"..tostring(skID)] ) then profile:write("SKM_ID_"..tostring(skID).."="..tostring(_G["SKM_ID_"..tostring(skID)]).."\n") end				
				if (_G["SKM_ON_"..tostring(skID)] ) then profile:write("SKM_ON_"..tostring(skID).."="..tostring(_G["SKM_ON_"..tostring(skID)]).."\n") end
				if (_G["SKM_Prio_"..tostring(skID)] ) then profile:write("SKM_Prio_"..tostring(skID).."="..tostring(_G["SKM_Prio_"..tostring(skID)]).."\n") end
				if (_G["SKM_LOS_"..tostring(skID)] ) then profile:write("SKM_LOS_"..tostring(skID).."="..tostring(_G["SKM_LOS_"..tostring(skID)]).."\n") end
				if (_G["SKM_MinR_"..tostring(skID)] ) then profile:write("SKM_MinR_"..tostring(skID).."="..tostring(_G["SKM_MinR_"..tostring(skID)]).."\n") end
				if (_G["SKM_MaxR_"..tostring(skID)] ) then profile:write("SKM_MaxR_"..tostring(skID).."="..tostring(_G["SKM_MaxR_"..tostring(skID)]).."\n") end
				if (_G["SKM_GT_"..tostring(skID)] ) then profile:write("SKM_GT_"..tostring(skID).."="..tostring(_G["SKM_GT_"..tostring(skID)]).."\n") end
				if (_G["SKM_TType_"..tostring(skID)] ) then profile:write("SKM_TType_"..tostring(skID).."="..tostring(_G["SKM_TType_"..tostring(skID)]).."\n") end
				if (_G["SKM_OutOfCombat_"..tostring(skID)] ) then profile:write("SKM_OutOfCombat_"..tostring(skID).."="..tostring(_G["SKM_OutOfCombat_"..tostring(skID)]).."\n") end
				
				if (_G["SKM_PMove_"..tostring(skID)] ) then profile:write("SKM_PMove_"..tostring(skID).."="..tostring(_G["SKM_PMove_"..tostring(skID)]).."\n") end
				if (_G["SKM_PHPL_"..tostring(skID)] ) then profile:write("SKM_PHPL_"..tostring(skID).."="..tostring(_G["SKM_PHPL_"..tostring(skID)]).."\n") end
				if (_G["SKM_PHPB_"..tostring(skID)] ) then profile:write("SKM_PHPB_"..tostring(skID).."="..tostring(_G["SKM_PHPB_"..tostring(skID)]).."\n") end
				if (_G["SKM_PPowL_"..tostring(skID)] ) then profile:write("SKM_PPowL_"..tostring(skID).."="..tostring(_G["SKM_PPowL_"..tostring(skID)]).."\n") end
				if (_G["SKM_PEff1_"..tostring(skID)] ) then profile:write("SKM_PEff1_"..tostring(skID).."="..tostring(_G["SKM_PEff1_"..tostring(skID)]).."\n") end
				if (_G["SKM_PEff2_"..tostring(skID)] ) then profile:write("SKM_PEff2_"..tostring(skID).."="..tostring(_G["SKM_PEff2_"..tostring(skID)]).."\n") end
				if (_G["SKM_PNEff1_"..tostring(skID)] ) then profile:write("SKM_PNEff1_"..tostring(skID).."="..tostring(_G["SKM_PNEff1_"..tostring(skID)]).."\n") end
				if (_G["SKM_PNEff2_"..tostring(skID)] ) then profile:write("SKM_PNEff2_"..tostring(skID).."="..tostring(_G["SKM_PNEff2_"..tostring(skID)]).."\n") end
				if (_G["SKM_PPowB_"..tostring(skID)] ) then profile:write("SKM_PPowB_"..tostring(skID).."="..tostring(_G["SKM_PPowB_"..tostring(skID)]).."\n") end
				
				if (_G["SKM_TMove_"..tostring(skID)] ) then profile:write("SKM_TMove_"..tostring(skID).."="..tostring(_G["SKM_TMove_"..tostring(skID)]).."\n") end
				if (_G["SKM_THPL_"..tostring(skID)] ) then profile:write("SKM_THPL_"..tostring(skID).."="..tostring(_G["SKM_THPL_"..tostring(skID)]).."\n") end
				if (_G["SKM_THPB_"..tostring(skID)] ) then profile:write("SKM_THPB_"..tostring(skID).."="..tostring(_G["SKM_THPB_"..tostring(skID)]).."\n") end
				if (_G["SKM_TECount_"..tostring(skID)] ) then profile:write("SKM_TECount_"..tostring(skID).."="..tostring(_G["SKM_TECount_"..tostring(skID)]).."\n") end
				if (_G["SKM_TERange_"..tostring(skID)] ) then profile:write("SKM_TERange_"..tostring(skID).."="..tostring(_G["SKM_TERange_"..tostring(skID)]).."\n") end
				if (_G["SKM_TACount_"..tostring(skID)] ) then profile:write("SKM_TACount_"..tostring(skID).."="..tostring(_G["SKM_TACount_"..tostring(skID)]).."\n") end
				if (_G["SKM_TARange_"..tostring(skID)] ) then profile:write("SKM_TARange_"..tostring(skID).."="..tostring(_G["SKM_TARange_"..tostring(skID)]).."\n") end
				if (_G["SKM_TEff1_"..tostring(skID)] ) then profile:write("SKM_TEff1_"..tostring(skID).."="..tostring(_G["SKM_TEff1_"..tostring(skID)]).."\n") end
				if (_G["SKM_TEff2_"..tostring(skID)] ) then profile:write("SKM_TEff2_"..tostring(skID).."="..tostring(_G["SKM_TEff2_"..tostring(skID)]).."\n") end
				if (_G["SKM_TNEff1_"..tostring(skID)] ) then profile:write("SKM_TNEff1_"..tostring(skID).."="..tostring(_G["SKM_TNEff1_"..tostring(skID)]).."\n") end
				if (_G["SKM_TNEff2_"..tostring(skID)] ) then profile:write("SKM_TNEff2_"..tostring(skID).."="..tostring(_G["SKM_TNEff2_"..tostring(skID)]).."\n") end
				
				profile:write("SKM_END_"..tostring(skID).."="..tostring(0).."\n")
				skID,skill = next (SkillMgr.SkillSet,skID)
			end			
			
			profile:flush()
			profile:close()
		else
			d("Error saving Profile: File not found!!")
		end
	end	
end

function SkillMgr.DeleteCurrentProfile()	
	-- Delete the currently selected Profile - file from the HDD
	if (gSMprofile ~= nil and tostring(gSMprofile) ~= "None" and tostring(gSMprofile) ~= "") then
		local profile = io.open(SkillMgr.profilepath ..tostring(gSMprofile)..".lua")
		if ( profile ~= nil ) then	
			d("Deleting current Profile: "..tostring(gSMprofile))
			profile:flush()
			profile:close()
			os.remove(SkillMgr.profilepath ..tostring(gSMprofile)..".lua")	
			-- updating dropdown list
			SkillMgr.UpdateProfiles()			
		end
	end	
end

function SkillMgr.UpdateCurrentProfileData()
	if ( gSMprofile ~= nil and tostring(gSMprofile) ~= "" and tostring(gSMprofile) ~= "None" ) then --and (tostring(gSMprofile) ~= tostring(Settings.GW2MINION.gSMlastprofile) or TableSize(SkillMgr.SkillSet) == 0)) then
		local profile = io.open(SkillMgr.profilepath..tostring(gSMprofile)..".lua", "r")
		if ( profile ) then	
			local unsortedSkillList = {}			
			local newskill = {}
			for line in profile:lines() do				
				local _, key, skillID, value = string.match(tostring(line), "(%w+)_(%w+)_(%d+)=([%w%s]*)")
				--d("key: "..tostring(key).." skillID:"..tostring(skillID) .." value:"..tostring(value))
				if ( key and skillID and value ) then
					if ( key == "END" ) then
						--d("Adding Skill :"..tostring(newskill.name).."Prio:"..tostring(newskill.Prio))
						table.insert(unsortedSkillList,tonumber(newskill.Prio),newskill)						
						newskill = {}
					elseif ( key == "ID" )then newskill.contentID = tonumber(value)
					elseif ( key == "NAME" )then newskill.name = tostring(value)
					elseif ( key == "ON" )then newskill.ON = tostring(value)
					elseif ( key == "Prio" )then newskill.Prio = tonumber(value)
					elseif ( key == "LOS" )then newskill.los = tonumber(value)
					elseif ( key == "MinR" )then newskill.minRange = tonumber(value)
					elseif ( key == "MaxR" )then newskill.maxRange = tonumber(value)
					elseif ( key == "GT" )then newskill.isGroundTargeted = tostring(value)
					elseif ( key == "TType" )then newskill.TType = tostring(value)
					elseif ( key == "OutOfCombat" )then newskill.OutOfCombat = tostring(value)
					elseif ( key == "PMove" )then newskill.PMove = tostring(value)
					elseif ( key == "PHPL" )then newskill.PHPL = tonumber(value)
					elseif ( key == "PHPB" )then newskill.PHPB = tonumber(value)
					elseif ( key == "PPowL" )then newskill.PPowL = tonumber(value)
					elseif ( key == "PEff1" )then newskill.PEff1 = tostring(value)
					elseif ( key == "PEff2" )then newskill.PEff2 = tostring(value)
					elseif ( key == "PNEff1" )then newskill.PNEff1 = tostring(value)
					elseif ( key == "PNEff2" )then newskill.PNEff2 = tostring(value)
					
					elseif ( key == "PPowB" )then newskill.PPowB = tonumber(value)
					elseif ( key == "TMove" )then newskill.TMove = tostring(value)
					elseif ( key == "THPL" )then newskill.THPL = tonumber(value)
					elseif ( key == "THPB" )then newskill.THPB = tonumber(value)
					
					elseif ( key == "TECount" )then newskill.TECount = tonumber(value)
					elseif ( key == "TERange" )then newskill.TERange = tonumber(value)
					elseif ( key == "TACount" )then newskill.TACount = tonumber(value)
					elseif ( key == "TARange" )then newskill.TARange = tonumber(value)
					elseif ( key == "TEff1" )then newskill.TEff1 = tostring(value)
					elseif ( key == "TEff2" )then newskill.TEff2 = tostring(value)
					elseif ( key == "TNEff1" )then newskill.TNEff1 = tostring(value)
					elseif ( key == "TNEff2" )then newskill.TNEff2 = tostring(value)
					
					end
				else
					d("Error loading inputline: Key: "..tostring(key).." skillID:"..tostring(skillID) .." value:"..tostring(value))
				end			
			end
			profile:flush()
			profile:close()
			
			-- Create UI Fields
			local sortedSkillList = {}
			if ( TableSize(unsortedSkillList) > 0 ) then
				local i,skill = next (unsortedSkillList)
				while i and skill do
					sortedSkillList[#sortedSkillList+1] = skill
					i,skill = next (unsortedSkillList,i)
				end
				table.sort(sortedSkillList, function(a,b) return a.Prio < b.Prio end )				

				for i = 1,TableSize(sortedSkillList),1 do					
					if (sortedSkillList[i] ~= nil ) then					
						SkillMgr.CreateNewSkillEntry(sortedSkillList[i])
					end
				end
			end
		else
			d("Error: Can't read SkillProfile: "..tostring(gSMprofile))
		end
	else
		d("No new SkillProfile selected!")		
	end
end

function SkillMgr.RefreshCurrentSkillList()
	SkillMgr.ClearCurrentSkills()
	SkillMgr.UIneedsRefresh = true
	--d("Clearing SkillList...")
end

function SkillMgr.CheckForNewSkills()
	for i = 1, 16, 1 do
		local skill = Player:GetSpellInfo(GW2.SKILLBARSLOT["Slot_" .. i])
		if ( skill ~= nil ) then			
			if ( SkillMgr.SkillSet[skill.contentID] == nil ) then
				SkillMgr.CreateNewSkillEntry(skill)
			end			
		end
	end
end

function SkillMgr.CreateNewSkillEntry(skill)	
	if (skill ~= nil ) then
		local skname
		if ( tonumber(skill.Prio) ~= nil and SkillMgr.CheckIfPriorityExists(skill.Prio) ) then
			skname = "PRIORITY CONFLICT!!: "..tostring((skill.Prio or TableSize(SkillMgr.SkillSet)*100))..": "..tostring(skill.name)
		else
			skname = "Priority: "..tostring((skill.Prio or TableSize(SkillMgr.SkillSet)*100))..": "..tostring(skill.name)
		end
		local skID = skill.contentID
		if ( tostring(skill.name) ~= "" and tonumber(skID) ~= nil) then			
			
			GUI_NewField(SkillMgr.mainwindow.name,"ID","SKM_ID_"..tostring(skID),tostring(skname))
			_G["SKM_ID_"..tostring(skID)] = skID
			
			-- NAME,
			--GUI_NewCheckbox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].enabled,"SKM_NAME_"..tostring(skID),tostring(skname))
			_G["SKM_NAME_"..tostring(skID)] = tostring(skill.name)
			
			-- ENABLED
			local skON = skill.ON or "1"
			GUI_NewCheckbox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].enabled,"SKM_ON_"..tostring(skID),tostring(skname))
			_G["SKM_ON_"..tostring(skID)] = tostring(skON)
			
			-- PRIORITY
			local skPrio = skill.Prio or TableSize(SkillMgr.SkillSet)*100
			GUI_NewField(SkillMgr.mainwindow.name,strings[gCurrentLanguage].priority,"SKM_Prio_"..tostring(skID),tostring(skname))
			_G["SKM_Prio_"..tostring(skID)] = skPrio
			
			-- REQUIRES LOS
			local skLOS = skill.los or "Yes"
			GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].los,"SKM_LOS_"..tostring(skID),tostring(skname),"Yes,No");
			_G["SKM_LOS_"..tostring(skID)] = tostring(skLOS)
			
			-- MINRANGE
			local skMinR = skill.minRange
			GUI_NewField(SkillMgr.mainwindow.name,strings[gCurrentLanguage].minRange,"SKM_MinR_"..tostring(skID),tostring(skname))
			_G["SKM_MinR_"..tostring(skID)] = skMinR
			
			-- MAXRANGE
			local skMaxR = skill.maxRange
			GUI_NewField(SkillMgr.mainwindow.name,strings[gCurrentLanguage].maxRange,"SKM_MaxR_"..tostring(skID),tostring(skname))
			_G["SKM_MaxR_"..tostring(skID)] = skMaxR
			
			-- IS GROUND TARGETED
			local skGT = skill.isGroundTargeted
			GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].isGroundTargeted,"SKM_GT_"..tostring(skID),tostring(skname),"false,true");
			_G["SKM_GT_"..tostring(skID)] = tostring(skGT)
			
			-- TARGETTYPE
			local skTType = skill.TType or "Enemy"
			GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].targetType,"SKM_TType_"..tostring(skID),tostring(skname),"Enemy,Self");
			_G["SKM_TType_"..tostring(skID)] = tostring(skTType)
			
			-- USEOUTOFCOMBAT
			local skOutOfCombat = skill.OutOfCombat or "No"
			GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].useOutOfCombat,"SKM_OutOfCombat_"..tostring(skID),tostring(skname),"No,Yes,Either");
			_G["SKM_OutOfCombat_"..tostring(skID)] = tostring(skOutOfCombat)
			
			-- PLAYER MOVING
			local skPMove = skill.PMove or "Either"
			GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].playerMoving,"SKM_PMove_"..tostring(skID),tostring(skname),"Either,Yes,No");
			_G["SKM_PMove_"..tostring(skID)] = tostring(skPMove)
			
			-- PLAYER >HEALTH PERCENT
			local skPHPLarger = skill.PHPL or 0
			GUI_NewField(SkillMgr.mainwindow.name,strings[gCurrentLanguage].playerHPGT,"SKM_PHPL_"..tostring(skID),tostring(skname));
			_G["SKM_PHPL_"..tostring(skID)] = skPHPLarger
			
			-- PLAYER <HEALTH PERCENT
			local skPHPBelow = skill.PHPB or 0
			GUI_NewField(SkillMgr.mainwindow.name,strings[gCurrentLanguage].playerHPLT,"SKM_PHPB_"..tostring(skID),tostring(skname));
			_G["SKM_PHPB_"..tostring(skID)] = skPHPBelow
			
			-- PLAYER >POWER PERCENT
			local skPPOWLarger = skill.PPowL or 0
			GUI_NewField(SkillMgr.mainwindow.name,strings[gCurrentLanguage].playerPowerGT ,"SKM_PPowL_"..tostring(skID),tostring(skname));
			_G["SKM_PPowL_"..tostring(skID)] = skPPOWLarger
			
			-- PLAYER <POWER PERCENT
			local skPPOWBelow = skill.PPowB or 0
			GUI_NewField(SkillMgr.mainwindow.name,strings[gCurrentLanguage].playerPowerLT,"SKM_PPowB_"..tostring(skID),tostring(skname));
			_G["SKM_PPowB_"..tostring(skID)] = skPPOWBelow	
			
			-- PLAYER HAS ANY EFFECT1
			local skPEff1 = skill.PEff1 or "None"
			GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].playerHas,"SKM_PEff1_"..tostring(skID),tostring(skname),"None,Bleeding,Blind,Burning,Chilled,Confusion,Crippled,Fear,Immobilized,Vulnerability,Weakness,Poison,Aegis,Fury,Might,Protection,Regeneration,Retaliation,Stability,Swiftness,Vigor,Stealth,Stun");
			_G["SKM_PEff1_"..tostring(skID)] = tostring(skPEff1)			
			-- PLAYER HAS ANY EFFECT2
			local skPEff2 = skill.PEff2 or "None"
			GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].orPlayerHas,"SKM_PEff2_"..tostring(skID),tostring(skname),"None,Bleeding,Blind,Burning,Chilled,Confusion,Crippled,Fear,Immobilized,Vulnerability,Weakness,Poison,Aegis,Fury,Might,Protection,Regeneration,Retaliation,Stability,Swiftness,Vigor,Stealth,Stun");
			_G["SKM_PEff2_"..tostring(skID)] = tostring(skPEff2)			
			
			-- PLAYER HAS NOT EFFECT1
			local skPNEff1 = skill.PNEff1 or "None"
			GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].playerHasNot,"SKM_PNEff1_"..tostring(skID),tostring(skname),"None,Bleeding,Blind,Burning,Chilled,Confusion,Crippled,Fear,Immobilized,Vulnerability,Weakness,Poison,Aegis,Fury,Might,Protection,Regeneration,Retaliation,Stability,Swiftness,Vigor,Stealth,Stun");
			_G["SKM_PNEff1_"..tostring(skID)] = tostring(skPNEff1)			
			-- PLAYER HAS NOT EFFECT2
			local skPNEff2 = skill.PNEff2 or "None"
			GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].orPlayerHasNot ,"SKM_PNEff2_"..tostring(skID),tostring(skname),"None,Bleeding,Blind,Burning,Chilled,Confusion,Crippled,Fear,Immobilized,Vulnerability,Weakness,Poison,Aegis,Fury,Might,Protection,Regeneration,Retaliation,Stability,Swiftness,Vigor,Stealth,Stun");
			_G["SKM_PNEff2_"..tostring(skID)] = tostring(skPNEff2)	
				
			-- TARGET MOVING
			local skTMove = skill.TMove or "Either"
			GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].targetMoving,"SKM_TMove_"..tostring(skID),tostring(skname),"Either,Yes,No");
			_G["SKM_TMove_"..tostring(skID)] = tostring(skTMove)
			
			-- TARGET >HEALTH PERCENT
			local skTHPLarger = skill.THPL or 0
			GUI_NewField(SkillMgr.mainwindow.name,strings[gCurrentLanguage].targetHPGT,"SKM_THPL_"..tostring(skID),tostring(skname));
			_G["SKM_THPL_"..tostring(skID)] = skTHPLarger
			
			-- TARGET <HEALTH PERCENT
			local skTHPBelow = skill.THPB or 0
			GUI_NewField(SkillMgr.mainwindow.name,strings[gCurrentLanguage].targetHPLT,"SKM_THPB_"..tostring(skID),tostring(skname));
			_G["SKM_THPB_"..tostring(skID)] = skTHPBelow
			
			-- NEAR TARGET ENEMIES COUNT
			local skTECount = skill.TECount or 0
			GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].enemiesNearCount,"SKM_TECount_"..tostring(skID),tostring(skname),"0,1,2,3,4,5,6");
			_G["SKM_TECount_"..tostring(skID)] = tostring(skTECount)
			
			-- NEAR TARGET ENEMIES RANGE
			local skTERange = skill.TERange or 0
			GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].enemiesNearRange,"SKM_TERange_"..tostring(skID),tostring(skname),"0,100,150,200,250,350,500,750");
			_G["SKM_TERange_"..tostring(skID)] = tostring(skTERange)
			
			-- NEAR TARGET ALLIES COUNT
			local skTACount = skill.TACount or 0
			GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].alliesNearCount,"SKM_TACount_"..tostring(skID),tostring(skname),"0,1,2,3,4,5,6");
			_G["SKM_TACount_"..tostring(skID)] = tostring(skTACount)
			
			-- NEAR TARGET ALLIES RANGE
			local skTARange = skill.TARange or 0
			GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].alliesNearRange,"SKM_TARange_"..tostring(skID),tostring(skname),"0,100,200,300,400,500,600");
			_G["SKM_TARange_"..tostring(skID)] = tostring(skTARange)
			
			-- TARGET HAS ANY EFFECT1
			local skTEff1 = skill.TEff1 or "None"
			GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].targetHas,"SKM_TEff1_"..tostring(skID),tostring(skname),"None,Bleeding,Blind,Burning,Chilled,Confusion,Crippled,Fear,Immobilized,Vulnerability,Weakness,Poison,Aegis,Fury,Might,Protection,Regeneration,Retaliation,Stability,Swiftness,Vigor,Stealth,Stun");
			_G["SKM_TEff1_"..tostring(skID)] = tostring(skTEff1)			
			-- TARGET HAS ANY EFFECT2
			local skTEff2 = skill.TEff2 or "None"
			GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].orTargetHas,"SKM_TEff2_"..tostring(skID),tostring(skname),"None,Bleeding,Blind,Burning,Chilled,Confusion,Crippled,Fear,Immobilized,Vulnerability,Weakness,Poison,Aegis,Fury,Might,Protection,Regeneration,Retaliation,Stability,Swiftness,Vigor,Stealth,Stun");
			_G["SKM_TEff2_"..tostring(skID)] = tostring(skTEff2)			
			
			-- TARGET HAS NOT EFFECT1
			local skTNEff1 = skill.TNEff1 or "None"
			GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].targetHasNot,"SKM_TNEff1_"..tostring(skID),tostring(skname),"None,Bleeding,Blind,Burning,Chilled,Confusion,Crippled,Fear,Immobilized,Vulnerability,Weakness,Poison,Aegis,Fury,Might,Protection,Regeneration,Retaliation,Stability,Swiftness,Vigor,Stealth,Stun");
			_G["SKM_TNEff1_"..tostring(skID)] = tostring(skTNEff1)			
			-- TARGET HAS NOT EFFECT2
			local skTNEff2 = skill.TNEff2 or "None"
			GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].orTargetHasNot,"SKM_TNEff2_"..tostring(skID),tostring(skname),"None,Bleeding,Blind,Burning,Chilled,Confusion,Crippled,Fear,Immobilized,Vulnerability,Weakness,Poison,Aegis,Fury,Might,Protection,Regeneration,Retaliation,Stability,Swiftness,Vigor,Stealth,Stun");
			_G["SKM_TNEff2_"..tostring(skID)] = tostring(skTNEff2)
			
			
			-- ADD MORE HERE
			
			SkillMgr.SkillSet[skID] = { name = tostring(skname) , prio = skPrio}
		end
	end
end

function SkillMgr.CheckIfPriorityExists(prio)
	local id,skill = next (SkillMgr.SkillSet)
	while id and skill do
		if ( tonumber(skill.prio) == tonumber(prio) ) then
			return true
		end		
		id,skill = next (SkillMgr.SkillSet,id)
	end
	return false
end

function SkillMgr.ClearCurrentSkills()
	local id,skill = next (SkillMgr.SkillSet)
	while id and skill do
		--d("Removing :"..tostring(skill.name))
		GUI_Delete("SkillManager",tostring(skill.name))		
		id,skill = next (SkillMgr.SkillSet,id)
	end
	SkillMgr.SkillSet = {}
end


function SkillMgr.SelectTarget()
	--TODO: Hook into combat and gcombat state!
	if ( not wt_core_controller.shouldRun and sMtargetmode ~= "No Autotarget" ) then
		local TargetList
		if (gSMmode == "Attack Everything") then
			if ( gsMtargetmode == "Autotarget Weakest" )then 
				TargetList = CharacterList( "lowesthealth,los,attackable,alive,noCritter,maxdistance="..wt_global_information.AttackRange+150)			
			elseif( gsMtargetmode == "Autotarget Closest" ) then
				TargetList = CharacterList( "nearest,los,attackable,alive,noCritter,maxdistance=1500")--..wt_global_information.AttackRange)
			elseif( gsMtargetmode == "Autotarget Biggest Crowd" ) then
				TargetList = CharacterList( "clustered=300,los,attackable,alive,noCritter,maxdistance="..wt_global_information.AttackRange+150)				
			end
		else
			if ( gsMtargetmode == "Autotarget Weakest" )then 
				TargetList = CharacterList( "lowesthealth,los,player,attackable,alive,noCritter,maxdistance="..wt_global_information.AttackRange+150)			
			elseif( gsMtargetmode == "Autotarget Closest" ) then
				TargetList = CharacterList( "nearest,los,player,attackable,alive,noCritter,maxdistance="..wt_global_information.AttackRange+150)
			elseif( gsMtargetmode == "Autotarget Biggest Crowd" ) then
				TargetList = CharacterList( "clustered=300,los,player,attackable,alive,noCritter,maxdistance="..wt_global_information.AttackRange+150)				
			end
		end
		if ( TableSize ( TargetList ) > 0 )then
			local TID, Target = next ( TargetList )
			if ( TID and TID ~= 0 and Target ) then
				if ( Player:GetTarget() ~= TID ) then
					Player:SetTarget(TID)
				end
			end
		else
			-- Increased Range
			if (gSMmode == "Attack Everything") then
				if ( gsMtargetmode == "Autotarget Weakest" )then 
					TargetList = CharacterList( "lowesthealth,los,attackable,alive,noCritter,maxdistance=1500")			
				elseif( gsMtargetmode == "Autotarget Closest" ) then
					TargetList = CharacterList( "nearest,los,attackable,alive,noCritter,maxdistance=1500")
				elseif( gsMtargetmode == "Autotarget Biggest Crowd" ) then
					TargetList = CharacterList( "clustered=300,los,attackable,alive,noCritter,maxdistance=1500")				
				end
			else
				if ( gsMtargetmode == "Autotarget Weakest" )then 
					TargetList = CharacterList( "lowesthealth,los,player,attackable,alive,noCritter,maxdistance=1500")			
				elseif( gsMtargetmode == "Autotarget Closest" ) then
					TargetList = CharacterList( "nearest,los,player,attackable,alive,noCritter,maxdistance=1500")
				elseif( gsMtargetmode == "Autotarget Biggest Crowd" ) then
					TargetList = CharacterList( "clustered=300,los,player,attackable,alive,noCritter,maxdistance=1500")				
				end
			end
			if ( TableSize ( TargetList ) > 0 )then
				local TID, Target = next ( TargetList )
				if ( TID and TID ~= 0 and Target ) then
					if ( Player:GetTarget() ~= TID ) then
						Player:SetTarget(TID)
					end
				end
			else
				-- No LOS
				if (gSMmode == "Attack Everything") then
					if ( gsMtargetmode == "Autotarget Weakest" )then 
						TargetList = CharacterList( "lowesthealth,attackable,alive,noCritter,maxdistance="..wt_global_information.AttackRange+150)			
					elseif( gsMtargetmode == "Autotarget Closest" ) then
						TargetList = CharacterList( "nearest,attackable,alive,noCritter,maxdistance=1500")--..wt_global_information.AttackRange)
					elseif( gsMtargetmode == "Autotarget Biggest Crowd" ) then
						TargetList = CharacterList( "clustered=300,attackable,alive,noCritter,maxdistance="..wt_global_information.AttackRange+150)				
					end
				else
					if ( gsMtargetmode == "Autotarget Weakest" )then 
						TargetList = CharacterList( "lowesthealth,player,attackable,alive,noCritter,maxdistance="..wt_global_information.AttackRange+150)			
					elseif( gsMtargetmode == "Autotarget Closest" ) then
						TargetList = CharacterList( "nearest,player,attackable,alive,noCritter,maxdistance="..wt_global_information.AttackRange+150)
					elseif( gsMtargetmode == "Autotarget Biggest Crowd" ) then
						TargetList = CharacterList( "clustered=300,player,attackable,alive,noCritter,maxdistance="..wt_global_information.AttackRange+150)				
					end
				end
				if ( TableSize ( TargetList ) > 0 )then
					local TID, Target = next ( TargetList )
					if ( TID and TID ~= 0 and Target ) then
						if ( Player:GetTarget() ~= TID ) then
							Player:SetTarget(TID)
						end
					end
				else
					-- Increased Range + No LOS
					if (gSMmode == "Attack Everything") then
						if ( gsMtargetmode == "Autotarget Weakest" )then 
							TargetList = CharacterList( "lowesthealth,attackable,alive,noCritter,maxdistance=1500")			
						elseif( gsMtargetmode == "Autotarget Closest" ) then
							TargetList = CharacterList( "nearest,attackable,alive,noCritter,maxdistance=1500")
						elseif( gsMtargetmode == "Autotarget Biggest Crowd" ) then
							TargetList = CharacterList( "clustered=300,attackable,alive,noCritter,maxdistance=1500")				
						end
					else
						if ( gsMtargetmode == "Autotarget Weakest" )then 
							TargetList = CharacterList( "lowesthealth,player,attackable,alive,noCritter,maxdistance=1500")			
						elseif( gsMtargetmode == "Autotarget Closest" ) then
							TargetList = CharacterList( "nearest,player,attackable,alive,noCritter,maxdistance=1500")
						elseif( gsMtargetmode == "Autotarget Biggest Crowd" ) then
							TargetList = CharacterList( "clustered=300,player,attackable,alive,noCritter,maxdistance=1500")				
						end
					end
					if ( TableSize ( TargetList ) > 0 )then
						local TID, Target = next ( TargetList )
						if ( TID and TID ~= 0 and Target ) then
							if ( Player:GetTarget() ~= TID ) then
								Player:SetTarget(TID)
							end
						end
					end
				end
			end
		end
	end
end

function SkillMgr.DoAction()
	
	SkillMgr.cskills = {}
	for i = 1, 16, 1 do
		local skill = Player:GetSpellInfo(GW2.SKILLBARSLOT["Slot_" .. i])
		if ( skill ~= nil ) then			
			SkillMgr.cskills[i] = skill
			SkillMgr.cskills[i].slot = GW2.SKILLBARSLOT["Slot_" .. i]
			if (i == 1) then
				wt_global_information.AttackRange = skill.maxRange or 160
			end
		end
	end
	
	local target, tid = nil, Player:GetTarget()
	if tid and tid ~= 0 then
		target = CharacterList:Get(tid)
		if target and target.attitude ~= GW2.ATTITUDE.Friendly then
			target.id = tid
		else
			target = GadgetList:Get(tid)
			if target then
				target.id = tid
			end
		end
	end
	if ( target and (target.attitude == GW2.ATTITUDE.Friendly or target.attitude == Unattackable)) then
		target = nil
	end

	local skillID = SkillMgr.GetNextBestSkillID(-999999)
	while skillID do
		for i = 1, 16, 1 do		
			if (SkillMgr.cskills[i] and SkillMgr.cskills[i].contentID == tonumber(skillID) and tostring(_G["SKM_ON_"..tostring(skillID)]) == "1" ) then -- we have the skill in our current skilldeck				
				--d(tostring(Player:GetCurrentlyCastedSpell()).." IC: "..tostring(Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_1)).." IS1cast: "..tostring(Player:IsSpellCurrentlyCast(GW2.SKILLBARSLOT.Slot_1)).." X:"..tostring(Player:IsCasting()))
	
				local castable = true
				
				-- COOLDOWN CHECK
				if ( SkillMgr.cskills[i].slot ~= GW2.SKILLBARSLOT.Slot_1 and Player:IsSpellOnCooldown(SkillMgr.cskills[i].slot)) then castable = false end
				
				-- OUTOFCOMBAT CHECK
				if ( castable and (tostring(_G["SKM_OutOfCombat_"..tostring(skillID)]) == "No" and not Player.inCombat) ) then castable = false end
				
				-- PLAYER MOVEMENT CHECK
				if ( castable and ( (tostring(_G["SKM_PMove_"..tostring(skillID)]) == "No" and Player.movementstate == GW2.MOVEMENTSTATE.GroundMoving) or (tostring(_G["SKM_PMove_"..tostring(skillID)]) == "Yes" and Player.movementstate == GW2.MOVEMENTSTATE.GroundNotMoving) )) then castable = false end
				--d("castable1:"..tostring(castable).." " ..tostring(skillID))	
				
				-- TARGETTYPE + LOS + RANGE + MOVEMENT + HEALTH CHECK 
				if ( castable and (tostring(_G["SKM_TType_"..tostring(skillID)]) == "Enemy" 
					and (not target
						or (tostring(_G["SKM_LOS_"..tostring(skillID)]) == "Yes" and not target.los)
						or (tonumber(_G["SKM_MinR_"..tostring(skillID)]) > 0 and target.distance < tonumber(_G["SKM_MinR_"..tostring(skillID)]))
						or (tonumber(_G["SKM_MaxR_"..tostring(skillID)]) > 0 and target.distance > tonumber(_G["SKM_MaxR_"..tostring(skillID)]))
						or (tostring(_G["SKM_TMove_"..tostring(skillID)]) == "No" and target.movementstate == GW2.MOVEMENTSTATE.GroundMoving)
						or (tostring(_G["SKM_PMove_"..tostring(skillID)]) == "Yes" and target.movementstate == GW2.MOVEMENTSTATE.GroundNotMoving)
						or (tonumber(_G["SKM_THPL_"..tostring(skillID)]) > 0 and tonumber(_G["SKM_THPL_"..tostring(skillID)]) > target.health.percent)
						or (tonumber(_G["SKM_THPB_"..tostring(skillID)]) > 0 and tonumber(_G["SKM_THPB_"..tostring(skillID)]) < target.health.percent)
						))) then castable = false end	
						
				-- PLAYER HEALTH,POWER,ENDURANCE CHECK				
				if ( castable and (
					(tonumber(_G["SKM_PHPL_"..tostring(skillID)]) > 0 and tonumber(_G["SKM_PHPL_"..tostring(skillID)]) > Player.health.percent)
					or (tonumber(_G["SKM_PHPB_"..tostring(skillID)]) > 0 and tonumber(_G["SKM_PHPB_"..tostring(skillID)]) < Player.health.percent)
					or (tonumber(_G["SKM_PPowL_"..tostring(skillID)]) > 0 and tonumber(_G["SKM_PPowL_"..tostring(skillID)]) > Player:GetProfessionPowerPercentage())
					or (tonumber(_G["SKM_PPowB_"..tostring(skillID)]) > 0 and tonumber(_G["SKM_PPowB_"..tostring(skillID)]) < Player:GetProfessionPowerPercentage())					
					)) then castable = false end
				
				-- PLAYER BUFF CHECKS
				if ( castable and (tostring(_G["SKM_PEff1_"..tostring(skillID)]) ~= "None" or tostring(_G["SKM_PEff2_"..tostring(skillID)]) ~= "None" or tostring(_G["SKM_PNEff1_"..tostring(skillID)]) ~= "None" or tostring(_G["SKM_PNEff2_"..tostring(skillID)]) ~= "None") )then 
					local mybuffs = Player.buffs
					if ( mybuffs ) then
						local E1 = SkillMgr.BuffEnum[tostring(_G["SKM_PEff1_"..tostring(skillID)])]
						local E2 = SkillMgr.BuffEnum[tostring(_G["SKM_PEff2_"..tostring(skillID)])]
						local NE1 = SkillMgr.BuffEnum[tostring(_G["SKM_PNEff1_"..tostring(skillID)])]
						local NE2 = SkillMgr.BuffEnum[tostring(_G["SKM_PNEff2_"..tostring(skillID)])]						
						local bufffound = false
						local i,buff = next(mybuffs)
						while i and buff do							
							local bskID = buff.skillID
							if ( bskID == NE1 or bskID == NE2 or bskID == E1 or bskID == E2) then
								bufffound = true
								break
							end
							i,buff = next(mybuffs,i)
						end
						if (not bufffound and (E1 or E2))then castable = false end
						if (bufffound and (NE1 or NE2))then castable = false end											
					end					
				end
				
				-- ALLIE AE CHECK
				if ( castable and (tonumber(_G["SKM_TACount_"..tostring(skillID)]) > 1 and tonumber(_G["SKM_TARange_"..tostring(skillID)]) > 0)) then
					if ( not target 
						or not target.id
						or ( TableSize(CharacterList("friendly,maxdistance="..tonumber(_G["SKM_TARange_"..tostring(skillID)])..",distanceto="..target.id)) < tonumber(_G["SKM_TACount_"..tostring(skillID)]))) then
						castable = false
					end
				end
				
				-- TARGET BUFF CHECKS 
				if ( castable and target and (tostring(_G["SKM_TEff1_"..tostring(skillID)]) ~= "None" or tostring(_G["SKM_TEff2_"..tostring(skillID)]) ~= "None" or tostring(_G["SKM_TNEff1_"..tostring(skillID)]) ~= "None" or tostring(_G["SKM_TNEff2_"..tostring(skillID)]) ~= "None") )then 
					local tbuffs = target.buffs
					if ( tbuffs ) then
						local E1 = SkillMgr.BuffEnum[tostring(_G["SKM_TEff1_"..tostring(skillID)])]
						local E2 = SkillMgr.BuffEnum[tostring(_G["SKM_TEff2_"..tostring(skillID)])]
						local NE1 = SkillMgr.BuffEnum[tostring(_G["SKM_TNEff1_"..tostring(skillID)])]
						local NE2 = SkillMgr.BuffEnum[tostring(_G["SKM_TNEff2_"..tostring(skillID)])]						
						local bufffound = false
						local i,buff = next(tbuffs)
						while i and buff do							
							local bskID = buff.skillID
							if ( bskID == NE1 or bskID == NE2 or bskID == E1 or bskID == E2) then
								bufffound = true
								break
							end
							i,buff = next(tbuffs,i)
						end
						if (not bufffound and (E1 or E2))then castable = false end
						if (bufffound and (NE1 or NE2))then castable = false end											
					end					
				end
				-- TARGET AE CHECK
				if ( castable and (tonumber(_G["SKM_TECount_"..tostring(skillID)]) > 1 and tonumber(_G["SKM_TERange_"..tostring(skillID)]) > 0)) then
					if ( not target 
						or not target.id
						or ( TableSize(CharacterList("alive,attackable,maxdistance="..tonumber(_G["SKM_TERange_"..tostring(skillID)])..",distanceto="..target.id)) < tonumber(_G["SKM_TECount_"..tostring(skillID)]))) then
						castable = false
					end
				end
									
				if ( castable ) then
					-- Swap Weapon check
					if ( SkillMgr.cskills[i].slot == GW2.SKILLBARSLOT.Slot_1 ) then
						SkillMgr.SwapWeaponCheck("CoolDown")
					end
					
					local sp = Player:GetCurrentlyCastedSpell()
					-- CAST Self check
					if ( tostring(_G["SKM_TType_"..tostring(skillID)]) == "Self" ) then						
						if ( not Player:IsCasting() or sp ~= SkillMgr.cskills[i].slot ) then
							Player:CastSpell(SkillMgr.cskills[i].slot)
							--	Player:LeaveCombatState()
						end
						--d("Casting on Self: "..tostring(cskills[i].name))
						return
					else
						if ( target and target.id ) then							
							if ( not Player:IsCasting() or sp ~= SkillMgr.cskills[i].slot ) then							
								Player:CastSpell(SkillMgr.cskills[i].slot,target.id)								
							end
							 --d("Casting on Enemy: "..tostring(SkillMgr.cskills[i].name))
							return
						end
					end					
				end
			end
		end		
		skillID = SkillMgr.GetNextBestSkillID(tonumber(_G["SKM_Prio_"..tostring(skillID)]))
	end
	-- swap weapons if target but out of range
	if ( target and target.distance > wt_global_information.AttackRange ) then
		SkillMgr.SwapWeaponCheck("Range")
	end	
end

function SkillMgr.SwapWeaponCheck(swaptype)
	
	if ( gSMSwapA == "1" and (SkillMgr.SwapTmr == 0 or SkillMgr.DoActionTmr - SkillMgr.SwapTmr > 500) ) then -- prevent hammering
		
		-- Swap after random Time
		if ( swaptype == "Pulse" and gSMSwapR == "1" and (SkillMgr.SwapRTmr == 0 or SkillMgr.DoActionTmr - SkillMgr.SwapRTmr > math.random(2000,5000))) then
			SkillMgr.SwapRTmr = SkillMgr.DoActionTmr
			SkillMgr.SwapWeapon(swaptype)
			--d(swaptype)
			return
		end
		
		-- Swap when skills 2-5 are on CD
		if ( swaptype == "CoolDown" and gSMSwapCD == "1" and math.random(0,1) == 1) then
			SkillMgr.SwapRTmr = SkillMgr.DoActionTmr
			SkillMgr.SwapWeapon(swaptype)
			--d(swaptype)
			return
		end
		
		-- Swap when our target is out of range for the current weapon
		if ( swaptype == "Range" and gSMSwapRange == "1" and math.random(0,1) == 1) then
			SkillMgr.SwapRTmr = SkillMgr.DoActionTmr
			SkillMgr.SwapWeapon(swaptype)
			--d(swaptype)
			return
		end
		
	end	
end

function SkillMgr.SwapWeapon(swaptype)	
	if ( wt_global_information.Currentprofession.professionID == 6 ) then 
		--Elementalist
		if ( swaptype == "Pulse" and gSMPrioAtt and tonumber(SkillMgr.ElementarAttunements[tostring(gSMPrioAtt)])~= nil and not Player:IsSpellOnCooldown(tonumber(SkillMgr.ElementarAttunements[tostring(gSMPrioAtt)]))) then
			--d("Switching to our prio attunement: "..tostring(gSMPrioAtt))
			Player:CastSpell(tonumber(SkillMgr.ElementarAttunements[tostring(gSMPrioAtt)]))
			SkillMgr.SwapTmr = SkillMgr.DoActionTmr
		else
			local switch = math.random(12,15)			
			if ( not Player:IsSpellOnCooldown(switch) ) then
				Player:CastSpell(switch)
				SkillMgr.SwapTmr = SkillMgr.DoActionTmr
			end
		end	
		
	elseif( wt_global_information.Currentprofession.professionID == 3 ) then 		
		-- Engineer		
		local availableKits = { [1] = 0 }-- Leave Kit Placeholder
		for i = 1, 16, 1 do
			if (SkillMgr.cskills[i]) then 
				if ( SkillMgr.EngineerKits[SkillMgr.cskills[i].contentID] ~= nil and not Player:IsSpellOnCooldown(SkillMgr.cskills[i].slot)) then
					if ( SkillMgr.SwapWeaponTable[SkillMgr.cskills[i].slot] == nil or (SkillMgr.DoActionTmr - SkillMgr.SwapWeaponTable[SkillMgr.cskills[i].slot].lastused or 0) > 1000) then
						availableKits[#availableKits+1] = SkillMgr.cskills[i].slot												
					end
				end				
			end
		end		
		local key = math.random(#availableKits)
		--d("KEYSIZE "..tostring(#availableKits).. " choosen: "..tostring(key))
		--d("Slot: " ..tostring(availableKits[key]))
		if ( key ~= 1 ) then
			Player:CastSpell(availableKits[key])
			if (gSMPrioKit ~= "None" and tostring(SkillMgr.EngineerKits[Player:GetSpellInfo(availableKits[key]).contentID]) ~= tostring(gSMPrioKit))then
				--d(tostring(SkillMgr.EngineerKits[Player:GetSpellInfo(availableKits[key]).contentID]).." is not our priokit: "..tostring(gSMPrioKit).." extending time")
				SkillMgr.SwapWeaponTable[availableKits[key]] = { lastused = SkillMgr.DoActionTmr + 5000 }
			else
				SkillMgr.SwapWeaponTable[availableKits[key]] = { lastused = SkillMgr.DoActionTmr }
			end
		else				
			if ( Player:CanSwapWeaponSet() ) then
				if (gSMPrioKit == "None" or swaptype == "Pulse") then
					Player:SwapWeaponSet()
					SkillMgr.SwapTmr = SkillMgr.DoActionTmr
				end
			end
		end
	else 
		-- All other professions
		if ( Player:CanSwapWeaponSet() ) then
			Player:SwapWeaponSet()
			SkillMgr.SwapTmr = SkillMgr.DoActionTmr
		end
	end	
end

function SkillMgr.GetNextBestSkillID(startingprio)
	local prio, skillID
	local skID,_ = next (SkillMgr.SkillSet)
	while skID do
		if ( (tonumber(_G["SKM_Prio_"..tostring(skID)]) and tonumber(_G["SKM_Prio_"..tostring(skID)]) > startingprio ) and (not prio or tonumber(_G["SKM_Prio_"..tostring(skID)]) < prio )) then
			prio = tonumber(_G["SKM_Prio_"..tostring(skID)])
			skillID = skID
		end
		skID,_ = next (SkillMgr.SkillSet,skID)
	end
	return skillID
end

function SkillMgr.ToggleMenu()
	if (SkillMgr.visible) then
		GUI_WindowVisible(SkillMgr.mainwindow.name,false)	
		SkillMgr.visible = false
	else
		local wnd = GUI_GetWindowInfo("GW2Minion")	
		--GUI_MoveWindow( SkillMgr.mainwindow.name, wnd.x+wnd.width,wnd.y) 
		GUI_WindowVisible(SkillMgr.mainwindow.name,true)	
		SkillMgr.visible = true
	end
end

RegisterEventHandler("Gameloop.Update",SkillMgr.OnUpdate)
RegisterEventHandler("SkillManager.toggle", SkillMgr.ToggleMenu)
RegisterEventHandler("GUI.Update",SkillMgr.GUIVarUpdate)
RegisterEventHandler("Module.Initalize",SkillMgr.ModuleInit)