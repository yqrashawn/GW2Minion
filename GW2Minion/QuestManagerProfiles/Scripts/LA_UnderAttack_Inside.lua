-- Big Thanks to Jorith!!
script = inheritsFrom( ml_task )
script.name = "LA_UnderAttack_Inside"
script.Data = {}

--******************
-- ml_quest_mgr Functions
--******************
function script:UIInit( identifier )
	-- You need to create the ScriptUI Elements exactly like you see here, the "event" needs to start with "tostring(identifier).." and the group needs to be GetString("questStepDetails")
	GUI_NewCheckbox(ml_quest_mgr.stepwindow.name,"Follow Commanders",tostring(identifier).."_btFollowCMD",GetString("questStepDetails"))
end

function script:SetData( identifier, tData )
	-- Save the data in our script-"instance" aka global variables and set the UI elements
	if ( identifier and tData ) then
		--d("script:SetData: "..tostring(identifier))
		self.Data = tData
		
		-- Update the script UI (make sure the Data assigning to a _G is NOT nil! else crashboooombang!)
		if ( self.Data["_btFollowCMD"] ) then _G[tostring(identifier).."_btFollowCMD"] = self.Data["_btFollowCMD"] end
		
	end
end

function script:EventHandler( identifier, event, value )
	-- for extended UI event handling, gets called when a scriptUI element is pressed	
	
end

--******************
-- ml_Task Functions
--******************
script.valid = true
script.completed = false
script.subtask = nil
script.process_elements = {}
script.overwatch_elements = {} 

function script:Init()
    -- Add Cause&Effects here
	-- Dead?
	self:add(ml_element:create( "Dead", c_dead, e_dead, 225 ), self.process_elements)
	
	-- Downed
	self:add(ml_element:create( "Downed", c_downed, e_downed, 200 ), self.process_elements)
	
	-- AoELooting Characters
	self:add(ml_element:create( "AoELoot", c_AoELoot, e_AoELoot, 175 ), self.process_elements)
	
	-- Dont Dive lol
	self:add(ml_element:create( "SwimUP", c_SwimUp, e_SwimUp, 165 ), self.process_elements)
	
	-- Normal Chests
	self:add(ml_element:create( "LootingChest", c_LootChests, e_LootChests, 155 ), self.process_elements)
	
	-- Resting
	self:add(ml_element:create( "Resting", c_resting, e_resting, 145 ), self.process_elements)

	-- Normal Looting
	self:add(ml_element:create( "Looting", c_LootCheck, e_LootCheck, 130 ), self.process_elements)

	-- Deposit Items
	self:add(ml_element:create( "DepositingItems", c_deposit, e_deposit, 120 ), self.process_elements)
	
	-- Salvaging
	self:add(ml_element:create( "Salvaging", c_salvage, e_salvage, 110 ), self.process_elements)
	
	
	-- Goto Commander
	self:add(ml_element:create( "GoToCommander", self.c_gotoComm, self.e_gotoComm, 70 ), self.process_elements)
	
	-- Goto Commander no Aggro comm dist > 750
	self:add(ml_element:create( "GoToCommander", self.c_gotoCommNoAggro, self.e_gotoComm, 65 ), self.process_elements)
			
	--Pickup Downed Players
	self:add(ml_element:create( "PickupPlayers", self.c_reviveDownedPlayersInCombat, self.e_reviveDownedPlayersInCombat, 60 ), self.process_elements)
	
	--Revive Other Players
	self:add(ml_element:create( "RevivePlayers", self.c_revivePlayers, self.e_revivePlayers, 55 ), self.process_elements)
		
	-- Goto Event (in case of no commader)
	self:add(ml_element:create( "GoToEvent", self.c_GoToEvent, self.e_GoToEvent, 50 ), self.process_elements)
	
	-- Defend
	self:add(ml_element:create( "Aggro", c_Aggro, e_Aggro, 40 ), self.process_elements) --reactive queue
	
	-- Blacklist stupid useless commanders who do nothing
	self:add(ml_element:create( "UselessCommander?", self.c_MrUselessCheck, self.e_MrUselessCheck, 25 ), self.process_elements)	
	
	self:AddTaskCheckCEs()
end


function script:task_complete_eval()
	return Player:GetLocalMapID() ~= 50
end
function script:task_complete_execute()
   self.completed = true
end



