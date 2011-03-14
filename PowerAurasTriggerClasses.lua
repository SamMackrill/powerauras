--[[
=======cPowaTrigger========
Base class for Trigger Types.
===========================
--]]
cPowaTrigger = PowaClass(function(trigger, auraId, triggerId, value, qualifier, compare)
	if(not auraId or not triggerId or not PowaAuras.Auras[auraId]) then return; end
	--PowaAuras:ShowText("Constructing Trigger type ", trigger.Type);
	trigger.Id               = triggerId;
	trigger.AuraId           = auraId;
	trigger.Actions          = {};
	trigger.Value            = value;
	trigger.Qualifier        = qualifier;
	trigger.Set              = false;
	trigger.CompareOperator  = compare;
end);

function cPowaTrigger:QueueActions(aura)
	for i = 1, #self.Actions do
		local action = self.Actions[i];
		action.TriggerValue = self.Value;
		--PowaAuras:ShowText("Queuing Action ", action.Id, " on Trigger ", self.Id, " for Aura ", aura.id);
		aura.TriggerActionQueue[#aura.TriggerActionQueue+1] = action;
	end
end

function cPowaTrigger:ResetActions()
	for i = 1, #self.Actions do
		local action = self.Actions[i];
		action:Reset();
	end
end

function cPowaTrigger:AddAction(actionClass, parameters)
	local action = actionClass(self.AuraId, self.Id, #self.Actions + 1, parameters);
	--PowaAuras:ShowText("Creating ", action.Type, " Action - Aura=", self.AuraId, " Trigger=", self.Id, " Action=", action.Id);
	self.Actions[action.Id] = action;
	return action;	
end

function cPowaTrigger:Check(value, qualifier)
	if (not self:CheckQulifier(qualifier)) then return false; end
	if (not self:Compare(self.CompareOperator, value, self.Value)) then
		if (self.Once and self.Set) then self:ResetActions(); end
		self.Set = false;
	else
		if (self.Once) then
			if (self.Set) then
				return false;
			else
			--PowaAuras:ShowText("Once Match! value=", value, " CompareTo=", self.Value);
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
	--PowaAuras:ShowText("CompareAlwaysTrue");
	if (op==nil) then return true; end
	if (op=="=") then return (v1==v2); end
	if (op==">") then return (v1>v2); end
	if (op=="<") then return (v1<v2); end
	if (op==">=") then return (v1>=v2); end
	if (op=="<=") then return (v1<=v2); end
	if (op=="!=") then return (v1~=v2); end
	return true;
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
cPowaAuraTimerTrigger = PowaClass(cPowaTrigger, { Type = "Timer", Once=true });

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
	--PowaAuras:ShowText("Constructing Action type ", action.Type );
	action.Id           = actionId;
	action.AuraId       = auraId;
	action.TriggerId    = triggerId;
	action.Parameters   = parameters;
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
	PowaAuras:ShowText( text );
end

--[[
=====cPowaAuraHideAction========
===========================
--]]
cPowaAuraHideAction = PowaClass(cPowaTriggerAction, { Type = "Hide" });

function cPowaAuraHideAction:Fire()
	local aura = PowaAuras.Auras[self.AuraId];
	local aura:Hide();
end
--[[
=====cPowaAuraAnimationAction========
===========================
--]]
cPowaAuraAnimationAction = PowaClass(cPowaTriggerAction, { Type = "Animation" });

function cPowaAuraAnimationAction:Fire()
	--PowaAuras:ShowText("Animation Play: ", self.AnimationGroup:GetName() );
	if (self.Parameters.HideFrame) then
		self.Parameters.HideFrame:StopAnimating();
		self.Parameters.HideFrame:Hide();
	end
	--PowaAuras:ShowText("  StopAnimating" );
	self.Parameters.Frame:StopAnimating();
	--PowaAuras:ShowText("  Show Frame" );
	self.Parameters.Frame:Show();
	--PowaAuras:ShowText("  Play" );
	self.AnimationGroup:Play();
end

function cPowaAuraAnimationAction:Init()
	local aura = PowaAuras.Auras[self.AuraId];
	local groupName = "Trigger" .. self.TriggerId .. "_" .. self.Id;
	--PowaAuras:ShowText("Add Animation: ", self.Parameters.Animation, " Group=", groupName );
	if (self.Parameters.Loop) then
		self.AnimationGroup =  PowaAuras:AddLoopingAnimation(aura, self, self.Parameters.Frame, self.Parameters.Animation, groupName, self.Parameters.Speed, self.Parameters.Alpha, self.Parameters.Secondary, "REPEAT")
	else
		self.AnimationGroup =  PowaAuras:AddAnimation(self, self.Parameters.Frame, self.Parameters.Animation, groupName, self.Parameters.Speed, self.Parameters.Alpha, self.Parameters.BeginSpin, self.Parameters.Hide, self.Parameters.State);
	end
end

function cPowaAuraAnimationAction:Finished()
	--PowaAuras:ShowText("Animation Finished Hide=", self.Parameters.Hide, " State=", self.Parameters.State );
	local aura = PowaAuras.Auras[self.AuraId];
	if (self.Parameters.Hide) then
		aura:Hide();
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
	--PowaAuras:ShowText("Change State to ", self.Parameters.Value );
	local aura = PowaAuras.Auras[self.AuraId];
	aura:SetState(self.Parameters.Name, self.Parameters.Value);
end


--[[
=====cPowaAuraPlaySoundAction========
===========================
--]]
cPowaAuraPlaySoundAction = PowaClass(cPowaTriggerAction, { Type = "PlaySound" });

function cPowaAuraPlaySoundAction:Fire()
	--PowaAuras:ShowText("Sound Play: ", self.Sound);
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
	--PowaAuras:ShowText("Set colour: R=", self.Parameters.R, " G=", self.Parameters.G, " B=", self.Parameters.B, " on texture ", self.Parameters.Texture);
	self.Parameters.Texture:SetVertexColor(self.Parameters.R,self.Parameters.G,self.Parameters.B);
end

function cPowaAuraColourAction:Reset()
	if (not self.Parameters.Revert) then return; end
	--PowaAuras:ShowText("Revert colour: R=", self.OldR, " G=", self.OldG, " B=", self.OldB);
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

