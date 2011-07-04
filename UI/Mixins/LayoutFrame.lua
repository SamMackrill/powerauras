-- Highly simplified version of old layout frame.
PowaAuras.UI:Register("LayoutFrame", {
	Scripts = {
		OnSizeChanged = true,
	},
	Init = function(self)
		-- I need things to store data in.
		self.Children = {};
		self.Columns = {};
		self.RowSpacing = 15;
		self.Locked = false;
		-- Boundaries.
		self.BoundsLeft = 0;
		self.BoundsRight = 0;
		self.BoundsTop = 0;
		-- Performance fix.
		self.LastWidth = self:GetWidth();
	end,
	AddColumn = function(self, width, paddingLeft, paddingRight)
		-- Add the column.
		tinsert(self.Columns, {
			Width = width,
			PaddingLeft = paddingLeft or 5,
			PaddingRight = paddingRight or 5,
		});
		-- Update.
		self:UpdateLayout();
	end,
	AddChild = function(self, child, span, wrap, marginTop, marginBottom)
		-- Store dataz.
		child.LayoutColumnSpan = min(span or 1, #(self.Columns));
		child.LayoutWrap = (wrap or false);
		child.LayoutMarginTop = marginTop or 0;
		child.LayoutMarginBottom = marginBottom or 0;
		tinsert(self.Children, child);
		-- Update.
		self:UpdateLayout();
	end,
	ClearChildren = function(self)
		-- I hope you remember to wipe!
		wipe(self.Children);
		self:UpdateLayout();
	end,
	LockLayout = function(self)
		self.Locked = true;
	end,
	OnSizeChanged = function(self, width)
		-- Recalculate layout if frame width changes.
		if(width ~= self.LastWidth) then
			self:UpdateLayout();
			self.LastWidth = width;
		end
	end,
	RemoveChild = function(self, frame)
		-- Find child, remove.
		for index, child in pairs(self.Children) do
			if(child == frame) then
				tremove(self.Children, index);
			end
		end
		-- Update.
		self:UpdateLayout();
	end,
	SetBounds = function(self, left, right, top)
		-- Set boundaries.
		self.BoundsLeft = left;
		self.BoundsRight = right;
		self.BoundsTop = top;
		-- Update.
		self:UpdateLayout();
	end,
	SetRowSpacing = function(self, spacing)
		-- Update spacing.
		self.RowSpacing = spacing;
		self:UpdateLayout();
	end,
	UnlockLayout = function(self)
		self.Locked = false;
		self:UpdateLayout();
	end,
	UpdateLayout = function(self)
		-- Cancel if locked.
		if(self.Locked) then return; end
		-- Layout variables.
		local width, maxColumns, column, columnOffset, offsetX, offsetY, rowHeight, rowHasGap = 
			self:GetWidth()-self.BoundsLeft-self.BoundsRight, #(self.Columns), 1, 0, self.BoundsLeft, 
			self.BoundsTop, 0, false;
		-- Go over my items!
		for _, item in pairs(self.Children) do
			-- Extract layout data for the child.
			local itemWrap, itemColumnSpan, itemMarginTop, itemMarginBottom = item.LayoutWrap, 
				min(item.LayoutColumnSpan, #(self.Columns)), item.LayoutMarginTop, item.LayoutMarginBottom;
			local itemWidth, itemHeight = item:GetSize();
			-- Increment column.
			if((((column+columnOffset)-1)+itemColumnSpan) <= maxColumns 
			and not (rowHasGap == true and itemWrap == true)) then
				column = (column+columnOffset);
				columnOffset = itemColumnSpan;
			else
				-- We'll need to wrap.
				column = 1;
				columnOffset = itemColumnSpan;
				offsetY = offsetY+rowHeight+(rowHeight > 0 and self.RowSpacing or 0);
				offsetX = self.BoundsLeft;
				rowHeight = 0;
				rowHasGap = false;
			end
			-- Is the item shown?
			if(item:IsVisible()) then
				-- Calculate column width.
				local columnLeft, columnWidth, columnRight, usableWidth = 0, 0, 0, 0;
				for c=column, ((column-1)+itemColumnSpan) do
					local col = self.Columns[c];
					-- Allow fluid column widths.
					columnWidth = columnWidth+(col and (col.Width > 1 and col.Width 
						or (col.Width >= 0 and col.Width <= 1 and (width*col.Width))) or 0);
					-- Padding cannot be fluid. Padding should only be applied for the first and last columns if the
					-- item spans multiple columns.
					columnLeft = columnLeft+(col and c == column and col.PaddingLeft or 0);
					columnRight = columnRight+(col and c == ((column-1)+itemColumnSpan) and col.PaddingRight or 0);
				end
				-- Update usable width.
				usableWidth = columnWidth-columnLeft-columnRight;
				-- Resize item to fit if necessary.
				if(itemWidth ~= usableWidth) then
					item:SetWidth(usableWidth);
				end
				-- Position item.
				item:ClearAllPoints();
				item:SetPoint("TOPLEFT", offsetX+columnLeft, -offsetY-itemMarginTop);
				-- Increment Y offset.
				itemHeight = (itemHeight+itemMarginTop+itemMarginBottom);
				rowHeight = (rowHeight > itemHeight and rowHeight or itemHeight);
				-- Increment X offset.
				offsetX = offsetX+columnWidth;
				rowHasGap = false;
			else
				-- Item not shown.
				columnOffset = 0;
				rowHasGap = true;
			end
			-- Update my own height.
			self:SetHeight(offsetY+rowHeight+self.RowSpacing);
		end
	end
});
