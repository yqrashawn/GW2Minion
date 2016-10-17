gw2_tm_heartquest = {}
gw2_tm_heartquest.lastcheck = 0

function gw2_tm_heartquest.Init()
	ml_task_mgr.AddTaskType("tm_hq", "tm_HeartQuest.st", gw2_tm_heartquest, {allowpretasks = true; allowposttasks = true; allowsubtasks = true; displayname = GetString("taskHeartQuest")})
end
RegisterEventHandler("Module.Initalize",gw2_tm_heartquest.Init)

function gw2_tm_heartquest:CanTaskRun_TM(taskProperties,customProperties)
	if(TimeSince(gw2_tm_heartquest.lastcheck) > 15000) then
		gw2_tm_heartquest.lastcheck = ml_global_information.Now
		if(table.valid(customProperties)) then
			local MList = MapMarkerList("issubregion")
			if(table.valid(MList)) then
				for _,marker in pairs(MList) do
					if(marker.subregionid == customProperties.hqid) then
						if(marker.contentid == GW2.MAPMARKER.HeartQuestComplete) then
							return false
						end
					end
				end
			end
		end
	end
	return true
end
