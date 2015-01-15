-- Interact with Npc Quest, thanks etb
script = inheritsFrom( ml_task )
script.name = "DoEvent"
script.Data = {}

--******************
-- ml_quest_mgr Functions
--******************
function script:UIInit( identifier )
	GUI_NewField(ml_quest_mgr.stepwindow.name,"Event ID",tostring(identifier).."nEventID",GetString("questStepDetails"))
	GUI_NewButton(ml_quest_mgr.stepwindow.name,"Set Event ID",tostring(identifier).."SetEventID",GetString("questStepDetails"))
		
end

function script:SetData( identifier, tData )
	if ( identifier and tData ) then		
				
		self.Data = tData
		
		if ( self.Data["nEventID"] ) then
		_G[tostring(identifier).."nEventID"] = self.Data["nEventID"]
		end
	end
end

function script:EventHandler( identifier, event, value )
	if ( event == "SetEventID" ) then
		local evList = MapMarkerList("nearest,isevent,onmesh,worldmarkertype="..mc_global.WorldMarkerType)
		local i,e = next(evList)
			if ( i and e ) then
				self.Data["nEventID"] = e.eventID
				
				-- Update UI fields
				_G[tostring(identifier).."nEventID"] = e.eventID
				return true
			end
		return false
	end
end
		

--******************
-- ml_Task Functions
--******************
script.valid = true
script.completed = false
script.subtask = nil
script.process_elements = {}
script.overwatch_elements = {} 
script.eventID = nil	
  

function script:Init()
    -- Add Cause&Effects here

	self:add(ml_element:create( "Dead", c_dead, e_dead, 300 ), self.process_elements)
	
	-- Downed
	self:add(ml_element:create( "Downed", c_downed, e_downed, 280 ), self.process_elements)
	
	-- AoELooting Characters
	self:add(ml_element:create( "AoELoot", c_AoELoot, e_AoELoot, 260 ), self.process_elements)
		
	-- Move InRange of Event
	self:add(ml_element:create( "MovingToEvent", c_MoveInEventRange, e_MoveInEventRange, 220 ), self.process_elements)
			
	-- Aggro
	self:add(ml_element:create( "Aggro", c_Aggro, e_Aggro, 160 ), self.process_elements) --reactive queue
		
	-- Normal Chests	
	self:add(ml_element:create( "LootingChest", c_event_LootChests, e_LootChests, 155 ), self.process_elements)
	
	-- Resting
	self:add(ml_element:create( "Resting", c_resting, e_resting, 145 ), self.process_elements)	

	-- Normal Looting
	self:add(ml_element:create( "Looting", c_event_LootCheck, e_Loot, 130 ), self.process_elements)

	-- Deposit Items
	self:add(ml_element:create( "DepositingItems", c_deposit, e_deposit, 120 ), self.process_elements)	
			
	-- Salvaging
	self:add(ml_element:create( "Salvaging", c_salvage, e_salvage, 75 ), self.process_elements)

	-- ReviveNPCs
	self:add(ml_element:create( "ReviveNPC", c_event_reviveNPC, e_reviveNPC, 70 ), self.process_elements)	
	
	-- Do EventObjectives
	self:add(ml_element:create( "DoEventObjectives", c_DoEventObjectives, e_DoEventObjectives, 60 ), self.process_elements)	

	self:AddTaskCheckCEs()
end


function script:task_complete_eval()	

	
	local eID = ml_task_hub:CurrentTask().Data["nEventID"]
	if ( eID == nil or TableSize(MapMarkerList("onmesh,eventID="..eID))==0 ) then
		c_MoveInEventRange.range = 150
		c_MoveInEventRange.reached = false
		return true
	end
	return false
end

function script:task_complete_execute()
   self.completed = true
end



-- Cause&Effect
script.c_MoveInEventRange = inheritsFrom( ml_cause )
script.e_MoveInEventRange = inheritsFrom( ml_effect )
script.c_MoveInEventRange.reached = false
script.c_MoveInEventRange.range = 2500 -- gets changed depending what objective we have

function script.c_MoveInEventRange:evaluate()
	local eID = ml_task_hub:CurrentTask().Data["nEventID"]
	if ( tonumber(eID)~=nil ) then
		local evList = MapMarkerList("nearest,eventID="..eID)
		local i,e = next(evList)
		if ( i and e ) then
			if ( c_MoveInEventRange.reached == false) then
				return true
			else
				-- Check if we moved too far away from the event
				local pPos = Player.pos
				local ePos = e.pos
				if (pPos) then
					if ( Distance2D ( pPos.x, pPos.y, ePos.x, ePos.y) > c_MoveInEventRange.range ) then
						return true					
					end
				end			
			end
		end
	end
	return false
