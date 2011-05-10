-- Define generic button.
PowaAuras.UI:Register("Button", {
	Scripts = {
		OnDisable = "UpdateColors",
		OnEnable = "UpdateColors",
		OnEnter = "UpdateColors",
		OnLeave = "UpdateColors",
		OnMouseDown = true,
		OnMouseUp = true,
		OnShow = "UpdateColors",
	},
	Init = function(self)
		-- Update colours immediately.
		self:UpdateColors();
	end,
	OnMouseDown = function(self)
		-- Button state doesn't update in time.
		if(self:IsEnabled()) then
			self:SetButtonState("PUSHED");
			self:UpdateColors();
		end
	end,
	OnMouseUp = function(self)
		-- Button state doesn't update in time.
		if(self:IsEnabled()) then
			self:SetButtonState("NORMAL");
			self:UpdateColors();
		end
	end,
	UpdateColors = function(self)
		local state = self:GetButtonState();
		-- Priority: Disabled, Pushed, Up.
		if(state == "DISABLED") then
			-- Disabled.
			self.BackgroundLeft:SetTexture("Interface\\Buttons\\UI-Panel-Button-Disabled");
			self.BackgroundMiddle:SetTexture("Interface\\Buttons\\UI-Panel-Button-Disabled");
			self.BackgroundRight:SetTexture("Interface\\Buttons\\UI-Panel-Button-Disabled");
		elseif(state == "PUSHED") then
			-- Pushed.
			self.BackgroundLeft:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down");
			self.BackgroundMiddle:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down");
			self.BackgroundRight:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down");
		else
			self.BackgroundLeft:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up");
			self.BackgroundMiddle:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up");
			self.BackgroundRight:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up");
		end
	end,
});