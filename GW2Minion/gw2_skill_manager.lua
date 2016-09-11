-- GW2Minion SkillManager
-- Creator: Jorith -- shamefully now, will get this mess cleaned once done :P
gw2_skill_manager = {}
gw2_skill_manager.toolTip = true
gw2_skill_manager.PlayerProfession = 10
gw2_skill_manager.paths = { [1] = GetStartupPath() .. [[\LuaMods\GW2Minion\SkillManagerProfiles\]]}  -- allowing others to add profiles from their own folders
gw2_skill_manager.currentSkillbarSkills = {}
gw2_skill_manager.profile = nil
gw2_skill_manager.profileList = {}
-- these list are order sensitive as "key" number is saved!!
gw2_skill_manager.engineerKits = {"None", "BombKit", "FlameThrower", "GrenadeKit", "ToolKit", "ElixirGun", "EliteMortarKit",}
gw2_skill_manager.elementalistAttunements = {"None", "Fire", "Water", "Air", "Earth",}
gw2_skill_manager.relativePosition = {"None", "Behind", "In-front", "Flanking",}
gw2_skill_manager.combatState = {"Either", "InCombat", "OutCombat",}
gw2_skill_manager.movementState = {"Either", "Moving", "NotMoving",}
gw2_skill_manager.targetType = {"Either", "Character", "Gadget",}
-- end of order sensitive tables.
gw2_skill_manager.mainWindow = {name = "Skill Manager", open = false, visible = true, size = {x = 0, y = 0,}, pos = {x = 0, y = 0,},}
gw2_skill_manager.profileWindow = {name = "Profile", open = false, visible = true, size = {x = 0, y = 0,}, pos = {x = 0, y = 0,},}
gw2_skill_manager.skillWindow = {name = "Skill", open = false, visible = true, size = {x = 0, y = 0,}, pos = {x = 0, y = 0,}, prio = 0,}

local profilePrototype = {
	name = "defaultName",
	profession = 10,
	professionSettings = {
		elementalist = {
			attunement_1 = 1,--"None",
			attunement_2 = 1,--"None",
			attunement_3 = 1,--"None",
			attunement_4 = 1,--"None",
		},
		engineer = {
			kit = 1,--"None",
		},
	},
	switchSettings = {
		switchWeapons = true,
		switchOnRange = false,
		switchRandom = false,
		switchOnCooldown = false,
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
			contentid = 0,
			health = {},
		},
		targetBlacklistBuffs = "762,785",
		path = gw2_skill_manager.paths[1],
		target = {targetID = nil, timestamp = ml_global_information.Now,},
		cloneProfileName = "",
		detectingSkills = false,
	},
}
local skillPrototype = {
	parent = nil,
	skill = {	id					= 0,
				name				= "",
				groundTargeted		= false,
				isProjectile		= false,
				castOnSelf			= false,
				relativePosition	= 1,--"None",
				los					= true,
				setRange			= false,
				minRange			= 0,
				maxRange			= 0,
				radius				= 0,
				slowCast			= false,
				lastSkillID			= "",
				delay				= 0,
				stopsMovement		= false,
	},
	player = {	combatState			= 1,--"Either",
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
				moving				= 1,--"Either",
	},
	target = {	type				= 1,--"Either",
				minHP				= 0,
				maxHP				= 0,
				enemyNearCount		= 0,
				enemyRangeMax		= 0,
				moving				= 1,--"Either",
				hasBuffs			= "",
				hasNotBuffs			= "",
				conditionCount		= 0,
				boonCount			= 0,
	},
	tmp = {
		lastCastTime = 0,
		slot = ml_global_information.MAX_SKILLBAR_SLOTS-1,
		dragging = false,
		moving = false,
		newPriority = 0,
	},
}

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- **Init gw2_skill_manager**
---------------------------------------------------------------------------------------------------------------------------------------------------------

function gw2_skill_manager.ModuleInit()
	if (Settings.GW2Minion.gCurrentProfile == nil) then
		Settings.GW2Minion.gCurrentProfile = {}
	end
	ml_gui.ui_mgr:AddMember({ id = "GW2MINION##SKILLMGR", name = "Skill MGR", onClick = function() gw2_skill_manager.mainWindow.open = not gw2_skill_manager.mainWindow.open end, tooltip = "Click to open \"Skill Manager\" window."},"GW2MINION##MENU_HEADER")
end
RegisterEventHandler("Module.Initalize",gw2_skill_manager.ModuleInit)


function gw2_skill_manager.mainWindow.Draw(event,ticks)
	if (gw2_skill_manager.mainWindow.open) then
		GUI:SetNextWindowSize(250,400,GUI.SetCond_FirstUseEver) -- TODO: remove auto resize and set "set" size for auto move?
		gw2_skill_manager.mainWindow.visible, gw2_skill_manager.mainWindow.open = GUI:Begin(gw2_skill_manager.mainWindow.name, gw2_skill_manager.mainWindow.open, GUI.WindowFlags_NoCollapse+GUI.WindowFlags_AlwaysAutoResize)
		if (gw2_skill_manager.mainWindow.visible) then
			-- Profile Choice.
			GUI:AlignFirstTextHeightToWidgets()
			GUI:Text("Profile:")
			GUI:SameLine(70)
			local changed = false
			gw2_skill_manager.profileList.currID, changed = GUI:Combo("##gw2sm-profilelist",gw2_skill_manager.profileList.currID,gw2_skill_manager.profileList.nameList)
			if (changed) then
				Settings.GW2Minion.gCurrentProfile[ml_global_information.Player_Name] = gw2_skill_manager.profileList.nameList[gw2_skill_manager.profileList.currID]
				Settings.GW2Minion.gCurrentProfile = Settings.GW2Minion.gCurrentProfile
				gw2_skill_manager.profile = gw2_skill_manager:GetProfile(gw2_skill_manager.profileList.nameList[gw2_skill_manager.profileList.currID])
				gw2_skill_manager.profileList = gw2_skill_manager:GetProfileList()
				gw2_skill_manager.profileWindow.open = false
				gw2_skill_manager.skillWindow.open = false
			end
			GUI:Separator()
			-- New Profile Button.
			if (GUI:Button("New Profile", 100,25)) then
				GUI:OpenPopup("##gw2sm-newprofile")
				--GUI:SetKeyboardFocusHere()
			end
			if (GUI:IsItemHovered() and gw2_skill_manager.toolTip) then
				GUI:SetTooltip("Create a new profile.")
			end
			-- New profile dialog.
			GUI:SetNextWindowPosCenter(GUI.SetCond_Always)
			GUI:SetNextWindowSize(300, 100, GUI.SetCond_Always)
			if (GUI:BeginPopup("##gw2sm-newprofile")) then
				--name
				GUI:AlignFirstTextHeightToWidgets()
				GUI:Text(GetString("name"))
				GUI:SameLine()
				gw2_skill_manager.profileList.newProfileName = GUI:InputText("##gw2sm-clonedprofilename",gw2_skill_manager.profileList.newProfileName)
				-----------------------------------------------------------------------------------------------------------------------------------
				GUI:Separator()
				------------------------------------------------------------------------------------------------------------------------
				-- Layout spacing.
				GUI:NewLine()
				GUI:NewLine()
				GUI:SameLine(0,40)
				-- CANCEL BUTTON.
				-->>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<
				if (GUI:Button(GetString("cancel"),80,30)) then
					GUI:CloseCurrentPopup()
				end
				-- OK BUTTON.
				-->>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<
				GUI:SameLine(0, 50)
				if (GUI:Button(GetString("ok"),80,30)) then
					if (string.valid(gw2_skill_manager.profileList.newProfileName) and gw2_skill_manager.profileList.newProfileName ~= "None" and table.contains(gw2_skill_manager.profileList.nameList, gw2_skill_manager.profileList.newProfileName) == false) then
						gw2_skill_manager.skillWindow.open = false
						gw2_skill_manager.profile = gw2_skill_manager:NewProfile(gw2_skill_manager.profileList.newProfileName)
						gw2_skill_manager.profile.tmp.detectingSkills = true
						gw2_skill_manager.profileList = gw2_skill_manager:GetProfileList(gw2_skill_manager.profile.name)
						gw2_skill_manager.profileWindow.open = true
						GUI:CloseCurrentPopup()
					else
						GUI:OpenPopup("Invalid Name.##gw2sm-newnameconflict")
					end
				end
				GUI:SetNextWindowPosCenter(GUI.SetCond_Always)
				GUI:SetNextWindowSize(400, 140, GUI.SetCond_Always)
				if (GUI:BeginPopupModal("Invalid Name.##gw2sm-newnameconflict",true,GUI.WindowFlags_NoResize+GUI.WindowFlags_NoMove+GUI.WindowFlags_ShowBorders)) then
					GUI:Spacing()
					GUI:SameLine(150)
					GUI:Text("Name in use.")
					GUI:Spacing()
					GUI:SameLine(135)
					GUI:SetWindowFontScale(0.8)
					GUI:Text("Please a different one.")
					GUI:SetWindowFontScale(1)
					
					GUI:Spacing()
					GUI:Separator()
					GUI:Dummy(100,20)
					GUI:Spacing()
					GUI:SameLine(160)
					if (GUI:Button(GetString("ok"),80,30)) then
						GUI:CloseCurrentPopup()
					end
					GUI:EndPopup()
				end
				GUI:EndPopup()
			end
			
			GUI:SameLine(180)
			-- Edit Profile Button.
			if (GUI:Button("Edit Profile", 100,25)) then
				if (gw2_skill_manager.profile and gw2_skill_manager.profileWindow.open == false) then
					gw2_skill_manager.profileWindow.open = true
				else
					gw2_skill_manager.profileWindow.open = false
					gw2_skill_manager.skillWindow.open = false
				end
			end
			if (GUI:IsItemHovered() and gw2_skill_manager.toolTip) then
				GUI:SetTooltip("Edit an existing profile.")
			end
			
		end
		GUI:End()
	else
		gw2_skill_manager.profileWindow.open = false
		gw2_skill_manager.skillWindow.open = false
	end
