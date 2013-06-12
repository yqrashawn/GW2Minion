-- Skillmanager for adv. skill customization
SkillMgr = { }
SkillMgr.version = "v0.4";
SkillMgr.profilepath = GetStartupPath() .. [[\LuaMods\gw2minion\SkillManagerProfiles\]];
SkillMgr.mainwindow = { name = "SkillManager", x = 450, y = 50, w = 350, h = 350}
SkillMgr.RecordSkillTmr = 0
SkillMgr.SkillMgrTmr = 0
SkillMgr.SkillSet = {}
SkillMgr.Skill = {	
	["ID"] = 0,
	["name"] = "",
}

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
	
	
	local wnd = GUI_GetWindowInfo("GW2Minion")
	GUI_NewWindow(SkillMgr.mainwindow.name,SkillMgr.mainwindow.x,SkillMgr.mainwindow.y,SkillMgr.mainwindow.w,SkillMgr.mainwindow.h)
	GUI_NewCheckbox(SkillMgr.mainwindow.name,"Activated","gSMactive","General Settings")
	GUI_NewComboBox(SkillMgr.mainwindow.name,"Profile","gSMprofile","General Settings","Settings.GW2MINION.gSMlastprofile");
	GUI_NewButton(SkillMgr.mainwindow.name,"Refresh Profiles","SMRefreshEvent","Skill Editor")
	GUI_NewButton(SkillMgr.mainwindow.name,"Delete Profile","SMDeleteEvent","Skill Editor")
	
	GUI_NewField(SkillMgr.mainwindow.name,"New Profile Name","gSMnewname","Skill Editor")
	GUI_NewButton(SkillMgr.mainwindow.name,"New Profile","newSMProfileEvent","Skill Editor")
	GUI_NewCheckbox(SkillMgr.mainwindow.name,"Autodetect Skills","gSMRecactive","Skill Editor")
	
	SkillMgr.UpdateProfiles()
	
	SkillMgr.UpdateCurrentProfile()
	
	RegisterEventHandler("SMRefreshEvent",SkillMgr.UpdateProfiles)
	RegisterEventHandler("SMDeleteEvent",SkillMgr.DeleteCurrentProfile)
	RegisterEventHandler("newSMProfileEvent",SkillMgr.CreateNewProfile)
end

function SkillMgr.GUIVarUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		d(tostring(k).." "..tostring(v))
		if ( k == "gSMactive") then			
			Settings.GW2MINION[tostring(k)] = v
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
				
				file:write("mapid=5 \n")
				
				file:flush()
				file:close()
			end
		end			
	end
end

function SkillMgr.UpdateProfiles()
	-- Grab all Profiles
	local profiles = "None"
	local found = "None"

	local profilelist = io.popen("dir /b ".. SkillMgr.profilepath .."*.lua")
	if ( profilelist ~= nil ) then
		for profile in profilelist:lines() do
			profile = string.gsub(profile, ".lua", "")		
			profiles = profiles..","..tostring(profile)
			if ( tostring(Settings.GW2MINION.gSMlastprofile) ~= nil and tostring(Settings.GW2MINION.gSMlastprofile) == tostring(profile) ) then
				found = profile
			end
		end
		profilelist:close()
	end
	wt_debug("ALL PROFILES: "..tostring(profiles))
	gSMprofile_listitems = profiles
	gSMprofile = tostring(found)
end

