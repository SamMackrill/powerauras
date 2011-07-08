-- UI upvalue.
local UI = PowaAuras.UI;
--- Base Dropdown widget definition, handles all of the core dropdown code but does not interact with any frames.
-- @name PowaAuras.UI.DropdownBase
-- @class table
UI:Register("DropdownBase", {
	SelectionEnabled = true,
	Scripts = {
		OnClick = true,
		OnDropdownMenuPosition = true,
		OnHide = true,
	},
	Init = function(self, closeOnSelect, title)
		-- Gain access to the menu.
		self.Menu = UI:DropdownList();
		-- Store our items in this.
		self.Items = {};
		self.CloseOnSelect = (closeOnSelect == nil and true or closeOnSelect);
		-- Selected key for this dropdown.
		self.SelectedKey = nil;
		-- Set the title and tooltip if we can.
		if(title or self:GetText()) then
			-- Title (optional fontstring element)
			if(self.Title) then
				self.Title:SetText(PowaAuras.Text[title or self:GetText()]);
			end
			-- Tooltip.
			UI:Tooltip(self, (title or self:GetText()), ((title or self:GetText()) .. "Desc"));
		end
	end,
	AddItem = function(self, key, text, tooltip)
		-- Make sure key is unique.
		for _, data in ipairs(self.Items) do
			if(data.Key == key) then return; end
		end
		-- Add.
		tinsert(self.Items, { Key = key, Value = text, Tooltip = tooltip });
		-- Fully update the menu if we add/remove any items.
		if(self.Menu:IsOwned(self)) then
			self.Menu:UpdateItems();
		end
		-- Done.
		return true;
	end,
	ClearItems = function(self, key)
		for _, data in ipairs(self.Items) do
			-- Remove.
			self:RemoveItem(data.Key);
		end
	end,
	GetItems = function(self)
		return self.Items;
	end,
	GetSelectedKey = function(self)
		return self.SelectedKey;
	end,
	IsSelectionEnabled = function(self)
		return self.SelectionEnabled;
	end,
	OnClick = function(self)
		-- Request the dropdown menu.
		self.Menu:Toggle(self);
		PlaySound("UChatScrollButton");
	end,
	OnDropdownMenuPosition = function(self)
		-- Update the sizing/positioning of the dropdown.
		self.Menu:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, 0);
		self.Menu:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, 0);
	end,
	OnHide = function(self)
		-- Hide the menu if we own it.
		if(self.Menu:IsOwned(self)) then
			self.Menu:Hide(self);
		end
	end,
	RemoveItem = function(self, key)
		-- Remove.
		for i, data in pairs(self.Items) do
			if(data.Key == key) then
				-- Remove.
				tremove(self.Items, i);
				-- Was this key selected?
				if(key == self:GetSelectedKey()) then
					self:SetSelectedKey(nil);
				end
				-- Fully update the menu if we add/remove any items.
				if(self.Menu:IsOwned(self)) then
					self.Menu:UpdateItems();
				end
				-- Done.
				return true;
			end
		end
	end,
	SetSelectedKey = function(self, key)
		-- Set key.
		self.SelectedKey = key;
		-- Fire callback.
		self:CallScript("OnDropdownItemSelected", key);
		-- Close?
		if(self.CloseOnSelect and self.Menu:IsOwned(self)) then
			self.Menu:Hide(self);
		elseif(self.Menu:IsOwned(self)) then
			-- Update menu.
			self.Menu:UpdateItems();
		end
	end,
	SortCallback = function(a, b)
		return (a.Value < b.Value);
	end,
	SortItems = function(self, callback)
		-- Sort the items out.
		sort(self.Items, callback or self.SortCallback);
		-- Fully update the menu.
		if(self.Menu:IsOwned(self)) then
			self.Menu:UpdateItems();
		end
	end,
	UpdateItem = function(self, key, text, tooltip)
		-- Update.
		for i, data in pairs(self.Items) do
			if(data.Key == key) then
				-- Update.
				self.Items[i].Value = text;
				self.Items[i].Tooltip = tooltip;
				-- Fully update the menu if we changed anything.
				if(self.Menu:IsOwned(self)) then
					self.Menu:UpdateItems();
				end
				-- Done.
				return true;
			end
		end	
	end,
});

