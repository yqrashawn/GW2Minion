-- Load routine only if player is a Thief

-- The following values have to get set ALWAYS for ALL professions!!
wt_profession_thief  =  inheritsFrom( nil )
wt_profession_thief.professionID = 5 -- needs to be set
wt_profession_thief.professionRoutineName = "Thief"
wt_profession_thief.professionRoutineVersion = "1.0"
wt_profession_thief.switchweaponTmr = 0


------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Determine our weapons
function wt_profession_thief.GetMainHandWeapon(MainHand)
	-- A bit stoopid but failsafe way to always get the correct weapons
	--d(Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_1).contentID )
	if (MainHand ~= nil ) then		
		if (MainHand.contentID == 229038 ) then return ("Shortbow")
		elseif (MainHand.contentID == 41909 or MainHand.contentID == 174541 or MainHand.contentID == 220922) then return ("Dagger")
		elseif (MainHand.contentID == 41922 or MainHand.contentID == 174588 or MainHand.contentID == 232644) then return ("Sword") 
		elseif (MainHand.contentID == 37262 ) then return ("Pistol")		
		end
	end
	return "default"
end
-- Determine our weapon
function wt_profession_thief.GetOffHandWeapon(OffHand)
--d(Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_4).contentID )
	if (OffHand ~= nil ) then
		if     (OffHand.contentID == 39085 ) then return ("Shortbow") 
		elseif (OffHand.contentID == 177987 ) then return ("Dagger")
		elseif (OffHand.contentID == 93089 ) then return ("Pistol")
		end
	end
	return "default"
end
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Randomly switch Weaponset
function wt_profession_thief.SwitchWeapon()
	if (wt_profession_thief.switchweaponTmr == 0 or wt_global_information.Now - wt_profession_thief.switchweaponTmr > math.random(1500,4000)) then
		wt_profession_thief.switchweaponTmr = wt_global_information.Now
		if ( gThiefSwapWeapons == "1" and Player:CanSwapWeaponSet() ) then
			Player:SwapWeaponSet()
			return true
		end
	end
	return false 
end

------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Combat Default Attack 
wt_profession_thief.c_attack_default = inheritsFrom(wt_cause)
wt_profession_thief.e_attack_default = inheritsFrom(wt_effect)

function wt_profession_thief.c_attack_default:evaluate()
	  return wt_core_state_combat.CurrentTarget ~= 0
end

wt_profession_thief.e_attack_default.usesAbility = true
function wt_profession_thief.e_attack_default:execute()	
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
						
						
			-- Skill 7,8,9,Elite
			if ( tonumber(gThiefSK7) > 0 ) then
				local SK7 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_7)
				if ( SK7 ~= nil and not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_7) and Player.health.percent < randomize(tonumber(gThiefSK7)) and (T.distance < SK7.maxRange or T.distance < 140 or SK7.maxRange < 100)) then
					Player:CastSpell(GW2.SKILLBARSLOT.Slot_7)
					return
				end
			end
			if ( tonumber(gThiefSK8) > 0 ) then
				local SK8 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_8)
				if ( SK8 ~= nil and not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_8) and Player.health.percent < randomize(tonumber(gThiefSK8)) and (T.distance < SK8.maxRange or T.distance < 140 or SK8.maxRange < 100)) then
					Player:CastSpell(GW2.SKILLBARSLOT.Slot_8)
					return
				end
			end
			if ( tonumber(gThiefSK9) > 0 ) then
				local SK9 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_9)
				if ( SK9 ~= nil and not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_9) and Player.health.percent < randomize(tonumber(gThiefSK9)) and (T.distance < SK9.maxRange or T.distance < 140 or SK9.maxRange < 100)) then
					Player:CastSpell(GW2.SKILLBARSLOT.Slot_9)
					return
				end
			end
			if ( tonumber(gThiefSK10) > 0 ) then
				local SK10 = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_10)
				if ( SK10 ~= nil and not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_10) and Player.health.percent < randomize(tonumber(gThiefSK10)) and (T.distance < SK10.maxRange or T.distance < 140 or SK10.maxRange < 100)) then
					Player:CastSpell(GW2.SKILLBARSLOT.Slot_10)
					return
				end
			end
						
			
			-- Weapons
			local myMHWeap = wt_profession_thief.GetMainHandWeapon(s1)
			local myOHWeap = wt_profession_thief.GetOffHandWeapon(s4)
			local init = Player:GetProfessionPowerPercentage()
			
			if ( myOHWeap == "Shortbow" ) then			
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_5) and s5~=nil and T.distance < s5.maxRange and init >60 ) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_5,TID) return
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_4) and s4~=nil and T.distance < s4.maxRange and init >40) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_4,TID) return
					end
				end			
			elseif ( myOHWeap == "Dagger") then				
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_5) and s5~=nil and T.distance < s5.maxRange and init >60) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_5,TID) return
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_4) and s4~=nil and T.distance < s4.maxRange and init >40) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_4,TID) return				
					end
				end								
			elseif ( myOHWeap == "Pistol") then				
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_5) and s5~=nil and T.distance < s5.maxRange and init >60) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_5,TID) return
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_4) and s4~=nil and T.distance < s4.maxRange  and init >40) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_4,TID) return					
					end
				end	
			end
			
			------
			if ( myMHWeap == "Shortbow" ) then			
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_3) and s3~=nil and T.distance < s3.maxRange and init >40) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_3,TID) 
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_2) and s2~=nil and T.distance < s2.maxRange and init >30) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_2,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_1) and s1~=nil and T.distance < s1.maxRange) then
						if (not wt_profession_thief.SwitchWeapon()) then
							Player:CastSpell(GW2.SKILLBARSLOT.Slot_1,TID)
						end
					end
				end
			elseif ( myMHWeap == "Dagger") then	
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_3) and s3~=nil and T.distance < s3.maxRange  and init >50) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_3,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_2) and s2~=nil and T.distance < s2.maxRange and init >30) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_2,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_1) and s1~=nil and T.distance < s1.maxRange) then
						if (not wt_profession_thief.SwitchWeapon()) then
							Player:CastSpell(GW2.SKILLBARSLOT.Slot_1,TID)
						end
					end
				end			
			elseif ( myMHWeap == "Pistol") then				
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_3) and s3~=nil and T.distance < s3.maxRange  and init >50 ) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_3,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_2) and s2~=nil and T.distance < s2.maxRange and init > 30) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_2,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_1) and s1~=nil and T.distance < s1.maxRange) then
						if (not wt_profession_thief.SwitchWeapon()) then
							Player:CastSpell(GW2.SKILLBARSLOT.Slot_1,TID)
						end
					end
				end	
			elseif ( myMHWeap == "Sword") then				
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_3) and s3~=nil and T.distance < s3.maxRange  and init >50 ) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_3,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_2) and s2~=nil and T.distance < s2.maxRange and init > 30) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_2,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_1) and s1~=nil and T.distance < s1.maxRange) then
						if (not wt_profession_thief.SwitchWeapon()) then
							Player:CastSpell(GW2.SKILLBARSLOT.Slot_1,TID)
						end
					end
				end			
							
			
			else --DEFAULT ATTACK
				if (s1 ~= nil) then
					wt_global_information.AttackRange = s1.maxRange
					if (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_5) and s5~=nil and (T.distance < s5.maxRange or s5.maxRange < 100)and init >60) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_5,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_4) and s4~=nil and (T.distance < s4.maxRange or s4.maxRange < 100)and init >40) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_4,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_3) and s3~=nil and (T.distance < s3.maxRange or s3.maxRange < 100)and init >50) then
						Player:CastSpell(GW2.SKILLBARSLOT.Slot_3,TID)
					elseif (not Player:IsSpellOnCooldown(GW2.SKILLBARSLOT.Slot_2) and s2~=nil and (T.distance < s2.maxRange or s2.maxRange < 100)and init >30) then
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
function wt_profession_thief.GUIVarUpdate(Event, NewVals, OldVals)
	for k,v in pairs(NewVals) do
		if ( k == "gThiefSwapWeapons" or k == "gThiefSK7" or k == "gThiefSK8" or k == "gThiefSK9" or k == "gThiefSK10") then
			Settings.GW2MINION[tostring(k)] = v
		end
	end
