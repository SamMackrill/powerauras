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
		if(tContains(self.SettingCallbacks, func)) then return false; end
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
	DeleteAura = function(self, id)
		-- AURA, YOU MUST EXIST.
		if(not PowaAuras.Auras[id]) then return; end
		-- Dispose.
		if(PowaAuras.Auras[id].Timer) then PowaAuras.Auras[id].Timer:Dispose(); end
		if(PowaAuras.Auras[id].Stacks) then PowaAuras.Auras[id].Stacks:Dispose(); end
		PowaAuras.Auras[id]:Dispose();
		-- Remove.
		PowaAuras.Auras[id] = nil;
		if(id > 120 and id < 361) then
			PowaGlobalSet[aura.id] = nil;
		elseif(id > 360) then
			PowaClassSet[select(2, UnitClass("player"))][id] = nil;
		end
		-- Fix things.
		PowaAuras:CalculateAuraSequence();
		PowaBrowser:TriageIcones();
	end,
	ToggleAllAuras = function(self, activeOnly, forceDisplay, state)
		-- Need to be done.
		if(not (PowaAuras.VariablesLoaded and PowaAuras.SetupDone)) then return; end 
		-- Go over all auras.
		for id, aura in pairs(PowaAuras.Auras) do
			-- Active check.
			if(not activeOnly or aura.Active == true) then
				-- Force display is used to make sure DisplayAura is called.
				if(forceDisplay) then
					self:ToggleAuraDisplay(id, false, true);
					self:ToggleAuraDisplay(id, true, true);
				else
					self:ToggleAuraDisplay(id, state, true);
				end
			end
		end
		-- Update.
		PowaBrowser:TriageIcones();
	end,
	ToggleAuraDisplay = function(self, id, state, noUpdate)
		-- Need to be done.
		if(not (PowaAuras.VariablesLoaded and PowaAuras.SetupDone)) then return; end 
		-- Aura required!
		local aura = PowaAuras.Auras[id];
		if(not aura) then return; end
		if(state == nil) then
			state = not aura.Active;
		end
		aura:CheckActive(state, true, true);
		if(aura.Timer) then aura.Timer:Redisplay(aura, true); end
		if(aura.Stacks) then aura.Stacks:Redisplay(aura, true); end
		-- Trigger update.
		if(not noUpdate) then
			PowaBrowser:TriageIcones();
		end
	end,
	ToggleAuraEnabled = function(self, id, state)
		-- Aura required!
		if(not PowaAuras.Auras[id]) then return; end
		if(state == nil) then
			state = not PowaAuras.Auras[id].off;
		end
		PowaAuras.Auras[id].off = state;
		self:ToggleAuraDisplay(id, false);
	end,
};

-- Register settings and any handlers below here.
for k, _ in pairs(PowaGlobalMisc) do
	PowaAuras.Helpers:RegisterSetting(k, k, PowaAuras.Helpers.SettingLocations.Global);
end
for k, _ in pairs(PowaMisc) do
	PowaAuras.Helpers:RegisterSetting(k, k, PowaAuras.Helpers.SettingLocations.Char);
end

-- Add a general update function for when these settings change.
PowaAuras.Helpers:RegisterSettingCallback(function(key, value)
	if(PowaAuras.ModTest and PowaGlobalMisc[key] ~= nil or PowaMisc[key] ~= nil) then
		PowaAuras.Helpers:ToggleAllAuras(true, true);
	end
end);