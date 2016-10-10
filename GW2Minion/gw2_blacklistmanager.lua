-- Adds additional options to the Blacklistmanager in the minionlib
gw2_blacklistmanager = {}
gw2_blacklistmanager.lists = {}

function gw2_blacklistmanager.ModuleInit()
	gw2_blacklistmanager.lists[GetString("vendorsbuy")] = ml_list_mgr.AddList(GetString("vendorsbuy"))
	gw2_blacklistmanager.lists[GetString("vendorsrepair")] = ml_list_mgr.AddList(GetString("vendorsrepair"))
	gw2_blacklistmanager.lists[GetString("vendorssell")] = ml_list_mgr.AddList(GetString("vendorssell"))
	gw2_blacklistmanager.lists[GetString("monsters")] = ml_list_mgr.AddList(GetString("monsters"))	
	gw2_blacklistmanager.lists[GetString("mapobjects")] = ml_list_mgr.AddList(GetString("mapobjects"))

	local eventlist = ml_list_mgr.AddList(GetString("event"), gw2_blacklistmanager.DrawEvent)
	eventlist.GUI.vars = { mapid = 0, name = "", pos = { x = 0, y = 0, z = 0}, id = 0, expiration_s = 0}
	gw2_blacklistmanager.lists[GetString("event")] = eventlist
end

function gw2_blacklistmanager.GetExcludeString(listname)
	local entries = ml_list_mgr.FindEntries(listname)
	local retval = ""

	if(table.valid(entries)) then
		for _,v in pairs(entries) do
			retval = retval .. v.id .. ";"
		end
		retval = string.gsub(retval, ";$", "")
	end
	
	return retval
end

function gw2_blacklistmanager.CheckBlacklistEntry(listname, id)
	if(listname and id) then
		return table.valid(ml_list_mgr.FindEntries(listname,"id="..id))
	end
	return false
end

function gw2_blacklistmanager.AddBlacklistEntry(listname, id, name, duration)
	if(listname and id and table.valid(gw2_blacklistmanager.lists[listname])) then
		duration = duration or 0
		if(type(duration) == "number" and duration > 0 and duration < ml_global_information.Now) then
			duration = ml_global_information.Now + duration
		end
		gw2_blacklistmanager.lists[listname]:AddEntry({id = id, name = name or "unknown", mapid = ml_global_information.CurrentMapID, expiration = duration})
	end
end

function gw2_blacklistmanager:DrawEvent()
	local vars = self.GUI.vars
	
	ml_gui.DrawTabs(self.GUI.main_tabs)
	GUI:Separator();
	
	GUI:Spacing(5);
	
	-- dbk: Add
	if (self.GUI.main_tabs.tabs[1].isselected) then
		if (GUI:Button("Pull nearest event details")) then
			local MList = MapMarkerList("nearest,isevent")
			if(table.valid(MList)) then
				local _,marker = next(MList)
				if(table.valid(marker)) then
					vars.mapid, vars.id, vars.name, vars.expiration_s = Player.localmapid, marker.eventid, marker.name or "unknown", math.ceil((ml_global_information.Now + 7200000)/1000)
				end
			end

		end
		
		GUI:PushItemWidth(150)
		GUI:Text("Map ID:"); GUI:SameLine(100); 
		vars.mapid = GUI:InputText("##listdetail-mapid",vars.mapid)
		GUI:Text("Event ID:"); GUI:SameLine(100); 
		vars.id = GUI:InputText("##listdetail-id",vars.id)
		GUI:Text("Name:"); GUI:SameLine(100);
		vars.name = GUI:InputText("##listdetail-name",vars.name)
		GUI:Text("Duration: (s)"); GUI:SameLine(100); 
		vars.expiration_s = GUI:InputInt("##listdetail-expiration",vars.expiration_s)
		GUI:PopItemWidth()
		
		if (GUI:Button("Add Entry")) then
			local details = { id = vars.id, mapid = vars.mapid, name = vars.name, expiration = vars.expiration_s*1000, expiration_s = vars.expiration_s }
			self:AddEntry(details)
		end
	end
	
	-- dbk: Edit
	if (self.GUI.main_tabs.tabs[2].isselected) then
	
		GUI:Separator();
		GUI:Columns(4, "##listdetail-view", true)
		GUI:SetColumnOffset(1,100); GUI:SetColumnOffset(2,160); GUI:SetColumnOffset(3,260); GUI:SetColumnOffset(4,360);
		GUI:Text("Name"); GUI:NextColumn();
		GUI:Text("Map ID"); GUI:NextColumn();
		GUI:Text("Event ID"); GUI:NextColumn(); GUI:NextColumn();
		GUI:Separator();
		
		local entries = self.entries
		if (table.valid(entries)) then
			for i, entry in pairs(entries) do
				GUI:Text(entry.name); GUI:NextColumn();
				GUI:Text(entry.mapid); GUI:NextColumn();
				GUI:Text(entry.id); GUI:NextColumn();
				if (GUI:Button("Delete")) then
					self:DeleteEntry(i); 
				end
				GUI:NextColumn();
			end
		end
		
		GUI:Columns(1)
	end	
end

RegisterEventHandler("Module.Initalize",gw2_blacklistmanager.ModuleInit)