end

function wt_profession_thief:HandleInit() 	
	if ( wt_profession_thief.professionID == Player.profession) then
		wt_debug("Initalizing profession routine for Thief")
		
		-- GUI Elements
		if ( Settings.GW2MINION.gThiefSwapWeapons == nil ) then
			Settings.GW2MINION.gThiefSwapWeapons = "1"
		end		
		if ( Settings.GW2MINION.gThiefSK7 == nil ) then
			Settings.GW2MINION.gThiefSK7 = "80"
		end
		if ( Settings.GW2MINION.gThiefSK8 == nil ) then
			Settings.GW2MINION.gThiefSK8 = "80"
		end
		if ( Settings.GW2MINION.gThiefSK9 == nil ) then
			Settings.GW2MINION.gThiefSK9 = "80"
		end
		if ( Settings.GW2MINION.gThiefSK10 == nil ) then
			Settings.GW2MINION.gThiefSK10 = "75"
		end
		
		GUI_NewCheckbox(wt_global_information.MainWindow.Name,"AutoSwapWeaponSets","gThiefSwapWeapons","Thief-Settings");
		GUI_NewLabel(wt_global_information.MainWindow.Name,"Allowed Range [0-100], 0=Disabled","Thief-Settings");
		GUI_NewField(wt_global_information.MainWindow.Name,"Use Skill7 at HP%","gThiefSK7","Thief-Settings");
		GUI_NewField(wt_global_information.MainWindow.Name,"Use Skill8 at HP%","gThiefSK8","Thief-Settings");
		GUI_NewField(wt_global_information.MainWindow.Name,"Use Skill9 at HP%","gThiefSK9","Thief-Settings");
		GUI_NewField(wt_global_information.MainWindow.Name,"Use Elite  at HP%","gThiefSK10","Thief-Settings");
		GUI_NewSeperator(wt_global_information.MainWindow.Name);
		
		
		gThiefSwapWeapons = Settings.GW2MINION.gThiefSwapWeapons
		gThiefSK7 = Settings.GW2MINION.gThiefSK7
		gThiefSK8 = Settings.GW2MINION.gThiefSK8
		gThiefSK9 = Settings.GW2MINION.gThiefSK9
		gThiefSK10 = Settings.GW2MINION.gThiefSK10
		
					
		-- Our C & E´s for Warrior combat:
		-- Default Causes & Effects that are already in the wt_core_state_combat for all classes:
		-- Death Check 				- Priority 10000   --> Can change state to wt_core_state_dead.lua
		-- Combat Over Check 		- Priority 500      --> Can change state to wt_core_state_idle.lua		
			
		local ke_Attack_default = wt_kelement:create("Attack",wt_profession_thief.c_attack_default,wt_profession_thief.e_attack_default, 45 )
		wt_core_state_combat:add(ke_Attack_default)
			

		-- We need to set the Currentprofession to our profession , so that other parts of the framework can use it.
		wt_global_information.Currentprofession = wt_profession_thief
		wt_global_information.AttackRange = 120
	end
end

RegisterEventHandler("Module.Initalize",wt_profession_thief.HandleInit)
RegisterEventHandler("GUI.Update",wt_profession_thief.GUIVarUpdate)













