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
	Init = function(text)
	
	end,
};
-- Register.
PowaAuras.UI:DefineWidget("TreeViewItem");