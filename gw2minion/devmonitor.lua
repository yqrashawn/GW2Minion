devmonitor = { }
devmonitor.running = false
devmonitor.lastticks = 0
devmonitor.visible = false
devmonitor.initialized = false

function devmonitor.ToggleMenu()
	if (devmonitor.visible) then
		GUI_WindowVisible("devmonitor",false)	
		devmonitor.visible = false
		devmonitor.running = false
	else
		if ( not devmonitor.initialized ) then
			devmonitor.ModuleInit()
			devmonitor.initialized = true
		end
		GUI_WindowVisible("devmonitor",true)	
		devmonitor.visible = true
		devmonitor.running = true
	end
end

function devmonitor.ModuleInit()
	GUI_NewWindow("devmonitor",400,50,250,430)
	GUI_NewField("devmonitor","Get Type","TargetGetType","TargetInfo")
	GUI_NewField("devmonitor","ID","TargetID","TargetInfo")
	GUI_NewField("devmonitor","health.current","TargetHealthCurrent","TargetInfo")
	GUI_NewField("devmonitor","health.max","TargetHealthMax","TargetInfo")
	GUI_NewField("devmonitor","health.percent","TargetHealthPercent","TargetInfo")
	GUI_NewField("devmonitor","pos.x","TargetPosX","TargetInfo")
	GUI_NewField("devmonitor","pos.y","TargetPosY","TargetInfo")
	GUI_NewField("devmonitor","pos.z","TargetPosZ","TargetInfo")
	GUI_NewField("devmonitor","pos.onmesh","TargetOnMesh","TargetInfo")
	GUI_NewField("devmonitor","alive","TargetAlive","TargetInfo")
	GUI_NewField("devmonitor","healthstate","TargetHealthState","TargetInfo")
	GUI_NewField("devmonitor","lootable","TargetLootable","TargetInfo")
	GUI_NewField("devmonitor","isPlayer","TargetIsPlayer","TargetInfo")
	GUI_NewField("devmonitor","isControlled","TargetIsControlled","TargetInfo")
	GUI_NewField("devmonitor","attitude","TargetAttitude","TargetInfo")
	GUI_NewField("devmonitor","swiming","TargetSwimming","TargetInfo")
	GUI_NewField("devmonitor","level","TargetLevel","TargetInfo")
	GUI_NewField("devmonitor","profession","TargetProfession","TargetInfo")
	GUI_NewField("devmonitor","distance","TargetDistance","TargetInfo")
	GUI_NewField("devmonitor","pathdistance","TargetPathDistance","TargetInfo")
	GUI_NewField("devmonitor","los","TargetLOS","TargetInfo")
	GUI_NewField("devmonitor","isChampion","TargetIsChampion","TargetInfo")
	GUI_NewField("devmonitor","isVeteran","TargetIsVeteran","TargetInfo")
	GUI_FoldGroup("devmonitor","TargetInfo");
	
	GUI_NewField("devmonitor","GagetType","GadgetGetType","GadgetInfo")
	GUI_NewField("devmonitor","GadgetID","GadgetID","GadgetInfo")
	GUI_NewField("devmonitor","GadgetAttitude","GadgetAttitude","GadgetInfo")
	GUI_NewField("devmonitor","Health.current","GadgetHealthCurrent","GadgetInfo")
	GUI_NewField("devmonitor","Health.max","GadgetHealthMax","GadgetInfo")
	GUI_NewField("devmonitor","Health.percent","GadgetHealthPercent","GadgetInfo")
	GUI_NewField("devmonitor","Pos.x","GadgetPosX","GadgetInfo")
	GUI_NewField("devmonitor","Pos.y","GadgetPosY","GadgetInfo")
	GUI_NewField("devmonitor","Pos.z","GadgetPosZ","GadgetInfo")
	GUI_NewField("devmonitor","Pos.onmesh","GadgetOnMesh","GadgetInfo")	
	GUI_NewField("devmonitor","Distance","GadgetDistance","GadgetInfo")
	GUI_NewField("devmonitor","Pathdistance","GadgetPathDistance","GadgetInfo")
	GUI_NewField("devmonitor","Los","GadgetLOS","GadgetInfo")
	GUI_NewField("devmonitor","type","GadgetType","GadgetInfo")
	GUI_NewField("devmonitor","resourceType","GadgetResourceType","GadgetInfo")
	GUI_NewField("devmonitor","gatherable","GadgetGatherable","GadgetInfo")
	GUI_NewField("devmonitor","contentID","GadgetcontentID","GadgetInfo")
	GUI_NewField("devmonitor","state","Gadgetstate","GadgetInfo")
	GUI_NewField("devmonitor","category","GadgetCategory","GadgetInfo")
	GUI_NewField("devmonitor","hasHPBar","GadgetHasHPBar","GadgetInfo")
	GUI_NewField("devmonitor","Iscombatant","Gadgetiscombatant","GadgetInfo")	
	GUI_NewField("devmonitor","IsOurs","GadgetIsOurs","GadgetInfo")
	GUI_NewField("devmonitor","UnknownA","GadgetA","GadgetInfo")
	GUI_NewField("devmonitor","UnknownB","GadgetB","GadgetInfo")
	GUI_NewField("devmonitor","UnknownC","GadgetC","GadgetInfo")
	GUI_NewField("devmonitor","UnknownD","GadgetD","GadgetInfo")
	GUI_NewField("devmonitor","UnknownE","GadgetE","GadgetInfo")
	GUI_NewField("devmonitor","UnknownF","GadgetF","GadgetInfo")
	GUI_NewField("devmonitor","UnknownG","GadgetG","GadgetInfo")
	GUI_NewField("devmonitor","isselectable","Gadgetisselectable","GadgetInfo")	
	GUI_FoldGroup("devmonitor","GadgetInfo");
			
	GUI_NewField("devmonitor","Event Count","EventCount","EventInfo")
	GUI_NewField("devmonitor","Event Type","Eventtype","EventInfo")
	GUI_NewField("devmonitor","Event WMtype","Eventwmtype","EventInfo")
	GUI_NewField("devmonitor","Event Mtype","Eventmtype","EventInfo")
	GUI_NewField("devmonitor","CharacterID","charID","EventInfo")
	GUI_NewField("devmonitor","EventID","eventID","EventInfo")
	GUI_NewField("devmonitor","QuestID","questID","EventInfo")
	GUI_NewField("devmonitor","Epos.x","EPosX","EventInfo")
	GUI_NewField("devmonitor","Epos.y","EPosY","EventInfo")
	GUI_NewField("devmonitor","Epos.z","EPosZ","EventInfo")
	GUI_NewField("devmonitor","Distance","Edist","EventInfo")
	GUI_NewField("devmonitor","ObjectiveCount","Ocount","EventInfo")
	GUI_NewField("devmonitor","Level","Level","EventInfo")
	GUI_NewField("devmonitor","IsRunning","runs","EventInfo")
	GUI_NewField("devmonitor","IsDungeonEv","isdungeon","EventInfo")
	GUI_NewField("devmonitor","EventA","EA","EventInfo")
	GUI_NewField("devmonitor","EventB","EB","EventInfo")
	GUI_NewField("devmonitor","EventC","EC","EventInfo")
	GUI_NewField("devmonitor","EventD","ED","EventInfo")
	GUI_NewField("devmonitor","EventE","EE","EventInfo")
	GUI_NewField("devmonitor","EventF","EF","EventInfo")
	GUI_NewField("devmonitor","EventG","EG","EventInfo")
	
	GUI_NewField("devmonitor","UKNA","UA","EventInfo")
	GUI_NewField("devmonitor","UKNB","UB","EventInfo")
	GUI_NewField("devmonitor","UKNC","UC","EventInfo")
	GUI_NewField("devmonitor","UKND","UD","EventInfo")
	GUI_NewField("devmonitor","UKNE","UE","EventInfo")
	GUI_NewField("devmonitor","UKNF","UF","EventInfo")
	GUI_NewField("devmonitor","UKNG","UG","EventInfo")
	GUI_NewField("devmonitor","UKNH","UH","EventInfo")
	GUI_NewField("devmonitor","UKNI","UI","EventInfo")
	GUI_FoldGroup("devmonitor","EventInfo");
	

	GUI_NewField("devmonitor","Type","mtype","MarkerInfo")
	GUI_NewField("devmonitor","Markertype","Markermtype","MarkerInfo")
	GUI_NewField("devmonitor","WorldMType","Markerwmtype","MarkerInfo")	
	GUI_NewField("devmonitor","Agent ID","MarkercharID","MarkerInfo")
	GUI_NewField("devmonitor","Marker ID","MarkerID","MarkerInfo")
	GUI_NewField("devmonitor","Quest ID","MarkerquestID","MarkerInfo")
	GUI_NewField("devmonitor","pos.x","MPosX","MarkerInfo")
	GUI_NewField("devmonitor","pos.y","MPosY","MarkerInfo")
	GUI_NewField("devmonitor","pos.z","MPosZ","MarkerInfo")
	GUI_NewField("devmonitor","Distance","Mdist","MarkerInfo")
	
	GUI_WindowVisible("devmonitor",false)
	
