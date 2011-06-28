-- Generic tab frame mixin.
PowaAuras.UI:Register("TabFrame", {
	Init = function(self, class)
		-- Store the name of the tab class we're using.
		self.TabClass = class;
		self.SelectedTab = 1;
		-- And our tabs in here.
		self.Tabs = {};
		-- Scripts mixin.
		PowaAuras.UI:Scripts(self);
	end,
	AddTab = function(self, frame, ...)
		-- Create the tab.
		tinsert(self.Tabs, PowaAuras.UI[self.TabClass](PowaAuras.UI, self, frame, ...));
		-- Update.
		self:UpdateTabs();
	end,
	ClearTabs = function(self)
		-- Remove all tabs.
		while(self.Tabs[1]) do
			self:RemoveTab(1);
		end
	end,
	GetSelectedTab = function(self)
		return self.SelectedTab;
	end,
	HideTab = function(self, index)
		-- Make sure it exists.
		if(not self.Tabs[index]) then return; end
		-- Well this is pretty simple. Note that you can still select hidden tabs programmatically.
		self.Tabs[index]:Hide();
	end,
	RemoveTab = function(self, index)
		-- Make sure it exists.
		if(not self.Tabs[index]) then return; end
		-- Remove the tab.
		self.Tabs[index]:Recycle();
		tremove(self.Tabs, index);
		-- If this tab was selected, select index #1.
		if(self.SelectedTab and self.SelectedTab == index) then
			self:SetSelectedTab(1);
		end
		-- Update tabs.
		self:UpdateTabs();
	end,
	SetSelectedTab = function(self, index)
		-- Make sure the index exists, even if its associated tab doesn't.
		if(not index or not self.Tabs[index]) then index = 1; end
		-- Set value.
		self.SelectedTab = index;
		-- Callback.
		self:CallScript("OnSelectedTabChanged", index);
		-- Update tabs.
		self:UpdateTabs();
	end,
	ShowTab = function(self, index)
		-- Make sure it exists.
		if(not self.Tabs[index]) then return; end
		-- Well this is pretty simple.
		self.Tabs[index]:Show();
	end,
	UpdateTabs = function(self)
		-- Locals.
		local offset = 0;
		-- Position tabs.
		for index, tab in pairs(self.Tabs) do
			-- Update the tab index first of all.
			tab:SetTabIndex(index);
			-- Checked?
			tab:SetChecked((self.SelectedTab and self.SelectedTab == index));
			-- Position it if needed.
			if(tab:IsShown()) then
				tab:ClearAllPoints();
				tab:SetPoint(
					tab.Points[1],
					self,
					tab.Points[2], 
					(tab.Points[3]+(tab.Orientation == "HORIZONTAL" and offset or 0)),
					(tab.Points[4]+(tab.Orientation == "VERTICAL" and offset or 0))
				);
				-- Bump the offset.
				offset = offset+tab.Offset;
			end
		end
	end,
});

-- Tab frame that is linked to a tree view. If either changes the selected index/key, then they are both updated.
PowaAuras.UI:Register("TreeControlledTabFrame", {
	Base = "TabFrame",
	Init = function(self, tree)
		-- Initialize tab frame.
		PowaAuras.UI.TabFrame.Init(self, "TabButtonBase");
		-- Need a tree.
		if(not tree) then
			return;
		end
		-- Replace tree view update func.
		tree:SetScript("OnSelectedKeyChanged", function(tree, key)
			-- Update selected tab.
			self:SetSelectedTab(key);
		end);
		-- Store tree.
		self.Tree = tree;
	end,
	SetSelectedTab = function(self, index)
		-- Call parent func.
		PowaAuras.UI.TabFrame.SetSelectedTab(self, index);
		-- Make sure keys/indexes match.
		if(self.Tree:GetSelectedKey() ~= index) then
			self.Tree:SetSelectedKey(index);
		end
	end,
});
