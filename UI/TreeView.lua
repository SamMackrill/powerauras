-- Create definition.
PowaAuras.UI["TreeView"] = {
	Init = function(self, title, callback)
	
	end,
	AddItem = function(self, key, text, parent)
	
	end,
	DisableItem = function(self, key)
	end,
	RemoveItem = function(self, key)
	end,
	HasItem = function(self, key)
	end,
	UpdateItems = function(self)	
	end,
};
-- Register.
PowaAuras.UI:DefineWidget("TreeView");

-- And a definition for the item.
PowaAuras.UI["TreeViewItem"] = {
	PreInit = function(self)
		-- Got any items or not?
		if(not self._Items) then self._Items = {}; end
		if(self._Items[1]) then
			-- Yay!
			return self._Items[1]
		end
	end,
	Init = function(self, text)
	
	end,
};
-- Register.
PowaAuras.UI:DefineWidget("TreeViewItem");