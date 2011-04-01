-- Create definition.
PowaAuras.UI["Checkbox"] = {
	Init = function(self, property, tooltipDesc)
		-- Update text to the localized variant.
		local localeKey = self:GetText();
		self:SetText(PowaAuras.Text[localeKey]);
		-- Do we have a property?
		if(type(property) == "string") then
			-- Store property.
			self.Property = property;
			-- Add OnClick handler for value setting.
			self:SetScript("OnClick", function(self)
				PowaAuras:SaveSetting(property, (self:GetChecked() and true or false));
			end);
		elseif(type(property) == "function") then
			-- Use supplied onclick handler.
			self:SetScript("OnClick", property);
		end
		-- Add tooltip.
		PowaAuras.UI.Tooltip(self, localeKey, tooltipDesc or localeKey .. "Desc");
		-- Update colours...
		self:UpdateColors();
	end,
	UpdateColors = function(self)
		if(self:GetChecked()) then
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
};
-- Register.
PowaAuras.UI:DefineWidget("Checkbox");