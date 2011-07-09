﻿--- English localisations

--if (GetLocale() == "enEN") then

PowaAuras.Anim[0] = "[Invisible]";
PowaAuras.Anim[1] = "Static";
PowaAuras.Anim[2] = "Flashing";
PowaAuras.Anim[3] = "Growing";
PowaAuras.Anim[4] = "Pulse";
PowaAuras.Anim[5] = "Bubble";
PowaAuras.Anim[6] = "Water drop";
PowaAuras.Anim[7] = "Electric";
PowaAuras.Anim[8] = "Shrinking";
PowaAuras.Anim[9] = "Flame";
PowaAuras.Anim[10] = "Orbit";
PowaAuras.Anim[11] = "Spin Clockwise";
PowaAuras.Anim[12] = "Spin Anti-Clockwise";

PowaAuras.BeginAnimDisplay[0] = "[None]";
PowaAuras.BeginAnimDisplay[1] = "Zoom In";
PowaAuras.BeginAnimDisplay[2] = "Zoom Out";
PowaAuras.BeginAnimDisplay[3] = "Fade In";
PowaAuras.BeginAnimDisplay[4] = "Left";
PowaAuras.BeginAnimDisplay[5] = "Top-Left";
PowaAuras.BeginAnimDisplay[6] = "Top";
PowaAuras.BeginAnimDisplay[7] = "Top-Right";
PowaAuras.BeginAnimDisplay[8] = "Right";
PowaAuras.BeginAnimDisplay[9] = "Bottom-Right";
PowaAuras.BeginAnimDisplay[10] = "Bottom";
PowaAuras.BeginAnimDisplay[11] = "Bottom-Left";
PowaAuras.BeginAnimDisplay[12] = "Bounce";

PowaAuras.EndAnimDisplay[0] = "[None]";
PowaAuras.EndAnimDisplay[1] = "Grow";
PowaAuras.EndAnimDisplay[2] = "Shrink";
PowaAuras.EndAnimDisplay[3] = "Fade Out";
PowaAuras.EndAnimDisplay[4] = "Spin";
PowaAuras.EndAnimDisplay[5] = "Spin In";

PowaAuras.Sound[0] = NONE;
PowaAuras.Sound[30] = NONE;

