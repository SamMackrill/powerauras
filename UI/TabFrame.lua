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
	UpdateTabs = function(self, index)
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