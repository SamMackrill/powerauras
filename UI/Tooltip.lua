-- Create definition.
PowaAuras.UI:Register("Tooltip", {
	PreInit = function(self, frame, title, text, children)
		-- Store data.
		frame.TooltipTitle = PowaAuras.Text[title];
		frame.TooltipText = PowaAuras.Text[text];
		-- Copy our functions over manually if needed.
		if(not frame.TooltipRefresh) then
			frame.TooltipRefresh = self.TooltipRefresh;
		end
		if(not frame.TooltipLeave) then
			frame.TooltipLeave = self.TooltipLeave;
		end
		-- Use the RefreshTooltip function as a display method.
		self:ApplyScript(frame, "OnEnter", frame.TooltipRefresh);
		self:ApplyScript(frame, "OnLeave", frame.TooltipLeave);
		-- Add to children too.
		if(children) then
			for _, child in pairs(children) do
				self:ApplyScript(frame[child], "OnEnter", function() frame:TooltipRefresh(); end);
				self:ApplyScript(frame[child], "OnLeave", function() frame:TooltipLeave(); end);
			end
		end
		-- We force the widget initializer to skip copying our functions over.
		return;
	end,
	TooltipRefresh = function(self)
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
	TooltipLeave = function(self)
		GameTooltip:Hide();
	end,
	ApplyScript = function(self, frame, script, callback)
		-- Prevents overwriting scripts.
		if(not frame.GetScript) then return; end
		if(frame:GetScript(script)) then
			frame:HookScript(script, callback);
		else
			frame:SetScript(script, callback);
		end
	end
});