--===== Base class for Timers and Stacks (virtual) =====
cPowaDecorator = PowaClass();

function cPowaDecorator:IsRelative()
	return (self.Relative and self.Relative~="NONE");
end

function cPowaDecorator:Show(aura, source)
	if (not self.enabled) then
		if (self.Showing) then
			self:Hide();
		end
		return;
	end
	--PowaAuras:ShowText(self.Type, " Show() Showing=", self.Showing, " source=", source);
	if (self.Showing) then return; end
	if (not self:ValidValue(aura, PowaAuras.ModTest)) then
		--PowaAuras:ShowText(self.Type, " Show() Invalid value");
		return;
	end
	
	local aura = PowaAuras.Auras[self.id];
	local frame1, frame2 = self:CreateFrameIfMissing(aura);
	if (frame1 == nil) then
		--PowaAuras:ShowText(self.Type, " Show() frame1 nil!");
		return;
	end

	if (self.Debug) then
		PowaAuras:Message(self.Type, " Show() ", self.id, " frame1:Show() ", frame1);
	end
		
	frame1:Show();
	if (frame2) then 
		--PowaAuras:Message(self.Type, " Show() ", self.id, " frame2:Show() ", frame2);
		frame2:Show();
	end

	self.Showing = true;
	self.HideRequest = false;
	
	self:DisplayCurrent();
	
	if (not PowaAuras.ModTest) then
		aura:CheckTriggers(self.Type.."Show");
	end
end

function cPowaDecorator:ValidValue(aura, testing)
	if (testing) then return true; end
	local displayValue = self:GetDisplayValue(aura, 0);
	--PowaAuras:ShowText(self.Type, " ValidValue()=", displayValue);
	return (displayValue and displayValue>0);
end

function cPowaDecorator:CheckActive(aura, testing)
    if (not self.enabled) then
		if (self.Active) then
			self:Dispose();
		end
		return;
	end
	local oldActive = self.Active;
	if (testing) then
		self.Active = aura.Active;	
	else
		self.Active = (aura.Active and not self.ShowOnAuraHide) or (not aura.Active and self.ShowOnAuraHide);	-- where is xor when you need it?
	end
	--PowaAuras:ShowText(aura.id, " CheckActive: ", self.Type, " AuraActive=", aura.Active, " ShowOnAuraHide=", self.ShowOnAuraHide);
	--PowaAuras:ShowText(GetTime(), " ", self.Type, "(", self.id, ") Active=", self.Active, " (was ", oldActive, ")");
	if (oldActive==self.Active) then return; end
	self.InvertCount = 0;

	if (not testing) then
		self:CheckDecoratorTriggers(aura, true);
		if (self.Active) then
			aura:CheckTriggers(self.Type.."Active");
		else
			aura:CheckTriggers(self.Type.."Inactive");
		end
	end

	--PowaAuras:ShowText(GetTime(), " ", self.Type, ".InvertCount=", self.InvertCount, " Showing=", self.Showing);

	if (not self.Active) then
		--PowaAuras:ShowText(GetTime(),"=== ", self.Type, " INACTIVE ", auraId);
		self:SetHideRequest(aura, self.Type.." Inactive", now, testing);
		return;
	end

	--PowaAuras:ShowText(GetTime(),"=== ", self.Type, " ACTIVE ", auraId);
	if (self.InvertCount>0 and not testing) then
		self:SetHideRequest(aura, self.Type.." Active and InvertCount>0", now, testing);
	else
		self:Show(aura, "Active");
	end	
end

function cPowaDecorator:Redisplay(aura, testing)
	--PowaAuras:ShowText(self.Type, " Redisplay ", auraId);
	self:Dispose();
	self:CreateFrameIfMissing(aura);
	self:SetShowOnAuraHide(aura);
	self:CheckActive(aura, testing);
end

