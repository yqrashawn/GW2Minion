-- Skillmanager for adv. skill customization
SkillMgr = { }
SkillMgr.version = "v0.4";
SkillMgr.profilepath = tostring(GetStartupPath()) .. [[\LuaMods\gw2minion\SkillManagerProfiles\]];
SkillMgr.mainwindow = { name = strings[gCurrentLanguage].skillManager, x = 450, y = 50, w = 350, h = 350}
SkillMgr.RecordSkillTmr = 0
SkillMgr.SkillMgrTmr = 0
SkillMgr.DoActionTmr = 0
SkillMgr.SkillSet = {}

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
	
	local wnd = GUI_GetWindowInfo("GW2Minion")
	GUI_NewWindow(SkillMgr.mainwindow.name,SkillMgr.mainwindow.x,SkillMgr.mainwindow.y,SkillMgr.mainwindow.w,SkillMgr.mainwindow.h)
	GUI_NewCheckbox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].activated,"gSMactive",strings[gCurrentLanguage].generalSettings)
	GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].profile,"gSMprofile",strings[gCurrentLanguage].generalSettings,"");
	GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].sMmode,"gSMmode",strings[gCurrentLanguage].generalSettings,"Attack Everything,Attack Players Only");
	--GUI_UnFoldGroup(SkillMgr.mainwindow.name,strings[gCurrentLanguage].generalSettings) crashes still
	
	GUI_NewButton(SkillMgr.mainwindow.name,strings[gCurrentLanguage].saveProfile,"SMSaveEvent",strings[gCurrentLanguage].skillEditor)
	GUI_NewButton(SkillMgr.mainwindow.name,strings[gCurrentLanguage].refreshProfiles,"SMRefreshEvent",strings[gCurrentLanguage].skillEditor)
	GUI_NewButton(SkillMgr.mainwindow.name,strings[gCurrentLanguage].deleteProfile,"SMDeleteEvent",strings[gCurrentLanguage].skillEditor)
	
	GUI_NewField(SkillMgr.mainwindow.name,strings[gCurrentLanguage].newProfileName,"gSMnewname",strings[gCurrentLanguage].skillEditor)
	GUI_NewButton(SkillMgr.mainwindow.name,strings[gCurrentLanguage].newProfile,"newSMProfileEvent",strings[gCurrentLanguage].skillEditor)
	GUI_NewCheckbox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].autoetectSkills,"gSMRecactive",strings[gCurrentLanguage].skillEditor)
	
	gSMmode = Settings.GW2MINION.gSMmode
	
	SkillMgr.UpdateProfiles()
	
	SkillMgr.UpdateCurrentProfileData()
	
	RegisterEventHandler("SMSaveEvent",SkillMgr.SaveProfile)
	RegisterEventHandler("SMRefreshEvent",SkillMgr.UpdateProfiles)
	RegisterEventHandler("SMDeleteEvent",SkillMgr.DeleteCurrentProfile)
	RegisterEventHandler("newSMProfileEvent",SkillMgr.CreateNewProfile)
end

