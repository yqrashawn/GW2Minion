mc_ai_combat = {}
mc_ai_combat.combatMoveTmr = 0
mc_ai_combat.combatEvadeTmr = 0
mc_ai_combat.combatEvadeLastHP = 0

-- Attack Task
mc_ai_combatAttack = inheritsFrom(ml_task)
mc_ai_combatAttack.name = "CombatAttack"
function mc_ai_combatAttack.Create()
    --ml_log("combatAttack:Create")
	local newinst = inheritsFrom(mc_ai_combatAttack)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {} 
	newinst.duration = mc_global.now + math.random(60000,240000)
	
    return newinst
end
function mc_ai_combatAttack:Init()
   -- ml_log("combatAttack_Init->")
	
	-- Dead?
	self:add(ml_element:create( "Dead", c_dead, e_dead, 225 ), self.process_elements)
	
	-- Downed
	self:add(ml_element:create( "Downed", c_downed, e_downed, 200 ), self.process_elements)
	
	-- AoELooting Characters
	self:add(ml_element:create( "AoELoot", c_AoELoot, e_AoELoot, 175 ), self.process_elements)
		
	-- AoELooting Gadgets/Chests needed ?
	
	
	-- Revive PartyMember
	
		
	-- Aggro
	self:add(ml_element:create( "Aggro", c_Aggro, e_Aggro, 160 ), self.process_elements) --reactive queue
		
	-- Normal Chests	
	self:add(ml_element:create( "LootingChest", c_LootChest, e_LootChest, 155 ), self.process_elements)
	
	-- Resting
	self:add(ml_element:create( "Resting", c_resting, e_resting, 145 ), self.process_elements)	

	-- Normal Looting
	self:add(ml_element:create( "Looting", c_Loot, e_Loot, 130 ), self.process_elements)

	-- Deposit Items
	self:add(ml_element:create( "DepositingItems", c_deposit, e_deposit, 120 ), self.process_elements)	
	
	-- Re-Equip Gathering Tools
	self:add(ml_element:create( "EquippingGatherTool", c_GatherToolsCheck, e_GatherToolsCheck, 110 ), self.process_elements)	
	
	-- Quick-Repair & Vendoring (when a vendor is nearby)	
	self:add(ml_element:create( "QuickVendoring", c_quickvendor, e_quickvendor, 100 ), self.process_elements)
	
	-- Repair & Vendoring
	self:add(ml_element:create( "Vendoring", c_vendor, e_vendor, 90 ), self.process_elements)	
		
	-- Salvaging
	self:add(ml_element:create( "Salvaging", c_salvage, e_salvage, 75 ), self.process_elements)

	-- ReviveNPCs
	self:add(ml_element:create( "ReviveNPC", c_reviveNPC, e_reviveNPC, 70 ), self.process_elements)	
	
	-- Gathering
	self:add(ml_element:create( "Gathering", c_Gathering, e_Gathering, 65 ), self.process_elements)
			
	-- Killsomething nearby					
	-- Valid Target
	self:add(ml_element:create( "SearchingTarget", c_NeedValidTarget, e_SearchTarget, 50 ), self.process_elements)
		
	-- Get into Combat Range
	self:add(ml_element:create( "MovingIntoCombatRange", c_MoveIntoCombatRange, e_MoveIntoCombatRange, 25 ), self.process_elements)
	
	-- Kill Target
	self:add(ml_element:create( "KillTarget", c_KillTarget, e_KillTarget, 10 ), self.process_elements)
		
	
    self:AddTaskCheckCEs()
end
function mc_ai_grind:task_complete_eval()	
	if ( mc_global.now - newinst.duration > 0 or TableSize(CharacterList("attackable,alive,nearest,onmesh,maxdistance=4000,exclude_contentid="..mc_blacklist.GetExcludeString(mc_getstring("monsters")))) == 0) then 
		Player:StopMovement()
		return true
	end
	return false
