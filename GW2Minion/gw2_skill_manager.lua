-- GW2Minion SkillManager
-- Creator: Jorith
gw2_skill_manager = {}
gw2_skill_manager.mainWindow = {name = GetString("skillManager"), x = 350, y = 50, w = 250, h = 350, groupsCreated = false, skillsCreated = false,}
gw2minion.MainWindow.ChildWindows[gw2_skill_manager.mainWindow.name] = gw2_skill_manager.mainWindow.name
gw2_skill_manager.skillWindow = {name = GetString("skillEditor"), x = 600, y = 50, w = 250, h = 550, currentSkill = 0,}
gw2minion.MainWindow.ChildWindows[gw2_skill_manager.skillWindow.name] = gw2_skill_manager.skillWindow.name
gw2_skill_manager.paths = { [1] = GetAddonPath() .. [[GW2Minion\SkillManagerProfiles\]]}  -- allowing others to add profiles from their own folders
gw2_skill_manager.currentSkillbarSkills = {}
gw2_skill_manager.profile = nil
gw2_skill_manager.status = {
	skillWindowCurrentPriority		= nil,
	detectingSkills					= false,
}

local profilePrototype = {
	name = "defaultName",
	profession = 10,
	professionSettings = {
		elementalist = {
			attunement_1 = "None",
			attunement_2 = "None",
			attunement_3 = "None",
			attunement_4 = "None",
		},
		engineer = {
			kit = "None",
		},
	},
	switchSettings = {
		switchWeapons = "1",
		switchOnRange = "0",
		switchRandom = "0",
		switchOnCooldown = 0,
	},
	skills = {},
	tmp = {
		maxAttackRange = 0,
		activeSkillRange = 154,
		combatMovement = {
			combat = false,
			range = false,
			allowed = true,
		},
		swapTimers = {
			lastSwap = 0,
			lastRandomSwap = 0,
			lastRangeSwap = 0,
		},
		targetCheck = {
			lastTicks = 0,
			id = 0,
			contentID = 0,
			health = {},
		},
		targetBlacklistBuffs = "762,785",
		path = gw2_skill_manager.paths[1],
	},
}
local skillPrototype = {
	parent = nil,
	skill = {	id					= 0,
				name				= "",
				groundTargeted		= "0",
				isProjectile		= "0",
				castOnSelf			= "0",
				relativePosition	= "None",
				los					= "1",
				setRange			= "0",
				minRange			= 0,
				maxRange			= 0,
				radius				= 0,
				slowCast			= "0",
				lastSkillID			= "",
				delay				= 0,
				stopsMovement		= "0",
				slot				= ml_global_information.MAX_SKILLBAR_SLOTS-1,
	},
	player = {	combatState			= "Either",
				minHP				= 0,
				maxHP				= 0,
				minPower			= 0,
				maxPower			= 0,
				minEndurance		= 0,
				maxEndurance		= 0,
				allyNearCount		= 0,
				allyRangeMax		= 0,
				allyDownedNearCount	= 0,
				allyDownedRangeMax	= 0,
				hasBuffs			= "",
				hasNotBuffs			= "",
				conditionCount		= 0,
				boonCount			= 0,
				moving				= "Either",
	},
	target = {	type				= "Either",
				minHP				= 0,
				maxHP				= 0,
				enemyNearCount		= 0,
				enemyRangeMax		= 0,
				moving				= "Either",
				hasBuffs			= "",
				hasNotBuffs			= "",
				conditionCount		= 0,
				boonCount			= 0,
	},
	tmp = {
		lastCastTime = 0,
		slot = ml_global_information.MAX_SKILLBAR_SLOTS-1,

	},
}


---------------------------------------------------------------------------------------------------------------------------------------------------------
-- **Init gw2_skill_manager**
---------------------------------------------------------------------------------------------------------------------------------------------------------

function gw2_skill_manager.ModuleInit()
	if (Settings.GW2Minion.gCurrentProfile == nil or ValidTable(Settings.GW2Minion.gCurrentProfile) == false) then
		Settings.GW2Minion.gCurrentProfile = {
			["Elementalist"] = "GW2Minion",
			["Engineer"] = "GW2Minion",
			["Guardian"] = "GW2Minion",
			["Mesmer"] = "GW2Minion",
			["Necromancer"] = "GW2Minion",
			["Ranger"] = "GW2Minion",
			["Thief"] = "GW2Minion",
			["Warrior"] = "GW2Minion",
			["Revenant"] = "GW2Minion",
		}
	end

	gw2_skill_manager.profile = gw2_skill_manager:GetProfile(Settings.GW2Minion.gCurrentProfile[gw2_common_functions.GetProfessionName()])

	local dw = WindowManager:GetWindow(gw2minion.DebugWindow.Name)
	if ( dw ) then
		--dw:NewField("CurrentAction","gSMCurrentAction",GetString("skillManager"))
	end

end
RegisterEventHandler("Module.Initalize",gw2_skill_manager.ModuleInit)


---------------------------------------------------------------------------------------------------------------------------------------------------------
-- **window functions**
---------------------------------------------------------------------------------------------------------------------------------------------------------

-- Create Main window.
function gw2_skill_manager:CreateMainWindow()
	local mainWindow = WindowManager:GetWindow(self.mainWindow.name)
	if (mainWindow) then
		return mainWindow
	else
		mainWindow = WindowManager:NewWindow(self.mainWindow.name,self.mainWindow.x,self.mainWindow.y,self.mainWindow.w,self.mainWindow.h,false)
		if (mainWindow) then
			mainWindow:NewComboBox(GetString("profile"),"gSMCurrentProfileName",GetString("settings"),gw2_skill_manager:GetProfileList())
			gSMCurrentProfileName = "None"
			mainWindow:NewButton(GetString("newProfile"),"gSMnewProfile",GetString("settings"))
			local button = mainWindow:NewButton(GetString("autoDetectSkills"),"gSMdetectSkills")
			button:SetToggleState(false)
			mainWindow:NewButton(GetString("deleteProfile"),"gSMdeleteProfile")
			mainWindow:NewButton(GetString("smCloneProfile"),"gSMcloneProfile")
			mainWindow:NewButton(GetString("saveProfile"),"gSMsaveProfile")
			mainWindow:UnFold(GetString("settings"))
			mainWindow:Hide()
			return mainWindow
		end
	end
	return false
end

-- Delete main window groups.
function gw2_skill_manager:MainWindowDeleteGroups()
	local mainWindow = WindowManager:GetWindow(self.mainWindow.name)
	if (mainWindow) then
		mainWindow:DeleteGroup(GetString("smProfessionSettings"))
		mainWindow:DeleteGroup(GetString("smSwitchSettings"))
		self.mainWindow.groupsCreated = false
		return true
	end
	return false
end

-- Create main window groups.
function gw2_skill_manager:MainWindowCreateGroups()
	local mainWindow = gw2_skill_manager:CreateMainWindow()
	if (mainWindow) then
		if (self:ProfileReady()) then
			-- update profile list in combobox.
			gSMCurrentProfileName_listitems = self:GetProfileList(self.profile.name)
			gSMCurrentProfileName = self.profile.name
			-- create swap settings group.
			--mainWindow:NewCheckBox(GetString("SwapRange"),"gSMSwitchOnRange",GetString("smSwitchSettings"))
			--mainWindow:NewCheckBox(GetString("SwapR"),"gSMSwitchRandom",GetString("smSwitchSettings"))
			--mainWindow:NewNumeric(GetString("SwapCD"),"gSMSwitchOnCooldown",GetString("smSwitchSettings"),0,20)
			--gSMSwitchOnRange = self.profile.switchSettings.switchOnRange
			--gSMSwitchRandom = self.profile.switchSettings.switchRandom
			--gSMSwitchOnCooldown = self.profile.switchSettings.switchOnCooldown
			mainWindow:NewCheckBox(GetString("Swap"),"gSMSwitchWeapon",GetString("smSwitchSettings"))
			gSMSwitchWeapon = self.profile.switchSettings.switchWeapons
			-- create profession settings group.
			local profession = ml_global_information.Player_Profession
			if (profession) then
				if (profession == GW2.CHARCLASS.Engineer) then
					mainWindow:NewComboBox(GetString("smPriorityKit"),"gSMPrioKit",GetString("smProfessionSettings"),"None,BombKit,FlameThrower,GrenadeKit,ToolKit,ElixirGun,EliteMortarKit")
					gSMPrioKit = self.profile.professionSettings.engineer.kit
				elseif(profession == GW2.CHARCLASS.Elementalist) then
					mainWindow:NewComboBox(GetString("smPriorityAttunement1"),"gSMPrioAtt1",GetString("smProfessionSettings"),"None,Fire,Water,Air,Earth")
					mainWindow:NewComboBox(GetString("smPriorityAttunement2"),"gSMPrioAtt2",GetString("smProfessionSettings"),"None,Fire,Water,Air,Earth")
					mainWindow:NewComboBox(GetString("smPriorityAttunement3"),"gSMPrioAtt3",GetString("smProfessionSettings"),"None,Fire,Water,Air,Earth")
					mainWindow:NewComboBox(GetString("smPriorityAttunement4"),"gSMPrioAtt4",GetString("smProfessionSettings"),"None,Fire,Water,Air,Earth")
					gSMPrioAtt1 = self.profile.professionSettings.elementalist.attunement_1
					gSMPrioAtt2 = self.profile.professionSettings.elementalist.attunement_2
					gSMPrioAtt3 = self.profile.professionSettings.elementalist.attunement_3
					gSMPrioAtt4 = self.profile.professionSettings.elementalist.attunement_4
				end
			end
		else
			-- update profile list in combobox.
			gSMCurrentProfileName_listitems = self:GetProfileList()
			gSMCurrentProfileName = "None"
		end
		self.mainWindow.groupsCreated = true
		return true
	end
	return false
end

-- Delete main window skills.
function gw2_skill_manager:MainWindowDeleteSkills()
	local mainWindow = WindowManager:GetWindow(self.mainWindow.name)
	if (mainWindow) then
		mainWindow:DeleteGroup(GetString("smSkillList"))
		self.mainWindow.skillsCreated = false
		return true
	end
	return false
end

-- Create main window skills.
function gw2_skill_manager:MainWindowCreateSkills()
	local mainWindow = gw2_skill_manager:CreateMainWindow()
	if (self:ProfileReady() and mainWindow) then
		for priority,skill in ipairs(gw2_skill_manager.profile.skills) do
			mainWindow:NewButton(priority .. ": " .. skill.skill.name,"gSMskillWindowButton"..priority,GetString("smSkillList"))
		end
		if (gw2_skill_manager.openSkills) then mainWindow:UnFold(GetString("smSkillList")) end
		mainWindow:UnFold(GetString("smSkillList"))
		self.mainWindow.skillsCreated = true
		return true
	end
	return false
end

-- Toggle Menu.
function gw2_skill_manager.ToggleMenu()
	local mainWindow = WindowManager:GetWindow(gw2_skill_manager.mainWindow.name)
	if (mainWindow) then
		if ( mainWindow.visible ) then
			mainWindow:Hide()
			local skillWindow = WindowManager:GetWindow(gw2_skill_manager.skillWindow.name)
			if ( skillWindow ) then
				skillWindow:Hide()
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

