-- This file contains mesmer specific combat routines

-- The following values have to get set ALWAYS for ALL professions!!
wt_profession_mesmer  =  inheritsFrom( nil )
wt_profession_mesmer.professionID = 7 -- needs to be set
wt_profession_mesmer.professionRoutineName = "Mesmer"
wt_profession_mesmer.professionRoutineVersion = "1.0"
wt_profession_mesmer.switchweaponTmr = 0


------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Determine our weapons
function wt_profession_mesmer.GetMainHandWeapon(MainHand)
	-- A bit stoopid but failsafe way to always get the correct weapons
	--d(Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_1).skillID)
	if (MainHand ~= nil ) then
		if     (MainHand.skillID == 10352 ) then return ("Staff") 
		elseif (MainHand.skillID == 10219 ) then return ("GreatSword") 
		elseif (MainHand.skillID == 10170 ) then return ("Sword")
		elseif (MainHand.skillID == 10289 ) then return ("Scepter")	
		end
	end
	return "default"
end
-- Determine our weapon
function wt_profession_mesmer.GetOffHandWeapon(OffHand)
	if (OffHand ~= nil ) then
		if     (OffHand.skillID == 10331 ) then return ("Staff") 
		elseif (OffHand.skillID == 10221 ) then return ("GreatSword") 		
		elseif (OffHand.skillID == 10280 ) then return ("Sword")
		elseif (OffHand.skillID == 10175 ) then return ("Pistol")
		elseif (OffHand.skillID == 10186 ) then return ("Focus")		
		elseif (OffHand.skillID == 10285 ) then return ("Torch")
		end
	end
	return "default"
end
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Randomly switch Weaponset
function wt_profession_mesmer.SwitchWeapon(current)
	if (wt_profession_mesmer.switchweaponTmr == 0 or wt_global_information.Now - wt_profession_mesmer.switchweaponTmr > math.random(1500,5000)) then	
		wt_profession_mesmer.switchweaponTmr = wt_global_information.Now
		if ( gMesSwapWeapons == "1" and Player:CanSwapWeaponSet() ) then
			Player:SwapWeaponSet()
			return true
		end
	end
	return false 
end
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Combat Default Attack 
wt_profession_mesmer.c_attack_default = inheritsFrom(wt_cause)
wt_profession_mesmer.e_attack_default = inheritsFrom(wt_effect)

function wt_profession_mesmer.c_attack_default:evaluate()
	  return wt_core_state_combat.CurrentTarget ~= 0
end