end
function mc_ai_grind:task_complete_execute()
   self.completed = true
end


------------
c_Aggro = inheritsFrom( ml_cause )
e_Aggro = inheritsFrom( ml_effect )
function c_Aggro:evaluate()
   -- ml_log("c_Aggro")
    return TableSize(CharacterList("nearest,alive,aggro,attackable,maxdistance=1200,onmesh")) > 0
end
function e_Aggro:execute()
	ml_log("e_Aggro ")
	local newTask = mc_ai_combatDefend.Create()
	ml_task_hub:Add(newTask.Create(), REACTIVE_GOAL, TP_ASAP)
end



e_SearchTarget = inheritsFrom( ml_effect )
function e_SearchTarget:execute()
	ml_log("e_SearchTarget")
	-- Weakest Aggro in CombatRange first	
	local TList = ( CharacterList("lowesthealth,attackable,alive,aggro,nearest,onmesh,maxdistance="..mc_global.AttackRange) )
	if ( TableSize( TList ) > 0 ) then
		local id, E  = next( TList )
		if ( id ~= nil and id ~= 0 and E ~= nil ) then
			--d("Found Aggro Target: "..(E.name).." ID:"..tostring(id))
			return ml_log(Player:SetTarget(id))			
		end		
	end
	
	-- Then nearest attackable Target
	TList = ( CharacterList("attackable,alive,nearest,onmesh,maxdistance=3500,exclude_contentid="..mc_blacklist.GetExcludeString(mc_getstring("monsters"))))
	if ( TableSize( TList ) > 0 ) then
		local id, E  = next( TList )
		if ( id ~= nil and id ~= 0 and E ~= nil ) then
			--d("New Target: "..(E.name).." ID:"..tostring(id))			
			return ml_log(Player:SetTarget(id))
		end		
	end
	return ml_log(false)
end






-- Defend Against Aggro Task
mc_ai_combatDefend = inheritsFrom(ml_task)
mc_ai_combatDefend.name = "CombatDefend"
function mc_ai_combatDefend.Create()    
	local newinst = inheritsFrom(mc_ai_combatDefend)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {} 
	
    return newinst
end
function mc_ai_combatDefend:Init()
    ml_log("combatDef:Init->")
    
    -- Dead?
	self:add(ml_element:create( "Dead", c_dead, e_dead, 225 ), self.process_elements)
	
	-- Downed
	self:add(ml_element:create( "Downed", c_downed, e_downed, 200 ), self.process_elements)
	
	-- AoELooting Characters
	self:add(ml_element:create( "AoELoot", c_AoELoot, e_AoELoot, 125 ), self.process_elements)
		
	-- AoELooting Gadgets/Chests needed
    
	-- Deposit Items
	self:add(ml_element:create( "DepositingItems", c_deposit, e_deposit, 90 ), self.process_elements)	
		
	-- Valid Target
	self:add(ml_element:create( "NeedValidTarget", c_NeedValidTarget, e_SetAggroTarget, 75 ), self.process_elements)
		
	-- Get into Combat Range
	self:add(ml_element:create( "MovingIntoCombatRange", c_MoveIntoCombatRange, e_MoveIntoCombatRange, 50 ), self.process_elements)
	
	-- Kill Target
	self:add(ml_element:create( "MovingIntoCombatRange", c_KillTarget, e_KillTarget, 25 ), self.process_elements)
		
  
    self:AddTaskCheckCEs()
end
function mc_ai_combatDefend:task_complete_eval()
	--ml_log("combatDefend:Complete?->")
	if ( TableSize(CharacterList("nearest,alive,aggro,attackable,maxdistance=1200,onmesh"))== 0) then 
		Player:StopMovement()
		return true
	end
	return false
end

function mc_ai_combatDefend:task_complete_execute()
   self.completed = true
end