function cPowaDecorator:SetHideRequest(aura, source, now, testing)

	if (self.Debug) then
		PowaAuras:Message(GetTime()," ", self.Type, " SetHideRequest ", self.HideRequest, " showing=", self.Showing, " from=", source, " now=", now);
		PowaAuras:Message(GetTime()," from=", source, " now=", now, " testing=", testing);
	end

	if ((self.HideRequest and not now) or not self.Showing) then return; end

	self.HideRequest = (not now);
	self.Showing = false;

	if (not testing) then
		--PowaAuras:ShowText(GetTime()," CheckTriggers ", self.Type.."Hide");
		aura:CheckTriggers(self.Type.."Hide");
	end

	if (now or testing) then
		self:Hide();
		return;
	end

end

function cPowaDecorator:IncrementInvertCount(aura)
	self.InvertCount = (self.InvertCount or 0) + 1;
	local aura = PowaAuras.Auras[self.id];
	if (PowaAuras.DebugTriggers or aura.Debug) then
		PowaAuras:DisplayText(self.id, " ", self.Type, " IncrementInvertCount InvertCount=", self.InvertCount);
	end
	if (self.InvertCount==1) then
		if (aura.Active or self.ShowOnAuraHide) then
			self:SetHideRequest(aura, self.Type.." Trigger Hide Action Active/ShowOnHide & InvertCount=1", now, PowaAuras.ModTest);
		else
			self:Show(aura, self.Type.." InvertCount=1");
		end
	end
end

function cPowaDecorator:DecrementInvertCount(aura, now)
	self.InvertCount = (self.InvertCount or 1) - 1;
	local aura = PowaAuras.Auras[self.id];
	if (aura.Debug) then
		PowaAuras:DisplayText(self.id, " ", self.Type, " DecrementInvertCount InvertCount=", self.InvertCount);
	end
	if (self.InvertCount==0) then
		if (aura.Active or self.ShowOnAuraHide) then
			self:Show(aura, self.Type.." InvertCount=0");
		else
			self:SetHideRequest(aura, self.Type.." Trigger Hide Action Inactive/ not ShowOnHide & InvertCount=0", now, PowaAuras.ModTest);
		end
	end
end

--==================
--===== Stacks =====
--==================

cPowaStacks = PowaClass(cPowaDecorator, function(stacker, aura, base)
	
	for k, v in pairs (cPowaStacks.ExportSettings) do
		if (base and base[k] ~= nil) then
			stacker[k] = base[k];
		else
			stacker[k] = v;
		end
	end
	
	stacker.Showing = false;
	stacker.id = aura.id;
	stacker:SetShowOnAuraHide(aura);
	stacker.Type = "Stacks";
end);

-- This is the set of values that will be exported with their default values
-- Be very careful if you change this as it may break old exports, adding new values is safe
-- Stings must always be set as at least an empty string
-- Numbers and booleans can be set interchangable (e.g. for tri-states)
cPowaStacks.ExportSettings = {
	enabled = false,
	x = 0,
	y = 0,
	a = 1.0,
	h = 1.0,
	Transparent = false,
	HideLeadingZeros = false,
	UpdatePing = false,
	Texture = "Default",
	Relative = "NONE",
	UseOwnColor = false,
	r = 1.0,
	g = 1.0,
	b = 1.0,
	LegacySizing = false,
}


function cPowaStacks:SetShowOnAuraHide(aura)
	self.ShowOnAuraHide = false;
end

function cPowaStacks:CreateAuraString()
	local tempstr = "";
	for k, default in pairs (self.ExportSettings) do
		tempstr = tempstr..PowaAuras:GetSettingForExport("stacks.", k, self[k], default);
	end
	return tempstr;
end

function cPowaStacks:CreateFrameIfMissing(aura)
	if (not PowaAuras.Frames[self.id] and self:IsRelative()) then
		self.Showing = false;
		return;
	end
	local frame = self:GetFrame();
	if (not frame) then
		--PowaAuras:ShowText("Creating missing StacksFrame for aura ", self.id);		
		frame = CreateFrame("Frame", nil, UIParent);
		PowaAuras.StacksFrames[self.id] = frame;
		
		frame:SetFrameStrata(aura.strata);
		frame:Hide(); 	
		frame.texture = frame:CreateTexture(nil, "BACKGROUND");
		frame.texture:SetBlendMode("ADD");
		frame.texture:SetAllPoints(frame);
		frame.texture:SetTexture(self:GetTexture());
		frame:SetAlpha(math.min(self.a, 0.99));
		frame:SetWidth(20 * self.h);
		frame:SetHeight(20 * self.h);
		if (self:IsRelative()) then
			--PowaAuras:ShowText(PowaAuras.Frames[auraId],": self.Relative=", self.Relative, " RelativeToParent=", PowaAuras.RelativeToParent[self.Relative], " x=", self.x, " y=",self.y);
			frame:SetPoint(PowaAuras.RelativeToParent[self.Relative], PowaAuras.Frames[auraId], self.Relative, self.x, self.y);
		else
			frame:SetPoint("CENTER", self.x, self.y);
		end
		
		frame.textures = {
			[1] = frame.texture
		};
		
	end
	return frame;
