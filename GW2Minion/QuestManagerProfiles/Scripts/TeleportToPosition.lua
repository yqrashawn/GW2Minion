	-- Teleport script for QuestManager
    script = inheritsFrom( ml_task )
    script.name = "GoToWaypoint"
    script.Data = {}
     
    --******************
    -- ml_quest_mgr Functions
    --******************
    function script:UIInit( identifier )
            -- You need to create the ScriptUI Elements exactly like you see here, the "event" needs to start with "tostring(identifier).." and the group needs to be GetString("questStepDetails")
            GUI_NewField(ml_quest_mgr.stepwindow.name,"Waypoint ID",tostring(identifier).."WPID",GetString("questStepDetails"))
            GUI_NewField(ml_quest_mgr.stepwindow.name,"Waypoint Name",tostring(identifier).."WPName",GetString("questStepDetails"))
            GUI_NewButton(ml_quest_mgr.stepwindow.name,"Set Current Waypoint",tostring(identifier).."SetWaypoint",GetString("questStepDetails"))           
    end
     
    function script:SetData( identifier, tData )
            -- Save the data in our script-"instance" aka global variables and set the UI elements
            if ( identifier and tData ) then               
                    --d("script:SetData: "..tostring(identifier))                          
                    self.Data = tData              
                    -- Update the script UI (make sure the Data assigning to a _G is NOT nil! else crashboooombang!)
                    if ( self.Data["WPID"] ) then _G[tostring(identifier).."WPID"] = self.Data["WPID"] end
                    if ( self.Data["WPName"] ) then _G[tostring(identifier).."WPName"] = self.Data["WPName"] end
            end
    end
     
    function script:EventHandler( identifier, event, value )
            -- for extended UI event handling, gets called when a scriptUI element is pressed      
            if ( event == "SetWaypoint" ) then
                    id,wp = next(WaypointList("nearest"))
                    if ( wp ) then
                            self.Data["WPID"] = wp.id
                            self.Data["WPName"] = wp.name
                            _G[tostring(identifier).."WPID"] = wp.id
                            _G[tostring(identifier).."WPName"] = wp.name
                    else           
                            self.Data["WPID"] = 0
                            self.Data["WPName"] = 0
                            _G[tostring(identifier).."WPID"] = 0
                            _G[tostring(identifier).."WPName"] = 0
                    end
            end
    end
     
    --******************
    -- ml_Task Functions
    --******************
    script.valid = true
    script.completed = false
    script.subtask = nil
    script.process_elements = {}
    script.overwatch_elements = {}
     
    function script:Init()
        -- Add Cause&Effects here
            -- Dead?
            self:add(ml_element:create( "Dead", c_dead, e_dead, 225 ), self.process_elements)
           
            -- Downed
            self:add(ml_element:create( "Downed", c_downed, e_downed, 200 ), self.process_elements)
           
            -- AoELooting Characters
            self:add(ml_element:create( "AoELoot", c_AoELoot, e_AoELoot, 175 ), self.process_elements)
                           
            -- Normal Chests       
            self:add(ml_element:create( "LootingChest", c_LootChests, e_LootChests, 155 ), self.process_elements)
           
            -- Resting
            self:add(ml_element:create( "Resting", c_resting, e_resting, 145 ), self.process_elements)     
     
            -- Normal Looting
            self:add(ml_element:create( "Looting", c_LootCheck, e_LootCheck, 130 ), self.process_elements)
     
            -- Deposit Items
            self:add(ml_element:create( "DepositingItems", c_deposit, e_deposit, 120 ), self.process_elements)     
           
            -- GoTo
            self:add(ml_element:create( "GoToWaypoint", self.c_goto, self.e_goto, 110 ), self.process_elements)    
           
            self:AddTaskCheckCEs()
    end
     
     
    function script:task_complete_eval()           
            return false
    end
    function script:task_complete_execute()
       self.completed = true
    end
     
     
     
    -- Cause&Effect
    script.c_goto = inheritsFrom( ml_cause )
    script.e_goto = inheritsFrom( ml_effect )
    function script.c_goto:evaluate()
            if (tonumber(ml_task_hub:CurrentTask().Data["WPID"]) ~= nil) then
                    return true
            else
                    ml_error("Quest GoToWaypoint Step has no Waypoint set!")
            end
            return false
    end
    function script.e_goto:execute()
            ml_log("e_goto")
            local nWay = wp.id
            if (nWay) then
				if ( Player.inCombat == false and Player:TeleportToWaypoint(nWay) == true) then
					ml_task_hub:CurrentTask().completed = true
				end
                return ml_log(true)                    
            else
            return ml_log(false)           
            end    
    end
     
     
    return script

