
cPowaDecorator = PowaClass();

function cPowaDecorator:IsRelative()
	return (self.Relative and self.Relative~="NONE");
end

function cPowaDecorator:Show()
	PowaAuras:ShowText(self.Type, " Show() Showing=", self.Showing, " InvertCount=", self.InvertCount);
	if (self.Showing) then return; end
	local aura = PowaAuras.Auras[self.id];
	local frame1, frame2 = self:CreateFrameIfMissing(aura);
	if (frame1 == nil) then
		--PowaAuras:ShowText(self.Type, " Show() frame1 nil!");
		return;
	end

	if (self.Debug) then
		PowaAuras:Message(self.Type, " Show() ", self.id, " frame:Show() ", frame1);
	end
		
	frame1:Show();
	if (frame2) then frame2:Show(); end

	self.Showing = true;
	self.HideRequest = false;
	
	self:DisplayCurrent();
	
	if (not PowaAuras.ModTest) then
		aura:CheckTriggers(self.Type.."Show");
	end
end

function cPowaDecorator:CheckActive(aura, testing)
	local oldActive = self.Active;
	if (testing) then
		self.Active = aura.Active;	
	else
		self.Active = (aura.Active and not self.ShowOnAuraHide) or (not aura.Active and self.ShowOnAuraHide);	
	end
	PowaAuras:DisplayText(aura.id, " CheckActive: ", self.Type, " AuraActive=", aura.Active, " ShowOnAuraHide=", self.ShowOnAuraHide);
	PowaAuras:DisplayText(GetTime(), " ", self.Type, "(", self.id, ") Active=", self.Active, " (was ", oldActive, ")");
	if (oldActive==self.Active) then return; end
	self.InvertCount = 0;

	if (not testing) then
		self:CheckDecoratorTriggers(aura, true);
	end

	PowaAuras:ShowText(GetTime(), " ", self.Type, ".InvertCount=", self.InvertCount, " Showing=", self.Showing);

	if (not self.Active) then
		PowaAuras:ShowText(GetTime(),"=== ", self.Type, " INACTIVE ", auraId);
		self:Hide();
		return;
	end

	PowaAuras:ShowText(GetTime(),"=== ", self.Type, " ACTIVE ", auraId);
	if (self.InvertCount>0 and not testing) then
		self:Hide();
	else
		self:Show();
	end	
end

function cPowaDecorator:IncrementInvertCount()
	self.InvertCount = (self.InvertCount or 0) + 1;
	local aura = PowaAuras.Auras[self.id];
	--if (PowaAuras.DebugTriggers or aura.Debug) then
		PowaAuras:DisplayText(self.id, " ", self.Type, " IncrementInvertCount InvertCount=", self.InvertCount);
	--end
	if (self.InvertCount==1) then
		if (aura.Active or self.ShowOnAuraHide) then
			self:Hide();
		else
			self:Show();
		end
	end
end

function cPowaDecorator:DecrementInvertCount(now)
	self.InvertCount = (self.InvertCount or 1) - 1;
	local aura = PowaAuras.Auras[self.id];
	--if (aura.Debug) then
		PowaAuras:DisplayText(self.id, " ", self.Type, " DecrementInvertCount InvertCount=", self.InvertCount);
	--end
	if (self.InvertCount==0) then
		if (aura.Active or self.ShowOnAuraHide) then
			self:Show();
		else
			self:Hide();
		end
	end
end


--===== Stacks =====

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
	stacker.ShowOnAuraHide = false;
	stacker.Type = "Stacks";
end);

-- This is the set of values that will be exported with their default values
-- Be very careful if you change this as it may break old exports, adding new values is safe
-- Stings must always be set as at least an empty string
-- Numbers an booleans can be set interchangable (e.g. for tri-states)
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

function cPowaStacks:CreateAuraString()
	local tempstr = "";
	for k, default in pairs (self.ExportSettings) do
		tempstr = tempstr..PowaAuras:GetSettingForExport("stacks.", k, self[k], default);
	end
	return tempstr;
end

