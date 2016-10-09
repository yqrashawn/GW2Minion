gw2_unstuck = {}
gw2_unstuck.gui = {open = false; visible = false; name = GetString("Unstuck")}
gw2_unstuck.updatetick = 0
gw2_unstuck.stucktick = 0
gw2_unstuck.stuckhistory = {}
gw2_unstuck.movementtype = { forward = false; backward = false; swimpup = false; swimdown = false; }

function gw2_unstuck.Start()
	d("[Unstuck]: Started")
	gw2_unstuck.Stop()
end

function gw2_unstuck.Stop()
	gw2_unstuck.laststuckentry = nil
	gw2_unstuck.laststuckposition = nil
	gw2_unstuck.lastwptimer = 0
	gw2_unstuck.lastposition = nil
	gw2_unstuck.lastraycastdetails = nil
	gw2_unstuck.distmoved = 0
	gw2_unstuck.manualcontrolmode = false
	gw2_unstuck.Reset()
end

function gw2_unstuck.Reset()
	gw2_unstuck.lastaction = nil
	gw2_unstuck.stuckcount = 0
	gw2_unstuck.threshold = Settings.GW2Minion.stuckthreshold
	gw2_unstuck.lastresult = false
	gw2_unstuck.pathblockingobject = nil
	gw2_unstuck.lasttimeonmesh = ml_global_information.Now
	
	for k,movementtype in pairs(gw2_unstuck.movementtype) do
		if(movementtype) then Player:UnSetMovement(movementtype) end
		gw2_unstuck.movementtype[k] = false
	end
end

function gw2_unstuck.HandleStuck(mode)
	if(gw2_unstuck.stucktick > 0 and TimeSince(gw2_unstuck.stucktick) < 250 ) then
		return gw2_unstuck.lastresult
	end
	
	gw2_unstuck.stucktick = ml_global_information.Now
	
	if(gw2_unstuck.manualcontrolmode) then
		gw2_unstuck.Reset()
		gw2_unstuck.lastresult = false
		return gw2_unstuck.lastresult		
	end
	
	if(not ml_global_information.Player_Alive) then
		gw2_unstuck.Reset()
		gw2_unstuck.lastresult = true
		return gw2_unstuck.lastresult
	end
	
	if(not ml_global_information.Player_CanMove) then
		gw2_unstuck.lastresult = true
		return gw2_unstuck.lastresult
	end
	
	if(gw2_common_functions.HasBuffs(Player, ml_global_information.ImmobilizeConditions)) then
		gw2_unstuck.lastresult = true
		return gw2_unstuck.lastresult
	end
	
	if(not ml_global_information.Player_OnMesh) then
		local meshstate = NavigationManager:GetNavMeshState()
		if(meshstate == GLOBAL.MESHSTATE.MESHEMPTY or meshstate == GLOBAL.MESHSTATE.MESHBUILDING or not string.valid(ml_mesh_mgr.currentfilename)) then
			d("[Unstuck]: No mesh loaded for this map.")
			gw2_unstuck.lastresult = true
			return gw2_unstuck.lastresult
		end
		
		gw2_unstuck.lastresult = gw2_unstuck.HandleOffMesh()
		gw2_unstuck.lastposition = Player.pos
		return gw2_unstuck.lastresult
	else
		gw2_unstuck.lasttimeonmesh = ml_global_information.Now
		
		if(table.valid(gw2_unstuck.lastposition)) then
			if(table.valid(gw2_unstuck.pathblockingobject)) then
				gw2_unstuck.lastresult = gw2_unstuck.stuckhandlers.attack(gw2_unstuck.pathblockingobject)
				if(not gw2_unstuck.lastresult) then
					gw2_unstuck.pathblockingobject = nil
				end
			else
				gw2_unstuck.lastresult = gw2_unstuck.HandleStuck_MovedDistanceCheck(mode)
			end
		end
		gw2_unstuck.lastposition = Player.pos
	end

	return gw2_unstuck.lastresult
end

