-- Register. This is really simple :p
PowaAuras.UI:Register("TabDialog", {
	Scripts = {
		OnHide = true,
	},
	Init = function(self, acceptFunc, cancelFunc, acceptKey, cancelKey)
		-- Replace functions if supplied.
		if(acceptFunc) then
			self.OnTabDialogAccept = acceptFunc;
		end
		if(cancelFunc) then
			self.OnTabDialogCancel = cancelFunc;
		end
		-- Apply scripts.
		self.AcceptButton:SetScript("OnClick", function()
			self:OnTabDialogAccept();
			PlaySound("UChatScrollButton");
		end);
		self.CancelButton:SetScript("OnClick", function()
			self:OnTabDialogCancel();
			PlaySound("UChatScrollButton");
		end);
		-- Localize buttons.
		self.AcceptButton:SetText(PowaAuras.Text[(acceptKey or "UI_Save")]);
		self.CancelButton:SetText(PowaAuras.Text[(cancelKey or "UI_Cancel")]);
		-- When frame is hidden, assume cancellation.
		self.OnHide = self.OnTabDialogCancel;
	end,
	OnTabDialogCancel = function(self)
	end,
	OnTabDialogAccept = function(self)
	end,
});
