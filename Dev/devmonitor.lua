Dev = { }
Dev.lastticks = 0
Dev.running = false
Dev.curTask = nil
Dev.initialized = false

function Dev.ModuleInit()
	
	GUI_NewWindow("Dev",400,50,250,430)		
	GUI_WindowVisible("Dev",false)	
	GUI_NewButton("Dev","TOGGLE DEVMONITOR ON_OFF","Dev.Test1")
	RegisterEventHandler("Dev.Test1", Dev.LoadModule)
end

function Dev.LoadModule()
	if ( Dev.initialized == false ) then
	Dev.initialized = true
	GUI_NewComboBox("Dev","Player/TargetInfo","chartarg","CharacterInfo","Player,Target");
	GUI_NewField("Dev","Ptr","TargetPtr","CharacterInfo")
	GUI_NewField("Dev","Ptr2","TargetPtr2","CharacterInfo")
	GUI_NewField("Dev","ID","TID","CharacterInfo")
	GUI_NewField("Dev","ContentID","TCID","CharacterInfo")
	GUI_NewField("Dev","Type","TType","CharacterInfo")	
	GUI_NewField("Dev","Name","TName","CharacterInfo")
	GUI_NewField("Dev","SpecName","TSName","CharacterInfo")
	GUI_NewField("Dev","Health","THP","CharacterInfo")
	GUI_NewField("Dev","Position","TPos","CharacterInfo")
	GUI_NewField("Dev","Heading","THead","CharacterInfo")
	GUI_NewField("Dev","Height/Radius","THRad","CharacterInfo")
	GUI_NewField("Dev","MovementState","TMoveState","CharacterInfo")
	GUI_NewField("Dev","MovementSpeed","TSpeed","CharacterInfo")
	GUI_NewField("Dev","In LOS","TLOS","CharacterInfo")
	GUI_NewField("Dev","OnMesh","TOnMesh","CharacterInfo")
	GUI_NewField("Dev","OnMeshExact","TOnMeshEx","CharacterInfo")
	GUI_NewField("Dev","Distance","TDist","CharacterInfo")
	GUI_NewField("Dev","PathDistance","TPDist","CharacterInfo")
	GUI_NewField("Dev","Profession","TProf","CharacterInfo")
	GUI_NewField("Dev","IsInInteractRange","TIsInInteractR","CharacterInfo")
	GUI_NewField("Dev","Interactable","TInteractable","CharacterInfo")
	GUI_NewField("Dev","Selectable","TSele","CharacterInfo")
	GUI_NewField("Dev","Attackable","TAtta","CharacterInfo")
	GUI_NewField("Dev","Lootable","TLootable","CharacterInfo")
	GUI_NewField("Dev","Level","TLvl","CharacterInfo")	
	GUI_NewField("Dev","HasPet","THasPet","CharacterInfo")
	GUI_NewField("Dev","IsAlive","TAlive","CharacterInfo")
	GUI_NewField("Dev","IsDowned","TDown","CharacterInfo")
	GUI_NewField("Dev","IsDead","TDead","CharacterInfo")
	GUI_NewField("Dev","Attitude","TAttit","CharacterInfo")
	GUI_NewField("Dev","IsAggro","TAggro","CharacterInfo")
	GUI_NewField("Dev","AggroPercent","TAggroPercent","CharacterInfo")
	GUI_NewField("Dev","InCombat","TInCombat","CharacterInfo")
	GUI_NewField("Dev","AttackedTargetPtr","TAttPrr","CharacterInfo")
	GUI_NewField("Dev","AttackedTargetID","TAttID","CharacterInfo")
	GUI_NewField("Dev","Current SpellID","TAttSPID","CharacterInfo")
	GUI_NewField("Dev","Last SpellID","TAttLSPID","CharacterInfo")
	GUI_NewField("Dev","Skill Slot","TAttSlot","CharacterInfo")
	GUI_NewField("Dev","Skill Duration","TAttSDur","CharacterInfo")
	GUI_NewField("Dev","IsControlled","TIsControlled","CharacterInfo")
	GUI_NewField("Dev","IsPlayer","TIsPlayer","CharacterInfo")
	GUI_NewField("Dev","IsPet","TIsPet","CharacterInfo")
	GUI_NewField("Dev","IsNPC","TIsMonster","CharacterInfo")
	GUI_NewField("Dev","IsClone","TIsClone","CharacterInfo")
	GUI_NewField("Dev","IsCritter","TIsCrit","CharacterInfo")
	GUI_NewField("Dev","IsEventNPC","TIsEventNPC","CharacterInfo")
	GUI_NewField("Dev","IsInWater","TIsInWater","CharacterInfo")
	GUI_NewField("Dev","IsDiving","TIsDiving","CharacterInfo")
	GUI_NewField("Dev","IsSwimming","TIsSwimming","CharacterInfo")
	GUI_NewField("Dev","IsChampion","TIsChamp","CharacterInfo")
	GUI_NewField("Dev","IsVeteran","TIsVet","CharacterInfo")
	GUI_NewField("Dev","IsLegendary","TIsLegend","CharacterInfo")
	GUI_NewField("Dev","IsElite","TIsElite","CharacterInfo")	
	GUI_NewField("Dev","IsUnknown0","TIsUnknown0","CharacterInfo")
	GUI_NewField("Dev","isGathering","TisGathering","CharacterInfo")
	GUI_NewField("Dev","IsUnknown2","TIsUnknown2","CharacterInfo")
	GUI_NewField("Dev","IsUnknown3","TIsUnknown3","CharacterInfo")
	GUI_NewField("Dev","IsUnknown4","TIsUnknown4","CharacterInfo")
	GUI_NewField("Dev","IsUnknown5","TIsUnknown5","CharacterInfo")
	GUI_NewField("Dev","IsUnknown6","TIsUnknown6","CharacterInfo")
	GUI_NewField("Dev","IsUnknown7","TIsUnknown7","CharacterInfo")
	GUI_NewField("Dev","IsUnknown8","TIsUnknown8","CharacterInfo")
	GUI_NewField("Dev","IsUnknown9","TIsUnknown9","CharacterInfo")
	GUI_NewField("Dev","IsUnknown10","TIsUnknown10","CharacterInfo")
	GUI_NewField("Dev","IsUnknown11","TIsUnknown11","CharacterInfo")
	GUI_NewField("Dev","IsUnknown12","TIsUnknown12","CharacterInfo")
	GUI_NewField("Dev","IsHeartQuestGiver","TIsUnknown13","CharacterInfo")

	chartarg = "Target"
	
	-- GadgetInfo
	GUI_NewField("Dev","Ptr","GTargetPtr","GadgetInfo")
	GUI_NewField("Dev","ID","GTID","GadgetInfo")	
	GUI_NewField("Dev","ContentID","GTCID","GadgetInfo")
	GUI_NewField("Dev","ContentID2","GTCID2","GadgetInfo")
	GUI_NewField("Dev","Type","GTType","GadgetInfo")	
	GUI_NewField("Dev","Type2","GTType2","GadgetInfo")	
	GUI_NewField("Dev","Name","GTName","GadgetInfo")
	GUI_NewField("Dev","Health","GTHP","GadgetInfo")
	GUI_NewField("Dev","Position","GTPos","GadgetInfo")
	GUI_NewField("Dev","Heading","GTHead","GadgetInfo")	
	GUI_NewField("Dev","Height/Radius","GTHRad","GadgetInfo")	
	GUI_NewField("Dev","In LOS","GTLOS","GadgetInfo")
	GUI_NewField("Dev","OnMesh","GTOnMesh","GadgetInfo")
	GUI_NewField("Dev","Distance","GTDist","GadgetInfo")
	GUI_NewField("Dev","PathDistance","GTPDist","GadgetInfo")
	GUI_NewField("Dev","IsInInteractRange","GTIsInInteractR","GadgetInfo")
	GUI_NewField("Dev","Interactable","GTInteractable","GadgetInfo")
	GUI_NewField("Dev","Selectable","GTSelec","GadgetInfo")	
	GUI_NewField("Dev","Attackable","GTAttack","GadgetInfo")
	GUI_NewField("Dev","Lootable","GTLootable","GadgetInfo")	
	GUI_NewField("Dev","Attitude","GTAttit","GadgetInfo")
	GUI_NewField("Dev","RessourceType","GTRessType","GadgetInfo")
	GUI_NewField("Dev","IsSelectable","GTSelectable","GadgetInfo")
	GUI_NewField("Dev","IsAlive","GTAlive","GadgetInfo")
	GUI_NewField("Dev","IsDead","GTDead","GadgetInfo")
	GUI_NewField("Dev","IsCombatant","GTIsCombat","GadgetInfo")
	GUI_NewField("Dev","IsGatherable","GTIsGather","GadgetInfo")
	GUI_NewField("Dev","HasHPBar","GTHasHP","GadgetInfo")	
	GUI_NewField("Dev","IsOurs","GTIsOurs","GadgetInfo")
	GUI_NewField("Dev","IsUnknown0","GTIsUnknown0","GadgetInfo")
	GUI_NewField("Dev","IsUnknown1","GTIsUnknown1","GadgetInfo")
	GUI_NewField("Dev","IsUnknown2","GTIsUnknown2","GadgetInfo")
	GUI_NewField("Dev","IsUnknown3","GTIsUnknown3","GadgetInfo")
	GUI_NewField("Dev","IsUnknown4","GTIsUnknown4","GadgetInfo")
	GUI_NewField("Dev","IsUnknown5","GTIsUnknown5","GadgetInfo")
	GUI_NewField("Dev","IsUnknown6","GTIsUnknown6","GadgetInfo")
	GUI_NewField("Dev","IsUnknown7","GTIsUnknown7","GadgetInfo")
	GUI_NewField("Dev","IsUnknown8","GTIsUnknown8","GadgetInfo")
	GUI_NewField("Dev","IsTurret","GTIsUnknown9","GadgetInfo")
	GUI_NewField("Dev","IsUnknown10","GTIsUnknown10","GadgetInfo")
	GUI_NewField("Dev","IsUnknown11","GTIsUnknown11","GadgetInfo")
	GUI_NewField("Dev","IsUnknown12","GTIsUnknown12","GadgetInfo")
	GUI_NewField("Dev","IsUnknown13","GTIsUnknown13","GadgetInfo")
	
	-- Buffinfo
	GUI_NewComboBox("Dev","BuffSource","bufftarg","BuffInfo","Player,Target");
	GUI_NewNumeric("Dev","ListEntry","buffSlot","BuffInfo","0","999");
	GUI_NewField("Dev","Ptr","BPtr","BuffInfo")
	GUI_NewField("Dev","Name","BIName","BuffInfo")
	GUI_NewField("Dev","BuffID","BIID","BuffInfo")
	GUI_NewField("Dev","ContentID","BICID","BuffInfo")	
	GUI_NewField("Dev","Stacks","BIStack","BuffInfo")
	GUI_NewField("Dev","Flags","BIFlag","BuffInfo")	
	bufftarg = "Player"
	buffSlot = 0	
	
	
	-- Inventory
	GUI_NewComboBox("Dev","Inventory/Equipped","iSource","InventoryInfo","Inventory,Equipped");
	GUI_NewNumeric("Dev","ItemSlot","invSlot","InventoryInfo","0","999");
	GUI_NewField("Dev","Ptr","IPtr","InventoryInfo")
	GUI_NewField("Dev","ItemID","IID","InventoryInfo")
	GUI_NewField("Dev","Name","IName","InventoryInfo")
	GUI_NewField("Dev","Rarity","IRar","InventoryInfo")
	GUI_NewField("Dev","ItemType","IType","InventoryInfo")
	GUI_NewField("Dev","WeaponType","IWeap","InventoryInfo")
	GUI_NewField("Dev","Durability","IDur","InventoryInfo")
	GUI_NewField("Dev","Location","ILoc","InventoryInfo")
	GUI_NewField("Dev","StackCount","IStack","InventoryInfo")
	GUI_NewField("Dev","Soulbound","ISould","InventoryInfo")
	GUI_NewField("Dev","Req.Soulbind","IRSoul","InventoryInfo")
	GUI_NewField("Dev","Accountbound","IAccbou","InventoryInfo")
	GUI_NewField("Dev","IsSalvagable","ISalv","InventoryInfo")
	GUI_NewButton("Dev","UseItem","Dev.IUse","InventoryInfo")
	RegisterEventHandler("Dev.IUse", Dev.Func)
	GUI_NewNumeric("Dev","Equip to Slot","ieqslot","InventoryInfo","0","36");
	GUI_NewButton("Dev","EquipItem","Dev.Equip","InventoryInfo")
	RegisterEventHandler("Dev.Equip", Dev.Func)		
	GUI_NewButton("Dev","DestroyItem","Dev.IDestroy","InventoryInfo")
	RegisterEventHandler("Dev.IDestroy", Dev.Func)	
	GUI_NewButton("Dev","SoulBindItem","Dev.Bind","InventoryInfo")
	RegisterEventHandler("Dev.Bind", Dev.Func)	
	GUI_NewButton("Dev","SalvageItem","Dev.Salvage","InventoryInfo")
	RegisterEventHandler("Dev.Salvage", Dev.Func)	
	GUI_NewButton("Dev","SellItem","Dev.ISell","InventoryInfo")
	RegisterEventHandler("Dev.ISell", Dev.Func)
	GUI_NewField("Dev","Items","ICount","InventoryInfo")
	GUI_NewField("Dev","TotalSlots","ISlots","InventoryInfo")
	GUI_NewField("Dev","FreeSlots","IFree","InventoryInfo")
	GUI_NewField("Dev","Money","IMoney","InventoryInfo")
	GUI_NewButton("Dev","DepositCollectables","Dev.Deposit","InventoryInfo")
	RegisterEventHandler("Dev.Deposit", Dev.Func)	
	ieqslot = 0
	iSource = "Inventory"
	invSlot = 0
	
	-- Vendor
	GUI_NewField("Dev","IsVendorOpen","VOpen","VendorInfo")
	GUI_NewNumeric("Dev","ItemSlot","vendSlot","VendorInfo","0","999");
	GUI_NewField("Dev","Ptr","VPtr","VendorInfo")
	GUI_NewField("Dev","ItemID","VID","VendorInfo")
	GUI_NewField("Dev","Name","VName","VendorInfo")
	GUI_NewField("Dev","Rarity","Vrar","VendorInfo")
	GUI_NewField("Dev","Price","VPrice","VendorInfo")
	GUI_NewField("Dev","Quantity","VQuant","VendorInfo")	
	GUI_NewField("Dev","ItemType","VType","VendorInfo")
	GUI_NewField("Dev","WeaponType","VWType","VendorInfo")
	GUI_NewButton("Dev","SellJunk","Dev.SellJunk","VendorInfo")
	RegisterEventHandler("Dev.SellJunk", Dev.Func)
	vendSlot = 0
	
	-- MapMarkerInfo
	GUI_NewComboBox("Dev","Closest/ListIndex","mmselection","MapMarkerInfo","Closest,ListIndex");
	GUI_NewNumeric("Dev","ListIndex","mmindex","MapMarkerInfo","0","9999");
	GUI_NewField("Dev","Ptr","MPtr","MapMarkerInfo")
	GUI_NewField("Dev","MDefPtr","MDefPtr","MapMarkerInfo")
	GUI_NewField("Dev","ListIndex(ID)","MID","MapMarkerInfo")
	GUI_NewField("Dev","Name/Description","MName","MapMarkerInfo")
	GUI_NewField("Dev","Type","MType","MapMarkerInfo")
	GUI_NewField("Dev","MarkerType","MMType","MapMarkerInfo")
	GUI_NewField("Dev","WorldMarkerType","MWMType","MapMarkerInfo")	
	GUI_NewField("Dev","EventID","MEventID","MapMarkerInfo")
	GUI_NewField("Dev","CharacterID","MCharID","MapMarkerInfo")
	GUI_NewField("Dev","ContentID","McontentID","MapMarkerInfo")
	GUI_NewField("Dev","SubRegionID","MSubRID","MapMarkerInfo")
	GUI_NewField("Dev","Position","MPos","MapMarkerInfo")
	GUI_NewField("Dev","IsOnMesh","MOnMesh","MapMarkerInfo")
	GUI_NewField("Dev","Distance","MDist","MapMarkerInfo")
	GUI_NewField("Dev","PathDistance","MPDist","MapMarkerInfo")	
	GUI_NewField("Dev","IsCharacter","MIChar","MapMarkerInfo")
	GUI_NewField("Dev","IsEvent","MIEvent","MapMarkerInfo")
	GUI_NewField("Dev","IsFloorChanger","MIFC","MapMarkerInfo")
	GUI_NewField("Dev","IsWorldPortal","MIWP","MapMarkerInfo")
	GUI_NewField("Dev","IsWaypoint","MIWayP","MapMarkerInfo")
	GUI_NewField("Dev","IsSubregion","MISR","MapMarkerInfo")
	GUI_NewField("Dev","IsVista","MIVist","MapMarkerInfo")
	GUI_NewField("Dev","IsUserWaypoint","MIUWay","MapMarkerInfo")
	GUI_NewField("Dev","IsUnknown0","MIsUnknown0","MapMarkerInfo")
	GUI_NewField("Dev","IsUnknown1","MIsUnknown1","MapMarkerInfo")
	GUI_NewField("Dev","IsUnknown2","MIsUnknown2","MapMarkerInfo")
	GUI_NewField("Dev","RegionDefPtr","MRegionDefPtr","MapMarkerInfo")
	GUI_NewField("Dev","RegionName","MRegionName","MapMarkerInfo")
	GUI_NewField("Dev","IsUnknown4","MIsUnknown4","MapMarkerInfo")
	GUI_NewField("Dev","IsUnknown5","MIsUnknown5","MapMarkerInfo")
	GUI_NewField("Dev","IsUnknown6","MIsUnknown6","MapMarkerInfo")
	GUI_NewField("Dev","IsUnknown7","MIsUnknown7","MapMarkerInfo")
	GUI_NewField("Dev","IsUnknown8","MIsUnknown8","MapMarkerInfo")
	GUI_NewField("Dev","IsUnknown9","MIsUnknown9","MapMarkerInfo")
	GUI_NewField("Dev","IsUnknown10","MIsUnknown10","MapMarkerInfo")
	GUI_NewField("Dev","IsUnknown11","MIsUnknown11","MapMarkerInfo")
	GUI_NewField("Dev","IsUnknown12","MIsUnknown12","MapMarkerInfo")
	GUI_NewField("Dev","IsUnknown13","MIsUnknown13","MapMarkerInfo")
	GUI_NewField("Dev","IsUnknown14","MIsUnknown14","MapMarkerInfo")
	GUI_NewField("Dev","IsCommander","MisCommander","MapMarkerInfo")
	mmindex = 0
	mmselection = "Closest"
	
	-- EventInfo
	GUI_NewComboBox("Dev","Closest/ListIndex","evselection","EventInfo","Closest,ListIndex");
	GUI_NewNumeric("Dev","ListIndex","evindex","EventInfo","0","9999");
	GUI_NewField("Dev","MarkerPtr","EVPtr","EventInfo")
	GUI_NewField("Dev","EventPtr","EVEPtr","EventInfo")
	GUI_NewField("Dev","Name","EVName","EventInfo")
	GUI_NewField("Dev","Type","EVType","EventInfo")
	GUI_NewField("Dev","MarkerType","EVMType","EventInfo")
	GUI_NewField("Dev","WorldMarkerType","EVWMType","EventInfo")	
	GUI_NewField("Dev","EventID","EVEventID","EventInfo")
	GUI_NewField("Dev","CharacterID","EVCharID","EventInfo")
	GUI_NewField("Dev","QuestID","EVQuestID","EventInfo")
	GUI_NewField("Dev","SubRegionID","EVSubRID","EventInfo")
	GUI_NewField("Dev","Position","EVPos","EventInfo")
	GUI_NewField("Dev","IsOnMesh","EVOnMesh","EventInfo")
	GUI_NewField("Dev","Distance","EVDist","EventInfo")	
	GUI_NewField("Dev","Level","EVLvl","EventInfo")
	GUI_NewField("Dev","IsRunning","EVIR","EventInfo")
	GUI_NewField("Dev","IsDungeonEvent","EVIDE","EventInfo")
	GUI_NewField("Dev","IsUnknown0","EVIsUnknown0","EventInfo")
	GUI_NewField("Dev","IsUnknown1","EVIsUnknown1","EventInfo")
	GUI_NewField("Dev","IsUnknown2","EVIsUnknown2","EventInfo")
	GUI_NewField("Dev","IsUnknown3","EVIsUnknown3","EventInfo")
	GUI_NewField("Dev","IsUnknown4","EVIsUnknown4","EventInfo")
	GUI_NewField("Dev","IsUnknown5","EVIsUnknown5","EventInfo")
	GUI_NewField("Dev","IsUnknown6","EVIsUnknown6","EventInfo")
	GUI_NewField("Dev","ObjectiveCount","EVOC","EventInfo")
	GUI_NewNumeric("Dev","ObjectiveListIndex","evoindex","EventInfo","0","9999");
	GUI_NewField("Dev","ObjectivePtr","EVOPtr","EventInfo")
	GUI_NewField("Dev","Type","EVOType","EventInfo")
	GUI_NewField("Dev","ID","EVOID","EventInfo")
	GUI_NewField("Dev","Ob_Value1","EVO1","EventInfo")
	GUI_NewField("Dev","Ob_Value2","EVO2","EventInfo")
	GUI_NewField("Dev","Ob_Value3","EVO3","EventInfo")
	GUI_NewField("Dev","Ob_Value4","EVO4","EventInfo")
	GUI_NewField("Dev","Ob_Value5","EVO5","EventInfo")
	
	evindex = 0
	evselection = "Closest"
	evoindex = 0
	
	-- WaypointInfo
	GUI_NewComboBox("Dev","Closest/ListIndex","wpselection","WaypointInfo","Closest,ListIndex");
	GUI_NewNumeric("Dev","ListIndex","wpindex","WaypointInfo","0","9999");
	GUI_NewField("Dev","Ptr","WPPtr","WaypointInfo")
	GUI_NewField("Dev","ID","WPID","WaypointInfo")
	GUI_NewField("Dev","Name","WPName","WaypointInfo")
	GUI_NewField("Dev","Distance","WPDist","WaypointInfo")
	GUI_NewField("Dev","Position","WPPos","WaypointInfo")
	GUI_NewField("Dev","OnMesh","WPOnMesh","WaypointInfo")
	GUI_NewField("Dev","Contested","WPCont","WaypointInfo")
	GUI_NewField("Dev","IsInSamezone","WPSameZ","WaypointInfo")	
	GUI_NewButton("Dev","TeleportToWaypoint","Dev.TeleWP","WaypointInfo")
	RegisterEventHandler("Dev.TeleWP", Dev.Func)
	GUI_NewButton("Dev","RespawnAtClosestWaypoint","Dev.Respawn","WaypointInfo")
	RegisterEventHandler("Dev.Respawn", Dev.Func)	
	wpindex = 0
	wpselection = "Closest"
	
	-- MovementInfo
	GUI_NewField("Dev","CanMove","micanmove","MovementInfo")
	GUI_NewField("Dev","IsMoving","mimov","MovementInfo")
	GUI_NewField("Dev","MovmentState","mistate","MovementInfo")
	GUI_NewField("Dev","MovementDirection","midirect","MovementInfo")
	GUI_NewNumeric("Dev","SetMovementType","mimovf","MovementInfo","0","12")
	mimovf = 0
	GUI_NewButton("Dev","SetMovementType","Dev.MoveDir","MovementInfo")
	RegisterEventHandler("Dev.MoveDir", Dev.Move)
	GUI_NewButton("Dev","UnSetMovementType","Dev.UnMoveDir","MovementInfo")
	RegisterEventHandler("Dev.UnMoveDir", Dev.Move)	
	GUI_NewButton("Dev","Stop Movement","Dev.MoveS","MovementInfo")
	RegisterEventHandler("Dev.MoveS", Dev.Move)		
	GUI_NewNumeric("Dev","EvadeDirection","mievdir","MovementInfo","0","7")
	mievdir= 0
	GUI_NewField("Dev","CanEvadeToDirection","micanevdir","MovementInfo")	
	GUI_NewButton("Dev","Evade","Dev.Evade","MovementInfo")
	RegisterEventHandler("Dev.Evade", Dev.Move)
	GUI_NewButton("Dev","Jump","Dev.Jump","MovementInfo")
	RegisterEventHandler("Dev.Jump", Dev.Move)		
	GUI_NewField("Dev","IsFacingCurrentTarget","mifacet","MovementInfo")
	GUI_NewButton("Dev","FaceCurrentTarget","Dev.FaceT","MovementInfo")
	RegisterEventHandler("Dev.FaceT", Dev.Move)
	GUI_NewButton("Dev","FaceExactCurrentTarget","Dev.FaceET","MovementInfo")
	RegisterEventHandler("Dev.FaceET", Dev.Move)
	
	-- Navigation
	GUI_NewButton("Dev","ChangeMeshRenderDepth","Dev.ChangeMDepth","NavigationSystem")
	RegisterEventHandler("Dev.ChangeMDepth", Dev.Func)
	GUI_NewField("Dev","X: ","tb_xPos","NavigationSystem")
	GUI_NewField("Dev","Y: ","tb_yPos","NavigationSystem")
	GUI_NewField("Dev","Z: ","tb_zPos","NavigationSystem")
	GUI_NewButton("Dev","GetCurrentPos","Dev.playerPosition","NavigationSystem")
	RegisterEventHandler("Dev.playerPosition", Dev.Move)
	GUI_NewComboBox("Dev","NavigationType","Nnavitype","NavigationSystem","Normal,Follow");
	GUI_NewComboBox("Dev","MovementType","Nmovetype","NavigationSystem","Straight,Random");
	GUI_NewCheckbox("Dev","SmoothTurns","Nsmooth","NavigationSystem");
	GUI_NewField("Dev","NavigateTo Result:","tb_nRes","NavigationSystem")
	GUI_NewButton("Dev","NavigateTo","Dev.naviTo","NavigationSystem")
	RegisterEventHandler("Dev.naviTo", Dev.Move)
	GUI_NewButton("Dev","Stop Movement","Dev.MoveS","NavigationSystem")
	GUI_NewField("Dev","RandomPtInCircleMinRadius","tb_min","NavigationSystem")
	GUI_NewField("Dev","RandomPtInCircleMaxRadius","tb_max","NavigationSystem")
	GUI_NewButton("Dev","GetRandomPointInCircle","Dev.ranPT","NavigationSystem")
	GUI_NewField("Dev","DistToRandomWaypoint","tb_xdist","NavigationSystem")
	RegisterEventHandler("Dev.ranPT", Dev.Move)
	tb_min = 0
	tb_max = 500
	GUI_NewButton("Dev","Teleport","Dev.Teleport","NavigationSystem")
	tb_nPoints = 0
	Nmovetype = "Straight"
	Nnavitype = "Normal"
	GUI_NewNumeric("Dev","ObstacleSize","obsSize","NavigationSystem","32","9999")
	obsSize = 50
	GUI_NewButton("Dev","AddObstacle","Dev.AddOB","NavigationSystem")
	RegisterEventHandler("Dev.AddOB", Dev.Move)
	GUI_NewButton("Dev","ClearObstacles","Dev.ClearOB","NavigationSystem")
	RegisterEventHandler("Dev.ClearOB", Dev.Move)
	GUI_NewNumeric("Dev","AvoidanceAreaSize","avoidSize","NavigationSystem","32","9999")
	avoidSize = 50
	GUI_NewButton("Dev","AddAvoidancearea","Dev.AddAA","NavigationSystem")
	RegisterEventHandler("Dev.AddAA", Dev.Move)
	GUI_NewButton("Dev","ClearAvoidanceareas","Dev.ClearAA","NavigationSystem")
	RegisterEventHandler("Dev.ClearAA", Dev.Move)
	
	-- Spell&CastingInfo
	GUI_NewField("Dev","IsCasting","SCIsCast","Spell&CastingInfo")
	GUI_NewField("Dev","CanCast","SCCanC","Spell&CastingInfo")
	GUI_NewField("Dev","IsSkillPending","SCPend","Spell&CastingInfo")
	GUI_NewField("Dev","CurrentlyCastSlot","SCCurCast","Spell&CastingInfo")
	GUI_NewField("Dev","CanSwapWeapons","SCCanSwap","Spell&CastingInfo")
	GUI_NewButton("Dev","SwapWeapons","Dev.SwapWeapons","Spell&CastingInfo")
	RegisterEventHandler("Dev.SwapWeapons", Dev.Func)	
	GUI_NewNumeric("Dev","ListIndex","SCindex","Spell&CastingInfo","0","16");
	GUI_NewField("Dev","Ptr","SCPtr","Spell&CastingInfo")
	GUI_NewField("Dev","Slot","SCSlot","Spell&CastingInfo")
	GUI_NewField("Dev","SkillID","SCID","Spell&CastingInfo")
	GUI_NewField("Dev","Name","SCName","Spell&CastingInfo")
	GUI_NewField("Dev","Cooldown","SCCD","Spell&CastingInfo")
	GUI_NewField("Dev","CooldownMax","SCCDM","Spell&CastingInfo")
	GUI_NewField("Dev","MinRange","SCMinR","Spell&CastingInfo")
	GUI_NewField("Dev","MaxRange","SCMaxR","Spell&CastingInfo")
	GUI_NewField("Dev","Radius","SCRad","Spell&CastingInfo")
	GUI_NewField("Dev","SkillType","SCType","Spell&CastingInfo")
	GUI_NewField("Dev","GroundTargeted","SCGT","Spell&CastingInfo")
	GUI_NewButton("Dev","CastSpell","Dev.CastSP","Spell&CastingInfo")
	RegisterEventHandler("Dev.CastSP", Dev.Func)
	GUI_NewButton("Dev","CastSpellNoChecks","Dev.CastSPN","Spell&CastingInfo")
	RegisterEventHandler("Dev.CastSPN", Dev.Func)
	SCindex = 0
	
	-- Hacks	
	GUI_NewField("Dev","X: ","tb_xPos","Hacks")
	GUI_NewField("Dev","Y: ","tb_yPos","Hacks")
	GUI_NewField("Dev","Z: ","tb_zPos","Hacks")
	GUI_NewButton("Dev","GetCurrentPos","Dev.playerPosition","Hacks")
	GUI_NewButton("Dev","Teleport","Dev.Teleport","Hacks")
	RegisterEventHandler("Dev.Teleport", Dev.Func)
	GUI_NewButton("Dev","Resync (manual)","Dev.Resync","Hacks")
	RegisterEventHandler("Dev.Resync", Dev.Func)	
	GUI_NewField("Dev","CurrentSpeed","HackSPC","Hacks")
	GUI_NewNumeric("Dev","SetSpeed","HackSPCS","Hacks","0","5000");
	
	GUI_NewField("Dev","CurrentGravity","HackGrav","Hacks")
	GUI_NewNumeric("Dev","SetGravity","HackGravS","Hacks","0","5000");	
	
	GUI_NewField("Dev","CurrentClimbHeight","HackCL","Hacks")
	GUI_NewNumeric("Dev","SetClimbHeight","HackSCL","Hacks","0","500");
	GUI_NewButton("Dev","Set Values","Dev.SetVals","Hacks")
	RegisterEventHandler("Dev.SetVals", Dev.Func)
	
	GUI_NewCheckbox("Dev","NoClip","HackNoCl","Hacks");
	
	-- ConversationInfo		
	GUI_NewField("Dev","IsConversationOpen","ConOpen","ConversationInfo")
	GUI_NewNumeric("Dev","ListIndex","convindex","ConversationInfo","0","10");
	GUI_NewField("Dev","Ptr","COPtr","ConversationInfo")
	GUI_NewField("Dev","ListIndex","COIdx","ConversationInfo")	
	GUI_NewField("Dev","ID","COID","ConversationInfo")
	GUI_NewField("Dev","Type","COType","ConversationInfo")
	GUI_NewButton("Dev","SelectConversationByType","Dev.SelConvID","ConversationInfo")
	RegisterEventHandler("Dev.SelConvID", Dev.Func)	
	GUI_NewButton("Dev","SelectConversationByIndex","Dev.SelConvIndex","ConversationInfo")
	RegisterEventHandler("Dev.SelConvIndex", Dev.Func)	
	convindex = 0
	
	--PartyInfo
	GUI_NewField("Dev","PartySize","PartySiz","PartyInfo")
	GUI_NewNumeric("Dev","ListIndex","partyindex","PartyInfo","0","5");
	GUI_NewField("Dev","Ptr","ParPtr","PartyInfo")
	GUI_NewField("Dev","ListIndex","ParIdx","PartyInfo")
	GUI_NewField("Dev","CharacterID","ParID","PartyInfo")	
	GUI_NewField("Dev","Name","ParName","PartyInfo")
	GUI_NewField("Dev","MapID","ParMap","PartyInfo")
	GUI_NewField("Dev","ConnectionStatus","ParCon","PartyInfo")
	GUI_NewField("Dev","InvitationStatus","ParInv","PartyInfo")	
	GUI_NewField("Dev","IsInAParty","ParPar","PartyInfo")
	GUI_NewField("Dev","Profession","ParProf","PartyInfo")
	GUI_NewField("Dev","Level","ParLvl","PartyInfo")
	GUI_NewField("Dev","HomeServerID","ParHSI","PartyInfo")
	GUI_NewField("Dev","CurrentServerID","ParCSI","PartyInfo")
	GUI_NewField("Dev","InstanceServerID","ParISI","PartyInfo")	
	GUI_NewField("Dev","Unknown","ParUnk","PartyInfo")	
	GUI_NewField("Dev","Unknown1","ParUnk1","PartyInfo")
	partyindex = 0
	
	--DungeonInfo
	GUI_NewField("Dev","IsInstanceDialogShown","DunDS","DungeonInfo")
	GUI_NewField("Dev","IsInstanceRegistered","DunISReg","DungeonInfo")	
	GUI_NewField("Dev","InstanceEntryID","DunEID","DungeonInfo")
	GUI_NewField("Dev","InstanceMode-ID","DunModeID","DungeonInfo")
	GUI_NewField("Dev","InstanceMode2-ID","DunModeID2","DungeonInfo")	
	GUI_NewField("Dev","IsCompleted?","DunIsCompl","DungeonInfo")
	GUI_NewField("Dev","IsCompleted2/CanLeave?","DunIsCompl2","DungeonInfo")	
	GUI_NewField("Dev","Unknown0","DunUnk0","DungeonInfo")
	GUI_NewField("Dev","Unknown1","DunUnk1","DungeonInfo")
	GUI_NewField("Dev","Unknown4","DunUnk4","DungeonInfo")
	GUI_NewField("Dev","Unknown5","DunUnk5","DungeonInfo")
	GUI_NewField("Dev","Unknown5","DunUnk6","DungeonInfo")
	GUI_NewField("Dev","Unknown6","DunInsID","DungeonInfo")
	
	
	GUI_NewButton("Dev","OpenNewInstance","Dev.DOpen","DungeonInfo")
	RegisterEventHandler("Dev.DOpen", Dev.Func)
	GUI_NewButton("Dev","JoinInstance","Dev.DJoin","DungeonInfo")
	RegisterEventHandler("Dev.DJoin", Dev.Func)
	GUI_NewButton("Dev","LeaveInstance","Dev.DLeave","DungeonInfo")
	RegisterEventHandler("Dev.DLeave", Dev.Func)	
	GUI_NewButton("Dev","ResetInstance","Dev.DReset","DungeonInfo")
	RegisterEventHandler("Dev.DReset", Dev.Func)
	GUI_NewField("Dev","CanClaimReward","DunClaim","DungeonInfo")
	GUI_NewButton("Dev","ClaimReward","Dev.DClaim","DungeonInfo")
	RegisterEventHandler("Dev.DReset", Dev.Func)
	
	-- QuestManager
	GUI_NewField("Dev","StoryName","qmstoryname","QuestManager")
	GUI_NewField("Dev","StoryID","qmstoryid","QuestManager")
	GUI_NewField("Dev","QuestName","qmquestname","QuestManager")
	GUI_NewField("Dev","QuestID","qmquestid","QuestManager")
	GUI_NewField("Dev","QuestIsComplete","qmquestcomplete","QuestManager")	
	GUI_NewField("Dev","QuestGoalName","qmgoalname","QuestManager")
	GUI_NewField("Dev","QuestGoalID","qmqgoalid","QuestManager")	
	GUI_NewField("Dev","StepMax","qmsmax","QuestManager")
	GUI_NewField("Dev","StepCurrent","qmscurr","QuestManager")
	GUI_NewField("Dev","StepName","qmsname","QuestManager")
	GUI_NewField("Dev","StepUnknown1","qmsu1","QuestManager")
	GUI_NewField("Dev","StepUnknown2","qmsu2","QuestManager")
	GUI_NewField("Dev","StepUnknown3","qmsu3","QuestManager")
	GUI_NewField("Dev","StepUnknown4","qmsu4","QuestManager")
	GUI_NewField("Dev","StepUnknown5","qmsu5","QuestManager")
	
	GUI_NewField("Dev","RewardCount","qmrewardcount","QuestManager")
	GUI_NewNumeric("Dev","RewardSelected","qmrewardsel","QuestManager","1","50");
	GUI_NewField("Dev","RewardItemName","qmrewardiname","QuestManager")
	GUI_NewField("Dev","RewardItemID","qmrewardiid","QuestManager")
	GUI_NewField("Dev","RewardItemCount","qmrewardicount","QuestManager")
	GUI_NewField("Dev","RewardItemUnknown1","qmrewardiunk1","QuestManager")
	GUI_NewField("Dev","RewardItemSelectable","qmrewardiselect","QuestManager")	
	qmrewardsel = 1
	
	--PetInfo
	GUI_NewField("Dev","HasPet","PetHas","PetInfo")
	GUI_NewField("Dev","CanSwitchPet","PetCanSwitch","PetInfo")
	GUI_NewButton("Dev","SwitchPet","Dev.SwitchP","PetInfo")
	RegisterEventHandler("Dev.SwitchP", Dev.Func)
	
	-- PlayerInfo
	GUI_NewField("Dev","Test1","PIUnk1","PlayerInfo")
	GUI_NewField("Dev","Test2","PIUnk2","PlayerInfo")
	GUI_NewField("Dev","Power/Initiative/Clones","PlPower","PlayerInfo")
	GUI_NewField("Dev","Karma","PlKarma","PlayerInfo")
	GUI_NewField("Dev","Endurance","PlEndura","PlayerInfo")
	GUI_NewField("Dev","XPTotal","TXp","PlayerInfo")
	GUI_NewField("Dev","XPNextLevel","TXpNL","PlayerInfo")
	GUI_NewField("Dev","XPToNextLevel","TXpTNL","PlayerInfo")
	GUI_NewField("Dev","XPCurrent","TXpC","PlayerInfo")
	
	-- GeneralInfo
	GUI_NewField("Dev","Language","GILang","GeneralInfo")
	GUI_NewField("Dev","LocalMapID","GIMapID","GeneralInfo")
	GUI_NewField("Dev","MouseInWorldPos","GMPos","GeneralInfo")
	
		
	
	-- Diverse Functions	
	GUI_NewButton("Dev","AoELoot","Dev.aoeloot","Functions")
	RegisterEventHandler("Dev.aoeloot", Dev.Func)
	GUI_NewButton("Dev","Interact/Use","Dev.Interact","Functions")
	RegisterEventHandler("Dev.Interact", Dev.Func)
	GUI_NewButton("Dev","Gather","Dev.Gather","Functions")
	RegisterEventHandler("Dev.Gather", Dev.Func)
	GUI_NewButton("Dev","LeaveCombatState","Dev.LeaveCmb","Functions")
	RegisterEventHandler("Dev.LeaveCmb", Dev.Func)	
	GUI_NewField("Dev","Entered ID","devstringid","Functions")
	GUI_NewField("Dev","Returned Name","devstring","Functions")
	GUI_NewButton("Dev","GetNameFromID","Dev.STringID","Functions")
	RegisterEventHandler("Dev.STringID", Dev.Func)
	nRenderDepth = 2
	
	GUI_SizeWindow("Dev",250,550)	
	end		
	
	Dev.Test1()	
