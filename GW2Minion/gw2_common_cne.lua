gw2_common_cne = {}


c_AttackBestCharacterTarget = inheritsFrom( ml_cause )
e_AttackBestCharacterTarget = inheritsFrom( ml_effect )
c_AttackBestCharacterTarget.target = nil
function c_AttackBestCharacterTarget:evaluate()
	c_AttackBestCharacterTarget.target = gw2_common_functions.GetBestCharacterTarget()
	if ( c_AttackBestCharacterTarget.target ~= nil ) then
		return true
	end
	c_AttackBestCharacterTarget.target = nil
	return false
end
function e_AttackBestCharacterTarget:execute()
	ml_log( "AttackBestCharacterTarget" )
	gw2_skill_manager.Attack( c_AttackBestCharacterTarget.target )	
	c_AttackBestCharacterTarget.target = nil
end