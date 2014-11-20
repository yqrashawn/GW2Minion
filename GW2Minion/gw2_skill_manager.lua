gw2_skill_manager = {}
gw2_skill_manager.mainWindow = {name = GetString("skillManager"), x = 350, y = 50, w = 250, h = 350}
gw2minion.MainWindow.ChildWindows[gw2_skill_manager.mainWindow.name] = gw2_skill_manager.mainWindow.name
gw2_skill_manager.skillEditWindow = {name = GetString("skillEditor"), x = 600, y = 50, w = 250, h = 550}
gw2minion.MainWindow.ChildWindows[gw2_skill_manager.skillEditWindow.name] = gw2_skill_manager.skillEditWindow.name
gw2_skill_manager.comboEditWindow = {name = GetString("comboEditor"), x = 600, y = 50, w = 250, h = 350}
gw2minion.MainWindow.ChildWindows[gw2_skill_manager.comboEditWindow.name] = gw2_skill_manager.comboEditWindow.name
gw2_skill_manager.comboSkillEditWindow = {name = GetString("comboSkillEditor"), x = 850, y = 50, w = 250, h = 550}
gw2minion.MainWindow.ChildWindows[gw2_skill_manager.comboSkillEditWindow.name] = gw2_skill_manager.comboSkillEditWindow.name
gw2_skill_manager.path = GetStartupPath() .. [[\LuaMods\GW2Minion\SkillManagerProfiles\]]
gw2_skill_manager.profile = nil
gw2_skill_manager.currentSkill = nil
gw2_skill_manager.currentCombo = nil
gw2_skill_manager.currentComboSkill = nil
gw2_skill_manager.detecting = false
gw2_skill_manager.attacking = false
gw2_skill_manager.lastAttack = 0
gw2_skill_manager.ticks = 0
local _private = {}
local profilePrototype = {}

