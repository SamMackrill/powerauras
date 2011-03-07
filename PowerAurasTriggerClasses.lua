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
	trigger.State            = false;
end);

cPowaTrigger.ExportSettings = {
	Enabled = true,
	LowerCondition = ">=5",
	UpperCondition = "<=6",
}

function cPowaTrigger:Check(value)
	local result = (value >= 5 and value <= 6);
	-- Attempt to activate our decorators.
	for dType, decorator in pairs(self.Decorators) do
		if(decorator) then
			if(result == true and PowaAuras.Auras[self.AuraId]:ApplyDecorator(dType, self.TriggerId) == true) then
				if(decorator.State == true) then
					decorator:Update(value);
				else
					decorator:Activate(value);
				end
			elseif(result == false and decorator.State == true) then
				decorator:Deactivate(value);
				PowaAuras.Auras[self.AuraId]:RemoveDecorator(dtype, self.TriggerId);
			end		
		end
	end
end

function cPowaTrigger:CreateDecorator(dType)
	-- Make the decorator class.
	local decorator = dType(self.AuraId, self.TriggerId);
	UIErrorsFrame:AddMessage("Creating " .. decorator.Type .. "Decorator (" .. self.AuraId .. ", " .. self.TriggerId .. ")", 0.0, 1.0, 0.0);
	self.Decorators[decorator.Type] = decorator;
	return true;	
end

-- -- function cPowaTrigger:RemoveDecorator(id)

-- -- end

--[[
=====cPowaTimerTrigger=====
Timer trigger type class.
===========================
--]]
cPowaTimerTrigger = PowaClass(cPowaTrigger, { Type = "Timer" });

--[[
=====cPowaDecorator========

===========================
--]]
cPowaDecorator = PowaClass(function(decorator, auraId, triggerId)
	if(not auraId or not triggerId or not PowaAuras.Auras[auraId] or not PowaAuras.Auras[auraId].Triggers[triggerId]) then return; end
	-- PowaAuras:ShowText("Constructing Decorator type " .. (decorator.Type or 0));
	-- Set up variables for trigger.
	decorator.AuraId           = auraId;
	decorator.TriggerId        = triggerId;
	decorator.State            = false;
	decorator.Value            = 0;
end);

cPowaDecorator.ExportSettings = {
	Enabled = true,
	IsGradual = true,
}

function cPowaDecorator:Activate(value)
	-- Activate me.
	self.State = true;
	self.Value = value;
	-- Update has logic for display stuff.
	self:Update(value, true);
end

function cPowaDecorator:Deactivate(value)
	self.State = false;
	self.Value = value;
	-- Final update.
	self:Update(value);
	UIErrorsFrame:AddMessage("Decorator (" .. self.AuraId .. ", " .. self.TriggerId .. ", " .. self.Type .. ") deactivating.", 1.0, 0.0, 0.0);
end

function cPowaDecorator:Update(value, firstRun)
	-- Update value.
	self.Value = value;
end

--[[
=====cPowaAuraOpacityDecorator========
Fix that later.
===========================
--]]
cPowaAuraOpacityDecorator = PowaClass(cPowaDecorator, { Type = "AuraOpacity" });

function cPowaAuraOpacityDecorator:Update(value, firstRun)
	-- Update value.
	self.Value = value;
	-- Print msg.
	if(firstRun) then
		UIErrorsFrame:AddMessage("Decorator (" .. self.AuraId .. ", " .. self.TriggerId .. ", " .. self.Type .. ") activating.", 0.0, 1.0, 0.0);
	else
		UIErrorsFrame:AddMessage("Decorator (" .. self.AuraId .. ", " .. self.TriggerId .. ", " .. self.Type .. ") updating.", 0.0, 0.0, 1.0);
	end
	-- Change opacity.
	local aura = PowaAuras.Auras[self.AuraId];
	if(not aura) then return; end
	local frame = aura:GetFrame();
	if(not frame) then return; end
	if(self.State == true) then
		frame:SetAlpha(0.25);
	else
		frame:SetAlpha(math.min(aura.alpha, 0.99));
	end
end
-- -- -- Testing script.
-- -- for i=1,4 do
   -- -- for j=1,1 do
      -- -- PowaAuras.Auras[i]:CreateTrigger(cPowaTimerTrigger);
      -- -- PowaAuras.Auras[i].Triggers[j]:CreateDecorator(cPowaAuraOpacityDecorator);
   -- -- end
-- -- end

-- -- local f = LOL or CreateFrame("Frame", "LOL", UIParent);
-- -- f.last = 0;
-- -- f:SetScript("OnUpdate", function(self, elapsed)
      -- -- f.last = f.last + elapsed;
      -- -- if(f.last > 0.1) then
         -- -- for i=1,4 do
            -- -- PowaAuras.Auras[i]:SetTriggerCheck("Timer", random(1,6));
         -- -- end
         -- -- f.last = f.last - 0.1;
      -- -- end
-- -- end);