-- Create definition.
PowaAuras.UI["FrameSeparator"] = {
	Init = function(frame, text)
		-- Go go go.
		frame:SetText(text or "");
	end,
	SetText = function(self, text)
		self.Text:SetText(PowaAuras.Text[text]);
	end
};
-- Register.
PowaAuras.UI:DefineWidget("FrameSeparator");