end
RegisterEventHandler("Gameloop.Draw", gw2_skill_manager.mainWindow.Draw)

function gw2_skill_manager.profileWindow.Draw(event,ticks)
	if (gw2_skill_manager.profileWindow.open) then
		GUI:SetNextWindowSize(250,400,GUI.SetCond_FirstUseEver) -- TODO: better start size, remove title bar, auto move with main.
		gw2_skill_manager.profileWindow.visible, gw2_skill_manager.profileWindow.open = GUI:Begin(gw2_skill_manager.profile.name.."###"..gw2_skill_manager.profileWindow.name, gw2_skill_manager.profileWindow.open, GUI.WindowFlags_NoCollapse)
		if (gw2_skill_manager.profileWindow.visible) then
			-- Save profile button.
			if (GUI:Button(GetString("save"), (GUI:GetContentRegionAvailWidth()/2)-(GUI:GetStyle().iteminnerspacing.x/2),25)) then
				gw2_skill_manager.profile:Save()
			end
			if (GUI:IsItemHovered() and gw2_skill_manager.toolTip) then
				GUI:SetTooltip("Save the current profile.")
			end
			GUI:SameLine(0)
			-- Clone profile button.
			if (GUI:Button(GetString("clone"), GUI:GetContentRegionAvailWidth(),25)) then
				GUI:OpenPopup("##gw2sm-cloneprofile")
			end
			if (GUI:IsItemHovered() and gw2_skill_manager.toolTip) then
				GUI:SetTooltip("Clone the current profile with a new name.")
			end
			-- Clone profile dialog.
			GUI:SetNextWindowPosCenter(GUI.SetCond_Always)
			GUI:SetNextWindowSize(300, 100, GUI.SetCond_Always)
			if (GUI:BeginPopup("##gw2sm-cloneprofile")) then
				--name
				GUI:AlignFirstTextHeightToWidgets()
				GUI:Text(GetString("name"))
				GUI:SameLine()
				gw2_skill_manager.profile.tmp.cloneProfileName = GUI:InputText("##gw2sm-clonedprofilename",gw2_skill_manager.profile.tmp.cloneProfileName)
				-----------------------------------------------------------------------------------------------------------------------------------
				GUI:Separator()
				------------------------------------------------------------------------------------------------------------------------
				-- Layout spacing.
				GUI:NewLine()
				GUI:NewLine()
				GUI:SameLine(0,40)
				-- CANCEL BUTTON.
				-->>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<
				if (GUI:Button(GetString("cancel"),80,30)) then
					GUI:CloseCurrentPopup()
				end
				-- OK BUTTON.
				-->>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<
				GUI:SameLine(0, 50)
				if (GUI:Button(GetString("ok"),80,30)) then
					if (string.valid(gw2_skill_manager.profile.tmp.cloneProfileName) and table.contains(gw2_skill_manager.profileList.nameList, gw2_skill_manager.profile.tmp.cloneProfileName) == false) then
						gw2_skill_manager.profile:Clone(gw2_skill_manager.profile.tmp.cloneProfileName)
						gw2_skill_manager.profileList = gw2_skill_manager:GetProfileList()
						GUI:CloseCurrentPopup()
					else
						GUI:OpenPopup("Invalid Name.##gw2sm-clonenameconflict")
					end
				end
				GUI:SetNextWindowPosCenter(GUI.SetCond_Always)
				GUI:SetNextWindowSize(400, 140, GUI.SetCond_Always)
				if (GUI:BeginPopupModal("Invalid Name.##gw2sm-clonenameconflict",true,GUI.WindowFlags_NoResize+GUI.WindowFlags_NoMove+GUI.WindowFlags_ShowBorders)) then
					GUI:Spacing()
					GUI:SameLine(150)
					GUI:Text("Name in use.")
					GUI:Spacing()
					GUI:SameLine(135)
					GUI:SetWindowFontScale(0.8)
					GUI:Text("Please a different one.")
					GUI:SetWindowFontScale(1)
					
					GUI:Spacing()
					GUI:Separator()
					GUI:Dummy(100,20)
					GUI:Spacing()
					GUI:SameLine(160)
					if (GUI:Button(GetString("ok"),80,30)) then
						GUI:CloseCurrentPopup()
					end
					GUI:EndPopup()
				end
				GUI:EndPopup()
			end
			-- Delete profile button.
			if (GUI:Button(GetString("delete"), (GUI:GetContentRegionAvailWidth()/2)-(GUI:GetStyle().iteminnerspacing.x/2),25)) then
				GUI:OpenPopup("##gw2sm-deleteporfile")
			end
			if (GUI:IsItemHovered() and gw2_skill_manager.toolTip) then
				GUI:SetTooltip("Delete the current profile.")
			end
			GUI:SameLine(0)
			local color = gw2_skill_manager.profile.tmp.detectingSkills and GUI:GetStyle().colors[GUI.Col_ButtonActive] or GUI:GetStyle().colors[GUI.Col_Button]
			GUI:PushStyleColor(GUI.Col_Button,color[1],color[2],color[3],color[4])
			if (GUI:Button(GetString("detectskills"), GUI:GetContentRegionAvailWidth(),25)) then
				gw2_skill_manager.profile.tmp.detectingSkills = not gw2_skill_manager.profile.tmp.detectingSkills
			end
			GUI:PopStyleColor(1)
			if (GUI:IsItemHovered() and gw2_skill_manager.toolTip) then
				GUI:SetTooltip("Enable to detect skills.")
			end
			
			if (GUI:CollapsingHeader(GetString("swap"))) then
				-- swap checkbox.
				GUI:Text(GetString("swap"))
				GUI:SameLine(0)
				gw2_skill_manager.profile.switchSettings.switchWeapons = GUI:Checkbox("##gw2sm-swapcheckbox", gw2_skill_manager.profile.switchSettings.switchWeapons)

				-- Class specific options.
				if (ml_global_information.Player_Profession == GW2.CHARCLASS.Engineer) then
					gw2_skill_manager.profile.professionSettings.engineer.kit = GUI:Combo("##gw2sm-engineerKit",gw2_skill_manager.profile.professionSettings.engineer.kit,gw2_skill_manager.engineerKits)
				elseif(ml_global_information.Player_Profession == GW2.CHARCLASS.Elementalist) then
					GUI:PushItemWidth((GUI:GetContentRegionAvailWidth()/2)-(GUI:GetStyle().iteminnerspacing.x/2))
					gw2_skill_manager.profile.professionSettings.elementalist.attunement_1 = GUI:Combo("##gw2sm-elementalistAttunement_1",gw2_skill_manager.profile.professionSettings.elementalist.attunement_1,gw2_skill_manager.elementalistAttunements)
					GUI:PopItemWidth()
					GUI:SameLine(0)
					GUI:PushItemWidth(GUI:GetContentRegionAvailWidth())
					gw2_skill_manager.profile.professionSettings.elementalist.attunement_2 = GUI:Combo("##gw2sm-elementalistAttunement_2",gw2_skill_manager.profile.professionSettings.elementalist.attunement_2,gw2_skill_manager.elementalistAttunements)
					GUI:PopItemWidth()
					GUI:PushItemWidth((GUI:GetContentRegionAvailWidth()/2)-(GUI:GetStyle().iteminnerspacing.x/2))
					gw2_skill_manager.profile.professionSettings.elementalist.attunement_3 = GUI:Combo("##gw2sm-elementalistAttunement_3",gw2_skill_manager.profile.professionSettings.elementalist.attunement_3,gw2_skill_manager.elementalistAttunements)
					GUI:PopItemWidth()
					GUI:SameLine(0)
					GUI:PushItemWidth(GUI:GetContentRegionAvailWidth())
					gw2_skill_manager.profile.professionSettings.elementalist.attunement_4 = GUI:Combo("##gw2sm-elementalistAttunement_4",gw2_skill_manager.profile.professionSettings.elementalist.attunement_4,gw2_skill_manager.elementalistAttunements)
					GUI:PopItemWidth()
				end
			end
			
			GUI:SetNextWindowPosCenter(GUI.SetCond_Always)
			GUI:SetNextWindowSize(400, 140, GUI.SetCond_Always)
			if (GUI:BeginPopupModal("##gw2sm-deleteporfile",true,GUI.WindowFlags_NoResize+GUI.WindowFlags_NoMove+GUI.WindowFlags_ShowBorders)) then
				GUI:Spacing()
				GUI:SameLine(50)
				GUI:Text("Are you sure you want to delete this profile?")
				GUI:Spacing()
				GUI:SameLine(80)
				GUI:SetWindowFontScale(0.8)
				GUI:Text("Press \"Delete\" to delete, \"Cancel\" to cancel. ")
				GUI:SetWindowFontScale(1)
				
				GUI:Spacing()
				GUI:Separator()
				GUI:Dummy(100,20)
				GUI:Spacing()
				GUI:SameLine(80)
				if (GUI:Button(GetString("cancel"),80,30)) then
					GUI:CloseCurrentPopup()
				end
				GUI:SameLine(240)
				if (GUI:Button(GetString("delete"),80,30)) then
					gw2_skill_manager.profileWindow.open = false
					gw2_skill_manager.profile:Delete()
					gw2_skill_manager.profileList = gw2_skill_manager:GetProfileList()
					GUI:CloseCurrentPopup()
				end
				GUI:EndPopup()
			end

			-- skill list child keeps scrolling in this erea.
			if (GUI:BeginChild("##gw2sm-skillregion", GUI:GetContentRegionAvailWidth(), 0, true)) then
				for priority,skill in ipairs(gw2_skill_manager.profile.skills) do
					if (skill.tmp.moving) then --GUI.Col_FrameBg highlight this shit?
						if (GUI:Button(GetString("ok##"..priority), GUI:CalcTextSize("0000"),20)) then
							if (gw2_skill_manager.profile:MoveSkill(priority,skill.tmp.newPriority)) then
								if (gw2_skill_manager.skillWindow.prio == priority) then
									gw2_skill_manager.skillWindow.prio = skill.tmp.newPriority
								end
								skill.tmp.newPriority = 0
								skill.tmp.moving = false
							end
						end
						GUI:SameLine(0)
						GUI:PushItemWidth(GUI:GetContentRegionAvailWidth())
						skill.tmp.newPriority = GUI:InputInt("##skillprioinputint"..priority,skill.tmp.newPriority,1,10)
						skill.tmp.newPriority = skill.tmp.newPriority < 1 and 1 or skill.tmp.newPriority > #gw2_skill_manager.profile.skills and #gw2_skill_manager.profile.skills or skill.tmp.newPriority
						GUI:PopItemWidth()
					else
						if (skill.tmp.dragging) then -- highlight these elements when dragging them
							local color = GUI:GetStyle().colors[GUI.Col_Button]
							GUI:PushStyleColor(GUI.Col_Button,color[1],color[2],color[3]*1.3,1)
							GUI:PushStyleColor(GUI.Col_ButtonHovered,color[1],color[2],color[3]*1.3,1)
						end
						if (GUI:Button(priority .. "##skillpriobutton", GUI:CalcTextSize("0000"),20)) then
							skill.tmp.newPriority = priority
							skill.tmp.moving = true
						end
						GUI:SetCursorPosY()
						GUI:SameLine(0)
						-- TODO: Make highlight better.
						local curState = gw2_skill_manager.skillWindow.prio
						if (curState == priority and not skill.tmp.dragging) then
							local color = GUI:GetStyle().colors[GUI.Col_ButtonActive]
							GUI:PushStyleColor(GUI.Col_Button,color[1],color[2],color[3], color[4])
						end
						if (GUI:Button(skill.skill.name .. "##" .. priority, GUI:GetContentRegionAvailWidth(),20)) then
							if (gw2_skill_manager.skillWindow.open == false or gw2_skill_manager.skillWindow.prio ~= priority) then
								gw2_skill_manager.skillWindow.open = true
								gw2_skill_manager.skillWindow.prio = priority
							else
								gw2_skill_manager.skillWindow.open = false
								gw2_skill_manager.skillWindow.prio = 0
							end
						end
						if (curState == priority and not skill.tmp.dragging) then
							GUI:PopStyleColor(1)
						end
						if (skill.tmp.dragging) then
							GUI:PopStyleColor(2)
						end
						
						if (GUI:IsItemHovered() and gw2_skill_manager.toolTip) then
							GUI:SetTooltip("Open edit window for: " .. skill.skill.name)
						end
					end
					-- Drag(right mouse button) the skill up or down.
					if (GUI:IsItemClicked(1) or skill.tmp.dragging) then
						skill.tmp.dragging = true
						if (GUI:IsMouseReleased(1) or not GUI:IsMouseDown(1) or not GUI:IsWindowHovered()) then
							skill.tmp.dragging = false
						end
						local x,y = GUI:GetMouseDragDelta(1)
						if (y >= 20 or y <= -20 ) then
							local curPrio = priority
							local movingIsOpen = priority == gw2_skill_manager.skillWindow.prio
							for i=1,round(math.abs(y/23)) do
								if (gw2_skill_manager.profile:MoveSkill(curPrio,y<0 and "up" or "down")) then
									curPrio = y<0 and curPrio-1 or curPrio+1
									-- move skill prio according to dragging.
									if (movingIsOpen == false and curPrio == gw2_skill_manager.skillWindow.prio) then
										gw2_skill_manager.skillWindow.prio = y<0 and gw2_skill_manager.skillWindow.prio+1 or gw2_skill_manager.skillWindow.prio-1
									elseif (movingIsOpen) then
										gw2_skill_manager.skillWindow.prio = curPrio
									end
									-- change prio change imput is open and skill moved and number still on original. prevent idiots from moving crap by mistake.
									if (gw2_skill_manager.profile.skills[y<0 and curPrio+1 or curPrio-1].tmp.newPriority == curPrio) then
										gw2_skill_manager.profile.skills[y<0 and curPrio+1 or curPrio-1].tmp.newPriority = y<0 and curPrio+1 or curPrio-1
									elseif (skill.tmp.newPriority == (y<0 and curPrio+1 or curPrio-1)) then
										skill.tmp.newPriority = curPrio
										--skill.tmp.moving = false
									end
								end
							end
							GUI:ResetMouseDragDelta(1)
						end
					end
				end
			end
			GUI:EndChild()
		end
		GUI:End()
	else
		gw2_skill_manager.skillWindow.open = false
	end
