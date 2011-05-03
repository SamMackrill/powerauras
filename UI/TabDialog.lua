-- Register. This is really simple :p
PowaAuras.UI:Register("TabDialog", {
	Scripts = {
		"OnHide",
	},
	Init = function(self, acceptKey, cancelKey)
		self.AcceptButton:SetScript("OnClick", function()
			self:OnAccept();
			PlaySound("UChatScrollButton");
		end);
		self.CancelButton:SetScript("OnClick", function()
			self:OnCancel();
			PlaySound("UChatScrollButton");
		end);
		self.AcceptButton:SetText(PowaAuras.Text[(acceptKey or "UI_Save")]);
		self.CancelButton:SetText(PowaAuras.Text[(cancelKey or "UI_Cancel")]);
		self.OnHide = self.OnCancel;
	end,
	OnCancel = function(self)
	end,
	OnAccept = function(self)
	end,
});