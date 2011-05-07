-- Create definition.
-- To be replaced.
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

PowaAuras.UI:Register("EditBox2", {
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
	Init = function(self, title, setting)
		-- Settings mixin.
		self.OnSettingChanged = self.SetText;
		PowaAuras.UI:Settings(self, setting);
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
	SetTitle = function(self, title)
		self.Title:SetText(PowaAuras.Text[title]);
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