function SkillMgr.DeleteCurrentProfile()	
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
		
			GUI_NewField(SkillMgr.mainwindow.name,"ID","SKM_ID"..tostring(skID),tostring(skname))
			_G["SKM_ID"..tostring(skID)] = skID
			
			-- ENABLED
			local skON = "1"
			GUI_NewCheckbox(SkillMgr.mainwindow.name,"Enabled","SKM_ON"..tostring(skID),tostring(skname))
			_G["SKM_ON"..tostring(skID)] = tostring(skON)
			
			-- PRIORITY
			local skPrio = TableSize(SkillMgr.SkillSet)
			GUI_NewField(SkillMgr.mainwindow.name,"Priority","SKM_Prio"..tostring(skID),tostring(skname))
			_G["SKM_Prio"..tostring(skID)] = skPrio
			
			-- COOLDOWN
			local skCD = skill.cooldown
			GUI_NewField(SkillMgr.mainwindow.name,"Cooldown","SKM_CD"..tostring(skID),tostring(skname))
			_G["SKM_CD"..tostring(skID)] = skCD
			
			-- MINRANGE
			local skMinR = skill.minRange
			GUI_NewField(SkillMgr.mainwindow.name,"MinRange","SKM_MinR"..tostring(skID),tostring(skname))
			_G["SKM_MinR"..tostring(skID)] = skMinR
			
			-- MAXRANGE
			local skMaxR = skill.maxRange
			GUI_NewField(SkillMgr.mainwindow.name,"MaxRange","SKM_MaxR"..tostring(skID),tostring(skname))
			_G["SKM_MaxR"..tostring(skID)] = skMaxR
			
			-- IS GROUND TARGETED
			local skGT = skill.isGroundTargeted
			GUI_NewComboBox(SkillMgr.mainwindow.name,"IsGroundTargeted","SKM_GT"..tostring(skID),tostring(skname),"false,true");
			_G["SKM_GT"..tostring(skID)] = tostring(skGT)
			
			-- TARGETTYPE
			local skTType = "Enemy"
			GUI_NewComboBox(SkillMgr.mainwindow.name,"TargetType","SKM_TType"..tostring(skID),tostring(skname),"Enemy,Self,Ally");
			_G["SKM_TType"..tostring(skID)] = tostring(skTType)
			
			-- USEINCOMBAT
			local skInCombat = "Yes"
			GUI_NewComboBox(SkillMgr.mainwindow.name,"UseInCombat","SKM_InCombat"..tostring(skID),tostring(skname),"Either,Yes,No");
			_G["SKM_InCombat"..tostring(skID)] = tostring(skInCombat)
			
			-- PLAYER MOVING
			local skPMove = "Either"
			GUI_NewComboBox(SkillMgr.mainwindow.name,"Player Moving","SKM_PMove"..tostring(skID),tostring(skname),"Either,Yes,No");
			_G["SKM_PMove"..tostring(skID)] = tostring(skPMove)
			
			-- PLAYER >HEALTH PERCENT
			local skPHPLarger = 0
			GUI_NewField(SkillMgr.mainwindow.name,"Player HP% >","SKM_PHPL"..tostring(skID),tostring(skname));
			_G["SKM_PHPL"..tostring(skID)] = skPHPLarger
			
			-- PLAYER <HEALTH PERCENT
			local skPHPBelow = 0
			GUI_NewField(SkillMgr.mainwindow.name,"Player HP% <","SKM_PHPB"..tostring(skID),tostring(skname));
			_G["SKM_PHPB"..tostring(skID)] = skPHPBelow
			
			-- PLAYER >POWER PERCENT
			local skPPOWLarger = 0
			GUI_NewField(SkillMgr.mainwindow.name,"Player Power% >","SKM_PPowL"..tostring(skID),tostring(skname));
			_G["SKM_PPowL"..tostring(skID)] = skPPOWLarger
			
			-- PLAYER HAS ANY EFFECT1
			local skPEff1 = "None"
			GUI_NewComboBox(SkillMgr.mainwindow.name,"Player has ","SKM_PEff1"..tostring(skID),tostring(skname),"None,Bleeding,Blind,Burning,Chilled,Confusion,Crippled,Fear,Immobilized,Vulnerability,Weakness,Poison,Aegis,Fury,Might,Protection,Regeneration,Retaliation,Stability,Swiftness,Vigor,Stealth,Stun");
			_G["SKM_PEff1"..tostring(skID)] = tostring(skPEff1)			
			-- PLAYER HAS ANY EFFECT2
			local skPEff2 = "None"
			GUI_NewComboBox(SkillMgr.mainwindow.name,"or Player has ","SKM_PEff2"..tostring(skID),tostring(skname),"None,Bleeding,Blind,Burning,Chilled,Confusion,Crippled,Fear,Immobilized,Vulnerability,Weakness,Poison,Aegis,Fury,Might,Protection,Regeneration,Retaliation,Stability,Swiftness,Vigor,Stealth,Stun");
			_G["SKM_PEff2"..tostring(skID)] = tostring(skPEff2)			
			
			-- PLAYER HAS NOT EFFECT1
			local skPNEff1 = "None"
			GUI_NewComboBox(SkillMgr.mainwindow.name,"Player has NOT ","SKM_PNEff1"..tostring(skID),tostring(skname),"None,Bleeding,Blind,Burning,Chilled,Confusion,Crippled,Fear,Immobilized,Vulnerability,Weakness,Poison,Aegis,Fury,Might,Protection,Regeneration,Retaliation,Stability,Swiftness,Vigor,Stealth,Stun");
			_G["SKM_PNEff1"..tostring(skID)] = tostring(skPNEff1)			
			-- PLAYER HAS NOT EFFECT2
			local skPNEff2 = "None"
			GUI_NewComboBox(SkillMgr.mainwindow.name,"or Player has NOT ","SKM_PNEff2"..tostring(skID),tostring(skname),"None,Bleeding,Blind,Burning,Chilled,Confusion,Crippled,Fear,Immobilized,Vulnerability,Weakness,Poison,Aegis,Fury,Might,Protection,Regeneration,Retaliation,Stability,Swiftness,Vigor,Stealth,Stun");
			_G["SKM_PNEff2"..tostring(skID)] = tostring(skPNEff2)	
						
			-- PLAYER <POWER PERCENT
			local skPPOWBelow = 0
			GUI_NewField(SkillMgr.mainwindow.name,"Player Power% <","SKM_PPowB"..tostring(skID),tostring(skname));
			_G["SKM_PPowB"..tostring(skID)] = skPPOWBelow			
					
			-- TARGET MOVING
			local skTMove = "Either"
			GUI_NewComboBox(SkillMgr.mainwindow.name,"Target Moving","SKM_TMove"..tostring(skID),tostring(skname),"Either,Yes,No");
			_G["SKM_TMove"..tostring(skID)] = tostring(skTMove)
			
			-- TARGET >HEALTH PERCENT
			local skTHPLarger = 0
			GUI_NewField(SkillMgr.mainwindow.name,"Target HP% >","SKM_THPL"..tostring(skID),tostring(skname));
			_G["SKM_THPL"..tostring(skID)] = skTHPLarger
			
			-- TARGET <HEALTH PERCENT
			local skTHPBelow = 0
			GUI_NewField(SkillMgr.mainwindow.name,"Target HP% <","SKM_THPB"..tostring(skID),tostring(skname));
			_G["SKM_THPB"..tostring(skID)] = skTHPBelow
			
			-- TARGET > DISTANCE
			local skTDistL = 0
			GUI_NewField(SkillMgr.mainwindow.name,"Target Distance >","SKM_TDistL"..tostring(skID),tostring(skname));
			_G["SKM_TDistL"..tostring(skID)] = skTDistL
			
			-- TARGET > DISTANCE
			local skTDistB = 0
			GUI_NewField(SkillMgr.mainwindow.name,"Target Distance <","SKM_TDistB"..tostring(skID),tostring(skname));
			_G["SKM_TDistB"..tostring(skID)] = skTDistB
			
			-- NEAR TARGET ENEMIES COUNT
			local skTECount = 0
			GUI_NewComboBox(SkillMgr.mainwindow.name,"Enemies Near Target(Count) >=","SKM_TECount"..tostring(skID),tostring(skname),"0,1,2,3,4,5,6");
			_G["SKM_TECount"..tostring(skID)] = tostring(skTECount)
			
			-- NEAR TARGET ENEMIES RANGE
			local skTERange = 0
			GUI_NewComboBox(SkillMgr.mainwindow.name,"Enemies Near Target(MaxRange) =","SKM_TERange"..tostring(skID),tostring(skname),"0,100,200,300,400,500,600");
			_G["SKM_TERange"..tostring(skID)] = tostring(skTERange)
			
			-- NEAR TARGET ALLIES COUNT
			local skTACount = 0
			GUI_NewComboBox(SkillMgr.mainwindow.name,"Allies Near Target(Count) >=","SKM_TACount"..tostring(skID),tostring(skname),"0,1,2,3,4,5,6");
			_G["SKM_TACount"..tostring(skID)] = tostring(skTACount)
			
			-- NEAR TARGET ALLIES RANGE
			local skTARange = 0
			GUI_NewComboBox(SkillMgr.mainwindow.name,"Allies Near Target(MaxRange) =","SKM_TARange"..tostring(skID),tostring(skname),"0,100,200,300,400,500,600");
			_G["SKM_TARange"..tostring(skID)] = tostring(skTARange)
			
			-- TARGET HAS ANY EFFECT1
			local skTEff1 = "None"
			GUI_NewComboBox(SkillMgr.mainwindow.name,"Target has ","SKM_TEff1"..tostring(skID),tostring(skname),"None,Bleeding,Blind,Burning,Chilled,Confusion,Crippled,Fear,Immobilized,Vulnerability,Weakness,Poison,Aegis,Fury,Might,Protection,Regeneration,Retaliation,Stability,Swiftness,Vigor,Stealth,Stun");
			_G["SKM_TEff1"..tostring(skID)] = tostring(skTEff1)			
			-- TARGET HAS ANY EFFECT2
			local skTEff2 = "None"
			GUI_NewComboBox(SkillMgr.mainwindow.name,"or Target has ","SKM_TEff2"..tostring(skID),tostring(skname),"None,Bleeding,Blind,Burning,Chilled,Confusion,Crippled,Fear,Immobilized,Vulnerability,Weakness,Poison,Aegis,Fury,Might,Protection,Regeneration,Retaliation,Stability,Swiftness,Vigor,Stealth,Stun");
			_G["SKM_TEff2"..tostring(skID)] = tostring(skTEff2)			
			
			-- TARGET HAS NOT EFFECT1
			local skTNEff1 = "None"
			GUI_NewComboBox(SkillMgr.mainwindow.name,"Target has NOT ","SKM_TNEff1"..tostring(skID),tostring(skname),"None,Bleeding,Blind,Burning,Chilled,Confusion,Crippled,Fear,Immobilized,Vulnerability,Weakness,Poison,Aegis,Fury,Might,Protection,Regeneration,Retaliation,Stability,Swiftness,Vigor,Stealth,Stun");
			_G["SKM_TNEff1"..tostring(skID)] = tostring(skTNEff1)			
			-- TARGET HAS NOT EFFECT2
			local skTNEff2 = "None"
			GUI_NewComboBox(SkillMgr.mainwindow.name,"or Target has NOT ","SKM_TNEff2"..tostring(skID),tostring(skname),"None,Bleeding,Blind,Burning,Chilled,Confusion,Crippled,Fear,Immobilized,Vulnerability,Weakness,Poison,Aegis,Fury,Might,Protection,Regeneration,Retaliation,Stability,Swiftness,Vigor,Stealth,Stun");
			_G["SKM_TNEff2"..tostring(skID)] = tostring(skTNEff2)
			
			
			-- ADD MORE HERE
			
			SkillMgr.SkillSet[skID] = skID
		end
	end
end

function SkillMgr.ClearCurrentSkills()
	local id,skill = next (SkillMgr.SkillSet)
	while id and skill do
		d("Removing :"..tostring(id))
		--TODO: ADD DELETE SKILLS FUNCTION TO GUI
		id,skill = next (SkillMgr.SkillSet,id)
	end
end


function SkillMgr.UpdateCurrentProfile()
	if (gSMprofile ~= nil and tostring(gSMprofile) ~= "None") then
		if (io.open(SkillMgr.profilepath..tostring(gSMprofile)..".lua")) then
			wt_debug("Updating profile: "..tostring(gSMprofile))
			
			
			
		end
	end
end

RegisterEventHandler("Gameloop.Update",SkillMgr.OnUpdate)
RegisterEventHandler("SkillManager.toggle", SkillMgr.ToggleMenu)
RegisterEventHandler("GUI.Update",SkillMgr.GUIVarUpdate)
RegisterEventHandler("Module.Initalize",SkillMgr.ModuleInit)
