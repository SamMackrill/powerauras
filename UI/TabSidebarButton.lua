-- Create definition.
PowaAuras.UI["TabSidebarButton"] = {
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
			self:Disable();
		else
			self:Enable();
		end
	end
};
-- Register.
PowaAuras.UI:DefineWidget("TabSidebarButton");