function gw2_unstuck.HandleOffMesh()
	d("[Unstuck]: Player not on mesh!")
	if(TimeSince(gw2_unstuck.lasttimeonmesh) > 20000) then
		if(not gw2_unstuck.stuckhandlers.waypoint()) then
			gw2_unstuck.stuckhandlers.stop()
		end
	elseif(TimeSince(gw2_unstuck.lasttimeonmesh) > 2000) then
		local p = NavigationManager:GetClosestPointOnMesh(Player.pos)
		if(table.valid(p) and p.distance > 0 and p.distance < 500) then
			d("[Unstuck]: Moving blindly to nearby mesh.")
			gw2_unstuck.HandleStuck_MovedDistanceCheck()
			gw2_unstuck.stuckhandlers.moveto(p)			
		end
	end
	
	return true
end

function gw2_unstuck.HandleStuck_MovedDistanceCheck(mode)
	if(table.valid(gw2_unstuck.lastposition)) then
		local ppos = Player.pos
		if(ml_global_information.Player_SwimState ~= GW2.SWIMSTATE.NotInWater) then
			-- Swimming straight up or down is a valid thing
			gw2_unstuck.distmoved = Distance3DT(ppos,gw2_unstuck.lastposition)
		else
			gw2_unstuck.distmoved = Distance2D(ppos.x,ppos.y,gw2_unstuck.lastposition.x,gw2_unstuck.lastposition.y)
		end
		
		local threshold = gw2_unstuck.ActiveThreshold()
		local mincount = (mode == nil or mode == "combat") and 5 or 2

		if(gw2_unstuck.distmoved < threshold) then
			gw2_unstuck.lastaction = nil
			if(gw2_unstuck.stuckcount >= mincount) then
				d(string.format("[Unstuck]: Distance moved: %s. Threshold: %s. Stuckcount: %s.", math.floor(gw2_unstuck.distmoved), math.floor(threshold), gw2_unstuck.stuckcount))
			end
			gw2_unstuck.stuckcount = gw2_unstuck.stuckcount + 1

			local _,stuckentry = gw2_unstuck.AddStuckEntry(ppos)

			if(gw2_unstuck.HandleStuckEntry(stuckentry)) then
				return false
			end
			
			if(ml_global_information.Player_SwimState ~= GW2.SWIMSTATE.NotInWater) then
				if(gw2_unstuck.HandleStuck_Swimming(mode,mincount)) then
					return true
				end
			elseif(gw2_unstuck.stuckcount > mincount+10) then
				gw2_obstacle_manager.AddAvoidanceArea({pos = Player.pos, radius = 25})
				gw2_unstuck.stuckhandlers.movebackward()
				gw2_unstuck.threshold = 200
				ml_global_information.Wait(2000)
				return true
			elseif(gw2_unstuck.stuckcount > mincount+8) then
				local dir = math.random(4,5)
				gw2_unstuck.lastaction = "dodgeforward"..(dir == 4 and "left" or "right")
				gw2_unstuck.stuckhandlers[gw2_unstuck.lastaction]()
				return true
			elseif(gw2_unstuck.stuckcount > mincount+6) then
				local hit,hitx,hity,hitz,a,b,c
			
				hit,hitx,hity,hitz,a,b,c = RayCast(ppos.x, ppos.y, ppos.z, ppos.x+(ppos.hx*400), ppos.y+(ppos.hy*400), ppos.z-55, 0)
				if(hit) then
					d("[Unstuck]: Something is in front of us.")
					local GList = ( GadgetList("maxdistance=3000"))
					if (table.valid(GList)) then
						local id, gadget  = next( GList )
						local target = nil
						while id and gadget and target == nil do
							if(gadget.isunknown8 == a) then
								target = gadget
							end
							id,gadget  = next(GList, id)
						end
						
						if(not table.valid(target)) then
							target = Player:GetInteractableTarget()
						end
						
						if(not table.valid(target)) then
							local GList = ( GadgetList("nearest,maxdistance=500"))
							if(table.valid(GList)) then
								target = select(2,next(GList))
							end
						end
						
						if(table.valid(target) and target.isgadget) then
							if(gw2_unstuck.lastraycastdetails == nil or target.id ~= gw2_unstuck.lastraycastdetails.id) then
								gw2_unstuck.lastraycastdetails = { id = target.id, pos = {x = hitx, y = hity, z = Player.pos.z}, a = a, b = b, c = c }

								if(gw2_unstuck.stuckhandlers.interact(target.id)) then
									gw2_unstuck.lastaction = "interact"
									return true
								end
								
								gw2_unstuck.pathblockingobject = { id = target.id, health = (target.health and target.health.current or 100), pos = {x = hitx, y = hity, z = hitz}, start = ml_global_information.Now, lasthealthcheck = ml_global_information.Now}
								
								if(gw2_unstuck.stuckhandlers.attack(gw2_unstuck.pathblockingobject)) then
									gw2_unstuck.lastaction = "attack"
									return true	
								end
							end
						end
					end
				end
				
				local posleft = gw2_unstuck.rotateposition(60, {x = ppos.x+(ppos.hx*100), y = ppos.y+(ppos.hx*100), z = ppos.z-55})
				hit,hitx,hity,hitz,a,b,c = RayCast(ppos.x, ppos.y, ppos.z, posleft.x, posleft.y, posleft.z-55, 0)
				if(not hit and gw2_unstuck.stuckhandlers.moveto(posleft)) then
					d("[Unstuck]: Free space on the left.")
					gw2_unstuck.lastaction = "moveto"
					stuckentry.handlevars = posleft
					gw2_obstacle_manager.AddAvoidanceArea({pos = Player.pos, radius = 25})
					if(gw2_unstuck.stuckhandlers.moveto(posleft)) then
						return true
					end
				end
				
				local posright = gw2_unstuck.rotateposition(-60, {x = ppos.x+(ppos.hx*100), y = ppos.y+(ppos.hx*100), z = ppos.z-55})
				hit,hitx,hity,hitz,a,b,c = RayCast(ppos.x, ppos.y, ppos.z, posright.x, posright.y, posright.z-55, 0)
				if(not hit and gw2_unstuck.stuckhandlers.moveto(posright)) then
					d("[Unstuck]: Free space on the right.")
					gw2_unstuck.lastaction = "moveto"
					stuckentry.handlevars = posright
					gw2_obstacle_manager.AddAvoidanceArea({pos = Player.pos, radius = 25})
					if(gw2_unstuck.stuckhandlers.moveto(posright)) then
						return true
					end
				end
			elseif(gw2_unstuck.stuckcount > mincount) then
				gw2_unstuck.lastaction = "jump"
				gw2_unstuck.stuckhandlers.jump()
				return false
			end
			
			gw2_unstuck.laststuckposition = ppos
			return false
		end

		if(gw2_unstuck.laststuckentry and gw2_unstuck.lastaction) then
			gw2_unstuck.laststuckentry.handled = gw2_unstuck.lastaction
			gw2_unstuck.laststuckentry.stuckcount = gw2_unstuck.laststuckentry.stuckcount > 0 and gw2_unstuck.laststuckentry.stuckcount - 1 or 0
		end
	end
	
	gw2_unstuck.Reset()
	
	return false
