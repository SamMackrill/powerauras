-- UI upvalue.
local UI = PowaAuras.UI;
-- Dropdown widget base.
UI:Register("DropdownBase", {
	Scripts = {
		OnClick = true,
		OnDropdownMenuHide = true,
		OnDropdownMenuPosition = true,
		OnDropdownMenuItemSelected = true,
		OnDropdownMenuShow = true,
		OnHide = true,
	},
	Init = function(self, closeOnSelect)
		-- If we own a menu, we reference the frame via this.
		self.Menu = nil;
		-- Store our items in this.
		self.Items = {};
		self.CloseOnSelect = (closeOnSelect == nil and true or closeOnSelect);
		-- Selected key for this dropdown.
		self.SelectedKey = nil;
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
			UI:DropdownList(self, self.SelectedKey):Toggle(true);
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
					UI:DropdownList(self, self.SelectedKey):Toggle(true);
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
	UpdateItem = function(self, key, text)
		-- Update.
		for i, data in pairs(self.Items) do
			if(data.Key == key) then
				-- Update.
				self.Items[i].Value = text;
				-- Fully update the menu if we changed anything.
				if(self.Menu) then
					self.Menu:Toggle(false);
					UI:DropdownList(self, self.SelectedKey):Toggle(true);
				end
				-- Done.
				return true;
			end
		end	
	end,
	GetItems = function(self)
		return self.Items;
	end,
	OnClick = function(self)
		-- Request the dropdown menu.
		UI:DropdownList(self, self.SelectedKey):Toggle();
		PlaySound("UChatScrollButton");
	end,
	OnDropdownMenuHide = function(self, dropdown)
		-- Update state.
		self.Menu = nil;
		print("|cFF527FCCDEBUG (Dropdown): |r", self, "no longer owns menu", dropdown);
	end,
	OnDropdownMenuPosition = function(self, dropdown, count)
		-- Update the sizing/positioning of the dropdown.
		dropdown:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, 0);
		dropdown:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, 0);
		dropdown:SetHeight(math.min(168, 8+(count*20)));
		dropdown.Child:SetSize(168, (count*20)-1);
	end,
	OnDropdownMenuItemSelected = function(self, dropdown, key)
		-- Update selected key.	
		self:SetSelectedKey(key);
		-- Close?
		if(self.CloseOnSelect and self.Menu) then
			self.Menu:Toggle(false);
		end			
	end,
	OnDropdownMenuShow = function(self, dropdown)
		-- Update state.
		self.Menu = dropdown;
		print("|cFF527FCCDEBUG (Dropdown): |r", self, "owns menu", dropdown);
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
		-- Fire callback.
		self:CallScript("OnDropdownItemSelected", key);
		-- Force update if we own the dropdown.
		if(self.Menu) then
			self.Menu.SelectedKey = key; -- A bit hackish, but it prevents a loop.
			self.Menu:UpdateItems();
		end
	end,
});

-- Define basic dropdown control widget.
UI:Register("Dropdown", {
	Base = "DropdownBase",
	Scripts = {
		OnSettingChanged = true,
	},
	Init = function(self, setting, closeOnSelect)
		-- Call parent init func.
		UI.DropdownBase.Init(self, closeOnSelect);
		-- Set the title and tooltip if we can.
		if(self:GetText()) then
			-- Title (optional fontstring element)
			if(self.Title) then
				self.Title:SetText(PowaAuras.Text[self:GetText()]);
			end
			-- Tooltip.
			UI:Tooltip(self, self:GetText(), (self:GetText() .. "Desc"));
		end
		-- Make sure our text is blank...
		self.Text:SetText(PowaAuras.Text["UI_DropdownNone"]);
		-- Settings mixin please.
		UI:Settings(self, setting);
	end,
	OnSettingChanged = function(self, key)
		-- Don't call this if the key is the same.
		if(self.SelectedKey == key) then return; end
		self:SetSelectedKey(key);
	end,
	SetSelectedKey = function(self, key)
		-- Call parent func.
		UI.DropdownBase.SetSelectedKey(self, key);
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
	end,
});

-- Not to be confused with DropdownList, this makes the list behave as a menu and disables selecting of elements.
UI:Register("DropdownMenu", {
	Base = "DropdownBase",
	Init = function(self, closeOnSelect)
		-- Call parent init func.
		UI.DropdownBase.Init(self, closeOnSelect);
		-- Set the title and tooltip if we can.
		if(self:GetText()) then
			-- Tooltip.
			UI:Tooltip(self, self:GetText(), (self:GetText() .. "Desc"));
		end
	end,
	SetSelectedKey = function(self, key)
		print("|cFF527FCCDEBUG (Dropdown): |r", self, "key change on menu", dropdown, "(key =", key, ")");	
		-- Selected key is always nil.
		self.SelectedKey = nil;
		-- Fire callback, pass the key so we know what was clicked.
		self:CallScript("OnDropdownItemSelected", key);
		-- Force update if we own the dropdown.
		if(self.Menu) then
			self.Menu.SelectedKey = nil; -- A bit hackish, but it prevents a loop.
			self.Menu:UpdateItems();
		end
	end,
});

-- This widget is the actual list shown by a dropdown. It's separated in case I need to add multilevel support later.
UI:Register("DropdownList", {
	Menu = nil, -- A single menu list is made and shared among all dropdowns.
	Owner = nil,
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
	Init = function(self, owner, defaultKey)
		-- Reset toggle status if the owner has changed.
		if(self.Owner ~= owner and self.Owner) then
			self.OnToggleShow = true;
			self:Hide();
		end
		-- Update selected key if given.
		self.SelectedKey = defaultKey or nil;
		-- Update owner.
		self.Owner = owner;
		-- Return list.
		return self;
	end,
	Hide = function(self)
		-- Call Hide callback.
		self.Owner:CallScript("OnDropdownMenuHide", self);
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
		self.Owner:CallScript("OnDropdownMenuItemSelected", self, key);
	end,
	Show = function(self)
		-- Call Show callback.
		self.Owner:CallScript("OnDropdownMenuShow", self);
		-- Get the items the dropdown has.
		local count = 0;
		for _, data in pairs(self.Owner:GetItems()) do
			-- Get item.
			local item = UI:DropdownItem(self.Child, self, (count*20), data.Key, data.Value);
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
		-- Position dropdown.
		self:SetParent(self.Owner);
		self.Owner:CallScript("OnDropdownMenuPosition", self, count);
		print("|cFF527FCCDEBUG (DropdownList): |rShowing", count, "items.");
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
UI:Register("DropdownItem", {
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
		PlaySound("UChatScrollButton");
	end,
	Recycle = function(self)
		-- Clear points/parent, done.
		self:ClearAllPoints(self);
		self:SetParent(UIParent);
		self:SetChecked(false);
		self:Hide();
		-- Add to list.
		tinsert(UI.DropdownItem.Items, self);
		print("|cFF527FCCDEBUG (DropdownItem): |rRecycled item,", #(UI.DropdownItem.Items) , "available.");
	end,
});