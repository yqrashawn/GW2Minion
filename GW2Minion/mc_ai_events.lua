-- Handles Events
mc_ai_events = {}

mc_ai_event = inheritsFrom(ml_task)
mc_ai_event.name = "DoEvent"

function mc_ai_event.Create()
	local newinst = inheritsFrom(mc_ai_event)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}
    newinst.eventID = nil	
    return newinst
end

function mc_ai_event:Init()
	d("mc_ai_eventINIT")
	-- Dead?
	self:add(ml_element:create( "Dead", c_dead, e_dead, 300 ), self.process_elements)
	
	-- Downed
	self:add(ml_element:create( "Downed", c_downed, e_downed, 280 ), self.process_elements)
	
	-- AoELooting Characters
	self:add(ml_element:create( "AoELoot", c_AoELoot, e_AoELoot, 260 ), self.process_elements)
		
	-- AoELooting Gadgets/Chests needed ?
	
	
	-- Revive PartyMember
	
	
	-- Move InRange of Event
	self:add(ml_element:create( "MovingToEvent", c_MoveInEventRange, e_MoveInEventRange, 220 ), self.process_elements)
			
	-- Aggro
	self:add(ml_element:create( "Aggro", c_Aggro, e_Aggro, 160 ), self.process_elements) --reactive queue
		
	-- Normal Chests	
	self:add(ml_element:create( "LootingChest", c_LootChests, e_LootChests, 155 ), self.process_elements)
	
	-- Resting
	self:add(ml_element:create( "Resting", c_resting, e_resting, 145 ), self.process_elements)	

	-- Normal Looting
	self:add(ml_element:create( "Looting", c_Loot, e_Loot, 130 ), self.process_elements)

	-- Deposit Items
	self:add(ml_element:create( "DepositingItems", c_deposit, e_deposit, 120 ), self.process_elements)	
			
	-- Salvaging
	self:add(ml_element:create( "Salvaging", c_salvage, e_salvage, 75 ), self.process_elements)

	-- ReviveNPCs
	self:add(ml_element:create( "ReviveNPC", c_reviveNPC, e_reviveNPC, 70 ), self.process_elements)	
	
	-- Do EventObjectives
	self:add(ml_element:create( "DoEventObjectives", c_DoEventObjectives, e_DoEventObjectives, 60 ), self.process_elements)	
			
	-- Killsomething nearby					
	-- Valid Target
	self:add(ml_element:create( "SearchingTarget", c_NeedValidTarget, e_SearchTarget, 50 ), self.process_elements)
		
	-- Get into Combat Range
	self:add(ml_element:create( "MovingIntoCombatRange", c_MoveIntoCombatRange, e_MoveIntoCombatRange, 25 ), self.process_elements)
	
	-- Kill Target
	self:add(ml_element:create( "KillTarget", c_KillTarget, e_KillTarget, 10 ), self.process_elements)
	
	
	self:AddTaskCheckCEs()
end
function mc_ai_event:task_complete_eval()
	local eID = ml_task_hub:CurrentTask().eventID
	
	return eID == nil or TableSize(MapMarkerList("onmesh,eventID="..eID))==0
end

function mc_ai_event:task_complete_execute()
   self.completed = true
end


-- For adding a doEvent Subtask
c_doEvents = inheritsFrom( ml_cause )
e_doEvents = inheritsFrom( ml_effect )
function c_doEvents:evaluate()	
	local evList = MapMarkerList("nearest,isevent,onmesh,worldmarkertype="..mc_global.WorldMarkerType..",exclude_eventid="..mc_blacklist.GetExcludeString(GetString("event")))
	local i,e = next(evList)
	if ( i and e ) then
		local evi = e.eventinfo
		if ( evi and evi.level <= Player.level + 3 ) then
			return true
		end
	end
	return false
end
function e_doEvents:execute()
	ml_log("e_doEvents")
	local evList = MapMarkerList("nearest,isevent,onmesh,worldmarkertype="..mc_global.WorldMarkerType..",exclude_eventid="..mc_blacklist.GetExcludeString(GetString("event")))
	if ( i and e ) then
		local evi = e.eventinfo
		if ( evi and evi.level <= Player.level + 3 ) then
			local newTask = mc_ai_event.Create()
			newTask.eventID = e.eventID
			ml_task_hub:CurrentTask():AddSubTask(newTask)
			return ml_log(true)
		end
	end
	return ml_log(false)
end


c_MoveInEventRange = inheritsFrom( ml_cause )
e_MoveInEventRange = inheritsFrom( ml_effect )
c_MoveInEventRange.reached = false
c_MoveInEventRange.range = 750 -- gets changed depending what objective we have
function c_MoveInEventRange:evaluate()
	local eID = ml_task_hub:CurrentTask().eventID
	if ( tonumber(eID)~=nil ) then
		local evList = MapMarkerList("eventID="..eID)
		local i,e = next(evList)
		if ( i and e ) then
			if ( not c_MoveInEventRange.reached ) then
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
function e_MoveInEventRange:execute()
	ml_log("e_MoveInEventRange")
	local eID = ml_task_hub:CurrentTask().eventID
	if ( tonumber(eID)~=nil ) then
		local evList = MapMarkerList("eventID="..eID)
		local i,e = next(evList)
		if ( i and e ) then
			local pPos = Player.pos
			local ePos = e.pos
			if (pPos and ePos) then
				if ( Distance2D ( pPos.x, pPos.y, ePos.x, ePos.y) > 1500 ) then
					c_MoveInEventRange.reached = false
					local navResult = tostring(Player:MoveTo(ePos.x,ePos.y,ePos.z,math.random(100,1000),false,false,true))		
					if (tonumber(navResult) < 0) then					
						ml_error("mc_ai_events.MoveInEventRange result: "..tonumber(navResult))					
					end
				else
					c_MoveInEventRange.reached = true
				end
			end
		end
	end
	return ml_log(false)
