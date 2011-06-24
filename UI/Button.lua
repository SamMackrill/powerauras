-- Define generic button.
PowaAuras.UI:Register("Button", {
	Scripts = {
		OnDisable = "UpdateTextures",
		OnEnable = "UpdateTextures",
		OnEnter = "UpdateTextures",
		OnLeave = "UpdateTextures",
		OnMouseDown = true,
		OnMouseUp = true,
		OnShow = "UpdateTextures",
	},
	DisabledTexture = "Interface\\Buttons\\UI-Panel-Button-Disabled",
	PushedTexture = "Interface\\Buttons\\UI-Panel-Button-Down",
	NormalTexture = "Interface\\Buttons\\UI-Panel-Button-Up",
	HighlightTexture = nil,
	Init = function(self)
		-- Update textures immediately.
		self:UpdateTextures();
	end,
	OnMouseDown = function(self)
		-- Button state doesn't update in time.
		if(self:IsEnabled()) then
			self:SetButtonState("PUSHED");
			self:UpdateTextures();
		end
	end,
	OnMouseUp = function(self)
		-- Button state doesn't update in time.
		if(self:IsEnabled()) then
			self:SetButtonState("NORMAL");
			self:UpdateTextures();
		end
	end,
	UpdateTextures = function(self)
		local state = self:GetButtonState();
		-- Priority: Disabled, Pushed, Up.
		if(state == "DISABLED" and self.DisabledTexture) then
			-- Disabled.
			self.BackgroundLeft:SetTexture(self.DisabledTexture);
			self.BackgroundMiddle:SetTexture(self.DisabledTexture);
			self.BackgroundRight:SetTexture(self.DisabledTexture);
		elseif(state == "PUSHED" and self.PushedTexture) then
			-- Pushed.
			self.BackgroundLeft:SetTexture(self.PushedTexture);
			self.BackgroundMiddle:SetTexture(self.PushedTexture);
			self.BackgroundRight:SetTexture(self.PushedTexture);
		elseif(state == "HIGHLIGHT" and self.HighlightTexture) then
			-- Highlight (optional).
			self.BackgroundLeft:SetTexture(self.HighlightTexture);
			self.BackgroundMiddle:SetTexture(self.HighlightTexture);
			self.BackgroundRight:SetTexture(self.HighlightTexture);
		elseif(self.NormalTexture) then
			self.BackgroundLeft:SetTexture(self.NormalTexture);
			self.BackgroundMiddle:SetTexture(self.NormalTexture);
			self.BackgroundRight:SetTexture(self.NormalTexture);
		end
	end,
});