function cPowaStacks:CreateFrameIfMissing(aura)
	if (not PowaAuras.Frames[aura.id] and self:IsRelative()) then
		aura.Stacks.Showing = false;
		return;
	end
	if (not PowaAuras.StacksFrames[aura.id]) then
		--PowaAuras:ShowText("Creating missing StacksFrame for aura "..tostring(aura.id));		
		local frame = CreateFrame("Frame", nil, UIParent);
		PowaAuras.StacksFrames[aura.id] = frame;
		
		frame:SetFrameStrata(aura.strata);
		frame:Hide(); 
		
		frame.texture = frame:CreateTexture(nil, "BACKGROUND");
		frame.texture:SetBlendMode("ADD");
		frame.texture:SetAllPoints(frame);
		frame.texture:SetTexture(aura.Stacks:GetTexture());
		
		frame.textures = {
			[1] = frame.texture
		};
		
	end
	PowaAuras:UpdateOptionsStacks(aura.id);
	return PowaAuras.StacksFrames[aura.id];
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

function cPowaStacks:ShowValue(aura, newvalue)
	local frame = self:GetFrame();
	if (PowaAuras.ModTest) then
		newvalue = random(0,25000);
	end
	if (frame==nil or newvalue==nil) then
		return;
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

	if (self.enabled==false or aura.InactiveDueToMulti) then 
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
		local frame = self:GetFrame();
		if (frame and frame:IsVisible()) then
			frame:Hide();
		end
		self.Showing = false;
		self.LastShownValue = nil;
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
	self.UpdateValueTo = self.LastShownValue;
	self:Update()
end

function cPowaStacks:Update()
	if (not self.UpdateValueTo) then return; end
	local aura = PowaAuras.Auras[self.id];
	if (aura == nil) then return;end
	
	if (self.ShowOnAuraHide and aura.Active)  or (not self.ShowOnAuraHide and not aura.Active) then
		if (self.Showing) then
			self:Hide();
		end
		return;
	end
	
	--if (aura.Debug) then
		PowaAuras:DisplayText("Stacks Update UpdateValueTo=",self.UpdateValueTo);
	--end
	
	if (self.Showing) then
		self.LastShownValue=self.UpdateValueTo;
		self:ShowValue(aura, self.UpdateValueTo);
		self.UpdateValueTo = nil;
	end
end

function cPowaStacks:Hide()
	--PowaAuras:ShowText("Hide Stacks Frame for ", self.id, " ", self.Showing, " ", PowaAuras.StacksFrames[self.id]);
	if (not self.Showing) then return; end
	local frame = self:GetFrame();
	if (frame) then
		frame:Hide();
	end
	self.Showing = false;
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

--===== Timer =====

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

function cPowaTimer:CreateFrameIfMissing(aura)
	if (not aura and self:IsRelative()) then
		self.Showing = false;
		return;
	end
	if (PowaAuras.TimerFrame[aura.id]) then
		return PowaAuras.TimerFrame[aura.id][1], PowaAuras.TimerFrame[aura.id][2];
	end
	local frame1, frame2;
	PowaAuras.TimerFrame[aura.id] = {};
	frame1 = PowaAuras:CreateTimerFrame(aura.id, 1);
	frame2 = PowaAuras:CreateTimerFrame(aura.id, 2);
	--PowaAuras:ShowText("Created missing TimerFrames for aura ", aura.id, " frame1=", frame1, " frame2=", frame2);		
	return frame1, frame2;
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
		if (self.Showing) then
			self:CheckActive(aura, false, PowaAuras.ModTest);
			PowaAuras:TestThisEffect(self.id);
		end
		return;
	end
	
	PowaAuras:ShowText("Timer Display=", newvalue, " Showing=", self.Showing);

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
	if (not self.Showing) then return; end
	if PowaAuras.TimerFrame[self.id] then
		self:HideFrame(1);
		self:HideFrame(2);
	end
	self.lastShownLarge = nil;
	self.lastShownSmall = nil;
	self.Showing = false;
	self.InvertCount = nil;
	--PowaAuras:ShowText(">>>>> Hide timer frame");
end

function cPowaTimer:Dispose()
	self:Hide();
	PowaAuras:Dispose("TimerFrame", self.id, 1);
	PowaAuras:Dispose("TimerFrame", self.id, 2);
	PowaAuras:Dispose("TimerFrame", self.id);
end