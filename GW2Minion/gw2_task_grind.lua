-- Grind
gw2_task_grind = inheritsFrom(ml_task)
gw2_task_grind.name = GetString("grindMode")

function gw2_task_grind.Create()
	local newinst = inheritsFrom(gw2_task_grind)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}
	
	-- custom fields
	newinst.maxGrindTmr = nil
	newinst.markerTime = 0
	newinst.currentMarker = false
	newinst.filterLevel = true
	
	-- TaskManager fields
	newinst.maxKills = 0 -- Amount of enemies to kill before task is completed, gets set by TaskManager Custom Conditions
	newinst.currentKills = 0 -- Counter of current task
	newinst.lastTargetID = nil -- set this value on each addsubtask(combat), this is used to determine if we killed one or not 
	newinst.lastTargetType = "character" -- same as above

    return newinst
end

function gw2_task_grind:Init()

	-- ProcessOverWatch() elements
	
	-- Handle Dead
	self:add(ml_element:create( "Dead", c_Dead, e_Dead, 500 ), self.overwatch_elements)	
	-- Handle Downed
	self:add(ml_element:create( "Downed", c_Downed, e_Doened, 450 ), self.overwatch_elements)
	-- Handle Rezz-Target is alive again or gone, deletes the subtask moveto in case it is needed
	self:add(ml_element:create( "RevivePartyMemberOverWatch", c_RezzOverWatchCheck, e_RezzOverWatchCheck, 400 ), self.overwatch_elements)
	

	
	-- Normal elements
	-- Revive Downed/Dead Partymember
	self:add(ml_element:create( "RevivePartyMember", c_RezzPartyMember, e_RezzPartyMember, 375 ), self.process_elements)	-- creates subtask: moveto
	-- Revive other Players
	self:add(ml_element:create( "RevivePlayer", c_reviveDownedPlayersInCombat, e_reviveDownedPlayersInCombat, 350 ), self.process_elements)	-- creates subtask: moveto
	-- FightAggro
	self:add(ml_element:create( "FightAggro", c_FightAggro, e_FightAggro, 325 ), self.process_elements) --creates immediate queue task for combat
	
	-- Resting / Wait to heal
	self:add(ml_element:create( "Resting", c_waitToHeal, e_waitToHeal, 300 ), self.process_elements)
	
	-- Normal Looting & chests
	self:add(ml_element:create( "Looting", c_Looting, e_Looting, 275 ), self.process_elements)
	
	-- Re-Equip Gathering Tools
	--self:add(ml_element:create( "EquippingGatherTool", c_GatherToolsCheck, e_GatherToolsCheck, 265 ), self.process_elements)	
	
	-- Buy & Repair & Vendoring
	self:add(ml_element:create( "VendorSell", c_createVendorSellTask, e_createVendorSellTask, 250 ), self.process_elements)
	self:add(ml_element:create( "VendorBuy", c_createVendorBuyTask, e_createVendorBuyTask, 240 ), self.process_elements)
	
	--self:add(ml_element:create( "QuickRepairItems", c_quickrepair, e_quickrepair, 240 ), self.process_elements)
	

	-- DoEvents
	--self:add(ml_element:create( "DoEvent", c_doEvents, e_doEvents, 215 ), self.process_elements)
	
	-- ReviveNPCs
	self:add(ml_element:create( "ReviveNPC", c_reviveNPC, e_reviveNPC, 200 ), self.process_elements) -- creates subtask: moveto
	
	-- Gathering
	self:add(ml_element:create( "Gathering", c_GatherTask, e_GatherTask, 175 ), self.process_elements) -- creates subtask: gatheringTask 
		
	-- Finish Enemy
	self:add(ml_element:create( "FinishEnemy", c_FinishEnemy, e_FinishEnemy, 150 ), self.process_elements)
		
	-- Fight in a smaller radius towards the current marker ( this takes care of reaching it and also when running outside the markerradius and we need to move back to marker)
	-- Only for GrindMarkers!
	self:add(ml_element:create( "FightTowardsGrindMarker", c_FightToGrindMarker, e_FightToGrindMarker, 125 ), self.process_elements)--creates immediate queue task for combat
	
	-- Pick the next/new Marker and makes sure we are staying near the current Marker
	self:add( ml_element:create( "NextMarker", c_MoveToMarker, e_MoveToMarker, 75 ), self.process_elements)

	-- Check for attackable Targets
	self:add(ml_element:create( "GetNextTarget", c_CombatTask, e_CombatTask, 50 ), self.process_elements)
		
	-- Move to a Randompoint if there is nothing to fight around us
	self:add( ml_element:create( "movetorandom", c_movetorandom, e_movetorandom, 25 ), self.process_elements)
	

	self:AddTaskCheckCEs()
