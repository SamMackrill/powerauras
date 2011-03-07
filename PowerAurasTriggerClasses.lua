--[[
=======cPowaTrigger========
Base class for Trigger Types.
===========================
--]]
cPowaTrigger = PowaClass(function(trigger, auraId, triggerId)
	if(not auraId or not triggerId or not PowaAuras.Auras[auraId]) then return; end
	-- PowaAuras:ShowText("Constructing Trigger type " .. (trigger.Type or 0));
	-- Set up variables for trigger.
	trigger.AuraId           = auraId;
	trigger.TriggerId        = triggerId;
	trigger.Decorators       = {};
	trigger.DecoratorsByType = {};
	trigger.State            = false;
	
	for decorator, _ in pairs(PowaAuras.TriggerDecorators) do
		trigger.DecoratorsByType[decorator] = {};
	end	
end);

cPowaTrigger.ExportSettings = {
	Enabled = true,
	LowerCondition = ">=5",
	UpperCondition = "<=6",
}
-- Got bored, did some testing for implementing multiple condition checks.
function cPowaTrigger:UpdateCondition()
	-- -- -- Matches this: >=5 & < 500 & (>= 60 | <= 80 & (== 52 | != 51)
	-- -- local regex = "(%s*([&|]?)%s*(%(*)%s*([<>=!]+)%s*([0-9]+)%s*(%)*))";
	-- -- -- Remove pre-existing conditions.
	-- -- wipe(self.Condition);
	-- -- for full, join, paren_open, operator, value, paren_end in string.gmatch(self.ExportSettings.Condition, regex) do
		-- -- -- Sanity check.
		-- -- if(operator == "==" or operator == ">=" or operator == "<=" or operator == "<" or operator == ">" or operator == "!=") then
			-- -- tinsert(self.Condition, { 
				-- -- Operator = operator,
				-- -- OpenDepth = strlen(paren_open or ""),
				-- -- CloseDepth = strlen(paren_end or ""),
				-- -- Value = value,
				-- -- Join = join
			-- -- });
		-- -- end
	-- -- end
end

function cPowaTrigger:Check(value)
	
	
	
	return false;
end

function cPowaTrigger:CreateDecorator(dType)

end

function cPowaTrigger:RemoveDecorator(id)

end

--[[
=====cPowaTimerTrigger=====
Timer trigger type class.
===========================
--]]
cPowaTimerTrigger = PowaClass(cPowaTrigger, { Type = "Timer" });

-- -- function cPowaTimerTrigger:Check(value)
	-- -- -- UIErrorsFrame:AddMessage("Checking " .. self.Type .. "Trigger (" .. self.AuraId .. "," .. self.TriggerId .. ") against value " .. value, 1.0, 0.0, 0.0);
	-- -- return false;
-- -- end