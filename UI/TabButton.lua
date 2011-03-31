-- Create definition.
PowaAuras.UI["TabButton"] = {
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
			self:SetHighlightTexture(nil);
			self:SetNormalFontObject("GameFontHighlightSmall");
			self:SetNormalTexture("Interface\\PaperDollInfoFrame\\UI-Character-ActiveTab");
			self:GetNormalTexture():SetTexCoord(0, 1, 0.606875, 0.05);
			self:Disable();
		else
			self:SetNormalTexture("Interface\\PaperDollInfoFrame\\UI-Character-InActiveTab");
			self:GetNormalTexture():SetTexCoord(0, 1, 1, 0);
			self:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-RealHighlight", "ADD");
			self:GetHighlightTexture():SetPoint("TOPLEFT", self, "TOPLEFT", 0, -7);
			self:GetHighlightTexture():SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0);
			self:GetHighlightTexture():SetTexCoord(0, 1, 0.2, 0.6);
			self:SetNormalFontObject("GameFontNormalSmall");
			self:Enable();
		end
	end
};
-- Register.
PowaAuras.UI:DefineWidget("TabButton");