end

function cPowaStacks:GetTexture()
	local texture = PowaMisc.DefaultStacksTexture;
	if (self.Texture ~= "Default") then
		texture = self.Texture;
	end
	local postfix = "";
	if (self.Transparent) then
		postfix = "Transparent";
	end
	return "Interface\\Addons\\PowerAuras\\TimerTextures\\"..texture.."\\Timers"..postfix..".tga";
end

function cPowaStacks:GetFrame()
	return PowaAuras.StacksFrames[self.id];
end

function cPowaStacks:GetDisplayValue()
	if (PowaAuras.ModTest) then
		return random(0,100);
	end
	return self.UpdateValueTo;
end

function cPowaStacks:ShowValue(aura, newvalue)
	local frame = self:GetFrame();
	if (frame==nil or newvalue==nil) then
		return;
	end
	
	if (not self.Showing) then
		self:Show(aura, "ShowValue");
	end
	
	--PowaAuras:ShowText("Stacks Showvalue id=", self.id, " newvalue=", newvalue);
	
	-- Create textures dynamically to support > 9 stacks.
	local texcount = #(frame.textures);
	local unitcount = (newvalue == 0 and 1 or (floor(math.log10(newvalue))+1));
	local tStep = PowaAuras.Tstep;
	local w = (self.LegacySizing and 20 or 10);
	
	for i=1, (texcount > unitcount and texcount or unitcount) do
		-- Make textures if needed.
		if(not frame.textures[i]) then
			-- PowaAuras:ShowText("StacksTexture=", i, ", texcount=", texcount, ", unitcount=", unitcount);
			tinsert(frame.textures, i, frame:CreateTexture(nil, "BACKGROUND"));
			frame.textures[i]:SetTexture(self:GetTexture());
			-- Increment texcount to be more accurate.
			texcount = texcount+1;
		end
		-- Update blending modes.
		if (aura.texmode == 1) then
			frame.textures[i]:SetBlendMode("ADD");
		else
			frame.textures[i]:SetBlendMode("DISABLE");
		end
		if (self.UseOwnColor) then
			frame.textures[i]:SetVertexColor(self.r,self.g,self.b);
		else
			local auraTexture = PowaAuras.Textures[self.id];
			if (auraTexture) then
				if auraTexture:GetObjectType() == "Texture" then
					frame.textures[i]:SetVertexColor(auraTexture:GetVertexColor());
				elseif auraTexture:GetObjectType() == "FontString" then
					frame.textures[i]:SetVertexColor(auraTexture:GetTextColor());
				end
			else
				frame.textures[i]:SetVertexColor(aura.r,aura.g,aura.b);
			end
		end
		-- Update positions.
		if(i > unitcount) then
			-- This one isn't being displayed.
			frame.textures[i]:Hide();
		else
			-- Show and position it accordingly.
			frame.textures[i]:Show();
			frame.textures[i]:ClearAllPoints();
			frame.textures[i]:SetPoint("RIGHT", frame, "RIGHT", -((i-1)*(w*self.h))+(((unitcount-2)*(w*self.h))/2), 0);
			frame.textures[i]:SetWidth((w*self.h));
			frame.textures[i]:SetHeight((20*self.h));
			-- Set the texture coordinates.
			frame.textures[i]:SetTexCoord(tStep , tStep * 1.5, tStep * (newvalue % 10), tStep * ((newvalue % 10)+1));
			-- PowaAuras:ShowText("Show stacks: ", (newvalue % 10), " (", newvalue, ")");
			-- Divide newvalue by 10 so it's correct for the next one.
			newvalue = floor(newvalue/10);
		end
	end

