-- Define basic dropdown control widget.
PowaAuras.UI:Register("Dropdown", {
	Scripts = {
		OnClick = true,
		OnHide = true,
	},
	Init = function(self, setting, defaultKey)
		-- If we own a menu, we reference the frame via this.
		self.Menu = nil;
		-- Store our items in this.
		self.Items = {};
		-- Default/Selected keys for this dropdown.
		self.DefaultKey = defaultKey or nil;
		self.SelectedKey = nil;
		-- Got a setting?
		if(setting) then
			-- Settings mixin please.
			self.OnSettingChanged = function(self, key)
				self:SetSelectedKey(key);
			end
			PowaAuras.UI:Register("Settings", self, setting);
		end
	end,
	AddItem = function(self, key, text, isDefault)
		-- Make sure key doesn't already exist.
		if(self.Items[key]) then return; end
		-- Add.
		self.Items[key] = text;
		-- Default?
		if(isDefault) then
			self.DefaultKey = key;
		end
		-- Force update if we own the dropdown.
		if(self.Menu) then
			self.Menu:Toggle(true);
		end
		-- Done.
		return true;
	end,
	RemoveItem = function(self, key)
		-- Key needs to exist.
		if(not self.Items[key]) then return; end
		-- Remove.
		self.Items[key] = nil;
		-- Was this the default key?
		if(key == self.DefaultKey) then
			self.DefaultKey = nil
		end
		-- Was this key selected?
		if(key == self.SelectedKey) then
			self.SelectedKey = (self.Items[self.DefaultKey] and self.DefaultKey or nil);
		end
		-- Force update if we own the dropdown.
		if(self.Menu) then
			self.Menu:Toggle(true);
		end
		-- Done.
		return true;
	end,
	ClearItems = function(self, key)
		for key, _ in pairs(self.Items) do
			-- Remove.
			self:RemoveItem(key);
		end
	end,
	OnClick = function(self)
		-- Request the dropdown menu.
		PowaAuras.UI:DropdownList(self, self.OnDropdownMenuShow, self.OnDropdownMenuHide, self.OnDropdownMenuSelected, self.SelectedKey):Toggle();
	end,
	OnDropdownMenuShow = function(self, dropdown)
		-- Update state.
		self.Menu = dropdown;
		print("|cFF527FCCDEBUG (Dropdown): |r", self, "owns menu", dropdown);
		-- Return our item list.
		return self.Items;
	end,
	OnDropdownMenuHide = function(self, dropdown)
		-- Update state.
		self.Menu = nil;
		print("|cFF527FCCDEBUG (Dropdown): |r", self, "no longer owns menu", dropdown);
	end,
	OnDropdownMenuSelected = function(self, dropdown, key)
		-- Update selected key.
		print("|cFF527FCCDEBUG (Dropdown): |r", self, "key change on menu", dropdown, "(key =", key, ")");		
		self.SelectedKey = key;
		-- Fire callback.
		self:OnDropdownItemSelected(key);
	end,
	OnDropdownItemSelected = function(self, key)
		-- Override this as you please.
	end,
	OnHide = function(self)
		-- Hide the menu if we own it.
		if(self.Menu) then
			self.Menu:Toggle(false);
		end
	end,
	SetSelectedKey = function(self, key)
		-- Update selected key.
		self.SelectedKey = key;
		-- Fire callback.
		self:OnDropdownItemSelected(key);
		-- Force update if we own the dropdown.
		if(self.Menu) then
			self.Menu:Toggle(true);
		end
	end,
});