function SkillMgr.GUIVarUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		d(tostring(k).." = "..tostring(v))
		if ( k == "gSMactive" or k == "gSMmode" ) then			
			Settings.GW2MINION[tostring(k)] = v
		elseif ( k == "gSMprofile" ) then			
			SkillMgr.UpdateCurrentProfileData()
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
			if ( tick - SkillMgr.RecordSkillTmr > 60000) then -- max record 60seconds, to compensate smart users who leave it on -.-
				SkillMgr.RecordSkillTmr = 0
				gSMRecactive = "0"
			elseif ( tick - SkillMgr.SkillMgrTmr > 500 ) then
				SkillMgr.SkillMgrTmr = tick
				SkillMgr.CheckForNewSkills()
			end
		end	
	end
	if ( gSMactive == "1" ) then
		if	( tick - SkillMgr.DoActionTmr > 150 ) then
			SkillMgr.DoActionTmr = tick
			SkillMgr.DoAction()
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
				if (_G["SKM_CD_"..tostring(skID)] ) then profile:write("SKM_CD_"..tostring(skID).."="..tostring(_G["SKM_CD_"..tostring(skID)]).."\n") end
				if (_G["SKM_MinR_"..tostring(skID)] ) then profile:write("SKM_MinR_"..tostring(skID).."="..tostring(_G["SKM_MinR_"..tostring(skID)]).."\n") end
				if (_G["SKM_MaxR_"..tostring(skID)] ) then profile:write("SKM_MaxR_"..tostring(skID).."="..tostring(_G["SKM_MaxR_"..tostring(skID)]).."\n") end
				if (_G["SKM_GT_"..tostring(skID)] ) then profile:write("SKM_GT_"..tostring(skID).."="..tostring(_G["SKM_GT_"..tostring(skID)]).."\n") end
				if (_G["SKM_TType_"..tostring(skID)] ) then profile:write("SKM_TType_"..tostring(skID).."="..tostring(_G["SKM_TType_"..tostring(skID)]).."\n") end
				if (_G["SKM_InCombat_"..tostring(skID)] ) then profile:write("SKM_InCombat_"..tostring(skID).."="..tostring(_G["SKM_InCombat_"..tostring(skID)]).."\n") end
				
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
				if (_G["SKM_TDistL_"..tostring(skID)] ) then profile:write("SKM_TDistL_"..tostring(skID).."="..tostring(_G["SKM_TDistL_"..tostring(skID)]).."\n") end
				if (_G["SKM_TDistB_"..tostring(skID)] ) then profile:write("SKM_TDistB_"..tostring(skID).."="..tostring(_G["SKM_TDistB_"..tostring(skID)]).."\n") end
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
	if (gSMprofile ~= nil and tostring(gSMprofile) ~= "None" and tostring(gSMprofile) ~= "" and tostring(gSMprofile) ~= tostring(Settings.GW2MINION.gSMlastprofile)) then
		-- Delete existing Skills
		SkillMgr.ClearCurrentSkills()
		local profile = io.open(SkillMgr.profilepath..tostring(gSMprofile)..".lua", "r")
		if ( profile ) then			
			local newskill = {}
			for line in profile:lines() do				
				local _, key, skillID, value = string.match(tostring(line), "(%w+)_(%w+)_(%d+)=([%w%s]*)")
				--d("key: "..tostring(key).." skillID:"..tostring(skillID) .." value:"..tostring(value))
				if ( key and skillID and value ) then
					if ( key == "END" ) then
						d("Adding Skill :"..tostring(newskill.name))
						SkillMgr.CreateNewSkillEntry(newskill)
						newskill = {}
					elseif ( key == "ID" )then newskill.contentID = tonumber(value)
					elseif ( key == "NAME" )then newskill.name = tostring(value)
					elseif ( key == "ON" )then newskill.ON = tostring(value)
					elseif ( key == "Prio" )then newskill.Prio = tonumber(value)
					elseif ( key == "CD" )then newskill.cooldown = tonumber(value)
					elseif ( key == "MinR" )then newskill.minRange = tonumber(value)
					elseif ( key == "MaxR" )then newskill.maxRange = tonumber(value)
					elseif ( key == "GT" )then newskill.isGroundTargeted = tostring(value)
					elseif ( key == "TType" )then newskill.TType = tostring(value)
					elseif ( key == "InCombat" )then newskill.InCombat = tostring(value)
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
					elseif ( key == "TDistL" )then newskill.TDistL = tonumber(value)
					elseif ( key == "TDistB" )then newskill.TDistB = tonumber(value)
					
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
		else
			d("Error: Can't read SkillProfile: "..tostring(gSMprofile))
		end
	else
		d("No new SkillProfile selected!")		
	end
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
		local skname = skill.name		
		local skID = skill.contentID
		if ( tostring(skill.name) ~= "" and tonumber(skID) ~= nil) then			
		
			GUI_NewField(SkillMgr.mainwindow.name,"ID","SKM_ID_"..tostring(skID),tostring(skname))
			_G["SKM_ID_"..tostring(skID)] = skID
			
			-- NAME,
			--GUI_NewCheckbox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].enabled,"SKM_NAME_"..tostring(skID),tostring(skname))
			_G["SKM_NAME_"..tostring(skID)] = tostring(skname)
			
			-- ENABLED
			local skON = skill.ON or "1"
			GUI_NewCheckbox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].enabled,"SKM_ON_"..tostring(skID),tostring(skname))
			_G["SKM_ON_"..tostring(skID)] = tostring(skON)
			
			-- PRIORITY
			local skPrio = skill.Prio or TableSize(SkillMgr.SkillSet)
			GUI_NewField(SkillMgr.mainwindow.name,strings[gCurrentLanguage].priority,"SKM_Prio_"..tostring(skID),tostring(skname))
			_G["SKM_Prio_"..tostring(skID)] = skPrio
			
			-- COOLDOWN
			local skCD = skill.cooldown
			GUI_NewField(SkillMgr.mainwindow.name,strings[gCurrentLanguage].cooldown,"SKM_CD_"..tostring(skID),tostring(skname))
			_G["SKM_CD_"..tostring(skID)] = skCD
			
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
			GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].targetType,"SKM_TType_"..tostring(skID),tostring(skname),"Enemy,Self,Ally");
			_G["SKM_TType_"..tostring(skID)] = tostring(skTType)
			
			-- USEINCOMBAT
			local skInCombat = skill.InCombat or "Yes"
			GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].useInCombat,"SKM_InCombat_"..tostring(skID),tostring(skname),"Either,Yes,No");
			_G["SKM_InCombat_"..tostring(skID)] = tostring(skInCombat)
			
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
						
			-- PLAYER <POWER PERCENT
			local skPPOWBelow = skill.PPowB or 0
			GUI_NewField(SkillMgr.mainwindow.name,strings[gCurrentLanguage].playerPowerLT,"SKM_PPowB_"..tostring(skID),tostring(skname));
			_G["SKM_PPowB_"..tostring(skID)] = skPPOWBelow			
					
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
			
			-- TARGET > DISTANCE
			local skTDistL = skill.TDistL or 0
			GUI_NewField(SkillMgr.mainwindow.name,strings[gCurrentLanguage].targetDistanceGT,"SKM_TDistL_"..tostring(skID),tostring(skname));
			_G["SKM_TDistL_"..tostring(skID)] = skTDistL
			
			-- TARGET > DISTANCE
			local skTDistB = skill.TDistB or 0
			GUI_NewField(SkillMgr.mainwindow.name,strings[gCurrentLanguage].targetDistanceLT,"SKM_TDistB_"..tostring(skID),tostring(skname));
			_G["SKM_TDistB_"..tostring(skID)] = skTDistB
			
			-- NEAR TARGET ENEMIES COUNT
			local skTECount = skill.TECount or 0
			GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].enemiesNearCount,"SKM_TECount_"..tostring(skID),tostring(skname),"0,1,2,3,4,5,6");
			_G["SKM_TECount_"..tostring(skID)] = tostring(skTECount)
			
			-- NEAR TARGET ENEMIES RANGE
			local skTERange = skill.TERange or 0
			GUI_NewComboBox(SkillMgr.mainwindow.name,strings[gCurrentLanguage].enemiesNearRange,"SKM_TERange_"..tostring(skID),tostring(skname),"0,100,200,300,400,500,600");
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
			
			SkillMgr.SkillSet[skID] = tostring(skname)
		end
	end
end

function SkillMgr.ClearCurrentSkills()
	local id,skill = next (SkillMgr.SkillSet)
	while id and skill do
		d("Removing :"..tostring(skill))
		GUI_Delete("SkillManager",tostring(skill))		
		id,skill = next (SkillMgr.SkillSet,id)
	end
	SkillMgr.SkillSet = {}
end




function SkillMgr.DoAction()
	--[[-- kill shit
	local cskills = {}
	for i = 1, 16, 1 do
		local skill = Player:GetSpellInfo(GW2.SKILLBARSLOT["Slot_" .. i])
		if ( skill ~= nil ) then			
			if ( SkillMgr.SkillSet[skill.contentID] == nil ) then
				SkillMgr.CreateNewSkillEntry(skill)
			end			
		end
	end
	--gSMmode]]--
end

RegisterEventHandler("Gameloop.Update",SkillMgr.OnUpdate)
RegisterEventHandler("SkillManager.toggle", SkillMgr.ToggleMenu)
RegisterEventHandler("GUI.Update",SkillMgr.GUIVarUpdate)
RegisterEventHandler("Module.Initalize",SkillMgr.ModuleInit)
