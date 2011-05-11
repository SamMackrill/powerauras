-- Basic tab button widget. Does nothing fancy.
PowaAuras.UI:Register("TabButtonBase", {
	Items = {},
	Hooks = {
		"SetChecked",
	},
	Points = {
		"BOTTOMLEFT",
		"TOPLEFT",
		0,
		0,
	},
	Orientation = "HORIZONTAL",
	Offset = 0,
	Template = "",
	Scripts = {
		OnClick = true,
	},
	Template = "",
	Construct = function(class, ui, ...)
		local item = class.Items[1];
		if(not item) then
			item = CreateFrame("CheckButton", nil, UIParent, class.Template);
			-- If the template was blank, hide the frame by default - treat it as a hidden tab.
			if(class.Template == "") then
				item:Hide();
			end
			return ui.Construct(class, ui, item, ...);
		else
			item:Init(parent, ...);
			return item;
		end
	end,
	Init = function(self, parent, frame)
		self:SetParent(parent);
		self.Frame = frame;
	end,
	GetTabIndex = function(self)
		return self.Index;
	end,
	OnClick = function(self)
		self:SetChecked(false);
		self:GetParent():SetSelectedTab(self.Index);
		PlaySound("igCharacterInfoTab");
	end,
	Recycle = function(self)
		 self:SetParent(UIParent);
		 self:ClearAllPoints();
		 self:Hide();
		 self.Frame:Hide();
		 self.Frame = nil;
		 tinsert(PowaAuras.UI.TabButtonBase.Items, self);
	end,
	SetTabIndex = function(self, index)
		self.Index = index;
	end,
	SetChecked = function(self, checked)
		-- Call normal func.
		self:__SetChecked(checked);
		-- Show/hide our frame.
		if(checked) then
			self.Frame:Show();
		else
			self.Frame:Hide();
		end
	end,
});

-- Standard tab button.
PowaAuras.UI:Register("TabButton", {
	Base = "TabButtonBase",
	Points = {
		"BOTTOMLEFT",
		"TOPLEFT",
		0,
		-2,
	},
	Offset = 117,
	Template = "PowaTabButtonTemplate",
	Init = function(self, parent, index, text, texture, width, height, left, right, top, bottom, x, y)
		-- Call parent func.
		self.Base.Init(self, parent, index);
		-- Set text.
		self.Text:SetText(text);
		-- Displaying an icon?
		if(texture) then
			-- Reposition the text.
			self.Text:SetPoint("LEFT", 39, -4);
			self.Text:SetPoint("RIGHT", -35, -4);
			-- Set up icon.
			self.Icon:SetTexture(texture);
			self.Icon:SetSize(width or 24, height or 24);
			self.Icon:SetTexCoord(left or 0, right or 1, top or 0, bottom or 1);
			self.Icon:SetPoint("LEFT", x or 13, y or -4);
			self.Icon:Show();
		else
			-- Fine.
			self.Icon:Hide();
		end
	end,
	SetChecked = function(self, checked)
		-- Call parent func.
		self.Base.SetChecked(self, checked);
		-- Style.
		if(checked == true) then
			-- Texture stuff.
			self.TabBgL:SetTexCoord(0.01562500, 0.25, 0.78906250, 0.93359375);
			self.TabBgM:SetTexCoord(0.25, 0.25, 0.78906250, 0.93359375);
			self.TabBgR:SetTexCoord(0.625, 0.79687500, 0.78906250, 0.93359375);
			self.HighlightL:Hide();
			self.HighlightM:Hide();
			self.HighlightR:Hide();
			self:Disable();
		else
			-- Texture stuff.
			self.TabBgL:SetTexCoord(0.01562500, 0.25, 0.61328125, 0.75390625);
			self.TabBgM:SetTexCoord(0.25, 0.25, 0.61328125, 0.75390625);
			self.TabBgR:SetTexCoord(0.625, 0.79687500, 0.61328125, 0.75390625);
			self.HighlightL:Show();
			self.HighlightM:Show();
			self.HighlightR:Show();
			self:Enable();
		end
	end,
});