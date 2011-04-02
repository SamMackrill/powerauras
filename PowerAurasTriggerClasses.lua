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
	local action = actionClass(self.AuraId, self.Id, self.NextActionId, parameters);
	self.NextActionId = self.NextActionId + 1;
	if (PowaAuras.DebugTriggers or self.Debug) then
		PowaAuras:DisplayText("Creating ", action.Type, " Action - Aura=", self.AuraId, " Trigger=", self.Id, " Action=", action.Id);
	end
	table.insert(self.Actions, action);
	return action;	
end

function cPowaTrigger:DeleteAction(action)
	if (not action) then return; end
	for index, a in pairs (self.Actions) do
		if (action.Id==a.Id) then
			table.remove(self.Actions, index);
			return;
		end
	end
end

function cPowaTrigger:Check(value, qualifier)
	if (not self:CheckQulifier(qualifier)) then return false; end
	local result = self:Compare(self.CompareOperator, value, self.Value);
	--if (PowaAuras.DebugTriggers or self.Debug) then
	--	PowaAuras:DisplayText("Check result=", result);
	--end
	if (not result) then
		if (self.Once and self.Set) then self:ResetActions(); end
		self.Set = false;
	else
		if (self.Once) then
			if (self.Set) then
				return false;
			else
				if (PowaAuras.DebugTriggers or self.Debug) then
					PowaAuras:DisplayText("Once Match! value=", value, " CompareTo=", self.Value);
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
cPowaAuraTimerTrigger = PowaClass(cPowaTrigger, { Type = "Timer", Once=true });

cPowaAuraDurationTrigger = PowaClass(cPowaTrigger, { Type = "Duration", Once=true });

cPowaAuraTimerRefreshTrigger = PowaClass(cPowaTrigger, { Type = "TimerRefresh" });

cPowaStacksTrigger = PowaClass(cPowaTrigger, { Type = "Stacks" });

cPowaAuraStartTrigger = PowaClass(cPowaTrigger, { Type = "AuraStart" });

cPowaAuraEndTrigger = PowaClass(cPowaTrigger, { Type = "AuraEnd" });

cPowaStateTrigger = PowaClass(cPowaTrigger, { Type = "State" });

--[[
=====cPowaTriggerAction========

===========================
--]]
cPowaTriggerAction = PowaClass(function(action, auraId, triggerId, actionId, parameters)
	if(not auraId or not triggerId or not PowaAuras.Auras[auraId] or not PowaAuras.Auras[auraId].Triggers[triggerId]) then return; end
	action.Id           = actionId;
	action.AuraId       = auraId;
	action.TriggerId    = triggerId;
	action.Name         = parameters.Name;
	parameters.Name     = nil;
	action.Parameters   = parameters;
	action.Debug = PowaAuras.Auras[auraId].Triggers[triggerId].Debug;
	if (PowaAuras.DebugTriggers or action.Debug) then
		PowaAuras:DisplayText("Constructing Action type ", action.Type );
	end
	action:Init();
end);

function cPowaTriggerAction:Init()
end

function cPowaTriggerAction:Finished()
end

function cPowaTriggerAction:Reset()
end

--[[
=====cPowaAuraMessageAction========
===========================
--]]
cPowaAuraMessageAction = PowaClass(cPowaTriggerAction, { Type = "Message" });

function cPowaAuraMessageAction:Fire()
	local aura = PowaAuras.Auras[self.AuraId];
	local text = aura:SubstituteInText(self.Parameters.Message , "%%v", function() return self.TriggerValue end, PowaAuras.Text.Unknown);
	PowaAuras:DisplayText( text );
end

--[[
=====cPowaAuraHideAction========
===========================
--]]
cPowaAuraHideAction = PowaClass(cPowaTriggerAction, { Type = "Hide" });

function cPowaAuraHideAction:Fire()
	if (PowaAuras.DebugTriggers or self.Debug) then
		PowaAuras:DisplayText("HideAction: Fire!");
	end
	local aura = PowaAuras.Auras[self.AuraId];
	if (self.Parameters.All or self.Parameters.Aura) then
		if (PowaAuras.DebugTriggers or self.Debug) then
			PowaAuras:DisplayText("  HideAction: Hide Aura");
		end
		aura:Hide("cPowaAuraHideAction");
		aura.TriggerForcedHide = true;
	end
	if (aura.Timer and (self.Parameters.All or self.Parameters.Timer)) then
		if (PowaAuras.DebugTriggers or self.Debug) then
			PowaAuras:DisplayText("  HideAction: Hide Timer");
		end
		aura.Timer:Hide();
		aura.Timer.TriggerForcedHide = true;
	end
	if (aura.Stacks and (self.Parameters.All or self.Parameters.Stacks)) then
		if (PowaAuras.DebugTriggers or self.Debug) then
			PowaAuras:DisplayText("  HideAction: Hide Stacks");
		end
		aura.Stacks:Hide();
		aura.Stacks.TriggerForcedHide = true;
	end
end

--[[
=====cPowaAuraAnimationAction========
===========================
--]]
cPowaAuraAnimationAction = PowaClass(cPowaTriggerAction, { Type = "Animation" });

function cPowaAuraAnimationAction:Fire()
	if (PowaAuras.DebugTriggers or self.Debug) then
		PowaAuras:DisplayText("Animation Play: ", self.AnimationGroup:GetName() );
	end
	if (self.Parameters.HideFrame) then
		self.Parameters.HideFrame:StopAnimating();
		self.Parameters.HideFrame:Hide();
	end
	self.Parameters.Frame:StopAnimating();
	self.Parameters.Frame:Show();
	self.AnimationGroup:Play();