-- Create Skill window.
function gw2_skill_manager:CreateSkillWindow()
	local skillWindow = WindowManager:GetWindow(self.skillWindow.name)
	if (skillWindow) then
		return true
	else
		skillWindow = WindowManager:NewWindow(self.skillWindow.name,self.skillWindow.x,self.skillWindow.y,self.skillWindow.w,self.skillWindow.h,true)
		if (skillWindow) then
			-- Skill Section.
			skillWindow:NewNumeric(GetString("smSkillID"),"SklMgr_ID",GetString("smSkill"))
			skillWindow:NewField(GetString("name"),"SklMgr_Name",GetString("smSkill"))
			skillWindow:NewCheckBox(GetString("smIsProjectile"),"SklMgr_IsProjectile",GetString("smSkill"))
			skillWindow:NewCheckBox(GetString("smTargetSelf"),"SklMgr_CastOnSelf",GetString("smSkill"))
			skillWindow:NewCheckBox(GetString("los"),"SklMgr_LOS",GetString("smSkill"))
			skillWindow:NewCheckBox(GetString("smSetRange"),"SklMgr_SetRange",GetString("smSkill"))
			skillWindow:NewNumeric(GetString("minRange"),"SklMgr_MinRange",GetString("smSkill"),0,6000)
			skillWindow:NewNumeric(GetString("maxRange"),"SklMgr_MaxRange",GetString("smSkill"),0,6000)
			skillWindow:NewNumeric(GetString("smRadius"),"SklMgr_Radius",GetString("smSkill"),0,6000)
			skillWindow:NewCheckBox(GetString("smSlowCast"),"SklMgr_SlowCast",GetString("smSkill"))
			skillWindow:NewField(GetString("prevSkillID"),"SklMgr_LastSkillID",GetString("smSkill"))
			skillWindow:NewNumeric(GetString("smDelay"),"SklMgr_Delay",GetString("smSkill"))
			skillWindow:NewComboBox(GetString("smRelativePosition"),"SklMgr_RelativePosition",GetString("smSkill"),"None,Behind,In-front,Flanking")
			skillWindow:NewCheckBox(GetString("smStopsMovement"),"SklMgr_StopsMovement",GetString("smSkill"))
			-- Player Section.
			skillWindow:NewComboBox(GetString("useOutOfCombat"),"SklMgr_CombatState",GetString("smPlayer"),"Either,InCombat,OutCombat")
			skillWindow:NewNumeric(GetString("playerHPLT"),"SklMgr_PMinHP",GetString("smPlayer"),0,100)
			skillWindow:NewNumeric(GetString("playerHPGT"),"SklMgr_PMaxHP",GetString("smPlayer"),0,99)
			skillWindow:NewNumeric(GetString("playerPowerLT"),"SklMgr_MinPower",GetString("smPlayer"),0,100)
			skillWindow:NewNumeric(GetString("playerPowerGT"),"SklMgr_MaxPower",GetString("smPlayer"),0,99)
			skillWindow:NewNumeric(GetString("playerEnduranceLT"),"SklMgr_MinEndurance",GetString("smPlayer"),0,100)
			skillWindow:NewNumeric(GetString("playerEnduranceGT"),"SklMgr_MaxEndurance",GetString("smPlayer"),0,99)
			skillWindow:NewNumeric(GetString("alliesNearCount"),"SklMgr_AllyCount",GetString("smPlayer"))
			skillWindow:NewNumeric(GetString("alliesNearRange"),"SklMgr_AllyRange",GetString("smPlayer"))
			skillWindow:NewNumeric(GetString("alliesDownedNearCount"),"SklMgr_AllyDownedCount",GetString("smPlayer"))
			skillWindow:NewNumeric(GetString("alliesDownedNearRange"),"SklMgr_AllyDownedRange",GetString("smPlayer"))
			skillWindow:NewField(GetString("playerHas"),"SklMgr_PHasBuffs",GetString("smPlayer"))
			skillWindow:NewField(GetString("playerHasNot"),"SklMgr_PHasNotBuffs",GetString("smPlayer"))
			skillWindow:NewNumeric(GetString("smCondCount"),"SklMgr_PCondCount",GetString("smPlayer"))
			skillWindow:NewNumeric(GetString("smBoonCount"),"SklMgr_PBoonCount",GetString("smPlayer"))
			skillWindow:NewComboBox(GetString("playerMoving"),"SklMgr_PlayerMoving",GetString("smPlayer"),"Either,Moving,NotMoving")
			-- Target Section.
			skillWindow:NewComboBox(GetString("targetType"),"SklMgr_Type",GetString("targetType"),"Either,Character,Gadget")
			skillWindow:NewNumeric(GetString("playerHPLT"),"SklMgr_TMinHP",GetString("targetType"),0,100)
			skillWindow:NewNumeric(GetString("playerHPGT"),"SklMgr_TMaxHP",GetString("targetType"),0,99)
			skillWindow:NewNumeric(GetString("enemiesNearCount"),"SklMgr_EnemyCount",GetString("targetType"))
			skillWindow:NewNumeric(GetString("enemiesNearRange"),"SklMgr_EnemyRange",GetString("targetType"))
			skillWindow:NewComboBox(GetString("targetMoving"),"SklMgr_TargetMoving",GetString("targetType"),"Either,Moving,NotMoving")
			skillWindow:NewField(GetString("targetHas"),"SklMgr_THasBuffs",GetString("targetType"))
			skillWindow:NewField(GetString("targetHasNot"),"SklMgr_THasNotBuffs",GetString("targetType"))
			skillWindow:NewNumeric(GetString("smCondCount"),"SklMgr_TCondCount",GetString("targetType"))
			skillWindow:NewNumeric(GetString("smBoonCount"),"SklMgr_TBoonCount",GetString("targetType"))
			-- Buttons.
			skillWindow:NewButton(GetString("smDelete"),"gSMdeleteSkill")
			skillWindow:NewButton(GetString("smPaste"),"gSMpasteSkill")
			skillWindow:NewButton(GetString("smCopy"),"gSMcopySkill")
			skillWindow:NewButton(GetString("smClone"),"gSMcloneSkill")
			skillWindow:NewButton(GetString("smMoveDown"),"gSMmoveDownSkill")
			skillWindow:NewButton(GetString("smMoveUp"),"gSMmoveUpSkill")
			skillWindow:Hide()
			-- I cannot bear the pain to move 30 new skills manually 100 slots upwards each 
			skillWindow:NewNumeric("NewPriority","SklMgr_NewSKPrio","Dev",1,500)
			skillWindow:NewButton("Set Priority","gSMmoveSkill","Dev")
			return true
		end
	end
	return false
end

-- Update Skill window.
function gw2_skill_manager:SkillWindowUpdate(skillPriority)
	skillPriority = tonumber(skillPriority)
	self:CreateSkillWindow()
	local skillWindow = WindowManager:GetWindow(self.skillWindow.name)
	-- find skill info to update the window.
	local currentSkill = self:ProfileReady() and self.profile.skills[skillPriority] or nil
	if (skillWindow and currentSkill) then
		-- Hide if same button pressed.
		if (skillWindow.visible and self.status.skillWindowCurrentPriority == skillPriority) then
			skillWindow:Hide()
			return true
		end
		-- Update last priority field.
		self.status.skillWindowCurrentPriority = skillPriority
		-- Reset window position.
		local mainWindow = WindowManager:GetWindow(self.mainWindow.name)
		if (mainWindow) then
			skillWindow:SetPos(mainWindow.x+mainWindow.width,mainWindow.y)
		end
		-- Show skill window.
		skillWindow:Show()
		-- Skill section information.
		SklMgr_ID = currentSkill.skill.id
		SklMgr_Name = currentSkill.skill.name
		SklMgr_IsProjectile = currentSkill.skill.isProjectile
		SklMgr_CastOnSelf = currentSkill.skill.castOnSelf
		SklMgr_LOS = currentSkill.skill.los
		SklMgr_SetRange = currentSkill.skill.setRange
		SklMgr_MinRange = currentSkill.skill.minRange
		SklMgr_MaxRange = currentSkill.skill.maxRange
		SklMgr_Radius = currentSkill.skill.radius
		SklMgr_SlowCast = currentSkill.skill.slowCast
		SklMgr_LastSkillID = currentSkill.skill.lastSkillID
		SklMgr_Delay = currentSkill.skill.delay
		SklMgr_RelativePosition = currentSkill.skill.relativePosition
		SklMgr_StopsMovement = currentSkill.skill.stopsMovement
		skillWindow:UnFold(GetString("smSkill"))
		-- Player section information.
		SklMgr_CombatState = currentSkill.player.combatState
		SklMgr_PMinHP = currentSkill.player.minHP
		SklMgr_PMaxHP = currentSkill.player.maxHP
		SklMgr_MinPower = currentSkill.player.minPower
		SklMgr_MaxPower = currentSkill.player.maxPower
		SklMgr_MinEndurance = currentSkill.player.minEndurance
		SklMgr_MaxEndurance = currentSkill.player.maxEndurance
		SklMgr_AllyCount = currentSkill.player.allyNearCount
		SklMgr_AllyRange = currentSkill.player.allyRangeMax
		SklMgr_AllyDownedCount = currentSkill.player.allyDownedNearCount
		SklMgr_AllyDownedRange = currentSkill.player.allyDownedRangeMax
		SklMgr_PHasBuffs = currentSkill.player.hasBuffs
		SklMgr_PHasNotBuffs = currentSkill.player.hasNotBuffs
		SklMgr_PCondCount = currentSkill.player.conditionCount
		SklMgr_PBoonCount = currentSkill.player.boonCount
		SklMgr_PlayerMoving = currentSkill.player.moving
		-- Target section information.
		SklMgr_Type = currentSkill.target.type
		SklMgr_TMinHP = currentSkill.target.minHP
		SklMgr_TMaxHP = currentSkill.target.maxHP
		SklMgr_EnemyCount = currentSkill.target.enemyNearCount
		SklMgr_EnemyRange = currentSkill.target.enemyRangeMax
		SklMgr_TargetMoving = currentSkill.target.moving
		SklMgr_THasBuffs = currentSkill.target.hasBuffs
		SklMgr_THasNotBuffs = currentSkill.target.hasNotBuffs
		SklMgr_TCondCount = currentSkill.target.conditionCount
		SklMgr_TBoonCount = currentSkill.target.boonCount
		return true
	elseif (skillWindow) then
		skillWindow:Hide()
		-- Update last priority field.
		self.status.skillWindowCurrentPriority = skillPriority
		return true
	end
	-- Update last priority field.
	self.status.skillWindowCurrentPriority = skillPriority
	return false
end


---------------------------------------------------------------------------------------------------------------------------------------------------------
-- **button functions**
---------------------------------------------------------------------------------------------------------------------------------------------------------

-- New Profile dialog.
function gw2_skill_manager:NewProfileDialog()
	local dialog = gw2_dialog_manager:GetDialog(GetString("newProfileName"))
	if (dialog == nil) then
		dialog = gw2_dialog_manager:NewDialog(GetString("newProfileName"))
		dialog:NewField(GetString("newProfileName"),"smDialogNewProfileName")
		dialog:SetOkFunction(
			function(list)
				if (ValidString(_G[list])) then
					gw2_skill_manager.profile = gw2_skill_manager:NewProfile(_G[list])
					gw2_skill_manager:SkillWindowUpdate()
					gw2_skill_manager:MainWindowDeleteGroups()
					gw2_skill_manager:MainWindowDeleteSkills()
					gw2_skill_manager:DetectSkillsButton(true)
					return true
				end
				return "Please enter " .. GetString("newProfileName") .. " first."
			end
		)
	end
	if (dialog) then
		dialog:Show()
		return true
	end
	return false
end

-- Clone profile dialog.
function gw2_skill_manager:CloneProfileDialog()
	if (self:ProfileReady()) then
		local dialog = gw2_dialog_manager:GetDialog(GetString("smCloneProfile"))
		if (dialog == nil) then
			dialog = gw2_dialog_manager:NewDialog(GetString("smCloneProfile"))
			dialog:NewField(GetString("smCloneProfile"),"smDialogCloneProfileName")
			dialog:SetOkFunction(
				function(name)
					local name = _G[name]
					if (ValidString(name)) then
						if (StringContains(gw2_skill_manager:GetProfileList(), name)) then return "Profile with that name already exists, please choose a new name." end
						gw2_skill_manager.profile:Clone(name)
						gw2_skill_manager.profile = gw2_skill_manager:GetProfile(name)
						gw2_skill_manager:SkillWindowUpdate()
						gw2_skill_manager:MainWindowDeleteGroups()
						gw2_skill_manager:MainWindowDeleteSkills()
						gw2_skill_manager:DetectSkillsButton(false)
						return true
					end
					return "Please enter " .. GetString("smCloneProfile") .. " name first."
				end
			)
		end
		if (dialog) then
			dialog:Show()
			return true
		end
	end
	return false
end

-- Delete profile dialog.
function gw2_skill_manager:DeleteProfileDialog()
	if (self:ProfileReady()) then
		local dialog = gw2_dialog_manager:GetDialog(GetString("delete"))
		if (dialog == nil) then
			dialog = gw2_dialog_manager:NewDialog(GetString("delete"))
			dialog:NewLabel("!!WARNING!! - This will permanently delete this profile.")
			dialog:SetOkFunction(
				function()
					if (gw2_skill_manager.profile:Delete()) then
						gw2_skill_manager:DetectSkillsButton(false)
						gw2_skill_manager.profile = nil
						Settings.GW2Minion.gCurrentProfile[gw2_common_functions.GetProfessionName()] = "None"
						Settings.GW2Minion.gCurrentProfile = Settings.GW2Minion.gCurrentProfile
						gw2_skill_manager:SkillWindowUpdate()
						gw2_skill_manager:MainWindowDeleteGroups()
						gw2_skill_manager:MainWindowDeleteSkills()
						return true
					end
					return false
				end
			)
		end
		if (dialog) then
			dialog:Show()
			return true
		end
	end
	return false
