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
		-- Add it where needed.
		local pos;
		if(not parent) then pos = #(self.ItemsByOrder)+1; else pos = self.ItemsByKey[parent]:GetPosition()+1; end
		tinsert(self.ItemsByOrder, pos, key);
		-- Was a parent specified?
		local depth = 1;
		if(parent) then depth = self.ItemsByKey[parent]:GetDepth()+1; end
		-- Add the actual data to the itemsbykey table...
		self.ItemsByKey[key] = PowaAuras.UI.TreeViewItem(nil, self.Scroll.Child, pos, text, depth, parent or nil);
		-- Update.
		self:UpdateItems();
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
		local pos = self.ItemsByKey[key]:GetPosition();
		self.ItemsByKey[key] = nil;
		tremove(self.ItemsByOrder, pos);
		-- Update (do this now, if we DO remove anything then it'll be called again).
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
			local item = CreateFrame("Button", nil, UIParent);
			return item;
		end
	end,
	Init = function(self, parent, pos, text, depth, parentKey)
		-- Set us up!
		if(parent and parent.SetItem) then parent:SetItem(self); end
		self:SetText(text);
		self:SetDepth(depth);
		self:SetPosition(pos);
		self.ParentKey = parentKey;
	end,
	GetDepth = function(self)
		return self.Depth;
	end,
	GetPosition = function(self)
		return self.Position;
	end,
	GetText = function(self)
		return self.Text;
	end,
	Recycle = function(self)
		-- Got a parent? If so, make sure we're not in the layout...
		local parent = self:GetParent();
		if(parent and parent.UnsetItem) then parent:UnsetItem(self); end
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
	SetText = function(self, text)
		self.Text = text;
	end,
	_Items = {}, -- Private.
};
-- Register.
PowaAuras.UI:DefineWidget("TreeViewItem");