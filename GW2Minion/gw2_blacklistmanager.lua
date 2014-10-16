-- Adds additional options to the Blacklistmanager in the minionlib
gw2_blacklistmanager = {}

function gw2_blacklistmanager.ModuleInit()

	
	bw = WindowManager:GetWindow(ml_blacklist_mgr.mainwindow.name)
	if ( bw ) then
		bw:NewButton(GetString("blacklistEvent"), "bBlackListEvent")
		RegisterEventHandler("bBlackListEvent", gw2_blacklistmanager.buttonEventHandler)
		
		bw:NewButton(GetString("blacklistVendor"), "bBlackListVendor")
		RegisterEventHandler("bBlackListVendor", gw2_blacklistmanager.buttonEventHandler)
				
		bw:NewButton(GetString("blacklistTarget"), "bBlackListTarget")
		RegisterEventHandler("bBlackListTarget", gw2_blacklistmanager.buttonEventHandler)
		
	end
	
end

function gw2_blacklistmanager.buttonEventHandler( arg ) 
	if ( arg == "bBlackListEvent" ) then
		local event = MapMarkerList("isevent,nearest")
		if ( event ) then
			local id,ev = next(event)
			if ( id and ev ) then
				d("Blacklisting closest Event, ID "..ev.eventID)
				ml_blacklist.AddBlacklistEntry(GetString("event"), ev.eventID, ev.eventID, true)				
			else
				d("Blacklisting: Invalid Event or no Event nearby")
			end
		end
	
	elseif ( arg == "bBlackListTarget" ) then
		local t = Player:GetTarget()
		if ( t ) then			   
			d("Blacklisting "..t.name)
			ml_blacklist.AddBlacklistEntry(GetString("monsters"), t.contentID, t.name, true)
			ml_blacklist.AddBlacklistEntry(GetString("mapobjects"), t.contentID, t.name, true)
		else
			d("Invalid target or no target selected")
		end
		
	elseif ( arg == "bBlackListVendor" ) then
		local t = Player:GetTarget()
		if ( t ) then			   
			d("Blacklisting Vendor "..t.name)
			ml_blacklist.AddBlacklistEntry(GetString("vendors"), t.id, t.name, true)			
			ml_blacklist.AddBlacklistEntry(GetString("vendorsbuy"), t.id, t.name, true)
		else
			d("Invalid target or no target selected")
		end
	end
end

RegisterEventHandler("Module.Initalize",gw2_blacklistmanager.ModuleInit)
