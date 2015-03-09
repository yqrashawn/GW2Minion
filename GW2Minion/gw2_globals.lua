ml_global_information = { }
ml_global_information.Path = GetStartupPath()
ml_global_information.Now = 0
ml_global_information.Lasttick = 0
ml_global_information.Running = false
ml_global_information.BotModes = {}
ml_global_information.LastGameState = 0
ml_global_information.ShowDebug = false
ml_global_information.idlePulseCount = 0
ml_global_information.WorldMarkerType = 24 -- enum for "in current map", changes on larger patches sometimes
ml_global_information.MarkerMinLevel = 1
ml_global_information.MarkerMaxLevel = 50
ml_global_information.MarkerTime = 0

-- Global vars which are used very often and we can just reduce the hammering by getting them once per frame here
function ml_global_information.OnUpdate()
	
	if ( Player ~= nil ) then
				
		ml_global_information.Player_Name = Player.name or ""
		ml_global_information.Player_Health = Player.health or { current = 0, max = 0, percent = 0 }
		ml_global_information.Player_Profession = Player.profession or 0
		ml_global_information.Player_ProfessionName = table_invert(GW2.CHARCLASS)[ml_global_information.Player_Profession] or "NoClass"
		ml_global_information.Player_Power = Player.power or 0
		ml_global_information.Player_Endurance = Player.endurance or 0		
		ml_global_information.Player_InCombat = Player.inCombat or false		
		ml_global_information.Player_Position = Player.pos
		ml_global_information.Player_Level = Player.level
		ml_global_information.Player_OnMesh = Player.onmesh or false
		ml_global_information.Player_Alive = Player.alive or false
		ml_global_information.Player_IsMoving = Player:IsMoving() or false
		ml_global_information.Player_CanMove = Player:CanMove() or false
		ml_global_information.Player_MovementDirections = Player:GetMovement() or { forward=false, backward=false, left=false, right=false }
		ml_global_information.Player_Inventory_SlotsFree = Inventory.freeSlotCount or 0
		ml_global_information.Player_SwimState = Player.swimming or 0
		ml_global_information.Player_MovementState = Player:GetMovementState() or 1
		ml_global_information.Player_Target = Player:GetTarget() or {}
		
		ml_global_information.Player_Party = Player:GetParty() or nil
		
		ml_global_information.CurrentMapID = Player:GetLocalMapID() or 0
		if ( gw2_datamanager and ml_global_information.CurrentMapID ~= 0) then  
			ml_global_information.CurrentMapName = gw2_datamanager.GetMapName( ml_global_information.CurrentMapID ) 
		else
			ml_global_information.CurrentMapName = ""
		end
		
		ml_global_information.AttackRange = gw2_skill_manager.GetMaxAttackRange()
		
		-- Update Debug fields
		if ( ml_global_information.ShowDebug ) then		
			dAttackRange = ml_global_information.AttackRange or 154
			
		end
	end
end

-- Resets the bot task & data
function ml_global_information.Reset()
    ml_task_hub:ClearQueues()
	if (gBotMode ~= nil) then
		local mode = ml_global_information.BotModes[gBotMode]
		if (mode ~= nil) then
			local newtask = mode.Create()
			ml_task_hub:Add(newtask, LONG_TERM_GOAL, TP_ASAP)
			return true
		end
    end
	return false
end

-- Stops the Bot
function ml_global_information.Stop()
    Player:StopMovement()
	c_movetorandom.randompoint = nil
	c_movetorandom.randompointreached = false
	ml_mesh_mgr.ResetOMC()
	ml_mesh_mgr.OMCStartPositionReached = false
	gw2_unstuck.Reset()
end

-- Waits xxx seconds before running the next pulse
function ml_global_information.Wait( mseconds )
	ml_global_information.Lasttick = ml_global_information.Lasttick + mseconds
	
end



ml_global_information.ConditionsEnum = {
		[736] = "Bleeding",
		[720] = "Blind",
		[737] = "Burning",
		[722] = "Chilled",
		[861] = "Confusion",
		[721] = "Crippled",
		[791] = "Fear",
		[727] = "Immobilized",
		[738] = "Vulnerability",
		[742] = "Weakness",
		[723] = "Poison",
		[890] = "Revealed", --you cannot stealth
		[872] = "Stun",
	};
	
ml_global_information.BoonsEnum = {
		[743] = "Aegis",
		[725] = "Fury",
		[740] = "Might",
		[717] = "Protection",
		[718] = "Regeneration",
		[873] = "Retaliation",
		[1122] = "Stability",
		[719] = "Swiftness",
		[726] = "Vigor",
		[762] = "Determined",
		[5979] = "Heal Turret Toggle",
		[5891] = "Thumper Toggle",
	};

ml_global_information.ServersUS = {		
	{id=1010,name="Ehmry Bay"},
	{id=1018,name="Northern Shiverpeaks"},
	{id=1002,name="Borlis Pass"},
	{id=1008,name="Jade Quarry"},
	{id=1005,name="Maguuma"},
	{id=1015,name="Isle of Janthir"},
	{id=1009,name="Fort Aspenwood"},
	{id=1013,name="Sanctum of Rall"},
	{id=1007,name="Gate of Madness"},
	{id=1006,name="Sorrow's Furnace"},
	{id=1019,name="Blackgate"},
	{id=1021,name="Dragonbrand"},
	{id=1012,name="Darkhaven"},
	{id=1003,name="Yak's Bend"},
	{id=1014,name="Crystal Desert"},
	{id=1001,name="Anvil Rock"},
	{id=1011,name="Stormbluff Isle"},
	{id=1020,name="Ferguson's Crossing"},
	{id=1016,name="Sea of Sorrows"},
	{id=1022,name="Kaineng"},
	{id=1023,name="Devona's Rest"},
	{id=1017,name="Tarnished Coast"},
	{id=1024,name="Eredon Terrace"},
	{id=1004,name="Henge of Denravi"}
	}	
ml_global_information.ServersEU = {
	{id=2012,name="Piken Square"},
	{id=2003,name="Gandara"},
	{id=2007,name="Far Shiverpeaks"},
	{id=2204,name="Abaddon's Mouth [DE]"},
	{id=2201,name="Kodash [DE]"},
	{id=2010,name="Seafarer's Rest"},
	{id=2301,name="Baruch Bay [SP]"},
	{id=2205,name="Drakkar Lake [DE]"},
	{id=2002,name="Desolation"},
	{id=2202,name="Riverside [DE]"},
	{id=2008,name="Whiteside Ridge"},
	{id=2203,name="Elona Reach [DE]"},
	{id=2206,name="Miller's Sound [DE]"},
	{id=2004,name="Blacktide"},
	{id=2207,name="Dzagonur [DE]"},
	{id=2105,name="Arborstone [FR]"},
	{id=2101,name="Jade Sea [FR]"},
	{id=2013,name="Aurora Glade"},
	{id=2103,name="Augury Rock [FR]"},
	{id=2102,name="Fort Ranik [FR]"},
	{id=2104,name="Vizunah Square [FR]"},
	{id=2009,name="Ruins of Surmia"},
	{id=2014,name="Gunnar's Hold"},
	{id=2005,name="Ring of Fire"},
	{id=2006,name="Underworld"},
	{id=2011,name="Vabbi"},
	{id=2001,name="Fissure of Woe"}
}
