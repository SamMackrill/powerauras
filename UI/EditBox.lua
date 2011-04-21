-- Create definition.
PowaAuras.UI:Register("EditBox", {
	Init = function(self, property, title, tooltipDesc)
		-- Property handling not yet implemented.
		
		-- Show a title?
		if(title) then
			-- Set title, change editbox text inset so that it doesn't collide.
			self.Title:SetText(PowaAuras.Text[title] .. ":");
			self:SetTextInsets(self.Title:GetStringWidth()+8, 0, 1, 0);
		else
			self.Title:Hide();
			self:SetTextInsets(0, 0, 1, 0);
		end
		-- Tooltip me up!
		if(title) then
			PowaAuras.UI:Tooltip(self, title, tooltipDesc or title .. "Desc");
		end
		-- Update colours...
		self:UpdateColors();		
	end,
	UpdateColors = function(self, state)
		-- self:HasFocus() will return true even if OnEditFocusLost is fired, oddly. So we can force a state to
		-- be used.
		if(type(state) ~= "boolean") then state = self:HasFocus(); end
		if(state) then
			if(self:IsMouseOver()) then
				self:SetBackdropBorderColor(1, 0.82, 0, 1);
			else
				self:SetBackdropBorderColor(1, 0.82, 0, 0.8);
			end
		else
			if(self:IsMouseOver()) then
				self:SetBackdropBorderColor(0.3, 0.3, 0.3, 1);
			else
				self:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8);
			end
		end		
	end
});