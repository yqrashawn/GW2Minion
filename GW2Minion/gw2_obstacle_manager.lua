gw2_obstacle_manager = {}
gw2_obstacle_manager.ticks = 0
gw2_obstacle_manager.obstacles = {}
gw2_obstacle_manager.avoidanceareas = {}

local ObstacleOptions = {
	id = nil;
	pos = {};
	time = nil;
	duration = true; -- ms, true until reload
	radius = 150;
	refid = nil;
	showAddMessage = true;
}

local AvoidanceAreaOptions = {
	id = nil;
	pos = {};
	time = nil;
	duration = true; -- ms, true until reload
	radius = 25;
	showAddMessage = true;
}

-- Add
function gw2_obstacle_manager.AddObstacle(options)
	options = (options and table_merge(ObstacleOptions,options) or ObstacleOptions)

	if(ValidTable(options.pos)) then
		local newpos = NavigationManager:GetClosestPointOnMesh(options.pos)
		if(newpos ~= nil) then
			options.pos.z = newpos.z
		end

		local add = true

		local i,existing = next(gw2_obstacle_manager.obstacles)	
		while i and existing and add do
			if(existing.pos.x == options.pos.x and existing.pos.y == options.pos.y and existing.pos.z == options.pos.z) then
				add = false
			end
			i,existing = next(gw2_obstacle_manager.obstacles,i)
		end

		if(add) then
			local obstacle = deepcopy(options)
			local refid = NavigationManager:AddNavObstacle({x = options.pos.x, y = options.pos.y, z = options.pos.z, r = options.radius})
			obstacle.id = obstacle.id and obstacle.id or refid
			obstacle.refid = refid
			obstacle.time = options.time or ml_global_information.Now
			table.insert(gw2_obstacle_manager.obstacles, obstacle)
			
			if(options.showAddMessage) then
				if(type(obstacle.duration) == "number") then
					d("Obstacle added with duration : "..math.ceil(obstacle.duration/1000).."s")
				else
					d("Obstacle added.")
				end
			end
			return refid
		end
	end
	return false
end

function gw2_obstacle_manager.AddObstacleAtTarget(target,options)
	options = (options and table_merge(ObstacleOptions,options) or ObstacleOptions)
	local refids = {}
	if(ValidTable(target)) then
			
		if(options.radius <= target.radius) then
			local l = target.radius
			local pos = target.pos
			local c = math.ceil(l/options.radius) + (math.ceil(l/options.radius) % 2)
			local half = c/2
			local start = 1
		
			if(options.showAddMessage) then
				d("Splitting the obstacle in multiple parts.")
			end
			
			for i=1,c do
				local opt = deepcopy(options)
				local newpos = { z = pos.z }

				local addPos = options.radius
				local a,x,y = 0
				
				if(i > half) then
					x = pos.x + (start*addPos)
					y = pos.y + (start*addPos)
					a = 45
				else
					x = pos.x - (start*addPos)
					y = pos.y - (start*addPos)
					a = -45
				end

				if(start == half) then
					start = 1
				else
					start = start + 1
				end

				a = a*(math.pi/180)
				local a2 = (-90*(math.pi/180))-math.atan2(pos.hy,pos.hx)

				local pos1 = {x = x, y = y, z = pos.z}
				local pos2 = gw2_obstacle_manager.RotatePosition(pos1, pos, a)
				local pos3 = gw2_obstacle_manager.RotatePosition(pos2, pos, a2)

				newpos = pos3
				opt.pos = newpos
				opt.showAddMessage = false
				
				local refid = gw2_obstacle_manager.AddObstacle(opt)
				if(refid) then
					table.insert(refids, refid)
				end
			end
		end

		options.pos = target.pos
		
		local refid = gw2_obstacle_manager.AddObstacle(options)
		if(refid) then
			table.insert(refids, refid)
		end

	end

	return refids
end

function gw2_obstacle_manager.AddAvoidanceArea(options)
	options = (options and table_merge(AvoidanceAreaOptions,options) or AvoidanceAreaOptions)
	if(ValidTable(options.pos)) then
		local newpos = NavigationManager:GetClosestPointOnMesh(options.pos)
		if(newpos ~= nil) then
			options.pos.z = newpos.z
		end

		local add = true
		local i,existing = next(gw2_obstacle_manager.avoidanceareas)
		
		while i and existing and add do
			if(existing.pos.x == options.pos.x and existing.pos.y == options.pos.y and existing.pos.z == options.pos.z) then
				add = false
			end
			i,existing = next(gw2_obstacle_manager.avoidanceareas,i)
		end
		
		if(add) then
			
			options.time = options.time or ml_global_information.Now
			table.insert(gw2_obstacle_manager.avoidanceareas, options)
			
			if(options.showAddMessage) then
				if(type(options.duration) == "number") then
					d("Avoidance area added with duration : "..math.ceil(options.duration/1000).."s")
				else
					d("Avoidance area added.")
				end
			end
			
			gw2_obstacle_manager.SetupAvoidanceAreas()
		end
	end
