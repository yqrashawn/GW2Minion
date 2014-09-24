gw2_skill_manager = {}
gw2_skill_manager.mainWindow = { name = GetString("skillManager"), x = 350, y = 50, w = 250, h = 350}
gw2_skill_manager.editWindow = { name = GetString("skillEditor"), w = 250, h = 550}
gw2_skill_manager.profile = nil
gw2_skill_manager.path = GetStartupPath() .. [[\LuaMods\GW2Minion\SkillManagerProfiles\]]
--setmetatable(gw2_skill_manager, {__call = function(cls,...) return cls.NewInstance(...) end})

function gw2_skill_manager.ModuleInit()
	-- Init Main Window
	local mainWindow = WindowManager:NewWindow(gw2_skill_manager.mainWindow.name,gw2_skill_manager.mainWindow.x,gw2_skill_manager.mainWindow.y,gw2_skill_manager.mainWindow.w,gw2_skill_manager.mainWindow.h,true)
	if (mainWindow) then
		mainWindow:NewCheckBox(GetString("active"),"gSMActive",GetString("generalSettings"))
		mainWindow:NewComboBox(GetString("profile"),"gCurrentProfileName",GetString("generalSettings"),gw2_skill_manager.GetProfileList())
		gCurrentProfileName = "None"
		
		mainWindow:NewField(GetString("newProfileName"),"gSMNewName",GetString("AdvancedSettings"))
		mainWindow:NewButton(GetString("newProfile"),"gSMNewName",GetString("AdvancedSettings"))
		
		mainWindow:NewButton(GetString("saveProfile"),"gSMprofile")
		
	end
	
	-- Init Edit Window
	local editWindow = WindowManager:NewWindow(gw2_skill_manager.editWindow.name,gw2_skill_manager.editWindow.x,gw2_skill_manager.editWindow.y,gw2_skill_manager.editWindow.w,gw2_skill_manager.editWindow.h,false)
	
	-- Set Default Profile
	--[[if (Settings.GW2Minion.gCurrentProfile) then
		gw2_skill_manager.profile = gw2_skill_manager.NewInstance(Settings.GW2Minion.gCurrentProfile)
		gw2_skill_manager.UpdateUI()
	end]]
	gw2_skill_manager.profile = gw2_skill_manager.NewInstance("testprofile")
	gw2_skill_manager.UpdateUI()
	
end

