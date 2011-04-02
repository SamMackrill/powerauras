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
			-- Go over the list, find the last element which references the same parent and place it after that.
			-- If no element is found, place after parent.
			pos = self.ItemsByKey[parent]:GetPosition()+1;
			local count = #(self.ItemsByOrder);
			for i=1,count do
				local key = self.ItemsByOrder[i];
				local item = self.ItemsByKey[key];
				if(item.ParentKey and item.ParentKey == parent) then
					pos = item:GetPosition()+1;
				end
			end
		end
		tinsert(self.ItemsByOrder, pos, key);
		-- Was a parent specified?
		local depth = 1;
		if(parent) then depth = self.ItemsByKey[parent]:GetDepth()+1; end
		-- Add the actual data to the itemsbykey table...
		self.ItemsByKey[key] = PowaAuras.UI.TreeViewItem(nil, self, pos, text, depth, parent or nil);
		-- Update.
		self:UpdateItems();
		return true;
	end,
	DisableItem = function(self, key)
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
	end,
	SetTitle = function(self, title)
	end,
	UpdateItems = function(self, items)
		-- Go over items.
		local count = #(self.ItemsByOrder);
		for i=1,count do
			local key = self.ItemsByOrder[i];
			local item = self.ItemsByKey[key];
			-- Make sure stuff is in order!
			item:SetPosition(i);
			-- Set points.
			item:ClearAllPoints();
			item:SetPoint("TOPLEFT", ((item:GetDepth()-1)*10), -((i-1)*23));
		end
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
			local item = CreateFrame("Button", nil, UIParent, "OptionsButtonTemplate");
			return item;
		end
	end,
	Init = function(self, parent, pos, text, depth, parentKey)
		-- Set us up!
		self:SetParent(parent);
		self:SetText(text);
		self:SetDepth(depth);
		self:SetPosition(pos);
		self.ParentKey = parentKey;
		self:ClearAllPoints();
		self:Show();
	end,
	GetDepth = function(self)
		return self.Depth;
	end,
	GetPosition = function(self)
		return self.Position;
	end,
	Recycle = function(self)
		-- Place in recycle table!
		tinsert(PowaAuras.UI.TreeViewItem._Items, self);
		self:ClearAllPoints();
		self:Hide();
	end,
	SetDepth = function(self, depth)
		self.Depth = depth;
	end,
	SetPosition = function(self, pos)
		self.Position = pos;
	end,
	SetSelected = function(self, selected)
		print(selected);
	end,
	SetStyle = function(self, level)
	end,
	_Items = {}, -- Private.
};
-- Register.
PowaAuras.UI:DefineWidget("TreeViewItem");