end

function gw2_unstuck.HandleStuck_Swimming(mode,mincount) 
	if(gw2_unstuck.stuckcount > mincount+5) then
		gw2_unstuck.stuckhandlers.swimdown()
		gw2_unstuck.stuckhandlers.moveforward()
		ml_global_information.Wait(math.random(500,1000))
		return true
	elseif(gw2_unstuck.stuckcount > mincount) then
		gw2_unstuck.stuckhandlers.swimup()
		gw2_unstuck.stuckhandlers.moveforward()
		ml_global_information.Wait(math.random(500,1000))
		return true
	end

	return false
end

function gw2_unstuck.HandleStuckEntry(entry)
	local retval = false
	if(table.valid(gw2_unstuck.laststuckentry)) then
		if(Distance3DT(entry.pos,gw2_unstuck.laststuckentry.pos) < 40) then
			entry.stuckcount = entry.stuckcount + 1
			entry.modified = ml_global_information.Now
		end

		if(entry.stuckcount > 40) then
			d("[Unstuck]: We have been stuck at this location 40 times.")
			gw2_unstuck.stuckhandlers.stop()
			retval = true
		elseif(entry.stuckcount > 20) then
			d("[Unstuck]: We have been stuck at this location 20 times.")
			gw2_obstacle_manager.AddAvoidanceArea({pos = Player.pos, radius = 50})
			entry.waypointcount = entry.waypointcount + 1
			if(entry.waypointcount < 15) then
				gw2_unstuck.stuckhandlers.waypoint()
			else
				d("[Unstuck]: We have waypointed away from this location more then 10 times.")
			end
			retval = true
		elseif(entry.handled and gw2_unstuck.stuckhandlers[entry.handled] and not table.deepcompare(gw2_unstuck.laststuckentry,entry)) then
			d("[Unstuck]: We managed to get unstuck here last time using: " .. entry.handled)
			retval = gw2_unstuck.stuckhandlers[entry.handled](entry.handlevars)
		end
	end
	
	gw2_unstuck.laststuckentry = entry
	
	return retval
