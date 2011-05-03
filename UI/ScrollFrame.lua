-- Create definition.
PowaAuras.UI:Register("ScrollFrame", {
	EnhancedScripts = true,
	Scripts = {
		OnShow = "ScrollUpdate",
		OnVerticalScroll = true,
		OnScrollRangeChanged = true,
		OnMouseWheel = true,
	},
	Init = function(self)
		-- Immediate update.
		self:ScrollUpdate();
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