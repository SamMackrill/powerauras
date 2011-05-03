-- Create definition.
PowaAuras.UI:Register("Checkbox", {
	Hooks = {
		"SetChecked",
	},
	EnhancedScripts = true,
	Scripts = {
		OnClick = true,
	},
	Init = function(self, property, invert, tooltipDesc)
		-- Update text to the localized variant.
		local localeKey = self:GetText();
		self:SetText(PowaAuras.Text[localeKey]);
		-- Store invert property.
		self.Invert = invert or false;
		-- Register Settings mixin.
		PowaAuras.UI:Settings(self, property);
		-- Add tooltip.
		PowaAuras.UI:Tooltip(self, localeKey, tooltipDesc or localeKey .. "Desc");
		-- Update colours...
		self:UpdateColors();
	end,
	OnClick = function(self)
		self:SaveSetting(self:GetChecked());
		PlaySound("UChatScrollButton");
	end,
	OnSettingChanged = function(self, value)
		--  Update based on invert state.
		if(self.Invert) then
			self:SetChecked(not value);
		else
			self:SetChecked(value);
		end
	end,
	SaveSetting = function(self, value)
		if(self.Invert) then
			PowaAuras.Helpers:SaveSetting(self.SettingKey, not self:GetChecked());
		else
			PowaAuras.Helpers:SaveSetting(self.SettingKey, (self:GetChecked() and true or false));
		end
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