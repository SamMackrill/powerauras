-- More definitions, yes please.
PowaAuras.UI:Register("AuraEditor", {
	AdvancedElements = {}, -- It'll reference, but that's no problem. There's only 1 aura editor.
	Hooks = {
		"Show",
	},
	Init = function(self)
		-- Hide advanced elements.
		self.Advanced:SetChecked(false);
		self:ToggleAdvanced(false);
		
		-- Close on escape key.
		tinsert(UISpecialFrames, self:GetName());
	end,
	Show = function(self)
		-- Make sure this stuff is correct...
		if(not self:UpdateElements(PowaBrowser:GetSelectedAura())) then
			self:Hide();
		else
			self:__Show();
		end
	end,
	RegisterAdvanced = function(self, element)
		tinsert(self.AdvancedElements, element);
	end,
	ToggleAdvanced = function(self, state)
		for _,v in ipairs(self.AdvancedElements) do
			if(state) then
				v:Show();
			else
				v:Hide();
			end
			if(v.Parent and v.Parent.UpdateLayout) then v.Parent:UpdateLayout(); end
		end
	end,
	UpdateElements = function(self, auraID)
		-- Get the aura.
		local aura = PowaAuras.Auras[auraID];
		if(not aura) then return; end
		
		-- Update controls
		aura:UpdateTriggerTree(PowaEditorActivation.Triggers.Tree);
		
		-- Toggle advanced elements.
		self:ToggleAdvanced(self.Advanced:GetChecked());
		-- Update some values.
		-- Done.
		return true;
	end,
	AddNewTrigger = function(self)
		PowaAuras:ShowText("Add New Trigger auraId=", PowaBrowser:GetSelectedAura());
	end,
});