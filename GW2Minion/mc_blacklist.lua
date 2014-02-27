-- <3 f3re
mc_blacklist = {}
mc_blacklist.mainwindow = { name = GetString("blacklistManager"), x = 350, y = 100, w = 250, h = 400}
mc_blacklist.path = GetStartupPath() .. [[\LuaMods\GW2Minion\blacklist.txt]]
mc_blacklist.currentID = ""
mc_blacklist.UIList = {}
mc_blacklist.ticks = 0
mc_blacklist.currentEntryCount = 0
mc_blacklist.blacklist = {}

function mc_blacklist.HandleInit()
    GUI_NewWindow(mc_blacklist.mainwindow.name,mc_blacklist.mainwindow.x,mc_blacklist.mainwindow.y,mc_blacklist.mainwindow.w,mc_blacklist.mainwindow.h,true)
    GUI_NewComboBox(mc_blacklist.mainwindow.name,GetString("blacklistName"),"gBlacklistName",GetString("generalSettings"),"")
    GUI_NewComboBox(mc_blacklist.mainwindow.name,GetString("blacklistEntry"),"gBlacklistEntry",GetString("generalSettings"),"")
    GUI_NewField(mc_blacklist.mainwindow.name,GetString("entryTime"),"gBlacklistEntryTime",GetString("generalSettings"))
    GUI_NewButton(mc_blacklist.mainwindow.name,GetString("deleteEntry"),"mc_blacklist.DeleteEntry",GetString("generalSettings"))
    RegisterEventHandler("mc_blacklist.DeleteEntry",mc_blacklist.UIDeleteEntry)
    
	GUI_NewButton(mc_blacklist.mainwindow.name, GetString("blacklistEvent"), "bBlackListEvent")
	RegisterEventHandler("bBlackListEvent", mc_blacklist.eventhandler)
	GUI_NewButton(mc_blacklist.mainwindow.name, GetString("blacklistVendor"), "bBlackListVendor")
	RegisterEventHandler("bBlackListVendor", mc_blacklist.eventhandler)
	GUI_NewButton(mc_blacklist.mainwindow.name, GetString("blacklistTarget"), "bBlackListTarget")
	RegisterEventHandler("bBlackListTarget", mc_blacklist.eventhandler)
	
	
    GUI_SizeWindow(mc_blacklist.mainwindow.name, mc_blacklist.mainwindow.w, mc_blacklist.mainwindow.h)
    GUI_UnFoldGroup(mc_blacklist.mainwindow.name, GetString("generalSettings"))
    GUI_WindowVisible(mc_blacklist.mainwindow.name,false)
	
		

	mc_blacklist.InitBlackLists()
	mc_blacklist.ReadBlacklistFile(mc_blacklist.path)
end

function mc_blacklist.InitBlackLists()
	if not mc_blacklist.BlacklistExists(GetString("monsters")) then
        mc_blacklist.CreateBlacklist(GetString("monsters"))
    end
	if not mc_blacklist.BlacklistExists(GetString("event")) then
        mc_blacklist.CreateBlacklist(GetString("event"))
    end
	if not mc_blacklist.BlacklistExists(GetString("salvageItems")) then
        mc_blacklist.CreateBlacklist(GetString("salvageItems"))
    end
	if not mc_blacklist.BlacklistExists(GetString("vendors")) then
        mc_blacklist.CreateBlacklist(GetString("vendors"))
    end
	if not mc_blacklist.BlacklistExists(GetString("vendorsbuy")) then
        mc_blacklist.CreateBlacklist(GetString("vendorsbuy"))
    end
	if not mc_blacklist.BlacklistExists(GetString("partymember")) then
        mc_blacklist.CreateBlacklist(GetString("partymember"))
    end
	if not mc_blacklist.BlacklistExists(GetString("mapobjects")) then
        mc_blacklist.CreateBlacklist(GetString("mapobjects"))
    end
end

function mc_blacklist.RefreshNames()
    local nameList = GetComboBoxList(mc_blacklist.blacklist)
    gBlacklistName_listitems = nameList["keyList"]
    gBlacklistName = nameList["firstKey"]
    
    mc_blacklist.UpdateAddEntry()
    mc_blacklist.RefreshEntries()
end