c_NeedValidTarget = inheritsFrom( ml_cause )
e_SetAggroTarget = inheritsFrom( ml_effect )
function c_NeedValidTarget:evaluate()
   -- ml_log("c_NeedValidTarget")
	local target = Player:GetTarget()
	if ( TableSize( target ) > 0 ) then	
		--d("NeedValidTarget "..tostring(not target.alive and not target.attackable and not target.onmesh))
		return (not target.alive or not target.attackable or not target.onmesh)
	end	
	return true
end
function e_SetAggroTarget:execute()
	ml_log("e_SetAggroTarget")
	-- lowesthealth in CombatRange first	
	local TList = ( CharacterList("lowesthealth,attackable,alive,aggro,onmesh,maxdistance="..mc_global.AttackRange) )
	if ( TableSize( TList ) > 0 ) then
		local id, E  = next( TList )
		if ( id ~= nil and id ~= 0 and E ~= nil ) then
			d("New Aggro Target: "..tostring(E.name).." ID:"..tostring(id))
			Player:SetTarget(id)
			return ml_log(true)	
		end		
	end
	
	-- Then nearest Aggro Target
	TList = ( CharacterList("attackable,alive,aggro,nearest,onmesh") )
	if ( TableSize( TList ) > 0 ) then
		local id, E  = next( TList )
		if ( id ~= nil and id ~= 0 and E ~= nil ) then
			d("New Aggro Target: "..tostring(E.name).." ID:"..tostring(id))
			Player:SetTarget(id)
			return ml_log(true)	
		end		
	end
	return ml_log(false)
end

c_MoveIntoCombatRange = inheritsFrom( ml_cause )
e_MoveIntoCombatRange = inheritsFrom( ml_effect )
c_MoveIntoCombatRange.running = false
function c_MoveIntoCombatRange:evaluate()
    --ml_log("c_MoveIntoCombRng")
    local t = Player:GetTarget()
	if ( t ) then	
		if (t.distance >= mc_global.AttackRange or not t.los) then
			return true
		else
			if ( c_MoveIntoCombatRange.running ) then 
				c_MoveIntoCombatRange.running = false
				Player:StopMovement()
			end
		end
	end
	return false
end
function e_MoveIntoCombatRange:execute()
	ml_log("e_MoveIntoCombRng")
	local t = Player:GetTarget()
	if ( t ) then	
		if ( t.distance >= mc_global.AttackRange or not t.los)then
			local tPos = t.pos
			-- moveto(x,y,z,stoppingdistance,navsystem(normal/follow),navpath(straight/random),smoothturns)		
			if ( tPos ) then
				--d("MoveIntoCombatRange..Running")
				local navResult = tostring(Player:MoveTo(tPos.x,tPos.y,tPos.z,100+t.radius,false,false,true))		
				if (tonumber(navResult) < 0) then
					ml_error("mc_ai_combat.MoveIntoCombatRange result: "..tonumber(navResult))					
				end
				c_MoveIntoCombatRange.running = true
				return true
			end
		end
	end	
	return ml_log(false)
end


c_KillTarget = inheritsFrom( ml_cause )
e_KillTarget = inheritsFrom( ml_effect )
function c_KillTarget()
	return true
end
function e_KillTarget:execute()
	ml_log("e_KillTarget")
	local t = Player:GetTarget()
	if ( t ) then
		local pos = t.pos
		if ( pos ) then
			Player:SetFacing(pos.x,pos.y,pos.z)
			mc_skillmanager.AttackTarget( t.id )
			
			DoCombatMovement()
			
			return ml_log(true)
		end
	else
		Player:StopMovement()		 
	end	
	return ml_log(false)
end


c_resting = inheritsFrom( ml_cause )
e_resting = inheritsFrom( ml_effect )
c_resting.hpPercent = math.random(45,85)
function c_resting:evaluate()
	if ( not Player.inCombat and Player.health.percent < c_resting.hpPercent ) then		
		local mybuffs = Player.buffs
		return not mc_helper.BufflistHasBuffs(mybuffs, "737,723,736") --burning,poison,bleeding		
	end	
	return false