-- Cause&Effect
script.c_gotoComm = inheritsFrom( ml_cause )
script.c_gotoCommNoAggro = inheritsFrom( ml_cause )
script.e_gotoComm = inheritsFrom( ml_effect )
script.commanderReached = false
function script.c_gotoComm:evaluate()
	if ( ml_task_hub:CurrentTask().Data["_btFollowCMD"] == "1" ) then
		local commList = MapMarkerList("iscommander,onmesh,nearest,exclude_characterid="..mc_blacklist.GetExcludeString(GetString("monsters")))
		local id, commander = next(commList)
		if (id and commander and (commander.distance > 2500 or script.commanderReached == false)) then
			script.commanderReached = false
			return true
		end
	end
	return false
end
function script.c_gotoCommNoAggro:evaluate()
	if ( ml_task_hub:CurrentTask().Data["_btFollowCMD"] == "1" ) then
		if ( TableSize(CharacterList("nearest,alive,aggro,attackable,maxdistance=1200,onmesh")) == 0) then
			mc_ai_unstuck.idlecounter = 0
			local commList = MapMarkerList("iscommander,onmesh,nearest,exclude_characterid="..mc_blacklist.GetExcludeString(GetString("monsters")))
			id, commander = next(commList)
			if (id and commander and (commander.distance > 750 or script.commanderReached == false)) then
				script.commanderReached = false
				return true
			end
		end
	end
	return false
end
function script.e_gotoComm:execute()
	ml_log("e_gotoComm")
	if (not mc_skillmanager.HealMe()) then
		local commList = MapMarkerList("iscommander,onmesh,nearest,exclude_characterid="..mc_blacklist.GetExcludeString(GetString("monsters")))
		local id, commander = next(commList)
		if (id and commander ) then
			if ( commander.distance > 3000) then
				-- Player:MoveTo(x,y,z,stoppingdistance,navsystem(normal/follow),navpath(straight/random),smoothturns)
				Player:MoveTo(commander.pos.x, commander.pos.y, commander.pos.z, 250, false, false, true)
			elseif ( commander.distance > 750) then
				Player:MoveTo(commander.pos.x, commander.pos.y, commander.pos.z, 250, false, true, true)
				
			elseif (commander.distance < 200) then
				script.commanderReached = true
				Player:StopMovement()
				
			elseif (commander.distance <= 750) then
				if (math.random(0,3) == 0 ) then 
					script.commanderReached = true
					Player:StopMovement()
				end
			else
				script.commanderReached = true
				Player:StopMovement()
			end
			ml_log(true)
		end
	end
	ml_log(false)
end




script.c_GoToEvent = inheritsFrom( ml_cause )
script.e_GoToEvent = inheritsFrom( ml_effect )
script.c_gotoEventreached = false
function script.c_GoToEvent:evaluate()
	if ( ml_task_hub:CurrentTask().Data["_btFollowCMD"] == "1" ) then
		local commList = MapMarkerList("iscommander,onmesh,nearest,exclude_characterid="..mc_blacklist.GetExcludeString(GetString("monsters")))
		local id, commander = next(commList)
		if (id and commander) then	
			return false
		end
	end
	
	local evList = MapMarkerList("nearest,isevent,onmesh,worldmarkertype="..mc_global.WorldMarkerType..",exclude_eventid="..mc_blacklist.GetExcludeString(GetString("event")))
	local i,e = next(evList)
	if ( i and e ) then
		if ( script.c_gotoEventreached == false) then
			return true
		else
			-- Check if we moved too far away from the event
			local pPos = Player.pos
			local ePos = e.pos
			if (pPos and ePos) then
				if ( Distance3D ( pPos.x, pPos.y, pPos.z, ePos.x, ePos.y, ePos.z) > 3000 ) then						
					return true					
				else
					if ( Player.inCombat == false and Distance3D ( pPos.x, pPos.y, pPos.z, ePos.x, ePos.y, ePos.z) > 450) then
						return true
					end
				end
			end			
		end			
	end
	return false
end
function script.e_GoToEvent:execute()
	ml_log("e_GoToEvent")
	if (not mc_skillmanager.HealMe()) then
		local evList = MapMarkerList("nearest,isevent,onmesh,worldmarkertype="..mc_global.WorldMarkerType..",exclude_eventid="..mc_blacklist.GetExcludeString(GetString("event")))
		local i,e = next(evList)
		if ( i and e ) then
			if ( e.distance > 3000) then
				-- Player:MoveTo(x,y,z,stoppingdistance,navsystem(normal/follow),navpath(straight/random),smoothturns)
				Player:MoveTo(e.pos.x, e.pos.y, e.pos.z, 250, false, false, true)
			elseif ( e.distance > 450) then
				Player:MoveTo(e.pos.x, e.pos.y, e.pos.z, 250, false, true, true)
				
			elseif (e.distance < 200) then
				script.c_gotoEventreached = true
				Player:StopMovement()
				
			elseif (e.distance <= 450) then
				if (math.random(0,3) == 0 ) then 
					script.c_gotoEventreached = true
					Player:StopMovement()
				end
			else
				script.c_gotoEventreached = true
				Player:StopMovement()
			end
			ml_log(true)
			return
		end
	end
	ml_log(false)
