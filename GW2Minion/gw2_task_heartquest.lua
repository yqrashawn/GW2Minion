-- This task is for the TaskManager and will try to do the most common HeartQuests...hopefully ^^
gw2_task_heartquest = inheritsFrom(ml_task)
gw2_task_heartquest.name = GetString("taskHeartQuest")

function gw2_task_heartquest.Create()
	local newinst = inheritsFrom(gw2_task_heartquest)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}
	
	-- General fields	
	newinst.startTime = ml_global_information.Now
	newinst.HQType = "Interact&Kill" -- Different types of HQs
	newinst.enemyContentIDs = nil
	newinst.interactContentIDs = nil
	newinst.interactContentID2s = nil
	newinst.currentKills = 0	
	newinst.lastEnemyTargetID = nil
	newinst.lastTargetType = "character"
	newinst.lastInteractTargetID = nil
	newinst.currentInteracts = 0
	newinst.subRegion = nil
	
	-- Reset some stuff
	e_StayNearHQ.walkingback = false
	
	

    return newinst
end

function gw2_task_heartquest:Init()

			
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
	
	--self:add(ml_element:create( "QuickRepairItems", c_quickrepair, e_quickrepair, 240 ), self.process_elements)
	

	-- DoEvents
	--self:add(ml_element:create( "DoEvent", c_doEvents, e_doEvents, 215 ), self.process_elements) would need a custom c_doEvents to not run away from the spot here
	
	-- ReviveNPCs
	self:add(ml_element:create( "ReviveNPC", c_reviveNPC, e_reviveNPC, 200 ), self.process_elements) -- creates subtask: moveto
	
	-- Gathering
	--self:add(ml_element:create( "Gathering", c_GatherTask, e_GatherTask, 175 ), self.process_elements) -- creates subtask: gatheringTask 
		
	-- Finish Enemy
	self:add(ml_element:create( "FinishEnemy", c_FinishEnemy, e_FinishEnemy, 150 ), self.process_elements)
		
	-- Stay near HQ
	self:add(ml_element:create( "StayNearHQ", c_StayNearHQ, e_StayNearHQ, 125 ), self.process_elements)

	-- If a interact contentID / ID2 was given, this will make the bot walk there and interact
	self:add( ml_element:create( "HandleInteract", c_HQHandleInteract, e_HQHandleInteract, 75 ), self.process_elements)

	-- If a Enemy contentID was given, this will make the bot walk there and attack it
	self:add( ml_element:create( "HandleKillEnemy", c_HQHandleKillEnemy, e_HQHandleKillEnemy, 50 ), self.process_elements)
	


	self:AddTaskCheckCEs()
end
function gw2_task_heartquest:task_complete_eval()
	-- Check for nearby unfinished HQs
	if ( ml_task_hub:CurrentTask().started == true and ml_task_hub:CurrentTask().mappos ~= nil and ml_task_hub:CurrentTask().pos ~= nil  ) then
		
		local dist = Distance3D(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z)		
		if ( dist < 8000 ) then
		
			if ( ml_task_hub:CurrentTask().subRegion ~= nil and tonumber(ml_task_hub:CurrentTask().subRegion) ) then
				local evList = MapMarkerList("onmesh,issubregion,contentID="..GW2.MAPMARKER.HeartQuest)
				local id,marker = next (evList)
				while ( id and marker ) do
					if ( marker.subregionID == tonumber(ml_task_hub:CurrentTask().subRegion) ) then
						-- we found our unfinished HQ
						return false
					end
					id,marker = next(evList,id)					
				end
				d("No unfinished HeartQuest with SubRegionID "..tostring(ml_task_hub:CurrentTask().subRegion).." nearby found, I guess we are done here.")
				ml_task_hub:CurrentTask().completed = true
				return true
			else
				-- no subregion was given, try a default way of checking for HQ
				local evList = MapMarkerList("nearest,onmesh,issubregion,contentID="..GW2.MAPMARKER.HeartQuest)
				if ( evList ) then 
					local i,marker = next(evList)
					if ( i and marker ) then
						return false
					end				
				end
				-- We are close to the startpoint of the HQ but no unfinished HQ was found
				d("No unfinished HeartQuest nearby found, I guess we are done here.")
				ml_task_hub:CurrentTask().completed = true
				return true
			end
		else
			ml_log("Distance to HQ: "..tostring(dist))
			
		end
	end
	return false
end

function gw2_task_heartquest:UIInit()	
	return true
end
function gw2_task_heartquest:UIDestroy()
	
end

