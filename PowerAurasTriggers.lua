--[[
=======cPowaTrigger========
Base class for Trigger Types.
===========================
--]]
cPowaTrigger = PowaClass(function(trigger, auraId, triggerId, parameters)
	if(not auraId or not triggerId or not PowaAuras.Auras[auraId]) then return; end
	if (PowaAuras.DebugTriggers) then
		PowaAuras:DisplayText("Constructing Trigger type ", trigger.Type);
	end
	trigger.Id               = triggerId;
	trigger.AuraId           = auraId;
	trigger.Actions          = {};
	trigger.Name             = parameters.Name;
	trigger.Value            = parameters.Value;
	trigger.Qualifier        = parameters.Qualifier;
	trigger.CompareOperator  = parameters.Compare;
	trigger.Debug            = parameters.Debug;
	trigger.Set              = false;
	trigger.NextActionId     = 1;
end);


function cPowaTrigger:ResetActions()
	for i = 1, #self.Actions do
		local action = self.Actions[i];
		action:Reset();
	end
end

function cPowaTrigger:AddAction(actionClass, parameters)
	local action = actionClass(self, self.NextActionId, parameters);
	self.NextActionId = self.NextActionId + 1;
	if (PowaAuras.DebugTriggers or self.Debug) then
		PowaAuras:DisplayText("Creating ", action.Type, " Action - Aura=", self.AuraId, " Trigger=", self.Id, " Action=", action.Id, " name=", action.Name);
	end
	table.insert(self.Actions, action);
	return action;	
end

function cPowaTrigger:DeleteAction(action)
	if (not action) then return; end
	for index, a in ipairs (self.Actions) do
		if (action.Id==a.Id) then
			table.remove(self.Actions, index);
			break;
		end
	end
end

function cPowaTrigger:Check(value, qualifier)
	if (self.Timer) then
		local aura = PowaAuras.Auras[self.AuraId];
		if (not aura.Timer or not aura.Timer.Active) then
			self.Set = false;
			return false;
		end
	end
	if (not self:CheckQulifier(qualifier)) then return false; end
	local result = self:Compare(self.CompareOperator, value, self.Value);
	--if (PowaAuras.DebugTriggers or self.Debug) then
	--	PowaAuras:DisplayText("Check result=", result);
	--end
	if (not result) then
		if (self.Once and self.Set) then 
			if (PowaAuras.DebugTriggers or self.Debug) then
				PowaAuras:DisplayText(self.Name, " Once Match! reset value=", value, " ", self.CompareOperator, " ", self.Value);
			end
			self:ResetActions();
		end
		self.Set = false;
	else
		if (self.Once) then
			if (self.Set) then
				return false;
			else
				if (PowaAuras.DebugTriggers or self.Debug) then
					PowaAuras:DisplayText(self.Name, " Once Match! value=", value, " ", self.CompareOperator, " ", self.Value);
				end
			end
		end
		self.Set = true;
	end
	return self.Set;
end

function cPowaTrigger:CheckQulifier(qualifier)
	if (self.Qualifier==nil) then return true; end
	return (qualifier==self.Qualifier);
end

function cPowaTrigger:Compare(op, v1, v2)
	--if (PowaAuras.DebugTriggers or self.Debug) then
	--	PowaAuras:DisplayText("Compare: ", v1, " ", op, " ", v2);
	--end
	if (op==nil) then return true; end
	if (v1==nil or v2==nil) then return false; end
	if (op=="=") then return (v1==v2); end
	if (op==">") then return (v1>v2); end
	if (op=="<") then return (v1<v2); end
	if (op==">=") then return (v1>=v2); end
	if (op=="<=") then return (v1<=v2); end
	if (op=="!=") then return (v1~=v2); end
	return true;
end



--[[
=====cPowaTimerTrigger=====
Timer trigger type class.
===========================
--]]
cPowaAuraTimerTrigger = PowaClass(cPowaTrigger, { Type = "Timer", Once = true, Timer=true });
cPowaAuraDurationTrigger = PowaClass(cPowaTrigger, { Type = "Duration", Once = true, Timer=true });
cPowaAuraTimerRefreshTrigger = PowaClass(cPowaTrigger, { Type = "TimerRefresh", Timer=true });

cPowaStacksTrigger = PowaClass(cPowaTrigger, { Type = "Stacks", Once = true });

cPowaAuraShowTrigger = PowaClass(cPowaTrigger, { Type = "AuraShow" });
cPowaAuraHideTrigger = PowaClass(cPowaTrigger, { Type = "AuraHide" });
cPowaAuraActiveTrigger = PowaClass(cPowaTrigger, { Type = "AuraActive" });
cPowaAuraInactiveTrigger = PowaClass(cPowaTrigger, { Type = "AuraInactive" });

cPowaAuraStacksShowTrigger = PowaClass(cPowaTrigger, { Type = "StacksShow" });
cPowaAuraStacksHideTrigger = PowaClass(cPowaTrigger, { Type = "StacksHide" });
cPowaAuraStacksActiveTrigger = PowaClass(cPowaTrigger, { Type = "StacksActive" });
cPowaAuraStacksInactiveTrigger = PowaClass(cPowaTrigger, { Type = "StacksInactive" });

cPowaAuraTimerShowTrigger = PowaClass(cPowaTrigger, { Type = "TimerShow" });
cPowaAuraTimerHideTrigger = PowaClass(cPowaTrigger, { Type = "TimerHide" });
cPowaAuraTimerActiveTrigger = PowaClass(cPowaTrigger, { Type = "TimerActive" });
cPowaAuraTimerInactiveTrigger = PowaClass(cPowaTrigger, { Type = "TimerInactive" });

cPowaStateTrigger = PowaClass(cPowaTrigger, { Type = "State" });

