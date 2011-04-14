--=====Trigger Action Base Class========

cPowaTriggerAction = PowaClass(function(action, trigger, actionId, parameters)
	if (not trigger) then return; end
	action.Id           = actionId;
	action.AuraId       = trigger.AuraId;
	action.Trigger      = trigger;
	action.Name         = parameters.Name;
	action.Parameters   = parameters;
	action.Debug        = trigger.Debug;
	if (PowaAuras.DebugTriggers or action.Debug) then
		PowaAuras:DisplayText("Constructing Action type ", action.Type, " Name=",action.Name);
	end
	action:Init();
end);

-- Optionally override these to do action specific tasks
function cPowaTriggerAction:Fire()
end

function cPowaTriggerAction:Init()
end

function cPowaTriggerAction:Finished()
end

function cPowaTriggerAction:Reset()
end

--=====Message Action========
-- Parameters:
--  Message

cPowaAuraMessageAction = PowaClass(cPowaTriggerAction, { Type = "Message" });

function cPowaAuraMessageAction:Fire()
	local aura = PowaAuras.Auras[self.AuraId];
	local text = aura:SubstituteInText(self.Parameters.Message , "%%v", function() return self.TriggerValue end, PowaAuras.Text.Unknown);
	PowaAuras:DisplayText( text );
end

--=====Hide Action========
-- Parameters:
--  All
--  Aura
--  Stacks
--  Timer

cPowaAuraHideAction = PowaClass(cPowaTriggerAction, { Type = "Hide" });

function cPowaAuraHideAction:Fire()
	if (PowaAuras.DebugTriggers or self.Debug) then
		PowaAuras:DisplayText("HideAction: Fire!");
	end
	local aura = PowaAuras.Auras[self.AuraId];
	if (self.Parameters.All or self.Parameters.Aura) then
		aura:Hide();
	end
	if (aura.Timer and ((self.Parameters.All and not aura.Timer.ShowOnAuraHide) or self.Parameters.Timer)) then
		aura.Timer:Hide();
	end
	if (aura.Stacks and ((self.Parameters.All and not aura.Stacks.ShowOnAuraHide) or self.Parameters.Stacks)) then
		aura.Stacks:Hide();
	end
end

--=====Invert Action========
-- Parameters:
--  All
--  Aura
--  Stacks
--  Timer

cPowaAuraInvertAction = PowaClass(cPowaTriggerAction, { Type = "Invert" });

function cPowaAuraInvertAction:Fire()
	if (PowaAuras.DebugTriggers or self.Debug) then
		PowaAuras:DisplayText("InvertAction: Fire!");
	end
	local aura = PowaAuras.Auras[self.AuraId];
	if (self.Parameters.All or self.Parameters.Aura) then
		aura:IncrementInvertCount(self.Parameters.Now);
	end
	if (aura.Timer and (self.Parameters.All or self.Parameters.Timer)) then
		aura.Timer:IncrementInvertCount(self.Parameters.Now);
	end
	if (aura.Stacks and (self.Parameters.All or self.Parameters.Stacks)) then
		aura.Stacks:IncrementInvertCount(self.Parameters.Now);
	end
end

function cPowaAuraInvertAction:Reset()
	if (PowaAuras.DebugTriggers or self.Debug) then
		PowaAuras:DisplayText("InvertAction: Reset");
	end
	local aura = PowaAuras.Auras[self.AuraId];
	if (self.Parameters.All or self.Parameters.Aura) then
		aura:DecrementInvertCount(self.Parameters.Now);
	end
	if (aura.Timer and (self.Parameters.All or self.Parameters.Timer)) then
		aura.Timer:DecrementInvertCount(self.Parameters.Now);
	end
	if (aura.Stacks and (self.Parameters.All or self.Parameters.Stacks)) then
		aura.Stacks:DecrementInvertCount(self.Parameters.Now);
	end
end