end

function gw2_unstuck.AddStuckEntry(pos)
	local k,entry = gw2_unstuck.GetStuckEntry(pos)
	
	if(not entry) then
		local now = ml_global_information.Now
		gw2_unstuck.stuckhistory[now] = {
			pos = pos;
			stuckcount = 0;
			handled = false;
			added = now,
			mapid = ml_global_information.CurrentMapID,
			modified = now,
			inwater = ml_global_information.Player_SwimState ~= GW2.SWIMSTATE.NotInWater,
			waypointcount = 0
		}
		k,entry = now,gw2_unstuck.stuckhistory[now]
	end

	return k,entry
end

function gw2_unstuck.GetStuckEntry(pos)
	if(table.valid(gw2_unstuck.stuckhistory)) then
		for k,stuckentry in pairs(gw2_unstuck.stuckhistory) do
			if(Distance3DT(pos,stuckentry.pos) < 40) then
				return k,stuckentry
			end
		end
	end
	return nil
end

function gw2_unstuck.ActiveThreshold()
	local threshold = gw2_unstuck.threshold * (gw2_common_functions.HasBuffs(Player, ml_global_information.SpeedBoons) and 1.33 or 1) -- Increased threshold with swiftness

	if (ml_global_information.Player_InCombat or gw2_common_functions.HasBuffs(Player, ml_global_information.SlowConditions) or gw2_unstuck.movementtype.backward) then
		-- We only move half (or less) the distance with conditions that slow movement
		threshold = threshold / 2
	end
	
	return threshold
end

gw2_unstuck.stuckhandlers = {}
function gw2_unstuck.stuckhandlers.jump()
	d("[Unstuck]: Trying to jump.")
	gw2_unstuck.stuckhandlers.moveforward()
	Player:Jump()
	return true
end

function gw2_unstuck.stuckhandlers.dodgeforwardright()
	d("[Unstuck]: Trying to dodge forward to the right.")
	Player:Evade(4)
	return true
end

function gw2_unstuck.stuckhandlers.dodgeforwardleft()
	d("[Unstuck]: Trying to dodge forward to the left.")
	Player:Evade(5)
	return true
end

function gw2_unstuck.stuckhandlers.moveto(pos)
	d("[Unstuck]: Trying to move to a position.")
	if(table.valid(pos)) then
		Player:SetFacing(pos.x,pos.y,pos.z)
		gw2_unstuck.stuckhandlers.moveforward()
		ml_global_information.Wait(math.random(1500,2000))
		return true
	end
	return false
end

function gw2_unstuck.stuckhandlers.moveforward()
	d("[Unstuck]: Trying to move forward.")
	gw2_unstuck.movementtype.forward = GW2.MOVEMENTTYPE.Forward
	Player:SetMovement(GW2.MOVEMENTTYPE.Forward)
	return true
end

function gw2_unstuck.stuckhandlers.movebackward()
	d("[Unstuck]: Trying to move backward.")
	gw2_unstuck.movementtype.backward = GW2.MOVEMENTTYPE.Backward
	Player:SetMovement(GW2.MOVEMENTTYPE.Backward)
	return true
end

function gw2_unstuck.stuckhandlers.swimup()
	d("[Unstuck]: Trying to swim up.")
	Player:StopMovement()
	Player:SetMovement(GW2.MOVEMENTTYPE.SwimUp)
	gw2_unstuck.movementtype.swimup = GW2.MOVEMENTTYPE.SwimUp
	return true