function gw2_task_heartquest.ModuleInit()
	d("gw2_task_heartquest:ModuleInit")

	-- Setup Debug fields
	local dw = WindowManager:GetWindow(gw2minion.DebugWindow.Name)
	if ( dw ) then
		dw:NewField("HQ Type","dbHQType","Task_HeartQuest")
		dw:NewField("HQ SubRegionID","dbHQSubRegionID","Task_HeartQuest")
		dw:NewField("Duration","dbHQDuration","Task_HeartQuest")
		dw:NewField("KillCount","dbHQKillcount","Task_HeartQuest")
		dw:NewField("Kill ContentIDs","dbHQKillIDs","Task_HeartQuest")
		dw:NewField("Interact Count","dbHQInteractcount","Task_HeartQuest")
		dw:NewField("Interact ContentIDs","dbHQInteractIDs","Task_HeartQuest")
		dw:NewField("Interact ContentID2s","dbHQInteractID2s","Task_HeartQuest")
	end
	
	ml_task_mgr.AddTaskType(GetString("taskHeartQuest"), gw2_task_heartquest) -- Allow this task to be selectable in TaskManager
end

-- TaskManager functions
function gw2_task_heartquest:UIInit_TM()
	--ml_task_mgr.NewField("maxkills", "beer")	
	ml_task_mgr.NewCombobox("HQ Type", "KillEnemies", "Interact&Kill") -- add more types here later if needed
	ml_task_mgr.NewField("HQ SubRegionID", "subRegion")
	ml_task_mgr.NewNumeric("Max Kills", "maxKills")
	ml_task_mgr.NewField("Enemy ContentIDs", "enemyContentIDs")
	ml_task_mgr.NewNumeric("Max Interacts", "maxInteracts")
	ml_task_mgr.NewField("Interact ContentIDs", "interactContentIDs")
	ml_task_mgr.NewField("Interact ContentID2s", "interactContentID2s")

end
-- TaskManager function: Checks for custom conditions to start this task, this is checked before the task is selected to be enqueued/created
function gw2_task_heartquest.CanTaskStart_TM()	
	return true
end
-- TaskManager function: Checks for custom conditions to keep this task running, this is checked during the task is actively running
function gw2_task_heartquest.CanTaskRun_TM()
	
	-- since this is called independent of the tasksystem, it 
	if ( ml_task_hub:CurrentTask().startTime ~= nil ) then
		dbHQDuration = tostring(math.floor((ml_global_information.Now-ml_task_hub:CurrentTask().startTime)/1000))
	end
	
	dbHQKillIDs = tostring(ml_task_hub:CurrentTask().enemyContentIDs)
	dbHQInteractIDs = tostring(ml_task_hub:CurrentTask().interactContentIDs)
	dbHQInteractID2s = tostring(ml_task_hub:CurrentTask().interactContentID2s)
	
	-- Check the maxkill counter
	if ( ml_task_hub:CurrentTask().maxKills ~= nil and ml_task_hub:CurrentTask().maxKills ~= 0 ) then
			
		if ( ml_global_information.ShowDebug ) then 
			dbHQKillcount = tostring(ml_task_hub:CurrentTask().currentKills).."/"..tostring(ml_task_hub:CurrentTask().maxKills).." Kills"
		end
		
		ml_log(" "..tostring(ml_task_hub:CurrentTask().currentKills).."/"..tostring(ml_task_hub:CurrentTask().maxKills).." Kills")
		
		-- We killed enough
		if ( tonumber(ml_task_hub:CurrentTask().maxKills) <=  ml_task_hub:CurrentTask().currentKills ) then return false end 
				
		-- Check if a targeted enemy got killed meanwhile
		if ( ml_task_hub:CurrentTask().lastEnemyTargetID ~= nil and tonumber(ml_task_hub:CurrentTask().lastEnemyTargetID) ~= nil) then
			local target = nil
			
			if ( ml_task_hub:CurrentTask().lastTargetType == "character" ) then
				target = CharacterList:Get(tonumber(ml_task_hub:CurrentTask().lastEnemyTargetID))
			else
				target = GadgetList:Get(tonumber(ml_task_hub:CurrentTask().lastEnemyTargetID))
			end
			
			if ( not target or not target.alive or not target.attackable) then
				ml_task_hub:CurrentTask().currentKills = tonumber(ml_task_hub:CurrentTask().currentKills) + 1
				ml_task_hub:CurrentTask().lastEnemyTargetID = nil
			end
		end
	end	
			
	
	-- Check the maxinteract counter
	if ( ml_task_hub:CurrentTask().maxInteracts ~= nil and ml_task_hub:CurrentTask().maxInteracts ~= 0 ) then
			
		if ( ml_global_information.ShowDebug ) then 
			dbHQInteractcount = tostring(ml_task_hub:CurrentTask().currentInteracts).."/"..tostring(ml_task_hub:CurrentTask().maxInteracts).." Interacts"
		end
		
		ml_log(" "..tostring(ml_task_hub:CurrentTask().currentInteracts).."/"..tostring(ml_task_hub:CurrentTask().maxInteracts).." Interacts")
		
		-- We killed enough
		if ( tonumber(ml_task_hub:CurrentTask().maxInteracts) <=  ml_task_hub:CurrentTask().currentInteracts ) then return false end 
				
		-- Check if a targeted enemy got killed meanwhile
		if ( ml_task_hub:CurrentTask().lastInteractTargetID ~= nil and tonumber(ml_task_hub:CurrentTask().lastInteractTargetID) ~= nil) then
						
			local target = GadgetList:Get(tonumber(ml_task_hub:CurrentTask().lastInteractTargetID))
			
			if ( not target ) then 
				target = CharacterList:Get(tonumber(ml_task_hub:CurrentTask().lastInteractTargetID))
			end
			
			if ( not target or not target.selectable or not target.interactable) then
				ml_task_hub:CurrentTask().currentInteracts = tonumber(ml_task_hub:CurrentTask().currentInteracts) + 1
				ml_task_hub:CurrentTask().lastInteractTargetID = nil
			end
		end
	end	
	return true