end

-- Save profile button.
function gw2_skill_manager:SaveProfileButton()
	if (self:ProfileReady() and self.profile:Save()) then
		Settings.GW2Minion.gCurrentProfile[gw2_common_functions.GetProfessionName()] = self.profile.name
		Settings.GW2Minion.gCurrentProfile = Settings.GW2Minion.gCurrentProfile
		gw2_skill_manager:DetectSkillsButton(false)
	end
end

-- Detect skills button.
function gw2_skill_manager:DetectSkillsButton(status)
	local mainWindow = WindowManager:GetWindow(self.mainWindow.name)
	if (mainWindow) then
		local button = mainWindow:GetControl(GetString("autoDetectSkills"))
		if (self:ProfileReady() and button) then
			if (type(status) == "boolean") then
				button:SetToggleState(status)
			end
			if (button.pressed) then
				self.status.detectingSkills = true
				button:SetText("Stop "..GetString("autoDetectSkills"))
				return true
			else
				self.status.detectingSkills = false
				button:SetText(GetString("autoDetectSkills"))
				return true
			end
		else
			button:SetToggleState(false)
		end
	end
	return false
end

-- Clone skill button.
function gw2_skill_manager:CloneSkillButton()
	if (self:ProfileReady()) then
		if (self.profile:CloneSkill(self.status.skillWindowCurrentPriority)) then
			gw2_skill_manager:MainWindowDeleteSkills()
			return true
		end
	end
	return false
end

-- Move skill up.
function gw2_skill_manager:MoveSkillUpButton()
	if (self:ProfileReady()) then
		if (self.profile:MoveSkill(self.status.skillWindowCurrentPriority,"up")) then
			self.status.skillWindowCurrentPriority = self.status.skillWindowCurrentPriority - 1
			gw2_skill_manager:MainWindowDeleteSkills()
			return true
		end
	end
	return false
end

-- Move skill down.
function gw2_skill_manager:MoveSkillDownButton()
	if (self:ProfileReady()) then
		if (self.profile:MoveSkill(self.status.skillWindowCurrentPriority,"down")) then
			self.status.skillWindowCurrentPriority = self.status.skillWindowCurrentPriority + 1
			gw2_skill_manager:MainWindowDeleteSkills()
			return true
		end
	end
	return false
end

-- Move skill to Priority
function gw2_skill_manager:MoveSkillButton()
	if (self:ProfileReady()) then
		if (self.profile:MoveSkill(self.status.skillWindowCurrentPriority,"to")) then
			self.status.skillWindowCurrentPriority = self.status.skillWindowCurrentPriority + 1
			gw2_skill_manager:MainWindowDeleteSkills()
			return true
		end
	end
	return false
end

-- Copy skill.
function gw2_skill_manager:CopySkillButton()
	if (self:ProfileReady()) then
		return self.profile:CopySkill(self.status.skillWindowCurrentPriority)
	end
	return false
end

-- Paste skill.
function gw2_skill_manager:PasteSkillButton()
	if (self:ProfileReady()) then
		if (self.profile:PasteSkill(self.status.skillWindowCurrentPriority)) then
			gw2_skill_manager:SkillWindowUpdate()
			return true
		end
	end
	return false
end

-- Delete skill.
function gw2_skill_manager:DeleteSkillButton()
	if (self:ProfileReady()) then
		if (self.profile:DeleteSkill(self.status.skillWindowCurrentPriority)) then
			self.status.skillWindowCurrentPriority = nil
			gw2_skill_manager:MainWindowDeleteSkills()
			gw2_skill_manager:SkillWindowUpdate()
			return true
		end
	end
	return false
end

-- Sort skills
function gw2_skill_manager:SortSkills()
	if (self:ProfileReady()) then
		self.profile:SortSkills()
		gw2_skill_manager:MainWindowDeleteSkills()
		gw2_skill_manager:SkillWindowUpdate()
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- **Profile functions**
---------------------------------------------------------------------------------------------------------------------------------------------------------

-- New profile.
function gw2_skill_manager:NewProfile(profileName)
	if (GetGameState() == 16 and ValidString(profileName) and profileName ~= "None") then
		profileName = string.gsub(profileName,'%W','')
		local list = self:GetProfileList()
		for name in StringSplit(list,",") do
			if (name == profileName) then return self:GetProfile(profileName) end
		end
		local newProfile = {
			name = profileName,
			profession = ml_global_information.Player_Profession,

		}
		newProfile = inheritTable(profilePrototype, newProfile)
		return newProfile
	end
	return nil
end

-- Get profile.
function gw2_skill_manager:GetProfile(profileName)
	if (GetGameState() == 16 and ValidString(profileName) and profileName ~= "None") then
		profileName = string.gsub(profileName,'%W','')
		profileName = gw2_common_functions.GetProfessionName() .. "_" .. profileName
		for _,path in pairs (self.paths) do 
			local profile = persistence.load(path .. profileName .. ".lua")
			if (profile) then
				profile = inheritTable(profilePrototype, profile)
				for _,skill in ipairs(profile.skills) do
					skill = inheritTable(skillPrototype, skill)
					skill.parent = setmetatable({},{__index = profile, __newindex = profile})
				end
				profile.tmp.path = path
				return profile
			end
		end
	end
	return nil
end

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- **Skill-Manager fucntions**
---------------------------------------------------------------------------------------------------------------------------------------------------------

-- Check for profile.
function gw2_skill_manager:ProfileReady()
	if (ValidTable(self.profile)) then
		return true
	end
	--ml_error("No current profile, please select or create a profile first.")
	return false
end

-- Get profile list.
function gw2_skill_manager:GetProfileList(newProfile)
	local profession = ml_global_information.Player_Profession
	local list = "None"
	if (profession) then
		for i,p in pairs (self.paths) do 
			local profileList = dirlist(p,".*lua")
			if (ValidTable(profileList)) then
				for _,profileName in pairs(profileList) do
					local profile = persistence.load(p .. profileName)
					if (ValidTable(profile)) then
						if (profile.profession == ml_global_information.Player_Profession and ValidString(profile.name)) then
							list = list .. "," .. profile.name
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

-- Update current skills.
function gw2_skill_manager:UpdateCurrentSkillbarSkills() -- TODO:check curentskill list garbage stuff
	self.currentSkillbarSkills = {}
	for i = 1, ml_global_information.MAX_SKILLBAR_SLOTS-1 do
		local currentSkill = Player:GetSpellInfo(GW2.SKILLBARSLOT["Slot_" .. i])
		if (currentSkill) then			
			local sName = currentSkill.name
			local sID = currentSkill.skillID
			self.currentSkillbarSkills[currentSkill.skillID] = currentSkill
			
			--Auto-update Profile with changed skillnames and skillIDs .. any ideas if that is a bad idea?..worked well so far			
			if ( self.profile ~= nil and sID and sName and sName ~= "") then 
				local profilechanged = false
				local inList = false
				for priority,skill in pairs(self.profile.skills) do
					if (skill.skill.id == sID) then
						if (skill.skill.name ~= sName) then
							skill.skill.name = sName
							d("CHANGED SKILLNAME FOUND: ".. skill.skill.name.. " != "..sName)
							profilechanged = true
						end
						inList = true
						break
					end
				end
				if ( not inList ) then
					for priority,skill in pairs(self.profile.skills) do
						if (skill.skill.name == sName and skill.skill.id ~= sID) then
							d("NEW SKILLID FOR EXISTING SKILL FOUND.."..tostring(sID).." "..sName)
							-- We have a skill with the same name but a different skillID, add it automatically..bad idea ?
							if (self.profile.skills[priority]) then
								local clone = deepcopy(self.profile.skills[priority])
								clone.skill.id = sID
								clone.skill.groundTargeted	= (currentSkill.isGroundTargeted == true and "1" or "0")
								clone.skill.setRange		= (tonumber(i) >= 1 and tonumber(i) <= 5 and "1" or "0")
								clone.skill.minRange		= currentSkill.minRange or 0
								clone.skill.maxRange		= currentSkill.maxRange or 0
								clone.skill.radius			= currentSkill.radius or 0
								clone.player.maxPower		= currentSkill.power or 0
								table.insert(self.profile.skills, priority+1, clone)
								profilechanged = true
							end
							break
						end
					end
				end
				if ( profilechanged == true ) then
					self:MainWindowDeleteSkills() -- Refresh UI
				end
			end
		end
	end
	
	gw2_skill_manager.UpdateSkillTrackerData()	
end

