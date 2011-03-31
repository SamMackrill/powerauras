-- Create definition.
PowaAuras.UI["TabFrame"] = {
	Init = function(frame, tabType, offset)
		-- Current tab.
		frame.Tab = 1;
		-- Stores the name of the frames each tab represents.
		frame.Tabs = {};
		frame.TabType = tabType or 1;
		-- Optional offset for tabs.
		frame.Offset = offset or (tabType == 4 and 10 or 0);
	end,
	RegisterTab = function(self, tab, text, hidden)
		if(not tab) then PowaAuras:ShowText("Cannot register tab, tab does not exist."); return; end
		-- Register the tab.
		tinsert(self.Tabs, tab);
		-- Does this tab have its own button?
		if(not tab.TabButton) then
			-- Make a new tab button.
			local tabButton;
			if(self.TabType == 1) then
				tabButton = CreateFrame("Button", nil, self, "PowaTabButtonTemplate");
				tab.TabButton = tabButton;
				PowaAuras.UI.TabButton(tab.TabButton, #(self.Tabs), text, self);
			elseif(self.TabType == 2) then
				tabButton = CreateFrame("Button", nil, self, "PowaTabSidebarButtonTemplate");
				tab.TabButton = tabButton;
				PowaAuras.UI.TabSidebarButton(tab.TabButton, #(self.Tabs), text, self);
			elseif(self.TabType == 3) then
				-- No tab button.
				tab.TabButton = nil;
			elseif(self.TabType == 4) then
				-- Icon tab button.
				tabButton = CreateFrame("Button", nil, self, "PowaTabIconButtonTemplate");
				tab.TabButton = tabButton;
				PowaAuras.UI.TabIconButton(tab.TabButton, #(self.Tabs), text, self);
			end
		end
		-- Update tabs.
		tab.TabDisabled = (hidden or false);
		self:UpdateTabs();
	end,
	HideTab = function(self, tab)
		if(not self.Tabs[tab]) then PowaAuras:ShowText("Cannot hide tab, tab does not exist."); return; end
		-- Disable it.
		self.Tabs[tab].TabDisabled = true;
		-- Update selection if needed.
		if(tab == self.Tab) then self.Tab = (#(self.Tabs) > 0 and 1 or 0); end
		self:UpdateTabs();
	end,
	ShowTab = function(self, tab)
		if(not self.Tabs[tab]) then PowaAuras:ShowText("Cannot show tab, tab does not exist."); return; end
		-- Enable it.
		self.Tabs[tab].TabDisabled = false;	
		self:UpdateTabs();
	end,
	SelectTab = function(self, tab)
		if(not self.Tabs[tab]) then PowaAuras:ShowText("Cannot select tab, tab does not exist."); return; end
		self.Tab = tab;
		self:UpdateTabs();	
	end,
	UpdateTabs = function(self)
		-- If no tab is selected, select #1.
		if(self.Tab == 0) then self.Tab = 1; end
		-- Go over tabs for offset positioning.
		local i = 1;
		for tabId, tab in pairs(self.Tabs) do
			if(tab) then
				if(tab.TabDisabled == false and tab.TabButton) then
					if(self.TabType == 1) then
						tab.TabButton:SetPoint("BOTTOMLEFT", self, "TOPLEFT", ((i-1)*115)+self.Offset, -2);
					elseif(self.TabType == 2) then
						tab.TabButton:SetPoint("TOPRIGHT", self, "TOPLEFT", 0, -((i-1)*24)-self.Offset);	
					elseif(self.TabType == 4) then		
						tab.TabButton:SetPoint("BOTTOMLEFT", self, "TOPLEFT", ((i-1)*38)+self.Offset, -2);			
					end
					tab.TabButton:SetSelected((tabId == self.Tab));
					tab.TabButton:Show();
				elseif(tab.TabButton) then
					tab.TabButton:Hide();					
				end
				-- Allow the tab to be shown, even if it's disabled.
				if(self.Tab ~= tabId) then
					tab:Hide();
				else
					-- Each tab is individually responsible for positioning its frame.
					tab:Show();
				end			
				i=i+1;
			end
		end
	end
};
-- Register.
PowaAuras.UI:DefineWidget("TabFrame");