end

function cPowaStacks:SetStackCount(count)
	--PowaAuras:UnitTestInfo("SetStackCount Id=",self.id," Count=",count);
	local aura = PowaAuras.Auras[self.id];
	if (aura == nil) then
		--PowaAuras:UnitTestInfo("Stacks aura missing");
		--PowaAuras:Message("Stacks aura missing");
		return;
	end

	if (not self.enabled or aura.InactiveDueToMulti) then 
		--PowaAuras:UnitTestInfo("Stacks disabled");
		--if (aura.Debug) then
		--	PowaAuras:DisplayText("Stacks disabled");
		--end
		return;
	end

	if (aura.Debug) then
		PowaAuras:DisplayText("SetStackCount Id=",self.id," Count=",count);
	end

	if (not count or count==0) then
		if (self.Showing) then
			aura:CheckTriggers("Stacks", 0);
			self:Hide();
		end
		return;
	end
	
	if (self.LastShownValue==count and self.Showing) then
		self.UpdateValueTo = nil;
		if (aura.Debug) then
			PowaAuras:DisplayText("Stacks unchanged");
		end
		return;
	end
	self.UpdateValueTo = count;
	aura:CheckTriggers("Stacks", count);
end

function cPowaStacks:DisplayCurrent()
	--PowaAuras:ShowText("DisplayCurrent=", self.UpdateValueTo);		
	self:Update()
end

function cPowaStacks:Update()
	if (not self.UpdateValueTo) then return; end
	local aura = PowaAuras.Auras[self.id];
	if (aura == nil) then return;end
	
	--if (self.ShowOnAuraHide and aura.Active)  or (not self.ShowOnAuraHide and not aura.Active) then
	--	if (self.Showing) then
	--		self:Hide();
	--	end
	--	return;
	--end
	if (not self.Showing and self:ValidValue(aura, PowaAuras.ModTest)) then
		self:Show(aura, "Not showing and value now valid")
		return;
	end
	
	if (aura.Debug) then
		PowaAuras:DisplayText("Stacks Update UpdateValueTo=",self.UpdateValueTo);
	end
	
	if (self.Showing) then
		self.LastShownValue=self.UpdateValueTo;
		self:ShowValue(aura, self.UpdateValueTo);
		self.UpdateValueTo = nil;
	end
end

function cPowaStacks:Hide()
	--PowaAuras:ShowText("Hide Stacks Frame for ", self.id, " ", self.Showing);
	--if (not self.Showing) then return; end
	local frame = self:GetFrame();
	if (frame) then
		frame:Hide();
	end
	self.Showing = false;
	self.HideRequest = false;
	self.UpdateValueTo = nil;
	self.LastShownValue = nil;
	self.InvertCount = nil;
end

function cPowaStacks:Dispose()
	self:Hide();
	PowaAuras:Dispose("StacksFrames", self.id);
end

function cPowaStacks:CheckDecoratorTriggers(aura, invertOnly)
end

--=================
--===== Timer =====
--=================

cPowaTimer = PowaClass(cPowaDecorator, function(timer, aura, base)

	for k, v in pairs (cPowaTimer.ExportSettings) do
		if (base and base[k] ~= nil) then
			timer[k] = base[k];
		else
			timer[k] = v;
		end
	end
	
	timer.Showing = false;
	timer.id = aura.id;
	timer:SetShowOnAuraHide(aura);
	timer.Type = "Timer";

	--for k,v in pairs (timer) do
	--	PowaAuras:ShowText("  "..tostring(k).."="..tostring(v));
	--end
end);

-- This is the set of values that will be exported (with their default values)
-- Be very careful if you change this as it may break many old exports
-- Settings must always be set as at least an empty string
-- Numbers and booleans can be set interchangably (e.g. for tri-states)
cPowaTimer.ExportSettings = {
	enabled = false,
	x = 0,
	y = 0,
	a = 1.0,
	h = 1.0,
	cents = true,
	Transparent = false,
	HideLeadingZeros = false,
	UpdatePing = false,
	ShowActivation = false,
	Seconds99 = false,
	Texture = "Default",
	Relative = "NONE",
	UseOwnColor = false,
	r = 1.0,
	g = 1.0,
	b = 1.0,
}

