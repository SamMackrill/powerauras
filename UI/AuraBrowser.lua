-- Add a definition for the browser frame. We'll only ever make one, but I'm sick of a lot of functions 
-- inside that big one. Besides, I like this system, do you? It's more memory efficient...I think. 
-- Does defining the same closure repeatedly cost more memory, rather than referencing a single defined closure?
PowaAuras.UI["AuraBrowser"] = {
	Init = function(self)
		-- Variables.
		self.SelectedAuras = {};
		self.SelectedPage = 1;
		-- Add OnSelectionChanged function to tree views.
		self.Tabs.Auras.Tree.OnSelectionChanged = self.OnSelectionChanged;
		-- Check...
		if(PowaAuras.VariablesLoaded) then self:OnVariablesLoaded(); end
	end,
	CountSelectedAuras = function(self)
		return #(self.SelectedAuras);
	end,
	GetPageName = function(self)
		local page = self.Tabs.Auras.Tree:GetSelectedKey();
		if(not page) then return ""; end
		if(page <= 5) then
			return PowaPlayerListe[page];
		elseif(page > 5 and page <= 15) then
			return PowaGlobalListe[page-5];
		elseif(page > 15 and page <= 20) then
			return PowaClassListe[UnitClass("player")][page-15];
		end
	end,
	GetSelectedAuras = function(self)
		return self.SelectedAuras;
	end,
	OnSelectionChanged = function(self, key)
		-- Save page.
		PowaBrowser.SelectedPage = key;
		-- Deselect any and all auras. This will trigger a button update.
		PowaBrowser:SetSelectedAura(nil, 0x1);
	end,
	OnVariablesLoaded = function()
		-- Easymode.
		local self = PowaBrowser;
		-- Do update check.
		if(PowaAuras.VersionInt > PowaGlobalMisc["LastVersion"]) then
			self.ShowVersionDialog = true;
		end
		-- First run check.
		if(PowaGlobalMisc["FirstRun"] == true) then
			self.ShowRunDialog = true;
			PowaGlobalMisc["FirstRun"] = false;
			-- Don't bother showing the version upgrade dialog if it's the first run.
			self.ShowVersionDialog = false;
		end
		-- Fix class auras. (TODO: Move this elsewhere)
		local class = UnitClass("player");
		if(not PowaClassListe) then PowaClassListe = {}; end
		if(not PowaClassListe[class]) then
			PowaClassListe[class] = {};
			for i=1,5 do
				PowaClassListe[class][i] = "Class " .. i;
			end
		end
		-- Counts.
		local playerPageCount, globalPageCount, classPageCount = #(PowaPlayerListe), #(PowaGlobalListe), #(PowaClassListe[class]);
		self.Tabs.Auras.Tree:AddItem("CHAR", PowaAuras.Text["UI_CharAuras"], nil, nil, true);
		for i=1,playerPageCount do
			self.Tabs.Auras.Tree:AddItem(i, PowaPlayerListe[i], "CHAR");
		end
		self.Tabs.Auras.Tree:AddItem("GLOBAL", PowaAuras.Text["UI_GlobAuras"], nil, nil, true);
		for i=1,globalPageCount do
			self.Tabs.Auras.Tree:AddItem(i+playerPageCount, PowaGlobalListe[i], "GLOBAL");
		end
		self.Tabs.Auras.Tree:AddItem("CLASS", PowaAuras.Text["UI_ClassAuras"], nil, nil, true);
		for i=1,classPageCount do
			self.Tabs.Auras.Tree:AddItem(i+playerPageCount+globalPageCount, PowaClassListe[class][i], "CLASS");
		end
		-- Add 24 beautiful buttons.
		self.Tabs.Auras.Page:SetLocked(true);
		for i=1,24 do
			-- Make button.
			local button = CreateFrame("Button", nil, self.Tabs.Auras.Page, "PowaAuraButtonTemplate");
			PowaAuras.UI.AuraButton(button);		
			-- Save.
			self.Tabs.Auras.Page:AddItem(button);
			self.Tabs.Auras.Page["Aura" .. i] = button;
		end
		-- Select things.
		self.Tabs.Auras.Tree:SetSelectedKey(1);
		-- Unlock (we just prevented 24 loops!)
		self.Tabs.Auras.Page:SetLocked(false);
		-- Button update.
		self:UpdateAuraButtons();
	end,
	SavePageName = function(self, name)
		-- Get the page.
		local page = self.Tabs.Auras.Tree:GetSelectedKey();
		if(not page) then return; end
		-- Write the name.
		if(page <= 5) then
			PowaPlayerListe[page] = name;
		elseif(page > 5 and page <= 15) then
			PowaGlobalListe[page-5] = name;
		elseif(page > 15 and page <= 20) then
			PowaClassListe[UnitClass("player")][page-15] = name;
		end
		-- Update listview.
		self.Tabs.Auras.Tree:GetItem(page):SetText(name);
	end,
	SetSelectedAura = function(self, id, multiSelectMode)
		-- Deselect if already selected.
		if(id and tContains(self.SelectedAuras, id)) then
			-- If ctrl is down, just deselect this one.
			if(id and multiSelectMode == 0x2) then
				for k,v in pairs(self.SelectedAuras) do
					if(v == id) then
						table.remove(self.SelectedAuras, k);
						self:UpdateAuraButtons();
						return;
					end
				end
			elseif(id and multiSelectMode == 0x1 and #(self.SelectedAuras) > 1) then
				-- You clicked one which was selected but didn't use a modifier key, so deselect all but this one.
				wipe(self.SelectedAuras)
				tinsert(self.SelectedAuras, id);
				self:UpdateAuraButtons();
			elseif(id and multiSelectMode == 0x1 and #(self.SelectedAuras) == 1) then
				-- Deselect all.
				wipe(self.SelectedAuras)
				self:UpdateAuraButtons();
			end
			-- Done, either way...
			return;
		end
		-- Wipe the auras table if no ID has been given, or if multiple selection is off.
		if(not id or multiSelectMode == 0x1) then
			wipe(self.SelectedAuras);
			if(not id) then
				self:UpdateAuraButtons();
				return;
			end
		end
		-- If we got this far we probably should just add the aura...
		if(multiSelectMode ~= 0x4) then
			tinsert(self.SelectedAuras, id);
		else
			-- Select all between the last selected aura and this one.
			local lastID;
			for _,v in pairs(self.SelectedAuras) do
				lastID = v;
			end
			wipe(self.SelectedAuras);
			if(not lastID) then lastID = ((self.SelectedPage-1)*24)+1; end
			-- Onwards!
			for i=lastID, id, (lastID < id and 1 or -1) do
				tinsert(self.SelectedAuras, i);
			end
		end		
		-- Update buttons.
		self:UpdateAuraButtons();
	end,
	UpdateAuraButtons = function(self)
		print("|cFF527FCCDEBUG (AuraBrowser): |rUpdating aura buttons!");
		-- Not strictly button related, but it prevents two function calls.
		PowaBrowser.Tabs.Auras.Page.Title:SetText(self:GetPageName());
		PowaBrowser.Tabs.Auras.Page.Title:ClearFocus();
		-- Go over buttons.
		for i=1,24 do
			local button, buttonAura = self.Tabs.Auras.Page["Aura" .. i], nil;
			-- Fix button and aura.
			button:SetAuraID(((self.SelectedPage-1)*24)+i);
			buttonAura = button:GetAura();
			-- Select/deselect.
			if(not tContains(self.SelectedAuras, button:GetAuraID())) then
				button:SetSelected(false);
			else
				button:SetSelected(true);
				-- button:SetLinked(false);
			end
			-- Icons.
			if(not buttonAura or not buttonAura.icon) then
				button.Icon:SetTexture("");
			else
				button.Icon:SetTexture(buttonAura.icon);
			end
		end
		-- No longer need you, mister linkedAuras.
		if(linkedAuras) then wipe(linkedAuras); end
	end
}

-- And a definition for the item.
PowaAuras.UI["AuraButton"] = {
	Scripts = {
		"OnClick"
	},
	Init = function(self, icon)
		-- Set things up.
		self.AuraID = id;
		self:SetIcon(icon or "");
		-- Register clicks.
		self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
		self:RegisterForDrag(true);
	end,
	GetAura = function(self)
		return PowaAuras.Auras[self.AuraID] or nil;
	end,
	GetAuraID = function(self)
		return self.AuraID;
	end,
	SetAuraID = function(self, id)
		self.AuraID = id;
	end,
	SetIcon = function(self, icon)
		self.Icon:SetTexture(icon);
	end,
	-- SetLinked = function(self, linked)
		-- self.Linked = linked;
		-- self:Update();
	-- end,
	OnClick = function(self, button)
		-- Left or right?
		if(button == "LeftButton") then
			-- Select aura.
			PowaBrowser:SetSelectedAura(self.AuraID, (IsControlKeyDown() and 0x2 or IsShiftKeyDown() and 0x4 or 0x1));
		elseif(button == "RightButton") then
			-- Shortcut for edit.
			
		end
	end,
	SetSelected = function(self, selected)
		self.Selected = selected;
		self:Update();
	end,
	Update = function(self)
		local texture = self:GetNormalTexture();
		-- Update texture state based on this priority.
		if(self.Selected) then
			texture:SetTexCoord(0.0078125, 0.2734375, 0.80859375, 0.94140625);
			texture:SetVertexColor(1, 1, 1);
		-- elseif(self.Linked) then
			-- texture:SetTexCoord(0.0078125, 0.2734375, 0.671875, 0.8046875);
			-- texture:SetVertexColor(1, 1, 1);
		else
			texture:SetTexCoord(0.0078125, 0.2734375, 0.80859375, 0.94140625);
			texture:SetVertexColor(0.75, 0.325, 0.325);
		end
	end,
};
-- Register.
PowaAuras.UI:DefineWidget("AuraBrowser");
PowaAuras.UI:DefineWidget("AuraButton");