-- Detect skills.
function gw2_skill_manager:DetectSkills()
	if (self:ProfileReady() and self.status.detectingSkills) then
		local nmbrOfSkills = #self.profile.skills
		self.profile:DetectSkills()
		if (nmbrOfSkills < #self.profile.skills) then
			self:MainWindowDeleteSkills()
		end
	end
end

-- Use skill profile.
function gw2_skill_manager:Use(targetID)
	if (gBotRunning == "1" and self:ProfileReady()) then
		targetID = tonumber(targetID)
		if (self.status.attacking and targetID == nil) then self.status.attacking = false return end -- prevent calling task by on-update loop if already used by other task (combat for example).
		-- use here
		self.profile:Use(targetID)
		--^^^^^^^^^
		self.status.attacking = targetID ~= nil
	end
end

-- Get Max Attack Range.
function gw2_skill_manager.GetMaxAttackRange()
	if (gw2_skill_manager:ProfileReady()) then
		return gw2_skill_manager.profile.tmp.maxAttackRange < 154 and 154 or gw2_skill_manager.profile.tmp.maxAttackRange
	end
	return 154
end

function gw2_skill_manager.RegisterProfilePath(path)
	if (ValidString(path) and TableContains(gw2_skill_manager.paths, path) == false) then
		table.insert(gw2_skill_manager.paths,path)
	end
end


---------------------------------------------------------------------------------------------------------------------------------------------------------
-- **profile prototype**
---------------------------------------------------------------------------------------------------------------------------------------------------------

-- Save.
function profilePrototype:Save()
	local saveFile = deepcopy(self)
	saveFile.clipboard = nil
	saveFile.tmp = nil
	if (ValidTable(saveFile.skills)) then
		for _,skill in pairs(saveFile.skills) do
			skill.tmp = nil
			skill.parent = nil
		end
	end
	
	persistence.store(self.tmp.path .. gw2_common_functions.GetProfessionName(saveFile.profession) .. "_" .. saveFile.name .. ".lua", saveFile)	
	return true
end

-- Delete.
function profilePrototype:Delete()
	os.remove(self.path .. gw2_common_functions.GetProfessionName(self.profession) .. "_" .. self.name .. ".lua")
	return true
end

-- Clone.
function profilePrototype:Clone(newName)
	if (ValidString(newName)) then
		local saveFile = deepcopy(self)
		saveFile.name = newName
		return saveFile:Save()
	end
	return false
end

-- Use profile.
function profilePrototype:Use(targetID)
	self.tmp.activeSkillRange = 154
	Player:SetTarget(targetID)
	self:Swap(targetID)
	self:CheckTargetBuffs(targetID)
	for k,skill in ipairs(self.skills) do
		if (skill:CanCast(targetID)) then
			self:CheckTargetHealth(targetID)
			skill:Cast(targetID)
			break
		end
	end
	self:DoCombatMovement(targetID)
	return true
end

-- Do CombatMovement
function profilePrototype:DoCombatMovement(targetID)
	local target = CharacterList:Get(targetID) or GadgetList:Get(targetID)
	local noStopMovementBuffs = gw2_common_functions.HasBuffs(Player,"791,727") == false
	if (ValidTable(target) and self.tmp.combatMovement.allowed and target.distance <= (self.tmp.activeSkillRange + 250) and noStopMovementBuffs and gDoCombatMovement ~= "0" and ml_global_information.Player_OnMesh and ml_global_information.Player_Alive and ml_global_information.Player_Health.percent < 99) then
		gw2_common_functions.Evade()
		local forward,backward,left,right,forwardLeft,forwardRight,backwardLeft,backwardRight = GW2.MOVEMENTTYPE.Forward,GW2.MOVEMENTTYPE.Backward,GW2.MOVEMENTTYPE.Left,GW2.MOVEMENTTYPE.Right,4,5,6,7
		local currentMovement = ml_global_information.Player_MovementDirections
		local movementDirection = {[forward] = true, [backward] = true,[left] = true,[right] = true,}
		local tDistance = target.distance
		-- Stop walking into range.
		if (self.tmp.combatMovement.range and target.distance < self.tmp.activeSkillRange - 250) then Player:StopMovement() self.tmp.combatMovement.range = false end
		-- Face target.
		if (ValidTable(target)) then Player:SetFacingExact(target.pos.x,target.pos.y,target.pos.z) end
		-- Range, walking too close to enemy, stop walking forward.
		if (self.tmp.activeSkillRange > 300 and tDistance < (self.tmp.activeSkillRange / 2)) then movementDirection[forward] = false end
		-- Range, walking too far from enemy, stop walking backward.
		if (self.tmp.activeSkillRange > 300 and tDistance > self.tmp.activeSkillRange * 0.95) then movementDirection[backward] = false end
		-- Melee, walking too close to enemy, stop walking forward.
		if (tDistance < target.radius) then movementDirection[forward] = false end
		-- Melee, walking too far from enemy, stop walking backward.
		if (tDistance > self.tmp.activeSkillRange) then movementDirection[backward] = false end
		-- We are strafing too far from target, stop walking left or right.
		if (tDistance > self.tmp.activeSkillRange) then
			movementDirection[left] = false
			movementDirection[right] = false
		end
		-- Can we move in direction, while staying on the mesh.
		if (movementDirection[forward] and gw2_common_functions.CanMoveDirection(forward,400) == false) then movementDirection[forward] = false end
		if (movementDirection[backward] and gw2_common_functions.CanMoveDirection(backward,400) == false) then movementDirection[backward] = false end
		if (movementDirection[left] and gw2_common_functions.CanMoveDirection(left,400) == false) then movementDirection[left] = false end
		if (movementDirection[right] and gw2_common_functions.CanMoveDirection(right,400) == false) then movementDirection[right] = false end
		--
		if (movementDirection[forward]) then
			if (movementDirection[left] and gw2_common_functions.CanMoveDirection(forwardLeft,300) == false) then
				movementDirection[left] = false
			elseif (movementDirection[right] and gw2_common_functions.CanMoveDirection(forwardRight,300) == false) then
				movementDirection[right] = false
			end
		elseif (movementDirection[backward]) then
			if (movementDirection[left] and gw2_common_functions.CanMoveDirection(backwardLeft,300) == false) then
				movementDirection[left] = false
			elseif (movementDirection[right] and gw2_common_functions.CanMoveDirection(backwardRight,300) == false) then
				movementDirection[right] = false
			end
		end

		-- Can we move in direction, while not walking towards potential enemy's.
		local targets = CharacterList("alive,los,notaggro,attackable,hostile,maxdistance=1500,exclude="..target.id)

		if (movementDirection[forward] and TableSize(gw2_common_functions.filterRelativePostion(targets,forward)) > 0) then movementDirection[forward] = false end
		if (movementDirection[backward] and TableSize(gw2_common_functions.filterRelativePostion(targets,backward)) > 0) then movementDirection[backward] = false end
		if (movementDirection[left] and TableSize(gw2_common_functions.filterRelativePostion(targets,left)) > 0) then movementDirection[left] = false end
		if (movementDirection[right] and TableSize(gw2_common_functions.filterRelativePostion(targets,right)) > 0) then movementDirection[right] = false end
		--
		if (movementDirection[forward]) then
			if (movementDirection[left] and TableSize(gw2_common_functions.filterRelativePostion(targets,forwardLeft)) > 0) then
				movementDirection[left] = false
			elseif (movementDirection[right] and TableSize(gw2_common_functions.filterRelativePostion(targets,forwardRight)) > 0) then
				movementDirection[right] = false
			end
		elseif (movementDirection[backward]) then
			if (movementDirection[left] and TableSize(gw2_common_functions.filterRelativePostion(targets,backwardLeft)) > 0) then
				movementDirection[left] = false
			elseif (movementDirection[right] and TableSize(gw2_common_functions.filterRelativePostion(targets,backwardRight)) > 0) then
				movementDirection[right] = false
			end
		end

		-- We know where we can move, decide where to go.
		if (movementDirection[forward] and movementDirection[backward]) then -- Can move forward and backward, choose.
			if (currentMovement.forward) then -- We are moving forward already.
				if (math.random(0,25) ~= 3) then -- Keep moving backwards gets higher chance.
					movementDirection[forward] = false
				else
					movementDirection[backward] = false
				end
			elseif (currentMovement.backward) then -- We are moving backward already.
				if (math.random(0,25) ~= 3) then -- Keep moving backward gets higher chance.
					movementDirection[forward] = false
				else
					movementDirection[backward] = false
				end
			end
		end
		if (movementDirection[left] and movementDirection[right]) then -- Can move left and right, choose.
			if (currentMovement.left) then -- We are moving left already.
				if (math.random(0,35) ~= 3) then -- Keep moving left gets higher chance.
					movementDirection[right] = false
				else
					movementDirection[left] = false
				end
			elseif (currentMovement.right) then -- We are moving right already.
				if (math.random(0,35) ~= 3) then -- Keep moving right gets higher chance.
					movementDirection[left] = false
				else
					movementDirection[right] = false
				end
			end
		end

		-- Execute combat movement.
		for direction,canMove in pairs(movementDirection) do
			if (canMove) then
				Player:SetMovement(direction)
			end
		end
		self.tmp.combatMovement.combat = true
	elseif (ValidTable(target) and target.distance > self.tmp.activeSkillRange and noStopMovementBuffs and (gBotMode ~= GetString("assistMode") or gMoveIntoCombatRange == "1") and not gw2_unstuck.HandleStuck("combat") and ml_global_information.Player_OnMesh and ml_global_information.Player_Alive) then
		local tPos = target.pos
		if (self.tmp.combatMovement.combat) then Player:StopMovement() self.tmp.combatMovement.combat = false end
		Player:MoveTo(tPos.x,tPos.y,tPos.z,self.tmp.activeSkillRange/2,false,false,true)
		self.tmp.combatMovement.range = true
	elseif (self.tmp.combatMovement.combat or self.tmp.combatMovement.range) then -- Stop active combat movement.
		Player:StopMovement()
		self.tmp.combatMovement.combat = false
		self.tmp.combatMovement.range = false
	end
end

-- Detect skills.
function profilePrototype:DetectSkills()
	for slot=1, ml_global_information.MAX_SKILLBAR_SLOTS-1 do
		self:CreateSkill(slot)
	end
	return true
end

-- Create skill.
function profilePrototype:CreateSkill(skillSlot)
	if (skillSlot) then
		local skillInfo = Player:GetSpellInfo(GW2.SKILLBARSLOT["Slot_" .. skillSlot])
		local newSkill = {}
		if (skillInfo and skillInfo.skillID ~= 10586 and ValidString(skillInfo.name)) then
			for priority,skill in pairs(self.skills) do
				if (skill.skill.id == skillInfo.skillID) then
					if (skill.skill.name ~= skillInfo.name) then
						skill.skill.name = skillInfo.name
						return true
					end
					return false
				end
			end
			newSkill = {
				skill = {	id				= skillInfo.skillID,
							name			= skillInfo.name,
							groundTargeted	= (skillInfo.isGroundTargeted == true and "1" or "0"),
							setRange		= (tonumber(skillSlot) >= 1 and tonumber(skillSlot) <= 5 and "1" or "0"),
							minRange		= skillInfo.minRange or 0,
							maxRange		= skillInfo.maxRange or 0,
							radius			= skillInfo.radius or 0,							
							slot			= skillInfo.slot or ml_global_information.MAX_SKILLBAR_SLOTS-1,
				},
				player = {	maxPower		= skillInfo.power or 0,
				},				
				parent = setmetatable({},{__index = self, __newindex = self}),
			}
			newSkill = inheritTable(skillPrototype, newSkill)
			-- If the skillname exists already in our List, add it right behind the existing one, I hate to move every skill "up" 100 lines ;)
			for priority,skill in pairs(self.skills) do
				if (skill.skill.name == skillInfo.name) then
					table.insert(self.skills, priority+1, newSkill)
					return true
				end
			end
			table.insert(self.skills,newSkill)
			return true
		end
	end
	return false
end

-- Clone skill.
function profilePrototype:CloneSkill(skillPriority)
	if (self.skills[skillPriority]) then
		local clone = deepcopy(self.skills[skillPriority])
		table.insert(self.skills, skillPriority+1, clone)
		return true
	end
	return false
end

