-- Create definition.
PowaAuras.UI:Register("ScrollFrame", {
	Scripts = {
		OnShow = "ScrollUpdate",
		OnVerticalScroll = true,
		OnScrollRangeChanged = true,
		OnMouseWheel = true,
	},
	Init = function(self)
		-- Register the scrollbar as...A scrollbar?
		PowaAuras.UI:ScrollBar(self.ScrollBar);
		-- Immediate update.
		self:ScrollUpdate();
		self:EnableMouseWheel(true); -- Don't need full mouse functionality - it prevents dragging.
	end,
	OnVerticalScroll = function(self, offset)
		self.ScrollBar:SetValue(offset);
		self:ScrollUpdate();
	end,
	OnScrollRangeChanged = function(self, _, yrange)
		self.ScrollBar:SetMinMaxValues(0, yrange);
		self:ScrollUpdate();
	end,
	OnMouseWheel = function(self, delta)
		if(delta > 0) then
			self.ScrollBar:SetValue(self.ScrollBar:GetValue()-(self.ScrollBar:GetHeight()/2));
		else
			self.ScrollBar:SetValue(self.ScrollBar:GetValue()+(self.ScrollBar:GetHeight()/2));
		end
		self:ScrollUpdate();
	end,
	ScrollUpdate = function(self)
		if(self:GetScrollChild():GetHeight() > self:GetHeight()) then
			self.ScrollBar:Show();
			self:GetScrollChild():SetWidth(self:GetWidth()-18);
		else
			self.ScrollBar:Hide();
			self:GetScrollChild():SetWidth(self:GetWidth());
		end
		if(self:GetVerticalScroll() == 0) then
			self.ScrollBar.ScrollUp:Disable();
		else
			self.ScrollBar.ScrollUp:Enable();
		end
		if(self:GetVerticalScroll() == self:GetVerticalScrollRange()) then
			self.ScrollBar.ScrollDown:Disable();
		else
			self.ScrollBar.ScrollDown:Enable();
		end
	end,
});

-- Generic scroll child used in the aura editor.
PowaAuras.UI:Register("EditorScrollChild", {
	Init = function(self)
		-- Update.
		self:UpdateLayout();
	end,
	UpdateLayout = function(self)
		-- Initial padding of 70.
		local height = 70;
		-- Add height of child elements.
		local count = self:GetNumChildren();
		for i=1, count do
			-- +8 for the spacing between elements.
			height = height+select(i, self:GetChildren()):GetHeight()+8;
		end
		-- Update.
		self:SetHeight(height);
	end,
});

-- Basic definition of ScrollBar, set up to work with the ScrollFrame by default.
PowaAuras.UI:Register("ScrollBar", {
	Scripts = {
		OnScrollDownClicked = true,
		OnScrollUpClicked = true,
		OnMouseWheel = true,
		OnValueChanged = true,
	},
	Init = function(self)
		-- Manually register certain scripts...
		self.ScrollDown:SetScript("OnClick", function(button, ...)
			self:CallScript("OnScrollDownClicked", ...);
			PlaySound("UChatScrollButton");
		end);
		self.ScrollUp:SetScript("OnClick", function(button, ...)
			self:CallScript("OnScrollUpClicked", ...);
			PlaySound("UChatScrollButton");
		end);
	end,
	OnScrollDownClicked = function(self)
		self:SetValue(self:GetValue()+(self:GetHeight()/2));
	end,
	OnScrollUpClicked = function(self)
		self:SetValue(self:GetValue()-(self:GetHeight()/2));
	end,
	OnMouseWheel = function(self)
		if(delta > 0) then
			self:SetValue(self:GetValue()-(self:GetHeight()/2));
		else
			self:SetValue(self:GetValue()+(self:GetHeight()/2));
		end
	end,
	OnValueChanged = function(self, value)
		self:GetParent():SetVerticalScroll(value);
	end,
});

