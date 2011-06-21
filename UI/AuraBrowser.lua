-- Add a definition for the browser frame. We'll only ever make one, but I'm sick of a lot of functions 
-- inside that big one. Besides, I like this system, do you? It's more memory efficient...I think. 
-- Does defining the same closure repeatedly cost more memory, rather than referencing a single defined closure?
PowaAuras.UI:Register("AuraBrowser", {
	Scripts = {
		OnShow = true,
		OnHide = true,
	},
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
	GetSelectedPage = function(self)
		return self.SelectedPage;
	end,
	GetSelectedAura = function(self)
		return self.SelectedAura;
	end,
	IsAuraSelected = function(self, id)
		return (self.SelectedAura == id);
	end,
	OnHide = function(self)
		PlaySound("igMainMenuClose");
		PowaAuras.ModTest = false;
		PowaAuras:ToggleAllAuras(false, false, false);
		PowaAuras.DoCheck.All = true;
	end,
	OnSelectionChanged = function(self, key)
		-- Save page.
		PowaBrowser.SelectedPage = key;
		-- Deselect any and all auras. This will trigger a button update.
		PowaBrowser:SetSelectedAura(nil);
	end,
	OnShow = function(self)
		PlaySound("igCharacterInfoTab");
		PowaAuras.ModTest = true;
	end,
	OnVariablesLoaded = function(self)
		-- Do update check.
		if(PowaAuras.VersionInt > PowaAuras:GetSetting("LastVersion")) then
			self.ShowVersionDialog = true;
		end
		-- First run check.
		if(PowaAuras:GetSetting("FirstRun") == true) then
			self.ShowRunDialog = true;
			PowaAuras:SaveSetting("FirstRun", false);
			-- Don't bother showing the version upgrade dialog if it's the first run.
			self.ShowVersionDialog = false;
		end
		-- Counts.
		local class = UnitClass("player");
		local playerPageCount, globalPageCount, classPageCount = #(PowaPlayerListe), #(PowaGlobalListe), 
			#(PowaClassListe[class]);
		-- Character auras.
		self.Tabs.Auras.Tree:AddItem("CHAR", PowaAuras.Text["UI_CharAuras"], nil, true);
		for i=1,playerPageCount do
			self.Tabs.Auras.Tree:AddItem(i, PowaPlayerListe[i], "CHAR");
		end
		-- Global auras.
		self.Tabs.Auras.Tree:AddItem("GLOBAL", PowaAuras.Text["UI_GlobAuras"], nil, true);
		for i=1,globalPageCount do
			self.Tabs.Auras.Tree:AddItem(i+playerPageCount, PowaGlobalListe[i], "GLOBAL");
		end
		-- Class auras.
		self.Tabs.Auras.Tree:AddItem("CLASS", PowaAuras.Text["UI_ClassAuras"], nil, true);
		for i=1,classPageCount do
			self.Tabs.Auras.Tree:AddItem(i+playerPageCount+globalPageCount, PowaClassListe[class][i], "CLASS");
		end
		-- Add 24 beautiful buttons.
		self.Tabs.Auras.Page:SetLocked(true);
		for i=1,24 do
			-- Make button.
			local button = PowaAuras.UI:AuraButton(self.Tabs.Auras.Page);
			-- Save.
			self.Tabs.Auras.Page:AddItem(button);
			self.Tabs.Auras.Page["Aura" .. i] = button;
		end
		-- Select things.
		self.Tabs.Auras.Tree:SetSelectedKey(1);
		-- Unlock (we just prevented 24 loops!)
		self.Tabs.Auras.Page:SetLocked(false);
		-- Button update.
		self:TriageIcones();
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
	SetSelectedAura = function(self, id, isCreate)
		-- Set it.
		self.SelectedAura = id;
		-- Update the editor.
		if(PowaEditor:IsShown()) then
			PowaEditor:Show();
		end
		-- Update buttons.
		self:TriageIcones();
		-- Update our stuffs!
		if(isCreate) then
			self.Tabs.Auras:SetSelectedTab(2);
		else
			self.Tabs.Auras:SetSelectedTab(1);
			if(not id) then
				self.Tabs.Auras.Page.SelectedTitle:SetText(PowaAuras.Text["UI_SelAura_None"]);
				self.Tabs.Auras.Page.AuraDelete:Hide();
				self.Tabs.Auras.Page.AuraEdit:Hide();
				self.Tabs.Auras.Page.AuraMove:Hide();
			else
				self.Tabs.Auras.Page.SelectedTitle:SetText(format(PowaAuras.Text["UI_SelAura_Title"], id));
				self.Tabs.Auras.Page.AuraDelete:Show();
				self.Tabs.Auras.Page.AuraEdit:Show();
				self.Tabs.Auras.Page.AuraMove:Show();
			end
		end
	end,
	TriageIcones = function(self)
		print("|cFF527FCCDEBUG (AuraBrowser): |rUpdating aura buttons!");
		-- Not strictly button related, but it prevents two function calls.
		self.Tabs.Auras.Page.Title:SetText(self:GetPageName());
		self.Tabs.Auras.Page.Title:ClearFocus();
		-- Keep track of if we've displayed at least one empty button.
		local hasDisplayedEmpty = nil;
		-- Go over buttons.
		for i=1,24 do
			local button, id = self.Tabs.Auras.Page["Aura" .. i], ((self.SelectedPage-1)*24)+i;
			-- Fix button and aura.
			button:SetAuraID(id);
			-- Is there an aura?
			if(button:GetAura()) then
				-- Update like normal.
				button:SetChecked((self.SelectedAura == id));
				button:Update(button.Flags["NORMAL"]);
			elseif(hasDisplayedEmpty) then
				-- Hide the button.
				button:SetChecked(false);
				button:Update(button.Flags["NOAURA"]);
			else
				-- It'll be a create aura button.
				button:SetChecked((self.SelectedAura == id));
				button:Update(button.Flags["CREATE"]);
				hasDisplayedEmpty = true;
			end
		end
		-- Bugfix for buttons vanishing.
		self.Tabs.Auras.Page:UpdateLayout();
	end,
});

