function PowaAuras:CalculateDurations(speed)
	-- speed ranges       from  0.05  to 2
	-- First  duration is then  1.225 to 0.25
	-- Second duration is then 30     to 0.25
	return 1.25 - speed / 2, 1.526 / math.max(speed,0.05) - 0.513;
end


function PowaAuras:AddAnimation(action, frame, animation, group, speed, alpha, beginSpin, hide, state, loop)

	local animationGroup = frame:CreateAnimationGroup(group);
	animationGroup.Action = action;
	animationGroup.HideWhenDone = hide;
	animationGroup.StateWhenDone = state;	
	if (loop) then
		animationGroup:SetLooping(loop);
	end
	animationGroup:SetScript("OnFinished",
	function(self, forced)
		--PowaAuras:ShowText("EndAnimation OnFinished ", self:GetName(), " Action=", self.Action.Id);
		if (self.Action) then
			self.Action:PlayNextAnimation();
		end
	end);
	
	local duration, duration2 = self:CalculateDurations(speed);
	
	--PowaAuras:ShowText("AddAnimation duration=", duration, " speed=", speed);
	if (animation<100 and animation~=PowaAuras.AnimationBeginTypes.Bounce) then
		self:AddJumpAlphaAndReturn(animationGroup, -math.min(alpha,0.99), duration, 1);
	end
	if (animation==PowaAuras.AnimationBeginTypes.ZoomOut) then
		self:AddJumpScaleAndReturn(animationGroup, 0.5, duration, 1);
	elseif (animation==PowaAuras.AnimationBeginTypes.ZoomIn) then
		self:AddJumpScaleAndReturn(animationGroup, 1.5, duration, 1);
	elseif (animation==PowaAuras.AnimationBeginTypes.FadeIn) then
	elseif (animation==PowaAuras.AnimationBeginTypes.TranslateLeft) then
		self:AddJumpTranslateAndReturn(animationGroup, -100, 0, duration, 1);
	elseif (animation==PowaAuras.AnimationBeginTypes.TranslateTopLeft) then
		self:AddJumpTranslateAndReturn(animationGroup, -75,75, duration, 1);
	elseif (animation==PowaAuras.AnimationBeginTypes.TranslateTop) then
		self:AddJumpTranslateAndReturn(animationGroup, 0, 100, duration, 1);
	elseif (animation==PowaAuras.AnimationBeginTypes.TranslateTopRight) then
		self:AddJumpTranslateAndReturn(animationGroup, 75, 75, duration, 1);
	elseif (animation==PowaAuras.AnimationBeginTypes.TranslateRight) then
		self:AddJumpTranslateAndReturn(animationGroup, 100, 0, duration, 1);
	elseif (animation==PowaAuras.AnimationBeginTypes.TranslateBottomRight) then
		self:AddJumpTranslateAndReturn(animationGroup, 75, -75, duration, 1);
	elseif (animation==PowaAuras.AnimationBeginTypes.TranslateBottom) then
		self:AddJumpTranslateAndReturn(animationGroup, 0, -100, duration, 1);
	elseif (animation==PowaAuras.AnimationBeginTypes.TranslateBottomLeft) then
		self:AddJumpTranslateAndReturn(animationGroup, -75, -75, duration, 1);
	elseif ((animation-100)==PowaAuras.AnimationEndTypes.Fade) then
		self:AddFade(animationGroup, duration / 2, 1);
	elseif ((animation-100)==PowaAuras.AnimationEndTypes.GrowAndFade) then
		self:AddFade(animationGroup, duration / 2, 1);
		self:AddScale(animationGroup, 2.0, 2.0, duration / 2, 1);
	elseif ((animation-100)==PowaAuras.AnimationEndTypes.ShrinkAndFade) then
		self:AddFade(animationGroup, duration / 2, 1);
		self:AddScale(animationGroup, 0.25, 0.25, duration / 2, 1);
	elseif ((animation-100)==PowaAuras.AnimationEndTypes.SpinAndFade) then
		self:AddFade(animationGroup, duration * 2, 1);
		self:AddRotation(animationGroup, 360 * 4, duration * 2, 1);
	elseif ((animation-100)==PowaAuras.AnimationEndTypes.SpinShrinkAndFade) then
		self:AddFade(animationGroup, duration * 2, 1);
		self:AddRotation(animationGroup, 360 * 4, duration * 2, 1);
		self:AddScale(animationGroup, 0.25, 0.25, duration * 2, 1);		
	elseif (animation==PowaAuras.AnimationBeginTypes.Bounce) then
		self:AddAlpha(animationGroup, math.min(alpha,0.99), 0, 0, 1);
		local u = 0;
		local height = 100;
		local efficiency = 0.6;
		local a = 800 * speed;
		self:AddTranslation(animationGroup,  0,  height, 0, 0, 1);
		local steps = 6;
		local dT = math.sqrt(2*height/a);
		local dt = dT / steps;
		local ds = {};
		for i = 1, steps do
			ds[i] = (u*dt+a*dt*dt/2) / height;
			u = u + a*dt;
			--self:ShowText(i, " ", ds[i]);
		end
		--self:ShowText("========");
		local order = animationGroup:GetMaxOrder()+1;
		while (height>2) do
			if (height<100) then
				--self:ShowText("=UP=");
				for i = 1, steps do
					--self:ShowText(order, " ", i, " ", ds[steps-i+1] * height);
					self:AddTranslation(animationGroup, 0, ds[steps-i+1] * height, dt, order);
					order = order + 1;
				end
			end
			--self:ShowText("=DOWN=");
			for i = 1, steps do
				--self:ShowText(order, " ", i, " ", -ds[i] * height);
				self:AddTranslation(animationGroup, 0, -ds[i] * height, dt, order);
				order = order + 1;
			end
			height = height * efficiency;
			--self:ShowText("\nHeight=", height);
		end
	elseif (animation==1000) then -- Ping
		self:AddJumpScaleAndReturn(animationGroup, 1.5, 0.3, 1)
		self:AddBrightenAndReturn(animationGroup, 1.2, alpha, 0.3, 1);
	end
	
	if (beginSpin) then
		self:AddRotation(animationGroup, 360, math.max(duration/4, 0.25), animationGroup:GetMaxOrder()+1);
	end
	
	return animationGroup, duration, duration2;
