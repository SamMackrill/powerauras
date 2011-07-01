--- Contains a large amount of helper functions for use with auras, settings and saved variable management.

--- Stores all of the registered settings by their associated keys.
-- @name PowaAuras.SettingsByKey
-- @class table
PowaAuras.SettingsByKey = {};
--- Stores all of the callbacks to be fired when a setting is updated.
-- @name PowaAuras.SettingCallbacks
-- @class table
PowaAuras.SettingCallbacks = {};
--- Enumeration of possible location types that are accepted by PowaAuras:RegisterSetting().
-- @name PowaAuras.SettingLocations
-- @class table
PowaAuras.SettingLocations = {
	Aura = 0x1,
	Global = 0x2,
	Char = 0x4, -- As in PowaMisc.
	AuraTimer = 0x8,
	AuraStacks = 0x10,
};
--- Registers a saved variable as a setting, assigning it a key and allowing callbacks to be assigned to the setting.
-- The key should be different from the actual variable name to prevent conflicts.
-- @param key The key to assign to the specified setting.
-- @param name The name of the subkey in the location which represents this setting.
-- @param location The location of the setting, use a value from PowaAuras.SettingLocations for this parameter.
function PowaAuras:RegisterSetting(key, name, location)
	-- Can't duplicate a key.
	if(self.SettingsByKey[key]) then return false; end
	-- Otherwise we're probably fine!
	-- 150 settings assigned like this = ~21kb memory usage.
	self.SettingsByKey[key] = {
		Name = name,
		Location = location,
	};
	return true;
end
--- Registers a callback to be called whenever a setting is updated. Callbacks are supplied two parameters when called,
-- which represent the key of the setting that was updated and the value that was set.
-- @param func The function to set as a callback. Callbacks cannot be unset.
-- @return Returns true if the callback was successfully set, false if the callback already existed.
function PowaAuras:RegisterSettingCallback(func)
	-- Safety.
	if(tContains(self.SettingCallbacks, func)) then return false; end
	-- Go go go?
	tinsert(self.SettingCallbacks, func);
	return true;
end
--- Checks if the setting with the given key exists.
-- @param key The settings key to check for.
-- @return Returns true if the setting exists, false otherwise.
function PowaAuras:SettingExists(key)
	return self.SettingsByKey[key] and true or false;
end
--- Retrieves a setting with the associated key.
-- @param key The setting to be retrieved.
-- @param id The ID of the aura to retrieve settings for, if the key represents an aura setting.
-- @return Returns the value associated with the specified setting, or false if the setting does not exist.
function PowaAuras:GetSetting(key, id)
	-- Make sure setting exists.
	local setting = self.SettingsByKey[key];
	if(not setting) then return false; end
	if(setting.Location == self.SettingLocations.Aura and self.Auras[(id or PowaBrowser:GetSelectedAura())]) then
		-- Aura value.
		return self.Auras[(id or PowaBrowser:GetSelectedAura())][setting.Name];
	elseif(setting.Location == self.SettingLocations.Global) then
		-- Global value.
		return PowaGlobalMisc[setting.Name];
	elseif(setting.Location == self.SettingLocations.Char) then
		-- Per-char value.
		return PowaMisc[setting.Name];
	end
end
--- Saves the given value into a specific setting, and fires any callbacks associated with the setting in the process.
-- @param key The key of the setting to modify.
-- @param value The value to be stored.
-- @param id The ID of the aura to set settings for, if the key represents an aura setting.
-- @return Returns true if the saving is successful, false otherwise.
function PowaAuras:SaveSetting(key, value, id)
	-- Make sure setting exists.
	local setting, ret = self.SettingsByKey[key], false;
	if(not setting) then return false; end
	-- Act based on location.
	if(setting.Location == self.SettingLocations.Aura and self.Auras[(id or PowaBrowser:GetSelectedAura())]) then
		-- Save value to aura.
		self.Auras[(id or PowaBrowser:GetSelectedAura())][setting.Name] = value;
		ret = true;
	elseif(setting.Location == self.SettingLocations.Global) then
		-- Save to global options table.
		PowaGlobalMisc[setting.Name] = value;
		ret = true;
	elseif(setting.Location == self.SettingLocations.Char) then
		-- Save to per-char options table.
		PowaMisc[setting.Name] = value;
		ret = true;
	end
	-- Call OnUpdate func. Pass new value.
	self:UpdateSetting(key, value);
	-- Done.
	return ret;
