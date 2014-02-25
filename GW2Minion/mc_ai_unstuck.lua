mc_ai_unstuck = {}
mc_ai_unstuck.stucktimer = 0
mc_ai_unstuck.stuckcounter = 0
mc_ai_unstuck.idletimer = 0
mc_ai_unstuck.idlecounter = 0
mc_ai_unstuck.respawntimer = 0
mc_ai_unstuck.ismoving = false
mc_ai_unstuck.lastpos = nil


function mc_ai_unstuck:OnUpdate( tick )
	
	if ( Player.alive == false) then 
		mc_ai_unstuck.Reset()
		return
	end
	
	
	if 	(mc_ai_unstuck.lastpos == nil) or (mc_ai_unstuck.lastpos and type(mc_ai_unstuck.lastpos) ~= "table") then
		mc_ai_unstuck.lastpos = Player.pos
		return	
	end
	
	if ( gBotMode == "Assist") then return end
	
	-- Stuck check for movement stucks
	if ( Player:IsMoving()) then
		local movedirs = Player:GetMovement()
		if ( not movedirs.backward and tick - mc_ai_unstuck.stucktimer > 500 ) then
			mc_ai_unstuck.stucktimer = tick
			local pPos = Player.pos
			if ( pPos ) then
				--d(Distance2D ( pPos.x, pPos.y, mc_ai_unstuck.lastpos.x, mc_ai_unstuck.lastpos.y))
				if ( Distance2D ( pPos.x, pPos.y, mc_ai_unstuck.lastpos.x,  mc_ai_unstuck.lastpos.y) < 75 ) then					
					if ( mc_ai_unstuck.stuckcounter > 1 ) then
						d("Seems we are stuck?")
						if ( Player:CanMove() ) then
							Player:Jump()
						end
					end
					if ( mc_ai_unstuck.stuckcounter > 8 ) then
						mc_ai_unstuck.HandleStuck()
					end
					mc_ai_unstuck.stuckcounter = mc_ai_unstuck.stuckcounter + 1
				else
					mc_ai_unstuck.stuckcounter = 0
					if ( mc_ai_unstuck.ismoving == true ) then
						Player:UnSetMovement(2)
						Player:UnSetMovement(3)
						mc_ai_unstuck.ismoving = false
					end
				end
				mc_ai_unstuck.lastpos = Player.pos
			end
		end
	else
		mc_ai_unstuck.stuckcounter = 0
		
		-- Idle stuck check	
		if ( tick - mc_ai_unstuck.idletimer > 6000 ) then
			mc_ai_unstuck.idletimer = tick
			if ( not Player:IsCasting() and not Player:IsConversationOpen() and not Inventory:IsVendorOpened() ) then
				local pPos = Player.pos
				
				if ( pPos ) then				
					if ( Distance2D ( pPos.x, pPos.y, mc_ai_unstuck.lastpos.x,  mc_ai_unstuck.lastpos.y) < 75 ) then
						mc_ai_unstuck.idlecounter = mc_ai_unstuck.idlecounter + 1
						if ( mc_ai_unstuck.idlecounter > 10 ) then -- 60 seconds of doing nothing
							d("Our bot seems to be doing nothing anymore...")
							mc_ai_unstuck.idlecounter = 0
							mc_ai_unstuck.HandleStuck()							
						end
					else
						mc_ai_unstuck.idlecounter = 0
					end
				end
				mc_ai_unstuck.lastpos = Player.pos
			end
		end
	end	
end

function mc_ai_unstuck.HandleStuck()
	if ( mc_global.now - mc_ai_unstuck.respawntimer < 30000 ) then
		ml_error("We used a waypoint within the last 30 seconds already but are stuck again !?")
		ml_error("Stopping bot...")
		mc_global.togglebot("0")
			--ExitGW()
	else
		d("Trying to teleport to nearest waypoint for unstuck..")
		if ( Player:RespawnAtClosestWaypoint() ) then
			mc_global.Wait(3000)
			mc_ai_unstuck.respawntimer = mc_global.now
		end
	end	
	mc_ai_unstuck.stuckcounter = 0	
end

function mc_ai_unstuck.stuckhandler( event, distmoved, stuckcount )

	if ( Player.alive == false) then 
		mc_ai_unstuck.Reset()
		return
	end
	
	d("STUCK! Distance Moved: "..tostring(distmoved) .. " Count: "..tostring(stuckcount) )
	Player:Jump()
	
	if ( tonumber(stuckcount) > 20 ) then
		local i = math.random(0,1)
		if ( i == 0 ) then
			Player:SetMovement(2)
			mc_ai_unstuck.ismoving = true
		elseif ( i == 1 ) then
			Player:SetMovement(3)
			mc_ai_unstuck.ismoving = true
		end
	end
	
	if ( tonumber(stuckcount) > 20 ) then
		ml_error("We are STUCK!")
		mc_ai_unstuck.HandleStuck()
	end
end

function mc_ai_unstuck.Reset()
	mc_ai_unstuck.stucktimer = 0
	mc_ai_unstuck.stuckcounter = 0
	mc_ai_unstuck.idletimer = 0
	mc_ai_unstuck.idlecounter = 0
	mc_ai_unstuck.respawntimer = 0
	mc_ai_unstuck.ismoving = false
	mc_ai_unstuck.lastpos = nil
end

RegisterEventHandler("Gameloop.Stuck",mc_ai_unstuck.stuckhandler) -- gets called by c++ when using the navigationsystem