-- Dropdown with text displays.
UI:Register("LabelledDropdown", {
	Base = "DropdownBase",
	Init = function(self, closeOnSelect, title)
		-- Normal function.
		UI.DropdownBase.Init(self, closeOnSelect, title);
		-- Update.
		self:UpdateText(key);
	end,
	SetSelectedKey = function(self, key)
		-- Normal function.
		UI.DropdownBase.SetSelectedKey(self, key);
		-- Update.
		self:UpdateText(key);
	end,
	UpdateText = function(self, key)
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
	end,
});

-- Define basic dropdown control widget.
UI:Register("Dropdown", {
	Base = "LabelledDropdown",
	Scripts = {
		OnSettingChanged = true,
	},
	Init = function(self, setting, closeOnSelect, title)
		-- Call parent init func.
		UI.LabelledDropdown.Init(self, closeOnSelect, title);
		-- Make sure our text is blank...
		self.Text:SetText(PowaAuras.Text["UI_DropdownNone"]);
		-- Settings mixin please.
		UI:Settings(self, setting);
	end,
	GetTitle = function(self)
		if(self.Title) then
			return self.Title:GetText();
		end
	end,
	GetSelectedKey = function(self)
		return self:GetSetting();
	end,
	OnSettingChanged = function(self, key)
		-- Update lists and whatnot.
		self:UpdateText(key);
		self:CallScript("OnDropdownItemSelected", key);
		-- Close?
		if(self.CloseOnSelect and self.Menu:IsOwned(self)) then
			self.Menu:Hide(self);
		elseif(self.Menu:IsOwned(self)) then
			-- Update menu.
			self.Menu:UpdateItems();
		end
	end,
	SetSelectedKey = function(self, key)
		-- Set the setting!
		self:SaveSetting(key);
	end,
	SetTitle = function(self, title)
		if(self.Title) then
			self.Title:SetText(title);
		end
	end,
});

-- Not to be confused with DropdownList, this makes the list behave as a menu and disables selecting of elements.
UI:Register("DropdownMenu", {
	Base = "DropdownBase",
	SelectionEnabled = false,
	SetSelectedKey = function(self, key)
		-- Set key to nil.
		self.SelectedKey = nil;
		-- Fire callback.
		self:CallScript("OnDropdownItemSelected", key);
		-- Close?
		if(self.CloseOnSelect and self.Menu:IsOwned(self)) then
			self.Menu:Hide(self);
		elseif(self.Menu:IsOwned(self)) then
			-- Update menu.
			self.Menu:UpdateItems();
		end
	end,
});

