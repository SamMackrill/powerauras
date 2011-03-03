--[[
------------------------------------------------------------------------------------------------------------------------
PowerTriggers.lua

Author: Daniel Yates <dyates92@gmail.com>

Implements basic Trigger functionality into PowerAuras. I would have put this in an existing file, but I hit the booze
after you left.
------------------------------------------------------------------------------------------------------------------------
--]]
PowaTriggers = {
	Conditions = {
		TIMER       = 1,
		STACKS      = 2,
		AURA_START  = 3,
		AURA_END    = 4,
		ANIM_START  = 5,
		ANIM_END    = 6,
	},
	Triggers = {},
}

-- Populate the other two tables.
for _, index in pairs(PowaTriggers.Conditions) do
	tinsert(PowaTriggers.Triggers, index, {[0] = 0}); -- Index 0 stores a count, faster than using # a lot.
end

-- Checks for the existance of any triggers belonging to the specified condition.
function PowaTriggers:HasTriggers(condition)
	if(not self.Triggers[condition] or self.TriggerCount[condition] == 0) then return false; else return true; end	
end

-- Checks for the existance of a specific trigger belonging to a specified condition.
function PowaTriggers:HasTrigger(condition, triggerId)
	if(self:HasTriggers(condition) == false) then return false; end
	if(self.Triggers[condition][triggerId]) then return true; else return false; end	
end

-- Attempts to fire any registered triggers for the given condition.
function PowaTriggers:FireTrigger(condition, value)
	-- Check trigger existance.
	if(self:HasTrigger(condition) == false) then return false; end
	-- Go over triggers.
	for triggerId, auraId in pairs(self.Triggers[condition]) do
		-- Fire it.
		if(PowaAuras.Auras[auraId]) then PowaAuras.Auras[auraId]:FireTrigger(triggerId, value); end
	end
	return true;
end

-- Registers a trigger.
function PowaTriggers:AddTrigger(condition, triggerId, auraId)
	if(triggerId == 0 or self:HasTrigger(condition, triggerId) == true) then return false; end
	-- Add the trigger.
	tinsert(self.Triggers[condition], triggerId, auraId);
	self.Triggers[condition][0] = self.Triggers[condition][0] + 1;
	return true;
end

-- Unregisters a trigger.
function PowaTriggers:RemoveTrigger(condition, triggerId, auraId)
	if(triggerId == 0 or self:HasTrigger(condition, triggerId) == false) then return false; end
	-- Remove the trigger.
	tremove(self.Triggers[condition], triggerId);
	self.Triggers[condition][0] = self.Triggers[condition] - 1;
	return true;
end

-- Accessible through PowaAuras.Triggers;
PowaAuras["Triggers"] = PowaTriggers;