end

function gw2_obstacle_manager.AddAvoidanceAreaAtTarget(target, options)
	options = (options and table_merge(AvoidanceAreaOptions,options) or AvoidanceAreaOptions)
	if(ValidTable(target)) then
		options.pos = target.pos
		options.radius = options.radius or target.radius
		gw2_obstacle_manager.AddAvoidanceArea(options)
	end
end

-- Remove
function gw2_obstacle_manager.RemoveObstacle(options)
	options = (options and table_merge(ObstacleOptions,options) or ObstacleOptions)
	if(ValidTable(options.pos)) then
		for i,obstacle in pairs(gw2_obstacle_manager.obstacles) do
			if(obstacle.refid and obstacle.pos.x == options.pos.x and obstacle.pos.y == options.pos.y and obstacle.pos.z == options.pos.z) then
				NavigationManager:RemoveNavObstacle(obstacle.refid)
				table.remove(gw2_obstacle_manager.obstacles,i)
			end
		end
	end
end

function gw2_obstacle_manager.RemoveObstacleByID(options)
	options = (options and table_merge(ObstacleOptions,options) or ObstacleOptions)
	if(options.id ~= nil) then
		for i,obstacle in pairs(gw2_obstacle_manager.obstacles) do
			if(obstacle.refid and obstacle.id == options.id) then
				NavigationManager:RemoveNavObstacle(obstacle.refid)
				table.remove(gw2_obstacle_manager.obstacles,i)
			end
		end
	end
end

function gw2_obstacle_manager.RemoveAvoidanceArea(options)
	options = (options and table_merge(AvoidanceAreaOptions,options) or AvoidanceAreaOptions)
	if(ValidTable(options.pos)) then
		for i,obstacle in pairs(gw2_obstacle_manager.avoidanceareas) do
			if(obstacle.pos.x == options.pos.x and obstacle.pos.y == options.pos.y and obstacle.pos.z == options.pos.z) then
				table.remove(gw2_obstacle_manager.avoidanceareas,i)
			end
		end
	end
end

function gw2_obstacle_manager.RemoveAvoidanceAreaByID(id)
	if(id ~= nil) then
		for i,obstacle in pairs(gw2_obstacle_manager.avoidanceareas) do
			if(obstacle.id == id) then
				table.remove(gw2_obstacle_manager.avoidanceareas,i)
			end
		end
	end
end


-- Utility
function gw2_obstacle_manager.RotatePosition(pos, oldpos, angle)
	local x,y = 0

	if(angle >= 0) then
		x = oldpos.x + ((pos.x-oldpos.x)*math.cos(angle)) - ((pos.y-oldpos.y)*math.sin(angle));
		y = oldpos.y + ((pos.x-oldpos.x)*math.sin(angle)) + ((pos.y-oldpos.y)*math.cos(angle));
	else
		x = oldpos.x + ((pos.x-oldpos.x)*math.cos(angle)) + ((pos.y-oldpos.y)*math.sin(angle));
		y = oldpos.y + (-math.sin(angle)*(pos.x-oldpos.x)) + ((pos.y-oldpos.y)*math.cos(angle));
	end

	return {x = x, y = y, z = pos.z}
end

function gw2_obstacle_manager.SetupAvoidanceAreas()
	if(ValidTable(gw2_obstacle_manager.avoidanceareas)) then
		local avoidance = {}
		for _,obstacle in pairs(gw2_obstacle_manager.avoidanceareas) do
			table.insert(avoidance, {x = obstacle.pos.x, y = obstacle.pos.y, z = obstacle.pos.z, r = obstacle.radius})
		end
		NavigationManager:SetAvoidanceAreas(avoidance)
	end
end

function gw2_obstacle_manager.OnUpdateHandler(tick)
	if(TimeSince(gw2_obstacle_manager.ticks) > tonumber(gPulseTime)) then
		for i,obstacle in pairs(gw2_obstacle_manager.obstacles) do
			if(type(obstacle.time) == "number" and type(obstacle.duration) == "number" and TimeSince(obstacle.time) > obstacle.duration) then
				NavigationManager:RemoveNavObstacle(obstacle.refid)
				table.remove(gw2_obstacle_manager.obstacles, i)
			end
		end
		
		local avoidanceRemoved = false
		for i,obstacle in pairs(gw2_obstacle_manager.avoidanceareas) do
			if(type(obstacle.time) == "number" and type(obstacle.duration) == "number" and TimeSince(obstacle.time) > obstacle.duration) then
				avoidanceRemoved = true
				table.remove(gw2_obstacle_manager.avoidanceareas, i)
			end
		end
		
		if(avoidanceRemoved) then
			gw2_obstacle_manager.SetupAvoidanceAreas()
		end
	end
end

RegisterEventHandler("Gameloop.Update",gw2_obstacle_manager.OnUpdateHandler)