end

function gw2_unstuck.stuckhandlers.swimdown()
	d("[Unstuck]: Trying to swim down.")
	Player:StopMovement()
	Player:SetMovement(GW2.MOVEMENTTYPE.SwimDown)
	gw2_unstuck.movementtype.swimdown = GW2.MOVEMENTTYPE.SwimDown
	return true
end

function gw2_unstuck.stuckhandlers.waypoint()
	d("[Unstuck]: Trying to use a waypoint.")
	if(gw2_unstuck.lastwptimer > 0 and TimeSince(gw2_unstuck.lastwptimer) < 30000) then
		d("[Unstuck]: Used a waypoint less then 30 seconds ago.")
		gw2_unstuck.stuckhandlers.stop()
	elseif (Inventory:GetInventoryMoney() > 200) then
		local wp = gw2_common_functions.GetClosestWaypointToPos(ml_global_information.CurrentMapID,Player.pos)
		if(table.valid(wp) and wp.distance > 500) then
			Player:StopMovement()
			gw2_unstuck.lastwptimer = ml_global_information.Now
			ml_global_information.Wait(math.random(3000,5000))
			Player:TeleportToWaypoint(wp.id)
			return true
		else
			d("[Unstuck]: No waypoint found.")
		end
	end
	return false
end

function gw2_unstuck.stuckhandlers.attack(object)
	d("[Unstuck]: Trying to attack.")
	if(table.valid(object)) then
		local skill = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_1)
		local target = GadgetList:Get(object.id)
		
		if(TimeSince(object.start) > 60000 or not table.valid(skill) or skill.maxrange == 0 or not table.valid(target) or target.alive == false or target.attackable == false) then
			d("[Unstuck]: Target destroyed or invalid")
			return false
		end
		
		if(TimeSince(object.start) > 10000 and TimeSince(object.lasthealthcheck) > 5000) then
			object.lasthealthcheck = ml_global_information.Now
			if(object.health <= target.health.current) then
				d("[Unstuck]: Target not losing health")
				return false
			end
			object.health = target.health.current
		end
		
		Player:StopMovement()
		
		local maxrange = skill.maxrange > 150 and skill.maxrange or 150
		local dist = Distance2D(Player.pos.x,Player.pos.y,object.pos.x,object.pos.y)
		
		Player:SetFacingExact(object.pos.x,object.pos.y,target.pos.z)
		if(dist > maxrange) then
			gw2_unstuck.stuckhandlers.moveforward()
			return true
		end
		
		-- Work around a weird issue with some skills that wont cast if too close to the target
		if(target.distance < 150) then
			gw2_unstuck.stuckhandlers.movebackward()
		end
		
		local ptarget = Player:GetTarget()
		if(ptarget == nil or ptarget.id ~= target.id) then
			Player:SetTarget(target.id)
		end
		
		if(Player.castinfo.slot == ml_global_information.MAX_SKILLBAR_SLOTS) then
			if(skill.isgroundtargeted) then
				Player:CastSpell(skill.slot,object.pos.x,object.pos.y,target.pos.z)
			else
				Player:CastSpell(skill.slot,target.id)
			end
		end
		return true
	end
	return false
end

function gw2_unstuck.stuckhandlers.interact(id)
	d("[Unstuck]: Trying to interact.")
	if(id) then
		local target = GadgetList:Get(id)
		if(table.valid(target)) then
			if(target.interactable and target.isininteractrange) then
				Player:SetFacingExact(target.x,target.y,target.z)
				Player:Interact(target.id)
				ml_global_information.Wait(math.random(750,1000))
				return true
			end
		end
	end
	return false	
end

function gw2_unstuck.stuckhandlers.stop()
	d("[Unstuck]: Stopping the bot.")
	Player:StopMovement()
	ml_bt_mgr.running = false
end

function gw2_unstuck.rotateposition(deg,pos,center)
	deg = deg*(math.pi/180)
	center = center or ml_global_information.Player_Position

	local rotated = {}
	local x = pos.x-center.x
	local y = pos.y-center.y
	local c = math.cos(deg)
	local s = math.sin(deg)

	rotated.x = (x * c) - (y * s) + center.x
	rotated.y = (y * s) + (x * c) + center.y
	rotated.z = pos.z

	return rotated
