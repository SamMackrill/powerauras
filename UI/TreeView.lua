-- Create definition.
PowaAuras.UI["TreeView"] = {
	Init = function(self, title, callback)
		-- Store our items in these...
		self.ItemsByOrder = {};
		self.ItemsByKey = {};
		self.SelectedKey = nil;
		self.SelectedIndex = nil;
		-- Set ze title.
		self:SetTitle(title);
	end,
	AddItem = function(self, key, text, parent)
		-- Prevent duplicate keys.
		if(self.ItemsByKey[key]) then return false; end
		-- Add it where needed.
		local pos;
		if(not parent) then
			-- Append to end.
			pos = #(self.ItemsByOrder)+1;
		elseif(parent) then
			-- Figure out a position...
			pos = self.ItemsByKey[parent]:GetPosition()+1;
			local depth, item = self.ItemsByKey[parent]:GetDepth(), nil;
			repeat
				item = self.ItemsByKey[self.ItemsByOrder[pos]];
				pos = pos+1;
			until(not item or depth > item:GetDepth())
			pos = pos-1;
		end
		tinsert(self.ItemsByOrder, pos, key);
		-- Was a parent specified?
		local depth = 1;
		if(parent) then
			depth = self.ItemsByKey[parent]:GetDepth()+1;
		end
		-- Add the actual data to the itemsbykey table...
		self.ItemsByKey[key] = PowaAuras.UI.TreeViewItem(nil, self, pos, text, depth, parent or nil);
		-- Update.
		self:UpdateItems();
		return true;
	end,
	DisableItem = function(self, key)
		if(self.ItemsByKey[key]) then self.ItemsByKey[key]:Disable(); end
	end,
	EnableItem = function(self, key)
		if(self.ItemsByKey[key]) then self.ItemsByKey[key]:Enable(); end
	end,
	GetSelectedIndex = function(self)
		return self.SelectedIndex;
	end,
	GetSelectedKey = function(self)
		return self.SelectedKey;
	end,
	HasItem = function(self, key)
		return (self.ItemsByKey[key] and true or false);
	end,
	RemoveItem = function(self, key)
		-- Remove item...
		local item = self.ItemsByKey[key];
		local pos = item:GetPosition();
		-- Recycle it.
		item:Recycle();
		self.ItemsByKey[key] = nil;
		tremove(self.ItemsByOrder, pos);
		-- Update (do this now, if we DO remove anything then it'll be called again, so no bugs be occurrin' mon!).
		self:UpdateItems();
		-- Find anything which referenced this one.
		for childKey, data in pairs(self.ItemsByKey) do
			-- And delete it.
			if(childKey ~= key and data.ParentKey and data.ParentKey == key) then
				self:RemoveItem(childKey);
			end
		end
		-- Was this item selected? Well deselect it.
		if(self.SelectedKey == key) then self:SetSelectedIndex(0); end
	end,
	OnSelectionChange = function(self, key) -- All TreeViews should override this func.
		print("Selection changed: " .. (key or "nil"));
	end,
	SetSelectedIndex = function(self, index)
		-- Go go go.
		if(self.ItemsByOrder[index] and self.SelectedIndex ~= index) then
			self.SelectedIndex = index;
			self.SelectedKey = self.ItemsByOrder[index];
			self:OnSelectionChange(self.SelectedKey);
		elseif((index == 1 and self.SelectedIndex ~= index) or index == 0) then
			-- No items at all!
			self.SelectedIndex = 0;
			self.SelectedKey = nil;
			self:OnSelectionChange(nil);			
		end
	end,
	SetSelectedKey = function(self, key)
		-- Go go go.
		if(self.ItemsByKey[key] and self.SelectedKey ~= key) then
			self.SelectedIndex = self.ItemsByKey[key]:GetPosition();
			self.SelectedKey = key;
			self:OnSelectionChange(self.SelectedKey);
		end
	end,
	SetTitle = function(self, title)
		self.Scroll.Child.Title:SetText(title);
	end,
	UpdateItems = function(self, items)
		-- Go over items.
		local count = #(self.ItemsByOrder);
		for i=1,count do
			local key = self.ItemsByOrder[i];
			local item = self.ItemsByKey[key];
			local parent = item.ParentKey and self.ItemsByKey[item.ParentKey] or nil;
			-- Make sure stuff is in order!
			item:SetPosition(i);
			-- Set points.
			item:ClearAllPoints();
			item:SetPoint("TOPLEFT", ((item:GetDepth()-1)*10), -4-(i*23));
			item:SetPoint("TOPRIGHT", 0, -4-(i*23));
			-- Hide expand button unless told otherwise.
			item.Expand:Hide();
			-- Show parent one though (see what I'm doing there?)
			if(parent) then parent.Expand:Show(); end
		end
		-- Update scrollchild height.
		self.Scroll.Child:SetHeight(27+count*23);
	end,
};
-- Register.
PowaAuras.UI:DefineWidget("TreeView");

-- And a definition for the item.
PowaAuras.UI["TreeViewItem"] = {
	PreInit = function(self)
		-- Got any items or not?
		if(self._Items[1]) then
			-- Yay!
			local item = self._Items[1];
			tremove(self._Items, 1);
			return item;
		else
			-- Get making.
			local item = CreateFrame("Button", nil, nil, "PowaTreeViewItemTemplate");
			return item;
		end
	end,
	Init = function(self, parent, pos, text, depth, parentKey)
		-- Set us up!
		self:SetParent(parent.Scroll.Child);
		self:SetText(text);
		self:SetDepth(depth);
		self:SetPosition(pos);
		self.ParentKey = parentKey;
		self:Show();
		self:SetScript("OnClick", self.OnClick);
	end,
	GetDepth = function(self)
		return self.Depth;
	end,
	GetPosition = function(self)
		return self.Position;
	end,
	OnClick = function(self)
		-- I know it looks ugly, the parent is the scrollchild so we need to work our way up...
		self:GetParent():GetParent():GetParent():SetSelectedIndex(self.Position);
	end,
	Recycle = function(self)
		-- Place in recycle table!
		tinsert(PowaAuras.UI.TreeViewItem._Items, self);
		self:Hide();
	end,
	SetDepth = function(self, depth)
		self.Depth = depth;
	end,
	SetPosition = function(self, pos)
		self.Position = pos;
	end,
	_Items = {}, -- Private.
};
-- Register.
PowaAuras.UI:DefineWidget("TreeViewItem");