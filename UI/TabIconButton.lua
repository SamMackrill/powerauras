-- Create definition.
PowaAuras.UI["TabIconButton"] = {
	Init = function(self, id, icon, parent)
		-- Stores status for tab.
		self.Selected = false;
		self.Id = id;
		local tex, w, h, l, r, t, b = "", 16, 16, 0, 1, 0, 1;
		if(type(icon) == "table") then
			tex, w, h, l, r, t, b = unpack(icon);
		else
			tex = icon;
		end
		self.Icon:SetTexture(tex);
		self.Icon:SetTexCoord(l, r, t, b);
		self.Icon:SetWidth(w);
		self.Icon:SetHeight(h);
		self:SetParent(parent);
		self:SetScript("OnClick", function()
			self:GetParent():SelectTab(self.Id);
		end);
	end,
	SetGlow = function(self, glow)
		if(glow == true) then
			self.Glow.StartAnimation:Play();
		else
			self.Glow.MainAnimation.Loop = false;		
		end
		self.Glowing = glow;
	end,
	SetSelected = function(self, selected)
		if(selected == true) then
			self.Highlight:Hide();
			self.TabBg:SetTexCoord(0.01562500, 0.79687500, 0.78906250, 0.953125);
		else
			if(not self.Glowing) then
				self.Highlight:Show();
			end
			self.TabBg:SetTexCoord(0.01562500, 0.79687500, 0.61328125, 0.7734375);
		end
		self.Selected = selected;
	end
};
-- Register.
PowaAuras.UI:DefineWidget("TabIconButton");