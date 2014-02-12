-- Handles Events
mc_ai_events = {}

c_doEvents = inheritsFrom( ml_cause )
e_doEvents = inheritsFrom( ml_effect )
function c_doEvents:evaluate()
	
	
	return 
end
function e_doEvents:execute()
	ml_log("e_doEvents")
	local GatherableList = GadgetList( "gatherable,shortestpath,onmesh")
	if ( GatherableList ) then
		local id,node = next (GatherableList)
		if ( id and node ) then
			
			if (not node.isInInteractRange) then
				-- MoveIntoInteractRange
				local tPos = node.pos
				if ( tPos ) then
					local navResult = tostring(Player:MoveTo(tPos.x,tPos.y,tPos.z,50,false,true,true))		
					if (tonumber(navResult) < 0) then
						ml_error("mc_ai_gathering.MoveIntoCombatRange result: "..tonumber(navResult))					
					end
					ml_log("MoveToGatherable..")
					return true
				end
			else
				-- Grab that thing
				Player:StopMovement()
				local t = Player:GetTarget()
				if ( node.selectable and (not t or t.id ~= id )) then
					Player:SetTarget( id )
				else
					-- yeah I know, but this usually doesnt break ;)
					if ( Player:GetCurrentlyCastedSpell() == 17 ) then	
						Player:Interact( id )
						ml_log("Gathering..")
						mc_global.Wait(1000)
						return true
					end	
				end			
			end
		end
	end
	return ml_log(false)
end