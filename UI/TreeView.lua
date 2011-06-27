--- UI Widget class definition for TreeViews.
-- @author Test author.
-- @copyright Test copyright tag.
-- @release Test release tag.

-- Create definition.
PowaAuras.UI:Register("TreeView", {
	Scripts = {
		OnSelectedKeyChanged = true, -- Temp.
	},
	Construct = function(class, ui, self, ...)
		-- Add scripts mixin and special scrolly thing to frame.
		ui:ScrollableItemsFrame(self);
		ui:Scripts(self);
		-- Normal ctor.
		return ui.Construct(class, ui, self, ...);
	end,
	Init = function(self)
		-- Store our items in these...
		self.ItemsByOrder = {};
		self.ItemsByKey = {};
		self.SelectedKey = nil;
		-- Initial update! (Fixed the scrollbar).
		self:UpdateItems();
	end,
	AddItem = function(self, key, text, parent, disable)
		-- DO NOT LET KEYS CONFLICT FOR THE LOVE OF GOD PLEASE DO NOT.
		if(self.ItemsByKey[key]) then return; end
		-- Got a parent? If so, find it.
		if(parent) then parent = self:FindItemByKey(parent); end
		if(not parent) then parent = self.ItemsByOrder; end
		-- Let's do it.
		tinsert(parent, { Key = key });
		self.ItemsByKey[key] = PowaAuras.UI:TreeViewItem(self, parent["Key"], key, text);
		-- Disable if needed.
		if(disable) then self:DisableItem(key); else self:EnableItem(key); end
		-- Invalidate item count.
		self.ItemCount = nil;
		-- Update.
		self:UpdateItems();
		return true;
	end,
	ClearItems = function(self)
		-- Go go go.
		for k,_ in pairs(self.ItemsByKey) do
			self:RemoveItem(k);
		end
		self:UpdateItems();
	end,
	CountItems = function(self, parent)
		-- Long count, go.
		local count = 0;
		for k, v in pairs(parent or self.ItemsByOrder) do
			if(k ~= "Key") then
				count = count+1;
				-- Recursively loop...
				count = count+self:CountItems(v);
			end
		end
		-- Done.
		return count;
	end,
	CountShownItems = function(self, parent)
		-- Long count, go.
		local count, key = 0, nil;
		for k, v in pairs(parent or self.ItemsByOrder) do
			-- Get object by key...
			key = self.ItemsByKey[v["Key"]];
			count = count+1;
			-- Recursively loop if we should.
			if(key and key:GetExpanded()) then
				count = count+self:CountItems(v);
			end
		end
		-- Done.
		return count;
	end,
	FindItemByKey = function(self, key, items)
		-- Go go power rangers.
		if(not items) then items = self.ItemsByOrder; end
		local count, item, tmpVal = #(items), nil, nil;
		for i=1,count do
			item = items[i];
			if(item["Key"] == key) then return item; end
			tmpVal = self:FindItemByKey(key, item);
			if(tmpVal) then
				return tmpVal;
			end
		end
		return nil;
	end,
	FindItemIndexByKey = function(self, key, items)
		-- Go go power rangers.
		if(not items) then items = self.ItemsByOrder; end
		local count, item = #(items), nil;
		for i=1,count do
			item = items[i];
			if(item["Key"] == key) then return i; end
		end
		return nil;
	end,
	DisableItem = function(self, key)
		if(self.ItemsByKey[key]) then self.ItemsByKey[key]:Disable(); end
	end,
	EnableItem = function(self, key)
		if(self.ItemsByKey[key]) then self.ItemsByKey[key]:Enable(); end
	end,
	GetItem = function(self, key)
		if(not key or not self.ItemsByKey[key]) then return; end
		return self.ItemsByKey[key];
	end,
	GetSelectedKey = function(self)
		return self.SelectedKey;
	end,
	HasItem = function(self, key)
		return (self.ItemsByKey[key] and true or false);
	end,
	HasTitle = function(self)
		if(not self.Scroll.Child.Title:GetText() or self.Scroll.Child.Title:GetText() == "") then
			return false;
		else
			return true;
		end
	end,
	RemoveItem = function(self, key)
		-- Find the item...
		if(not self.ItemsByKey[key]) then return; end
		local item, index, parentTable = self.ItemsByKey[key], 0, nil;
		-- Find its parents table.
		parentTable = (item:GetParentKey() and self:FindItemByKey(item:GetParentKey()) or self.ItemsByOrder);
		-- Find its index in the parent list.
		index = self:FindItemIndexByKey(key, parentTable);
		-- I need all of these.
		if(not item or not index or not parentTable) then return false; end
		-- Remove all children.
		local count, itemData = nil, self:FindItemByKey(key);
		count = #(itemData);
		if(count > 0) then
			repeat
				self:RemoveItem(itemData[1]["Key"]);
				count = count-1;
			until(count == 0);
		end
		-- Kill the item.
		tremove(parentTable, index);
		self.ItemsByKey[key] = nil;
		item:Recycle();
		-- Change selection if needed.
		if(self.SelectedKey == key) then self:SetSelectedKey(nil); end
		-- Invalidate item count.
		self.ItemCount = nil;
		-- Update.
		self:UpdateItems();
	end,
	SetSelectedKey = function(self, key)
		-- Go go go.
		if(key == nil or (self.ItemsByKey[key] and self.SelectedKey ~= key)) then
			self.SelectedKey = key;
			self:CallScript("OnSelectedKeyChanged", self.SelectedKey);
		end
		-- Update.
		self:UpdateItems();
	end,
	ToggleElementChildren = function(self, key)
		-- Get item.
		local item = self.ItemsByKey[key];
		if(not item) then return; end
		-- Set expand state.
		item:ToggleExpanded();
		-- Update.
		self:UpdateItems();
	end,
	UpdateItems = function(self)
		-- Change scroll boundaries. Invokes an update.
		self:SetScrollRange(0, self:CountShownItems()-floor(self:GetHeight()/24));
	end,
	UpdateScrollList = function(self, parent, level, visible, hidden, parentShowing)
		-- Fix missing params.
		if(not level) then level = 1; end
		if(not parent) then parent = self.ItemsByOrder; end
		if(not visible) then visible = 0; end
		if(not hidden) then hidden = 0; end
		if(not parentShowing and level == 1) then parentShowing = true; end
		-- Show all the items that we can fit.
		local maxVisible, count = floor(self:GetHeight()/24), #(parent);
		for i=1, count do
			-- Get item.
			local key = parent[i];
			local item = self.ItemsByKey[key["Key"]];
			-- Show if we're between the scroll range.
			if(parentShowing and hidden >= self:GetScrollOffset() and visible < maxVisible) then
				-- Increment visible counter.
				visible = visible+1;
				-- Show it.
				item:SetPoint("TOPLEFT", 4, -4-((visible-1)*24));
				item:SetPoint("TOPRIGHT", (self.ScrollBar:IsShown() and -20 or -4), -4-((visible-1)*24));
				item:Show();
				-- Indent text (do NOT indent the entire item, it looks weird).
				item.Text:SetPoint("LEFT", 4+((level-1)*10), 0);
				-- Show or hide expand button.
				if(#(key) > 0) then
					item.Expand:Show();
				else
					item.Expand:Hide();
				end
			else
				-- Hide it.
				item:Hide();
				-- Only increment hidden counter if the parent element was showing.
				hidden = (parentShowing and hidden+1 or hidden);
			end
			-- Selected?
			item:SetSelected((self.SelectedKey == key["Key"]));
			-- Iterate over element children.
			visible, hidden = self:UpdateScrollList(key, level+1, visible, hidden, 
				(parentShowing == true and item:GetExpanded() or false));
		end
		-- Return counters of visible/hidden elements..
		return visible, hidden;
	end,
});

-- And a definition for the item.
PowaAuras.UI:Register("TreeViewItem", {
	Items = {}, -- Stores a list of reusable items.
	Hooks = {
		"Disable",
		"Enable",
	},
	Construct = function(self, ui, ...)
		-- Got any items or not?
		local item = nil;
		if(self.Items[1]) then
			-- Yay!
			item = self.Items[1];
			tremove(self.Items, 1);
			-- Skip to init.
			item:Init(...);
			return item;
		else
			-- Get making.
			item = CreateFrame("Button", nil, nil, "PowaTreeViewItemTemplate");
			-- Reuse existing constructor.
			return ui.Construct(self, _, item, ...);
		end
	end,
	Init = function(self, parentTree, parentKey, key, text)
		-- Set us up!
		self:SetParent(parentTree);
		self:SetKey(key);
		self:SetText(text);
		self:SetParentKey(parentKey);
		self:ToggleExpanded(true);
		self:SetScript("OnClick", self.OnClick);
		self:Show();
	end,
	Disable = function(self)
		self:__Disable();
		self:UpdateFonts();
	end,
	Enable = function(self)
		self:__Enable();
		self:UpdateFonts();
	end,
	GetExpanded = function(self)
		return self.Expanded;
	end,
	GetKey = function(self)
		return self.Key;
	end,
	GetParentKey = function(self)
		return self.ParentKey;
	end,
	OnClick = function(self)
		-- Could be implemented in a nicer way, but meh.
		self:GetParent():SetSelectedKey(self.Key);
		PlaySound("UChatScrollButton");
	end,
	Recycle = function(self)
		-- Place in recycle table!
		tinsert(self.Items, self);
		self:Hide();
	end,
	SetKey = function(self, key)
		self.Key = key;
	end,
	SetParentKey = function(self, key)
		self.ParentKey = key;
		-- Update fonts based on parent key.
		self:UpdateFonts();
	end,
	SetSelected = function(self, selected)
		if(selected) then
			self:SetNormalTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar-Blue");
			self:GetNormalTexture():SetBlendMode("ADD");
			self:SetNormalFontObject((self.ParentKey and PowaFontHighlightSmall or PowaFontHighlight));
			self:SetHighlightTexture(nil);
		else
			self:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar-Blue");
			self:GetHighlightTexture():SetBlendMode("ADD");
			self:SetNormalFontObject((self.ParentKey and PowaFontNormalSmall or PowaFontNormal));
			self:SetNormalTexture(nil);		
		end
	end,
	ToggleExpanded = function(self, force)
		-- Set it.
		if(force) then
			self.Expanded = force;
		else
			self.Expanded = not self.Expanded;
		end
		-- Update imagery.
		if(self.Expanded) then
			self.Expand:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
			self.Expand:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-Down");
			self.Expand:SetDisabledTexture("Interface\\Buttons\\UI-MinusButton-Disabled");
		else
			self.Expand:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
			self.Expand:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-Down");
			self.Expand:SetDisabledTexture("Interface\\Buttons\\UI-PlusButton-Disabled");		
		end
	end,
	UpdateFonts = function(self)
		if(self.ParentKey) then
			self:SetHighlightFontObject(PowaFontHighlightSmall);
			self:SetDisabledFontObject(PowaFontNormalSmall);
		else
			self:SetHighlightFontObject(PowaFontHighlight);
			self:SetDisabledFontObject(PowaFontNormal);
		end	
	end,
});
