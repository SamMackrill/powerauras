-- Create definition.
PowaAuras.UI["LayoutFrame"] = {
	Init = function(frame, columns, columnSizes, isScrollChild, debug)
		frame.Columns = columns or 1;
		frame.ColumnSizes = columnSizes or {};
		frame.Items = {};
		frame.Debug = debug or false;
		frame.IsScrollChild = isScrollChild or false;
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
			-- Skip if item is not visible.
			-- We skip this block as it positions the element, something which is useless.
			-- However, updating the HORIZONTAL offset is vital to the layout, the vertical not so much.
			if(item:IsShown()) then
				-- Debug layout?
				if(self.Debug == true) then self:DebugItem(item, cW, cH, cW-pL-pR, cH-pT-pB, pL, pR, pT, pB, mL, mR, mT, mB, oX, oY); end
				-- Update sizes, subtracting padding.
				item:SetWidth(cW - pL - pR);
				item:SetHeight(cH - pT - pB);
				-- Set point.
				item:ClearAllPoints();
				item:SetPoint("TOPLEFT", self, "TOPLEFT", oX+pL+mL, (oY - pT - mT));
			else
				-- ...So we "forget" the column height ever existed.
				cH = 0;
			end
			-- Update offsets once more for margins only.
			oX = oX + cW + mL + mR;
			-- Use cH for vertical offset. The Y offset of each row is determined based on the largest object in the previous row.
			-- So if we directly write to oY, then we're going to offset everything else on this row too.
			cH = cH + mB + mT;
			mY = (mY > cH and mY or cH);
			-- Column offset update.
			cO = item.LayoutOpts["Columns"];
		end
		-- Is the current parent frame a scrollchild?
		if(self.IsScrollChild) then
			self:SetHeight(oY+mY); -- +5 for some padding.
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
};
-- Register.
PowaAuras.UI:DefineWidget("LayoutFrame");