end

function gw2_task_grind:UIInit()
	local mw = WindowManager:GetWindow(gw2minion.MainWindow.Name)
	if ( mw ) then
		mw:NewCheckBox(GetString("doEvents"),"gDoEvents",GetString("grindMode"))
		mw:NewCheckBox(GetString("gatherMode"),"gGather",GetString("grindMode"))
		
		mw:UnFold( GetString("grindMode") );
	end
	
	Settings.GW2Minion.gDoEvents = Settings.GW2Minion.gDoEvents or "1"
	Settings.GW2Minion.gGather = Settings.GW2Minion.gGather or "1"
	
	gDoEvents = Settings.GW2Minion.gDoEvents
	gGather = Settings.GW2Minion.gGather
	return true
end
function gw2_task_grind:UIDestroy()
	d("gw2_task_grind:UIDestroy")
	GUI_DeleteGroup(gw2minion.MainWindow.Name, GetString("grindMode"))
end

function gw2_task_grind.ModuleInit()
	d("gw2_task_grind:ModuleInit")

	-- Setup Debug fields
	local dw = WindowManager:GetWindow(gw2minion.DebugWindow.Name)
	if ( dw ) then
		dw:NewField("CurrentMarker","dbCurrMarker","Global")
		dw:NewField("KillCount","dbGrindKillcount","Task_Grind")
	end
	
	ml_task_mgr.AddTaskType(GetString("grindMode"), gw2_task_grind) -- Allow this task to be selectable in TaskManager
end

-- TaskManager functions
function gw2_task_grind:UIInit_TM()
	--ml_task_mgr.NewField("maxkills", "beer")
	ml_task_mgr.NewNumeric("Max Kills", "maxKills")	
	--ml_task_mgr.NewCombobox("testcbox", "whiskey", "A,B,C")
	
end
-- TaskManager function: Checks for custom conditions to start this task
function gw2_task_grind.CanTaskStart_TM()
	return true
end
-- TaskManager function: Checks for custom conditions to keep this task running
function gw2_task_grind.CanTaskRun_TM()
			
	-- Check the maxkill counter
	if ( ml_task_hub:CurrentTask().maxKills ~= nil and ml_task_hub:CurrentTask().maxKills ~= 0 ) then
			
		if ( ml_global_information.ShowDebug ) then 
			dbGrindKillcount = tostring(ml_task_hub:CurrentTask().currentKills).."/"..tostring(ml_task_hub:CurrentTask().maxKills).." Kills"
		end
		
		ml_log(" "..tostring(ml_task_hub:CurrentTask().currentKills).."/"..tostring(ml_task_hub:CurrentTask().maxKills).." Kills")
		-- We killed enough
		if ( tonumber(ml_task_hub:CurrentTask().maxKills) <=  ml_task_hub:CurrentTask().currentKills ) then return false end 
		
		-- Check if a targeted enemy got killed meanwhile
		if ( ml_task_hub:CurrentTask().lastTargetID ~= nil and tonumber(ml_task_hub:CurrentTask().lastTargetID) ~= nil) then
			local target = nil
			
			if ( ml_task_hub:CurrentTask().lastTargetType == "character" ) then
				target = CharacterList:Get(tonumber(ml_task_hub:CurrentTask().lastTargetID))
			else
				target = GadgetList:Get(tonumber(ml_task_hub:CurrentTask().lastTargetID))
			end
			
			if ( not target or not target.alive ) then
				ml_task_hub:CurrentTask().currentKills = tonumber(ml_task_hub:CurrentTask().currentKills) + 1
				ml_task_hub:CurrentTask().lastTargetID = nil
			end
		end
	end	
	return true
end

--------- Creates a new IMMEDIATE_GOAL task to kill an enemy when we are fighting our way towards the current grindmarker
c_FightToGrindMarker = inheritsFrom( ml_cause )
e_FightToGrindMarker = inheritsFrom( ml_effect )
c_FightToGrindMarker.target = nil
function c_FightToGrindMarker:evaluate()
	if ( c_MoveToMarker.markerreached == false and c_MoveToMarker.allowedToFight == true) then
		local target = gw2_common_functions.GetBestCharacterTarget( 2000 ) -- maxrange 2000 where enemies should be searched for
		if ( target ) then
			c_FightToGrindMarker.target = target
			return ml_global_information.Player_SwimState == GW2.SWIMSTATE.NotInWater and c_FightToGrindMarker.target ~= nil			
		end
	end
	c_FightToGrindMarker.target = nil
	return false