-- And a definition for the button.
PowaAuras.UI:Register("AuraButton", {
	Flags = {
		NORMAL = 0x1,
		NOAURA = 0x2,
		CREATE = 0x4,
	},
	Scripts = {
		OnClick = true,
		OnEnter = true,
		OnLeave = true,
	},
	Hooks = {
		"SetChecked",
	},
	Construct = function(class, ui, parent, ...)
		-- Make button, run through normal constructor.
		return ui.Construct(class, ui, CreateFrame("CheckButton", nil, parent, "PowaAuraButtonTemplate"), ...);
	end,
	Init = function(self)
		-- Set things up.
		self.AuraID = id;
		self.State = self.Flags["NOAURA"];
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
	GetState = function(self)
		return self.State;
	end,
	OnClick = function(self, button)
		-- Always deselect ourself.
		self:SetChecked(false);
		-- Play a sound!
		PlaySound("UChatScrollButton");
		-- Left or right?
		if(button == "LeftButton") then
			-- I don't appreciate your tone, CREATE flag. I suggest you leave immediately.
			if(self.State == self.Flags["CREATE"]) then
				PowaBrowser:SetSelectedAura(self.AuraID, true);
				return;
			end
			-- Check modifier keys.
			if(IsAltKeyDown()) then
				-- Show/Hide aura.
				PowaAuras:ToggleAuraDisplay(self.AuraID, 
					((PowaEditor:IsShown() and PowaEditor.AuraID and PowaEditor.AuraID == self.AuraID) or nil));
			elseif(IsControlKeyDown()) then
				-- Debug the aura state.
				print("|cFF527FCCDEBUG (AuraButton): |rDebug aura: " .. self.AuraID);
			elseif(IsShiftKeyDown()) then
				-- Disable/Enable aura.
				PowaAuras:ToggleAuraEnabled(self.AuraID);
			else
				-- Select it.
				PowaBrowser:SetSelectedAura(self.AuraID, false);
			end
		elseif(button == "RightButton" and self.State == self.Flags["NORMAL"]) then
			-- Shortcut for edit.
			PowaBrowser:SetSelectedAura(self.AuraID, false);
			PowaEditor:Show();
		end
	end,
	OnEnter = function(self)
		-- Update.
		self:Update();
	end,
	OnLeave = function(self)
		-- Update.
		self:Update();
	end,
	SetAuraID = function(self, id)
		self.AuraID = id;
	end,
	SetChecked = function(self, checked)
		-- Call original func.
		self:__SetChecked(checked);
		-- Update state.
		self:Update();
	end,
	SetState = function(self, state)
		self.State = state;
	end,
	TooltipRefresh = function(self)
		-- Need an aura to continue.
		local aura = self:GetAura();
		if(not aura and self.State ~= self.Flags["CREATE"]) then
			-- Hang on, we've got a visible aura button with no aura.
			if(self:GetChecked()) then
				return PowaBrowser:SetSelectedAura(nil, false);
			else
				return PowaBrowser:TriageIcones();
			end
		end
		-- Hide tip.
		GameTooltip:Hide();
		-- Reparent.
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0);
		-- Set back up.
		if(self.State == self.Flags["NORMAL"]) then
			GameTooltip:SetText(PowaAuras.Text.AuraType[aura.bufftype]);
			GameTooltip:AddLine(format("|cFFFFD100%s: |r%d", PowaAuras.Text.UI_ID, self.AuraID), 1, 1, 1, true);
			if(aura.buffname) then
				GameTooltip:AddLine(tostring(aura.buffname), 1, 1, 1, true);
			end
			GameTooltip:AddLine(PowaAuras.Text["UI_SelAura_TooltipExt"], 1, 1, 1, true);
		else
			GameTooltip:SetText(PowaAuras.Text["UI_CreateAura"]);
			GameTooltip:AddLine(PowaAuras.Text["UI_CreateAura_Tooltip"], 1, 1, 1, true);
		end
		-- Show tip.
		GameTooltip:Show();
	end,
	Update = function(self, state)
		-- Get aura.
		local aura = self:GetAura();
		-- Use current state if needed.
		if(not state) then
			state = self:GetState();
		end
		-- If there's no aura, quit and complain. But ignore if we've been given the create flag.
		if(not aura and state ~= self.Flags["CREATE"]) then
			state = self.Flags["NOAURA"];
		end
		-- State update.
		self:SetState(state);
		-- Handle noaura states first.
		if(state == self.Flags["NOAURA"]) then
			self.Icon:SetTexture("");
			self:Hide();
			return;
		elseif(state == self.Flags["CREATE"]) then
			self.Icon:SetTexture("Interface\\GuildBankFrame\\UI-GuildBankFrame-NewTab");
			self.Icon:SetTexCoord(0.11, 0.93, 0.07, 0.93);
			self:SetAlpha(1);
			self.OffText:Hide();
		elseif(state == self.Flags["NORMAL"]) then		
			-- Icons.
			if(not aura.icon or aura.icon == "") then
				self.Icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");
			else
				self.Icon:SetTexture(aura.icon);
			end
			-- Restore texcoords.
			self.Icon:SetTexCoord(0.07, 0.93, 0.07, 0.93);
			-- Is the aura off, showing or not on and not showing?
			if(aura.off) then
				SetDesaturation(self.Icon, true);
				self:SetAlpha(0.5);
				self.OffText:Show();
			elseif(aura.Active) then
				SetDesaturation(self.Icon, false);
				self:SetAlpha(1);
				self.OffText:Hide();
			else
				SetDesaturation(self.Icon, false);
				self:SetAlpha(0.5);
				self.OffText:Hide();
			end
		end
		-- Show button.
		self:Show();
	end,
});

PowaAuras.UI:Register("CreateAuraRadioButton", {
	Base = "RadioButton",
	Template = "PowaCreateAuraRadioButtonTemplate",
	Items = {},
	Hooks = {
		"SetChecked",
	},
	SetChecked = function(self, checked)
		-- Update state.
		self:__SetChecked(checked);
		self.Selected = checked;
		-- Check new state.
		if(checked) then
			SetDesaturation(self.Icon, false);
			self:SetBackdropBorderColor(1, 0.82, 0, 1);
		else
			SetDesaturation(self.Icon, true);	
			self:SetBackdropBorderColor(0.3, 0.3, 0.3, 1);
		end
	end,
});
