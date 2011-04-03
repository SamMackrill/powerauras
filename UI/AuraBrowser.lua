-- New features list stuff.
local NEWFEATURES_VERSIONS = {
	50000,
	41700,
	41600,
	41400,
	41300,
	41200,
	41100,
	41000,
	40900,
	40800,
	40700,
	40600,
	40500,
	40400,
	40300,
	40200,
	40100,
	40000,
}

local NEWFEATURES_VERSIONS_DESC = {
}

-- OnLoad function for the browser frame.
function PowaBrowser_OnLoad(self)
	-- New features tables! Assign them!!!
	for _, version in pairs(NEWFEATURES_VERSIONS) do
		self.Tabs.NewFeatures.List:AddItem(version, format("%.2f", version/10000));
	end
	print(self.Tabs.NewFeatures.List.Scroll:GetName());
	-- -- self.Tabs.NewFeatures.List:AddItem(1, 1);
	-- -- self.Tabs.NewFeatures.List:AddItem(2, 2, 1);
	-- -- self.Tabs.NewFeatures.List:AddItem(3, 3, 1);
	-- -- self.Tabs.NewFeatures.List:AddItem(4, 4, 2);
	-- -- self.Tabs.NewFeatures.List:AddItem(5, 5, 4);
	-- -- self.Tabs.NewFeatures.List:AddItem(6, 6, 2);
	-- -- self.Tabs.NewFeatures.List:AddItem(7, 7, 4);
	-- -- self.Tabs.NewFeatures.List:AddItem(8, 8, 2);
	-- -- self.Tabs.NewFeatures.List:AddItem(9, 9, 5);
	-- -- self.Tabs.NewFeatures.List:AddItem(10, 10, 5);
	-- -- self.Tabs.NewFeatures.List:AddItem(11, 11, 10);
	-- -- self.Tabs.NewFeatures.List:AddItem(12, 12, 11);
	-- -- self.Tabs.NewFeatures.List:AddItem(13, 13, 5);
	-- -- self.Tabs.NewFeatures.List:AddItem(14, 14, 5);
	-- -- self.Tabs.NewFeatures.List:AddItem(15, 15);
	-- -- self.Tabs.NewFeatures.List:AddItem(16, 16);
	-- -- self.Tabs.NewFeatures.List:AddItem(17, 17, 16);
	-- -- self.Tabs.NewFeatures.List:AddItem(18, 18, 17);
	-- -- self.Tabs.NewFeatures.List:AddItem(19, 19, 16);
	-- -- self.Tabs.NewFeatures.List:AddItem(20, 20, 18);
	-- -- self.Tabs.NewFeatures.List:AddItem(21, 21);
end
-- The good bits.
function PowaBrowser_OnVariablesLoaded()
	local self = PowaBrowser;
	-- Do update check.
	if(tonumber(PowaAuras.Version) > PowaGlobalMisc["LastVersion"]) then
		-- Make version check tab glow!
		self.Tabs.NewFeatures.TabButton:SetGlow(true);
	end
end