end
function e_FightToGrindMarker:execute()
	ml_log("e_FightToGrindMarker ")
			
	if (c_FightToGrindMarker.target ~= nil) then
		Player:StopMovement()
		-- For TM Conditions
		ml_task_hub:CurrentTask().lastTargetID = c_FightToGrindMarker.target.id
		-- Create new Subtask combat
		local newTask = gw2_task_combat.Create()
		newTask.targetID = c_FightToGrindMarker.target.id
		newTask.targetPos = c_FightToGrindMarker.target.pos	
		ml_task_hub:Add(newTask.Create(), IMMEDIATE_GOAL, TP_IMMEDIATE)
		c_FightToGrindMarker.target = nil
	else
		ml_log("e_FightToGrindMarker found no target")
	end
	return ml_log(false)
end

---------
-- Moves player towards the current marker and makes sure we are still inside the radius around the marker, moves the player randomly around the maker to kill n find stuff
-- If Markertime is up, it will pick also the next marker
-- If there are no Maker in the current mesh, it will pick a random point and go there
c_MoveToMarker = inheritsFrom( ml_cause )
e_MoveToMarker = inheritsFrom( ml_effect )
c_MoveToMarker.markerreachedfirsttime = false
c_MoveToMarker.markerreached = false
c_MoveToMarker.allowedToFight = false -- this sh*t is needed else he will go back n forth on the outer side of the marker's min radius if an enemy sits at larger-min-dist behind that radius -.-
function c_MoveToMarker:evaluate()
	-- Get a new/next Marker if we need one ( no marker , out of level, time up )
	if (ml_task_hub:CurrentTask().currentMarker == nil or ml_task_hub:CurrentTask().currentMarker == false 
		or ( ml_task_hub:CurrentTask().filterLevel and ml_task_hub:CurrentTask().currentMarker:GetMinLevel() and ml_task_hub:CurrentTask().currentMarker:GetMaxLevel() and (ml_global_information.Player_Level < ml_task_hub:CurrentTask().currentMarker:GetMinLevel() or ml_global_information.Player_Level > ml_task_hub:CurrentTask().currentMarker:GetMaxLevel())) 
		or ( ml_task_hub:CurrentTask().currentMarker:GetTime() and ml_task_hub:CurrentTask().currentMarker:GetTime() ~= 0 and TimeSince(ml_task_hub:CurrentTask().markerTime) > ml_task_hub:CurrentTask().currentMarker:GetTime() * 1000 )) then
		-- TODO: ADD TIMEOUT FOR MARKER
		ml_task_hub:CurrentTask().currentMarker = ml_marker_mgr.GetNextMarker(GetString("grindMarker"), ml_task_hub:CurrentTask().filterLevel)
		
		-- disable the levelfilter in case we didnt find any other marker
		if (ml_task_hub:CurrentTask().currentMarker == nil) then
			ml_task_hub:CurrentTask().filterLevel = false
			ml_task_hub:CurrentTask().currentMarker = ml_marker_mgr.GetNextMarker(GetString("grindMarker"), ml_task_hub:CurrentTask().filterLevel)
		end
		
		-- we found a new marker, setup vars
		if ( ml_task_hub:CurrentTask().currentMarker ~= nil ) then
			d("New Grind Marker set!")
			ml_task_hub:CurrentTask().markerTime = ml_global_information.Now -- Are BOTH needed to get updated ?
			ml_global_information.MarkerTime = ml_global_information.Now     -- This needs to be global else we cannot access the stuff in parent or subtasks
			ml_global_information.MarkerMinLevel = ml_task_hub:CurrentTask().currentMarker:GetMinLevel()
			ml_global_information.MarkerMaxLevel = ml_task_hub:CurrentTask().currentMarker:GetMaxLevel()	
			c_MoveToMarker.markerreached = false
			c_MoveToMarker.markerreachedfirsttime = false
		end
	end
	
	-- We have a valid current Grindmarker
    if (ml_task_hub:CurrentTask().currentMarker ~= false and ml_task_hub:CurrentTask().currentMarker ~= nil) then
        
		-- Reset the Markertime until we actually reached the marker the first time and then let it count down
		if (c_MoveToMarker.markerreachedfirsttime == false ) then
			ml_task_hub:CurrentTask().markerTime = ml_global_information.Now
			ml_global_information.MarkerTime = ml_global_information.Now
		end
		
		-- Debug info
		if ( ml_global_information.ShowDebug ) then dbCurrMarker = ml_task_hub:CurrentTask().currentMarker:GetName() or "" end
		
		-- We haven't reached the currentMarker or ran outside its radius
		if ( c_MoveToMarker.markerreached == false) then			
			return true
		
		else
			-- check if we ran outside the currentMarker radius and if so, we need to walk back to the currentMarker
			local pos = ml_task_hub:CurrentTask().currentMarker:GetPosition()
			local distance = Distance2D(ml_global_information.Player_Position.x, ml_global_information.Player_Position.y, pos.x, pos.y)			
			if  (gBotMode == GetString("grindMode") and distance > ml_task_hub:CurrentTask().currentMarker:GetFieldValue(GetString("maxRange"))) then
				d("We need to move back to our current Marker!")
				c_MoveToMarker.markerreached = false
				c_MoveToMarker.allowedToFight = false
				return true
			end
		end		
	end
	
    return false
