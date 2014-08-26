-- initializes the questmanager which is included in minionlib and handles the executionlogic of quests/steps
mc_questmanager = {}
mc_questmanager.profilepath = GetStartupPath() .. [[\LuaMods\GW2Minion\QuestManagerProfiles\]];


function mc_questmanager.ModuleInit( ) 
	ml_quest_mgr.ModuleInit("GW2Minion",mc_questmanager.profilepath ) -- from minionlib/ml_quest_mgr.lua

	-- Add Map exploration stuff	
	GUI_NewButton(ml_quest_mgr.mainwindow.name,GetString("questGenMapExplo"),"QMGenMapExploProfile",GetString("generalSettings"))
	RegisterEventHandler("QMGenMapExploProfile",mc_questmanager.GenerateMapExploreProfile)
end
RegisterEventHandler("Module.Initalize",mc_questmanager.ModuleInit) -- from minionlib/ml_quest_mgr.lua



-- RunQuestProfile-Task for example how to run the quest-step-script-tasks ;)
mc_ai_questprofile = inheritsFrom(ml_task)
mc_ai_questprofile.name = "QuestMode"

function mc_ai_questprofile.Create()
	local newinst = inheritsFrom(mc_ai_questprofile)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}
	newinst.currentQuest = nil
	newinst.currentStep = nil
		
    return newinst
end

function mc_ai_questprofile:Init()

end

function mc_ai_questprofile:Process()
	
	-- Get a Quest
	if ( self.currentStep~=nil and self.currentStep.script ~= nil and self.currentStep.script.completed == true ) then
		d("QuestStep "..tostring(self.currentStep.name).." completed!")
		ml_quest_mgr.SetQuestData( self.currentQuest, self.currentStep, nil, "done", "1" )
		self.currentStep = nil
	end
	
	if ( self.currentQuest == nil or ml_quest_mgr.QuestIsForMapID(self.currentQuest, Player:GetLocalMapID()) == false ) then
		self.currentQuest = ml_quest_mgr.GetNewQuest()		
		if ( self.currentQuest == nil ) then
			d("No more Quests in Questprofile left, terminating task")
			self.completed = true
		end
	
	else
		-- Get next QuestStep
		if ( self.currentStep == nil or self.currentStep.done == "1" or ( self.currentStep.script ~= nil and self.currentStep.script.completed == true)) then
			
			-- Set this step to "Finished" in our character's questprofile progress			-- 									
			if ( self.currentStep~=nil and self.currentStep.script ~= nil ) then 
				d("QuestStep "..tostring(self.currentStep.name).." completed!") 				
				ml_quest_mgr.SetQuestData( self.currentQuest, self.currentStep, nil, "done", "1" )
				self.currentStep = nil
			end
			
			-- Getting next questStep
			self.currentStep = ml_quest_mgr.GetNextQuestStep( self.currentQuest )				
			if ( self.currentStep == nil ) then
				d("All steps of current Quest "..tostring( self.currentQuest.name).." are finished!")
				ml_quest_mgr.SetQuestData( self.currentQuest, nil, nil, "done", "1" )
								
				-- Reset QuestSteps for repeatable Quests
				if ( self.currentQuest.repeatable == "1" ) then
					d("Resetting QuestSteps for "..tostring( self.currentQuest.name))
					ml_quest_mgr.ResetQuest( self.currentQuest )
				end
				
				d("Saving QuestProgress..")
				ml_quest_mgr.SaveProfile()		
				self.currentQuest = nil
			end			
		else
			-- Execute currentStep Task
			if ( self.currentStep.script ~= nil ) then
								
				ml_task_hub:CurrentTask():AddSubTask(self.currentStep.script)
				
			else
				ml_error("QuestStep "..tostring(self.currentStep.name).." has NO script selected!!!!!")
			end			
		end
		
	end	
end

function mc_ai_questprofile:task_complete_eval()
	ml_log("mc_ai_questprofile:task_complete_eval->")
	return false
