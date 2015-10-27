-- Handler for different OMC types and record keys

function ml_mesh_mgr.ProcessShortcuts()
--Left Alt + Right Mouse
	if ( MeshManager:IsKeyPressed(164) and MeshManager:IsKeyPressed(2)) then
		local mousepos = MeshManager:GetMousePos()
		if ( TableSize(mousepos) > 0 ) then	
			if (MeshManager:DeleteRasterTriangle(mousepos)) then
				d("Deletion was successful.")
			end
		end
	end	
	
	if ( gMeshrec == "1" and gMeshChange == "0" and  MeshManager:IsKeyPressed(162) and MeshManager:IsKeyPressed(3)) then
		ml_mesh_mgr.CreateSingleCell()
	end	
	
	-- Record Mesh & Gamedata
	if ( gMeshrec == "1" or gMeshChange == "1") then
		-- Key-Input-Handler
		
		-- 160 = Left Shift
		if ( MeshManager:IsKeyPressed(160) ) then
			MeshManager:RecSize(2*tonumber(gRecAreaSize))
		else
			MeshManager:RecSize(tonumber(gRecAreaSize))
		end
				
		-- 162 = Left CTRL + Left Mouse
		if ( MeshManager:IsKeyPressed(162) and MeshManager:IsKeyPressed(1)) then --162 is the integervalue of the virtualkeycode (hex)
			MeshManager:RecSize(1)
			MeshManager:RecForce(true)
		else
			MeshManager:RecForce(false)
			if ( not  MeshManager:IsKeyPressed(160) ) then
				MeshManager:RecSize(tonumber(gRecAreaSize))					
			end
		end			
				
		-- 162 = Left CTRL 
		if ( MeshManager:IsKeyPressed(162) ) then --162 is the integervalue of the virtualkeycode (hex)
			-- show the mesh if it issnt shown
			if ( gShowMesh == "0" ) then
				MeshManager:ShowTriMesh(true)
			end
			MeshManager:RecSteeper(true)
		else
			if ( gShowMesh == "0" ) then
				MeshManager:ShowTriMesh(false)
			end
			MeshManager:RecSteeper(false)
		end	 
	end	
end

function ml_mesh_mgr.HandleOMC( ... )
	local args = {...}
	local OMCType = args[2]	
	local OMCStartPosition,OMCEndposition,OMCFacingDirection = ml_mesh_mgr.UnpackArgsForOMC( args )
	d("OMC REACHED : "..tostring(OMCType))
	
	if ( ValidTable(OMCStartPosition) and ValidTable(OMCEndposition) and ValidTable(OMCFacingDirection) ) then
		ml_mesh_mgr.OMCStartPosition = OMCStartPosition
		ml_mesh_mgr.OMCEndposition = OMCEndposition
		ml_mesh_mgr.OMCFacingDirection = OMCFacingDirection
		ml_mesh_mgr.OMCType = OMCType
		ml_mesh_mgr.OMCIsHandled = true -- Turn on omc handler
	end
end