end

function gw2_unstuck.Init()
	if(Settings.GW2Minion.stuckthreshold == nil or type(Settings.GW2Minion.stuckthreshold) ~= "number") then Settings.GW2Minion.stuckthreshold = 40 end
	
	ml_gui.ui_mgr:AddMember({ id = "GW2MINION##UNSTUCKMGR", name = GetString("Unstuck"), onClick = function() gw2_unstuck.gui.open = gw2_unstuck.gui.open ~= true end, tooltip = "Click to open \"Unstuck\" window.", texture = GetStartupPath().."\\GUI\\UI_Textures\\unstuck.png"},"GW2MINION##MENU_HEADER")
	
	gw2_unstuck.Stop()
end
RegisterEventHandler("Module.Initalize",gw2_unstuck.Init)

function gw2_unstuck.Update(_, tick)
	if(TimeSince(gw2_unstuck.updatetick) > 250) then
		gw2_unstuck.updatetick = tick
		for k,entry in pairs(gw2_unstuck.stuckhistory) do			
			if(TimeSince(entry.modified) > 120000) then
				-- Decrease the stuck count over time
				if(entry.stuckcount > 0) then
					entry.stuckcount = entry.stuckcount - 1
					entry.modified = ml_global_information.Now
				elseif(entry.handled == false) then
					gw2_unstuck.stuckhistory[k] = nil
				end
			elseif(entry.mapid ~= ml_global_information.CurrentMapID and entry.handled == false) then
				gw2_unstuck.stuckhistory[k] = nil
			end
		end
	end
end
RegisterEventHandler("Gameloop.Update",gw2_unstuck.Update)

---- GUI
function gw2_unstuck.Draw()
	if(gw2_unstuck.gui.open) then
		GUI:SetNextWindowSize(550,400,GUI.SetCond_Appearing)
		gw2_unstuck.gui.visible, gw2_unstuck.gui.open = GUI:Begin(gw2_unstuck.gui.name, gw2_unstuck.gui.open)
		
		if(gw2_unstuck.gui.visible) then
			Settings.GW2Minion.stuckthreshold = GUI:SliderInt(GetString("Threshold"), Settings.GW2Minion.stuckthreshold, 25, 80)
			GUI:Separator()
			GUI:Text(GetString("With swiftness")..": "..tostring(round(Settings.GW2Minion.stuckthreshold*1.33,2)))
			GUI:Text(GetString("In combat")..": "..tostring(round(Settings.GW2Minion.stuckthreshold/2,2)))

			GUI:Text(GetString("Active threshold")..": "..tostring(gw2_unstuck.ActiveThreshold()))
			GUI:Separator()
			if(GUI:ListBoxHeader(GetString("Stuck history"), table.size(gw2_unstuck.stuckhistory), 5)) then
				for k,entry in pairs(gw2_unstuck.stuckhistory) do
					if(GUI:Selectable(entry.mapid.." / "..math.ceil(entry.pos.x)..","..math.ceil(entry.pos.y)..","..math.ceil(entry.pos.z).." / "..GetString("Handled")..": " .. tostring(entry.handled), gw2_unstuck.gui.selectedstuckentry == k)) then
						gw2_unstuck.gui.selectedstuckentry = k
					end
				end
				GUI:ListBoxFooter()
			end
			GUI:Separator()
			GUI:Text(GetString("Current stuck count")..": "..tostring(gw2_unstuck.stuckcount))
			GUI:Text(GetString("Distance moved")..": "..tostring(round(gw2_unstuck.distmoved,2)))
			
			GUI:Separator()
			if(gw2_unstuck.gui.selectedstuckentry) then
				local entry = gw2_unstuck.stuckhistory[gw2_unstuck.gui.selectedstuckentry]
				if(entry) then
					for k,v in pairs(entry) do
						GUI:Text(k) GUI:SameLine() GUI:Text(":") GUI:SameLine() GUI:Text(tostring(v))
					end
				end
			end
		end
		GUI:End()
	end
end
RegisterEventHandler("Gameloop.Draw",gw2_unstuck.Draw)