function cPowaTimer:CreateAuraString()
	local tempstr = "";
	for k, default in pairs (self.ExportSettings) do
		tempstr = tempstr..PowaAuras:GetSettingForExport("timer.", k, self[k], default);
	end
	return tempstr;
end

function cPowaTimer:SetShowOnAuraHide(aura)
	--PowaAuras:Message("CTR Timer id=", aura.id);
	--PowaAuras:Message("CooldownAura=", aura.CooldownAura);
	--PowaAuras:Message("inverse=", aura.inverse);
	--PowaAuras:Message("CanHaveTimer=", aura.CanHaveTimer);
	--PowaAuras:Message("CanHaveTimerOnInverse=", aura.CanHaveTimerOnInverse);
	--PowaAuras:Message("ShowActivation=", self.ShowActivation);
	self.ShowOnAuraHide = self.ShowActivation~=true and ((aura.CooldownAura and (not aura.inverse and aura.CanHaveTimer)) or (not aura.CooldownAura and (aura.inverse and aura.CanHaveTimerOnInverse)));
	--PowaAuras:Message("ShowOnAuraHide=", self.ShowOnAuraHide);
end

function cPowaTimer:CreateFrameIfMissing(aura)
	if (not aura and self:IsRelative()) then
		self.Showing = false;
		return;
	end
	local frame1, frame2;
	if (PowaAuras.TimerFrame[self.id]) then
		frame1, frame2 = PowaAuras.TimerFrame[self.id][1], PowaAuras.TimerFrame[self.id][2];
	else
		PowaAuras.TimerFrame[self.id] = {};
	end
	if (not frame1) then
		--PowaAuras:ShowText("Created missing TimerFrames for aura ", self.id, " frame1=", frame1);		
		frame1 = self:CreateFrame(aura, 1);
		frame1:SetAlpha(math.min(self.a,0.99));
		frame1:SetWidth(20 * self.h);
		frame1:SetHeight(20 * self.h);
		if (self:IsRelative()) then
			frame1:SetPoint(PowaAuras.RelativeToParent[self.Relative], PowaAuras.Frames[self.id], self.Relative, self.x, self.y);
		else
			frame1:SetPoint("CENTER", self.x, self.y);
		end
	end
	if (self.cents) then
		if (not frame2) then
			--PowaAuras:ShowText("Created missing TimerFrames for aura ", self.id, " frame2=", frame2);		
			frame2 = self:CreateFrame(aura, 2);
			frame2:SetAlpha(self.a * 0.75);
			frame2:SetWidth(14 * self.h);
			frame2:SetHeight(14 * self.h);
			frame2:SetPoint("LEFT", frame1, "RIGHT", 1, -1.5);
		end
	elseif (frame2) then
		PowaAuras:Dispose("TimerFrame", self.id, 2);
		frame2 = nil;
	end
	return frame1, frame2;
end

function cPowaTimer:CreateFrame(aura, index)
	local frame = CreateFrame("Frame", nil, UIParent);
	PowaAuras.TimerFrame[self.id][index] = frame;
	
	frame:SetFrameStrata(aura.strata);
	frame:Hide(); 

	frame.texture = frame:CreateTexture(nil,"BACKGROUND");
	frame.texture:SetBlendMode("ADD");
	frame.texture:SetAllPoints(frame);
	frame.texture:SetTexture(self:GetTexture());
	return frame, texture;
end

function cPowaTimer:GetTexture()
	local texture = PowaMisc.DefaultTimerTexture;
	if (self.Texture ~= "Default") then
		texture = self.Texture;
	end
	local postfix = "";
	if (self.Transparent) then
		postfix = "Transparent";
	end
    texture = "Interface\\Addons\\PowerAuras\\TimerTextures\\"..texture.."\\Timers"..postfix..".tga";
	--PowaAuras:ShowText("Timer texture: ", texture);
	return texture;
end

function cPowaTimer:HasDependants(aura)
	return (aura.InvertAuraBelow > 0) or (aura.timerduration > 0);