function mc_blacklist.RefreshEntries()
    local entrylist = ""
    local firstEntry = ""
    local blacklist = mc_blacklist.blacklist[gBlacklistName]
    if (blacklist) then
        for id, entry in pairs(blacklist) do
            if (entrylist == "") then
                entrylist = entry.name
                firstEntry = entry.name
                mc_blacklist.currentID = id
            else
                entrylist = entrylist..","..entry.name
            end
        end
        
        gBlacklistEntry_listitems = entrylist
        gBlacklistEntry = firstEntry
        mc_blacklist.currentEntryCount = TableSize(blacklist)
    end
end

function mc_blacklist.UpdateAddEntry()
    -- init the correct "Add Entry" controls
    GUI_DeleteGroup(mc_blacklist.mainwindow.name, GetString("addEntry"))
    local initUI = mc_blacklist.UIList[gBlacklistName]
    if (initUI) then
        initUI()
        GUI_UnFoldGroup(mc_blacklist.mainwindow.name, GetString("addEntry"))
    end
    
    GUI_SizeWindow(mc_blacklist.mainwindow.name, mc_blacklist.mainwindow.w, mc_blacklist.mainwindow.h)
end

function mc_blacklist.UIDeleteEntry()
    mc_blacklist.DeleteEntry(gBlacklistName, mc_blacklist.currentID)
    mc_blacklist.RefreshEntries()
end

function mc_blacklist.AddInitUI(blacklistName, initFunc)
    mc_blacklist.UIList[blacklistName] = initFunc
    mc_blacklist.UpdateAddEntry()
end

function mc_blacklist.ReadBlacklistFile(path)
    if path and path ~= "" then
		local loadedlist = persistence.load(path) or {}
		if ( TableSize(loadedlist) > 0 ) then
			mc_blacklist.blacklist = loadedlist
		end
		
		mc_blacklist.InitBlackLists()		
		
		mc_blacklist.RefreshNames()
    end
end

function mc_blacklist.WriteBlacklistFile(path)
    if path and path ~= "" then
        persistence.store(path, mc_blacklist.blacklist)
    end
end

function mc_blacklist.GUIVarUpdate(Event, NewVals, OldVals)
    for k,v in pairs(NewVals) do
        if (k == "gBlacklistName") then
            mc_blacklist.UpdateAddEntry()
            mc_blacklist.RefreshEntries()
        elseif (k == "gBlacklistEntry") then
            mc_blacklist.currentID = mc_blacklist.GetEntryID(gBlacklistName,gBlacklistEntry)
            mc_blacklist.UpdateEntryTime()
        end
    end
end

function mc_blacklist.UpdateEntryTime()
    local entryTime = mc_blacklist.GetEntryTime(gBlacklistName, mc_blacklist.currentID)
    if (entryTime == true) then
        gBlacklistEntryTime = "Infinite"
    elseif (entryTime) then
        gBlacklistEntryTime = tostring(round(entryTime/1000,0))
    else
        gBlacklistEntryTime = ""
    end
end

function mc_blacklist.ToggleMenu()
    if (mc_blacklist.visible) then
        GUI_WindowVisible(mc_blacklist.mainwindow.name,false)	
        mc_blacklist.visible = false
    else
        local wnd = GUI_GetWindowInfo("MinionBot")
        if (wnd) then
            GUI_MoveWindow( mc_blacklist.mainwindow.name, wnd.x+wnd.width,wnd.y) 
            GUI_WindowVisible(mc_blacklist.mainwindow.name,true)
        end
        
        mc_blacklist.visible = true
    end
end

-- have to update the entry list regularly since there's no way to capture a button click 
-- externally when entries are added to the list
function mc_blacklist.OnUpdate(tickcount)
    if (tickcount - mc_blacklist.ticks > 2000) then
        mc_blacklist.ticks = tickcount
		
		-- checks for temporarily blacklisted entries and removed them if time is up
		for name, blacklist in pairs(mc_blacklist.blacklist) do
            for id, entry in pairs (blacklist) do
                if entry.time ~= true and mc_global.now - entry.time > 0 then
                    mc_blacklist.DeleteEntry(name, id)
                end
            end
        end
		
		mc_blacklist.UpdateEntryTime()
		
        local blacklist = mc_blacklist.blacklist[gBlacklistName]
        if (TableSize(blacklist) ~= mc_blacklist.currentEntryCount) then
            mc_blacklist.RefreshEntries()
        end
    end