end
--- Fires all of the setting callbacks, passing the key of the setting that was updated and the new value to the 
-- functions.
-- @param key The key of the setting which has been updated.
-- @param value The value to be passed to the callback functions.
-- @return Returns false if the setting does not exist.
function PowaAuras:UpdateSetting(key, value)
	-- Make sure setting exists.
	if(not self.SettingsByKey[key]) then return false; end
	-- Run update funcs.
	for _, func in ipairs(self.SettingCallbacks) do
		func(key, value);
	end
end
--- Calls UpdateSetting for all Aura related setting keys if the passed aura ID exists.
-- @param id The ID of the aura to use.
function PowaAuras:FireAuraSettingCallbacks(id)
	-- Make sure aura exists.
	if(not self.Auras[id]) then return; end
	-- Go over registered settings.
	for key, data in pairs(self.SettingsByKey) do
		if(data.Location == self.SettingLocations.Aura) then
			self:UpdateSetting(key, self:GetSetting(key, id));
		end
	end
end
--- Determines the next free aura slot on the given page. If no page is specified then the selected page in the aura
-- browser is used.
-- @param page The page to find a free slot on. If no page is given, the currently selected page is used.
-- @return A mixed value based on whether or not a free slot could be found on the page. An integer representing the
-- empty aura ID slot if found, or false if no free slot was found on the page.
-- @return The page index scanned. You can use this to determine the page scanned if you didn't pass one as a parameter.
function PowaAuras:GetNextFreeSlot(page)
	-- Default to currently selected page if needed.
	if(not page) then page = PowaBrowser.SelectedPage; end
	for i=(1+((page-1)*24)), (24+((page-1)*24)) do
		if(not self.Auras[i]) then return i, page; end
	end
	-- We did the loop? Damn.
	return false, page;
end
--- Creates a new aura with the default settings and type (Buff) on the given page. If a page is not given, then the
-- currently selected page in the AuraEditor is used.
-- @param page The page to create the aura on. Leaving this blank will default to the selected page in the aura browser.
function PowaAuras:CreateAura(page)
	-- Get a new aura slot. It also returns the page, so will allow for a nil arg to be passed and corrected.
	local i, page = self:GetNextFreeSlot(page);
	if(not i or not page) then return false; end
	-- Select it.
	PowaBrowser:OnSelectedKeyChanged(page); -- Update page if needed.
	PowaBrowser:SetSelectedAura(i);
	-- Build a new aura.
	local aura = self:AuraFactory(self.BuffTypes.Buff, i);
	aura:Init();
	self.Auras[i] = aura;
	-- Save to appropriate config table.
	self:UpdateAuraTables(i);
	-- Fix other things.
	self:ReindexAuras(false);
	aura:CheckActive(true, true, true);
	self:DisplayAura(i);
end
--- Attempts to delete the aura with the given ID. This will in turn invoke an aura reindexing after the aura has been
-- deleted.
-- @param id The ID of the aura to delete.
-- @param quickDelete Defaults to false, if set to true then ReindexAuras will not be called.
function PowaAuras:DeleteAura(id, quickDelete)
	-- AURA, YOU MUST EXIST.
	if(not self.Auras[id]) then return; end
	-- Dispose.
	self:ToggleAuraDisplay(id, false, true);
	if(self.Auras[id].Timer) then self.Auras[id].Timer:Dispose(); end
	if(self.Auras[id].Stacks) then self.Auras[id].Stacks:Dispose(); end
	self.Auras[id]:Dispose();
	-- Remove.
	self.Auras[id] = nil;
	self:UpdateAuraTables(id);
	-- Fix things.
	if(not quickDelete) then
		self:ReindexAuras(true);
	end