end

function PowaAuras:AddLoopingAnimation(aura, action, frame, animation, group, speed, alpha, isSecondary, loop)
		
	local animationGroup = frame:CreateAnimationGroup(group);
	animationGroup.Action = action;
	if (loop) then
		animationGroup:SetLooping(loop);
	end

	animationGroup:SetScript("OnFinished",
	function(self, forced)
		if (self.Action) then
			self.Action:PlayNextAnimation();
		end
	end);

	local duration, duration2 = self:CalculateDurations(speed);
	if (animation==PowaAuras.AnimationTypes.Flashing) then
		local deltaAlpha = math.min(alpha * 0.5,0.99);
		self:AddAlpha(animationGroup, -deltaAlpha, duration, 1);
		self:AddAlpha(animationGroup,  deltaAlpha, duration, 2);
	elseif (animation==PowaAuras.AnimationTypes.Growing) then
		self:AddScale(animationGroup, 1.2, 1.2, duration * 3, 1);
		self:AddAlpha(animationGroup, -math.min(alpha,0.99), duration * 3, 1);
	elseif (animation==PowaAuras.AnimationTypes.Pulse) then
		self:AddScale(animationGroup, 1.08, 1.08, duration, 1);
		self:AddScale(animationGroup, 0.9259, 0.9259, duration, 2);
	elseif (animation==PowaAuras.AnimationTypes.Shrinking) then
		self:AddAlpha(animationGroup, -math.min(alpha,0.99), duration, 1);
		self:AddScale(animationGroup, 1.3, 1.3, 0, 2);
		self:AddScale(animationGroup, 1/1.3, 1/1.3, duration * 3, 3);
		self:AddAlpha(animationGroup, math.min(alpha,0.99), duration * 3, 3);
	elseif (animation==PowaAuras.AnimationTypes.WaterDrop) then
		self:AddMoveRandomLocation(animationGroup, 0, 20, -10, 0, 20, -10, 0, 0, false, speed, 1);
		self:AddScale(animationGroup, 0.85, 0.85, 0, 0, 1);
		self:AddScale(animationGroup, 1.76, 1.76, duration * 4, 2);
		self:AddAlpha(animationGroup, -math.min(alpha,0.99), duration * 4, 2);
	elseif (animation==PowaAuras.AnimationTypes.Electric) then
		frame:SetAlpha(alpha / 2); 
		animationGroup.speed = speed;
		animationGroup:SetScript("OnPlay",
		function(self)
			self.Trigger = (random( 210 - self.speed * 100 ) < 4);
			--PowaAuras:ShowText("Electric OnPlay Trigger=", self.Trigger);
		end);
		self:AddMoveRandomLocation(animationGroup, 0, 10, -5, 0, 10, -5, 0.05, true, speed, 1);
		self:AddAlphaOnTrigger(animationGroup, 2, 0.05, 1);
	elseif (animation==PowaAuras.AnimationTypes.Flame) then
		local steps = 40;
		local deltaAlpha = math.min(alpha,0.99) / steps;
		local stepDuration = duration * 4 / steps;
		for i = 1, steps do
			self:AddMoveRandomLocation(animationGroup, 1, 7, -4, 0, 2, 0, stepDuration, false, speed, i);
			self:AddAlpha(animationGroup, -deltaAlpha, stepDuration, i);
			self:AddScale(animationGroup, 0.98, 0.98, stepDuration, i);
		end
	elseif (animation==PowaAuras.AnimationTypes.Bubble) then
		local factor = 0.05;
		local increase = 1 + factor;
		local decrease = 1 - factor;
		if (isSecondary) then
			increase = 1 - factor;
			decrease = 1 + factor;
		end
		self:AddScale(animationGroup, increase, decrease, duration/3, 1);
		self:AddScale(animationGroup, 1/increase,  1/decrease, duration/3, 2);
		self:AddScale(animationGroup, decrease, increase, duration/3, 3);
		self:AddScale(animationGroup, 1/decrease,  1/increase, duration/3, 4);
	elseif (animation==PowaAuras.AnimationTypes.Orbit) then
		local maxWidth  = math.max(aura.x, -aura.x, 5);
		local maxHeight = maxWidth * (1.6 - aura.torsion);
		local i = 1;
		local x = aura.x;
		if (isSecondary) then
			x = -PowaAuras.Auras[aura.id].x;
			frame:SetPoint("Center", x,  PowaAuras.Auras[aura.id].y);
		end
		local y = aura.y;
		local step = 9;
		local angleOffset = 190;
		if (x>0) then
			angleOffset = 10;
		end

		for angle = 0, 360-step, step do
			local newx = maxWidth * cos(angle + angleOffset);
			local newy = aura.y + maxHeight * sin(angle + angleOffset);
			--self:ShowText("Orbit ", i, " angle=", angle, " x=", string.format("%.2f", x), " y=", string.format("%.2f", y));
			self:AddTranslation(animationGroup, newx-x, newy-y, duration * step / 30, i);
			i = i + 1;
			x = newx;
			y = newy;
		end
	elseif (animation==PowaAuras.AnimationTypes.SpinClockwise) then
		self:AddRotation(animationGroup, -360, math.max(duration2, 0.25), 1);
	elseif (animation==PowaAuras.AnimationTypes.SpinAntiClockwise) then
		self:AddRotation(animationGroup,  360, math.max(duration2, 0.25), 1);
	end

	return animationGroup;