end

--- Determine the value to display in the timer
function cPowaTimer:GetDisplayValue(aura, elapsed)
	local newvalue = 0;
	if (PowaAuras.ModTest) then
		newvalue = random(0,99) + (random(0, 99) / 100);
		
	elseif (self.ShowActivation and self.Start~=nil) then
		newvalue = self.Duration;
	
	elseif (aura.timerduration and aura.timerduration > 0) then--- if a user defined timer is active for the aura override the rest
		if (((aura.target or aura.targetfriend) and (PowaAuras.ResetTargetTimers == true)) or not self.CustomDuration) then
			self.CustomDuration = aura.timerduration;
		else
			self.CustomDuration = math.max(self.CustomDuration - elapsed, 0);
		end	
		newvalue = self.CustomDuration;
	else
		if (self.DurationInfo and self.DurationInfo > 0) then
			newvalue = math.max(self.DurationInfo - GetTime(), 0);
		end
	end

	if (PowaAuras.DebugCycle) then
		PowaAuras:Message("newvalue=",newvalue); --OK
	end
	return newvalue;
end

function cPowaTimer:Display(aura, newvalue)
		
	if (not newvalue or newvalue <= 0) then
		--PowaAuras:ShowText("Timer Value=", newvalue, " Showing=", self.Showing);
		if (self.Showing) then
			self:CheckActive(aura, false, PowaAuras.ModTest);
			PowaAuras:TestThisEffect(self.id);
		end
		return;
	end
	
	--PowaAuras:ShowText("Timer Display=", newvalue, " Showing=", self.Showing);

	local split = 60;
	if (self.Seconds99) then
		split = 100;
	end
	if (PowaAuras.DebugCycle) then
		PowaAuras:Message("cents=",self.cents); --OK
	end
	if (self.cents) then
		local small;
		if (newvalue > split) then 
			small = math.fmod(newvalue,60);  -- Seconds (large = minutes)
		else
			small = (newvalue - math.floor(newvalue)) * 100; -- hundredths of a second (large = seconds)
		end
		if (PowaMisc.TimerRoundUp) then
			small = math.ceil(small);
		end

		if (PowaAuras.DebugCycle) then
			PowaAuras:Message("small=",small); --OK
		end
		if (self.lastShownSmall~=small) then
			self:ShowValue(aura, 2, small);
			self.lastShownSmall=small;
		end
	end	

	local large = newvalue;
	if (newvalue > split) then 
		large = newvalue / 60;		
	end
	large = math.min (99.00, large);
	if ((not self.cents) and PowaMisc.TimerRoundUp) then
		large = math.ceil(large);
	else
		large = math.floor(large);		
	end

	if (PowaAuras.DebugCycle) then
		PowaAuras:Message("large=",large); --OK
	end
	if (self.lastShownLarge~=large) then
		self:ShowValue(aura, 1, large);
		self.lastShownLarge=large;
	end
	
end

function cPowaTimer:CheckDecoratorTriggers(aura, invertOnly)
	local newvalue = self:GetDisplayValue(aura, 0);
	
	--PowaAuras:ShowText("Timer CheckActive: Re-evaluate timer triggers @", newvalue);
	aura:CheckTriggers("Timer", newvalue, nil, invertOnly);
	aura:CheckTriggers("Duration", newvalue, nil, invertOnly);
	aura:ProcessTriggerQueue();
end

function cPowaTimer:DisplayCurrent()
	self:Update(0);
end

