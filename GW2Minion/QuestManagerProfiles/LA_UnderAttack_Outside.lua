-- Big Thanks to Jorith!!
script = inheritsFrom( ml_task )
script.name = "LA_UnderAttack_Outside"
script.Data = {}

--******************
-- ml_quest_mgr Functions
--******************
function script:UIInit( identifier )
	-- You need to create the ScriptUI Elements exactly like you see here, the "event" needs to start with "tostring(identifier).." and the group needs to be GetString("questStepDetails")
	
end

function script:SetData( identifier, tData )
	-- Save the data in our script-"instance" aka global variables and set the UI elements
	if ( identifier and tData ) then
		--d("script:SetData: "..tostring(identifier))
		self.Data = tData
		
		-- Update the script UI (make sure the Data assigning to a _G is NOT nil! else crashboooombang!)
		
	end
end

function script:EventHandler( identifier, event )
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
	--self:add(ml_element:create( "Dead", c_dead, e_dead, 225 ), self.process_elements)
	
	-- Downed
	self:add(ml_element:create( "Downed", c_downed, e_downed, 200 ), self.process_elements)
	
	-- AoELooting Characters
	self:add(ml_element:create( "AoELoot", c_AoELoot, e_AoELoot, 175 ), self.process_elements)
	
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
	
	-- Repair & Vendoring
	self:add(ml_element:create( "QuickSellItems", c_quickvendorsell, e_quickvendorsell, 100 ), self.process_elements)
	self:add(ml_element:create( "QuickBuyItems", c_quickbuy, e_quickbuy, 99 ), self.process_elements)
	self:add(ml_element:create( "QuickRepairItems", c_quickrepair, e_quickrepair, 98 ), self.process_elements)
	
	
	-- Goto Portal
	self:add(ml_element:create( "GoToPortal", self.c_gotoPortal, self.e_gotoPortal, 80 ), self.process_elements)
	
	--Revive Other Players
	self:add(ml_element:create( "RevivePlayers", self.c_revivePlayers, self.e_revivePlayers, 55 ), self.process_elements)

	-- Defend
	self:add(ml_element:create( "Aggro", c_Aggro, e_Aggro, 35 ), self.process_elements) --reactive queue
	
	-- Waitfor Event / Walk into portal
	self:add(ml_element:create( "WaitForEvent", self.c_eventCheck, self.e_eventCheck, 25 ), self.process_elements)
	
	-- Stay near Portal
	self:add(ml_element:create( "GoToPortal", self.c_staynearPortal, self.e_staynearPortal, 10 ), self.process_elements)	


	self:AddTaskCheckCEs()
end


function script:task_complete_eval()
	return Player:GetLocalMapID() ~= 27
end
function script:task_complete_execute()
   self.completed = true
end



-- Cause&Effect
script.c_gotoPortal = inheritsFrom( ml_cause )
script.e_gotoPortal = inheritsFrom( ml_effect )
script.portalEntry = { x=-18071, y=14552, z=-5197 }
function script.c_gotoPortal:evaluate()
	local pPos = Player.pos
	if ( pPos and Player.inCombat == false and script.c_eventDone == true ) then
		return true
	end
	return false
end
function script.e_gotoPortal:execute()
	ml_log("e_gotoPortal")
	local pPos = Player.pos
	if ( pPos ) then
		if (script.c_eventDone == true) then
			if ( Distance3D( pPos.x, pPos.y, pPos.z, script.portalEntry.x,script.portalEntry.y,script.portalEntry.z)< 35 ) then
				d("Trying to enter Portal")
				script.c_eventDone = false				
			else
				-- Player:MoveTo(x,y,z,stoppingdistance,navsystem(normal/follow),navpath(straight/random),smoothturns)
				if (tonumber(Player:MoveTo(script.portalEntry.x,script.portalEntry.y,script.portalEntry.z, 25, false, false, true)) < 0) then
					ml_error("e_gotoPortal result: ")					
				end 
			end
		end
	end
end


script.c_revivePlayers = inheritsFrom( ml_cause )
script.e_revivePlayers = inheritsFrom( ml_effect )
function script.c_revivePlayers:evaluate()
    return (not Player.inCombat and TableSize(CharacterList("shortestpath,selectable,interactable,dead,friendly,player,onmesh,maxdistance=2500")) > 0)
end
function script.e_revivePlayers:execute()
	ml_log("e_revivePlayers")
	local CharList = CharacterList("shortestpath,selectable,interactable,dead,friendly,player,onmesh,maxdistance=2500")
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
	return ml_log(false)	
end


script.c_eventCheck = inheritsFrom( ml_cause )
script.c_eventDone = true
script.c_eventRunning = false
script.e_eventCheck = inheritsFrom( ml_effect )
function script.c_eventCheck:evaluate()
	if ( TableSize(MapMarkerList("nearest,isevent,eventID=3156,onmesh,worldmarkertype="..mc_global.WorldMarkerType))>0) then 
	    script.c_eventRunning = true
		return (not Player.inCombat and (script.c_eventRunning == true ))
	end
	if ( not Player.inCombat and (script.c_eventRunning == true )) then
		return true
	end
	return false
end
function script.e_eventCheck:execute()
	ml_log("e_eventCheck")
	local event = MapMarkerList("nearest,isevent,eventID=3156,onmesh,worldmarkertype="..mc_global.WorldMarkerType)
	if ( TableSize(event) > 0 ) then
		script.c_eventRunning = true
		
		-- Attack/Defend here?

		return ml_log(true)
		
	else
		-- The event must be finished now
		script.c_eventDone = true
		script.c_eventRunning = false
	end
	return ml_log(false)	
end



-- stay near portal 
script.portalReached = false
script.portalPos = { x=-18071, y=14552, z=-5197 }
script.c_staynearPortal = inheritsFrom( ml_cause )
script.e_staynearPortal = inheritsFrom( ml_effect )
function script.c_staynearPortal:evaluate()
	local pPos = Player.pos
	if ( pPos and Player.inCombat == false and (script.portalReached == false or Distance2D( pPos.x, pPos.y, pPos.z, script.portalPos.x,script.portalPos.y,script.portalPos.z)> 1500 ) ) then
		mc_ai_unstuck.idlecounter = 0
		return true
	end
	return false
end
function script.e_staynearPortal:execute()
	ml_log("e_staynearPortal")
	local pPos = Player.pos
	if ( pPos ) then
		if (script.portalReached == false or Distance2D( pPos.x, pPos.y, pPos.z, script.portalPos.x,script.portalPos.y,script.portalPos.z)> 1500 ) then
			-- Player:MoveTo(x,y,z,stoppingdistance,navsystem(normal/follow),navpath(straight/random),smoothturns)
			Player:MoveTo(script.portalPos.x,script.portalPos.y,script.portalPos.z, 200, false, false, true)
			script.portalReached = false
		else
			script.portalReached = true
			Player:StopMovement()
		end
	end
end


return script