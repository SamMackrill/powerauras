-- UI upvalue.
local UI = PowaAuras.UI;
-- Create definition.
UI:Register("CheckboxBase", {
	Hooks = {
		"SetChecked",
		"SetText",
	},
	Scripts = {
		OnClick = true,
	},
	Init = function(self)
		-- Add tooltip.
		UI:Tooltip(self, "", "");
		-- Update text to the localized variant.
		self:SetText(self:GetText());
		-- Update colours...
		self:UpdateColors();
	end,
	OnClick = function(self)
		PlaySound("UChatScrollButton");
	end,
	SetChecked = function(self, checked)
		-- Update.
		self:__SetChecked(checked);
		self:UpdateColors();
	end,
	SetText = function(self, text, tooltip)
		-- Update text.
		text = text or "";
		local realText = (rawget(PowaAuras.Text, text) or text);
		self:__SetText(realText);
		-- Tooltip. If using text that isn't a localization key, you will need to supply the tooltip parameter.
		self.TooltipTitle = realText;
		tooltip = (tooltip or text .. "Desc");
		self.TooltipText = (rawget(PowaAuras.Text, tooltip) or tooltip);
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
	end,
});

-- Main checkbox widget.
UI:Register("Checkbox", {
	Base = "CheckboxBase",
	Scripts = {
		OnSettingChanged = true,
	},
	Init = function(self, property, invert)
		-- Call parent init.
		PowaAuras.UI.CheckboxBase.Init(self);
		-- Store invert property.
		self.Invert = invert or false;
		-- Register Settings mixin.
		UI:Settings(self, property);
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
			PowaAuras:SaveSetting(self.SettingKey, not self:GetChecked());
		else
			PowaAuras:SaveSetting(self.SettingKey, (self:GetChecked() and true or false));
		end
	end,
});

-- Color picker widget. This isn't necessarily a checkbox, but it looks a lot like one.
-- TODO Make this code more reusable.
UI:Register("AuraColorPicker", {
	Base = "CheckboxBase",
	Scripts = {
		OnSettingChanged = true,
	},
	Init = function(self, setting)
		-- Call main init!
		PowaAuras.UI.CheckboxBase.Init(self);
		-- Register for right clicks.
		self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
		-- Keep the previous colour available.
		self.PreviousColor = { 1, 1, 1 };
		-- Add functions now.
		self.OnSettingChanged = function(key, value)
			--  Update me, baby.
			local r, g, b = self:GetNormalTexture():GetVertexColor();
			if(key == "Aura.r") then
				self:GetNormalTexture():SetVertexColor(value, g, b);
			elseif(key == "Aura.g") then
				self:GetNormalTexture():SetVertexColor(r, value, b);
			elseif(key == "Aura.b") then
				self:GetNormalTexture():SetVertexColor(r, g, value);
			end
		end
		self.OnColorPickerCancel = function(restore)
			-- Always restore.
			self.OnColorPickerChanged(restore);
		end
		self.OnColorPickerChanged = function(restore)
			-- Get color.
			local r, g, b = ColorPickerFrame:GetColorRGB();
			if(restore) then
				r, g, b = unpack(restore);
			end
			-- Save me.
			self:SaveSetting(r, g, b);
			self:UpdateColors();
		end
		-- This one is fun because we need three setting hooks...
		PowaAuras:RegisterSettingCallback(self.OnSettingChanged);
		PowaAuras:RegisterSettingCallback(self.OnSettingChanged);
		PowaAuras:RegisterSettingCallback(self.OnSettingChanged);
	end,
	OnClick = function(self, button)
		-- I love it when we play sounds.
		PlaySound("UChatScrollButton");
		-- Left or right click?
		if(button == "LeftButton") then
			-- Update previous colours.
			local r, g, b = self:GetNormalTexture():GetVertexColor();
			self.PreviousColor[1] = r;
			self.PreviousColor[2] = g;
			self.PreviousColor[3] = b;
			-- COLOR PICKER! I DEMAND JUSTICE!
			ColorPickerFrame:Hide();
			ColorPickerFrame:SetColorRGB(r, g, b);
			ColorPickerFrame.hasOpacity = nil;
			ColorPickerFrame.previousValues = self.PreviousColor;
			-- I demand you call these two functions, weakling!
			ColorPickerFrame.func = self.OnColorPickerChanged;
			ColorPickerFrame.cancelFunc = self.OnColorPickerCancel;
			-- Show yourself, coward!
			ColorPickerFrame:Show();
		elseif(button == "RightButton") then
			-- Shift right click = Reset to white.
			if(IsShiftKeyDown()) then
				self.PreviousColor[1] = 1;
				self.PreviousColor[2] = 1;
				self.PreviousColor[3] = 1;
			end
			-- Restore previous colour.
			self.OnColorPickerChanged(self.PreviousColor);
			ColorPickerFrame:Hide();
		end
	end,
	OnColorPickerCancel = nil,
	OnColorPickerChanged = nil,
	OnSettingChanged = nil,
	SaveSetting = function(self, r, g, b)
		-- Save me, oh great one!
		PowaAuras:SaveSetting("Aura.r", tonumber(r) or 1);
		PowaAuras:SaveSetting("Aura.g", tonumber(g) or 1);
		PowaAuras:SaveSetting("Aura.b", tonumber(b) or 1);
	end,
	GetChecked = function() return ColorPickerFrame:IsShown(); end,
	SetChecked = function() --[[ Do nothing. ]] end,
});
