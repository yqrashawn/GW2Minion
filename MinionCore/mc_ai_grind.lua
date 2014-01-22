
--[[
mc_global.ai_grind = mc_core.TreeWalker:new("MainBot",nil,
    mc_core.Sequence:new(	
							-- Continue when we have a target, else pick a new one
							mc_core.DecoratorContinue:new( function() return Player:GetTarget() == 0 end, mc_global.PickNewTarget ),
							mc_core.DecoratorContinue:new( mc_global.hastarget, mc_global.Attack() ),
							mc_core.Wait:new( function () return false end, function() return d("Wait is overrr") end ),
							
						)
				)



function mc_global.PickNewTarget()
	if ( Player.inCombat ) then
		local TList = ( CharacterList( "attackable,alive,noCritter,nearest,los,onmesh,maxdistance="..wt_global_information.MaxAggroDistanceFar ) )
		if ( TableSize( TList ) > 0 ) then
			local id, E  = next( TList )
			if ( id ~= nil and id ~= 0 and E ~= nil ) then
				Player:SetTarget(E)
				return true
			end		
		end
	end
	return false
end
	
function mc_global.Attack()
	d("ATTACK")

end		]]