end
function mc_ai_questprofile:task_complete_execute()
    ml_log("mc_ai_questprofile:task_complete_execute->")
end

if ( mc_global.BotModes) then
	mc_global.BotModes[GetString("questRunProfile")] = mc_ai_questprofile
end



-- Run Quest(s) for the GrindTask, this will just finish (try to lol) the current quest instead of auto picking a new quest when the current once is finished
mc_ai_doquest = inheritsFrom(ml_task)
mc_ai_doquest.name = "DoQuest"

function mc_ai_doquest.Create()
	local newinst = inheritsFrom(mc_ai_doquest)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}
	newinst.currentQuest = nil
	newinst.currentStep = nil
		
    return newinst
end

function mc_ai_doquest:Init()

	-- Dead?
	self:add(ml_element:create( "Dead", c_dead, e_dead, 225 ), self.process_elements)
	
	-- Downed
	self:add(ml_element:create( "Downed", c_downed, e_downed, 200 ), self.process_elements)
	
	-- AoELooting Characters
	self:add(ml_element:create( "AoELoot", c_AoELoot, e_AoELoot, 175 ), self.process_elements)
		
	-- Partymember Downed/Dead
	self:add(ml_element:create( "RevivePartyMember", c_memberdown, e_memberdown, 170 ), self.process_elements)	
		
	-- Aggro
	self:add(ml_element:create( "Aggro", c_Aggro, e_Aggro, 165 ), self.process_elements) --reactive queue
	
	-- Dont Dive lol
	self:add(ml_element:create( "SwimUP", c_SwimUp, e_SwimUp, 160 ), self.process_elements)
	
	-- Normal Chests	
	self:add(ml_element:create( "LootingChest", c_LootChests, e_LootChests, 155 ), self.process_elements)
	
	-- Resting
	self:add(ml_element:create( "Resting", c_resting, e_resting, 145 ), self.process_elements)	

	-- Normal Looting
	self:add(ml_element:create( "Looting", c_LootCheck, e_LootCheck, 130 ), self.process_elements)

	-- Deposit Items
	self:add(ml_element:create( "DepositingItems", c_deposit, e_deposit, 120 ), self.process_elements)	
	
	-- Re-Equip Gathering Tools
	self:add(ml_element:create( "EquippingGatherTool", c_GatherToolsCheck, e_GatherToolsCheck, 110 ), self.process_elements)	
	
	-- Quick-Repair & Vendoring (when a vendor is nearby)	
	self:add(ml_element:create( "QuickSellItems", c_quickvendorsell, e_quickvendorsell, 100 ), self.process_elements)
	self:add(ml_element:create( "QuickBuyItems", c_quickbuy, e_quickbuy, 99 ), self.process_elements)
	self:add(ml_element:create( "QuickRepairItems", c_quickrepair, e_quickrepair, 98 ), self.process_elements)
	
	-- Repair & Vendoring
	self:add(ml_element:create( "SellItems", c_vendorsell, e_vendorsell, 90 ), self.process_elements)	
	self:add(ml_element:create( "BuyItems", c_vendorbuy, e_vendorbuy, 89 ), self.process_elements)
	self:add(ml_element:create( "RepairItems", c_vendorrepair, e_vendorrepair, 88 ), self.process_elements)
	
	-- Salvaging
	self:add(ml_element:create( "Salvaging", c_salvage, e_salvage, 75 ), self.process_elements)
		
	-- ReviveNPCs
	self:add(ml_element:create( "ReviveNPC", c_reviveNPC, e_reviveNPC, 70 ), self.process_elements)	
	
	-- Gathering
	self:add(ml_element:create( "Gathering", c_gatherTask, e_gatherTask, 65 ), self.process_elements)
		
	-- Do Quest 
	self:add(ml_element:create( "DoQuest", c_doQuest, e_doQuest, 50 ), self.process_elements)
	
    self:AddTaskCheckCEs()
end