ml_mesh_mgr.OMCStartPosition = nil
ml_mesh_mgr.OMCEndposition = nil
ml_mesh_mgr.OMCFacingDirection = nil
ml_mesh_mgr.OMCType = nil
ml_mesh_mgr.OMCIsHandled = false
ml_mesh_mgr.OMCStartPositionReached = false
ml_mesh_mgr.OMCJumpStartedTimer = 0
ml_mesh_mgr.OMCThrottle = 0
function ml_mesh_mgr.OMC_Handler_OnUpdate( tickcount ) 
	if ( ml_mesh_mgr.OMCIsHandled ) then
		ml_global_information.Lasttick = ml_global_information.Now -- Pauses the main bot-loop, no unstuck or continues path creation.
		
		if ( ml_mesh_mgr.OMCThrottle > tickcount ) then -- Throttles OMC actions
			return
		end
		
		-- Update IsMoving with exact data
		ml_global_information.Player_IsMoving = Player:IsMoving() or false
		ml_global_information.Player_Position = Player.pos
		-- Set all position data, pPos = Player pos, sPos = start omc pos and heading, ePos = end omc pos
		local pPos = ml_global_information.Player_Position
		local sPos = {
						x = tonumber(ml_mesh_mgr.OMCStartPosition[1]), y = tonumber(ml_mesh_mgr.OMCStartPosition[2]), z = tonumber(ml_mesh_mgr.OMCStartPosition[3]),
						hx = tonumber(ml_mesh_mgr.OMCFacingDirection[1]), hy = tonumber(ml_mesh_mgr.OMCFacingDirection[2]), hz = tonumber(ml_mesh_mgr.OMCFacingDirection[3]),
					}
		local ePos = {
						x = tonumber(ml_mesh_mgr.OMCEndposition[1]), y = tonumber(ml_mesh_mgr.OMCEndposition[2]), z = tonumber(ml_mesh_mgr.OMCEndposition[3]),
					}
		
		if ( ml_mesh_mgr.OMCStartPositionReached == false ) then
			if ( ValidTable(sPos) ) then
				local dist = Distance3D(sPos.x,sPos.y,sPos.z,pPos.x,pPos.y,pPos.z)
				if (dist > 150) then
					ml_mesh_mgr.ResetOMC()
				else
					if ( dist < 35 ) then -- Close enough to start
						d("OMC StartPosition reached..Facing Target Direction..")
						
						Player:SetFacingH(sPos.hx,sPos.hy,sPos.hz) -- Set heading
						ml_mesh_mgr.OMCThrottle = tickcount + 450 -- Pause omc update loop to allow camera to turn (timing untested)
						Player:StopMovement()
						ml_mesh_mgr.OMCStartPositionReached = true
						return
					end
					
					if ( not ml_global_information.Player_IsMoving ) then Player:SetMovement(GW2.MOVEMENTTYPE.Forward) end -- Move towards start location
					Player:SetFacingExact(sPos.x,sPos.y,sPos.z,true) -- Face start location (4th arg: true, turns camera)
					return
				end
			end
			
		else
			
			if ( ml_mesh_mgr.OMCType == "OMC_JUMP" ) then
				if ( ValidTable(ml_mesh_mgr.OMCEndposition) ) then
					-- We are at our start OMC point and are facing the correct direction, now start moving forward and jump
					if ( not ml_global_information.Player_IsMoving ) then
						Player:SetMovement(GW2.MOVEMENTTYPE.Forward)
						
						-- give the bot some time to gain speed before we jump for longer jumps
						local dist = Distance2D(ePos.x,ePos.y,sPos.x,sPos.y)
						local heightdiff = math.abs(ePos.z - pPos.z)
						--d(heightdiff)
						if ( dist > 125) then
							ml_mesh_mgr.OMCThrottle = tickcount + 100
							return
						end
						
					end
					
					Player:SetFacingExact(ePos.x,ePos.y,ePos.z,true)
					
					if (ml_mesh_mgr.OMCJumpStartedTimer == 0 ) then
						Player:Jump()
						ml_mesh_mgr.OMCJumpStartedTimer = ml_global_information.Now
					end
					
					local dist = Distance3D(ePos.x,ePos.y,ePos.z,pPos.x,pPos.y,pPos.z)
					ml_global_information.Player_MovementState = Player:GetMovementState() or 1
					
					local dist2d = Distance2D(ePos.x,ePos.y,pPos.x,pPos.y)
					
					--d("DISTCHECK: "..tostring(dist).."  2d: "..tostring(dist2d))
					
					if ( dist < 25 or (dist < 35 and dist2d < 10)) then
						d("OMC Endposition reached..")
						ml_mesh_mgr.ResetOMC() -- turn off omc handler
						ml_global_information.Lasttick = ml_global_information.Lasttick + 100 -- delay bot after doing omc
					
					elseif(ml_global_information.Player_MovementState ~= GW2.MOVEMENTSTATE.Jumping and ml_global_information.Player_MovementState ~= GW2.MOVEMENTSTATE.Falling and ml_mesh_mgr.OMCJumpStartedTimer ~= 0 and TimeSince(ml_mesh_mgr.OMCJumpStartedTimer) > 350) then
						d("We landed already")
						ml_mesh_mgr.ResetOMC()
						ml_global_information.Lasttick = ml_global_information.Lasttick + 100
					
					elseif( dist > 500 and  ml_mesh_mgr.OMCJumpStartedTimer ~= 0 and TimeSince(ml_mesh_mgr.OMCJumpStartedTimer) > 1500)then
						d("We failed to land on the enposition..use teleport maybe?")
						ml_mesh_mgr.ResetOMC()
					
					elseif(ePos.z < sPos.z and ePos.z < pPos.z and math.abs(ePos.z - pPos.z) > 30 and ml_mesh_mgr.OMCJumpStartedTimer ~= 0 and TimeSince(ml_mesh_mgr.OMCJumpStartedTimer) > 500 ) then
						d("We felt below the OMCEndpoint height..means we missed the landingpoint..")
						ml_mesh_mgr.ResetOMC()
						ml_global_information.Lasttick = ml_global_information.Lasttick + 500
					
					else
						return
					end
				end
			
			elseif ( ml_mesh_mgr.OMCType == "OMC_WALK" ) then
				if ( ValidTable(ml_mesh_mgr.OMCEndposition) ) then
					if ( not ml_global_information.Player_IsMoving ) then Player:SetMovement(GW2.MOVEMENTTYPE.Forward) end
					Player:SetFacingExact(ePos.x,ePos.y,ePos.z,true)
					local dist = Distance3D(ePos.x,ePos.y,ePos.z,pPos.x,pPos.y,pPos.z)
					if ( dist < 50 ) then
						d("OMC Endposition reached..")
						--ml_global_information.Lasttick = ml_global_information.Lasttick + 2000
						ml_mesh_mgr.ResetOMC()
					else
						return
					end
				end
			
			elseif ( ml_mesh_mgr.OMCType == "OMC_LIFT" ) then
				if ( ValidTable(ml_mesh_mgr.OMCStartPosition) ) then
					if ( not ml_global_information.Player_IsMoving ) then Player:SetMovement(GW2.MOVEMENTTYPE.Forward) end
					local dist = Distance3D(sPos.x,sPos.y,sPos.z,pPos.x,pPos.y,pPos.z)
					if ( dist > 250 ) then
						d("OMC Endposition reached..")
						--ml_global_information.Lasttick = ml_global_information.Lasttick + 200
						ml_mesh_mgr.ResetOMC()
					else
						return
					end
				end
			
			elseif ( ml_mesh_mgr.OMCType == "OMC_TELEPORT" ) then
				if ( ValidTable(ml_mesh_mgr.OMCEndposition) ) then
					if ( ml_global_information.Player_IsMoving ) then Player:StopMovement() end
					-- Add playerdetection when distance to OMCEndposition is > xxx
					local enddist = Distance3D(ePos.x,ePos.y,ePos.z,pPos.x,pPos.y,pPos.z)
					if ( enddist > 220 ) then
						if ( TableSize(CharacterList("nearest,player,maxdistance=1500"))>0 ) then
							ml_log("Need to teleport but players are nearby..waiting..")
							ml_mesh_mgr.OMCThrottle = tickcount + 2000
							ml_global_information.Lasttick = ml_global_information.Lasttick + 1500
							Player:StopMovement()
							return
						end
					end
					Player:Teleport(ePos.x, ePos.y, ePos.z)
					d("OMC Endposition reached..")
					ml_mesh_mgr.ResetOMC()
					
				end
			
			elseif ( ml_mesh_mgr.OMCType == "OMC_INTERACT" ) then
				d("OMC Endposition reached..")
				Player:Interact()
				ml_mesh_mgr.ResetOMC()
			
			elseif ( ml_mesh_mgr.OMCType == "OMC_PORTAL" ) then
				if ( ValidTable(ml_mesh_mgr.OMCEndposition) ) then
					if ( not ml_global_information.Player_IsMoving ) then Player:SetMovement(GW2.MOVEMENTTYPE.Forward) end
					local dist = Distance3D(ePos.x,ePos.y,ePos.z,pPos.x,pPos.y,pPos.z)
					if ( dist < 100 ) then
						d("OMC Endposition reached..")
						ml_global_information.Lasttick = ml_global_information.Lasttick + 2000
						ml_mesh_mgr.ResetOMC()
					else
						return
					end
				end
			
			end
		
		
		end
	end