end

function Dev.GUIVarUpdate(Event, NewVals, OldVals)
    for k,v in pairs(NewVals) do
        if (k == "HackNoCl") then
            if ( v == "1" ) then
                d(Player:NoClip(true))
            else
                d(Player:NoClip(false))
            end        
        end	
	end
end

function Dev.Test1()
	Dev.running = not Dev.running
	if ( not Dev.running) then Dev.curTask = nil end
	d(Dev.running)
end

function Dev.Func ( arg ) 
	if ( arg == "Dev.Deposit") then
		d(Inventory:DepositCollectables())
	elseif ( arg == "Dev.IUse") then
		if ( iSource == "Inventory") then
			local myitem = Inventory:Get(tonumber(invSlot))
			if ( myitem ) then
				d(myitem:Use())
			end
		end
	elseif ( arg == "Dev.Equip") then
		if ( iSource == "Inventory") then
			local myitem = Inventory:Get(tonumber(invSlot))
			if ( myitem ) then
				d(myitem:Equip(tonumber(ieqslot)))
			end
		end
	elseif ( arg == "Dev.IDestroy") then
		if ( iSource == "Inventory") then
			local myitem = Inventory:Get(tonumber(invSlot))
			if ( myitem ) then
				d(myitem:Destroy())
			end
		end
	elseif ( arg == "Dev.Bind") then
		if ( iSource == "Inventory") then
			local myitem = Inventory:Get(tonumber(invSlot))
			if ( myitem ) then
				d(myitem:Bind())
			end
		end
	elseif ( arg == "Dev.Salvage") then
		if ( iSource == "Inventory") then
			local myitem = Inventory:Get(tonumber(invSlot))
			if ( myitem ) then
				d(myitem:Salvage())
			end
		end
	elseif ( arg == "Dev.ISell") then
		if ( iSource == "Inventory") then
			local myitem = Inventory:Get(tonumber(invSlot))
			if ( myitem ) then
				d(myitem:Sell())
			end
		end
	elseif ( arg == "Dev.SellJunk") then
		d(Inventory:SellJunk())
	elseif ( arg == "Dev.STringID") then
		if ( tonumber(devstringid)~=nil) then
			devstring = GetStringFromID(tonumber(devstringid))
		end
	elseif ( arg == "Dev.TeleWP") then
		if ( tonumber(WPID)~=nil and tonumber(WPID) > 0) then
			d(Player:TeleportToWaypoint(WPID))
		end
	elseif ( arg == "Dev.Respawn") then		
		d(Player:RespawnAtClosestWaypoint())	
	elseif ( arg == "Dev.LeaveCmb") then			
		d(Player:LeaveCombatState())
	elseif ( arg == "Dev.SwapWeapons") then		
		d(Player:SwapWeaponSet())
	elseif ( arg == "Dev.CastSP" ) then	
		d(Player:CastSpell(tonumber(SCindex)))
	elseif ( arg == "Dev.CastSPN") then		
		d(Player:CastSpellNoChecks(tonumber(SCindex)))
	elseif ( arg == "Dev.Teleport") then
		if (tonumber(tb_xPos) ~= nil ) then
			d(Player:Teleport(tonumber(tb_xPos),tonumber(tb_yPos),tonumber(tb_zPos)))
		end		
	elseif ( arg == "Dev.Resync") then		
		if (tonumber(tb_xPos) ~= nil ) then
			d(Player:Resync())
		end	
	elseif ( arg == "Dev.SelConvIndex") then		
		if ( Player:IsConversationOpen() ) then
			d(Player:SelectConversationOptionByIndex(tonumber(COID)))
		end	
	elseif ( arg == "Dev.SelConvID") then		
		if ( Player:IsConversationOpen() and tonumber(COType)) then			
			d(Player:SelectConversationOption(tonumber(COType)))
		end
	elseif ( arg == "Dev.SwitchP") then				
		d(Player:SwitchPet())
	elseif ( arg == "Dev.DOpen") then				
		d(Player:OpenInstance())			
	elseif ( arg == "Dev.DJoin") then				
		d(Player:JoinInstance())
	elseif ( arg == "Dev.DLeave") then				
		d(Player:LeaveInstance())
	elseif ( arg == "Dev.DReset") then				
		d(Player:ResetInstance())
	elseif ( arg == "Dev.DClaim" and Player:CanClaimReward()) then				
		d(Player:ClaimReward())
	elseif ( arg == "Dev.ChangeMDepth") then
		d(RenderManager:ChangeMeshDepth())
	elseif ( arg == "Dev.Interact") then		
		local t = Player:GetTarget()
		if ( t ) then
			d(Player:Interact(t.id))
		else
			d(Player:Interact())
		end	
	elseif ( arg == "Dev.Gather") then		
		local t = Player:GetTarget()
		if ( t ) then
			d(Player:Interact(t.id))
		else
			d(Player:Interact())
		end
	elseif ( arg == "Dev.aoeloot") then
		d(Player:AoELoot())		
	elseif ( arg == "Dev.SetVals") then
		
		if ( tonumber(HackSPCS) ~=nil ) then Player:SetSpeed(tonumber(HackSPCS)) end		
		if ( tonumber(HackGravS)~=nil ) then Player:SetGravity(tonumber(HackGravS)) end
		if ( tonumber(HackSCL)~=nil ) then Player:SetCrawlHeight(tonumber(HackSCL)) end
	
	end	
