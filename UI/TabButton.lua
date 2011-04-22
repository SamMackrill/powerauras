-- Create definition.
PowaAuras.UI:Register("TabButton", {
	Init = function(tab, id, text, parent)
		-- Stores status for tab.
		tab.Selected = false;
		tab.Id = id;
		tab:SetText(PowaAuras.Text[text]);
		tab:SetParent(parent);
		tab:SetScript("OnClick", function()
			tab:GetParent():SelectTab(tab.Id);
		end);
	end,
	SetSelected = function(self, selected)
		if(selected == true) then
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
	end
});