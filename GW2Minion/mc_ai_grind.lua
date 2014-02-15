-- Grind
mc_ai_grind = inheritsFrom(ml_task)
mc_ai_grind.name = "GrindMode"

function mc_ai_grind.Create()
	local newinst = inheritsFrom(mc_ai_grind)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}
            
    return newinst
end

function mc_ai_grind:Init()

end

function mc_ai_grind:Process()
	--ml_log("Grind_Process->")
		
		
	-- Randomly pick next maingoal and pursue it			
	local i = math.random(0,1)
	
	
	-- Events
	
	
	-- Killsomething nearby
	if ( i == 0 and function() return TableSize(CharacterList("alive,attackable,onmesh,maxdistance=3500,exclude_contentid="..mc_blacklist.GetExcludeString(GetString("monsters")))) == 0 end ) then
		local newTask = mc_ai_combatAttack.Create()
		ml_task_hub:CurrentTask():AddSubTask(newTask)
	
	-- Do Events
	elseif ( i == 2 and gDoEvents == "1") then
		local evList = MapMarkerList("nearest,isevent,onmesh,worldmarkertype="..mc_global.WorldMarkerType..",exclude_eventid="..mc_blacklist.GetExcludeString(GetString("event")))
		local id,ev = next(evList)
		if ( id and ev ) then
			local evi = ev.eventinfo
			if ( evi and evi.level <= Player.level + 3 ) then
				local newTask = mc_ai_event.Create()
				newTask.eventID = ev.eventID
				ml_task_hub:CurrentTask():AddSubTask(newTask)
			end
		end
	
	end
							
	-- Explore
							
	
end

function mc_ai_grind:OnSleep()
	d("mc_ai_grind:OnSleep->")
end

function mc_ai_grind:OnTerminate()
	d("mc_ai_grind:OnTerminate->")
end

function mc_ai_grind:IsGoodToAbort()
	d("mc_ai_grind:IsGoodToAbort->")
end

-- Gets called after the CnEs are evaluated, if true, calls directly task_complete_execute()
function mc_ai_grind:task_complete_eval()	
	return false
end
function mc_ai_grind:task_complete_execute()
    
end





function mc_ai_grind.moduleinit()
	
	
end
if ( mc_global.BotModes) then
	mc_global.BotModes[GetString("grindMode")] = mc_ai_grind
end
RegisterEventHandler("Module.Initalize",mc_ai_grind.moduleinit)