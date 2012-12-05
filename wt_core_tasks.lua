-- Holds all available functions that each add a new specific Task to the TaskManager

------------------------------------------------------------------
-- Explore Waypoint Task
function wt_core_taskmanager:addWaypointTask( waypoint )
	if ( waypoint ~= nil and waypoint.pos.x ~= 0 and waypoint.pos.y ~= 0 and waypoint.pos.z ~= 0 ) then 
		local explWP = inheritsFrom( wt_task )
		explWP.name = "Explore Waypoint"
		explWP.priority = wt_task.priorities.normal
		explWP.position = {}
		explWP.position.x = waypoint.pos.x
		explWP.position.y = waypoint.pos.y
		explWP.position.z = waypoint.pos.z
		explWP.position.radius = 1000
		function explWP:canRun()			
			return true
		end

		function explWP:execute()			
			if ( not wt_core_taskmanager.behavior == "move" ) then
				wt_core_taskmanager:SetMoveToBehavior()
			end
			local mypos = Player.pos
			local distance =  Distance3D( explWP.position.x, explWP.position.y, explWP.position.z, mypos.x, mypos.y, mypos.z )
			if ( distance > 150 ) then
				--wt_debug("Walking towards new Waypoint ")	
				Player:MoveTo( explWP.position.x, explWP.position.y, explWP.position.z, 200 )
			end		
			explWP.name = "Explore Waypoint, dist: "..(math.floor(distance))
		end

		function explWP:isFinished()
			local mypos = Player.pos
			if ( mypos ~= nil ) then 
				local distance =  Distance3D( explWP.position.x, explWP.position.y, explWP.position.z, mypos.x, mypos.y, mypos.z )
				if ( distance < 250 ) then
					wt_debug("Task Finished " .. explWP.name)
					wt_core_taskmanager:SetDefaultBehavior()
					return true
				end
			end
			return false
		end	
		wt_core_taskmanager:addTask( explWP )
	end
end

------------------------------------------------------------------
-- Explore Point Of Interest Task
function wt_core_taskmanager:addPOITask( poi )
	if ( poi ~= nil and poi.pos.x ~= 0 and poi.pos.y ~= 0 and poi.pos.z ~= 0 ) then 
		local explPoi = inheritsFrom( wt_task )
		explPoi.name = "Explore PointOfInterest"
		explPoi.priority = wt_task.priorities.normal
		explPoi.position = {}
		explPoi.position.x = poi.pos.x
		explPoi.position.y = poi.pos.y
		explPoi.position.z = poi.pos.z
		explPoi.position.radius = 1000
		function explPoi:canRun()			
			return true
		end
		
		function explPoi:execute()
			if ( not wt_core_taskmanager.behavior == "move" ) then
				wt_core_taskmanager:SetMoveToBehavior()
			end
			local mypos = Player.pos
			local distance =  Distance3D( explPoi.position.x, explPoi.position.y, explPoi.position.z, mypos.x, mypos.y, mypos.z )
			if ( distance > 150 ) then
				--wt_debug("Walking towards new PointOfInterest ")	
				Player:MoveTo( explPoi.position.x, explPoi.position.y, explPoi.position.z, 200 )
			end
			explPoi.name = "Explore PointOfInterest, dist: "..(math.floor(distance))
		end

		function explPoi:isFinished()
			local mypos = Player.pos
			if ( mypos ~= nil ) then 
				local distance =  Distance3D( explPoi.position.x, explPoi.position.y, explPoi.position.z, mypos.x, mypos.y, mypos.z )
				if ( distance < 250 ) then
					wt_debug("Task Finished " .. explPoi.name)
					wt_core_taskmanager:SetDefaultBehavior()
					return true
				end
			end
			return false
		end	
		wt_core_taskmanager:addTask( explPoi )
	end
end