-- This widget is the actual list shown by a dropdown. It's separated in case I need to add multilevel support later.
UI:Register("DropdownList", {
	Menu = nil, -- A single menu list is made and shared among all dropdowns.
	Owner = nil,
	Items = {}, -- Active DropdownItem list.
	Hooks = {
		"Hide",
		"Show",
		"SetFrameStrata",
	},
	Construct = function(class, ui)
		if(not class.Menu) then
			-- Make the list frame.
			local frame = CreateFrame("Frame", nil, UIParent, "PowaBorderedFrameTemplate");
			-- Some other things need setting up too.
			frame:SetFrameStrata("DIALOG");
			frame:SetToplevel(true);
			frame:SetClampedToScreen(true);
			frame:SetBackdropColor(0, 0, 0, 1);
			-- Register as scrollable.
			ui:ScrollableItemsFrame(frame);
			-- Construct as normal.
			class.Menu = ui.Construct(class, ui, frame);
		end
		-- Return ourself.
		return class.Menu;
	end,
	Hide = function(self, owner)
		-- Only hide if the owner matches.
		if(self.Owner and self.Owner ~= owner) then return; end
		-- Remove owner.
		local callOwner = self.Owner;
		self.Owner = nil;
		-- Recycle items.
		self:UpdateItems();
		-- Clear parent, points and so on.
		self:ClearAllPoints();
		self:SetParent(UIParent);
		-- Hide.
		self:__Hide();
		-- Call Hide callback.
		if(callOwner) then
			callOwner:CallScript("OnDropdownMenuHide");
		end
	end,
	IsOwned = function(self, owner)
		return (self.Owner == owner);
	end,
	SetFrameStrata = function(self)
		-- Force DIALOG strata.
		self:__SetFrameStrata("DIALOG");
	end,
	Show = function(self, owner)
		-- If owner has changed, tell them to GTFO.
		if(self.Owner and self.Owner ~= owner) then
			self:Hide(self.Owner);
		end
		-- Update owner/key.
		self.Owner = owner;
		-- Update items.
		self:UpdateItems();
		-- Show.
		self:__Show();
		-- Call Show callback.
		self.Owner:CallScript("OnDropdownMenuShow");
	end,
	Toggle = function(self, owner)
		-- Show or hide?
		if(not self:IsOwned(owner) or not self:IsShown()) then
			self:Show(owner);
		else
			self:Hide(owner);
		end
	end,
	UpdateItems = function(self)
		-- Fix the scroll range, this will in turn invoke an update.
		local max = (self.Owner and #(self.Owner:GetItems()) or 0);
		-- Manually set scroll offset to the position of the selected item.
		for i=1, max do
			if(self.Owner:GetItems()[i].Key == self.Owner:GetSelectedKey()) then
				self.ScrollOffset = i-1;
				break;
			end
		end
		-- Set the top limit to max-8, which compensates for the height of the dropdown (8 items max onscreen).
		self:SetScrollRange(0, max-8);
	end,
	UpdateScrollList = function(self)
		-- Recycle all items, then clear the table.
		for _, item in ipairs(self.Items) do
			item:Recycle();
		end
		wipe(self.Items);
		-- Make sure we have an owner before continuing.
		if(not self.Owner) then return; end
		-- Get items.
		local items, count = self.Owner:GetItems(), 0;
		-- Add child items.
		for i=self.ScrollOffset+1, self.ScrollOffset+8 do
			-- Get item data.
			local data = items[i];
			if(not data) then break; end
			-- Get item.
			local item = UI:DropdownItem(self, 4+(count*20), data.Key, data.Value, data.Tooltip);
			-- Select if needed.
			if(self.Owner:IsSelectionEnabled() and self.Owner:GetSelectedKey() == data.Key) then
				item:SetChecked(true);
			else
				item:SetChecked(false);
			end
			-- Insert into storage.
			tinsert(self.Items, item);
			-- Increment count.
			count=count+1;
		end
		-- Size it.
		self:SetSize(168, math.min(168, 8+(count*20)));
		-- Position dropdown.
		self:SetParent(self.Owner);
		self:SetFrameStrata();
		self.Owner:CallScript("OnDropdownMenuPosition");
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
			-- Implements a tooltip.
			ui:Tooltip(item);
			-- Normal ctor.
			item = ui.Construct(class, ui, item, parent, ...);
		else
			-- Init.
			tremove(class.Items, 1);
			item:Init(parent, ...);
		end
		-- Done.
		return item;
	end,
	Init = function(self, menu, offsetY, key, text, tooltip)
		self:SetParent(menu);
		self:ClearAllPoints();
		self:SetPoint("TOPLEFT", 0, -offsetY);
		self:SetPoint("TOPRIGHT", (menu.ScrollBar:IsShown() and -20 or 0), -offsetY);
		self.Value:SetText(text);
		self.Key = key;
		self.Menu = menu;
		if(tooltip) then
			self.TooltipText = tooltip;
			self.TooltipTitle = text;
		else
			self.TooltipText = nil;
			self.TooltipTitle = nil;
		end
		self:Show();
	end,
	OnClick = function(self)
		-- Update selection status.
		self:SetChecked(false);
		self.Menu.Owner:SetSelectedKey(self.Key);
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
	end,
});
