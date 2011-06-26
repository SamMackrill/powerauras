-- Define widget.
PowaAuras.UI:Register("RadioGroup", {
	Init = function(self, class, alwaysSelect)
		-- Add item register.
		self.RadioItems = {};
		self.RadioItemClass = class or "RadioButton";
		self.RadioAlwaysSelect = alwaysSelect;
		self.SelectedRadioKey = nil;
	end,
	CreateRadioItem = function(self, key, ...)
		-- Make sure it doesn't already exist.
		if(self.RadioItems[key]) then return; end
		-- Add frame.
		self.RadioItems[key] = PowaAuras.UI[self.RadioItemClass](PowaAuras.UI, _, self, key, ...);
		-- Update.
		self:UpdateRadioItems();
		-- Return item for manual positioning/sizing.
		return self.RadioItems[key];
	end,
	ClearRadioItems = function(self)
		-- Go over all items, call remove.
		for key, _ in pairs(self.RadioItems) do
			self:RemoveRadioItem(key);
		end
	end,
	GetRadioItem = function(self, key)
		-- Make sure it already exists.
		if(not self.RadioItems[key]) then return; end
		return self.RadioItems[key];
	end,
	GetSelectedRadioKey = function(self)
		return self.SelectedRadioKey;
	end,
	RemoveRadioItem = function(self, key)
		-- Make sure it already exists.
		if(not self.RadioItems[key]) then return; end
		-- Go go go.
		self.RadioItems[key]:Recycle();
		self.RadioItems[key] = nil;
		-- Update.
		self:UpdateRadioItems();
	end,
	OnRadioSelectionChanged = function(self, key)
	end,
	SetSelectedRadioKey = function(self, key)
		-- Make sure it already exists. Allow nil though.
		if(key and not self.RadioItems[key] or key == self.SelectedRadioKey) then return; end
		-- Select it.
		self.SelectedRadioKey = key;
		-- Update.
		self:OnRadioSelectionChanged(key);
		self:UpdateRadioItems();
	end,
	UpdateRadioItems = function(self)
		-- Forcing a selection?
		if(self.RadioAlwaysSelect and not self.SelectedRadioKey) then
			-- Umm, isn't there a cleaner way of getting the first key of a hash?
			for k, v in pairs(self.RadioItems) do
				if(v) then
					self:SetSelectedRadioKey(k);
					return;
				end
			end
		end
		-- Simply change the checked state.
		for _, item in ipairs(self.RadioItems) do
			if(item) then
				if(item.Key == self.SelectedRadioKey) then
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
			-- Skip to init.
			item:Init(...);
			return item;
		else
			-- Get making.
			item = CreateFrame("CheckButton", nil, nil, self.Template);
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
		self:GetParent():SetSelectedRadioKey(self.Key);
		PlaySound("UChatScrollButton");
	end,
	Recycle = function(self)
		-- Place in recycle table!
		tinsert(self.Items, self);
		self:Hide();
	end,
});
