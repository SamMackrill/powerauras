-- Define generic button.
PowaAuras.UI:Register("Button", {
	Scripts = {
		OnDisable = "UpdateTextures",
		OnEnable = "UpdateTextures",
		OnEnter = "UpdateTextures",
		OnLeave = "UpdateTextures",
		OnMouseDown = "UpdateTextures",
		OnMouseUp = "UpdateTextures",
		OnShow = "UpdateTextures",
	},
	DisabledTexture = "Interface\\Buttons\\UI-Panel-Button-Disabled",
	PushedTexture = "Interface\\Buttons\\UI-Panel-Button-Down",
	NormalTexture = "Interface\\Buttons\\UI-Panel-Button-Up",
	Init = function(self)
		-- Update textures immediately.
		self:UpdateTextures();
	end,
	UpdateTextures = function(self)
		local state = self:GetButtonState();
		-- Priority: Disabled, Pushed, Up.
		if(not self:IsEnabled() and self.DisabledTexture) then
			-- Disabled.
			self.BackgroundLeft:SetTexture(self.DisabledTexture);
			self.BackgroundMiddle:SetTexture(self.DisabledTexture);
			self.BackgroundRight:SetTexture(self.DisabledTexture);
		elseif(self:IsMouseOver() and IsMouseButtonDown() and self.PushedTexture) then
			-- Pushed.
			self.BackgroundLeft:SetTexture(self.PushedTexture);
			self.BackgroundMiddle:SetTexture(self.PushedTexture);
			self.BackgroundRight:SetTexture(self.PushedTexture);
		elseif(self.NormalTexture) then
			self.BackgroundLeft:SetTexture(self.NormalTexture);
			self.BackgroundMiddle:SetTexture(self.NormalTexture);
			self.BackgroundRight:SetTexture(self.NormalTexture);
		end
	end,
});
