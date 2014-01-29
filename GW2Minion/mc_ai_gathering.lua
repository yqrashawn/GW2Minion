-- Handles Gathering of Ressourcenodes
mc_ai_gathering = {}
mc_ai_gathering.gatheringBT = {}

function mc_ai_gathering.moduleinit()

end

function mc_ai_gathering.NotInGatherRange()
	mc_log("NotInGatherRange")
	local GatherableList = GadgetList( "gatherable,shortestpath,onmesh")
	if ( GatherableList ) then
		local id,node = next (GatherableList)
		if ( id and node ) then
			return (not node.isInInteractRange)
		end
	end
	mc_error("No Gatherable found ")
	return true
end

function mc_ai_gathering.MoveIntoInteractRange()	
	mc_log("MoveIntoInteractRange")
	local GatherableList = GadgetList( "gatherable,shortestpath,onmesh")
	if ( GatherableList ) then
		local id,node = next (GatherableList)
		if ( id and node ) then
			if (not node.isInInteractRange) then
				local tPos = node.pos
				if ( tPos ) then
					local navResult = tostring(Player:MoveTo(tPos.x,tPos.y,tPos.z,50,false,true,true))		
					if (tonumber(navResult) < 0) then
						mc_error("mc_ai_gathering.MoveIntoCombatRange result: "..tonumber(navResult))					
					end
					return "Running"
				end
			else
				Player:StopMovement()
				if ( node.distance < math.random(0,1500) and Player:GetTarget() ~= id ) then
					Player:SetTarget( id )
				end				
				return true
			end
		end
	end
	return false
end


function mc_ai_gathering.Gather()	
	mc_log("Gather")
	local GatherableList = GadgetList( "gatherable,nearest,onmesh")
	if ( GatherableList ) then
		local id,node = next (GatherableList)
		if ( id and node ) then
			if ( node.isInInteractRange) then
				if ( Player:GetCurrentlyCastedSpell() == 17 ) then								
					Player:Interact( id )
					return "Running"
				end			
			else
				mc_error("mc_ai_gathering: We should be in interact range but we are not")
			end
		end
	end
	return false
end


-- Functions used in the BT need to be defined "above" it!
mc_ai_gathering.gatheringBT = mc_core.Sequence:new(
		
	-- Move into interactrange
	mc_core.DecoratorContinue:new( mc_ai_gathering.NotInGatherRange , mc_ai_gathering.MoveIntoInteractRange ),
	
	-- Gather
	mc_core.Action:new( mc_ai_gathering.Gather )
) 
	
RegisterEventHandler("Module.Initalize",mc_ai_gathering.moduleinit)