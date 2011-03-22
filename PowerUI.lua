-- wroustea@guerrillamailblock.com
-- (Ignore that, just a disposable email I used for a battle.net account for a wow trial)

-- Each widget has its own init function, and a shared pool of closures available to all widgets.
-- You can initialize a widget by calling PowaAuras.UI.[widget]().
PowaAuras.UI = {
	CreateWidget = function(self, widget, data, ctor)
		self[widget] = setmetatable(data or {}, { __call = ctor; });
		return true;
	end,
}

-- Tooltip definition.
PowaAuras.UI:CreateWidget("Tooltip", {
		Refresh = function(self)
			-- Hide tip.
			GameTooltip:Hide();
			-- Reparent.
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0);
			-- Set back up.
			GameTooltip:SetText(self.TooltipTitle or "");
			GameTooltip:AddLine(self.TooltipText or "", 1, 1, 1, true);
			-- Show tip.
			GameTooltip:Show();
		end
	},
	function(self, frame, title, text, children)
		-- Store data.
		frame.TooltipTitle = PowaAuras.Text[title];
		frame.TooltipText = PowaAuras.Text[text];
		-- Use the RefreshTooltip function as a display method.
		frame.Refresh = self.Refresh;
		frame:SetScript("OnEnter", frame.Refresh);
		-- Hide on leave.
		frame:SetScript("OnLeave", function()
			GameTooltip:Hide();
		end);
		-- Add to children too.
		if(children) then
			for _, child in pairs(children) do
				frame[child]:SetScript("OnEnter", function() frame:Refresh(); end);
				frame[child]:SetScript("OnLeave", function() GameTooltip:Hide(); end);
			end
		end
	end
);

-- Slider definition.
PowaAuras.UI:CreateWidget("Slider", {
		GetMinValue = function(self)
			return select(1, self.Slider:GetMinMaxValues());
		end,
		GetMaxValue = function(self)
			return select(2, self.Slider:GetMinMaxValues());
		end,
		SetMinMaxValues = function(self, min, max, labelMin, labelMax)
			self.Slider:SetMinMaxValues(min, max);
			self.Slider.Low:SetText((labelMin and PowaAuras.Text[labelMin] or min) .. (self.Unit or ""));
			self.Slider.High:SetText((labelMax and PowaAuras.Text[labelMax] or max) .. (self.Unit or ""));
		end,
		SetTitle = function(self, title)
			self.Slider.Text:SetText(PowaAuras.Text[title]);	
		end,
		SetValue = function(self, value)
			self.Slider:SetValue(value);
		end,
		GetValue = function(self)
			self.Slider:GetValue();
		end,
		SetValueStep = function(self, value)
			self.Slider:SetValueStep(value);
		end,
		GetValueStep = function(self)
			self.Slider:GetValueStep();
		end,
		SetUnit = function(self, unit)
			-- Manual calls to SetMinMaxValues are needed afterwards!
			self.Unit = unit;
		end
	},
	function(self, frame, min, max, default, step, title, unit, minLabel, maxLabel, tooltipDesc)
		-- Move functions over...
		frame.GetMinValue = self.GetMinValue;
		frame.GetMaxValue = self.GetMaxValue;
		frame.SetMinMaxValues = self.SetMinMaxValues;
		frame.SetTitle = self.SetTitle;
		frame.SetValue = self.SetValue;
		frame.GetValue = self.GetValue;
		frame.SetValueStep = self.SetValueStep;
		frame.GetValueStep = self.GetValueStep;
		frame.SetUnit = self.SetUnit;
		-- Call them.
		frame:SetUnit(unit or "");
		frame:SetMinMaxValues(min, max, minLabel, maxLabel);
		frame:SetValue(default);
		frame:SetValueStep(step);
		frame:SetTitle(title);
		-- Add tooltips to the slider, background frame and editbox.
		PowaAuras.UI.Tooltip(frame, title, title .. "Desc" or tooltipDesc, { "Slider", "Value" });
	end
);

