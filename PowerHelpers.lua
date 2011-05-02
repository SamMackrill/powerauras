-- Common helper functions.
PowaAuras.Helpers = {
	SettingsByKey = {},
	SettingLocations = {
		Aura = 0x1,
		Global = 0x2,
		Char = 0x4, -- As in PowaMisc.
	},
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
	SaveSetting = function(self, key, value)
		-- Make sure setting exists.
		if(not self.SettingsByKey[key]) then return false; end
		if(self.SettingsByKey[key].Location == self.SettingLocations.Aura and PowaBrowser.SelectedAura) then
			-- Save value to aura.
			return true;
		elseif(self.SettingsByKey[key].Location == self.SettingLocations.Global) then
			-- Save to global options table.
			return true;
		elseif(self.SettingsByKey[key].Location == self.SettingLocations.Char) then
			-- Save to per-char options table.
			return true;
		end
		-- If we're here we failed.
		return false;
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