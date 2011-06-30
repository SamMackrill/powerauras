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
			r = "Color.r",
			g = "Color.g",
			b = "Color.b",
			inverse = "Invert",
			ignoremaj = "IgnoreCase",
			exact = "ExactMatch",
			stacks = "StacksMatch",
			stacksLower = "StacksLowerBound",
			stacksOperator = "StacksOperator",
			thresholdinvert = "ThresholdInvert",
			mine = "IsMine",
			focus = "Units.Focus",
			raid = "Units.Raid",
			groupOrSelf = "Units.RaidPartySelf",
			party = "Units.Party",
			groupany = "Units.RaidPartyAny",
			optunitn = false,
			unitn = "Units.Custom",
			inRaid = "InRaid",
			inParty = "InParty",
			ismounted = "IsMounted",
			isResting = "IsResting",
			inVehicle = "InVehicle",
			combat = "InCombat",
			isAlive = "IsAlive",
			PvP = "IsPvP",
			Instance5Man = "Instance.Dungeon",
			Instance5ManHeroic = "Instance.DungeonHeroic",
			Instance10Man = "Instance.Raid10",
			Instance10ManHeroic = "Instance.Raid10Heroic",
			Instance25Man = "Instance.Raid25",
			Instance25ManHeroic = "Instance.Raid25Heroic",
			InstanceBg = "Instance.Battleground",
			InstanceArena = "Instance.Arena",
			RoleTank     = "Role.Tank",
			RoleHealer   = "Role.Healer",
			RoleMeleDps  = "Role.DPSMelee",
			RoleRangeDps = "Role.DPSRanged",
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
				end
				-- Write value.
				if(replace) then
					parent[replace] = aura[old];
				end
				-- Clear old one.
--				aura[old] = nil;
			end
			-- Convert outstanding keys.
			-- Aura source location.
			if(aura["wowtex"]) then
				aura["Source"] = "WoW";
				aura["SourceKey"] = aura["texture"];
				aura["SourcePath"] = PowaAuras.AuraTexturesByGroup.WoW[aura["texture"]];
			elseif(aura["customtex"]) then
				aura["Source"] = "Custom";
				aura["SourceKey"] = 1;
				aura["SourcePath"] = aura["customname"];
			elseif(aura["textaura"]) then
				aura["Source"] = "Text";
				aura["SourceKey"] = aura["aurastextfont"];
				aura["SourcePath"] = PowaAuras.AuraTexturesByGroup.Text[aura["aurastextfont"]];
			elseif(aura["owntex"]) then
				aura["Source"] = "Icon";
				aura["SourceKey"] = 1;
				aura["SourcePath"] = aura["icon"];
			else
				aura["Source"] = "Normal";
				aura["SourceKey"] = aura["texture"];
				aura["SourcePath"] = "Interface\\AddOns\\PowerAuras\\Auras\\Aura" .. aura["texture"] .. ".tga";
			end
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
			-- Handle spec things.
			for i=1, 2 do
				if(aura["spec" .. i]) then
					aura["Spec" .. i] = bit.bor(cPowaAura.SpecFlags.TREE_FIRST, cPowaAura.SpecFlags.TREE_SECOND, 
						cPowaAura.SpecFlags.TREE_THIRD);
				else
					aura["Spec" .. i] = 0;
				end			
			end
			-- Friendly/Hostile targets.
			if(aura["target"] and not aura["targetfriend"]) then
				aura["Units"]["Target"] = true;
				aura["Units"]["TargetFlags"] = cPowaAura.UnitFlags.REACTION_HOSTILE;
			elseif(not aura["target"] and aura["targetfriend"]) then
				aura["Units"]["Target"] = true;
				aura["Units"]["TargetFlags"] = cPowaAura.UnitFlags.REACTION_FRIENDLY;
			elseif(aura["target"] and aura["targetfriend"]) then
				aura["Units"]["Target"] = true;
				aura["Units"]["TargetFlags"] = bit.bor(cPowaAura.UnitFlags.REACTION_HOSTILE, cPowaAura.UnitFlags.REACTION_FRIENDLY);
			else
				aura["Units"]["Target"] = false;
				aura["Units"]["TargetFlags"] = bit.bor(cPowaAura.UnitFlags.REACTION_HOSTILE, cPowaAura.UnitFlags.REACTION_FRIENDLY);
			end
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
	if(old == current) then return; end
	-- Determine the update path.
	for version, updater in pairs(self.UpdateFunctions) do
		if(old < updater.Version and current >= updater.Version) then
			updater:Function(aura, auraID);
		end
	end
end