--[[
	TODO:
	> Make UI definitions for all below frames.
--]]

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
			self:GetHighlightTexture():SetPoint("TOPLEFT", self, "TOPLEFT", 0, -7);
			self:GetHighlightTexture():SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0);
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
function PowaTabFrame_Init(frame, tabType, offset)
	-- Current tab.
	frame.Tab = 1;
	-- Stores the name of the frames each tab represents.
	frame.Tabs = {};
	frame.TabType = tabType or 1;
	-- Optional offset for tabs.
	frame.Offset = offset or 0;
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
			elseif(self.TabType == 2) then
				tabButton = CreateFrame("Button", frame:GetName() .. "TabButton" .. #(self.Tabs), self, "PowaTabSidebarButtonTemplate");
				tab.TabButton = tabButton;
				PowaTabSidebarButton_Init(tab.TabButton, #(self.Tabs), text, self);
			elseif(self.TabType == 3) then
				-- No tab button.
				tab.TabButton = nil;
			end
		end
		PowaAuras:ShowText("Registering tab: " .. (text or "") .. " (" .. #(self.Tabs) .. ")");
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
		-- Go over tabs for offset positioning.
		local i = 1;
		for tabId, tab in pairs(self.Tabs) do
			if(tab) then
				if(tab.TabDisabled == false and tab.TabButton) then
					if(self.TabType == 1) then
						tab.TabButton:SetPoint("BOTTOMLEFT", self, "TOPLEFT", ((i-1)*115)+self.Offset, -2);
					else
						tab.TabButton:SetPoint("TOPRIGHT", self, "TOPLEFT", 0, -((i-1)*24)-self.Offset);						
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
	frame.SetItem = function(self, child, options)
		-- Each frame has its own layout options.
		child.LayoutOpts = {
			Padding = { 0, 0, 0, 0 }, -- Padding modifies element offsets by reducing frame size to compensate.
			Margin = { 0, 0, 0, 0 },  -- Margins modify element offsets, but not frame size.
			Columns = 1,              -- Column span. Defaults to 1.
		}
		-- Overwrite any.
		if(options) then
			for k, v in pairs(options) do
				child.LayoutOpts[k] = v;
			end
		end
		-- Insert it into the items table.
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
		local itemCount, column, columnOffset, offsetY, offsetX, modY = #(self.Items), 0, 1, 0, 0, 0;
		for i=1,itemCount do
			-- Some locals for width, height and the item...
			local item, colWidth, colHeight = self.Items[i], 0, 0;
			-- Store padding/margins in locals, as it's a long thing to write out and we need to calculate stuff from it a lot.
			local paddingLeft, paddingRight, paddingTop, paddingBottom = item.LayoutOpts["Padding"][1], 
				item.LayoutOpts["Padding"][2], item.LayoutOpts["Padding"][3], item.LayoutOpts["Padding"][4];
			local marginLeft, marginRight, marginTop, marginBottom = item.LayoutOpts["Margin"][1], 
				item.LayoutOpts["Margin"][2], item.LayoutOpts["Margin"][3], item.LayoutOpts["Margin"][4];
			-- Calculate the padding/margins if they're fluid values.
			-- The only difference in these fluid values is they are not fluid if they equal 1.
			paddingLeft = (paddingLeft > 0 and paddingLeft < 1 and self:GetWidth() * paddingLeft or paddingLeft);
			paddingRight = (paddingRight> 0 and paddingRight < 1 and self:GetWidth() * paddingRight or paddingRight);
			paddingTop = (paddingTop > 0 and paddingTop < 1 and self:GetWidth() * paddingTop or paddingTop);
			paddingBottom = (paddingBottom > 0 and paddingBottom < 1 and self:GetWidth() * paddingBottom or paddingBottom);
			marginLeft = (marginLeft > 0 and marginLeft < 1 and self:GetWidth() * marginLeft or marginLeft);
			marginRight = (marginRight > 0 and marginRight < 1 and self:GetWidth() * marginRight or marginRight);
			marginTop = (marginTop > 0 and marginTop < 1 and self:GetWidth() * marginTop or marginTop);
			marginBottom = (marginBottom > 0 and marginBottom < 1 and self:GetWidth() * marginBottom or marginBottom);
			-- Update column offset.
			if(self.Columns < (column+columnOffset)) then
				column = 1;
				offsetX = 0;
				offsetY = offsetY-modY;
				modY = 0;
			else
				column = column+columnOffset;
			end
			-- Calculate column height and width, obeying column span rules.
			-- If the size is <= 1, then it's a fluid value based on container size. If no size is specified, default to item size.
			if(column+(item.LayoutOpts["Columns"]-1) <= self.Columns) then
				for i=column, column+(item.LayoutOpts["Columns"]-1) do
					colWidth = colWidth + (self.ColumnSizes[i]["X"] or 0);
					colHeight = (colHeight > (self.ColumnSizes[i]["Y"] or 0) and colHeight or (self.ColumnSizes[i]["Y"] or 0));
				end
			else
				colWidth = (self.ColumnSizes[column]["X"] or 0);
				colHeight = (self.ColumnSizes[column]["Y"] or 0);
			end
			if(item.LayoutOpts["Columns"] > 1) then
				print(colWidth, colHeight, paddingLeft, paddingRight, paddingTop, paddingBottom, marginLeft, marginRight, marginTop, marginBottom);
			end
			-- Update column height/width.
			colWidth = (colWidth == 0 and item:GetWidth() or colWidth <= 1 and (self:GetWidth() * colWidth));
			colHeight = (colHeight == 0 and item:GetHeight() or colHeight <= 1 and (self:GetHeight() * colHeight));
			-- Update sizes, subtracting padding.
			item:SetWidth(colWidth - paddingLeft - paddingRight);
			item:SetHeight(colHeight - paddingTop - paddingBottom);
			-- Update X offset to take into account the left padding and margins.
			-- Do not modify the Y offset as this will push all further items down. Instead just modify the offset in the SetPoint call.
			offsetX = offsetX + paddingLeft + marginLeft;
			-- Set point.
			item:ClearAllPoints();
			item:SetPoint("TOPLEFT", self, "TOPLEFT", offsetX, (offsetY - paddingTop - marginTop));
			-- Update offsets once more for right/bottom padding and margins.
			offsetX = offsetX + colWidth + paddingRight + marginRight;
			-- Use colHeight for vertical offset. The Y offset of each row is determined based on the largest object in the previous row.
			colHeight = colHeight + paddingBottom + marginBottom + paddingTop + marginTop;
			modY = (modY > colHeight and modY or colHeight);
			-- Column offset update.
			columnOffset = item.LayoutOpts["Columns"];
		end
	end
end

function PowaBrowserFrame_Init(frame, min, max, update)
	-- Set up some values.
	frame.Page = 1;
	-- Setting either max/min to nil will result in no page limits.
	frame.MaxPage = max;
	frame.MinPage = min;
	-- Sets the page.
	frame.SetPage = function(self, page)
		-- Page boundaries.
		if(self.MinPage and page < self.MinPage) then page = self.MinPage; end
		if(self.MaxPage and page > self.MaxPage) then page = self.MaxPage; end
		-- Update page contents.
		self.Page = page;
		self:UpdatePage(page);
		-- Enable/Disable buttons.
		if(not self.MinPage or self.Page > self.MinPage) then
			self.PrevPageButton:Enable();
		else
			self.PrevPageButton:Disable();		
		end
		if(not self.MaxPage or self.Page < self.MaxPage) then
			self.NextPageButton:Enable();
		else
			self.NextPageButton:Disable();		
		end
		-- Update page editbox.
		if(self.EditBox) then
			self.EditBox:SetText(page);
		end
	end
	-- Quick page functions.
	frame.NextPage = function(self)
		self:SetPage(self.Page+1);
	end
	frame.PrevPage = function(self)
		self:SetPage(self.Page-1);
	end
	frame.FirstPage = function(self)
		self:SetPage(self.MinPage or 1);
	end
	frame.LastPage = function(self)
		self:SetPage(self.MaxPage or 1);	
	end
	-- Min/Max pages.
	frame.SetMinPage = function(self, page)
		-- Update page.
		self.MinPage = page;
		self:SetPage(self.Page);
	end
	frame.SetMaxPage = function(self, page)
		-- Update page.
		self.MaxPage = page;
		self:SetPage(self.Page);
	end
	-- This is supplied in the init function.
	frame.UpdatePage = update;
	-- Set page to 1.
	frame:SetPage(1);
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