-- TOolbox 
tb = { }
tb.running = false
tb.visible = false
tb.lastrun = 0

function tb.ModuleInit() 	
	GUI_NewWindow("ToolBox", 450, 100, 200, 150)	
	GUI_NewButton("ToolBox","AutoUnpackAllBags","TB.unpack")
	GUI_NewSeperator("ToolBox")	
	GUI_NewButton("ToolBox","AutoSalvageAllItems","TB.salvage")
	GUI_NewSeperator("ToolBox")
	GUI_NewButton("ToolBox","EventMonitor","TB.eventmon")
	GUI_NewSeperator("ToolBox")
	GUI_NewButton("ToolBox","Minions,(Re)load Mesh","TB.reload")
	GUI_NewField("ToolBox","Meshname:","greloadmesh");
	GUI_NewSeperator("ToolBox")
	GUI_WindowVisible("ToolBox",false)
end

function tb.ToggleMenu()
	if (tb.visible) then
		GUI_WindowVisible("ToolBox",false)	
		tb.visible = false
	else
		GUI_WindowVisible("ToolBox",true)	
		tb.visible = true
	end
end

function tb.OnUpdate( event, tickcount )
	if (tb.running ) then
		if (tickcount - tb.lastrun > 150) then
			tb.lastrun = tickcount	
			if (not wt_core_taskmanager:CheckPrioTask()) then
				tb.running = false
			else
				wt_core_taskmanager:DoPrioTask()
			end			
		end	
	end
end

function tb.UnpackBags()
	if (wt_core_taskmanager.current_task == nil) then
		local newtask = inheritsFrom( wt_task )
		newtask.name = "Opening Bags"
		newtask.priority = 1500
		newtask.done = false
		newtask.last_execution = 0
		newtask.throttle = 150
		newtask.deposited = false
		
		function newtask:execute()
			local opened = false
			if (ItemList.freeSlotCount > 1) then
				newtask.deposited = false
				local inv = ItemList("itemtype=4,notsoulbound")	
				id,item = next(inv)
				if (id ~=nil and item ~= nil ) then	
					local itemid = item.dataID
					if ( itemid == 10169 or itemid == 21867 
					or itemid == 11542 or itemid == 11540 or itemid == 11540 
					or itemid == 11455 or itemid == 11455 or itemid == 11456 
					or itemid == 11456 or itemid == 11519 or itemid == 11509 
					or itemid == 11496 or itemid == 11472 or itemid == 11504 
					or itemid == 11483) then --ADD MORE IDs HERE
						wt_debug( "Opening Bag..")
						opened = true					
						item:Use()
					end
				end
			else 
				if (not newtask.deposited) then
					Inventory:DepositCollectables()
					newtask.deposited = true
					opened = true
				end
			end
			
			if(not opened) then
				newtask.done = true
			end
		end
				
		function newtask:isFinished()
			if ( newtask.done ) then				
				wt_core_taskmanager.current_task = nil
				return true
			end
			return false
		end	
		
		wt_core_taskmanager.current_task = newtask
		tb.running = true
	else
		wt_core_taskmanager.current_task = nil
		tb.running = false
	end
end

function tb.AutoSalvage()	
	if (wt_core_taskmanager.current_task == nil) then	
		local newtask = inheritsFrom( wt_task )
		newtask.name = "Salvage All Items"
		newtask.priority = 1500
		newtask.done = false
		newtask.last_execution = 0
		newtask.throttle = 150
		newtask.deposited = false
		newtask.lastitemID = 0
		newtask.lastitemstacksize = 0
		newtask.ignorelist = {}
		
		function newtask:execute()
			local taskran = false
			if (ItemList.freeSlotCount > 1) then
				newtask.deposited = false
				local inventory = ItemList("")
				local salvageItems = {}
				local salvageTools = {}
				id , item = next(inventory)
				while ( id ~= nil ) do
					if ( item ~= nil and not item.soulbound and item.rarity < 4 and ( item.itemtype == GW2.ITEMTYPE.Armor or item.itemtype == GW2.ITEMTYPE.Weapon or item.itemtype == GW2.ITEMTYPE.Trophy ) and not table.contains(newtask.ignorelist, item.dataID)) then						
						table.insert(salvageItems,item)
					elseif ( item.itemtype == GW2.ITEMTYPE.SalvageTool ) then
						table.insert(salvageTools,item)
					end
					id, item  = next(inventory,id)
				end				
				if ( TableSize(salvageItems) > 0 and TableSize(salvageTools) >0 ) then
					id , item = next(salvageItems)
					tid , tool = next(salvageTools)
					if ( id ~= nil and item ~= nil and tid ~=nil and tool ~= nil ) then
						if ( Player:GetCurrentlyCastedSpell() == 17 ) then
							wt_debug("Salvaging item " .. tostring(item.name) .. " with " .. tostring(tool.name))
							tool:Use(item)
							taskran = true
							if (newtask.lastitemID == 0 or newtask.lastitemID ~= item.dataID or (newtask.lastitemID == item.dataID and item.stackcount < newtask.lastitemstacksize)) then
								newtask.lastitemID = item.dataID
								newtask.lastitemstacksize = item.stackcount
							else
								wt_debug("Cannot Salvage item: "..tostring(item.name).." ignoring it")
								table.insert(newtask.ignorelist,item.dataID)
							end
						end
					end
				end
			else 
				if (not newtask.deposited) then
					Inventory:DepositCollectables()
					newtask.deposited = true
					taskran = true
				end
			end
			
			if(not taskran) then
				newtask.done = true
			end
		end
				
		function newtask:isFinished()
			if ( newtask.done ) then
				wt_core_taskmanager.current_task = nil
				return true
			end
			return false
		end	
		wt_debug("Salvaging Task Added..")
		wt_core_taskmanager.current_task = newtask
		tb.running = true
	else
		wt_core_taskmanager.current_task = nil
		tb.running = false
	end
end

function tb.MinionsloadMesh()
	wt_debug("Telling Minions to (re)load mesh: "..tostring(greloadmesh))
	if (greloadmesh ~= nil and greloadmesh ~= "" and gMinionEnabled == "1" and MultiBotIsConnected( )) then
		MultiBotSend( "50;"..greloadmesh,"gw2minion" )
	end
end


RegisterEventHandler("TB.toggle", tb.ToggleMenu)
RegisterEventHandler("TB.unpack", tb.UnpackBags)
RegisterEventHandler("TB.salvage", tb.AutoSalvage)
RegisterEventHandler("TB.reload", tb.MinionsloadMesh)
RegisterEventHandler("TB.eventmon", eventmonitor.ToggleMenu)
RegisterEventHandler("Gameloop.Update",tb.OnUpdate)
RegisterEventHandler("Module.Initalize",tb.ModuleInit)