--=====Animation Action========
-- Parameters:
--  Frame
--  HideFrame (optional)
--  Animation
--  Loop
--  Speed
--  Alpha
--  Secondary
--  BeginSpin
--  Hide
--  StateName
--  StateValue

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
	local groupName = "Trigger" .. self.Trigger.Id .. "_" .. self.Id;
	if (PowaAuras.DebugTriggers or self.Debug) then
		PowaAuras:DisplayText("Add Animation: ", self.Parameters.Animation, " Group=", groupName );
	end
	if (self.Parameters.Loop) then
		self.AnimationGroup =  PowaAuras:AddLoopingAnimation(aura, self, self.Parameters.Frame, self.Parameters.Animation, groupName, self.Parameters.Speed, self.Parameters.Alpha, self.Parameters.Secondary, "REPEAT")
	else
		self.AnimationGroup =  PowaAuras:AddAnimation(self, self.Parameters.Frame, self.Parameters.Animation, groupName, self.Parameters.Speed, self.Parameters.Alpha, self.Parameters.BeginSpin, self.Parameters.Hide, self.Parameters.StateValue);
	end
end

function cPowaAuraAnimationAction:Finished()
	if (PowaAuras.DebugTriggers or self.Debug) then
		PowaAuras:DisplayText("Animation Finished Hide=", self.Parameters.Hide, " StateValue=", self.Parameters.StateValue );
	end
	local aura = PowaAuras.Auras[self.AuraId];
	if (self.Parameters.Hide) then
		aura:Hide("cPowaAuraAnimationAction Finished");
	end	
	if (self.Parameters.StateValue) then
		aura:SetState(self.Parameters.StateName, self.Parameters.StateValue);
	end
end

--=====State Action========
-- Parameters:
--  StateName
--  StateValue

cPowaAuraStateAction = PowaClass(cPowaTriggerAction, { Type = "State" });

function cPowaAuraStateAction:Fire()
	if (PowaAuras.DebugTriggers or self.Debug) then
		PowaAuras:DisplayText("Change State of ", self.Parameters.StateName, " to ", self.Parameters.StateValue );
	end
	local aura = PowaAuras.Auras[self.AuraId];
	if (aura==nil) then
		PowaAuras:DisplayText("cPowaAuraStateAction Fire: Aura nil!!! id=", self.AuraId );
		return;
	end
	aura:SetState(self.Parameters.StateName, self.Parameters.StateValue);
end

--=====Play Sound Action========
-- Parameters:
--  Sound
--  CustomSound

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

--=====Colour Action========
-- Parameters:
--  Texture
--  R
--  G
--  B
--  Revert (optional)

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

--=====Change Single Setting Base====--
cPowaAuraSettingAction = PowaClass(cPowaTriggerAction);

function cPowaAuraSettingAction:Set(value)
end

function cPowaAuraSettingAction:Get()
end

function cPowaAuraSettingAction:Fire()
	self.OldValue = self:Get();
	if (PowaAuras.DebugTriggers or self.Debug) then
		PowaAuras:DisplayText("Set Setting ", self.Type, " to ", self.Parameters.Value);
	end
	self:Set(self.Parameters.Value);
end

function cPowaAuraSettingAction:Reset()
	if (not self.Parameters.Revert) then return; end
	if (PowaAuras.DebugTriggers or self.Debug) then
		PowaAuras:DisplayText("Revert Setting ", self.Type, " to ", self.Parameters.Value);
	end
	self:Set(self.OldValue);
end

--=====Opacity Action========
-- Parameters:
--  Frame
--  Value
--  Revert (optional)

cPowaAuraOpacityAction = PowaClass(cPowaAuraSettingAction, { Type = "AuraOpacity" });

function cPowaAuraOpacityAction:Set(value)
	self.Parameters.Frame:SetAlpha(math.min(value, 0.99));
end

function cPowaAuraOpacityAction:Get()
	return self.Parameters.Frame:GetAlpha();
end

--=====Size Action========
-- Parameters:
--  Aura
--  Value
--  Revert (optional)

cPowaAuraSizeAction = PowaClass(cPowaAuraSettingAction, { Type = "AuraSize" });

function cPowaAuraSizeAction:Set(value)
	PowaAuras:SetFrameSize(self.Parameters.Frame, value, self.Parameters.Aura.torsion, self.Parameters.Aura.textaura, self.Parameters.Aura.aurastextfont)
end

function cPowaAuraSizeAction:Get()
	return self.Parameters.Aura.size;
end
