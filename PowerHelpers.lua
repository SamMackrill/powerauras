-- Common helper functions.
PowaAuras.Helpers = {
	SettingsByKey = {},
	SettingCallbacks = {},
	SettingLocations = {
		Aura = 0x1,
		Global = 0x2,
		Char = 0x4, -- As in PowaMisc.
	},
	-- The key can be different from the name to prevent conflicts. The plan is aura settings will have Aura prefixed to
	-- the key which would otherwise be the setting name, so for "Enabled" it'd be "AuraEnabled".
	RegisterSetting = function(self, key, name, location)
		-- Can't duplicate a key.
		if(self.SettingsByKey[key]) then return false; end
		-- Otherwise we're probably fine!
		-- 150 settings assigned like this = ~21kb memory usage.
		self.SettingsByKey[key] = {
			Name = name,
			Location = location,
		};
		return true;
	end,
	RegisterSettingCallback = function(self, func)
		-- Safety.
		if(tContains(self, func)) then return false; end
		-- Go go go?
		tinsert(self.SettingCallbacks, func);
		return true;
	end,
	GetSetting = function(self, key)
		-- Make sure setting exists.
		if(not self.SettingsByKey[key]) then return false; end
		if(self.SettingsByKey[key].Location == self.SettingLocations.Aura and PowaBrowser.SelectedAura) then
			-- Aura value.
			return;
		elseif(self.SettingsByKey[key].Location == self.SettingLocations.Global) then
			-- Global value.
			return PowaGlobalMisc[self.SettingsByKey[key].Name];
		elseif(self.SettingsByKey[key].Location == self.SettingLocations.Char) then
			-- Per-char value.
			return PowaMisc[self.SettingsByKey[key].Name];
		end
	end,
	SaveSetting = function(self, key, value)
		-- Make sure setting exists.
		if(not self.SettingsByKey[key]) then return false; end
		local ret = false;
		if(self.SettingsByKey[key].Location == self.SettingLocations.Aura and PowaBrowser.SelectedAura) then
			-- Save value to aura.
			ret = true;
		elseif(self.SettingsByKey[key].Location == self.SettingLocations.Global) then
			-- Save to global options table.
			PowaGlobalMisc[self.SettingsByKey[key].Name] = value;
			ret = true;
		elseif(self.SettingsByKey[key].Location == self.SettingLocations.Char) then
			-- Save to per-char options table.
			PowaMisc[self.SettingsByKey[key].Name] = value;
			ret = true;
		end
		-- Call OnUpdate func. Pass new value.
		self:UpdateSetting(key, value);
		-- Done.
		return ret;
	end,
	UpdateSetting = function(self, key, value)
		-- Make sure setting exists.
		if(not self.SettingsByKey[key]) then return false; end
		-- Run update funcs.
		for _, func in ipairs(self.SettingCallbacks) do
			func(key, value);
		end
	end,
	GetNextFreeSlot = function(self, page)
		-- Default to currently selected page if needed.
		if(not page) then page = PowaBrowser.SelectedPage; end
		for i=(1+((page-1)*24)), (24+((page-1)*24)) do
			if(not PowaAuras.Auras[i]) then return i, page; end
		end
		-- We did the loop? Damn.
		return false, page;
	end,
	CreateAura = function(self, id, page)
		-- Get a new aura slot. It also returns the page, so will allow for a nil arg to be passed and corrected.
		local i, page = self:GetNextFreeSlot(page);
		if(not i or not page) then return false; end
		-- Select it.
		PowaBrowser:OnSelectionChanged(page); -- Update page if needed.
		PowaBrowser:SetSelectedAura(i);
		-- Build a new aura.
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, i);
		aura:Init();
		PowaAuras.Auras[i] = aura;
		-- Save to appropriate config table.
		if(i > 120 and i <= 360) then
			PowaGlobalSet[i] = aura;
		elseif(i > 360) then
			PowaClassSet[select(2, UnitClass("player"))][i] = aura;
		end
		-- Fix other things.
		PowaAuras:CalculateAuraSequence();
		aura:CheckActive(true, true, true);
		PowaAuras:DisplayAura(i);
	end,
};

-- Register settings down below here.
for k, _ in pairs(PowaGlobalMisc) do
	PowaAuras.Helpers:RegisterSetting(k, k, PowaAuras.Helpers.SettingLocations.Global);
end
for k, _ in pairs(PowaMisc) do
	PowaAuras.Helpers:RegisterSetting(k, k, PowaAuras.Helpers.SettingLocations.Char);
end