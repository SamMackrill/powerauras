-- More definitions, yes please.
PowaAuras.UI:Register("AuraEditor", {
	Hooks = {
		"Show",
		"Hide",
	},
	Init = function(self)
		-- Hide advanced elements.
		self.Advanced:SetChecked(false);
		self:ToggleAdvanced(false);
	end,
	Hide = function(self)
	
	end,
	Show = function(self)
		-- Make sure this stuff is correct...
		self:ToggleAdvanced(self.Advanced:GetChecked());		
	end,
	ToggleAdvanced = function(self, state, parent)
		-- Make sure a parent is specified.
		if(not parent) then parent = self; end
		-- Needs a GetChildren function.
		if(not parent.GetChildren) then return; end
		-- Go over children.
		for _, child in ipairs({ parent:GetChildren() }) do
			-- Is it flagged as advanced?
			if(child.GetFlag and child:GetFlag(0x1)) then
				if(state) then
					child:Show();
				else
					child:Hide();
				end
			end
			-- Go over the children of this element...
			self:ToggleAdvanced(state, child);
		end
	end,
});