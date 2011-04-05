-- OnLoad function for the browser frame.
function PowaBrowser_OnLoad(self)
	-- -- self.Tabs.Auras.Tree:AddItem(1, 1);
	-- -- self.Tabs.Auras.Tree:AddItem(2, 2, 1);
	-- -- self.Tabs.Auras.Tree:AddItem(3, 3, 1);
	-- -- self.Tabs.Auras.Tree:AddItem(4, 4, 2);
	-- -- self.Tabs.Auras.Tree:AddItem(5, 5, 4);
	-- -- self.Tabs.Auras.Tree:AddItem(6, 6, 2);
	-- -- self.Tabs.Auras.Tree:AddItem(7, 7, 4);
	-- -- self.Tabs.Auras.Tree:AddItem(8, 8, 2);
	-- -- self.Tabs.Auras.Tree:AddItem(9, 9, 5);
	-- -- self.Tabs.Auras.Tree:AddItem(10, 10, 5);
	-- -- self.Tabs.Auras.Tree:AddItem(11, 11, 10);
	-- -- self.Tabs.Auras.Tree:AddItem(12, 12, 11);
	-- -- self.Tabs.Auras.Tree:AddItem(13, 13, 5);
	-- -- self.Tabs.Auras.Tree:AddItem(14, 14, 5);
	-- -- self.Tabs.Auras.Tree:AddItem(15, 15);
	-- -- self.Tabs.Auras.Tree:AddItem(16, 16);
	-- -- self.Tabs.Auras.Tree:AddItem(17, 17, 16);
	-- -- self.Tabs.Auras.Tree:AddItem(18, 18, 17);
	-- -- self.Tabs.Auras.Tree:AddItem(19, 19, 16);
	-- -- self.Tabs.Auras.Tree:AddItem(20, 20, 18);
	-- -- self.Tabs.Auras.Tree:AddItem(21, 21);
end

-- The good bits.
function PowaBrowser_OnVariablesLoaded()
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
	-- Add functions to the browser frame.
	self.GetSelectedAura = function(self)
		return self.SelectedAura;
	end
	self.SetSelectedAura = function(self, id)
		if(id and self.SelectedAura == id) then return; end
		print("Selecting aura: " .. (id or "nil"));
		if(not id or not PowaAuras.Auras[id]) then print("No aura with id " .. (id or "nil") .. " exists. Continuing anyway..."); end
		self.SelectedAura = id;
		-- Update buttons.
		print("Randomizing linked aura status");
		for i=1,24 do
			local button = self.Tabs.Auras.Page["Aura" .. i];
			if(not id or button:GetAuraID() ~= id) then button:SetSelected(false); else button:SetSelected(true); end
			local rand = math.random(1,5);
			if(rand == 3 and id and i < 20) then
				button:SetLinked(true);
			else
				button:SetLinked(false);
			end
		end
	end
	self.GetPageName = function(self)
		local page = self.Tabs.Auras.Tree:GetSelectedKey();
		if(not page) then return ""; end
		if(page <= 5) then
			return PowaPlayerListe[page];
		elseif(page > 5 and page <= 15) then
			return PowaGlobalListe[page-5];
		elseif(page > 15 and page <= 20) then
			return PowaClassListe[UnitClass("player")][page-15];
		end
	end
	self.SavePageName = function(self, name)
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
	end
	-- Add OnSelectionChanged function to tree views.
	self.Tabs.Auras.Tree.OnSelectionChanged = function(self, key)
		-- Deselect any and all auras.
		PowaBrowser:SetSelectedAura(nil);
		-- Update aura buttons.
		print("Randomizing aura icons");
		for i=1,24 do
			PowaBrowser.Tabs.Auras.Page["Aura" .. i]:SetAuraID(((key-1)*24)+i);
			local rand = math.random(1,3);
			if(rand == 1 and i < 20) then
				PowaBrowser.Tabs.Auras.Page["Aura" .. i]:SetIcon("Interface\\Icons\\Ability_Creature_Cursed_05");
			elseif(rand == 2 and i < 20) then
				PowaBrowser.Tabs.Auras.Page["Aura" .. i]:SetIcon("Interface\\Icons\\Ability_Ambush");
			elseif(rand == 3 and i < 20) then
				PowaBrowser.Tabs.Auras.Page["Aura" .. i]:SetIcon("Interface\\Icons\\Ability_Hunter_Pet_WindSerpent");
			else
				PowaBrowser.Tabs.Auras.Page["Aura" .. i]:SetIcon("");
			end
		end
		-- Set the title.
		PowaBrowser.Tabs.Auras.Page.Title:SetText(PowaBrowser:GetPageName());
		PowaBrowser.Tabs.Auras.Page.Title:ClearFocus();
	end
	-- Add functions to the browser frame.
	-- Add appropriate items to trees.
	-- (The code here will allow for as many pages of whatever type including class-specific auras, but it likely won't be fully implemented for a while).
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
end

-- And a definition for the item.
PowaAuras.UI["AuraButton"] = {
	Init = function(self, icon)
		-- Set things up.
		self.AuraID = id;
		self:SetIcon(icon or "");
		-- Register clicks.
		self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
		self:RegisterForDrag(true);
		self:SetScript("OnClick", self.OnClick);
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
	SetLinked = function(self, linked)
		self.Linked = linked;
		self:Update();
	end,
	OnClick = function(self, button)
		-- Left or right?
		if(button == "LeftButton") then
			-- Attempt to select this aura.
			PowaBrowser:SetSelectedAura(self.AuraID);
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
		elseif(self.Linked) then
			texture:SetTexCoord(0.0078125, 0.2734375, 0.671875, 0.8046875);
			texture:SetVertexColor(1, 1, 1);
		else
			texture:SetTexCoord(0.0078125, 0.2734375, 0.80859375, 0.94140625);
			texture:SetVertexColor(0.75, 0.325, 0.325);
		end
	end,
};
-- Register.
PowaAuras.UI:DefineWidget("AuraButton");