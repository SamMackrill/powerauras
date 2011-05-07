-- Create definition.
PowaAuras.UI:Register("Settings", {
	Construct = function(class, _, frame, setting)
		-- Place in default functions.
		frame.GetSetting = frame.GetSetting or class.GetSetting;
		frame.SaveSetting = frame.SaveSetting or class.SaveSetting;
		frame.UpdateSetting = frame.UpdateSetting or class.UpdateSetting;
		frame.OnSettingChanged = frame.OnSettingChanged or class.OnSettingChanged;
		-- Register setting.
		frame:UpdateSetting(setting);
		-- We're done.
		return;
	end,
	GetSetting = function(self)
		return PowaAuras.Helpers:GetSetting(self.SettingKey);
	end,
	OnSettingChanged = function(self, value)
		-- Override as you please.
	end,
	SaveSetting = function(self, value)
		return PowaAuras.Helpers:SaveSetting(self.SettingKey, value);
	end,
	UpdateSetting = function(self, setting)
		-- Store setting.
		self.SettingKey = setting;
		-- Only register the callback once.
		if(not self.HasRegisteredSettingsCallback) then
			-- Go go go.
			PowaAuras.Helpers:RegisterSettingCallback(function(key, value)
				if(self.SettingKey ~= key) then return; end
				self:OnSettingChanged(value);
			end);
			self.HasRegisteredSettingsCallback = true;
		end
		-- Trigger update.
		self:OnSettingChanged(self:GetSetting());
	end,
});