end



-- Interact with stuff than we should interact with 
c_StayNearHQ = inheritsFrom( ml_cause )
e_StayNearHQ = inheritsFrom( ml_effect )
e_StayNearHQ.walkingback = false
function c_StayNearHQ:evaluate()
	
	if ( e_StayNearHQ.walkingback ) then return true end 
	
	if ( ml_task_hub:CurrentTask().pos ~= nil ) then
		local startPos = ml_task_hub:CurrentTask().pos
		local dist = Distance3D(startPos.x,startPos.y,startPos.z,ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z)
		
		local maxradius = tonumber(ml_task_hub:CurrentTask().radius)
		if ( maxradius == 0 ) then maxradius = 6000 end
		
		if ( dist > maxradius ) then
			--this will make the TM to walk back to the startposition of this task
			return true
			
		end		
	end
	e_StayNearHQ.walkingback = false
	return false
end
function e_StayNearHQ:execute()
	ml_log("e_StayNearHQ ")
	if ( not gw2_unstuck.HandleStuck() ) then
		local navResult = tostring(Player:MoveTo(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,250,false,false,false))		
		if (tonumber(navResult) < 0) then					
			d("e_StayNearHQ result: "..tonumber(navResult))
		else
			e_StayNearHQ.walkingback = true
			return ml_log(true)
		end
	end
	e_StayNearHQ.walkingback = false
	return ml_log(false)
end

