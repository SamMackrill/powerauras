-- Define a function per version here.
PowaAuras.UpdateFunctions = {
	[1] = {
		Version = 50000,
		Keys = {
			-- Key = Old key, Value = New key. Anything omitted is handled specially, false values mean delete outright.
			off = "Disabled",
			bufftype = "Type",
			buffname = "ValueCheck",
			texmode = "Glow",
			aurastext = "Text",
			strata = "Strata",
			timerduration = "TimerDuration",
			alpha = "Opacity",
			size = "Scale",
			torsion = "Deform",
			symetrie = "Flip",
			x = "PosX",
			y = "PosY",
			randomcolor = "ColorRandom",
			r = "Color.1",
			g = "Color.2",
			b = "Color.3",
			inverse = "Invert",
			ignoremaj = "IgnoreCase",
			exact = "ExactMatch",
			stacks = "StacksMatch",
			stacksLower = "StacksLowerBound",
			stacksOperator = "StacksOperator",
			thresholdinvert = "ThresholdInvert",
			mine = "IsMine",
			icon = "IconPath",
--			raid = "Units.Raid",
--			groupOrSelf = "Units.RaidPartySelf",
--			party = "Units.Party",
--			optunitn = false,
--			unitn = "Units.Custom",
			inRaid = "InRaid",
			inParty = "InParty",
			ismounted = "IsMounted",
			isResting = "IsResting",
			inVehicle = "InVehicle",
			combat = "InCombat",
			isAlive = "IsAlive",
			PvP = "IsPvP",
--			Instance5Man = "Instance.Dungeon",
--			Instance5ManHeroic = "Instance.DungeonHeroic",
--			Instance10Man = "Instance.Raid10",
--			Instance10ManHeroic = "Instance.Raid10Heroic",
--			Instance25Man = "Instance.Raid25",
--			Instance25ManHeroic = "Instance.Raid25Heroic",
--			InstanceBg = "Instance.Battleground",
--			InstanceArena = "Instance.Arena",
--			RoleTank     = "Role.Tank",
--			RoleHealer   = "Role.Healer",
--			RoleMeleDps  = "Role.DPSMelee",
--			RoleRangeDps = "Role.DPSRanged",
			gcd = false,
			multiids = "MultiCheck",
			tooltipCheck = "TooltipCheck",
		},
		Function = function(self, aura, auraID)
			print(auraID, "-->");
			-- Store the version.
			-- aura.Version = 50000;
			-- Replace keys.
			for old, replace in pairs(self.Keys) do
				-- If the new key contains a period, it needs to be a subkey of a table. Only one period is supported.
				-- Insert sexist comment here.
				local splitPos, parent = (replace and replace:find("%.")), aura;
				if(splitPos) then
					-- Make parent table if needed.
					local parentKey = replace:sub(1, splitPos-1);
					if(not aura[parentKey]) then
						aura[parentKey] = {};
					end
					-- And get!
					parent = aura[parentKey];
					replace = replace:sub(splitPos+1);
					-- If we can number it, do so.
					replace = tonumber(replace) or replace;
				end
				-- Write value.
				if(replace and aura[old] ~= nil) then
					parent[replace] = aura[old];
					print(aura[old], " --> ", parent[replace], " (", old, " --> ", replace, ")");
				end
				-- Clear old one.
				aura[old] = nil;
			end
			-- Convert outstanding keys.
			-- Aura source location.
--			if(aura["wowtex"]) then
--				aura["Source"] = "WoW";
--				aura["SourceKey"] = aura["texture"];
--				aura["SourcePath"] = PowaAuras.AuraTexturesByGroup.WoW[aura["texture"]];
--			elseif(aura["customtex"]) then
--				aura["Source"] = "Custom";
--				aura["SourceKey"] = 1;
--				aura["SourcePath"] = aura["customname"];
--			elseif(aura["textaura"]) then
--				aura["Source"] = "Text";
--				aura["SourceKey"] = aura["aurastextfont"];
--				aura["SourcePath"] = PowaAuras.AuraTexturesByGroup.Text[aura["aurastextfont"]];
--			elseif(aura["owntex"]) then
--				aura["Source"] = "Icon";
--				aura["SourceKey"] = 1;
--				aura["SourcePath"] = "";
--			else
--				aura["Source"] = "Normal";
--				aura["SourceKey"] = aura["texture"];
--				aura["SourcePath"] = "Interface\\AddOns\\PowerAuras\\Auras\\Aura" .. aura["texture"] .. ".tga";
--			end
			-- Threshold becomes StacksMatch if you're using a power aura. Wait, what?
			if(aura["Type"] == PowaAuras.BuffTypes.Health or aura["Type"] == PowaAuras.BuffTypes.Mana 
			or aura["Type"] == PowaAuras.BuffTypes.EnergyRagePower) then
				-- Copy my threshold over.
				aura["StacksMatch"] = aura["threshold"];
				-- In addition, copy the subtype over.
				aura["Subtype"] = aura["PowerType"];
			elseif(aura["Type"] == PowaAuras.BuffTypes.Stance) then
				-- Stance is GO!
				aura["Subtype"] = aura["stance"];
			elseif(aura["Type"] == PowaAuras.BuffTypes.GTFO) then
				-- GTFO is GO!
				aura["Subtype"] = aura["GTFO"];
			else
				aura["Subtype"] = 0;
			end
			-- Clear old subtypes.
			aura["PowerType"] = nil;
			aura["threshold"] = nil;
			aura["stance"] = nil;
			aura["GTFO"] = nil;
			-- Handle spec things.
			for i=1, 2 do
				if(aura["spec" .. i]) then
					aura["Spec" .. i] = bit.bor(cPowaAura.SpecFlags.TREE_FIRST, cPowaAura.SpecFlags.TREE_SECOND, 
						cPowaAura.SpecFlags.TREE_THIRD);
				else
					aura["Spec" .. i] = 0;
				end
				-- Remove old key.
				aura["spec" .. i] = nil;	
			end
--			-- Friendly/Hostile targets.
--			if(aura["target"] and not aura["targetfriend"]) then
--				aura["Units"]["Target"] = bit.bor(cPowaAura.UnitFlags.EXISTS, cPowaAura.UnitFlags.REACTION_HOSTILE);
--			elseif(not aura["target"] and aura["targetfriend"]) then
--				aura["Units"]["Target"] = bit.bor(cPowaAura.UnitFlags.EXISTS, cPowaAura.UnitFlags.REACTION_FRIENDLY);
--			elseif(aura["target"] and aura["targetfriend"]) then
--				aura["Units"]["Target"] = bit.bor(cPowaAura.UnitFlags.EXISTS, cPowaAura.UnitFlags.REACTION_HOSTILE, 
--					cPowaAura.UnitFlags.REACTION_FRIENDLY);
--			else
--				aura["Units"]["Target"] = 0;
--			end
--			-- Focus target.
--			if(aura["focus"]) then
--				aura["Units"]["Focus"] = cPowaAura.UnitFlags.EXISTS;
--			else
--				aura["Units"]["Focus"] = 0;
--			end
		end,
	},
};

