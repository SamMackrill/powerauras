-- Define a function per version here.
PowaAuras.UpdateFunctions = {
	[1] = {
		Version = 50000,
		Function = function(self, aura, auraID)
			-- Store the version.
			-- aura.Version = 50000;
			-- Fix texmode/glow.
			if(aura.texmode == 1 or aura.texmode == true) then
				aura.texmode = true;
			else
				aura.texmode = false;
			end
			-- Texture source.
			if(aura.owntex or aura.SourceType == PowaAuras.SourceTypes.Icon) then
				aura.SourceType = PowaAuras.SourceTypes.Icon;
			elseif(aura.wowtex or aura.SourceType == PowaAuras.SourceTypes.WoW) then
				aura.SourceType = PowaAuras.SourceTypes.WoW;
			elseif(aura.customtex or aura.SourceType == PowaAuras.SourceTypes.Custom) then
				aura.SourceType = PowaAuras.SourceTypes.Custom;
			elseif(aura.textaura or aura.SourceType == PowaAuras.SourceTypes.Text) then
				aura.SourceType = PowaAuras.SourceTypes.Text;
			else
				aura.SourceType = PowaAuras.SourceTypes.Default;
			end
			-- Clear old keys.
			aura.texmode = nil;
--			aura.owntex = nil;
--			aura.customtex = nil;
--			aura.textaura = nil;
--			aura.wowtex = nil;
			-- Handle spec things.
--			for i=1, 2 do
--				if(aura["spec" .. i]) then
--					aura["Spec" .. i] = bit.bor(cPowaAura.SpecFlags.TREE_FIRST, cPowaAura.SpecFlags.TREE_SECOND, 
--						cPowaAura.SpecFlags.TREE_THIRD);
--				else
--					aura["Spec" .. i] = 0;
--				end
--				-- Remove old key.
--				aura["spec" .. i] = nil;	
--			end
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
