	function TestPA:test_AuraDisplay_NoBeginAnimation_NoMainAnimation()
		self:SetUp();
		self:SetupFor("SoloPaladin");

		assertEquals(WoWMock.Output, "|cffB0A0ff<Power Auras Classic>|r |cffffff00v2.6.2F|r - Type /powa to view the options.#", "Set-up");
		WoWMock.Output = "";
		assertEquals(self.Output, "");
		self.Output = "";
		
		PowaAuras.Auras = {};	 
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="Wyrmrest Champion", size=1});
		PowaAuras.Auras[aura.id] = aura;
		PowaAuras:CreateEffectLists();
		PowaAuras.ChecksTimer = 0;

		--TestPA.Debug = true;
		local result, reason = PowaAuras:TestThisEffect(aura.id, true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "player has buff Wyrmrest Champion", "Reason "..aura.buffname);

		local expected = "TestThisEffect 1 #ShouldShow 1 #CheckIfShouldShow  HELPFUL  aura #DisplayAura 1 #ShowAuraForFirstTime 1 #New Frames 1 #New Texture 1 #frame:Show() 1 #ShowSecondaryAuraForFirstTime 1 #";
		assertEquals(self.Output, expected , "TestThisEffect detailed trace");

		self.Output = "";
		PowaAuras:OnUpdate(0.1);

		expected = "OnUpdate 0.1 #ChecksTimer 0.1 0.2 #Pending #DoCheck update #NewCheckBuffs #TestThisEffect 1 #ShouldShow 1 #CheckIfShouldShow  HELPFUL  aura #Aura updates #Base Update  0.03 #";
		assertEquals(self.Output, expected , "OnUpdate detailed trace");
		
		local frame = PowaAuras.Frames[aura.id];
		assertEquals(frame:GetWidth()  , 256 , "frame.width");
		assertEquals(frame:GetHeight() , 256 , "frame.height");
		assertEquals(frame:GetAlpha()  , 0.75 ,"frame.alpha");
		assertEquals(frame.x, 0 , "frame.x");
		assertEquals(frame.x, 0 , "frame.x");
		assertEquals(frame.Anchor, "CENTER" , "frame.Anchor");

		PowaAuras:OnUpdate(0.1);

		local frame = PowaAuras.Frames[aura.id];
		assertEquals(frame:GetWidth()  , 256 , "frame.width");
		assertEquals(frame:GetHeight() , 256 , "frame.height");
		assertEquals(frame:GetAlpha()  , 0.75 ,"frame.alpha");
		assertEquals(frame.x, 0 , "frame.x");
		assertEquals(frame.x, 0 , "frame.x");
		assertEquals(frame.Anchor, "CENTER" , "frame.Anchor");

		self:TearDown()
	end


	function TestPA:test_AuraDisplay_NoBeginAnimation_MainAnimationType2()
		self:SetUp();
		self:SetupFor("SoloPaladin");

		assertEquals(WoWMock.Output, "|cffB0A0ff<Power Auras Classic>|r |cffffff00v2.6.2F|r - Type /powa to view the options.#", "Set-up");
		WoWMock.Output = "";
		assertEquals(self.Output, "");
		self.Output = "";
		
		PowaAuras.Auras = {};	 
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="Wyrmrest Champion", size=1, anim1=2});
		PowaAuras.Auras[aura.id] = aura;
		PowaAuras:CreateEffectLists();
		PowaAuras.ChecksTimer = 0;

		--TestPA.Debug = true;
		local result, reason = PowaAuras:TestThisEffect(aura.id, true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "player has buff Wyrmrest Champion", "Reason "..aura.buffname);

		local expected = "TestThisEffect 1 #ShouldShow 1 #CheckIfShouldShow  HELPFUL  aura #DisplayAura 1 #ShowAuraForFirstTime 1 #New Frames 1 #New Texture 1 #frame:Show() 1 #ShowSecondaryAuraForFirstTime 1 #";
		assertEquals(self.Output, expected , "TestThisEffect detailed trace");

		self.Output = "";
		PowaAuras:OnUpdate(0.1);

		expected = "OnUpdate 0.1 #ChecksTimer 0.1 0.2 #Pending #DoCheck update #NewCheckBuffs #TestThisEffect 1 #ShouldShow 1 #CheckIfShouldShow  HELPFUL  aura #Aura updates #cPowaAnimationFlashing Update  0.03 #";
		assertEquals(self.Output, expected , "OnUpdate detailed trace");
		
		local frame = PowaAuras.Frames[aura.id];
		assertEquals(frame:GetWidth()  , 256 , "frame.width");
		assertEquals(frame:GetHeight() , 256 , "frame.height");
		assertEquals(frame:GetAlpha()  , 0.735 ,"frame.alpha");
		assertEquals(frame.x, 0 , "frame.x");
		assertEquals(frame.x, 0 , "frame.x");
		assertEquals(frame.Anchor, "CENTER" , "frame.Anchor");

		self.Output = "";
		PowaAuras:OnUpdate(0.1);
		expected = "OnUpdate 0.1 #ChecksTimer 0.2 0.2 #Pending #DoCheck update #Aura updates #cPowaAnimationFlashing Update  0.03 #";
		assertEquals(self.Output, expected , "OnUpdate detailed trace");

		local frame = PowaAuras.Frames[aura.id];
		assertEquals(frame:GetWidth()  , 256 , "frame.width");
		assertEquals(frame:GetHeight() , 256 , "frame.height");
		assertEquals(frame:GetAlpha()  , 0.72 ,"frame.alpha");
		assertEquals(frame.x, 0 , "frame.x");
		assertEquals(frame.x, 0 , "frame.x");
		assertEquals(frame.Anchor, "CENTER" , "frame.Anchor");

		self:TearDown()
	end


	function TestPA:test_AuraDisplay_NoBeginAnimation_MainAnimationType3()
		self:SetUp();
		self:SetupFor("SoloPaladin");

		assertEquals(WoWMock.Output, "|cffB0A0ff<Power Auras Classic>|r |cffffff00v2.6.2F|r - Type /powa to view the options.#", "Set-up");
		WoWMock.Output = "";
		assertEquals(self.Output, "");
		self.Output = "";
		
		PowaAuras.Auras = {};	 
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="Wyrmrest Champion", size=1, anim1=3});
		PowaAuras.Auras[aura.id] = aura;
		PowaAuras:CreateEffectLists();
		PowaAuras.ChecksTimer = 0;

		--TestPA.Debug = true;
		local result, reason = PowaAuras:TestThisEffect(aura.id, true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "player has buff Wyrmrest Champion", "Reason "..aura.buffname);

		local expected = "TestThisEffect 1 #ShouldShow 1 #CheckIfShouldShow  HELPFUL  aura #DisplayAura 1 #ShowAuraForFirstTime 1 #New Frames 1 #New Texture 1 #frame:Show() 1 #ShowSecondaryAuraForFirstTime 1 #";
		assertEquals(self.Output, expected , "TestThisEffect detailed trace");

		self.Output = "";
		PowaAuras:OnUpdate(0.1);

		expected = "OnUpdate 0.1 #ChecksTimer 0.1 0.2 #Pending #DoCheck update #NewCheckBuffs #TestThisEffect 1 #ShouldShow 1 #CheckIfShouldShow  HELPFUL  aura #Aura updates #cPowaAnimationGrowing Update  0.03 #";
		assertEquals(self.Output, expected , "OnUpdate detailed trace");
		
		local frame = PowaAuras.Frames[aura.id];
		assertEquals(frame:GetWidth()  , 256.75 , "frame.width");
		assertEquals(frame:GetHeight() , 256.75 , "frame.height");
		assertEquals(frame:GetAlpha()  , 0.7 ,"frame.alpha");
		assertEquals(frame.x, 0 , "frame.x");
		assertEquals(frame.x, 0 , "frame.x");
		assertEquals(frame.Anchor, "CENTER" , "frame.Anchor");

		self.Output = "";
		PowaAuras:OnUpdate(0.1);
		expected = "OnUpdate 0.1 #ChecksTimer 0.2 0.2 #Pending #DoCheck update #Aura updates #cPowaAnimationGrowing Update  0.03 #";
		assertEquals(self.Output, expected , "OnUpdate detailed trace");

		local frame = PowaAuras.Frames[aura.id];
		assertEquals(frame:GetWidth()  , 257.5 , "frame.width");
		assertEquals(frame:GetHeight() , 257.5 , "frame.height");
		assertEquals(frame:GetAlpha()  , 0.65 ,"frame.alpha");
		assertEquals(frame.x, 0 , "frame.x");
		assertEquals(frame.x, 0 , "frame.x");
		assertEquals(frame.Anchor, "CENTER" , "frame.Anchor");

		PowaAuras:OnUpdate(0.2);
		PowaAuras:OnUpdate(0.2);
		PowaAuras:OnUpdate(0.2);
		self.Output = "";
		PowaAuras:OnUpdate(0.2);
		expected = "OnUpdate 0.2 #ChecksTimer 0.2 0.2 #Pending #DoCheck update #Aura updates #cPowaAnimationGrowing Update  0.03 #";
		assertEquals(self.Output, expected , "OnUpdate detailed trace");

		local frame = PowaAuras.Frames[aura.id];
		assertEquals(frame:GetWidth()  , 260.5 , "frame.width");
		assertEquals(frame:GetHeight() , 260.5 , "frame.height");
		assertEquals(frame:GetAlpha()  , 0.4560546875 ,"frame.alpha");
		assertEquals(frame.x, 0 , "frame.x");
		assertEquals(frame.x, 0 , "frame.x");
		assertEquals(frame.Anchor, "CENTER" , "frame.Anchor");

		PowaAuras:OnUpdate(0.2);
		PowaAuras:OnUpdate(0.2);
		PowaAuras:OnUpdate(0.2);
		self.Output = "";
		PowaAuras:OnUpdate(0.2);
		expected = "OnUpdate 0.2 #ChecksTimer 0.2 0.2 #Pending #DoCheck update #Aura updates #cPowaAnimationGrowing Update  0.03 #";
		assertEquals(self.Output, expected , "OnUpdate detailed trace");

		local frame = PowaAuras.Frames[aura.id];
		assertEquals(frame:GetWidth()  , 263.5 , "frame.width");
		assertEquals(frame:GetHeight() , 263.5 , "frame.height");
		assertEquals(frame:GetAlpha()  , 0.4267578125 ,"frame.alpha");
		assertEquals(frame.x, 0 , "frame.x");
		assertEquals(frame.x, 0 , "frame.x");
		assertEquals(frame.Anchor, "CENTER" , "frame.Anchor");
		
		self.Output = "";
		PowaAuras:OnUpdate(0.2);
		expected = "OnUpdate 0.2 #ChecksTimer 0.4 0.2 #Pending #DoCheck update #Aura updates #cPowaAnimationGrowing Update  0.03 #";
		assertEquals(self.Output, expected , "OnUpdate detailed trace");

		local frame = PowaAuras.Frames[aura.id];
		assertEquals(frame:GetWidth()  , 264.25 , "frame.width");
		assertEquals(frame:GetHeight() , 264.25 , "frame.height");
		assertEquals(frame:GetAlpha()  , 0.41943359375 ,"frame.alpha");
		assertEquals(frame.x, 0 , "frame.x");
		assertEquals(frame.x, 0 , "frame.x");
		assertEquals(frame.Anchor, "CENTER" , "frame.Anchor");

		self:TearDown()
	end	