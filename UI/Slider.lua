-- Create definition.
PowaAuras.UI:Register("Slider", {
	Hooks = {
		"SetMinMaxValues",
	},
	Scripts = {
		OnSettingChanged = true,
		OnValueChanged = true,
	},
	Init = function(self, title, setting)
		-- Set the title....
		self:SetTitle(title or "");
		-- Add tooltips to the slider, background frame and editbox.
		PowaAuras.UI:Tooltip(self, title, (title .. "Desc"), "Value");
		-- Set up the editbox. Use an anonymous class and link it to this one directly.
		PowaAuras.UI:AnonymousWidget("SettingsEditBox", {
			Scripts = {
				OnSettingChanged = true,
				OnEnterPressed = true,
			},
			OnEditFocusLost = function(editbox)
				editbox:HighlightText(0, 0);
				-- Bugfix.
				self.OnEditBoxSettingChanged(editbox, editbox:GetSetting());
				editbox:ClearFocus();
				editbox:UpdateColours();
			end,
			OnEnterPressed = self.OnEditBoxValueChanged,
			OnSettingChanged = self.OnEditBoxSettingChanged,
		}, self.Value, title, setting);
		-- Set title of editbox to nothing.
		self.Value:SetTitle("");
		self.Value.Title:Hide();
		-- Link slider to settings mixin.
		PowaAuras.UI:Settings(self, setting);
		-- Update min/max labels.
		self:SetMinMaxLabels();
	end,
	GetMaxValue = function(self)
		return (select(2, self:GetMinMaxValues()));
	end,
	GetMinValue = function(self)
		return (select(1, self:GetMinMaxValues()));
	end,
	GetUnit = function(self)
		return self.Unit;
	end,
	OnEditBoxSettingChanged = function(self, value)
		if(self:GetText() ~= tostring(value)) then
			self:SetText(tostring(value));
		end
	end,
	OnEditBoxValueChanged = function(self)
		-- Store value.
		local num = tonumber(self:GetText());
		if(self:GetSetting() ~= self:GetText() and num) then
			self:SaveSetting(PowaAuras:Range(num, self:GetParent():GetMinValue(), self:GetParent():GetMaxValue()));
		else
			self:SetText(self:GetSetting());
		end
		-- Always clear ze focus.
		self:ClearFocus();
	end,
	OnSettingChanged = function(self, value)
		if(self:GetValue() ~= value and value ~= nil) then
			self:SetValue(value);
		end
	end,
	OnValueChanged = function(self, value)
		-- Store value.
		if(self:GetSetting() ~= value) then
			self:SaveSetting(value);
		end
	end,
	SetMinMaxLabels = function(self, labelMin, labelMax)
		-- Use min/max if no labels are defined.
		if(not labelMin) then labelMin = self:GetMinValue(); end
		if(not labelMax) then labelMax = self:GetMaxValue(); end
		-- Set.
		self.Low:SetText(labelMin .. (self.Unit or ""));
		self.High:SetText(labelMax .. (self.Unit or ""));
		-- Store so SetUnit can be called later on.
		self.MinLabel = labelMin;
		self.MaxLabel = labelMax;
	end,
	SetMinMaxValues = function(self, min, max)
		-- Normal func.
		self:__SetMinMaxValues(min, max);
		-- Update labels.
		self:SetMinMaxLabels(self.MinLabel, self.MaxLabel);
	end,
	SetTitle = function(self, title)
		self.Text:SetText(PowaAuras.Text[title]);	
	end,
	SetUnit = function(self, unit)
		-- Update unit...
		self.Unit = unit;
		-- Update labels!
		self:SetMinMaxLabels(self.MinLabel, self.MaxLabel);
	end,
});
