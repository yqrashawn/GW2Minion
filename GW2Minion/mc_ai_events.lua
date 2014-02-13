-- Handles Events
mc_ai_events = {}

c_doEvents = inheritsFrom( ml_cause )
e_doEvents = inheritsFrom( ml_effect )
function c_doEvents:evaluate()
	
	
	return 
end
function e_doEvents:execute()
	ml_log("e_doEvents")
	
	return ml_log(false)
end