end

function PowaAuras:AddJumpTranslateAndReturn(animationGroup, dx, dy, duration, order)
	self:AddTranslation(animationGroup,  dx,  dy, 0, 0, order);
	self:AddTranslation(animationGroup, -dx, -dy, duration, order+1);
end

function PowaAuras:AddJumpAlphaAndReturn(animationGroup, change, duration, order)
	self:AddAlpha(animationGroup,  change, 0, 0, order);
	self:AddAlpha(animationGroup, -change, duration, order+1);
end

function PowaAuras:AddJumpScaleAndReturn(animationGroup, scale, duration, order)
	self:AddScale(animationGroup, scale, scale, 0, 0, order);
	self:AddScale(animationGroup, 1/scale, 1/scale, duration, order+1);
end

function PowaAuras:AddMoveRandomLocation(animationGroup, xrangel, xrangeu, xoffset, yrangel, yrangeu, yoffset, duration, useTrigger, speed, order)
	local trans = animationGroup:CreateAnimation("Translation");
	trans.speed = speed;
	trans.xrangel = xrangel;
	trans.xrangeu = xrangeu;
	trans.yrangel = yrangel;
	trans.yrangeu = yrangeu;
	trans.xoffset = xoffset;
	trans.yoffset = yoffset;
	trans.useTrigger = useTrigger;
	trans:SetOrder(order);
	trans:SetDuration(duration);
	trans:SetScript("OnPlay",
	function(self)
		if (not self.useTrigger or self:GetParent().Trigger) then
			self:SetOffset((random(self.xrangel,self.xrangeu) + self.xoffset) * self.speed, (random(self.yrangel,self.yrangeu) + self.yoffset) * self.speed);
		else
			self:SetOffset(0,0);		
		end
	end);