end
function script.e_MoveInEventRange:execute()
	ml_log("e_MoveInEventRange")
	local eID = ml_task_hub:CurrentTask().Data["nEventID"]
	if ( tonumber(eID)~=nil ) then
		local evList = MapMarkerList("nearest,eventID="..eID)
		local i,e = next(evList)
		if ( i and e ) then
			local pPos = Player.pos
			local ePos = e.pos
			if (pPos and ePos) then
				ml_log(tostring(math.floor(Distance2D( pPos.x, pPos.y, ePos.x, ePos.y))))
				if ( c_MoveInEventRange.reached == false) then
					-- 1st time get into event range
					if ( Distance2D ( pPos.x, pPos.y, ePos.x, ePos.y) > 350 ) then
						local navResult = tostring(Player:MoveTo(ePos.x,ePos.y,ePos.z,35,false,false,true))		
						if (tonumber(navResult) < 0) then					
							ml_error("DoEvent.MoveInEventRange result: "..tonumber(navResult))					
						end
						return ml_log(true)
					else
						c_MoveInEventRange.reached = true
					end
					
				else
					-- Check if we moved too far away from the event we are in
					if ( Distance2D ( pPos.x, pPos.y, ePos.x, ePos.y) > c_MoveInEventRange.range ) then
						local navResult = tostring(Player:MoveTo(ePos.x,ePos.y,ePos.z,35,false,false,true))		
						if (tonumber(navResult) < 0) then					
							ml_error("DoEvent.MoveBackIntoEventRange result: "..tonumber(navResult))					
						end
						c_MoveInEventRange.reached = false
						return ml_log(true)
					end
				end
			end
		end
	end
	return ml_log(false)
end


script.c_DoEventObjectives = inheritsFrom( ml_cause )
script.e_DoEventObjectives = inheritsFrom( ml_effect )

function script.c_DoEventObjectives:evaluate()
	local eID = ml_task_hub:CurrentTask().Data["nEventID"]
	if ( tonumber(eID)~=nil ) then
		local evList = MapMarkerList("nearest,eventID="..eID)
		if ( TableSize(evList)>0) then
			local i,e = next(evList)
			if ( i and e ) then
				return true		
			end
		end
	end
	return false
