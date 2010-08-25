
	function TestPA:test_Runes_BB_2Ready()
		self:SetUp();
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Runes, 1, {buffname="BB"});

		aura.runes[1] = 2;
		aura.runes[2] = 0;
		aura.runes[3] = 0;
		aura.runes[4] = 0;
		
		aura.runeEnd[1] = 0;
		aura.runeEnd[2] = 0;
		aura.runeEnd[3] = 0;
		aura.runeEnd[4] = 0;
		aura.runeEnd[5] = 0;
		aura.runeEnd[6] = 0;
			
		TestPA.Debug = true;
		local show, reason = aura:RunesPresent(true);
		TestPA.Debug = false;

		assertEquals(show, true , "show");
		assertEquals(reason, "Runes Ready" , "reason");	
		
		self:TearDown()
	end	

	
	function TestPA:test_Runes_BB_1Ready()
		self:SetUp();
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Runes, 1, {buffname="BB", inverse=true, Timer=cPowaTimer(self)});

		aura.runes[1] = 1;
		aura.runes[2] = 0;
		aura.runes[3] = 0;
		aura.runes[4] = 0;
		
		aura.runeEnd[1] = 0;
		aura.runeEnd[2] = 1;
		aura.runeEnd[3] = 0;
		aura.runeEnd[4] = 0;
		aura.runeEnd[5] = 0;
		aura.runeEnd[6] = 0;
			
		TestPA.Debug = true;
		local show, reason = aura:RunesPresent(true);
		TestPA.Debug = false;

		assertEquals(show, false , "show");
		assertEquals(reason, "Runes not Ready" , "reason");	
		assertEquals(aura.Timer.DurationInfo, 1 , "DurationInfo");	
		
		self:TearDown()
	end	

		
	function TestPA:test_Runes_BB_0Ready()
		self:SetUp();
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Runes, 1, {buffname="BB", inverse=true, Timer=cPowaTimer(self)});

		aura.runes[1] = 0;
		aura.runes[2] = 0;
		aura.runes[3] = 0;
		aura.runes[4] = 0;
		
		aura.runeEnd[1] = 1;
		aura.runeEnd[2] = 2;
		aura.runeEnd[3] = 0;
		aura.runeEnd[4] = 0;
		aura.runeEnd[5] = 0;
		aura.runeEnd[6] = 0;
			
		TestPA.Debug = true;
		local show, reason = aura:RunesPresent(true);
		TestPA.Debug = false;

		assertEquals(show, false , "show");
		assertEquals(reason, "Runes not Ready" , "reason");	
		assertEquals(aura.Timer.DurationInfo, 2 , "DurationInfo");	
		
		self:TearDown()
	end	

	function TestPA:test_Runes_BFU_6Ready()
		self:SetUp();
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Runes, 1, {buffname="BFU"});

		aura.runes[1] = 2;
		aura.runes[2] = 2;
		aura.runes[3] = 2;
		aura.runes[4] = 0;
		
		aura.runeEnd[1] = 0;
		aura.runeEnd[2] = 0;
		aura.runeEnd[3] = 0;
		aura.runeEnd[4] = 0;
		aura.runeEnd[5] = 0;
		aura.runeEnd[6] = 0;
			
		TestPA.Debug = true;
		local show, reason = aura:RunesPresent(true);
		TestPA.Debug = false;

		assertEquals(show, true , "show");
		assertEquals(reason, "Runes Ready" , "reason");	
		
		self:TearDown()
	end

	function TestPA:test_Runes_BBFFUU_6Ready()
		self:SetUp();
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Runes, 1, {buffname="BBFFUU"});

		aura.runes[1] = 2;
		aura.runes[2] = 2;
		aura.runes[3] = 2;
		aura.runes[4] = 0;
		
		aura.runeEnd[1] = 0;
		aura.runeEnd[2] = 0;
		aura.runeEnd[3] = 0;
		aura.runeEnd[4] = 0;
		aura.runeEnd[5] = 0;
		aura.runeEnd[6] = 0;
			
		TestPA.Debug = true;
		local show, reason = aura:RunesPresent(true);
		TestPA.Debug = false;

		assertEquals(show, true , "show");
		assertEquals(reason, "Runes Ready" , "reason");	
		
		self:TearDown()
	end

	function TestPA:test_Runes_BBFFUU_3Ready()
		self:SetUp();
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Runes, 1, {buffname="BBFFUU", inverse=true, Timer=cPowaTimer(self)});

		aura.runes[1] = 1;
		aura.runes[2] = 1;
		aura.runes[3] = 1;
		aura.runes[4] = 0;
		
		aura.runeEnd[1] = 1;
		aura.runeEnd[2] = 0;
		aura.runeEnd[3] = 2;
		aura.runeEnd[4] = 0;
		aura.runeEnd[5] = 0;
		aura.runeEnd[6] = 3;
			
		TestPA.Debug = true;
		local show, reason = aura:RunesPresent(true);
		TestPA.Debug = false;

		assertEquals(show, false , "show");
		assertEquals(reason, "Runes not Ready" , "reason");	
		assertEquals(aura.Timer.DurationInfo, 3 , "DurationInfo");	
		
		self:TearDown()
	end
	function TestPA:test_Runes_BBFFUU_3Ready1UD()
		self:SetUp();
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Runes, 1, {buffname="BBFFUU", inverse=true, Timer=cPowaTimer(self)});

		aura.runes[1] = 1;
		aura.runes[2] = 1;
		aura.runes[3] = 0;
		aura.runes[4] = 1;
		
		aura.runeEnd[1] = 1;
		aura.runeEnd[2] = 0;
		aura.runeEnd[3] = 2;
		aura.runeEnd[4] = 0;
		aura.runeEnd[5] = 0;
		aura.runeEnd[6] = 3;
			
		TestPA.Debug = true;
		local show, reason = aura:RunesPresent(true);
		TestPA.Debug = false;

		assertEquals(show, false , "show");
		assertEquals(reason, "Runes not Ready" , "reason");	
		assertEquals(aura.Timer.DurationInfo, 3 , "DurationInfo");	
		
		self:TearDown()
	end	