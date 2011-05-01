-- Add a definition for the browser frame. We'll only ever make one, but I'm sick of a lot of functions 
-- inside that big one. Besides, I like this system, do you? It's more memory efficient...I think. 
-- Does defining the same closure repeatedly cost more memory, rather than referencing a single defined closure?
PowaAuras.UI:Register("AuraBrowser", {
	Init = function(self)
		-- Variables.
		self.SelectedAura = nil;
		self.SelectedPage = 1;
		-- Add OnSelectionChanged function to tree views.
		self.Tabs.Auras.Tree.OnSelectionChanged = self.OnSelectionChanged;
		-- Check...
		if(PowaAuras.VariablesLoaded) then self:OnVariablesLoaded(); end
		-- Close on escape key.
		-- tinsert(UISpecialFrames, self:GetName());
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
	GetSelectedAura = function(self)
		return self.SelectedAura;
	end,
	IsAuraSelected = function(self, id)
		return (self.SelectedAura == id);
	end,
	OnSelectionChanged = function(self, key)
		-- Save page.
		PowaBrowser.SelectedPage = key;
		-- Deselect any and all auras. This will trigger a button update.
		PowaBrowser:SetSelectedAura(nil);
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
		-- Counts.
		local class = UnitClass("player");
		local playerPageCount, globalPageCount, classPageCount = #(PowaPlayerListe), #(PowaGlobalListe), 
			#(PowaClassListe[class]);
		-- Character auras.
		self.Tabs.Auras.Tree:AddItem("CHAR", PowaAuras.Text["UI_CharAuras"], nil, nil, true);
		for i=1,playerPageCount do
			self.Tabs.Auras.Tree:AddItem(i, PowaPlayerListe[i], "CHAR");
		end
		-- Global auras.
		self.Tabs.Auras.Tree:AddItem("GLOBAL", PowaAuras.Text["UI_GlobAuras"], nil, nil, true);
		for i=1,globalPageCount do
			self.Tabs.Auras.Tree:AddItem(i+playerPageCount, PowaGlobalListe[i], "GLOBAL");
		end
		-- Class auras.
		self.Tabs.Auras.Tree:AddItem("CLASS", PowaAuras.Text["UI_ClassAuras"], nil, nil, true);
		for i=1,classPageCount do
			self.Tabs.Auras.Tree:AddItem(i+playerPageCount+globalPageCount, PowaClassListe[class][i], "CLASS");
		end
		-- Add 24 beautiful buttons.
		self.Tabs.Auras.Page:SetLocked(true);
		for i=1,24 do
			-- Make button.
			local button = CreateFrame("Button", nil, self.Tabs.Auras.Page, "PowaAuraButtonTemplate");
			PowaAuras.UI:AuraButton(button);		
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
	SetSelectedAura = function(self, id)
		-- Set it.
		self.SelectedAura = id;
		-- Update the editor.
		if(PowaEditor:IsShown()) then
			PowaEditor:Show();
		end
		-- Update buttons.
		self:UpdateAuraButtons();
		-- Update our thing.
	end,
	UpdateAuraButtons = function(self)
		print("|cFF527FCCDEBUG (AuraBrowser): |rUpdating aura buttons!");
		-- Not strictly button related, but it prevents two function calls.
		PowaBrowser.Tabs.Auras.Page.Title:SetText(self:GetPageName());
		PowaBrowser.Tabs.Auras.Page.Title:ClearFocus();
		-- Keep track of if we've displayed at least one empty button.
		local hasDisplayedEmpty = nil;
		-- Go over buttons.
		for i=1,24 do
			local button, buttonAura = self.Tabs.Auras.Page["Aura" .. i], nil;
			-- Fix button and aura.
			button:SetAuraID(((self.SelectedPage-1)*24)+i);
			buttonAura = button:GetAura();
			-- ...Was there an aura?
			if(buttonAura) then
				-- Select/deselect.
				if(self.SelectedAura ~= button:GetAuraID()) then
					button:SetSelected(false);
				else
					button:SetSelected(true);
				end
				-- Don't make it create an aura, please!!
				button:SetCreateAura(false);
				-- Icons.
				if(not buttonAura.icon or buttonAura.icon == "") then
					button.Icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");
				else
					button.Icon:SetTexture(buttonAura.icon);
				end
				-- Restore texcoords.
				button.Icon:SetTexCoord(0.07, 0.93, 0.07, 0.93);
				-- Show button.
				button:Show();
			else
				-- Hide?
				if(hasDisplayedEmpty) then
					button.Icon:SetTexture("");
					button:SetSelected(false);
					button:SetCreateAura(false);
					button:Hide();
				else
					-- Prevent further buttons being displayed.
					hasDisplayedEmpty = true;
					-- Flag this one as an aura creator.
					button:SetCreateAura(true);
					-- Icon fixes (use different texcoords as it slips to the right a bit here).
					button.Icon:SetTexture("Interface\\GuildBankFrame\\UI-GuildBankFrame-NewTab");
					button.Icon:SetTexCoord(0.11, 0.93, 0.07, 0.93);
					-- Allow it to be selected.
					if(self.SelectedAura ~= button:GetAuraID()) then
						button:SetSelected(false);
					else
						button:SetSelected(true);
					end
					button:Show();
				end
			end
		end
		-- Bugfix for buttons vanishing.
		PowaBrowser.Tabs.Auras.Page:UpdateLayout();
		-- No longer need you, mister linkedAuras.
		if(linkedAuras) then wipe(linkedAuras); end
	end
});