-- Move skill.
function profilePrototype:MoveSkill(skillPriority, direction)
	local skill = self.skills[skillPriority]
	if (ValidTable(skill) and direction) then
		local newPriority = (direction == "up" and skillPriority > 1 and skillPriority - 1 or direction == "down" and skillPriority < #self.skills and skillPriority + 1 or direction == "to" and tonumber(SklMgr_NewSKPrio) and tonumber(SklMgr_NewSKPrio) >= 1 and tonumber(SklMgr_NewSKPrio) <= #self.skills and tonumber(SklMgr_NewSKPrio))
		if (newPriority) then
			table.remove(self.skills,skillPriority)
			table.insert(self.skills,newPriority,skill)
			return true
		end
	end
	return false
end

-- Copy skill.
function profilePrototype:CopySkill(skillPriority)
	if (self.skills[skillPriority]) then
		self.clipboard = deepcopy(self.skills[skillPriority])
		self.clipboard.priority = nil
		self.clipboard.skill.id = nil
		self.clipboard.skill.name = nil
		return true
	end
	return false
end

-- Paste skill.
function profilePrototype:PasteSkill(skillPriority)
	if (self.clipboard) then
		self.clipboard.priority = self.skills[skillPriority].priority
		self.clipboard.skill.id = self.skills[skillPriority].skill.id
		self.clipboard.skill.name = self.skills[skillPriority].skill.name
		self.skills[skillPriority] = deepcopy(self.clipboard)
		return true
	end
	return false
end

-- Delete skill.
function profilePrototype:DeleteSkill(skillPriority)
	if (tonumber(skillPriority)) then
		table.remove(self.skills, skillPriority)
		return true
	end
	return false
end

-- Get skill byID.
function profilePrototype:GetSkillByID(skillID)
	for _,skill in ipairs(self.skills) do
		if (skill.skill.id == skillID) then
			return skill
		end
	end
	return
end

-- Check Target Health.
function profilePrototype:CheckTargetHealth(targetID)
	local target = CharacterList:Get(targetID) or GadgetList:Get(targetID)
	if (ValidTable(target) and target.id ~= Player.id) then
		if (target.id ~= self.tmp.targetCheck.id or target.contentID ~= self.tmp.targetCheck.contentID) then
			self.tmp.targetCheck = {
				id = target.id,
				contentID = target.conentID,
				health = target.health,
				lastTicks = ml_global_information.Now,
			}
		elseif (ml_global_information.Now - self.tmp.lastTicks > 2500) then
			self.tmp.targetCheck = {
				id = target.id,
				contentID = target.conentID,
				health = target.health,
				lastTicks = ml_global_information.Now,
			}
			if (target.health.percent > (self.tmp.health.percent + 10) or (ml_global_information.Now - self.tmp.lastTicks > 15000 and target.health.percent == 100)) then
				d("!!!!!!!!!!!!!!! TARGET BLACKLISTED, NOT DYING !!!!!!!!!!!!!!!")
				ml_blacklist.AddBlacklistEntry(GetString("monsters"), target.contentID, target.name, ml_global_information.Now + 90000)
			end
		end
	end
end

-- Check Target Buffs.
function profilePrototype:CheckTargetBuffs(targetID)
	local target = CharacterList:Get(targetID) or GadgetList:Get(targetID)
	if (ValidTable(target) and target.id ~= Player.id) then
		if (gw2_common_functions.BufflistHasBuffs(target.buffs,self.tmp.targetBlacklistBuffs)) then
			d("!!!!!!!!!!!!!!! TARGET BLACKLISTED, INVUNRABLE BUFFS !!!!!!!!!!!!!!!")
			ml_blacklist.AddBlacklistEntry(GetString("monsters"),target.contentID,target.name,ml_global_information.Now+30000)
		end
	end
end

-- Swap pet.
function profilePrototype:SwapPet()
	if (ml_global_information.Player_Profession == GW2.CHARCLASS.Ranger) then
		local pet = Player:GetPet()
		if (Player:CanSwitchPet() and ml_global_information.Player_Alive and ValidTable(pet) and (pet.alive == false or pet.health.percent < 15)) then
			Player:SwitchPet()
			return true
		end
		return false
	end
end

-- Swap attunement.
function profilePrototype:SwapAttunement()
	if (ml_global_information.Player_Profession == GW2.CHARCLASS.Elementalist) then
		local settings = self.professionSettings.elementalist
		local attunements = {["Fire"] = GW2.SKILLBARSLOT.Slot_13, ["Water"] = GW2.SKILLBARSLOT.Slot_14, ["Air"] = GW2.SKILLBARSLOT.Slot_15, ["Earth"] = GW2.SKILLBARSLOT.Slot_16,}
		local currentAttunement = (gw2_common_functions.HasBuffs(Player, "5585") and "Fire" or gw2_common_functions.HasBuffs(Player, "5586") and "Water" or gw2_common_functions.HasBuffs(Player, "5575") and "Air" or gw2_common_functions.HasBuffs(Player, "5580") and "Earth")
		attunements[currentAttunement] = nil
		local newAttunement = (attunements[settings.attunement_1] or attunements[settings.attunement_2] or attunements[settings.attunement_3] or attunements[settings.attunement_4] or GetRandomTableEntry(attunement))
		if (newAttunement) then
			Player:CastSpell(newAttunement)
		end
	end
end

-- This little thingy tracks the cooldown and ranges of the different skillbars, so the bot can switch n swap weapons more intelligently
gw2_skill_manager.SkillTracker = {
	
	-- enums, using ml_global_information.Player_CurrentWeaponSet as key
	weaponsetname = {
		[0] = "Aqua1",
		[1] = "Aqua2",
		[2] = "Kit/Astral",
		[3] = "LichForm",
		[4] = "Weapon1",
		[5] = "Weapon2",
	},
	
	-- enums, using ml_global_information.Player_TransformID as key
	transformidname = {
		--[0] = "not yet unlocked",
		[1] = "FireAttunement",
		[2] = "WaterAttunement",
		[3] = "AitAttunement",
		[4] = "EartheAttunement",
		[5] = "DeathShroud",
		
		[9] = "RangerNormalForm",
		[10] = "RangerAstralForm",	
	},
	
	-- Main weapon table
	weapons = {
		-- default weapons are needed
		[0] = { name = "Aqua1",	range = {},  cooldowns = {} },
		[1] = { name = "Aqua2",	range = {},  cooldowns = {} },
		[4] = { name = "Weapon1",	range = {},  cooldowns = {} },
		[5] = { name = "Weapon2",	range = {},  cooldowns = {} }
	},
	
	-- Elementalist (using ml_global_information.Player_TransformID as key) 1 - 4 is attunment	
	elelastswap = 0, -- 1,25 sec all attunements are on cd after a swap
	attunements = {
		[1] = { name = "Fire", 			range = {}, cooldowns = { }, lastswap = 0},
		[2] = { name = "Water", 		range = {}, cooldowns = { }, lastswap = 0},
		[3] = { name = "Air", 			range = {}, cooldowns = { }, lastswap = 0},
		[4] = { name = "Earth", 		range = {}, cooldowns = { }, lastswap = 0},
	},
	
	-- Engineer
	engilastswap = 0, -- there is at least 1 second cd after swapping
	kits = {			
			[5812] = { name = "BombKit", 		range = { [GW2.SKILLBARSLOT.Slot_1] = 300, [GW2.SKILLBARSLOT.Slot_2] = 300, [GW2.SKILLBARSLOT.Slot_3]= 300, [GW2.SKILLBARSLOT.Slot_4] = 300, [GW2.SKILLBARSLOT.Slot_5] = 300		}, cooldowns = { }, inuse = false},
			[5927] = { name = "FlameThrower",	range = { [GW2.SKILLBARSLOT.Slot_1] = 425, [GW2.SKILLBARSLOT.Slot_2] = 600, [GW2.SKILLBARSLOT.Slot_3]= 300, [GW2.SKILLBARSLOT.Slot_4] = 600, [GW2.SKILLBARSLOT.Slot_5] = 180		}, cooldowns = { }, inuse = false},
			[6020] = { name = "GrenadeKit",		range = { [GW2.SKILLBARSLOT.Slot_1] = 900, [GW2.SKILLBARSLOT.Slot_2] = 900, [GW2.SKILLBARSLOT.Slot_3]= 900, [GW2.SKILLBARSLOT.Slot_4] = 900, [GW2.SKILLBARSLOT.Slot_5] = 900 		}, cooldowns = { }, inuse = false},
			[5805] = { name = "GrenadeKit",		range = { [GW2.SKILLBARSLOT.Slot_1] = 900, [GW2.SKILLBARSLOT.Slot_2] = 900, [GW2.SKILLBARSLOT.Slot_3]= 900, [GW2.SKILLBARSLOT.Slot_4] = 900, [GW2.SKILLBARSLOT.Slot_5] = 900 		}, cooldowns = { }, inuse = false},
			[5904] = { name = "ToolKit",		range = { [GW2.SKILLBARSLOT.Slot_1] = 155, [GW2.SKILLBARSLOT.Slot_2] = 240, [GW2.SKILLBARSLOT.Slot_3]= 155, [GW2.SKILLBARSLOT.Slot_4] = 0,   [GW2.SKILLBARSLOT.Slot_5] = 0  		}, cooldowns = { }, inuse = false},
			[5933] = { name = "ElixirGun",		range = { [GW2.SKILLBARSLOT.Slot_1] = 900, [GW2.SKILLBARSLOT.Slot_2] = 900, [GW2.SKILLBARSLOT.Slot_3]= 450, [GW2.SKILLBARSLOT.Slot_4] = 180, [GW2.SKILLBARSLOT.Slot_5] = 0  		}, cooldowns = { }, inuse = false},
			[30800] ={ name = "EliteMortarKit", range = { [GW2.SKILLBARSLOT.Slot_1] = 1500, [GW2.SKILLBARSLOT.Slot_2] = 1500, [GW2.SKILLBARSLOT.Slot_3]= 1500, [GW2.SKILLBARSLOT.Slot_4] = 1500, [GW2.SKILLBARSLOT.Slot_5] = 1500	}, cooldowns = { }, inuse = false},
	},
	stowkits = {
		[6110] = 6020, -- Stow GrenadeKit
		[6111] = 5812, -- Stow BombKit
		[6114] = 5927, -- Stow FlameThrower
		[6115] = 5933, -- Stow ElixirGun
		[6113] = 5904, -- Stow ToolKit
		[29905] = 30800, -- Stow EliteMortarKit
	},
}
-- for the player:cast(), so it knows which entry to modify 
function gw2_skill_manager.GetCurrentSkillTrackerEntry()	
	-- Weapons
	if (ml_global_information.Player_Profession ~= GW2.CHARCLASS.Elementalist and (ml_global_information.Player_Profession ~= GW2.CHARCLASS.Engineer or ml_global_information.Player_Profession == GW2.CHARCLASS.Engineer and ml_global_information.Player_CurrentWeaponSet ~= 2 )) then			
		return gw2_skill_manager.SkillTracker.weapons[ml_global_information.Player_CurrentWeaponSet]		
	
	--Elementalist
	elseif (ml_global_information.Player_Profession == GW2.CHARCLASS.Elementalist and ml_global_information.Player_TransformID >= 1 and ml_global_information.Player_TransformID <=4) then
		return gw2_skill_manager.SkillTracker.attunements[ml_global_information.Player_TransformID]
	
	-- Engineer
	elseif (ml_global_information.Player_Profession == GW2.CHARCLASS.Engineer) then		
		for stowID,kitID in pairs(gw2_skill_manager.SkillTracker.stowkits) do
			if ( ValidTable(gw2_skill_manager.currentSkillbarSkills[stowID]) ) then
				return gw2_skill_manager.SkillTracker.kits[kitID]
			end
		end
	end
end
-- Gets called from UpdateCurrentSkillbarSkills()
function gw2_skill_manager.UpdateSkillTrackerData( )

-- Weapons
	if (ml_global_information.Player_Profession ~= GW2.CHARCLASS.Elementalist) then
		
		-- Don't record the weaponset if it is an Engineer kit
		if ( ml_global_information.Player_Profession ~= GW2.CHARCLASS.Engineer or ml_global_information.Player_Profession == GW2.CHARCLASS.Engineer and ml_global_information.Player_CurrentWeaponSet ~= 2 ) then
			-- Create a new Entry in the Skilltracker for our current weaponset
			if ( not ValidTable(gw2_skill_manager.SkillTracker.weapons[ml_global_information.Player_CurrentWeaponSet]) ) then
				gw2_skill_manager.SkillTracker.weapons[ml_global_information.Player_CurrentWeaponSet] = { name = gw2_skill_manager.SkillTracker.weaponsetname[ml_global_information.Player_CurrentWeaponSet] or "Unknown",	range = {},  cooldowns = {} }
			end
			
			-- Update the data of the current weaponset
			for _skillID,skill in pairs(gw2_skill_manager.currentSkillbarSkills) do
				if ( skill.slot >= GW2.SKILLBARSLOT.Slot_1 and skill.slot <= GW2.SKILLBARSLOT.Slot_5) then 
					gw2_skill_manager.RefreshSkillTrackerEntry(	gw2_skill_manager.SkillTracker.weapons[ml_global_information.Player_CurrentWeaponSet], skill.slot, skill )
				end
			end
		end
		
		-- Update the cooldown data of the weapons not currently equipped				
		for wpsetID,weaponset in pairs(gw2_skill_manager.SkillTracker.weapons) do						
			for i=GW2.SKILLBARSLOT.Slot_1, GW2.SKILLBARSLOT.Slot_5 do
				gw2_skill_manager.RefreshSkillTrackerEntry( weaponset, i , nil )
			end
		end
	end

-- Elementalist Kits
	if (ml_global_information.Player_Profession == GW2.CHARCLASS.Elementalist and ml_global_information.Player_TransformID >= 1 and ml_global_information.Player_TransformID <=4) then
		-- Update currently equipped Attument weaponset
		for _skillID,skill in pairs(gw2_skill_manager.currentSkillbarSkills) do
			if ( skill.slot >= GW2.SKILLBARSLOT.Slot_1 and skill.slot <= GW2.SKILLBARSLOT.Slot_5) then 
				gw2_skill_manager.RefreshSkillTrackerEntry(gw2_skill_manager.SkillTracker.attunements[ml_global_information.Player_TransformID], skill.slot, skill)
			end
		end
		-- Update not equipped Attunement Cooldowns
		for TransformID,attunement in pairs(gw2_skill_manager.SkillTracker.attunements) do
			for i=GW2.SKILLBARSLOT.Slot_1, GW2.SKILLBARSLOT.Slot_5 do
				gw2_skill_manager.RefreshSkillTrackerEntry( attunement, i , nil )
			end
		end	
	end
	
-- Engineer Kits
	if (ml_global_information.Player_Profession == GW2.CHARCLASS.Engineer) then
		for stowID,kitID in pairs(gw2_skill_manager.SkillTracker.stowkits) do
			if ( ValidTable(gw2_skill_manager.currentSkillbarSkills[stowID]) ) then
				gw2_skill_manager.SkillTracker.kits[kitID].inuse = true
				-- We have this kit equipped currently, update the data
				--d("USING : "..gw2_skill_manager.SkillTracker.kits[kitID].name)
				if (ValidTable(gw2_skill_manager.SkillTracker.kits[kitID])) then 
					
					-- Find skill.slot 1 - 5 in gw2_skill_manager.currentSkillbarSkills and update our SkillTracker data
					for _skillID,skill in pairs(gw2_skill_manager.currentSkillbarSkills) do
						if ( skill.slot >= GW2.SKILLBARSLOT.Slot_1 and skill.slot <= GW2.SKILLBARSLOT.Slot_5) then 
							gw2_skill_manager.RefreshSkillTrackerEntry(gw2_skill_manager.SkillTracker.kits[kitID], skill.slot, skill)
						end
					end
				else
					d("ERROR@gw2_skill_manager@UpdateEngineerKitData, Unknown KitID: "..tostring(kitID))
				end
				
			else
				if ( ValidTable(gw2_skill_manager.currentSkillbarSkills[kitID]) ) then
					gw2_skill_manager.SkillTracker.kits[kitID].inuse = true
				else
					gw2_skill_manager.SkillTracker.kits[kitID].inuse = false
				end
			end
		end
		-- Update the cooldown data of the kits not currently equipped
		for kitID,kit in pairs(gw2_skill_manager.SkillTracker.kits) do
			for i=GW2.SKILLBARSLOT.Slot_1, GW2.SKILLBARSLOT.Slot_5 do
				gw2_skill_manager.RefreshSkillTrackerEntry( kit, i , nil )
			end
		end		
	end
	-- Debug Testing output ;)
	--[[
	for ID,entry in pairs(gw2_skill_manager.SkillTracker.weapons) do
		for i=5,9 do
			trackerdata[entry.name.."_"..tostring(i)] = "Range:"..tostring(entry.range[i]).." CD:"..tostring(entry.cooldowns[i].current).."/"..tostring(entry.cooldowns[i].maxcd)
		end
	end
	for ID,entry in pairs(gw2_skill_manager.SkillTracker.kits) do
		for i=5,9 do
			trackerdata[entry.name.."_"..tostring(i)] = "Range:"..tostring(entry.range[i]).." CD:"..tostring(entry.cooldowns[i].current).."/"..tostring(entry.cooldowns[i].maxcd)
		end
	end
	for ID,entry in pairs(gw2_skill_manager.SkillTracker.attunements) do
		for i=5,9 do
			trackerdata[entry.name.."_"..tostring(i)] = "Range:"..tostring(entry.range[i]).." CD:"..tostring(entry.cooldowns[i].current).."/"..tostring(entry.cooldowns[i].maxcd)
		end
	end
	, lastswap = 0
	d(trackerdata)]]