end
function e_resting:execute()
	ml_log("e_resting")
	c_resting.hpPercent = math.random(45,85)
	if (Player.profession == 8 ) then -- Necro, leave shroud
		local deathshroud = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_13)
		if ( deathshroud ~= nil and deathshroud.skillID == 10585 and Player:CanCast() and Player:GetCurrentlyCastedSpell() == 17) then
			Player:CastSpell(GW2.SKILLBARSLOT.Slot_13)
			mc_global.Wait(500)
			return
		end
	end
	
	-- check Skillmanager if he can heal first
	if not mc_skillmanager.HealMe() then
	
		-- else cast our normal heal skill if possible
		local s6 = Player:GetSpellInfo( GW2.SKILLBARSLOT.Slot_6 )
		if( s6 and Player:GetCurrentlyCastedSpell() == 17 and s6.cooldown == 0 ) then
			Player:CastSpell( GW2.SKILLBARSLOT.Slot_6 )
			mc_global.Wait(750)
		end		
	end
	return
end

------------
c_reviveNPC = inheritsFrom( ml_cause )
e_reviveNPC = inheritsFrom( ml_effect )
function c_reviveNPC:evaluate()
   -- ml_log("c_reviveNPC")
    return (not Player.inCombat and TableSize(CharacterList("nearest,selectable,interactable,dead,friendly,npc,onmesh")) > 0)
end
function e_reviveNPC:execute()
	ml_log("e_reviveNPC")
	local CharList = CharacterList("shortestpath,selectable,interactable,dead,friendly,npc,onmesh")
	if ( TableSize(CharList) > 0 ) then
		local id,entity = next (CharList)
		if ( id and entity ) then
			
			if (not entity.isInInteractRange) then
				-- MoveIntoInteractRange
				local tPos = entity.pos
				if ( tPos ) then
					local navResult = tostring(Player:MoveTo(tPos.x,tPos.y,tPos.z,50,false,true,true))		
					if (tonumber(navResult) < 0) then
						ml_error("e_reviveNPC.MoveIntoCombatRange result: "..tonumber(navResult))					
					end
					ml_log("MoveToReviveNPC..")
					return true
				end
			else
				-- Grab that thing
				Player:StopMovement()
				local t = Player:GetTarget()
				if ( not t or t.id ~= id ) then
					Player:SetTarget( id )
				else
					-- yeah I know, but this usually doesnt break ;)
					if ( Player:GetCurrentlyCastedSpell() == 17 ) then								
						Player:Interact( id )
						ml_log("Looting..")
						mc_global.Wait(1000)
						return true
					end	
				end
			end
		end
	end
	return ml_log(false)	
end


