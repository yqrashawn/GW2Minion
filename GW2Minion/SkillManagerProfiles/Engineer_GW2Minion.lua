-- Persistent Data
local multiRefObjects = {

} -- multiRefObjects
local obj1 = {
	["name"] = "GW2Minion";
	["profession"] = 3;
	["professionSettings"] = {
		["elementalist"] = {
		};
		["engineer"] = {
			["kit"] = "FlameThrower";
		};
	};
	["skills"] = {
		[1] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 15;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = true;
				["id"] = 5972;
				["los"] = false;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Toss Elixir S";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 15;
			};
			["target"] = {
			};
		};
		[2] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 15;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 6090;
				["los"] = false;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Toss Elixir S";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 15;
			};
			["target"] = {
			};
		};
		[3] = {
			["player"] = {
				["conditionCount"] = 0;
				["minHP"] = 75;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5834;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Elixir H";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 0;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[4] = {
			["player"] = {
				["minHP"] = 75;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5980;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Cleansing Burst";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 0;
			};
			["target"] = {
			};
		};
		[5] = {
			["player"] = {
				["minHP"] = 75;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 6176;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Regenerating Mist";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 12;
			};
			["target"] = {
			};
		};
		[6] = {
			["player"] = {
				["minHP"] = 75;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 29772;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Bandage Self";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 12;
			};
			["target"] = {
			};
		};
		[7] = {
			["player"] = {
				["minHP"] = 75;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5857;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Healing Turret";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 0;
			};
			["target"] = {
			};
		};
		[8] = {
			["player"] = {
				["minHP"] = 75;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5966;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Healing Mist";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 14;
			};
			["target"] = {
			};
		};
		[9] = {
			["player"] = {
				["allyDownedNearCount"] = 0;
				["allyDownedRangeMax"] = 0;
				["allyNearCount"] = 0;
				["allyRangeMax"] = 0;
				["boonCount"] = 0;
				["combatState"] = "Either";
				["conditionCount"] = 0;
				["hasBuffs"] = "";
				["hasNotBuffs"] = "";
				["maxEndurance"] = 0;
				["maxHP"] = 0;
				["maxPower"] = 0;
				["minEndurance"] = 0;
				["minHP"] = 0;
				["minPower"] = 0;
				["moving"] = "Either";
			};
			["skill"] = {
				["castOnSelf"] = false;
				["delay"] = 0;
				["id"] = 30264;
				["isProjectile"] = false;
				["lastSkillID"] = "";
				["los"] = true;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Overcharge Supply Crate";
				["radius"] = 0;
				["relativePosition"] = "None";
				["setRange"] = false;
				["slowCast"] = false;
				["stopsMovement"] = false;
			};
			["target"] = {
				["boonCount"] = 0;
				["conditionCount"] = 0;
				["enemyNearCount"] = 0;
				["enemyRangeMax"] = 0;
				["hasBuffs"] = "";
				["hasNotBuffs"] = "";
				["maxHP"] = 0;
				["minHP"] = 0;
				["moving"] = "Either";
				["type"] = "Either";
			};
		};
		[10] = {
			["player"] = {
				["minHP"] = 75;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 30357;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Medic Gyro";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 0;
			};
			["target"] = {
			};
		};
		[11] = {
			["player"] = {
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 1175;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Bandage";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[12] = {
			["player"] = {
				["minHP"] = 20;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 21659;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "A.E.D.";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 0;
			};
			["target"] = {
			};
		};
		[13] = {
			["player"] = {
				["minHP"] = 0;
				["moving"] = "NotMoving";
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 30599;
				["maxRange"] = 360;
				["minRange"] = 0;
				["name"] = "Orbital Strike";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 16;
				["slowCast"] = true;
			};
			["target"] = {
				["moving"] = "NotMoving";
			};
		};
		[14] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 6177;
				["maxRange"] = 1500;
				["minRange"] = 0;
				["name"] = "Rocket";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 13;
			};
			["target"] = {
				["moving"] = "NotMoving";
			};
		};
		[15] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 22573;
				["maxRange"] = 1500;
				["minRange"] = 0;
				["name"] = "Rocket";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 13;
			};
			["target"] = {
				["moving"] = "NotMoving";
			};
		};
		[16] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5867;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Toss Elixir R";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 15;
			};
			["target"] = {
			};
		};
		[17] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6091;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Toss Elixir R";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 13;
			};
			["target"] = {
			};
		};
		[18] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5975;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Analyze";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 14;
			};
			["target"] = {
			};
		};
		[19] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6178;
				["maxRange"] = 1000;
				["minRange"] = 0;
				["name"] = "Surprise Shot";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 14;
			};
			["target"] = {
			};
		};
		[20] = {
			["player"] = {
				["minHP"] = 70;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = true;
				["id"] = 29716;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Med Pack Drop";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 16;
			};
			["target"] = {
			};
		};
		[21] = {
			["player"] = {
				["minHP"] = 70;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 30588;
				["maxRange"] = 180;
				["minRange"] = 0;
				["name"] = "Med Pack Drop";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 16;
			};
			["target"] = {
			};
		};
		[22] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 17260;
				["los"] = false;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Detonate Flame Blast";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 6;
			};
			["target"] = {
			};
		};
		[23] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5810;
				["isProjectile"] = true;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Grenade Barrage";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 13;
			};
			["target"] = {
				["moving"] = "NotMoving";
			};
		};
		[24] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6172;
				["isProjectile"] = true;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Grenade Barrage";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 13;
			};
			["target"] = {
				["moving"] = "NotMoving";
			};
		};
		[25] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5982;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Launch Personal Battering Ram";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 14;
			};
			["target"] = {
			};
		};
		[26] = {
			["player"] = {
				["minHP"] = 60;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = true;
				["id"] = 5868;
				["los"] = false;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Supply Crate";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[27] = {
			["player"] = {
				["minHP"] = 60;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 6183;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Supply Crate";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[28] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 6181;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Throw Napalm";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 15;
			};
			["target"] = {
				["moving"] = "NotMoving";
			};
		};
		[29] = {
			["player"] = {
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = true;
				["id"] = 30725;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Toss Elixir X";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 16;
			};
			["target"] = {
			};
		};
		[30] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 29515;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Toss Elixir X";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 16;
			};
			["target"] = {
			};
		};
		[31] = {
			["player"] = {
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = true;
				["id"] = 5978;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Toss Elixir H";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 12;
			};
			["target"] = {
			};
		};
		[32] = {
			["player"] = {
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 6118;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Toss Elixir H";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 12;
			};
			["target"] = {
			};
		};
		[33] = {
			["player"] = {
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = true;
				["id"] = 5970;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Toss Elixir U";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 14;
			};
			["target"] = {
			};
		};
		[34] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6089;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Toss Elixir U";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 14;
			};
			["target"] = {
			};
		};
		[35] = {
			["player"] = {
				["conditionCount"] = 2;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = true;
				["id"] = 5969;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Toss Elixir C";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 15;
			};
			["target"] = {
			};
		};
		[36] = {
			["player"] = {
				["conditionCount"] = 2;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 6077;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Toss Elixir C";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 15;
			};
			["target"] = {
			};
		};
		[37] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5999;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Throw Wrench";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 14;
			};
			["target"] = {
			};
		};
		[38] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = true;
				["id"] = 5967;
				["los"] = false;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Toss Elixir B";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 14;
			};
			["target"] = {
			};
		};
		[39] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6092;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Toss Elixir B";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 14;
			};
			["target"] = {
			};
		};
		[40] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6179;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Net Attack";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 13;
			};
			["target"] = {
			};
		};
		[41] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6164;
				["maxRange"] = 360;
				["minRange"] = 0;
				["name"] = "Mine Field";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 15;
			};
			["target"] = {
			};
		};
		[42] = {
			["player"] = {
				["minHP"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5813;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Big Ol' Bomb";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 13;
			};
			["target"] = {
			};
		};
		[43] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5983;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Rocket Kick";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 14;
			};
			["target"] = {
			};
		};
		[44] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6180;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Rumble";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 14;
			};
			["target"] = {
			};
		};
		[45] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 21661;
				["maxRange"] = 180;
				["minRange"] = 0;
				["name"] = "Static Shock";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 12;
			};
			["target"] = {
			};
		};
		[46] = {
			["player"] = {
				["combatState"] = "OutCombat";
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5985;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Detonate Flame Turret";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 15;
			};
			["target"] = {
			};
		};
		[47] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 30262;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Detection Pulse";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 16;
			};
			["target"] = {
			};
		};
		[48] = {
			["player"] = {
				["minHP"] = 50;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 30027;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Defense Field";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 13;
			};
			["target"] = {
			};
		};
		[49] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 30279;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Chemical Field";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 13;
			};
			["target"] = {
			};
		};
		[50] = {
			["player"] = {
				["combatState"] = "OutCombat";
				["minHP"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5961;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Detonate Healing Turret";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 12;
			};
			["target"] = {
			};
		};
		[51] = {
			["player"] = {
				["minHP"] = 85;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 30101;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Bulwark Gyro";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[52] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 29665;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Bypass Coating";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 14;
			};
			["target"] = {
			};
		};
		[53] = {
			["player"] = {
				["maxPower"] = 0;
				["minHP"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5829;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Static Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[54] = {
			["player"] = {
				["combatState"] = "OutCombat";
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5984;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Detonate Net Turret";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 13;
			};
			["target"] = {
			};
		};
		[55] = {
			["player"] = {
				["combatState"] = "OutCombat";
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6134;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Detonate Rocket Turret";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 13;
			};
			["target"] = {
			};
		};
		[56] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 31167;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Spare Capacitor";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 15;
			};
			["target"] = {
			};
		};
		[57] = {
			["player"] = {
				["combatState"] = "OutCombat";
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5957;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Detonate Rifle Turret";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 14;
			};
			["target"] = {
			};
		};
		[58] = {
			["player"] = {
				["minHP"] = 95;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 29505;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Reconstruction Field";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 12;
			};
			["target"] = {
			};
		};
		[59] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5977;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Incendiary Ammo";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 15;
			};
			["target"] = {
			};
		};
		[60] = {
			["player"] = {
				["combatState"] = "OutCombat";
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5960;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Detonate Thumper Turret";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 14;
			};
			["target"] = {
			};
		};
		[61] = {
			["player"] = {
				["moving"] = "Moving";
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5973;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Superspeed";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 14;
			};
			["target"] = {
			};
		};
		[62] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 30815;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Sneak Gyro";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[63] = {
			["player"] = {
				["minHP"] = 60;
			};
			["skill"] = {
				["delay"] = 0;
				["groundTargeted"] = false;
				["id"] = 5832;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Elixir X";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[64] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 20451;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Elixir X";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[65] = {
			["player"] = {
				["minHP"] = 85;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 31248;
				["maxRange"] = 1500;
				["minRange"] = 0;
				["name"] = "Blast Gyro Tag";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[66] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5912;
				["maxRange"] = 1000;
				["minRange"] = 0;
				["name"] = "Rocket Turret";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[67] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 22574;
				["maxRange"] = 1000;
				["minRange"] = 0;
				["name"] = "Rocket Turret";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[68] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5818;
				["maxRange"] = 1000;
				["minRange"] = 0;
				["name"] = "Rifle Turret";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[69] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 6161;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Throw Mine";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[70] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5910;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Rocket Boots";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[71] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5837;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Net Turret";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[72] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 29921;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Shredder Gyro";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[73] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5836;
				["maxRange"] = 450;
				["minRange"] = 0;
				["name"] = "Flame Turret";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[74] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5838;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Thumper Turret";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[75] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5811;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Personal Battering Ram";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[76] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5913;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Explosive Rockets";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[77] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5821;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Elixir B";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[78] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6057;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Throw Shield";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[79] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6126;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Magnetic Inversion";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[80] = {
			["player"] = {
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5861;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Elixir S";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[81] = {
			["player"] = {
				["conditionCount"] = 2;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5860;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Elixir C";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[82] = {
			["player"] = {
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5862;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Elixir U";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[83] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 29739;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Purge Gyro";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[84] = {
			["player"] = {
			};
			["skill"] = {
				["delay"] = 10000;
				["groundTargeted"] = false;
				["id"] = 5933;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Elixir Gun";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[85] = {
			["player"] = {
				["maxPower"] = 0;
				["minHP"] = 66;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6053;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Magnetic Shield";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[86] = {
			["player"] = {
			};
			["skill"] = {
				["castOnSelf"] = true;
				["delay"] = 0;
				["groundTargeted"] = false;
				["id"] = 5968;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Elixir R";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[87] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5865;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Utility Goggles";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[88] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5889;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Thump";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[89] = {
			["player"] = {
			};
			["skill"] = {
				["delay"] = 0;
				["groundTargeted"] = false;
				["id"] = 5874;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Automatic Fire";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[90] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6098;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Automatic Fire";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[91] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5893;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Electrified Net";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[92] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5825;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Slick Shoes";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[93] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5900;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Smoke Screen";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[94] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 30032;
				["maxRange"] = 1500;
				["minRange"] = 0;
				["name"] = "Elixir Shell";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[95] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5996;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Magnet";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[96] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 30713;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Thunderclap";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[97] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5806;
				["isProjectile"] = true;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Poison Grenade";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[98] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6167;
				["isProjectile"] = true;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Poison Grenade";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[99] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5937;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Super Elixir";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[100] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6104;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Super Elixir";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[101] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6102;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Super Elixir";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[102] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 14490;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Seismic Leap";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[103] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 30121;
				["maxRange"] = 1500;
				["minRange"] = 0;
				["name"] = "Flash Shell";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[104] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5939;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Glue Bomb";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[105] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6159;
				["maxRange"] = 180;
				["minRange"] = 0;
				["name"] = "Smoke Vent";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[106] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5809;
				["isProjectile"] = true;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Freeze Grenade";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[107] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6168;
				["isProjectile"] = true;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Freeze Grenade";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[108] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14556;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Throw Boulder";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[109] = {
			["player"] = {
			};
			["skill"] = {
				["delay"] = 0;
				["groundTargeted"] = true;
				["id"] = 5929;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Napalm";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[110] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 30307;
				["maxRange"] = 1500;
				["minRange"] = 0;
				["name"] = "Endothermic Shell";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[111] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5824;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Smoke Bomb";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[112] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14489;
				["maxRange"] = 1000;
				["minRange"] = 0;
				["name"] = "Dash";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[113] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 30665;
				["maxRange"] = 1000;
				["minRange"] = 0;
				["name"] = "Rocket Charge";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[114] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5936;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Acid Bomb";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[115] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5998;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Gear Shield";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[116] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5808;
				["isProjectile"] = true;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Flash Grenade";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[117] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6169;
				["isProjectile"] = true;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Flash Grenade";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[118] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 30885;
				["maxRange"] = 1500;
				["minRange"] = 0;
				["name"] = "Poison Gas Shell";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 6;
			};
			["target"] = {
			};
		};
		[119] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5965;
				["maxRange"] = 450;
				["minRange"] = 0;
				["name"] = "Fumigate";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[120] = {
			["player"] = {
				["minHP"] = 75;
			};
			["skill"] = {
				["delay"] = 0;
				["groundTargeted"] = false;
				["id"] = 5930;
				["los"] = true;
				["maxRange"] = 200;
				["minRange"] = 0;
				["name"] = "Air Blast";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[121] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5822;
				["maxRange"] = 180;
				["minRange"] = 0;
				["name"] = "Concussion Bomb";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[122] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5905;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Pry Bar";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[123] = {
			["player"] = {
				["minHP"] = 90;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 29840;
				["maxRange"] = 170;
				["minRange"] = 0;
				["name"] = "Shock Shield";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 8;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[124] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5807;
				["isProjectile"] = true;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Shrapnel Grenade";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 6;
			};
			["target"] = {
			};
		};
		[125] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6054;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Static Shield";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[126] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6170;
				["isProjectile"] = true;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Shrapnel Grenade";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 6;
			};
			["target"] = {
			};
		};
		[127] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5935;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Glob Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 6;
			};
			["target"] = {
			};
		};
		[128] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5831;
				["maxRange"] = 250;
				["minRange"] = 0;
				["name"] = "Blowtorch";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[129] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5830;
				["maxRange"] = 700;
				["minRange"] = 0;
				["name"] = "Glue Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 9;
			};
			["target"] = {
				["moving"] = "Moving";
			};
		};
		[130] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6004;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Net Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 6;
			};
			["target"] = {
				["moving"] = "Moving";
			};
		};
		[131] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6153;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Blunderbuss";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[132] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5828;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Poison Dart Volley";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 6;
			};
			["target"] = {
			};
		};
		[133] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6154;
				["maxRange"] = 200;
				["minRange"] = 0;
				["name"] = "Overcharged Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[134] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 6005;
				["maxRange"] = 800;
				["minRange"] = 0;
				["name"] = "Jump Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 9;
			};
			["target"] = {
				["moving"] = "NotMoving";
			};
		};
		[135] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5931;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Flame Blast";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 6;
			};
			["target"] = {
			};
		};
		[136] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14488;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Kick";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 6;
			};
			["target"] = {
			};
		};
		[137] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 10180;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Kick";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 6;
			};
			["target"] = {
			};
		};
		[138] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5823;
				["maxRange"] = 180;
				["minRange"] = 0;
				["name"] = "Fire Bomb";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 6;
			};
			["target"] = {
			};
		};
		[139] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5995;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Box of Nails";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 6;
			};
			["target"] = {
			};
		};
		[140] = {
			["player"] = {
				["allyDownedNearCount"] = 0;
				["allyDownedRangeMax"] = 0;
				["allyNearCount"] = 0;
				["allyRangeMax"] = 0;
				["boonCount"] = 0;
				["combatState"] = "Either";
				["conditionCount"] = 0;
				["hasBuffs"] = "";
				["hasNotBuffs"] = "";
				["maxEndurance"] = 0;
				["maxHP"] = 0;
				["maxPower"] = 0;
				["minEndurance"] = 0;
				["minHP"] = 0;
				["minPower"] = 0;
				["moving"] = "Either";
			};
			["skill"] = {
				["castOnSelf"] = false;
				["delay"] = 0;
				["groundTargeted"] = false;
				["id"] = 30088;
				["isProjectile"] = false;
				["lastSkillID"] = "";
				["los"] = true;
				["maxRange"] = 180;
				["minRange"] = 0;
				["name"] = "Electro-whirl";
				["radius"] = 0;
				["relativePosition"] = "None";
				["setRange"] = true;
				["slot"] = 6;
				["slowCast"] = true;
				["stopsMovement"] = false;
			};
			["target"] = {
				["boonCount"] = 0;
				["conditionCount"] = 0;
				["enemyNearCount"] = 0;
				["enemyRangeMax"] = 0;
				["hasBuffs"] = "";
				["hasNotBuffs"] = "";
				["maxHP"] = 0;
				["minHP"] = 0;
				["moving"] = "Either";
				["type"] = "Either";
			};
		};
		[141] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 30371;
				["maxRange"] = 1500;
				["minRange"] = 0;
				["name"] = "Mortar Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[142] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5882;
				["isProjectile"] = true;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Grenade";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[143] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6171;
				["isProjectile"] = true;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Grenade";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[144] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5934;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Tranquilizer Dart";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[145] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5928;
				["maxRange"] = 425;
				["minRange"] = 0;
				["name"] = "Flame Jet";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[146] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5842;
				["maxRange"] = 180;
				["minRange"] = 0;
				["name"] = "Bomb";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[147] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5993;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Whack";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[148] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 30489;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Equalizing Blow";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[149] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 29785;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Negative Bash";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[150] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 30501;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Positive Strike";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[151] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14485;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Smash";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[152] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5992;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Smack";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[153] = {
			["player"] = {
				["combatState"] = "OutCombat";
				["minHP"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6097;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Detonate Harpoon Turret";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 14;
			};
			["target"] = {
			};
		};
		[154] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14487;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Uppercut";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[155] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5994;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Thwack";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[156] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 14486;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Bash";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[157] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6175;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Box of Piranhas";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 6;
			};
			["target"] = {
			};
		};
		[158] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6163;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Deploy Mine";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[159] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6093;
				["maxRange"] = 1000;
				["minRange"] = 0;
				["name"] = "Harpoon Turret";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[160] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6182;
				["maxRange"] = 1000;
				["minRange"] = 0;
				["name"] = "Harpoon";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 14;
			};
			["target"] = {
			};
		};
		[161] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5603;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Whirlpool";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[162] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6147;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Scatter Mines";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 6;
			};
			["target"] = {
			};
		};
		[163] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6146;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Retreating Grapple";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[164] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6149;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Timed Charge";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[165] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6145;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Net Wall";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[166] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6073;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Detonate Mines";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 6;
			};
			["target"] = {
			};
		};
		[167] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6148;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Homing Torpedo";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[168] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5916;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Floating Mine";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[169] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5917;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Anchor";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 6;
			};
			["target"] = {
			};
		};
		[170] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5918;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Buoy";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[171] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5962;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Grappling Line";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 6;
			};
			["target"] = {
			};
		};
		[172] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5963;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Booby Trap";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[173] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5820;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Throw Junk";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[174] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 6003;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Hip Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[175] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5827;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Fragmentation Shot";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[176] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 10661;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Withering Plague";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[177] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 10662;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Plague of Darkness";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 6;
			};
			["target"] = {
			};
		};
		[178] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 10663;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Plague of Pestilence";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
	};
	["switchSettings"] = {
		["switchOnRange"] = "1";
		["switchRandom"] = "1";
	};
}
return obj1