end
function gw2_skill_manager.RefreshSkillTrackerEntry( trackerEntry, slot, skilldata, timestamp_cast )
	-- Make sure the cooldown table is valid on this trackerEntry
	if ( not ValidTable(trackerEntry.cooldowns[slot]) ) then
		trackerEntry.cooldowns[slot] = {maxcd = 0, current = 0, timestamp = 0}
	end
	if ( not trackerEntry.range[slot] ) then
		trackerEntry.range[slot] = 0
	end
	
	local cdTable = trackerEntry.cooldowns[slot]
			
	if ( ValidTable(skilldata) ) then
		-- Update range & maxcd in case they are not set
		cdTable.maxcd = skilldata.cooldownmax or 0		
		trackerEntry.range[slot] = skilldata.maxRange or 150
		
		-- Check for skills which went on cooldown		
		if ( cdTable.maxcd > 0 ) then
			if ( skilldata.cooldown ~= 0 or timestamp_cast ~= nil) then
				-- skill is on cooldown or was just cast
				if ( cdTable.timestamp == 0 ) then
					-- set the time when the bot noticed that the skill went on cooldown
					cdTable.timestamp = timestamp_cast or ml_global_information.Now -- ~1000 is the ~time that already passes until the data is being refreshed, so a 10s cd starts at 9sec to be visible
				end
			else
				-- make sure we are not having a current cooldown (timing hickups)
				if ( cdTable.timestamp ~= 0 and ml_global_information.Now - cdTable.timestamp > 1500) then
					cdTable.timestamp = 0
					cdTable.current = 0
				end
			end
		end
	else
		-- Update the cooldown timer
		if ( cdTable.timestamp ~= 0 ) then
			cdTable.current = cdTable.maxcd - (ml_global_information.Now - cdTable.timestamp)
			
			-- skill is not on cd anymore
			if ( cdTable.current <= 0 ) then
				cdTable.timestamp = 0
				cdTable.current = 0
			end
		end
	end
end

-- Can Swap kit.
function profilePrototype:SwapWeapon( targetdist )
	local currentwpset = gw2_skill_manager.GetCurrentSkillTrackerEntry()
	
	-- Get a list of usable weaponsets
	local wpsets = {}
	if ( Player.inCombat and ( Player:CanSwapWeaponSet() or ml_global_information.Player_CurrentWeaponSet == 2) ) then 
		if ( ml_global_information.Player_SwimState == GW2.SWIMSTATE.NotInWater ) then
			if ( ml_global_information.Player_CurrentWeaponSet ~= 4 and ValidTable(gw2_skill_manager.SkillTracker.weapons[4])) then wpsets[4] = { set = gw2_skill_manager.SkillTracker.weapons[4], prio = 0 } end
			if ( ml_global_information.Player_Level > 9 and ml_global_information.Player_Profession ~= GW2.CHARCLASS.Engineer and ml_global_information.Player_Profession ~= GW2.CHARCLASS.Elementalist ) then -- this is needed, else the not existing weapon 2 is being added as "possible to swap to" set
				if ( ml_global_information.Player_CurrentWeaponSet ~= 5 and ValidTable(gw2_skill_manager.SkillTracker.weapons[5])) then wpsets[5] = { set = gw2_skill_manager.SkillTracker.weapons[5], prio = 0 } end		
			end
		
		elseif ( ml_global_information.Player_SwimState == GW2.SWIMSTATE.Diving ) then
			if ( ml_global_information.Player_CurrentWeaponSet ~= 0 and ValidTable(gw2_skill_manager.SkillTracker.weapons[0])) then wpsets[0] = { set = gw2_skill_manager.SkillTracker.weapons[0], prio = 0 } end
			if ( ml_global_information.Player_CurrentWeaponSet ~= 1 and ValidTable(gw2_skill_manager.SkillTracker.weapons[1])) then wpsets[1] = { set = gw2_skill_manager.SkillTracker.weapons[1], prio = 0 } end				
		end
	end
	
	-- Elementalist	
	if (ml_global_information.Player_Profession == GW2.CHARCLASS.Elementalist and ml_global_information.Now - gw2_skill_manager.SkillTracker.elelastswap > 1250) then		
		if ( ml_global_information.Player_TransformID ~= 1 and ValidTable(gw2_skill_manager.SkillTracker.attunements[1]) and self:CanCastSlot(GW2.SKILLBARSLOT.Slot_13)) then wpsets[13] = { set = gw2_skill_manager.SkillTracker.attunements[1], prio = 0 } end
		if ( ml_global_information.Player_TransformID ~= 2 and ValidTable(gw2_skill_manager.SkillTracker.attunements[2]) and self:CanCastSlot(GW2.SKILLBARSLOT.Slot_14)) then wpsets[14] = { set = gw2_skill_manager.SkillTracker.attunements[2], prio = 0 } end
		if ( ml_global_information.Player_TransformID ~= 3 and ValidTable(gw2_skill_manager.SkillTracker.attunements[3]) and self:CanCastSlot(GW2.SKILLBARSLOT.Slot_15)) then wpsets[15] = { set = gw2_skill_manager.SkillTracker.attunements[3], prio = 0 } end
		if ( ml_global_information.Player_TransformID ~= 4 and ValidTable(gw2_skill_manager.SkillTracker.attunements[4]) and self:CanCastSlot(GW2.SKILLBARSLOT.Slot_16)) then wpsets[16] = { set = gw2_skill_manager.SkillTracker.attunements[4], prio = 0 } end
	end
	
	-- Engineer Kits
	if (ml_global_information.Player_Profession == GW2.CHARCLASS.Engineer and ml_global_information.Now - gw2_skill_manager.SkillTracker.engilastswap > 1000) then		
		if ( currentwpset ) then
			for kitID,kit in pairs(gw2_skill_manager.SkillTracker.kits) do
				--d(kit.name.." active "..tostring(kit.inuse))
				if ( kit.inuse and kit ~= currentwpset ) then
					--d(kit.name.." ~ = "..currentwpset.name)
					wpsets[kitID] = { set = kit, prio = 0 }
				end
			end
		end
	end
	--d("CanSwapWeapon TableSize :"..tostring(TableSize(wpsets)))
	--d(wpsets)
	
	-- Add our current weaponset
	if ( currentwpset ) then
		wpsets[100] = {set = currentwpset, prio = 1 }
	end
	
	-- Evaluate & Swap	
	if ( TableSize(wpsets) > 0 ) then
		local bestwpset
		local bestID
		for setID,entry in pairs(wpsets) do
			local israngeweapon = false
			-- We should switch to that skill asap so the data gets set/initialized			
			if ( not ValidTable(entry.set.range) or not ValidTable(entry.set.cooldowns)) then
				entry.prio = 6
			
			else				
				for i=GW2.SKILLBARSLOT.Slot_1, GW2.SKILLBARSLOT.Slot_5 do
					if ( i == GW2.SKILLBARSLOT.Slot_1 and entry.set.range[i] > 500) then
						israngeweapon = true
					end
					
					if ( entry.set.cooldowns[i].current == 0 ) then -- max gain +5
						entry.prio = entry.prio + 1
						
						if ( not israngeweapon or (israngeweapon and targetdist > 300 )) then
							if ( (entry.set.range[i] == 0 and targetdist < 155) or entry.set.range[i]+50 >= targetdist ) then -- max gain +5
								entry.prio = entry.prio + 1
							end							
						end
					end
					--d(entry.set.name.."SK:"..tostring(i).." Prio:"..tostring(entry.prio) .. " InRange:"..tostring(entry.set.range[i]+150).." >= "..tostring(targetdist))
				end				
			end
			
			-- Bonus for Elementalist Prefered Priority
			local settings = self.professionSettings.elementalist
			if ( entry.set.name == settings.attunement_1 ) then
				entry.prio = entry.prio + 3
			elseif ( entry.set.name == settings.attunement_2 ) then
				entry.prio = entry.prio + 2
			elseif ( entry.set.name == settings.attunement_3 ) then
				entry.prio = entry.prio + 1
			elseif ( entry.set.name == settings.attunement_4 ) then
				entry.prio = entry.prio + 0.5
			end
			
			-- Bonus for Engineer Prefered Kit/Astral
			if ( entry.set.name == self.professionSettings.engineer.kit ) then
				entry.prio = entry.prio + 2
			end
			
			if ( not bestwpset or bestwpset.prio < entry.prio ) then
				bestwpset = entry
				bestID = setID
			end
			
		end	
				
		--for setID,entry in pairs(wpsets) do
		--	d("Set : "..tostring(entry.prio).." "..entry.set.name)
		--end
				
		if ( bestwpset.set.name ~= currentwpset.name ) then
			--d("Switching from "..currentwpset.name.." to "..bestwpset.set.name.. " (Prio "..tostring(bestwpset.prio)..") setID:"..tostring(bestID))
			if ( bestID <= 5 ) then-- weaponswap
				Player:SwapWeaponSet()
			
			elseif ( bestID >= 13 and bestID <=16) then -- attunement
				local slot = GW2.SKILLBARSLOT["Slot_" .. bestID]
				if ( Player:CastSpell(slot) ) then
					gw2_skill_manager.SkillTracker.elelastswap = ml_global_information.Now
				end
				
			elseif ( bestID > 100 ) then -- engi kitID								
				for _skillID,skill in pairs(gw2_skill_manager.currentSkillbarSkills) do
					for kitID,kit in pairs(gw2_skill_manager.SkillTracker.kits) do
						if (_skillID == kitID ) then
							if ( Player:CastSpell(skill.slot) ) then
								gw2_skill_manager.SkillTracker.engilastswap = ml_global_information.Now
							end
						end
					end	
				end				
			end
		end
	end	
end

function profilePrototype:CanCastSlot(slot)
	for _skillID,skill in pairs(gw2_skill_manager.currentSkillbarSkills) do
		if ( skill.slot == slot and skill.cooldown == 0 ) then
			return true
		end
	end	
	return false
end

