function PowaAuras:RegisterAdvancedElement(element)
	tinsert(PowaAuras.UI.AdvancedElements, (element:GetName() or element));
end

function PowaAuras:ToggleAdvancedElements(state)
	for i,v in pairs(PowaAuras.UI.AdvancedElements) do
		if(type(v) == "string") then v = _G[v]; end
		if(state == true) then v:Show(); else v:Hide(); end
		if(v:GetParent().UpdateLayout) then v:GetParent():UpdateLayout(); end
	end
end

function PowaAuras:ShowAuraEditor()
	-- Make sure advanced things are shown/hidden.
	PowaAuras:ToggleAdvancedElements(PowaEditor.Advanced:GetChecked());
end