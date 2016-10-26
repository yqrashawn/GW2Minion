gw2minion = {}

function gw2minion.Init()
	-- Register Button 
	local gw2mainmenu = {
		header = { id = "GW2MINION##MENU_HEADER", expanded = false, name = "GW2Minion", texture = GetStartupPath().."\\GUI\\UI_Textures\\gw2minion.png"},
		members = {{ id = "GW2MINION##MENU_ADDONS", name = "Addons", tooltip = "Installed Lua Addons.", texture = GetStartupPath().."\\GUI\\UI_Textures\\addon.png"}	}
	} 
	ml_gui.ui_mgr:AddComponent(gw2mainmenu)
	
	-- Setup GuestServerList
	gw2minion.RefreshGuestServers()	
	
	-- setup meshmanager
	if ( ml_mesh_mgr ) then 
		ml_mesh_mgr.GetMapID = function () return Player:GetLocalMapID() end
		ml_mesh_mgr.GetMapName = function () return ml_global_information.CurrentMapName end
		ml_mesh_mgr.GetPlayerPos = function () return Player.pos end

		-- Set worldnavigation data
		ml_mesh_mgr.navData = persistence.load(GetStartupPath()..GetLuaModsPath()..[[GW2Minion\]].."worldnav_data.lua")
		if ( not ValidTable(ml_mesh_mgr.navData)) then 
			ml_mesh_mgr.navData = {} 
		else
			ml_mesh_mgr.SetupNavNodes()
		end
		
		-- Set default meshes SetDefaultMesh(mapid, filename)
		ml_mesh_mgr.SetDefaultMesh(15,"Queensdale")
		ml_mesh_mgr.SetDefaultMesh(17,"Harathi Hinterlands")
		ml_mesh_mgr.SetDefaultMesh(19,"PlainsOfAshford")
		ml_mesh_mgr.SetDefaultMesh(20,"BlazzeridgeSteppes")
		ml_mesh_mgr.SetDefaultMesh(21,"Fields of Ruin")
		ml_mesh_mgr.SetDefaultMesh(22,"FireHeartRise")		
		ml_mesh_mgr.SetDefaultMesh(23,"Kessex Hills")		
		ml_mesh_mgr.SetDefaultMesh(24,"Gendarran Fields")
		ml_mesh_mgr.SetDefaultMesh(25,"IronMarches")
		ml_mesh_mgr.SetDefaultMesh(26,"Dredgehaunt Cliffs")
		ml_mesh_mgr.SetDefaultMesh(27,"LonarsPass")
		ml_mesh_mgr.SetDefaultMesh(28,"Wayfarer Foothills")		
		ml_mesh_mgr.SetDefaultMesh(29,"TimberlineFalls")
		ml_mesh_mgr.SetDefaultMesh(30,"FrostGorge Sound")
		ml_mesh_mgr.SetDefaultMesh(31,"Snowden Drifts")		
		ml_mesh_mgr.SetDefaultMesh(32,"DiessaPlateau")
		ml_mesh_mgr.SetDefaultMesh(34,"Caledon Forest")
		ml_mesh_mgr.SetDefaultMesh(35,"MetricaProvince")
		ml_mesh_mgr.SetDefaultMesh(39,"MountMaelstrom")
		
		ml_mesh_mgr.SetDefaultMesh(51,"Straits of Devastation")
		ml_mesh_mgr.SetDefaultMesh(53,"Sparkfly Fen")
		ml_mesh_mgr.SetDefaultMesh(54,"Brisban Wildlands")
		
		ml_mesh_mgr.SetDefaultMesh(62,"CursedShore")
		ml_mesh_mgr.SetDefaultMesh(65,"Malchors Leap")
		ml_mesh_mgr.SetDefaultMesh(73,"BloodtideCoast")
		
		-- Lions Arch
		ml_mesh_mgr.SetDefaultMesh(50,"Lions Arch")
		-- Black Citadel
		ml_mesh_mgr.SetDefaultMesh(218,"Black Citadel")
		ml_mesh_mgr.SetDefaultMesh(371,"Heros Canton")
		ml_mesh_mgr.SetDefaultMesh(833,"Ash Tribune Quarters")
		ml_mesh_mgr.SetDefaultMesh(460,"Citadel Stockade")
		ml_mesh_mgr.SetDefaultMesh(372,"Blood Tribune Quarters")
		ml_mesh_mgr.SetDefaultMesh(373,"The Command Core")
		-- Divitnity's Reach
		ml_mesh_mgr.SetDefaultMesh(18,"Divinitys Reach")
		ml_mesh_mgr.SetDefaultMesh(378,"Queens Throne Room")
		ml_mesh_mgr.SetDefaultMesh(248,"Salma District (Home)")
		ml_mesh_mgr.SetDefaultMesh(914,"The Dead End")
		ml_mesh_mgr.SetDefaultMesh(330,"Seraph Headquarters")
		-- Hoelbrak
		ml_mesh_mgr.SetDefaultMesh(326,"Hoelbrak")
		ml_mesh_mgr.SetDefaultMesh(374,"Knut Whitebears Loft")
		ml_mesh_mgr.SetDefaultMesh(375,"Hunters Hearth (Home)")
		ml_mesh_mgr.SetDefaultMesh(376,"Stonewrights Steading")
		-- Rata Sum
		ml_mesh_mgr.SetDefaultMesh(139,"Rata Sum")
		ml_mesh_mgr.SetDefaultMesh(650,"Applied Development Lab (Home)")
		ml_mesh_mgr.SetDefaultMesh(651,"Council Level")
		ml_mesh_mgr.SetDefaultMesh(649,"Snaff Memorial Lab")
		-- The Grove
		ml_mesh_mgr.SetDefaultMesh(91,"The Grove")
		ml_mesh_mgr.SetDefaultMesh(647,"Dreamers Terrace (Home)")
		ml_mesh_mgr.SetDefaultMesh(646,"The House of Caithe")
		ml_mesh_mgr.SetDefaultMesh(648,"The Omphalos Chamber")

		ml_mesh_mgr.SetDefaultMesh(350,"Heart of the Mists")
		ml_mesh_mgr.SetDefaultMesh(968,"EdgeOfTheMist")
		ml_mesh_mgr.SetDefaultMesh(988,"Dry Top")
		--HoT
		ml_mesh_mgr.SetDefaultMesh(1052,"Verdant Brink")
		ml_mesh_mgr.SetDefaultMesh(1043,"Auric Basin")
		
		--sPVP
		 ml_mesh_mgr.SetDefaultMesh(549,"sPvP Battle of Kyhlo")
		 ml_mesh_mgr.SetDefaultMesh(554,"sPvP Forest of Niflhel")
		 ml_mesh_mgr.SetDefaultMesh(795,"sPvP Legacy of the Foefire")
		 ml_mesh_mgr.SetDefaultMesh(866,"Mad Kings Labyrinth")
		 ml_mesh_mgr.SetDefaultMesh(875,"sPvP Temple of the Silent Storm")
		 ml_mesh_mgr.SetDefaultMesh(894,"sPvP Spirit Watch")
		 ml_mesh_mgr.SetDefaultMesh(900,"sPvP Skyhammer")
		 ml_mesh_mgr.SetDefaultMesh(984,"sPvP Courtyard")
		 ml_mesh_mgr.SetDefaultMesh(1011,"sPvP Battle of Champions")
		 ml_mesh_mgr.SetDefaultMesh(1015,"SilverWastes")		 
		 ml_mesh_mgr.SetDefaultMesh(1041,"DragonStand")
		 ml_mesh_mgr.SetDefaultMesh(1045,"TangledDepths")
		 ml_mesh_mgr.SetDefaultMesh(1163,"sPvP Revenge of the Capricorn")		 
		 ml_mesh_mgr.SetDefaultMesh(1165,"Bloodstone Fen")
		 ml_mesh_mgr.SetDefaultMesh(1171,"sPvp Coloseum")
		 ml_mesh_mgr.SetDefaultMesh(1175,"Infernal Cape")
		 
		--Instances
		ml_mesh_mgr.SetDefaultMesh(896,"North Noland Hatchery") -- Diessa Plateau
			
				
	end
	
	if(ml_task_mgr) then
		ml_task_mgr.min_level = 0
		ml_task_mgr.max_level = 80 
		ml_task_mgr.GetMapName = gw2_datamanager.GetMapName
		ml_task_mgr.btreepath = GetStartupPath()..[[\LuaMods\GW2Minion\Behavior]]
		ml_task_mgr.taskpath = GetStartupPath()..[[\LuaMods\GW2Minion\TaskManagerProfiles\]]
		ml_task_mgr.Init()
		
		ml_task_mgr.AddTaskType("tm_grind", "GrindMode.bt", nil, {displayname = GetString("grindMode")})
		ml_task_mgr.AddTaskType("tm_gather", "GatherMode.bt", nil, {displayname = GetString("gatherMode")})
		ml_task_mgr.AddTaskType("tm_moveto", "blank.st", nil, {allowpretasks = true; displayname = GetString("movetolocation")})
		ml_task_mgr.AddTaskType("tm_generic", "blank.st", nil, {allowpretasks = true; allowposttasks = true; allowsubtasks = true; displayname = GetString("blanktask")})
		
		ml_task_mgr.AddSubTaskType("tm_st_movetomultiple", "tm_MoveToMultiple.st", nil, {displayname = GetString("movetomultiplelocations")})
		ml_task_mgr.AddSubTaskType("tm_st_moveto", "tm_MoveTo.st", nil, {displayname = GetString("movetolocation")})
		ml_task_mgr.AddSubTaskType("tm_st_interact", "tm_Interact.st", nil, {displayname = GetString("interact")})
		ml_task_mgr.AddSubTaskType("tm_st_fightaggro", "HandleAggro.st", nil, {displayname = GetString("fightaggro")})
		ml_task_mgr.AddSubTaskType("tm_st_killspecific", "tm_CombatHandler.st", nil, {displayname = GetString("killspecific")})
		ml_task_mgr.AddSubTaskType("tm_st_hqstatus", "tm_CheckHQStatus.st", nil, {displayname = GetString("checkhqstatus")})
		ml_task_mgr.AddSubTaskType("tm_st_talk", "tm_Talk.st", nil, {displayname = GetString("talk")})
		ml_task_mgr.AddSubTaskType("tm_st_changemesh", "tm_ChangeMesh.st", nil, {displayname = GetString("changemesh")})		
	end
