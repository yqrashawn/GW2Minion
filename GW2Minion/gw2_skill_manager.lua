gw2_skill_manager = {}
gw2_skill_manager.mainWindow = {name = GetString("skillManager"), x = 350, y = 50, w = 250, h = 350}
gw2minion.MainWindow.ChildWindows[gw2_skill_manager.mainWindow.name] = gw2_skill_manager.mainWindow.name
gw2_skill_manager.skillEditWindow = {name = GetString("skillEditor"), x = 600, y = 50, w = 250, h = 550}
gw2minion.MainWindow.ChildWindows[gw2_skill_manager.skillEditWindow.name] = gw2_skill_manager.skillEditWindow.name
gw2_skill_manager.comboEditWindow = {name = GetString("comboEditor"), x = 600, y = 50, w = 250, h = 350}
gw2minion.MainWindow.ChildWindows[gw2_skill_manager.comboEditWindow.name] = gw2_skill_manager.comboEditWindow.name
gw2_skill_manager.comboSkillEditWindow = {name = GetString("comboSkillEditor"), x = 850, y = 50, w = 250, h = 550}
gw2minion.MainWindow.ChildWindows[gw2_skill_manager.comboSkillEditWindow.name] = gw2_skill_manager.comboSkillEditWindow.name
gw2_skill_manager.path = GetAddonPath() .. [[GW2Minion\SkillManagerProfiles\]]
gw2_skill_manager.profile = nil
gw2_skill_manager.currentSkill = nil
gw2_skill_manager.currentCombo = nil
gw2_skill_manager.currentComboSkill = nil
gw2_skill_manager.groupsDeleted = true
gw2_skill_manager.groupsCreated = true
gw2_skill_manager.skillsDeleted = true
gw2_skill_manager.skillsCreated = true
gw2_skill_manager.openSkills = false
gw2_skill_manager.openCombos = false
gw2_skill_manager.detecting = false
gw2_skill_manager.attacking = false
gw2_skill_manager.lastAttack = 0
local _private = {}
local profilePrototype = {}

-- Init module
function gw2_skill_manager.ModuleInit()
	if (Settings.GW2Minion.gCurrentProfile == nil) then
		Settings.GW2Minion.gCurrentProfile = "None"
	end
	
	local dw = WindowManager:GetWindow(gw2minion.DebugWindow.Name)
	if ( dw ) then
		dw:NewField("CurrentAction","gSMCurrentAction","SkillManager")
		dw:NewField("CurrentCast","gSMCurrentCast","SkillManager")
		
	end
	
	gw2_skill_manager.profile = gw2_skill_manager.GetProfile(Settings.GW2Minion.gCurrentProfile)
	gMoveIntoCombatRange = Settings.GW2Minion.gMoveIntoCombatRange
end
RegisterEventHandler("Module.Initalize",gw2_skill_manager.ModuleInit)

function gw2_skill_manager.GetProfile(profileName)
	if (GetGameState() == 16) then
		if (profileName == nil or profileName == "None") then return false end
		profileName = string.gsub(profileName,'%W','')
		profileName = table_invert(GW2.CHARCLASS)[Player.profession] .. "_" .. profileName
		local profile = persistence.load(gw2_skill_manager.path .. profileName .. ".lua")
		if (profile) then
			setmetatable(profile, {__index = profilePrototype})
			return profile
		end
	end
end

function gw2_skill_manager.NewProfile(profileName)
	if (GetGameState() == 16) then
		if (profileName == nil or profileName == "None") then return false end
		local list = _private.GetProfileList()
		for name in StringSplit(list,",") do
			if (name == profileName) then return gw2_skill_manager.GetProfile(profileName) end
		end
		profileName = string.gsub(profileName,'%W','')
		profileName = table_invert(GW2.CHARCLASS)[ml_global_information.Player_Profession] .. "_" .. profileName
		local newProfile = {
			name = profileName,
			profession = ml_global_information.Player_Profession,
			professionSettings = {
				priorityKit = "None",
				PriorityAtt1 = "None",
				PriorityAtt2 = "None",
				PriorityAtt3 = "None",
				PriorityAtt4 = "None",
			},
			switchSettings = {
				switchOnRange = "0",
				switchRandom = "0",
				switchOnCooldown = "0",
			},
			skills = {},
			combos = {},
			clipboard = nil,
		}
		setmetatable(newProfile, {__index = profilePrototype})
		return newProfile
	end
end

function gw2_skill_manager.ToggleMenu()
	gw2_skill_manager.MainWindow()
	local mainWindow = WindowManager:GetWindow(gw2_skill_manager.mainWindow.name)
	if (mainWindow) then
		if ( mainWindow.visible ) then
			mainWindow:Hide()
			local editWindow = WindowManager:GetWindow(gw2_skill_manager.skillEditWindow.name)
			if ( editWindow ) then 
				editWindow:Hide()
			end
		else
			local wnd = WindowManager:GetWindow(gw2minion.MainWindow.Name)
			if ( wnd ) then
				mainWindow:SetPos(wnd.x+wnd.width,wnd.y)
				mainWindow:Show()
			end
		end
	end
end

function gw2_skill_manager.Attack(target)
	if (gw2_skill_manager.profile) then
		gw2_skill_manager.profile:Attack(target)
	end
end

function gw2_skill_manager.Heal()
	if (gw2_skill_manager.profile) then
		gw2_skill_manager.profile:Heal()
	end
end

function gw2_skill_manager.GetMaxAttackRange()
	if ( gw2_skill_manager.profile ) then
		return gw2_skill_manager.profile:GetAttackRange()
	else
		return 154
	end
end

function gw2_skill_manager.UpdateSkillInfo()
	if ( gw2_skill_manager.profile ) then
		gw2_skill_manager.profile:UpdateSkillInfo()
	end
end

