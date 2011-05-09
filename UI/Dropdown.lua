-- Define basic dropdown control widget.
PowaAuras.UI:Register("Dropdown", {
	Scripts = {
		OnClick = true,
		OnHide = true,
	},
	Init = function(self, setting, closeOnSelect)
		-- If we own a menu, we reference the frame via this.
		self.Menu = nil;
		-- Store our items in this.
		self.Items = {};
		self.CloseOnSelect = (closeOnSelect == nil and false or closeOnSelect);
		-- Selected key for this dropdown.
		self.SelectedKey = nil;
		-- Set the title and tooltip if we can.
		if(self:GetText()) then
			-- Title (optional fontstring element)
			if(self.Title) then
				self.Title:SetText(PowaAuras.Text[self:GetText()]);
			end
			-- Tooltip.
			PowaAuras.UI:Tooltip(self, self:GetText(), (self:GetText() .. "Desc"));
		end
		-- Make sure our text is blank...
		self.Text:SetText(PowaAuras.Text["UI_DropdownNone"]);
		-- Settings mixin please.
		self.OnSettingChanged = function(self, key)
			-- Don't call this if the key is the same.
			if(self.SelectedKey == key) then return; end
			self:SetSelectedKey(key);
		end
		PowaAuras.UI:Settings(self, setting);
	end,
	AddItem = function(self, key, text)
		-- Make sure key is unique.
		for _, data in ipairs(self.Items) do
			if(data.Key == key) then return; end
		end
		-- Add.
		tinsert(self.Items, { Key = key, Value = text });
		-- Fully update the menu if we add/remove any items.
		if(self.Menu) then
			self.Menu:Toggle(false);
			PowaAuras.UI:DropdownList(self, self.OnDropdownMenuShow, self.OnDropdownMenuHide, 
				self.OnDropdownMenuSelected, self.SelectedKey):Toggle();
		end
		-- Done.
		return true;
	end,
	RemoveItem = function(self, key)
		-- Remove.
		for i, data in pairs(self.Items) do
			if(data.Key == key) then
				-- Remove.
				tremove(self.Items, i);
				-- Was this key selected?
				if(key == self.SelectedKey) then
					self:SetSelectedKey(nil);
				end
				-- Fully update the menu if we add/remove any items.
				if(self.Menu) then
					self.Menu:Toggle(false);
					PowaAuras.UI:DropdownList(self, self.OnDropdownMenuShow, self.OnDropdownMenuHide, 
						self.OnDropdownMenuSelected, self.SelectedKey):Toggle();
				end
				-- Done.
				return true;
			end
		end
	end,
	ClearItems = function(self, key)
		for _, data in ipairs(self.Items) do
			-- Remove.
			self:RemoveItem(data.Key);
		end
	end,
	OnClick = function(self)
		-- Request the dropdown menu.
		PowaAuras.UI:DropdownList(self, self.OnDropdownMenuShow, self.OnDropdownMenuHide, self.OnDropdownMenuSelected, 
			self.SelectedKey):Toggle();
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
		self:SetSelectedKey(key);
		-- Close?
		if(self.CloseOnSelect and self.Menu) then
			self.Menu:Toggle(false);
		end			
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
		print("|cFF527FCCDEBUG (Dropdown): |r", self, "key change on menu", dropdown, "(key =", key, ")");	
		-- Update selected key.
		self.SelectedKey = key;
		-- Find key, change text.
		local hasChanged = false;
		for _, data in ipairs(self.Items) do
			if(key and data.Key == key) then
				self.Text:SetText(data.Value);
				hasChanged = true;
				break;
			end
		end
		-- If the text wasn't set, set it as the default.
		if(not key or not hasChanged) then
			self.Text:SetText(PowaAuras.Text["UI_DropdownNone"]);
		end
		-- Save the setting.
		self:SaveSetting(key);
		-- Fire callback.
		self:OnDropdownItemSelected(key);
		-- Force update if we own the dropdown.
		if(self.Menu) then
			self.Menu.SelectedKey = key; -- A bit hackish, but it prevents a loop.
			self.Menu:UpdateItems();
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
		end
		-- Update selected key if given.
		self.SelectedKey = defaultKey or nil;
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
		self:UpdateItems();
		-- Fire update callback.
		self.UpdateCallback(self.Owner, self, key);
	end,
	Show = function(self)
		-- Call show callback first, loop over return values.
		local count = 0;
		for _, data in pairs(self.ShowCallback(self.Owner, self)) do
			-- Get item.
			local item = PowaAuras.UI:DropdownItem(self.Child, self, (count*20), data.Key, data.Value);
			-- Select if needed.
			if(self.SelectedKey and data.Key == self.SelectedKey) then
				item:SetChecked(true);
			else
				item:SetChecked(false);
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
	UpdateItems = function(self)
		for _, item in pairs(self.Items) do
			if(self.SelectedKey and item.Key == self.SelectedKey) then
				item:SetChecked(true);
			else
				item:SetChecked(false);
			end
		end
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