-- Create definition.
PowaAuras.UI["Tooltip"] = {
	Init = function(frame, title, text, children)
		-- Store data.
		frame.TooltipTitle = PowaAuras.Text[title];
		frame.TooltipText = PowaAuras.Text[text];
		-- Use the RefreshTooltip function as a display method.
		frame:ApplyScript(frame, "OnEnter", frame.Refresh);
		frame:ApplyScript(frame, "OnLeave", frame.Leave);
		-- Add to children too.
		if(children) then
			for _, child in pairs(children) do
				frame:ApplyScript(frame[child], "OnEnter", function() frame:Refresh(); end);
				frame:ApplyScript(frame[child], "OnLeave", function() GameTooltip:Hide(); end);
			end
		end
	end,
	Refresh = function(self)
		-- Hide tip.
		GameTooltip:Hide();
		-- Reparent.
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0);
		-- Set back up.
		GameTooltip:SetText(self.TooltipTitle or "");
		GameTooltip:AddLine(self.TooltipText or "", 1, 1, 1, true);
		-- Show tip.
		GameTooltip:Show();
	end,
	Leave = function(self)
		GameTooltip:Hide();
	end,
	ApplyScript = function(self, frame, script, callback)
		-- Prevents overwriting scripts.
		if(not frame.HasScript) then return; end
		if(frame:HasScript(script)) then
			frame:HookScript(script, callback);
		else
			frame:SetScript(script, callback);
		end
	end
};
-- Register.
PowaAuras.UI:DefineWidget("Tooltip");