end

-- creates a new blacklist and assigns clearThrottle as the timer to check 
-- for temp entries to remove
function mc_blacklist.CreateBlacklist(blacklistName)
    mc_blacklist.blacklist[blacklistName] = {}
    mc_blacklist.RefreshNames()
end

-- checks ALL blacklists to see if entryName exists
-- use this ONLY if you're sure your blacklists have unique types
function mc_blacklist.IsBlacklisted(entryName)
	for name, blacklist in pairs(mc_blacklist.blacklist) do
		for id, entry in pairs (blacklist) do
			if entry.name == entryName then
				return true
			end
		end
	end
	
	return false
end

-- checks only the named blacklist to see if entryName exists
function mc_blacklist.CheckBlacklistEntry(blacklistName, entryID)
	local blacklist = mc_blacklist.blacklist[blacklistName]
	if blacklist[entryID] then
		return true
	end
    
    return false
end

function mc_blacklist.GetEntryTime(blacklistName, entryID)
    local blacklist = mc_blacklist.blacklist[blacklistName]
    if blacklist and blacklist[entryID] then
        if (blacklist[entryID].time == true) then
            return true
        else
            return blacklist[entryID].time - mc_global.now
        end
	else
        return nil
    end
end

-- adds a new entry to the named blacklist for the given time duration
-- if time == true then the entry is permanent for the duration of the session
function mc_blacklist.AddBlacklistEntry(blacklistName, entryID, entryName, entryTime)
	local blacklist = mc_blacklist.blacklist[blacklistName]
    if (blacklist) then
        if (not blacklist[entryID]) then
            blacklist[entryID] = { time = entryTime, name = entryName } 
            mc_blacklist.WriteBlacklistFile(mc_blacklist.path)
        end
        return true
    end
    
    return false
end

function mc_blacklist.BlacklistExists(blacklistName)
    return mc_blacklist.blacklist[blacklistName] ~= nil
end

function mc_blacklist.GetExcludeString(blacklistName)
    local excludeString = ""
	local blacklist = mc_blacklist.blacklist[blacklistName]
    if ( blacklist) then
		for id, entry in pairs(blacklist) do
			excludeString = excludeString .. id .. ";"
		end
    end
    if (excludeString ~= "") then
        -- strip off trailing comma
        return excludeString:sub(1,excludeString:len() - 1) 
    else
        return 0
    end
end

function mc_blacklist.GetEntryID(blacklistName, entryName)
    local blacklist = mc_blacklist.blacklist[blacklistName]
    if (blacklist) then
        for id, entry in pairs(blacklist) do
            if entry.name == entryName then
                return id
            end
        end
    end
    
    return nil
end

function mc_blacklist.DeleteEntry(blacklistName, entryID)
    local blacklist = mc_blacklist.blacklist[blacklistName]
	if ( blacklist ) then
		if blacklist[entryID] then
			blacklist[entryID] = nil
			mc_blacklist.WriteBlacklistFile(mc_blacklist.path)
			return true
		end
    end
    return false
end

--GW2 
function mc_blacklist.eventhandler( arg ) 
	if ( arg == "bBlackListTarget" ) then
		local t = Player:GetTarget()
		if ( t ) then			   
			d("Blacklisted "..t.name)
			mc_blacklist.AddBlacklistEntry(GetString("monsters"), t.contentID, t.name, true)			
		else
			d("Invalid target or no target selected")
		end
	elseif ( arg == "bBlackListEvent" ) then
		local event = MapMarkerList("isevent,nearest")
		if ( event ) then
			local id,ev = next(event)
			if ( id and ev ) then
				d("Blacklisted closest Event, ID "..id)
				mc_blacklist.AddBlacklistEntry(GetString("event"), ev.eventID, id, true)				
			else
				d("Invalid Event or no Event nearby")
			end
		end
	elseif ( arg == "bBlackListVendor" ) then
		local t = Player:GetTarget()
		if ( t ) then			   
			d("Blacklisted "..t.name)
			mc_blacklist.AddBlacklistEntry(GetString("vendors"), t.id, t.name, true)			
		else
			d("Invalid target or no target selected")
		end
	end
end



RegisterEventHandler("GUI.Update",mc_blacklist.GUIVarUpdate)
RegisterEventHandler("Module.Initalize",mc_blacklist.HandleInit)
