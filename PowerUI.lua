-- wroustea@guerrillamailblock.com
-- (Ignore that, just a disposable email I used for a battle.net account for a wow trial)

-- Initializes a tab button, linking it to a frame and a tab.
function PowaTabButton_Init(tab, id, text, parent)
	-- Stores status for tab.
	tab.Selected = false;
	tab.Text = _G[tab:GetName() .. "Text"];
	tab.Id = id;
	tab:SetText(text);
	tab:SetParent(parent);
	tab:SetScript("OnClick", function()
		tab:GetParent():SelectTab(tab.Id);
	end);
	-- Selects/deselects the tab. Modifies appearance only (frame handled by the tab frame)
	tab.SetSelected = function(self, selected)
		if(selected == true) then
			self:SetHighlightTexture(nil);
			self:SetNormalFontObject("GameFontHighlightSmall");
			self:SetNormalTexture("Interface\\PaperDollInfoFrame\\UI-Character-ActiveTab");
			self:GetNormalTexture():SetTexCoord(0, 1, 0.606875, 0.05);
			self:Disable();
		else
			self:SetNormalTexture("Interface\\PaperDollInfoFrame\\UI-Character-InActiveTab");
			self:GetNormalTexture():SetTexCoord(0, 1, 1, 0);
			self:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-RealHighlight", "ADD");
			self:GetHighlightTexture():SetPoint("TOPLEFT", self, "TOPLEFT", 0, -4);
			self:GetHighlightTexture():SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 1);
			self:GetHighlightTexture():SetTexCoord(0, 1, 0.2, 0.6);
			self:SetNormalFontObject("GameFontNormalSmall");
			self:Enable();
		end
	end
end

-- Sidebar equivalent of the tab button.
function PowaTabSidebarButton_Init(tab, id, text, parent)
	-- Stores status for tab.
	tab.Selected = false;
	tab.Text = _G[tab:GetName() .. "Text"];
	tab.Id = id;
	tab:SetText(text);
	tab:SetParent(parent);
	tab:SetScript("OnClick", function()
		tab:GetParent():SelectTab(tab.Id);
	end);
	-- Selects/deselects the tab. Modifies appearance only (frame handled by the tab frame)
	tab.SetSelected = function(self, selected)
		if(selected == true) then
			-- self:SetHighlightTexture(nil);
			self:Disable();
		else
			-- self:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar-Blue");
			self:Enable();
		end
	end
end