function gw2_skill_manager.GUIVarUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		-- Changes in skills
		-- Skill change
		if (
				--k == "SklMgr_GrndTarget" or
				k == "SklMgr_HealnBuff" or
				k == "SklMgr_LOS" or
				k == "SklMgr_SetRange" or
				k == "SklMgr_MinRange" or
				k == "SklMgr_MaxRange" or
				k == "SklMgr_Radius" or
				k == "SklMgr_SlowCast" or
				k == "SklMgr_LastSkillID" or
				k == "SklMgr_Delay")
			then
			local var = {	--SklMgr_GrndTarget = {global = "groundTargeted", gType = "tostring",},
							SklMgr_HealnBuff = {global = "healing", gType = "tostring",},
							SklMgr_LOS = {global = "los", gType = "tostring",},
							SklMgr_SetRange = {global = "setRange", gType = "tostring",},
							SklMgr_MinRange = {global = "minRange", gType = "tonumber",},
							SklMgr_MaxRange = {global = "maxRange", gType = "tonumber",},
							SklMgr_Radius = {global = "radius", gType = "tonumber",},
							SklMgr_SlowCast = {global = "slowCast", gType = "tostring",},
							SklMgr_LastSkillID = {global = "lastSkillID", gType = "tonumber",},
							SklMgr_Delay = {global = "delay", gType = "tonumber",},
			}
			gw2_skill_manager.profile.skills[gw2_skill_manager.currentSkill].skill[var[k].global] = _G[var[k].gType](v)
		-- Player change
		elseif (
				k == "SklMgr_CombatState" or
				k == "SklMgr_PMinHP" or
				k == "SklMgr_PMaxHP" or
				k == "SklMgr_MinPower" or
				k == "SklMgr_MaxPower" or
				k == "SklMgr_MinEndurance" or
				k == "SklMgr_MaxEndurance" or
				k == "SklMgr_AllyCount" or
				k == "SklMgr_AllyRange" or
				k == "SklMgr_PHasBuffs" or
				k == "SklMgr_PHasNotBuffs" or
				k == "SklMgr_PCondCount" or
				k == "SklMgr_PBoonCount")
			then
			local var = {	SklMgr_CombatState = {global = "combatState", gType = "tostring",},
							SklMgr_PMinHP = {global = "minHP", gType = "tonumber",},
							SklMgr_PMaxHP = {global = "maxHP", gType = "tonumber",},
							SklMgr_MinPower = {global = "minPower", gType = "tonumber",},
							SklMgr_MaxPower = {global = "maxPower", gType = "tonumber",},
							SklMgr_MinEndurance = {global = "minEndurance", gType = "tonumber",},
							SklMgr_MaxEndurance = {global = "maxEndurance", gType = "tonumber",},
							SklMgr_AllyCount = {global = "allyNearCount", gType = "tonumber",},
							SklMgr_AllyRange = {global = "allyRangeMax", gType = "tonumber",},
							SklMgr_PHasBuffs = {global = "hasBuffs", gType = "tostring",},
							SklMgr_PHasNotBuffs = {global = "hasNotBuffs", gType = "tostring",},
							SklMgr_PCondCount = {global = "conditionCount", gType = "tonumber",},
							SklMgr_PBoonCount = {global = "boonCount", gType = "tonumber",},
			}
			gw2_skill_manager.profile.skills[gw2_skill_manager.currentSkill].player[var[k].global] = _G[var[k].gType](v)
		-- Target change
		elseif (
				k == "SklMgr_Type" or
				k == "SklMgr_TMinHP" or
				k == "SklMgr_TMaxHP" or
				k == "SklMgr_EnemyCount" or
				k == "SklMgr_EnemyRange" or
				k == "SklMgr_Moving" or
				k == "SklMgr_THasBuffs" or
				k == "SklMgr_THasNotBuffs" or
				k == "SklMgr_TCondCount" or
				k == "SklMgr_TBoonCount")
			then
			local var = {	SklMgr_Type = {global = "type", gType = "tostring",},
							SklMgr_TMinHP = {global = "minHP", gType = "tonumber",},
							SklMgr_TMaxHP = {global = "maxHP", gType = "tonumber",},
							SklMgr_EnemyCount = {global = "enemyNearCount", gType = "tonumber",},
							SklMgr_EnemyRange = {global = "enemyRangeMax", gType = "tonumber",},
							SklMgr_Moving = {global = "moving", gType = "tostring",},
							SklMgr_THasBuffs = {global = "hasBuffs", gType = "tostring",},
							SklMgr_THasNotBuffs = {global = "hasNotBuffs", gType = "tostring",},
							SklMgr_TCondCount = {global = "conditionCount", gType = "tonumber",},
							SklMgr_TBoonCount = {global = "boonCount", gType = "tonumber",},
			}
			gw2_skill_manager.profile.skills[gw2_skill_manager.currentSkill].target[var[k].global] = _G[var[k].gType](v)
		elseif (k == "gSMSwitchOnRange") then
			gw2_skill_manager.profile.switchSettings.switchOnRange = v
		elseif (k == "gSMSwitchRandom") then
			gw2_skill_manager.profile.switchSettings.switchRandom = v
		elseif (k == "gSMSwitchOnCooldown") then
			gw2_skill_manager.profile.switchSettings.switchOnCooldown = v
		elseif (k == "gSMPrioKit") then
			gw2_skill_manager.profile.professionSettings.priorityKit = v
		elseif (k == "gSMPrioAtt1") then
			gw2_skill_manager.profile.professionSettings.PriorityAtt1 = v
		elseif (k == "gSMPrioAtt2") then
			gw2_skill_manager.profile.professionSettings.PriorityAtt2 = v
		elseif (k == "gSMPrioAtt3") then
			gw2_skill_manager.profile.professionSettings.PriorityAtt3 = v
		elseif (k == "gSMPrioAtt4") then
			gw2_skill_manager.profile.professionSettings.PriorityAtt4 = v
		elseif (k == "gSMCurrentProfileName") then
			gw2_skill_manager.profile = gw2_skill_manager.GetProfile(gSMCurrentProfileName)
			gw2_skill_manager.detecting = false
			gw2_skill_manager.MainWindow()
			gw2_skill_manager.currentSkill = nil
			gw2_skill_manager.SkillEditWindow()
			Settings.GW2Minion.gCurrentProfile = gSMCurrentProfileName
		end
	end
end
RegisterEventHandler("GUI.Update",gw2_skill_manager.GUIVarUpdate)

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- **window functions**
function gw2_skill_manager.MainWindow(openSkills,openCombos)
	local mainWindow = WindowManager:GetWindow(gw2_skill_manager.mainWindow.name)
	if (mainWindow == nil) then
		gw2_skill_manager.CreateMainWindow()
		mainWindow = WindowManager:GetWindow(gw2_skill_manager.mainWindow.name)
	end
	if (mainWindow) then
		if (gw2_skill_manager.profile) then
			gw2_skill_manager.openSkills = openSkills
			gw2_skill_manager.openCombos = openCombos
			gw2_skill_manager.groupsDeleted = false
			gw2_skill_manager.groupsCreated = false
			gw2_skill_manager.skillsDeleted = false
			gw2_skill_manager.skillsCreated = false
		else
			gw2_skill_manager.groupsDeleted = false
			gw2_skill_manager.skillsDeleted = false
			gSMCurrentProfileName_listitems = _private.GetProfileList()
			gSMCurrentProfileName = "None"
		end
	end
end

function gw2_skill_manager.UpdateSkillsMainWindow(openSkills)
	gw2_skill_manager.skillsDeleted = false
	gw2_skill_manager.skillsCreated = false
	gw2_skill_manager.openSkills = openSkills
end

function gw2_skill_manager.CreateMainWindow()
	-- Init Main Window
	mainWindow = WindowManager:NewWindow(gw2_skill_manager.mainWindow.name,gw2_skill_manager.mainWindow.x,gw2_skill_manager.mainWindow.y,gw2_skill_manager.mainWindow.w,gw2_skill_manager.mainWindow.h,false)
	-- Settings section
	mainWindow:NewComboBox(GetString("profile"),"gSMCurrentProfileName",GetString("settings"),_private.GetProfileList())
	gSMCurrentProfileName = "None"
	mainWindow:NewButton(GetString("newProfile"),"gSMNewProfile",GetString("settings"))
	RegisterEventHandler("gSMNewProfile",gw2_skill_manager.NewProfileDialog)
	local bb = mainWindow:NewButton(GetString("autoDetectSkills"),"gSMDetectSkills")
	bb:SetToggleState(false)
	RegisterEventHandler("gSMDetectSkills",_private.DetectSkills)
	mainWindow:NewButton(GetString("deleteProfile"),"gSMDeleteProfile")
	RegisterEventHandler("gSMDeleteProfile",_private.Delete)
	mainWindow:NewButton(GetString("smCloneProfile"),"gSMCloneProfile")
	RegisterEventHandler("gSMCloneProfile",gw2_skill_manager.CloneProfileDialog)
	mainWindow:NewButton(GetString("saveProfile"),"gSMSaveProfile")
	RegisterEventHandler("gSMSaveProfile",_private.Save)
	mainWindow:UnFold(GetString("settings"))
	
	mainWindow:Hide()
end

