mc_skillmanager = {}
-- Skillmanager for adv. skill customization
mc_skillmanager.profilepath = GetStartupPath() .. [[\LuaMods\GW2Minion\SkillManagerProfiles\]];
mc_skillmanager.mainwindow = { name = mc_getstring("skillManager"), x = 350, y = 50, w = 250, h = 350}
mc_skillmanager.editwindow = { name = mc_getstring("skillEditor"), w = 250, h = 550}
mc_skillmanager.visible = false
mc_skillmanager.SkillProfile = {}
mc_skillmanager.SkillRecordingActive = false
mc_skillmanager.RecordSkillTmr = 0
mc_skillmanager.RegisteredButtonEventList = {}

--Enums
mc_skillmanager.EngineerKits = {
	[5812] = "BombKit",
	[5927] = "FlameThrower",
	[6020] = "GrenadeKit",
	[5904] = "ToolKit",
	[5933] = "ElixirGun",
	--[5802] = "Medkit",
};

mc_skillmanager.ElementarAttunements = {
	["Fire"] = 12,
	["Water"] = 13,
	["Air"] = 14,
	["Earth"] = 15,
};

mc_skillmanager.BuffEnum = {
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
		["Any Condition"] = 99999,
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

mc_skillmanager.ConditionsEnum = {
		[736] = "Bleeding",
		[720] = "Blind",
		[737] = "Burning",
		[722] = "Chilled",
		[861] = "Confusion",
		[721] = "Crippled",
		[791] = "Fear",
		[727] = "Immobilized",
		[738] = "Vulnerability",
		[742] = "Weakness",
		[723] = "Poison",		
	};
	
mc_skillmanager.BoonsEnum = {
		[743] = "Aegis",
		[725] = "Fury",
		[740] = "Might",
		[717] = "Protection",
		[718] = "Regeneration",
		[873] = "Retaliation",
		[1122] = "Stability",
		[719] = "Swiftness",
		[726] = "Vigor",
		[762] = "Determined",
	};




function mc_skillmanager.ModuleInit() 	
	if (Settings.GW2Minion.gSMprofile == nil) then
		Settings.GW2Minion.gSMprofile = "None"
	end
	if (Settings.GW2Minion.gSMSwapA == nil) then
		Settings.GW2Minion.gSMSwapA = "1"
	end
	if (Settings.GW2Minion.gSMSwapR == nil) then
		Settings.GW2Minion.gSMSwapR = "0"
	end
	if (Settings.GW2Minion.gSMSwapCD == nil) then
		Settings.GW2Minion.gSMSwapCD = "1"
	end
	if (Settings.GW2Minion.gSMSwapRange == nil) then
		Settings.GW2Minion.gSMSwapRange = "1"
	end
	if (Settings.GW2Minion.gSMPrioKit == nil) then
		Settings.GW2Minion.gSMPrioKit = "None"
	end
	if (Settings.GW2Minion.gSMPrioAtt == nil) then
		Settings.GW2Minion.gSMPrioAtt = "Fire"
	end	
	if (Settings.GW2Minion.gSMPrioAtt2 == nil) then
		Settings.GW2Minion.gSMPrioAtt2 = "Water"
	end	
	if (Settings.GW2Minion.gSMPrioAtt3 == nil) then
		Settings.GW2Minion.gSMPrioAtt3 = "Air"
	end	
	if (Settings.GW2Minion.gSMPrioAtt4 == nil) then
		Settings.GW2Minion.gSMPrioAtt4 = "Earth"
	end		

		
	GUI_NewWindow(mc_skillmanager.mainwindow.name,mc_skillmanager.mainwindow.x,mc_skillmanager.mainwindow.y,mc_skillmanager.mainwindow.w,mc_skillmanager.mainwindow.h)
	GUI_NewComboBox(mc_skillmanager.mainwindow.name,mc_getstring("profile"),"gSMprofile",mc_getstring("generalSettings"),"None")
		
	GUI_NewCheckbox(mc_skillmanager.mainwindow.name,mc_getstring("SwapA"),"gSMSwapA",mc_getstring("AdvancedSettings"))
	GUI_NewCheckbox(mc_skillmanager.mainwindow.name,mc_getstring("SwapR"),"gSMSwapR",mc_getstring("AdvancedSettings"))
	GUI_NewCheckbox(mc_skillmanager.mainwindow.name,mc_getstring("SwapCD"),"gSMSwapCD",mc_getstring("AdvancedSettings"))
	GUI_NewCheckbox(mc_skillmanager.mainwindow.name,mc_getstring("SwapRange"),"gSMSwapRange",mc_getstring("AdvancedSettings"))
	
	local prof = Player.profession
	if ( prof ~= nil ) then
		if (prof == 3) then	-- Engineer
		GUI_NewComboBox(mc_skillmanager.mainwindow.name,mc_getstring("PriorizeKit"),"gSMPrioKit",mc_getstring("AdvancedSettings"),"None,BombKit,FlameThrower,GrenadeKit,ToolKit,ElixirGun")
		
		elseif( prof == 6 ) then -- Elementalist
			GUI_NewComboBox(mc_skillmanager.mainwindow.name,mc_getstring("PriorizeAttunement1"),"gSMPrioAtt",mc_getstring("AdvancedSettings"),"None,Fire,Water,Air,Earth")
			GUI_NewComboBox(mc_skillmanager.mainwindow.name,mc_getstring("PriorizeAttunement2"),"gSMPrioAtt2",mc_getstring("AdvancedSettings"),"None,Fire,Water,Air,Earth")
			GUI_NewComboBox(mc_skillmanager.mainwindow.name,mc_getstring("PriorizeAttunement3"),"gSMPrioAtt3",mc_getstring("AdvancedSettings"),"None,Fire,Water,Air,Earth")
			GUI_NewComboBox(mc_skillmanager.mainwindow.name,mc_getstring("PriorizeAttunement4"),"gSMPrioAtt4",mc_getstring("AdvancedSettings"),"None,Fire,Water,Air,Earth")
		end				
	end
	
	GUI_NewButton(mc_skillmanager.mainwindow.name,mc_getstring("autoetectSkills"),"SMAutodetect",mc_getstring("skillEditor"))
	RegisterEventHandler("SMAutodetect",mc_skillmanager.AutoDetectSkills)	
	GUI_NewButton(mc_skillmanager.mainwindow.name,mc_getstring("saveProfile"),"SMSaveEvent")	
	RegisterEventHandler("SMSaveEvent",mc_skillmanager.SaveProfile)	
	GUI_NewField(mc_skillmanager.mainwindow.name,mc_getstring("newProfileName"),"gSMnewname",mc_getstring("skillEditor"))
	GUI_NewButton(mc_skillmanager.mainwindow.name,mc_getstring("newProfile"),"SMCreateNewProfile",mc_getstring("skillEditor"))
	RegisterEventHandler("SMCreateNewProfile",mc_skillmanager.CreateNewProfile)
			
		
	gSMSwapA = Settings.GW2Minion.gSMSwapA
	gSMSwapR = Settings.GW2Minion.gSMSwapR
	gSMSwapCD = Settings.GW2Minion.gSMSwapCD
	gSMSwapRange = Settings.GW2Minion.gSMSwapRange
	gSMPrioKit = Settings.GW2Minion.gSMPrioKit
	gSMPrioAtt = Settings.GW2Minion.gSMPrioAtt
	gSMPrioAtt2 = Settings.GW2Minion.gSMPrioAtt2
	gSMPrioAtt3 = Settings.GW2Minion.gSMPrioAtt3
	gSMPrioAtt4 = Settings.GW2Minion.gSMPrioAtt4	
	gSMprofile = Settings.GW2Minion.gSMprofile
	gSMnewname = ""
  		
	GUI_SizeWindow(mc_skillmanager.mainwindow.name,mc_skillmanager.mainwindow.w,mc_skillmanager.mainwindow.h)
	GUI_UnFoldGroup(mc_skillmanager.mainwindow.name,mc_getstring("generalSettings"))
	GUI_WindowVisible(mc_skillmanager.mainwindow.name,false)
	
	
	-- EDITOR WINDOW
	GUI_NewWindow(mc_skillmanager.editwindow.name,mc_skillmanager.mainwindow.x+mc_skillmanager.mainwindow.w,mc_skillmanager.mainwindow.y,mc_skillmanager.editwindow.w,mc_skillmanager.editwindow.h)		
	GUI_NewField(mc_skillmanager.editwindow.name,mc_getstring("maMarkerName"),"SKM_NAME","SkillDetails")
	GUI_NewCheckbox(mc_skillmanager.editwindow.name,mc_getstring("initFight"),"SKM_ON","SkillDetails")
	GUI_NewCheckbox(mc_skillmanager.editwindow.name,mc_getstring("los"),"SKM_LOS","SkillDetails")
	GUI_NewCheckbox(mc_skillmanager.editwindow.name,mc_getstring("channeled"),"SKM_CHAN","SkillDetails")
	GUI_NewNumeric(mc_skillmanager.editwindow.name,mc_getstring("minRange"),"SKM_MinR","SkillDetails")
	GUI_NewNumeric(mc_skillmanager.editwindow.name,mc_getstring("maxRange"),"SKM_MaxR","SkillDetails")
	GUI_NewComboBox(mc_skillmanager.editwindow.name,mc_getstring("targetType"),"SKM_TType","SkillDetails","Enemy,Self");
	GUI_NewComboBox(mc_skillmanager.editwindow.name,mc_getstring("useOutOfCombat"),"SKM_OutOfCombat","SkillDetails","No,Yes,Either");
	GUI_NewNumeric(mc_skillmanager.editwindow.name,mc_getstring("playerHPGT"),"SKM_PHPL","SkillDetails");
	GUI_NewNumeric(mc_skillmanager.editwindow.name,mc_getstring("playerHPLT"),"SKM_PHPB","SkillDetails");
	GUI_NewNumeric(mc_skillmanager.editwindow.name,mc_getstring("playerPowerGT"),"SKM_PPowL","SkillDetails");
	GUI_NewNumeric(mc_skillmanager.editwindow.name,mc_getstring("playerPowerLT"),"SKM_PPowB","SkillDetails");
	GUI_NewField(mc_skillmanager.editwindow.name,mc_getstring("playerHas"),"SKM_PEff1","SkillDetails");	
	GUI_NewField(mc_skillmanager.editwindow.name,mc_getstring("playerHasNot"),"SKM_PNEff1","SkillDetails");	
	GUI_NewComboBox(mc_skillmanager.editwindow.name,mc_getstring("targetMoving"),"SKM_TMove","SkillDetails","Either,Yes,No");
	GUI_NewNumeric(mc_skillmanager.editwindow.name,mc_getstring("targetHPGT"),"SKM_THPL","SkillDetails");
	GUI_NewNumeric(mc_skillmanager.editwindow.name,mc_getstring("targetHPLT"),"SKM_THPB","SkillDetails");
	GUI_NewNumeric(mc_skillmanager.editwindow.name,mc_getstring("enemiesNearCount"),"SKM_TECount","SkillDetails");
	GUI_NewNumeric(mc_skillmanager.editwindow.name,mc_getstring("enemiesNearRange"),"SKM_TERange","SkillDetails");
	GUI_NewNumeric(mc_skillmanager.editwindow.name,mc_getstring("alliesNearCount"),"SKM_TACount","SkillDetails");
	GUI_NewNumeric(mc_skillmanager.editwindow.name,mc_getstring("alliesNearRange"),"SKM_TARange","SkillDetails");
	GUI_NewField(mc_skillmanager.editwindow.name,mc_getstring("targetHas"),"SKM_TEff1","SkillDetails");	
	GUI_NewField(mc_skillmanager.editwindow.name,mc_getstring("targetHasNot"),"SKM_TNEff1","SkillDetails");	
	GUI_NewNumeric(mc_skillmanager.editwindow.name,"Target has #Conditions >","SKM_TCondC","SkillDetails");
	GUI_NewNumeric(mc_skillmanager.editwindow.name,"Player has #Boons >","SKM_PBoonC","SkillDetails");
	GUI_NewNumeric(mc_skillmanager.editwindow.name,"Target has #Boons >","SKM_TBoonC","SkillDetails");
	
	GUI_UnFoldGroup(mc_skillmanager.editwindow.name,"SkillDetails")
	GUI_SizeWindow(mc_skillmanager.editwindow.name,mc_skillmanager.editwindow.w,mc_skillmanager.editwindow.h)
	GUI_WindowVisible(mc_skillmanager.editwindow.name,false)
	--[[SKM_NAME = ""
	SKM_ON = "0"
	SKM_Prio = 0
	SKM_LOS = "1"
	SKM_CHAN = "0"
	SKM_MinR = 0
	SKM_MaxR = 0
	SKM_TType = "Enemy"
	SKM_OutOfCombat = "Either"
	SKM_PHPL = 0
	SKM_PHPB = 0
	SKM_PPowL = 0
	SKM_PPowB = 0
	SKM_PEff1 = ""
	SKM_PCondC = 0
	SKM_PNEff1 = ""
	SKM_TMove = "Either"
	SKM_THPL = 0
	SKM_THPB = 0
	SKM_TECount = 0
	SKM_TERange = 0
	SKM_TACount = 0
	SKM_TARange = 0
	SKM_TEff1 = ""
	SKM_TNEff1 = ""
	SKM_TCondC = 0
	SKM_PBoonC = 0
	SKM_TBoonC = 0--]]
	
	GUI_NewButton(mc_skillmanager.editwindow.name,"DELETE","SMEDeleteEvent")
	RegisterEventHandler("SMEDeleteEvent",mc_skillmanager.EditorButtonHandler)	
	GUI_NewButton(mc_skillmanager.editwindow.name,"CLONE","SMECloneEvent")
	RegisterEventHandler("SMECloneEvent",mc_skillmanager.EditorButtonHandler)	
	GUI_NewButton(mc_skillmanager.editwindow.name,"DOWN","SMESkillDOWNEvent")	
	RegisterEventHandler("SMESkillDOWNEvent",mc_skillmanager.EditorButtonHandler)	
	GUI_NewButton(mc_skillmanager.editwindow.name,"UP","SMESkillUPEvent")
	RegisterEventHandler("SMESkillUPEvent",mc_skillmanager.EditorButtonHandler)
		
	mc_skillmanager.UpdateProfiles() -- Update the profiles dropdownlist
	GUI_DeleteGroup(mc_skillmanager.mainwindow.name,"ProfileSkills")
	mc_skillmanager.UpdateCurrentProfileData()	
end

function mc_skillmanager.UpdateCurrentProfileData()
    if ( gSMprofile ~= nil and gSMprofile ~= "" and gSMprofile ~= "None" ) then
        local profile = fileread(mc_skillmanager.profilepath..gSMprofile..".lua")
        if ( TableSize(profile) > 0) then
            local unsortedSkillList = {}			
            local newskill = {}            
			local i, line = next (profile)
            
			-- Profession Check			
			local _, key, id, value = string.match(line, "(%w+)_(%w+)_(%d+)=(.*)")
            if ( tostring(key) == "Profession" and tonumber(id) == Player.profession) then
                d("Skillprofile Profession matches Playerprofession, loading profile")
				
				
				
				
			else
				d("Skillprofile Profession DOES NOT match Playerprofession")
				d("key: "..tostring(key).." id:"..tostring(id))
            end
			
            if ( line ) then                
                while i and line do
                    local _, key, value = string.match(line, "(%w+)_(%w+)=(.*)")
                   	--d("key: "..tostring(key).." value:"..tostring(value))
                    
                    if ( key and value ) then
						value = string.gsub(value, "\r", "")					
						if ( key == "END" ) then
							--d("Adding Skill :"..newskill.name.."Prio:"..tostring(newskill.prio))
							table.insert(unsortedSkillList,tonumber(newskill.prio),newskill)						
							newskill = {}
							elseif ( key == "ID" )then newskill.skillID = tonumber(value)
							elseif ( key == "NAME" )then newskill.name = value
							elseif ( key == "ON" )then newskill.used = tostring(value)
							elseif ( key == "Prio" )then newskill.prio = tonumber(value)
							elseif ( key == "LOS" )then 
								if ( tostring(value) == "Yes" ) then newskill.los = "1" 
								elseif ( tostring(value) == "No" ) then newskill.los = "0" 
								else	newskill.los = tostring(value)
								end
							elseif ( key == "CHAN" )then newskill.channel = tostring(value)	
							elseif ( key == "MinR" )then newskill.minRange = tonumber(value)
							elseif ( key == "MaxR" )then newskill.maxRange = tonumber(value)
							elseif ( key == "TType" )then newskill.ttype = tostring(value)
							elseif ( key == "OutOfCombat" )then newskill.ooc = tostring(value)
							elseif ( key == "PHPL" )then newskill.phpl = tonumber(value)
							elseif ( key == "PHPB" )then newskill.phpb = tonumber(value)
							elseif ( key == "PPowL" )then newskill.ppowl = tonumber(value)
							elseif ( key == "PPowB" )then newskill.ppowb = tonumber(value)
							elseif ( key == "PEff1" )then newskill.peff1 = tostring(value)
							elseif ( key == "PNEff1" )then newskill.pneff1 = tostring(value)
							elseif ( key == "PCondC" )then newskill.pcondc = tonumber(value)												
							elseif ( key == "TMove" )then newskill.tmove = tostring(value)
							elseif ( key == "THPL" )then newskill.thpl = tonumber(value)
							elseif ( key == "THPB" )then newskill.thpb = tonumber(value)						
							elseif ( key == "TECount" )then newskill.tecount = tonumber(value)
							elseif ( key == "TERange" )then newskill.terange = tonumber(value)
							elseif ( key == "TACount" )then newskill.tacount = tonumber(value)
							elseif ( key == "TARange" )then newskill.tarange = tonumber(value)
							elseif ( key == "TEff1" )then newskill.teff1 = tostring(value)
							elseif ( key == "TNEff1" )then newskill.tneff1 = tostring(value)						
							elseif ( key == "TCondC" )then newskill.tcondc = tonumber(value)
							elseif ( key == "PBoonC" )then newskill.pboonc = tonumber(value)
							elseif ( key == "TBoonC" )then newskill.tboonc = tonumber(value)	
						end
					else
						mc_error("Error loading inputline: Key: "..(tostring(key)).." value:"..tostring(value))
					end				
					i, line = next (profile,i)
                end
            end
            
            -- Create UI Fields
            local sortedSkillList = {}
            if ( TableSize(unsortedSkillList) > 0 ) then
                local i,skill = next (unsortedSkillList)
                while i and skill do
                    sortedSkillList[#sortedSkillList+1] = skill
                    i,skill = next (unsortedSkillList,i)
                end
                table.sort(sortedSkillList, function(a,b) return a.prio < b.prio end )	
                for i = 1,TableSize(sortedSkillList),1 do					
                    if (sortedSkillList[i] ~= nil ) then
                        sortedSkillList[i].prio = i						
                        mc_skillmanager.CreateNewSkillEntry(sortedSkillList[i])
                    end
                end
            end
        else
            d("Profile is empty..")			
        end		
    else
        d("No new SkillProfile selected!")
		gSMprofile = "None"
    end
    GUI_UnFoldGroup(mc_skillmanager.mainwindow.name,"ProfileSkills")
end

function mc_skillmanager.GUIVarUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		--d(tostring(k).." = "..tostring(v))
		if (  k == "gSMSwapA" or 
			 k == "gSMSwapR" or 
			 k == "gSMSwapCD" or 
			 k == "gSMSwapRange" or 
			 k == "gSMPrioAtt" or
			 k == "gSMPrioAtt2" or
			 k == "gSMPrioAtt3" or
			 k == "gSMPrioAtt4" or			 			 
			 k == "gSMPrioKit") then			
			Settings.GW2Minion[tostring(k)] = v
		elseif ( k == "gSMprofile" ) then			
			mc_skillmanager.SkillRecordingActive = false				
			GUI_WindowVisible(mc_skillmanager.editwindow.name,false)
			GUI_DeleteGroup(mc_skillmanager.mainwindow.name,"ProfileSkills")
			mc_skillmanager.SkillProfile = {}
			mc_skillmanager.UpdateCurrentProfileData()
			Settings.GW2Minion.gSMprofile = tostring(v)
		elseif ( k == "SKM_NAME" ) then mc_skillmanager.SkillProfile[SKM_Prio].name = v
		elseif ( k == "SKM_ON" ) then mc_skillmanager.SkillProfile[SKM_Prio].used = v
		elseif ( k == "SKM_LOS" ) then mc_skillmanager.SkillProfile[SKM_Prio].los = v
		elseif ( k == "SKM_INSTA" ) then mc_skillmanager.SkillProfile[SKM_Prio].insta = v
		elseif ( k == "SKM_CHAN" ) then mc_skillmanager.SkillProfile[SKM_Prio].channel = v	
		elseif ( k == "SKM_MinR" ) then mc_skillmanager.SkillProfile[SKM_Prio].minRange = tonumber(v)
		elseif ( k == "SKM_MaxR" ) then mc_skillmanager.SkillProfile[SKM_Prio].maxRange = tonumber(v)
		elseif ( k == "SKM_TType" ) then mc_skillmanager.SkillProfile[SKM_Prio].ttype = v
		elseif ( k == "SKM_OutOfCombat" ) then mc_skillmanager.SkillProfile[SKM_Prio].ooc = v
		elseif ( k == "SKM_PHPL" ) then mc_skillmanager.SkillProfile[SKM_Prio].phpl = tonumber(v)
		elseif ( k == "SKM_PHPB" ) then mc_skillmanager.SkillProfile[SKM_Prio].phpb = tonumber(v)
		elseif ( k == "SKM_PPowL" ) then mc_skillmanager.SkillProfile[SKM_Prio].ppowl = tonumber(v)
		elseif ( k == "SKM_PPowB" ) then mc_skillmanager.SkillProfile[SKM_Prio].ppowb = tonumber(v)
		elseif ( k == "SKM_PEff1" ) then mc_skillmanager.SkillProfile[SKM_Prio].peff1 = v
		elseif ( k == "SKM_PCondC" ) then mc_skillmanager.SkillProfile[SKM_Prio].pcondc = tonumber(v)
		elseif ( k == "SKM_PNEff1" ) then mc_skillmanager.SkillProfile[SKM_Prio].pneff1 = v
		elseif ( k == "SKM_TMove" ) then mc_skillmanager.SkillProfile[SKM_Prio].tmove = v
		elseif ( k == "SKM_THPL" ) then mc_skillmanager.SkillProfile[SKM_Prio].thpl = tonumber(v)
		elseif ( k == "SKM_THPB" ) then mc_skillmanager.SkillProfile[SKM_Prio].thpb = tonumber(v)
		elseif ( k == "SKM_TECount" ) then mc_skillmanager.SkillProfile[SKM_Prio].tecount = tonumber(v)
		elseif ( k == "SKM_TERange" ) then mc_skillmanager.SkillProfile[SKM_Prio].terange = tonumber(v)
		elseif ( k == "SKM_TACount" ) then mc_skillmanager.SkillProfile[SKM_Prio].tacount = tonumber(v)
		elseif ( k == "SKM_TARange" ) then mc_skillmanager.SkillProfile[SKM_Prio].terange = tonumber(v)
		elseif ( k == "SKM_TEff1" ) then mc_skillmanager.SkillProfile[SKM_Prio].teff1 = v
		elseif ( k == "SKM_TNEff1" ) then mc_skillmanager.SkillProfile[SKM_Prio].tneff1 = v				
		elseif ( k == "SKM_TCondC" ) then mc_skillmanager.SkillProfile[SKM_Prio].tcondc = tonumber(v)
		elseif ( k == "SKM_PBoonC" ) then mc_skillmanager.SkillProfile[SKM_Prio].pboonc = tonumber(v)
		elseif ( k == "SKM_TBoonC" ) then mc_skillmanager.SkillProfile[SKM_Prio].tboonc = tonumber(v)					
		end
	end
end

function mc_skillmanager.EditorButtonHandler(event)
	mc_skillmanager.SkillRecordingActive = false
	if ( event == "SMECloneEvent") then
		local clone = deepcopy(mc_skillmanager.SkillProfile[SKM_Prio])
		clone.prio = table.maxn(mc_skillmanager.SkillProfile)+1
		mc_skillmanager.CreateNewSkillEntry(clone)
		
	elseif ( event == "SMEDeleteEvent") then				
		if ( TableSize(mc_skillmanager.SkillProfile) > 0 ) then
			GUI_Delete(mc_skillmanager.mainwindow.name,"ProfileSkills")
			local i,s = next ( mc_skillmanager.SkillProfile, SKM_Prio)
			while i and s do
				s.prio = s.prio - 1
				mc_skillmanager.SkillProfile[SKM_Prio] = s
				SKM_Prio = i
				i,s = next ( mc_skillmanager.SkillProfile, i)
			end
			mc_skillmanager.SkillProfile[SKM_Prio] = nil
			mc_skillmanager.RefreshSkillList()	
			GUI_WindowVisible(mc_skillmanager.editwindow.name,false)
		end
		
	elseif (event == "SMESkillUPEvent") then		
		if ( TableSize(mc_skillmanager.SkillProfile) > 0 ) then
			if ( SKM_Prio > 1) then
				GUI_Delete(mc_skillmanager.mainwindow.name,"ProfileSkills")
				local tmp = mc_skillmanager.SkillProfile[SKM_Prio-1]
				mc_skillmanager.SkillProfile[SKM_Prio-1] = mc_skillmanager.SkillProfile[SKM_Prio]
				mc_skillmanager.SkillProfile[SKM_Prio-1].prio = mc_skillmanager.SkillProfile[SKM_Prio-1].prio - 1
				mc_skillmanager.SkillProfile[SKM_Prio] = tmp
				mc_skillmanager.SkillProfile[SKM_Prio].prio = mc_skillmanager.SkillProfile[SKM_Prio].prio + 1
				SKM_Prio = SKM_Prio-1
				mc_skillmanager.RefreshSkillList()				
			end
		end
		
	elseif ( event == "SMESkillDOWNEvent") then			
		if ( TableSize(mc_skillmanager.SkillProfile) > 0 ) then
			if ( SKM_Prio < TableSize(mc_skillmanager.SkillProfile)) then
				GUI_Delete(mc_skillmanager.mainwindow.name,"ProfileSkills")		
				local tmp = mc_skillmanager.SkillProfile[SKM_Prio+1]
				mc_skillmanager.SkillProfile[SKM_Prio+1] = mc_skillmanager.SkillProfile[SKM_Prio]
				mc_skillmanager.SkillProfile[SKM_Prio+1].prio = mc_skillmanager.SkillProfile[SKM_Prio+1].prio + 1
				mc_skillmanager.SkillProfile[SKM_Prio] = tmp
				mc_skillmanager.SkillProfile[SKM_Prio].prio = mc_skillmanager.SkillProfile[SKM_Prio].prio - 1
				SKM_Prio = SKM_Prio+1
				mc_skillmanager.RefreshSkillList()						
			end
		end
	end
end

function mc_skillmanager.RefreshSkillList()	
	if ( TableSize( mc_skillmanager.SkillProfile ) > 0 ) then
		local i,s = next ( mc_skillmanager.SkillProfile )
		while i and s do
			mc_skillmanager.CreateNewSkillEntry(s)
			i,s = next ( mc_skillmanager.SkillProfile , i )
		end
	end
	GUI_UnFoldGroup(mc_skillmanager.mainwindow.name,"ProfileSkills")
end

function mc_skillmanager.SaveProfile()
	local filename = ""
    local isnew = false
    -- Save under new name if one was entered
    if ( gSMnewname ~= "" ) then
        filename = gSMnewname
        gSMnewname = ""
        isnew = true
    elseif (gSMprofile ~= nil and gSMprofile ~= "None" and gSMprofile ~= "") then
        filename = gSMprofile
        gSMnewname = ""		
    end
	
	 -- Save current Profiledata into the Profile-file 
    if ( filename ~= "" ) then
		d("Saving Profile Data into File: "..filename)
		local profession = Player.profession
		local string2write = "SKM_Profession_"..tostring(profession).."="..tostring(profession).."\n"
		local skID,skill = next (mc_skillmanager.SkillProfile)
		while skID and skill do
			string2write = string2write.."SKM_NAME="..skill.name.."\n"
			string2write = string2write.."SKM_ID="..skill.skillID.."\n"
			string2write = string2write.."SKM_ON="..skill.used.."\n"			
			string2write = string2write.."SKM_Prio="..skill.prio.."\n"
			string2write = string2write.."SKM_LOS="..skill.los.."\n"
			string2write = string2write.."SKM_CHAN="..skill.channel.."\n"			
			string2write = string2write.."SKM_MinR="..skill.minRange.."\n"
			string2write = string2write.."SKM_MaxR="..skill.maxRange.."\n" 
			string2write = string2write.."SKM_TType="..skill.ttype.."\n"
			string2write = string2write.."SKM_OutOfCombat="..skill.ooc.."\n"
			string2write = string2write.."SKM_PHPL="..skill.phpl.."\n" 
			string2write = string2write.."SKM_PHPB="..skill.phpb.."\n" 
			string2write = string2write.."SKM_PPowL="..skill.ppowl.."\n" 
			string2write = string2write.."SKM_PPowB="..skill.ppowb.."\n" 
			string2write = string2write.."SKM_PEff1="..skill.peff1.."\n" 
			string2write = string2write.."SKM_PCondC="..skill.pcondc.."\n" 
			string2write = string2write.."SKM_PNEff1="..skill.pneff1.."\n" 								
			string2write = string2write.."SKM_TMove="..skill.tmove.."\n" 
			string2write = string2write.."SKM_THPL="..skill.thpl.."\n" 
			string2write = string2write.."SKM_THPB="..skill.thpb.."\n" 
			string2write = string2write.."SKM_TECount="..skill.tecount.."\n" 
			string2write = string2write.."SKM_TERange="..skill.terange.."\n" 
			string2write = string2write.."SKM_TACount="..skill.tacount.."\n" 
			string2write = string2write.."SKM_TARange="..skill.terange.."\n" 	
			string2write = string2write.."SKM_TEff1="..skill.teff1.."\n" 
			string2write = string2write.."SKM_TNEff1="..skill.tneff1.."\n" 
			string2write = string2write.."SKM_TCondC="..skill.tcondc.."\n" 
			string2write = string2write.."SKM_PBoonC="..skill.pboonc.."\n" 
			string2write = string2write.."SKM_TBoonC="..skill.tboonc.."\n"					
			string2write = string2write.."SKM_END=0\n"
		
			skID,skill = next (mc_skillmanager.SkillProfile,skID)
		end	
		d(filewrite(mc_skillmanager.profilepath ..filename..".lua",string2write))
		
		if ( isnew ) then
            gSMprofile_listitems = gSMprofile_listitems..","..filename
            gSMprofile = filename
            Settings.GW2Minion.gSMprofile = filename
        end
	else
		mc_error("You need to enter a new Filename first!!")
	end
end

function mc_skillmanager.CreateNewProfile()
	-- Delete existing Skills
    GUI_DeleteGroup(mc_skillmanager.mainwindow.name,"ProfileSkills")
    gSMprofile = "None"
    Settings.GW2Minion.gSMprofile = gSMprofile
    gSMnewname = ""	
	mc_skillmanager.SkillProfile = {}
end

function mc_skillmanager.AutoDetectSkills()
	mc_skillmanager.RecordSkillTmr = mc_global.now
	mc_skillmanager.SkillRecordingActive = true
end

function mc_skillmanager.UpdateProfiles()
	-- Grab all Profiles and enlist them in the dropdown field
	local profiles = "None"
	local found = "None"	
	local profilelist = dirlist(mc_skillmanager.profilepath,".*lua")
	if ( TableSize(profilelist) > 0) then			
		local i,profile = next ( profilelist)
		while i and profile do				
			profile = string.gsub(profile, ".lua", "")
			--d("Skillprofile: "..tostring(profile).." == "..tostring(gSMnewname))
			
			-- Make sure it matches our profession
			local file = fileread(mc_skillmanager.profilepath..profile..".lua")
			if ( TableSize(file) > 0) then
				local i, line = next (file)					
				local _, key, id, value = string.match(line, "(%w+)_(%w+)_(%d+)=(.*)")
				if ( tostring(key) == "Profession" and tonumber(id) == Player.profession) then
					profiles = profiles..","..profile
					if ( Settings.GW2Minion.gSMprofile ~= nil and Settings.GW2Minion.gSMprofile == profile ) then
						d("Last Profile found : "..profile)
						found = profile
					end					
				end
			end
			i,profile = next ( profilelist,i)
		end		
	else
		mc_error("No Skillmanager profiles for our current Profession found")
	end
	gSMprofile_listitems = profiles
	gSMprofile = found
end

function mc_skillmanager.CheckForNewSkills()
	for i = 1, 16, 1 do
		local skill = Player:GetSpellInfo(GW2.SKILLBARSLOT["Slot_" .. i])
		if ( skill ~= nil ) then
			local skID = skill.skillID
			if ( skID ) then
				local found = false
				if ( TableSize( mc_skillmanager.SkillProfile ) > 0 ) then
					local i,s = next ( mc_skillmanager.SkillProfile )
					while i and s do
						if s.skillID == skID then
							found = true
							break
						end
						i,s = next ( mc_skillmanager.SkillProfile , i )
					end
				end
				if not found then
					mc_skillmanager.CreateNewSkillEntry(skill)
				end
			end			
		end
	end
	GUI_UnFoldGroup(mc_skillmanager.mainwindow.name,"ProfileSkills")
end

function mc_skillmanager.CreateNewSkillEntry(skill)	
	if (skill ~= nil ) then
		local skname = skill.name
		local skID = skill.skillID		
		if (skname ~= "" and skID ) then
			local newskillprio = skill.prio or table.maxn(mc_skillmanager.SkillProfile)+1
			local bevent = tostring(newskillprio)
			
			GUI_NewButton(mc_skillmanager.mainwindow.name, tostring(bevent)..": "..skname, bevent,"ProfileSkills")
			if ( mc_skillmanager.RegisteredButtonEventList[newskillprio] == nil ) then
				RegisterEventHandler(bevent,mc_skillmanager.EditSkill)
				mc_skillmanager.RegisteredButtonEventList[newskillprio] = 1
			end	
			
			mc_skillmanager.SkillProfile[newskillprio] = {		
				skillID = skID,
				prio = newskillprio,
				name = skname,
				used = skill.used or "1",		
				los = skill.los or "1",
				channel = skill.channel or "0",
				minRange = skill.minRange or 0,
				maxRange = skill.maxRange or 0,
				ttype = skill.ttype or "Enemy",
				ooc = skill.ooc or "No",
				phpl = skill.phpl or 0,
				phpb = skill.phpb or 0,
				ppowl = skill.ppowl or 0,
				ppowb = skill.ppowb or 0,
				peff1 = skill.peff1 or "",
				pcondc = skill.pcondc or 0,
				pneff1 = skill.pneff1 or "",
				tmove = skill.tmove or "Either",
				thpl = skill.thpl or 0,
				thpb = skill.thpb or 0,
				tecount = skill.tecount or 0,
				terange = skill.terange or 0,
				tacount = skill.tacount or 0,
				tarange = skill.tarange or 0,
				teff1 = skill.teff1 or "",
				tneff1 = skill.tneff1 or "",
				tcondc = skill.condc or 0,
				pboonc = skill.pboonc or 0,
				tboonc = skill.tboonc or 0
			}		
		end		
	end
end

function mc_skillmanager.EditSkill(event)
	local wnd = GUI_GetWindowInfo(mc_skillmanager.mainwindow.name)	
	GUI_MoveWindow( mc_skillmanager.editwindow.name, wnd.x+wnd.width,wnd.y) 
	GUI_WindowVisible(mc_skillmanager.editwindow.name,true)
	-- Update EditorData
	local skill = mc_skillmanager.SkillProfile[tonumber(event)]	
	if ( skill ) then		
		SKM_NAME = skill.name or ""
		SKM_ON = skill.used or "1"
		SKM_Prio = tonumber(event)
		SKM_LOS = skill.los or "1"
		SKM_CHAN = skill.channel or "0"
		SKM_MinR = tonumber(skill.minRange) or 0
		SKM_MaxR = tonumber(skill.maxRange) or 160
		SKM_TType = skill.ttype or "Either"
		SKM_OutOfCombat = skill.ooc or "No"
		SKM_PHPL = tonumber(skill.phpl) or 0
		SKM_PHPB = tonumber(skill.phpb) or 0
		SKM_PPowL = tonumber(skill.ppowl) or 0
		SKM_PPowB = tonumber(skill.ppowb) or 0
		SKM_PEff1 = skill.peff1 or ""
		SKM_PCondC = tonumber(skill.pcondc) or 0
		SKM_PNEff1 = skill.pneff1 or ""
		SKM_TMove = skill.tmove or "Either"
		SKM_THPL = tonumber(skill.thpl) or 0
		SKM_THPB = tonumber(skill.thpb) or 0
		SKM_TECount = tonumber(skill.tecount) or 0
		SKM_TERange = tonumber(skill.terange) or 0
		SKM_TACount = tonumber(skill.tacount) or 0
		SKM_TARange = tonumber(skill.terange) or 0
		SKM_TEff1 = skill.teff1 or ""
		SKM_TNEff1 = skill.tneff1 or ""
		SKM_TCondC = tonumber(skill.tcondc) or 0
		SKM_PBoonC = tonumber(skill.pboonc) or 0
		SKM_TBoonC = tonumber(skill.tboonc) or 0
	end
end


function mc_skillmanager.OnUpdate( tick )
	
	if ( mc_skillmanager.SkillRecordingActive ) then
		if ( tick - mc_skillmanager.RecordSkillTmr > 30000) then -- max record 30seconds
			mc_skillmanager.RecordSkillTmr = 0
			mc_skillmanager.SkillRecordingActive = false
		elseif ( tick - mc_skillmanager.RecordSkillTmr > 500 ) then
			mc_skillmanager.RecordSkillTmr = tick
			mc_skillmanager.CheckForNewSkills()
		end		
	end
	
end

function mc_skillmanager.ToggleMenu()
	if (mc_skillmanager.visible) then
		GUI_WindowVisible(mc_skillmanager.mainwindow.name,false)	
		mc_skillmanager.visible = false
	else
		local wnd = GUI_GetWindowInfo("MinionBot")	
		GUI_MoveWindow( mc_skillmanager.mainwindow.name, wnd.x+wnd.width,wnd.y) 
		GUI_WindowVisible(mc_skillmanager.mainwindow.name,true)	
		mc_skillmanager.visible = true
	end
end


--DOTO: Check if SM profile is loaded and go through all spells which are set to be used as opener
function mc_skillmanager.GetAttackRange()
	local maxrange = 180
	for i = 1, 9, 1 do
		if ( i ~= 4 ) then -- dont use elite 
			local skill = Player:GetSpellInfo(GW2.SKILLBARSLOT["Slot_" .. i])
			if ( skill ~= nil ) then				

				if ( i == 1 ) then
					maxrange = skill.maxRange or 180
				else
					if ( not skill.cooldown and skill.maxRange > maxrange) then
						maxrange = skill.maxRange
					end
				end				
			end
		end
	end
	return maxrange
end

function mc_skillmanager.AttackTarget( TargetID )
	mc_skillmanager.cskills = {} -- Current List of Skills

d("CHECK0")	

	for i = 1, 16, 1 do
		local skill = Player:GetSpellInfo(GW2.SKILLBARSLOT["Slot_" .. i])
		if ( skill ~= nil ) then			
			mc_skillmanager.cskills[i] = skill
			mc_skillmanager.cskills[i].slot = GW2.SKILLBARSLOT["Slot_" .. i]
			
			--Find this skill in our SkillProfile and get its prio into the CurrentListOfSkills
			for k,v in pairs(mc_skillmanager.SkillProfile) do
				if v.skillID == mc_skillmanager.cskills[i].skillID then
					mc_skillmanager.cskills[i].prio = v.prio					
					break
				end
			end			
		end
	end
d("CHECK1")
	
	--Valid Target?
	local target
	if ( not TargetID or TargetID == 0) then
		target = Player:GetTarget()
		if ( target ) then TargetID = target.id end
	else
		target = CharacterList:Get(TargetID)
		if ( not target ) then 			 
			target = GadgetList:Get(TargetID)
		end		
	end
	
	d("CHECK2")
	if ( target and TargetID and target.attackable ) then
		
		local mybuffs = Player.buffs
		local targetbuffs = target.buffs
		d("CHECK3")
		if ( TableSize(mc_skillmanager.SkillProfile) > 0 ) then
			for prio,skill in pairs(mc_skillmanager.SkillProfile) do
				
				--Try to find this skill in our current Skill List
				local currentSlot = 0
				for i = 0, 16, 1 do
					if ( mc_skillmanager.cskills[i] and mc_skillmanager.cskills[i].skillID == skill.skillID and mc_skillmanager.cskills[i].cooldown == 0) then
						currentSlot = i
						break
					end
				end
				if ( currentSlot > 0 ) then
					d("Cast Slot "..tostring(currentSlot))
					
				
				end				
			end
		end
	end
end



RegisterEventHandler("SkillManager.toggle", mc_skillmanager.ToggleMenu)
RegisterEventHandler("GUI.Update",mc_skillmanager.GUIVarUpdate)
RegisterEventHandler("Module.Initalize",mc_skillmanager.ModuleInit)