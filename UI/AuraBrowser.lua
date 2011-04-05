-- OnLoad function for the browser frame.
function PowaBrowser_OnLoad(self)
	-- -- self.Tabs.Auras.Tree:AddItem(1, 1);
	-- -- self.Tabs.Auras.Tree:AddItem(2, 2, 1);
	-- -- self.Tabs.Auras.Tree:AddItem(3, 3, 1);
	-- -- self.Tabs.Auras.Tree:AddItem(4, 4, 2);
	-- -- self.Tabs.Auras.Tree:AddItem(5, 5, 4);
	-- -- self.Tabs.Auras.Tree:AddItem(6, 6, 2);
	-- -- self.Tabs.Auras.Tree:AddItem(7, 7, 4);
	-- -- self.Tabs.Auras.Tree:AddItem(8, 8, 2);
	-- -- self.Tabs.Auras.Tree:AddItem(9, 9, 5);
	-- -- self.Tabs.Auras.Tree:AddItem(10, 10, 5);
	-- -- self.Tabs.Auras.Tree:AddItem(11, 11, 10);
	-- -- self.Tabs.Auras.Tree:AddItem(12, 12, 11);
	-- -- self.Tabs.Auras.Tree:AddItem(13, 13, 5);
	-- -- self.Tabs.Auras.Tree:AddItem(14, 14, 5);
	-- -- self.Tabs.Auras.Tree:AddItem(15, 15);
	-- -- self.Tabs.Auras.Tree:AddItem(16, 16);
	-- -- self.Tabs.Auras.Tree:AddItem(17, 17, 16);
	-- -- self.Tabs.Auras.Tree:AddItem(18, 18, 17);
	-- -- self.Tabs.Auras.Tree:AddItem(19, 19, 16);
	-- -- self.Tabs.Auras.Tree:AddItem(20, 20, 18);
	-- -- self.Tabs.Auras.Tree:AddItem(21, 21);
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
	self.Tabs.Auras.Tree:AddItem("CHAR", PowaAuras.Text["UI_CharAuras"], nil, nil, true);
	for i=1,playerPageCount do
		self.Tabs.Auras.Tree:AddItem(i, PowaPlayerListe[i], "CHAR");
	end
	self.Tabs.Auras.Tree:AddItem("CLASS", PowaAuras.Text["UI_ClassAuras"], nil, nil, true);
	for i=1,classPageCount do
		self.Tabs.Auras.Tree:AddItem(i+playerPageCount, PowaClassListe[class][i], "CLASS");
	end
	self.Tabs.Auras.Tree:AddItem("GLOBAL", PowaAuras.Text["UI_GlobAuras"], nil, nil, true);
	for i=1,globalPageCount do
		self.Tabs.Auras.Tree:AddItem(i+playerPageCount+classPageCount, PowaGlobalListe[i], "GLOBAL");
	end
end