-- Swap.
function profilePrototype:Swap(targetID)	
	local timers = self.tmp.swapTimers
	local settings = self.switchSettings
	if (settings.switchWeapons == "1" ) then 
		if ( TimeSince(timers.lastSwap) > 1500) then
			timers.lastSwap = ml_global_information.Now	
			
			
			local canSwap = false
			local target = CharacterList:Get(targetID) or GadgetList:Get(targetID)
				
			--[[if (canSwap == false and settings.switchOnRange == "1" and TimeSince(timers.lastRangeSwap) > 0) then
				timers.lastRangeSwap = ml_global_information.Now		
				if ( self.tmp.maxAttackRange < 300 and ValidTable(target) and target.distance > self.tmp.maxAttackRange) then
					timers.lastRangeSwap = ml_global_information.Now + math.random(5000,10000)
					canSwap = true
				end
			end	
			if (settings.switchRandom == "1" and (ml_global_information.Player_InCombat or ml_global_information.Player_IsMoving) and TimeSince(timers.lastRandomSwap) > 0) then
				timers.lastRandomSwap = ml_global_information.Now + math.random(3000,15000)
				canSwap = true
			end
			if (canSwap == false and tonumber(settings.switchOnCooldown) > 0) then
				local skillsOnCooldown = 0
				for _,skill in pairs(gw2_skill_manager.currentSkillbarSkills) do
					if (skill.slot > GW2.SKILLBARSLOT.Slot_1  and skill.slot <= GW2.SKILLBARSLOT.Slot_5 and skill.cooldown ~= 0 and (skill.power == 0 or skill.power <= ml_global_information.Player_Power)) then
						skillsOnCooldown = skillsOnCooldown + 1
					end
				end
				if (skillsOnCooldown >= tonumber(settings.switchOnCooldown)) then
					canSwap = true
				end
			end		
			if (canSwap ) then	
				self:SwapAttunement()
				self:SwapKit()
				self:SwapWeaponSet()
			end]]
			
			if ( ValidTable(target) ) then
				-- Don't swap on slowcast spells, else they get interrupted
				local canswap = true
				local lastSkillID = (Player.castinfo.skillID == 0 and Player.castinfo.lastSkillID or Player.castinfo.skillID)
				if ( lastSkillID ) then 
					local lastSkill = self:GetSkillByID(lastSkillID)
					if (lastSkill and lastSkill.skill.slowCast == "1" and Player.castinfo.slot == lastSkill.tmp.slot) then 
						canswap = false
					end
				end
				if ( canswap ) then
					self:SwapWeapon(target.distance)
				end
			end
			
		end
	end
	self:SwapPet()
end

function profilePrototype:SortSkills()
	-- Sort skills by type first.
	local skillsByType = {{}, {}, {}, {}, {}} -- 1: Healing, 2: Previous skill id, 3: F skills, 4: Normal skills, 5: Autoattack
	for priority,skill in ipairs(self.skills) do
		local slot = skill.skill.slot
		local skillType = 4
		if(slot > 10) then
			skillType = 3
		elseif((skill.skill.castOnSelf ~= nil and skill.skill.castOnSelf == "1") or slot == 0) then
			skillType = 1
			skill.skill.castOnSelf = "1"
		elseif(skill.skill.lastSkillID ~= nil and skill.skill.lastSkillID ~= "") then
			skillType = 2
		elseif(slot == 5) then
			skillType = 5
		end
		table.insert(skillsByType[skillType],skill)
	end

	local sortedSkillList = {}
	-- Sort skills from each type.
	for skillType,skillList in ipairs(skillsByType) do
		-- by id.
		local function sortByID(skill1, skill2)
			return skill1.skill.id > skill2.skill.id
		end
		table.sort(skillList,sortByID)

		-- by name.
		local function sortByName(skill1, skill2)
			return skill1.skill.name > skill2.skill.name
		end
		table.sort(skillList, sortByName)

		-- by attributes.
		local function attributeCount(skill)
			local result = 0

			if (ValidTable(skill)) then
				-- Healing -> Elites -> F skills -> Slot skills -> Weapon skills in reverse
				if (skill.skill.slot == 0) then
					result = result + 400000
					if ( skill.player.minHP and skill.player.minHP == 0 ) then
						skill.player.minHP = 75
					end
				elseif (skill.skill.slot == 4) then
					result = result + 100000
				elseif (skill.skill.slot > 10) then
					result = result + 60000
				elseif (skill.skill.slot >= 1 and skill.skill.slot <= 3) then
					result = result + 40000
				else
					result = result + skill.skill.slot
				end
				-- Longer range higher.
				result = skill.skill.maxRange / 1000 > 0 and result + skill.skill.maxRange / 1000 or result
				result = skill.skill.minRange / 1000 > 0 and result + skill.skill.minRange / 1000 or result
				-- skills with less checks first
				result = result + TableSize(skill.skill) + TableSize(skill.player) + TableSize(skill.target)
			end

			return result
		end
		local function sortByAttributeScore(skill1, skill2)
			return attributeCount(skill1) > attributeCount(skill2)
		end

		table.sort(skillList, sortByAttributeScore)
		-- add sorted skills to sortedSkillList
		for _,skill in ipairs(skillList) do
			table.insert(sortedSkillList, skill)
		end
	end

	self.skills = sortedSkillList
	
end

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- **skill prototype**
---------------------------------------------------------------------------------------------------------------------------------------------------------

-- can cast.
function skillPrototype:CanCast(targetID)
	local skillOnBar = gw2_skill_manager.currentSkillbarSkills[self.skill.id] or {}
	local target = CharacterList:Get(targetID) or GadgetList:Get(targetID)
	if (ValidTable(skillOnBar) and (ValidTable(target) or self.skill.castOnSelf == "1") ) then
		-- update profile range.
		if (self.skill.setRange == "1") then
			self.parent.tmp.maxAttackRange = (self.skill.maxRange > 0 and self.skill.maxRange > self.parent.tmp.maxAttackRange and self.skill.maxRange or self.parent.tmp.maxAttackRange)
			self.parent.tmp.maxAttackRange = (self.skill.radius > 0 and self.skill.radius > self.parent.tmp.maxAttackRange and self.skill.radius or self.parent.tmp.maxAttackRange)
		end

		-- get last skill.
		local lastSkillID = (Player.castinfo.skillID == 0 and Player.castinfo.lastSkillID or Player.castinfo.skillID)

		-- skillBar attributes.
		if (skillOnBar.cooldown == 1) then return false end
		self.tmp.slot = skillOnBar.slot
		
		if (skillOnBar.power > ml_global_information.Player_Power) then return false end
		
		-- skill attributes.
		if (self.skill.id == Player.castinfo.skillID and self.tmp.slot ~= GW2.SKILLBARSLOT.Slot_1) then return false end
		if (self.skill.lastSkillID ~= "" and StringContains(tostring(self.skill.lastSkillID),tostring(lastSkillID)) == false) then return false end
		if (self.skill.delay > 0 and self.tmp.lastCastTime and TimeSince(self.tmp.lastCastTime) < (self.skill.delay)) then return false end -- IMPORT: devide all delay times by 100
		if (ValidTable(target)) then
			if (self.skill.los == "1" and target.los == false) then return false end
			if (self.skill.minRange > 0 and (target.distance+target.radius) < self.skill.minRange) then return false end
			if (self.skill.maxRange > 0 and (target.distance-target.radius) > (self.skill.maxRange < 154 and 154 or self.skill.maxRange)) then return false end
			if (self.skill.radius > 0 and self.skill.maxRange == 0 and (target.distance > self.skill.radius)) then return false end
			if (self.skill.relativePosition ~= "None") then -- "None,Behind,In-front,Flanking"
				local diffDegree = gw2_common_functions.getDegreeDiffTargets(target.id,Player.id)
				local relativePos = (diffDegree > 315 or diffDegree < 45) and "In-front" or (diffDegree > 45 and diffDegree < 135) and "Flanking" or (diffDegree > 135 and diffDegree < 225) and "Behind" or (diffDegree > 225 and diffDegree < 315) and "Flanking"
				if (self.skill.relativePosition == "Behind" and relativePos ~= "Behind") then
					return false
				elseif (self.skill.relativePosition == "In-front" and relativePos ~= "In-front") then
					return false
				elseif (self.skill.relativePosition == "Flanking" and relativePos ~= "Flanking") then
					return false
				end
			end
		end
		-- player attributes.
		if (self.player.combatState == "InCombat" and ml_global_information.Player_InCombat == false ) then return false end
		if (self.player.combatState == "OutCombat" and ml_global_information.Player_InCombat == true ) then return false end
		if (self.player.minHP > 0 and ml_global_information.Player_Health.percent > self.player.minHP) then return false end
		if (self.player.maxHP > 0 and ml_global_information.Player_Health.percent < self.player.maxHP) then return false end
		if (self.player.minPower > 0 and ml_global_information.Player_Power > self.player.minPower) then return false end
		if (self.player.maxPower > 0 and ml_global_information.Player_Power < self.player.maxPower) then return false end
		if (self.player.minEndurance > 0 and ml_global_information.Player_Endurance > self.player.minEndurance) then return false end
		if (self.player.maxEndurance > 0 and ml_global_information.Player_Endurance < self.player.maxEndurance) then return false end
		if (self.player.allyNearCount > 0) then
			local maxdistance = (self.player.allyRangeMax == 0 and "" or "maxdistance=" .. self.player.allyRangeMax .. ",")
			if (TableSize(CharacterList("friendly," .. maxdistance .. "distanceto=" .. Player.id .. ",exclude=" .. Player.id)) < self.player.allyNearCount) then return false end
		end
		if (self.player.allyDownedNearCount > 0) then
			local maxdistance = (self.player.allyDownedRangeMax > 0 and self.player.allyDownedRangeMax or 2500)
			if (TableSize(CharacterList("friendly,maxdistance=" .. maxdistance .. ",distanceto=" .. Player.id .. ",downed,exclude=" .. Player.id)) < self.player.allyDownedNearCount) then return false end
		end
		local playerBuffList = Player.buffs
		if (self.player.hasBuffs ~= "" and ValidTable(playerBuffList) and not gw2_common_functions.BufflistHasBuffs(playerBuffList, tostring(self.player.hasBuffs))) then return false end
		if (self.player.hasNotBuffs ~= "" and ValidTable(playerBuffList) and gw2_common_functions.BufflistHasBuffs(playerBuffList, tostring(self.player.hasNotBuffs))) then return false end
		if (self.player.conditionCount > 0 and ValidTable(playerBuffList) and gw2_common_functions.CountConditions(playerBuffList) < self.player.conditionCount) then return false end
		if (self.player.boonCount > 0 and ValidTable(playerBuffList) and gw2_common_functions.CountBoons(playerBuffList) < self.player.boonCount) then return false end
		if (self.player.moving == "Moving" and ml_global_information.Player_MovementState == GW2.MOVEMENTSTATE.GroundNotMoving ) then return false end
		if (self.player.moving == "NotMoving" and ml_global_information.Player_MovementState == GW2.MOVEMENTSTATE.GroundMoving ) then return false end
		-- target attributes.
		if (ValidTable(target)) then
			local targetBuffList = (target.buffs or false)
			if (self.target.minHP > 0 and target.health.percent > self.target.minHP) then return false end
			if (self.target.maxHP > 0 and target.health.percent < self.target.maxHP) then return false end
			if (self.target.enemyNearCount > 0) then
				local maxdistance = (self.target.enemyRangeMax == 0 and "" or "maxdistance=" .. self.target.enemyRangeMax .. ",")
				if (TableSize(CharacterList("alive,attackable," .. maxdistance .. "distanceto=" .. target.id .. ",exclude=" .. target.id)) < self.target.enemyNearCount) then return false end
			end
			if (self.target.moving == "Moving" and target.movementstate == GW2.MOVEMENTSTATE.GroundNotMoving ) then return false end
			if (self.target.moving == "NotMoving" and target.movementstate == GW2.MOVEMENTSTATE.GroundMoving ) then return false end
			if (self.target.hasBuffs ~= "" and targetBuffList and not gw2_common_functions.BufflistHasBuffs(targetBuffList, tostring(self.target.hasBuffs))) then return false end
			if (self.target.hasNotBuffs ~= "" and targetBuffList and gw2_common_functions.BufflistHasBuffs(targetBuffList, tostring(self.target.hasNotBuffs))) then return false end
			if (self.target.conditionCount > 0 and targetBuffList and gw2_common_functions.CountConditions(targetBuffList) <= self.target.conditionCount) then return false end
			if (self.target.boonCount > 0 and targetBuffList and gw2_common_functions.CountBoons(targetBuffList) <= self.target.boonCount) then return false end
			if (self.target.type == "Character" and target.isCharacter == false) then return false end
			if (self.target.type == "Gadget" and target.isGadget == false) then return false end
		end
		-- update active skill range.
		self.parent.tmp.activeSkillRange = (self.skill.maxRange > 0 and self.skill.maxRange > self.parent.tmp.activeSkillRange and self.skill.maxRange or self.parent.tmp.activeSkillRange)
		self.parent.tmp.activeSkillRange = (self.skill.radius > 0 and self.skill.radius > self.parent.tmp.activeSkillRange and self.skill.radius or self.parent.tmp.activeSkillRange)
		-- update combatMovement status.
		self.parent.tmp.combatMovement.allowed = (self.skill.stopsMovement == "0")

		-- Check lastSkill attributes.
		local lastSkill = self.parent:GetSkillByID(lastSkillID)
		if (lastSkill and lastSkill.skill.slowCast == "1" and Player.castinfo.slot == lastSkill.tmp.slot) then return false end

		-- skill can be cast now.
		return true
	-- update profile range.
	elseif (ValidTable(target) == false and self.skill.setRange == "1" and ValidTable(skillOnBar) and skillOnBar.cooldown == 0) then
		self.parent.tmp.maxAttackRange = (self.skill.maxRange > 0 and self.skill.maxRange > self.parent.tmp.maxAttackRange and self.skill.maxRange or self.parent.tmp.maxAttackRange)
		self.parent.tmp.maxAttackRange = (self.skill.radius > 0 and self.skill.radius > self.parent.tmp.maxAttackRange and self.skill.radius or self.parent.tmp.maxAttackRange)
	end
	return false
