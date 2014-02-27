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
	if ( self.currentQuest == nil ) then
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

function mc_questmanager.GenerateMapExploreProfile()
	local mdata = mc_datamanager.GetLocalMapData( Player:GetLocalMapID() )
	if ( TableSize(mdata) > 0 and TableSize(mdata["floors"]) > 0 and TableSize(mdata["floors"][0]) > 0) then
		local data = mdata["floors"][0]
		
		-- tasks & sectors have 2D Map coords and level info
		local sectors = mdata["floors"][0]["sectors"]
		local tasks = mdata["floors"][0]["tasks"]		
		local pois = mdata["floors"][0]["points_of_interest"]
		local skillpoints = mdata["floors"][0]["skill_challenges"]
		
				
		
		local levelmap = {} -- Create a "2D - Levelmap/Table" which provides us an avg. level for all other entries in the zone
		local id,entry = next (sectors)
		while id and entry do			
			local realpos = mc_datamanager.recalc_coords(mdata["continent_rect"], mdata["map_rect"], entry["coord"])
			-- CREATE GOTO SECTOR QUEST
			mc_questmanager.AddExploreSectorQuest( realpos, entry, entry["level"] )			
			table.insert(levelmap, { pos = realpos, level = entry["level"] } )			
			id,entry = next(sectors,id)
		end
		
		-- HEARTQUESTS
		local id,entry = next (tasks)
		while id and entry do			
			local realpos = mc_datamanager.recalc_coords(mdata["continent_rect"], mdata["map_rect"], entry["coord"])
			-- CREATE GOTO HEARTQUEST QUEST
			mc_questmanager.AddDoHeartQuest( realpos, entry, entry["level"] )	
			table.insert(levelmap, { pos = realpos, level = entry["level"] } )			
			id,entry = next(tasks,id)
		end
				
		-- POIs
		local id,entry = next (pois)
		while id and entry do
			local realpos = mc_datamanager.recalc_coords(mdata["continent_rect"], mdata["map_rect"], entry["coord"])
			--d(tostring(entry["type"])..": "..tostring(entry["name"]).." : "..realpos[1].." "..realpos[2].. " Level: "..tostring(mc_questmanager.GetApproxLevel( levelmap, realpos )))
			if ( entry["type"] == "waypoint" ) then
				mc_questmanager.AddExploreWaypointQuest( realpos, entry , mc_questmanager.GetApproxLevel( levelmap, realpos ) )
			end
			if ( entry["type"] == "landmark" ) then
				mc_questmanager.AddExploreLandmarkQuest( realpos, entry , mc_questmanager.GetApproxLevel( levelmap, realpos ) )
			end
			if ( entry["type"] == "vista" ) then
				mc_questmanager.AddExploreVistaQuest( realpos, entry , mc_questmanager.GetApproxLevel( levelmap, realpos ) )
			end
			
			id,entry = next(pois,id)
		end		
		
		-- SKILLPOINTS
		local id,entry = next (skillpoints)
		while id and entry do
			local realpos = mc_datamanager.recalc_coords(mdata["continent_rect"], mdata["map_rect"], entry["coord"])
			--d(tostring(entry["name"]).." : "..realpos[1].." "..realpos[2].. " Level: "..tostring(mc_questmanager.GetApproxLevel( levelmap, realpos )))			
			mc_questmanager.AddGetSkillQuest( realpos, mc_questmanager.GetApproxLevel( levelmap, realpos ) )
			id,entry = next(skillpoints,id)
		end	
		
		
		ml_quest_mgr.RefreshQuestList()
	else
		ml_error("No Mapdata for our current map found!")
	end
end


function mc_questmanager.GetApproxLevel( levelmap, pPos )
	local level = { 0 , 80 }
	local dist = 999999999
	local idx = 0
	if ( TableSize(levelmap) > 0 and TableSize(pPos) > 0) then
		local i, e = next ( levelmap )
		while i and e do
			local dis = Distance2D(e.pos[1], e.pos[2], pPos[1], pPos[2])
			--d(tostring(dis).." "..tostring(idx).." "..tostring(levelmap[idx]))
			if ( dis < dist ) then
				dist = dis
				idx = i
			end
			i,e = next( levelmap,i)
		end
	end
	if ( idx ~= 0 ) then
		level = levelmap[idx].level
	end
	return level
end

