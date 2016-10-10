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
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5503;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Signet of Restoration";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 6;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[2] = {
			["player"] = {
				["maxPower"] = 0;
				["minHP"] = 75;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 29535;
				["los"] = false;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "\"Wash the Pain Away!\"";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 0;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[3] = {
			["player"] = {
				["minHP"] = 95;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5507;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Ether Renewal";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 6;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[4] = {
			["player"] = {
				["minHP"] = 70;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5569;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Glyph of Elemental Harmony";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 6;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[5] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 75;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 21656;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Arcane Brilliance";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 6;
			};
			["target"] = {
			};
		};
		[6] = {
			["player"] = {
				["combatState"] = "Either";
				["minHP"] = 20;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["delay"] = 0;
				["groundTargeted"] = false;
				["id"] = 10700;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Leave Transform";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 10;
			};
			["target"] = {
			};
		};
		[7] = {
			["player"] = {
				["conditionCount"] = 1;
				["minHP"] = 0;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 25492;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Crashing Waves";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 10;
			};
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
			["skill"] = {
				["castOnSelf"] = false;
				["groundTargeted"] = false;
				["id"] = 25499;
				["los"] = true;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Flame Barrage";
				["radius"] = 360;
				["setRange"] = false;
				["slot"] = 10;
			};
			["target"] = {
			};
		};
		[9] = {
			["player"] = {
				["minHP"] = 10;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = true;
				["id"] = 5762;
				["los"] = true;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Renewal of Fire";
				["radius"] = 180;
				["setRange"] = false;
				["slot"] = 7;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[10] = {
			["player"] = {
				["hasBuffs"] = "872,833";
				["maxHP"] = 0;
				["minHP"] = 0;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5572;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Signet of Air";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
			};
			["target"] = {
				["minHP"] = 0;
			};
		};
		[11] = {
			["player"] = {
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = true;
				["id"] = 5761;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Renewal of Earth";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 8;
				["slowCast"] = true;
			};
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
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5639;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Armor of Earth";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[13] = {
			["player"] = {
				["allyDownedNearCount"] = 1;
				["allyDownedRangeMax"] = 900;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 24410;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Renewal of Water";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[14] = {
			["player"] = {
				["allyDownedNearCount"] = 1;
				["allyDownedRangeMax"] = 900;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 24407;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Renewal of Fire";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
				["slowCast"] = true;
			};
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
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5554;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Mist Form";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[16] = {
			["player"] = {
				["allyDownedNearCount"] = 1;
				["allyDownedRangeMax"] = 900;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = true;
				["id"] = 5763;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Renewal of Water";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 8;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[17] = {
			["player"] = {
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = true;
				["id"] = 5760;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Renewal of Air";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 8;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[18] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 0;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5635;
				["los"] = true;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Arcane Power";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 8;
			};
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
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5554;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Mist Form";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[20] = {
			["player"] = {
				["conditionCount"] = 2;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5535;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Cleansing Fire";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[21] = {
			["player"] = {
				["hasNotBuffs"] = "719";
				["minHP"] = 0;
				["moving"] = "Moving";
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 25478;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Windborne Speed";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[22] = {
			["player"] = {
				["allyDownedNearCount"] = 1;
				["allyDownedRangeMax"] = 900;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 24409;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Renewal of Air";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[23] = {
			["player"] = {
				["combatState"] = "InCombat";
				["conditionCount"] = 0;
				["minHP"] = 80;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5639;
				["los"] = true;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Armor of Earth";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[24] = {
			["player"] = {
				["combatState"] = "Either";
				["hasBuffs"] = "872,833";
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5506;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Glyph of Elemental Power";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[25] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 60;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5641;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Arcane Shield";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[26] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5506;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Glyph of Elemental Power";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[27] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5695;
				["los"] = true;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Rock Barrier";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 2;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[28] = {
			["player"] = {
			};
			["skill"] = {
				["castOnSelf"] = true;
				["delay"] = 0;
				["groundTargeted"] = false;
				["id"] = 5610;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Steam Vent";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 3;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[29] = {
			["player"] = {
				["conditionCount"] = 1;
				["minHP"] = 0;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5558;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Cleansing Wave";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[30] = {
			["player"] = {
				["combatState"] = "InCombat";
				["conditionCount"] = 0;
				["minHP"] = 50;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5521;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Obsidian Flesh";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[31] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 70;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5678;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Fire Shield";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[32] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 90;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5558;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Cleansing Wave";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[33] = {
			["player"] = {
				["conditionCount"] = 2;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5555;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Magnetic Wave";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[34] = {
			["player"] = {
				["combatState"] = "InCombat";
				["conditionCount"] = 1;
				["minHP"] = 90;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = true;
				["id"] = 5551;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Healing Rain";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[35] = {
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
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[36] = {
			["player"] = {
				["allyDownedNearCount"] = 0;
				["allyDownedRangeMax"] = 0;
				["moving"] = "Moving";
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5682;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Windborne Speed";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[37] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5685;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Magnetic Aura";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 3;
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
				["groundTargeted"] = false;
				["id"] = 5520;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Frost Aura";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 4;
			};
			["target"] = {
				["type"] = "Either";
			};
		};
		[39] = {
			["player"] = {
			};
			["skill"] = {
				["castOnSelf"] = true;
				["delay"] = 5000;
				["groundTargeted"] = false;
				["id"] = 5614;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Detonate";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 3;
			};
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
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = true;
				["id"] = 5510;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Water Trident";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[41] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5527;
				["los"] = true;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Shocking Aura";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[42] = {
			["player"] = {
				["minHP"] = 85;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = true;
				["id"] = 5681;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Geyser";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[43] = {
			["player"] = {
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5564;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Vapor Form";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[44] = {
			["player"] = {
				["minHP"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5746;
				["lastSkillID"] = 21646;
				["maxRange"] = 450;
				["minRange"] = 0;
				["name"] = "Crippling Shield";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[45] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5728;
				["lastSkillID"] = 5727;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Thunderclap";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[46] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5727;
				["lastSkillID"] = 5726;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Static Swing";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[47] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 21646;
				["lastSkillID"] = 5621;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Shield Smash";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[48] = {
			["player"] = {
				["combatState"] = "InCombat";
				["conditionCount"] = 2;
				["minHP"] = 40;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5493;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Water Attunement";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 14;
			};
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
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 5494;
				["los"] = false;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Air Attunement";
				["radius"] = 0;
				["setRange"] = false;
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
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 25488;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Glyph of Elementals";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 10;
				["slowCast"] = true;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[51] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5516;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Conjure Fiery Greatsword";
				["radius"] = 150;
				["setRange"] = true;
				["slot"] = 10;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[52] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 25490;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Glyph of Elementals";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 10;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[53] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 25489;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Glyph of Elementals";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 10;
				["slowCast"] = true;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[54] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 25491;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Glyph of Elementals";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 10;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[55] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5602;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Whirlpool";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 10;
				["slowCast"] = true;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[56] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 25498;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Stomp";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 10;
			};
			["target"] = {
			};
		};
		[57] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 25480;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Shocking Bolt";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 10;
			};
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
				["type"] = "Character";
			};
		};
		[58] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5534;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Tornado";
				["radius"] = 240;
				["setRange"] = true;
				["slot"] = 10;
				["slowCast"] = true;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[59] = {
			["player"] = {
				["conditionCount"] = 0;
				["minHP"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5738;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Sandstorm";
				["radius"] = 240;
				["setRange"] = true;
				["slot"] = 7;
				["slowCast"] = true;
			};
			["target"] = {
				["moving"] = "NotMoving";
				["type"] = "Character";
			};
		};
		[60] = {
			["player"] = {
				["minHP"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5736;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Firestorm";
				["radius"] = 240;
				["setRange"] = true;
				["slot"] = 7;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[61] = {
			["player"] = {
				["maxHP"] = 80;
				["minHP"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5572;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Signet of Air";
				["radius"] = 240;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
				["minHP"] = 20;
				["moving"] = "Moving";
				["type"] = "Character";
			};
		};
		[62] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 25497;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Glyph of Lesser Elementals";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[63] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 25495;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Glyph of Lesser Elementals";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[64] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 25486;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Glyph of Lesser Elementals";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[65] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 25487;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Glyph of Lesser Elementals";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[66] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5735;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Ice Storm";
				["radius"] = 240;
				["setRange"] = true;
				["slot"] = 7;
				["slowCast"] = true;
			};
			["target"] = {
				["moving"] = "NotMoving";
			};
		};
		[67] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5737;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Lightning Storm";
				["radius"] = 240;
				["setRange"] = true;
				["slot"] = 7;
				["slowCast"] = true;
			};
			["target"] = {
				["moving"] = "NotMoving";
			};
		};
		[68] = {
			["player"] = {
				["allyDownedNearCount"] = 0;
				["allyDownedRangeMax"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 22572;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Arcane Wave";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[69] = {
			["player"] = {
				["minHP"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5638;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Arcane Wave";
				["radius"] = 360;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[70] = {
			["player"] = {
				["maxHP"] = 80;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5571;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Signet of Earth";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
			};
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
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5570;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Signet of Water";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
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
			["skill"] = {
				["castOnSelf"] = false;
				["groundTargeted"] = false;
				["id"] = 5542;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Signet of Fire";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[73] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5539;
				["maxRange"] = 1500;
				["minRange"] = 0;
				["name"] = "Arcane Blast";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[74] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 25494;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Enervating Punch";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[75] = {
			["player"] = {
				["minHP"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5540;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Conjure Flame Axe";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[76] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5536;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Lightning Flash";
				["radius"] = 120;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[77] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5567;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Conjure Frost Bow";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[78] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5546;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Conjure Earth Shield";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[79] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5624;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Conjure Lightning Hammer";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[80] = {
			["player"] = {
				["allyDownedNearCount"] = 1;
				["allyDownedRangeMax"] = 900;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 24411;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Renewal of Earth";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[81] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 25476;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Frozen Ground";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 7;
			};
			["target"] = {
			};
		};
		[82] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5661;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Murky Water";
				["radius"] = 120;
				["setRange"] = true;
				["slot"] = 5;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[83] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5607;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Tidal Wave";
				["radius"] = 240;
				["setRange"] = true;
				["slot"] = 5;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[84] = {
			["player"] = {
				["maxPower"] = 0;
				["minHP"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 30795;
				["isProjectile"] = true;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Lightning Orb";
				["radius"] = 300;
				["setRange"] = true;
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
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 30446;
				["los"] = false;
				["maxRange"] = 750;
				["minRange"] = 0;
				["name"] = "Water Globe";
				["radius"] = 240;
				["setRange"] = false;
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
				["groundTargeted"] = false;
				["id"] = 29533;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Wildfire";
				["radius"] = 180;
				["setRange"] = true;
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[87] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5501;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Meteor Shower";
				["radius"] = 360;
				["setRange"] = true;
				["slot"] = 5;
				["slowCast"] = true;
				["stopsMovement"] = true;
			};
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
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5522;
				["maxRange"] = 360;
				["minRange"] = 0;
				["name"] = "Churning Earth";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
				["slowCast"] = true;
			};
			["target"] = {
				["type"] = "Character";
			};
		};
		[89] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5600;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Heat Wave";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[90] = {
			["player"] = {
				["combatState"] = "InCombat";
				["minHP"] = 95;
			};
			["skill"] = {
				["castOnSelf"] = false;
				["groundTargeted"] = false;
				["id"] = 5623;
				["los"] = true;
				["maxRange"] = 200;
				["minRange"] = 0;
				["name"] = "Fortify";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
				["slowCast"] = true;
				["stopsMovement"] = true;
			};
			["target"] = {
			};
		};
		[91] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5721;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Deep Freeze";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
				["slowCast"] = true;
				["stopsMovement"] = true;
			};
			["target"] = {
				["hasNotBuffs"] = "1122,905";
				["moving"] = "Either";
				["type"] = "Character";
			};
		};
		[92] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5531;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Firestorm";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
				["slowCast"] = true;
				["stopsMovement"] = false;
			};
			["target"] = {
			};
		};
		[93] = {
			["player"] = {
			};
			["skill"] = {
				["delay"] = 0;
				["groundTargeted"] = false;
				["id"] = 5748;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Undercurrent";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
				["slowCast"] = true;
				["stopsMovement"] = true;
			};
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
			};
		};
		[94] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5648;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Air Bubble";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
				["slowCast"] = true;
			};
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
				["type"] = "Character";
			};
		};
		[95] = {
			["player"] = {
				["minHP"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5754;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Debris Tornado";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
				["slowCast"] = false;
			};
			["target"] = {
			};
		};
		[96] = {
			["player"] = {
				["minHP"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5515;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Frozen Ground";
				["radius"] = 300;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[97] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5605;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Ice Globe";
				["radius"] = 240;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
				["enemyNearCount"] = 0;
				["enemyRangeMax"] = 0;
			};
		};
		[98] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5671;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Static Field";
				["radius"] = 180;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
				["hasNotBuffs"] = "1122,743";
				["moving"] = "Either";
				["type"] = "Character";
			};
		};
		[99] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5552;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Lightning Surge";
				["radius"] = 180;
				["setRange"] = true;
				["slot"] = 2;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[100] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5529;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Ride the Lightning";
				["radius"] = 180;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[101] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5686;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Shock Wave";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[102] = {
			["player"] = {
				["allyDownedNearCount"] = 0;
				["allyDownedRangeMax"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5652;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Air Pocket";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[103] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5692;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Dragon's Tooth";
				["radius"] = 180;
				["setRange"] = true;
				["slot"] = 2;
				["slowCast"] = true;
			};
			["target"] = {
				["moving"] = "NotMoving";
			};
		};
		[104] = {
			["player"] = {
				["minHP"] = 85;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 29415;
				["los"] = false;
				["maxRange"] = 0;
				["minRange"] = 0;
				["name"] = "Overload Water";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 13;
				["slowCast"] = true;
				["stopsMovement"] = true;
			};
			["target"] = {
			};
		};
		[105] = {
			["player"] = {
				["minHP"] = 85;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 29719;
				["maxRange"] = 360;
				["minRange"] = 0;
				["name"] = "Overload Air";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 14;
				["slowCast"] = true;
				["stopsMovement"] = false;
			};
			["target"] = {
			};
		};
		[106] = {
			["player"] = {
				["minHP"] = 85;
			};
			["skill"] = {
				["castOnSelf"] = false;
				["groundTargeted"] = false;
				["id"] = 29618;
				["los"] = true;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Overload Earth";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 15;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[107] = {
			["player"] = {
				["minHP"] = 85;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 29706;
				["maxRange"] = 180;
				["minRange"] = 0;
				["name"] = "Overload Fire";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 12;
				["slowCast"] = true;
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
				["groundTargeted"] = false;
				["id"] = 29968;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "\"Rebound!\"";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[109] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 29948;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "\"Flash-Freeze!\"";
				["radius"] = 0;
				["setRange"] = false;
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
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 30047;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "\"Eye of the Storm!\"";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[111] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 30432;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "\"Aftershock!\"";
				["radius"] = 240;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[112] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 30662;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "\"Feel the Burn!\"";
				["radius"] = 0;
				["setRange"] = true;
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
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 29453;
				["los"] = true;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Sand Squall";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[114] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 30336;
				["maxRange"] = 750;
				["minRange"] = 0;
				["name"] = "Dust Storm";
				["radius"] = 180;
				["setRange"] = true;
				["slot"] = 9;
			};
			["target"] = {
			};
		};
		[115] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5490;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Comet";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[116] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5650;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Lightning Cage";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
				["type"] = "Character";
			};
		};
		[117] = {
			["player"] = {
				["minHP"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5556;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Freezing Gust";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[118] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5562;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Gale";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
			};
		};
		[119] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5723;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Ice Storm";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
				["slowCast"] = true;
				["stopsMovement"] = true;
			};
			["target"] = {
				["moving"] = "NotMoving";
			};
		};
		[120] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5694;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Blinding Flash";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[121] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5719;
				["maxRange"] = 550;
				["minRange"] = 0;
				["name"] = "Flame Leap";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[122] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5528;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Eruption";
				["radius"] = 300;
				["setRange"] = true;
				["slot"] = 2;
				["slowCast"] = true;
			};
			["target"] = {
				["moving"] = "NotMoving";
			};
		};
		[123] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5679;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Flame Burst";
				["radius"] = 240;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[124] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5557;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Fire Grab";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
			};
		};
		[125] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5732;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Static Field";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
				["moving"] = "Moving";
			};
		};
		[126] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5659;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Rock Anchor";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
			};
		};
		[127] = {
			["player"] = {
				["minHP"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5550;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Ice Spike";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[128] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5599;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Lava Chains";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
			};
		};
		[129] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5687;
				["maxRange"] = 180;
				["minRange"] = 0;
				["name"] = "Updraft";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 5;
			};
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
			};
		};
		[130] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5733;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Wind Blast";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
				["slowCast"] = true;
			};
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
			};
		};
		[131] = {
			["player"] = {
				["minHP"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5753;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Dust Tornado";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
				["slowCast"] = false;
			};
			["target"] = {
			};
		};
		[132] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5517;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Fiery Rush";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[133] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5747;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Magnetic Shield";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[134] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5533;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Fiery Eruption";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
				["slowCast"] = true;
				["stopsMovement"] = true;
			};
			["target"] = {
			};
		};
		[135] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5655;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Electrocute";
				["radius"] = 240;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[136] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5597;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Boil";
				["radius"] = 240;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[137] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5537;
				["maxRange"] = 400;
				["minRange"] = 0;
				["name"] = "Cone of Cold";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[138] = {
			["player"] = {
				["allyDownedNearCount"] = 0;
				["allyDownedRangeMax"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5658;
				["maxRange"] = 400;
				["minRange"] = 0;
				["name"] = "Rock Spray";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[139] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5496;
				["maxRange"] = 400;
				["minRange"] = 0;
				["name"] = "Drake's Breath";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[140] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5530;
				["maxRange"] = 400;
				["minRange"] = 0;
				["name"] = "Swirling Winds";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[141] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5725;
				["maxRange"] = 360;
				["minRange"] = 0;
				["name"] = "Lightning Storm";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[142] = {
			["player"] = {
				["combatState"] = "InCombat";
				["maxPower"] = 0;
			};
			["skill"] = {
				["castOnSelf"] = true;
				["groundTargeted"] = false;
				["id"] = 29548;
				["los"] = false;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Heat Sync";
				["radius"] = 0;
				["setRange"] = false;
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[143] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5555;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Magnetic Wave";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
			};
		};
		[144] = {
			["player"] = {
				["maxPower"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 30864;
				["maxRange"] = 360;
				["minRange"] = 0;
				["name"] = "Tidal Surge";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[145] = {
			["player"] = {
				["conditionCount"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5717;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Burning Retreat";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
				["moving"] = "Moving";
				["type"] = "Character";
			};
		};
		[146] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5718;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Ring of Fire";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
				["moving"] = "Moving";
			};
		};
		[147] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5690;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Earthquake";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
			};
		};
		[148] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 21647;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Stone Sheath";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
				["slowCast"] = true;
				["stopsMovement"] = true;
			};
			["target"] = {
			};
		};
		[149] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5691;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Ring of Fire";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
				["moving"] = "Moving";
			};
		};
		[150] = {
			["player"] = {
			};
			["skill"] = {
				["delay"] = 1200;
				["groundTargeted"] = false;
				["id"] = 5653;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Vacuum";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[151] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5553;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Gust";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
			};
		};
		[152] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5566;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Steam";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[153] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5683;
				["maxRange"] = 1175;
				["minRange"] = 0;
				["name"] = "Unsteady Ground";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
				["moving"] = "Moving";
			};
		};
		[154] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5559;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Magnetic Grasp";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[155] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5662;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Magnetic Current";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[156] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5497;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Flamewall";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
				["moving"] = "Either";
			};
		};
		[157] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5505;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Grasping Earth";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[158] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5696;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Dust Devil";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[159] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5568;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Frost Fan";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[160] = {
			["player"] = {
				["minHP"] = 0;
			};
			["skill"] = {
				["castOnSelf"] = false;
				["groundTargeted"] = true;
				["id"] = 5538;
				["los"] = true;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Shatterstone";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
				["moving"] = "NotMoving";
			};
		};
		[161] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 17008;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Magnetic Leap";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[162] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5547;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Magnetic Surge";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
				["hasNotBuffs"] = "1122,906,905";
			};
		};
		[163] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5548;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Lava Font";
				["radius"] = 180;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[164] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5606;
				["maxRange"] = 320;
				["minRange"] = 0;
				["name"] = "Ice Wall";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[165] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5644;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Burning Speed";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[166] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5487;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Frozen Burst";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[167] = {
			["player"] = {
				["maxPower"] = 0;
				["minHP"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 30008;
				["maxRange"] = 750;
				["minRange"] = 0;
				["name"] = "Cyclone";
				["radius"] = 240;
				["setRange"] = true;
				["slot"] = 8;
			};
			["target"] = {
			};
		};
		[168] = {
			["player"] = {
				["combatState"] = "InCombat";
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5680;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Burning Retreat";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 4;
			};
			["target"] = {
				["moving"] = "Moving";
				["type"] = "Character";
			};
		};
		[169] = {
			["player"] = {
			};
			["skill"] = {
				["delay"] = 2000;
				["groundTargeted"] = false;
				["id"] = 5611;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Ice Globe";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[170] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5593;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Explosive Lava Axe";
				["radius"] = 240;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[171] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5561;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Lightning Strike";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[172] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5780;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Hurl";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[173] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5697;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Fiery Whirl";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[174] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = true;
				["id"] = 5675;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Phoenix";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 3;
			};
			["target"] = {
			};
		};
		[175] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5720;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Frost Volley";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[176] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5609;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Stone Kick";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[177] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5625;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Lightning Leap";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[178] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5646;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Lightning Touch";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[179] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5525;
				["maxRange"] = 240;
				["minRange"] = 0;
				["name"] = "Ring of Earth";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 2;
			};
			["target"] = {
			};
		};
		[180] = {
			["player"] = {
				["conditionCount"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5491;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Fireball";
				["radius"] = 180;
				["setRange"] = true;
				["slot"] = 1;
				["slowCast"] = false;
			};
			["target"] = {
				["conditionCount"] = 0;
			};
		};
		[181] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5549;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Water Blast";
				["radius"] = 240;
				["setRange"] = true;
				["slot"] = 1;
				["slowCast"] = false;
			};
			["target"] = {
			};
		};
		[182] = {
			["player"] = {
				["allyDownedNearCount"] = 0;
				["allyDownedRangeMax"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5598;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Magma Orb";
				["radius"] = 120;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[183] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5518;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Chain Lightning";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
				["slowCast"] = false;
			};
			["target"] = {
			};
		};
		[184] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5519;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Stoning";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
				["slowCast"] = false;
			};
			["target"] = {
			};
		};
		[185] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5500;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Stone Shards";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[186] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5526;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Arc Lightning";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[187] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5532;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Flame Wave";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
				["slowCast"] = true;
			};
			["target"] = {
			};
		};
		[188] = {
			["player"] = {
				["minHP"] = 0;
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 15718;
				["maxRange"] = 400;
				["minRange"] = 0;
				["name"] = "Dragon's Claw";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[189] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5657;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Rock Blade";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[190] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5604;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Water Missile";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[191] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5656;
				["maxRange"] = 1200;
				["minRange"] = 0;
				["name"] = "Forked Lightning";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[192] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5504;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Discharge Lightning";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[193] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5595;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Water Arrow";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[194] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5508;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Flamestrike";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[195] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5541;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Lava Axe";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[196] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5693;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Ice Shards";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[197] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5752;
				["maxRange"] = 900;
				["minRange"] = 0;
				["name"] = "Electrified Tornado";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[198] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5608;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Water Fist";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[199] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 15716;
				["maxRange"] = 600;
				["minRange"] = 0;
				["name"] = "Vapor Blade";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[200] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 15717;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Impale";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[201] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5489;
				["maxRange"] = 300;
				["minRange"] = 0;
				["name"] = "Lightning Whip";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[202] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5726;
				["maxRange"] = 150;
				["minRange"] = 0;
				["name"] = "Lightning Swing";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
		[203] = {
			["player"] = {
			};
			["skill"] = {
				["groundTargeted"] = false;
				["id"] = 5621;
				["maxRange"] = 130;
				["minRange"] = 0;
				["name"] = "Shield Smack";
				["radius"] = 0;
				["setRange"] = true;
				["slot"] = 1;
			};
			["target"] = {
			};
		};
	};
	["switchSettings"] = {
		["switchWeapons"] = true;
	};
}
return obj1