end
--- Attempts to change the type of the aura with the given ID.
-- @param id The iD of the aura to change type.
-- @param new The new type of aura.
function PowaAuras:ChangeAuraType(id, new)
	-- Get the old aura.
	local aura, oldAura = nil, self.Auras[id];
	if(not oldAura) then
		return;
	end
	-- Dispose of old aura.
	oldAura:Dispose();
	-- Clear icon on old aura.
	oldAura.IconPath = "";
	-- Build the new aura.
	aura = self:AuraFactory(new, id, oldAura);
	-- Initialise it.
	aura:Init();
	self.Auras[id] = aura;
	-- Save to appropriate config table.
	self:UpdateAuraTables(id);
	-- Fix other things.
	self:ReindexAuras(false);	
end
--- Toggles the displays of all auras. Can optionally force a specific display state, force a refresh or only update
-- auras that are already actively displaying.
-- @param activeOnly Set to true if you only want to toggle auras that are actively displaying. Defaults to false.
-- @param forceDisplay Set to true if you want to force the aura to refresh by toggling it off and then on immediately
-- afterwards. Setting this to true will ignore the state parameter. Defaults to false.
-- @param state Forces a specific state to be applied to the auras, set to true if you want the auras to show or false
-- if you want the auras to hide. Nil values will toggle the state to be the inverse of what it is currently, and is
-- the default.
function PowaAuras:ToggleAllAuras(activeOnly, forceDisplay, state)
	-- Need to be done.
	if(not (self.VariablesLoaded and self.SetupDone)) then return; end 
	-- Go over all auras.
	for id, aura in pairs(self.Auras) do
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
end
--- Reindexes auras both internally and on the AuraBrowser interface, with an optional check to make sure no "gaps"
-- are present.
-- @param fullCheck Set to true if you want a longer, more costly check to take place. This will move auras around to
-- prevent gaps appearing. The full check is applied to all pages unless specified.
-- @param checkPage Optional integer. Pass a specific page number to limit the reindexing operation to that specific 
-- page for a significant speed improvement.
function PowaAuras:ReindexAuras(fullCheck, checkPage)
	-- Do a full check?
	if(fullCheck) then
		-- Go go power rangers! Loop through all pages by default, limit to just a specific page if told to.
		for page=(checkPage or 1), (checkPage or self.MaxPages) do
			-- Storage for current auras iterated on this page.
			local count = 0;
			for aura=1, self.MaxAurasPerPage do
				-- Calculate the real ID.
				local auraID = ((page-1)*self.MaxAurasPerPage)+aura;
				-- Does the aura exist?
				if(self.Auras[auraID]) then
					-- Hide aura.
					self:ToggleAuraDisplay(auraID, false, true);
					-- Increment counter.
					count = count+1;
					-- Is the count in line with the aura index on this page?
					if(count ~= aura) then
						-- Reindexing required.
						self:ReindexAura(auraID, ((page-1)*self.MaxAurasPerPage)+count, false);
					end
				end
			end
		end
	end
	-- Basic function calls.
	self:CalculateAuraSequence();
	PowaBrowser:TriageIcones();
