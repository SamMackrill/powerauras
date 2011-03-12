--[[
=======cPowaTrigger========
Base class for Trigger Types.
===========================
--]]
cPowaTrigger = PowaClass(function(trigger, auraId, triggerId, value)
	if(not auraId or not triggerId or not PowaAuras.Auras[auraId]) then return; end
	PowaAuras:ShowText("Constructing Trigger type ", trigger.Type);
	-- Set up variables for trigger.
	trigger.Id               = triggerId;
	trigger.AuraId           = auraId;
	trigger.Actions          = {};
	trigger.Value            = value;
	trigger.State            = false;
end);

--[[
cPowaTrigger.ExportSettings = {
	Enabled = true,
	LowerCondition = ">=5",
	UpperCondition = "<=6",
}

function cPowaTrigger:Check(value)
	local result = (value >= 5 and value <= 6);
	-- Attempt to activate our Actions.
	for dType, action in pairs(self.Actions) do
		if(action) then
			if(result == true and PowaAuras.Auras[self.AuraId]:ApplyAction(dType, self.Id) == true) then
				if(action.State == true) then
					action:Update(value);
				else
					action:Activate(value);
				end
			elseif(result == false and action.State == true) then
				action:Deactivate(value);
				PowaAuras.Auras[self.AuraId]:RemoveAction(dtype, self.Id);
			end		
		end
	end
end
]]--


