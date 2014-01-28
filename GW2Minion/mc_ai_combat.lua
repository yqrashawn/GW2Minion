-- Handles Death, respawn and downed fighting
mc_ai_combat = {}
mc_ai_combat.DefendBT = {}
mc_ai_combat.SeachAndKillBT = {}
mc_ai_combat.combatMoveTmr = 0
mc_ai_combat.combatEvadeTmr = 0
mc_ai_combat.combatEvadeLastHP = 0

function mc_ai_combat.moduleinit()

end

function mc_ai_combat.todo()
	d("TODO: handle Combat")
	return true
end

function mc_ai_combat.NoValidTarget()
	local target = Player:GetTarget()
	if ( TableSize( target ) > 0 ) then
		return (not target.alive and not target.attackable and not target.onmesh)
	end
	return true
end

function mc_ai_combat.SetAggroTarget()
	-- lowesthealth in CombatRange first	
	local TList = ( CharacterList("lowesthealth,attackable,alive,aggro,nearest,onmesh,maxdistance="..mc_global.AttackRange) )
	if ( TableSize( TList ) > 0 ) then
		local id, E  = next( TList )
		if ( id ~= nil and id ~= 0 and E ~= nil ) then
			d("New Aggro Target: "..tostring(E.name).." ID:"..tostring(id))
			return Player:SetTarget(id)			
		end		
	end
	
	-- Then nearest Aggro Target
	TList = ( CharacterList("attackable,alive,aggro,nearest,onmesh") )
	if ( TableSize( TList ) > 0 ) then
		local id, E  = next( TList )
		if ( id ~= nil and id ~= 0 and E ~= nil ) then
			d("New Aggro Target: "..tostring(E.name).." ID:"..tostring(id))
			return Player:SetTarget(id)			
		end		
	end
	return false
end

function mc_ai_combat.FindAndSetTarget()
	-- Weakest Aggro in CombatRange first	
	local TList = ( CharacterList("lowesthealth,attackable,alive,aggro,nearest,onmesh,maxdistance="..mc_global.AttackRange) )
	if ( TableSize( TList ) > 0 ) then
		local id, E  = next( TList )
		if ( id ~= nil and id ~= 0 and E ~= nil ) then
			d("Found Aggro Target: "..tostring(E.name).." ID:"..tostring(id))
			return Player:SetTarget(id)			
		end		
	end
	
	-- Then nearest attackable Target
	TList = ( CharacterList("attackable,alive,nearest,onmesh,maxdistance=3500") )
	if ( TableSize( TList ) > 0 ) then
		local id, E  = next( TList )
		if ( id ~= nil and id ~= 0 and E ~= nil ) then
			d("New Target: "..tostring(E.name).." ID:"..tostring(id))
			return Player:SetTarget(id)			
		end		
	end
	return false

end

function mc_ai_combat.NotInCombatRange() 
	local t = Player:GetTarget()
	if ( t ) then
		return (t.distance >= mc_global.AttackRange or not t.los)
	end
	return true
end


function mc_ai_combat.MoveIntoCombatRange()		
	local t = Player:GetTarget()
	if ( t ) then
		local tPos = t.pos
		-- moveto(x,y,z,stoppingdistance,navsystem(normal/follow),navpath(straight/random),smoothturns)
		local navResult = tostring(Player:MoveTo(tPos.x,tPos.y,tPos.z,130,false,false,true))		
		if (tonumber(navResult) < 0) then
			mc_error("mc_ai_combat.MoveIntoCombatRange result: "..tostring(navResult))
			
		end
	end	
	return true
end

function mc_ai_combat.KillTarget()
	local t = Player:GetTarget()
	if ( t ) then
		local pos = t.pos	
		Player:SetFacing(pos.x,pos.y,pos.z)
		mc_skillmanager.AttackTarget( t.id )
	end
	
	DoCombatMovement()
	
	return true
end

function DoCombatMovement()
	
	-- Check for knockdown & immobilized buffs
	if ( mc_helper.HasBuffs(Player, "791,727") ) then --Fear and Immobilized
		d("No CombatMovement : We got Fear/Immobilized debuff")
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
					d("Evade!");
					local tries = 0
					while (tries < 4) do
						local direction = math.random(0,7)
						if (Player:CanEvade(direction)) then
							Player:Evade(direction)
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
					d("OutOfMesh! Stopping CombatMovement")
					Player:StopMovement()
					
					return
				end
				
				if (Player.inCombat and not Player:IsFacingTarget() and Tdist > 180) then
					Player:StopMovement()
					local Tpos = T.pos
					-- moveto(x,y,z,stoppingdistance,navsystem(normal/follow),navpath(straight/random),smoothturns)
					local navResult = tostring(Player:MoveTo(tPos.x,tPos.y,tPos.z,130,false,true,false))
					if (tonumber(navResult) < 0) then
						mc_error("mc_ai_combat.CombatMovement result: "..tostring(navResult))
					end
				end
				
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
			--d("PRECHECK "..tostring(Tdist ~= nil) .." Timer"..tostring(mc_global.now - mc_ai_combat.combatMoveTmr > 0) .."  cancast: "..tostring(Player:CanCast()).."  oOM: "..tostring(Player.onmeshexact).."  Tlos: "..tostring(T.los) .."  Icom: "..tostring(Player.inCombat and T.inCombat))
			if ( Tdist ~= nil and mc_global.now - mc_ai_combat.combatMoveTmr > 0 and Player:CanCast() and Player.onmesh and Player:IsFacingTarget() and T.los and Player.inCombat and T.inCombat) then	
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
				d("MOVING DIR: "..tostring(dir))
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

-- Functions used in the BT need to be defined "above" it!
-- DefendBT Tree: Kill aggro targets
mc_ai_combat.DefendBT = mc_core.PrioritySelector:new(
	
	-- Valid Target? -> Select Aggro Target TODO:Invincible Check
	mc_core.Decorator:new( mc_ai_combat.NoValidTarget, mc_ai_combat.SetAggroTarget ),
	
	-- Move into combatrange
	mc_core.Decorator:new( mc_ai_combat.NotInCombatRange, mc_ai_combat.MoveIntoCombatRange ),
	
	-- Fight
	mc_core.Action:new( mc_ai_combat.KillTarget )
)


--SeachAndKillBT: Search enemies nearby and kill them
mc_ai_combat.SeachAndKillBT = mc_core.PrioritySelector:new(
	
	-- Valid Target? -> Select Aggro Target TODO:Invincible Check
	mc_core.Decorator:new( mc_ai_combat.NoValidTarget, mc_ai_combat.FindAndSetTarget ),
	
	-- Move into combatrange
	mc_core.Decorator:new( mc_ai_combat.NotInCombatRange , mc_ai_combat.MoveIntoCombatRange ),
	
	-- Fight
	mc_core.Action:new( mc_ai_combat.KillTarget )
) 
	
RegisterEventHandler("Module.Initalize",mc_ai_combat.moduleinit)