end
RegisterEventHandler("Module.Initalize",gw2minion.Init)

function gw2minion.DrawCall(event, ticks )
	
	if ( not gw2minion.mainbtreeinstance ) then
		if ( FolderExists(GetStartupPath()  .. "\\\LuaMods\\\GW2Minion\\\Behavior")) then
			if ( FileExists(GetStartupPath()  .. "\\\LuaMods\\\GW2Minion\\\Behavior\\\GW2_Main.ct")) then 
			
				gw2minion.mainbtreeinstance = ml_bt_mgr.LoadBehaviorTree(GetStartupPath()  .. "\\\LuaMods\\\GW2Minion\\\Behavior", "GW2_Main.ct")
				 -- getting the context for the BTree
				gw2minion.mainbtreeinstance.context = gw2minion.mainbtreeinstance:start() 
				
				-- REMOVE THIS FROM THE LIVE ADDONS OR ELSE EVERYONE CAN JUST DUMP YOUR BEHAVIOR TREE! THIS IS JUST SO YOU CAN EDIT YOUR OWN BTREE IN THE EDITOR "live"
				local btentry = {
					name = "GW2_Main",
					filename = "GW2_Main.ct",
					filepath = GetStartupPath()  .. "\\\LuaMods\\\GW2Minion\\\Behavior",
					liveinstance = gw2minion.mainbtreeinstance				
				}
				
				ml_bt_mgr.SetLiveInstance(btentry)
			else
				ml_error("[gw2minion.DrawCall] - Invalid File: "..GetStartupPath()  .. "\\\LuaMods\\\GW2Minion\\\Behavior\\\GW2_Main.ct")
			end
		else
			if ( not FolderCreate (GetStartupPath()  .. "\\\LuaMods\\\GW2Minion\\\Behavior") ) then 
				ml_error("[gw2minion.DrawCall] - Invalid Folder: "..GetStartupPath()  .. "\\\LuaMods\\\GW2Minion\\\Behavior")
			end
		end
		
	else	
		if ( not gw2minion.mainbtreeinstance.isloadedineditor ) then 
			gw2minion.mainbtreeinstance:run()
		end
	end