-- Special scrollframe, it doesn't use one but instead allows you to scroll through a list of items and display them.
-- It isn't "smooth", relying on a simple offset. The scroll offset can be either horizontal or vertical based, but not
-- both.
PowaAuras.UI:Register("ScrollableItemsFrame", {
	ScrollOffset = 0,
	ScrollRangeMax = 0,
	ScrollRangeMin = 0,
	ScrollStep = 1,
	Construct = function(class, ui, self, hasScrollBar)
		-- Apply scripts handler.
		ui:Scripts(self);
		-- Register mouse wheel events.
		self:EnableMouseWheel(true);
		self:SetScript("OnMouseWheel", class.OnMouseWheel);
		-- Make slider.
		self.ScrollBar = CreateFrame("Slider", nil, self, "PowaScrollBarTemplate");
		self.ScrollBar:SetPoint("TOPRIGHT", -2, -20);
		self.ScrollBar:SetPoint("BOTTOMRIGHT", 2, 20);
		-- Update things.
		self.ScrollBar:SetValueStep(class.ScrollStep);
		self.ScrollBar:SetMinMaxValues(class.ScrollRangeMin, class.ScrollRangeMax);
		self.ScrollBar:SetValue(class.ScrollOffset);
		-- Register as ScrollBar.
		ui:ScrollBar(self.ScrollBar);
		-- Override me some scripts.
		self.ScrollBar:SetScript("OnScrollDownClicked", function() class.IncrementScroll(self); end);
		self.ScrollBar:SetScript("OnScrollUpClicked", function() class.DecrementScroll(self); end);
		self.ScrollBar:SetScript("OnMouseWheel", function(_, delta) class.OnMouseWheel(self, delta); end);
		self.ScrollBar:SetScript("OnValueChanged", function(_, value) class.SetScrollOffset(self, value) end);
		-- Hide ScrollBar by default.
		self.ScrollBar:Hide();
		-- Call normal ctor.
		ui.Construct(class, ui, self);
	end,
	DecrementScroll = function(self)
		-- Decrement if possible.
		self:SetScrollOffset(self.ScrollOffset-self.ScrollStep);
	end,
	GetScrollOffset = function(self)
		return self.ScrollOffset;
	end,
	GetScrollRange = function(self)
		return self.ScrollRangeMin, self.ScrollRangeMax;
	end,
	IncrementScroll = function(self)
		-- Increment if possible.
		self:SetScrollOffset(self.ScrollOffset+self.ScrollStep);
	end,
	OnMouseWheel = function(self, delta)
		if(delta < 0) then
			self:IncrementScroll();
		else
			self:DecrementScroll();
		end
	end,
	SetScrollOffset = function(self, offset)
		-- Set offset.
		self.ScrollOffset = offset;
		self:CallScript("OnScrollOffsetChanged", self.ScrollOffset);
		-- Update.
		self:UpdateScrollOffset();
	end,
	SetScrollRange = function(self, minRange, maxRange)
		-- Update ranges.
		self.ScrollRangeMin = minRange;
		self.ScrollRangeMax = max(maxRange, minRange);
		self:CallScript("OnScrollRangeChanged", minRange, maxRange);
		-- Update.
		self:UpdateScrollOffset();
	end,
	SetScrollStep = function(self, step)
		-- Set step.
		self.ScrollStep = step;
		self.ScrollBar:SetValueStep(step);
		self:CallScript("OnScrollStepChanged", step);
		-- Force scroll to be a multiple of the step.
		self:SetScrollOffset(self.ScrollOffset - mod(self.ScrollOffset, step));
	end,
	UpdateScrollList = function(self)
		-- Rest must be implemented manually!
	end,
	UpdateScrollOffset = function(self)
		-- Cap it.
		self.ScrollOffset = min(self.ScrollOffset, self.ScrollRangeMax);
		self.ScrollOffset = max(self.ScrollOffset, self.ScrollRangeMin);
		self:CallScript("OnScrollOffsetChanged", self.ScrollOffset);
		-- Fix scrollbar.
		self.ScrollBar:SetMinMaxValues(self.ScrollRangeMin, self.ScrollRangeMax);
		self.ScrollBar:SetValue(self.ScrollOffset);
		-- Buttons...
		if(self.ScrollOffset <= self.ScrollRangeMin) then
			self.ScrollBar.ScrollUp:Disable();
		else
			self.ScrollBar.ScrollUp:Enable();
		end
		if(self.ScrollOffset >= self.ScrollRangeMax) then
			self.ScrollBar.ScrollDown:Disable();
		else
			self.ScrollBar.ScrollDown:Enable();
		end
		-- Hide scrollbar if it isn't needed.
		if(self.ScrollRangeMax-self.ScrollRangeMin <= 0) then
			self.ScrollBar:Hide();
		else
			self.ScrollBar:Show();
		end
		-- Update.
		self:UpdateScrollList();
	end,
});