------------------------------------------------------------------
-- Kill stuff nearby Task
function wt_core_taskmanager:addSearchAndKillTask(  )
	 
	local newtask = inheritsFrom( wt_task )
	newtask.name = "Search And Kill"
	newtask.priority = wt_task.priorities.normal
	newtask.startingTime = wt_global_information.Now
	newtask.maxduration = math.random(60000,600000)
	
	function newtask:canRun()			
		return true
	end
		
	function newtask:execute()
		if ( not wt_core_taskmanager.behavior == "default" ) then
			wt_core_taskmanager:SetDefaultBehavior()
		end
		TargetList = ( CharacterList( "shortestpath,onmesh,noCritter,attackable,alive,maxdistance="..wt_global_information.MaxSearchEnemyDistance..",maxlevel="..( Player.level + wt_global_information.AttackEnemiesLevelMaxRangeAbovePlayerLevel ) ) )
		if ( TargetList ~= nil ) then 	
			nextTarget, E  = next( TargetList )
			if ( nextTarget ~= nil ) then
				--wt_debug( "TaskManager: Begin Combat, Found target "..nextTarget )
				Player:StopMoving()
				wt_core_state_combat.setTarget( nextTarget )
				wt_core_controller.requestStateChange( wt_core_state_combat )
			end
		end
		newtask.name = "Search And Kill "..(math.floor((newtask.maxduration-(wt_global_information.Now - newtask.startingTime))/1000)).." sec"
	end

	function newtask:isFinished()
		TargetList = ( CharacterList( "nearest,onmesh,noCritter,attackable,alive,maxdistance="..wt_global_information.MaxSearchEnemyDistance..",maxlevel="..( Player.level + wt_global_information.AttackEnemiesLevelMaxRangeAbovePlayerLevel ) ) )
		if ( TargetList ~= nil ) then 	
			return (TableSize( TargetList ) == 0 or (wt_global_information.Now - newtask.startingTime) > newtask.maxduration)		
		end		
		return ((wt_global_information.Now - newtask.startingTime) > newtask.maxduration)
	end	
	wt_core_taskmanager:addTask( newtask )
	
end

------------------------------------------------------------------
-- Fight at FarmSpot Task
function wt_core_taskmanager:addFarmSpotTask( marker )
	 
	local newtask = inheritsFrom( wt_task )	
	newtask.name = "Fight at FarmSpot "
	newtask.priority = wt_task.priorities.normal
	newtask.spotreached = false
	newtask.startingTime = 0
	newtask.position = {}
	newtask.position.x = marker.x
	newtask.position.y = marker.y
	newtask.position.z = marker.z
	newtask.maxduration = math.random(60000,600000)
		
	function newtask:canRun()			
		return true
	end
		
	function newtask:execute()
		if ( not newtask.spotreached ) then
			if ( not wt_core_taskmanager.behavior == "move" ) then
				wt_core_taskmanager:SetMoveToBehavior()
			end
			local me = Player
			local distance =  Distance3D( newtask.position.x, newtask.position.y, newtask.position.z, me.pos.x, me.pos.y, me.pos.z )
			if ( distance > 350 ) then
				--wt_debug("Walking towards FarmSpot Marker ")	
				Player:MoveTo(  newtask.position.x, newtask.position.y, newtask.position.z, 100 )
			else
				newtask.spotreached = true
				newtask.startingTime = wt_global_information.Now
			end
			newtask.name = "MoveTo FarmSpot, dist: "..(math.floor(distance))
		else
			if ( not wt_core_taskmanager.behavior == "default" ) then
				wt_core_taskmanager:SetDefaultBehavior()
			end
			TargetList = ( CharacterList( "shortestpath,onmesh,noCritter,attackable,alive,maxdistance="..wt_global_information.MaxSearchEnemyDistance..",maxlevel="..( Player.level + wt_global_information.AttackEnemiesLevelMaxRangeAbovePlayerLevel ) ) )
			if ( TargetList ~= nil ) then 	
				nextTarget, E  = next( TargetList )
				if ( nextTarget ~= nil ) then
					--wt_debug( "TaskManager: Begin Combat, Found target "..nextTarget )
					Player:StopMoving()
					wt_core_state_combat.setTarget( nextTarget )
					wt_core_controller.requestStateChange( wt_core_state_combat )
				end
			end
			newtask.name = "Fight at FarmSpot "..(math.floor((newtask.maxduration-(wt_global_information.Now - newtask.startingTime))/1000)).." sec"	
		end		
	end

	function newtask:isFinished()
		if ( newtask.spotreached ) then 
			TargetList = ( CharacterList( "nearest,onmesh,noCritter,attackable,alive,maxdistance="..wt_global_information.MaxSearchEnemyDistance..",maxlevel="..( Player.level + wt_global_information.AttackEnemiesLevelMaxRangeAbovePlayerLevel ) ) )
			if ( TargetList ~= nil ) then 	
				return (TableSize( TargetList ) == 0 or (wt_global_information.Now - newtask.startingTime) > newtask.maxduration)		
			end		
			return ((wt_global_information.Now - newtask.startingTime) > newtask.maxduration)
		end
		return false
	end	
	wt_core_taskmanager:addTask( newtask )
	