function mc_ai_doquest:task_complete_eval()
	return self.currentQuest == nil or  ml_quest_mgr.QuestIsForMapID(ml_task_hub:CurrentTask().currentQuest, Player:GetLocalMapID()) == false
end
function mc_ai_doquest:task_complete_execute()
    self.completed = true
end

-- C n E's 
------------
c_doQuest = inheritsFrom( ml_cause )
e_doQuest = inheritsFrom( ml_effect )
function c_doQuest:evaluate()
    return ml_task_hub:CurrentTask().currentQuest ~= nil
end
function e_doQuest:execute()
	ml_log("e_doQuest")
	-- Get next QuestStep
	if ( ml_task_hub:CurrentTask().currentStep == nil or ml_task_hub:CurrentTask().currentStep.done == "1" or ( ml_task_hub:CurrentTask().currentStep.script ~= nil and ml_task_hub:CurrentTask().currentStep.script.completed == true)) then
			
		-- Set this step to "Finished" in our character's questprofile progress			-- 									
		if ( ml_task_hub:CurrentTask().currentStep~=nil and ml_task_hub:CurrentTask().currentStep.script ~= nil ) then 
			d("QuestStep "..tostring(ml_task_hub:CurrentTask().currentStep.name).." completed!") 				
			ml_quest_mgr.SetQuestData( ml_task_hub:CurrentTask().currentQuest, ml_task_hub:CurrentTask().currentStep, nil, "done", "1" )
			ml_task_hub:CurrentTask().currentStep = nil
		end
					
		-- Getting next questStep
		ml_task_hub:CurrentTask().currentStep = ml_quest_mgr.GetNextQuestStep( ml_task_hub:CurrentTask().currentQuest )				
		if ( ml_task_hub:CurrentTask().currentStep == nil ) then
			d("All steps of current Quest- "..tostring( ml_task_hub:CurrentTask().currentQuest.name).." -are finished!")
			ml_quest_mgr.SetQuestData( ml_task_hub:CurrentTask().currentQuest, nil, nil, "done", "1" )
							
			-- Reset QuestSteps for repeatable Quests
			if ( ml_task_hub:CurrentTask().currentQuest.repeatable == "1" ) then
				d("Resetting QuestSteps for "..tostring( ml_task_hub:CurrentTask().currentQuest.name))
				ml_quest_mgr.ResetQuest( ml_task_hub:CurrentTask().currentQuest )
			end
			
			d("Saving QuestProgress..")
			ml_quest_mgr.SaveProfile()		
			ml_task_hub:CurrentTask().currentQuest = nil
		end			
	else
		-- Execute currentStep Task
		if ( ml_task_hub:CurrentTask().currentStep.script ~= nil ) then
			ml_task_hub:CurrentTask():AddSubTask(ml_task_hub:CurrentTask().currentStep.script)
			
		else
			ml_error("QuestStep "..tostring(ml_task_hub:CurrentTask().currentStep.name).." has NO script selected!!!!!")
		end			
	end	
end




