--- Triggers control when things happen on an Aura and fire the appropriate actions.
-- Each Aura will have a list of Triggers specific to that aura (stored in aura.Triggers table).
-- The triggers are polled in the code by calling aura:CheckTriggers(TYPE, ...).
-- Where TYPE is a string defined in one of the derived trigger classes (see below).
-- The trigger will then determine if it needs to activate based on the parameters passed to CheckTriggers.
-- When a trigger activates it will fire its associated Actions in order.


---Base class for Trigger Types.
-- @name cPowaTrigger
-- @class table
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

--- Call Reset on all Actions, used by "Fire Once" Triggers
function cPowaTrigger:ResetActions()
	for i = 1, #self.Actions do
		local action = self.Actions[i];
		action:Reset();
	end
end

--- Creates and adds an new Action
-- @param actionClass Class of Action to add
-- @param parameters Table of Action specific initialisation parameters
function cPowaTrigger:AddAction(actionClass, parameters)
	local action = actionClass(self, self.NextActionId, parameters);
	self.NextActionId = self.NextActionId + 1;
	if (PowaAuras.DebugTriggers or self.Debug) then
		PowaAuras:DisplayText("Creating ", action.Type, " Action - Aura=", self.AuraId, " Trigger=", self.Id, " Action=", action.Id, " name=", action.Name);
	end
	table.insert(self.Actions, action);
	return action;	
end

--- Deletes Action
-- @param action Action to delete
function cPowaTrigger:DeleteAction(action)
	if (not action) then return; end
	for index, a in ipairs (self.Actions) do
		if (action.Id==a.Id) then
			table.remove(self.Actions, index);
			break;
		end
	end
end

--- Determine if Trigger needs to activate
-- @param value Value used by trigger to see if it should activate
-- @param qualifier Filter to check if this aura should be considered (use nil to ignore)
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

-- Determine if the qualifier matches the one set for this trigger
-- @param qualifier check qualifiers match
function cPowaTrigger:CheckQulifier(qualifier)
	if (self.Qualifier==nil) then return true; end
	return (qualifier==self.Qualifier);
end

--- Compare two values based on various operators
-- @param op Operator to use for comparison e.g. "="
-- @param v1 LHS value for compare
-- @param v2 RHS value for compare
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



-- Derived trigger classes

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

