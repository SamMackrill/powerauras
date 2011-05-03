-- Create definition.
PowaAuras.UI:Register("TabSidebarButton", {
	Init = function(tab, id, text, parent)
		-- Stores status for tab.
		tab.Selected = false;
		tab.Id = id;
		tab:SetText(PowaAuras.Text[text]);
		tab:SetParent(parent);
		tab:SetScript("OnClick", function()
			tab:GetParent():SelectTab(tab.Id);
			PlaySound("igCharacterInfoTab");
		end);
	end,
	SetSelected = function(self, selected)
		if(selected == true) then
			self:Disable();
		else
			self:Enable();
		end
	end
});