end
			
function devmonitor.UpdateWindow()
	TID = Player:GetTarget()
	if (TID  ~= nil) and (TID ~= 0) then
		mytarget = CharacterList:Get(TID)
		if (mytarget ~= nil) then
			TargetID = TID
			TargetGetType = "Character"
			TargetHealthCurrent = mytarget.health.current
			TargetHealthMax = mytarget.health.max
			TargetHealthPercent = mytarget.health.percent
			TargetPosX = (math.floor(mytarget.pos.x * 10) / 10)
			TargetPosY = (math.floor(mytarget.pos.y * 10) / 10)
			TargetPosZ = (math.floor(mytarget.pos.z * 10) / 10)
			TargetOnMesh = tostring(mytarget.pos.onmesh)
			TargetAlive = tostring(mytarget.alive)
			TargetHealthState = mytarget.healthstate
			TargetLootable = tostring(mytarget.lootable)
			TargetIsPlayer = tostring(mytarget.isPlayer)
			TargetIsControlled = tostring(mytarget.isControlled)
			TargetAttitude = mytarget.attitude
			TargetSwimming = mytarget.swimming
			TargetLevel = mytarget.level
			TargetProfession = mytarget.profession
			TargetDistance = (math.floor(mytarget.distance * 10) / 10)
			TargetPathDistance = mytarget.pathdistance
			TargetLOS = tostring(mytarget.los)
			TargetIsVeteran = tostring(mytarget.isVeteran)
			TargetIsChampion = tostring(mytarget.isChampion)
		else
			mytarget = GadgetList:Get(TID)
			if (mytarget ~= nil) then
				GadgetID = TID
				GadgetGetType = "Gadget"
				GadgetAttitude = tostring(mytarget.attitude)
				if (mytarget.hashpbar and mytarget.iscombatant and mytarget.health ~= nil) then
					GadgetHealthCurrent = mytarget.health.current
					GadgetHealthMax = mytarget.health.max
					GadgetHealthPercent = mytarget.health.percent
				else
					GadgetHealthCurrent = "n/a"
					GadgetHealthMax = "n/a"
					GadgetHealthPercent = "n/a"
				end
				GadgetPosX = (math.floor(mytarget.pos.x * 10) / 10)
				GadgetPosY = (math.floor(mytarget.pos.y * 10) / 10)
				GadgetPosZ = (math.floor(mytarget.pos.z * 10) / 10)
				GadgetOnMesh = tostring(mytarget.pos.onmesh)				
				GadgetDistance = (math.floor(mytarget.distance * 10) / 10)
				GadgetPathDistance = mytarget.pathdistance
				GadgetLOS = tostring(mytarget.los)
				GadgetType = mytarget.type
				GadgetResourceType = mytarget.resourceType
				GadgetGatherable = tostring(mytarget.gatherable)
				GadgetcontentID = tostring(mytarget.contentID)
				Gadgetstate = tostring(mytarget.state)
				GadgetCategory = tostring(mytarget.category)
				GadgetHasHPBar = tostring(mytarget.hashpbar)
				Gadgetiscombatant = tostring(mytarget.iscombatant)
				GadgetIsOurs = tostring(mytarget.isours)
				GadgetA = tostring(mytarget.A)
				GadgetB = tostring(mytarget.B)
				GadgetC = tostring(mytarget.C)
				GadgetD = tostring(mytarget.D)
				GadgetE = tostring(mytarget.E)
				GadgetF = tostring(mytarget.F)
				GadgetG = tostring(mytarget.G)
				Gadgetisselectable = tostring(mytarget.isselectable)				
			end
		end
		
	else
	--get nearest gadget
			local mytargetT = GadgetList("nearest")
			if (mytargetT ~= nil) then
				local i,mytarget = next(mytargetT)
				if (i~=nil and mytarget ~= nil) then
					GadgetID = i
					GadgetGetType = "NearestGadget"
					if (mytarget.hashpbar and mytarget.iscombatant and mytarget.health) then
						GadgetHealthCurrent = mytarget.health.current
						GadgetHealthMax = mytarget.health.max
						GadgetHealthPercent = mytarget.health.percent
					else
						GadgetHealthCurrent = "n/a"
						GadgetHealthMax = "n/a"
						GadgetHealthPercent = "n/a"
					end
					GadgetPosX = (math.floor(mytarget.pos.x * 10) / 10)
					GadgetPosY = (math.floor(mytarget.pos.y * 10) / 10)
					GadgetPosZ = (math.floor(mytarget.pos.z * 10) / 10)
					GadgetOnMesh = tostring(mytarget.pos.onmesh)				
					GadgetDistance = (math.floor(mytarget.distance * 10) / 10)
					GadgetPathDistance = mytarget.pathdistance
					GadgetLOS = tostring(mytarget.los)
					GadgetType = mytarget.type
					GadgetResourceType = mytarget.resourceType
					GadgetGatherable = tostring(mytarget.gatherable)
					GadgetcontentID = tostring(mytarget.contentID)
					Gadgetstate = tostring(mytarget.state)
					GadgetCategory = tostring(mytarget.category)
					GadgetHasHPBar = tostring(mytarget.hashpbar)
					GadgetIsOurs = tostring(mytarget.isours)
					GadgetA = tostring(mytarget.A)
					GadgetB = tostring(mytarget.B)
					GadgetC = tostring(mytarget.C)
					GadgetD = tostring(mytarget.D)
					GadgetE = tostring(mytarget.E)
					GadgetF = tostring(mytarget.F)
					GadgetG = tostring(mytarget.G)
					Gadgetisselectable = tostring(mytarget.isselectable)	
					end
			end
	end
	
	local mlist = MapMarkerList("isevent")
	if (mlist ~= nil) then	
		local i,event = next(mlist)
		if (i~=nil and event~=nil) then			
			EventCount = tostring(TableSize(mlist))
			Eventtype = tostring(event.type)
			Eventwmtype = tostring(event.worldmarkertype)
			Eventmtype = tostring(event.markertype)
			charID = tostring(event.characterID)
			eventID = tostring(event.eventID)
			questID = tostring(event.questID)
			EPosX = math.floor(event.pos.x)
			EPosY = math.floor(event.pos.y)
			EPosZ = math.floor(event.pos.z)
			Edist = math.floor(event.distance)
			UA = tostring(event.A)
			UB = tostring(event.B)
			UC = tostring(event.C)
			UD = tostring(event.D)
			UE = tostring(event.E)
			UF = tostring(event.F)
			UG = tostring(event.G)
			UH = tostring(event.H)
			UI = tostring(event.I)
			local einfo = event.eventinfo
			if ( einfo) then
				ObjectiveCount = tostring(einfo.objectivecount)
				Level = tostring(einfo.level)
				runs = tostring(einfo.isrunning)
				isdungeon = tostring(einfo.isdungeonevent)
				EA = tostring(einfo.A)
				EB = tostring(einfo.B)
				EC = tostring(einfo.C)
				ED = tostring(einfo.D)
				EE = tostring(einfo.E)
				EF = tostring(einfo.F)
				EG = tostring(einfo.G)
			else
				ObjectiveCount = "none"
				Level = "none"
				runs = "none"
				isdungeon = "none"
				EA = "none"
				EB = "none"
				EC = "none"
				ED = "none"
				EE = "none"
				EF = "none"
				EG = "none"
			end
			

		end
	end
	
	--local mlist = MapMarkerList("nearest")
	local mlist = MapObjectList("nearest")
	if (mlist ~= nil) then	
		local i,event = next(mlist)
		if (i~=nil and event~=nil) then			
			mtype = tostring(event.type)
			Markermtype = tostring(event.markertype)
			Markerwmtype = tostring(event.worldmarkertype)			
			MarkercharID = tostring(event.characterID)
			MarkerEventID = tostring(event.eventID)
			MarkerquestID = tostring(event.questID)
			MPosX = math.floor(event.pos.x)
			MPosY = math.floor(event.pos.y)
			MPosZ = math.floor(event.pos.z)
			Mdist = math.floor(event.distance)

		end
	end
	
	GUI_RefreshWindow("devmonitor")
end

function devmonitor.OnUpdateHandler( Event, ticks ) 	
	if ( devmonitor.initialized and devmonitor.running and ticks - devmonitor.lastticks > 1000 ) then
		devmonitor.lastticks = ticks
		devmonitor.UpdateWindow()
	end
end

RegisterEventHandler("Gameloop.Update", devmonitor.OnUpdateHandler)