-- Sort functions by version.
sort(PowaAuras.UpdateFunctions, function(a, b)
	return (a.Version < b.Version);
end);


-- Call this to update an aura.
function PowaAuras:UpdateAura(aura, auraID)
	-- Get versions.
	local old, current = aura.Version or 10000, self.VersionInt;
	-- Make sure an update is needed.
	if(old == current or auraID == 0) then return; end
	-- Determine the update path.
	for version, updater in pairs(self.UpdateFunctions) do
		if(old < updater.Version and current >= updater.Version) then
			updater:Function(aura, auraID);
		end
	end
end

-- Old export settings (needed for imports to process properly).
PowaAuras.OldExportSettings = {
	off = false,
	
	bufftype = PowaAuras.BuffTypes.Buff,
	buffname = "???",
	
	texmode = 1,
	wowtex = false,
	customtex = false,
	textaura = false,
	owntex = false,
	texture = 1,
	customname = "",
	aurastext = "",
	aurastextfont = 1,
	icon = "",
	strata = "LOW",

	timerduration = 0,
	
	-- Sound Settings
	sound = 0,
	customsound = "",	
	soundend = 0,
	customsoundend = "",	
	
	-- Animation Settings
	begin = 0,
	anim1 = 1,
	anim2 = 0,
	speed = 1.00,
	finish = 1,
	beginSpin = false,

	duration = 0,
	
	-- Appearance Settings
	alpha = 0.75,
	size = 0.75,
	torsion = 1,
	symetrie = 0,
	x = 0,
	y = -30,
	randomcolor = false,
	r = 1.0,
	g = 1.0,
	b = 1.0,
	
	inverse = false,
	ignoremaj = true,
	exact = false,
	Extra = false,
	
	InvertAuraBelow = 0,

	stacks = 0,
	stacksLower = 0,
	stacksOperator = PowaAuras.DefaultOperator,

	threshold = 50,
	thresholdinvert = false,

	mine = false,

	focus = false,
	target = false,
	targetfriend = false,
	raid = false,
	groupOrSelf = false,
	party = false,

	groupany = true,
	optunitn = false,
	unitn = "",

	inRaid = 0,
	inParty = 0,
	ismounted = false,
	isResting = 0,
	inVehicle = false,	
	combat = 0,
	isAlive = true,
	PvP = 0,
	
	Instance5Man = 0,
	Instance5ManHeroic = 0,
	Instance10Man = 0,
	Instance10ManHeroic = 0,
	Instance25Man = 0,
	Instance25ManHeroic = 0,
	InstanceBg = 0,
	InstanceArena = 0,
	
	RoleTank     = 0,
	RoleHealer   = 0,
	RoleMeleDps  = 0,
	RoleRangeDps = 0,
	
	spec1 = true,
	spec2 = true,
	gcd = false,
	stance = 10,
	GTFO = 0,
	PowerType = -1,
	multiids = "",
	tooltipCheck = "",
	UseOldAnimations = false,
}