function gw2_skill_manager.NewInstance(profileName)
	profileName = table_invert(GW2.CHARCLASS)[Player.profession] .. "_" .. profileName
	local newProfile = (persistence.load(gw2_skill_manager.path .. profileName .. ".lua") or
						{
							name = profileName,
							path = gw2_skill_manager.path .. profileName .. ".lua",
							profession = Player.profession,
							skills = {},
							clipboard = nil,
						}
					)
	
	-- create place-holder for prototype skill
	newProfile.skills.prototype = {}
	
	
	--[[ private functions newProfile
			- not accessible on final object, private.
			
			_private:AddSkill(skill)-> skill = valid skill object
			_private:RemoveSkill(skill) -> skill = valid skill object
			_private:InsertSkill(skill) -> skill = valid skill object
			_private:CorrectSkillPriority() -> NO ARG
			_private:CreateSkill(skillSlot) -> skillSlot = number of the skill on the skillbar
			_private:MoveSkill(skill,direction) -> skill = valid skill object, direction = "up" for higher priority or "down" for lower priority
			_private:GetAvailableSkills(heal) -> heal = boolean, true returns only skills that heal.
			_private:CanCast(skill,target) -> skill = valid skill object, target = optional target object.
	]]
	
	local _private = {}
	function _private:AddSkill(skill)
		if (skill) then
			local priority = skill.priority
			if (priority) then
				newProfile.skills[priority] = skill
				setmetatable(newProfile.skills[priority], newProfile.skills.prototype)
				return true
			end
		end
		return false
	end

	function _private:RemoveSkill(skill)
		if (skill) then
			local priority = skill.priority
			if (priority) then
				table.remove(newProfile.skills, priority)
				_private:CorrectSkillPriority()
				return true
			end
		end
		return false
	end

	function _private:InsertSkill(skill)
		if (skill) then
			local priority = skill.priority
			if (priority) then
				table.insert(newProfile.skills, priority, skill)
				_private:CorrectSkillPriority()
				return true
			end
		end
		return false
	end

	function _private:CorrectSkillPriority()
		for priority=1,(TableSize(newProfile.skills)-1) do
			newProfile.skills[priority].priority = priority
			setmetatable(newProfile.skills[priority], newProfile.skills.prototype)
		end
		return true
	end

	function _private:CreateSkill(skillSlot)
		if (skillSlot) then
			local skillInfo = Player:GetSpellInfo(GW2.SKILLBARSLOT["Slot_" .. skillSlot])
			if (skillInfo) then

				for key,skill in pairs(newProfile.skills) do
					if (key and skill and skill.skill) then
						if (skill.skill.name == skillInfo.name) then
							if (skill.skill.id ~= skillInfo.skillID) then
								local updatedSkill = deepcopy(skill)
								updatedSkill.skill.id = skillInfo.skillID
								_private:AddSkill(updatedSkill)
								return true
							end
							return false
						end
						if (skill.skill.id == skillInfo.skillID) then
							if (skill.skill.name ~= skillInfo.name) then
								local updatedSkill = deepcopy(skill)
								updatedSkill.skill.name = skillInfo.name
								_private:AddSkill(updatedSkill)
								return true
							end
							return false
						end
					end
				end

				skill = {
					priority = TableSize(newProfile.skills),
					skill = {
								id				= skillInfo.skillID,
								name			= skillInfo.name,
								target			= "Enemy",
								groundTargeted	= skillInfo.isGroundTargeted or false,
								healing			= false,
								allyNearCount	= 0,
								allyRangeMax	= 0,
								enemyNearCount	= 0,
								enemyRangeMax	= 0,
					},
					player = {
								combatState		= "Either",
								minHP			= 0,
								maxHP			= 0,
								minPower		= 0,
								maxPower		= 0,
								minEndurance	= 0,
								maxEndurance	= 0,
								hasBuffs		= "",
								hasNotBuffs		= "",
								conditionCount	= 0,
								boonCount		= 0,
								
					},
					target = {
								los				= true,
								minRange		= skillInfo.minRange or 0,
								maxRange		= skillInfo.maxRange or 0,
								radius			= skillInfo.radius or 0,
								minHP			= 0,
								maxHP			= 0,
								moving			= "Either",
								hasBuffs		= "",
								hasNotBuffs		= "",
								conditionCount	= 0,
								boonCount		= 0,
								type			= "Either",
					},
				}
				_private:AddSkill(skill)
				return true
			end
		end
		return false
	end

	function _private:MoveSkill(skill,direction)
		local priority = skill.priority
		if (newProfile.skills[priority] and direction) then
			local skillToNewLocation = nil
			local skillToOldLocation = nil
			local newPriority = (direction == "up" and priority ~= 1 and priority - 1 or direction == "down" and priority ~= TableSize(newProfile.skills) and priority + 1)
			if (newProfile.skills[newPriority]) then
				skillToNewLocation = newProfile.skills[priority]
				skillToNewLocation.priority = newPriority
				skillToOldLocation = newProfile.skills[newPriority]
				skillToOldLocation.priority = priority
				_private:AddSkill(skillToNewLocation)
				_private:AddSkill(skillToOldLocation)
				return true
			end
		end
		return false
	end

	function _private:CheckTargetBuffs(target)
		if (target) then
			if (mc_helper.BufflistHasBuffs(target.buffs,"762")) then
				mc_blacklist.AddBlacklistEntry(GetString("monsters"),target.contentID,target.name,ml_global_information.Now+90000)
				Player:ClearTarget()
				return false
			end
			return true
		end
	end

	_private.lastID = 0
	_private.lastHP = 0
	_private.Tmr = 0
	function _private:TargetLosingHealth(target)
		if (target) then
			if ( _private.lastID ~= target.id ) then
				_private.lastID = target.id
				_private.lastHP = target.health.current
				_private.Tmr = mc_global.now
			elseif ( mc_global.now - _private.Tmr > 20000 ) then
				_private.Tmr = mc_global.now
				if (_private.lastHP ~= 0 and _private.lastHP <= target.health.current) then
					mc_blacklist.AddBlacklistEntry(GetString("monsters"), target.contentID, target.name, ml_global_information.Now + 90000)
					Player:ClearTarget()
					return false
				else
					_private.lastHP = target.health.current
				end
			end
			return true
		end
	end

	function _private:GetAvailableSkills(heal)
		heal = heal or false
		local activeSkillList = {}
		local returnSkillList = {}
		for i = 1, 16, 1 do
			local skill = Player:GetSpellInfo(GW2.SKILLBARSLOT["Slot_" .. i])
			if ( skill ~= nil ) then
				activeSkillList[skill.skillID] = skill
			end
		end
		local newPriority = 1
		local maxRange = 154
		if ( ValidTable(newProfile.skills) and TableSize(activeSkillList) ) then
			for priority=1,TableSize(newProfile.skills)-1 do
				local skill = newProfile.skills[priority]
				for _,aSkill in pairs(activeSkillList) do
					if (aSkill.skillID == skill.skill.id and aSkill.cooldown == 0 and (heal == false or skill.skill.healing == true) ) then
						returnSkillList[newPriority] = skill
						returnSkillList[newPriority].slot = aSkill.slot
						newPriority = newPriority + 1
						if (aSkill.slot >= GW2.SKILLBARSLOT.Slot_1  and aSkill.slot <= GW2.SKILLBARSLOT.Slot_5 and skill.target.maxRange > maxRange) then
							maxRange = skill.target.maxRange
						end
						break
					end
				end
			end
		end
		return (ValidTable(returnSkillList) and returnSkillList or false),maxRange
	end

	function _private:CanCast(skill,target)
		if (skill) then
			-- Check Skill related conditions
			if (target or skill.skill.target == "Self") then
				local entityToCheck = (target or Player)
				-- Friends around Target check
				if ( skill.skill.allyNearCount > 0 and skill.skill.allyRangeMax > 0) then
					if (TableSize(CharacterList("friendly,maxdistance=" .. skill.skill.allyRangeMax .. ",distanceto=" .. entityToCheck.id)) < skill.skill.allyNearCount) then return false end
				end
				-- Enemies around Target check
				if ( skill.skill.enemyNearCount > 0 and skill.skill.enemyRangeMax > 0) then
					if (TableSize(CharacterList("alive,attackable,maxdistance=" .. skill.skill.enemyRangeMax .. ",distanceto=" .. entityToCheck.id)) < skill.skill.enemyNearCount) then return false end
				end
			end
			
			-- Check Player related conditions
			local playerBuffList = Player.buffs
			if (skill.player.combatState == "InCombat" and ml_global_information.Player_InCombat == false ) then return false end
			if (skill.player.combatState == "OutsideCombat" and ml_global_information.Player_InCombat == true ) then return false end
			if (skill.player.minHP > 0 and Player_Health.percent > skill.player.minHP) then return false end
			if (skill.player.maxHP > 0 and Player_Health.percent < skill.player.maxHP) then return false end
			if (skill.player.minEndurance > 0 and ml_global_information.Player_Endurance > skill.player.minEndurance) then return false end
			if (skill.player.maxEndurance > 0 and ml_global_information.Player_Endurance < skill.player.maxEndurance) then return false end
			if (skill.player.hasBuffs ~= "" and playerBuffList and not mc_helper.BufflistHasBuffs(playerBuffList, skill.player.hasBuffs)) then return false end
			if (skill.player.hasNotBuffs ~= "" and playerBuffList and mc_helper.BufflistHasBuffs(playerBuffList, skill.player.hasNotBuffs)) then return false end
			if (skill.player.conditionCount > 0 and playerBuffList and mc_helper.CountConditions(playerBuffList) <= skill.player.conditionCount) then return false end
			if (skill.player.boonCount > 0 and playerBuffList and mc_helper.CountBoons(playerBuffList) <= skill.player.boonCount) then return false end
			
			-- Check Target related conditions
			if (target and skill.skill.target == "Enemy") then
				local targetBuffList = target.buffs
				if (skill.target.los == true and target.los == false) then return false end
				if (skill.target.minRange > 0 and target.distance < skill.target.minRange) then return false end
				if (skill.target.maxRange > 0 and target.distance > skill.target.maxRange) then return false end
				if (skill.target.minHP > 0 and Player_Health.percent > skill.target.minHP) then return false end
				if (skill.target.maxHP > 0 and Player_Health.percent < skill.target.maxHP) then return false end
				if (target.isCharacter) then
					if (skill.target.moving == "Yes" and target.movementstate == GW2.MOVEMENTSTATE.GroundNotMoving )then return false end
					if (skill.target.moving == "No" and target.movementstate == GW2.MOVEMENTSTATE.GroundMoving )then return false end
				end
				if (skill.target.hasBuffs ~= "" and targetBuffList and not mc_helper.BufflistHasBuffs(targetBuffList, skill.target.hasBuffs)) then return false end
				if (skill.target.hasNotBuffs ~= "" and targetBuffList and mc_helper.BufflistHasBuffs(targetBuffList, skill.target.hasNotBuffs)) then return false end
				if (skill.target.conditionCount > 0 and targetBuffList and mc_helper.CountConditions(targetBuffList) <= skill.target.conditionCount) then return false end
				if (skill.target.boonCount > 0 and targetBuffList and mc_helper.CountBoons(targetBuffList) <= skill.target.boonCount) then return false end
				if (skill.target.type == "Character" and target.isCharacter == false) then return false end
				if (skill.target.type == "Gadget" and target.isGadget == false) then return false end
			elseif (skill.skill.target == "Enemy") then
				return false
			end

			return true
		end
		return false
	end

	_private.SwapTmr = 0
	_private.lastKitTable = {}
	function _private:SwapWeapon()
		if (ml_global_information.Now - _private.SwapTmr > 750) then
			if (Player.profession == GW2.CHARCLASS.Elementalist) then 
				local switch
				local skill = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_1)
				if ( skill ~= nil ) then
					local sID = skill.skillID
					local attunement = {
						["Fire"] = {[1] = 12, [5491] = 12, [15718] = 12, [5508] = 12,},
						["Water"] = {[1] = 13, [5549] = 13, [15716] = 13, [5693] = 13,},
						["Air"] = {[1] = 14, [5518] = 14, [5489] = 14, [5526] = 14,},
						["Earth"] = {[1] = 15, [5519] = 15, [15717] = 15, [5500] = 15,},
					}
					local currentAttunement = (attunement["Fire"][sID] or attunement["Water"][sID] or attunement["Air"][sID] or attunement["Earth"][sID])
					if (currentAttunement) then
						switch = ((attunement[gSMPrioAtt][1] ~= currentAttunement and not Player:IsSpellOnCooldown(attunement[gSMPrioAtt][1]) and attunement[gSMPrioAtt][1]) or
								(attunement[gSMPrioAtt2][1] ~= currentAttunement and not Player:IsSpellOnCooldown(attunement[gSMPrioAtt][1]) and attunement[gSMPrioAtt2][1]) or
								(attunement[gSMPrioAtt3][1] ~= currentAttunement and not Player:IsSpellOnCooldown(attunement[gSMPrioAtt][1]) and attunement[gSMPrioAtt3][1]) or
								(attunement[gSMPrioAtt4][1] ~= currentAttunement and not Player:IsSpellOnCooldown(attunement[gSMPrioAtt][1]) and attunement[gSMPrioAtt4][1]))
					end
					if (switch) then
						Player:CastSpell(switch)
						_private.SwapTmr = ml_global_information.Now
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
				local availableSkills = _private:GetAvailableSkills()
				local availableKits = { [0] = 0 }
				for key=1,TableSize(availableSkills)-1 do
					local skill = availableSkills[key]
					if (skill and EngineerKits[skill.skill.id]) then
						if (_private.lastKitTable[skill.slot] == nil or (ml_global_information.Now - _private.lastKitTable[skill.slot].lastused or 0) > 1500) then
							availableKits[TableSize(availableKits)].slot = skill.slot
							availableKits[TableSize(availableKits)].skillID = skill.skill.id
						end
					end
				end
				local key = math.random(0,TableSize(availableKits))
				if (key ~= 0) then
					Player:CastSpell(availableKits[key].slot)
					if (gSMPrioKit ~= "None" and EngineerKits[availableKits[key].skillID] ~= tostring(gSMPrioKit))then
						_private.lastKitTable[availableKits[key].slot] = { lastused = ml_global_information.Now + 15000 }
					else
						_private.lastKitTable[availableKits[key].slot] = { lastused = ml_global_information.Now }
					end
				elseif (Player:CanSwapWeaponSet()) then
					Player:SwapWeaponSet()
					_private.SwapTmr = ml_global_information.Now
				end
			elseif (Player:CanSwapWeaponSet()) then
				Player:SwapWeaponSet()
				_private.SwapTmr = ml_global_information.Now
			end
		end
	end

	_private.combatMoveTmr = 0
	_private.lastEvadedSkill = 0
	function _private:DoCombatMovement()
		local T = Player:GetTarget()
		if ( T and Player.health.percent < 98 ) then
			if ( mc_helper.HasBuffs(Player, "791,727") ) then return false end
			local Tdist = T.distance
			local playerHP = Player.health.percent
			local movedir = Player:GetMovement()

			-- EVADE
			if (Player.endurance >= 50 and Player.health.percent < 100) then
				-- Get target and check if casting.
				local target = Player:GetTarget()
				if (target) then
					local castinfo = target.castinfo
					if (castinfo and castinfo.targetID == Player.id and castinfo.skillID ~= 0 and castinfo.skillID ~= _private.lastEvadedSkill) then
						_private.lastEvadedSkill = target.castinfo.SkillID
						Player:SetFacingExact(target.pos.x,target.pos.y,target.pos.z)
						local direction = {[1]=1,[2]=2,[3]=0,[4]=6,[5]=7}
						local dir = math.random(1,TableSize(direction))
						if (Player:CanEvade(direction[dir],100)) then
							Player:Evade(direction[dir])
						end
					end
				end
			end

			--CONTROL CURRENT COMBAT MOVEMENT
			if ( Player:IsMoving() ) then

				if ( not Player.onmeshexact and (movedir.backward or movedir.left or movedir.right) ) then
					d("We ran outside the NavMesh!")
					Player:UnSetMovement(1)
					Player:UnSetMovement(2)
					Player:UnSetMovement(3)
					local pPos = Player.pos
					if (pPos) then
						local mPos = NavigationManager:GetClosestPointOnMesh(pPos)
						if ( mPos ) then
							--d("Moving back onto the NavMesh..")
							Player:MoveTo(mPos.x,mPos.y,mPos.z,50,false,false,false)
						end
					end
					return
				end

				if (tonumber(Tdist) ~= nil) then
					if (ml_global_information.AttackRange > 300) then
						-- RANGE
						if (Tdist < (ml_global_information.AttackRange / 2) and movedir.forward ) then -- we are too close and moving towards enemy
							Player:UnSetMovement(0)	-- stop moving forward
						elseif ( Tdist > ml_global_information.AttackRange and movedir.backward ) then -- we are too far away and moving backwards
							Player:UnSetMovement(1)	-- stop moving backward
						elseif (Tdist > ml_global_information.AttackRange and (movedir.left or movedir.right)) then -- we are strafing outside the maxrange
							if ( movedir.left ) then
								Player:UnSetMovement(2) -- stop moving Left
							elseif( movedir.right) then
								Player:UnSetMovement(3) -- stop moving Right
							end
						end
					else
						-- MELEE
						if ( Tdist < 85 and movedir.forward) then -- we are too close and moving towards enemy
							Player:UnSetMovement(0)	-- stop moving forward
						elseif (Tdist > ml_global_information.AttackRange and movedir.backward) then -- we are too far away and moving backwards
							Player:UnSetMovement(1)	-- stop moving backward
						elseif ((Tdist > ml_global_information.AttackRange + 50 or Tdist < 50) and (movedir.left or movedir.right)) then -- we are strafing outside the maxrange
							if ( movedir.left ) then
								Player:UnSetMovement(2) -- stop moving Left
							elseif( movedir.right) then
								Player:UnSetMovement(3) -- stop moving Right
							end
						end
					end
				end
			end

			--Set New Movement
			--d("PRECHECK "..tostring(Tdist ~= nil) .." Timer"..tostring(mc_global.now - _private.combatMoveTmr > 0) .."  cancast: "..tostring(Player:CanCast()).."  oOM: "..tostring(Player.onmesh).." Tlos: "..tostring(T.los) .."  Icom: "..tostring(Player.inCombat and T.inCombat))
			if ( Tdist ~= nil and mc_global.now - _private.combatMoveTmr > 0 and Player:CanCast() and Player.onmesh and T.los and Player.inCombat and T.inCombat) then

				_private.combatMoveTmr = mc_global.now + math.random(1000,2000)
				--tablecount:  1, 2, 3, 4, 5   --Table index starts at 1, not 0 
				local dirs = { 0, 1, 2, 3, 4 } --Forward = 0, Backward = 1, Left = 2, Right = 3, + stop

				if (ml_global_information.AttackRange > 300 ) then
					-- RANGE
					if (Tdist < ml_global_information.AttackRange ) then
						if (Tdist > (ml_global_information.AttackRange * 0.90)) then 
							table.remove(dirs,2) -- We are too far away to walk backward
						end
						if (Tdist < 600) then 
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
					if (Tdist < ml_global_information.AttackRange ) then
						if (Tdist > 200) then 
							table.remove(dirs,2) -- We are too far away to walk backwards
						end
						if (Tdist < 100) then 
							table.remove(dirs,1) -- We are too close to walk forwards
						end
						if (movedir.left ) then 
							--table.remove(dirs,4) -- We are moving left, so don't try to go right
						end
						if (movedir.right ) then
							--table.remove(dirs,3) -- We are moving right, so don't try to go left
						end
					end
				end
				-- Forward = 0, Backward = 1, Left = 2, Right = 3, + stop
				-- F = 3, B = 0, L = 6, R = 7, LF = 4, RF = 5, LB = 1, RB = 2
				if (Player:CanMoveDirection(3,400) == false or Player:CanMoveDirection(4,350) == false or Player:CanMoveDirection(5,350) == false) then 
					Player:UnSetMovement(0)
					table.remove(dirs,1)
				end
				if (Player:CanMoveDirection(0,400) == false or Player:CanMoveDirection(1,350) == false or Player:CanMoveDirection(2,350) == false) then 
					Player:UnSetMovement(1)
					table.remove(dirs,2)
				end
				if (Player:CanMoveDirection(6,400) == false or Player:CanMoveDirection(4,350) == false or Player:CanMoveDirection(1,350) == false) then 
					Player:UnSetMovement(2)
					table.remove(dirs,3)
				end
				if (Player:CanMoveDirection(7,400) == false or Player:CanMoveDirection(5,350) == false or Player:CanMoveDirection(2,350) == false) then 
					Player:UnSetMovement(3)
					table.remove(dirs,4)
				end

				-- MOVE
				local dir = dirs[ math.random( #dirs ) ]
				if (dir ~= 4) then
					Player:SetMovement(dir)
				else 
					Player:StopMovement()
				end
			end
		else
			Player:StopMovement()
		end
		return false
	end


	--[[ public functions newProfile
			- public functions accessible on final object
			
			newProfile:Save() -> Saves current profile
			newProfile:Delete() -> Deletes current profile
			newProfile:Reload() -> Reload current profile
			newProfile:Heal() -> Heal self
			newProfile:Attack(target) -> ARG: target entity. Attack target
			newProfile:DetectSkills() -> Detect player skills
			newProfile:SkillList() -> Return table of skills and their details
	]]
	
	function newProfile:Save()
		local saveFile = {
			name = self.name,
			path = self.path,
			profession = self.profession,
			skills = {},
		}
		for priority=1,(TableSize(self.skills)-1) do
			saveFile.skills[priority] = self.skills[priority]
		end
		persistence.store(self.path, saveFile)
		return true
	end

	function newProfile:Delete()
		os.remove(self.path)
		self = nil
		return true
	end

	function newProfile:Reload()
		self = gw2_skill_manager(self.name,true)
		return true
	end

	function newProfile:Heal()
		if (Player.castinfo.duration == 0) then
			local skills = _private:GetAvailableSkills(true)
			for priority=1,TableSize(skills) do
				local skill = skills[priority]
				if (_private:CanCast(skill) == true) then
					Player:CastSpell(skill.slot)
					return true
				end
			end
		end
		return false
	end

	_private.runIntoCombatRange = false
	function newProfile:Attack(target)
		if (target and _private:CheckTargetBuffs(target)) then
			_private:DoCombatMovement()
			local skills,maxRange = _private:GetAvailableSkills()
			if (target.distance < maxRange) then
				if (_private.runIntoCombatRange == true) then
					_private.runIntoCombatRange = false
					Player:StopMovement()
				end
				if (Player.castinfo.duration == 0) then
					if (ValidTable(skills)) then
						for priority=1,TableSize(skills) do
							local skill = skills[priority]
							if (_private:CanCast(skill,target) == true) then
								if (target) then
									Player:CastSpell(skill.slot, target.id)
								else
									Player:CastSpell(skill.slot)
								end
								if (_private:TargetLosingHealth(target)) then
									return false
								end
								return true
							end
						end
						_private:SwapWeapon()
					end
				end
			else
				if (maxRange < 300 and target.distance > maxRange) then _private:SwapWeapon() end
				MoveOnlyStraightForward()
				local tPos = target.pos
				Player:MoveTo(tPos.x,tPos.y,tPos.z,50 + target.radius,false,false,true)
				_private.runIntoCombatRange = true
			end
		end
		return false
	end

	function newProfile:DetectSkills()
		for slot=1,16 do
			_private:CreateSkill(slot)
		end
		return true
	end

	function newProfile:SkillList()
		return self.skills
	end


	--[[ skill functions prototype skill
			-- prototype skill functions, accessible on each skill
			
			newProfile.skills[key]MoveUp()
			newProfile.skills[key]MoveDown()
			newProfile.skills[key]Clone()
			newProfile.skills[key]Copy()
			newProfile.skills[key]Paste()
			newProfile.skills[key]Delete()
	]]

	function newProfile.skills.prototype:MoveUp()
		return _private:MoveSkill(self,"up")
	end

	function newProfile.skills.prototype:MoveDown()
		return _private:MoveSkill(self,"down")
	end

	function newProfile.skills.prototype:Clone()
		local clone = deepcopy(self)
		return _private:InsertSkill(clone)
	end

	function newProfile.skills.prototype:Copy()
		newProfile.clipboard = deepcopy(self)
		newProfile.clipboard.priority = nil
		newProfile.clipboard.skill.id = nil
		newProfile.clipboard.skill.name = nil
		return true
	end

	function newProfile.skills.prototype:Paste()
		if (newProfile.clipboard) then
			local newSkill = deepcopy(newProfile.clipboard)
			newSkill.priority = self.priority
			newSkill.skill.id = self.skill.id
			newSkill.skill.name = self.skill.name
			return _private:AddSkill(newSkill)
		end
		return false
	end

	function newProfile.skills.prototype:Delete()
		return _private:RemoveSkill(self)
	end


	newProfile.skills.prototype.__index = newProfile.skills.prototype
	-- set metatable for skills
	if (ValidTable(newProfile.skills)) then
		for priority=1,(TableSize(newProfile.skills)-1) do
			if (newProfile.skills[priority].combo == nil) then
				setmetatable(newProfile.skills[priority], newProfile.skills.prototype)
			else 
				
			end
		end
	end

	return newProfile
end

function gw2_skill_manager.GetProfileList()
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
					list = list .. "," .. name
				end
			end
		end
	end
	return list
end

function gw2_skill_manager.UpdateUI()
	local mainWindow = WindowManager:GetWindow(gw2_skill_manager.mainWindow.name)
	if (mainWindow) then
		local box = mainWindow:GetControl(GetString("profile"),GetString("generalSettings"))
		if (box) then
			box:Clear()
			for profile in StringSplit(gw2_skill_manager.GetProfileList(),",") do
				d(profile)
				box:Add(profile)
			end
		end
		mainWindow:DeleteGroup(GetString("profileSkills"))
		if (gw2_skill_manager.profile) then
			for key=1,#gw2_skill_manager.profile.skills do
				local skill = gw2_skill_manager.profile.skills[key]
				mainWindow:NewButton(skill.priority .. ":" .. skill.skill.name,skill.priority,GetString("profileSkills"))
				
			end
		end
	end
end

RegisterEventHandler("Module.Initalize",gw2_skill_manager.ModuleInit)
