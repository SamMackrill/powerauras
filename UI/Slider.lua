-- Create definition.
PowaAuras.UI:Register("Slider", {
	Hooks = {
		"GetValue",
		"SetValue",
	},
	Init = function(self, title, unit, minLabel, maxLabel, tooltipDesc)
		-- Call them.
		self:SetMinMaxLabels(minLabel, maxLabel);
		self:SetUnit(unit or "");
		self:SetTitle(title or "");
		-- Add tooltips to the slider, background frame and editbox.
		PowaAuras.UI:Tooltip(self, title, tooltipDesc or title .. "Desc", { "Value" });
		-- Update editbox value.
		self.Value:SetText(self:GetValue());
	end,
	GetMinValue = function(self)
		return select(1, self:GetMinMaxValues());
	end,
	GetMaxValue = function(self)
		return select(2, self:GetMinMaxValues());
	end,
	GetValue = function(self)
		if(self.OnValueGet) then
			return self:OnValueGet(self:__GetValue());
		else
			return self:__GetValue();
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
	SetTitle = function(self, title)
		self.Text:SetText(PowaAuras.Text[title]);	
	end,
	SetUnit = function(self, unit)
		-- Update unit...
		self.Unit = unit;
		-- Update labels!
		self:SetMinMaxLabels(self.MinLabel, self.MaxLabel);
	end,
	SetValue = function(self, value)
		if(self.OnValueSet) then
			return self:__SetValue(self:OnValueSet(value));
		else
			return self:__SetValue(value);
		end		
	end
});