-- Utility functions
function mc_questmanager.GenerateMapExploreProfile()
	local mdata = mc_datamanager.GetLocalMapData( Player:GetLocalMapID() )
	if ( TableSize(mdata) > 0 and TableSize(mdata["floors"]) > 0 and TableSize(mdata["floors"][0]) > 0) then
		local data = mdata["floors"][0]
		
		-- tasks & sectors have 2D Map coords and level info
		local sectors = mdata["floors"][0]["sectors"]
		local tasks = mdata["floors"][0]["tasks"]		
		local pois = mdata["floors"][0]["points_of_interest"]
		local skillpoints = mdata["floors"][0]["skill_challenges"]
		
				
		
		mc_datamanager.levelmap = {} -- Create a "2D - Levelmap/Table" which provides us an avg. level for all other entries in the zone
		local id,entry = next (sectors)
		while id and entry do			
			local realpos = mc_datamanager.recalc_coords(mdata["continent_rect"], mdata["map_rect"], entry["coord"])
			-- CREATE GOTO SECTOR QUEST
			local position = { x=realpos[1], y=realpos[2], z=-2500}
			mc_questmanager.AddExploreSectorQuest( position, entry, entry["level"] )			
			table.insert(mc_datamanager.levelmap, { pos= position, level = entry["level"] } )			
			id,entry = next(sectors,id)
		end
		
		-- HEARTQUESTS
		local id,entry = next (tasks)
		while id and entry do			
			local realpos = mc_datamanager.recalc_coords(mdata["continent_rect"], mdata["map_rect"], entry["coord"])
			-- CREATE GOTO HEARTQUEST QUEST
			local position = { x=realpos[1], y=realpos[2], z=-2500}
			mc_questmanager.AddDoHeartQuest( position, entry, entry["level"] )	
			table.insert(mc_datamanager.levelmap, {  pos= position, level = entry["level"] } )			
			id,entry = next(tasks,id)
		end
				
		-- POIs
		local id,entry = next (pois)
		while id and entry do
			local realpos = mc_datamanager.recalc_coords(mdata["continent_rect"], mdata["map_rect"], entry["coord"])
			local position = { x=realpos[1], y=realpos[2], z=-2500}
			--d(tostring(entry["type"])..": "..tostring(entry["name"]).." : "..realpos[1].." "..realpos[2].. " Level: "..tostring(mc_questmanager.GetApproxLevel(position )))
			if ( entry["type"] == "waypoint" ) then
				mc_questmanager.AddExploreWaypointQuest( position, entry , mc_questmanager.GetApproxLevel( position ) )
			end
			if ( entry["type"] == "landmark" ) then
				mc_questmanager.AddExploreLandmarkQuest( position, entry , mc_questmanager.GetApproxLevel( position ) )
			end
			if ( entry["type"] == "vista" ) then
				mc_questmanager.AddExploreVistaQuest( position, entry , mc_questmanager.GetApproxLevel( position ) )
			end
			
			id,entry = next(pois,id)
		end		
		
		-- SKILLPOINTS
		local id,entry = next (skillpoints)
		while id and entry do
			local realpos = mc_datamanager.recalc_coords(mdata["continent_rect"], mdata["map_rect"], entry["coord"])
			local position = { x=realpos[1], y=realpos[2], z=-2500}			
			mc_questmanager.AddGetSkillQuest( position, mc_questmanager.GetApproxLevel( position ) )
			id,entry = next(skillpoints,id)
		end	
		
		
		local mapname = mc_datamanager.GetMapName( Player:GetLocalMapID())
		if ( mapname ~= nil and mapname ~= "" and mapname ~= "None" ) then
			gQMnewname = mapname
		end		
		
		ml_quest_mgr.RefreshQuestList()
	else
		d("No Mapdata for our current map found!")
	end
end


function mc_questmanager.GetApproxLevel( pPos )
	local level = { 0 , 80 }
	local dist = 9999999
	local idx = 0
	if ( TableSize(mc_datamanager.levelmap) > 0 and TableSize(pPos) > 0) then
		local i, e = next ( mc_datamanager.levelmap )
		while i and e do
			local dis = Distance2D(e.pos.x, e.pos.y, pPos.x, pPos.y)
			--d(tostring(dis).." "..tostring(idx).." "..tostring(mc_datamanager.levelmap[idx]))
			if ( dis < dist ) then
				dist = dis
				idx = i
			end
			i,e = next( mc_datamanager.levelmap,i)
		end
	end
	if ( idx ~= 0 ) then
		level = mc_datamanager.levelmap[idx].level
	end
	return level
end