end
-- Storage table for ReindexAura.
local reindexTable = {};
--- Reindexes a specific aura from one ID to another, and updates the aura chains to reflect the change. By default
-- the operation performed is a move, and the aura at the old location will be replaced with a nil value. Note that
-- reindexing auras is a slow operation.
-- @param oldID The current location of the aura.
-- @param newID The new location of the aura.
-- @param doCopy Optional boolean, set to true if you want the aura to remain in the old location and to copy it to the
-- new location. False is the default behaviour and moves the aura.
function PowaAuras:ReindexAura(oldID, newID, doCopy)
	-- Get old aura.
	local oldAura, newAura = self.Auras[oldID];
	if(not oldAura or not newID) then
		-- Error.
		return;
	end
	-- Copying or moving? We could pretend we're copying but it'll be slower.
	if(doCopy) then
		-- Right, slow mode.
		self.Auras[newID] = self:AuraFactory(oldAura.bufftype, newID, oldAura);
		newAura = self.Auras[newID];
		-- Copy the decorators to the new aura.
		oldAura:CopyDecorators(newID);
	else
		-- It's a move. Moving is really easy.
		self.Auras[newID] = oldAura;
		newAura = self.Auras[newID];
		-- Clear old crap.
		oldAura = nil;
		self:DeleteAura(oldID, true);
		-- Update the ID on the decorators/triggers. Do this after deleting the old aura, otherwise things explode.
		newAura:UpdateAuraID(newID);
		-- Go over all auras and update any ID references.
		local reindexTable, reindexCount = reindexTable, 0;
		for i=1, self.MaxAuras do
			local aura = self.Auras[i];
			-- Does aura exist, and have ID's?
			if(aura and aura.multiids and aura.multiids:trim() ~= "") then
				-- Wipe temp table.
				wipe(reindexTable);
				reindexCount = 0;
				-- Go over ID's.
				for id in aura.multiids:trim():gmatch("[^/]+") do
					-- Inc. counter.
					reindexCount = reindexCount+1;
					-- Trim id.
					id = id:trim();
					-- Preserve inverse if needed.
					local isInverse = (id:sub(1, 1) == "!" and true or false);
					-- Does the ID match the old one?
					if(isInverse and tonumber(id:sub(2)) == oldID or tonumber(id) == newID) then
						-- Replace!
						reindexTable[reindexCount] = (isInverse and "!" or "") .. newID;
					else
						-- No, fine.
						reindexTable[reindexCount] = (isInverse and "!" or "") .. id;
					end
				end
				-- Replace ID's.
				aura.multiids = strjoin("/", unpack(reindexTable));
			end
		end
	end
	-- Update global settings tables.
	self:UpdateAuraTables(oldID);
	self:UpdateAuraTables(newID);
end
--- Toggles the display state of an aura, hiding it if already shown and vice versa.
-- Can optionally force a specific state to be used.
-- @param id The ID of the aura to toggle.
-- @param state A state to force upon the aura. Pass true to force it to show, or false to force it to hide.
-- @param noUpdate Set to true if you want the aura to display without triggering an update on the AuraBrowser.
function PowaAuras:ToggleAuraDisplay(id, state, noUpdate)
	-- Need to be done.
	if(not (self.VariablesLoaded and self.SetupDone)) then return; end 
	-- Aura required!
	local aura = self.Auras[id];
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
end
--- Enables or Disables an aura. Can optionally use this to force a specific state on the aura.
-- @param id The ID of the aura to enable or disable.
-- @param state An optional state to force on the aura. Set to true if you want the aura to be enabled, false otherwise.
function PowaAuras:ToggleAuraEnabled(id, state)
	-- Aura required!
	if(not self.Auras[id]) then return; end
	if(state == nil) then
		state = not self.Auras[id].off;
	end
	self.Auras[id].off = state;
	self:ToggleAuraDisplay(id, false);
