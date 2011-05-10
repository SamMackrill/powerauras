-- Define a function per version here.
PowaAuras.UpdateFunctions = {
	[1] = {
		Version = 50000,
		Function = function(aura, auraID)
			print(auraID, "-->");
			-- Store the version.
			-- aura.Version = 50000;
			-- Replace these keys.
			for k, v in pairs(aura) do
				-- This will be a very long function.
				if(k == "off") then
					print("aura.Disabled =", v);
				elseif(k == "bufftype") then
					print("aura.Type =", v);
				elseif(k == "buffname") then
					print("aura.Data =", v);
				elseif(k == "texmode") then
					print("aura.Glow =", v);
				elseif(k == "wowtex" and v) then
					print("aura.SourceType = WoW");
				elseif(k == "customtex" and v) then
					print("aura.SourceType = Custom");
				elseif(k == "textaura" and v) then
					print("aura.SourceType = Text");
				elseif(k == "owntex" and v) then
					print("aura.SourceType = Icon");
				elseif(k == "texture" and not aura["customtex"] and not aura["owntex"] and not aura["textaura"]) then
					if(not aura["customtex"]) then
						print("aura.SourceType = Normal");
					end
					print("aura.SourceKey =", v);
				elseif(k == "aurastextfont" and aura["textaura"]) then
					print("aura.SourceKey =", v);
				elseif(k == "customname" and aura["customtex"]) then
					print("aura.SourcePath =", v);
				elseif(k == "icon" and aura["owntex"]) then
					print("aura.SourcePath =", v);
				elseif(k == "aurastext" and aura["textaura"]) then
					print("aura.Text =", v);
				elseif(k == "strata") then
					print("aura.Strata =", v);
				end				
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
			updater.Function(aura, auraID);
		end
	end
end