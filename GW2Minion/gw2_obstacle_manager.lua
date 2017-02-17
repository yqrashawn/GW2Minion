gw2_obstacle_manager = {}
gw2_obstacle_manager.ticks = 0
gw2_obstacle_manager.obstacles = {}
gw2_obstacle_manager.avoidanceareas = {}

local AvoidanceAreaOptions = {
	id = nil;
	pos = {};
	time = nil;
	duration = true; -- ms, true until reload
	radius = 50;
	showAddMessage = true;
}

function gw2_obstacle_manager.AddAvoidanceArea(options)
	options = deepcopy(options and table.merge(AvoidanceAreaOptions,options) or AvoidanceAreaOptions)
	if(table.valid(options.pos)) then
		local newpos = NavigationManager:GetClosestPointOnMesh(options.pos)
		if(newpos ~= nil) then
			options.pos.z = newpos.z
		end

		local add = true
		local i,existing = next(gw2_obstacle_manager.avoidanceareas)
		
		while i and existing and add do
			if(math.distance2d(existing.pos,options.pos) < existing.radius) then
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
	options = deepcopy(options and table.merge(AvoidanceAreaOptions,options) or AvoidanceAreaOptions)
	if(table.valid(target)) then
		options.pos = target.pos
		options.radius = options.radius or target.radius
		gw2_obstacle_manager.AddAvoidanceArea(options)
	end
end

-- Remove
function gw2_obstacle_manager.RemoveAvoidanceArea(options)
	options = deepcopy(options and table.merge(AvoidanceAreaOptions,options) or AvoidanceAreaOptions)
	if(table.valid(options.pos)) then
		for i,obstacle in pairs(gw2_obstacle_manager.avoidanceareas) do
			if(obstacle.pos.x == options.pos.x and obstacle.pos.y == options.pos.y and obstacle.pos.z == options.pos.z) then
				table.remove(gw2_obstacle_manager.avoidanceareas,i)
				gw2_obstacle_manager.SetupAvoidanceAreas()
			end
		end
	end
end

function gw2_obstacle_manager.RemoveAvoidanceAreaByID(id)
	if(id ~= nil) then
		for i,obstacle in pairs(gw2_obstacle_manager.avoidanceareas) do
			if(obstacle.id == id) then
				table.remove(gw2_obstacle_manager.avoidanceareas,i)
				gw2_obstacle_manager.SetupAvoidanceAreas()
			end
		end
	end
end

function gw2_obstacle_manager.SetupAvoidanceAreas()
	if(table.valid(gw2_obstacle_manager.avoidanceareas)) then
		for _,obstacle in pairs(gw2_obstacle_manager.avoidanceareas) do
			ml_navigation:AddAvoidanceArea(obstacle.pos, obstacle.radius)
		end
		NavigationManager:SetAvoidanceAreas(ml_navigation.avoidanceareas)
	end
end

function gw2_obstacle_manager.OnUpdateHandler(_,tick)
	if(TimeSince(gw2_obstacle_manager.ticks) > BehaviorManager:GetTicksThreshold()) then
		gw2_obstacle_manager.ticks = tick
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