wt_profession_mesmer.e_attack_default.usesAbility = true
function wt_profession_mesmer.e_attack_default:execute()
	TID = wt_core_state_combat.CurrentTarget
	if ( TID ~= 0 ) then
		local T = CharacterList:Get(TID)
		if ( T ~= nil ) then		
			--wt_debug("attacking " .. wt_core_state_combat.CurrentTarget .. " Distance " .. T.distance)
			local TPos = T.pos
			Player:SetFacing(TPos.x, TPos.y, TPos.z)
			local s1 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_1)
			local s2 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_2)
			local s3 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_3)
			local s4 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_4)
			local s5 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_5)
			--local F1 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_13)
			
			
			-- F1-F4 Skills -- TODO: Player:GetProfessionPowerPercentage() returns 100 at 0 clones, 66 at 1 clone, 33 at 2 clones and 0 at 3 clones
			--if ( gWarUseBurst == "1" and not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_13) and F1~=nil and Player:GetProfessionPowerPercentage() == 100 and (T.distance < F1.maxRange)) then
			--		Player:CastSpell(GW2.SKILLBARSLOT.Slot_13)
			--		return
			--end
			-- Skill 7,8,9,Elite
			if ( tonumber(gMesSK7) > 0 ) then
				local SK7 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_7)
				if ( SK7 ~= nil and not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_7) and Player.health.percent < randomize(tonumber(gMesSK7)) and (T.distance < SK7.maxRange or T.distance < 140 or SK7.maxRange < 100)) then
					Player:CastSpell(GW2.SKILLBARSLOT.Slot_7)
					return
				end
			end
			if ( tonumber(gMesSK8) > 0 ) then
				local SK8 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_8)
				if ( SK8 ~= nil and not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_8) and Player.health.percent < randomize(tonumber(gMesSK8)) and (T.distance < SK8.maxRange or T.distance < 140 or SK8.maxRange < 100)) then
					Player:CastSpell(GW2.SKILLBARSLOT.Slot_8)
					return
				end
			end
			if ( tonumber(gMesSK9) > 0 ) then
				local SK9 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_9)
				if ( SK9 ~= nil and not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_9) and Player.health.percent < randomize(tonumber(gMesSK9)) and (T.distance < SK9.maxRange or T.distance < 140 or SK9.maxRange < 100)) then
					Player:CastSpell(GW2.SKILLBARSLOT.Slot_9)
					return
				end
			end
			if ( tonumber(gMesSK10) > 0 ) then
				local SK10 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_10)
				if ( SK10 ~= nil and not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_10) and Player.health.percent < randomize(tonumber(gMesSK10)) and (T.distance < SK10.maxRange or T.distance < 140 or SK10.maxRange < 100)) then
					Player:CastSpell(GW2.SKILLBARSLOT.Slot_10)
					return
				end
			end
			
			-- Attack with weapon
			local myMHWeap = wt_profession_mesmer.GetMainHandWeapon(s1)
			local myOHWeap = wt_profession_mesmer.GetOffHandWeapon(s4)
						
			if ( myOHWeap == "Staff" ) then			
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_5) and s5~=nil and (T.distance < s5.maxRange) and T.movementstate ~= GW2.MOVEMENTSTATE.GroundMoving) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_5,TID) return
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_4) and s4~=nil and T.distance < 160) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_4,TID) return
					end
				end
			end
			if ( myOHWeap == "GreatSword") then				
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_5) and s5~=nil and T.distance < s5.maxRange and T.distance < 160) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_5,TID) return
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_4) and s4~=nil and T.distance < s4.maxRange) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_4,TID) return				
					end
				end	
			end					
			if ( myOHWeap == "Sword") then				
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_5) and s5~=nil and T.distance < s5.maxRange) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_5,TID) return
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_4) and s4~=nil and T.distance < 160) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_4,TID) return				
					end
				end
			end
			if ( myOHWeap == "Pistol") then				
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_5) and s5~=nil and T.distance < s5.maxRange) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_5,TID) return
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_4) and s4~=nil and T.distance < s4.maxRange) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_4,TID) return					
					end
				end
			end
			if ( myOHWeap == "Focus") then				
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_5) and s5~=nil and T.distance < s5.maxRange) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_5,TID) return
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_4) and s4~=nil and T.distance < s4.maxRange and T.distance > 260) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_4,TID) return					
					end
				end				
			end
			if ( myOHWeap == "Torch") then				
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_5) and s5~=nil and T.distance < s5.maxRange) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_5,TID) return
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_4) and s4~=nil and T.distance < 160 and T.inCombat) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_4,TID) return					
					end
				end						
			end
			------
			if ( myMHWeap == "Staff" ) then			
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_3) and s3~=nil and T.distance < s3.maxRange) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_3,TID) 
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_2) and s2~=nil and T.distance < 130) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_2,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_1) and s1~=nil and T.distance < s1.maxRange) then
						if (not wt_profession_mesmer.SwitchWeapon()) then
							Player:CastSpell(GW2.SKILLBARSLOT.Slot_1,TID)
						end
					end
				end
			elseif ( myMHWeap == "GreatSword") then				
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_3) and s3~=nil and T.distance < s3.maxRange) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_3,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_2) and s2~=nil and T.distance < s2.maxRange) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_2,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_1) and s1~=nil and T.distance < s1.maxRange) then
						if (not wt_profession_mesmer.SwitchWeapon()) then
							Player:CastSpell(GW2.SKILLBARSLOT.Slot_1,TID)
						end
					end
				end						
			elseif ( myMHWeap == "Sword") then				
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_3) and s3~=nil and T.distance < s3.maxRange) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_3,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_2) and s2~=nil and T.distance < s2.maxRange ) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_2,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_1) and s1~=nil and T.distance < s1.maxRange) then
						if (not wt_profession_mesmer.SwitchWeapon()) then
							Player:CastSpell(GW2.SKILLBARSLOT.Slot_1,TID)
						end
					end
				end
			elseif ( myMHWeap == "Scepter") then				
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_3) and s3~=nil and T.distance < s3.maxRange ) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_3,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_2) and s2~=nil and T.distance < 160 and T.inCombat) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_2,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_1) and s1~=nil and T.distance < s1.maxRange) then
						if (not wt_profession_mesmer.SwitchWeapon()) then
							Player:CastSpell(GW2.SKILLBARSLOT.Slot_1,TID)
						end
					end
				end
				
			
			else --DEFAULT ATTACK
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_5) and s5~=nil and (T.distance < s5.maxRange or s5.maxRange < 100)) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_5,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_4) and s4~=nil and (T.distance < s4.maxRange or s4.maxRange < 100)) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_4,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_3) and s3~=nil and (T.distance < s3.maxRange or s3.maxRange < 100)) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_3,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_2) and s2~=nil and (T.distance < s2.maxRange or s2.maxRange < 100)) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_2,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_1) and s1~=nil and (T.distance < s1.maxRange or s1.maxRange < 100)) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_1,TID)
					end
				end
			end	
		end
	end
