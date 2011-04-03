-- OnLoad function for the browser frame.
function PowaBrowser_OnLoad(self)
	-- -- self.Tabs.Auras.List:AddItem(1, 1);
	-- -- self.Tabs.Auras.List:AddItem(2, 2, 1);
	-- -- self.Tabs.Auras.List:AddItem(3, 3, 1);
	-- -- self.Tabs.Auras.List:AddItem(4, 4, 2);
	-- -- self.Tabs.Auras.List:AddItem(5, 5, 4);
	-- -- self.Tabs.Auras.List:AddItem(6, 6, 2);
	-- -- self.Tabs.Auras.List:AddItem(7, 7, 4);
	-- -- self.Tabs.Auras.List:AddItem(8, 8, 2);
	-- -- self.Tabs.Auras.List:AddItem(9, 9, 5);
	-- -- self.Tabs.Auras.List:AddItem(10, 10, 5);
	-- -- self.Tabs.Auras.List:AddItem(11, 11, 10);
	-- -- self.Tabs.Auras.List:AddItem(12, 12, 11);
	-- -- self.Tabs.Auras.List:AddItem(13, 13, 5);
	-- -- self.Tabs.Auras.List:AddItem(14, 14, 5);
	-- -- self.Tabs.Auras.List:AddItem(15, 15);
	-- -- self.Tabs.Auras.List:AddItem(16, 16);
	-- -- self.Tabs.Auras.List:AddItem(17, 17, 16);
	-- -- self.Tabs.Auras.List:AddItem(18, 18, 17);
	-- -- self.Tabs.Auras.List:AddItem(19, 19, 16);
	-- -- self.Tabs.Auras.List:AddItem(20, 20, 18);
	-- -- self.Tabs.Auras.List:AddItem(21, 21);
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
		-- Don't bother showing the version upgrade dialog if it's the first run.
		self.ShowVersionDialog = false;
	end
	-- Add appropriate items to trees.
	-- (The code here will allow for as many pages of whatever type including class-specific auras, but it likely won't be fully implemented for a while).
	local class = UnitClass("player");
	if(not PowaClassListe) then PowaClassListe = {}; end
	if(not PowaClassListe[class]) then
		PowaClassListe[class] = {};
		for i=1,5 do
			PowaClassListe[class][i] = "Class " .. i;
		end
	end
	-- Counts.
	local playerPageCount, globalPageCount, classPageCount = #(PowaPlayerListe), #(PowaGlobalListe), #(PowaClassListe[class]);
	self.Tabs.Auras.List:AddItem("CHAR", PowaAuras.Text["UI_CharAuras"]);
	for i=1,playerPageCount do
		self.Tabs.Auras.List:AddItem(i, PowaPlayerListe[i], "CHAR");
	end
	self.Tabs.Auras.List:AddItem("CLASS", PowaAuras.Text["UI_ClassAuras"]);
	for i=1,classPageCount do
		self.Tabs.Auras.List:AddItem(i+playerPageCount, PowaClassListe[class][i], "CLASS");
	end
	self.Tabs.Auras.List:AddItem("GLOBAL", PowaAuras.Text["UI_GlobAuras"]);
	for i=1,globalPageCount do
		self.Tabs.Auras.List:AddItem(i+playerPageCount+classPageCount, PowaGlobalListe[i], "GLOBAL");
	end
end