-- Initializes a tab frame. The tab frame is the frame that holds the tabs, and their respective frames.
function PowaTabFrame_Init(frame, tabType)
	-- Current tab.
	frame.Tab = 1;
	-- Stores the name of the frames each tab represents.
	frame.Tabs = {};
	frame.TabType = tabType or 1;
	-- Registers a tab for display.
	frame.RegisterTab = function(self, tab, text, hidden)
		if(not tab) then PowaAuras:ShowText("Cannot register tab, tab does not exist."); return; end
		-- Register the tab.
		tinsert(self.Tabs, tab);
		-- Does this tab have its own button?
		if(not tab.TabButton) then
			-- Make a new tab button.
			local tabButton;
			if(self.TabType == 1) then
				tabButton = CreateFrame("Button", frame:GetName() .. "TabButton" .. #(self.Tabs), self, "PowaTabButtonTemplate");
				tab.TabButton = tabButton;
				PowaTabButton_Init(tab.TabButton, #(self.Tabs), text, self);
			else
				tabButton = CreateFrame("Button", frame:GetName() .. "TabButton" .. #(self.Tabs), self, "PowaTabSidebarButtonTemplate");
				tab.TabButton = tabButton;
				PowaTabSidebarButton_Init(tab.TabButton, #(self.Tabs), text, self);
			end
		end
		PowaAuras:ShowText("Registering tab: " .. text .. " (" .. #(self.Tabs) .. ")");
		-- Update tabs.
		tab.TabDisabled = (hidden or false);
		self:UpdateTabs();
	end
	-- Hides a tab. If the tab being hidden is selected, the selection is reset to #1.
	frame.HideTab = function(self, tab)
		if(not self.Tabs[tab]) then PowaAuras:ShowText("Cannot hide tab, tab does not exist."); return; end
		PowaAuras:ShowText("Hiding tab: " .. tab);
		-- Disable it.
		self.Tabs[tab].TabDisabled = true;
		-- Update selection if needed.
		if(tab == self.Tab) then self.Tab = (#(self.Tabs) > 0 and 1 or 0); end
		self:UpdateTabs();
	end
	-- Shows a tab.
	frame.ShowTab = function(self, tab)
		if(not self.Tabs[tab]) then PowaAuras:ShowText("Cannot show tab, tab does not exist."); return; end
		PowaAuras:ShowText("Showing tab: " .. tab);
		-- Enable it.
		self.Tabs[tab].TabDisabled = false;	
		self:UpdateTabs();
	end
	-- Selects a tab.
	frame.SelectTab = function(self, tab)
		if(not self.Tabs[tab]) then PowaAuras:ShowText("Cannot select tab, tab does not exist."); return; end
		PowaAuras:ShowText("Selecting tab: " .. tab);
		self.Tab = tab;
		self:UpdateTabs();	
	end
	-- Internal function for updating tab display.
	frame.UpdateTabs = function(self)
		-- If no tab is selected, select #1.
		if(self.Tab == 0) then self.Tab = 1; end
		-- Go over tabs
		local i = 1;
		for tabId, tab in pairs(self.Tabs) do
			if(tab) then
				if(tab.TabDisabled == false) then
					if(self.TabType == 1) then
						tab.TabButton:SetPoint("BOTTOMLEFT", self, "TOPLEFT", (i-1)*115, -2);
					else
						tab.TabButton:SetPoint("TOPRIGHT", self, "TOPLEFT", 0, -((i-1)*24));						
					end
					tab.TabButton:SetSelected((tabId == self.Tab));
					tab.TabButton:Show();
				else
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
end

-- Initializes a frame to support automatic layouts.
function PowaLayoutFrame_Init(frame)
	frame.Columns = 1;
	frame.ColumnSizes = {};
	frame.Items = {};
	-- Sets the columns for the grid. Defaults to 1, can specify a sizes table.
	frame.SetColumns = function(self, columns, sizes)
		self.Columns = columns;
		self.ColumnSizes = sizes or {};
		self:UpdateLayout();
	end
	-- Adds/removes items to the grid.
	frame.SetItem = function(self, child, padding)
		-- Insert it into the items table.
		child.LayoutPadding = padding or { Left = 0, Right = 0, Top = 0, Bottom = 0 };
		tinsert(self.Items, child);
		self:UpdateLayout();
		return #(self.Items); -- Should be the ID...
	end
	frame.UnsetItem = function(self, itemId)
		tremove(self.Items, itemId);
		self:UpdateLayout();
	end
	-- Updates the layout of the frame.
	frame.UpdateLayout = function(self)
		local itemCount, item, column, offsetY, offsetX, modY, colWidth, colHeight = #(self.Items), nil, 0, 0, 0, 0, 0, 0;
		for i=1,itemCount do
			item = self.Items[i];
			if(self.Columns == column) then
				column = 1;
				offsetX = 0;
				offsetY = offsetY-modY;
				modY = 0;
			else
				column = column+1;			
			end
			--[[ 
				colWidth will either be an absolute width,  a decimal which represents a fluid width based on the 
				container width), or nil (which will just be the item width).
				
				Padding is subtracted from width.
			--]]
			colWidth = (self.ColumnSizes[column]["X"] 
				and (self.ColumnSizes[column]["X"] > 1 
					and self.ColumnSizes[column]["X"] 
					or self:GetWidth() * self.ColumnSizes[column]["X"]) 
				or item:GetWidth())-item.LayoutPadding["Right"]-item.LayoutPadding["Left"];
			colHeight = (self.ColumnSizes[column]["Y"] 
				and (self.ColumnSizes[column]["Y"] > 1 
					and self.ColumnSizes[column]["Y"] 
					or self:GetHeight() * self.ColumnSizes[column]["Y"]) 
				or item:GetHeight())-item.LayoutPadding["Bottom"]-item.LayoutPadding["Top"];
			-- Update offset to take into account the padding.
			offsetX = offsetX+item.LayoutPadding["Left"];
			offsetY = offsetY-item.LayoutPadding["Top"];
			-- Set point.
			item:ClearAllPoints();
			item:SetPoint("TOPLEFT", self, "TOPLEFT", offsetX, offsetY);
			item:SetWidth(colWidth);
			item:SetHeight(colHeight);
			-- Update offsets.
			modY = (modY > colHeight and modY or colHeight);
			offsetX = offsetX+colWidth;
		end
	end
end

-- Most of this was just a test. Ignore 90% of it.

-- -- -- We reuse widgets to cut down on used memory/frames.
-- -- PowaAuras.UIWidgets = {};
-- -- PowaAuras.UIWidgetCount = 0;

-- -- -- Doesn't support constructors like PowaClass, uses a custom __call function for widget creation.
-- -- function PowaAuras:UIWidgetClass(base, widget)
	-- -- local w, mt = {}, {};
	-- -- if(base and type(base) == "table") then
		-- -- for i,v in pairs(base) do
			-- -- w[i] = v;
		-- -- end
	-- -- end
	-- -- if(widget and type(widget) == "table") then
		-- -- for i,v in pairs(widget) do
			-- -- w[i] = v;
		-- -- end
	-- -- end
	-- -- -- Custom constructor function for widget reuse.
	-- -- mt.__call = function(_, ...)
		-- -- -- Try reusing any hidden widgets.
		-- -- local frame;
		-- -- if(not self.UIWidgets[w.Type]) then self.UIWidgets[w.Type] = {}; end
		-- -- if(self.UIWidgets[w.Type][1]) then
			-- -- -- Reuse existing.
			-- -- frame = self.UIWidgets[w.Type][1];
			-- -- tremove(self.UIWidgets[w.Type], 1);
			-- -- frame:Init(true, ...);
		-- -- else
			-- -- -- Make a new widget.
			-- -- self.UIWidgetCount = self.UIWidgetCount + 1;
			-- -- frame = w:Construct(("PowaUI" .. (w.Type or "Widget") .. self.UIWidgetCount));
			-- -- -- Shallow copy of all methods and fields on the widget table.
			-- -- for i,v in pairs(w) do
				-- -- frame[i] = v;
			-- -- end
			-- -- frame:Init(false, ...);
		-- -- end
		-- -- -- Done.
		-- -- return frame;
	-- -- end
	-- -- setmetatable(w, mt);
	-- -- return w;
-- -- end

-- -- cPowaUIWidget = PowaAuras:UIWidgetClass({ __PowaUIWidget = true, Type = "Widget" });

-- -- -- Constructor. This constructs the frame used for the widget. Only called once, must return the created frame.
-- -- -- Do not reference self in here, use the frame object instead.
-- -- function cPowaUIWidget:Construct(name)
	-- -- -- Create the frame.
	-- -- local self = CreateFrame("Frame", name, UIParent);
	-- -- -- Set up some storage variables.
	-- -- self.Name = name;
	-- -- -- Hook some functions.
	-- -- self.__Hide = self.Hide;
	-- -- return self;
-- -- end

-- -- -- Init function. Called whenever the widget is constructed or reused. First param is true if the widget is being reused.
-- -- function cPowaUIWidget:Init(isRecycled, parent, width, height, point, relative, offsetx, offsety)
	-- -- -- Reset positioning/sizing.
	-- -- self:SetParent((parent or UIParent));
	-- -- self:SetPoint((point or "CENTER"), (parent or UIParent), (relative or "CENTER"), (offsetx or 0), (offsety or 0));
	-- -- self:SetWidth((width or 0));
	-- -- self:SetHeight((height or 0));
	-- -- self:Show();	
	
	-- -- print("Initialized widget: (" .. self.Type .. ", " .. self.Name .. ", " .. (isRecycled and "true" or "false") .. ")");
-- -- end

-- -- -- Recycle function. Makes sure the frame allows itself to be reused. Don't call this directly, use Hide();
-- -- function cPowaUIWidget:Recycle()
	-- -- if(self:IsShown() or self:IsVisible()) then
		-- -- -- Recycle is set as the onhide handler, but the frame is still shown. Hide it first.
		-- -- self:Hide();
	-- -- else
		-- -- -- Allow reuse.
		-- -- self:Reset();
		-- -- tinsert(PowaAuras.UIWidgets[self.Type], self);
		-- -- print("Recycled widget: (" .. self.Type .. ", " .. self.Name .. ")");
		-- -- -- Go over our child frames.
		-- -- local children = { self:GetChildren() };
		-- -- for _, child in ipairs(children) do
			-- -- -- Hide them!
			-- -- if(child.__PowaUIWidget) then child:Hide(); end
		-- -- end
	-- -- end
-- -- end

-- -- -- Reset function. Override this if you need to remove additional things like hooks.
-- -- function cPowaUIWidget:Reset()
	-- -- -- Clear any anchors, reset parent to something else. Failing to do so may result in many errors and oddities.
	-- -- self:ClearAllPoints();
	-- -- self:SetParent(UIParent);
-- -- end

-- -- function cPowaUIWidget:Hide(...)
	-- -- -- Call normal hide (we do this hook because OnHide doesn't fire if you hide a hidden frame).
	-- -- self:__Hide(...);
	-- -- -- Recycle frame.
	-- -- self:Recycle();
-- -- end

-- -- -- Attempts to layout all children in a grid. Needs fine-tuning.
-- -- function cPowaUIWidget:LayoutChildren(columns)
	-- -- -- Go over our child frames.
	-- -- local children, i, row, yoffset, nextyoffset, w, c = { self:GetChildren() }, 1, 1, 5, 0, (self:GetWidth()/columns)-10, columns;
	-- -- for _, child in ipairs(children) do
		-- -- if(child.__PowaUIWidget) then
			-- -- -- Have we changed row?
			-- -- if(math.floor(i/c) > row) then
				-- -- row = math.floor(i/c)+1;
				-- -- yoffset = yoffset+nextyoffset+5;
				-- -- nextyoffset = 0;
			-- -- end
			-- -- -- Calculate height of element. If it's larger than our next offset, change it.
			-- -- nextyoffset = (nextyoffset > child:GetHeight() and nextyoffset or child:GetHeight());
			-- -- -- Position element.
			-- -- child:ClearAllPoints();
			-- -- child:SetPoint("TOPLEFT", self, "TOPLEFT", 5+((i-1)*(w+5))-(floor((i-1)/c)*(c*(w+5))), -yoffset);
			-- -- -- Update element width if needed!
			-- -- if(child:GetWidth() > w) then
				-- -- child:SetWidth(w);
			-- -- end
			-- -- -- Next!
			-- -- i = i+1;
		-- -- end
	-- -- end
-- -- end

-- -- cPowaUIFrame = PowaAuras:UIWidgetClass(cPowaUIWidget, { Type = "Frame" });

-- -- function cPowaUIFrame:Construct(name)
	-- -- -- Create the frame.
	-- -- local self = CreateFrame("Frame", name, UIParent, "BasicFrameTemplate");
	-- -- -- Set up some storage variables.
	-- -- self.Name = name;
	-- -- -- Hook some functions.
	-- -- self.__Hide = self.Hide;
	-- -- return self;
-- -- end

-- -- function cPowaUIFrame:Init(isRecycled, parent, width, height, point, relative, offsetx, offsety)
	-- -- -- Reset positioning/sizing.
	-- -- self:SetParent((parent or UIParent));
	-- -- self:SetPoint((point or "CENTER"), (parent or UIParent), (relative or "CENTER"), (offsetx or 0), (offsety or 0));
	-- -- self:SetWidth((width or 0));
	-- -- self:SetHeight((height or 0));
	-- -- self:Show();
	-- -- -- Add child elements (they'll be created or recycled automatically)
	-- -- self.Children = {
		-- -- [1] = cPowaUIChildFrame(self, 200, 100),
		-- -- [2] = cPowaUIChildFrame(self, 200, 100),
		-- -- [3] = cPowaUIChildFrame(self, 200, 100),
		-- -- [4] = cPowaUIChildFrame(self, 200, 100),
		-- -- [5] = cPowaUIChildFrame(self, 200, 100),
		-- -- [6] = cPowaUIChildFrame(self, 200, 100),
		-- -- [7] = cPowaUIChildFrame(self, 200, 100),
		-- -- [8] = cPowaUIChildFrame(self, 200, 100),
		-- -- [9] = cPowaUIChildFrame(self, 200, 100),
		-- -- [10] = cPowaUIChildFrame(self, 200, 100),
		-- -- [11] = cPowaUIChildFrame(self, 200, 100),
		-- -- [12] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [13] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [14] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [15] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [16] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [17] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [18] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [19] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [20] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [21] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [22] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [23] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [24] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [25] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [26] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [27] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [28] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [29] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [30] = cPowaUIChildFrame(self, 200, 100),
	-- -- };
	-- -- self:LayoutChildren(3);
	-- -- -- Show frame.
	-- -- self:Show();
	
	-- -- print("Initialized widget: (" .. self.Type .. ", " .. self.Name .. ", " .. (isRecycled and "true" or "false") .. ")");
-- -- end

-- -- cPowaUIChildFrame = PowaAuras:UIWidgetClass(cPowaUIFrame, { Type = "ChildFrame" });

-- -- function cPowaUIChildFrame:Construct(name)
	-- -- -- Create the frame.
	-- -- local self = CreateFrame("Frame", name, UIParent, "BasicFrameTemplate");
	-- -- -- Set up some storage variables.
	-- -- self.Name = name;
	-- -- -- Hook some functions.
	-- -- self.__Hide = self.Hide;
	-- -- return self;
-- -- end

-- -- function cPowaUIChildFrame:Init(isRecycled, parent, width, height, point, relative, offsetx, offsety)
	-- -- -- Reset positioning/sizing.
	-- -- self:SetParent((parent or UIParent));
	-- -- self:SetPoint((point or "CENTER"), (parent or UIParent), (relative or "CENTER"), (offsetx or 0), (offsety or 0));
	-- -- self:SetWidth((width or 0));
	-- -- self:SetHeight((height or 0));
	-- -- -- Show frame.
	-- -- self:Show();
	
	
	-- -- print("Initialized widget: (" .. self.Type .. ", " .. self.Name .. ", " .. (isRecycled and "true" or "false") .. ")");
-- -- end