PowaAuras:MergeTables(PowaAuras.Text, 
{
	welcome = "Type /powa to view the options.",

	aucune = "None",
	aucun = "None",
	largeur = "Width",
	hauteur = "Height",
	mainHand = "main",
	offHand = "off",
	bothHands = "both",

	Unknown	 = "unknown",

	DebuffType =
	{
		Magic   = "Magic",
		Disease = "Disease",
		Curse   = "Curse",
		Poison  = "Poison",
		-- Non standard types below here.
		Enrage  = "Enrage",
	},

	DebuffCatType =
	{
		[PowaAuras.DebuffCatType.CC]      = "CC",
		[PowaAuras.DebuffCatType.Silence] = "Silence",
		[PowaAuras.DebuffCatType.Snare]   = "Snare",
		[PowaAuras.DebuffCatType.Stun]    = "Stun",
		[PowaAuras.DebuffCatType.Root]    = "Root",
		[PowaAuras.DebuffCatType.Disarm]  = "Disarm",
		[PowaAuras.DebuffCatType.PvE]     = "PvE",
	},
	
	Role =
	{
		RoleTank     = "Tank",
		RoleHealer   = "Healer",
		RoleMeleDps  = "Melee DPS",
		RoleRangeDps = "Ranged DPS",
	},
	
	nomReasonRole =
	{
		RoleTank     = "Is a Tank",
		RoleHealer   = "Is a Healer",
		RoleMeleDps  = "Is a Melee DPS",
		RoleRangeDps = "Is a Ranged DPS",
	},

	nomReasonNotRole =
	{
		RoleTank     = "Not a Tank",
		RoleHealer   = "Not a Healer",
		RoleMeleDps  = "Not a Melee DPS",
		RoleRangeDps = "Not a Ranged DPS",
	},
	
	AuraType =
	{
		[PowaAuras.BuffTypes.Buff] = "Buff",
		[PowaAuras.BuffTypes.Debuff] = "Debuff",
		[PowaAuras.BuffTypes.AoE] = "AOE Debuff",
		[PowaAuras.BuffTypes.TypeDebuff] = "Debuff type",
		[PowaAuras.BuffTypes.Enchant] = "Weapon Enchant",
		[PowaAuras.BuffTypes.Combo] = "Combo Points",
		[PowaAuras.BuffTypes.ActionReady] = "Action Usable",
		[PowaAuras.BuffTypes.Health] = "Health",
		[PowaAuras.BuffTypes.Mana] = "Mana",
		[PowaAuras.BuffTypes.EnergyRagePower] = "Rage/Energy/Power",
		[PowaAuras.BuffTypes.Aggro] = "Aggro",
		[PowaAuras.BuffTypes.PvP] = "PvP",
		[PowaAuras.BuffTypes.Stance] = "Stance",
		[PowaAuras.BuffTypes.SpellAlert] = "Spell Alert", 
		[PowaAuras.BuffTypes.SpellCooldown] = "Spell Cooldown", 
		[PowaAuras.BuffTypes.StealableSpell] = "Stealable Spell",
		[PowaAuras.BuffTypes.PurgeableSpell] = "Purgeable Spell",
		[PowaAuras.BuffTypes.Static] = "Static Aura",
		[PowaAuras.BuffTypes.Totems] = "Totems",
		[PowaAuras.BuffTypes.Pet] = "Pet",
		[PowaAuras.BuffTypes.Runes] = "Runes",
		[PowaAuras.BuffTypes.Slots] = "Equipment Slots",
		[PowaAuras.BuffTypes.Items] = "Named Items",
		[PowaAuras.BuffTypes.Tracking] = "Tracking",
		[PowaAuras.BuffTypes.TypeBuff] = "Buff type",
		[PowaAuras.BuffTypes.UnitMatch] = "Unit Match",
		[PowaAuras.BuffTypes.PetStance] = "Pet Stance",
		[PowaAuras.BuffTypes.GTFO] = "GTFO Alert",
	},
	
	PowerType =
	{
		[-1] = "Default",
		[SPELL_POWER_RAGE] = "Rage",
		[SPELL_POWER_FOCUS] = "Focus",
		[SPELL_POWER_ENERGY] = "Energy",
		[SPELL_POWER_RUNIC_POWER] = "Runic Power",
		[SPELL_POWER_SOUL_SHARDS] = "Soul Shards",
		[SPELL_POWER_LUNAR_ECLIPSE] = "Lunar Eclipse",
		[SPELL_POWER_SOLAR_ECLIPSE] = "Solar Eclipse",
		[SPELL_POWER_HOLY_POWER] = "Holy Power",
	},
	
	Relative = 
	{
		NONE        = "Free", 
		TOPLEFT     = "Top-Left", 
		TOP         = "Top", 
		TOPRIGHT    = "Top-Right", 
		RIGHT       = "Right", 
		BOTTOMRIGHT = "BottomRight", 
		BOTTOM      = "Bottom", 
		BOTTOMLEFT  = "Bottom-Left", 
		LEFT        = "Left", 
		CENTER      = "Center",
	},
	
	Slots =
	{
		Ammo = "Ammo",
		Back = "Back",
		Chest = "Chest",
		Feet = "Feet",
		Finger0 = "Finger1",
		Finger1 = "Finger2",
		Hands = "Hands",
		Head = "Head",
		Legs = "Legs",
		MainHand = "MainHand",
		Neck = "Neck",
		Ranged = "Ranged",
		SecondaryHand = "OffHand",
		Shirt = "Shirt",
		Shoulder = "Shoulder",
		Tabard = "Tabard",
		Trinket0 = "Trinket1",
		Trinket1 = "Trinket2",
		Waist = "Waist",
		Wrist = "Wrist",	
	},

	-- Main
	nomEnable = "Activate Power Auras",
	aideEnable = "Enable all Power Auras effects",

	nomDebug = "Activate Debug Messages",
	aideDebug = "Enable Debug Messages",
    nomTextureCount = "Max Textures",
	aideTextureCount = "Change this if you add your own textures",
	
	aideOverrideTextureCount = "Override the number of textures",
	nomOverrideTextureCount= "Set this if you are adding your own textures",

	ListePlayer = "Page",
	ListeGlobal = "Global",
	ListeClass = "Class",
	aideMove = "Move the effect here.",
	aideCopy = "Copy the effect here.",
	nomRename = "Rename",
	aideRename = "Rename the selected effect's page.",

	nomTest = "Test",
	nomTestAll = "Test All",
	nomHide = "Hide all",
	nomEdit = "Edit",
	nomNew = "New",
	nomDel = "Delete",
	nomImport = "Import", 
	nomExport = "Export", 
	nomImportSet = "Import Set", 
	nomExportSet = "Export Set", 
	nomUnlock = "Unlock",
	nomLock = "Lock",

	aideImport = "Press Ctrl-V to paste the Aura-string and press \'Accept\'",
	aideExport = "Press Ctrl-C to copy the Aura-string for sharing.",
	aideImportSet = "Press Ctrl-V to paste the Aura-Set-string and press \'Accept\' this will erase all auras on this page",
	aideExportSet = "Press Ctrl-C to copy all the Auras on this page for sharing.",
	aideDel = "Remove the selected effect (Hold CTRL to allow this button to work)",

	nomMove = "Move",
	nomCopy = "Copy",
	nomPlayerEffects = "Character effects",
	nomGlobalEffects = "Global\neffects",

	aideEffectTooltip = "(Shift-click to toggle effect ON or OFF)",
	aideEffectTooltip2 = "(Ctrl-click to give reason for activation)",

	aideItems = "Enter full name of Item or [xxx] for Id",
	aideSlots = "Enter name of slot to track: Ammo, Back, Chest, Feet, Finger0, Finger1, Hands, Head, Legs, MainHand, Neck, Ranged, SecondaryHand, Shirt, Shoulder, Tabard, Trinket0, Trinket1, Waist, Wrist",
	aideTracking = "Enter name of Tracking type e.g. fish",
	aideUnitMatch = "Enter the names of the units that need to match, separated by a forward slash (/).\n\nYou can use unit ID's such as \"player\", \"pet\", \"boss1\", \"arena1\", as well as an asterisk (*) to see if the unit in question exists.\n\n|cFFEFEFEFExamples|r\nTarget is Ragnaros:\ntarget/Ragnaros\n\nPet target exists:\npettarget/*\n\nBoss targetting me:\nboss1target/player",
	aidePetStance = "Enter the ID numbers of pet stances that need to be active in order for the aura to show. You can specify multiple stances to trigger an aura by separating them with a forward slash (/).\n\n|cFFEFEFEFStance ID Numbers|r\nAggressive/Assist = 1\nDefensive = 2\nPassive = 3\n\n|cFFFF0000Note: |rYou must have the three stances on your pet action bar for this to work.",
	
	-- editor
	aideCustomText = "Enter text to display (%t=target name, %f=focus name, %v=display value, %u=unit name, %str=str, %agl=agl, %sta=sta, %int=int, %spi=spi, %sp=spell power, %ap=attack power, %df=defence)",

	nomSoundStarting = "Starting Sound:",
	nomSound = "Sound to play",
	nomSound2 = "More sounds to play",
	aideSound = "Plays a sound at the beginning.",
	aideSound2 = "Plays a sound at the beginning.",
	nomCustomSound = "OR soundfile:",
	aideCustomSound = "Enter a soundfile that is in the Sounds folder, BEFORE you started the game. mp3 and wav are supported. example: 'cookie.mp3'\nOr\nEnter the full path to play any WoW sound e.g. Sound\\Events\\GuldanCheers.wav",

	nomCustomSoundPath = "Path to custom sounds:",
	aideCustomSoundPath = "Set this to your own path (within the WoW install) to prevent your own sounds being overwritten by updating Power Auras",

	nomCustomAuraPath = "Path to custom aura textures:",
	aideCustomAuraPath = "Set this to your own path (within the WoW install) to prevent your own textures being overwritten by updating Power Auras",

	nomSoundEnding = "Ending Sound:",
	nomSoundEnd = "Sound to play",
	nomSound2End = "More sounds to play",
	aideSoundEnd = "Plays a sound at the end.",
	aideSound2End = "Plays a sound at the end.",
	nomCustomSoundEnd = "OR soundfile:",
	aideCustomSoundEnd = "Enter a soundfile that is in the Sounds folder, BEFORE you started the game. mp3 and wav are supported. example: 'cookie.mp3'\nOr\nEnter the full path to play any WoW sound e.g. Sound\\Events\\GuldanCheers.wav",
	nomTexture = "Texture",
	aideTexture = "The texture to be shown. You can easily replace textures by changing the files Aura#.tga in the Addon's directory.",

	nomAnim1 = "Main Animation",
	nomAnim2 = "Secondary Animation",
	aideAnim1 = "Animate the texture or not, with various effects.",
	aideAnim2 = "This animation will be shown with less opacity than the main animaton. Attention, to not overload the screen.",

	nomDeform = "Deformation",
	aideDeform = "Stretch the texture in height or in width.",

	aideColor = "Click here to change the color of the texture.",
	aideTimerColor = "Click here to change the color of the timer.",
	aideStacksColor = "Click here to change the color of the stacks.",
	aideFont = "Click here to pick Font. Press OK to apply the selection.",
	aideMultiID = "Enter here other Aura IDs to combine checks. Multiple IDs must be separated with '/'. Aura ID can be found as [#] on first line of Aura tooltip.", 
	aideTooltipCheck = "Also check the tooltip contains this text",

	aideBuff = "Enter here the name of the buff, or a part of the name, which must activate/deactivate the effect. You can enter several names (ex: Super Buff/Power)",
	aideBuff2 = "Enter here the name of the debuff, or a part of the name, which must activate/deactivate the effect. You can enter several names (ex: Dark Disease/Plague)",
	aideBuff3 = "Enter here the type of the debuff which must activate or deactivate the effect (Poison, Disease, Curse, Magic, CC, Silence, Stun, Snare, Root or None). You can enter several types (ex: Disease/Poison)",
	aideBuff4 = "Enter here the name of area of effect that must trigger this effect (like a rain of fire for example, the name of this AOE can be found in the combat log)",
	aideBuff5 = "Enter here the temporary enchant which must activate this effect : optionally prepend it with 'main/' or 'off/ to designate mainhand or offhand slot. (ex: main/crippling)",
	aideBuff6 = "Enter here the number of combo points that must activate this effect (ex : 1 or 1/2/3 or 0/4/5 etc...) ",
	aideBuff7 = "Enter here the name, or a part of the name, of an action in your action bars. The effect will be active when this action is usable.",
	aideBuff8 = "Enter here the name, or a part of the name, of a spell from your spellbook. You can enter a spell id [12345].",
	
	aideSpells = "Enter here the Spell Name that will trigger a spell alert Aura.",
	aideStacks = "Enter here the operator and the amount of stacks, required activate/deactivate the effect. Operator is required ex: '<5' '>3' '=11' '!5' '>=0' '<=6' '2-8'",

	aideStealableSpells = "Enter here the Stealable Spell Name that will trigger the Aura (use * for any stealable spell).", 
	aidePurgeableSpells = "Enter here the Purgeable Spell Name that will trigger the Aura (use * for any purgeable spell).", 

	aideTotems = "Enter here the Totem Name that will trigger the Aura or a number 1=Fire, 2=Earth, 3=Water, 4=Air (use * for any totem).", 

	aideRunes = "Enter here the Runes that will trigger the Aura B/b=Blood, F/f=frost, U/u=Unholy, D/d=Death (Death runes will count as the other types if you use uppercase or the ignorecase flag is set) ex: 'BF' 'BfU' 'DDD'", 

	aideUnitn = "Enter here the name of the unit, which must activate/deactivate the effect. You can enter only names, if they are in your raid or group.",
	aideUnitn2 = "Only for raid/group.",

	aideMaxTex = "Define the maximum number of textures available on the Effect Editor. If you add textures on the Mod directory (with the names AURA1.tga to AURA50.tga), you must indicate the correct number here.",
	aideWowTextures = "Check this to use the texture of WoW instead of textures in the Power Auras directory for this effect.",
	aideTextAura = "Check this to type text instead of texture.",
	aideRealaura = "Real Aura",
	aideCustomTextures = "Check this to use textures in the 'Custom' subdirectory. Put the name of the texture below (ex: myTexture.tga). You can also use a Spell Name (ex: Feign Death) or SpellID (ex: 5384).",
	aideRandomColor = "Check this to tell this effect to use random color each time it will be activated.",

	aideTexMode = "Uncheck this to use the texture opacity. By default, the darkest colors will be more transparent.",

	nomActivationBy = "Activation by :",

	nomOwnTex = "Use own Texture",
	aideOwnTex = "Use the De/Buff or Ability Texture instead.",
	nomStacks = "Stacks",

	nomUpdateSpeed = "Update speed",
	nomSpeed = "Animation speed",
	nomTimerUpdate = "Timer update speed",
	nomBegin = "Begin Animation",
	nomEnd = "End Animation",
	nomSymetrie = "Symmetry",
	nomAlpha = "Opacity",
	nomPos = "Position",
	nomTaille = "Size",

	nomExact = "Exact Name",
	nomThreshold = "Threshold",
	aideThreshInv = "Check this to invert the threshold logic. Unchecked = Low Warning / Checked = High Warning.",
	nomThreshInv = "</>",
	nomStance = "Stance",
	nomGTFO = "Alert Type",
	nomPowerType = "Power Type:",

	nomMine = "Cast by me",
	aideMine = "Check this to test only buffs/debuffs cast by the player",
	nomDispellable = "I can dispell",
	aideDispellable = "Check to show only buffs that are dispellable",
	nomCanInterrupt = "Can be Interrupted",
	aideCanInterrupt = "Check to show only for spells that can be Interrupted",
	nomIgnoreUseable = "Cooldown Only",
	aideIgnoreUseable = "Ignores if spell is usable (just uses cooldown)",
	nomIgnoreItemUseable = "Equipped Only",
	aideIgnoreItemUseable = "Ignores if item is usable (just if equipped)",
	nomCheckPet = "Pet",
	aideCheckPet = "Check to Monitor only Pet Spells",

	nomOnMe = "Cast On Me",
	aideOnMe = "Only show if being Cast On Me",

	nomPlayerSpell = "Player Casting",
	aidePlayerSpell = "Check if Player is casting a spell",

	nomCheckTarget = "Enemy Target",
	nomCheckFriend = "Friendly Target",
	nomCheckParty = "Partymember",
	nomCheckFocus = "Focus",
	nomCheckRaid = "Raidmember",
	nomCheckGroupOrSelf = "Raid/Party or self",
	nomCheckGroupAny = "Any", 
	nomCheckOptunitn = "Unitname",

	aideTarget = "Check this to test an enemy target only.",
	aideTargetFriend = "Check this to test a friendly target only.",
	aideParty = "Check this to test a party member only.",
	aideGroupOrSelf = "Check this to test a party or raid member or self.",
	aideFocus = "Check this to test the focus only.",
	aideRaid = "Check this to test a raid member only.",
	aideGroupAny = "Check this to test buff on 'Any' party/raid member. Unchecked: Test that 'All' are buffed.",
	aideOptunitn = "Check this to test a special char in raid/group only.",	
	aideExact = "Check this to test the exact name of the buff/debuff/action.",
	aideStance = "Select which Stance,Aura or Form trigger the event.",
	aideGTFO = "Select which GTFO Alert will trigger the event.",
	aidePowerType = "Select which type of resource to track",

	aideShowSpinAtBeginning= "At the end of the begin animation show a 360 degree spin",
	nomCheckShowSpinAtBeginning = "Show Spin after begin animation ends",

	nomCheckShowTimer = "Show",
	nomTimerDuration = "Duration",
	aideTimerDuration = "Show a timer to simulate buff/debuff duration on the target (0 to deactivate)",
	aideShowTimer = "Check this to show the timer of this effect.",
	aideSelectTimer = "Select which timer will show the duration",
	aideSelectTimerBuff = "Select which timer will show the duration (this one is reserved for player's buffs)",
	aideSelectTimerDebuff = "Select which timer will show the duration (this one is reserved for player's debuffs)",

	nomCheckShowStacks = "Show",
	aideShowStacks = "Activate this to show the stacks for this effect.",

	nomCheckInverse = "Invert",
	aideInverse = "Invert the logic to show this effect only when buff/debuff is not active.",	

	nomCheckIgnoreMaj = "Ignore case",	
	aideIgnoreMaj = "Check this to ignore upper/lowercase of buff/debuff names.",

	nomAuraDebug= "Debug",
	aideAuraDebug = "Debug this Aura",

	nomDuration = "Anim. duration",
	aideDuration = "After this time, this effect will disapear (0 to deactivate)",

	nomOldAnimations = "Old Animations";
	aideOldAnimations = "Use Old Animations";

	nomCentiemes = "Show hundredth",
	nomDual = "Show two timers",
	nomHideLeadingZeros = "Hide Leading Zeros",
	nomTransparent = "Use transparent textures",
	nomActivationTime = "Show Time since activation",
	nomTimer99 = "When below 100 show only seconds",
	nomUseOwnColor = "Use own color:",
	nomUpdatePing = "Animate on refresh",
	nomLegacySizing = "Wider Digits",
	nomRelative = "Relative to Main Aura",
	nomClose = "Close",
	nomEffectEditor = "Effect Editor",
	nomAdvOptions = "Options",
	nomMaxTex = "Maximum of textures available",
	nomTabAnim = "Animation",
	nomTabActiv = "Activation",
	nomTabSound = "Sound",
	nomTabTimer = "Timer",
	nomTabStacks = "Stacks",
	nomWowTextures = "WoW Textures",
	nomCustomTextures = "Custom Textures",
	nomTextAura = "Text Aura",
	nomRealaura = "Real Aura",
	nomRandomColor = "Random Colors",
	nomTexMode = "Glow",

	nomTalentGroup1 = "Spec 1",
	aideTalentGroup1 = "Show this effect only when you are in your primary talent spec.",
	nomTalentGroup2 = "Spec 2",
	aideTalentGroup2 = "Show this effect only when you are in your secondary talent spec.",

	nomReset = "Reset Editor Positions",	
	nomPowaShowAuraBrowser = "Show Aura Browser",
	
	nomDefaultTimerTexture = "Default Timer Texture",
	nomTimerTexture = "Timer Texture",
	nomDefaultStacksTexture = "Default Stacks Texture",
	nomStacksTexture = "Stacks Texture",
	
	Enabled = "Enabled",
	Default = "Default",

	Ternary = {
		combat = "In Combat",
		inRaid = "In Raid",
		inParty = "In Party",
		isResting = "Resting",
		ismounted = "Mounted",
		inVehicle = "In Vehicle",
		isAlive= "Alive",
		PvP= "PvP flag set",
		Instance5Man= "5-Man",
		Instance5ManHeroic= "5-Man Hc",
		Instance10Man= "10-Man",
		Instance10ManHeroic= "10-Man Hc",
		Instance25Man= "25-Man",
		Instance25ManHeroic= "25-Man Hc",
		InstanceBg= "Battleground",
		InstanceArena= "Arena",
	},

	nomWhatever = "Ignored",
	aideTernary = "Sets how the status effects how this aura is shown.",
	TernaryYes = {
		combat = "Only When In Combat",
		inRaid = "Only When In Raid",
		inParty = "Only When In Party",
		isResting = "Only When Resting",
		ismounted = "Only When Mounted",
		inVehicle = "Only When In Vehicle",
		isAlive= "Only When Alive",
		PvP= "Only when PvP flag set",
		Instance5Man= "Only when in a 5-Man Normal instance",
		Instance5ManHeroic= "Only when in a 5-Man Heroic instance",
		Instance10Man= "Only when in a 10-Man Normal instance",
		Instance10ManHeroic= "Only when in a 10-Man Heroic instance",
		Instance25Man= "Only when in a 25-Man Normal instance",
		Instance25ManHeroic= "Only when in a 25-Man Heroic instance",
		InstanceBg= "Only when in a Battleground",
		InstanceArena= "Only when in an Arena instance",
		RoleTank     = "Only when a Tank",
		RoleHealer   = "Only when a Healer",
		RoleMeleDps  = "Only when a Melee DPS",
		RoleRangeDps = "Only when a Ranged DPS",
	},
	TernaryNo = {
		combat = "Only When Not in Combat",
		inRaid = "Only When Not in Raid",
		inParty = "Only When Not in Party",
		isResting = "Only When Not Resting",
		ismounted = "Only When Not Mounted",
		inVehicle = "Only When Not in Vehicle",
		isAlive= "Only When Dead",
		PvP= "Only when PvP flag Not set",
		Instance5Man= "Only when Not in a 5-Man Normal instance",
		Instance5ManHeroic= "Only when Not in a 5-Man Heroic instance",
		Instance10Man= "Only when Not in a 10-Man Normal instance",
		Instance10ManHeroic= "Only when Not in a 10-Man Heroic instance",
		Instance25Man= "Only when Not in a 25-Man Normal instance",
		Instance25ManHeroic= "Only when Not in a 25-Man Heroic instance",
		InstanceBg= "Only when Not in a Battleground",
		InstanceArena= "Only when Not in an Arena instance",
		RoleTank     = "Only when Not a Tank",
		RoleHealer   = "Only when Not a Healer",
		RoleMeleDps  = "Only when Not a Melee DPS",
		RoleRangeDps = "Only when Not a Ranged DPS",
	},
	TernaryAide = {
		combat = "Effect modified by Combat status.",
		inRaid = "Effect modified by Raid status.",
		inParty = "Effect modified by Party status.",
		isResting = "Effect modified by Resting status.",
		ismounted = "Effect modified by Mounted status.",
		inVehicle = "Effect modified by Vehicle status.",
		isAlive= "Effect modified by Alive status.",
		PvP= "Effect modified by PvP flag",
		Instance5Man= "Effect modified by being in a 5-Man Normal instance",
		Instance5ManHeroic= "Effect modified by being in a 5-Man Heroic instance",
		Instance10Man= "Effect modified by being in a 10-Man Normal instance",
		Instance10ManHeroic= "Effect modified by being in a 10-Man Heroic instance",
		Instance25Man= "Effect modified by being in a 25-Man Normal instance",
		Instance25ManHeroic= "Effect modified by being in a 25-Man Heroic instance",
		InstanceBg= "Effect modified by being in a Battleground",
		InstanceArena= "Effect modified by being in an Arena instance",
		RoleTank     = "Effect modified by being a Tank",
		RoleHealer   = "Effect modified by being a Healer",
		RoleMeleDps  = "Effect modified by being a Melee DPS",
		RoleRangeDps = "Effect modified by being a Ranged DPS",
	},

	nomTimerInvertAura = "Invert Aura When Time Below",
	aidePowaTimerInvertAuraSlider = "Invert the aura when the duration is less than this limit (0 to deactivate)",
	nomTimerHideAura = "Hide Aura & Timer Until Time Above",
	aidePowaTimerHideAuraSlider = "Hide the aura and timer when the duration is greater than this limit (0 to deactivate)",

	aideTimerRounding = "When checked will round the timer up",
	nomTimerRounding = "Round Timer Up",
	
	aideAllowInspections = "Allow Power Auras to Inspect players to determine roles, turning this off will sacrifice accuracy for speed",
	nomAllowInspections = "Allow Inspections",
	
	nomCarried = "Only if in bags",
	aideCarried = "Ignores if item is usable (just if in a bag)",

	-- Diagnostic reason text, these have substitutions (using $1, $2 etc) to allow for different sententance constructions
	nomReasonShouldShow = "Should show because $1",
	nomReasonWontShow   = "Won't show because $1",
	
	nomReasonMulti         = "All multiples match $1", --$1=Multiple match ID list
	nomReasonMultiInactive = "Aura $1 is not active", --$1=Multiple match Aura Id
	nomReasonMultiActive   = "Aura $1 is active", --$1=Multiple match Aura Id
	
	nomReasonDisabled = "Power Auras Disabled",
	nomReasonGlobalCooldown = "Ignore Global Cooldown",
	
	nomReasonBuffPresent = "$1 has $2 $3", --$1=Target $2=BuffType, $3=BuffName (e.g. "Unit4 has Debuff Misery")
	nomReasonBuffMissing = "$1 doesn't have $2 $3", --$1=Target $2=BuffType, $3=BuffName (e.g. "Unit4 doesn't have Debuff Misery")
	nomReasonBuffFoundButIncomplete = "$2 $3 found for $1 but\n$4", --$1=Target $2=BuffType, $3=BuffName, $4=IncompleteReason (e.g. "Debuff Sunder Armor found for Target but\nStacks<=2")
	
	nomReasonOneInGroupHasBuff     = "$1 has $2 $3",            --$1=GroupId   $2=BuffType, $3=BuffName (e.g. "Raid23 has Buff Blessing of Kings")
	nomReasonNotAllInGroupHaveBuff = "Not all in $1 have $2 $3", --$1=GroupType $2=BuffType, $3=BuffName (e.g. "Not all in Raid have Buff Blessing of Kings")
	nomReasonAllInGroupHaveBuff    = "All in $1 have $2 $3",     --$1=GroupType $2=BuffType, $3=BuffName (e.g. "All in Raid have Buff Blessing of Kings")
	nomReasonNoOneInGroupHasBuff   = "No one in $1 has $2 $3",  --$1=GroupType $2=BuffType, $3=BuffName (e.g. "No one in Raid has Buff Blessing of Kings")

	nomReasonBuffPresentTimerInvert = "Buff present, timer invert",
	nomReasonBuffPresentNotMine     = "Not cast by me",
	nomReasonBuffFound              = "Buff present",
	nomReasonStacksMismatch         = "Stacks = $1 expecting $2", --$1=Actual Stack count, $2=Expected Stack logic match (e.g. ">=0")

	nomReasonAuraMissing = "Aura missing",
	nomReasonAuraOff     = "Aura off",
	nomReasonAuraBad     = "Aura bad",
	
	nomReasonNotForTalentSpec = "Aura not active for this talent spec",
	
	nomReasonPlayerDead     = "Player is DEAD",
	nomReasonPlayerAlive    = "Player is Alive",
	nomReasonNoTarget       = "No Target",
	nomReasonTargetPlayer   = "Target is you",
	nomReasonTargetDead     = "Target is Dead",
	nomReasonTargetAlive    = "Target is Alive",
	nomReasonTargetFriendly = "Target is Friendly",
	nomReasonTargetNotFriendly = "Target not Friendly",

	nomReasonNoPet = "Player has no Pet",

	nomReasonNotInCombat = "Not in combat",
	nomReasonInCombat = "In combat",
	
	nomReasonInParty = "In Party",
	nomReasonInRaid = "In Raid",
	nomReasonNotInParty = "Not in Party",
	nomReasonNotInRaid = "Not in Raid",
	nomReasonNotInGroup = "Not in Party/Raid",
	nomReasonNoFocus = "No focus",	
	nomReasonNoCustomUnit = "Can't find custom unit not in party, raid or with pet unit=$1",
	nomReasonPvPFlagNotSet = "PvP flag not set",
	nomReasonPvPFlagSet = "PvP flag set",
	
	nomReasonNotMounted = "Not Mounted",
	nomReasonMounted = "Mounted",		
	nomReasonNotInVehicle = "Not In Vehicle",
	nomReasonInVehicle = "In Vehicle",		
	nomReasonNotResting = "Not Resting",
	nomReasonResting = "Resting",		
	nomReasonStateOK = "State OK",
	
	nomReasonNotIn5ManInstance = "Not in 5-Man Instance",
	nomReasonIn5ManInstance = "In 5-Man Instance",		
	nomReasonNotIn5ManHeroicInstance = "Not in 5-Man Heroic Instance",
	nomReasonIn5ManHeroicInstance = "In 5-Man Heroic Instance",		
	
	nomReasonNotIn10ManInstance = "Not in 10-Man Instance",
	nomReasonIn10ManInstance = "In 10-Man Instance",		
	nomReasonNotIn10ManHeroicInstance = "Not in 10-Man Heroic Instance",
	nomReasonIn10ManHeroicInstance = "In 10-Man Heroic Instance",		
	
	nomReasonNotIn25ManInstance = "Not in 25-Man Instance",
	nomReasonIn25ManInstance = "In 25-Man Instance",		
	nomReasonNotIn25ManHeroicInstance = "Not in 25-Man Heroic Instance",
	nomReasonIn25ManHeroicInstance = "In 25-Man Heroic Instance",		
	
	nomReasonNotInBgInstance = "Not in Battleground Instance",
	nomReasonInBgInstance = "In Battleground Instance",		
	nomReasonNotInArenaInstance = "Not in Arena Instance",
	nomReasonInArenaInstance = "In Arena Instance",

	nomReasonInverted        = "$1 (inverted)", -- $1 is the reason, but the inverted flag is set so the logic is reversed
	
	nomReasonSpellUsable     = "Spell: $1 usable",
	nomReasonSpellNotUsable  = "Spell: $1 not usable",
	nomReasonSpellNotReady   = "Spell: $1 Not Ready, on cooldown, timer invert",
	nomReasonSpellNotEnabled = "Spell: $1 not enabled ",
	nomReasonSpellNotFound   = "Spell: $1 not found",
	nomReasonSpellOnCooldown = "Spell: $1 on Cooldown",
	
	nomReasonCastingOnMe	 = "$1 is casting $2 on me", --$1=CasterName $2=SpellName (e.g. "Rotface is casting Slime Spray on me")
	nomReasonNotCastingOnMe	 = "No matching spell being cast on me",
	
	nomReasonCastingByMe	 = "I am casting $1 on $2", --$1=SpellName $2=TargetName (e.g. "I am casting Holy Light on Fred")
	nomReasonNotCastingByMe	 = "No matching spell being cast by me",

	nomReasonAnimationDuration  = "Still within custom duration",

	nomReasonItemUsable     = "Item: $1 usable",
	nomReasonItemNotUsable  = "Item: $1 not usable",
	nomReasonItemNotReady   = "Item: $1 Not Ready, on cooldown, timer invert",
	nomReasonItemNotEnabled = "Item: $1 not enabled ",
	nomReasonItemNotFound   = "Item: $1 not found",
	nomReasonItemOnCooldown = "Item: $1 on Cooldown",
	
	nomReasonItemEquipped    = "Item: $1 equipped",
	nomReasonItemNotEquipped = "Item: $1 not equipped",
						
	nomReasonItemInBags      = "Item: $1 in bags",
	nomReasonItemNotInBags   = "Item: $1 not in bags",
	nomReasonItemNotOnPlayer = "Item: $1 not carried",

	nomReasonSlotUsable     = "$1 Slot usable",
	nomReasonSlotNotUsable  = "$1 Slot not usable",
	nomReasonSlotNotReady   = "$1 Slot Not Ready, on cooldown, timer invert",
	nomReasonSlotNotEnabled = "$1 Slot has no cooldown effect",
	nomReasonSlotNotFound   = "$1 Slot not found",
	nomReasonSlotOnCooldown = "$1 Slot on Cooldown",
	nomReasonSlotNone       = "$1 Slot is empty",
	
	nomReasonStealablePresent = "$1 has Stealable spell $2", --$1=Target $2=SpellName (e.g. "Focus has Stealable spell Blessing of Wisdom")
	nomReasonNoStealablePresent = "Nobody has Stealable spell $1", --$1=SpellName (e.g. "Nobody has Stealable spell Blessing of Wisdom")
	nomReasonRaidTargetStealablePresent = "Raid$1Target has has Stealable spell $2", --$1=RaidId $2=SpellName (e.g. "Raid21Target has Stealable spell Blessing of Wisdom")
	nomReasonPartyTargetStealablePresent = "Party$1Target has has Stealable spell $2", --$1=PartyId $2=SpellName (e.g. "Party4Target has Stealable spell Blessing of Wisdom")
	
	nomReasonPurgeablePresent = "$1 has Purgeable spell $2", --$1=Target $2=SpellName (e.g. "Focus has Purgeable spell Blessing of Wisdom")
	nomReasonNoPurgeablePresent = "Nobody has Purgeable spell $1", --$1=SpellName (e.g. "Nobody has Purgeable spell Blessing of Wisdom")
	nomReasonRaidTargetPurgeablePresent = "Raid$1Target has has Purgeable spell $2", --$1=RaidId $2=SpellName (e.g. "Raid21Target has Purgeable spell Blessing of Wisdom")
	nomReasonPartyTargetPurgeablePresent = "Party$1Target has has Purgeable spell $2", --$1=PartyId $2=SpellName (e.g. "Party4Target has Purgeable spell Blessing of Wisdom")

	nomReasonAoETrigger = "AoE $1 triggered", -- $1=AoE spell name
	nomReasonAoENoTrigger = "AoE no trigger for $1", -- $1=AoE spell match
	
	nomReasonEnchantMainInvert = "Main Hand $1 enchant found, timer invert", -- $1=Enchant match
	nomReasonEnchantMain = "Main Hand $1 enchant found", -- $1=Enchant match
	nomReasonEnchantOffInvert = "Off Hand $1 enchant found, timer invert"; -- $1=Enchant match
	nomReasonEnchantOff = "Off Hand $1 enchant found", -- $1=Enchant match
	nomReasonNoEnchant = "No enchant found on weapons for $1", -- $1=Enchant match

	nomReasonNoUseCombo = "You do not use combo points",
	nomReasonNoUseComboInForm = "You don't use combo points in this form",
	nomReasonComboMatch = "Combo points $1 match $2",-- $1=Combo Points, $2=Combo Match
	nomReasonNoComboMatch = "Combo points $1 no match with $2",-- $1=Combo Points, $2=Combo Match

	nomReasonActionNotFound = "not found on Action Bar",
	nomReasonActionReady = "Action Ready",
	nomReasonActionNotReadyInvert = "Action Not Ready (on cooldown), timer invert",
	nomReasonActionNotReady = "Action Not Ready (on cooldown)",
	nomReasonActionlNotEnabled = "Action not enabled",
	nomReasonActionNotUsable = "Action not usable",

	nomReasonYouAreCasting = "You are casting $1", -- $1=Casting match
	nomReasonYouAreNotCasting = "You are not casting $1", -- $1=Casting match
	nomReasonTargetCasting = "Target casting $1", -- $1=Casting match
	nomReasonFocusCasting = "Focus casting $1", -- $1=Casting match
	nomReasonRaidTargetCasting = "Raid$1Target casting $2", --$1=RaidId $2=Casting match
	nomReasonPartyTargetCasting = "Party$1Target casting $2", --$1=PartyId $2=Casting match
	nomReasonNoCasting = "Nobody's target casting $1", -- $1=Casting match
	
	nomReasonStance = "Current Stance $1, matches $2", -- $1=Current Stance, $2=Match Stance
	nomReasonNoStance = "Current Stance $1, does not match $2", -- $1=Current Stance, $2=Match Stance
	
	nomReasonRunesNotReady = "Runes not Ready",
	nomReasonRunesReady = "Runes Ready",
	
	nomReasonPetExists= "Player has Pet",
	nomReasonPetMissing = "Player Pet Missing",
	
	nomReasonTrackingMissing = "Tracking not set to $1",
	nomTrackingSet = "Tracking set to $1",

	nomNotInInstance = "Not in correct instance",

	nomReasonStatic = "Static Aura",
	
	nomReasonUnitMatch = "Unit $1 matches unit $2.",
	nomReasonNoUnitMatch = "Unit $1 does not match unit $2.",
	
	nomReasonPetStance = "Pet is in $1 stance.",
	
	nomReasonUnknownName = "Unit name unknown",
	nomReasonRoleUnknown = "Role unknown",
	nomReasonRoleNoMatch = "No matching Role",

	nomUnknownSpellId = "PowerAuras: Aura $1 references an unknown spellId: ", -- $1=SpellID

	nomReasonGTFOAlerts = "GTFO alerts are never always on.",

	ReasonStat = {
		Health     = {MatchReason="$1 Health past limit",   NoMatchReason="$1 Health not past limit"},
		Mana       = {MatchReason="$1 Mana past limit",     NoMatchReason="$1 Mana not past limit"},
		Power	   = {MatchReason="$1 $3 past limit", 		NoMatchReason="$1 $3 not past limit", NilReason = "$1 has wrong Power Type"},
		Aggro      = {MatchReason="$1 has aggro",           NoMatchReason="$1 does not have aggro"},
		PvP        = {MatchReason="$1 PvP flag set",        NoMatchReason="$1 PvP flag not set"},
		SpellAlert = {MatchReason="$1 casting $2",        	NoMatchReason="$1 not casting $2"},
	},
	
	-- Export dialog
	ExportDialogTopTitle      = "Export Auras",
	ExportDialogCopyTitle     = "Press Ctrl-C to copy the below aura string.",
	ExportDialogMidTitle      = "Send to Player",
	ExportDialogSendTitle1    = "Enter a player name below and click 'Send'.",
	ExportDialogSendTitle2    = "Contacting %s (%d seconds remaining)...",      -- The 1/2/3/4 suffix denotes the internal status of the frame.
	ExportDialogSendTitle3a   = "%s is in combat and cannot accept the offer.",
	ExportDialogSendTitle3b   = "%s is not accepting export requests.",
	ExportDialogSendTitle3c   = "%s has not responded, they may be away or offline.",
	ExportDialogSendTitle3d   = "%s is currently receiving another export request.",
	ExportDialogSendTitle3e   = "%s has declined the offer.",
	ExportDialogSendTitle4    = "Sending auras...",
	ExportDialogSendTitle5    = "Send successful!",
	ExportDialogSendButton1   = "Send",
	ExportDialogSendButton2   = "Back",
	ExportDialogCancelButton  = "Close",
	-- Cross-client import dialog
	PlayerImportDialogTopTitle       = "You Have Auras!",
	PlayerImportDialogDescTitle1     = "%s would like to send you some auras.",
	PlayerImportDialogDescTitle2     = "Receiving auras...",
	PlayerImportDialogDescTitle3     = "The offer has expired.",
	PlayerImportDialogDescTitle4     = "Select a page to save the auras to.",
	PlayerImportDialogWarningTitle   = "|cFFFF0000Note: |rYou are being sent an aura set, this will overwrite any existing auras on the selected page.",
	PlayerImportDialogDescTitle5     = "Auras saved!",
	PlayerImportDialogDescTitle6     = "No aura slots are available.",
	PlayerImportDialogAcceptButton1  = "Accept",
	PlayerImportDialogAcceptButton2  = "Save",
	PlayerImportDialogCancelButton1  = "Reject",

	aideCommsRegisterFailure = "There was an error when setting up addon communications.",
	aideBlockIncomingAuras = "Prevent anybody sending you auras",
	nomBlockIncomingAuras = "Block Incoming Auras",
	aideFixExports = "Check this when aura exports are not functioning correctly and leave you with a blank textbox.",
	nomFixExports = "Alternative Exports",
	aideAnimationsAreBrokenSorry = "If your animations appear to skip or increase in size randomly, you should enable Old Animations.",
	
	AuraTypeDesc = {
		[PowaAuras.BuffTypes.Buff] = "Sets up an aura to act whenever a unit gains or loses a buff.",
		[PowaAuras.BuffTypes.Debuff] = "Sets up an aura to act whenever a unit gains or loses a debuff.",
		[PowaAuras.BuffTypes.AoE] = "AOE Debuff",
		[PowaAuras.BuffTypes.TypeDebuff] = "Debuff type",
		[PowaAuras.BuffTypes.Enchant] = "Weapon Enchant",
		[PowaAuras.BuffTypes.Combo] = "Combo Points",
		[PowaAuras.BuffTypes.ActionReady] = "Action Usable",
		[PowaAuras.BuffTypes.Health] = "Health",
		[PowaAuras.BuffTypes.Mana] = "Mana",
		[PowaAuras.BuffTypes.EnergyRagePower] = "Rage/Energy/Power",
		[PowaAuras.BuffTypes.Aggro] = "Aggro",
		[PowaAuras.BuffTypes.PvP] = "PvP",
		[PowaAuras.BuffTypes.Stance] = "Stance",
		[PowaAuras.BuffTypes.SpellAlert] = "Spell Alert", 
		[PowaAuras.BuffTypes.SpellCooldown] = "Spell Cooldown", 
		[PowaAuras.BuffTypes.StealableSpell] = "Stealable Spell",
		[PowaAuras.BuffTypes.PurgeableSpell] = "Purgeable Spell",
		[PowaAuras.BuffTypes.Static] = "Static Aura",
		[PowaAuras.BuffTypes.Totems] = "Totems",
		[PowaAuras.BuffTypes.Pet] = "Pet",
		[PowaAuras.BuffTypes.Runes] = "Runes",
		[PowaAuras.BuffTypes.Slots] = "Equipment Slots",
		[PowaAuras.BuffTypes.Items] = "Named Items",
		[PowaAuras.BuffTypes.Tracking] = "Tracking",
		[PowaAuras.BuffTypes.TypeBuff] = "Buff type",
		[PowaAuras.BuffTypes.UnitMatch] = "Unit Match",
		[PowaAuras.BuffTypes.GTFO] = "GTFO Alert",
	},
	
	-- New UI strings.
	UI_Cancel                  = "Cancel",
	UI_Save                    = "Save",
	UI_Back                    = "Back",
	UI_Next                    = "Next",
	UI_ID                      = "ID",
	UI_DropdownNone            = "Select an option...",

	-- Table keys.
	UI_StrataLevels            = {
		[1] = "Background",
		[2] = "Low",
		[3] = "Medium",
		[4] = "High",
	},
	-- Flips are 0 based.
	UI_FlipTypes               = {
		[0] = "None",
		[1] = "Horizontal",
		[2] = "Vertical",
		[3] = "Horizontal + Vertical",
	},
	
	UI_Sources                 = {
		[PowaAuras.SourceTypes.Default] = "Default Textures",
		[PowaAuras.SourceTypes.WoW]     = "WoW Textures",
		[PowaAuras.SourceTypes.Custom]  = "Custom Texture",
		[PowaAuras.SourceTypes.Text]    = "Text Display",
		[PowaAuras.SourceTypes.Icon]    = "Ability Icon",
	},
	
	UI_Auras                   = "Auras",
	UI_Config                  = "Options",
	UI_Help                    = "Help",
	
	UI_CharAuras               = "Character Auras",
	UI_ClassAuras              = "Class Auras",
	UI_GlobAuras               = "Global Auras",
	
	UI_CreateAura              = "Create New Aura",
	UI_CreatePresetAura        = "Create Aura From Presets",
	UI_CreateImportAura        = "Create Aura From Import",
	UI_CreateAura_Tooltip      = "Creates or imports a new aura on this page.\n\n|cFFFFD100Left-Click: |rOpen Creation Dialog",
	UI_CreateNew               = "Blank Aura",
	UI_CreateNewDesc           = "Create a new aura with the default settings.",
	UI_CreatePreset            = "Preset Aura",
	UI_CreatePresetDesc        = "Import an existing preset aura available to your class.",
	UI_CreateImport            = "Import Aura",
	UI_CreateImportDesc        = "Import an aura or aura set from an export code.",
	UI_CreateImportExp         = "Import Code",
	UI_CreateImportExpDesc     = "Paste an aura import code into the editbox to import the auras.\n\n|cFFFFD100Ctrl-V: |rPaste",
	UI_CreateImportWarning     = "|cFFFF0000Note: |rYou are importing an aura set, this will overwrite all existing auras on the selected page.",
	UI_CreateImportError       = "|cFFFF0000Error: |rAn error occured while trying to import the code, this may be because the code is not valid or has been damaged.",
	UI_MoveAuraReceive         = "Move Aura %d to Page %d",
	UI_MoveAuraReceive_Tooltip = "Moves the aura you have selected to this page.",
	UI_CopyAuraReceive         = "Copy Aura %d to Page %d",
	UI_CopyAuraReceive_Tooltip = "Copies the aura you have selected to this page.",
	
	UI_ConfigTitle             = "Configuration",
	UI_Config_Enable           = "Enable Power Auras",
	UI_Config_EnableDesc       = "If unchecked, Power Auras will be disabled.",
	UI_Config_Inspect          = "Allow Inspections",
	UI_Config_InspectDesc      = "If checked, Power Auras will utilize inspections to determine roles. This may cause issues with the inspection interface due to design flaws with the API.",
	UI_Config_RoundTimer       = "Round Timers Up",
	UI_Config_RoundTimerDesc   = "If checked, timers will round up to the nearest second to behave more like the Blizzard UI.",
	UI_Config_BlockComms       = "Block Incoming Auras",
	UI_Config_BlockCommsDesc   = "If checked, any aura export requests from other players will be automatically blocked.",
	UI_Config_FixExports       = "Alternative Exports",
	UI_Config_FixExportsDesc   = "If checked, your export strings will contain all data values instead of ones that do not match the defaults. Only enable this if you are experiencing issues with your exports.",
	UI_Config_UpdateSpeed      = "Update Speed",
	UI_Config_UpdateSpeedDesc  = "Controls the speed of updates, lower this if you are experiencing performance issues.",
	UI_Config_TimerSpeed       = "Timer Update Speed",
	UI_Config_TimerSpeedDesc   = "Controls the speed of timer updates, lower this if you are experiencing performance issues.",
	UI_Config_PathTex          = "Custom Textures",
	UI_Config_PathTexDesc      = "Specifies the path to load your custom aura textures from.",
	UI_Config_PathSfx          = "Custom Sounds",
	UI_Config_PathSfxDesc      = "Specifies the path to load your custom aura sounds from.",
	UI_Config_TimerTex         = "Default Timer Texture",
	UI_Config_TimerTexDesc     = "Changes the default texture used for timer displays.",
	UI_Config_StackTex         = "Default Stacks Texture",
	UI_Config_StackTexDesc     = "Changes the default texture used for stack displays.",
	UI_ConfigTitlePerf         = "Performance",
	UI_ConfigTitleCust         = "Textures and Sounds",
	
	UI_PageTools               = "Page Tools",
	UI_PageToolsDesc           = "Allows you to perform tasks like testing all auras, exporting the current page and unlocking or locking auras.",	
	UI_ShowAll                 = "Show All Auras",
	UI_HideAll                 = "Hide All Auras",
	UI_LockAll                 = "Lock Auras",
	UI_UnlockAll               = "Unlock Auras",
	UI_ExportPage              = "Export Current Page",
	
	UI_SelAura_None            = "No Aura Selected",
	UI_SelAura_Title           = "Aura %d",
	UI_SelAura_TooltipExt      = "\n|cFFFFD100Left-Click: |rSelect Aura\n|cFFFFD100Right-Click: |rEdit Aura\n|cFFFFD100Alt-Click: |rShow/Hide Aura\n|cFFFFD100Shift-Click: |rEnable/Disable Aura",
	UI_SelAura_Edit            = "Edit",
	UI_SelAura_EditDesc        = "Opens the aura editor to configure this aura.",
	UI_SelAura_Move            = "Move/Copy",
	UI_SelAura_MoveDesc        = "Moves or copies the selected aura to another page. To move or copy the aura to another page, click this button and then click the Add Aura button on the appropriate page.\n\n|cFFFFD100Left-Click: |rMove the aura\n|cFFFFD100Ctrl-Click: |rCopy the aura",
	UI_SelAura_Delete          = "Delete",
	UI_SelAura_DeleteDesc      = "Permanently deletes the aura. You must be holding the Ctrl key for this to work.\n\n|cFFFFD100Ctrl-Click: |rDelete the aura",
	UI_SelAura_Export          = "Export",
	UI_SelAura_ExportDesc      = "Converts the aura into a string which can then be given to other people for them to import.",
	UI_SelAura_Test            = "Test",
	UI_SelAura_TestDesc        = "Performs tests to see if the conditions that the aura must meet are all present, and displays the reasoning behind why it should or should not be currently showing.",
	
	UI_Editor                  = "Aura Editor",
	UI_Editor_TabDisplay       = "Display",
	UI_Editor_TabActivation    = "Activation",
	UI_Editor_TabAnim          = "Animations",
	UI_Editor_TabTriggers      = "Triggers",
	UI_Editor_TabSound         = "Sounds",
	UI_Editor_CatSuffix        = "%s Select a category below to display the options available.",
	
	UI_Editor_Aura             = "Aura",
	UI_Editor_AuraDesc         = "Configures the display settings of the aura texture.",
	UI_Editor_Aura_CatTexture  = "Texture Source",
	UI_Editor_Aura_CatStyle    = "Style",
	UI_Editor_Aura_CatSize     = "Size and Positioning",
	UI_Editor_Timer            = "Timer",
	UI_Editor_TimerDesc        = "Configures the settings of the timer display.",
	UI_Editor_Stacks           = "Stacks",
	UI_Editor_StacksDesc       = "Configures the settings of the stacks display.",
	UI_Editor_Text             = "Text [NYI]",
	UI_Editor_Activation       = "Activation",
	UI_Editor_ActivationDesc   = "Configures the main activation criteria that must be met for this aura to show, these change based on the type of aura being used.",
	UI_Editor_Type             = "Activation Type",
	UI_Editor_TypeDesc         = "Changes the type of activation class to use for this aura, which controls what the aura responds to such as Buffs, Health and Spells.",
	UI_Editor_Rules            = "Rules",
	UI_Editor_RulesDesc        = "Configures additional criteria that must be met for the aura to show, such as being in or out of combat.",
	
	-- Editor widgets.
	UI_Editor_Aura_Source        = "Texture Source",
	UI_Editor_Aura_SourceDesc    = "Modified the type of aura display to use, for example a custom texture or one included inside the game.",
	UI_Editor_Aura_SourceNum     = "Texture %d/%d",
	UI_Editor_Aura_SourceErr     = "|cFFFF0000Error:|r No texture found",
	UI_Editor_Aura_SizeX         = "Width",
	UI_Editor_Aura_SizeXDesc     = "Sets the width of the texture frame. If you are using an aura that appears to be stretched, try altering the Width and Height sliders.",
	UI_Editor_Aura_SizeY         = "Height",
	UI_Editor_Aura_SizeYDesc     = "Sets the height of the texture frame. If you are using an aura that appears to be stretched, try altering the Width and Height sliders.",
	UI_Editor_Aura_Scale         = "Scale",
	UI_Editor_Aura_ScaleDesc     = "Changes the scale of the texture. Higher values make it bigger, lower values make it smaller.",
	UI_Editor_Aura_PosX          = "Position (X)",
	UI_Editor_Aura_PosXDesc      = "Changes the horizontal positioning of the texture.",
	UI_Editor_Aura_PosY          = "Position (Y)",
	UI_Editor_Aura_PosYDesc      = "Changes the vertical positioning of the texture.",
	UI_Editor_Aura_Flip          = "Flip",
	UI_Editor_Aura_FlipDesc      = "Allows you to flip the aura texture from left to right, top to bottom or both.",
	UI_Editor_Aura_Opacity       = "Opacity",
	UI_Editor_Aura_OpacityDesc   = "Changes the opacity of the aura texture. Lower values make the aura more transparent, higher ones make it more opaque.",
	UI_Editor_Aura_Strata        = "Strata [NYI]",
	UI_Editor_Aura_StrataDesc    = "Changes the frame strata (layer) of the texture. Setting this higher will make it overlay other auras and UI elements.",
	UI_Editor_Aura_Glow          = "Glow",
	UI_Editor_Aura_GlowDesc      = "If enabled, any darkened areas in the texture will become more transparent.",
	UI_Editor_Aura_Color         = "Color",
	UI_Editor_Aura_ColorDesc     = "Allows you to apply color tinting to the aura texture. Right click to reset the color tint.\n\n|cFFFFD100Right-Click: |rReset to previous selected color.\n|cFFFFD100Shift-Right-Click: |rReset the color to white.",
	UI_Editor_Aura_RndColor      = "Random Color",
	UI_Editor_Aura_RndColorDesc  = "Allows you to apply color tinting to the aura texture. Right click to reset the color tint.",
	UI_Editor_Aura_Rotate        = "Rotation",
	UI_Editor_Aura_RotateDesc    = "Allows you to rotate the texture by a given amount of degrees.",
	
	UI_TriggerAdd              = "Add",
	UI_TriggerDelete           = "Delete",
});

--end