-- Init module
function gw2_skill_manager.ModuleInit()
	if (Settings.GW2Minion.gCurrentProfile == nil) then
		Settings.GW2Minion.gCurrentProfile = "None"
	end
	gw2_skill_manager.profile = gw2_skill_manager.GetProfile(Settings.GW2Minion.gCurrentProfile)
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
		profileName = table_invert(GW2.CHARCLASS)[Player.profession] .. "_" .. profileName
		local newProfile = {
			name = profileName,
			profession = Player.profession,
			professionSettings = {
				priorityKit = "None",
				PriorityAtt1 = "None",
				PriorityAtt2 = "None",
				PriorityAtt3 = "None",
				PriorityAtt4 = "None",
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

function gw2_skill_manager.GUIVarUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		-- Changes in skills
		-- Skill change
		if (
				k == "SklMgr_Target" or
				k == "SklMgr_GrndTarget" or
				k == "SklMgr_Healing" or
				k == "SklMgr_LOS" or
				k == "SklMgr_MinRange" or
				k == "SklMgr_MaxRange" or
				k == "SklMgr_InstantCast" or
				k == "SklMgr_LastSkillID" or
				k == "SklMgr_Delay")
			then
			local var = {	SklMgr_Target = "target",
							SklMgr_GrndTarget = "groundTargeted",
							SklMgr_Healing = "healing",
							SklMgr_LOS = "los",
							SklMgr_MinRange = "minRange",
							SklMgr_MaxRange = "maxRange",
							SklMgr_InstantCast = "instantCast",
							SklMgr_LastSkillID = "lastSkillID",
							SklMgr_Delay = "delay",
			}
			if (v == "true") then v = true elseif (v == "false") then v = false end
			if (tonumber(v) ~= nil) then v = tonumber(v) end
			gw2_skill_manager.profile.skills[gw2_skill_manager.currentSkill].skill[var[k]] = v
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
			local var = {	SklMgr_CombatState = "combatState",
							SklMgr_PMinHP = "minHP",
							SklMgr_PMaxHP = "maxHP",
							SklMgr_MinPower = "minPower",
							SklMgr_MaxPower = "maxPower",
							SklMgr_MinEndurance = "minEndurance",
							SklMgr_MaxEndurance = "maxEndurance",
							SklMgr_AllyCount = "allyNearCount",
							SklMgr_AllyRange = "allyRangeMax",
							SklMgr_PHasBuffs = "hasBuffs",
							SklMgr_PHasNotBuffs = "hasNotBuffs",
							SklMgr_PCondCount = "conditionCount",
							SklMgr_PBoonCount = "boonCount",
			}
			if (v == "true") then v = true elseif (v == "false") then v = false end
			if (tonumber(v) ~= nil) then v = tonumber(v) end
			gw2_skill_manager.profile.skills[gw2_skill_manager.currentSkill].player[var[k]] = v
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
			local var = {	SklMgr_Type = "type",
							SklMgr_TMinHP = "minHP",
							SklMgr_TMaxHP = "maxHP",
							SklMgr_EnemyCount = "enemyNearCount",
							SklMgr_EnemyRange = "enemyRangeMax",
							SklMgr_Moving = "moving",
							SklMgr_THasBuffs = "hasBuffs",
							SklMgr_THasNotBuffs = "hasNotBuffs",
							SklMgr_TCondCount = "conditionCount",
							SklMgr_TBoonCount = "boonCount",
			}
			if (v == "true") then v = true elseif (v == "false") then v = false end
			if (tonumber(v) ~= nil) then v = tonumber(v) end
			gw2_skill_manager.profile.skills[gw2_skill_manager.currentSkill].target[var[k]] = v
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
		-- Main window elements
		--mainWindow:NewButton(GetString("newCombo"),"gSMNewCombo")
		--RegisterEventHandler("gSMNewCombo",gw2_skill_manager.CreateNewComboDialog)
		mainWindow:NewButton(GetString("deleteProfile"),"gSMDeleteProfile")
		RegisterEventHandler("gSMDeleteProfile",_private.Delete)
		mainWindow:NewButton(GetString("saveProfile"),"gSMSaveProfile")
		RegisterEventHandler("gSMSaveProfile",_private.Save)
		mainWindow:UnFold(GetString("settings"))
		
		mainWindow:Hide()
	end
	if (mainWindow) then
		mainWindow:DeleteGroup(GetString("ProfessionSettings"))
		mainWindow:DeleteGroup(GetString("comboList"))
		mainWindow:DeleteGroup(GetString("skillList"))
		if (gw2_skill_manager.profile) then
			local name = gw2_skill_manager.profile.name
			name = string.sub(name,select(2,string.find(name,"_"))+1,#name)
			gSMCurrentProfileName_listitems = _private.GetProfileList(name)
			gSMCurrentProfileName = name
			
			local profession = Player.profession
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
		
			--for _,combo in ipairs(gw2_skill_manager.profile.combos) do
			--	mainWindow:NewButton(combo.priority .. ": " .. combo.name,"ComboEditWindowButton"..combo.priority,GetString("comboList"))
			--	RegisterEventHandler("ComboEditWindowButton"..combo.priority,gw2_skill_manager.ComboEditWindow)
			--end
			--if (openCombos) then mainWindow:UnFold(GetString("comboList")) end
			
			for _,skill in ipairs(gw2_skill_manager.profile.skills) do
				mainWindow:NewButton(skill.priority .. ": " .. skill.skill.name,"SkillEditWindowButton"..skill.priority,GetString("skillList"))
				RegisterEventHandler("SkillEditWindowButton"..skill.priority,gw2_skill_manager.SkillEditWindow)
			end
			if (openSkills) then mainWindow:UnFold(GetString("skillList")) end
		else
			gSMCurrentProfileName_listitems = _private.GetProfileList()
			gSMCurrentProfileName = "None"
		end
	end
end

function gw2_skill_manager.SkillEditWindow(skill)
	local editWindow = WindowManager:GetWindow(gw2_skill_manager.skillEditWindow.name)
	if (editWindow == nil) then
		-- Init Edit Window
		editWindow = WindowManager:NewWindow(gw2_skill_manager.skillEditWindow.name,gw2_skill_manager.skillEditWindow.x,gw2_skill_manager.skillEditWindow.y,gw2_skill_manager.skillEditWindow.w,gw2_skill_manager.skillEditWindow.h,true)
		-- Skill Section
		editWindow:NewNumeric(GetString("smSkillID"),"SklMgr_ID",GetString("Skill"))
		editWindow:NewField(GetString("name"),"SklMgr_Name",GetString("Skill"))
		editWindow:NewCheckBox(GetString("isGroundTargeted"),"SklMgr_GrndTarget",GetString("Skill"))
		editWindow:NewCheckBox(GetString("smsktypeheal"),"SklMgr_Healing",GetString("Skill"))
		editWindow:NewCheckBox(GetString("los"),"SklMgr_LOS",GetString("Skill"))
		editWindow:NewNumeric(GetString("minRange"),"SklMgr_MinRange",GetString("Skill"),0,6000)
		editWindow:NewNumeric(GetString("maxRange"),"SklMgr_MaxRange",GetString("Skill"),0,6000)
		editWindow:NewCheckBox(GetString("instantCast"),"SklMgr_InstantCast",GetString("Skill"))
		editWindow:NewField(GetString("prevSkillID"),"SklMgr_LastSkillID",GetString("Skill"))
		editWindow:NewNumeric(GetString("smDelay"),"SklMgr_Delay",GetString("Skill"))
		-- Player Section
		editWindow:NewComboBox(GetString("useOutOfCombat"),"SklMgr_CombatState",GetString("Player"),"Either,InCombat,OutCombat")
		editWindow:NewNumeric(GetString("playerHPLT"),"SklMgr_PMinHP",GetString("Player"),0,100)
		editWindow:NewNumeric(GetString("playerHPGT"),"SklMgr_PMaxHP",GetString("Player"),0,99)
		editWindow:NewNumeric(GetString("playerPowerLT"),"SklMgr_MinPower",GetString("Player"),0,100)
		editWindow:NewNumeric(GetString("playerPowerGT"),"SklMgr_MaxPower",GetString("Player"),0,99)
		editWindow:NewNumeric(GetString("playerEnduranceLT"),"SklMgr_MinEndurance",GetString("Player"),0,100)
		editWindow:NewNumeric(GetString("playerEnduranceGT"),"SklMgr_MaxEndurance",GetString("Player"),0,99)
		editWindow:NewNumeric(GetString("alliesNearCount"),"SklMgr_AllyCount",GetString("Player"))
		editWindow:NewNumeric(GetString("alliesNearRange"),"SklMgr_AllyRange",GetString("Player"))
		editWindow:NewField(GetString("playerHas"),"SklMgr_PHasBuffs",GetString("Player"))
		editWindow:NewField(GetString("playerHasNot"),"SklMgr_PHasNotBuffs",GetString("Player"))
		editWindow:NewNumeric(GetString("orPlayerCond"),"SklMgr_PCondCount",GetString("Player"))
		editWindow:NewNumeric(GetString("smBoonCount"),"SklMgr_PBoonCount",GetString("Player"))
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
			SklMgr_GrndTarget = lSkill.skill.groundTargeted
			SklMgr_Healing = lSkill.skill.healing
			SklMgr_LOS = lSkill.skill.los
			SklMgr_MinRange = lSkill.skill.minRange
			SklMgr_MaxRange = lSkill.skill.maxRange
			SklMgr_InstantCast = lSkill.skill.instantCast
			SklMgr_LastSkillID = lSkill.skill.lastSkillID
			SklMgr_Delay = lSkill.skill.delay
			-- Player
			SklMgr_CombatState = lSkill.player.combatState
			SklMgr_PMinHP = lSkill.player.minHP
			SklMgr_PMaxHP = lSkill.player.maxHP
			SklMgr_MinPower = lSkill.player.minPower
			SklMgr_MaxPower = lSkill.player.maxPower
			SklMgr_MinEndurance = lSkill.player.minEndurance
			SklMgr_MaxEndurance = lSkill.player.maxEndurance
			SklMgr_AllyCount = lSkill.skill.allyNearCount
			SklMgr_AllyRange = lSkill.skill.allyRangeMax
			SklMgr_PHasBuffs = lSkill.player.hasBuffs
			SklMgr_PHasNotBuffs = lSkill.player.hasNotBuffs
			SklMgr_PCondCount = lSkill.player.conditionCount
			SklMgr_PBoonCount = lSkill.player.boonCount
			-- Target
			SklMgr_Type = lSkill.target.type
			SklMgr_TMinHP = lSkill.target.minHP
			SklMgr_TMaxHP = lSkill.target.maxHP
			SklMgr_EnemyCount = lSkill.skill.enemyNearCount
			SklMgr_EnemyRange = lSkill.skill.enemyRangeMax
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
		dialog:SetOkFunction(function(list)
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

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- **pricate variables**
_private.maxRange = 154
--_private.runningIntoCombatRange = false -- TODO: order all variables nicely
_private.targetLosingHP = {id = 0, health = 0, timer = 0}
_private.SwapTimer = 0
_private.lastKitTable = {}
_private.skillLastCast = {}
_private.infSkillsActive = {targetID = nil, skill = 0}
_private.lastEvadedSkill = {targetID = 0, skillID = 0}
_private.combatMoveTmr = 0
_private.combatMoveActive = false

-- **private functions**
function _private.GetProfileList(newProfile)
	local profession = Player.profession
	local list = "None"
	if (profession) then
		local profileList = dirlist(gw2_skill_manager.path,".*lua")
		if (ValidTable(profileList)) then
			for _,profile in pairs(profileList) do
				profile = string.gsub(profile, ".lua", "")
				local prof = string.sub(profile,1,select(2,string.find(profile,"_"))-1)
				if (GW2.CHARCLASS[prof] == profession) then
					local name = string.sub(profile,select(2,string.find(profile,"_"))+1,#profile)
					if (name:match("%W") == nil) then
						list = list .. "," .. name
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
				if (skill.skill.name == skillInfo.name) then
					if (skill.skill.id ~= skillInfo.skillID) then
						newSkill = deepcopy(skill)
						newSkill.skill.id = skillInfo.skillID
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
							minRange		= skillInfo.minRange or 0,
							maxRange		= skillInfo.maxRange or 0,
							radius			= skillInfo.radius or 0,
							instantCast		= "0",
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
		if (gw2_common_functions.BufflistHasBuffs(target.buffs,"762")) then
			ml_blacklist.AddBlacklistEntry(GetString("monsters"),target.id,target.name,ml_global_information.Now+90000)
			d("this blacklisting so much?? :S!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
			Player:ClearTarget()
			return false
		end
	end
	return true
end

function _private.GetPredictedLocation(target)
	local tPos = target.pos
	local tSpeed = target.speed
	local tHeading = math.atan2(tPos.hx, tPos.hy)
	local newX = tSpeed * math.sin(tHeading) + tPos.x
	local newZ = tSpeed * math.cos(tHeading) + tPos.z
	return {x = newX, y = tPos.y, z = newZ}
end

function _private.TargetLosingHealth(target)
	if (target) then
		if ( _private.targetLosingHP.id ~= target.id ) then
			_private.targetLosingHP.id = target.id
			_private.targetLosingHP.health = target.health.current
			_private.targetLosingHP.timer = ml_global_information.Now
		elseif (TimeSince(_private.targetLosingHP.timer) > 10000 ) then
			_private.targetLosingHP.timer = ml_global_information.Now
			if (_private.targetLosingHP.health ~= 0 and _private.targetLosingHP.health < target.health.current) then
				ml_blacklist.AddBlacklistEntry(GetString("monsters"), target.id, target.name, ml_global_information.Now + 90000)
				Player:ClearTarget()
				d("!!!!!!!!!!!!!!!!!!!!!!!!!! did we need to blacklist??")
				return false
			else
				_private.lastHP = target.health.current
			end
		end
		return true
	end
end

function _private.GetAvailableSkills(skillList,heal)
	local skillbarSkills = {}
	local returnSkillList = {}
	for i = 1, 16, 1 do
		local skill = Player:GetSpellInfo(GW2.SKILLBARSLOT["Slot_" .. i])
		if (skill) then
			skillbarSkills[skill.skillID] = skill
		end
	end
	local newPriority = 1
	local maxRange = 154
	if ( ValidTable(skillList) and ValidTable(skillbarSkills) ) then
		for _,skill in ipairs(skillList) do
			for _,aSkill in pairs(skillbarSkills) do
				if (aSkill.skillID == skill.skill.id and aSkill.cooldown == 0 and (heal ~= true or skill.skill.healing == true)) then
					returnSkillList[newPriority] = skill
					returnSkillList[newPriority].slot = aSkill.slot
					returnSkillList[newPriority].maxCooldown = aSkill.cooldownmax
					newPriority = newPriority + 1
					if ((aSkill.slot >= GW2.SKILLBARSLOT.Slot_1  and aSkill.slot <= GW2.SKILLBARSLOT.Slot_5 and skill.skill.maxRange > 0 or skill.skill.radius > 0)) then
						maxRange = (skill.skill.maxRange > 0 and skill.skill.maxRange > maxRange and skill.skill.maxRange or maxRange)
						maxRange = (skill.skill.maxRange == 0 and skill.skill.radius > 0 and skill.skill.radius > maxRange and skill.skill.radius or maxRange)
					end
					break
				end
			end
		end
	end
	_private.maxRange = maxRange
	return (ValidTable(returnSkillList) and returnSkillList or {}),skillbarSkills
end

function _private.CanCast(skill,target)
	if (skill) then
		-- skill attributes
		if (skill.skill.lastSkillID ~= "" and tostring(skill.skill.lastSkillID) ~= Player.castinfo.lastSkillID) then return false end
		if (skill.skill.delay > 0 and _private.skillLastCast[skill.skill.id] ~= nil and TimeSince(_private.skillLastCast[skill.skill.id]) < (skill.skill.delay+skill.maxCooldown)) then return false end
		if (skill.skill.los == true and (target == nil or target.los == false)) then return false end
		if (skill.skill.minRange > 0 and (target == nil or target.distance < skill.skill.minRange)) then return false end
		if (skill.skill.maxRange > 0 and (target == nil or target.distance > skill.skill.maxRange)) then return false end
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
		if (skill.target.minHP > 0 and (target == nil or ml_global_information.Player_Health.percent > skill.target.minHP)) then return false end
		if (skill.target.maxHP > 0 and (target == nil or ml_global_information.Player_Health.percent < skill.target.maxHP)) then return false end
		if ( skill.target.enemyNearCount > 0) then
			local maxdistance = (skill.target.enemyRangeMax == 0 and "" or "maxdistance=" .. skill.target.enemyRangeMax .. ",")
			if (target == nil or TableSize(CharacterList("alive,attackable," .. maxdistance .. ",distanceto=" .. target.id .. "exclude=" .. target.id)) < skill.target.enemyNearCount) then return false end
		end
		if (skill.target.moving == "Yes" and (target == nil or target.movementstate == GW2.MOVEMENTSTATE.GroundNotMoving )) then return false end
		if (skill.target.moving == "No" and (target == nil or target.movementstate == GW2.MOVEMENTSTATE.GroundMoving )) then return false end
		if (skill.target.hasBuffs ~= "" and (target == nil or targetBuffList and not gw2_common_functions.BufflistHasBuffs(targetBuffList, tostring(skill.target.hasBuffs)))) then return false end
		if (skill.target.hasNotBuffs ~= "" and (target == nil or targetBuffList and gw2_common_functions.BufflistHasBuffs(targetBuffList, tostring(skill.target.hasNotBuffs)))) then return false end
		if (skill.target.conditionCount > 0 and (target == nil or targetBuffList and gw2_common_functions.CountConditions(targetBuffList) <= skill.target.conditionCount)) then return false end
		if (skill.target.boonCount > 0 and (target == nil or targetBuffList and gw2_common_functions.CountBoons(targetBuffList) <= skill.target.boonCount)) then return false end
		if (skill.target.type == "Character" and (target == nil or target.isCharacter == false)) then return false end
		if (skill.target.type == "Gadget" and (target == nil or target.isGadget == false)) then return false end
		-- skill can be cast
		return true
	end
	return false
end

function _private.SwapWeapon()
	if (TimeSince(_private.SwapTimer) > 750) then
		if (Player.profession == GW2.CHARCLASS.Elementalist) then 
			local switch
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
					switch = ((attunement[gSMPrioAtt1][1] ~= currentAttunement and not Player:IsSpellOnCooldown(attunement[gSMPrioAtt1][1]) and attunement[gSMPrioAtt1][1]) or
							(attunement[gSMPrioAtt2][1] ~= currentAttunement and not Player:IsSpellOnCooldown(attunement[gSMPrioAtt2][1]) and attunement[gSMPrioAtt2][1]) or
							(attunement[gSMPrioAtt3][1] ~= currentAttunement and not Player:IsSpellOnCooldown(attunement[gSMPrioAtt3]) and attunement[gSMPrioAtt3][1]) or
							(attunement[gSMPrioAtt4][1] ~= currentAttunement and not Player:IsSpellOnCooldown(attunement[gSMPrioAtt4][1]) and attunement[gSMPrioAtt4][1]))
				end
				if (switch) then
					Player:CastSpell(switch)
					_private.SwapTimer = ml_global_information.Now
				end
			end
		elseif( Player.profession == GW2.CHARCLASS.Engineer ) then
			local EngineerKits = {
				[5812] = "BombKit",
				[5927] = "FlameThrower",
				[6020] = "GrenadeKit",
				[5805] = "GrenadeKit",
				[5904] = "ToolKit",
				[5933] = "ElixirGun",
			}
			local availableSkills = _private.GetAvailableSkills()
			local availableKits = { [1] = { slot=0, skillID=0} }-- Leave Kit Placeholder
			for _,skill in ipairs(availableSkills) do
				if (skill and EngineerKits[skill.skill.id] and _private.lastKitTable[skill.slot] == nil or TimeSince(_private.lastKitTable[skill.slot].lastused) > 1500) then
					local kitcount = TableSize(availableKits)
					availableKits[kitcount+1] = {}
					availableKits[kitcount+1].slot = skill.slot
					availableKits[kitcount+1].skillID = skill.skill.id
				end
			end
			local key = math.random(1,TableSize(availableKits))
			if (key ~= 1) then
				Player:CastSpell(availableKits[key].slot)
				if (gSMPrioKit ~= "None" and EngineerKits[availableKits[key].skillID] ~= tostring(gSMPrioKit))then
					_private.lastKitTable[availableKits[key].slot] = { lastused = ml_global_information.Now + 15000 }
				else
					_private.lastKitTable[availableKits[key].slot] = { lastused = ml_global_information.Now }
				end
			elseif (Player:CanSwapWeaponSet()) then
				Player:SwapWeaponSet()
				_private.SwapTimer = ml_global_information.Now
			end
		elseif (Player:CanSwapWeaponSet()) then
			Player:SwapWeaponSet()
			_private.SwapTimer = ml_global_information.Now
		end
	end
end

function _private.AttackSkill(target,availableSkills)
	if (ValidTable(availableSkills)) then
		for _,skill in ipairs(availableSkills) do
			if (_private.CanCast(skill,target) == true) then
				if (target) then
					if (skill.skill.groundTargeted and target.movementstate == 3) then
						local pos = _private.GetPredictedLocation(target)
						Player:CastSpell(skill.slot,pos.x,pos.y,pos.z)
					else
						Player:CastSpell(skill.slot,target.id)
					end
				else
					Player:CastSpell(skill.slot)
				end
				_private.skillLastCast[skill.skill.id] = ml_global_information.Now
				if (_private.TargetLosingHealth(target) == false) then
					return false
				end
				return true
			end
		end
		_private.SwapWeapon()
	end
	return false
end

function _private:Evade()
	if (ml_global_information.Player_Endurance >= 50) then
		local targets = CharacterList("aggro")
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
				if (Player:CanEvade(direction[dir],100)) then
					_private.lastEvadedSkill.skillID = skillofTarget
					Player:Evade(direction[dir])
					return true
				end
			end
		end
	end
	return false
end

function _private.canMoveDirection(dir,distance)
	if (tonumber(dir) and tonumber(distance)) then
		local checkDist = distance/10
		for step=1,10 do
			if (Player:CanMoveDirection(dir,(checkDist*step)) == false) then
				return false
			end
		end
		return true
	end
end

function _private:DoCombatMovement()
	local target = Player:GetTarget()
	if (_private.combatMoveActive and target and ml_global_information.Player_Health.percent < 99 and gDoCombatMovement ~= "0") then
		if ( gw2_common_functions.HasBuffs(Player, "791,727") ) then return false end
		local Tdist = target.distance
		local playerHP = ml_global_information.Player_Health.percent
		local movedir = ml_global_information.Player_MovementDirections

		-- SET FACING TARGET
		Player:SetFacingExact(target.pos.x,target.pos.y,target.pos.z)

		--CONTROL CURRENT COMBAT MOVEMENT
		if ( Player:IsMoving() ) then

			if ( not Player.onmeshexact and (movedir.backward or movedir.left or movedir.right) ) then
				Player:UnSetMovement(1)
				Player:UnSetMovement(2)
				Player:UnSetMovement(3)
				local pPos = Player.pos
				if (pPos) then
					local mPos = NavigationManager:GetClosestPointOnMesh(pPos)
					if ( mPos ) then
						Player:MoveTo(mPos.x,mPos.y,mPos.z,50,false,false,false)
					end
				end
				return
			end

			if (tonumber(Tdist) ~= nil) then
				if (_private.maxRange > 300 and Tdist < (_private.maxRange / 4) and movedir.forward ) then -- we are too close and moving towards enemy
					Player:UnSetMovement(0)	-- stop moving forward
				elseif ( Tdist < (target.radius + 10) and movedir.forward) then
					Player:UnSetMovement(0)	-- stop moving forward
				elseif ( Tdist > _private.maxRange and movedir.backward ) then -- we are too far away and moving backwards
					Player:UnSetMovement(1)	-- stop moving backward
				elseif (Tdist > _private.maxRange and movedir.left) then -- we are strafing outside the maxrange
					Player:UnSetMovement(2) -- stop moving Left
				elseif (Tdist > _private.maxRange and movedir.right) then -- we are strafing outside the maxrange
					Player:UnSetMovement(3) -- stop moving Right
				end
			end
		end

		--Set New Movement
		if ( Tdist ~= nil and TimeSince(_private.combatMoveTmr) > 0 and Player.onmesh) then

			_private.combatMoveTmr = ml_global_information.Now + math.random(1000,2000)
			--tablecount:  1, 2, 3, 4, 5   --Table index starts at 1, not 0 
			local dirs = { 0, 1, 2, 3, 4 } --Forward = 0, Backward = 1, Left = 2, Right = 3, + stop

			if (_private.maxRange > 300 ) then
				-- RANGE
				if (Tdist < _private.maxRange ) then
					if (Tdist > (_private.maxRange * 0.95)) then 
						table.remove(dirs,2) -- We are too far away to walk backward
					end
					if (Tdist < (_private.maxRange / 4)) then 
						table.remove(dirs,1) -- We are too close to walk forward
					end	
					if (Tdist < 250) then 
						table.remove(dirs,5) -- We are too close, remove "stop"
						if (movedir.left ) then 
							table.remove(dirs,3) -- We are moving left, so don't try to go left
						end
						if (movedir.right ) then
							table.remove(dirs,4) -- We are moving right, so don't try to go right
						end
					end
				end

			else
				-- MELEE
				if (Tdist > _private.maxRange) then 
					table.remove(dirs,2) -- We are too far away to walk backwards
				end
				if (Tdist < (target.radius)) then 
					table.remove(dirs,1) -- We are too close to walk forwards
				end
			end
			-- Forward = 0, Backward = 1, Left = 2, Right = 3, + stop
			-- F = 3, B = 0, L = 6, R = 7, LF = 4, RF = 5, LB = 1, RB = 2
			if (_private.canMoveDirection(3,400) == false or _private.canMoveDirection(4,350) == false or _private.canMoveDirection(5,350) == false) then 
				Player:UnSetMovement(0)
				table.remove(dirs,1)
			end
			if (_private.canMoveDirection(0,400) == false or _private.canMoveDirection(1,350) == false or _private.canMoveDirection(2,350) == false) then 
				Player:UnSetMovement(1)
				table.remove(dirs,2)
			end
			if (_private.canMoveDirection(6,400) == false or _private.canMoveDirection(4,350) == false or _private.canMoveDirection(1,350) == false) then 
				Player:UnSetMovement(2)
				table.remove(dirs,3)
			end
			if (_private.canMoveDirection(7,400) == false or _private.canMoveDirection(5,350) == false or _private.canMoveDirection(2,350) == false) then 
				Player:UnSetMovement(3)
				table.remove(dirs,4)
			end

			-- MOVE
			local dir = dirs[ math.random( #dirs ) ]
			if (dir ~= 4) then
				Player:SetMovement(dir)
				_private.combatMoveActive = true
			else 
				Player:StopMovement()
			end
		end
	elseif (_private.combatMoveActive) then
		_private.combatMoveActive = false
		Player:StopMovement()
	end
	return false
end

function _private.Save()
	gw2_skill_manager.profile:Save()
	gw2_skill_manager.MainWindow()
	gw2_skill_manager.SkillEditWindow()
	local name = gw2_skill_manager.profile.name
	name = string.sub(name,select(2,string.find(name,"_"))+1,#name)
	Settings.GW2Minion.gCurrentProfile = name
end

function _private.Delete()
	gw2_skill_manager.profile:Delete()
	gw2_skill_manager.profile = nil
	Settings.GW2Minion.gCurrentProfile = "None"
	gw2_skill_manager.MainWindow()
end

function _private.DetectSkills(newProfile)
	local mainWindow = WindowManager:GetWindow(gw2_skill_manager.mainWindow.name)
	if (mainWindow) then 
		local button = mainWindow:GetControl(GetString("autoDetectSkills"))
		if (button and gw2_skill_manager.profile) then
			if (newProfile == true) then
				button:SetToggleState(true)
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
	gw2_skill_manager.MainWindow(true)
	gw2_skill_manager.SkillEditWindow()
end

function _private.MoveSkillUp()
	if (gw2_skill_manager.profile:MoveSkill(gw2_skill_manager.currentSkill,"up")) then
		gw2_skill_manager.currentSkill = gw2_skill_manager.currentSkill - 1
		gw2_skill_manager.MainWindow(true)
		gw2_skill_manager.SkillEditWindow(gw2_skill_manager.currentSkill)
	end
end

function _private.MoveSkillDown()
	if (gw2_skill_manager.profile:MoveSkill(gw2_skill_manager.currentSkill,"down")) then
		gw2_skill_manager.currentSkill = gw2_skill_manager.currentSkill + 1
		gw2_skill_manager.MainWindow(true)
		gw2_skill_manager.SkillEditWindow(gw2_skill_manager.currentSkill)
	end
end

function _private.CloneSkill()
	gw2_skill_manager.profile:CloneSkill(gw2_skill_manager.currentSkill)
	gw2_skill_manager.currentSkill = gw2_skill_manager.currentSkill + 1
	gw2_skill_manager.MainWindow(true)
	gw2_skill_manager.SkillEditWindow(gw2_skill_manager.currentSkill)
end

function _private.CopySkill()
	gw2_skill_manager.profile:CopySkill(gw2_skill_manager.currentSkill)
end

function _private.PasteSkill()
	gw2_skill_manager.profile:PasteSkill(gw2_skill_manager.currentSkill)
end

function _private:ReturnSkillByID(skills,id)
	if (ValidTable(skills) and tonumber(id)) then
		for _,skill in ipairs(skills) do
			if (skill.skill.id == id) then
				return deepcopy(skill)
			end
		end
		return nil
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- **profile prototype**
-- main profile stuff
function profilePrototype:Save()
	local saveFile = deepcopy(self)
	saveFile.clipboard = nil
	setmetatable(saveFile, {})
	persistence.store(gw2_skill_manager.path .. self.name .. ".lua", saveFile)
	return true
end

function profilePrototype:Delete()
	os.remove(gw2_skill_manager.path .. self.name .. ".lua")
	return true
end

function profilePrototype:Heal()
	if (Player.castinfo.duration == 0) then
		local pSkills = self.skills
		local skills = _private.GetAvailableSkills(pSkills,true)
		for priority=1,#skills do
			local skill = skills[priority]
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
		local pSkills = self.skills
		local skills,skillbarSkills = _private.GetAvailableSkills(pSkills)
		local maxRange = (target.inCombat == false and target.movementstate == GW2.MOVEMENTSTATE.GroundMoving and target.distance > _private.maxRange and _private.maxRange-(_private.maxRange/10) or _private.maxRange-10)
		if (target) then Player:SetTarget(target.id) end
		if (target == nil or target.distance < maxRange and target.los) then
		--if (target == nil or target.distance < _private.maxRange and target.los) then
			if (_private.runningIntoCombatRange == true) then Player:StopMovement() _private.runningIntoCombatRange = false end
			local lastSkillInfo = _private:ReturnSkillByID(pSkills,Player.castinfo.lastSkillID)
			_private:Evade()
			_private.combatMoveActive = true
			Player:SetFacingExact(target.pos.x,target.pos.y,target.pos.z)
			if (Player.castinfo.duration == 0 or (lastSkillInfo and lastSkillInfo.skill.instantCast == "1")) then
				if (_private.AttackSkill(target,skills)) then
					return true
				end
			end
		elseif (target and gMoveIntoCombatRange ~= "0") then
			if (_private.maxRange < 300 and target.distance > _private.maxRange) then _private:SwapWeapon() end
			gw2_common_functions.MoveOnlyStraightForward()
			local tPos = target.pos
			if (gw2_unstuck.HandleStuck() == false) then
				Player:MoveTo(tPos.x,tPos.y,tPos.z,50 + target.radius,false,false,true)
				_private.runningIntoCombatRange = true
			end
		end
	end
	return false
end

function profilePrototype:GetAttackRange()
	return _private.maxRange
end

-- main skill stuff
function profilePrototype:DetectSkills()
	for slot=1,16 do
		local newSkill = _private.CreateSkill(self.skills,slot)
		if (newSkill) then
			self.skills[newSkill.priority] = newSkill
			gw2_skill_manager.MainWindow(true)
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
	if (gw2_skill_manager.detecting == true) then
		gw2_skill_manager.profile:DetectSkills()
	end
	if (TimeSince(gw2_skill_manager.ticks) > 500) then
		gw2_skill_manager.ticks = ticks
		_private:DoCombatMovement()
		if (_private.runningIntoCombatRange and Player:GetTarget() == nil) then
			Player:StopMovement()
			_private.runningIntoCombatRange = false
		end
	end
end