end

script.c_gotoEvent = inheritsFrom( ml_cause )
script.e_gotoEvent = inheritsFrom( ml_effect )
script.c_gotoEvent.reached = false
script.c_gotoEvent.range = 500
function script.c_gotoEvent:evaluate()
	local eID = ml_task_hub:CurrentTask().eventID
	if ( tonumber(eID)~=nil ) then
		local evList = MapMarkerList("nearest,eventID="..eID)
		local i,e = next(evList)
		if ( i and e ) then
			if ( script.c_gotoEvent.reached == false) then
				return true
			else
				-- Check if we moved too far away from the event
				local pPos = Player.pos
				local ePos = e.pos
				if (pPos) then
					if ( Distance2D ( pPos.x, pPos.y, ePos.x, ePos.y) > script.c_gotoEvent.range ) then
						return true					
					end
				end			
			end
		end
	end
	return false
end
function script.e_gotoEvent:execute()
	ml_log("script.e_gotoEvent")
	local eID = ml_task_hub:CurrentTask().eventID
	if ( tonumber(eID)~=nil ) then
		local evList = MapMarkerList("nearest,eventID="..eID)
		local i,e = next(evList)
		if ( i and e ) then
			local pPos = Player.pos
			local ePos = e.pos
			if (pPos and ePos) then
				ml_log(tostring(math.floor(Distance2D( pPos.x, pPos.y, ePos.x, ePos.y))))
				if ( script.c_gotoEvent.reached == false) then
					-- 1st time get into event range
					if ( Distance2D ( pPos.x, pPos.y, ePos.x, ePos.y) > 200 ) then
						local navResult = tostring(Player:MoveTo(ePos.x,ePos.y,ePos.z,125,false,false,true))		
						if (tonumber(navResult) < 0) then					
							ml_error("mc_ai_events.MoveInEventRange result: "..tonumber(navResult))					
						end
						return ml_log(true)
					else
						script.c_gotoEvent.reached = true
					end
					
				else
					-- Check if we moved too far away from the event we are in
					if ( Distance2D ( pPos.x, pPos.y, ePos.x, ePos.y) > script.c_gotoEvent.range ) then
						local navResult = tostring(Player:MoveTo(ePos.x,ePos.y,ePos.z,125,false,false,true))		
						if (tonumber(navResult) < 0) then					
							ml_error("mc_ai_events.MoveBackIntoEventRange result: "..tonumber(navResult))					
						end
						script.c_gotoEvent.reached = false
						return ml_log(true)
					end
				end
			end
		end
	end
	return ml_log(false)
end


script.c_reviveDownedPlayersInCombat = inheritsFrom( ml_cause )
script.e_reviveDownedPlayersInCombat = inheritsFrom( ml_effect )
function script.c_reviveDownedPlayersInCombat:evaluate()
	if ( Player.health.percent > 60 ) then		
		return TableSize(CharacterList("shortestpath,selectable,interactable,downed,friendly,player,onmesh,maxdistance=1000")) > 0
	end
	return false
end
function script.e_reviveDownedPlayersInCombat:execute()
	ml_log("e_reviveDownedPlayersInCombat")
	local CharList = CharacterList("shortestpath,selectable,interactable,downed,friendly,player,onmesh,maxdistance=1500")
	if ( TableSize(CharList) > 0 ) then
		local id,entity = next (CharList)
		if ( id and entity ) then
			
			if (not entity.isInInteractRange) then
				-- MoveIntoInteractRange
				local tPos = entity.pos
				if ( tPos ) then
					local navResult = tostring(Player:MoveTo(tPos.x,tPos.y,tPos.z,50,false,true,true))		
					if (tonumber(navResult) < 0) then
						ml_error("e_revive.MoveIntoCombatRange result: "..tonumber(navResult))					
					end
					ml_log("MoveToRevive..")
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
					if ( Player.profession == 8 ) then
						local skill = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_1)
						if ( skill ~= nil ) then
							if ( skill.skillID == 10554 ) then
								Player:CastSpell(GW2.SKILLBARSLOT.Slot_13) -- Leave Death Shroud
								return
							-- add more here if needed
							end
						end
					end
					
					Player:Interact( id )
					ml_log("Reviving..")
					mc_global.Wait(1000)
					return true
				end
			end
		end
	end
	return ml_log(false)	
