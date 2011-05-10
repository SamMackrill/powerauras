
PowaSet = {
	[0] = {
		["gcd"] = false,
		["b"] = 1,
		["anim1"] = 1,
		["g"] = 1,
		["optunitn"] = false,
		["ignoremaj"] = true,
		["opt2"] = 0,
		["target"] = false,
		["icon"] = "",
		["size"] = 0.75,
		["buffname"] = "",
		["r"] = 1,
		["y"] = -30,
		["x"] = 0,
		["customname"] = "",
		["groupany"] = true,
		["timerduration"] = 0,
		["unitn"] = "",
		["bufftype"] = 1,
		["stacks"] = 0,
		["focus"] = false,
		["isenchant"] = false,
		["raid"] = false,
		["texture"] = 1,
		["alpha"] = 0.75,
		["aurastext"] = "",
		["symetrie"] = 0,
		["Timer"] = {
			["y"] = 0,
			["x"] = 0,
			["dual"] = false,
			["cents"] = true,
			["id"] = 0,
			["h"] = 1,
			["a"] = 1,
			["enabled"] = false,
		},
		["opt1"] = 0,
		["owntex"] = false,
		["duration"] = 0,
		["mine"] = false,
		["multiids"] = "",
		["speed"] = 1,
		["anim2"] = 0,
		["stacksOperator"] = ">=",
		["realaura"] = 1,
		["threshold"] = 50,
		["exact"] = false,
		["textaura"] = false,
		["wowtex"] = false,
		["groupOrSelf"] = false,
		["customsound"] = "",
		["combat"] = 0,
		["aurastextfont"] = 1,
		["tooltipCheck"] = "",
		["soundfile"] = "",
		["customtex"] = false,
		["thresholdinvert"] = false,
		["isdebufftype"] = false,
		["stance"] = 10,
		["spec2"] = true,
		["spec1"] = true,
		["torsion"] = 1,
		["begin"] = 0,
		["id"] = 0,
		["off"] = false,
		["party"] = false,
		["sound"] = 0,
		["isdebuff"] = false,
		["texmode"] = 1,
		["inverse"] = false,
		["ismounted"] = false,
		["targetfriend"] = false,
		["randomcolor"] = false,
		["isinraid"] = false,
		["finish"] = 1,
	},
}
PowaMisc = {
}
PowaTimer = {
}
PowaPlayerListe = {
	"Page 1", -- [1]
	"Page 2", -- [2]
	"Page 3", -- [3]
	"Page 4", -- [4]
	"Page 5", -- [5]
}
PowaState = {
	["Inventory"] = {
		["ItemCooldown"] = {
			0, -- [1]
			0, -- [2]
			0, -- [3]
			0, -- [4]
			0, -- [5]
			0, -- [6]
			0, -- [7]
			0, -- [8]
			0, -- [9]
			0, -- [10]
			0, -- [11]
			0, -- [12]
			0, -- [13]
			0, -- [14]
			0, -- [15]
			0, -- [16]
			0, -- [17]
			0, -- [18]
			0, -- [19]
			0, -- [20]
			0, -- [21]
			0, -- [22]
			0, -- [23]
			[0] = 0,
		},
		["ItemLink"] = {
			[16] = "|cffffffff|Hitem:2092:0:0:0:0:0:0:0:1|h[Worn Dagger]|h|r",
			[7] = "|cff9d9d9d|Hitem:6137:0:0:0:0:0:0:0:1|h[Thug Pants]|h|r",
			[18] = "|cffffffff|Hitem:25861:0:0:0:0:0:0:0:1|h[Crude Throwing Axe]|h|r",
			[4] = "|cffffffff|Hitem:6136:0:0:0:0:0:0:0:1|h[Thug Shirt]|h|r",
			[8] = "|cffffffff|Hitem:6138:0:0:0:0:0:0:0:1|h[Thug Boots]|h|r",
		},
		["Slot"] = {
			{
				["Id"] = 1,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "HeadSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Head.blp",
			}, -- [1]
			{
				["Id"] = 2,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "NeckSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Neck.blp",
			}, -- [2]
			{
				["Id"] = 3,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "ShoulderSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Shoulder.blp",
			}, -- [3]
			{
				["Id"] = 4,
				["Tooltip"] = {
					["Left1"] = "Thug Shirt",
					["NumLines"] = 2,
					["Left2"] = "Shirt",
				},
				["Slot"] = "ShirtSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Shirt.blp",
			}, -- [4]
			{
				["Id"] = 5,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "ChestSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Chest.blp",
			}, -- [5]
			{
				["Id"] = 6,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "WaistSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Waist.blp",
			}, -- [6]
			{
				["Id"] = 7,
				["Tooltip"] = {
					["Left1"] = "Thug Pants",
					["Left2"] = "Legs",
					["Left3"] = "2 Armor",
					["Right2"] = "Cloth",
					["NumLines"] = 4,
					["Left4"] = "Durability 25 / 25",
				},
				["Slot"] = "LegsSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Legs.blp",
			}, -- [7]
			{
				["Id"] = 8,
				["Tooltip"] = {
					["Left1"] = "Thug Boots",
					["NumLines"] = 2,
					["Left2"] = "Feet",
				},
				["Slot"] = "FeetSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Feet.blp",
			}, -- [8]
			{
				["Id"] = 9,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "WristSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Wrists.blp",
			}, -- [9]
			{
				["Id"] = 10,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "HandsSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Hands.blp",
			}, -- [10]
			{
				["Id"] = 11,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "Finger0Slot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Finger.blp",
			}, -- [11]
			{
				["Id"] = 12,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "Finger1Slot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Finger.blp",
			}, -- [12]
			{
				["Id"] = 13,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "Trinket0Slot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Trinket.blp",
			}, -- [13]
			{
				["Id"] = 14,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "Trinket1Slot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Trinket.blp",
			}, -- [14]
			{
				["Id"] = 15,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "BackSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Chest.blp",
			}, -- [15]
			{
				["Id"] = 16,
				["Tooltip"] = {
					["Left1"] = "Worn Dagger",
					["Left2"] = "One-Hand",
					["Right3"] = "Speed 1.60",
					["Left5"] = "Durability 15 / 16",
					["Left3"] = "1 - 2 Damage",
					["Right2"] = "Dagger",
					["NumLines"] = 5,
					["Left4"] = "(0.9 damage per second)",
				},
				["Slot"] = "MainHandSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-MainHand.blp",
			}, -- [16]
			{
				["Id"] = 17,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "SecondaryHandSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-SecondaryHand.blp",
			}, -- [17]
			{
				["Id"] = 18,
				["Tooltip"] = {
					["Left1"] = "Crude Throwing Axe",
					["Left2"] = "Thrown",
					["Right3"] = "Speed 1.80",
					["Left3"] = "2 - 4 Damage",
					["Right2"] = "Thrown",
					["NumLines"] = 4,
					["Left4"] = "(1.7 damage per second)",
				},
				["Slot"] = "RangedSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Ranged.blp",
			}, -- [18]
			{
				["Id"] = 19,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "TabardSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Tabard.blp",
			}, -- [19]
			{
				["Id"] = 20,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "Bag0Slot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Bag.blp",
			}, -- [20]
			{
				["Id"] = 21,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "Bag1Slot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Bag.blp",
			}, -- [21]
			{
				["Id"] = 22,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "Bag2Slot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Bag.blp",
			}, -- [22]
			{
				["Id"] = 23,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "Bag3Slot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Bag.blp",
			}, -- [23]
			[0] = {
				["Id"] = 0,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "AmmoSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Ranged.blp",
			},
			["WristSlot"] = {
				["Id"] = 9,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "WristSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Wrists.blp",
			},
			["Bag2Slot"] = {
				["Id"] = 22,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "Bag2Slot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Bag.blp",
			},
			["BackSlot"] = {
				["Id"] = 15,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "BackSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Chest.blp",
			},
			["Trinket0Slot"] = {
				["Id"] = 13,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "Trinket0Slot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Trinket.blp",
			},
			["LegsSlot"] = {
				["Id"] = 7,
				["Tooltip"] = {
					["Left1"] = "Thug Pants",
					["Left2"] = "Legs",
					["Left3"] = "2 Armor",
					["Right2"] = "Cloth",
					["NumLines"] = 4,
					["Left4"] = "Durability 25 / 25",
				},
				["Slot"] = "LegsSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Legs.blp",
			},
			["Bag3Slot"] = {
				["Id"] = 23,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "Bag3Slot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Bag.blp",
			},
			["TabardSlot"] = {
				["Id"] = 19,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "TabardSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Tabard.blp",
			},
			["FeetSlot"] = {
				["Id"] = 8,
				["Tooltip"] = {
					["Left1"] = "Thug Boots",
					["NumLines"] = 2,
					["Left2"] = "Feet",
				},
				["Slot"] = "FeetSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Feet.blp",
			},
			["HandsSlot"] = {
				["Id"] = 10,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "HandsSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Hands.blp",
			},
			["Finger1Slot"] = {
				["Id"] = 12,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "Finger1Slot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Finger.blp",
			},
			["ChestSlot"] = {
				["Id"] = 5,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "ChestSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Chest.blp",
			},
			["Bag1Slot"] = {
				["Id"] = 21,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "Bag1Slot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Bag.blp",
			},
			["Trinket1Slot"] = {
				["Id"] = 14,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "Trinket1Slot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Trinket.blp",
			},
			["HeadSlot"] = {
				["Id"] = 1,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "HeadSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Head.blp",
			},
			["AmmoSlot"] = {
				["Id"] = 0,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "AmmoSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Ranged.blp",
			},
			["MainHandSlot"] = {
				["Id"] = 16,
				["Tooltip"] = {
					["Left1"] = "Worn Dagger",
					["Left2"] = "One-Hand",
					["Right3"] = "Speed 1.60",
					["Left5"] = "Durability 15 / 16",
					["Left3"] = "1 - 2 Damage",
					["Right2"] = "Dagger",
					["NumLines"] = 5,
					["Left4"] = "(0.9 damage per second)",
				},
				["Slot"] = "MainHandSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-MainHand.blp",
			},
			["RangedSlot"] = {
				["Id"] = 18,
				["Tooltip"] = {
					["Left1"] = "Crude Throwing Axe",
					["Left2"] = "Thrown",
					["Right3"] = "Speed 1.80",
					["Left3"] = "2 - 4 Damage",
					["Right2"] = "Thrown",
					["NumLines"] = 4,
					["Left4"] = "(1.7 damage per second)",
				},
				["Slot"] = "RangedSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Ranged.blp",
			},
			["ShirtSlot"] = {
				["Id"] = 4,
				["Tooltip"] = {
					["Left1"] = "Thug Shirt",
					["NumLines"] = 2,
					["Left2"] = "Shirt",
				},
				["Slot"] = "ShirtSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Shirt.blp",
			},
			["SecondaryHandSlot"] = {
				["Id"] = 17,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "SecondaryHandSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-SecondaryHand.blp",
			},
			["Finger0Slot"] = {
				["Id"] = 11,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "Finger0Slot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Finger.blp",
			},
			["ShoulderSlot"] = {
				["Id"] = 3,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "ShoulderSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Shoulder.blp",
			},
			["WaistSlot"] = {
				["Id"] = 6,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "WaistSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Waist.blp",
			},
			["Bag0Slot"] = {
				["Id"] = 20,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "Bag0Slot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Bag.blp",
			},
			["NeckSlot"] = {
				["Id"] = 2,
				["Tooltip"] = {
					["NumLines"] = 0,
				},
				["Slot"] = "NeckSlot",
				["Texture"] = "interface\\paperdoll\\UI-PaperDoll-Slot-Neck.blp",
			},
		},
	},
	["CurrentMapZone"] = 8,
	["Zone"] = "Durotar",
	["Bags"] = {
		{
			["Slots"] = 0,
		}, -- [1]
		{
			["Slots"] = 0,
		}, -- [2]
		{
			["Slots"] = 0,
		}, -- [3]
		{
			["Slots"] = 0,
		}, -- [4]
		[0] = {
			{
				["Count"] = 5,
				["Name"] = "|cffffffff|Hitem:117:0:0:0:0:0:0:0:1|h[Tough Jerky]|h|r",
				["Texture"] = "Interface\\Icons\\INV_Misc_Food_16",
			}, -- [1]
			{
				["Count"] = 1,
				["Name"] = "|cffffffff|Hitem:6948:0:0:0:0:0:0:0:1|h[Hearthstone]|h|r",
				["Texture"] = "Interface\\Icons\\INV_Misc_Rune_01",
			}, -- [2]
			{
				["Count"] = 1,
				["Name"] = "|cff9d9d9d|Hitem:7098:0:0:0:0:0:0:1493571584:1|h[Splintered Tusk]|h|r",
				["Texture"] = "Interface\\Icons\\INV_Misc_Bone_05",
			}, -- [3]
			{
				["Count"] = 1,
				["Name"] = "|cff9d9d9d|Hitem:1374:0:0:0:0:0:0:1762007040:1|h[Frayed Shoes]|h|r",
				["Texture"] = "Interface\\Icons\\INV_Boots_09",
			}, -- [4]
			{
				["Count"] = 1,
				["Name"] = "|cff9d9d9d|Hitem:4865:0:0:0:0:0:0:477138272:1|h[Ruined Pelt]|h|r",
				["Texture"] = "Interface\\Icons\\INV_Misc_Pelt_Wolf_Ruin_04",
			}, -- [5]
			["Slots"] = 16,
		},
	},
	["BuildInfo"] = {
		["BuildNum"] = "9947",
		["BuildDate"] = "May 26 2009",
		["Version"] = "3.1.3",
	},
	["PowaPlayerListe"] = {
		"Page 1", -- [1]
		"Page 2", -- [2]
		"Page 3", -- [3]
		"Page 4", -- [4]
		"Page 5", -- [5]
	},
	["Locale"] = "enUS",
	["ActiveTalentGroup"] = 1,
	["Time"] = 20290.429,
	["PowaGlobalListe"] = {
		"Global 1", -- [1]
		"Global 2", -- [2]
		"Global 3", -- [3]
		"Global 4", -- [4]
		"Global 5", -- [5]
		"Global 6", -- [6]
		"Global 7", -- [7]
		"Global 8", -- [8]
		"Global 9", -- [9]
		"Global 10", -- [10]
	},
	["target"] = {
		["Visible"] = 1,
		["ChannelInfo"] = {
		},
		["Mana"] = 0,
		["Unit"] = "target",
		["HealthMax"] = 42,
		["CastingInfo"] = {
		},
		["Damage"] = 0,
		["IsTapped"] = 1,
		["Connected"] = 1,
		["Power"] = {
			0, -- [1]
			100, -- [2]
			100, -- [3]
			1000, -- [4]
			0, -- [5]
			0, -- [6]
			["Default"] = 0,
			[0] = 0,
		},
		["RangedAttackPower"] = 0,
		["InteractDistance"] = {
			1, -- [1]
			1, -- [2]
			1, -- [3]
			1, -- [4]
		},
		["PowerType"] = 1,
		["Health"] = 3,
		["AttackBothHands"] = 0,
		["XPMax"] = 0,
		["Buffs"] = {
		},
		["TargetTarget"] = "Mottled Boar",
		["LocClass"] = "Mottled Boar",
		["Stats"] = {
			{
				["Type"] = "Strength",
				["PosBuff"] = 0,
				["NegBuff"] = 0,
				["Base"] = 0,
				["Stat"] = 0,
			}, -- [1]
			{
				["Type"] = "Agility",
				["PosBuff"] = 0,
				["NegBuff"] = 0,
				["Base"] = 0,
				["Stat"] = 0,
			}, -- [2]
			{
				["Type"] = "Stamina",
				["PosBuff"] = 0,
				["NegBuff"] = 0,
				["Base"] = 0,
				["Stat"] = 0,
			}, -- [3]
			{
				["Type"] = "Intellect",
				["PosBuff"] = 0,
				["NegBuff"] = 0,
				["Base"] = 0,
				["Stat"] = 0,
			}, -- [4]
			{
				["Type"] = "Spirit",
				["PosBuff"] = 0,
				["NegBuff"] = 0,
				["Base"] = 0,
				["Stat"] = 0,
			}, -- [5]
		},
		["AttackSpeed"] = 2.000000094994903,
		["Target"] = "Himan",
		["Class"] = "WARRIOR",
		["RangedAttack"] = 0,
		["ManaMax"] = 0,
		["PVPRank"] = 0,
		["PVPName"] = "Mottled Boar",
		["RangedDamage"] = 0,
		["TargetInCombat"] = 1,
		["Armor"] = 0,
		["Level"] = 1,
		["XP"] = 0,
		["Debuffs"] = {
		},
		["AttackPower"] = 0,
		["Defense"] = 0,
		["IsTappedByPlayer"] = 1,
		["UnitHasVehicleUI"] = false,
		["Classification"] = "normal",
		["Tooltip"] = {
			["Left1"] = "Mottled Boar",
			["NumLines"] = 2,
			["Left2"] = "Level 1 Beast",
		},
		["CreatureFamily"] = "Boar",
		["CreatureType"] = "Beast",
		["Resistances"] = {
			{
				["Type"] = "Holy",
				["Malus"] = 0,
				["Total"] = 0,
				["Base"] = 0,
				["Bonus"] = 0,
			}, -- [1]
			{
				["Type"] = "Fire",
				["Malus"] = 0,
				["Total"] = 0,
				["Base"] = 0,
				["Bonus"] = 0,
			}, -- [2]
			{
				["Type"] = "Nature",
				["Malus"] = 0,
				["Total"] = 0,
				["Base"] = 0,
				["Bonus"] = 0,
			}, -- [3]
			{
				["Type"] = "Frost",
				["Malus"] = 0,
				["Total"] = 0,
				["Base"] = 0,
				["Bonus"] = 0,
			}, -- [4]
			{
				["Type"] = "Shadow",
				["Malus"] = 0,
				["Total"] = 0,
				["Base"] = 0,
				["Bonus"] = 0,
			}, -- [5]
			{
				["Type"] = "Arcane",
				["Malus"] = 0,
				["Total"] = 0,
				["Base"] = 0,
				["Bonus"] = 0,
			}, -- [6]
			[0] = {
				["Type"] = "Physical",
				["Malus"] = 0,
				["Total"] = 0,
				["Base"] = 0,
				["Bonus"] = 0,
			},
		},
		["PowerMax"] = {
			0, -- [1]
			100, -- [2]
			100, -- [3]
			1000, -- [4]
			0, -- [5]
			0, -- [6]
			["Default"] = 0,
			[0] = 0,
		},
		["Name"] = "Mottled Boar",
		["Sex"] = 1,
		["CanAttack"] = 1,
		["CanBeAttacked"] = 1,
		["InCombat"] = 1,
		["Pos"] = {
			["Y"] = 0,
			["X"] = 0,
		},
	},
	["CurrentMapContinent"] = 1,
	["ComboPoints"] = {
		["vehicle"] = 0,
		["player"] = 1,
	},
	["Realm"] = "Scarshield Legion",
	["WeaponEnchant"] = {
	},
	["PowaGlobalSet"] = {
	},
	["Powa"] = {
		["MoveEffect"] = 0,
		["Frames"] = {
			[0] = {
				[0] = nil --[[ skipped userdata ]],
				["baseH"] = 256,
				["baseL"] = 256,
				["texture"] = {
					[0] = nil --[[ skipped userdata ]],
				},
			},
		},
		["WeAreInCombat"] = true,
		["WeAreInVehicle"] = false,
		["Anim"] = {
			"Static", -- [1]
			"Flashing", -- [2]
			"Growing", -- [3]
			"Pulse", -- [4]
			"Bubble", -- [5]
			"Water drop", -- [6]
			"Electric", -- [7]
			"Shrinking", -- [8]
			"Flame", -- [9]
			"Orbit", -- [10]
			[0] = "[Invisible]",
		},
		["Tstep"] = 0.09765625,
		["playerclass"] = "ROGUE",
		["AuraHide"] = false,
		["ModTest"] = false,
		["Enabled"] = 1,
		["WeAreAlive"] = true,
		["Fonts"] = {
			"Fonts\\FRIZQT__.TTF", -- [1]
			"Fonts\\ARIALN.TTF", -- [2]
			"Fonts\\skurri.ttf", -- [3]
			"Fonts\\MORPHEUS.ttf", -- [4]
			"Interface\\Addons\\PowerAuras\\Fonts\\All_Star_Resort.ttf", -- [5]
			"Interface\\Addons\\PowerAuras\\Fonts\\Army.ttf", -- [6]
			"Interface\\Addons\\PowerAuras\\Fonts\\Army_Condensed.ttf", -- [7]
			"Interface\\Addons\\PowerAuras\\Fonts\\Army_Expanded.ttf", -- [8]
			"Interface\\Addons\\PowerAuras\\Fonts\\Blazed.ttf", -- [9]
			"Interface\\Addons\\PowerAuras\\Fonts\\Blox2.ttf", -- [10]
			"Interface\\Addons\\PowerAuras\\Fonts\\CloisterBlack.ttf", -- [11]
			"Interface\\Addons\\PowerAuras\\Fonts\\Moonstar.ttf", -- [12]
			"Interface\\Addons\\PowerAuras\\Fonts\\Neon.ttf", -- [13]
			"Interface\\Addons\\PowerAuras\\Fonts\\Pulse_virgin.ttf", -- [14]
			"Interface\\Addons\\PowerAuras\\Fonts\\Punk_s_not_dead.ttf", -- [15]
			"Interface\\Addons\\PowerAuras\\Fonts\\whoa!.ttf", -- [16]
			"Interface\\Addons\\PowerAuras\\Fonts\\Hexagon.ttf", -- [17]
			"Interface\\Addons\\PowerAuras\\Fonts\\Starcraft_Normal.ttf", -- [18]
		},
		["PowaStance"] = {
			[0] = "Humanoid",
		},
		["Events"] = {
			"PLAYER_ENTERING_WORLD", -- [1]
			"PLAYER_TARGET_CHANGED", -- [2]
			"PLAYER_FOCUS_CHANGED", -- [3]
			"PLAYER_AURAS_CHANGED", -- [4]
			"PLAYER_REGEN_DISABLED", -- [5]
			"PLAYER_REGEN_ENABLED", -- [6]
			"PLAYER_DEAD", -- [7]
			"PLAYER_ALIVE", -- [8]
			"PLAYER_UNGHOST", -- [9]
			"PLAYER_UPDATE_RESTING", -- [10]
			"UNIT_HEALTH", -- [11]
			"UNIT_MAXHEALTH", -- [12]
			"UNIT_MANA", -- [13]
			"UNIT_MAXMANA", -- [14]
			"UNIT_RAGE", -- [15]
			"UNIT_ENERGY", -- [16]
			"UNIT_MAXENERGY", -- [17]
			"UNIT_COMBO_POINTS", -- [18]
			"UNIT_RUNIC_POWER", -- [19]
			"UNIT_MAXRUNIC_POWER", -- [20]
			"UNIT_AURA", -- [21]
			"UNIT_AURASTATE", -- [22]
			"UNIT_FACTION", -- [23]
			"UNIT_ENTERED_VEHICLE", -- [24]
			"UNIT_EXITED_VEHICLE", -- [25]
			"UNIT_SPELLCAST_START", -- [26]
			"UNIT_SPELLCAST_STOP", -- [27]
			"UNIT_SPELLCAST_FAILED", -- [28]
			"UNIT_SPELLCAST_INTERRUPTED", -- [29]
			"UNIT_SPELLCAST_DELAYED", -- [30]
			"UNIT_SPELLCAST_CHANNEL_START", -- [31]
			"UNIT_SPELLCAST_CHANNEL_UPDATE", -- [32]
			"UNIT_SPELLCAST_CHANNEL_STOP", -- [33]
			"UNIT_SPELLCAST_SUCCEEDED", -- [34]
			"PARTY_MEMBERS_CHANGED", -- [35]
			"RAID_ROSTER_UPDATE", -- [36]
			"COMBAT_LOG_EVENT_UNFILTERED", -- [37]
			"UPDATE_SHAPESHIFT_FORM", -- [38]
			"ACTIONBAR_UPDATE_USABLE", -- [39]
			"ACTIONBAR_UPDATE_COOLDOWN", -- [40]
			"ACTIONBAR_SLOT_CHANGED", -- [41]
			"UPDATE_SHAPESHIFT_FORMS", -- [42]
			"VARIABLES_LOADED", -- [43]
			"PLAYER_TALENT_UPDATE", -- [44]
		},
		["Text"] = {
			["aideMultiID"] = "Enter here other Aura IDs to combine checks. Multiple IDs must be separated with '/'. Aura ID can be found as [#] on first line of Aura tooltip.",
			["aideCustomTextures"] = "Check this to use textures in the 'Custom' subdirectory. Put the name of the texture below (ex: myTexture.tga). You can also use a Spell Name (ex: Feign Death) or SpellID (ex: 5384).",
			["aideExport"] = "Press Ctrl-C to copy the Aura-string for sharing.",
			["nomCheckInverse"] = "Invert",
			["nomCheckFocus"] = "Focus",
			["nomTest"] = "Test",
			["aideShowTimer"] = "Check this to show the timer of this effect.",
			["nomTalentGroup2"] = "Spec 2",
			["nomRandomColor"] = "Random Colors",
			["aideBuff5"] = "Enter here the temporary enchant which must activate this effect : optionally prepend it with 'main/' or 'off/ to designate mainhand or offhand slot. (ex: main/crippling)",
			["aideRename"] = "Rename the selected effect's page.",
			["aideBuff6"] = "You can entrer here the numbers of combo points that must activate this effect (ex : 1 or 123 or 045 etc...) ",
			["nomThreshold"] = "Threshold",
			["nomDebug"] = "Activate Debug Messages",
			["nomDuration"] = "Anim. duration",
			["nomIsInRaid"] = "Only if in Raid",
			["nomStance"] = "Stance",
			["nomRename"] = "Rename",
			["nomWowTextures"] = "WoW Textures",
			["nomCheckRageEnergy"] = "Rage/Energy/Runic",
			["nomMove"] = "Move",
			["ListePlayer"] = "Page",
			["aideMove"] = "Move the effect here.",
			["nomCheckAoeDebuff"] = "AOE Debuff",
			["aideInverse"] = "Invert the logic to show this effect only when buff/debuff is not active.",
			["nomCheckGroupAny"] = "Any",
			["aideTimerDuration"] = "Show a timer to simulate buff/debuff duration on the target (0 to deactivate)",
			["nomAnim1"] = "Main Animation",
			["nomBegin"] = "Begin Animation",
			["aideSpells"] = "Enter here the Spell Name that will trigger a spell alert Aura.",
			["aideGroupAny"] = "Check this to test buff on 'Any' party/raid member. Unchecked: Test that 'All' are buffed.",
			["nomCheckPvP"] = "PvP",
			["aideUnitn"] = "Enter here the name of the unit, which must activate/deactivate the effect. You can enter only names, if they are in your raid or group.",
			["nomCheckBuff"] = "Buff",
			["nomPos"] = "Position",
			["aideBuff7"] = "Enter here the name, or a part of the name, of an action in your action bars. The effect will be active when this action is usable.",
			["aideAnim2"] = "This animation will be shown with less opacity than the main animaton. Attention, to not overload the screen, only a single secondary animation will be shown at the same time.",
			["aideIsInRaid"] = "Show this effect only when you are in a raid.",
			["aideSelectTimer"] = "Select which timer will show the duration",
			["aideEnable"] = "Enable all Power Auras effects",
			["nomImport"] = "Import",
			["nomHide"] = "Hide all",
			["aideCustomSound"] = "Enter a soundfile that is in the Sounds folder, BEFORE you started the game. mp3 and wav are supported. example: 'cookie.mp3' ;)",
			["aideColor"] = "Click here to change the color of the texture.",
			["DebuffType"] = {
				["Curse"] = "Curse",
				["Poison"] = "Poison",
				["Magic"] = "Magic",
				["Disease"] = "Disease",
			},
			["aideTextAura"] = "Check this to type text instead of texture.",
			["aideGroupOrSelf"] = "Check this to test a party or raid member or self.",
			["aideCopy"] = "Copy the effect here.",
			["nomCentiemes"] = "Show hundredth",
			["aideOwnTex"] = "Use the De/Buff or Ability Texture instead.",
			["nomEdit"] = "Edit",
			["aideBuff"] = "Enter here the name of the buff, or a part of the name, which must activate/deactivate the effect. You can enter several names if they are decently separated (ex: Super Buff/Power)",
			["nomCheckTarget"] = "Enemy Target",
			["nomEffectEditor"] = "Effect Editor",
			["aideTarget"] = "Check this to test an enemy target only.",
			["aideNotInCombat"] = "Show this effect only when you are NOT in combat.",
			["nomCheckCombo"] = "Combo Points",
			["nomStacks"] = "Stacks",
			["aideAddEffect"] = "Add an effect for edition.",
			["aideTooltipCheck"] = "Also check the tooltip starts with this text",
			["nomTaille"] = "Size",
			["aideOptunitn"] = "Check this to test a spezial char in raid/group only.",
			["aideImport"] = "Press Ctrl-V to paste the Aura-string and press 'Accept'",
			["aucun"] = "None",
			["aideRaid"] = "Check this to test a raid member only.",
			["aideThreshInv"] = "Check this to invert the threshold logic. Health/Mana: default = Low Warning / checked = High Warning. Energy/Rage/Power: default = High Warning / checked = Low Warning",
			["nomCheckDebuffType"] = "Debuff's type",
			["nomTabActiv"] = "Activation",
			["nomEnable"] = "Activate Power Auras",
			["hauteur"] = "Height",
			["welcome"] = "Type /powa to view the options.",
			["ListeGlobal"] = "Global",
			["aideDebug"] = "Enable Debug Messages",
			["aideFont"] = "Click here to pick Font. Press OK to apply the selection.",
			["nomCheckGroupOrSelf"] = "Raid/Party or self",
			["aideInCombat"] = "Show this effect only when you are in combat.",
			["nomGlobalEffects"] = "Global\neffects",
			["nomCheckOptunitn"] = "Unitname",
			["aideMine"] = "Check this to test only buffs/debuffs cast by the player",
			["nomTextAura"] = "Text Aura",
			["nomGCD"] = "Global Cooldown",
			["aideUnitn2"] = "Only for raid/group.",
			["nomTalentGroup1"] = "Spec 1",
			["nomNew"] = "New",
			["nomActivationBy"] = "Activation by :",
			["nomCheckRaid"] = "Raidmember",
			["aideWowTextures"] = "Check this to use the texture of WoW instead of textures in the Power Auras directory for this effect.",
			["nomCheckFriend"] = "Friendly Target",
			["nomCheckHealth"] = "Health",
			["aideFocus"] = "Check this to test the focus only.",
			["aideIgnoreMaj"] = "Check this to ignore upper/lowercase of buff/debuff names.",
			["nomCheckSkill"] = "Action Usable",
			["nomExport"] = "Export",
			["nomMine"] = "Cast by me",
			["aideTargetFriend"] = "Check this to test a friendly target only.",
			["nomCheckSpells"] = "Spell Alert",
			["aideSelectTimerDebuff"] = "Select which timer will show the duration (this one is reserved for player's debuffs)",
			["nomNotInCombat"] = "Only if not in Combat",
			["aideTalentGroup1"] = "Show this effect only when you are in your primary talent spec.",
			["nomTexture"] = "Texture",
			["aideTexture"] = "The texture to be shown. You can easily replace textures by changing the files Aura#.tga in the Addon's directory.",
			["aideAnim1"] = "Animate the texture or not, with various effects.",
			["aideEffectTooltip"] = "(Shift-click to toggle effect ON or OFF)",
			["aideDeform"] = "Stretch the texture in height or in width.",
			["aideBuff2"] = "Enter here the name of the debuff, or a part of the name, which must activate/deactivate the effect. You can enter several names if they are decently separated (ex: Dark Disease/Plague)",
			["aideDel"] = "Remove the selected effect (Hold CTRL to allow this button to work)",
			["nomCopy"] = "Copy",
			["aideBuff4"] = "Enter here the name of area of effect that must trigger this effect (like a rain of fire for example, the name of this AOE can be found in the combat log)",
			["nomClose"] = "Close",
			["nomMaxTex"] = "Maximum of textures available",
			["aideStacks"] = "Enter here the operator and the amount of stacks, which must activate/deactivate the effect. It works only with an operator! ex: '<5' or '>3' or '=11'",
			["aideDuration"] = "After this time, this effect will disapear (0 to deactivate)",
			["nomCustomSound"] = "OR soundfile:",
			["nomPlayerEffects"] = "Character effects",
			["nomSpeed"] = "Animation speed",
			["aideTexMode"] = "Uncheck this to use the texture opacity. By default, the darkest colors will be more transparent.",
			["nomAlpha"] = "Opacity",
			["nomExact"] = "Exact Name",
			["nomCheckIgnoreMaj"] = "Ignore uppercase",
			["aideStance"] = "Select which Stance,Aura or Form trigger the event.",
			["largeur"] = "Width",
			["nomSymetrie"] = "Symmetry",
			["aideGCD"] = "Check this and the Global Cooldown triggers with 'action usable'. May cause blinking the aura, when an action only has a Global Cooldown.",
			["offHand"] = "off",
			["nomSound"] = "Sound to play",
			["aideExact"] = "Check this to test the exact name of the buff/debuff/action.",
			["nomCheckEnchant"] = "Weapon Enchant",
			["nomDel"] = "Delete",
			["nomTabTimer"] = "Timer",
			["nomCheckParty"] = "Partymember",
			["nomCheckStance"] = "Stance",
			["aideRealaura"] = "Real Aura",
			["nomCheckAggro"] = "Aggro",
			["aucune"] = "None",
			["aideSound"] = "Plays a sound at the beginning.",
			["nomAnim2"] = "Secondary Animation",
			["aideParty"] = "Check this to test a party member only.",
			["nomCheckShowTimer"] = "Show",
			["nomThreshInv"] = "</>",
			["aideRandomColor"] = "Check this to tell this effect to use random color each time it will be activated.",
			["nomTexMode"] = "Glow",
			["nomCustomTextures"] = "Custom Textures",
			["nomCheckDebuff"] = "Debuff",
			["nomOwnTex"] = "Use own Texture",
			["nomDual"] = "Show 2 timers",
			["nomTimerDuration"] = "Duration",
			["nomDeform"] = "Deformation",
			["aideSelectTimerBuff"] = "Select which timer will show the duration (this one is reserved for player's buffs)",
			["nomCheckMana"] = "Mana",
			["nomEnd"] = "End Animation",
			["aideIsMounted"] = "Checked: Only when on mount. Uncheked: Only when dismounted.",
			["nomAdvOptions"] = "Options",
			["mainHand"] = "main",
			["nomTabAnim"] = "Animation",
			["nomTabSound"] = "Sound",
			["bothHands"] = "both",
			["aideMaxTex"] = "Define the maximum number of textures available on the Effect Editor. If you add textures on the Mod directory (with the names AURA1.tga to AURA50.tga), you must indicate the correct number here.",
			["nomIsMounted"] = "Only if Mounted",
			["nomInCombat"] = "Only if in Combat",
			["aideTalentGroup2"] = "Show this effect only when you are in your secondary talent spec.",
			["aideBuff3"] = "Enter here the type of the debuff which must activate or deactivate the effect (Poison, Disease, Curse, Magic or None). You can also enter several types of debuff.",
			["nomRealaura"] = "Real Aura",
		},
		["minScale"] = {
			["a"] = 0,
			["h"] = 0,
			["w"] = 0,
		},
		["TimerFrame"] = {
		},
		["MaxAuras"] = 360,
		["CurrentSecondeAura"] = 0,
		["WowTextures"] = {
			"Spells\\AuraRune_B", -- [1]
			"Spells\\AuraRune256b", -- [2]
			"Spells\\Circle", -- [3]
			"Spells\\GENERICGLOW2B", -- [4]
			"Spells\\GenericGlow2b1", -- [5]
			"Spells\\ShockRingCrescent256", -- [6]
			"SPELLS\\AuraRune1", -- [7]
			"SPELLS\\AuraRune5Green", -- [8]
			"SPELLS\\AuraRune7", -- [9]
			"SPELLS\\AuraRune8", -- [10]
			"SPELLS\\AuraRune9", -- [11]
			"SPELLS\\AuraRune11", -- [12]
			"SPELLS\\AuraRune_A", -- [13]
			"SPELLS\\AuraRune_C", -- [14]
			"SPELLS\\AuraRune_D", -- [15]
			"SPELLS\\Holy_Rune1", -- [16]
			"SPELLS\\Rune1d_GLOWless", -- [17]
			"SPELLS\\Rune4blue", -- [18]
			"SPELLS\\RuneBC1", -- [19]
			"SPELLS\\RuneBC2", -- [20]
			"SPELLS\\RUNEFROST", -- [21]
			"Spells\\Holy_Rune_128", -- [22]
			"Spells\\Nature_Rune_128", -- [23]
			"SPELLS\\Death_Rune", -- [24]
			"SPELLS\\DemonRune6", -- [25]
			"SPELLS\\DemonRune7", -- [26]
			"Spells\\DemonRune5backup", -- [27]
			"Particles\\Intellect128_outline", -- [28]
			"Spells\\Intellect_128", -- [29]
			"SPELLS\\GHOST1", -- [30]
			"Spells\\Aspect_Beast", -- [31]
			"Spells\\Aspect_Hawk", -- [32]
			"Spells\\Aspect_Wolf", -- [33]
			"Spells\\Aspect_Snake", -- [34]
			"Spells\\Aspect_Cheetah", -- [35]
			"Spells\\Aspect_Monkey", -- [36]
			"Spells\\Blobs", -- [37]
			"Spells\\Blobs2", -- [38]
			"Spells\\GradientCrescent2", -- [39]
			"Spells\\InnerFire_Rune_128", -- [40]
			"Spells\\RapidFire_Rune_128", -- [41]
			"Spells\\Protect_128", -- [42]
			"Spells\\Reticle_128", -- [43]
			"Spells\\Star2A", -- [44]
			"Spells\\Star4", -- [45]
			"Spells\\Strength_128", -- [46]
			"Particles\\STUNWHIRL", -- [47]
			"SPELLS\\BloodSplash1", -- [48]
			"SPELLS\\DarkSummon", -- [49]
			"SPELLS\\EndlessRage", -- [50]
			"SPELLS\\Rampage", -- [51]
			"SPELLS\\Eye", -- [52]
			"SPELLS\\Eyes", -- [53]
			"SPELLS\\Zap1b", -- [54]
		},
		["Misc"] = {
		},
		["CurrentAuraPage"] = 1,
		["AuraClasses"] = {
			{
				["buffAuraType"] = "HELPFUL",
				["__index"] = nil --[[ skipped recursive table ]],
				["_base"] = {
					["__index"] = nil --[[ skipped recursive table ]],
					["_base"] = {
						["__index"] = nil --[[ skipped recursive table ]],
					},
				},
			}, -- [1]
			{
				["buffAuraType"] = "HARMFUL",
				["__index"] = nil --[[ skipped recursive table ]],
				["_base"] = {
					["__index"] = nil --[[ skipped recursive table ]],
					["_base"] = {
						["__index"] = nil --[[ skipped recursive table ]],
					},
				},
			}, -- [2]
			{
				["buffAuraType"] = "HARMFUL",
				["__index"] = nil --[[ skipped recursive table ]],
				["_base"] = {
					["__index"] = nil --[[ skipped recursive table ]],
					["_base"] = {
						["__index"] = nil --[[ skipped recursive table ]],
					},
				},
			}, -- [3]
			{
				["__index"] = nil --[[ skipped recursive table ]],
				["_base"] = {
					["__index"] = nil --[[ skipped recursive table ]],
				},
			}, -- [4]
			{
				["__index"] = nil --[[ skipped recursive table ]],
				["_base"] = {
					["__index"] = nil --[[ skipped recursive table ]],
				},
			}, -- [5]
			{
				["__index"] = nil --[[ skipped recursive table ]],
				["_base"] = {
					["__index"] = nil --[[ skipped recursive table ]],
				},
			}, -- [6]
			{
				["__index"] = nil --[[ skipped recursive table ]],
				["_base"] = {
					["__index"] = nil --[[ skipped recursive table ]],
				},
			}, -- [7]
			{
				["ValueName"] = "Health",
				["__index"] = nil --[[ skipped recursive table ]],
				["_base"] = {
					["__index"] = nil --[[ skipped recursive table ]],
					["_base"] = {
						["__index"] = nil --[[ skipped recursive table ]],
					},
				},
			}, -- [8]
			{
				["ValueName"] = "Mana",
				["__index"] = nil --[[ skipped recursive table ]],
				["_base"] = {
					["__index"] = nil --[[ skipped recursive table ]],
					["_base"] = {
						["__index"] = nil --[[ skipped recursive table ]],
					},
				},
			}, -- [9]
			{
				["ValueName"] = "EnergyRagePower",
				["__index"] = nil --[[ skipped recursive table ]],
				["_base"] = {
					["ValueName"] = "Mana",
					["__index"] = nil --[[ skipped recursive table ]],
					["_base"] = {
						["__index"] = nil --[[ skipped recursive table ]],
						["_base"] = {
							["__index"] = nil --[[ skipped recursive table ]],
						},
					},
				},
			}, -- [10]
			{
				["__index"] = nil --[[ skipped recursive table ]],
				["_base"] = {
					["__index"] = nil --[[ skipped recursive table ]],
				},
			}, -- [11]
			{
				["__index"] = nil --[[ skipped recursive table ]],
				["_base"] = {
					["__index"] = nil --[[ skipped recursive table ]],
				},
			}, -- [12]
			{
				["__index"] = nil --[[ skipped recursive table ]],
				["_base"] = {
					["__index"] = nil --[[ skipped recursive table ]],
				},
			}, -- [13]
			{
				["__index"] = nil --[[ skipped recursive table ]],
				["_base"] = {
					["__index"] = nil --[[ skipped recursive table ]],
				},
			}, -- [14]
		},
		["ChecksTimer"] = 0.1000000052154064,
		["Colors"] = {
			["Red"] = "|cffff2020",
			["BGrey"] = "|c00D0D0D0",
			["Blue"] = "|cff6666ff",
			["Green"] = "|cff66cc33",
			["Grey"] = "|cff999999",
			["Yellow"] = "|cffffff40",
			["Orange"] = "|cffff9930",
			["White"] = "|c00FFFFFF",
		},
		["NextCheck"] = 0.2,
		["WeAreMounted"] = false,
		["allowedOperators"] = {
			["!"] = true,
			[">="] = true,
			["="] = true,
			["<"] = true,
			["<="] = true,
			[">"] = true,
		},
		["ActiveTalentGroup"] = 1,
		["CurrentAuraId"] = 1,
		["maxScale"] = {
			["a"] = 0,
			["h"] = 0,
			["w"] = 0,
		},
		["ResetTargetTimers"] = false,
		["Auras"] = {
			[0] = {
				["gcd"] = false,
				["b"] = 1,
				["anim1"] = 1,
				["g"] = 1,
				["thresholdinvert"] = false,
				["tooltipCheck"] = "",
				["opt2"] = 0,
				["target"] = false,
				["icon"] = "",
				["size"] = 0.75,
				["torsion"] = 1,
				["r"] = 1,
				["begin"] = 0,
				["x"] = 0,
				["customname"] = "",
				["groupany"] = true,
				["timerduration"] = 0,
				["unitn"] = "",
				["bufftype"] = 1,
				["stacks"] = 0,
				["focus"] = false,
				["isenchant"] = false,
				["raid"] = false,
				["texture"] = 1,
				["alpha"] = 0.75,
				["aurastext"] = "",
				["symetrie"] = 0,
				["Timer"] = {
					["y"] = 0,
					["dual"] = false,
					["enabled"] = false,
					["a"] = 1,
					["cents"] = true,
					["h"] = 1,
					["id"] = 0,
					["x"] = 0,
				},
				["soundfile"] = "",
				["owntex"] = false,
				["duration"] = 0,
				["mine"] = false,
				["multiids"] = "",
				["speed"] = 1,
				["sound"] = 0,
				["stacksOperator"] = ">=",
				["realaura"] = 1,
				["threshold"] = 50,
				["exact"] = false,
				["textaura"] = false,
				["wowtex"] = false,
				["groupOrSelf"] = false,
				["customsound"] = "",
				["combat"] = 0,
				["aurastextfont"] = 1,
				["finish"] = 1,
				["spec2"] = true,
				["customtex"] = false,
				["randomcolor"] = false,
				["isdebufftype"] = false,
				["opt1"] = 0,
				["optunitn"] = false,
				["y"] = -30,
				["ignoremaj"] = true,
				["anim2"] = 0,
				["id"] = 0,
				["off"] = false,
				["buffname"] = "",
				["texmode"] = 1,
				["party"] = false,
				["isdebuff"] = false,
				["inverse"] = false,
				["ismounted"] = false,
				["targetfriend"] = false,
				["spec1"] = true,
				["isinraid"] = false,
				["stance"] = 10,
			},
		},
		["Sound"] = {
			"LEVELUP", -- [1]
			"LOOTWINDOWCOINSOUND", -- [2]
			"MapPing", -- [3]
			"Exploration", -- [4]
			"QUESTADDED", -- [5]
			"QUESTCOMPLETED", -- [6]
			"WriteQuest", -- [7]
			"Fishing Reel in", -- [8]
			"igPVPUpdate", -- [9]
			"ReadyCheck", -- [10]
			"RaidWarning", -- [11]
			"AuctionWindowOpen", -- [12]
			"AuctionWindowClose", -- [13]
			"TellMessage", -- [14]
			"igBackPackOpen", -- [15]
			[0] = "None",
		},
		["curScale"] = {
			["a"] = 0,
			["h"] = 0,
			["w"] = 0,
		},
		["Textures"] = {
			[0] = {
				[0] = nil --[[ skipped userdata ]],
			},
		},
		["AoeAuraAdded"] = "",
		["MainOptionPage"] = 1,
		["FramesVisibleTime"] = {
			0, -- [1]
			0, -- [2]
			0, -- [3]
			0, -- [4]
			0, -- [5]
			0, -- [6]
			0, -- [7]
			0, -- [8]
			0, -- [9]
			0, -- [10]
			0, -- [11]
			0, -- [12]
			0, -- [13]
			0, -- [14]
			0, -- [15]
			0, -- [16]
			0, -- [17]
			0, -- [18]
			0, -- [19]
			0, -- [20]
			0, -- [21]
			0, -- [22]
			0, -- [23]
			0, -- [24]
			0, -- [25]
			0, -- [26]
			0, -- [27]
			0, -- [28]
			0, -- [29]
			0, -- [30]
			0, -- [31]
			0, -- [32]
			0, -- [33]
			0, -- [34]
			0, -- [35]
			0, -- [36]
			0, -- [37]
			0, -- [38]
			0, -- [39]
			0, -- [40]
			0, -- [41]
			0, -- [42]
			0, -- [43]
			0, -- [44]
			0, -- [45]
			0, -- [46]
			0, -- [47]
			0, -- [48]
			0, -- [49]
			0, -- [50]
			0, -- [51]
			0, -- [52]
			0, -- [53]
			0, -- [54]
			0, -- [55]
			0, -- [56]
			0, -- [57]
			0, -- [58]
			0, -- [59]
			0, -- [60]
			0, -- [61]
			0, -- [62]
			0, -- [63]
			0, -- [64]
			0, -- [65]
			0, -- [66]
			0, -- [67]
			0, -- [68]
			0, -- [69]
			0, -- [70]
			0, -- [71]
			0, -- [72]
			0, -- [73]
			0, -- [74]
			0, -- [75]
			0, -- [76]
			0, -- [77]
			0, -- [78]
			0, -- [79]
			0, -- [80]
			0, -- [81]
			0, -- [82]
			0, -- [83]
			0, -- [84]
			0, -- [85]
			0, -- [86]
			0, -- [87]
			0, -- [88]
			0, -- [89]
			0, -- [90]
			0, -- [91]
			0, -- [92]
			0, -- [93]
			0, -- [94]
			0, -- [95]
			0, -- [96]
			0, -- [97]
			0, -- [98]
			0, -- [99]
			0, -- [100]
			0, -- [101]
			0, -- [102]
			0, -- [103]
			0, -- [104]
			0, -- [105]
			0, -- [106]
			0, -- [107]
			0, -- [108]
			0, -- [109]
			0, -- [110]
			0, -- [111]
			0, -- [112]
			0, -- [113]
			0, -- [114]
			0, -- [115]
			0, -- [116]
			0, -- [117]
			0, -- [118]
			0, -- [119]
			0, -- [120]
			0, -- [121]
			0, -- [122]
			0, -- [123]
			0, -- [124]
			0, -- [125]
			0, -- [126]
			0, -- [127]
			0, -- [128]
			0, -- [129]
			0, -- [130]
			0, -- [131]
			0, -- [132]
			0, -- [133]
			0, -- [134]
			0, -- [135]
			0, -- [136]
			0, -- [137]
			0, -- [138]
			0, -- [139]
			0, -- [140]
			0, -- [141]
			0, -- [142]
			0, -- [143]
			0, -- [144]
			0, -- [145]
			0, -- [146]
			0, -- [147]
			0, -- [148]
			0, -- [149]
			0, -- [150]
			0, -- [151]
			0, -- [152]
			0, -- [153]
			0, -- [154]
			0, -- [155]
			0, -- [156]
			0, -- [157]
			0, -- [158]
			0, -- [159]
			0, -- [160]
			0, -- [161]
			0, -- [162]
			0, -- [163]
			0, -- [164]
			0, -- [165]
			0, -- [166]
			0, -- [167]
			0, -- [168]
			0, -- [169]
			0, -- [170]
			0, -- [171]
			0, -- [172]
			0, -- [173]
			0, -- [174]
			0, -- [175]
			0, -- [176]
			0, -- [177]
			0, -- [178]
			0, -- [179]
			0, -- [180]
			0, -- [181]
			0, -- [182]
			0, -- [183]
			0, -- [184]
			0, -- [185]
			0, -- [186]
			0, -- [187]
			0, -- [188]
			0, -- [189]
			0, -- [190]
			0, -- [191]
			0, -- [192]
			0, -- [193]
			0, -- [194]
			0, -- [195]
			0, -- [196]
			0, -- [197]
			0, -- [198]
			0, -- [199]
			0, -- [200]
			0, -- [201]
			0, -- [202]
			0, -- [203]
			0, -- [204]
			0, -- [205]
			0, -- [206]
			0, -- [207]
			0, -- [208]
			0, -- [209]
			0, -- [210]
			0, -- [211]
			0, -- [212]
			0, -- [213]
			0, -- [214]
			0, -- [215]
			0, -- [216]
			0, -- [217]
			0, -- [218]
			0, -- [219]
			0, -- [220]
			0, -- [221]
			0, -- [222]
			0, -- [223]
			0, -- [224]
			0, -- [225]
			0, -- [226]
			0, -- [227]
			0, -- [228]
			0, -- [229]
			0, -- [230]
			0, -- [231]
			0, -- [232]
			0, -- [233]
			0, -- [234]
			0, -- [235]
			0, -- [236]
			0, -- [237]
			0, -- [238]
			0, -- [239]
			0, -- [240]
			0, -- [241]
			0, -- [242]
			0, -- [243]
			0, -- [244]
			0, -- [245]
			0, -- [246]
			0, -- [247]
			0, -- [248]
			0, -- [249]
			0, -- [250]
			0, -- [251]
			0, -- [252]
			0, -- [253]
			0, -- [254]
			0, -- [255]
			0, -- [256]
			0, -- [257]
			0, -- [258]
			0, -- [259]
			0, -- [260]
			0, -- [261]
			0, -- [262]
			0, -- [263]
			0, -- [264]
			0, -- [265]
			0, -- [266]
			0, -- [267]
			0, -- [268]
			0, -- [269]
			0, -- [270]
			0, -- [271]
			0, -- [272]
			0, -- [273]
			0, -- [274]
			0, -- [275]
			0, -- [276]
			0, -- [277]
			0, -- [278]
			0, -- [279]
			0, -- [280]
			0, -- [281]
			0, -- [282]
			0, -- [283]
			0, -- [284]
			0, -- [285]
			0, -- [286]
			0, -- [287]
			0, -- [288]
			0, -- [289]
			0, -- [290]
			0, -- [291]
			0, -- [292]
			0, -- [293]
			0, -- [294]
			0, -- [295]
			0, -- [296]
			0, -- [297]
			0, -- [298]
			0, -- [299]
			0, -- [300]
			0, -- [301]
			0, -- [302]
			0, -- [303]
			0, -- [304]
			0, -- [305]
			0, -- [306]
			0, -- [307]
			0, -- [308]
			0, -- [309]
			0, -- [310]
			0, -- [311]
			0, -- [312]
			0, -- [313]
			0, -- [314]
			0, -- [315]
			0, -- [316]
			0, -- [317]
			0, -- [318]
			0, -- [319]
			0, -- [320]
			0, -- [321]
			0, -- [322]
			0, -- [323]
			0, -- [324]
			0, -- [325]
			0, -- [326]
			0, -- [327]
			0, -- [328]
			0, -- [329]
			0, -- [330]
			0, -- [331]
			0, -- [332]
			0, -- [333]
			0, -- [334]
			0, -- [335]
			0, -- [336]
			0, -- [337]
			0, -- [338]
			0, -- [339]
			0, -- [340]
			0, -- [341]
			0, -- [342]
			0, -- [343]
			0, -- [344]
			0, -- [345]
			0, -- [346]
			0, -- [347]
			0, -- [348]
			0, -- [349]
			0, -- [350]
			0, -- [351]
			0, -- [352]
			0, -- [353]
			0, -- [354]
			0, -- [355]
			0, -- [356]
			0, -- [357]
			0, -- [358]
			0, -- [359]
			0, -- [360]
			[0] = 0,
		},
		["DoResetAoe"] = false,
		["UsablePending"] = {
		},
		["AurasByType"] = {
			["Combo"] = {
			},
			["Mana"] = {
			},
			["RaidBuffs"] = {
			},
			["RageEnergy"] = {
			},
			["NamedUnitHealth"] = {
			},
			["Aoe"] = {
			},
			["GroupOrSelfBuffs"] = {
			},
			["TargetRageEnergy"] = {
			},
			["RaidPvP"] = {
			},
			["Aggro"] = {
			},
			["Spells"] = {
			},
			["UnitBuffs"] = {
			},
			["PartyPvP"] = {
			},
			["Health"] = {
			},
			["PartyAggro"] = {
			},
			["FocusRageEnergy"] = {
			},
			["Stance"] = {
			},
			["TargetPvP"] = {
			},
			["PartyBuffs"] = {
			},
			["PartyHealth"] = {
			},
			["FocusBuffs"] = {
			},
			["TargetHealth"] = {
			},
			["Actions"] = {
			},
			["RaidRageEnergy"] = {
			},
			["TargetMana"] = {
			},
			["RaidAggro"] = {
			},
			["TargetSpells"] = {
			},
			["NamedUnitMana"] = {
			},
			["FocusSpells"] = {
			},
			["FocusMana"] = {
			},
			["RaidHealth"] = {
			},
			["TargetBuffs"] = {
			},
			["PvP"] = {
			},
			["FocusHealth"] = {
			},
			["PartyMana"] = {
			},
			["UnitRageEnergy"] = {
			},
			["Enchants"] = {
			},
			["Buffs"] = {
			},
			["PartyRageEnergy"] = {
			},
			["RaidMana"] = {
			},
		},
		["DefaultOperator"] = ">=",
		["WeAreInRaid"] = false,
		["Version"] = "v2.6.2",
		["speedScale"] = 0,
		["Display"] = {
			"Zoom In", -- [1]
			"Zoom Out", -- [2]
			"Opacity only", -- [3]
			"Left", -- [4]
			"Top-Left", -- [5]
			"Top", -- [6]
			"Top-Right", -- [7]
			"Right", -- [8]
			"Bottom-Right", -- [9]
			"Bottom", -- [10]
			"Bottom-Left", -- [11]
			[0] = "[None]",
		},
		["SecondeAura"] = 0,
		["DoCheck"] = {
			["Mounted"] = false,
			["Combo"] = false,
			["Mana"] = false,
			["RaidBuffs"] = false,
			["RageEnergy"] = false,
			["NamedUnitHealth"] = false,
			["RaidAggro"] = false,
			["GroupOrSelfBuffs"] = false,
			["TargetRageEnergy"] = false,
			["RaidPvP"] = false,
			["Aggro"] = false,
			["Spells"] = false,
			["UnitBuffs"] = false,
			["PartyPvP"] = false,
			["Health"] = false,
			["PartyAggro"] = false,
			["FocusRageEnergy"] = false,
			["Stance"] = false,
			["TargetPvP"] = false,
			["PartyBuffs"] = false,
			["PartyHealth"] = false,
			["FocusBuffs"] = false,
			["TargetMana"] = false,
			["TargetHealth"] = false,
			["Actions"] = false,
			["RaidRageEnergy"] = false,
			["Aoe"] = false,
			["Others"] = true,
			["TargetSpells"] = false,
			["NamedUnitMana"] = false,
			["FocusSpells"] = false,
			["FocusMana"] = false,
			["RaidHealth"] = false,
			["TargetBuffs"] = false,
			["PartyMana"] = false,
			["FocusHealth"] = false,
			["UnitRageEnergy"] = false,
			["Enchants"] = false,
			["PvP"] = false,
			["Buffs"] = false,
			["PartyRageEnergy"] = false,
			["RaidMana"] = false,
		},
		["BuffTypes"] = {
			["TypeDebuff"] = 3,
			["EnergyRagePower"] = 10,
			["Buff"] = 1,
			["Aggro"] = 11,
			["Mana"] = 9,
			["ActionReady"] = 7,
			["SpellAlert"] = 13,
			["Debuff"] = 2,
			["Health"] = 8,
			["Enchant"] = 5,
			["Combo"] = 6,
			["PvP"] = 12,
			["AoE"] = 4,
			["Stance"] = 14,
		},
	},
	["PartyLeaderIndex"] = 0,
	["targettarget"] = {
		["Visible"] = 1,
		["FactionGroup"] = "Horde",
		["InParty"] = 1,
		["Unit"] = "targettarget",
		["HealthMax"] = 65,
		["ChannelInfo"] = {
		},
		["ThreatSituation"] = 3,
		["XPMax"] = 400,
		["CastingInfo"] = {
		},
		["Damage"] = 4.314286231994629,
		["IsPlayer"] = 1,
		["Classification"] = "normal",
		["TargetTarget"] = "Himan",
		["Power"] = {
			100, -- [1]
			100, -- [2]
			78, -- [3]
			0, -- [4]
			8, -- [5]
			0, -- [6]
			["Default"] = 78,
			[0] = 0,
		},
		["RangedAttackPower"] = 16,
		["InteractDistance"] = {
			1, -- [1]
			1, -- [2]
			1, -- [3]
			1, -- [4]
		},
		["Target"] = "Mottled Boar",
		["PowerType"] = 3,
		["Health"] = 62,
		["Stats"] = {
			{
				["Type"] = "Strength",
				["PosBuff"] = 0,
				["NegBuff"] = 0,
				["Base"] = 22,
				["Stat"] = 22,
			}, -- [1]
			{
				["Type"] = "Agility",
				["PosBuff"] = 0,
				["NegBuff"] = 0,
				["Base"] = 25,
				["Stat"] = 25,
			}, -- [2]
			{
				["Type"] = "Stamina",
				["PosBuff"] = 0,
				["NegBuff"] = 0,
				["Base"] = 22,
				["Stat"] = 22,
			}, -- [3]
			{
				["Type"] = "Intellect",
				["PosBuff"] = 0,
				["NegBuff"] = 0,
				["Base"] = 16,
				["Stat"] = 16,
			}, -- [4]
			{
				["Type"] = "Spirit",
				["PosBuff"] = 0,
				["NegBuff"] = 0,
				["Base"] = 21,
				["Stat"] = 21,
			}, -- [5]
		},
		["RangedAttack"] = 1,
		["Race"] = "Troll",
		["PVPRank"] = 0,
		["PVPName"] = "Himan",
		["LocClass"] = "Rogue",
		["Debuffs"] = {
		},
		["AttackSpeed"] = 1.600000075995922,
		["PowerMax"] = {
			100, -- [1]
			100, -- [2]
			100, -- [3]
			0, -- [4]
			8, -- [5]
			100, -- [6]
			["Default"] = 100,
			[0] = 0,
		},
		["Class"] = "ROGUE",
		["Friend"] = 1,
		["ManaMax"] = 100,
		["Mana"] = 78,
		["RangedDamage"] = 1.800000085495412,
		["TargetInCombat"] = 1,
		["Armor"] = 52,
		["Level"] = 1,
		["XP"] = 100,
		["AttackPower"] = 29,
		["Defense"] = 5,
		["UnitHasVehicleUI"] = false,
		["Connected"] = 1,
		["Tooltip"] = {
			["Left1"] = "Himan",
			["NumLines"] = 2,
			["Left2"] = "Level 1 Troll Rogue (Player)",
		},
		["CanCooperate"] = 1,
		["AttackBothHands"] = 5,
		["Resistances"] = {
			{
				["Type"] = "Holy",
				["Malus"] = 0,
				["Total"] = 0,
				["Base"] = 0,
				["Bonus"] = 0,
			}, -- [1]
			{
				["Type"] = "Fire",
				["Malus"] = 0,
				["Total"] = 0,
				["Base"] = 0,
				["Bonus"] = 0,
			}, -- [2]
			{
				["Type"] = "Nature",
				["Malus"] = 0,
				["Total"] = 0,
				["Base"] = 0,
				["Bonus"] = 0,
			}, -- [3]
			{
				["Type"] = "Frost",
				["Malus"] = 0,
				["Total"] = 0,
				["Base"] = 0,
				["Bonus"] = 0,
			}, -- [4]
			{
				["Type"] = "Shadow",
				["Malus"] = 0,
				["Total"] = 0,
				["Base"] = 0,
				["Bonus"] = 0,
			}, -- [5]
			{
				["Type"] = "Arcane",
				["Malus"] = 0,
				["Total"] = 0,
				["Base"] = 0,
				["Bonus"] = 0,
			}, -- [6]
			[0] = {
				["Type"] = "Physical",
				["Malus"] = 0,
				["Total"] = 52,
				["Base"] = 52,
				["Bonus"] = 0,
			},
		},
		["Player"] = 1,
		["Name"] = "Himan",
		["Sex"] = 2,
		["CreatureType"] = "Humanoid",
		["Buffs"] = {
		},
		["InCombat"] = 1,
		["Pos"] = {
			["Y"] = 0.7232962846755981,
			["X"] = 0.4380789697170258,
		},
	},
	["Macros"] = {
		{
			["Body"] = "/cleartarget<LF>/tar Dirkee<LF>/tar Vyra<LF>/tar Time<LF>/stopmacro [noexists]<LF>/tell smacker > %t <<LF>/run PlaySoundFile(\"Sound\\\\Music\\\\ZoneMusic\\\\DMF_L70ETC01.mp3\")<LF>",
			["Name"] = "Drake",
			["Texture"] = "Interface\\Icons\\Ability_Mount_Drake_Blue",
		}, -- [1]
		{
			["Body"] = "#ShowToolTip<LF>/castsequence Divine Shield, Divine Sacrifice<LF>",
			["Name"] = "DS",
			["Texture"] = "Interface\\Icons\\Spell_Holy_PowerWordBarrier",
		}, -- [2]
		{
			["Body"] = "/powa dump<LF>",
			["Name"] = "Dump",
			["Texture"] = "Interface\\Icons\\Ability_Hunter_MarkedForDeath",
		}, -- [3]
		{
			["Body"] = "/use Warts-B-Gone Lip Balm<LF>/kiss<LF>",
			["Name"] = "Frog",
			["Texture"] = "Interface\\Icons\\INV_Misc_QuestionMark",
		}, -- [4]
		{
			["Body"] = "/p Help! Healer has aggro!<LF>",
			["Name"] = "Help",
			["Texture"] = "Interface\\Icons\\Ability_Mage_ChilledToTheBone",
		}, -- [5]
		{
			["Body"] = "/targetexact Ewe<LF>/targetexact Parrot<LF>/targetexact Ram<LF>/love<LF>",
			["Name"] = "Love",
			["Texture"] = "Interface\\Icons\\Spell_BrokenHeart",
		}, -- [6]
		{
			["Body"] = "/script UIErrorsFrame:UnregisterEvent(\"UI_ERROR_MESSAGE\");<LF>/console Sound_EnableSFX 0<LF>",
			["Name"] = "Off",
			["Texture"] = "Interface\\Icons\\Ability_Druid_Eclipse",
		}, -- [7]
		{
			["Body"] = "/script UIErrorsFrame:RegisterEvent(\"UI_ERROR_MESSAGE\");<LF>/console Sound_EnableSFX 1<LF>",
			["Name"] = "On",
			["Texture"] = "Interface\\Icons\\Ability_Druid_EclipseOrange",
		}, -- [8]
		{
			["Body"] = "/cleartarget<LF>/click MultiBarLeftButton3<LF>/stopmacro [exists]<LF>/click SilverDragonMacroButton<LF>/stopmacro [noexists]<LF>/tell smacker > %t <<LF>",
			["Name"] = "rare3",
			["Texture"] = "Interface\\Icons\\Ability_Spy",
		}, -- [9]
		{
			["Body"] = "#showtooltip Redemption<LF>/cast Redemption<LF>/stopmacro [combat,nohelp,nodead]<LF>/say Upsadaisy, %t!<LF>",
			["Name"] = "Rez",
			["Texture"] = "Interface\\Icons\\Spell_Holy_Resurrection",
		}, -- [10]
		{
			["Body"] = "/click SilverDragonMacroButton<LF>",
			["Name"] = "SilverDragon",
			["Texture"] = "Interface\\Icons\\Ability_Hunter_SniperTraining",
		}, -- [11]
		{
			["Body"] = "/target Elder Stranglethorn Tiger<LF>",
			["Name"] = "Tiger",
			["Texture"] = "Interface\\Icons\\INV_Misc_QuestionMark",
		}, -- [12]
		{
		}, -- [13]
		{
		}, -- [14]
		{
		}, -- [15]
		{
		}, -- [16]
		{
		}, -- [17]
		{
		}, -- [18]
		{
		}, -- [19]
		{
		}, -- [20]
		{
		}, -- [21]
		{
		}, -- [22]
		{
		}, -- [23]
		{
		}, -- [24]
		{
		}, -- [25]
		{
		}, -- [26]
		{
		}, -- [27]
		{
		}, -- [28]
		{
		}, -- [29]
		{
		}, -- [30]
		{
		}, -- [31]
		{
		}, -- [32]
		{
		}, -- [33]
		{
		}, -- [34]
		{
		}, -- [35]
		{
		}, -- [36]
	},
	["SpellTabs"] = {
		{
			["Offset"] = 0,
			["Count"] = 9,
			["Name"] = "General",
			["Texture"] = "Interface\\Icons\\Ability_Kick",
		}, -- [1]
		{
			["Offset"] = 9,
			["Count"] = 1,
			["Name"] = "Assassination",
			["Texture"] = "Interface\\Icons\\Ability_Rogue_Eviscerate",
		}, -- [2]
		{
			["Offset"] = 10,
			["Count"] = 1,
			["Name"] = "Combat",
			["Texture"] = "Interface\\Icons\\Ability_BackStab",
		}, -- [3]
		{
			["Offset"] = 0,
			["Count"] = 0,
		}, -- [4]
		{
			["Offset"] = 0,
			["Count"] = 0,
		}, -- [5]
		{
			["Offset"] = 0,
			["Count"] = 0,
		}, -- [6]
		{
			["Offset"] = 0,
			["Count"] = 0,
		}, -- [7]
		{
			["Offset"] = 0,
			["Count"] = 0,
		}, -- [8]
	},
	["player"] = {
		["Visible"] = 1,
		["FactionGroup"] = "Horde",
		["InParty"] = 1,
		["Unit"] = "player",
		["HealthMax"] = 65,
		["ChannelInfo"] = {
		},
		["ThreatSituation"] = 3,
		["XPMax"] = 400,
		["CastingInfo"] = {
		},
		["Damage"] = 4.314286231994629,
		["IsPlayer"] = 1,
		["Classification"] = "normal",
		["TargetTarget"] = "Himan",
		["Power"] = {
			100, -- [1]
			100, -- [2]
			78, -- [3]
			0, -- [4]
			8, -- [5]
			0, -- [6]
			["Default"] = 78,
			[0] = 0,
		},
		["RangedAttackPower"] = 16,
		["InteractDistance"] = {
			1, -- [1]
			1, -- [2]
			1, -- [3]
			1, -- [4]
		},
		["Target"] = "Mottled Boar",
		["PowerType"] = 3,
		["Health"] = 62,
		["Stats"] = {
			{
				["Type"] = "Strength",
				["PosBuff"] = 0,
				["NegBuff"] = 0,
				["Base"] = 22,
				["Stat"] = 22,
			}, -- [1]
			{
				["Type"] = "Agility",
				["PosBuff"] = 0,
				["NegBuff"] = 0,
				["Base"] = 25,
				["Stat"] = 25,
			}, -- [2]
			{
				["Type"] = "Stamina",
				["PosBuff"] = 0,
				["NegBuff"] = 0,
				["Base"] = 22,
				["Stat"] = 22,
			}, -- [3]
			{
				["Type"] = "Intellect",
				["PosBuff"] = 0,
				["NegBuff"] = 0,
				["Base"] = 16,
				["Stat"] = 16,
			}, -- [4]
			{
				["Type"] = "Spirit",
				["PosBuff"] = 0,
				["NegBuff"] = 0,
				["Base"] = 21,
				["Stat"] = 21,
			}, -- [5]
		},
		["RangedAttack"] = 1,
		["Race"] = "Troll",
		["PVPRank"] = 0,
		["PVPName"] = "Himan",
		["LocClass"] = "Rogue",
		["Debuffs"] = {
		},
		["AttackSpeed"] = 1.600000075995922,
		["PowerMax"] = {
			100, -- [1]
			100, -- [2]
			100, -- [3]
			0, -- [4]
			8, -- [5]
			100, -- [6]
			["Default"] = 100,
			[0] = 0,
		},
		["Class"] = "ROGUE",
		["Friend"] = 1,
		["ManaMax"] = 100,
		["Mana"] = 78,
		["RangedDamage"] = 1.800000085495412,
		["TargetInCombat"] = 1,
		["Armor"] = 52,
		["Level"] = 1,
		["XP"] = 100,
		["AttackPower"] = 29,
		["Defense"] = 5,
		["UnitHasVehicleUI"] = false,
		["Connected"] = 1,
		["Tooltip"] = {
			["Left1"] = "Himan",
			["NumLines"] = 2,
			["Left2"] = "Level 1 Troll Rogue (Player)",
		},
		["CanCooperate"] = 1,
		["AttackBothHands"] = 5,
		["Resistances"] = {
			{
				["Type"] = "Holy",
				["Malus"] = 0,
				["Total"] = 0,
				["Base"] = 0,
				["Bonus"] = 0,
			}, -- [1]
			{
				["Type"] = "Fire",
				["Malus"] = 0,
				["Total"] = 0,
				["Base"] = 0,
				["Bonus"] = 0,
			}, -- [2]
			{
				["Type"] = "Nature",
				["Malus"] = 0,
				["Total"] = 0,
				["Base"] = 0,
				["Bonus"] = 0,
			}, -- [3]
			{
				["Type"] = "Frost",
				["Malus"] = 0,
				["Total"] = 0,
				["Base"] = 0,
				["Bonus"] = 0,
			}, -- [4]
			{
				["Type"] = "Shadow",
				["Malus"] = 0,
				["Total"] = 0,
				["Base"] = 0,
				["Bonus"] = 0,
			}, -- [5]
			{
				["Type"] = "Arcane",
				["Malus"] = 0,
				["Total"] = 0,
				["Base"] = 0,
				["Bonus"] = 0,
			}, -- [6]
			[0] = {
				["Type"] = "Physical",
				["Malus"] = 0,
				["Total"] = 52,
				["Base"] = 52,
				["Bonus"] = 0,
			},
		},
		["Player"] = 1,
		["Name"] = "Himan",
		["Sex"] = 2,
		["CreatureType"] = "Humanoid",
		["Buffs"] = {
		},
		["InCombat"] = 1,
		["Pos"] = {
			["Y"] = 0.7232962846755981,
			["X"] = 0.4380789697170258,
		},
	},
	["ShapeshiftForm"] = 0,
	["ActionSlots"] = {
		{
			["Tooltip"] = {
				["Left1"] = "Attack",
				["NumLines"] = 1,
			},
			["CurrentAction"] = 1,
			["UsableAction"] = 1,
			["Count"] = 0,
			["AttackAction"] = 1,
			["Texture"] = "Interface\\Icons\\INV_Weapon_ShortBlade_05",
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 1,
			},
			["HasAction"] = 1,
		}, -- [1]
		{
			["HasRange"] = 1,
			["Tooltip"] = {
				["Left1"] = "Sinister Strike",
				["Left2"] = "45 Energy",
				["Right1"] = "Rank 1",
				["Left5"] = "An instant strike that causes 3 damage in addition to your normal weapon damage.  Awards 1 combo point.",
				["Left3"] = "Instant",
				["Right2"] = "Melee Range",
				["NumLines"] = 5,
				["Left4"] = "Requires Melee Weapon",
			},
			["UsableAction"] = 1,
			["Count"] = 0,
			["InRange"] = 1,
			["Texture"] = "Interface\\Icons\\Spell_Shadow_RitualOfSacrifice",
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 1,
			},
			["HasAction"] = 1,
		}, -- [2]
		{
			["HasRange"] = 1,
			["Tooltip"] = {
				["Left1"] = "Eviscerate",
				["Left2"] = "35 Energy",
				["Right1"] = "Rank 1",
				["Left5"] = "Finishing move that causes damage per combo point:<CR><LF>   1 point  : 7-12 damage<CR><LF>   2 points: 13-19 damage<CR><LF>   3 points: 19-26 damage<CR><LF>   4 points: 24-33 damage<CR><LF>   5 points: 30-40 damage",
				["Left3"] = "Instant",
				["Right2"] = "Melee Range",
				["NumLines"] = 5,
				["Left4"] = "Requires Melee Weapon",
			},
			["UsableAction"] = 1,
			["Count"] = 0,
			["InRange"] = 1,
			["Texture"] = "Interface\\Icons\\Ability_Rogue_Eviscerate",
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 1,
			},
			["HasAction"] = 1,
		}, -- [3]
		{
			["HasRange"] = 1,
			["Tooltip"] = {
				["Left2"] = "5-30 yd range",
				["Left1"] = "Throw",
				["Left4"] = "Requires Thrown",
				["Left5"] = "Hurl a thrown weapon at the target.",
				["Left3"] = "0.5 sec cast",
				["NumLines"] = 5,
				["Right3"] = "1.8 sec cooldown",
			},
			["UsableAction"] = 1,
			["Count"] = 0,
			["InRange"] = 0,
			["Texture"] = "Interface\\Icons\\Ability_Throw",
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 1,
			},
			["HasAction"] = 1,
		}, -- [4]
		{
			["Tooltip"] = {
				["Left1"] = "Berserking",
				["Left2"] = "Instant",
				["Right1"] = "Racial",
				["Left3"] = "Increases your attack speed by 10% to 30%.  At full health the speed increase is 10% with a greater effect up to 30% if you are badly hurt when you activate Berserking.  Lasts 10 sec.",
				["Right2"] = "3 min cooldown",
				["NumLines"] = 3,
			},
			["UsableAction"] = 1,
			["Count"] = 0,
			["Texture"] = "Interface\\Icons\\Racial_Troll_Berserk",
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 1,
			},
			["HasAction"] = 1,
		}, -- [5]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [6]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [7]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [8]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [9]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [10]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [11]
		{
			["Tooltip"] = {
				["Left1"] = "Tough Jerky",
				["NumLines"] = 2,
				["Left2"] = "Use: Restores 61 health over 18 sec.  Must remain seated while eating.",
			},
			["Count"] = 5,
			["Texture"] = "Interface\\Icons\\INV_Misc_Food_16",
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 1,
			},
			["HasAction"] = 1,
		}, -- [12]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [13]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [14]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [15]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [16]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [17]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [18]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [19]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [20]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [21]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [22]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [23]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [24]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [25]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [26]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [27]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [28]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [29]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [30]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [31]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [32]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [33]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [34]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [35]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [36]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [37]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [38]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [39]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [40]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [41]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [42]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [43]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [44]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [45]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [46]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [47]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [48]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [49]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [50]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [51]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [52]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [53]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [54]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [55]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [56]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [57]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [58]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [59]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [60]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [61]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [62]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [63]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [64]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [65]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [66]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [67]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [68]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [69]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [70]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [71]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [72]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [73]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [74]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [75]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [76]
		{
			["Tooltip"] = {
				["Left1"] = "Berserking",
				["Left2"] = "Instant",
				["Right1"] = "Racial",
				["Left3"] = "Increases your attack speed by 10% to 30%.  At full health the speed increase is 10% with a greater effect up to 30% if you are badly hurt when you activate Berserking.  Lasts 10 sec.",
				["Right2"] = "3 min cooldown",
				["NumLines"] = 3,
			},
			["UsableAction"] = 1,
			["Count"] = 0,
			["Texture"] = "Interface\\Icons\\Racial_Troll_Berserk",
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 1,
			},
			["HasAction"] = 1,
		}, -- [77]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [78]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [79]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [80]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [81]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [82]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [83]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [84]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [85]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [86]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [87]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [88]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [89]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [90]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [91]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [92]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [93]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [94]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [95]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [96]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [97]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [98]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [99]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [100]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [101]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [102]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [103]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [104]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [105]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [106]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [107]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [108]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [109]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [110]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [111]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [112]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [113]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [114]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [115]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [116]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [117]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [118]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [119]
		{
			["Count"] = 0,
			["Cooldown"] = {
				["Start"] = 0,
				["Duration"] = 0,
				["Enabled"] = 0,
			},
		}, -- [120]
	},
	["SpellBook"] = {
		{
			["Name"] = "Attack",
			["Texture"] = "Interface\\Icons\\INV_Weapon_ShortBlade_05",
			["Tooltip"] = {
				["Left1"] = "Attack",
				["NumLines"] = 2,
				["Left2"] = "10.90% chance to crit",
			},
			["Cooldown"] = {
				["Enabled"] = 1,
				["StartTime"] = 0,
				["Duration"] = 0,
			},
			["Rank"] = "",
		}, -- [1]
		{
			["Name"] = "Beast Slaying",
			["Texture"] = "Interface\\Icons\\INV_Misc_Pelt_Bear_Ruin_02",
			["Tooltip"] = {
				["Left1"] = "Beast Slaying",
				["NumLines"] = 2,
				["Left2"] = "Damage dealt versus Beasts increased by 5%.",
			},
			["Cooldown"] = {
				["Enabled"] = 1,
				["StartTime"] = 0,
				["Duration"] = 0,
			},
			["Rank"] = "Racial Passive",
		}, -- [2]
		{
			["Name"] = "Berserking",
			["Texture"] = "Interface\\Icons\\Racial_Troll_Berserk",
			["Tooltip"] = {
				["Left1"] = "Berserking",
				["Left2"] = "Instant",
				["Left3"] = "Increases your attack speed by 10% to 30%.  At full health the speed increase is 10% with a greater effect up to 30% if you are badly hurt when you activate Berserking.  Lasts 10 sec.",
				["Right2"] = "3 min cooldown",
				["NumLines"] = 3,
			},
			["Cooldown"] = {
				["Enabled"] = 1,
				["StartTime"] = 0,
				["Duration"] = 0,
			},
			["Rank"] = "Racial",
		}, -- [3]
		{
			["Name"] = "Bow Specialization",
			["Texture"] = "Interface\\Icons\\INV_Weapon_Bow_12",
			["Tooltip"] = {
				["Left1"] = "Bow Specialization",
				["Left2"] = "Requires Bows",
				["Left3"] = "Your chance to critically hit with Bows is increased by 1%.",
				["NumLines"] = 3,
			},
			["Cooldown"] = {
				["Enabled"] = 1,
				["StartTime"] = 0,
				["Duration"] = 0,
			},
			["Rank"] = "Racial Passive",
		}, -- [4]
		{
			["Name"] = "Da Voodoo Shuffle",
			["Texture"] = "Interface\\Icons\\INV_Misc_Idol_02",
			["Tooltip"] = {
				["Left1"] = "Da Voodoo Shuffle",
				["NumLines"] = 2,
				["Left2"] = "Reduces the duration of all movement impairing effects by 15%.  Trolls be flippin' out mon!",
			},
			["Cooldown"] = {
				["Enabled"] = 1,
				["StartTime"] = 0,
				["Duration"] = 0,
			},
			["Rank"] = "Racial Passive",
		}, -- [5]
		{
			["Name"] = "Dodge",
			["Texture"] = "Interface\\Icons\\Spell_Nature_Invisibilty",
			["Tooltip"] = {
				["Left1"] = "Dodge",
				["Left2"] = "21.79% chance to dodge",
				["Left3"] = "Gives a chance to dodge enemy melee attacks.",
				["NumLines"] = 3,
			},
			["Cooldown"] = {
				["Enabled"] = 1,
				["StartTime"] = 0,
				["Duration"] = 0,
			},
			["Rank"] = "Passive",
		}, -- [6]
		{
			["Name"] = "Regeneration",
			["Texture"] = "Interface\\Icons\\Spell_Nature_Regenerate",
			["Tooltip"] = {
				["Left1"] = "Regeneration",
				["NumLines"] = 2,
				["Left2"] = "Health regeneration rate increased by 10%.  10% of total Health regeneration may continue during combat.",
			},
			["Cooldown"] = {
				["Enabled"] = 1,
				["StartTime"] = 0,
				["Duration"] = 0,
			},
			["Rank"] = "Racial Passive",
		}, -- [7]
		{
			["Name"] = "Throw",
			["Texture"] = "Interface\\Icons\\Ability_Throw",
			["Tooltip"] = {
				["Left2"] = "5-30 yd range",
				["Left1"] = "Throw",
				["Left4"] = "Requires Thrown",
				["Left5"] = "Hurl a thrown weapon at the target.",
				["Left3"] = "0.5 sec cast",
				["NumLines"] = 5,
				["Right3"] = "1.8 sec cooldown",
			},
			["Cooldown"] = {
				["Enabled"] = 1,
				["StartTime"] = 0,
				["Duration"] = 0,
			},
			["Rank"] = "",
		}, -- [8]
		{
			["Name"] = "Throwing Specialization",
			["Texture"] = "Interface\\Icons\\INV_ThrowingAxe_03",
			["Tooltip"] = {
				["Left1"] = "Throwing Specialization",
				["Left2"] = "Requires Thrown",
				["Left3"] = "Your chance to critically hit with Throwing Weapons is increased by 1%.",
				["NumLines"] = 3,
			},
			["Cooldown"] = {
				["Enabled"] = 1,
				["StartTime"] = 0,
				["Duration"] = 0,
			},
			["Rank"] = "Racial Passive",
		}, -- [9]
		{
			["Name"] = "Eviscerate",
			["Texture"] = "Interface\\Icons\\Ability_Rogue_Eviscerate",
			["Tooltip"] = {
				["Left1"] = "Eviscerate",
				["Left4"] = "Requires Melee Weapon",
				["Left5"] = "Finishing move that causes damage per combo point:<CR><LF>   1 point  : 7-12 damage<CR><LF>   2 points: 13-19 damage<CR><LF>   3 points: 19-26 damage<CR><LF>   4 points: 24-33 damage<CR><LF>   5 points: 30-40 damage",
				["Left3"] = "Instant",
				["Right2"] = "Melee Range",
				["NumLines"] = 5,
				["Left2"] = "35 Energy",
			},
			["Cooldown"] = {
				["Enabled"] = 1,
				["StartTime"] = 0,
				["Duration"] = 0,
			},
			["Rank"] = "Rank 1",
		}, -- [10]
		{
			["Name"] = "Sinister Strike",
			["Texture"] = "Interface\\Icons\\Spell_Shadow_RitualOfSacrifice",
			["Tooltip"] = {
				["Left1"] = "Sinister Strike",
				["Left4"] = "Requires Melee Weapon",
				["Left5"] = "An instant strike that causes 3 damage in addition to your normal weapon damage.  Awards 1 combo point.",
				["Left3"] = "Instant",
				["Right2"] = "Melee Range",
				["NumLines"] = 5,
				["Left2"] = "45 Energy",
			},
			["Cooldown"] = {
				["Enabled"] = 1,
				["StartTime"] = 0,
				["Duration"] = 0,
			},
			["Rank"] = "Rank 1",
		}, -- [11]
	},
	["NumShapeshiftForms"] = 0,
	["PowaGlobal"] = {
		["maxtextures"] = 50,
	},
	["Battlefields"] = {
		{
			["Status"] = "none",
			["Id"] = 0,
		}, -- [1]
		{
			["Status"] = "none",
			["Id"] = 0,
		}, -- [2]
		{
			["Status"] = "none",
			["Id"] = 0,
		}, -- [3]
	},
}