end
RegisterEventHandler("Gameloop.Draw", gw2minion.DrawCall)


function gw2minion.RefreshGuestServers()
	ml_global_information.GuestServerList = { [0] = "None" }
	local homeserverid = GetHomeServer()	
	-- US Servers
	if ( homeserverid > 1000 and homeserverid < 2000 ) then
		ml_global_information.GuestServerList = {
			[0]="None",
			[1010]="Ehmry Bay",
			[1018]="Northern Shiverpeaks",
			[1002]="Borlis Pass",
			[1008]="Jade Quarry",
			[1005]="Maguuma",
			[1015]="Isle of Janthir",
			[1009]="Fort Aspenwood",
			[1013]="Sanctum of Rall",
			[1007]="Gate of Madness",
			[1006]="Sorrow's Furnace",
			[1019]="Blackgate",
			[1021]="Dragonbrand",
			[1012]="Darkhaven",
			[1003]="Yak's Bend",
			[1014]="Crystal Desert",
			[1001]="Anvil Rock",
			[1011]="Stormbluff Isle",
			[1020]="Ferguson's Crossing",
			[1016]="Sea of Sorrows",
			[1022]="Kaineng",
			[1023]="Devona's Rest",
			[1017]="Tarnished Coast",
			[1024]="Eredon Terrace",
			[1004]="Henge of Denravi",
		}	
	elseif ( homeserverid > 2000 and homeserverid < 3000 ) then
		-- EU Servers
		ml_global_information.GuestServerList = {
			[0]="None",
			[2012]="Piken Square",
			[2003]="Gandara",
			[2007]="Far Shiverpeaks",
			[2204]="Abaddon's Mouth [DE]",
			[2201]="Kodash [DE]",
			[2010]="Seafarer's Rest",
			[2301]="Baruch Bay [SP]",
			[2205]="Drakkar Lake [DE]",
			[2002]="Desolation",
			[2202]="Riverside [DE]",
			[2008]="Whiteside Ridge",
			[2203]="Elona Reach [DE]",
			[2206]="Miller's Sound [DE]",
			[2004]="Blacktide",
			[2207]="Dzagonur [DE]",
			[2105]="Arborstone [FR]",
			[2101]="Jade Sea [FR]",
			[2013]="Aurora Glade",
			[2103]="Augury Rock [FR]",
			[2102]="Fort Ranik [FR]",
			[2104]="Vizunah Square [FR]",
			[2009]="Ruins of Surmia",
			[2014]="Gunnar's Hold",
			[2005]="Ring of Fire",
			[2006]="Underworld",
			[2011]="Vabbi",
			[2001]="Fissure of Woe",
		}
	end
end