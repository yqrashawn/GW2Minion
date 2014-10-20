gw2_common_cne = {}

c_FinishEnemy = inheritsFrom( ml_cause )
e_FinishEnemy = inheritsFrom( ml_effect )
function FinishEnemy()    
	if ( ml_global_information.Player_IsMoving == false and ml_global_information.Player_Health.percent > 15 ) then
		local EList = CharacterList("nearest,downed,aggro,attackable,interactable,selectable,maxdistance=150,onmesh")
		if ( EList ) then
			local id,entity = next (EList)
			if ( id and entity ) then
				if ( entity.isInInteractRange ) then
					local t = Player:GetTarget()
					if ( t and t.id == id ) then						
						Player:Interact( id )
						ml_log("Finishing..")						
						mc_global.Wait(1000)
						return true						
					end
				end
			end
		end
	end
	return false
end