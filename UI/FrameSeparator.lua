-- Create definition.
PowaAuras.UI:Register("FrameSeparator", {
	Init = function(self, text, key)
		-- Go go go.
		self:SetText(text or "");
		-- Expand state.
		self.Key = key;
		self.Children = {};
		-- Add some scripts...
		self:SetScript("OnEnter", self.OnEnter);
		self:SetScript("OnLeave", self.OnLeave);
		self:SetScript("OnMouseUp", self.OnMouseUp);
		self:SetScript("OnShow", self.OnShow);
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
		self.State = (PowaGlobalMisc["EditorCategoryState"][self.Key] == nil and true or PowaGlobalMisc["EditorCategoryState"][self.Key]);
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
			self.Text:SetFontObject(GameFontNormal);
			self:UpdateColors();
		else
			self.Expand:SetTexCoord(0, 0.5, 0, 0.5);
			self.Text:SetFontObject(GameFontDisable);
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
			if(self:IsMouseOver()) then
				self.Line:SetVertexColor(1.0, 0.82, 0, 1);
			else
				self.Line:SetVertexColor(1.0, 0.82, 0, 0.8);
			end
		else
			if(self:IsMouseOver()) then
				self.Line:SetVertexColor(0.3, 0.3, 0.3, 1);
			else
				self.Line:SetVertexColor(0.3, 0.3, 0.3, 0.8);
			end
		end
	end
});