end

function ml_mesh_mgr.ResetOMC()
	Player:UnSetMovement(GW2.MOVEMENTTYPE.Forward)
	Player:StopMovement()
	ml_mesh_mgr.OMCStartPosition = nil
	ml_mesh_mgr.OMCEndposition = nil
	ml_mesh_mgr.OMCFacingDirection = nil
	ml_mesh_mgr.OMCType = nil
	ml_mesh_mgr.OMCIsHandled = false
	ml_mesh_mgr.OMCStartPositionReached = false
	ml_mesh_mgr.OMCJumpStartedTimer = 0
	ml_mesh_mgr.OMCThrottle = 0
end

function ml_mesh_mgr.UnpackArgsForOMC( args )
	if ( tonumber(args[3]) ~= nil and tonumber(args[4]) ~= nil and tonumber(args[5]) ~= nil -- OMC Start point
	 and tonumber(args[6]) ~= nil and tonumber(args[7]) ~= nil and tonumber(args[8]) ~= nil -- OMC END point
	 and tonumber(args[9]) ~= nil and tonumber(args[10]) ~= nil and tonumber(args[11]) ~= nil -- OMC Start point-Facing direction
	 ) then
		d("ml_mesh_mgr.UnpackArgsForOMC( args )")
		d("facing dirs:")
		d("hx = "..args[9])
		d("hy = "..args[10])
		d("hz = "..args[11])
		return {tonumber(args[3]),tonumber(args[4]),tonumber(args[5]) },{ tonumber(args[6]),tonumber(args[7]),tonumber(args[8])},{tonumber(args[9]),tonumber(args[10]),tonumber(args[11])}
	 else
		d("No valid positions for OMC reveived! ")
	 end
end

RegisterEventHandler("Gameloop.OffMeshConnectionReached",ml_mesh_mgr.HandleOMC)