end

script.c_revivePlayers = inheritsFrom( ml_cause )
script.e_revivePlayers = inheritsFrom( ml_effect )
function script.c_revivePlayers:evaluate()
	 return (not Player.inCombat and TableSize(CharacterList("nearest,selectable,interactable,dead,friendly,player,onmesh,maxdistance=1500")) > 0)
end
function script.e_revivePlayers:execute()
	ml_log("e_revivePlayers")
	local CharList = CharacterList("shortestpath,selectable,interactable,dead,friendly,player,onmesh,maxdistance=1500")
	if ( TableSize(CharList) > 0 ) then
		local id,entity = next (CharList)
		if ( id and entity ) then
			
			if (not entity.isInInteractRange) then
				-- MoveIntoInteractRange
				local tPos = entity.pos
				if ( tPos ) then
					local navResult = tostring(Player:MoveTo(tPos.x,tPos.y,tPos.z,50,false,true,true))		
					if (tonumber(navResult) < 0) then
						ml_error("e_revive.MoveIntoCombatRange result: "..tonumber(navResult))					
					end
					ml_log("MoveToRevive..")
					return true
				end
			else
				-- Grab that thing
				Player:StopMovement()
				local t = Player:GetTarget()
				if ( not t or t.id ~= id ) then
					Player:SetTarget( id )
				else
																				
					if ( Player.profession == 8 ) then
						local skill = Player:GetSpellInfo(GW2.SKILLBARSLOT.Slot_1)
						if ( skill ~= nil ) then
							if ( skill.skillID == 10554 ) then
								Player:CastSpell(GW2.SKILLBARSLOT.Slot_13) -- Leave Death Shroud
								return
							-- add more here if needed
							end
						end
					end
					
					Player:Interact( id )
					ml_log("Reviving..")
					mc_global.Wait(1000)
					return true
				end
			end
		end
	end
	return ml_log(false)	
end



script.c_MrUselessCheck = inheritsFrom( ml_cause )
script.e_MrUselessCheck = inheritsFrom( ml_effect )
script.c_MrUselessCheck.Tmr = 0
function script.c_MrUselessCheck:evaluate()
	if ( ml_task_hub:CurrentTask().Data["_btFollowCMD"] == "1" ) then
		local commList = MapMarkerList("iscommander,onmesh,nearest,exclude_characterid="..mc_blacklist.GetExcludeString(GetString("monsters")))
		local id, commander = next(commList)
		if (id and commander and commander.characterID ~= 0 and commander.distance < 750 and script.commanderReached == true) then		
			local cmd = CharacterList:Get(commander.characterID)
			if ( cmd and cmd.inCombat == false and Player.inCombat == false and cmd.movementstate == GW2.MOVEMENTSTATE.GroundNotMoving) then
				return true
			end
		end
		script.c_MrUselessCheck.Tmr = 0
	end
	return false
end
function script.e_MrUselessCheck:execute()
	ml_log("e_MrUselessCheck"..tostring(script.c_MrUselessCheck.Tmr - mc_global.now	))
	if ( script.c_MrUselessCheck.Tmr == 0 ) then 
		script.c_MrUselessCheck.Tmr = mc_global.now		
	elseif ( mc_global.now - script.c_MrUselessCheck.Tmr > 8000 and mc_global.now - script.c_MrUselessCheck.Tmr < 20000 and Player:IsMoving()== false) then 
		-- move a bit around
		local pPos = Player.pos
		local p = NavigationManager:GetRandomPointOnCircle(pPos.x,pPos.y,pPos.z,100,800)
		if ( p and Distance3D(p.x,p.y,p.z,pPos.x,pPos.y,pPos.z) > 100) then			
			Player:MoveTo(p.x,p.y,p.z,50,false,true,true)
			mc_global.Wait(1000)
		end
		
	elseif ( mc_global.now - script.c_MrUselessCheck.Tmr > 30000 and Player:IsMoving()== false) then
		-- Blacklist useless commander for 10 min
		local commList = MapMarkerList("iscommander,onmesh,nearest,exclude_characterid="..mc_blacklist.GetExcludeString(GetString("monsters")))
		local id, commander = next(commList)
		if (id and commander and commander.characterID ~= 0 and (commander.distance < 750 and script.commanderReached == true)) then		
			local cmd = CharacterList:Get(commander.characterID)
			if ( cmd ) then
				mc_blacklist.AddBlacklistEntry(GetString("monsters"), cmd.id, cmd.name, mc_global.now + 600000)
			end
		end
	end
	ml_log(false)
end
return script