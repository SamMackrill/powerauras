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
-- New features list stuff.
local NEWFEATURES_DESC = {
	["1.0"] = {
		[1] = "This is item #1",
		[2] = "This is item #2",
		[3] = "This is item #3",
		[4] = "This is item #4",
	},
	["1.1"] = {	
		[5] = "This is item #5",
		[6] = "This is item #6",
		[7] = "This is item #7",
		[8] = "This is item #8",
	},
}

-- OnLoad function for the browser frame.
function PowaBrowser_OnLoad(self)
	-- New features tables! Assign them!!!
	for _, version in pairs(NEWFEATURES_VERSIONS) do
		print(version);
		-- self.Tabs.NewFeatures.List:AddItem(version, format("%.2f", version/10000));
	end
	self.Tabs.NewFeatures.List:AddItem("a", "A");
	self.Tabs.NewFeatures.List:AddItem("b", "B", "a");
	self.Tabs.NewFeatures.List:AddItem("c", "C", "b");
	self.Tabs.NewFeatures.List:AddItem("d", "D", "a");
	self.Tabs.NewFeatures.List:AddItem("e", "E");
	self.Tabs.NewFeatures.List:AddItem("f", "F", "e");
	self.Tabs.NewFeatures.List:AddItem("g", "G", "e");
	self.Tabs.NewFeatures.List:AddItem("h", "H", "c");
	-- self.Tabs.NewFeatures.List:AddItem(NEWFEATURES_LIST);
end
-- The good bits.
function PowaBrowser_OnVariablesLoaded()
	local self = PowaBrowser;
	-- Do update check.
	if(tonumber(PowaAuras.Version) > PowaGlobalMisc["LastVersion"]) then
		-- Make version check tab glow!
		self.Tabs.NewFeatures.TabButton:SetGlow(true);
	end
	
	self.Tabs:SelectTab(3);
end