-- And a definition for the button.
PowaAuras.UI:Register("AuraButton", {
	Scripts = {
		"OnClick",
	},
	Init = function(self, icon)
		-- Set things up.
		self.AuraID = id;
		self:SetIcon(icon or "");
		-- Register clicks.
		self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
		-- I demand a tooltip.
		PowaAuras.UI:Tooltip(self);
	end,
	GetAura = function(self)
		return PowaAuras.Auras[self.AuraID] or nil;
	end,
	GetAuraID = function(self)
		return self.AuraID;
	end,
	GetCreateAura = function(self)
		return self.CreateAura;
	end,
	SetAuraID = function(self, id)
		self.AuraID = id;
	end,
	SetIcon = function(self, icon)
		self.Icon:SetTexture(icon);
	end,
	OnClick = function(self, button)
		-- Left or right?
		if(button == "LeftButton") then
			-- Select aura, or create.
			if(self.CreateAura) then
				print("|cFF527FCCDEBUG (AuraBrowser): |rCreate aura: " .. self.AuraID);
				PowaBrowser:SetSelectedAura(self.AuraID, self.CreateAura);
			else
				PowaBrowser:SetSelectedAura(self.AuraID, self.CreateAura);
			end
			-- Is the ctrl key down?
			if(IsControlKeyDown()) then
				-- Debug the aura too.
			end
		elseif(button == "RightButton" and not self.CreateAura) then
			-- Shortcut for edit.
			PowaBrowser:SetSelectedAura(self.AuraID, self.CreateAura);
			PowaEditor:Show();
			print("|cFF527FCCDEBUG (AuraBrowser): |rOpen aura editor: " .. self.AuraID);
		end
	end,
	SetCreateAura = function(self, create)
		self.CreateAura = create;
	end,
	SetSelected = function(self, selected)
		self.Selected = selected;
		self:Update();
	end,
	TooltipRefresh = function(self)
		-- Hide tip.
		GameTooltip:Hide();
		-- Reparent.
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0);
		-- Set back up.
		if(not self.CreateAura) then
			GameTooltip:SetText(PowaAuras.Text.AuraType[PowaAuras.Auras[self.AuraID].bufftype]);
			GameTooltip:AddLine(format("|cFFFFD100%s: |r%d", PowaAuras.Text.UI_ID, self.AuraID), 1, 1, 1, true);
			if(PowaAuras.Auras[self.AuraID] and PowaAuras.Auras[self.AuraID].buffname) then
				GameTooltip:AddLine(tostring(PowaAuras.Auras[self.AuraID].buffname), 1, 1, 1, true);
			end
			GameTooltip:AddLine(PowaAuras.Text["UI_SelAura_TooltipExt"], 1, 1, 1, true);
		else
			GameTooltip:SetText(PowaAuras.Text["UI_CreateAura"]);
			GameTooltip:AddLine(PowaAuras.Text["UI_CreateAura_Tooltip"], 1, 1, 1, true);
		end
		-- Show tip.
		GameTooltip:Show();
	end,
	Update = function(self)
		local texture = self:GetNormalTexture();
		-- Update texture state based on this priority.
		if(self.Selected) then
			texture:SetTexCoord(0.0078125, 0.2734375, 0.80859375, 0.94140625);
			texture:SetVertexColor(1, 1, 1);
		else
			texture:SetTexCoord(0.0078125, 0.2734375, 0.80859375, 0.94140625);
			texture:SetVertexColor(0.75, 0.325, 0.325);
		end
	end,
});