end
RegisterEventHandler("Gameloop.Draw", gw2_skill_manager.profileWindow.Draw)

function gw2_skill_manager.skillWindow.Draw(event,ticks)
	if (gw2_skill_manager.skillWindow.open) then
		local currentSkill = gw2_skill_manager.profile.skills[gw2_skill_manager.skillWindow.prio]
		GUI:SetNextWindowSize(250,400,GUI.SetCond_FirstUseEver) -- TODO: better start size, remove title bar, auto move with main?
		gw2_skill_manager.skillWindow.visible, gw2_skill_manager.skillWindow.open = GUI:Begin(currentSkill.skill.name.."###"..gw2_skill_manager.skillWindow.name, gw2_skill_manager.skillWindow.open, GUI.WindowFlags_NoCollapse)
		if (gw2_skill_manager.skillWindow.visible) then
			if (GUI:Button(GetString("moveup"), GUI:GetContentRegionAvailWidth()/2,25)) then
				if (gw2_skill_manager.profile:MoveSkill(gw2_skill_manager.skillWindow.prio,"up")) then
					gw2_skill_manager.skillWindow.prio = gw2_skill_manager.skillWindow.prio - 1
				end
			end
			if (GUI:IsItemHovered() and gw2_skill_manager.toolTip) then
				GUI:SetTooltip("Move this skill up.")
			end
			GUI:SameLine()
			-- Copy skill button.
			if (GUI:Button(GetString("copy"), GUI:GetContentRegionAvailWidth(),25)) then
				gw2_skill_manager.profile:CopySkill(gw2_skill_manager.skillWindow.prio)
			end
			if (GUI:IsItemHovered() and gw2_skill_manager.toolTip) then
				GUI:SetTooltip("Copy this skills setting to clipboard.")
			end
			-- Move skill down button.
			if (GUI:Button(GetString("movedown"), GUI:GetContentRegionAvailWidth()/2,25)) then
				if (gw2_skill_manager.profile:MoveSkill(gw2_skill_manager.skillWindow.prio,"down")) then
					gw2_skill_manager.skillWindow.prio = gw2_skill_manager.skillWindow.prio + 1
				end
			end
			if (GUI:IsItemHovered() and gw2_skill_manager.toolTip) then
				GUI:SetTooltip("Move this skill down.")
			end
			GUI:SameLine()
			-- paste skill button.
			if (GUI:Button(GetString("paste"), GUI:GetContentRegionAvailWidth(),25)) then
				gw2_skill_manager.profile:PasteSkill(gw2_skill_manager.skillWindow.prio)
				currentSkill = gw2_skill_manager.profile.skills[gw2_skill_manager.skillWindow.prio]
			end
			if (GUI:IsItemHovered() and gw2_skill_manager.toolTip) then
				GUI:SetTooltip("Paste the copied settings to this skill.")
			end
			-- delete skill button.
			if (GUI:Button(GetString("delete"), GUI:GetContentRegionAvailWidth()/2,25)) then
				gw2_skill_manager.profile:DeleteSkill(gw2_skill_manager.skillWindow.prio)
				gw2_skill_manager.skillWindow.open = false
			end
			if (GUI:IsItemHovered() and gw2_skill_manager.toolTip) then
				GUI:SetTooltip("Delete this skill.")
			end
			GUI:SameLine()
			-- Clone skill button.
			if (GUI:Button(GetString("clone"), GUI:GetContentRegionAvailWidth(),25)) then
				gw2_skill_manager.profile:CloneSkill(gw2_skill_manager.skillWindow.prio)
			end
			if (GUI:IsItemHovered() and gw2_skill_manager.toolTip) then
				GUI:SetTooltip("Clone this skill.")
			end

			-- skill data.
			-- skill list child keeps scrolling in this erea.
			if (GUI:BeginChild("##gw2sm-skillinfo", GUI:GetContentRegionAvailWidth(), 0, true)) then -- BUG: No border on child causes small layout glitch with scrollbars.
				GUI:SetNextTreeNodeOpened(true, GUI.SetCond_Appearing)
				if (GUI:CollapsingHeader(GetString("skill"))) then
					GUI:Columns(2, "skillinfocolumn", false)
					GUI:SetColumnOffset(1,170)
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("skillid"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("skillname"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("isprojectile"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("castonself"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("los"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("setrange"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("minrange"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("maxrange"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("radius"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("slowcast"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("prevskillid"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("delay"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("relativeposition"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("stopmovement"))
					GUI:NextColumn()
					GUI:PushItemWidth(GUI:GetContentRegionAvailWidth())
					GUI:InputText("##gw2sm-skillIDsadasd",currentSkill.skill.id,GUI.InputTextFlags_ReadOnly)
					GUI:InputText("##gw2sm-skillName",currentSkill.skill.name,GUI.InputTextFlags_ReadOnly)
					currentSkill.skill.isProjectile = GUI:Checkbox("##gw2sm-isprojectile", currentSkill.skill.isProjectile)
					currentSkill.skill.castOnSelf = GUI:Checkbox("##gw2sm-castonself", currentSkill.skill.castOnSelf)
					currentSkill.skill.los = GUI:Checkbox("##gw2sm-los", currentSkill.skill.los)
					currentSkill.skill.setRange = GUI:Checkbox("##gw2sm-setrange", currentSkill.skill.setRange)
					currentSkill.skill.minRange = GUI:InputInt("##gw2sm-minrange", currentSkill.skill.minRange, 100, 1000)
					currentSkill.skill.minRange = currentSkill.skill.minRange > 0 and currentSkill.skill.minRange or 0
					currentSkill.skill.maxRange = GUI:InputInt("##gw2sm-maxrange", currentSkill.skill.maxRange, 100, 1000)
					currentSkill.skill.maxRange = currentSkill.skill.maxRange > 0 and currentSkill.skill.maxRange or 0
					currentSkill.skill.radius = GUI:InputInt("##gw2sm-radius", currentSkill.skill.radius, 100, 1000)
					currentSkill.skill.radius = currentSkill.skill.radius > 0 and currentSkill.skill.radius or 0
					currentSkill.skill.slowCast = GUI:Checkbox("##gw2sm-slowcast", currentSkill.skill.slowCast)
					currentSkill.skill.lastSkillID = GUI:InputText("##gw2sm-prevskillid",currentSkill.skill.lastSkillID)
					currentSkill.skill.delay = GUI:InputInt("##gw2sm-delay", currentSkill.skill.delay, 100, 1000)
					currentSkill.skill.delay = currentSkill.skill.delay > 0 and currentSkill.skill.delay or 0
					currentSkill.skill.relativePosition = GUI:Combo("##gw2sm-engineerKit",currentSkill.skill.relativePosition,gw2_skill_manager.relativePosition)
					currentSkill.skill.stopsMovement = GUI:Checkbox("##gw2sm-slowcast", currentSkill.skill.stopsMovement)
					GUI:PopItemWidth()
					GUI:Columns(1)
				end
				GUI:SetNextTreeNodeOpened(true, GUI.SetCond_Appearing)
				if (GUI:CollapsingHeader(GetString("player"))) then
					GUI:Columns(2, "playerinfocolumn", false)
					GUI:SetColumnOffset(1,170)
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("combatstate"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("minhp"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("maxhp"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("minpower"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("maxpower"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("minendurance"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("maxendurance"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("alliesnearcount"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("alliesrange"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("aliesdownedcount"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("aliesdownedrange"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("hasbuffs"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("hasnotbuffs"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("conditioncount"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("booncount"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("movementstate"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:NextColumn()
					GUI:PushItemWidth(GUI:GetContentRegionAvailWidth())
					currentSkill.player.combatState = GUI:Combo("##gw2sm-engineerKit",currentSkill.player.combatState,gw2_skill_manager.combatState)
					currentSkill.player.minHP = GUI:InputInt("##gw2sm-plminhp", currentSkill.player.minHP, 1, 10)
					currentSkill.player.minHP = currentSkill.player.minHP > 0 and currentSkill.player.minHP or 0
					currentSkill.player.maxHP = GUI:InputInt("##gw2sm-plmaxhp", currentSkill.player.maxHP, 1, 10)
					currentSkill.player.maxHP = currentSkill.player.maxHP > 0 and currentSkill.player.maxHP or 0
					currentSkill.player.minPower = GUI:InputInt("##gw2sm-plminpower", currentSkill.player.minPower, 1, 10)
					currentSkill.player.minPower = currentSkill.player.minPower > 0 and currentSkill.player.minPower or 0
					currentSkill.player.maxPower = GUI:InputInt("##gw2sm-plmaxpower", currentSkill.player.maxPower, 1, 10)
					currentSkill.player.maxPower = currentSkill.player.maxPower > 0 and currentSkill.player.maxPower or 0
					currentSkill.player.minEndurance = GUI:InputInt("##gw2sm-plminendurance", currentSkill.player.minEndurance, 1, 10)
					currentSkill.player.minEndurance = currentSkill.player.minEndurance > 0 and currentSkill.player.minEndurance or 0
					currentSkill.player.maxEndurance = GUI:InputInt("##gw2sm-plmaxendurance", currentSkill.player.maxEndurance, 1, 10)
					currentSkill.player.maxEndurance = currentSkill.player.maxEndurance > 0 and currentSkill.player.maxEndurance or 0
					--TODO: prevent negative number from here. finding better way now. and getting food.
					currentSkill.player.allyNearCount = GUI:InputInt("##gw2sm-plalliescount", currentSkill.player.allyNearCount, 1, 10)
					currentSkill.player.allyRangeMax = GUI:InputInt("##gw2sm-plalliesrange", currentSkill.player.allyRangeMax, 100, 1000)
					currentSkill.player.allyDownedNearCount = GUI:InputInt("##gw2sm-plaliesdownedcount", currentSkill.player.allyDownedNearCount, 1, 10)
					currentSkill.player.allyDownedRangeMax = GUI:InputInt("##gw2sm-plaliesdownedrange", currentSkill.player.allyDownedRangeMax, 100, 1000)
					currentSkill.player.hasBuffs = GUI:InputText("##gw2sm-plhasbuffs",currentSkill.player.hasBuffs)
					currentSkill.player.hasNotBuffs = GUI:InputText("##gw2sm-plhasnotbuffs",currentSkill.player.hasNotBuffs)
					currentSkill.player.conditionCount = GUI:InputInt("##gw2sm-plconditioncount", currentSkill.player.conditionCount, 1, 5)
					currentSkill.player.boonCount = GUI:InputInt("##gw2sm-plbooncount", currentSkill.player.boonCount, 1, 5)
					currentSkill.player.moving = GUI:Combo("##gw2sm-plmovementstate",currentSkill.player.moving,gw2_skill_manager.movementState)
					GUI:PopItemWidth()
					GUI:Columns(1)
				end
				GUI:SetNextTreeNodeOpened(true, GUI.SetCond_Appearing)
				if (GUI:CollapsingHeader(GetString("target"))) then
					GUI:Columns(2, "targetinfocolumn", false)
					GUI:SetColumnOffset(1,170)
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("targettype"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("minhp"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("maxhp"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("enemiesnearcount"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("enemiesnearrange"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("movementstate"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("hasbuffs"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("hasnotbuffs"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("conditioncount"))
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(GetString("booncount"))
					GUI:NextColumn()
					GUI:PushItemWidth(GUI:GetContentRegionAvailWidth())
					currentSkill.target.type = GUI:Combo("##gw2sm-targettype",currentSkill.target.type,gw2_skill_manager.targetType)
					currentSkill.target.minHP = GUI:InputInt("##gw2sm-tminhp", currentSkill.target.minHP, 1, 10)
					currentSkill.target.maxHP = GUI:InputInt("##gw2sm-tmaxhp", currentSkill.target.maxHP, 1, 10)
					currentSkill.target.enemyNearCount = GUI:InputInt("##gw2sm-tenemynearcount", currentSkill.target.enemyNearCount, 1, 10)
					currentSkill.target.enemyRangeMax = GUI:InputInt("##gw2sm-plenemynearrange", currentSkill.target.enemyRangeMax, 100, 1000)
					currentSkill.target.moving = GUI:Combo("##gw2sm-tmovementstate",currentSkill.target.moving,gw2_skill_manager.movementState)
					currentSkill.target.hasBuffs = GUI:InputText("##gw2sm-thasbuffs",currentSkill.target.hasBuffs)
					currentSkill.target.hasNotBuffs = GUI:InputText("##gw2sm-thasnotbuffs",currentSkill.target.hasNotBuffs)
					currentSkill.target.conditionCount = GUI:InputInt("##gw2sm-tconditioncount", currentSkill.target.conditionCount, 1, 5)
					currentSkill.target.boonCount = GUI:InputInt("##gw2sm-tbooncount", currentSkill.target.boonCount, 1, 5)
					GUI:PopItemWidth()
					GUI:Columns(1)
				end
			end
			GUI:EndChild()
		end
		GUI:End()
	else
		gw2_skill_manager.skillWindow.prio = 0
	end
end
RegisterEventHandler("Gameloop.Draw", gw2_skill_manager.skillWindow.Draw)

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- **Profile functions**
---------------------------------------------------------------------------------------------------------------------------------------------------------

-- New profile.
function gw2_skill_manager:NewProfile(profileName)
	if (GetGameState() == 16 and string.valid(profileName) and profileName ~= "None") then
		profileName = string.gsub(profileName,'%W','')
		--[[local list = self:GetProfileList()
		for _,name in pairs(list.nameList) do
			if (name == profileName) then return self:GetProfile(profileName) end
		end]]
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
	if (GetGameState() == 16 and string.valid(profileName) and profileName ~= "None") then
		profileName = string.gsub(profileName,'%W','')
		profileName = gw2_common_functions.GetProfessionName() .. "_" .. profileName
		for _,path in pairs (self.paths) do 
			local profile = persistence.load(path .. profileName .. ".lua")
			if (profile) then
				profile = inheritTable(profilePrototype, profile)
				
				---temp update profile boolean crap
				
				
				
				---end
				
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

-- update profile
function gw2_skill_manager:UpdateProfileList()
	if (GetGameState() == 16 and Player.profession ~= gw2_skill_manager.PlayerProfession) then
		if (Settings.GW2Minion.gCurrentProfile[Player.name] == nil) then
			Settings.GW2Minion.gCurrentProfile[Player.name] = "GW2Minion"
			Settings.GW2Minion.gCurrentProfile = Settings.GW2Minion.gCurrentProfile
		end
		gw2_skill_manager.PlayerProfession = Player.profession
		gw2_skill_manager.profile = gw2_skill_manager:GetProfile(Settings.GW2Minion.gCurrentProfile[ml_global_information.Player_Name])
		gw2_skill_manager.profileList = gw2_skill_manager:GetProfileList()
	end
end

-- Check for profile.
function gw2_skill_manager:ProfileReady()
	if (table.valid(self.profile)) then
		return true
	end
	--ml_error("No current profile, please select or create a profile first.")
	return false
end

-- Get profile list.
function gw2_skill_manager:GetProfileList(newProfile)
	local profession = Player.Profession
	local list = {nameList = {"None",}, currID = 1, newProfileName = ""}
	if (profession) then
		for _,p in pairs (self.paths) do 
			local profileList = FolderList(p,[[(.*)lua$]])
			if (table.valid(profileList)) then
				for _,profileName in pairs(profileList) do
					local profile = persistence.load(p .. profileName)
					if (table.valid(profile)) then
						if (profile.profession == profession and string.valid(profile.name)) then
							table.insert(list.nameList, profile.name)
							if (gw2_skill_manager.profile and gw2_skill_manager.profile.name == profile.name) then
								list.currID = table.size(list.nameList)
							end
						end
					end
				end
			end
		end
	end
	if (string.valid(newProfile)) then
		if (table.contains(list,newProfile) == false) then
			table.insert(list.nameList, newProfile)
			list.currID = table.size(list.nameList)
		end
	end
	return list
end

-- Update current skills.
function gw2_skill_manager:UpdateCurrentSkillbarSkills()
	self.currentSkillbarSkills = {}
	for i = 1, ml_global_information.MAX_SKILLBAR_SLOTS-1 do
		local currentSkill = Player:GetSpellInfo(GW2.SKILLBARSLOT["Slot_" .. i])
		if (currentSkill) then
			self.currentSkillbarSkills[currentSkill.skillid] = currentSkill
			
			--Auto-update Profile with changed skillnames
			if ( self.profile ~= nil and currentSkill.skillid and currentSkill.name and currentSkill.name ~= "") then 
				for priority,skill in pairs(self.profile.skills) do
					if (skill.skill.id == currentSkill.skillid) then
						skill.tmp.slot = currentSkill.slot
						if (skill.skill.name ~= currentSkill.name) then
							skill.skill.name = currentSkill.name
						end
					end
				end
			end
		end
	end
	
	gw2_skill_manager.UpdateSkillTrackerData()	
end

-- Detect skills.
function gw2_skill_manager:DetectSkills()
	if (self:ProfileReady() and self.profile.tmp.detectingSkills) then
		self.profile:DetectSkills()
	end
end

-- Use skill profile.
function gw2_skill_manager:Use(targetID)
	if ((gBotRunning == "1" or (ml_bt_mgr and ml_bt_mgr.running)) and self:ProfileReady()) then
		self.profile:Use(targetID)
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
	if (string.valid(path) and TableContains(gw2_skill_manager.paths, path) == false) then
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
	if (table.valid(saveFile.skills)) then
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
	FileDelete(self.tmp.path .. gw2_common_functions.GetProfessionName(self.profession) .. "_" .. self.name .. ".lua")
	return true
end

-- Clone.
function profilePrototype:Clone(newName)
	if (string.valid(newName)) then
		local saveFile = deepcopy(self)
		saveFile.name = newName
		return saveFile:Save()
	end
	return false
end

-- Use profile.
function profilePrototype:Use(targetID)
	self.tmp.activeSkillRange = 154
	if (tonumber(targetID) ~= nil) then -- refresh targetid and timestamp.
		Player:SetTarget(targetID)
		self.tmp.target = {targetID = targetID, timestamp = (ml_global_information.Now + 500),}
	elseif (ml_global_information.Now - self.tmp.target.timestamp >= 0) then -- remove expired target.
		self.tmp.target = {targetID = nil, timestamp = ml_global_information.Now,}
	end
	self:Swap(self.tmp.target.targetID)
	if (self:CheckTargetBuffs(self.tmp.target.targetID)) then
		for k,skill in ipairs(self.skills) do
			if (skill:CanCast(self.tmp.target.targetID)) then
				if (self:CheckTargetHealth(self.tmp.target.targetID)) then
					skill:Cast(self.tmp.target.targetID)
				end
				break
			end
		end
	end
	self:DoCombatMovement(self.tmp.target.targetID)
	return true
end

-- Do CombatMovement
function profilePrototype:DoCombatMovement(targetID)
	local target = CharacterList:Get(targetID) or GadgetList:Get(targetID)
	local noStopMovementBuffs = gw2_common_functions.HasBuffs(Player,"791,727") == false
	if (table.valid(target) and self.tmp.combatMovement.allowed and target.distance <= (self.tmp.activeSkillRange + 250) and noStopMovementBuffs and gDoCombatMovement ~= "0" and ml_global_information.Player_OnMesh and ml_global_information.Player_Alive and ml_global_information.Player_Health.percent < 99) then
		gw2_common_functions.Evade()
		local forward,backward,left,right,forwardLeft,forwardRight,backwardLeft,backwardRight = GW2.MOVEMENTTYPE.Forward,GW2.MOVEMENTTYPE.Backward,GW2.MOVEMENTTYPE.Left,GW2.MOVEMENTTYPE.Right,4,5,6,7
		local currentMovement = ml_global_information.Player_MovementDirections
		local movementDirection = {[forward] = true, [backward] = true,[left] = true,[right] = true,}
		local tDistance = target.distance
		-- Stop walking into range.
		if (self.tmp.combatMovement.range and target.distance < self.tmp.activeSkillRange - 250) then Player:StopMovement() self.tmp.combatMovement.range = false end
		-- Face target.
		if (table.valid(target)) then Player:SetFacingExact(target.pos.x,target.pos.y,target.pos.z) end
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

		if (movementDirection[forward] and table.size(gw2_common_functions.filterRelativePostion(targets,forward)) > 0) then movementDirection[forward] = false end
		if (movementDirection[backward] and table.size(gw2_common_functions.filterRelativePostion(targets,backward)) > 0) then movementDirection[backward] = false end
		if (movementDirection[left] and table.size(gw2_common_functions.filterRelativePostion(targets,left)) > 0) then movementDirection[left] = false end
		if (movementDirection[right] and table.size(gw2_common_functions.filterRelativePostion(targets,right)) > 0) then movementDirection[right] = false end
		--
		if (movementDirection[forward]) then
			if (movementDirection[left] and table.size(gw2_common_functions.filterRelativePostion(targets,forwardLeft)) > 0) then
				movementDirection[left] = false
			elseif (movementDirection[right] and table.size(gw2_common_functions.filterRelativePostion(targets,forwardRight)) > 0) then
				movementDirection[right] = false
			end
		elseif (movementDirection[backward]) then
			if (movementDirection[left] and table.size(gw2_common_functions.filterRelativePostion(targets,backwardLeft)) > 0) then
				movementDirection[left] = false
			elseif (movementDirection[right] and table.size(gw2_common_functions.filterRelativePostion(targets,backwardRight)) > 0) then
				movementDirection[right] = false
			end
		end

		-- We know where we can move, decide where to go.
		if (movementDirection[forward] and movementDirection[backward]) then -- Can move forward and backward, choose.
			
			-- Range, try to stay back from target.
			if (self.tmp.activeSkillRange > 300) then
				movementDirection[forward] = false
				if (tDistance >= self.tmp.activeSkillRange - 25) then
					movementDirection[backward] = false
				end
			end
			-- Melee, try to stay close to target.
			if (self.tmp.activeSkillRange <= 300) then
				movementDirection[backward] = false
				if (tDistance <= self.tmp.activeSkillRange - 25) then
					movementDirection[forward] = false
				end
			end
			
			--[[if (currentMovement.forward) then -- We are moving forward already.
				if (math.random(0,25) ~= 3) then -- Keep moving backwards/forwards gets higher chance.
					--movementDirection[forward] = false
					movementDirection[backward] = false
				else
					--movementDirection[backward] = false
					movementDirection[forward] = false
				end
			elseif (currentMovement.backward) then -- We are moving backward already.
				if (math.random(0,25) ~= 3) then -- Keep moving backward gets higher chance.
					movementDirection[forward] = false
				else
					movementDirection[backward] = false
				end
			end--]]
		end
		if (movementDirection[left] and movementDirection[right]) then -- Can move left and right, choose.
			if (currentMovement.left) then -- We are moving left already.
				if (math.random(0,250) ~= 3) then -- Keep moving left gets higher chance.
					movementDirection[right] = false
				else
					movementDirection[left] = false
				end
			elseif (currentMovement.right) then -- We are moving right already.
				if (math.random(0,250) ~= 3) then -- Keep moving right gets higher chance.
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
	elseif (table.valid(target) and target.distance > self.tmp.activeSkillRange and noStopMovementBuffs and (gBotMode ~= GetString("assistMode") or Settings.GW2Minion.moveintoombatrange == true) and not gw2_unstuck.HandleStuck("combat") and ml_global_information.Player_OnMesh and ml_global_information.Player_Alive) then
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
		if (skillInfo and skillInfo.skillid ~= 10586 and string.valid(skillInfo.name)) then
			for priority,skill in pairs(self.skills) do
				if (skill.skill.id == skillInfo.skillid) then
					return false
				end
			end
			newSkill = {
				skill = {	id				= skillInfo.skillid,
							name			= skillInfo.name,
							groundTargeted	= skillInfo.isGroundTargeted,
							setRange		= skillSlot >= 1 and skillSlot <= 5 or false,
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
	if (table.valid(skill) and direction) then
		local newPriority = nil
		if (string.valid(direction)) then
			newPriority = (direction == "up" and skillPriority > 1 and skillPriority - 1 or direction == "down" and skillPriority < #self.skills and skillPriority + 1)
		elseif (tonumber(direction) and direction > 0 and direction <= #self.skills) then
			newPriority = direction
		end
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
function profilePrototype:GetSkillByID(skillid)
	for _,skill in ipairs(self.skills) do
		if (skill.skill.id == skillid) then
			return skill
		end
	end
	return
end

-- Check Target Health.
function profilePrototype:CheckTargetHealth(targetID)
	local target = CharacterList:Get(targetID) or GadgetList:Get(targetID)
	if (table.valid(target) and target.id ~= Player.id) then
		if (target.id ~= self.tmp.targetCheck.id or target.contentid ~= self.tmp.targetCheck.contentid) then
			self.tmp.targetCheck = {
				id = target.id,
				contentid = target.contentid,
				health = target.health,
				lastTicks = ml_global_information.Now,
			}
		elseif (ml_global_information.Now - self.tmp.targetCheck.lastTicks > 2500) then
			if (target.health.percent > (self.tmp.targetCheck.health.percent + 25) or (ml_global_information.Now - self.tmp.targetCheck.lastTicks > 15000 and target.health.percent > 90)) then
				d("!!!!!!!!!!!!!!! TARGET BLACKLISTED, NOT DYING !!!!!!!!!!!!!!!")
				ml_blacklist.AddBlacklistEntry(GetString("monsters"), target.contentid, target.name, ml_global_information.Now + 90000)
				return false
			end
			self.tmp.targetCheck = {
				id = target.id,
				contentid = target.contentid,
				health = target.health,
				lastTicks = ml_global_information.Now,
			}
		end
	end
	return true
end

-- Check Target Buffs.
function profilePrototype:CheckTargetBuffs(targetID)
	local target = CharacterList:Get(targetID) or GadgetList:Get(targetID)
	if (table.valid(target) and target.id ~= Player.id) then
		if (gw2_common_functions.BufflistHasBuffs(target.buffs,self.tmp.targetBlacklistBuffs)) then
			d("!!!!!!!!!!!!!!! TARGET BLACKLISTED, INVUNRABLE BUFFS !!!!!!!!!!!!!!!")
			ml_blacklist.AddBlacklistEntry(GetString("monsters"),target.contentid,target.name,ml_global_information.Now+30000)
			return false
		end
	end
	return true
end

-- Swap pet.
function profilePrototype:SwapPet()
	if (ml_global_information.Player_Profession == GW2.CHARCLASS.Ranger) then
		local pet = Player:GetPet()
		if (Player:CanSwitchPet() and ml_global_information.Player_Alive and table.valid(pet) and (pet.alive == false or pet.health.percent < 15)) then
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
			if ( table.valid(gw2_skill_manager.currentSkillbarSkills[stowID]) ) then
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
			if ( not table.valid(gw2_skill_manager.SkillTracker.weapons[ml_global_information.Player_CurrentWeaponSet]) ) then
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
			if ( table.valid(gw2_skill_manager.currentSkillbarSkills[stowID]) ) then
				gw2_skill_manager.SkillTracker.kits[kitID].inuse = true
				-- We have this kit equipped currently, update the data
				--d("USING : "..gw2_skill_manager.SkillTracker.kits[kitID].name)
				if (table.valid(gw2_skill_manager.SkillTracker.kits[kitID])) then 
					
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
				if ( table.valid(gw2_skill_manager.currentSkillbarSkills[kitID]) ) then
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
	if ( not table.valid(trackerEntry.cooldowns[slot]) ) then
		trackerEntry.cooldowns[slot] = {maxcd = 0, current = 0, timestamp = 0}
	end
	if ( not trackerEntry.range[slot] ) then
		trackerEntry.range[slot] = 0
	end
	
	local cdTable = trackerEntry.cooldowns[slot]
			
	if ( table.valid(skilldata) ) then
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
			if ( ml_global_information.Player_CurrentWeaponSet ~= 4 and table.valid(gw2_skill_manager.SkillTracker.weapons[4])) then wpsets[4] = { set = gw2_skill_manager.SkillTracker.weapons[4], prio = 0 } end
			if ( ml_global_information.Player_Level > 9 and ml_global_information.Player_Profession ~= GW2.CHARCLASS.Engineer and ml_global_information.Player_Profession ~= GW2.CHARCLASS.Elementalist ) then -- this is needed, else the not existing weapon 2 is being added as "possible to swap to" set
				if ( ml_global_information.Player_CurrentWeaponSet ~= 5 and table.valid(gw2_skill_manager.SkillTracker.weapons[5])) then wpsets[5] = { set = gw2_skill_manager.SkillTracker.weapons[5], prio = 0 } end		
			end
		
		elseif ( ml_global_information.Player_SwimState == GW2.SWIMSTATE.Diving ) then
			if ( ml_global_information.Player_CurrentWeaponSet ~= 0 and table.valid(gw2_skill_manager.SkillTracker.weapons[0])) then wpsets[0] = { set = gw2_skill_manager.SkillTracker.weapons[0], prio = 0 } end
			if ( ml_global_information.Player_CurrentWeaponSet ~= 1 and table.valid(gw2_skill_manager.SkillTracker.weapons[1])) then wpsets[1] = { set = gw2_skill_manager.SkillTracker.weapons[1], prio = 0 } end				
		end
	end
	
	-- Elementalist	
	if (ml_global_information.Player_Profession == GW2.CHARCLASS.Elementalist and ml_global_information.Now - gw2_skill_manager.SkillTracker.elelastswap > 1250) then		
		if ( ml_global_information.Player_TransformID ~= 1 and table.valid(gw2_skill_manager.SkillTracker.attunements[1]) and self:ShouldUseAttunement(gw2_skill_manager.SkillTracker.attunements[1].name) and self:CanCastSlot(GW2.SKILLBARSLOT.Slot_13)) then wpsets[13] = { set = gw2_skill_manager.SkillTracker.attunements[1], prio = 0 } end
		if ( ml_global_information.Player_TransformID ~= 2 and table.valid(gw2_skill_manager.SkillTracker.attunements[2]) and self:ShouldUseAttunement(gw2_skill_manager.SkillTracker.attunements[2].name) and self:CanCastSlot(GW2.SKILLBARSLOT.Slot_14)) then wpsets[14] = { set = gw2_skill_manager.SkillTracker.attunements[2], prio = 0 } end
		if ( ml_global_information.Player_TransformID ~= 3 and table.valid(gw2_skill_manager.SkillTracker.attunements[3]) and self:ShouldUseAttunement(gw2_skill_manager.SkillTracker.attunements[3].name) and self:CanCastSlot(GW2.SKILLBARSLOT.Slot_15)) then wpsets[15] = { set = gw2_skill_manager.SkillTracker.attunements[3], prio = 0 } end
		if ( ml_global_information.Player_TransformID ~= 4 and table.valid(gw2_skill_manager.SkillTracker.attunements[4]) and self:ShouldUseAttunement(gw2_skill_manager.SkillTracker.attunements[4].name) and self:CanCastSlot(GW2.SKILLBARSLOT.Slot_16)) then wpsets[16] = { set = gw2_skill_manager.SkillTracker.attunements[4], prio = 0 } end
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
	--d("CanSwapWeapon table.size :"..tostring(table.size(wpsets)))
	--d(wpsets)
	
	-- Add our current weaponset
	if ( currentwpset ) then
		wpsets[100] = {set = currentwpset, prio = 1 }
	end
	
	-- Evaluate & Swap	
	if ( table.size(wpsets) > 0 ) then
		local bestwpset
		local bestID
		for setID,entry in pairs(wpsets) do
			local israngeweapon = false
			-- We should switch to that skill asap so the data gets set/initialized			
			if ( not table.valid(entry.set.range) or not table.valid(entry.set.cooldowns)) then
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
		if ( currentwpset ) then		
			if ( bestwpset.set.name ~= currentwpset.name ) then
				--d("Switching from "..currentwpset.name.." to "..bestwpset.set.name.. " (Prio "..tostring(bestwpset.prio)..") setID:"..tostring(bestID) .." ID .."..tostring(ml_global_information.Player_TransformID))
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
end

--Elementalist check if the attunement should be swapped to at alliesDownedNearCount
function profilePrototype:ShouldUseAttunement( name ) 
	return self.professionSettings.elementalist.attunement_1 == name or 
		   self.professionSettings.elementalist.attunement_2 == name or
		   self.professionSettings.elementalist.attunement_3 == name or
		   self.professionSettings.elementalist.attunement_4 == name
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
	if (settings.switchWeapons) then 
		if ( TimeSince(timers.lastSwap) > 1500) then
			timers.lastSwap = ml_global_information.Now	
			
			
			local canSwap = false
			local target = CharacterList:Get(targetID) or GadgetList:Get(targetID)
				
			--[[if (canSwap == false and settings.switchOnRange and TimeSince(timers.lastRangeSwap) > 0) then
				timers.lastRangeSwap = ml_global_information.Now		
				if ( self.tmp.maxAttackRange < 300 and table.valid(target) and target.distance > self.tmp.maxAttackRange) then
					timers.lastRangeSwap = ml_global_information.Now + math.random(5000,10000)
					canSwap = true
				end
			end	
			if (settings.switchRandom and (ml_global_information.Player_InCombat or ml_global_information.Player_IsMoving) and TimeSince(timers.lastRandomSwap) > 0) then
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
			
			if ( table.valid(target) ) then
				-- Don't swap on slowcast spells, else they get interrupted
				local canswap = true
				local lastSkillID = (Player.castinfo.skillID == 0 and Player.castinfo.lastSkillID or Player.castinfo.skillID)
				if ( lastSkillID ) then 
					local lastSkill = self:GetSkillByID(lastSkillID)
					if (lastSkill and lastSkill.skill.slowCast and Player.castinfo.slot == lastSkill.tmp.slot) then 
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
		local slot = skill.tmp.slot
		local skillType = 4
		if(slot > 10) then
			skillType = 3
		elseif(skill.skill.castOnSelf or slot == 0) then
			skillType = 1
			skill.skill.castOnSelf = true
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

			if (table.valid(skill)) then
				-- Healing -> Elites -> F skills -> Slot skills -> Weapon skills in reverse
				if (skill.tmp.slot == 0) then
					result = result + 400000
					if ( skill.player.minHP and skill.player.minHP == 0 ) then
						skill.player.minHP = 75
					end
				elseif (skill.tmp.slot == 4) then
					result = result + 100000
				elseif (skill.tmp.slot > 10) then
					result = result + 60000
				elseif (skill.tmp.slot >= 1 and skill.tmp.slot <= 3) then
					result = result + 40000
				else
					result = result + skill.tmp.slot
				end
				-- Longer range higher.
				result = skill.skill.maxRange / 1000 > 0 and result + skill.skill.maxRange / 1000 or result
				result = skill.skill.minRange / 1000 > 0 and result + skill.skill.minRange / 1000 or result
				-- skills with less checks first
				result = result + table.size(skill.skill) + table.size(skill.player) + table.size(skill.target)
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
function skillPrototype:CanCast(targetID) -- TODO: change to use booleans
	local skillOnBar = gw2_skill_manager.currentSkillbarSkills[self.skill.id] or {}
	local target = CharacterList:Get(targetID) or GadgetList:Get(targetID)
	if (table.valid(skillOnBar) and (table.valid(target) or self.skill.castOnSelf) ) then
		
		-- get last skill.
		local lastSkillID = (Player.castinfo.skillID == 0 and Player.castinfo.lastSkillID or Player.castinfo.skillID)

		-- skillBar attributes.
		if (skillOnBar.cooldown == 1) then return false end
		self.tmp.slot = skillOnBar.slot
		
		if (skillOnBar.power > ml_global_information.Player_Power) then return false end
		
		-- skill attributes.
		if (self.skill.id == Player.castinfo.skillID and self.tmp.slot ~= GW2.SKILLBARSLOT.Slot_1) then return false end
		if (self.skill.lastSkillID ~= "" and string.contains(tostring(self.skill.lastSkillID),tostring(lastSkillID)) == false) then return false end
		if (self.skill.delay > 0 and self.tmp.lastCastTime and TimeSince(self.tmp.lastCastTime) < (self.skill.delay)) then return false end -- IMPORT: devide all delay times by 100
		if (table.valid(target)) then
			if (self.skill.los and target.los == false) then return false end
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
			if (table.size(CharacterList("friendly," .. maxdistance .. "distanceto=" .. Player.id .. ",exclude=" .. Player.id)) < self.player.allyNearCount) then return false end
		end
		if (self.player.allyDownedNearCount > 0) then
			local maxdistance = (self.player.allyDownedRangeMax > 0 and self.player.allyDownedRangeMax or 2500)
			if (table.size(CharacterList("friendly,maxdistance=" .. maxdistance .. ",distanceto=" .. Player.id .. ",downed,exclude=" .. Player.id)) < self.player.allyDownedNearCount) then return false end
		end
		local playerBuffList = Player.buffs
		if (self.player.hasBuffs ~= "" and table.valid(playerBuffList) and not gw2_common_functions.BufflistHasBuffs(playerBuffList, tostring(self.player.hasBuffs))) then return false end
		if (self.player.hasNotBuffs ~= "" and table.valid(playerBuffList) and gw2_common_functions.BufflistHasBuffs(playerBuffList, tostring(self.player.hasNotBuffs))) then return false end
		if (self.player.conditionCount > 0 and table.valid(playerBuffList) and gw2_common_functions.CountConditions(playerBuffList) < self.player.conditionCount) then return false end
		if (self.player.boonCount > 0 and table.valid(playerBuffList) and gw2_common_functions.CountBoons(playerBuffList) < self.player.boonCount) then return false end
		if (self.player.moving == "Moving" and ml_global_information.Player_MovementState == GW2.MOVEMENTSTATE.GroundNotMoving ) then return false end
		if (self.player.moving == "NotMoving" and ml_global_information.Player_MovementState == GW2.MOVEMENTSTATE.GroundMoving ) then return false end
		-- target attributes.
		if (table.valid(target)) then
			local targetBuffList = (target.buffs or false)
			if (self.target.minHP > 0 and target.health.percent > self.target.minHP) then return false end
			if (self.target.maxHP > 0 and target.health.percent < self.target.maxHP) then return false end
			if (self.target.enemyNearCount > 0) then
				local maxdistance = (self.target.enemyRangeMax == 0 and "" or "maxdistance=" .. self.target.enemyRangeMax .. ",")
				if (table.size(CharacterList("attackable," .. maxdistance .. "distanceto=" .. target.id .. ",exclude=" .. target.id)) < self.target.enemyNearCount) then return false end
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
		self.parent.tmp.combatMovement.allowed = not self.skill.stopsMovement

		-- Check lastSkill attributes.
		local lastSkill = self.parent:GetSkillByID(lastSkillID)
		if (lastSkill and lastSkill.skill.slowCast and Player.castinfo.slot == lastSkill.tmp.slot) then return false end
		
		-- update profile range.
		if (self.skill.setRange) then
			self.parent.tmp.maxAttackRange = (self.skill.maxRange > 0 and self.skill.maxRange > self.parent.tmp.maxAttackRange and self.skill.maxRange or self.parent.tmp.maxAttackRange)
			self.parent.tmp.maxAttackRange = (self.skill.radius > 0 and self.skill.radius > self.parent.tmp.maxAttackRange and self.skill.radius or self.parent.tmp.maxAttackRange)
		end
		
		-- skill can be cast now.
		return true
	-- update profile range.
	elseif (table.valid(target) == false and self.skill.setRange and table.valid(skillOnBar) and skillOnBar.cooldown == 0 and ( self.player.maxPower <= 0 or ml_global_information.Player_Power > self.player.maxPower)) then
		self.parent.tmp.maxAttackRange = (self.skill.maxRange > 0 and self.skill.maxRange > self.parent.tmp.maxAttackRange and self.skill.maxRange or self.parent.tmp.maxAttackRange)
		self.parent.tmp.maxAttackRange = (self.skill.radius > 0 and self.skill.radius > self.parent.tmp.maxAttackRange and self.skill.radius or self.parent.tmp.maxAttackRange)		
	end
	return false
end

-- cast.
function skillPrototype:Cast(targetID)
	local target = CharacterList:Get(targetID) or GadgetList:Get(targetID)
	-- Face target.
	--if (table.valid(target)) then Player:SetFacingExact(target.pos.x,target.pos.y,target.pos.z) end
	-- Target self if needed.
	target = (self.skill.castOnSelf and Player or table.valid(target) and target or nil)
	if (table.valid(target)) then
		--d("Casting Spell : " ..self.skill.name)
		local pos = target.pos--self:Predict(target) -- just too off target. crap target prediction.
		local castresult = false
		if (self.skill.groundTargeted) then
			if (target.isCharacter) then
				castresult = Player:CastSpell(self.tmp.slot, pos.x, pos.y, pos.z)
			elseif (target.isGadget) then
				if (self.skill.isProjectile) then
					castresult = Player:CastSpell(self.tmp.slot, pos.x, pos.y, (pos.z))
				else
					castresult = Player:CastSpell(self.tmp.slot, pos.x, pos.y, (pos.z - target.height))
				end
			end
		else
			castresult = Player:CastSpell(self.tmp.slot, target.id)
		end
		
		if ( castresult and gw2_skill_manager.currentSkillbarSkills[self.skill.id]) then
			--self.tmp.cast = false TODO: Color the currently fired skill? color all skill according to casting/canCast/cannotCast?
			local trackerEntry = gw2_skill_manager.GetCurrentSkillTrackerEntry()
			if ( trackerEntry ) then
				gw2_skill_manager.RefreshSkillTrackerEntry( trackerEntry, self.tmp.slot, gw2_skill_manager.currentSkillbarSkills[self.skill.id], ml_global_information.Now )
			end
			
			-- Necromancer transformation (death shroud / reaper shroud) fails when swapping weapons during the transformation, so we increase the swaptimer here a bit
			if ( ml_global_information.Player_Profession == GW2.CHARCLASS.Necromancer and ( self.skill.id == 10574 or self.skill.id == 30792 ))then
				timers = gw2_skill_manager.profile.tmp.swapTimers
				timers.lastSwap = timers.lastSwap + 1500
			end
		end
		
		self.tmp.lastCastTime = ml_global_information.Now
		return true
	end
	return false
end

-- predict pos.
function skillPrototype:Predict(target)
	if (table.valid(target)) then
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
-- **Update loop**
---------------------------------------------------------------------------------------------------------------------------------------------------------

function gw2_skill_manager.OnUpdate(ticks)
	gw2_skill_manager:UpdateProfileList()
	gw2_skill_manager:UpdateCurrentSkillbarSkills()
	gw2_skill_manager:DetectSkills()
	gw2_skill_manager:Use()
end





