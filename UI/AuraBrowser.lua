-- OnLoad function for the browser frame.
function PowaBrowser_OnLoad(self)
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
	if(PowaAuras.VersionInt > PowaGlobalMisc["LastVersion"]) then
		self.ShowVersionDialog = true;
	end
	-- First run check.
	if(PowaGlobalMisc["FirstRun"] == true) then
		self.ShowRunDialog = true;
		PowaGlobalMisc["FirstRun"] = false;
	end
end