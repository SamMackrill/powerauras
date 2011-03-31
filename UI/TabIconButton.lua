-- Create definition.
PowaAuras.UI["TabIconButton"] = {
	Init = function(tab, id, icon, parent)
		-- Stores status for tab.
		tab.Selected = false;
		tab.Id = id;
		local tex, w, h, l, r, t, b = "", 16, 16, 0, 1, 0, 1;
		if(type(icon) == "table") then
			tex, w, h, l, r, t, b = unpack(icon);
		else
			tex = icon;
		end
		tab.Icon:SetTexture(tex);
		tab.Icon:SetTexCoord(l, r, t, b);
		tab.Icon:SetWidth(w);
		tab.Icon:SetHeight(h);
		tab:SetParent(parent);
		tab:SetScript("OnClick", function()
			tab:GetParent():SelectTab(tab.Id);
		end);
	end,
	SetSelected = function(self, selected)
		if(selected == true) then
			self.Hider:Show();
			self.Highlight:Hide();
			self.TabBg:SetTexCoord(0.01562500, 0.79687500, 0.78906250, 0.953125);
		else
			self.Hider:Show();
			self.Highlight:Show();
			self.TabBg:SetTexCoord(0.01562500, 0.79687500, 0.61328125, 0.7734375);
		end
	end
};
-- Register.
PowaAuras.UI:DefineWidget("TabIconButton");