function DoCombatMovement()
	
	-- Check for knockdown & immobilized buffs
	if ( mc_helper.HasBuffs(Player, "791,727") ) then --Fear and Immobilized
		--d("No CombatMovement : We got Fear/Immobilized debuff")
		return false
	end
	
	
	local T = Player:GetTarget()
	if ( T ) then
				
			local Tdist = T.distance					
			local playerHP = Player.health.percent
			local movedir = Player:GetMovement()
						
			-- EVADE
			if (mc_ai_combat.combatEvadeTmr == 0 or mc_global.now - mc_ai_combat.combatEvadeTmr > 2000) then
				mc_ai_combat.combatEvadeTmr = mc_global.now			
				mc_ai_combat.combatEvadeLastHP = 0
			end				
			if (mc_ai_combat.combatEvadeLastHP > 0 ) then				
				if (mc_ai_combat.combatEvadeLastHP <= playerHP) then
					mc_ai_combat.combatEvadeLastHP = playerHP
				elseif (mc_ai_combat.combatEvadeLastHP - playerHP > math.random(5,10) and Player.endurance >= 50 and Player:IsFacingTarget()) then
				-- we lost 5-10% hp in the last 2,5seconds, evade!
					
					local tries = 0
					while (tries < 4) do
						local direction = math.random(0,7)
						if (Player:CanEvade(direction,100)) then							
							d("Evade! :"..tostring(Player:Evade(direction)));
							mc_ai_combat.combatEvadeLastHP = 0
							return
						end
						tries = tries + 1
					end					
				end
			else 
				mc_ai_combat.combatEvadeLastHP = playerHP
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
				
				--[[if (Player.inCombat and not Player:IsFacingTarget() and Tdist < 180) then
					Player:StopMovement()
					local tpos = T.pos
					-- moveto(x,y,z,stoppingdistance,navsystem(normal/follow),navpath(straight/random),smoothturns)
					local navResult = tostring(Player:MoveTo(tPos.x,tPos.y,tPos.z,130,false,true,false))
					if (tonumber(navResult) < 0) then
						ml_error("mc_ai_combat.CombatMovement result: "..tostring(navResult))
					end
				end]]
				
				if (tonumber(Tdist) ~= nil) then
					if (mc_global.AttackRange > 300) then
						-- RANGE
						if (Tdist < (mc_global.AttackRange / 2) and movedir.forward ) then -- we are too close and moving towards enemy						
							Player:UnSetMovement(0)	-- stop moving forward	
						elseif ( Tdist > mc_global.AttackRange and movedir.backward ) then -- we are too far away and moving backwards
							Player:UnSetMovement(1)	-- stop moving backward	
						elseif (Tdist > mc_global.AttackRange and (movedir.left or movedir.right)) then -- we are strafing outside the maxrange
							if ( movedir.left ) then
								Player:UnSetMovement(2) -- stop moving Left	
							elseif( movedir.right) then
								Player:UnSetMovement(3) -- stop moving Right
							end
						end	
					else
						-- MELEE
						if ( Tdist < 85 and movedir.forward) then -- we are too close	and moving towards enemy
							Player:UnSetMovement(0)	-- stop moving forward	
						elseif (Tdist > mc_global.AttackRange and movedir.backward) then -- we are too far away and moving backwards
							Player:UnSetMovement(1)	-- stop moving backward	
						elseif ((Tdist > mc_global.AttackRange + 50 or Tdist < 50) and (movedir.left or movedir.right)) then -- we are strafing outside the maxrange
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
			--d("PRECHECK "..tostring(Tdist ~= nil) .." Timer"..tostring(mc_global.now - mc_ai_combat.combatMoveTmr > 0) .."  cancast: "..tostring(Player:CanCast()).."  oOM: "..tostring(Player.onmesh).." Tlos: "..tostring(T.los) .."  Icom: "..tostring(Player.inCombat and T.inCombat))
			if ( Tdist ~= nil and mc_global.now - mc_ai_combat.combatMoveTmr > 0 and Player:CanCast() and Player.onmesh and T.los and Player.inCombat and T.inCombat) then	

				mc_ai_combat.combatMoveTmr = mc_global.now + math.random(1000,2000)
				--tablecount:  1, 2, 3, 4, 5   --Table index starts at 1, not 0 
				local dirs = { 0, 1, 2, 3, 4 } --Forward = 0, Backward = 1, Left = 2, Right = 3, + stop
				
				if (mc_global.AttackRange > 300 ) then										
					-- RANGE
					if (Tdist < mc_global.AttackRange ) then						
						if (Tdist > (mc_global.AttackRange * 0.90)) then 
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
					if (Tdist < mc_global.AttackRange ) then						
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
				
				-- MOVE				
				local dir = dirs[ math.random( #dirs ) ] 
				--d("New MOVING DIR: "..tostring(dir))
				if ( dir ~= 4) then										
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