function gw2_skill_manager.UpdateMainWindowGroups()
	if (gw2_skill_manager.groupsDeleted == false) then
		mainWindow:DeleteGroup(GetString("ProfessionSettings"))
		mainWindow:DeleteGroup(GetString("comboList"))
		mainWindow:DeleteGroup(GetString("smSwitchSettings"))
		gw2_skill_manager.groupsDeleted = true
		return true
	elseif (gw2_skill_manager.groupsCreated == false) then
		local name = gw2_skill_manager.profile.name
		name = string.sub(name,select(2,string.find(name,"_"))+1,#name)
		gSMCurrentProfileName_listitems = _private.GetProfileList(name)
		gSMCurrentProfileName = name
		
		mainWindow:NewCheckBox(GetString("SwapRange"),"gSMSwitchOnRange",GetString("smSwitchSettings"))
		gSMSwitchOnRange = gw2_skill_manager.profile.switchSettings.switchOnRange
		mainWindow:NewCheckBox(GetString("SwapR"),"gSMSwitchRandom",GetString("smSwitchSettings"))
		gSMSwitchRandom = gw2_skill_manager.profile.switchSettings.switchRandom
		mainWindow:NewNumeric(GetString("SwapCD"),"gSMSwitchOnCooldown",GetString("smSwitchSettings"),0,25)
		gSMSwitchOnCooldown = gw2_skill_manager.profile.switchSettings.switchOnCooldown
		
		local profession = ml_global_information.Player_Profession
		if (profession) then
			if (profession == GW2.CHARCLASS.Engineer) then
				mainWindow:NewComboBox(GetString("PrioritizeKit"),"gSMPrioKit",GetString("ProfessionSettings"),"None,BombKit,FlameThrower,GrenadeKit,ToolKit,ElixirGun")
				gSMPrioKit = gw2_skill_manager.profile.professionSettings.priorityKit
			elseif(profession == GW2.CHARCLASS.Elementalist) then
				mainWindow:NewComboBox(GetString("PriorizeAttunement1"),"gSMPrioAtt1",GetString("ProfessionSettings"),"None,Fire,Water,Air,Earth")
				mainWindow:NewComboBox(GetString("PriorizeAttunement2"),"gSMPrioAtt2",GetString("ProfessionSettings"),"None,Fire,Water,Air,Earth")
				mainWindow:NewComboBox(GetString("PriorizeAttunement3"),"gSMPrioAtt3",GetString("ProfessionSettings"),"None,Fire,Water,Air,Earth")
				mainWindow:NewComboBox(GetString("PriorizeAttunement4"),"gSMPrioAtt4",GetString("ProfessionSettings"),"None,Fire,Water,Air,Earth")
				gSMPrioAtt1 = gw2_skill_manager.profile.professionSettings.PriorityAtt1
				gSMPrioAtt2 = gw2_skill_manager.profile.professionSettings.PriorityAtt2
				gSMPrioAtt3 = gw2_skill_manager.profile.professionSettings.PriorityAtt3
				gSMPrioAtt4 = gw2_skill_manager.profile.professionSettings.PriorityAtt4
			end
		end
		gw2_skill_manager.groupsCreated = true
		return true
	end
end

function gw2_skill_manager.UpdateMainWindowSkills()
	if (gw2_skill_manager.skillsDeleted == false) then
		mainWindow:DeleteGroup(GetString("smSkillList"))
		gw2_skill_manager.skillsDeleted = true
		return true
	elseif (gw2_skill_manager.skillsCreated == false) then
		for _,skill in ipairs(gw2_skill_manager.profile.skills) do
			mainWindow:NewButton(skill.priority .. ": " .. skill.skill.name,"SkillEditWindowButton"..skill.priority,GetString("smSkillList"))
			RegisterEventHandler("SkillEditWindowButton"..skill.priority,gw2_skill_manager.SkillEditWindow)
		end
		if (gw2_skill_manager.openSkills) then mainWindow:UnFold(GetString("smSkillList")) end
		gw2_skill_manager.skillsCreated = true
		return true
	end
end

function gw2_skill_manager.SkillEditWindow(skill)
	local editWindow = WindowManager:GetWindow(gw2_skill_manager.skillEditWindow.name)
	if (editWindow == nil) then
		-- Init Edit Window
		editWindow = WindowManager:NewWindow(gw2_skill_manager.skillEditWindow.name,gw2_skill_manager.skillEditWindow.x,gw2_skill_manager.skillEditWindow.y,gw2_skill_manager.skillEditWindow.w,gw2_skill_manager.skillEditWindow.h,true)
		-- Skill Section
		editWindow:NewNumeric(GetString("smSkillID"),"SklMgr_ID",GetString("smSkill"))
		editWindow:NewField(GetString("name"),"SklMgr_Name",GetString("smSkill"))
		--editWindow:NewCheckBox(GetString("isGroundTargeted"),"SklMgr_GrndTarget",GetString("smSkill"))
		editWindow:NewCheckBox(GetString("smHealBuff"),"SklMgr_HealnBuff",GetString("smSkill"))
		editWindow:NewCheckBox(GetString("los"),"SklMgr_LOS",GetString("smSkill"))
		editWindow:NewCheckBox(GetString("smSetRange"),"SklMgr_SetRange",GetString("smSkill"))
		editWindow:NewNumeric(GetString("minRange"),"SklMgr_MinRange",GetString("smSkill"),0,6000)
		editWindow:NewNumeric(GetString("maxRange"),"SklMgr_MaxRange",GetString("smSkill"),0,6000)
		editWindow:NewNumeric(GetString("smRadius"),"SklMgr_Radius",GetString("smSkill"),0,6000)
		editWindow:NewCheckBox(GetString("smSlowCast"),"SklMgr_SlowCast",GetString("smSkill"))
		editWindow:NewField(GetString("prevSkillID"),"SklMgr_LastSkillID",GetString("smSkill"))
		editWindow:NewNumeric(GetString("smDelay"),"SklMgr_Delay",GetString("smSkill"))
		-- Player Section
		editWindow:NewComboBox(GetString("useOutOfCombat"),"SklMgr_CombatState",GetString("smPlayer"),"Either,InCombat,OutCombat")
		editWindow:NewNumeric(GetString("playerHPLT"),"SklMgr_PMinHP",GetString("smPlayer"),0,100)
		editWindow:NewNumeric(GetString("playerHPGT"),"SklMgr_PMaxHP",GetString("smPlayer"),0,99)
		editWindow:NewNumeric(GetString("playerPowerLT"),"SklMgr_MinPower",GetString("smPlayer"),0,100)
		editWindow:NewNumeric(GetString("playerPowerGT"),"SklMgr_MaxPower",GetString("smPlayer"),0,99)
		editWindow:NewNumeric(GetString("playerEnduranceLT"),"SklMgr_MinEndurance",GetString("smPlayer"),0,100)
		editWindow:NewNumeric(GetString("playerEnduranceGT"),"SklMgr_MaxEndurance",GetString("smPlayer"),0,99)
		editWindow:NewNumeric(GetString("alliesNearCount"),"SklMgr_AllyCount",GetString("smPlayer"))
		editWindow:NewNumeric(GetString("alliesNearRange"),"SklMgr_AllyRange",GetString("smPlayer"))
		editWindow:NewField(GetString("playerHas"),"SklMgr_PHasBuffs",GetString("smPlayer"))
		editWindow:NewField(GetString("playerHasNot"),"SklMgr_PHasNotBuffs",GetString("smPlayer"))
		editWindow:NewNumeric(GetString("smCondCount"),"SklMgr_PCondCount",GetString("smPlayer"))
		editWindow:NewNumeric(GetString("smBoonCount"),"SklMgr_PBoonCount",GetString("smPlayer"))
		-- Target Section
		editWindow:NewComboBox(GetString("targetType"),"SklMgr_Type",GetString("targetType"),"Either,Character,Gadget")
		editWindow:NewNumeric(GetString("playerHPLT"),"SklMgr_TMinHP",GetString("targetType"),0,100)
		editWindow:NewNumeric(GetString("playerHPGT"),"SklMgr_TMaxHP",GetString("targetType"),0,99)
		editWindow:NewNumeric(GetString("enemiesNearCount"),"SklMgr_EnemyCount",GetString("targetType"))
		editWindow:NewNumeric(GetString("enemiesNearRange"),"SklMgr_EnemyRange",GetString("targetType"))
		editWindow:NewComboBox(GetString("targetMoving"),"SklMgr_Moving",GetString("targetType"),"Either,Moving,NotMoving")
		editWindow:NewField(GetString("targetHas"),"SklMgr_THasBuffs",GetString("targetType"))
		editWindow:NewField(GetString("targetHasNot"),"SklMgr_THasNotBuffs",GetString("targetType"))
		editWindow:NewNumeric(GetString("smCondCount"),"SklMgr_TCondCount",GetString("targetType"))
		editWindow:NewNumeric(GetString("smBoonCount"),"SklMgr_TBoonCount",GetString("targetType"))
		-- Buttons
		editWindow:NewButton(GetString("smDelete"),"gSMdeleteSkill")
		RegisterEventHandler("gSMdeleteSkill",_private.DeleteSkill)
		editWindow:NewButton(GetString("smPaste"),"gSMpasteSkill")
		RegisterEventHandler("gSMpasteSkill",_private.PasteSkill)
		editWindow:NewButton(GetString("smCopy"),"gSMcopySkill")
		RegisterEventHandler("gSMcopySkill",_private.CopySkill)
		editWindow:NewButton(GetString("smClone"),"gSMcloneSkill")
		RegisterEventHandler("gSMcloneSkill",_private.CloneSkill)
		editWindow:NewButton(GetString("smMoveDown"),"gsmMoveDownSkill")
		RegisterEventHandler("gsmMoveDownSkill",_private.MoveSkillDown)
		editWindow:NewButton(GetString("smMoveUp"),"gsmMoveUpSkill")
		RegisterEventHandler("gsmMoveUpSkill",_private.MoveSkillUp)
		
		editWindow:Hide()
	end
	if (editWindow) then
		if (skill and editWindow and gw2_skill_manager.profile) then
			local lSkill = nil
			if (string.find(skill,"SkillEditWindowButton",nil,true)) then
				skill = string.gsub(skill, "SkillEditWindowButton", "")
				skill = tonumber(skill)
				if (editWindow.visible and skill == gw2_skill_manager.currentSkill) then editWindow:Hide() return end
				gw2_skill_manager.currentSkill = skill
				lSkill = gw2_skill_manager.profile.skills[skill]
			else
				lSkill = gw2_skill_manager.profile.skills[skill]
			end
			local wnd = WindowManager:GetWindow(gw2_skill_manager.mainWindow.name)
			if ( wnd ) then editWindow:SetPos(wnd.x+wnd.width,wnd.y) end
			editWindow:Show()
			-- Skill
			SklMgr_ID = lSkill.skill.id
			SklMgr_Name = lSkill.skill.name
			--SklMgr_GrndTarget = lSkill.skill.groundTargeted
			SklMgr_HealnBuff = lSkill.skill.healing
			SklMgr_LOS = lSkill.skill.los
			SklMgr_SetRange = lSkill.skill.setRange
			SklMgr_MinRange = lSkill.skill.minRange
			SklMgr_MaxRange = lSkill.skill.maxRange
			SklMgr_Radius = lSkill.skill.radius
			SklMgr_SlowCast = lSkill.skill.slowCast
			SklMgr_LastSkillID = lSkill.skill.lastSkillID
			SklMgr_Delay = lSkill.skill.delay
			editWindow:UnFold(GetString("smSkill"))
			-- Player
			SklMgr_CombatState = lSkill.player.combatState
			SklMgr_PMinHP = lSkill.player.minHP
			SklMgr_PMaxHP = lSkill.player.maxHP
			SklMgr_MinPower = lSkill.player.minPower
			SklMgr_MaxPower = lSkill.player.maxPower
			SklMgr_MinEndurance = lSkill.player.minEndurance
			SklMgr_MaxEndurance = lSkill.player.maxEndurance
			SklMgr_AllyCount = lSkill.player.allyNearCount
			SklMgr_AllyRange = lSkill.player.allyRangeMax
			SklMgr_PHasBuffs = lSkill.player.hasBuffs
			SklMgr_PHasNotBuffs = lSkill.player.hasNotBuffs
			SklMgr_PCondCount = lSkill.player.conditionCount
			SklMgr_PBoonCount = lSkill.player.boonCount
			-- Target
			SklMgr_Type = lSkill.target.type
			SklMgr_TMinHP = lSkill.target.minHP
			SklMgr_TMaxHP = lSkill.target.maxHP
			SklMgr_EnemyCount = lSkill.target.enemyNearCount
			SklMgr_EnemyRange = lSkill.target.enemyRangeMax
			SklMgr_Moving = lSkill.target.moving
			SklMgr_THasBuffs = lSkill.target.hasBuffs
			SklMgr_THasNotBuffs = lSkill.target.hasNotBuffs
			SklMgr_TCondCount = lSkill.target.conditionCount
			SklMgr_TBoonCount = lSkill.target.boonCount
		elseif (skill == nil and editWindow) then
			editWindow:Hide()
		end
	end
end

function gw2_skill_manager.NewProfileDialog()
	local dialog = gw2_dialog_manager:GetDialog(GetString("newProfileName"))
	if (dialog == nil) then
		dialog = gw2_dialog_manager:NewDialog(GetString("newProfileName"))
		dialog:NewField(GetString("newProfileName"),"smDialogNewProfileName")
		dialog:SetOkFunction(
			function(list)
				if (ValidString(_G[list])) then
					gw2_skill_manager.profile = gw2_skill_manager.NewProfile(_G[list])
					gw2_skill_manager.MainWindow()
					_private.DetectSkills(true)
					return true
				end
				return "Please enter " .. GetString("newProfileName") .. " first."
			end
		)
	end
	if (dialog) then
		dialog:Show()
	end
end

function gw2_skill_manager.CloneProfileDialog()
	local dialog = gw2_dialog_manager:GetDialog(GetString("smCloneProfile"))
	if (dialog == nil) then
		dialog = gw2_dialog_manager:NewDialog(GetString("smCloneProfile"))
		dialog:NewField(GetString("smCloneProfile"),"smDialogCloneProfileName")
		dialog:SetOkFunction(
			function(list)
				if (ValidString(_G[list])) then
					local newName = table_invert(GW2.CHARCLASS)[Player.profession] .. "_" .. _G[list]
					gw2_skill_manager.profile:Clone(newName)
					gw2_skill_manager.profile = gw2_skill_manager.GetProfile(_G[list])
					gw2_skill_manager.MainWindow()
					return true
				end
				return "Please enter " .. GetString("smCloneProfile") .. " name first."
			end
		)
	end
	if (dialog) then
		dialog:Show()
	end
end

function gw2_skill_manager.DeleteProfileDialog()
	local dialog = gw2_dialog_manager:GetDialog(GetString("delete"))
	if (dialog == nil) then
		dialog = gw2_dialog_manager:NewDialog(GetString("delete"))
		dialog:SetOkFunction(
			function()
				gw2_skill_manager.profile:Delete()
				gw2_skill_manager.profile = nil
				Settings.GW2Minion.gCurrentProfile = "None"
				gw2_skill_manager.MainWindow()
				gw2_skill_manager.SkillEditWindow()
				return true
			end
		)
	end
	if (dialog) then
		dialog:Show()
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- **pricate variables**
_private.maxRange = 154
_private.runningIntoCombatRange = false -- TODO: order all variables nicely
_private.doingCombatMovement = false
_private.combatMoveTmr = 0
_private.targetLosingHP = {id = 0, health = 0, timer = 0}
_private.SwapTimer = 0
_private.SwapRandomTimer = 0
_private.SwapPetTimer = 0
_private.lastKitTable = {}
_private.skillLastCast = {}
_private.lastEvadedSkill = {targetID = 0, skillID = 0}
_private.evadeAt = {healthPercentage = math.random(75,90), enemiesAround = 3, timer = 0}
_private.lastTarget = {}
_private.currentSkills = {}
_private.currentHealSkills = {}
_private.skillbarSkills = {}
_private.lastSkillID = 0

-- **private functions**
function _private.GetProfileList(newProfile)
	local profession = ml_global_information.Player_Profession
	local list = "None"
	if (profession) then
		local profileList = dirlist(gw2_skill_manager.path,".*lua")
		if (ValidTable(profileList)) then
			for _,profileName in pairs(profileList) do
				local profile = persistence.load(gw2_skill_manager.path .. profileName)
				if (ValidTable(profile)) then
					if (profile.profession == ml_global_information.Player_Profession and ValidString(profile.name)) then
						local _,found = string.find(profile.name,"_")
						if (found) then
							local name = string.sub(profile.name,found+1,#profile.name)
							if (ValidString(name) and name:match("%W") == nil) then
								list = list .. "," .. name
							end
						end
					end
				end
			end
		end
	end
	if (ValidString(newProfile)) then
		if (StringContains(list,newProfile) == false) then
			list = list .. "," .. newProfile
		end
	end
	return list
end

function _private.CreateSkill(skillList,skillSlot)
	if (skillSlot) then
		local skillInfo = Player:GetSpellInfo(GW2.SKILLBARSLOT["Slot_" .. skillSlot])
		local newSkill = {}
		if (skillInfo and skillInfo.skillID ~= 10586 and ValidString(skillInfo.name)) then
			for priority,skill in pairs(skillList) do
				if (skill.skill.id == skillInfo.skillID) then
					if (skill.skill.name ~= skillInfo.name) then
						newSkill = deepcopy(skill)
						newSkill.skill.name = skillInfo.name
						return newSkill
					end
					return false
				end
			end
			newSkill = {
				priority = #skillList+1,
				skill = {	id				= skillInfo.skillID,
							name			= skillInfo.name,
							groundTargeted	= (skillInfo.isGroundTargeted == true and "1" or "0"),
							healing			= "0",
							los				= "1",
							setRange		= (tonumber(skillSlot) >= 1 and tonumber(skillSlot) <= 5 and "1" or "0"),
							minRange		= skillInfo.minRange or 0,
							maxRange		= skillInfo.maxRange or 0,
							radius			= skillInfo.radius or 0,
							slowCast		= "0",
							lastSkillID		= "",
							delay			= 0,
				},
				player = {	combatState		= "Either",
							minHP			= 0,
							maxHP			= 0,
							minPower		= 0,
							maxPower		= 0,
							minEndurance	= 0,
							maxEndurance	= 0,
							allyNearCount	= 0,
							allyRangeMax	= 0,
							hasBuffs		= "",
							hasNotBuffs		= "",
							conditionCount	= 0,
							boonCount		= 0,
				},
				target = {	type			= "Either",
							minHP			= 0,
							maxHP			= 0,
							enemyNearCount	= 0,
							enemyRangeMax	= 0,
							moving			= "Either",
							hasBuffs		= "",
							hasNotBuffs		= "",
							conditionCount	= 0,
							boonCount		= 0,
				},
			}
			return newSkill
		end
	end
	return false
end

function _private.CorrectSkillPriority(skillList)
	for priority,_ in ipairs(skillList) do
		skillList[priority].priority = priority
	end
	return skillList
end

function _private.CheckTargetBuffs(target)
	if (target) then
		if (gw2_common_functions.BufflistHasBuffs(target.buffs,"762,785")) then
			ml_blacklist.AddBlacklistEntry(GetString("monsters"),target.contentID,target.name,ml_global_information.Now+30000)
			Player:ClearTarget()
			return false
		end
	end
	return true
end

function _private.GetPredictedLocation(target,skill)
	local pPos = Player.pos
	if (_private.lastTarget.id and _private.lastTarget.id == target.id and _private.lastTarget.pos) then
		local tPos = target.pos
		local dx = tPos.x-_private.lastTarget.pos.x
		local dy = tPos.y-_private.lastTarget.pos.y
		local targetSpeed = math.sqrt(dx*dx + dy*dy)
		local targetHeading = math.atan2(dx, dy)
		local ePos = {
			x = tPos.x + math.sin(targetHeading) * targetSpeed/5 * (1 + target.distance / 30),
			y = tPos.y + math.cos(targetHeading) * targetSpeed/5 * (1 + target.distance / 30),
			z = tPos.z,
		}
		_private.lastTarget.pos = target.pos
		local dist = Distance3D(pPos.x,pPos.y,pPos.z,ePos.x,ePos.y,ePos.z)
		if (dist < skill.skill.maxRange) then
			return ePos
		end
	else
		_private.lastTarget.pos = target.pos
		_private.lastTarget.id = target.id
	end
	return target.pos
end

function _private.TargetLosingHealth(target)
	if (target) then
		if (_private.targetLosingHP.id ~= target.id) then
			_private.targetLosingHP = {id = target.id, health = target.health.current, timer = ml_global_information.Now}
		elseif (_private.targetLosingHP.id == target.id and TimeSince(_private.targetLosingHP.timer) > 15000 ) then
			_private.targetLosingHP.timer = ml_global_information.Now
			if (_private.targetLosingHP.health ~= 0 and _private.targetLosingHP.health == target.health.current) then
				ml_blacklist.AddBlacklistEntry(GetString("monsters"), target.contentID, target.name, ml_global_information.Now + 90000)
				Player:ClearTarget()
				d("BlackListed some target, health not changeing AT ALL!")
				return false
			else
				_private.targetLosingHP.health = target.health.current
			end
		end
		return true
	else
		_private.targetLosingHP = {id = 0, health = 0, timer = 0}
	end
end

function _private.CanCast(skill,target)
	if (skill) then
		-- skill attributes
		if (skill.skill.lastSkillID ~= "" and tostring(skill.skill.lastSkillID) ~= Player.castinfo.lastSkillID) then return false end
		if (skill.skill.delay > 0 and _private.skillLastCast[skill.skill.id] ~= nil and TimeSince(_private.skillLastCast[skill.skill.id]+skill.maxCooldown) < (skill.skill.delay)) then return false end
		if (skill.skill.los == "1" and (skill.skill.healing == "0" and (target == nil or target.los == false))) then return false end
		if (skill.skill.minRange > 0 and (skill.skill.healing == "0" and (target == nil or (target.distance+target.radius) < skill.skill.minRange))) then return false end
		if (skill.skill.maxRange > 0 and (skill.skill.healing == "0" and (target == nil or (target.distance-target.radius) > (skill.skill.maxRange < 154 and 154 or skill.skill.maxRange)))) then return false end
		--if (skill.skill.maxRange > 0 and (skill.skill.healing == "0" and (target == nil or (target.distance) > (skill.skill.maxRange < 154 and 154 or skill.skill.maxRange)))) then return false end
		if (skill.skill.maxRange == 0 and skill.skill.radius > 0 and (skill.skill.healing == "0" and (target == nil or target.distance > skill.skill.radius))) then return false end
		-- player attributes
		local playerBuffList = Player.buffs
		if (skill.player.combatState == "InCombat" and ml_global_information.Player_InCombat == false ) then return false end
		if (skill.player.combatState == "OutCombat" and ml_global_information.Player_InCombat == true ) then return false end
		if (skill.player.minHP > 0 and ml_global_information.Player_Health.percent > skill.player.minHP) then return false end
		if (skill.player.maxHP > 0 and ml_global_information.Player_Health.percent < skill.player.maxHP) then return false end
		if (skill.player.minPower > 0 and ml_global_information.Player_Power > skill.player.minPower) then return false end
		if (skill.player.maxPower > 0 and ml_global_information.Player_Power < skill.player.maxPower) then return false end
		if (skill.player.minEndurance > 0 and ml_global_information.Player_Endurance > skill.player.minEndurance) then return false end
		if (skill.player.maxEndurance > 0 and ml_global_information.Player_Endurance < skill.player.maxEndurance) then return false end
		if (skill.player.allyNearCount > 0) then
			local maxdistance = (skill.player.allyRangeMax == 0 and "" or "maxdistance=" .. skill.player.allyRangeMax .. ",")
			if (TableSize(CharacterList("friendly," .. maxdistance .. "distanceto=" .. Player.id .. ",exclude=" .. Player.id)) < skill.player.allyNearCount) then return false end
		end
		if (skill.player.hasBuffs ~= "" and playerBuffList and not gw2_common_functions.BufflistHasBuffs(playerBuffList, tostring(skill.player.hasBuffs))) then return false end
		if (skill.player.hasNotBuffs ~= "" and playerBuffList and gw2_common_functions.BufflistHasBuffs(playerBuffList, tostring(skill.player.hasNotBuffs))) then return false end
		if (skill.player.conditionCount > 0 and playerBuffList and gw2_common_functions.CountConditions(playerBuffList) <= skill.player.conditionCount) then return false end
		if (skill.player.boonCount > 0 and playerBuffList and gw2_common_functions.CountBoons(playerBuffList) <= skill.player.boonCount) then return false end
		-- target attributes
		local targetBuffList = (target and target.buffs or false)
		if (skill.target.minHP > 0 and (skill.skill.healing == "0" and (target == nil or ml_global_information.Player_Health.percent > skill.target.minHP))) then return false end
		if (skill.target.maxHP > 0 and (skill.skill.healing == "0" and (target == nil or ml_global_information.Player_Health.percent < skill.target.maxHP))) then return false end
		if ( skill.target.enemyNearCount > 0) then
			local maxdistance = (skill.target.enemyRangeMax == 0 and "" or "maxdistance=" .. skill.target.enemyRangeMax .. ",")
			if (skill.skill.healing == "0" and (target == nil or TableSize(CharacterList("alive,attackable," .. maxdistance .. "distanceto=" .. target.id .. ",exclude=" .. target.id)) < skill.target.enemyNearCount)) then return false end
		end
		if (skill.target.moving == "Yes" and (skill.skill.healing == "0" and (target == nil or target.movementstate == GW2.MOVEMENTSTATE.GroundNotMoving ))) then return false end
		if (skill.target.moving == "No" and (skill.skill.healing == "0" and (target == nil or target.movementstate == GW2.MOVEMENTSTATE.GroundMoving ))) then return false end
		if (skill.target.hasBuffs ~= "" and (skill.skill.healing == "0" and (target == nil or targetBuffList and not gw2_common_functions.BufflistHasBuffs(targetBuffList, tostring(skill.target.hasBuffs))))) then return false end
		if (skill.target.hasNotBuffs ~= "" and (skill.skill.healing == "0" and (target == nil or targetBuffList and gw2_common_functions.BufflistHasBuffs(targetBuffList, tostring(skill.target.hasNotBuffs))))) then return false end
		if (skill.target.conditionCount > 0 and (skill.skill.healing == "0" and (target == nil or targetBuffList and gw2_common_functions.CountConditions(targetBuffList) <= skill.target.conditionCount))) then return false end
		if (skill.target.boonCount > 0 and (skill.skill.healing == "0" and (target == nil or targetBuffList and gw2_common_functions.CountBoons(targetBuffList) <= skill.target.boonCount))) then return false end
		if (skill.target.type == "Character" and (skill.skill.healing == "0" and (target == nil or target.isCharacter == false))) then return false end
		if (skill.target.type == "Gadget" and (skill.skill.healing == "0" and (target == nil or target.isGadget == false))) then return false end
		-- skill can be cast
		return true
	end
	return false
end

function _private.SwapWeapon(target)
	if (Player:CanCast() and Player:IsCasting() == false and Player:CanSwapWeaponSet() and TimeSince(_private.SwapTimer) > 500) then
		local swap,cause = false,nil
		if (gw2_skill_manager.profile.switchSettings.switchOnRange == "1" and _private.maxRange < 300 and target and target.distance > _private.maxRange) then
			swap = true
		elseif (gw2_skill_manager.profile.switchSettings.switchRandom == "1" and TimeSince(_private.SwapRandomTimer) > 0) then
			swap = true
		elseif (tonumber(gw2_skill_manager.profile.switchSettings.switchOnCooldown) > 0) then
			local skillsOnCooldown = 0
			for _,skill in pairs(_private.skillbarSkills) do
				if (skill.slot > GW2.SKILLBARSLOT.Slot_1  and skill.slot <= GW2.SKILLBARSLOT.Slot_5 and skill.cooldown ~= 0) then
					skillsOnCooldown = skillsOnCooldown + 1
				end
			end
			if (skillsOnCooldown >= tonumber(gw2_skill_manager.profile.switchSettings.switchOnCooldown)) then
				swap = true
			end
		end
		if (ml_global_information.Player_Profession == GW2.CHARCLASS.Ranger and TimeSince(_private.SwapPetTimer) > 2500) then
			_private.SwapPetTimer = ml_global_information.Now
			_private.SwapRangerPet()
		end
		if (swap) then
			_private.SwapTimer = ml_global_information.Now
			_private.SwapRandomTimer = ml_global_information.Now + math.random(5000,15000)
			if (ml_global_information.Player_Profession == GW2.CHARCLASS.Elementalist) then
				return _private.SwapElementalistAttunement()			
			elseif (ml_global_information.Player_Profession == GW2.CHARCLASS.Engineer) then
				return _private.SwapEngineerKit()
			else
				if (ml_global_information.ShowDebug) then
					gSMCurrentAction = "Swap weapons: Mode = normal."
				end
				_private.SwapRangerPet()
				Player:SwapWeaponSet()
				return true
			end
		end
	end
	return false
end

function _private.SwapEngineerKit()
	local EngineerKits = {
		[5812] = "BombKit",
		[5927] = "FlameThrower",
		[6020] = "GrenadeKit",
		[5805] = "GrenadeKit",
		[5904] = "ToolKit",
		[5933] = "ElixirGun",
	}
	local availableKits = { [1] = { slot=0, skillID=0} }-- Leave Kit Placeholder
	local prefKitEquiped = false
	for _,skill in pairs(_private.skillbarSkills) do
		if (skill and EngineerKits[skill.skillID] and (_private.lastKitTable[skill.slot] == nil or TimeSince(_private.lastKitTable[skill.slot].lastused) > 1500)) then
			local kitcount = TableSize(availableKits) + 1
			availableKits[kitcount] = {}
			availableKits[kitcount].slot = skill.slot
			availableKits[kitcount].skillID = skill.skillID
		end
	end
	local key = math.random(1,TableSize(availableKits))
	if (key ~= 1) then
		if (ml_global_information.ShowDebug) then
			gSMCurrentAction = "Swap weapons: Mode = engineer."
		end
		Player:CastSpell(availableKits[key].slot)
		local prioKit = gw2_skill_manager.profile.professionSettings.priorityKit
		if (prioKit ~= "None" and EngineerKits[availableKits[key].skillID] ~= prioKit)then
			_private.lastKitTable[availableKits[key].slot] = { lastused = ml_global_information.Now + 15000 }
		else
			_private.lastKitTable[availableKits[key].slot] = { lastused = ml_global_information.Now }
		end
		return true
	end	
	return false
end

function _private.SwapElementalistAttunement()
	local switch = nil
	local skill = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_1)
	if ( skill ~= nil ) then
		local sID = skill.skillID
		local attunement = {
			["Fire"] = {[1] = GW2.SKILLBARSLOT.Slot_13 , [5491] = GW2.SKILLBARSLOT.Slot_13 , [15718] = GW2.SKILLBARSLOT.Slot_13 , [5508] = GW2.SKILLBARSLOT.Slot_13 ,},
			["Water"] = {[1] = GW2.SKILLBARSLOT.Slot_14 , [5549] = GW2.SKILLBARSLOT.Slot_14 , [15716] = GW2.SKILLBARSLOT.Slot_14 , [5693] = GW2.SKILLBARSLOT.Slot_14 ,},
			["Air"] = {[1] = GW2.SKILLBARSLOT.Slot_15 , [5518] = GW2.SKILLBARSLOT.Slot_15 , [5489] = GW2.SKILLBARSLOT.Slot_15 , [5526] = GW2.SKILLBARSLOT.Slot_15 ,},
			["Earth"] = {[1] = GW2.SKILLBARSLOT.Slot_16 , [5519] = GW2.SKILLBARSLOT.Slot_16 , [15717] = GW2.SKILLBARSLOT.Slot_16 , [5500] = GW2.SKILLBARSLOT.Slot_16 ,},
		}
		local currentAttunement = (attunement["Fire"][sID] or attunement["Water"][sID] or attunement["Air"][sID] or attunement["Earth"][sID])
		if (currentAttunement) then
			local randomAttunement = nil
			for attempts=1,10 do
				local randomPick = GetRandomTableEntry(attunement)[1]
				if (randomPick ~= currentAttunement and not Player:IsSpellOnCooldown(randomPick)) then
					randomAttunement = randomPick
					break
				end
			end
			local att1 = gw2_skill_manager.profile.professionSettings.PriorityAtt1
			local att2 = gw2_skill_manager.profile.professionSettings.PriorityAtt2
			local att3 = gw2_skill_manager.profile.professionSettings.PriorityAtt3
			local att4 = gw2_skill_manager.profile.professionSettings.PriorityAtt4
			switch = ((att1 ~= "None" and attunement[att1][1] ~= currentAttunement and not Player:IsSpellOnCooldown(attunement[att1][1]) and attunement[att1][1]) or
					(att2 ~= "None" and attunement[att2][1] ~= currentAttunement and not Player:IsSpellOnCooldown(attunement[att2][1]) and attunement[att2][1]) or
					(att3 ~= "None" and attunement[att3][1] ~= currentAttunement and not Player:IsSpellOnCooldown(attunement[att3][1]) and attunement[att3][1]) or
					(att4 ~= "None" and attunement[att4][1] ~= currentAttunement and not Player:IsSpellOnCooldown(attunement[att4][1]) and attunement[att4][1]) or
					(att1 == "None" and att2 == "None" and att3 == "None" and att4 == "None" and randomAttunement))
		end
		if (switch) then
			Player:CastSpell(switch)
			if (ml_global_information.ShowDebug) then
				gSMCurrentAction = "Swap weapons: Mode = Elementalist."
			end
			return true
		end
	end	
	return false
end

function _private.SwapRangerPet()
	local pet = Player:GetPet()
	if ( pet ~= nil and Player:CanSwitchPet() and Player.healthstate == GW2.HEALTHSTATE.Alive and (pet.alive == false or pet.health.percent < 12)) then	
		if (ml_global_information.ShowDebug) then
			gSMCurrentAction = "Swap weapons: Mode = Ranger."
		end
		Player:SwitchPet()
		return true
	end
	return false
end

function _private.AttackSkill(target)
	if (ValidTable(_private.currentSkills)) then
		for _,skill in ipairs(_private.currentSkills) do
			if (_private.CanCast(skill,target) == true) then
				--d("Casting "..skill.skill.name.. " CanCast: "..tostring( Player:CanCast() ).." CurrentCastDuration: "..tostring(Player.castinfo.duration))
				if (ml_global_information.ShowDebug) then
					gSMCurrentCast = "Casting "..skill.skill.name.. " CanCast: "..tostring( Player:CanCast() ).." CurrentCastDuration: "..tostring(Player.castinfo.duration)
				end
				if (target) then
					local pos = _private.GetPredictedLocation(target,skill)
					if (skill.skill.groundTargeted == "1") then
						if (target.isCharacter) then
							Player:CastSpell(skill.slot,pos.x,pos.y,pos.z)
						elseif (target.isGadget) then
							Player:CastSpell(skill.slot,pos.x,pos.y,pos.z-target.height)
						end
					else
						Player:CastSpell(skill.slot,target.id)
					end
				else
					Player:CastSpell(skill.slot)
				end
				if (ml_global_information.ShowDebug) then
					gSMCurrentAction = "Casting skills"
				end
				_private.lastSkillID = skill.skill.id
				_private.skillLastCast[skill.skill.id] = ml_global_information.Now
				if (_private.TargetLosingHealth(target) == false) then
					return false
				end
				return true
			end
		end
	end
	return false
end

function _private.Evade()
	if (gDoCombatMovement ~= "0" and ml_global_information.Player_Endurance >= 50 and TimeSince(_private.evadeAt.timer) > 300) then
		_private.evadeAt.timer = ml_global_information.Now
		local targets = CharacterList("aggro")
		if (ml_global_information.Player_Health.percent < _private.evadeAt.healthPercentage or TableSize(targets) >= _private.evadeAt.enemiesAround) then
			_private.evadeAt.healthPercentage = math.random(75,90)
			for _,target in pairs(targets) do
				local targetOfTarget = target.castinfo.targetID
				local skillofTarget = target.castinfo.skillID
				if (target.id ~= _private.lastEvadedSkill.targetID) then
					_private.lastEvadedSkill = {targetID = target.id, skillID = 0}
				end
				if (targetOfTarget == Player.id and skillofTarget ~= 0 and skillofTarget ~= _private.lastEvadedSkill.skillID) then
					--GW2.DODGEDIRECTIONS = {Backward = 0, BackwardLeft = 1, BackwardRight = 2, Forward = 3, ForwardLeft = 4, ForwardRight = 5, Left = 6, Right = 7}
					local direction = {[1]=1,[2]=2,[3]=0,[4]=6,[5]=7,[6]=6,[7]=7,}
					local dir = math.random(1,#direction)
					if (_private.CanMoveDirection(direction[dir],320)) then
						_private.lastEvadedSkill.skillID = skillofTarget
						Player:Evade(direction[dir])
						if (ml_global_information.ShowDebug) then
							gSMCurrentAction = "Evading: dir = "..dir.."."
						end
						return true
					end
				end
			end
		end
	end
	return false
end

function _private.CanMoveDirection(dir,distance)
	if (tonumber(dir) and tonumber(distance)) then
		local timesToCheck = 15
		local checkDist = distance/timesToCheck
		for step=1,timesToCheck do
			if (Player:CanMoveDirection(dir,(checkDist*step)) == false) then
				return false
			end
		end
		return true
	end
end

function _private.DoCombatMovement()
	local target = ml_global_information.Player_Target
	if (gDoCombatMovement ~= "0" and ValidTable(target) and ml_global_information.Player_Health.percent < 99 and not gw2_unstuck.HandleStuck("combat")) then
		if (gw2_common_functions.HasBuffs(Player,"791,727")) then Player:StopMovement() return false end
		local tDistance = target.distance
		local moveDir = ml_global_information.Player_MovementDirections

		-- SET FACING TARGET
		Player:SetFacingExact(target.pos.x,target.pos.y,target.pos.z) -- TODO: really needed?

		--CONTROL CURRENT COMBAT MOVEMENT
		if (Player:IsMoving() ) then

			if (tonumber(tDistance) ~= nil) then
				if (_private.maxRange > 300 and tDistance < (_private.maxRange / 4) and moveDir.forward) then -- we are too close and moving towards enemy
					Player:UnSetMovement(0)	-- stop moving forward
				elseif (tDistance < (target.radius) and moveDir.forward) then
					Player:UnSetMovement(0)	-- stop moving forward
				elseif (tDistance > _private.maxRange and moveDir.backward) then -- we are too far away and moving backwards
					Player:UnSetMovement(1)	-- stop moving backward
				elseif (tDistance > _private.maxRange and (moveDir.left or moveDir.right)) then -- we are strafing outside the maxrange
					Player:UnSetMovement(2) -- stop moving Left -- TODO: Make sure left stops right.
					--Player:UnSetMovement(3) -- stop moving Right
				end
			end
		end

		--Set New Movement
		if (tonumber(tDistance) ~= nil and TimeSince(_private.combatMoveTmr) > 0 and Player.onmesh) then

			_private.combatMoveTmr = ml_global_information.Now + math.random(1000,3500)
			--tablecount:  1, 2, 3, 4, 5   --Table index starts at 1, not 0 
			local dirs = { 0, 1, 2, 3, 4 } --Forward = 0, Backward = 1, Left = 2, Right = 3, + stop

			if (_private.maxRange > 300) then
				-- RANGE
				if (tDistance < _private.maxRange) then
					if (tDistance > (_private.maxRange * 0.95)) then 
						table.remove(dirs,2) -- We are too far away to walk backward
					end
					if (tDistance < (_private.maxRange / 4)) then 
						table.remove(dirs,1) -- We are too close to walk forward
					end	
					if (tDistance < 250) then 
						table.remove(dirs,5) -- We are too close, remove "stop"
						if (moveDir.left) then 
							table.remove(dirs,3) -- We are moving left, so don't try to go left
						end
						if (moveDir.right) then
							table.remove(dirs,4) -- We are moving right, so don't try to go right
						end
					end
				end

			else
				-- MELEE
				if (tDistance > _private.maxRange) then 
					table.remove(dirs,2) -- We are too far away to walk backwards
				end
				if (tDistance < (target.radius)) then 
					table.remove(dirs,1) -- We are too close to walk forwards
				end
			end
			-- Forward = 0, Backward = 1, Left = 2, Right = 3, + stop
			-- F = 3, B = 0, L = 6, R = 7, LF = 4, RF = 5, LB = 1, RB = 2
			if (_private.CanMoveDirection(3,400) == false or _private.CanMoveDirection(4,350) == false or _private.CanMoveDirection(5,350) == false) then 
				Player:UnSetMovement(0)
				table.remove(dirs,1)
			end
			if (_private.CanMoveDirection(0,400) == false or _private.CanMoveDirection(1,350) == false or _private.CanMoveDirection(2,350) == false) then 
				Player:UnSetMovement(1)
				table.remove(dirs,2)
			end
			if (_private.CanMoveDirection(6,400) == false or _private.CanMoveDirection(4,350) == false or _private.CanMoveDirection(1,350) == false) then 
				Player:UnSetMovement(2)
				table.remove(dirs,3)
			end
			if (_private.CanMoveDirection(7,400) == false or _private.CanMoveDirection(5,350) == false or _private.CanMoveDirection(2,350) == false) then 
				Player:UnSetMovement(3)
				table.remove(dirs,4)
			end

			-- MOVE
			local dir = dirs[ math.random( #dirs ) ]
			if (dir ~= 4) then
				Player:SetMovement(dir)
				_private.doingCombatMovement = true
			else 
				Player:StopMovement()
			end
			
		end
	elseif (gDoCombatMovement ~= "0" and target and _private.doingCombatMovement == true) then
		_private.doingCombatMovement = false
		Player:StopMovement()
	end
	return false
end

function _private.Save()
	gw2_skill_manager.profile:Save()
	gw2_skill_manager.MainWindow(true)
	gw2_skill_manager.SkillEditWindow()
	local name = gw2_skill_manager.profile.name
	name = string.sub(name,select(2,string.find(name,"_"))+1,#name)
	Settings.GW2Minion.gCurrentProfile = name
end

function _private.Delete()
	gw2_skill_manager.DeleteProfileDialog()
	--[[gw2_skill_manager.profile:Delete()
	gw2_skill_manager.profile = nil
	Settings.GW2Minion.gCurrentProfile = "None"
	gw2_skill_manager.MainWindow()
	gw2_skill_manager.SkillEditWindow()]]
end

function _private.DetectSkills(onOff)
	local mainWindow = WindowManager:GetWindow(gw2_skill_manager.mainWindow.name)
	if (mainWindow) then 
		local button = mainWindow:GetControl(GetString("autoDetectSkills"))
		if (button and gw2_skill_manager.profile) then
			if (type(onOff) == "boolean") then
				button:SetToggleState(onOff)
			end
			if (button.pressed) then
				d("Recording Skills..")
				gw2_skill_manager.detecting = true
				button:SetText("Stop "..GetString("autoDetectSkills"))
			else
				d("Stopping Recording Skills..")
				gw2_skill_manager.detecting = false
				button:SetText(GetString("autoDetectSkills"))
			end
		else
			d("No current profile, please create profile first.")
		end
	end
end

function _private.DeleteSkill()
	gw2_skill_manager.profile:DeleteSkill(gw2_skill_manager.currentSkill)
	gw2_skill_manager.UpdateSkillsMainWindow(true)
	gw2_skill_manager.SkillEditWindow()
end

function _private.MoveSkillUp()
	if (gw2_skill_manager.profile:MoveSkill(gw2_skill_manager.currentSkill,"up")) then
		gw2_skill_manager.currentSkill = gw2_skill_manager.currentSkill - 1
		gw2_skill_manager.UpdateSkillsMainWindow(true)
		gw2_skill_manager.SkillEditWindow(gw2_skill_manager.currentSkill)
	end
end

function _private.MoveSkillDown()
	if (gw2_skill_manager.profile:MoveSkill(gw2_skill_manager.currentSkill,"down")) then
		gw2_skill_manager.currentSkill = gw2_skill_manager.currentSkill + 1
		gw2_skill_manager.UpdateSkillsMainWindow(true)
		gw2_skill_manager.SkillEditWindow(gw2_skill_manager.currentSkill)
	end
end

function _private.CloneSkill()
	gw2_skill_manager.profile:CloneSkill(gw2_skill_manager.currentSkill)
	gw2_skill_manager.currentSkill = gw2_skill_manager.currentSkill + 1
	gw2_skill_manager.UpdateSkillsMainWindow(true)
	gw2_skill_manager.SkillEditWindow(gw2_skill_manager.currentSkill)
end

function _private.CopySkill()
	gw2_skill_manager.profile:CopySkill(gw2_skill_manager.currentSkill)
end

function _private.PasteSkill()
	gw2_skill_manager.profile:PasteSkill(gw2_skill_manager.currentSkill)
end

function _private.ReturnSkillByID(skills,id)
	if (ValidTable(skills) and tonumber(id)) then
		for _,skill in ipairs(skills) do
			if (skill.skill.id == id) then
				return skill
				--return deepcopy(skill)
			end
		end
		return nil
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- **profile prototype**
-- main profile stuff
function profilePrototype:Save()
	_private.DetectSkills(false)
	local saveFile = deepcopy(self)
	saveFile.clipboard = nil
	setmetatable(saveFile, {})
	persistence.store(gw2_skill_manager.path .. self.name .. ".lua", saveFile)
	return true
end

function profilePrototype:Clone(newName)
	if (ValidString(newName)) then
		_private.DetectSkills(false)
		local saveFile = deepcopy(self)
		saveFile.name = newName
		saveFile.clipboard = nil
		setmetatable(saveFile, {})
		persistence.store(gw2_skill_manager.path .. saveFile.name .. ".lua", saveFile)
		return true
	end
	return false
end

function profilePrototype:Delete()
	_private.DetectSkills(false)
	os.remove(gw2_skill_manager.path .. self.name .. ".lua")
	return true
end

function profilePrototype:Heal()
	if (Player.castinfo.duration == 0) then
		for priority=1,#_private.currentHealSkills do
			local skill = _private.currentHealSkills[priority]
			if (_private.CanCast(skill) == true) then			
				Player:CastSpell(skill.slot)
				return true
			end
		end
	end
	return false
end

function profilePrototype:Attack(target)
	if (_private.CheckTargetBuffs(target)) then
		if (target and target.id ~= ml_global_information.Player_Target.id) then Player:SetTarget(target.id) end
		if (target == nil or target.distance < _private.maxRange) then
			if (_private.runningIntoCombatRange == true and (target.inCombat == true or target.movementstate == GW2.MOVEMENTSTATE.GroundNotMoving)) then Player:StopMovement() _private.runningIntoCombatRange = false end
			local lastSkillInfo = _private.ReturnSkillByID(self.skills,_private.lastSkillID)
			_private.DoCombatMovement()
			--if (Player.castinfo.duration == 0 or (lastSkillInfo and lastSkillInfo.skill.slowCast == "0")) then
			if ((Player:CanCast() and Player:IsCasting() == false) or (lastSkillInfo and lastSkillInfo.skill.slowCast == "0")) then
				if (_private.Evade()) then
					return true
				elseif (_private.SwapWeapon(target)) then
					return true
				elseif (_private.AttackSkill(target)) then
					return true
				end
			end
		elseif (target and (gBotMode ~= GetString("assistMode") or gMoveIntoCombatRange == "1")) then
			gw2_common_functions.MoveOnlyStraightForward()
			_private.SwapWeapon(target)
			local tPos = target.pos
			if (gw2_unstuck.HandleStuck() == false) then
				Player:MoveTo(tPos.x,tPos.y,tPos.z,target.radius,false,false,true)
				_private.runningIntoCombatRange = true
			end
		end
	end
	return false
end

function profilePrototype:GetAttackRange()
	return _private.maxRange
end

function profilePrototype:UpdateSkillInfo()
	_private.skillbarSkills = {}
	_private.currentSkills = {}
	_private.currentHealSkills = {}
	for i = 1, 16, 1 do
		local skill = Player:GetSpellInfo(GW2.SKILLBARSLOT["Slot_" .. i])
		if (skill) then
			_private.skillbarSkills[skill.skillID] = skill
		end
	end
	local newPriority = 1
	local newHealPriority = 1
	local maxRange = 154
	if ( ValidTable(self.skills) and ValidTable(_private.skillbarSkills) ) then
		for _,skill in ipairs(self.skills) do
			for _,aSkill in pairs(_private.skillbarSkills) do
				if (aSkill.skillID == skill.skill.id and (skill.skill.id ~= _private.lastSkillID or aSkill.slot == GW2.SKILLBARSLOT.Slot_1) and aSkill.cooldown == 0) then
					_private.currentSkills[newPriority] = skill
					_private.currentSkills[newPriority].slot = aSkill.slot
					_private.currentSkills[newPriority].cooldown = aSkill.cooldown
					_private.currentSkills[newPriority].maxCooldown = aSkill.cooldownmax
					newPriority = newPriority + 1
					if (skill.skill.healing == "1") then
						_private.currentHealSkills[newHealPriority] = skill
						_private.currentHealSkills[newHealPriority].slot = aSkill.slot
						_private.currentHealSkills[newHealPriority].cooldown = aSkill.cooldown
						_private.currentHealSkills[newHealPriority].maxCooldown = aSkill.cooldownmax
						newHealPriority = newHealPriority + 1
					end
					local canCastCheck = (ValidTable(ml_global_information.Player_Target) == false or _private.CanCast(skill,ml_global_information.Player_Target))
					if (skill.skill.setRange == "1" and canCastCheck) then
						maxRange = (skill.skill.maxRange > 0 and skill.skill.maxRange > maxRange and skill.skill.maxRange or maxRange)
						maxRange = (skill.skill.maxRange == 0 and skill.skill.radius > 0 and skill.skill.radius > maxRange and skill.skill.radius or maxRange)
					end
					break
				end
			end
		end
	end
	_private.maxRange = maxRange
end


-- main skill stuff
function profilePrototype:DetectSkills()
	for slot=1,16 do
		local newSkill = _private.CreateSkill(self.skills,slot)
		if (newSkill) then
			self.skills[newSkill.priority] = newSkill
			gw2_skill_manager.UpdateSkillsMainWindow(true)
		end
	end
	return true
end

function profilePrototype:DeleteSkill(skillPriority)
	if (tonumber(skillPriority)) then
		table.remove(self.skills, skillPriority)
		self.skills = _private.CorrectSkillPriority(self.skills)
		return true
	end
	return false
end

function profilePrototype:MoveSkill(skillPriority,direction)
	if (self.skills[skillPriority] and direction) then
		local newPriority = (direction == "up" and skillPriority ~= 1 and skillPriority - 1 or direction == "down" and skillPriority < #self.skills and skillPriority + 1)
		if (self.skills[newPriority]) then
			local skillToNewLocation = deepcopy(self.skills[skillPriority])
			local skillToOldLocation = deepcopy(self.skills[newPriority])
			self.skills[newPriority] = deepcopy(skillToNewLocation)
			self.skills[skillPriority] = deepcopy(skillToOldLocation)
			self.skills = _private.CorrectSkillPriority(self.skills)
			return true
		end
	end
	return false
end

function profilePrototype:CloneSkill(skillPriority)
	if (self.skills[skillPriority]) then
		local clone = deepcopy(self.skills[skillPriority])
		table.insert(self.skills, clone.priority+1, clone)
		self.skills = _private.CorrectSkillPriority(self.skills)
		return true
	end
	return false
end

function profilePrototype:CopySkill(skillPriority)
	self.clipboard = deepcopy(self.skills[skillPriority])
	self.clipboard.priority = nil
	self.clipboard.skill.id = nil
	self.clipboard.skill.name = nil
	return true
end

function profilePrototype:PasteSkill(skillPriority)
	if (self.clipboard) then
		self.clipboard.priority = self.skills[skillPriority].priority
		self.clipboard.skill.id = self.skills[skillPriority].skill.id
		self.clipboard.skill.name = self.skills[skillPriority].skill.name
		self.skills[skillPriority] = deepcopy(self.clipboard)
	end
end

function profilePrototype:GetSkillList() -- really needed??
	return function()
		for _,skill in ipairs(self.skills) do
			return skill.name
		end
	end
end


function gw2_skill_manager.OnUpdate(ticks)
	gw2_skill_manager.UpdateSkillInfo()
	if (gw2_skill_manager.detecting == true) then
		gw2_skill_manager.profile:DetectSkills()
	end
	if (_private.doingCombatMovement and ValidTable(ml_global_information.Player_Target) == false) then
		_private.doingCombatMovement = false
		Player:StopMovement()
	end
	if (_private.runningIntoCombatRange and ValidTable(ml_global_information.Player_Target) == false) then
		_private.runningIntoCombatRange = false
		Player:StopMovement()
	end
	if (gw2_skill_manager.UpdateMainWindowGroups()) then
		return true
	elseif (gw2_skill_manager.UpdateMainWindowSkills()) then
		return true
	end
end
