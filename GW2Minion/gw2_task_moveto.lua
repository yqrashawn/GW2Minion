-- Moveto task
-- For navigating to further away targets or points, do not use this for short range combat navigation, it will be slow, very slow
-- This task should handle movement, antistuck and do basic things to handle stucks, we'll see how it develops 
gw2_task_moveto = inheritsFrom(ml_task)
gw2_task_moveto.name = "MoveTo"

function gw2_task_moveto.Create()
	local newinst = inheritsFrom(gw2_task_moveto)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}
	
	newinst.targetPos = nil
	newinst.targetID = nil
	newinst.targetRadius = 25
	newinst.stoppingDistance = 25
	newinst.use3d = true
	
	newinst.followNavSystem = false
	newinst.randomMovement = false
	newinst.smoothTurns = true
	
	newinst.stuckCount = 0
	newinst.stuckTimer = 0
	newinst.stuckRandomPos = nil
    return newinst
end

function gw2_task_moveto:Process()
	ml_log("MoveTo")
	if ( ValidTable(ml_task_hub:CurrentTask().targetPos) ) then
	
		local dist = Distance3D(ml_task_hub:CurrentTask().targetPos.x,ml_task_hub:CurrentTask().targetPos.y,ml_task_hub:CurrentTask().targetPos.z,ml_global_information.Player_Position.x,ml_global_information.Player_Position.y,ml_global_information.Player_Position.z)
		if ( not ml_task_hub:CurrentTask().use3d ) then
			dist = Distance3D(ml_task_hub:CurrentTask().targetPos.x,ml_task_hub:CurrentTask().targetPos.y,ml_global_information.Player_Position.x,ml_global_information.Player_Position.y)
		end
		
		-- Check for valid targetID only when in <2500 range, because gamedata tends to fade at distances. Update data in case it finds the target.
		if ( dist < 2500 ) then
			-- Charlist
			-- Gadgetlist
			-- check for closest point on mesh to compensate for 3D vs mesh differences
			
		end
		
		
		if ( dist <= ml_task_hub:CurrentTask().stoppingDistance + ml_task_hub:CurrentTask().targetRadius ) then
			ml_task_hub:CurrentTask().completed = true
		else			
			local newnodecount = Player:MoveTo(ml_task_hub:CurrentTask().targetPos.x,ml_task_hub:CurrentTask().targetPos.y,ml_task_hub:CurrentTask().targetPos.z,25+ml_task_hub:CurrentTask().targetRadius,ml_task_hub:CurrentTask().followNavSystem,ml_task_hub:CurrentTask().randomMovement,ml_task_hub:CurrentTask().smoothTurns)
						
			if ( ml_global_information.ShowDebug and newnodecount ~= dbPNodes ) then
				dbPNodesLast = dbPNodes
				dbPNodes = newnodecount
			end			
			-- Check for increased node count when the targetpos is the same to prevent back n forth twisting and stuck 
			
			
			-- Errorhandling
			if ( newnodecount < 0 ) then			
			--[[
			-1 : Startpoint not on navmesh
			-2 : Endpoint not on navmesh
			-3 : No path between start and endpoint found
			-4 : Path between start and endpoint has a lenght of 0
			-5 : No path between start and endpoint found
			-6 : Couldn't find a path
			-7 : Distance Playerpos-Targetpos < stoppingthreshold
			-8 : NavMesh is not ready/loaded
			-9 : Player object not valid
			-10 : Moveto coordinates are crap
			]]
				
				if ( newnodecount == -1 ) then
					-- try to get to the closest point on the navmesh first
					-- NavigationManager:GetPointToMeshDistance(x,y,z)
					-- NavigationManager:GetClosestPointOnMesh(x,y,z)
				elseif ( newnodecount == -2 ) then
					-- try to get instead to the closest point near the endpoint on the navmesh
					-- NavigationManager:GetPointToMeshDistance(x,y,z)
					-- NavigationManager:GetClosestPointOnMesh(x,y,z)
				else
					
					ml_log("gw2_task_moveto: No Valid Path : "..tostring(newnodecount))
					ml_task_hub:CurrentTask().completed = true
				
				end
			
			end			
			
		end
		
		if ( ml_global_information.ShowDebug ) then 
			dbTPos = (math.floor(ml_task_hub:CurrentTask().targetPos.x * 10) / 10).." / "..(math.floor(ml_task_hub:CurrentTask().targetPos.y * 10) / 10).." / "..(math.floor(ml_task_hub:CurrentTask().targetPos.z * 10) / 10)
			dbTDist = dist
			dbPStopDist = ml_task_hub:CurrentTask().stoppingDistance
			dbTID = tostring(ml_task_hub:CurrentTask().targetID)
			dbStuckCount = stuckCount
			dbStuckTmr = stuckTimer
			if ( ValidTable(ml_task_hub:CurrentTask().stuckRandomPos) ) then
				dbStuckRPos = (math.floor(ml_task_hub:CurrentTask().stuckRandomPos.x * 10) / 10).." / "..(math.floor(ml_task_hub:CurrentTask().stuckRandomPos.y * 10) / 10).." / "..(math.floor(ml_task_hub:CurrentTask().stuckRandomPos.z * 10) / 10)
			else
				dbStuckRPos = "0/0/0"
			end
		end
	
	
	else
		ml_log("gw2_task_moveto: No Valid targetPos!")
		ml_task_hub:CurrentTask().completed = true
	end
	
	-- Blocked by gadget check
	-- Water check
	-- Stuck check
	-- Cast Speedbuff check
	-- AoELoot check ? -> common OnUpdate probably	
	
end

function gw2_task_moveto.ModuleInit()
	d("gw2_task_moveto:ModuleInit")
	
	-- Setup Debug fields
	local dw = WindowManager:GetWindow(gw2minion.DebugWindow.Name)
	if ( dw ) then
		dw:NewField("PathNodes","dbPNodes","Task_MoveTo")
		dw:NewField("LastPathNodes","dbPNodesLast","Task_MoveTo")
		dw:NewField("PathStoppingDist","dbPStopDist","Task_MoveTo")
		dw:NewField("TargetPos","dbTPos","Task_MoveTo")
		dw:NewField("TargetDist","dbTDist","Task_MoveTo")
		dw:NewField("TargetID","dbTID","Task_MoveTo")		
		dw:NewField("StuckCount","dbStuckCount","Task_MoveTo")
		dw:NewField("StuckTmr","dbStuckTmr","Task_MoveTo")
		dw:NewField("StuckRandomPos","dbStuckRPos","Task_MoveTo")		
	end
end

RegisterEventHandler("Module.Initalize",gw2_task_moveto.ModuleInit)