function mc_questmanager.AddExploreSectorQuest( pos2D, entry, level)
	local pos3D = NavigationManager:GetClosestPointOnMeshFrom2D( pos2D )
	local Name = entry["name"] or ""
	if ( pos3D and pos3D.x ~= 0 and pos3D.y ~= 0 ) then
		-- use the 2D x,y and the z from the closeestpointonmesh		
		newquest = {
			prio = table.maxn(ml_quest_mgr.QuestList)+1,
			name = Name,
			done = "0",
			minlevel = level + 2,
			maxlevel = 80,
			map = mc_datamanager.GetMapName( Player:GetLocalMapID()),
			mapid = Player:GetLocalMapID(),
			prequest = "None",
			repeatable = "0",
			steps = {
				-- Add a simple ExploreMapObject Step 
				[1] = { prio = 1,
					name = "GoTo "..Name,
					done = "0",
					script = { 
						name = "ExploreMapObject",
						data = {
							GotoX = pos2D.x,
							GotoY = pos2D.y,
							GotoZ = pos3D.z					
						},
					},
				}
			}
		}
		ml_quest_mgr.QuestList[newquest.prio] = newquest		
	else
		d("Sector "..Name.." is NOT on the Navmesh!! ..Not adding it to the QuestProfile")
		--d("Added: "..Name.." "..pos3D.x.." "..pos3D.y.." "..pos3D.z)		
	end
end

function mc_questmanager.AddExploreWaypointQuest( pos2D, entry , level)	

	local pos3D = NavigationManager:GetClosestPointOnMeshFrom2D( pos2D )
	local WPName = entry["name"] or ""
	if ( pos3D and pos3D.x ~= 0 and pos3D.y ~= 0 ) then
		-- use the 2D x,y and the z from the closeestpointonmesh		
		newquest = {
			prio = table.maxn(ml_quest_mgr.QuestList)+1,
			name = WPName,
			done = "0",
			minlevel = level + 2,
			maxlevel = 80,
			map = mc_datamanager.GetMapName( Player:GetLocalMapID()),
			mapid = Player:GetLocalMapID(),
			prequest = "None",
			repeatable = "0",
			steps = {
				-- Add a simple ExploreMapObject Step 
				[1] = { prio = 1,
					name = "GoTo"..WPName,
					done = "0",
					script = { 
						name = "ExploreMapObject",
						data = {
							GotoX = pos2D.x,
							GotoY = pos2D.y,
							GotoZ = pos3D.z					
						},
					},
				}
			}
		}
		ml_quest_mgr.QuestList[newquest.prio] = newquest	
	else
		d("Waypoint "..WPName.." is NOT on the Navmesh!! ..Not adding it to the QuestProfile")
		--d("Added: "..WPName.." "..pos3D.x.." "..pos3D.y.." "..pos3D.z)		
	end
end

function mc_questmanager.AddExploreLandmarkQuest( pos2D, entry , level)	

	local pos3D = NavigationManager:GetClosestPointOnMeshFrom2D( pos2D )
	local WPName = entry["name"] or ""
	if ( pos3D and pos3D.x ~= 0 and pos3D.y ~= 0 ) then
		-- use the 2D x,y and the z from the closeestpointonmesh		
		newquest = {
			prio = table.maxn(ml_quest_mgr.QuestList)+1,
			name = WPName,
			done = "0",
			minlevel = level + 2,
			maxlevel = 80,
			map = mc_datamanager.GetMapName( Player:GetLocalMapID()),
			mapid = Player:GetLocalMapID(),
			prequest = "None",
			repeatable = "0",
			steps = {
				-- Add a simple ExploreMapObject Step 
				[1] = { prio = 1,
					name = "GoTo"..WPName,
					done = "0",
					script = { 
						name = "ExploreMapObject",
						data = {
							GotoX = pos2D.x,
							GotoY = pos2D.y,
							GotoZ = pos3D.z					
						},
					},
				}
			}
		}
		ml_quest_mgr.QuestList[newquest.prio] = newquest		
	else
		d("Landmark "..WPName.." is NOT on the Navmesh!! ..Not adding it to the QuestProfile")
		--d("Added: "..WPName.." "..pos3D.x.." "..pos3D.y.." "..pos3D.z)		
	end
end

