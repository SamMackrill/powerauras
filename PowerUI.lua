-- wroustea@guerrillamailblock.com
-- (Ignore that, just a disposable email I used for a battle.net account for a wow trial)

-- Each widget has its own init function, and a shared pool of closures available to all widgets.
-- You can initialize a widget by calling PowaAuras.UI.[widget]().
PowaAuras.UI = {
	-- Browser frame definition.
	BrowserFrame = {
		Init = function(frame, min, max, update)
			-- Set up some values.
			frame.Page = 1;
			-- Setting either max/min to nil will result in no page limits.
			frame.MaxPage = max;
			frame.MinPage = min;
			-- This is supplied in the init function.
			frame.UpdatePage = update;
			-- Set page to 1.
			frame:SetPage(1);
		end,
		SetPage = function(self, page)
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
			if(self.PageBox) then
				self.PageBox.EditBox:SetText(page);
			end
		end,
		NextPage = function(self)
			self:SetPage(self.Page+1);
		end,
		PrevPage = function(self)
			self:SetPage(self.Page-1);
		end,
		FirstPage = function(self)
			self:SetPage(self.MinPage or 1);
		end,
		LastPage = function(self)
			self:SetPage(self.MaxPage or 1);	
		end,
		SetMinPage = function(self, page)
			-- Update page.
			self.MinPage = page;
			self:SetPage(self.Page);
		end,
		SetMaxPage = function(self, page)
			-- Update page.
			self.MaxPage = page;
			self:SetPage(self.Page);
		end
	},
	-- Layout frame definition.
	LayoutFrame = {
		Init = function(frame)
			frame.Columns = 1;
			frame.ColumnSizes = {};
			frame.Items = {};
			frame.Debug = false;
		end,
		SetColumns = function(self, columns, sizes)
			self.Columns = columns;
			self.ColumnSizes = sizes or {};
			self:UpdateLayout();
		end,
		SetItem = function(self, child, options)
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
		end,
		UnsetItem = function(self, itemId)
			tremove(self.Items, itemId);
			self:UpdateLayout();
		end,
		UpdateLayout = function(self)
			local iC, c, cO, oY, oX, mY = #(self.Items), 0, 1, 0, 0, 0;
			for i=1,iC do
				-- Some locals for width, height and the item...
				local item, cW, cH = self.Items[i], 0, 0;
				-- Store padding/margins in locals, as it's a long thing to write out and we need to calculate stuff from it a lot.
				local pL, pR, pT, pB = item.LayoutOpts["Padding"][1], 
					item.LayoutOpts["Padding"][2], item.LayoutOpts["Padding"][3], item.LayoutOpts["Padding"][4];
				local mL, mR, mT, mB = item.LayoutOpts["Margin"][1], 
					item.LayoutOpts["Margin"][2], item.LayoutOpts["Margin"][3], item.LayoutOpts["Margin"][4];
				-- Calculate the padding/margins if they're fluid values.
				-- The only difference in these fluid values is they are not fluid if they equal 1.
				pL = (pL > 0 and pL < 1 and self:GetWidth() * pL or pL);
				pR = (pR > 0 and pR < 1 and self:GetWidth() * pR or pR);
				pT = (pT > 0 and pT < 1 and self:GetWidth() * pT or pT);
				pB = (pB > 0 and pB < 1 and self:GetWidth() * pB or pB);
				mL = (mL > 0 and mL < 1 and self:GetWidth() * mL or mL);
				mR = (mR > 0 and mR < 1 and self:GetWidth() * mR or mR);
				mT = (mT > 0 and mT < 1 and self:GetWidth() * mT or mT);
				mB = (mB > 0 and mB < 1 and self:GetWidth() * mB or mB);
				-- Update column offset.
				if(self.Columns < (c+cO)) then
					-- We've gone down a row. Reset column to #1, reset X offset and lower the Y offset.
					c = 1;
					oX = 0;
					oY = oY-mY;
					mY = 0;
				else
					c = c+cO;
				end
				-- Calculate column height and width, obeying column span rules.
				-- If the size is <= 1, then it's a fluid value based on container size. If no size is specified, default to item size.
				if(c+(item.LayoutOpts["Columns"]-1) <= self.Columns) then
					for j=c, c+(item.LayoutOpts["Columns"]-1) do
						cW = cW + (self.ColumnSizes[j]["X"] or 0);
						cH = (cH > (self.ColumnSizes[j]["Y"] or 0) and cH or (self.ColumnSizes[j]["Y"] or 0));
					end
				else
					cW = (self.ColumnSizes[c]["X"] or 0);
					cH = (self.ColumnSizes[c]["Y"] or 0);
				end
				-- Update column height/width.
				cW = (cW == 0 and item:GetWidth() or cW <= 1 and (self:GetWidth() * cW));
				cH = (cH == 0 and item:GetHeight() or cH <= 1 and (self:GetHeight() * cH));
				-- Debug layout?
				if(self.Debug == true) then self:DebugItem(item, cW, cH, cW-pL-pR, cH-pT-pB, pL, pR, pT, pB, mL, mR, mT, mB, oX, oY); end
				-- Update sizes, subtracting padding.
				item:SetWidth(cW - pL - pR);
				item:SetHeight(cH - pT - pB);
				-- Set point.
				item:ClearAllPoints();
				item:SetPoint("TOPLEFT", self, "TOPLEFT", oX+pL+mL, (oY - pT - mT));
				-- Update offsets once more for margins only.
				oX = oX + cW + mL + mR;
				-- Use cH for vertical offset. The Y offset of each row is determined based on the largest object in the previous row.
				-- So if we directly write to oY, then we're going to offset everything else on this row too.
				cH = cH + mB + mT;
				mY = (mY > cH and mY or cH);
				-- Column offset update.
				cO = item.LayoutOpts["Columns"];
			end
		end,
		DebugItem = function(self, item, fcW, fcH, cW, cH, pL, pR, pT, pB, mL, mR, mT, mB, oX, oY)
			local name = item:GetName();
			for i=1, 9 do
				-- Get texture/frame.
				local frame = item["Debug" .. i] or CreateFrame("Frame", nil, item);
				frame:EnableMouse(true);
				frame:SetFrameStrata("HIGH");
				frame.Texture = frame:CreateTexture();
				frame.Texture:SetAllPoints(frame);
				-- Are we doing size, padding or margins?
				if(i == 1) then
					-- Size.
					frame.Texture:SetTexture(1, 0, 0, 1);
					frame:SetAllPoints(item); -- Just do a setallpoints for width/height...				
					PowaAuras.UI.Tooltip(frame, item:GetName(), "Width: " .. fcW .. "\nHeight: " .. fcH .. 
						"\nReal Width: " .. cW .. "\nReal Height: " .. cH .. 
						"\n\nPadding (L): " .. pL .. "\nPadding (R): " .. pR .. "\nPadding (T): " .. pT .. "\nPadding (B): " .. pB .. 
						"\n\nMargin (L): " .. mL .. "\nMargin (R): " .. mR .. "\nMargin (T): " .. mT .. "\nMargin (B): " .. mB .. 
						"\n\nOffset (X): " .. oX .. "\nOffset (Y): " .. oY .. "\nReal Offset (X): " .. oX+pL+mL .. "\nReal Offset (Y): " .. oY-pT-mT);
				elseif(i >= 2 and i <= 5) then
					-- Padding.
					frame.Texture:SetTexture(0, 1, 0, 1);
					if(i == 2) then
						frame:SetPoint("RIGHT", item, "LEFT");
						PowaAuras.UI.Tooltip(frame, item:GetName(), "Padding (L): " .. pL);
						frame:SetWidth(math.abs(pL));
						frame:SetHeight(math.abs(cH));
					elseif(i == 3) then
						frame:SetPoint("LEFT", item, "RIGHT");
						PowaAuras.UI.Tooltip(frame, item:GetName(), "Padding (R): " .. pR);
						frame:SetWidth(math.abs(pR));
						frame:SetHeight(math.abs(cH));
					elseif(i == 4) then
						frame:SetPoint("BOTTOM", item, "TOP");
						PowaAuras.UI.Tooltip(frame, item:GetName(), "Padding (T): " .. pT);
						frame:SetHeight(math.abs(pT));
						frame:SetWidth(math.abs(cW));
					elseif(i == 5) then
						frame:SetPoint("TOP", item, "BOTTOM");
						PowaAuras.UI.Tooltip(frame, item:GetName(), "Padding (B): " .. pB);
						frame:SetHeight(math.abs(pB));
						frame:SetWidth(math.abs(cW));
					end
				elseif(i >= 6 and i <= 9) then
					-- Margins.
					frame.Texture:SetTexture(0, 0, 1, 1);
					if(i == 6) then
						frame:SetPoint("RIGHT", item, "LEFT", -pL, 0);
						PowaAuras.UI.Tooltip(frame, item:GetName(), "Margin (L): " .. mL);
						frame:SetWidth(math.abs(mL));
						frame:SetHeight(math.abs(cH));
					elseif(i == 7) then
						frame:SetPoint("LEFT", item, "RIGHT", pR, 0);
						PowaAuras.UI.Tooltip(frame, item:GetName(), "Margin (R): " .. mR);
						frame:SetWidth(math.abs(mR));
						frame:SetHeight(math.abs(cH));
					elseif(i == 8) then
						frame:SetPoint("BOTTOM", item, "TOP", 0, pT);
						PowaAuras.UI.Tooltip(frame, item:GetName(), "Margin (T): " .. mT);
						frame:SetHeight(math.abs(mT));
						frame:SetWidth(math.abs(cW));
					elseif(i == 9) then
						frame:SetPoint("TOP", item, "BOTTOM", 0, -pB);
						PowaAuras.UI.Tooltip(frame, item:GetName(), "Margin (B): " .. mB);
						frame:SetHeight(math.abs(mB));
						frame:SetWidth(math.abs(cW));
					end
				end
				-- Store texture...
				item["Debug" .. i] = frame;
			end
		end
	},
	-- Slider definition.
	Slider = {	
		Init = function(frame, min, max, default, step, title, unit, minLabel, maxLabel, tooltipDesc)
			-- Call them.
			frame:SetUnit(unit or "");
			frame:SetMinMaxValues(min or 1, max or 100, minLabel, maxLabel);
			frame:SetValue(default or 50);
			frame:SetValueStep(step or 1);
			frame:SetTitle(title or "");
			-- Add tooltips to the slider, background frame and editbox.
			PowaAuras.UI.Tooltip(frame, title, title .. "Desc" or tooltipDesc, { "Slider", "Value" });
		end,
		GetMinValue = function(self)
			return select(1, self.Slider:GetMinMaxValues());
		end,
		GetMaxValue = function(self)
			return select(2, self.Slider:GetMinMaxValues());
		end,
		SetMinMaxValues = function(self, min, max, labelMin, labelMax)
			self.Slider:SetMinMaxValues(min, max);
			self.Slider.Low:SetText((labelMin or min) .. (self.Unit or ""));
			self.Slider.High:SetText((labelMax or max) .. (self.Unit or ""));
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
	-- Tab definition.
	TabFrame = {
		Init = function(frame, tabType, offset)
			-- Current tab.
			frame.Tab = 1;
			-- Stores the name of the frames each tab represents.
			frame.Tabs = {};
			frame.TabType = tabType or 1;
			-- Optional offset for tabs.
			frame.Offset = offset or 0;
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
					tabButton = CreateFrame("Button", frame:GetName() .. "TabButton" .. #(self.Tabs), self, "PowaTabButtonTemplate");
					tab.TabButton = tabButton;
					PowaAuras.UI.TabButton(tab.TabButton, #(self.Tabs), text, self);
				elseif(self.TabType == 2) then
					tabButton = CreateFrame("Button", frame:GetName() .. "TabButton" .. #(self.Tabs), self, "PowaTabSidebarButtonTemplate");
					tab.TabButton = tabButton;
					PowaAuras.UI.TabSidebarButton(tab.TabButton, #(self.Tabs), text, self);
				elseif(self.TabType == 3) then
					-- No tab button.
					tab.TabButton = nil;
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
	},
	-- Tab button definition.
	TabButton = {
		Init = function(tab, id, text, parent)
			-- Stores status for tab.
			tab.Selected = false;
			tab.Text = _G[tab:GetName() .. "Text"];
			tab.Id = id;
			tab:SetText(text);
			tab:SetParent(parent);
			tab:SetScript("OnClick", function()
				tab:GetParent():SelectTab(tab.Id);
			end);
		end,
		SetSelected = function(self, selected)
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
	},
	-- Tab sidebar button definition.
	TabSidebarButton = {
		Init = function(tab, id, text, parent)
			-- Stores status for tab.
			tab.Selected = false;
			tab.Text = _G[tab:GetName() .. "Text"];
			tab.Id = id;
			tab:SetText(text);
			tab:SetParent(parent);
			tab:SetScript("OnClick", function()
				tab:GetParent():SelectTab(tab.Id);
			end);
		end,
		SetSelected = function(self, selected)
			if(selected == true) then
				self:Disable();
			else
				self:Enable();
			end
		end
	},
	-- Tooltip definition.
	Tooltip = {
		Init = function(frame, title, text, children)
			-- Store data.
			frame.TooltipTitle = PowaAuras.Text[title];
			frame.TooltipText = PowaAuras.Text[text];
			-- Use the RefreshTooltip function as a display method.
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
		end,
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
	
	-- Turns the definition tables into metatables with constructor-like functionality.
	DefineWidget = function(self, widget)
		if(not self[widget]) then print("No widget definition exists for: " .. widget); end
		self[widget] = setmetatable(self[widget], { 
				__call = function(self, widget, ...)
					-- Constructor. Copy anything we have over automatically...
					for k,v in pairs(self) do
						widget[k] = v;
					end
					-- Run passed ctor.
					return self:Init(widget, ...);
				end
			}
		);
		return true;
	end,
}

-- Set up constructors.
PowaAuras.UI.DefineWidget("BrowserFrame");
PowaAuras.UI.DefineWidget("LayoutFrame");
PowaAuras.UI.DefineWidget("Slider");
PowaAuras.UI.DefineWidget("TabFrame");
PowaAuras.UI.DefineWidget("TabButton");
PowaAuras.UI.DefineWidget("TabSidebarButton");
PowaAuras.UI.DefineWidget("Tooltip");

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