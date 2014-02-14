-- Handles Exporation of POI/Waypoints/Others
--mc_ai_exploration.POIType = 412
--mc_ai_exploration.POIMarkerType = 22

--mc_ai_exploration.HeartQuestType1 = 148 
--mc_ai_exploration.HeartQuestType2 = 145 
--mc_ai_exploration.HeartQuestMarkerType = 8

mc_ai_exploration = inheritsFrom(ml_task)
mc_ai_exploration.name = "Exploration"

function mc_ai_exploration.Create()
	local newinst = inheritsFrom(mc_ai_exploration)
    
    --ml_task members
    newinst.valid = true
    newinst.completed = false
    newinst.subtask = nil
    newinst.process_elements = {}
    newinst.overwatch_elements = {}
            
    return newinst
end

function mc_ai_exploration:Init()
	-- Dead?
	self:add(ml_element:create( "Dead", c_dead, e_dead, 300 ), self.process_elements)
	
	
	self:AddTaskCheckCEs()
end
function mc_ai_exploration:task_complete_eval()

	return false
end

function mc_ai_exploration:task_complete_execute()
   self.completed = true
end




c_explorePOI = inheritsFrom( ml_cause )
e_explorePOI = inheritsFrom( ml_effect )
function c_explorePOI:evaluate()
	
	
	return 
end
function e_explorePOI:execute()
	ml_log("e_explorePOI")
	
	return ml_log(false)
end