end

Dev.Obstacles = {}
Dev.AvoidanceAreas = {}
function Dev.Move ( arg ) 
	if ( arg == "Dev.MoveDir") then
		d(Player:SetMovement(tonumber(mimovf)))
	elseif ( arg == "Dev.UnMoveDir") then
		d(Player:UnSetMovement(tonumber(mimovf)))		
	elseif ( arg == "Dev.MoveS") then
		d(Player:StopMovement())
	elseif ( arg == "Dev.Evade") then
		d(Player:Evade(tonumber(mievdir)))		
	elseif ( arg == "Dev.Jump") then
		d(Player:Jump())			
	elseif ( arg == "Dev.FaceT") then
		local t = Player:GetTarget()
		if ( t ) then
			local pos = t.pos
			d(Player:SetFacing(pos.x,pos.y,pos.z))
		end
	elseif ( arg == "Dev.FaceET") then
		local t = Player:GetTarget()
		if ( t ) then
			local pos = t.pos
			d(Player:SetFacingExact(pos.x,pos.y,pos.z))
		end	
	elseif ( arg == "Dev.playerPosition") then
			local p = Player.pos
			tb_xPos = tostring(p.x)
			tb_yPos = tostring(p.y)
			tb_zPos = tostring(p.z)
			d(p)
	elseif ( arg == "Dev.naviTo" and tonumber(tb_xPos)~=nil) then		
		local navsystem
		local navpath
		local smoothturns
		if ( Nnavitype == "Normal") then 
			navsystem = false 
		else 
			navsystem = true --FollowNavSystem
		end
		if ( Nmovetype == "Straight") then 
			navpath = false 
		else 
			navpath = true --Random
		end
		if ( Nsmooth == "0") then 
			smoothturns = false 
		else 
			smoothturns = true
		end
		
		tb_nRes = tostring(Player:MoveTo(tonumber(tb_xPos),tonumber(tb_yPos),tonumber(tb_zPos),25,navsystem,navpath,smoothturns))
	elseif ( arg == "Dev.ranPT") then
		local ppos = Player.pos
		if ( tonumber(tb_min) and tonumber(tb_max) ) then 
			local p = NavigationManager:GetRandomPointOnCircle(ppos.x,ppos.y,ppos.z,tonumber(tb_min),tonumber(tb_max))
			if ( p) then
				tb_xPos = tostring(p.x)
				tb_yPos = tostring(p.y)
				tb_zPos = tostring(p.z)				
				tb_xdist = Distance3D(p.x,p.y,p.z,ppos.x,ppos.y,ppos.z)
			end
		end

	elseif ( arg == "Dev.AddOB" and Player.onmesh) then
		local pPos = Player.pos
		if ( pPos ) then
			table.insert(Dev.Obstacles, { x=pPos.x, y=pPos.y, z=pPos.z, r=tonumber(obsSize) })
			d("Adding new Obstacle with size "..tostring(obsSize))
			NavigationManager:AddNavObstacles(Dev.Obstacles)
		end
	elseif ( arg == "Dev.ClearOB" ) then
		local pPos = Player.pos
		if ( pPos ) then
			Dev.Obstacles = {}
			d("Clearing Obstacles ")
			NavigationManager:ClearNavObstacles()
		end
	elseif ( arg == "Dev.AddAA" and Player.onmesh) then
		local pPos = Player.pos
		if ( pPos ) then
			table.insert(Dev.AvoidanceAreas, { x=pPos.x, y=pPos.y, z=pPos.z, r=tonumber(avoidSize) })
			d("adding AvoidanceArea with size "..tostring(avoidSize))
			NavigationManager:SetAvoidanceAreas(Dev.AvoidanceAreas)
		end
	elseif ( arg == "Dev.ClearAA" ) then
		local pPos = Player.pos
		if ( pPos ) then
			Dev.AvoidanceAreas = {}
			d("Clearing AvoidanceAreas ")
			NavigationManager:ClearAvoidanceAreas()
		end			
	end
