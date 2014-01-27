-- GrindMode Behavior
mc_ai_grind = {}
mc_ai_grind.BT = {}


function mc_ai_grind.moduleinit()
	-- Never add a predicate or child function like this "mc_core.FALSE()" , always "mc_core.FALSE", or you will call the function instead of passing its name  !!
	mc_ai_grind.BT = mc_core.TreeWalker:new("MainBot",nil,    
		
		-- PrioritySelector:Goes top to bottom, picks the first node that returns "true" or "Running" and calls its childnode
		mc_core.PrioritySelector:new(
			-- Dead?
			mc_core.Decorator:new( function() return Player.dead end, mc_ai_death.BT ),
						
			-- AoELooting Characters
			mc_core.Decorator:new( function() return TableSize(CharacterList( "nearest,lootable,onmesh,maxdistance=900" )) > 0 end, function() return Player:AoELoot() end ),
			
			-- AoELooting Gadgets/Chests needed?
			
			-- Aggro?
			mc_core.Decorator:new( function() return TableSize(CharacterList("nearest,alive,aggro,attackable,maxdistance=1200,onmesh")) > 0 end, mc_ai_combat.DefendBT ),
			
			-- Looting
									
			-- Repair
			
			-- Vendoring
			
			-- Randomly pick next maingoal and pursue it			
			mc_core.RandomSelector:new(	
				
				-- Events
				
				-- Gathering
				
				-- Explore
				
				-- Killsomething nearby		(RepeatUntil(predicate,child,targettime): repeat child() until predicate() true or targettime (in seconds) passed)				
				mc_core.RepeatUntil:new( function() return TableSize(CharacterList("alive,attackable,onmesh,maxdistance=3500")) == 0 end, mc_ai_combat.SeachAndKillBT, math.random(60,240))
				
				
				
				
				--[[-- random choice 2
				mc_core.PrioritySelector:new(
				
					-- we have a target
					mc_core.Decorator:new( function() return Player:GetTarget() ~= nil end, mc_global.Attack ),							
													
					-- we wait 3 seconds
					mc_core.Wait:new( mc_core.FALSE , mc_core.TRUE , 3),
						
					-- try to get a new target					
					mc_core.Decorator:new( function() return Player:GetTarget() == nil end, mc_global.PickNewTarget )
					-- move on to the next marker/spot
					
				)
				]]
			)
		)
	)
	-- Updating the botmode
	mc_global.BotModes[mc_getstring("grindMode")] = mc_ai_grind.BT
end

-- Adding it to our botmodes
if ( mc_global.BotModes ) then
	mc_global.BotModes[mc_getstring("grindMode")] = mc_ai_grind.BT
end 

RegisterEventHandler("Module.Initalize",mc_ai_grind.moduleinit)