end

function cPowaAuraAnimationAction:Init()
	local aura = PowaAuras.Auras[self.AuraId];
	local groupName = "Trigger" .. self.TriggerId .. "_" .. self.Id;
	if (PowaAuras.DebugTriggers or self.Debug) then
		PowaAuras:DisplayText("Add Animation: ", self.Parameters.Animation, " Group=", groupName );
	end
	if (self.Parameters.Loop) then
		self.AnimationGroup =  PowaAuras:AddLoopingAnimation(aura, self, self.Parameters.Frame, self.Parameters.Animation, groupName, self.Parameters.Speed, self.Parameters.Alpha, self.Parameters.Secondary, "REPEAT")
	else
		self.AnimationGroup =  PowaAuras:AddAnimation(self, self.Parameters.Frame, self.Parameters.Animation, groupName, self.Parameters.Speed, self.Parameters.Alpha, self.Parameters.BeginSpin, self.Parameters.Hide, self.Parameters.State);
	end
end

function cPowaAuraAnimationAction:Finished()
	if (PowaAuras.DebugTriggers or self.Debug) then
		PowaAuras:DisplayText("Animation Finished Hide=", self.Parameters.Hide, " State=", self.Parameters.State );
	end
	local aura = PowaAuras.Auras[self.AuraId];
	if (self.Parameters.Hide) then
		aura:Hide("cPowaAuraAnimationAction Finished");
	end	
	if (self.Parameters.State) then
		aura:SetState(self.Parameters.StateName, self.Parameters.State);
	end
end

--[[
=====cPowaAuraStateAction========
===========================
--]]
cPowaAuraStateAction = PowaClass(cPowaTriggerAction, { Type = "State" });

function cPowaAuraStateAction:Fire()
	if (PowaAuras.DebugTriggers or self.Debug) then
		PowaAuras:DisplayText("Change State of ", self.Parameters.StateName, " to ", self.Parameters.StateValue );
	end
	local aura = PowaAuras.Auras[self.AuraId];
	aura:SetState(self.Parameters.StateName, self.Parameters.StateValue);
end


--[[
=====cPowaAuraPlaySoundAction========
===========================
--]]
cPowaAuraPlaySoundAction = PowaClass(cPowaTriggerAction, { Type = "PlaySound" });

function cPowaAuraPlaySoundAction:Fire()
	if (PowaAuras.DebugTriggers or self.Debug) then
		PowaAuras:DisplayText("Sound Play: ", self.Sound);
	end
	if (self.WoWSound) then
		PlaySound(self.Sound, PowaMisc.SoundChannel);
	else
		PlaySoundFile(self.Sound, PowaMisc.SoundChannel);
	end
end

function cPowaAuraPlaySoundAction:Init()
	if (self.Parameters.CustomSound~=nil and self.Parameters.CustomSound ~= "") then
		local pathToSound;
		if (string.find(self.Parameters.CustomSound, "\\")) then
			self.Sound = self.Parameters.CustomSound;
		else 
			self.Sound = PowaGlobalMisc.PathToSounds .. self.Parameters.CustomSound;
		end
	elseif (self.Parameters.Sound > 0) then
		if (PowaAuras.Sound[self.Parameters.Sound]~=nil and string.len(PowaAuras.Sound[self.Parameters.Sound])>0) then
			if (string.find(PowaAuras.Sound[self.Parameters.Sound], "%.")) then
				self.Sound = PowaGlobalMisc.PathToSounds .. PowaAuras.Sound[self.Parameters.Sound]; -- PAC sound
			else	
				self.Sound = PowaAuras.Sound[self.Parameters.Sound]; -- Built-in WoW sound
			end
		end
	end	
end


--[[
=====cPowaAuraColourAction========
===========================
--]]
cPowaAuraColourAction = PowaClass(cPowaTriggerAction, { Type = "Colour" });

function cPowaAuraColourAction:Fire()
	self.OldR, self.OldG, self.OldB = self.Parameters.Texture:GetVertexColor();
	if (PowaAuras.DebugTriggers or self.Debug) then
		PowaAuras:DisplayText("Set colour: R=", self.Parameters.R, " G=", self.Parameters.G, " B=", self.Parameters.B, " on texture ", self.Parameters.Texture);
	end
	self.Parameters.Texture:SetVertexColor(self.Parameters.R,self.Parameters.G,self.Parameters.B);
end

function cPowaAuraColourAction:Reset()
	if (not self.Parameters.Revert) then return; end
	if (PowaAuras.DebugTriggers or self.Debug) then
		PowaAuras:DisplayText("Revert colour: R=", self.OldR, " G=", self.OldG, " B=", self.OldB);
	end
	self.Parameters.Texture:SetVertexColor(self.OldR, self.OldG, self.OldB);
end

--[[
=====cPowaAuraOpacityAction========
Fix that later.
===========================
--]]
cPowaAuraOpacityAction = PowaClass(cPowaTriggerAction, { Type = "AuraOpacity" });

--[[
function cPowaAuraOpacityAction:Update(value, firstRun)
	-- Update value.
	self.Value = value;
	-- Print msg.
	if(firstRun) then
		UIErrorsFrame:AddMessage("Action (" .. self.AuraId .. ", " .. self.Id .. ", " .. self.Type .. ") activating.", 0.0, 1.0, 0.0);
	else
		UIErrorsFrame:AddMessage("Action (" .. self.AuraId .. ", " .. self.Id .. ", " .. self.Type .. ") updating.", 0.0, 0.0, 1.0);
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
]]--


