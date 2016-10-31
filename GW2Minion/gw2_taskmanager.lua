gw2_tm_heartquest = {}
gw2_tm_heartquest.lastcheck = 0
function gw2_tm_heartquest:CanTaskRun_TM(taskProperties,customProperties)
	if(TimeSince(gw2_tm_heartquest.lastcheck) > 15000) then
		gw2_tm_heartquest.lastcheck = ml_global_information.Now
		if(table.valid(customProperties)) then
			local MList = MapMarkerList("issubregion")
			if(table.valid(MList)) then
				for _,marker in pairs(MList) do
					if(marker.subregionid == customProperties.hqid and marker.contentid == GW2.MAPMARKER.HeartQuestComplete) then
						return false
					end
				end
			end
		end
	end
	return true
end

gw2_tm_heropoint = {}
gw2_tm_heropoint.lastcheck = 0
function gw2_tm_heartquest:CanTaskRun_TM(taskProperties,customProperties)
	if(TimeSince(gw2_tm_heropoint.lastcheck) > 1000) then
		gw2_tm_heartquest.lastcheck = ml_global_information.Now
		if(Distance3DT(taskProperties.pos,ml_global_information.Player_Position) < 2000) then
			local MList = MapMarkerList("nearest,onmesh,contentid="..GW2.MAPMARKER.SkillpointComplete)
			if(table.valid(MList)) then
				local _,hp = next(MList)
				if(not table.valid(hp) or hp.distance < 500) then
					return false
				end
			end
		end
	end
	return true
end

gw2_taskmanager = {}
function gw2_taskmanager.Init()
	if(ml_task_mgr) then
		ml_task_mgr.min_level = 0
		ml_task_mgr.max_level = 80 
		ml_task_mgr.GetMapName = gw2_datamanager.GetMapName
		ml_task_mgr.btreepath = GetLuaModsPath()..[[GW2Minion\Behavior]]
		ml_task_mgr.taskpath = GetLuaModsPath()..[[GW2Minion\TaskManagerProfiles\]]
		ml_task_mgr.Init()
		
		ml_task_mgr.AddTaskType("tm_grind", "GrindMode.bt", nil, {displayname = GetString("Grind mode")})
		ml_task_mgr.AddTaskType("tm_gather", "GatherMode.bt", nil, {displayname = GetString("Gather mode")})
		ml_task_mgr.AddTaskType("tm_moveto", "blank.st", nil, {allowpretasks = true; displayname = GetString("Move to location")})
		ml_task_mgr.AddTaskType("tm_generic", "blank.st", nil, {allowpretasks = true; allowposttasks = true; allowsubtasks = true; displayname = GetString("Generic task")})
		ml_task_mgr.AddTaskType("tm_wait", "Wait.st", nil, {displayname = GetString("Wait")})
		ml_task_mgr.AddTaskType("tm_vista", "tm_Vista.st", nil, {allowpretasks = true; allowposttasks = true; displayname = GetString("View vista")})
		ml_task_mgr.AddTaskType("tm_heropoint", "blank.st", gw2_tm_heropoint, {allowpretasks = true; allowposttasks = true; allowsubtasks = true; displayname = GetString("Heropoint")})
		ml_task_mgr.AddTaskType("tm_hq", "tm_HeartQuest.st", gw2_tm_heartquest, {allowpretasks = true; allowposttasks = true; allowsubtasks = true; displayname = GetString("Heartquest")})
		
		ml_task_mgr.AddSubTaskType("tm_st_movetomultiple", "tm_MoveToMultiple.st", nil, {displayname = GetString("Move to multiple locations")})
		ml_task_mgr.AddSubTaskType("tm_st_moveto", "tm_MoveTo.st", nil, {displayname = GetString("Move to location")})
		ml_task_mgr.AddSubTaskType("tm_st_interact", "tm_Interact.st", nil, {displayname = GetString("Interact")})
		ml_task_mgr.AddSubTaskType("tm_st_fightaggro", "HandleAggro.st", nil, {displayname = GetString("Fight aggro")})
		ml_task_mgr.AddSubTaskType("tm_st_killspecific", "tm_CombatHandler.st", nil, {displayname = GetString("Kill specific targets")})
		ml_task_mgr.AddSubTaskType("tm_st_hqstatus", "tm_CheckHQStatus.st", nil, {displayname = GetString("Check HQ status")})
		ml_task_mgr.AddSubTaskType("tm_st_talk", "tm_Talk.st", nil, {displayname = GetString("Talk")})
		ml_task_mgr.AddSubTaskType("tm_st_changemesh", "tm_ChangeMesh.st", nil, {displayname = GetString("Change mesh")})
		ml_task_mgr.AddSubTaskType("tm_st_useitem", "tm_UseItem.st", nil, {displayname = GetString("Use inventory item")})
		ml_task_mgr.AddSubTaskType("tm_st_deliver", "tm_DeliverItem.st", nil, {displayname = GetString("Deliver item")})					
	end
end
RegisterEventHandler("Module.Initalize",gw2_taskmanager.Init)
