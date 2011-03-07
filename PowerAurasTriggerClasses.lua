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
	-- UIErrorsFrame:AddMessage("Checking " .. self.Type .. "Trigger (" .. self.AuraId .. "," .. self.TriggerId .. ") against value " .. value, 1.0, 0.0, 0.0);
	value = math.random(2, 100);
	if(value == 2) then return 2; end
	if(value == 1) then return 1; end
	return false;
end

-- Test script (run ingame)
-- -- GLOBALCOUNTVAR = 25;

-- -- for i=1,4 do
   -- -- for j=1,10 do
      -- -- PowaAuras.Auras[i]:CreateTrigger(cPowaTimerTrigger);
   -- -- end
-- -- end

-- -- local f = LOL or CreateFrame("Frame", "LOL", UIParent);
-- -- f.last = 0;
-- -- f:SetScript("OnUpdate", function(self, elapsed)
      -- -- f.last = f.last + elapsed;
      -- -- if(f.last > 0.001) then
         -- -- for i=1,4 do
            -- -- PowaAuras.Auras[i]:SetTriggerCheck("Timer", random(1,100));
         -- -- end
         -- -- f.last = f.last - 0.001;
      -- -- end
-- -- end);