function mc_questmanager.AddExploreSectorQuest( pos2D, entry, level)
	local pos3D = NavigationManager:GetClosestPointOnMeshFrom2D( {x=pos2D[1], y=pos2D[2] , z=-2500 })
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
				-- Add a simple GoToPosition Step 
				[1] = { prio = 1,
					name = "GoTo "..Name,
					done = "0",
					script = { 
						name = "GotoPosition",
						data = {
							GotoX = pos2D[1],
							GotoY = pos2D[2],
							GotoZ = pos3D.z					
						},
					},
				}
			}
		}
		ml_quest_mgr.QuestList[newquest.prio] = newquest		
	else
		ml_error("Sector "..Name.." is NOT on the Navmesh!! ..Not adding it to the QuestProfile")
		--d("Added: "..Name.." "..pos3D.x.." "..pos3D.y.." "..pos3D.z)		
	end
end

function mc_questmanager.AddExploreWaypointQuest( pos2D, entry , level)	

	local pos3D = NavigationManager:GetClosestPointOnMeshFrom2D( {x=pos2D[1], y=pos2D[2] , z=-2500 })
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
				-- Add a simple GoToPosition Step 
				[1] = { prio = 1,
					name = "GoTo"..WPName,
					done = "0",
					script = { 
						name = "GotoPosition",
						data = {
							GotoX = pos2D[1],
							GotoY = pos2D[2],
							GotoZ = pos3D.z					
						},
					},
				}
			}
		}
		ml_quest_mgr.QuestList[newquest.prio] = newquest	
	else
		ml_error("Waypoint "..WPName.." is NOT on the Navmesh!! ..Not adding it to the QuestProfile")
		--d("Added: "..WPName.." "..pos3D.x.." "..pos3D.y.." "..pos3D.z)		
	end
end

function mc_questmanager.AddExploreLandmarkQuest( pos2D, entry , level)	

	local pos3D = NavigationManager:GetClosestPointOnMeshFrom2D( {x=pos2D[1], y=pos2D[2] , z=-2500 })
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
				-- Add a simple GoToPosition Step 
				[1] = { prio = 1,
					name = "GoTo"..WPName,
					done = "0",
					script = { 
						name = "GotoPosition",
						data = {
							GotoX = pos2D[1],
							GotoY = pos2D[2],
							GotoZ = pos3D.z					
						},
					},
				}
			}
		}
		ml_quest_mgr.QuestList[newquest.prio] = newquest		
	else
		ml_error("Landmark "..WPName.." is NOT on the Navmesh!! ..Not adding it to the QuestProfile")
		--d("Added: "..WPName.." "..pos3D.x.." "..pos3D.y.." "..pos3D.z)		
	end
end

function mc_questmanager.AddExploreVistaQuest( pos2D, entry , level)	

	local pos3D = NavigationManager:GetClosestPointOnMeshFrom2D( {x=pos2D[1], y=pos2D[2] , z=-2500 })
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
							GotoX = pos2D[1],
							GotoY = pos2D[2],
							GotoZ = pos3D.z					
						},
					},
				}
			}
		}
		ml_quest_mgr.QuestList[newquest.prio] = newquest	
	else
		ml_error("An undiscovered Vista is NOT on the Navmesh!! ..Not adding it to the QuestProfile")
		--d("Added: "..WPName.." "..pos3D.x.." "..pos3D.y.." "..pos3D.z)		
	end
end

function mc_questmanager.AddDoHeartQuest( pos2D, entry , level)	

	local pos3D = NavigationManager:GetClosestPointOnMeshFrom2D( {x=pos2D[1], y=pos2D[2] , z=-2500 })
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
						name = "GotoPosition",
						data = {
							GotoX = pos2D[1],
							GotoY = pos2D[2],
							GotoZ = pos3D.z					
						},
					},
				}
			}
		}
		ml_quest_mgr.QuestList[newquest.prio] = newquest		
	else
		ml_error("HeartQuest "..WPName.." is NOT on the Navmesh!! ..Not adding it to the QuestProfile")
		--d("Added: "..WPName.." "..pos3D.x.." "..pos3D.y.." "..pos3D.z)		
	end
end

function mc_questmanager.AddGetSkillQuest( pos2D, level)	

	local pos3D = NavigationManager:GetClosestPointOnMeshFrom2D( {x=pos2D[1], y=pos2D[2] , z=-2500 })
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
							GotoX = pos2D[1],
							GotoY = pos2D[2],
							GotoZ = pos3D.z					
						},
					},
				}
			}
		}
		ml_quest_mgr.QuestList[newquest.prio] = newquest	
	else
		ml_error(WPName.." is NOT on the Navmesh!! ..Not adding it to the QuestProfile")
		--d("Added: "..WPName.." "..pos3D.x.." "..pos3D.y.." "..pos3D.z)		
	end
end