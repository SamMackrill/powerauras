-- Create definition.
PowaAuras.UI["LayoutFrame"] = {
	Init = function(self, x, y, alignMode, locked, isScrollChild, debug)
		-- Set up some things. My comments are ever descriptive tonight.
		self.Columns = {};
		self.Items = {};
		self:SetLocked(locked or false);
		self:SetOffsetX(x or 0);
		self:SetOffsetY(y or 0);
		self:SetAlign(alignMode or 1);
		self:SetDebug(debug or false);
		-- Autoscrollbar stuff.
		self.IsScrollChild = isScrollChild or false;
		if(isScrollChild) then
			-- Autoscrollbar!
			self.__SetHeight = self.SetHeight;
			self.SetHeight = function(self, height)
				self:__SetHeight(height);
				if(self:GetParent():GetHeight() > height) then
					self:GetParent().ScrollBar:Hide();
				end
			end
			if(self:GetParent():GetHeight() > self:GetHeight()) then
				self:GetParent().ScrollBar:Hide();
			end
		end
		-- Initial update.
		self:UpdateLayout();
	end,
	AddColumn = function(self, width, height, mode)
		tinsert(self.Columns, { X = width or 0, Y = height or 0, Mode = mode or 1 });
		self:UpdateLayout();
	end,
	AddItem = function(self, child, columns, padding, margins)
		-- Each frame has its own layout options.
		child.Columns = columns or 1;
		child.Padding = padding or { 0, 0, 0, 0 };
		child.Margins = margins or { 0, 0, 0, 0 };
		-- Insert it into the items table.
		tinsert(self.Items, child);
		self:UpdateLayout();
		return #(self.Items); -- Should be the ID...
	end,
	GetAlign = function(self)
		return self.AlignMode;
	end,
	GetDebug = function(self, debug)
		return self.Debug;
	end,
	GetLocked = function(self, locked)
		return self.IsLocked;
	end,
	GetOffsetX = function(self, x)
		return self.OffsetX;
	end,
	GetOffsetY = function(self, y)
		return self.OffsetY;
	end,
	RemoveColumn = function(self, column)
		tremove(self.Columns, column);
		self:UpdateLayout();
	end,
	RemoveItem = function(self, item)
		for i,v in pairs(self.Items) do
			if(v == item) then
				tremove(self.Items, i);
				self:UpdateLayout();
				return;
			end
		end
	end,
	SetAlign = function(self, align)
		self.AlignMode = align;
		self:UpdateLayout();
	end,
	SetDebug = function(self, debug)
		self.Debug = debug;
		self:UpdateLayout();
	end,
	SetLocked = function(self, locked)
		self.IsLocked = locked;
		self:UpdateLayout();
	end,
	SetOffsetX = function(self, x)
		self.OffsetX = x;
		self:UpdateLayout();
	end,
	SetOffsetY = function(self, y)
		self.OffsetY = -y;
		self:UpdateLayout();
	end,
	SetItem = function(self, ...)
		-- Deprecated.
		self:AddItem(...);
	end,
	UnsetItem = function(self, ...)
		-- Deprecated.
		self:RemoveItem(...);
	end,
	UpdateLayout = function(self)
		-- Check lock.
		if(self.IsLocked) then return; end
		-- Locals.
		local iC, c, cO, oY, oX, mY, cC, aO, aW, aF, gX, gY = #(self.Items), 0, 1, 0, 0, 0, #(self.Columns), 0, 0, false, self.OffsetX, self.OffsetY;
		-- Calculate align offset.
		if(self.AlignMode > 1) then
			-- Calculate total column set width.
			for _, col in pairs(self.Columns) do
				-- Fluid columns aren't allowed if you want the layout to be aligned.
				if(col["X"] <= 1) then aW = 0; aF = true; end
				if(not aF) then
					aW = aW + col["X"];
				end
			end
			-- Update align offset.
			if(self.AlignMode == 2) then
				-- Center align.
				aO = math.floor((self:GetWidth()-aW)/2);
			elseif(self.AlignMode == 3) then
				-- Right align.
				aO = math.floor(self:GetWidth()-aW);
			end
		end
		-- Align items.
		for i=1,iC do
			-- Some locals for width, height and the item...
			local item, cW, cH = self.Items[i], 0, 0;
			-- Store padding/margins in locals, as it's a long thing to write out and we need to calculate stuff from it a lot.
			local pL, pR, pT, pB = item.Padding[1], 
				item.Padding[2], item.Padding[3], item.Padding[4];
			local mL, mR, mT, mB = item.Margins[1], 
				item.Margins[2], item.Margins[3], item.Margins[4];
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
			if(cC < (c+cO)) then
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
			if(c+(item.Columns-1) <= cC) then
				for j=c, c+(item.Columns-1) do
					cW = cW + (self.Columns[j]["X"] or 0);
					cH = (cH > (self.Columns[j]["Y"] or 0) and cH or (self.Columns[j]["Y"] or 0));
				end
			else
				cW = (self.Columns[c]["X"] or 0);
				cH = (self.Columns[c]["Y"] or 0);
			end
			-- Update column height/width.
			cW = (cW == 0 and item:GetWidth() or cW <= 1 and (self:GetWidth() * cW) or cW);
			cH = (cH == 0 and item:GetHeight() or cH <= 1 and (self:GetHeight() * cH) or cH);
			-- Skip if item is not visible.
			if(item:IsShown()) then
				-- Debug layout?
				if(self.Debug == true) then self:DebugItem(item, cW, cH, cW-pL-pR, cH-pT-pB, pL, pR, pT, pB, mL, mR, mT, mB, oX, oY); end
				-- Update sizes, subtracting padding.
				if(self.Columns[c].Mode == 1 or (self.Columns[c].Mode == 2 and item:GetWidth() > (cW-pL-pR))) then
					item:SetWidth(cW-pL-pR);
				end
				if(self.Columns[c].Mode == 1 or (self.Columns[c].Mode == 2 and item:GetHeight() > (cH-pT-pB))) then
					item:SetHeight(cH-pT-pB);
				end
				-- Set point.
				item:ClearAllPoints();
				item:SetPoint("TOPLEFT", self, "TOPLEFT", gX+aO+oX+pL+mL, gY+oY-pT-mT);
			else
				-- ...So we "forget" the column height ever existed.
				cH = 0; mB = 0; mT = 0;
			end
			-- Update offsets once more for margins only.
			oX = oX + cW + mL + mR;
			-- Use cH for vertical offset. The Y offset of each row is determined based on the largest object in the previous row.
			-- So if we directly write to oY, then we're going to offset everything else on this row too.
			cH = cH + mB + mT;
			mY = (mY > cH and mY or cH);
			-- Column offset update.
			cO = item.Columns;
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
			local frame = item["Debug" .. i] or CreateFrame("Frame", nil, self);
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