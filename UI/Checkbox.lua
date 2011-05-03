-- Create definition.
PowaAuras.UI:Register("Checkbox", {
	Hooks = {
		"SetChecked",
	},
	Init = function(self, property, tooltipDesc)
		-- Update text to the localized variant.
		local localeKey = self:GetText();
		self:SetText(PowaAuras.Text[localeKey]);
		-- Do we have a property?
		if(type(property) == "string") then
			-- Add OnClick handler for value setting.
			self:SetScript("OnClick", function(self)
				PowaAuras.Helpers:SaveSetting(property, (self:GetChecked() and true or false));
			end);
		elseif(type(property) == "function") then
			-- Use supplied onclick handler.
			self:SetScript("OnClick", property);
		end
		-- Also register a callback on the same property for whenever it's changed.
		PowaAuras.Helpers:RegisterSettingCallback(property, function(value)
			self:SetChecked(value);
		end);
		-- Add tooltip.
		PowaAuras.UI:Tooltip(self, localeKey, tooltipDesc or localeKey .. "Desc");
		-- Update colours...
		self:UpdateColors();
	end,
	SetChecked = function(self, checked)
		-- Update.
		self:__SetChecked(checked);
		self:UpdateColors();
	end,
	UpdateColors = function(self)
		if(self:GetChecked()) then
			if(self:IsMouseOver()) then
				self.BorderLeft:SetVertexColor(1, 0.82, 0, 1);
				self.BorderTop:SetGradientAlpha("HORIZONTAL", 1, 0.82, 0, 1, 1, 0.82, 0, 0);
				self.BorderBottom:SetGradientAlpha("HORIZONTAL", 1, 0.82, 0, 1, 1, 0.82, 0, 0);
			else
				self.BorderLeft:SetVertexColor(1, 0.82, 0, 0.8);
				self.BorderTop:SetGradientAlpha("HORIZONTAL", 1, 0.82, 0, 0.8, 1, 0.82, 0, 0);
				self.BorderBottom:SetGradientAlpha("HORIZONTAL", 1, 0.82, 0, 0.8, 1, 0.82, 0, 0);
			end
		else
			if(self:IsMouseOver()) then
				self.BorderLeft:SetVertexColor(0.3, 0.3, 0.3, 1);
				self.BorderTop:SetGradientAlpha("HORIZONTAL", 0.3, 0.3, 0.3, 1, 0.3, 0.3, 0.3, 0);
				self.BorderBottom:SetGradientAlpha("HORIZONTAL", 0.3, 0.3, 0.3, 1, 0.3, 0.3, 0.3, 0);
			else
				self.BorderLeft:SetVertexColor(0.3, 0.3, 0.3, 0.8);
				self.BorderTop:SetGradientAlpha("HORIZONTAL", 0.3, 0.3, 0.3, 0.8, 0.3, 0.3, 0.3, 0);
				self.BorderBottom:SetGradientAlpha("HORIZONTAL", 0.3, 0.3, 0.3, 0.8, 0.3, 0.3, 0.3, 0);
			end
		end
	end
});