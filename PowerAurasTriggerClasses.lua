--[[
=======cPowaTrigger========
Base class for Trigger Types.
===========================
--]]
cPowaTrigger = PowaClass(function(trigger, auraId, triggerId)
	if(not auraId or not triggerId or not PowaAuras.Auras[auraId]) then return; end
	-- PowaAuras:ShowText("Constructing Trigger type " .. (trigger.Type or 0));
	-- Set up variables for trigger.
	trigger.AuraId     = auraId;
	trigger.TriggerId  = triggerId;
	trigger.Decorators = {};
	trigger.State      = false;
end);

function cPowaTrigger:Check(value)
	return false;
end
--[[
=====cPowaTimerTrigger=====
Timer trigger type class.
===========================
--]]
cPowaTimerTrigger = PowaClass(cPowaTrigger, { Type = "Timer" });

function cPowaTimerTrigger:Check(value)
	-- PowaAuras:ShowText("Checking timer trigger (" .. self.AuraId .. "," .. self.TriggerId .. ") against value " .. value);
	return false;
end