end
			
function Dev.UpdateWindow()
	-- CharacterInfo --
	local mytarget
	if ( chartarg == "Player" ) then
		mytarget = Player
	else
		mytarget = Player:GetTarget()
	end
	-- get the nearest Gadget if none is selected
	
	if ( mytarget == nil ) then
		mytarget = GadgetList("nearest")
		if ( mytarget) then
			_,mytarget = next(mytarget)
		end
	end
	
	if (mytarget ~= nil) then
		if ( mytarget.isCharacter ) then
			TargetPtr = string.format( "%x",tonumber(mytarget.ptr ))
			TargetPtr2 = string.format( "%x",tonumber(mytarget.ptr2 ))
			TID = mytarget.id
			TCID = mytarget.contentID
			TType = "Character"
			TName = tostring(mytarget.name)
			--TSName = tostring(mytarget.specname)
			THP = tostring(mytarget.health.current.." / "..mytarget.health.max.." / "..mytarget.health.percent.."%")
			TPos = (math.floor(mytarget.pos.x * 10) / 10).." / "..(math.floor(mytarget.pos.y * 10) / 10).." / "..(math.floor(mytarget.pos.z * 10) / 10)
			THead = (math.floor(mytarget.pos.hx * 10) / 10).." / "..(math.floor(mytarget.pos.hy * 10) / 10).." / "..(math.floor(mytarget.pos.hz * 10) / 10)
			THRad = tostring(mytarget.height.." / "..mytarget.radius)
			TMoveState = mytarget.movementstate
			TSpeed = tostring(mytarget.speed)
			TLOS = tostring(mytarget.los)
			TOnMesh = tostring(mytarget.onmesh)
			TOnMeshEx = tostring(mytarget.onmeshexact)
			TDist = (math.floor(mytarget.distance * 10) / 10)
			TPDist = (math.floor(mytarget.pathdistance * 10) / 10)
			TProf = mytarget.profession
			TIsInInteractR = tostring(mytarget.isInInteractRange)
			TInteractable = tostring(mytarget.interactable)
			TSele = tostring(mytarget.selectable)
			TAtta = tostring(mytarget.attackable)
			TLootable = tostring(mytarget.lootable)
			TLvl = mytarget.level.." / "..mytarget.effectiveLevel
			THasPet = tostring(mytarget.hasPet)
			TAlive = tostring(mytarget.alive)
			TDown = tostring(mytarget.downed)
			TDead = tostring(mytarget.dead)
			TAttit = tostring(mytarget.attitude)
			TAggro = tostring(mytarget.isAggro)
			TAggroPercent = mytarget.aggropercent
			TInCombat = tostring(mytarget.inCombat)
			local castinfo = mytarget.castinfo
			if ( TableSize(castinfo) > 0 ) then
				TAttPrr = castinfo.ptr
				TAttID = castinfo.targetID
				TAttSPID = castinfo.skillID
				TAttLSPID = castinfo.lastSkillID
				TAttSlot = castinfo.slot
				TAttSDur = castinfo.duration
			else
				TAttPrr = 0
				TAttID = 0
				TAttSPID = 0
				TAttLSPID = 0
				TAttSlot = 0
				TAttSDur = 0
			end
			TIsControlled = tostring(mytarget.isControlled)
			TIsPlayer = tostring(mytarget.isPlayer)
			TIsPet = tostring(mytarget.isPet)
			TIsMonster = tostring(mytarget.isMonster)
			TIsClone = tostring(mytarget.isClone)
			TIsCrit = tostring(mytarget.isCritter)
			TIsEventNPC = tostring(mytarget.isEventNPC)
			TIsInWater = tostring(mytarget.swimming ~= 0)
			TIsDiving = tostring(mytarget.swimming == 1)
			TIsSwimming = tostring(mytarget.swimming == 2)
			TIsChamp = tostring(mytarget.isChampion)
			TIsVet = tostring(mytarget.isVeteran)
			TIsLegend = tostring(mytarget.isLegendary)
			TIsElite = tostring(mytarget.isElite)
			TIsUnknown0 = tostring(mytarget.isUnknown0)
			TisGathering = tostring(mytarget.isGathering)
			TIsUnknown2 = tostring(mytarget.isUnknown2)
			TIsUnknown3 = tostring(mytarget.isUnknown3)
			TIsUnknown4 = tostring(mytarget.isUnknown4)
			TIsUnknown5 = tostring(mytarget.isUnknown5)
			TIsUnknown6 = tostring(mytarget.isUnknown6)	--true for some merchants
			TIsUnknown7 = tostring(mytarget.isUnknown7)
			TIsUnknown8 = tostring(mytarget.isUnknown8)	-- true when doing nothing/no script runs I think
			TIsUnknown9 = tostring(mytarget.isUnknown9) -- lotsa friendly true
			TIsUnknown10 = tostring(mytarget.isUnknown10)
			TIsUnknown11 = tostring(mytarget.isUnknown11)	--true when interactable/gotquest
			TIsUnknown12 = tostring(mytarget.isUnknown12)
			TIsUnknown13 = tostring(mytarget.isHeartQuestGiver)

		end
		-- gadget
		
		if ( mytarget.isGadget ) then
			GTargetPtr = string.format( "%x",tonumber(mytarget.ptr ))
			GTID = mytarget.id
			GTCID = mytarget.contentID
			GTCID2 = mytarget.contentID2
			GTType = mytarget.type
			GTType2 = mytarget.type2
			GTName = tostring(mytarget.name)
			if (mytarget.health) then
				GTHP = tostring(mytarget.health.current.." / "..mytarget.health.max.." / "..mytarget.health.percent.."%")
			else
				GTHP = 0
			end
			GTPos = (math.floor(mytarget.pos.x * 10) / 10).." / "..(math.floor(mytarget.pos.y * 10) / 10).." / "..(math.floor(mytarget.pos.z * 10) / 10)
			GTHead = (math.floor(mytarget.pos.hx * 10) / 10).." / "..(math.floor(mytarget.pos.hy * 10) / 10).." / "..(math.floor(mytarget.pos.hz * 10) / 10)
			GTHRad = tostring(mytarget.height.." / "..mytarget.radius)			
			GTLOS = tostring(mytarget.los)
			GTOnMesh = tostring(mytarget.onmesh)
			GTDist = (math.floor(mytarget.distance * 10) / 10)
			GTPDist = (math.floor(mytarget.pathdistance * 10) / 10)
			GTIsInInteractR = tostring(mytarget.isInInteractRange)
			GTInteractable = tostring(mytarget.interactable)
			GTSelec = tostring(mytarget.selectable)
			GTLootable = tostring(mytarget.lootable)
			GTAttit = tostring(mytarget.attitude)
			GTRessType = mytarget.resourceType
			GTSelectable = tostring(mytarget.isselectable)
			GTAttack = tostring(mytarget.attackable)
			GTAlive = tostring(mytarget.alive)
			GTDead = tostring(mytarget.dead)
			GTIsCombat = tostring(mytarget.iscombatant)
			GTIsGather = tostring(mytarget.gatherable)
			GTHasHP = tostring(mytarget.hashpbar)
			GTIsOurs = tostring(mytarget.isours)
			GTIsUnknown0 = tostring(mytarget.isUnknown0)
			GTIsUnknown1 = tostring(mytarget.isUnknown1)
			GTIsUnknown2 = tostring(mytarget.isUnknown2)
			GTIsUnknown3 = tostring(mytarget.isUnknown3)
			GTIsUnknown4 = tostring(mytarget.isUnknown4)
			GTIsUnknown5 = tostring(mytarget.isUnknown5)
			GTIsUnknown6 = tostring(mytarget.isUnknown6)	
			GTIsUnknown7 = tostring(mytarget.isUnknown7)
			GTIsUnknown8 = tostring(mytarget.isUnknown8)	
			GTIsUnknown9 = tostring(mytarget.isTurret) 
			GTIsUnknown10 = tostring(mytarget.isUnknown10)
			GTIsUnknown11 = tostring(mytarget.isUnknown11)	
			GTIsUnknown12 = tostring(mytarget.isUnknown12)
			GTIsUnknown13 = tostring(mytarget.isUnknown13)
		end
				
		--emptyfields
	else
		TType = "NONE"
		GTType = "NONE"
	end	
	
	-- Buffinfo	
	local blist
	local binfo
	if ( bufftarg == "Player" ) then
		blist = Player.buffs
	else
		local t = Player:GetTarget()
		if ( t ) then
			blist = t.buffs
		end
	end	
	if ( blist ) then
		local count = 0
		local i,b = next (blist)
		while i and b do
			if ( count == tonumber(buffSlot)) then
				binfo = b
				break
			end
			count = count + 1
			i,b = next (blist,i)
		end		
	end
	
	if (binfo) then
		BPtr = string.format( "%x",tonumber(binfo.ptr ))
		BIID = binfo.buffID
		BICID = binfo.contentID
		BIName = binfo.name
		BIStack = binfo.stacks
		BIFlag = binfo.flags
	else
		BPtr = 0
		BIID = 0
		BICID = 0
		BIName = 0
		BIStack = 0
		BIFlag =0
	end
	
	
	
	-- Inventory		
	local myinv = Inventory("")
	local myitem
	if ( myinv and iSource == "Inventory") then
		myitem = myinv[tonumber(invSlot)]
	elseif ( iSource == "Equipped") then
		myitem = Inventory:GetEquippedItemBySlot(tonumber(invSlot))
	end	
	if ( myitem ) then
		ICount = Inventory.count
		ISlots = Inventory.slotCount
		IFree = Inventory.freeSlotCount
		IMoney = tostring(Inventory:GetInventoryMoney())
		IPtr = string.format( "%x",tonumber(myitem.ptr ))
		IID = myitem.itemID
		IName = myitem.name
		IRar = myitem.rarity
		IType = myitem.itemtype
		IWeap = myitem.weapontype
		IDur = myitem.durability
		ILoc = myitem.location
		IStack = myitem.stackcount
		ISould = tostring(myitem.soulbound)
		IAccbou = tostring(myitem.accountbound)
		IRSoul = tostring(myitem.reqsoulbind)
		ISalv = tostring(myitem.salvagable)
	else
		ICount = Inventory.count
		ISlots = Inventory.slotCount
		IFree = Inventory.freeSlotCount
		IMoney = tostring(Inventory:GetInventoryMoney())
		IPtr = 0
		IID = 0
		IName = 0
		IRar = 0
		IType = 0
		IWeap = 0
		IDur = 0
		ILoc = 0
		IStack = 0
		ISould = 0
		IAccbou = 0
		IRSoul = 0
		ISalv = 0
	end
	
	--Vendorinfo
	local vitem = VendorItemList:Get(tonumber(vendSlot))
	VOpen = tostring(Inventory:IsVendorOpened())
	if ( vitem ) then
		VPtr = string.format( "%x",tonumber(vitem.ptr ))
		VID = vitem.itemID
		VName = vitem.name
		Vrar = vitem.rarity
		VPrice = vitem.price
		VQuant = vitem.quantity
		VType = vitem.itemtype
		VWType = vitem.weapontype
		
	else
		VPtr = 0
		VID = 0
		VName = 0
		Vrar = 0
		VPrice = 0
		VQuant = 0
		VType = 0
		VWType = 0
	end
	
	-- MarkerInfo
	local id,mm
	if ( mmselection == "Closest" ) then
		local MM = MapMarkerList("nearest")
		id,mm = next(MM)
	else
		mm = MapMarkerList:Get(tonumber(mmindex))
		id = tonumber(mmindex)
	end
	if ( mm ) then
		MPtr = string.format( "%x",tonumber(mm.ptr ))
		MDefPtr = string.format( "%x",tonumber(mm.ptr2 ))
		MID = id
		MName = mm.name
		MType = mm.type
		MMType = mm.markertype
		MWMType = mm.worldmarkertype
		MEventID = mm.eventID
		MCharID = mm.characterID
		McontentID = mm.contentID
		MSubRID = mm.subregionID
		MPos = (math.floor(mm.pos.x * 10) / 10).." / "..(math.floor(mm.pos.y * 10) / 10).." / "..(math.floor(mm.pos.z * 10) / 10)		
		MOnMesh = tostring(mm.onmesh)
		MDist = mm.distance
		MPDist = mm.pathdistance
		MIChar = tostring(mm.isCharacter)
		MIEvent = tostring(mm.isevent)
		MIFC = tostring(mm.isFloorChanger)
		MIWP = tostring(mm.isWorldPortal)
		MIWayP = tostring(mm.isWaypoint)
		MISR = tostring(mm.isSubregion)
		MIVist = tostring(mm.isVista)
		MIUWay = tostring(mm.isUserWaypoint)
		MIsUnknown0 = tostring(mm.isUnknown0)
		MIsUnknown1 = tostring(mm.isUnknown1)
		MIsUnknown2 = tostring(mm.isUnknown2)
		MRegionDefPtr = tostring(mm.regiondef)
		MRegionName = mm.regionname
		MIsUnknown4 = tostring(mm.isUnknown4)
		MIsUnknown5 = tostring(mm.isUnknown5)
		MIsUnknown6 = tostring(mm.isUnknown6)	
		MIsUnknown7 = tostring(mm.isUnknown7)
		MIsUnknown8 = tostring(mm.isUnknown8)
		MIsUnknown9 = tostring(mm.isUnknown9) 
		MIsUnknown10 = tostring(mm.isUnknown10)
		MIsUnknown11 = tostring(mm.isUnknown11)
		MIsUnknown12 = tostring(mm.isUnknown12)		
		MIsUnknown13 = tostring(mm.isUnknown13)
		MIsUnknown14 = tostring(mm.isUnknown14)
		MisCommander = tostring(mm.isCommander)
	else
		MPtr = 0
		MDefPtr = 0
		MID = 0
		MType = 0
		MMType = 0
		MWMType = 0
		MEventID = 0
		MCharID = 0
		McontentID = 0
		MSubRID = 0
		MPos = 0		
		MOnMesh = 0
		MDist = 0
		MPDist = 0
		MIChar = 0
		MIEvent = 0
		MIFC = 0
		MIWP = 0
		MIWayP = 0
		MISR = 0
		MIVist = 0
		MIUWay = 0
		MIsUnknown0 = 0
		MIsUnknown1 = 0
		MIsUnknown2 = 0
		MRegionDefPtr = 0
		MRegionName = ""
		MIsUnknown4 = 0
		MIsUnknown5 = 0
		MIsUnknown6 = 0	
		MIsUnknown7 = 0
		MIsUnknown8 = 0
		MIsUnknown9 = 0 
		MIsUnknown10 = 0
		MIsUnknown11 = 0
		MIsUnknown12 = 0		
		MIsUnknown13 = 0
		MIsUnknown14 = 0
		MisCommander = 0
	end 
	
	-- EventInfo
	local id,ev
	if ( evselection == "Closest" ) then
		id,ev = next(MapMarkerList("nearest,isevent"))		
	else
		local mml = MapMarkerList("isevent")
		local count = 0
		if ( mml and tonumber(evindex)~=nil) then
			id,ev = next(mml)
			while ( id and ev ) do
				if (count == tonumber(evindex)) then
					break
				end
				count = count + 1
				id,ev = next(mml,id)
			end
		end
	end
	if ( ev ) then
		EVPtr = string.format( "%x",tonumber(ev.ptr ))		
		EVType = ev.type
		EVMType = ev.markertype
		EVWMType = ev.worldmarkertype		
		EVEventID = ev.eventID
		EVQuestID = ev.contentID
		EVCharID = ev.characterID
		EVSubRID = ev.subregionID
		EVPos = (math.floor(ev.pos.x * 10) / 10).." / "..(math.floor(ev.pos.y * 10) / 10).." / "..(math.floor(ev.pos.z * 10) / 10)		
		EVOnMesh = tostring(ev.onmesh)
		EVDist = ev.distance
		EVPDist = ev.pathdistance
		local evi = ev.eventinfo
		if ( evi ) then
			EVEPtr = string.format( "%x",tonumber(evi.ptr ))
			EVName = evi.name
			EVOC = evi.objectivecount
			EVLvl = evi.level
			EVIR = evi.inrange
			EVIDE = evi.isdungeonevent
			EVIsUnknown0 = tostring(evi.A)
			EVIsUnknown1 = tostring(evi.B)
			EVIsUnknown2 = tostring(evi.C)
			EVIsUnknown3 = tostring(evi.D)
			EVIsUnknown4 = tostring(evi.E)
			EVIsUnknown5 = tostring(evi.F)
			EVIsUnknown6 = tostring(evi.G)
		else
			EVEPtr = 0
			EVName = 0
			EVOC = 0
			EVLvl = 0
			EVIR = 0
			EVIDE = 0
			EVIsUnknown0 = 0
			EVIsUnknown1 = 0
			EVIsUnknown2 = 0
			EVIsUnknown3 = 0
			EVIsUnknown4 = 0
			EVIsUnknown5 = 0
			EVIsUnknown6 = 0
		end
		local evo = ev.eventobjectivelist
		local oid,ob
		if ( evo ) then			
			local count = 0
			if ( evo and tonumber(evoindex)~=nil) then
				oid,ob = next(evo)
				while ( oid and ob ) do
					if (count == tonumber(evoindex)) then
						break
					end
					count = count + 1
					oid,ob = next(evo,oid)
				end
			end
			if ( ob ) then
				EVOPtr = string.format( "%x",tonumber(ob.ptr ))
				EVOID = ob.id
				EVOIsUnknown0 = ob.isUnknown0
				local ot = ob.type
				if ( ot == 0  ) then EVOType = "0-BreakMoral" end
				if ( ot == 1  ) then EVOType = "1-CaptureLcoation" end
				if ( ot == 2  ) then EVOType = "2-CollectItems" end
				if ( ot == 3  ) then EVOType = "3-Counter" end
				if ( ot == 4  ) then EVOType = "4-KillCount" end
				if ( ot == 5  ) then EVOType = "5-Cull" end
				if ( ot == 8  ) then EVOType = "8-DefendGadget" end
				if ( ot == 10 ) then EVOType = "10-Escort" end
				if ( ot == 11 ) then EVOType = "11-EventStatus" end
				if ( ot == 12 ) then EVOType = "12-InteractWithGadget" end
				if ( ot == 13 ) then EVOType = "13-Intimidate" end
				if ( ot == 14 ) then EVOType = "14-IntimidateScaled" end
				if ( ot == 17 ) then EVOType = "17-RepairGadget" end
				if ( ot == 18 ) then EVOType = "18-Timer" end
				if ( ot == 19 ) then EVOType = "19-Tripwire" end
				if ( ot == 20 ) then EVOType = "20-WvwHold" end
				if ( ot == 21 ) then EVOType = "21-WvwOrbResetTimer" end
				if ( ot == 22 ) then EVOType = "22-WvwUpgrade" end
				
				EVO1 = ob.value1
				EVO2 = ob.value2
				EVO3 = ob.value3
				EVO4 = ob.value4
				EVO5 = ob.value5
			else
				EVOPtr = 0
				EVOID = 0
				EVOIsUnknown0 = 0
				EVOType = 0
				EVO1 = 0
				EVO2 = 0
				EVO3 = 0
				EVO4 = 0
				EVO5 = 0
			end
		else		
			EVOPtr = 0
			EVOID = 0
			EVOIsUnknown0 = 0
			EVOType = 0
			EVO1 = 0
			EVO2 = 0
			EVO3 = 0
			EVO4 = 0
			EVO5 = 0
		end		
	else
		EVEPtr = 0
		EVPtr = 0
		EVType = 0
		EVMType = 0
		EVWMType = 0		
		EVEventID = 0
		EVCharID = 0
		EVQuestID = 0
		EVSubRID = 0
		EVPos = 0
		EVOnMesh = 0
		EVDist = 0
		EVPDist = 0
		EVOC = 0
		EVLvl = 0
		EVIR = 0
		EVIDE = 0
		EVIsUnknown0 = 0
		EVIsUnknown1 = 0
		EVIsUnknown2 = 0
		EVIsUnknown3 = 0
		EVIsUnknown4 = 0
		EVIsUnknown5 = 0
		EVIsUnknown6 = 0
	end
	
	-- WaypointInfo
	local id,wp
	if ( wpselection == "Closest" ) then
		id,wp = next(WaypointList("nearest"))		
	else
		local wpl = WaypointList("")
		local count = 0
		if ( wpl and tonumber(wpindex)~=nil) then
			id,wp = next(wpl)
			while ( id and wp ) do
				if (count == tonumber(wpindex)) then
					break
				end
				count = count + 1
				id,wp = next(wpl,id)
			end
		end
	end
	if ( wp ) then
		WPPtr = string.format( "%x",tonumber(wp.ptr ))		
		WPID = wp.id
		WPName = wp.name
		if ( wp.samezone ) then
			WPDist = wp.distance
		else
			WPDist = "Is Outside this Zone"
		end
		WPPos = (math.floor(wp.pos.x * 10) / 10).." / "..(math.floor(wp.pos.y * 10) / 10).." / "..(math.floor(wp.pos.z * 10) / 10)		
		WPOnMesh = tostring(wp.onmesh)
		WPCont = tostring(wp.contested)
		WPSameZ = tostring(wp.samezone)
	else
		WPPtr = 0		
		WPID = 0
		WPName = 0
		WPDist = 0
		WPPos = 0
		WPOnMesh = 0
		WPCont = 0
		WPSameZ = 0
	end
	
	-- MovementInfo
	micanmove = tostring(Player:CanMove())
	mimov = tostring(Player:IsMoving())
	mistate = Player:GetMovementState()
	local movdirs = Player:GetMovement()
	local movstr = ""
	if (movdirs.forward) then movstr = "forward" end
	if (movdirs.left) then movstr = movstr.." left" end
	if (movdirs.right) then movstr = movstr.." right" end
	if (movdirs.backward) then movstr = movstr.." backward" end
	midirect = movstr
	micanevdir = tostring(Player:CanEvade(tonumber(mievdir),100))	
	local facedir = Player:IsFacingTarget()
	if ( facedir == 1 ) then
		mifacet = "InFront"
	elseif( facedir == 2) then
		mifacet = "Flanking"
	elseif( facedir == 3) then
		mifacet = "Behind"
	elseif( facedir == false) then
		mifacet = "Not Facing"
	end
	
	-- Spell&CastingInfo
	SCIsCast = tostring(Player:IsCasting())
	SCCanC = tostring(Player:CanCast())
	SCPend = tostring(Player:IsSkillPending())
	SCCurCast = Player:GetCurrentlyCastedSpell()
	SCCanSwap = tostring(Player:CanSwapWeaponSet())
	local spell = Player:GetSpellInfo(tonumber(SCindex))
	if (spell) then
		SCPtr = string.format( "%x",tonumber(spell.ptr ))
		SCSlot = spell.slot
		SCID = spell.skillID
		SCName = spell.name
		SCCD = spell.cooldown
		SCCDM = spell.cooldownmax
		SCMinR = spell.minRange
		SCMaxR = spell.maxRange
		SCRad = spell.radius
		SCType = spell.skillType
		SCGT = tostring(spell.isGroundTargeted)
	else
		SCPtr = 0
		SCSlot = 0
		SCID = 0
		SCName = 0
		SCCD = 0
		SCCDM = 0
		SCMinR = 0
		SCMaxR = 0
		SCRad = 0
		SCType = 0
		SCGT = 0
	end
	
	-- Hacks
	HackSPC = Player:GetSpeed()	
	HackGrav = Player:GetGravity()
	HackCL = Player:GetCrawlHeight()
	if ( tonumber(HackSPC) ~=nil and HackSPCS == "" ) then HackSPCS = HackSPC end		
	if ( tonumber(HackGrav)~=nil and HackGravS == "" ) then HackGravS = HackGrav end
	if ( tonumber(HackCL)~=nil and HackSCL == "") then HackSCL = HackCL end
	
	-- ConversationInfo	
	ConOpen = tostring(Player:IsConversationOpen())
	local i,c
	local convOptions = Player:GetConversationOptions()
	if ( convOptions ) then
		i,c = next (convOptions)
		local count = 0
		while ( i and c ) do
			if (count == tonumber(convindex)) then
				break
			end
			count = count + 1
			i,c = next(convOptions,i)
		end	
	end
	if ( c ) then
		COPtr = string.format( "%x",tonumber(c.ptr ))
		COIdx = c.index
		COID = c.id
		COType = c.type		
	else
		COPtr = 0
		COIdx = 0
		COID = 0
		COType = 0	
	end
	
	--PartyInfo
	PartySiz = Player:GetPartySize()
	local party = Player:GetParty()	
	local p,i
	if ( party ) then
		local count = 0
		i,p = next(party)
		while i and p do
			if ( count == tonumber(partyindex) ) then
				break
			end
			count = count + 1
			i,p = next(party,i)
		end
	end	
	if ( p ) then		
		ParPtr = string.format( "%x",tonumber(p.ptr ))
		ParIdx = p.index
		ParName = p.name
		ParMap = p.mapid
		ParCon = p.connectstatus
		ParInv = p.invitestatus
		ParPar = tostring(p.hasparty)
		ParDOw = p.instanceopen
		ParProf = p.profession
		ParLvl = p.level
		ParHSI = p.homeserverid
		ParCSI = p.currentserverid
		ParISI = p.instanceserverid		
		ParUnk = p.isUnknown0
		ParUnk1 = p.isUnknown1		
		ParID = p.id
	else
		ParPtr = 0
		ParIdx = 0
		ParName = 0
		ParMap = 0
		ParCon = 0
		ParInv = 0
		ParPar = 0
		ParDOw = 0
		ParProf = 0
		ParLvl = 0
		ParHSI = 0
		ParCSI = 0
		ParISI = 0
		ParUnk = 0
		ParUnk1	= 0
		ParID = 0
	end
	
	
	--PetInfo
	PetCanSwitch = tostring(Player:CanSwitchPet())
	if ( Player:GetPet() ~=nil) then
		PetHas = tostring(true)		
	else
		PetHas = tostring(false)
	end
	
	--DungeonInfo
	DunDS = tostring(Player:IsInstanceDialogShown())
	DunClaim = tostring(Player:CanClaimReward())
	local dInfo = Player:GetInstanceInfo()
	if (dInfo) then
		DunISReg = tostring(dInfo.isInstanceRegistered)
		DunEID = dInfo.instanceEntryID
		DunModeID = dInfo.instanceModeID
		DunModeID2 = dInfo.instanceMode2ID
		DunInsID = dInfo.instanceID
		DunUnk0 = tostring(dInfo.isUnknown0)
		DunUnk1 = tostring(dInfo.isUnknown1)
		DunIsCompl = tostring(dInfo.isUnknown2)
		DunIsCompl2 = tostring(dInfo.isUnknown3)
		DunUnk4 = tostring(dInfo.isUnknown4)
		DunUnk5 = tostring(dInfo.isUnknown5)
		DunUnk6 = tostring(dInfo.isUnknown6)		
	else
		DunISReg = 0
		DunEID = 0
		DunModeID = 0
		DunModeID2 = 0
		DunInsID = 0
		DunUnk0 = 0
		DunUnk1 = 0
		DunIsCompl = 0
		DunIsCompl2 = 0
		DunUnk4 = 0
		DunUnk5 = 0
		DunUnk6 = 0
	end
	
	
	-- QuestManager
	local qm = QuestManager:GetActiveQuest()
	if ( TableSize(qm) > 0 ) then
		qmstoryname = qm.storyname
		qmstoryid = qm.storyid
		qmquestname = qm.questname
		qmquestid = qm.questid
		qmquestcomplete = tostring(qm.isquestcomplete)
		qmgoalname = qm.questgoalname
		qmqgoalid = qm.questgoalid
		qmsmax = qm.stepmax
		qmscurr = qm.stepcurrent
		qmsname = qm.stepname
		qmsu1 = tostring(qm.stepU1)
		qmsu2 = tostring(qm.stepU2)
		qmsu3 = tostring(qm.stepU3)
		qmsu4 = tostring(qm.stepU4)
		qmsu5 = tostring(qm.stepU5)
		qmrewardcount = qm.questrewardcount				
		
	else
		qmstoryname = ""
		qmstoryid = 0
		qmquestname = ""
		qmquestid = 0
		qmquestcomplete = false
		qmgoalname = ""
		qmqgoalid = 0
		qmsmax = 0
		qmscurr = 0
		qmsname = ""
		qmsu1 = 0
		qmsu1 = 0
		qmsu1 = 0
		qmsu1 = 0
		qmsu1 = 0
		qmrewardcount = 0
	
	end
	local qmr = QuestManager:GetActiveQuestRewardList()
	local reward = nil
	if ( TableSize(qmr) > 0 )then
		local count = 1
		local iid
		iid, reward = next (qmr)
		while (iid ~= nil and reward ~= nil) do			
			if ( count == tonumber(qmrewardsel) ) then
				break
			end
			count = count + 1
			iid,reward = next (qmr,iid)
		end		
	end
	if ( reward ) then
		qmrewardiname = reward.name
		qmrewardiid = reward.itemID
		qmrewardicount = reward.count
		qmrewardiunk1 = reward.Unknown2
		qmrewardiselect = tostring(reward.selectable)
	else
		qmrewardiname = ""
		qmrewardiid = 0
		qmrewardicount = 0
		qmrewardiunk1 = 0
		qmrewardiselect = false
	end
	
	
	-- PlayerInfo
	myplayer = Player
	if (myplayer ~= nil) then
		PIUnk1 = 0
		PIUnk2 = 0
		PlPower = Player.power		
		PlKarma = Player.karma
		PlEndura = Player.endurance
		TXp = tostring(myplayer.XPTotal)
		TXpNL = tostring(myplayer.XPNextLevel)
		TXpTNL = tostring(myplayer.XPToNextLevel)
		TXpC = tostring(myplayer.XPCurrent)
	end
	
	-- GeneralInfo
	local mousepos = MeshManager:GetMousePos()
	GMPos = tostring(mousepos.x).." / "..tostring(mousepos.y).." / "..tostring(mousepos.z)
	GIMapID = Player:GetLocalMapID()
	GILang = tostring(Player:GetLanguage())
end

function Dev.OnUpdateHandler( Event, ticks ) 	
	if ( ticks - Dev.lastticks > 500 ) then
		Dev.lastticks = ticks		
		if ( Dev.running ) then
			Dev.UpdateWindow()
			
			if (Dev.curTask) then
				Dev.curTask()
			end
		end
	end
end


RegisterEventHandler("Module.Initalize",Dev.ModuleInit)
RegisterEventHandler("Gameloop.Update", Dev.OnUpdateHandler)
RegisterEventHandler("GUI.Update",Dev.GUIVarUpdate)