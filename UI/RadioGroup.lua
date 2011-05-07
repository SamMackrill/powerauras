-- Define widget.
PowaAuras.UI:Register("RadioGroup", {
	Init = function(self, class, alwaysSelect)
		-- Add item register.
		self.Items = {};
		self.ItemClass = class or "RadioButton";
		self.AlwaysSelect = alwaysSelect;
		self.SelectedKey = nil;
	end,
	AddItem = function(self, key, ...)
		-- Make sure it doesn't already exist.
		if(self.Items[key]) then return; end
		-- Add frame.
		self.Items[key] = PowaAuras.UI[self.ItemClass](PowaAuras.UI, _, self, key, ...);
		-- Update.
		self:UpdateItems();
		-- Return item for manual positioning/sizing.
		return self.Items[key];
	end,
	ClearItems = function(self)
		-- Go over all items, call remove.
		for key, _ in pairs(self.Items) do
			self:RemoveItem(key);
		end
	end,
	GetItem = function(self, key)
		-- Make sure it already exists.
		if(not self.Items[key]) then return; end
		return self.Items[key];
	end,
	RemoveItem = function(self, key)
		-- Make sure it already exists.
		if(not self.Items[key]) then return; end
		-- Go go go.
		self.Items[key]:Recycle();
		self.Items[key] = nil;
		-- Update.
		self:UpdateItems();
	end,
	OnSelectionChanged = function(self, key)
	end,
	SelectItem = function(self, key)
		-- Make sure it already exists. Allow nil though.
		if(key and not self.Items[key] or key == self.SelectedKey) then return; end
		-- Select it.
		self.SelectedKey = key;
		-- Update.
		self:OnSelectionChanged(key);
		self:UpdateItems();
	end,
	UpdateItems = function(self)
		-- Forcing a selection?
		if(self.AlwaysSelect and not self.SelectedKey) then
			-- Umm, isn't there a cleaner way of getting the first key of a hash?
			for k, v in pairs(self.Items) do
				if(v) then
					self:SelectItem(k);
					return;
				end
			end
		end
		-- Simply change the checked state.
		for _, item in ipairs(self.Items) do
			if(item) then
				if(item.Key == self.SelectedKey) then
					item:SetChecked(true);
				else
					item:SetChecked(false);
				end
			end
		end
	end,
});

-- Any extensions to this should inherit this via the Base field and change the Template field.
PowaAuras.UI:Register("RadioButton", {
	Template = "PowaRadioButtonTemplate",
	Items = {}, -- Shared pool of reusable buttons.
	Scripts = {
		OnClick = true,
	},
	Construct = function(self, ui, item, ...)
		-- Got any items or not?
		local item = nil;
		if(self.Items[1]) then
			-- Yay!
			item = self.Items[1];
			tremove(self.Items, 1);
			print("|cFF527FCCDEBUG (RadioButton): |rRecycled item! Total available: " .. #(self.Items));
			-- Skip to init.
			item:Init(...);
			return item;
		else
			-- Get making.
			item = CreateFrame("CheckButton", nil, nil, self.Template);
			print("|cFF527FCCDEBUG (RadioButton): |rCreating item!");
			-- Reuse existing constructor.
			return ui.Construct(self, _, item, ...);
		end
	end,
	Init = function(self, parent, key)
		-- Set us up!
		self:SetParent(parent);
		self.Key = key;
		self.Selected = false;
		self:SetChecked(false);
		self:Show();
	end,
	OnClick = function(self)
		-- Select this key.
		self:GetParent():SelectItem(self.Key);
		PlaySound("UChatScrollButton");
	end,
	Recycle = function(self)
		-- Place in recycle table!
		tinsert(self.Items, self);
		print("|cFF527FCCDEBUG (RadioButton): |rRecycling item! Total available: " .. #(self.Items));
		self:Hide();
	end,
});