end


-----------------------------------------------------------------------------------
-- Registration and setup of GUI and causes and effects to the different states for this profession
-----------------------------------------------------------------------------------
function wt_profession_mesmer.GUIVarUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		if ( k == "gMesSwapWeapons" or k == "gWarUseBurst" or k == "gMesSK7" or k == "gMesSK8" or k == "gMesSK9" or k == "gMesSK10") then
			Settings.GW2MINION[tostring(k)] = v
		end
	end
end

function wt_profession_mesmer:HandleInit() 	
	if ( Player.profession ~= nil and Player.profession == wt_profession_mesmer.professionID ) then
		wt_debug("Initalizing profession routine for Mesmer")
				
		-- GUI Elements
		if ( Settings.GW2MINION.gMesSwapWeapons == nil ) then
			Settings.GW2MINION.gMesSwapWeapons = "0"
		end
		--if ( Settings.GW2MINION.gWarUseBurst == nil ) then
		--	Settings.GW2MINION.gWarUseBurst = "0"
		--end
		if ( Settings.GW2MINION.gMesSK7 == nil ) then
			Settings.GW2MINION.gMesSK7 = "0"
		end
		if ( Settings.GW2MINION.gMesSK8 == nil ) then
			Settings.GW2MINION.gMesSK8 = "0"
		end
		if ( Settings.GW2MINION.gMesSK9 == nil ) then
			Settings.GW2MINION.gMesSK9 = "0"
		end
		if ( Settings.GW2MINION.gMesSK10 == nil ) then
			Settings.GW2MINION.gMesSK10 = "0"
		end
		
		GUI_NewCheckbox(wt_global_information.MainWindow.Name,"AutoSwapWeaponSets","gMesSwapWeapons","Mesmer-Settings");
		--GUI_NewCheckbox(wt_global_information.MainWindow.Name,"AutoUse F1","gWarUseBurst","Mesmer-Settings");
		GUI_NewLabel(wt_global_information.MainWindow.Name,"Allowed Range [0-100], 0=Disabled","Mesmer-Settings");
		GUI_NewField(wt_global_information.MainWindow.Name,"Use Skill7 at HP%","gMesSK7","Mesmer-Settings");
		GUI_NewField(wt_global_information.MainWindow.Name,"Use Skill8 at HP%","gMesSK8","Mesmer-Settings");
		GUI_NewField(wt_global_information.MainWindow.Name,"Use Skill9 at HP%","gMesSK9","Mesmer-Settings");
		GUI_NewField(wt_global_information.MainWindow.Name,"Use Elite  at HP%","gMesSK10","Mesmer-Settings");
		
		
		gMesSwapWeapons = Settings.GW2MINION.gMesSwapWeapons
		--gWarUseBurst = Settings.GW2MINION.gWarUseBurst
		gMesSK7 = Settings.GW2MINION.gMesSK7
		gMesSK8 = Settings.GW2MINION.gMesSK8
		gMesSK9 = Settings.GW2MINION.gMesSK9
		gMesSK10 = Settings.GW2MINION.gMesSK10
				
					
		-- Our C & E´s for Warrior combat:
		-- Default Causes & Effects that are already in the wt_core_state_combat for all classes:
		-- Death Check 				- Priority 10000   --> Can change state to wt_core_state_dead.lua
		-- Combat Over Check 		- Priority 500      --> Can change state to wt_core_state_idle.lua		
			
		local ke_Attack_default = wt_kelement:create("Attack",wt_profession_mesmer.c_attack_default,wt_profession_mesmer.e_attack_default, 45 )
		wt_core_state_combat:add(ke_Attack_default)
			

		-- We need to set the Currentprofession to our profession , so that other parts of the framework can use it.
		wt_global_information.Currentprofession = wt_profession_mesmer
		wt_global_information.AttackRange = 130
	end
	
end

RegisterEventHandler("Module.Initalize",wt_profession_mesmer.HandleInit)
RegisterEventHandler("GUI.Update",wt_profession_mesmer.GUIVarUpdate)
















