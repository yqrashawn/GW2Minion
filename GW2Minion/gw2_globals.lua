ml_global_information = ml_global_information or {}
ml_global_information.Path = GetStartupPath()
ml_global_information.Lasttick = 0
ml_global_information.Running = false
ml_global_information.MAX_SKILLBAR_SLOTS = 20

ml_global_information.ConditionsEnum = {
	[736]		= "Bleeding",
	[720]		= "Blind",
	[737]		= "Burning",
	[722]		= "Chilled",
	[861]		= "Confusion",
	[721]		= "Crippled",
	[791]		= "Fear",
	[727]		= "Immobilized",
	[738]		= "Vulnerability",
	[742]		= "Weakness",
	[723]		= "Poison",
	[27705]		= "Taunt",
	[26766]		= "Slow",
	[19426]		= "Torment",
};

ml_global_information.BoonsEnum = {
	[743]		= "Aegis",
	[17675]		= "Aegis",
	[725]		= "Fury",
	[740]		= "Might",
	[717]		= "Protection",
	[1187]		= "Quickness",
	[718]		= "Regeneration",
	[17674]		= "Regeneration",
	[26980]		= "Resistance",
	[873]		= "Retaliation",
	[1122]		= "Stability",
	[719]		= "Swiftness",
	[726]		= "Vigor",
	[762]		= "Determined",
};

ml_global_information.SpeedBoons = {
	[719]		= "Swiftness",
	[5974]		= "Super Speed",
	[5543]		= "Mist form",
	[12542]		= "Signet of the Hunt",
	[13060]		= "Signet of Shadows",
	[5572]		= "Signet of Air",
	[10612]		= "Signet of the Locust",
}

ml_global_information.SlowConditions = {
	[721]		= "Cripple",
	[722]		= "Chill",
	[18621]		= "Ichor",
}

ml_global_information.ImmobilizeConditions = {
	[727]		= "Immobilize",
	[791]		= "Fear",
	[872]		= "Stun",
	[833]		= "Daze",
	[27705]		= "Taunt",
	[15090]		= "Petrified 1",
	[16963]		= "Petrified 2",
}

ml_global_information.InvulnerabilityConditions = {
	[762]		= "Determined",
	[903]		= "Righteous Indignation",
	[36143]		= "Destruction Immunity",
}

-- Moved this here so it's easier to look at and easier to copy paste
function ml_global_information.OnUpdate(Event,ticks)
	if(TimeSince(ml_global_information.Lasttick) > ml_bt_mgr.throttletmr) then
		ml_global_information.Lasttick = ticks
		
		ml_global_information.GameState = GetGameState()

		if(Player) then
			ml_global_information.Player_ID = Player.id or 0
			ml_global_information.Player_Name = Player.name or ""
			ml_global_information.Player_Health = Player.health or { current = 0, max = 0, percent = 0 }
			ml_global_information.Player_Profession = Player.profession or 0
			ml_global_information.Player_ProfessionName = table_invert(GW2.CHARCLASS)[ml_global_information.Player_Profession] or "NoClass"
			ml_global_information.Player_Power = Player.power or 0
			ml_global_information.Player_Endurance = Player.endurance or 0
			ml_global_information.Player_InCombat = Player.incombat or false		
			ml_global_information.Player_Position = Player.pos
			ml_global_information.Player_Level = Player.level
			ml_global_information.Player_OnMesh = Player.onmesh or false
			ml_global_information.Player_Alive = Player.alive or false
			ml_global_information.Player_IsMoving = Player:IsMoving() or false
			ml_global_information.Player_CanMove = Player:CanMove() or false
			ml_global_information.Player_MovementDirections = Player:GetMovement() or { forward=false, backward=false, left=false, right=false }
			ml_global_information.Player_Inventory_SlotsFree = Inventory.freeslotcount or 0
			ml_global_information.Player_HealthState = Player.healthstate or 0
			ml_global_information.Player_SwimState = Player.swimming or 0
			ml_global_information.Player_MovementState = Player:GetMovementState() or 1
			ml_global_information.Player_Party = Player:GetParty() or nil

			ml_global_information.CurrentMapID = Player:GetLocalMapID() or 0
			if (gw2_datamanager and ml_global_information.CurrentMapID ~= 0) then  
				ml_global_information.CurrentMapName = gw2_datamanager.GetMapName(ml_global_information.CurrentMapID) 
			else
				ml_global_information.CurrentMapName = ""
			end

			ml_global_information.AttackRange = gw2_skill_manager.GetMaxAttackRange()

			ml_global_information.Player_CurrentWeaponSet = Player:GetCurrentWeaponSet() or 0	-- 0 Aqua1, 1 Aqua2, 2 Engikit, 3 Necro Lich Form/ranger astralform,  4 Weapon1, 5 Weapon2
			ml_global_information.Player_TransformID = Player:GetTransformID() or 0 -- 1-4 attunement, 5 deathshroud, 9 rangernormal, 10 rangerastralform
		end
	end
end
RegisterEventHandler("Gameloop.Update", ml_global_information.OnUpdate)

function ml_global_information.Start()
	gw2_unstuck.Start()
end

function ml_global_information.Stop()
    Player:StopMovement()
	gw2_unstuck.Stop()
	ml_mesh_mgr.ResetOMC()
	ml_mesh_mgr.OMCStartPositionReached = false
end

-- Waits xxx seconds before running the next pulse
function ml_global_information.Wait( mseconds )
	ml_bt_mgr.lasttick = (ml_bt_mgr.lasttick or ml_global_information.Now) + mseconds
end