-- Create definition.
PowaAuras.UI:Register("EditBox", {
	Items = {},
	Scripts = {
		OnEscapePressed = true,
		OnEnterPressed = true,
		OnEnter = "UpdateColours",
		OnLeave = "UpdateColours",
		OnEditFocusGained = true,
		OnEditFocusLost = true,
	},
	Template = "PowaLabelledEditBoxTemplate",
	Construct = function(class, ui, frame, ...)
		-- Call normal ctor if frame was passed.
		if(frame) then
			return ui.Construct(class, _, frame, ...);
		end
		-- Recycling constructor of win.
		local item = class.Items[1];
		if(not item) then
			-- New frame needed.
			local parent = select(1, ...);
			item = CreateFrame("EditBox", nil, parent, class.Template);
			-- Pass it through the original ctor.
			return ui.Construct(class, _, item, select(2, ...));
		else
			-- Reinitialize it, done.
			tremove(class.Items, 1);
			item:Init(...);
			return item;
		end
	end,
	Init = function(self, title)
		-- Set title.
		self:SetTitle(title);
		-- Tooltip mixin.
		PowaAuras.UI:Tooltip(self, title, (title .. "Desc"));
	end,
	GetTitle = function(self)
		return self.Title:GetText();
	end,
	OnEditFocusGained = function(self)
		self:HighlightText();
		self:UpdateColours();
	end,
	OnEditFocusLost = function(self)
		self:HighlightText(0, 0);
		-- Call clearfocus so focus is REALLY cleared.
		self:ClearFocus();
		self:UpdateColours();
	end,
	OnEnterPressed = function(self)
		self:ClearFocus();
	end,
	OnEscapePressed = function(self)
		self:ClearFocus();
	end,
	SetTitle = function(self, title)
		self.Title:SetText((title and PowaAuras.Text[title] or ""));
	end,
	UpdateColours = function(self)
		if(self:HasFocus()) then
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
	end,
});

-- Settings enabled editbox.
PowaAuras.UI:Register("SettingsEditBox", {
	Base = "EditBox",
	Items = {},
	Scripts = {
		OnSettingChanged = "SetText",
	},
	Init = function(self, title, setting)
		-- Call main init func.
		PowaAuras.UI.EditBox.Init(self, title);
		-- Settings mixin.
		PowaAuras.UI:Settings(self, setting);
	end,
	OnEditFocusLost = function(self)
		self:HighlightText(0, 0);
		-- Call clearfocus so focus is REALLY cleared.
		self:SetText(self:GetSetting());
		self:ClearFocus();
		self:UpdateColours();
	end,
	OnEnterPressed = function(self)
		-- Save setting.
		self:SaveSetting(self:GetText());
		self:ClearFocus();
	end,
	OnEscapePressed = function(self)
		-- Restore defaults.
		self:SetText(self:GetSetting());
		self:ClearFocus();
	end,
});

-- Numeric version of the settings editbox.
PowaAuras.UI:Register("NumericSettingsEditBox", {
	Base = "SettingsEditBox",
	Items = {},
	Hooks = {
		"SetText",
	},
	Scripts = {
		OnSettingChanged = "SetText",
	},
	Init = function(self, title, setting, decimals)
		-- Call main init func.
		self.Decimals = decimals or 0;
		-- Fix meh!
		PowaAuras.UI.SettingsEditBox.Init(self, title, setting);
	end,
	GetDecimals = function(self)
		return self.Decimals;
	end,
	OnEnterPressed = function(self)
		-- Save setting.
		local val = tonumber(self:GetText());
		if(val) then
			self:SaveSetting(self:Round(tonumber(self:GetText())));
		else
			self:SetText(self:GetSetting() or 0);
		end
		self:ClearFocus();
	end,
	Round = function(self, src)
		return floor(src*(10^self.Decimals)+0.5)/(10^self.Decimals);
	end,
	SetDecimals = function(self, deci)
		self.Decimals = deci;
		if(not self:HasFocus()) then
			self:OnEscapePressed();
		end
	end,
	SetText = function(self, text)
		-- Fix the value.
		self:__SetText((tonumber(text) and self:Round(tonumber(text)) or text or 0));
	end,
});