function mc_questmanager.AddExploreVistaQuest( pos2D, entry , level)	

	local pos3D = NavigationManager:GetClosestPointOnMeshFrom2D( pos2D )
	local WPName = "Discover Vista"
	if ( pos3D and pos3D.x ~= 0 and pos3D.y ~= 0 ) then
		-- use the 2D x,y and the z from the closeestpointonmesh		
		newquest = {
			prio = table.maxn(ml_quest_mgr.QuestList)+1,
			name = WPName,
			done = "0",
			minlevel = level + 2,
			maxlevel = 80,
			map = mc_datamanager.GetMapName( Player:GetLocalMapID()),
			mapid = Player:GetLocalMapID(),
			prequest = "None",
			repeatable = "0",
			steps = {
				-- Add a simple ExploreVista Step 
				[1] = { prio = 1,
					name = "GoTo"..WPName,
					done = "0",
					script = { 
						name = "ExploreVista",
						data = {
							GotoX = pos2D.x,
							GotoY = pos2D.y,
							GotoZ = pos3D.z					
						},
					},
				}
			}
		}
		ml_quest_mgr.QuestList[newquest.prio] = newquest	
	else
		d("An undiscovered Vista is NOT on the Navmesh!! ..Not adding it to the QuestProfile")
		--d("Added: "..WPName.." "..pos3D.x.." "..pos3D.y.." "..pos3D.z)		
	end
end

function mc_questmanager.AddDoHeartQuest( pos2D, entry , level)	

	local pos3D = NavigationManager:GetClosestPointOnMeshFrom2D( pos2D )
	local WPName = entry["objective"] or ""
	if ( pos3D and pos3D.x ~= 0 and pos3D.y ~= 0 ) then
		-- use the 2D x,y and the z from the closeestpointonmesh		
		newquest = {
			prio = table.maxn(ml_quest_mgr.QuestList)+1,
			name = WPName,
			done = "0",
			minlevel = level + 2,
			maxlevel = 80,
			map = mc_datamanager.GetMapName( Player:GetLocalMapID()),
			mapid = Player:GetLocalMapID(),
			prequest = "None",
			repeatable = "0",
			steps = {
				-- Add a simple GoTo Step 
				[1] = { prio = 1,
					name = "GoTo"..WPName,
					done = "0",
					script = { 
						name = "DoHeartQuest",
						data = {
							GotoX = pos2D.x,
							GotoY = pos2D.y,
							GotoZ = pos3D.z					
						},
					},
				}
			}
		}
		ml_quest_mgr.QuestList[newquest.prio] = newquest		
	else
		d("HeartQuest "..WPName.." is NOT on the Navmesh!! ..Not adding it to the QuestProfile")
		--d("Added: "..WPName.." "..pos3D.x.." "..pos3D.y.." "..pos3D.z)		
	end
end

function mc_questmanager.AddGetSkillQuest( pos2D, level)	

	local pos3D = NavigationManager:GetClosestPointOnMeshFrom2D( pos2D )
	local WPName = "SkillChallenge"
	if ( pos3D and pos3D.x ~= 0 and pos3D.y ~= 0 ) then
		-- use the 2D x,y and the z from the closeestpointonmesh		
		newquest = {
			prio = table.maxn(ml_quest_mgr.QuestList)+1,
			name = WPName,
			done = "0",
			minlevel = level + 2,
			maxlevel = 80,
			map = mc_datamanager.GetMapName( Player:GetLocalMapID()),
			mapid = Player:GetLocalMapID(),
			prequest = "None",
			repeatable = "0",
			steps = {
				-- Add a simple GoToPosition Step 
				[1] = { prio = 1,
					name = "GoTo"..WPName,
					done = "0",
					script = { 
						name = "DoSkillChallenge",
						data = {
							GotoX = pos2D.x,
							GotoY = pos2D.y,
							GotoZ = pos3D.z					
						},
					},
				}
			}
		}
		ml_quest_mgr.QuestList[newquest.prio] = newquest	
	else
		d(WPName.." is NOT on the Navmesh!! ..Not adding it to the QuestProfile")
		--d("Added: "..WPName.." "..pos3D.x.." "..pos3D.y.." "..pos3D.z)		
	end
end