-- Makes sure we dont walk away too far
c_HQHandleInteract = inheritsFrom( ml_cause )
e_HQHandleInteract = inheritsFrom( ml_effect )
e_HQHandleInteract.lastTarget = nil
e_HQHandleInteract.lastTargetID = nil
e_HQHandleInteract.lastQueryTmr = 0
e_HQHandleInteract.WasChecked = false -- to make sure handleinteract is done before enemy checks
function c_HQHandleInteract:evaluate()
	local radius = tonumber(ml_task_hub:CurrentTask().radius)
	if ( radius == 0 ) then radius = 8000 end
	
	-- to prevent hammering the "shortestpath"
	if ( e_HQHandleInteract.lastTarget ~= nil and e_HQHandleInteract.lastTargetID ~= nil and TimeSince(e_HQHandleInteract.lastQueryTmr) < 2000 ) then
		if ( ValidTable(CharacterList:Get(e_HQHandleInteract.lastTargetID)) or ValidTable(GadgetList:Get(e_HQHandleInteract.lastTargetID)) ) then			
			return true			
		end	
	end
	
	-- dont spam it when no target was found
	if (TimeSince(e_HQHandleInteract.lastQueryTmr) < 1000) then e_HQHandleInteract.WasChecked = false return false end 
	e_HQHandleInteract.lastQueryTmr = ml_global_information.Now
	e_HQHandleInteract.WasChecked = true
	
	if ( ml_task_hub:CurrentTask().interactContentIDs ~= nil and ml_task_hub:CurrentTask().interactContentIDs ~= "" and ValidString(ml_task_hub:CurrentTask().interactContentIDs) ) then
				
		-- Lets pray that no dumbnut entered bullshit into these ContentID fields -.-
		-- Search Charlist and Gadgetlist for the wanted targets
		local TargetList = CharacterList("shortestpath,onmesh,interactable,selectable,contentID="..ml_task_hub:CurrentTask().interactContentIDs..",exclude_contentid="..ml_blacklist.GetExcludeString(GetString("monsters")))
		if ( TargetList ) then
			local id,entry = next(TargetList)
			if (id and entry ) then
				local tPos = entry.pos				
				if ( Distance3D(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,tPos.x,tPos.y,tPos.z) < radius ) then
					e_HQHandleInteract.lastTarget = entry 
					e_HQHandleInteract.lastTargetID = id					
					return true
				end
			end
		end	
		
		local TargetList = GadgetList("shortestpath,onmesh,interactable,selectable,contentID="..ml_task_hub:CurrentTask().interactContentIDs..",exclude_contentid="..ml_blacklist.GetExcludeString(GetString("monsters")))
		if ( TargetList ) then
			local id,entry = next(TargetList)
			if (id and entry ) then
				local tPos = entry.pos					
				if ( Distance3D(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,tPos.x,tPos.y,tPos.z) < radius ) then
					e_HQHandleInteract.lastTarget = entry 
					e_HQHandleInteract.lastTargetID = id
					return true
				end
			end
		end	
		
	end
	
	if ( ml_task_hub:CurrentTask().interactContentID2s ~= nil  and ml_task_hub:CurrentTask().interactContentID2s ~= "" and ValidString(ml_task_hub:CurrentTask().interactContentID2s) ) then
		-- Search Gadgetlist for the wanted targets	
		local TargetList = GadgetList("shortestpath,onmesh,interactable,selectable,contentID2="..ml_task_hub:CurrentTask().interactContentID2s..",exclude_contentid="..ml_blacklist.GetExcludeString(GetString("monsters")))
		if ( TargetList ) then
			local id,entry = next(TargetList)
			if (id and entry ) then				
				local tPos = entry.pos
				if ( Distance3D(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,tPos.x,tPos.y,tPos.z) < radius ) then
					e_HQHandleInteract.lastTarget = entry
					e_HQHandleInteract.lastTargetID = id
					return true
				end
			end
		end	
	end
	
	e_HQHandleInteract.lastTarget = nil
	e_HQHandleInteract.lastTargetID = nil
	e_HQHandleInteract.lastQueryTmr = ml_global_information.Now
	return false
end
function e_HQHandleInteract:execute()
	ml_log("HQHandleInteract ")
	if ( e_HQHandleInteract.lastTarget and e_HQHandleInteract.lastTarget.onmesh and e_HQHandleInteract.lastTarget.interactable and e_HQHandleInteract.lastTarget.selectable) then 
		if ( e_HQHandleInteract.lastTarget.isInInteractRange and e_HQHandleInteract.lastTarget.distance < 100) then
			Player:StopMovement()
			local target = Player:GetTarget()
			if (not target or target.id ~= e_HQHandleInteract.lastTarget.id) then
				Player:SetTarget(e_HQHandleInteract.lastTarget.id)
				return true
				
			else
				ml_log("Interact with Target.. ")
				if ( Player:GetCurrentlyCastedSpell() == 17 ) then	
					Player:Interact(e_HQHandleInteract.lastTarget.id)
					-- For TM Conditions
					ml_task_hub:CurrentTask().lastInteractTargetID = e_HQHandleInteract.lastTarget.id				
					ml_global_information.Wait(1000)					
				end
				return ml_log(true)				
			end
			
		else
			-- Get in range
			ml_log(" Getting in InteractRange, Distance:"..tostring(math.floor(e_HQHandleInteract.lastTarget.distance)))			
			local ePos = e_HQHandleInteract.lastTarget.pos
			local tRadius = e_HQHandleInteract.lastTarget.radius or 50
			if ( not gw2_unstuck.HandleStuck() ) then
				local navResult = tostring(Player:MoveTo(ePos.x,ePos.y,ePos.z,25+tRadius,false,false,true))		
				if (tonumber(navResult) < 0) then					
					d("MoveInRange result: "..tonumber(navResult))
				else
					return ml_log(true)
				end
			end		
		end
	else
		e_HQHandleInteract.lastTarget = nil
		e_HQHandleInteract.lastTargetID = nil
		e_HQHandleInteract.lastQueryTmr = ml_global_information.Now
	end
	
	return ml_log(false)
end