end

------------------------------------------------------------------
-- Fight at HeartQuest Task
function wt_core_taskmanager:addHeartQuestTask( quest )
	 
	local newtask = inheritsFrom( wt_task )	
	newtask.name = "Fight at HeartQuest"
	newtask.priority = wt_task.priorities.normal
	newtask.spotreached = false
	newtask.startingTime = 0
	newtask.position = {}
	newtask.position.x = quest.pos.x
	newtask.position.y = quest.pos.y
	newtask.position.z = quest.pos.z
	newtask.maxduration = math.random(60000,600000)
		
	function newtask:canRun()			
		return true
	end
		
	function newtask:execute()
		if ( not newtask.spotreached ) then
			if ( not wt_core_taskmanager.behavior == "move" ) then
				wt_core_taskmanager:SetMoveToBehavior()
			end
			local me = Player
			local distance =  Distance3D( newtask.position.x, newtask.position.y, newtask.position.z, me.pos.x, me.pos.y, me.pos.z )
			if ( distance > 350 ) then
				--wt_debug("Walking towards FarmSpot Marker ")	
				Player:MoveTo(  newtask.position.x, newtask.position.y, newtask.position.z, 100 )
			else
				newtask.spotreached = true
				newtask.startingTime = wt_global_information.Now
			end
			newtask.name = "Fight at HeartQuest, dist: "..(math.floor(distance))
		else
			if ( not wt_core_taskmanager.behavior == "default" ) then
				wt_core_taskmanager:SetDefaultBehavior()
			end
			local me = Player
			local distance =  Distance3D( newtask.position.x, newtask.position.y, newtask.position.z, me.pos.x, me.pos.y, me.pos.z )
			if ( distance > 4000 ) then
				--wt_debug("Walking towards FarmSpot Marker ")	
				Player:MoveTo(  newtask.position.x, newtask.position.y, newtask.position.z, 1000 )
			else
				TargetList = ( CharacterList( "shortestpath,onmesh,noCritter,attackable,alive,maxdistance="..wt_global_information.MaxSearchEnemyDistance..",maxlevel="..( Player.level + wt_global_information.AttackEnemiesLevelMaxRangeAbovePlayerLevel ) ) )
				if ( TargetList ~= nil ) then 	
					nextTarget, E  = next( TargetList )
					if ( nextTarget ~= nil ) then
						--wt_debug( "TaskManager: Begin Combat, Found target "..nextTarget )
						Player:StopMoving()
						wt_core_state_combat.setTarget( nextTarget )
						wt_core_controller.requestStateChange( wt_core_state_combat )
					end
				end
			end
			newtask.name = "Fight at FarmSpot "..(math.floor((newtask.maxduration-(wt_global_information.Now - newtask.startingTime))/1000)).." sec"
		end		
	end

	function newtask:isFinished()
		if ( newtask.spotreached ) then 
			local TargetID = Player:GetTarget()
			local Target = nil
			if ( TargetID ~= 0 ) then
				Target = CharacterList:Get( TargetID )
			end
			if ( Target == nil or not Target.alive ) then
				TargetList = ( CharacterList( "shortestpath,onmesh,noCritter,attackable,alive,maxdistance="..wt_global_information.MaxSearchEnemyDistance..",maxlevel="..( Player.level + wt_global_information.AttackEnemiesLevelMaxRangeAbovePlayerLevel ) ) )
				if ( TargetList ~= nil ) then 	
					return (TableSize( TargetList ) == 0 or wt_global_information.Now - newtask.startingTime > newtask.maxduration)		
				end
			end
			return (wt_global_information.Now - newtask.startingTime > newtask.maxduration)
		end
		return false
	end	
	wt_core_taskmanager:addTask( newtask )
	
end

