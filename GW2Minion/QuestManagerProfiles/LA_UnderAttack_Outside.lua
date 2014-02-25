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
	self:add(ml_element:create( "SellItems", c_vendorsell, e_vendorsell, 105 ), self.process_elements)
	self:add(ml_element:create( "BuyItems", c_vendorbuy, e_vendorbuy, 104 ), self.process_elements)
	self:add(ml_element:create( "RepairItems", c_vendorrepair, e_vendorrepair, 103 ), self.process_elements)
	
	-- Quick Repair & Vendoring
	self:add(ml_element:create( "QuickSellItems", c_quickvendorsell, e_quickvendorsell, 100 ), self.process_elements)
	self:add(ml_element:create( "QuickBuyItems", c_quickbuy, e_quickbuy, 99 ), self.process_elements)
	self:add(ml_element:create( "QuickRepairItems", c_quickrepair, e_quickrepair, 98 ), self.process_elements)
	
	--Revive Other Players
	self:add(ml_element:create( "RevivePlayers", self.c_revivePlayers, self.e_revivePlayers, 80 ), self.process_elements)
	
	-- Goto Portal
	self:add(ml_element:create( "GoToPortal", self.c_gotoPortal, self.e_gotoPortal, 70 ), self.process_elements)
	
	-- Defend
	self:add(ml_element:create( "Aggro", c_Aggro, e_Aggro, 35 ), self.process_elements) --reactive queue
	
	-- Stay near Portal
	self:add(ml_element:create( "GoToPortal", self.c_staynearPortal, self.e_staynearPortal, 10 ), self.process_elements)


	self:AddTaskCheckCEs()
end


function script:task_complete_eval()
	return (Player:GetLocalMapID() ~= 27 and Player:GetLocalMapID() ~= 24 and Player:GetLocalMapID() ~= 73)
end
function script:task_complete_execute()
   self.completed = true
end



-- Cause&Effect
-- goto portal
script.c_gotoPortal = inheritsFrom( ml_cause )
script.e_gotoPortal = inheritsFrom( ml_effect )
script.localMapID = Player:GetLocalMapID()
script.gate = {
				[27] = { --lornar
						eventid = 3156,
						gateid = 517,
						entryPos = { x = -18071, y = 14552, z = -5197 },
						waitPos = { x= -18333, y= 13575, z= -4940 },
				},
				[24] = { --gendarren
						eventid = 5757,
						gateid = 385,
						entryPos = { x = 9431, y = -21749, z = -108 },
						waitPos = { x= 9050, y= -17937, z= -101 },
				},
				[73] = { --bloodtide
						eventid = 5289,
						gateid = 471,
						entryPos = { x = 9174, y = 38746, z = -856 },
						waitPos = { x= 8474, y= 38266, z= -684 },
				},
}
function script.c_gotoPortal:evaluate()
	local pPos = Player.pos
	local gateOpen = (GadgetList:Get(script.gate[script.localMapID].gateid) and GadgetList:Get(script.gate[script.localMapID].gateid).isUnknown1 == 463)
	return ( pPos and gateOpen and not Player.inCombat and script.gate[script.localMapID] and TableSize(MapMarkerList("nearest,isevent,eventID="..script.gate[script.localMapID].eventid..",onmesh,worldmarkertype="..mc_global.WorldMarkerType)) == 0 )
end
function script.e_gotoPortal:execute()
	ml_log("e_gotoPortal")
	local pPos = Player.pos
	local gPos = script.gate[script.localMapID].entryPos --GatePosition, entry point
	if ( pPos ) then
		if (tonumber(Player:MoveTo(gPos.x,gPos.y,gPos.z, 20, false, false, true)) < 0) then
			ml_error("e_gotoPortal result: ")
		end 
	end
end

-- stay near portal 
script.waitPosReached = false
script.randomWaitPos = nil -- Will hold random place around waitPos.
script.c_staynearPortal = inheritsFrom( ml_cause )
script.e_staynearPortal = inheritsFrom( ml_effect )
function script.c_staynearPortal:evaluate()
	local pPos, wPos = Player.pos, script.gate[script.localMapID].waitPos
	if ( pPos and wPos and Player.inCombat == false and Distance2D( pPos.x, pPos.y, wPos.x, wPos.y) > 400) then
		return true
	end
	mc_ai_unstuck.idlecounter = 0
	return false
end
function script.e_staynearPortal:execute()
	ml_log("e_staynearPortal")
	local pPos, wPos = Player.pos, script.gate[script.localMapID].waitPos
	if (not script.randomWaitPos or Distance2D(script.randomWaitPos.x, script.randomWaitPos.y, wPos.x, wPos.y) < 200) then
		script.randomWaitPos = NavigationManager:GetRandomPointOnCircle(wPos.x, wPos.y, wPos.z ,200, 400)
		d(Distance2D(script.randomWaitPos.x, script.randomWaitPos.y, wPos.x, wPos.y))
	elseif ( pPos and script.randomWaitPos ) then
		Player:MoveTo(script.randomWaitPos.x, script.randomWaitPos.y, script.randomWaitPos.z, 200, false, false, true)
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


return script