function cPowaTimer:Update(elapsed)
	--PowaAuras:UnitTestInfo("Timer.Update ",self.id);
	local aura = PowaAuras.Auras[self.id];
	if (aura == nil) then
		--PowaAuras:UnitTestInfo("Timer aura missing");
		if (PowaAuras.DebugCycle) then
			PowaAuras:DisplayText("Timer aura missing for id=",self.id);
		end
		return;
	end
	
	if (PowaAuras.DebugCycle) then
		PowaAuras:DisplayText("Timer.Update ",self.id);
	end
	
	if (self.Start==nil) then
		self.Duration = 0;
	else
		self.Duration = math.max(GetTime() - self.Start, 0);
	end
	
	--if ((self.enabled==false and not self:HasDependants(aura)) or (aura.ForceTimeInvert and aura.InvertTimeHides)) then
	if (self.enabled==false and not self:HasDependants(aura)) then
		--PowaAuras:UnitTestInfo("Timer disabled");
		if (PowaAuras.DebugCycle) then
			PowaAuras:DisplayText("Timer disabled");
		end
		return;
	end

	local newvalue = self:GetDisplayValue(aura, elapsed);
	
	--if (self.ShowOnAuraHide and aura.Active)  or (not self.ShowOnAuraHide and not aura.Active) then
	--	if (self.Showing) then
	--		self:Hide();
	--	end
	--	return;
	--end

	if (not PowaAuras.ModTest) then
		aura:CheckTriggers("Timer", newvalue);
		aura:CheckTriggers("Duration", self.Duration);
	end
	
	if (self.Showing) then
		self:Display(aura, newvalue);
	end
end

-- This is used to dectect timer refreshes
function cPowaTimer:SetDurationInfo(endtime)
	if (self.DurationInfo == endtime) then return end;
	self.DurationInfo = endtime;
	local aura = PowaAuras.Auras[self.id];
	aura:CheckTriggers("TimerRefresh");
end

function cPowaTimer:ExtractDigits(displayValue)
	local deci = math.floor(displayValue / 10);
	local uni = math.floor(displayValue - (deci*10))
	return deci, uni;
end

function cPowaTimer:ShowValue(aura, frameIndex, displayValue)
	if (PowaAuras.TimerFrame==nil) then return; end
	if (PowaAuras.TimerFrame[self.id]==nil) then return; end
	local timerFrame = PowaAuras.TimerFrame[self.id][frameIndex];
	if (timerFrame==nil) then return; end
	
	if (not self.Showing) then
		if (aura.texmode == 1) then
			timerFrame.texture:SetBlendMode("ADD");
		else
			timerFrame.texture:SetBlendMode("DISABLE");
		end
		if (self.UseOwnColor) then
			timerFrame.texture:SetVertexColor(self.r,self.g,self.b);
		else
			local auraTexture = PowaAuras.Textures[self.id];
			if (auraTexture) then
				if auraTexture:GetObjectType() == "Texture" then
					timerFrame.texture:SetVertexColor(auraTexture:GetVertexColor());
				elseif auraTexture:GetObjectType() == "FontString" then
					timerFrame.texture:SetVertexColor(auraTexture:GetTextColor());
				end
			else
				timerFrame.texture:SetVertexColor(aura.r,aura.g,aura.b);
			end
		end
	end
	
	local deci, uni = self:ExtractDigits(displayValue);
	--PowaAuras:ShowText("Show timer: ",deci, " ", uni, " ", PowaAuras.Auras[k].Timer.HideLeadingZeros);
	local tStep = PowaAuras.Tstep;
	if (deci==0 and self.HideLeadingZeros) then
		timerFrame.texture:SetTexCoord(tStep , tStep * 1.5, tStep * uni, tStep * (uni+1));
	else
		timerFrame.texture:SetTexCoord(tStep * uni, tStep * (uni+1), tStep * deci, tStep * (deci+1));
	end

end

function cPowaTimer:HideFrame(i)
	if (PowaAuras.TimerFrame[self.id] and PowaAuras.TimerFrame[self.id][i]) then
		--PowaAuras:ShowText("Hide Timer Frame ", i," for ", self.id);
		PowaAuras.TimerFrame[self.id][i]:Hide();
	end
end

function cPowaTimer:Hide()
	if PowaAuras.TimerFrame[self.id] then
		self:HideFrame(1);
		self:HideFrame(2);
	end
	self.lastShownLarge = nil;
	self.lastShownSmall = nil;
	self.Showing = false;
	self.HideRequest = false;
	self.InvertCount = nil;
	--PowaAuras:ShowText(">>>>> Hide timer frame");
end

function cPowaTimer:Dispose()
	self:Hide();
	PowaAuras:Dispose("TimerFrame", self.id, 1);
	PowaAuras:Dispose("TimerFrame", self.id, 2);
	PowaAuras:Dispose("TimerFrame", self.id);
end