end
function script.e_DoEventObjectives:execute()
	ml_log("e_DoEventObjectives")
	local eID = ml_task_hub:CurrentTask().Data["nEventID"]
	if ( tonumber(eID)~=nil ) then
		local evList = MapMarkerList("nearest,eventID="..eID)
		if ( TableSize(evList)>0) then
			local i,e = next(evList)
			if ( i and e ) then
			
				--pick out the first objective
				local evo = e.eventobjectivelist				
				if ( evoList ) then
					local oid,obj = next(evoList)
					if ( oid and obj ) then
						local objType = obj.type
						-- Add seperate SubTasks here...if you want lol
						if ( objType == GW2.OBJECTIVETYPE.BreakMoral ) then 
						ml_log("OBJECTIVETYPE.BreakMoral")
						c_MoveInEventRange.range = 3000
						
						elseif ( objType == GW2.OBJECTIVETYPE.CaptureLocation ) then
						ml_log("OBJECTIVETYPE.CaptureLocation")
						c_MoveInEventRange.range = 2500
						
						elseif ( objType == GW2.OBJECTIVETYPE.CollectItems ) then 
						ml_log("OBJECTIVETYPE.CollectItems")
						c_MoveInEventRange.range = 4000
						
						elseif ( objType == GW2.OBJECTIVETYPE.Counter ) then 
						ml_log("OBJECTIVETYPE.Counter")
						-- obj.value1 = 0 when multiple enemies, when 1 enemy then it is the ID of that
						-- obj.value2 = countermax
						-- obj.value4 = currentcount
						c_MoveInEventRange.range = 3000
						-- Kill Main Boss
						local target = nil						
						if ( obj.value1 and obj.value1 ~= 0 ) then
							target = CharacterList:Get(obj.value1)
							if ( not target ) then
								target = GadgetList:Get(obj.value1)
							end
							if ( target ) then
								local t = Player:GetTarget()
								if ( t and t.id ~= target.id ) then
									return Player:SetTarget(t.id)
								end
							end
						end
						return ml_log(true)
						elseif ( objType == GW2.OBJECTIVETYPE.KillCount ) then 
						ml_log("OBJECTIVETYPE.KillCount")
						-- value 4 = kills left ?
						c_MoveInEventRange.range = 3000
						
						elseif ( objType == GW2.OBJECTIVETYPE.Cull ) then 
						ml_log("OBJECTIVETYPE.Cull")
						-- valie 1 and 2 , possibly scaling values ?
						-- value 4 = amount of objects/enemies remaining 
						c_MoveInEventRange.range = 3000
						
						elseif ( objType == GW2.OBJECTIVETYPE.DefendGadget ) then 
						ml_log("OBJECTIVETYPE.DefendGadget")
						c_MoveInEventRange.range = 2500
						
						elseif ( objType == GW2.OBJECTIVETYPE.Escort ) then 
						c_MoveInEventRange.range = 1500
						ml_log("OBJECTIVETYPE.Escort")
						--Value 4 = ID to escort
						if ( obj.value4 and obj.value4 ~= 0 ) then
							target = CharacterList:Get(obj.value4)
							if ( not target ) then
								target = GadgetList:Get(obj.value4)
							end
							if ( target ) then
								-- Make sure our Target is alive, else revive
								if ( (target.downed or target.dead) and Player.health.percent > 50 and target.distance < 3000) then
									if (not target.isInInteractRange) then
										local tPos = target.pos
										if ( tPos ) then
											Player:MoveTo(tPos.x,tPos.y,tPos.z,35,false,true,true)
											return true
										end
									else
										Player:StopMovement()
										local t = Player:GetTarget()
										if ( not t or t.id ~= id ) then
											Player:SetTarget( id )
										else
											if ( Player:GetCurrentlyCastedSpell() == 17 ) then								
												Player:Interact( id )
												ml_log("Reviving..")
												mc_global.Wait(1000)
												return true
											end	
										end
									end
								end
							end
						end
						
						elseif ( objType == GW2.OBJECTIVETYPE.EventStatus ) then 
						ml_log("OBJECTIVETYPE.EventStatus")
						c_MoveInEventRange.range = 2500
						
						elseif ( objType == GW2.OBJECTIVETYPE.InteractWithGadget ) then 
						ml_log("OBJECTIVETYPE.InteractWithGadget")
						c_MoveInEventRange.range = 3500
						
						elseif ( objType == GW2.OBJECTIVETYPE.Intimidate ) then 
						ml_log("OBJECTIVETYPE.Intimidate")
						c_MoveInEventRange.range = 3500
						-- value1 == ID of enemy to "intimidate" if there is only 1 
						-- value2 = amount of enemies to intimidate (?)
						elseif ( objType == GW2.OBJECTIVETYPE.IntimidateScaled ) then 
						ml_log("OBJECTIVETYPE.IntimidateScaled")
						c_MoveInEventRange.range = 3500
						
						elseif ( objType == GW2.OBJECTIVETYPE.RepairGadget ) then 
						ml_log("OBJECTIVETYPE.RepairGadget")
						c_MoveInEventRange.range = 3500
						
						elseif ( objType == GW2.OBJECTIVETYPE.Timer ) then 
						ml_log("OBJECTIVETYPE.Timer")
						c_MoveInEventRange.range = 3500
						
						-- value2 = current timer (counting down from value3 to 0 in ms)
						-- value3 = start timer value 
						elseif ( objType == GW2.OBJECTIVETYPE.Tripwire ) then 
						ml_log("OBJECTIVETYPE.Tripwire")
						c_MoveInEventRange.range = 2500
						
						elseif ( objType == GW2.OBJECTIVETYPE.WvwHold ) then 
						ml_log("OBJECTIVETYPE.WvwHold")
						c_MoveInEventRange.range = 2500
						
						elseif ( objType == GW2.OBJECTIVETYPE.WvwOrbResetTimer ) then 
						ml_log("OBJECTIVETYPE.WvwOrbResetTimer")
						c_MoveInEventRange.range = 4500
						
						elseif ( objType == GW2.OBJECTIVETYPE.WvwUpgrade ) then 
						ml_log("OBJECTIVETYPE.WvwUpgrade")
						c_MoveInEventRange.range = 4500
						
						else
							ml_error("Unhandled EventType !!!! : "..tostring(objType))
						end
					end						
				end
			end
		end
	end
	
	--
							-- Kill
						if ( c_NeedValidTarget:evaluate() ) then 
							e_SearchTarget:execute()
						else
							if ( c_MoveIntoCombatRange:evaluate() ) then
								e_MoveIntoCombatRange:execute()
							else
								e_KillTarget:execute()
							end
						end
	
	return ml_log(false)