end

-- cast.
function skillPrototype:Cast(targetID)
	local target = CharacterList:Get(targetID) or GadgetList:Get(targetID)
	-- Face target.
	--if (ValidTable(target)) then Player:SetFacingExact(target.pos.x,target.pos.y,target.pos.z) end
	-- Target self if needed.
	target = (self.skill.castOnSelf == "1" and Player or ValidTable(target) and target or nil)
	if (ValidTable(target)) then
		--d("Casting Spell : " ..self.skill.name)
		local pos = target.pos--self:Predict(target) -- just too off target. crap target prediction.
		local castresult = false
		if (self.skill.groundTargeted == "1") then
			if (target.isCharacter) then
				castresult = Player:CastSpell(self.tmp.slot, pos.x, pos.y, pos.z)
			elseif (target.isGadget) then
				if (self.skill.isProjectile == "1") then
					castresult = Player:CastSpell(self.tmp.slot, pos.x, pos.y, (pos.z))
				else
					castresult = Player:CastSpell(self.tmp.slot, pos.x, pos.y, (pos.z - target.height))
				end
			end
		else
			castresult = Player:CastSpell(self.tmp.slot, target.id)
		end
		
		if ( castresult and gw2_skill_manager.currentSkillbarSkills[self.skill.id]) then
			local trackerEntry = gw2_skill_manager.GetCurrentSkillTrackerEntry()
			if ( trackerEntry ) then
				gw2_skill_manager.RefreshSkillTrackerEntry( trackerEntry, self.tmp.slot, gw2_skill_manager.currentSkillbarSkills[self.skill.id], ml_global_information.Now )
			end
		end
		
		self.tmp.lastCastTime = ml_global_information.Now
		return true
	end
	return false
end

-- predict pos.
function skillPrototype:Predict(target)
	if (ValidTable(target)) then
		local pPos = Player.pos
		local tPos = target.pos
		local targetSpeed = (target.speed / 1000) * gPulseTime
		local targetHeading = gw2_common_functions.headingToRadian(target.pos)
		local ePos = {
			x = tPos.x + math.sin(targetHeading) * targetSpeed/5 * (1 + target.distance / 30),
			y = tPos.y + math.cos(targetHeading) * targetSpeed/5 * (1 + target.distance / 30),
			z = tPos.z,
		}
		local dist = Distance3D(pPos.x,pPos.y,pPos.z,ePos.x,ePos.y,ePos.z)
		if (dist < self.skill.maxRange) then
			return ePos
		end
		return tPos
	end
end


---------------------------------------------------------------------------------------------------------------------------------------------------------
-- **GUI variable update**
---------------------------------------------------------------------------------------------------------------------------------------------------------

function gw2_skill_manager.GUIVarUpdate(Event, NewVals, OldVals) -- not done
	for k,v in pairs(NewVals) do
		-- Changes in skills
		-- Skill change
		if (
				k == "SklMgr_HealnBuff" or
				k == "SklMgr_IsProjectile" or
				k == "SklMgr_CastOnSelf" or
				k == "SklMgr_LOS" or
				k == "SklMgr_SetRange" or
				k == "SklMgr_MinRange" or
				k == "SklMgr_MaxRange" or
				k == "SklMgr_Radius" or
				k == "SklMgr_SlowCast" or
				k == "SklMgr_LastSkillID" or
				k == "SklMgr_Delay" or
				k == "SklMgr_RelativePosition" or
				k == "SklMgr_StopsMovement")
			then
			local var = {	SklMgr_IsProjectile = {global = "isProjectile", gType = "tostring",},
							--SklMgr_HealnBuff = {global = "healing", gType = "tostring",},
							SklMgr_CastOnSelf = {global = "castOnSelf", gType = "tostring",},
							SklMgr_LOS = {global = "los", gType = "tostring",},
							SklMgr_SetRange = {global = "setRange", gType = "tostring",},
							SklMgr_MinRange = {global = "minRange", gType = "tonumber",},
							SklMgr_MaxRange = {global = "maxRange", gType = "tonumber",},
							SklMgr_Radius = {global = "radius", gType = "tonumber",},
							SklMgr_SlowCast = {global = "slowCast", gType = "tostring",},
							SklMgr_LastSkillID = {global = "lastSkillID", gType = "tonumber",},
							SklMgr_Delay = {global = "delay", gType = "tonumber",},
							SklMgr_RelativePosition = {global = "relativePosition", gType = "tostring",},
							SklMgr_StopsMovement = {global = "stopsMovement", gType = "tostring",},
			}
			gw2_skill_manager.profile.skills[gw2_skill_manager.status.skillWindowCurrentPriority].skill[var[k].global] = _G[var[k].gType](v)
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
				k == "SklMgr_AllyDownedCount" or
				k == "SklMgr_AllyDownedRange" or
				k == "SklMgr_PHasBuffs" or
				k == "SklMgr_PHasNotBuffs" or
				k == "SklMgr_PCondCount" or
				k == "SklMgr_PBoonCount" or
				k == "SklMgr_PlayerMoving")
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
							SklMgr_AllyDownedCount = {global = "allyDownedNearCount", gType = "tonumber",},
							SklMgr_AllyDownedRange = {global = "allyDownedRangeMax", gType = "tonumber",},
							SklMgr_PHasBuffs = {global = "hasBuffs", gType = "tostring",},
							SklMgr_PHasNotBuffs = {global = "hasNotBuffs", gType = "tostring",},
							SklMgr_PCondCount = {global = "conditionCount", gType = "tonumber",},
							SklMgr_PBoonCount = {global = "boonCount", gType = "tonumber",},
							SklMgr_PlayerMoving = {global = "moving", gType = "tostring",},
			}
			gw2_skill_manager.profile.skills[gw2_skill_manager.status.skillWindowCurrentPriority].player[var[k].global] = _G[var[k].gType](v)
		-- Target change
		elseif (
				k == "SklMgr_Type" or
				k == "SklMgr_TMinHP" or
				k == "SklMgr_TMaxHP" or
				k == "SklMgr_EnemyCount" or
				k == "SklMgr_EnemyRange" or
				k == "SklMgr_TargetMoving" or
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
							SklMgr_TargetMoving = {global = "moving", gType = "tostring",},
							SklMgr_THasBuffs = {global = "hasBuffs", gType = "tostring",},
							SklMgr_THasNotBuffs = {global = "hasNotBuffs", gType = "tostring",},
							SklMgr_TCondCount = {global = "conditionCount", gType = "tonumber",},
							SklMgr_TBoonCount = {global = "boonCount", gType = "tonumber",},
			}
			gw2_skill_manager.profile.skills[gw2_skill_manager.status.skillWindowCurrentPriority].target[var[k].global] = _G[var[k].gType](v)				
		elseif (k == "gSMSwitchWeapon") then
			gw2_skill_manager.profile.switchSettings.switchWeapons = v
		elseif (k == "gSMSwitchOnRange") then
			gw2_skill_manager.profile.switchSettings.switchOnRange = v
		elseif (k == "gSMSwitchRandom") then
			gw2_skill_manager.profile.switchSettings.switchRandom = v
		elseif (k == "gSMSwitchOnCooldown") then
			gw2_skill_manager.profile.switchSettings.switchOnCooldown = tonumber(v)
		elseif (k == "gSMPrioKit") then
			gw2_skill_manager.profile.professionSettings.engineer.kit = v
		elseif (k == "gSMPrioAtt1") then
			gw2_skill_manager.profile.professionSettings.elementalist.attunement_1 = v
		elseif (k == "gSMPrioAtt2") then
			gw2_skill_manager.profile.professionSettings.elementalist.attunement_2 = v
		elseif (k == "gSMPrioAtt3") then
			gw2_skill_manager.profile.professionSettings.elementalist.attunement_3 = v
		elseif (k == "gSMPrioAtt4") then
			gw2_skill_manager.profile.professionSettings.elementalist.attunement_4 = v
		elseif (k == "gSMCurrentProfileName") then
			gw2_skill_manager:DetectSkillsButton(false)
			gw2_skill_manager.profile = gw2_skill_manager:GetProfile(v)
			Settings.GW2Minion.gCurrentProfile[gw2_common_functions.GetProfessionName()] = v
			Settings.GW2Minion.gCurrentProfile = Settings.GW2Minion.gCurrentProfile
			gw2_skill_manager:MainWindowDeleteGroups()
			gw2_skill_manager:MainWindowDeleteSkills()
			gw2_skill_manager:SkillWindowUpdate()
		end
	end
end
RegisterEventHandler("GUI.Update",gw2_skill_manager.GUIVarUpdate)

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- **GUI item update**
---------------------------------------------------------------------------------------------------------------------------------------------------------

function gw2_skill_manager.HandleButton(event, button)
	local sfind = function(name) return button:find(name,nil,true) end
	local sgsub = function(name) return button:gsub(name,"") end
	if (sfind("gSMskillWindowButton")) then
		local priority = sgsub("gSMskillWindowButton")
		gw2_skill_manager:SkillWindowUpdate(priority)
	elseif (button == "gSMnewProfile") then
		gw2_skill_manager:NewProfileDialog()
	elseif (button == "gSMdetectSkills") then
		gw2_skill_manager:DetectSkillsButton()
	elseif (button == "gSMdeleteProfile") then
		gw2_skill_manager:DeleteProfileDialog()
	elseif (button == "gSMcloneProfile") then
		gw2_skill_manager:CloneProfileDialog()
	elseif (button == "gSMsaveProfile") then
		gw2_skill_manager:SaveProfileButton()
	elseif (button == "gSMdeleteSkill") then
		gw2_skill_manager:DeleteSkillButton()
	elseif (button == "gSMpasteSkill") then
		gw2_skill_manager:PasteSkillButton()
	elseif (button == "gSMcopySkill") then
		gw2_skill_manager:CopySkillButton()
	elseif (button == "gSMcloneSkill") then
		gw2_skill_manager:CloneSkillButton()
	elseif (button == "gSMmoveDownSkill") then
		gw2_skill_manager:MoveSkillDownButton()
	elseif (button == "gSMmoveUpSkill") then
		gw2_skill_manager:MoveSkillUpButton()
	elseif (button == "gSMmoveSkill") then
		gw2_skill_manager:MoveSkillButton()
	elseif (button == "") then

	elseif (button == "") then

	elseif (button == "") then

	elseif (button == "") then

	end
end
RegisterEventHandler( "GUI.Item", gw2_skill_manager.HandleButton)

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- **Update loop**
---------------------------------------------------------------------------------------------------------------------------------------------------------

function gw2_skill_manager.OnUpdate(ticks)
	if (gw2_skill_manager.mainWindow.groupsCreated == false) then
		gw2_skill_manager:MainWindowCreateGroups()
	end
	if (gw2_skill_manager.mainWindow.skillsCreated == false) then
		gw2_skill_manager:MainWindowCreateSkills()
	end
	gw2_skill_manager:UpdateCurrentSkillbarSkills()
	gw2_skill_manager:DetectSkills()
	gw2_skill_manager:Use()
end