end
--- Creates a single aura or an entire aura set from the given import string. The type is determined automatically and
-- if a set is to be imported then all auras on the currently selected page in the editor are deleted. If no page is
-- selected, then it will default to the first page. If you are only importing a single aura, then it will attempt to
-- find space on the currently selected page in the editor. If no space is found then false is returned, and importing
-- is cancelled. It is recommended that you wrap any calls to this function inside of pcall() to prevent lua errors 
-- from being displayed to the user.
-- @param importString The string to read as an import code. The string is trimmed automatically.
-- @return True if the import has probably succeeded, false otherwise.
function PowaAuras:CreateAuraFromImport(importString)
	-- Make sure we've a string.
	if(not importString or importString:trim() == "") then
		return false;
	end
	-- Trim string.
	importString = importString:trim();
	-- Set or normal?
	if(importString:lower():sub(1, 4) == "set=") then
		-- Set. Delete all auras on this page.
		local page = ((PowaBrowser:GetSelectedPage() or 1)-1);
		for i=1, 24 do
			self:DeleteAura((page*24)+i, true);
		end
		-- We'll grab the new page name when parsing the string.
		local setName, offset, auraID = nil, nil, (page*24)+1;
		-- Go over values.
		for k, v in string.gmatch(importString, "([^\n=@]+)=([^@]+)@") do
			-- Is this the set name declaration?
			if(k:lower() == "set") then
				setName = (v and v:trim() or nil);
			else
				-- Normal data. Check imported aura ID offset.
				if(not offset) then
					local _, _, oldAuraID = k:find("(%d+)");
					if(self:IsNumeric(oldAuraID)) then
						offset = ((page*24)+1)-oldAuraID;
					end
				end
				-- Import single aura to this ID.
				self.Auras[auraID] = self:ImportAura(v, auraID, offset);
				self.Auras[auraID]:Init();
				-- Save to appropriate config table.
				self:UpdateAuraTables(auraID);
				-- Increment aura ID.
				auraID = auraID+1;
			end
		end
		-- Did it have a set name?
		if(setName and setName ~= "") then
			PowaBrowser:SavePageName(setName);
		end
		-- Fix sequences/icons.
		self:ReindexAuras(true);
	else
		-- Single aura. Find space on the page.
		local auraID = self:GetNextFreeSlot();
		if(not auraID) then
			-- Error.
			return false;
		end
		-- Import it.
		self.Auras[auraID] = self:ImportAura(importString, auraID);
		self.Auras[auraID]:Init();
		-- Save to appropriate config table.
		self:UpdateAuraTables(auraID);
		-- Fix sequences/icons.
		self:ReindexAuras(true);
	end
	-- It probably worked.
	return true;
end
--- Updates the global saved variable tables for Global/Class auras to reflect any changes to a specific aura ID or all
-- aura ID's.
-- @param auraID The ID of the aura to use when updating a saved variable table. If omitted, then both the Global and
-- Class tables are updated for all auras.
function PowaAuras:UpdateAuraTables(auraID)
	PowaAuras:ShowText("Updating aura tables for id: " .. tostring(auraID));
	-- Any aura ID?
	if(auraID and auraID > 0) then
		if(auraID > 120 and auraID < 361) then
			PowaGlobalSet[auraID] = self.Auras[auraID];
		elseif(auraID > 360) then
			PowaClassSet[select(2, UnitClass("player"))][auraID] = self.Auras[auraID];
		end
	else
		-- Right, just update the tables.
		for i=121, self.MaxAuras do
			if(i > 120 and i < 361) then
				PowaGlobalSet[i] = self.Auras[i];
			elseif(i > 360) then
				PowaClassSet[select(2, UnitClass("player"))][i] = self.Auras[i];
			end
		end
	end
end
--- Determines what page number the given aura ID belongs to.
-- @params auraID The aura ID to return a page number for.
-- @return The page number the aura ID belongs to.
function PowaAuras:GetAuraPage(auraID)
	return ceil(auraID/self.MaxAurasPerPage);
end

-- Register settings and any handlers below here.
for k, _ in pairs(PowaGlobalMisc) do
	PowaAuras:RegisterSetting(k, k, PowaAuras.SettingLocations.Global);
end
for k, _ in pairs(PowaMisc) do
	PowaAuras:RegisterSetting(k, k, PowaAuras.SettingLocations.Char);
end
for k, _ in pairs(cPowaAura.ExportSettings) do
	PowaAuras:RegisterSetting("Aura." .. k, k, PowaAuras.SettingLocations.Aura);
end
for k, _ in pairs(cPowaTimer.ExportSettings) do
	PowaAuras:RegisterSetting("Aura.Timer." .. k, k, PowaAuras.SettingLocations.AuraTimer);
end
for k, _ in pairs(cPowaStacks.ExportSettings) do
	PowaAuras:RegisterSetting("Aura.Stacks." .. k, k, PowaAuras.SettingLocations.AuraStacks);
end

-- Add a general update function for when these settings change.
PowaAuras:RegisterSettingCallback(function(key, value)
	if(PowaAuras.ModTest and PowaGlobalMisc[key] ~= nil or PowaMisc[key] ~= nil) then
		PowaAuras:ToggleAllAuras(true, true);
	end
end);