end

function PowaAuras:AddAlphaOnTrigger(animationGroup, alphaTo, duration, order)
	local alpha = animationGroup:CreateAnimation("Alpha");
	alpha:SetOrder(order);
	alpha:SetDuration(duration);
	alpha.alphaTo = alphaTo;
	alpha:SetScript("OnPlay",
	function(self)
		if (self:GetParent().Trigger) then
			self:SetChange(self.alphaTo);
		else
			self:SetChange(0);
		end
	end);
end

function PowaAuras:AddTranslation(animationGroup, dx, dy, duration, order)
	local trans = animationGroup:CreateAnimation("Translation");
	trans:SetOrder(order);
	trans:SetDuration(duration);
	trans:SetOffset(dx, dy);
end

function PowaAuras:AddScale(animationGroup, xscaleTo, yscaleTo, duration, order)
	local scale = animationGroup:CreateAnimation("Scale");
	scale:SetOrder(order);
	scale:SetDuration(duration);
	scale:SetScale(xscaleTo, yscaleTo);
	scale:SetSmoothing("IN_OUT");
end

function PowaAuras:AddAlpha(animationGroup, alphaTo, duration, order)
	local alpha = animationGroup:CreateAnimation("Alpha");
	alpha:SetOrder(order);
	alpha:SetDuration(duration);
	alpha:SetChange(alphaTo);
end

function PowaAuras:AddFade(animationGroup, duration, order)
	local alpha = animationGroup:CreateAnimation("Alpha");
	alpha:SetOrder(order);
	alpha:SetDuration(duration);
	alpha:SetScript("OnPlay",
	function(self)
		self:SetChange(-self:GetRegionParent():GetAlpha());
	end);
end

function PowaAuras:AddRelativeAlpha(animationGroup, change, duration, order)
	local alpha = animationGroup:CreateAnimation("Alpha");
	alpha:SetOrder(order);
	alpha:SetDuration(duration);
	alpha:SetScript("OnPlay",
	function(self)
		local alpha = self:GetRegionParent():GetAlpha();
		self:SetChange(math.min((alpha * change),0.99));
	end);
end

function PowaAuras:AddAbsoluteAlpha(animationGroup, targetAlpha, duration, order)
	local alpha = animationGroup:CreateAnimation("Alpha");
	alpha:SetOrder(order);
	alpha:SetDuration(duration);
	alpha:SetScript("OnPlay",
	function(self)
		self:SetChange(math.min(targetAlpha,0.99) - self:GetRegionParent():GetAlpha());
	end);
end

function PowaAuras:AddBrightenAndReturn(animationGroup, change, targetAlpha, duration, order)
	self:AddRelativeAlpha(animationGroup,  change, 0, 0, order);
	self:AddAbsoluteAlpha(animationGroup, targetAlpha, duration, order+1);
end

function PowaAuras:AddRotation(animationGroup, angle, duration, order)
	local rotation = animationGroup:CreateAnimation("Rotation");
	rotation:SetOrder(order);
	rotation:SetDuration(duration);
	rotation:SetDegrees(angle);
end

