gw2_skill_manager = {}
gw2_skill_manager.mainWindow = {name = GetString("skillManager"), x = 350, y = 50, w = 250, h = 350}
gw2minion.MainWindow.ChildWindows[gw2_skill_manager.mainWindow.name] = gw2_skill_manager.mainWindow.name
gw2_skill_manager.editWindow = {name = GetString("skillEditor"), x = 600, y = 50, w = 250, h = 550}
gw2minion.MainWindow.ChildWindows[gw2_skill_manager.editWindow.name] = gw2_skill_manager.editWindow.name
gw2_skill_manager.profile = nil
gw2_skill_manager.currentSkill = nil
gw2_skill_manager.path = GetStartupPath() .. [[\LuaMods\GW2Minion\SkillManagerProfiles\]]
gw2_skill_manager.detecting = false
gw2_skill_manager.RecordRefreshTmr = 0
gw2_skill_manager.attacking = false
gw2_skill_manager.lastAttack = 0
--setmetatable(gw2_skill_manager, {__call = function(cls,...) return cls.NewInstance(...) end})

function gw2_skill_manager.ModuleInit()
	-- Set Default Profile
	if (Settings.GW2Minion.gCurrentProfile == nil) then
		Settings.GW2Minion.gCurrentProfile = "None"
	end
	gw2_skill_manager.profile = gw2_skill_manager.NewInstance(Settings.GW2Minion.gCurrentProfile)
end