-- This widget is the actual list shown by a dropdown. It's separated in case I need to add multilevel support later.
PowaAuras.UI:Register("DropdownList", {
	Menu = nil, -- A single menu list is made and shared among all dropdowns.
	Owner = nil,
	HideCallback = nil,
	ShowCallback = nil,
	UpdateCallback = nil,
	SelectedKey = nil,
	Items = {}, -- Active DropdownItem list.
	OnToggleShow = true,
	Hooks = {
		"Hide",
		"Show",
	},
	Construct = function(class, ui, ...)
		if(not class.Menu) then
			-- Make the list frame.
			local frame = CreateFrame("Frame", nil, UIParent, "PowaBorderedFrameTemplate");
			-- Some other things need setting up too.
			frame:SetFrameStrata("FULLSCREEN_DIALOG");
			frame:SetToplevel(true);
			frame:SetClampedToScreen(true);
			frame:SetBackdropColor(0, 0, 0, 1);
			-- Add a scrollframe...
			frame.Scroll = CreateFrame("ScrollFrame", nil, frame, "PowaScrollFrameTemplate");
			frame.Scroll:SetPoint("TOPLEFT", 4, -4);
			frame.Scroll:SetPoint("BOTTOMRIGHT", -4, 4);
			-- Add a child frame to the scrollframe.
			frame.Child = CreateFrame("Frame", nil, frame.Scroll);
			frame.Child:SetPoint("TOPLEFT", 0, 0);
			frame.Scroll:SetScrollChild(frame.Child);
			-- Register as scrollframe widget.
			ui:ScrollFrame(frame.Scroll);
			-- Construct as normal.
			class.Menu = ui.Construct(class, ui, frame, ...);
		else
			-- Go to Init. Do not pass Go. Do not collect £200.
			class.Menu:Init(...);
		end
		-- Return ourself.
		return class.Menu;
	end,
	Init = function(self, owner, showCallback, hideCallback, updateCallback, defaultKey)
		-- Reset toggle status if the owner has changed.
		if(self.Owner ~= owner and self.Owner) then
			self.OnToggleShow = true;
			self:Hide();
			-- Update selected key if given.
			self.SelectedKey = defaultKey or nil;
		end
		-- Update owner.
		self.Owner = owner;
		self.HideCallback = hideCallback;
		self.ShowCallback = showCallback;
		self.UpdateCallback = updateCallback;
		-- Return list.
		return self;
	end,
	Hide = function(self)
		-- Call Hide callback.
		if(self.HideCallback) then
			self.HideCallback(self.Owner, self);
		end
		-- Clear parent, points and so on.
		self:ClearAllPoints();
		self:SetParent(UIParent);
		-- Recycle all items, then clear the table.
		for _, item in ipairs(self.Items) do
			item:Recycle();
		end
		wipe(self.Items);
		-- Hide.
		self:__Hide();
	end,
	SetSelectedKey = function(self, key)
		-- Update selected key and items.
		self.SelectedKey = key;
		for k, v in pairs(self.Items) do
			if(k == key) then
				v:SetChecked(true);
			else
				v:SetChecked(false);
			end
		end
		-- Fire update callback.
		self.UpdateCallback(self.Owner, self, key);
	end,
	Show = function(self)
		-- Call show callback first, loop over return values.
		local count = 0;
		for k, v in pairs(self.ShowCallback(self.Owner, self)) do
			-- Get item.
			local item = PowaAuras.UI:DropdownItem(self.Child, self, (count*20), k, v);
			-- Select if needed.
			if(self.SelectedKey and k == self.SelectedKey) then
				item:SetChecked(true);
			end
			-- Insert into storage.
			tinsert(self.Items, item);
			-- Increment counter.
			count = count+1;
		end
		print("|cFF527FCCDEBUG (DropdownList): |rShowing", count, "items.");
		-- Size/position.
		self:SetParent(self.Owner);
		self:SetPoint("TOPLEFT", self.Owner, "BOTTOMLEFT", 0, 0);
		self:SetPoint("TOPRIGHT", self.Owner, "BOTTOMRIGHT", 0, 0);
		self:SetHeight(math.min(168, 8+(count*20)));
		self.Child:SetSize(168, (count*20)-1);
		-- Show.
		self:__Show();
	end,
	Toggle = function(self, force)
		-- Forcing?
		if(force ~= nil) then
			self.OnToggleShow = force;
		end
		-- Show or hide?
		if(self.OnToggleShow) then
			self:Show();
		else
			self:Hide();
		end
		-- Invert state.
		self.OnToggleShow = not self.OnToggleShow;
	end,
});

-- Dropdown items are recycled.
PowaAuras.UI:Register("DropdownItem", {
	Items = {}, -- Recyclable items.
	Scripts = {
		OnClick = true,
	},
	Construct = function(class, ui, parent, ...)
		-- Got any items left over or do we need to make some?
		local item = class.Items[1];
		if(not item) then
			-- Make one.
			item = CreateFrame("CheckButton", nil, parent, "PowaDropdownItemTemplate");
			-- Normal ctor.
			item = ui.Construct(class, ui, item, parent, ...);
			print("|cFF527FCCDEBUG (DropdownItem): |rCreated item.");
		else
			-- Init.
			tremove(class.Items, 1);
			item:Init(parent, ...);
			print("|cFF527FCCDEBUG (DropdownItem): |rReusing item,", #(class.Items) , "remaining.");
		end
		-- Done.
		return item;
	end,
	Init = function(self, parent, menu, offsetY, key, text)
		self:SetParent(parent);
		self:SetPoint("TOPLEFT", 0, -offsetY);
		self:SetPoint("TOPRIGHT", 0, -offsetY);
		self.Value:SetText(text);
		self.Key = key;
		self.Menu = menu;
		self:Show();
	end,
	OnClick = function(self)
		-- Update selection status.
		self.Menu:SetSelectedKey(self.Key);
	end,
	Recycle = function(self)
		-- Clear points/parent, done.
		self:ClearAllPoints(self);
		self:SetParent(UIParent);
		self:SetChecked(false);
		self:Hide();
		-- Add to list.
		tinsert(PowaAuras.UI.DropdownItem.Items, self);
		print("|cFF527FCCDEBUG (DropdownItem): |rRecycled item,", #(PowaAuras.UI.DropdownItem.Items) , "available.");
	end,
});