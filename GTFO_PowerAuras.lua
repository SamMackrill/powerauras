--------------------------------------------------------------------------
-- GTFO_PowerAuras.lua 
--------------------------------------------------------------------------
--[[
GTFO & Power Auras Integration
Author: Zensunim of Malygos

Change Log:
	v2.1
		- Added Power Auras Integration

]]--

function GTFO_DisplayAura(iType)
	if (not PowaAuras) then return; end
	if (iType == 1) then
		PowaAuras:MarkAuras("GTFOHigh");
	elseif (iType == 2) then
		PowaAuras:MarkAuras("GTFOLow");
	elseif (iType == 3) then
		PowaAuras:MarkAuras("GTFOFail");
	elseif (iType == 4) then
		PowaAuras:MarkAuras("GTFOFriendlyFire");
	end
end