-- Search n Kill the wanted Enemies
c_HQHandleKillEnemy = inheritsFrom( ml_cause )
e_HQHandleKillEnemy = inheritsFrom( ml_effect )
e_HQHandleKillEnemy.lastTarget = nil
e_HQHandleKillEnemy.lastTargetID = nil
e_HQHandleKillEnemy.lastQueryTmr = 0
function c_HQHandleKillEnemy:evaluate()
	if ( ml_task_hub:CurrentTask().enemyContentIDs ~= nil and ml_task_hub:CurrentTask().enemyContentIDs ~= "" and  ValidString(ml_task_hub:CurrentTask().enemyContentIDs) ) then
		-- Lets pray that no dumbnut entered bullshit into these ContentID fields -.-
		
		-- to prevent hammering the "shortestpath"
		if ( e_HQHandleKillEnemy.lastTarget ~= nil and e_HQHandleKillEnemy.lastTargetID ~= nil and TimeSince(e_HQHandleKillEnemy.lastQueryTmr) < 2000 ) then
			if ( ValidTable(CharacterList:Get(e_HQHandleKillEnemy.lastTargetID)) or ValidTable(GadgetList:Get(e_HQHandleKillEnemy.lastTargetID)) ) then			
				return true			
			end	
		end
		
		-- dont spam it when no target was found
		if (e_HQHandleInteract.WasChecked == false or TimeSince(e_HQHandleKillEnemy.lastQueryTmr) < 1000) then return false end 
		e_HQHandleKillEnemy.lastQueryTmr = ml_global_information.Now
		
		
		-- Search Charlist and Gadgetlist for the wanted enemies
		local radius = tonumber(ml_task_hub:CurrentTask().radius)
		if ( radius == 0 ) then maxradius = 8000 end
		local TargetList = CharacterList("shortestpath,onmesh,attackable,selectable,alive,contentID="..ml_task_hub:CurrentTask().enemyContentIDs)
		if ( TargetList ) then
			local id,entry = next(TargetList)
			if (id and entry ) then
				local tPos = entry.pos				 
				if ( Distance3D(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,tPos.x,tPos.y,tPos.z) < radius ) then
					e_HQHandleKillEnemy.lastTarget = entry					
					e_HQHandleKillEnemy.lastTargetID = id					
					return true
				end
			end
		end	
		
		local TargetList = GadgetList("shortestpath,onmesh,attackable,selectable,alive,contentID="..ml_task_hub:CurrentTask().enemyContentIDs)
		if ( TargetList ) then
			local id,entry = next(TargetList)
			if (id and entry ) then
				local tPos = entry.pos				 
				if ( Distance3D(ml_task_hub:CurrentTask().pos.x,ml_task_hub:CurrentTask().pos.y,ml_task_hub:CurrentTask().pos.z,tPos.x,tPos.y,tPos.z) < radius ) then
					e_HQHandleKillEnemy.lastTarget = entry					
					e_HQHandleKillEnemy.lastTargetID = id
					return true
				end
			end
		end	
		
	end
	e_HQHandleKillEnemy.lastTarget = nil
	e_HQHandleKillEnemy.lastTargetID = nil
	e_HQHandleKillEnemy.lastQueryTmr = ml_global_information.Now
	return false
end
function e_HQHandleKillEnemy:execute()
	ml_log("HQHandleKillEnemy ")
	if ( e_HQHandleKillEnemy.lastTarget and e_HQHandleKillEnemy.lastTarget.onmesh and e_HQHandleKillEnemy.lastTarget.attackable and e_HQHandleKillEnemy.lastTarget.alive) then 
		Player:StopMovement()
		-- For TM Conditions
		ml_task_hub:CurrentTask().lastEnemyTargetID = e_HQHandleKillEnemy.lastTarget.id
		ml_task_hub:CurrentTask().lastTargetType = "character"
		
		-- Create new Subtask Combat
		local newTask = gw2_task_combat.Create()
		newTask.targetID = e_HQHandleKillEnemy.lastTarget.id		
		newTask.targetPos = e_HQHandleKillEnemy.lastTarget.pos
		if ( e_HQHandleKillEnemy.lastTarget.isGadget ) then
			newTask.targetType = "gadget"
			ml_task_hub:CurrentTask().lastTargetType = "gadget"
		end
		
		
		ml_task_hub:Add(newTask.Create(), IMMEDIATE_GOAL, TP_IMMEDIATE)
		return ml_log(true)
		
	end
	
	e_HQHandleKillEnemy.lastTarget = nil
	e_HQHandleKillEnemy.lastTargetID = nil
	e_HQHandleKillEnemy.lastQueryTmr = ml_global_information.Now
	return ml_log(false)
end

RegisterEventHandler("Module.Initalize",gw2_task_heartquest.ModuleInit)
