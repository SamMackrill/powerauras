-- Create definition.
PowaAuras.UI:Register("FrameSeparator", {
	Init = function(self, text, key)
		-- Go go go.
		self:SetText(text or "");
		-- Expand state.
		self.Key = key;
		self.Children = {};
		self.State = true;
		-- Add some scripts if needed.
		if(key) then
			self:SetScript("OnEnter", self.OnEnter);
			self:SetScript("OnLeave", self.OnLeave);
			self:SetScript("OnMouseUp", self.OnMouseUp);
			self:SetScript("OnShow", self.OnShow);
		end
	end,
	AddChild = function(self, child)
		tinsert(self.Children, child);
		self:ToggleExpand(self.State);
	end,
	OnEnter = function(self)
		self.Expand:Show();
		self:UpdateColors();
	end,
	OnLeave = function(self)
		self.Expand:Hide();
		self:UpdateColors();
	end,
	OnMouseUp = function(self)
		if(self.State == true) then
			self:ToggleExpand(false);
		else
			self:ToggleExpand(true);		
		end
	end,
	OnShow = function(self)
		-- Update state!
		if(not self.Key) then
			self.State = true;
		else
			self.State = (PowaGlobalMisc["EditorCategoryState"][self.Key] == nil and true or PowaGlobalMisc["EditorCategoryState"][self.Key]);
		end
		self:ToggleExpand(self.State);
	end,
	SetText = function(self, text)
		self.Text:SetText(PowaAuras.Text[text]);
	end,
	ToggleExpand = function(self, state)
		-- Save state.
		self.State = state;
		if(self.Key) then
			PowaGlobalMisc["EditorCategoryState"][self.Key] = state;
		end
		-- Change things depending on state.
		if(state == true) then
			self.Expand:SetTexCoord(0.5, 1, 0, 0.5);
			self.Text:SetFontObject(PowaFontNormal);
			self:UpdateColors();
		else
			self.Expand:SetTexCoord(0, 0.5, 0, 0.5);
			self.Text:SetFontObject(PowaFontDisable);
			self:UpdateColors();
		end
		-- Show/Hide children.
		for _, child in pairs(self.Children) do
			if(state == true) then child:Show(); else child:Hide(); end
		end
		-- Update positioning of parent if needed.
		if(self:GetParent().UpdateLayout) then self:GetParent():UpdateLayout(); end
	end,
	UpdateColors = function(self)
		if(self.State == true) then
			if(self:IsMouseOver() or not self.Key) then
				self.Line:SetVertexColor(1.0, 0.82, 0, 1);
			else
				self.Line:SetVertexColor(1.0, 0.82, 0, 0.8);
			end
		else
			if(self:IsMouseOver() or not self.Key) then
				self.Line:SetVertexColor(0.3, 0.3, 0.3, 1);
			else
				self.Line:SetVertexColor(0.3, 0.3, 0.3, 0.8);
			end
		end
	end
});