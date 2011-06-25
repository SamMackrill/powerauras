-- Create definition.
PowaAuras.UI:Register("ScrollFrame", {
	Scripts = {
		OnShow = "ScrollUpdate",
		OnVerticalScroll = true,
		OnScrollRangeChanged = true,
		OnMouseWheel = true,
	},
	Init = function(self)
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