function cPowaTrigger:QueueActions(aura)
	for i = 1, #self.Actions do
		local action = self.Actions[i];
		action.TriggerValue = self.Value;
		PowaAuras:ShowText("Queuing Action ", action.Id, " on Trigger ", self.Id, " for Aura ", aura.id);
		aura.TriggerActionQueue[#aura.TriggerActionQueue+1] = action;
	end
end

function cPowaTrigger:AddAction(actionClass, parameters)
	local action = actionClass(self.AuraId, self.Id, #self.Actions + 1, parameters);
	PowaAuras:ShowText("Creating ", action.Type, " Action - Aura=", self.AuraId, " Trigger=", self.Id, " Action=", action.Id);
	self.Actions[action.Id] = action;
	return action;	
end

--[[
function cPowaTrigger:RemoveAction(id)
	-- Remove action if exists.
	if(not self.Actions[id]) then return; end
	self.Actions[id] = nil;
end
]]--

--[[
=====cPowaTimerTrigger=====
Timer trigger type class.
===========================
--]]
cPowaTimerTrigger = PowaClass(cPowaTrigger, { Type = "Timer" });
cPowaStacksTrigger = PowaClass(cPowaTrigger, { Type = "Stacks" });
cPowaAuraStartTrigger = PowaClass(cPowaTrigger, { Type = "AuraStart" });
function cPowaAuraStartTrigger:Check()
	--PowaAuras:ShowText("cPowaAuraStartTrigger:Check");
	return true;
end
cPowaAuraEndTrigger = PowaClass(cPowaTrigger, { Type = "AuraEnd" });
function cPowaAuraEndTrigger:Check()
	--PowaAuras:ShowText("cPowaAuraEndTrigger:Check");
	return true;
end
cPowaAuraStateTrigger = PowaClass(cPowaTrigger, { Type = "State" });
function cPowaAuraStateTrigger:Check(state)
	--PowaAuras:ShowText("cPowaAuraEndTrigger:Check");
	self.Value = state;
	return true;
end
--[[
=====cPowaTriggerAction========

===========================
--]]
cPowaTriggerAction = PowaClass(function(action, auraId, triggerId, actionId, parameters)
	if(not auraId or not triggerId or not PowaAuras.Auras[auraId] or not PowaAuras.Auras[auraId].Triggers[triggerId]) then return; end
	PowaAuras:ShowText("Constructing Action type ", action.Type );
	-- Set up variables for action.
	action.Id           = actionId;
	action.AuraId       = auraId;
	action.TriggerId    = triggerId;
	--action.State        = false;
	action.Parameters   = parameters;
	action:Init();
end);

function cPowaTriggerAction:Init()
end

function cPowaTriggerAction:Finished()
end

--[[
cPowaTriggerAction.ExportSettings = {
	Enabled = true,
	IsGradual = true,
}

function cPowaTriggerAction:Activate(value)
	-- Activate me.
	self.State = true;
	self.Value = value;
	-- Update has logic for display stuff.
	self:Update(value, true);
end

function cPowaTriggerAction:Deactivate(value)
	self.State = false;
	self.Value = value;
	-- Final update.
	self:Update(value);
	UIErrorsFrame:AddMessage("Action (" .. self.AuraId .. ", " .. self.Id .. ", " .. self.Type .. ") deactivating.", 1.0, 0.0, 0.0);
end

function cPowaTriggerAction:Update(value, firstRun)
	-- Update value.
	self.Value = value;
end
]]--

--[[
=====cPowaAuraMessageAction========
===========================
--]]
cPowaAuraMessageAction = PowaClass(cPowaTriggerAction, { Type = "Message" });

function cPowaAuraMessageAction:Fire()
	local aura = PowaAuras.Auras[self.AuraId];
	local text = aura:SubstituteInText(self.Parameters.Message , "%%v", function() return self.TriggerValue end, PowaAuras.Text.Unknown);
	PowaAuras:ShowText( text );
end

--[[
=====cPowaAuraAnimationAction========
===========================
--]]
cPowaAuraAnimationAction = PowaClass(cPowaTriggerAction, { Type = "Animation" });

function cPowaAuraAnimationAction:Fire()
	PowaAuras:ShowText("Animation Play: ", self.AnimationGroup:GetName() );
	self.Parameters.Frame:StopAnimating();
	self.AnimationGroup:Play();
end

function cPowaAuraAnimationAction:Init()
	local aura = PowaAuras.Auras[self.AuraId];
	local groupName = "Trigger" .. self.TriggerId .. "_" .. self.Id;
	PowaAuras:ShowText("Add Animation: ", self.Parameters.Animation, " Group=", groupName );
	if (self.Parameters.Loop) then
		self.AnimationGroup =  PowaAuras:AddLoopingAnimation(aura, self.Parameters.Frame, self.Parameters.Animation, groupName, self.Parameters.Speed, self.Parameters.Alpha)
	else
		self.AnimationGroup =  PowaAuras:AddAnimation(aura, self.Parameters.Frame, self.Parameters.Animation, groupName, self.Parameters.Speed, self.Parameters.Alpha, self.Parameters.BeginSpin, self.Parameters.Hide, self.Parameters.State);
	end
end

function cPowaAuraAnimationAction:Finished()
	PowaAuras:ShowText("Animation Finished Hide=", self.Parameters.Hide, " State=", self.Parameters.State );
	local aura = PowaAuras.Auras[self.AuraId];
	if (self.Parameters.Hide) then
		aura:Hide(true);
	end
	aura:SetState(self.Parameters.State);
end

--[[
=====cPowaAuraPlaySoundAction========
===========================
--]]
cPowaAuraPlaySoundAction = PowaClass(cPowaTriggerAction, { Type = "PlaySound" });

function cPowaAuraPlaySoundAction:Fire()
	PowaAuras:ShowText("Sound Play: ", self.Sound);
	if (self.WoWSound) then
		PlaySound(self.Sound, PowaMisc.SoundChannel);
	else
		PlaySoundFile(self.Sound, PowaMisc.SoundChannel);
	end
end

function cPowaAuraPlaySoundAction:Init()
	if (self.Parameters.CustomSound ~= "") then
		local pathToSound;
		if (string.find(aura.customsound, "\\")) then
			self.Sound = self.Parameters.CustomSound;
		else 
			self.Sound = PowaGlobalMisc.PathToSounds .. self.Parameters.CustomSound;
		end
	elseif (self.Parameters.Sound > 0) then
		if (PowaAuras.Sound[self.Parameters.Sound]~=nil and string.len(PowaAuras.Sound[self.Parameters.Sound])>0) then
			if (string.find(PowaAuras.Sound[self.Parameters.Sound], "%.")) then
				--self:ShowText("Playing sound ",PowaGlobalMisc.PathToSounds,PowaAuras.Sound[aura.sound]);		
				self.Sound = PowaGlobalMisc.PathToSounds .. PowaAuras.Sound[self.Parameters.Sound];
			else
				--self:ShowText("Playing WoW sound ",PowaAuras.Sound[aura.sound]);		
				self.Sound = PowaAuras.Sound[self.Parameters.Sound];
			end
		end
	end	
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

-- -- -- Testing script.
-- -- for i=1,4 do
      -- local aura = PowaAuras.Auras[i];
   -- -- for j=1,1 do
      -- -- local trigger=aura:CreateTrigger(cPowaTimerTrigger);
      -- -- trigger:AddAction(cPowaAuraOpacityAction);
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