end


c_DoEventObjectives = inheritsFrom( ml_cause )
e_DoEventObjectives = inheritsFrom( ml_effect )
function c_DoEventObjectives:evaluate()
	local eID = ml_task_hub:CurrentTask().eventID
	if ( tonumber(eID)~=nil ) then
		local evList = MapMarkerList("eventID="..eID)
		if ( TableSize(evList)>0) then
			local i,e = next(evList)
			if ( i and e ) then
				return true		
			end
		end
	end
	return false
end
function e_DoEventObjectives:execute()
	ml_log("e_DoEventObjectives")
	local eID = ml_task_hub:CurrentTask().eventID
	if ( tonumber(eID)~=nil ) then
		local evList = MapMarkerList("eventID="..eID)
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
						elseif ( objType == GW2.OBJECTIVETYPE.CaptureLocation ) then
						ml_log("OBJECTIVETYPE.CaptureLocation")
						elseif ( objType == GW2.OBJECTIVETYPE.CollectItems ) then 
						ml_log("OBJECTIVETYPE.CollectItems")
						elseif ( objType == GW2.OBJECTIVETYPE.Counter ) then 
						ml_log("OBJECTIVETYPE.Counter")
						-- obj.value1 = 0 when multiple enemies, when 1 enemy then it is the ID of that
						-- obj.value2 = countermax
						-- obj.value4 = currentcount
						c_MoveInEventRange.range = 2500
						-- Kill Main Boss
						local target = nil						
						if ( obj.value1 and obj.value1 ~= 0 ) then
							target = CharacterList:Get(obj.value1)
							if ( not target ) then
								target = GadgetList:Get(obj.value1)
							end
							local t = Player:GetTarget()
							if ( t and t.id ~= target.id ) then
								return Player:SetTarget(t.id)
							end
						end
						return ml_log(true)
						elseif ( objType == GW2.OBJECTIVETYPE.KillCount ) then 
						ml_log("OBJECTIVETYPE.KillCount")
						elseif ( objType == GW2.OBJECTIVETYPE.Cull ) then 
						ml_log("OBJECTIVETYPE.Cull")
						elseif ( objType == GW2.OBJECTIVETYPE.DefendGadget ) then 
						ml_log("OBJECTIVETYPE.DefendGadget")
						elseif ( objType == GW2.OBJECTIVETYPE.Escort ) then 
						c_MoveInEventRange.range = 1500
						ml_log("OBJECTIVETYPE.Escort")
						elseif ( objType == GW2.OBJECTIVETYPE.EventStatus ) then 
						ml_log("OBJECTIVETYPE.EventStatus")
						elseif ( objType == GW2.OBJECTIVETYPE.InteractWithGadget ) then 
						ml_log("OBJECTIVETYPE.InteractWithGadget")
						elseif ( objType == GW2.OBJECTIVETYPE.Intimidate ) then 
						ml_log("OBJECTIVETYPE.Intimidate")
						elseif ( objType == GW2.OBJECTIVETYPE.IntimidateScaled ) then 
						ml_log("OBJECTIVETYPE.IntimidateScaled")
						elseif ( objType == GW2.OBJECTIVETYPE.RepairGadget ) then 
						ml_log("OBJECTIVETYPE.RepairGadget")
						elseif ( objType == GW2.OBJECTIVETYPE.Timer ) then 
						ml_log("OBJECTIVETYPE.Timer")
						elseif ( objType == GW2.OBJECTIVETYPE.Tripwire ) then 
						ml_log("OBJECTIVETYPE.Tripwire")
						elseif ( objType == GW2.OBJECTIVETYPE.WvwHold ) then 
						ml_log("OBJECTIVETYPE.WvwHold")
						elseif ( objType == GW2.OBJECTIVETYPE.WvwOrbResetTimer ) then 
						ml_log("OBJECTIVETYPE.WvwOrbResetTimer")
						elseif ( objType == GW2.OBJECTIVETYPE.WvwUpgrade ) then 
						ml_log("OBJECTIVETYPE.WvwUpgrade")
						else
							ml_error("Unhandled EventType !!!! : "..tostring(objType))
						end
												
						-- KillKillKill lol
						if ( c_NeedValidTarget:evaluate() ) then 
							e_SearchTarget:execute()
						else
							if ( c_MoveIntoCombatRange:evaluate() then
								e_MoveIntoCombatRange:execute()
							else
								e_KillTarget:execute()
							end
						end
					end						
				end
			end
		end
	end
	return ml_log(false)
end