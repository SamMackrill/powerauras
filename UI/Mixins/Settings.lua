-- Create definition.
PowaAuras.UI:Register("Settings", {
	Construct = function(class, ui, frame, setting)
		-- Place in default functions.
		frame.GetSetting = frame.GetSetting or class.GetSetting;
		frame.SaveSetting = frame.SaveSetting or class.SaveSetting;
		frame.UpdateSetting = frame.UpdateSetting or class.UpdateSetting;
		-- Using the scripts mixin?
		if(not frame.CallScript) then
			-- Make it so.
			ui:Scripts(frame);
		end
		-- Register setting.
		frame:UpdateSetting(setting);
	end,
	GetSetting = function(self)
		if(not self.SettingKey) then return; end
		return PowaAuras:GetSetting(self.SettingKey);
	end,
	SaveSetting = function(self, value)
		if(not self.SettingKey) then return; end
		return PowaAuras:SaveSetting(self.SettingKey, value);
	end,
	UpdateSetting = function(self, setting)
		-- Update setting key if needed, but only if it exists.
		if(setting and self.SettingKey ~= setting and PowaAuras:SettingExists(setting)) then
			self.SettingKey = setting;
		elseif(setting and self.SettingKey ~= setting or not setting) then
			-- You tried to change it but the new one doesn't exist...
			self.SettingKey = nil;
		end
		-- Need a setting brah!
		if(not self.SettingKey) then return; end
		-- Only register the callback once.
		if(not self.HasRegisteredSettingsCallback) then
			-- Go go go.
			PowaAuras:RegisterSettingCallback(function(key, value)
				if(self.SettingKey ~= key) then return; end
				self:CallScript("OnSettingChanged", value);
			end);
			self.HasRegisteredSettingsCallback = true;
		end
		-- Trigger update.
		self:CallScript("OnSettingChanged", self:GetSetting());
	end,
});