end
function e_MoveToMarker:execute()
	ml_log(" e_MoveToMarker ")
	-- Move to our current marker
	if (ml_task_hub:CurrentTask().currentMarker ~= nil and ml_task_hub:CurrentTask().currentMarker ~= false) then
		
		local pos = ml_task_hub:CurrentTask().currentMarker:GetPosition()
		local dist = Distance2D(ml_global_information.Player_Position.x, ml_global_information.Player_Position.y, pos.x, pos.y)
		
		-- Allow fighting when we are far away from the "outside radius of the marker" , else the bot goes back n forth spinning trying to reach the target outside n going back inside right after
		if ( dist < ml_task_hub:CurrentTask().currentMarker:GetFieldValue(GetString("maxRange"))) then
			c_MoveToMarker.allowedToFight = true
		else
			c_MoveToMarker.allowedToFight = false
		end
		
		if  ( dist < 200) then
			-- We reached our Marker
			c_MoveToMarker.markerreached = true
			c_MoveToMarker.markerreachedfirsttime = true
			d("Reached current Marker...")
			return ml_log(true)		
		else
			-- We need to reach our Marker yet
			-- make sure the next marker is reachable & onmesh
			if ( ValidTable(NavigationManager:GetPath(ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z,pos.x,pos.y,pos.z))) then
				
				local newTask = gw2_task_moveto.Create()
				newTask.name = "MoveTo GrindMarker"
				newTask.targetPos = pos
				ml_task_hub:CurrentTask():AddSubTask(newTask)
				return ml_log(true)
				
			else
				d("WARNING: Cannot reach next Marker, trying to pick another one...")
				ml_task_hub:CurrentTask().currentMarker = nil
				-- Debug info
				if ( ml_global_information.ShowDebug ) then dbCurrMarker = "" end 
			end
		end
	end
	return ml_log(false)
end

--------- Creates a new IMMEDIATE_GOAL task to kill an enemy
c_CombatTask = inheritsFrom( ml_cause )
e_CombatTask = inheritsFrom( ml_effect )
c_CombatTask.target = nil
function c_CombatTask:evaluate()
	local target = gw2_common_functions.GetBestCharacterTarget( 9999 ) -- maxrange 2000 where enemies should be searched for
	if ( target ) then
		c_CombatTask.target = target
		return ml_global_information.Player_SwimState == GW2.SWIMSTATE.NotInWater and c_CombatTask.target ~= nil			
	end	
	c_CombatTask.target = nil
	return false
end
function e_CombatTask:execute()
	ml_log("CombatTask ")
			
	if (c_CombatTask.target ~= nil) then
		Player:StopMovement()
		-- For TM Conditions
		ml_task_hub:CurrentTask().lastTargetID = c_CombatTask.target.id
		
		-- Create new Subtask Combat
		local newTask = gw2_task_combat.Create()
		newTask.targetID = c_CombatTask.target.id		
		newTask.targetPos = c_CombatTask.target.pos	
		ml_task_hub:Add(newTask.Create(), IMMEDIATE_GOAL, TP_IMMEDIATE)
		c_CombatTask.target = nil
	else
		ml_log("gw2_task_grind.CombatTask found no target")
	end
	return ml_log(false)
end





ml_global_information.AddBotMode(GetString("grindMode"), gw2_task_grind)
RegisterEventHandler("Module.Initalize",gw2_task_grind.ModuleInit)
