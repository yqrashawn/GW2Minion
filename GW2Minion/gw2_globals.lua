ml_global_information = ml_global_information or {}
ml_global_information.Path = GetStartupPath()
ml_global_information.Lasttick = 0
ml_global_information.Running = false
ml_global_information.MAX_SKILLBAR_SLOTS = 20

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
	[27705] = "Taunt",
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

ml_global_information.SlowConditions = {
	[721] = "Cripple",
	[722] = "Chill",
	[18621] = "Ichor"
}

ml_global_information.ImmobilizeConditions = {
	[727] = "Immobilize",
	[791] = "Fear",
	[872] = "Stun",
	[833] = "Daze",
	[27705] = "Taunt",
	[15090] = "Petrified 1",
	[16963] = "Petrified 2"
}

ml_global_information.InvulnerabilityConditions = {
	[762] = "Determined",
	[903] = "Righteous Indignation",
	[36143] = "Destruction Immunity",
}

function ml_global_information.Start()
	gw2_unstuck.Start()
end

-- Stops the Bot
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