end


-- Special Causes for Events, this is needed to not make the char wander away
script.c_event_LootChests = inheritsFrom( ml_cause )
function script.c_event_LootChests:evaluate()
	if ( Inventory.freeSlotCount > 0 ) then
		local eID = ml_task_hub:CurrentTask().Data["nEventID"]
		if ( tonumber(eID)~=nil ) then
			local evList = MapMarkerList("nearest,eventID="..eID)
			local i,e = next(evList)
			if ( i and e ) then
				local ePos = e.pos
				if (ePos) then
				
					local GList = GadgetList("onmesh,lootable,maxdistance=4000")
					if ( TableSize( GList ) > 0 ) then			
						local index, LT = next( GList )
						while ( index ~= nil and LT~=nil ) do
							local gPos = LT.pos
							if ( LT.selectable and (LT.contentID == 17698 or LT.contentID == 198260 or LT.contentID == 232192 or LT.contentID == 232193 or LT.contentID == 232194 or LT.contentID == 262863 or LT.contentID == 236384) 
								and gPos~= nil and Distance2D( gPos.x, gPos.y, ePos.x, ePos.y) < c_MoveInEventRange.range) then --or LT.contentID == 41638
								d("CHEST: "..tostring(LT.name).." "..tostring(LT.distance).." "..tostring(LT.contentID).." "..tostring(LT.lootable).." "..tostring(index))
								return true
							end
							index, LT = next( GList,index )
						end
					end
				end
			end
		end
	end
	return false
end

script.c_event_LootCheck = inheritsFrom( ml_cause )
function script.c_event_LootCheck:evaluate()
	if ( Inventory.freeSlotCount > 0 ) then
		local LList = CharacterList("shortestpath,lootable,onmesh")
		if ( TableSize(LList) > 0 ) then
			local eID = ml_task_hub:CurrentTask().Data["nEventID"]
			if ( tonumber(eID)~=nil ) then
				local evList = MapMarkerList("nearest,eventID="..eID)
				local i,e = next(evList)
				if ( i and e ) then
					local ePos = e.pos
					if (ePos) then
					
						local id, entity = next( LList )
						while ( id ~= nil and entity~=nil ) do
							local gPos = entity.pos
							if ( gPos ) then 
								if ( c_MoveInEventRange.range < 1200 ) then
									if ( Distance2D( gPos.x, gPos.y, ePos.x, ePos.y) < 1500) then
										return true
									end
								else
									if ( Distance2D( gPos.x, gPos.y, ePos.x, ePos.y) < c_MoveInEventRange.range) then
										return true
									end
								end
							end
							id, entity = next( LList,id )
						end
					end
				end
			end
		end
	end
	return false
end

script.c_event_reviveNPC = inheritsFrom( ml_cause )
function script.c_event_reviveNPC:evaluate()
	if ( Player.inCombat == false ) then
		local CList = CharacterList("shortestpath,selectable,interactable,dead,friendly,npc,onmesh,maxdistance=2500")
		if ( TableSize(CList) > 0 ) then
			local eID = ml_task_hub:CurrentTask().Data["nEventID"]
			if ( tonumber(eID)~=nil ) then
				local evList = MapMarkerList("nearest,eventID="..eID)
				local i,e = next(evList)
				if ( i and e ) then
					local ePos = e.pos
					if (ePos) then
					
						local id, entity = next( CList )
						while ( id ~= nil and entity~=nil ) do
							local gPos = entity.pos
							if ( gPos ) then 
								if ( c_MoveInEventRange.range < 1200 ) then
									if ( Distance2D( gPos.x, gPos.y, ePos.x, ePos.y) < 1500) then
										return true
									end
								else
									if ( Distance2D( gPos.x, gPos.y, ePos.x, ePos.y) < c_MoveInEventRange.range) then
										return true
									end
								end
							end
							id, entity = next( CList,id )
						end
					end
				end
			end
		end
	end
	return false
end


return script