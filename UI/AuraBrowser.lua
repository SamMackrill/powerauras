-- New features list stuff.
local NEWFEATURES_LIST = {
	["1.0"] = {
		[1] = "TEST #1",
		[2] = "TEST #2",
		[3] = "TEST #3",
		[4] = "TEST #4",
	},
	["1.1"] = {
		[5] = "TEST #5",
		[6] = "TEST #6",
		[7] = "TEST #7",
		[8] = "TEST #8",
	},
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