function gw2_skill_manager.NewInstance(profileName)
	if (GetGameState() == 16) then
		if (profileName == nil or profileName == "None") then return false end
		profileName = string.gsub(profileName,'%W','')
		profileName = table_invert(GW2.CHARCLASS)[Player.profession] .. "_" .. profileName
		local newProfile = (persistence.load(gw2_skill_manager.path .. profileName .. ".lua") or
							{
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
									lastSkillID		= "",
									delay			= 0,
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
				if (gw2_common_functions.BufflistHasBuffs(target.buffs,"762")) then
					ml_blacklist.AddBlacklistEntry(GetString("monsters"),target.contentID,target.name,ml_global_information.Now+90000)
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
					_private.Tmr = ml_global_information.Now
				elseif ( ml_global_information.Now - _private.Tmr > 20000 ) then
					_private.Tmr = ml_global_information.Now
					if (_private.lastHP ~= 0 and _private.lastHP <= target.health.current) then
						ml_blacklist.AddBlacklistEntry(GetString("monsters"), target.contentID, target.name, ml_global_information.Now + 90000)
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
							if ((aSkill.slot >= GW2.SKILLBARSLOT.Slot_1  and aSkill.slot <= GW2.SKILLBARSLOT.Slot_5) and
							(skill.target.maxRange > 0 and skill.target.maxRange > maxRange or skill.target.maxRange < 1 and skill.target.radius > maxRange)) then
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

					-- Last SkillID check
					if (skill.skill.lastSkillID ~= nil and skill.skill.lastSkillID ~= "" and tostring(skill.skill.lastSkillID) ~= Player.castinfo.lastSkillID) then return false end
					-- Delay check
					if (skill.skill.delay ~= nil and skill.skill.delay > 0 and (_private.skillLastCast[skill.id] == nil or skill.skill.delay < TimeSince(_private.skillLastCast[skill.id]))) then return false end

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
				if (skill.player.combatState == "OutCombat" and ml_global_information.Player_InCombat == true ) then return false end
				if (skill.player.minHP > 0 and ml_global_information.Player_Health.percent > skill.player.minHP) then return false end
				if (skill.player.maxHP > 0 and ml_global_information.Player_Health.percent < skill.player.maxHP) then return false end
				if (skill.player.minEndurance > 0 and ml_global_information.Player_Endurance > skill.player.minEndurance) then return false end
				if (skill.player.maxEndurance > 0 and ml_global_information.Player_Endurance < skill.player.maxEndurance) then return false end
				if (skill.player.hasBuffs ~= "" and playerBuffList and not gw2_common_functions.BufflistHasBuffs(playerBuffList, tostring(skill.player.hasBuffs))) then return false end
				if (skill.player.hasNotBuffs ~= "" and playerBuffList and gw2_common_functions.BufflistHasBuffs(playerBuffList, tostring(skill.player.hasNotBuffs))) then return false end
				if (skill.player.conditionCount > 0 and playerBuffList and gw2_common_functions.CountConditions(playerBuffList) <= skill.player.conditionCount) then return false end
				if (skill.player.boonCount > 0 and playerBuffList and gw2_common_functions.CountBoons(playerBuffList) <= skill.player.boonCount) then return false end

				-- Check Target related conditions
				if (target and skill.skill.target == "Enemy") then
					local targetBuffList = target.buffs
					if (skill.target.los == true and target.los == false) then return false end
					if (skill.target.minRange > 0 and target.distance < skill.target.minRange) then return false end
					if (skill.target.maxRange > 0 and target.distance > skill.target.maxRange) then return false end
					if (skill.target.minHP > 0 and ml_global_information.Player_Health.percent > skill.target.minHP) then return false end
					if (skill.target.maxHP > 0 and ml_global_information.Player_Health.percent < skill.target.maxHP) then return false end
					if (target.isCharacter) then
						if (skill.target.moving == "Yes" and target.movementstate == GW2.MOVEMENTSTATE.GroundNotMoving )then return false end
						if (skill.target.moving == "No" and target.movementstate == GW2.MOVEMENTSTATE.GroundMoving )then return false end
					end
					if (skill.target.hasBuffs ~= "" and targetBuffList and not gw2_common_functions.BufflistHasBuffs(targetBuffList, tostring(skill.target.hasBuffs))) then return false end
					if (skill.target.hasNotBuffs ~= "" and targetBuffList and gw2_common_functions.BufflistHasBuffs(targetBuffList, tostring(skill.target.hasNotBuffs))) then return false end
					if (skill.target.conditionCount > 0 and targetBuffList and gw2_common_functions.CountConditions(targetBuffList) <= skill.target.conditionCount) then return false end
					if (skill.target.boonCount > 0 and targetBuffList and gw2_common_functions.CountBoons(targetBuffList) <= skill.target.boonCount) then return false end
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
							switch = ((attunement[gSMPrioAtt1][1] ~= currentAttunement and not Player:IsSpellOnCooldown(attunement[gSMPrioAtt1][1]) and attunement[gSMPrioAtt1][1]) or
									(attunement[gSMPrioAtt2][1] ~= currentAttunement and not Player:IsSpellOnCooldown(attunement[gSMPrioAtt2][1]) and attunement[gSMPrioAtt2][1]) or
									(attunement[gSMPrioAtt3][1] ~= currentAttunement and not Player:IsSpellOnCooldown(attunement[gSMPrioAtt3]) and attunement[gSMPrioAtt3][1]) or
									(attunement[gSMPrioAtt4][1] ~= currentAttunement and not Player:IsSpellOnCooldown(attunement[gSMPrioAtt4][1]) and attunement[gSMPrioAtt4][1]))
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
					local availableKits = { [1] = { slot=0, skillID=0} }-- Leave Kit Placeholder
					for key=1,TableSize(availableSkills) do
						local skill = availableSkills[key]
						if (skill and EngineerKits[skill.skill.id]) then
							if (_private.lastKitTable[skill.slot] == nil or (ml_global_information.Now - _private.lastKitTable[skill.slot].lastused or 0) > 1500) then
								local kitcount = TableSize(availableKits)
								availableKits[kitcount+1] = {}
								availableKits[kitcount+1].slot = skill.slot
								availableKits[kitcount+1].skillID = skill.skill.id
							end
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
			if ( T and ml_global_information.Player_Health.percent < 98 and gDoCombatMovement ~= "0") then
				if ( gw2_common_functions.HasBuffs(Player, "791,727") ) then return false end
				local Tdist = T.distance
				local playerHP = ml_global_information.Player_Health.percent
				local movedir = ml_global_information.Player_MovementDirections
				local _,attackRange = _private:GetAvailableSkills()

				-- SET FACING TARGET
				Player:SetFacingExact(T.pos.x,T.pos.y,T.pos.z)

				-- EVADE
				if (ml_global_information.Player_Endurance >= 50 and ml_global_information.Player_Health.percent < 100) then
					-- Get target and check if casting.
					local target = Player:GetTarget()
					if (target) then
						local targetOfTarget = target.castinfo.targetID
						local skillofTarget = target.castinfo.skillID
						if (targetOfTarget == Player.id and skillofTarget ~= 0 and skillofTarget ~= _private.lastEvadedSkill) then
							_private.lastEvadedSkill = skillofTarget
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
						if (attackRange > 300) then
							-- RANGE
							if (Tdist < (attackRange / 2) and movedir.forward ) then -- we are too close and moving towards enemy
								Player:UnSetMovement(0)	-- stop moving forward
							elseif ( Tdist > attackRange and movedir.backward ) then -- we are too far away and moving backwards
								Player:UnSetMovement(1)	-- stop moving backward
							elseif (Tdist > attackRange and movedir.left) then -- we are strafing outside the maxrange
								Player:UnSetMovement(2) -- stop moving Left
							elseif (Tdist > attackRange and movedir.right) then -- we are strafing outside the maxrange
								Player:UnSetMovement(3) -- stop moving Right
							end
						else
							-- MELEE
							if ( Tdist < (T.radius + 5) and movedir.forward) then -- we are too close and moving towards enemy
								Player:UnSetMovement(0)	-- stop moving forward
							elseif (Tdist > attackRange and movedir.backward) then -- we are too far away and moving backwards
								Player:UnSetMovement(1)	-- stop moving backward
							elseif ((Tdist > attackRange + 50 or Tdist < 50) and movedir.left) then -- we are strafing outside the maxrange
								Player:UnSetMovement(2) -- stop moving Left
							elseif ((Tdist > attackRange + 50 or Tdist < 50) and movedir.right) then -- we are strafing outside the maxrange
								Player:UnSetMovement(3) -- stop moving Right
							end
						end
					end
				end

				--Set New Movement
				if ( Tdist ~= nil and ml_global_information.Now - _private.combatMoveTmr > 0 and Player:CanCast() and Player.onmesh and T.los and Player.inCombat and T.inCombat) then

					_private.combatMoveTmr = ml_global_information.Now + math.random(1000,2000)
					--tablecount:  1, 2, 3, 4, 5   --Table index starts at 1, not 0 
					local dirs = { 0, 1, 2, 3, 4 } --Forward = 0, Backward = 1, Left = 2, Right = 3, + stop

					if (attackRange > 300 ) then
						-- RANGE
						if (Tdist < attackRange ) then
							if (Tdist > (attackRange * 0.90)) then 
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
						if (Tdist < attackRange ) then
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
			end
			return false
		end


		--[[ public functions newProfile
				- public functions accessible on final object
				
				newProfile:Save() -> Saves current profile
				newProfile:Delete() -> Deletes current profile
				newProfile:Reload() -> Reload current profile
				newProfile:Heal() -> Heal self
				newProfile:Attack(target) -> ARG: target = entity, Attack target.
				newProfile:DetectSkills() -> Detect player skills
				newProfile:SkillList() -> Return table of skills and their details
		]]
		
		function newProfile:Save()
			local saveFile = {
				name = self.name,
				profession = self.profession,
				professionSettings = {
										priorityKit = self.professionSettings.priorityKit,
										PriorityAtt1 = self.professionSettings.PriorityAtt1,
										PriorityAtt2 = self.professionSettings.PriorityAtt2,
										PriorityAtt3 = self.professionSettings.PriorityAtt3,
										PriorityAtt4 = self.professionSettings.PriorityAtt4,
									},
				skills = {},
			}
			for priority=1,(TableSize(self.skills)-1) do
				saveFile.skills[priority] = self.skills[priority]
			end
			persistence.store(gw2_skill_manager.path .. self.name .. ".lua", saveFile)
			return true
		end

		function newProfile:Delete()
			os.remove(gw2_skill_manager.path .. self.name .. ".lua")
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
		_private.skillLastCast = {}
		function newProfile:Attack(target)
			if (_private:CheckTargetBuffs(target)) then
				local skills,maxRange = _private:GetAvailableSkills()
				
				if (target == nil or target.distance < maxRange) then
					if (_private.runIntoCombatRange == true) then
						_private.runIntoCombatRange = false
						Player:StopMovement()
					end
					_private:DoCombatMovement()
					
					if (Player.castinfo.duration == 0  ) then						
						if (ValidTable(skills)) then
							for priority=1,TableSize(skills) do
								local skill = skills[priority]
								if (_private:CanCast(skill,target) == true) then
									if (target) then
										Player:CastSpell(skill.slot, target.id)
									else
										Player:CastSpell(skill.slot)
									end
									_private.skillLastCast[skill.skill.id] = ml_global_information.Now
									if (_private:TargetLosingHealth(target)) then
										return false
									end
									return true
								end
							end
							_private:SwapWeapon()
						end
					end
				elseif (gMoveIntoCombatRange ~= "0") then
					if (maxRange < 300 and target.distance > maxRange) then _private:SwapWeapon() end
					gw2_common_functions.MoveOnlyStraightForward()
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

		function newProfile:GetMaxAttackRange()
			local _,maxRange = _private:GetAvailableSkills()
			return maxRange
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
end

function gw2_skill_manager.GetProfileList(NewProfile)
	local profession = Player.profession
	local list = "None"
	if (ValidString(NewProfile)) then list = list .. "," .. NewProfile end
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
	return list
end

function gw2_skill_manager.UpdateMainWindow(openGroup)
	local mainWindow = WindowManager:GetWindow(gw2_skill_manager.mainWindow.name)
	if (mainWindow) then
		gSMCurrentProfileName_listitems = gw2_skill_manager.GetProfileList()
		mainWindow:DeleteGroup(GetString("profileSkills"))
		mainWindow:DeleteGroup(GetString("ProfessionSettings"))
		if (gw2_skill_manager.profile) then
			if (Player) then
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
			end
			
			for key=1,#gw2_skill_manager.profile.skills do
				local skill = gw2_skill_manager.profile.skills[key]
				mainWindow:NewButton(skill.priority .. ":" .. skill.skill.name,skill.priority,GetString("profileSkills"))
				RegisterEventHandler(skill.priority,gw2_skill_manager.UpdateEditWindow)
			end
			if (openGroup) then mainWindow:UnFold(GetString("profileSkills")) end
		end
	end
end

function gw2_skill_manager.UpdateEditWindow(skill)
	local editWindow = WindowManager:GetWindow(gw2_skill_manager.editWindow.name)
	if (skill and editWindow and gw2_skill_manager.profile) then
		editWindow:Show()
		gw2_skill_manager.currentSkill = tonumber(skill)
		local lSkill = gw2_skill_manager.profile.skills[tonumber(skill)]
		-- Skill
		SklMgr_ID = lSkill.skill.id
		SklMgr_Name = lSkill.skill.name
		SklMgr_Target = lSkill.skill.target
		SklMgr_GrndTarget = tostring(lSkill.skill.groundTargeted)
		SklMgr_Healing = tostring(lSkill.skill.healing)
		SklMgr_LastSkillID = lSkill.skill.lastSkillID
		SklMgr_Delay = lSkill.skill.delay
		SklMgr_AllyCount = lSkill.skill.allyNearCount
		SklMgr_AllyRange = lSkill.skill.allyRangeMax
		SklMgr_EnemyCount = lSkill.skill.enemyNearCount
		SklMgr_EnemyRange = lSkill.skill.enemyRangeMax
		-- Player
		SklMgr_CombatState = lSkill.player.combatState
		SklMgr_PMinHP = lSkill.player.minHP
		SklMgr_PMaxHP = lSkill.player.maxHP
		SklMgr_MinPower = lSkill.player.minPower
		SklMgr_MaxPower = lSkill.player.maxPower
		SklMgr_MinEndurance = lSkill.player.minEndurance
		SklMgr_MaxEndurance = lSkill.player.maxEndurance
		SklMgr_PHasBuffs = lSkill.player.hasBuffs
		SklMgr_PHasNotBuffs = lSkill.player.hasNotBuffs
		SklMgr_PCondCount = lSkill.player.conditionCount
		SklMgr_PBoonCount = lSkill.player.boonCount
		-- Target
		SklMgr_LOS = tostring(lSkill.target.los)
		SklMgr_MinRange = lSkill.target.minRange
		SklMgr_MaxRange = lSkill.target.maxRange
		SklMgr_MaxRadius = lSkill.target.radius
		SklMgr_TMinHP = lSkill.target.minHP
		SklMgr_TMaxHP = lSkill.target.maxHP
		SklMgr_Moving = lSkill.target.moving
		SklMgr_THasBuffs = lSkill.target.hasBuffs
		SklMgr_THasNotBuffs = lSkill.target.hasNotBuffs
		SklMgr_TCondCount = lSkill.target.conditionCount
		SklMgr_TBoonCount = lSkill.target.boonCount
		SklMgr_Type = lSkill.target.type
	elseif (skill == nil and editWindow) then
		editWindow:Hide()
	end
end

function gw2_skill_manager.ToggleMenu()
	gw2_skill_manager.CreateWindows()
	local mainWindow = WindowManager:GetWindow(gw2_skill_manager.mainWindow.name)
	if (mainWindow) then
		if ( mainWindow.visible ) then
			mainWindow:Hide()
			local editWindow = WindowManager:GetWindow(gw2_skill_manager.editWindow.name)
			if ( editWindow ) then 
				editWindow:Hide()
			end
		else
			local wnd = WindowManager:GetWindow(gw2minion.MainWindow.Name)
			if ( wnd ) then
				mainWindow:SetPos(wnd.x+wnd.width,wnd.y)
				mainWindow:Show()
			end
			local editWindow = WindowManager:GetWindow(gw2_skill_manager.editWindow.name)
			if ( editWindow ) then 
				editWindow:SetPos(wnd.x+wnd.width+mainWindow.width,wnd.y)
			end
		end
	end
end

function gw2_skill_manager.CreateWindows()
	if (WindowManager:GetWindow(gw2_skill_manager.mainWindow.name) == nil) then
		-- Init Main Window
		local mainWindow = WindowManager:NewWindow(gw2_skill_manager.mainWindow.name,gw2_skill_manager.mainWindow.x,gw2_skill_manager.mainWindow.y,gw2_skill_manager.mainWindow.w,gw2_skill_manager.mainWindow.h,false)
		if (mainWindow) then
			-- Settings section
			mainWindow:NewComboBox(GetString("profile"),"gSMCurrentProfileName",GetString("settings"),"")
			gSMCurrentProfileName = Settings.GW2Minion.gCurrentProfile
			mainWindow:NewButton(GetString("newProfile"),"gSMNewProfile",GetString("settings"))
			RegisterEventHandler("gSMNewProfile",function() gw2_skill_manager.CreateDialog(GetString("newProfileName"),gw2_skill_manager.NewProfile) end)
			local bb = mainWindow:NewButton(GetString("autoDetectSkills"),"gSMDetectSkills")
			bb:SetToggleState(false)
			RegisterEventHandler("gSMDetectSkills",gw2_skill_manager.DetectSkills)
			-- Main window elements
			mainWindow:NewButton(GetString("saveProfile"),"gSMprofile")
			RegisterEventHandler("gSMprofile",gw2_skill_manager.SaveProfile)
			mainWindow:UnFold(GetString("settings"))
			
			mainWindow:Hide()
		end
	end
	
	if (WindowManager:GetWindow(gw2_skill_manager.editWindow.name) == nil) then
		-- Init Edit Window
		local editWindow = WindowManager:NewWindow(gw2_skill_manager.editWindow.name,gw2_skill_manager.editWindow.x,gw2_skill_manager.editWindow.y,gw2_skill_manager.editWindow.w,gw2_skill_manager.editWindow.h,true)
		if (editWindow) then
			-- Skill Section
			editWindow:NewNumeric(GetString("smSkillID"),"SklMgr_ID",GetString("Skill"))
			editWindow:NewField(GetString("name"),"SklMgr_Name",GetString("Skill"))
			editWindow:NewComboBox(GetString("targetType"),"SklMgr_Target",GetString("Skill"),"Either,Enemy,Player")
			editWindow:NewComboBox(GetString("isGroundTargeted"),"SklMgr_GrndTarget",GetString("Skill"),"true,false")
			editWindow:NewComboBox(GetString("smsktypeheal"),"SklMgr_Healing",GetString("Skill"),"true,false")
			editWindow:NewField(GetString("prevSkillID"),"SklMgr_LastSkillID",GetString("Skill"))
			editWindow:NewNumeric(GetString("smDelay"),"SklMgr_Delay",GetString("Skill"))
			editWindow:NewNumeric(GetString("alliesNearCount"),"SklMgr_AllyCount",GetString("Skill"))
			editWindow:NewNumeric(GetString("alliesNearRange"),"SklMgr_AllyRange",GetString("Skill"))
			editWindow:NewNumeric(GetString("enemiesNearCount"),"SklMgr_EnemyCount",GetString("Skill"))
			editWindow:NewNumeric(GetString("enemiesNearRange"),"SklMgr_EnemyRange",GetString("Skill"))
			-- Player Section
			editWindow:NewComboBox(GetString("useOutOfCombat"),"SklMgr_CombatState",GetString("Player"),"Either,InCombat,OutCombat")
			editWindow:NewNumeric(GetString("playerHPLT"),"SklMgr_PMinHP",GetString("Player"),0,100)
			editWindow:NewNumeric(GetString("playerHPGT"),"SklMgr_PMaxHP",GetString("Player"),0,99)
			editWindow:NewNumeric(GetString("playerPowerLT"),"SklMgr_MinPower",GetString("Player"),0,100)
			editWindow:NewNumeric(GetString("playerPowerGT"),"SklMgr_MaxPower",GetString("Player"),0,99)
			editWindow:NewNumeric(GetString("playerEnduranceLT"),"SklMgr_MinEndurance",GetString("Player"),0,100)
			editWindow:NewNumeric(GetString("playerEnduranceGT"),"SklMgr_MaxEndurance",GetString("Player"),0,99)
			editWindow:NewField(GetString("playerHas"),"SklMgr_PHasBuffs",GetString("Player"))
			editWindow:NewField(GetString("playerHasNot"),"SklMgr_PHasNotBuffs",GetString("Player"))
			editWindow:NewNumeric(GetString("orPlayerCond"),"SklMgr_PCondCount",GetString("Player"))
			editWindow:NewNumeric(GetString("smBoonCount"),"SklMgr_PBoonCount",GetString("Player"))
			-- Target Section
			editWindow:NewComboBox(GetString("los"),"SklMgr_LOS",GetString("targetType"),"true,false")
			editWindow:NewNumeric(GetString("minRange"),"SklMgr_MinRange",GetString("targetType"),0,5000)
			editWindow:NewNumeric(GetString("maxRange"),"SklMgr_MaxRange",GetString("targetType"),0,5000)
			editWindow:NewNumeric(GetString("smRadius"),"SklMgr_MaxRadius",GetString("targetType"),0,5000)
			editWindow:NewNumeric(GetString("playerHPLT"),"SklMgr_TMinHP",GetString("targetType"),0,100)
			editWindow:NewNumeric(GetString("playerHPGT"),"SklMgr_TMaxHP",GetString("targetType"),0,99)
			editWindow:NewComboBox(GetString("targetMoving"),"SklMgr_Moving",GetString("targetType"),"Either,Moving,NotMoving")
			editWindow:NewField(GetString("targetHas"),"SklMgr_THasBuffs",GetString("targetType"))
			editWindow:NewField(GetString("targetHasNot"),"SklMgr_THasNotBuffs",GetString("targetType"))
			editWindow:NewNumeric(GetString("smCondCount"),"SklMgr_TCondCount",GetString("targetType"))
			editWindow:NewNumeric(GetString("smBoonCount"),"SklMgr_TBoonCount",GetString("targetType"))
			editWindow:NewComboBox(GetString("targetType"),"SklMgr_Type",GetString("targetType"),"Either,Character,Gadget")
			-- Buttons
			editWindow:NewButton(GetString("smDeleteSkill"),"gSMdeleteSkill")
			RegisterEventHandler("gSMdeleteSkill",gw2_skill_manager.DeleteSkill)
			editWindow:NewButton(GetString("smPasteSkill"),"gSMpasteSkill")
			RegisterEventHandler("gSMpasteSkill",gw2_skill_manager.PasteSkill)
			editWindow:NewButton(GetString("smCopySkill"),"gSMcopySkill")
			RegisterEventHandler("gSMcopySkill",gw2_skill_manager.CopySkill)
			editWindow:NewButton(GetString("smCloneSkill"),"gSMcloneSkill")
			RegisterEventHandler("gSMcloneSkill",gw2_skill_manager.CloneSkill)
			editWindow:NewButton(GetString("smMoveDownSkill"),"gSMdownUpSkill")
			RegisterEventHandler("gSMdownUpSkill",gw2_skill_manager.MoveSkillDown)
			editWindow:NewButton(GetString("smMoveUpSkill"),"gSMmoveUpSkill")
			RegisterEventHandler("gSMmoveUpSkill",gw2_skill_manager.MoveSkillUp)
			
			editWindow:Hide()
		end
	end
	gw2_skill_manager.UpdateMainWindow()
end

function gw2_skill_manager.SaveProfile()
	if (gw2_skill_manager.profile) then
		gw2_skill_manager.profile:Save()
		gSMCurrentProfileName_listitems = gw2_skill_manager.GetProfileList()
		local name = gw2_skill_manager.profile.name
		name = string.sub(name,select(2,string.find(name,"_"))+1,#name)
		gSMCurrentProfileName = name
		Settings.GW2Minion.gCurrentProfile = gSMCurrentProfileName
	end
end

function gw2_skill_manager.NewProfile(profileName)
	gw2_skill_manager.profile = gw2_skill_manager.NewInstance(profileName)
	gw2_skill_manager.UpdateMainWindow()
	gw2_skill_manager.currentSkill = nil
	gw2_skill_manager.UpdateEditWindow()
	gSMCurrentProfileName_listitems = gw2_skill_manager.GetProfileList(profileName)
	gSMCurrentProfileName = profileName
	gw2_skill_manager.DetectSkills(true)
end

function gw2_skill_manager.DetectSkills(arg)
	local mw = WindowManager:GetWindow(gw2_skill_manager.mainWindow.name)
	if ( mw ) then 
		local sb = mw:GetControl(GetString("autoDetectSkills"))
		if ( sb ) then
			if (gw2_skill_manager.profile) then
				
				if ( arg == true ) then -- Create New Profile -> autorecord afterwards
					if ( sb.pressed ) then
						sb:SetToggleState(false)
					else
						sb:SetToggleState(true)
					end
				end
				if ( sb.pressed ) then
					d("Recording Skills..")
					gw2_skill_manager.detecting = true
					sb:SetText("Stop "..GetString("autoDetectSkills"))
				else
					d("Stopping Recording Skills..")
					gw2_skill_manager.detecting = false					
					sb:SetText(GetString("autoDetectSkills"))
				end				
				
			else
				d("You need to create a profile first")
				sb:SetToggleState(false)
				gw2_skill_manager.CreateDialog()
			end
		end
	end
end

function gw2_skill_manager.MoveSkillUp()
	gw2_skill_manager.profile.skills[gw2_skill_manager.currentSkill]:MoveUp()
	if (gw2_skill_manager.currentSkill > 1) then
		gw2_skill_manager.currentSkill = gw2_skill_manager.currentSkill - 1
		gw2_skill_manager.UpdateMainWindow(true)
	end
end

function gw2_skill_manager.MoveSkillDown()
	gw2_skill_manager.profile.skills[gw2_skill_manager.currentSkill]:MoveDown()
	if (gw2_skill_manager.currentSkill < (TableSize(gw2_skill_manager.profile.skills) - 1)) then
		gw2_skill_manager.currentSkill = gw2_skill_manager.currentSkill + 1
		gw2_skill_manager.UpdateMainWindow(true)
	end
end

function gw2_skill_manager.CloneSkill()
	gw2_skill_manager.profile.skills[gw2_skill_manager.currentSkill]:Clone()
	gw2_skill_manager.UpdateMainWindow(true)
end

function gw2_skill_manager.CopySkill()
	gw2_skill_manager.profile.skills[gw2_skill_manager.currentSkill]:Copy()
end

function gw2_skill_manager.PasteSkill()
	gw2_skill_manager.profile.skills[gw2_skill_manager.currentSkill]:Paste()
	gw2_skill_manager.UpdateEditWindow(gw2_skill_manager.currentSkill)
end

function gw2_skill_manager.DeleteSkill()
	gw2_skill_manager.profile.skills[gw2_skill_manager.currentSkill]:Delete()
	gw2_skill_manager.UpdateMainWindow(true)
	gw2_skill_manager.currentSkill = nil
	gw2_skill_manager.UpdateEditWindow()
end

function gw2_skill_manager.GUIVarUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		-- Changes in skills
		-- Skill change
		if (
				k == "SklMgr_Target" or
				k == "SklMgr_GrndTarget" or
				k == "SklMgr_Healing" or
				k == "SklMgr_LastSkillID" or
				k == "SklMgr_Delay" or
				k == "SklMgr_AllyCount" or
				k == "SklMgr_AllyRange" or
				k == "SklMgr_EnemyCount" or
				k == "SklMgr_EnemyRange")
			then
			local var = {	SklMgr_Target = "target",
							SklMgr_GrndTarget = "groundTargeted",
							SklMgr_Healing = "healing",
							SklMgr_LastSkillID = "lastSkillID",
							SklMgr_Delay = "delay",
							SklMgr_AllyCount = "allyNearCount",
							SklMgr_AllyRange = "allyRangeMax",
							SklMgr_EnemyCount = "enemyNearCount",
							SklMgr_EnemyRange = "enemyRangeMax",
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
				k == "SklMgr_LOS" or
				k == "SklMgr_MinRange" or
				k == "SklMgr_MaxRange" or
				k == "SklMgr_MaxRadius" or
				k == "SklMgr_TMinHP" or
				k == "SklMgr_TMaxHP" or
				k == "SklMgr_Moving" or
				k == "SklMgr_THasBuffs" or
				k == "SklMgr_THasNotBuffs" or
				k == "SklMgr_TCondCount" or
				k == "SklMgr_TBoonCount" or
				k == "SklMgr_Type")
			then
			local var = {	SklMgr_LOS = "los",
							SklMgr_MinRange = "minRange",
							SklMgr_MaxRange = "maxRange",
							SklMgr_MaxRadius = "radius",
							SklMgr_TMinHP = "minHP",
							SklMgr_TMaxHP = "maxHP",
							SklMgr_Moving = "moving",
							SklMgr_THasBuffs = "hasBuffs",
							SklMgr_THasNotBuffs = "hasNotBuffs",
							SklMgr_TCondCount = "conditionCount",
							SklMgr_TBoonCount = "boonCount",
							SklMgr_Type = "type",
			}
			if (v == "true") then v = true elseif (v == "false") then v = false end
			if (tonumber(v) ~= nil) then v = tonumber(v) end
			gw2_skill_manager.profile.skills[gw2_skill_manager.currentSkill].target[var[k]] = v
		elseif (k == "gSMCurrentProfileName") then
			gw2_skill_manager.profile = gw2_skill_manager.NewInstance(gSMCurrentProfileName)
			gw2_skill_manager.detecting = false
			gw2_skill_manager.UpdateMainWindow()
			gw2_skill_manager.currentSkill = nil
			gw2_skill_manager.UpdateEditWindow()
			Settings.GW2Minion.gCurrentProfile = gSMCurrentProfileName
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
		end
	end
end

function gw2_skill_manager.CreateDialog()
	
	local dialog = WindowManager:GetWindow(GetString("newProfileName"))
	local wSize = {w = 300, h = 100}
	if ( not dialog ) then
		dialog = WindowManager:NewWindow(GetString("newProfileName"),nil,nil,nil,nil,true)
		dialog:NewField(GetString("newProfileName"),"smdialogfieldString","Please Enter")
		dialog:UnFold("Please Enter")
		
		local bSize = {w = 60, h = 20}
		-- Cancel Button
		local cancel = dialog:NewButton("Cancel","CancelDialog")
		cancel:Dock(0)
		cancel:SetSize(bSize.w,bSize.h)
		cancel:SetPos(((wSize.w - 12) - bSize.w),40)
		RegisterEventHandler("CancelDialog", function() dialog:SetModal(false) dialog:Hide() end)
		-- OK Button
		local OK = dialog:NewButton("OK","OKDialog")
		OK:Dock(0)
		OK:SetSize(bSize.w,bSize.h)
		OK:SetPos(((wSize.w - 12) - (bSize.w * 2 + 10)),40)
		RegisterEventHandler("OKDialog", function() if (ValidString(smdialogfieldString) == false) then ml_error("Please enter " .. GetString("newProfileName") .. " first.") return false end dialog:SetModal(false) dialog:Hide() gw2_skill_manager.NewProfile(smdialogfieldString)  return true end)
	end
	
	dialog:SetSize(wSize.w,wSize.h)
	dialog:Dock(GW2.DOCK.Center)
	dialog:Focus()
	dialog:SetModal(true)	
	dialog:Show()
end

function gw2_skill_manager.GetMaxAttackRange()
	if ( gw2_skill_manager.profile ) then
		return gw2_skill_manager.profile:GetMaxAttackRange()
	else
		d("No gw2_skill_manager.profile loaded!")
		return 154
	end
end

function gw2_skill_manager.Attack(target)
	if ( gw2_skill_manager.profile ) then
		gw2_skill_manager.attacking = true
		gw2_skill_manager.lastAttack = ml_global_information.Lasttick
		gw2_skill_manager.profile:Attack(target)
	else
		d("No gw2_skill_manager.profile loaded!")
	end
end

function gw2_skill_manager.Heal()
	if ( gw2_skill_manager.profile ) then
		gw2_skill_manager.profile:Heal(target)
	else
		d("No gw2_skill_manager.profile loaded!")
	end
end

function gw2_skill_manager.OnUpdate(tickcount)
	if (gw2_skill_manager.detecting == true) then
		if (tickcount - gw2_skill_manager.RecordRefreshTmr > 500) then
			gw2_skill_manager.RecordRefreshTmr = tickcount
			gw2_skill_manager.UpdateMainWindow(true)
		end
		gw2_skill_manager.profile:DetectSkills()
	end
	if (gw2_skill_manager.attacking == true and TimeSince(gw2_skill_manager.lastAttack) > 500) then
		gw2_skill_manager.attacking = false
		gw2_common_functions.MoveOnlyStraightForward()
	end
end

RegisterEventHandler("Module.Initalize",gw2_skill_manager.ModuleInit)
RegisterEventHandler("GUI.Update",gw2_skill_manager.GUIVarUpdate)
