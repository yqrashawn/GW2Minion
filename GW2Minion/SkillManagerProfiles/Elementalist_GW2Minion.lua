-- Persistent Data
local multiRefObjects = {

} -- multiRefObjects
local obj1 = {
	["name"] = "GW2Minion";
	["profession"] = 6;
	["professionSettings"] = {
		["elementalist"] = {
			["attunement_1"] = "Fire";
			["attunement_2"] = "Air";
			["attunement_3"] = "Earth";
			["attunement_4"] = "None";
		};
		["engineer"] = {
		};
	};
	["skills"] = {
		[1] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 80;
			};
			["priority"] = 1;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5503;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Signet of Restoration";
				["radius"] = 0;
				["setRange"] = "0";
				["slowCast"] = "1";
			};
			["slot"] = 6;
			["target"] = {
			};
		};
		[2] = {
			["player"] = {
				["maxPower"] = 0;
				["minHP"] = 75;
			};
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 29535;
				["los"] = "0";
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "\"Wash the Pain Away!\"";
				["radius"] = 0;
				["setRange"] = "0";
				["slot"] = 0;
				["slowCast"] = "1";
			};
			["target"] = {
			};
		};
		[3] = {
			["player"] = {
				["minHP"] = 95;
			};
			["priority"] = 2;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5507;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Ether Renewal";
				["radius"] = 0;
				["setRange"] = "0";
				["slowCast"] = "1";
			};
			["slot"] = 6;
			["target"] = {
			};
		};
		[4] = {
			["player"] = {
				["minHP"] = 70;
			};
			["priority"] = 3;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5569;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Glyph of Elemental Harmony";
				["radius"] = 0;
				["setRange"] = "0";
				["slowCast"] = "1";
			};
			["slot"] = 6;
			["target"] = {
			};
		};
		[5] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 75;
			};
			["priority"] = 4;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 21656;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Arcane Brilliance";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 6;
			["target"] = {
			};
		};
		[6] = {
			["player"] = {
				["combatState"] = "Either";
				["minHP"] = 20;
			};
			["priority"] = 5;
			["skill"] = {
				["castOnSelf"] = "1";
				["delay"] = 0;
				["groundTargeted"] = "0";
				["id"] = 10700;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Leave Transform";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 10;
			["target"] = {
			};
		};
		[7] = {
			["player"] = {
				["conditionCount"] = 1;
				["minHP"] = 0;
			};
			["priority"] = 6;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 25492;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Crashing Waves";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 10;
			["target"] = {
				["hasNotBuffs"] = "1122,906,905\
";
			};
		};
		[8] = {
			["player"] = {
				["combatState"] = "InCombat";
				["conditionCount"] = 0;
				["minHP"] = 0;
			};
			["priority"] = 7;
			["skill"] = {
				["castOnSelf"] = "0";
				["groundTargeted"] = "0";
				["id"] = 25499;
				["los"] = "1";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Flame Barrage";
				["radius"] = 360;
				["setRange"] = "0";
			};
			["slot"] = 10;
			["target"] = {
			};
		};
		[9] = {
			["player"] = {
				["minHP"] = 10;
			};
			["priority"] = 8;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "1";
				["id"] = 5762;
				["los"] = "1";
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Renewal of Fire";
				["radius"] = 180;
				["setRange"] = "0";
				["slowCast"] = "1";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[10] = {
			["player"] = {
				["hasBuffs"] = "872,833";
				["maxHP"] = 0;
				["minHP"] = 0;
			};
			["priority"] = 9;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5572;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Signet of Air";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 7;
			["target"] = {
				["minHP"] = 0;
			};
		};
		[11] = {
			["player"] = {
			};
			["priority"] = 10;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "1";
				["id"] = 5761;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Renewal of Earth";
				["radius"] = 0;
				["setRange"] = "0";
				["slowCast"] = "1";
			};
			["slot"] = 8;
			["target"] = {
				["enemyNearCount"] = 0;
				["enemyRangeMax"] = 0;
			};
		};
		[12] = {
			["player"] = {
				["combatState"] = "InCombat";
				["conditionCount"] = 0;
				["hasBuffs"] = "872,833";
				["minHP"] = 0;
			};
			["priority"] = 11;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5639;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Armor of Earth";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[13] = {
			["player"] = {
				["allyDownedNearCount"] = 1;
				["allyDownedRangeMax"] = 900;
			};
			["priority"] = 12;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 24410;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Renewal of Water";
				["radius"] = 0;
				["setRange"] = "0";
				["slowCast"] = "1";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[14] = {
			["player"] = {
				["allyDownedNearCount"] = 1;
				["allyDownedRangeMax"] = 900;
			};
			["priority"] = 13;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 24407;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Renewal of Fire";
				["radius"] = 0;
				["setRange"] = "0";
				["slowCast"] = "1";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[15] = {
			["player"] = {
				["combatState"] = "OutCombat";
				["hasNotBuffs"] = "719";
				["minHP"] = 0;
				["moving"] = "Moving";
			};
			["priority"] = 14;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5554;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Mist Form";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[16] = {
			["player"] = {
				["allyDownedNearCount"] = 1;
				["allyDownedRangeMax"] = 900;
			};
			["priority"] = 15;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "1";
				["id"] = 5763;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Renewal of Water";
				["radius"] = 0;
				["setRange"] = "0";
				["slowCast"] = "1";
			};
			["slot"] = 8;
			["target"] = {
			};
		};
		[17] = {
			["player"] = {
			};
			["priority"] = 16;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "1";
				["id"] = 5760;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Renewal of Air";
				["radius"] = 0;
				["setRange"] = "0";
				["slowCast"] = "1";
			};
			["slot"] = 8;
			["target"] = {
			};
		};
		[18] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 0;
			};
			["priority"] = 17;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5635;
				["los"] = "1";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Arcane Power";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 8;
			["target"] = {
				["type"] = "Character";
			};
		};
		[19] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 40;
				["moving"] = "Either";
			};
			["priority"] = 18;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5554;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Mist Form";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[20] = {
			["player"] = {
				["conditionCount"] = 2;
			};
			["priority"] = 19;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5535;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Cleansing Fire";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[21] = {
			["player"] = {
				["hasNotBuffs"] = "719";
				["minHP"] = 0;
				["moving"] = "Moving";
			};
			["priority"] = 20;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 25478;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Windborne Speed";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[22] = {
			["player"] = {
				["allyDownedNearCount"] = 1;
				["allyDownedRangeMax"] = 900;
			};
			["priority"] = 21;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 24409;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Renewal of Air";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[23] = {
			["player"] = {
				["combatState"] = "InCombat";
				["conditionCount"] = 0;
				["minHP"] = 80;
			};
			["priority"] = 22;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5639;
				["los"] = "1";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Armor of Earth";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[24] = {
			["player"] = {
				["combatState"] = "Either";
				["hasBuffs"] = "872,833";
			};
			["priority"] = 23;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5506;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Glyph of Elemental Power";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[25] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 60;
			};
			["priority"] = 24;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5641;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Arcane Shield";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 9;
			["target"] = {
			};
		};
		[26] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["priority"] = 25;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5506;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Glyph of Elemental Power";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[27] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["priority"] = 26;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5695;
				["los"] = "1";
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Rock Barrier";
				["radius"] = 0;
				["setRange"] = "0";
				["slowCast"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[28] = {
			["player"] = {
			};
			["priority"] = 27;
			["skill"] = {
				["castOnSelf"] = "1";
				["delay"] = 0;
				["groundTargeted"] = "0";
				["id"] = 5610;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Steam Vent";
				["radius"] = 0;
				["setRange"] = "0";
				["slowCast"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[29] = {
			["player"] = {
				["conditionCount"] = 1;
				["minHP"] = 0;
			};
			["priority"] = 28;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5558;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Cleansing Wave";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 5;
			["target"] = {
			};
		};
		[30] = {
			["player"] = {
				["combatState"] = "InCombat";
				["conditionCount"] = 0;
				["minHP"] = 50;
			};
			["priority"] = 29;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5521;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Obsidian Flesh";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 5;
			["target"] = {
			};
		};
		[31] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 70;
			};
			["priority"] = 30;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5678;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Fire Shield";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 5;
			["target"] = {
			};
		};
		[32] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 90;
			};
			["priority"] = 31;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5558;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Cleansing Wave";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 5;
			["target"] = {
			};
		};
		[33] = {
			["player"] = {
				["conditionCount"] = 2;
			};
			["priority"] = 32;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5555;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Magnetic Wave";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 4;
			["target"] = {
			};
		};
		[34] = {
			["player"] = {
				["combatState"] = "InCombat";
				["conditionCount"] = 1;
				["minHP"] = 90;
			};
			["priority"] = 33;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "1";
				["id"] = 5551;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Healing Rain";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 5;
			["target"] = {
			};
		};
		[35] = {
			["player"] = {
			};
			["priority"] = 34;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 1175;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Bandage";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 4;
			["target"] = {
			};
		};
		[36] = {
			["player"] = {
				["allyDownedNearCount"] = 0;
				["allyDownedRangeMax"] = 0;
				["moving"] = "Moving";
			};
			["priority"] = 35;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5682;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Windborne Speed";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 4;
			["target"] = {
			};
		};
		[37] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["priority"] = 36;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5685;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Magnetic Aura";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[38] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["priority"] = 37;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5520;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Frost Aura";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 4;
			["target"] = {
				["type"] = "Either";
			};
		};
		[39] = {
			["player"] = {
			};
			["priority"] = 38;
			["skill"] = {
				["castOnSelf"] = "1";
				["delay"] = 5000;
				["groundTargeted"] = "0";
				["id"] = 5614;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Detonate";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 3;
			["target"] = {
				["enemyNearCount"] = 1;
				["enemyRangeMax"] = 600;
			};
		};
		[40] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 90;
			};
			["priority"] = 39;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "1";
				["id"] = 5510;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Water Trident";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[41] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["priority"] = 40;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5527;
				["los"] = "1";
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Shocking Aura";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
				["type"] = "Character";
			};
		};
		[42] = {
			["player"] = {
				["minHP"] = 85;
			};
			["priority"] = 41;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "1";
				["id"] = 5681;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Geyser";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[43] = {
			["player"] = {
			};
			["priority"] = 42;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5564;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Vapor Form";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[44] = {
			["player"] = {
				["minHP"] = 0;
			};
			["priority"] = 43;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5746;
				["lastSkillID"] = 21646;
				["maxRange"] = 450;
				["minRange"] = 0;
				["name"] = "Crippling Shield";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[45] = {
			["player"] = {
			};
			["priority"] = 44;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5728;
				["lastSkillID"] = 5727;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Thunderclap";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[46] = {
			["player"] = {
			};
			["priority"] = 45;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5727;
				["lastSkillID"] = 5726;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Static Swing";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[47] = {
			["player"] = {
			};
			["priority"] = 46;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 21646;
				["lastSkillID"] = 5621;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Shield Smash";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[48] = {
			["player"] = {
				["combatState"] = "InCombat";
				["conditionCount"] = 2;
				["minHP"] = 40;
			};
			["priority"] = 47;
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5493;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Water Attunement";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 14;
			["target"] = {
				["conditionCount"] = 0;
			};
		};
		[49] = {
			["player"] = {
				["combatState"] = "OutCombat";
				["conditionCount"] = 0;
				["hasNotBuffs"] = "719";
				["maxPower"] = 0;
				["minHP"] = 0;
				["moving"] = "Moving";
			};
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 5494;
				["los"] = "0";
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Air Attunement";
				["radius"] = 0;
				["setRange"] = "0";
				["slot"] = 14;
			};
			["target"] = {
				["hasNotBuffs"] = "";
				["moving"] = "Either";
			};
		};
		[50] = {
			["player"] = {
				["conditionCount"] = 0;
				["minHP"] = 0;
			};
			["priority"] = 49;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 25488;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Glyph of Elementals";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 10;
			["target"] = {
				["type"] = "Character";
			};
		};
		[51] = {
			["player"] = {
			};
			["priority"] = 50;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5516;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Conjure Fiery Greatsword";
				["radius"] = 150;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 10;
			["target"] = {
			};
		};
		[52] = {
			["player"] = {
			};
			["priority"] = 51;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 25490;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Glyph of Elementals";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 10;
			["target"] = {
			};
		};
		[53] = {
			["player"] = {
			};
			["priority"] = 52;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 25489;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Glyph of Elementals";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 10;
			["target"] = {
				["type"] = "Character";
			};
		};
		[54] = {
			["player"] = {
			};
			["priority"] = 53;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 25491;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Glyph of Elementals";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 10;
			["target"] = {
			};
		};
		[55] = {
			["player"] = {
			};
			["priority"] = 54;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5602;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Whirlpool";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 10;
			["target"] = {
				["type"] = "Character";
			};
		};
		[56] = {
			["player"] = {
			};
			["priority"] = 55;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 25498;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Stomp";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 10;
			["target"] = {
			};
		};
		[57] = {
			["player"] = {
			};
			["priority"] = 56;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 25480;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Shocking Bolt";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 10;
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
				["type"] = "Character";
			};
		};
		[58] = {
			["player"] = {
			};
			["priority"] = 57;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5534;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Tornado";
				["radius"] = 240;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 10;
			["target"] = {
				["type"] = "Character";
			};
		};
		[59] = {
			["player"] = {
				["conditionCount"] = 0;
				["minHP"] = 0;
			};
			["priority"] = 58;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5738;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Sandstorm";
				["radius"] = 240;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 7;
			["target"] = {
				["moving"] = "NotMoving";
				["type"] = "Character";
			};
		};
		[60] = {
			["player"] = {
				["minHP"] = 0;
			};
			["priority"] = 59;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5736;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Firestorm";
				["radius"] = 240;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[61] = {
			["player"] = {
				["maxHP"] = 80;
				["minHP"] = 0;
			};
			["priority"] = 60;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5572;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Signet of Air";
				["radius"] = 240;
				["setRange"] = "1";
			};
			["slot"] = 7;
			["target"] = {
				["minHP"] = 20;
				["moving"] = "Moving";
				["type"] = "Character";
			};
		};
		[62] = {
			["player"] = {
			};
			["priority"] = 61;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 25497;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Glyph of Lesser Elementals";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[63] = {
			["player"] = {
			};
			["priority"] = 62;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 25495;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Glyph of Lesser Elementals";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[64] = {
			["player"] = {
			};
			["priority"] = 63;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 25486;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Glyph of Lesser Elementals";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[65] = {
			["player"] = {
			};
			["priority"] = 64;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 25487;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Glyph of Lesser Elementals";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[66] = {
			["player"] = {
			};
			["priority"] = 65;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5735;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Ice Storm";
				["radius"] = 240;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 7;
			["target"] = {
				["moving"] = "NotMoving";
			};
		};
		[67] = {
			["player"] = {
			};
			["priority"] = 66;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5737;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Lightning Storm";
				["radius"] = 240;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 7;
			["target"] = {
				["moving"] = "NotMoving";
			};
		};
		[68] = {
			["player"] = {
				["allyDownedNearCount"] = 0;
				["allyDownedRangeMax"] = 0;
			};
			["priority"] = 67;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 22572;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Arcane Wave";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[69] = {
			["player"] = {
				["minHP"] = 0;
			};
			["priority"] = 68;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5638;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Arcane Wave";
				["radius"] = 360;
				["setRange"] = "1";
			};
			["slot"] = 7;
			["target"] = {
				["type"] = "Character";
			};
		};
		[70] = {
			["player"] = {
				["maxHP"] = 80;
			};
			["priority"] = 69;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5571;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Signet of Earth";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 7;
			["target"] = {
				["minHP"] = 20;
				["moving"] = "Moving";
			};
		};
		[71] = {
			["player"] = {
				["maxHP"] = 80;
				["minHP"] = 0;
			};
			["priority"] = 70;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5570;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Signet of Water";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 7;
			["target"] = {
				["minHP"] = 20;
				["moving"] = "Moving";
				["type"] = "Character";
			};
		};
		[72] = {
			["player"] = {
				["minHP"] = 20;
			};
			["priority"] = 71;
			["skill"] = {
				["castOnSelf"] = "0";
				["groundTargeted"] = "0";
				["id"] = 5542;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Signet of Fire";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[73] = {
			["player"] = {
			};
			["priority"] = 72;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5539;
				["maxRange"] = 1500;
				["minRange"] = 0;
				["name"] = "Arcane Blast";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 7;
			["target"] = {
				["type"] = "Character";
			};
		};
		[74] = {
			["player"] = {
			};
			["priority"] = 73;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 25494;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Enervating Punch";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 7;
			["target"] = {
				["type"] = "Character";
			};
		};
		[75] = {
			["player"] = {
				["minHP"] = 0;
			};
			["priority"] = 74;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5540;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Conjure Flame Axe";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[76] = {
			["player"] = {
			};
			["priority"] = 75;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5536;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Lightning Flash";
				["radius"] = 120;
				["setRange"] = "1";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[77] = {
			["player"] = {
			};
			["priority"] = 76;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5567;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Conjure Frost Bow";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[78] = {
			["player"] = {
			};
			["priority"] = 77;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5546;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Conjure Earth Shield";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[79] = {
			["player"] = {
			};
			["priority"] = 78;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5624;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Conjure Lightning Hammer";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[80] = {
			["player"] = {
				["allyDownedNearCount"] = 1;
				["allyDownedRangeMax"] = 900;
			};
			["priority"] = 79;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 24411;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Renewal of Earth";
				["radius"] = 0;
				["setRange"] = "0";
				["slowCast"] = "1";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[81] = {
			["player"] = {
			};
			["priority"] = 80;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 25476;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Frozen Ground";
				["radius"] = 0;
				["setRange"] = "0";
			};
			["slot"] = 7;
			["target"] = {
			};
		};
		[82] = {
			["player"] = {
			};
			["priority"] = 81;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5661;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Murky Water";
				["radius"] = 120;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 5;
			["target"] = {
			};
		};
		[83] = {
			["player"] = {
			};
			["priority"] = 82;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5607;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Tidal Wave";
				["radius"] = 240;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 5;
			["target"] = {
			};
		};
		[84] = {
			["player"] = {
				["maxPower"] = 0;
				["minHP"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 30795;
				["isProjectile"] = "1";
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Lightning Orb";
				["radius"] = 300;
				["setRange"] = "1";
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[85] = {
			["player"] = {
				["combatState"] = "InCombat";
				["maxPower"] = 0;
				["minHP"] = 90;
			};
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 30446;
				["los"] = "0";
				["maxRange"] = 750;
				["minRange"] = 0;
				["name"] = "Water Globe";
				["radius"] = 240;
				["setRange"] = "0";
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[86] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 29533;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Wildfire";
				["radius"] = 180;
				["setRange"] = "1";
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[87] = {
			["player"] = {
			};
			["priority"] = 83;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5501;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Meteor Shower";
				["radius"] = 360;
				["setRange"] = "1";
				["slowCast"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 5;
			["target"] = {
				["maxHP"] = 10;
				["moving"] = "NotMoving";
			};
		};
		[88] = {
			["player"] = {
				["conditionCount"] = 0;
				["minHP"] = 0;
			};
			["priority"] = 84;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5522;
				["maxRange"] = 360;
				["minRange"] = 0;
				["name"] = "Churning Earth";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 5;
			["target"] = {
				["type"] = "Character";
			};
		};
		[89] = {
			["player"] = {
			};
			["priority"] = 85;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5600;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Heat Wave";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 5;
			["target"] = {
			};
		};
		[90] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 95;
			};
			["priority"] = 86;
			["skill"] = {
				["castOnSelf"] = "0";
				["groundTargeted"] = "0";
				["id"] = 5623;
				["los"] = "1";
				["maxRange"] = 200;
				["minRange"] = 0;
				["name"] = "Fortify";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 5;
			["target"] = {
			};
		};
		[91] = {
			["player"] = {
			};
			["priority"] = 87;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5721;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Deep Freeze";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 5;
			["target"] = {
				["hasNotBuffs"] = "1122,905";
				["moving"] = "Either";
				["type"] = "Character";
			};
		};
		[92] = {
			["player"] = {
			};
			["priority"] = 88;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5531;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Firestorm";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
				["stopsMovement"] = "0";
			};
			["slot"] = 5;
			["target"] = {
			};
		};
		[93] = {
			["player"] = {
			};
			["priority"] = 89;
			["skill"] = {
				["delay"] = 0;
				["groundTargeted"] = "0";
				["id"] = 5748;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Undercurrent";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 4;
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
			};
		};
		[94] = {
			["player"] = {
			};
			["priority"] = 90;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5648;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Air Bubble";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 4;
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
				["type"] = "Character";
			};
		};
		[95] = {
			["player"] = {
				["minHP"] = 0;
			};
			["priority"] = 91;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5754;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Debris Tornado";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "0";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[96] = {
			["player"] = {
				["minHP"] = 0;
			};
			["priority"] = 92;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5515;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Frozen Ground";
				["radius"] = 300;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
			};
		};
		[97] = {
			["player"] = {
			};
			["priority"] = 93;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5605;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Ice Globe";
				["radius"] = 240;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
				["enemyNearCount"] = 0;
				["enemyRangeMax"] = 0;
			};
		};
		[98] = {
			["player"] = {
			};
			["priority"] = 94;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5671;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Static Field";
				["radius"] = 180;
				["setRange"] = "1";
			};
			["slot"] = 5;
			["target"] = {
				["hasNotBuffs"] = "1122,743";
				["moving"] = "Either";
				["type"] = "Character";
			};
		};
		[99] = {
			["player"] = {
			};
			["priority"] = 95;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5552;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Lightning Surge";
				["radius"] = 180;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[100] = {
			["player"] = {
			};
			["priority"] = 96;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5529;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Ride the Lightning";
				["radius"] = 180;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
			};
		};
		[101] = {
			["player"] = {
			};
			["priority"] = 97;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5686;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Shock Wave";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 5;
			["target"] = {
			};
		};
		[102] = {
			["player"] = {
				["allyDownedNearCount"] = 0;
				["allyDownedRangeMax"] = 0;
			};
			["priority"] = 98;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5652;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Air Pocket";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[103] = {
			["player"] = {
			};
			["priority"] = 99;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5692;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Dragon's Tooth";
				["radius"] = 180;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 2;
			["target"] = {
				["moving"] = "NotMoving";
			};
		};
		[104] = {
			["player"] = {
				["minHP"] = 85;
			};
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 29415;
				["los"] = "0";
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Overload Water";
				["radius"] = 0;
				["setRange"] = "0";
				["slot"] = 13;
				["slowCast"] = "1";
				["stopsMovement"] = "1";
			};
			["target"] = {
			};
		};
		[105] = {
			["player"] = {
				["minHP"] = 85;
			};
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 29719;
				["maxRange"] = 360;
				["minRange"] = 0;
				["name"] = "Overload Air";
				["radius"] = 0;
				["setRange"] = "1";
				["slot"] = 14;
				["slowCast"] = "1";
				["stopsMovement"] = "0";
			};
			["target"] = {
			};
		};
		[106] = {
			["player"] = {
				["minHP"] = 85;
			};
			["skill"] = {
				["castOnSelf"] = "0";
				["groundTargeted"] = "0";
				["id"] = 29618;
				["los"] = "1";
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Overload Earth";
				["radius"] = 0;
				["setRange"] = "1";
				["slot"] = 15;
				["slowCast"] = "1";
			};
			["target"] = {
			};
		};
		[107] = {
			["player"] = {
				["minHP"] = 85;
			};
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 29706;
				["maxRange"] = 180;
				["minRange"] = 0;
				["name"] = "Overload Fire";
				["radius"] = 0;
				["setRange"] = "1";
				["slot"] = 12;
				["slowCast"] = "1";
			};
			["target"] = {
			};
		};
		[108] = {
			["player"] = {
				["conditionCount"] = 0;
				["minHP"] = 70;
			};
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 29968;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "\"Rebound!\"";
				["radius"] = 0;
				["setRange"] = "0";
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[109] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 29948;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "\"Flash-Freeze!\"";
				["radius"] = 0;
				["setRange"] = "0";
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[110] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 30047;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "\"Eye of the Storm!\"";
				["radius"] = 0;
				["setRange"] = "0";
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[111] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 30432;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "\"Aftershock!\"";
				["radius"] = 240;
				["setRange"] = "1";
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[112] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 30662;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "\"Feel the Burn!\"";
				["radius"] = 0;
				["setRange"] = "1";
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[113] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 90;
			};
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 29453;
				["los"] = "1";
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Sand Squall";
				["radius"] = 0;
				["setRange"] = "1";
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[114] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 30336;
				["maxRange"] = 750;
				["minRange"] = 0;
				["name"] = "Dust Storm";
				["radius"] = 180;
				["setRange"] = "1";
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[115] = {
			["player"] = {
			};
			["priority"] = 100;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5490;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Comet";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 5;
			["target"] = {
			};
		};
		[116] = {
			["player"] = {
			};
			["priority"] = 101;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5650;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Lightning Cage";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 5;
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
				["type"] = "Character";
			};
		};
		[117] = {
			["player"] = {
				["minHP"] = 0;
			};
			["priority"] = 102;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5556;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Freezing Gust";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
			};
		};
		[118] = {
			["player"] = {
			};
			["priority"] = 103;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5562;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Gale";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 5;
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
			};
		};
		[119] = {
			["player"] = {
			};
			["priority"] = 104;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5723;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Ice Storm";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 4;
			["target"] = {
				["moving"] = "NotMoving";
			};
		};
		[120] = {
			["player"] = {
			};
			["priority"] = 105;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5694;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Blinding Flash";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[121] = {
			["player"] = {
			};
			["priority"] = 106;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5719;
				["maxRange"] = 550;
				["minRange"] = 0;
				["name"] = "Flame Leap";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 5;
			["target"] = {
			};
		};
		[122] = {
			["player"] = {
			};
			["priority"] = 107;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5528;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Eruption";
				["radius"] = 300;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 2;
			["target"] = {
				["moving"] = "NotMoving";
			};
		};
		[123] = {
			["player"] = {
			};
			["priority"] = 108;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5679;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Flame Burst";
				["radius"] = 240;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[124] = {
			["player"] = {
			};
			["priority"] = 109;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5557;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Fire Grab";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 5;
			["target"] = {
			};
		};
		[125] = {
			["player"] = {
			};
			["priority"] = 110;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5732;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Static Field";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 5;
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
				["moving"] = "Moving";
			};
		};
		[126] = {
			["player"] = {
			};
			["priority"] = 111;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5659;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Rock Anchor";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
			};
		};
		[127] = {
			["player"] = {
				["minHP"] = 0;
			};
			["priority"] = 112;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5550;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Ice Spike";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[128] = {
			["player"] = {
			};
			["priority"] = 113;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5599;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Lava Chains";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
			};
		};
		[129] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["priority"] = 114;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5687;
				["maxRange"] = 180;
				["minRange"] = 0;
				["name"] = "Updraft";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 5;
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
			};
		};
		[130] = {
			["player"] = {
			};
			["priority"] = 115;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5733;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Wind Blast";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 3;
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
			};
		};
		[131] = {
			["player"] = {
				["minHP"] = 0;
			};
			["priority"] = 116;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5753;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Dust Tornado";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "0";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[132] = {
			["player"] = {
			};
			["priority"] = 117;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5517;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Fiery Rush";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
			};
		};
		[133] = {
			["player"] = {
			};
			["priority"] = 118;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5747;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Magnetic Shield";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
			};
		};
		[134] = {
			["player"] = {
			};
			["priority"] = 119;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5533;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Fiery Eruption";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[135] = {
			["player"] = {
			};
			["priority"] = 120;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5655;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Electrocute";
				["radius"] = 240;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[136] = {
			["player"] = {
			};
			["priority"] = 121;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5597;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Boil";
				["radius"] = 240;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[137] = {
			["player"] = {
			};
			["priority"] = 122;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5537;
				["maxRange"] = 400;
				["minRange"] = 0;
				["name"] = "Cone of Cold";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[138] = {
			["player"] = {
				["allyDownedNearCount"] = 0;
				["allyDownedRangeMax"] = 0;
			};
			["priority"] = 123;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5658;
				["maxRange"] = 400;
				["minRange"] = 0;
				["name"] = "Rock Spray";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[139] = {
			["player"] = {
			};
			["priority"] = 124;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5496;
				["maxRange"] = 400;
				["minRange"] = 0;
				["name"] = "Drake's Breath";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[140] = {
			["player"] = {
			};
			["priority"] = 125;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5530;
				["maxRange"] = 400;
				["minRange"] = 0;
				["name"] = "Swirling Winds";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
			};
		};
		[141] = {
			["player"] = {
			};
			["priority"] = 126;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5725;
				["maxRange"] = 360;
				["minRange"] = 0;
				["name"] = "Lightning Storm";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
			};
		};
		[142] = {
			["player"] = {
				["combatState"] = "InCombat";
				["maxPower"] = 0;
			};
			["skill"] = {
				["castOnSelf"] = "1";
				["groundTargeted"] = "0";
				["id"] = 29548;
				["los"] = "0";
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Heat Sync";
				["radius"] = 0;
				["setRange"] = "0";
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[143] = {
			["player"] = {
			};
			["priority"] = 127;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5555;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Magnetic Wave";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
			};
		};
		[144] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 30864;
				["maxRange"] = 360;
				["minRange"] = 0;
				["name"] = "Tidal Surge";
				["radius"] = 0;
				["setRange"] = "1";
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[145] = {
			["player"] = {
				["conditionCount"] = 0;
			};
			["priority"] = 144;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5717;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Burning Retreat";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
				["moving"] = "Moving";
				["type"] = "Character";
			};
		};
		[146] = {
			["player"] = {
			};
			["priority"] = 129;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5718;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Ring of Fire";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
				["moving"] = "Moving";
			};
		};
		[147] = {
			["player"] = {
			};
			["priority"] = 130;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5690;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Earthquake";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
			};
		};
		[148] = {
			["player"] = {
			};
			["priority"] = 131;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 21647;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Stone Sheath";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
				["stopsMovement"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[149] = {
			["player"] = {
			};
			["priority"] = 132;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5691;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Ring of Fire";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
				["moving"] = "Moving";
			};
		};
		[150] = {
			["player"] = {
			};
			["priority"] = 133;
			["skill"] = {
				["delay"] = 1200;
				["groundTargeted"] = "0";
				["id"] = 5653;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Vacuum";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[151] = {
			["player"] = {
			};
			["priority"] = 134;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5553;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Gust";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
			};
		};
		[152] = {
			["player"] = {
			};
			["priority"] = 135;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5566;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Steam";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[153] = {
			["player"] = {
			};
			["priority"] = 136;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5683;
				["maxRange"] = 1175;
				["minRange"] = 0;
				["name"] = "Unsteady Ground";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
				["moving"] = "Moving";
			};
		};
		[154] = {
			["player"] = {
			};
			["priority"] = 137;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5559;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Magnetic Grasp";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[155] = {
			["player"] = {
			};
			["priority"] = 138;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5662;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Magnetic Current";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[156] = {
			["player"] = {
			};
			["priority"] = 139;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5497;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Flamewall";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
				["moving"] = "Either";
			};
		};
		[157] = {
			["player"] = {
			};
			["priority"] = 140;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5505;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Grasping Earth";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[158] = {
			["player"] = {
			};
			["priority"] = 141;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5696;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Dust Devil";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[159] = {
			["player"] = {
			};
			["priority"] = 142;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5568;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Frost Fan";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[160] = {
			["player"] = {
				["minHP"] = 0;
			};
			["priority"] = 143;
			["skill"] = {
				["castOnSelf"] = "0";
				["groundTargeted"] = "1";
				["id"] = 5538;
				["los"] = "1";
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Shatterstone";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
				["moving"] = "NotMoving";
			};
		};
		[161] = {
			["player"] = {
			};
			["priority"] = 144;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 17008;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Magnetic Leap";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[162] = {
			["player"] = {
			};
			["priority"] = 145;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5547;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Magnetic Surge";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
			};
		};
		[163] = {
			["player"] = {
			};
			["priority"] = 146;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5548;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Lava Font";
				["radius"] = 180;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[164] = {
			["player"] = {
			};
			["priority"] = 147;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5606;
				["maxRange"] = 320;
				["minRange"] = 0;
				["name"] = "Ice Wall";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[165] = {
			["player"] = {
			};
			["priority"] = 148;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5644;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Burning Speed";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[166] = {
			["player"] = {
			};
			["priority"] = 149;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5487;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Frozen Burst";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[167] = {
			["player"] = {
				["maxPower"] = 0;
				["minHP"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 30008;
				["maxRange"] = 750;
				["minRange"] = 0;
				["name"] = "Cyclone";
				["radius"] = 240;
				["setRange"] = "1";
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[168] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["priority"] = 150;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5680;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Burning Retreat";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 4;
			["target"] = {
				["moving"] = "Moving";
				["type"] = "Character";
			};
		};
		[169] = {
			["player"] = {
			};
			["priority"] = 151;
			["skill"] = {
				["delay"] = 2000;
				["groundTargeted"] = "0";
				["id"] = 5611;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Ice Globe";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[170] = {
			["player"] = {
			};
			["priority"] = 152;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5593;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Explosive Lava Axe";
				["radius"] = 240;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[171] = {
			["player"] = {
			};
			["priority"] = 153;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5561;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Lightning Strike";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[172] = {
			["player"] = {
			};
			["priority"] = 154;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5780;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Hurl";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[173] = {
			["player"] = {
			};
			["priority"] = 155;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5697;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Fiery Whirl";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[174] = {
			["player"] = {
			};
			["priority"] = 156;
			["skill"] = {
				["groundTargeted"] = "1";
				["id"] = 5675;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Phoenix";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 3;
			["target"] = {
			};
		};
		[175] = {
			["player"] = {
			};
			["priority"] = 157;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5720;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Frost Volley";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[176] = {
			["player"] = {
			};
			["priority"] = 158;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5609;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Stone Kick";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[177] = {
			["player"] = {
			};
			["priority"] = 159;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5625;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Lightning Leap";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[178] = {
			["player"] = {
			};
			["priority"] = 160;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5646;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Lightning Touch";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[179] = {
			["player"] = {
			};
			["priority"] = 161;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5525;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Ring of Earth";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 2;
			["target"] = {
			};
		};
		[180] = {
			["player"] = {
				["conditionCount"] = 0;
			};
			["priority"] = 162;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5491;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Fireball";
				["radius"] = 180;
				["setRange"] = "1";
				["slowCast"] = "0";
			};
			["slot"] = 1;
			["target"] = {
				["conditionCount"] = 0;
			};
		};
		[181] = {
			["player"] = {
			};
			["priority"] = 163;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5549;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Water Blast";
				["radius"] = 240;
				["setRange"] = "1";
				["slowCast"] = "0";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[182] = {
			["player"] = {
				["allyDownedNearCount"] = 0;
				["allyDownedRangeMax"] = 0;
			};
			["priority"] = 164;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5598;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Magma Orb";
				["radius"] = 120;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[183] = {
			["player"] = {
			};
			["priority"] = 165;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5518;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Chain Lightning";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "0";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[184] = {
			["player"] = {
			};
			["priority"] = 166;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5519;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Stoning";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "0";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[185] = {
			["player"] = {
			};
			["priority"] = 167;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5500;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Stone Shards";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[186] = {
			["player"] = {
			};
			["priority"] = 168;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5526;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Arc Lightning";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[187] = {
			["player"] = {
			};
			["priority"] = 169;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5532;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Flame Wave";
				["radius"] = 0;
				["setRange"] = "1";
				["slowCast"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[188] = {
			["player"] = {
				["minHP"] = 0;
			};
			["priority"] = 170;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 15718;
				["maxRange"] = 400;
				["minRange"] = 0;
				["name"] = "Dragon's Claw";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[189] = {
			["player"] = {
			};
			["priority"] = 171;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5657;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Rock Blade";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[190] = {
			["player"] = {
			};
			["priority"] = 172;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5604;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Water Missile";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[191] = {
			["player"] = {
			};
			["priority"] = 173;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5656;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Forked Lightning";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[192] = {
			["player"] = {
			};
			["priority"] = 174;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5504;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Discharge Lightning";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[193] = {
			["player"] = {
			};
			["priority"] = 175;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5595;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Water Arrow";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[194] = {
			["player"] = {
			};
			["priority"] = 176;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5508;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Flamestrike";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[195] = {
			["player"] = {
			};
			["priority"] = 177;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5541;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Lava Axe";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[196] = {
			["player"] = {
			};
			["priority"] = 178;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5693;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Ice Shards";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[197] = {
			["player"] = {
			};
			["priority"] = 179;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5752;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Electrified Tornado";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[198] = {
			["player"] = {
			};
			["priority"] = 180;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5608;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Water Fist";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[199] = {
			["player"] = {
			};
			["priority"] = 181;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 15716;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Vapor Blade";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[200] = {
			["player"] = {
			};
			["priority"] = 182;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 15717;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Impale";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[201] = {
			["player"] = {
			};
			["priority"] = 183;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5489;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Lightning Whip";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[202] = {
			["player"] = {
			};
			["priority"] = 184;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5726;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Lightning Swing";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
		[203] = {
			["player"] = {
			};
			["priority"] = 185;
			["skill"] = {
				["groundTargeted"] = "0";
				["id"] = 5621;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Shield Smack";
				["radius"] = 0;
				["setRange"] = "1";
			};
			["slot"] = 1;
			["target"] = {
			};
		};
	};
	["switchSettings"] = {
		["switchOnCooldown"] = 0;
		["switchOnRange"] = "0";
		["switchRandom"] = "1";
	};
}
return obj1
