
	function TestPA:test_Runes_BB_2Ready()
		self:SetUp();
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Runes, 1, {buffname="BB"});

		aura.runes[1] = 2; -- B
		aura.runes[2] = 0; -- U
		aura.runes[3] = 0; -- F
		aura.runes[4] = 0; -- D
		
		aura.runeEnd[1] = 0; -- B
		aura.runeEnd[2] = 0; -- B
		aura.runeEnd[3] = 0; -- U
		aura.runeEnd[4] = 0; -- U
		aura.runeEnd[5] = 0; -- F
		aura.runeEnd[6] = 0; -- F
			
		--TestPA.Debug = true;
		local show, reason = aura:RunesPresent(true);
		--TestPA.Debug = false;

		assertEquals(show, true , "show");
		assertEquals(reason, "Runes Ready" , "reason");	
		
		self:TearDown()
	end	

	
	function TestPA:test_Runes_BB_1Ready()
		self:SetUp();
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Runes, 1, {buffname="BB", inverse=true, Timer=cPowaTimer(self)});

		aura.runes[1] = 1; -- B
		aura.runes[2] = 0; -- U
		aura.runes[3] = 0; -- F
		aura.runes[4] = 0; -- D
		
		aura.runeEnd[1] = 0; -- B
		aura.runeEnd[2] = 1; -- B
		aura.runeEnd[3] = 0; -- U
		aura.runeEnd[4] = 0; -- U
		aura.runeEnd[5] = 0; -- F
		aura.runeEnd[6] = 0; -- F
			
		--TestPA.Debug = true;
		local show, reason = aura:RunesPresent(true);
		--TestPA.Debug = false;

		assertEquals(show, false , "show");
		assertEquals(reason, "Runes not Ready" , "reason");	
		assertEquals(aura.Timer.DurationInfo, 1 , "DurationInfo");	
		
		self:TearDown()
	end	

		
	function TestPA:test_Runes_BB_0Ready()
		self:SetUp();
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Runes, 1, {buffname="BB", inverse=true, Timer=cPowaTimer(self)});

		aura.runes[1] = 0; -- B
		aura.runes[2] = 0; -- U
		aura.runes[3] = 0; -- F
		aura.runes[4] = 0; -- D
		
		aura.runeEnd[1] = 1; -- B
		aura.runeEnd[2] = 2; -- B
		aura.runeEnd[3] = 0; -- U
		aura.runeEnd[4] = 0; -- U
		aura.runeEnd[5] = 0; -- F
		aura.runeEnd[6] = 0; -- F
			
		--TestPA.Debug = true;
		local show, reason = aura:RunesPresent(true);
		--TestPA.Debug = false;

		assertEquals(show, false , "show");
		assertEquals(reason, "Runes not Ready" , "reason");	
		assertEquals(aura.Timer.DurationInfo, 2 , "DurationInfo");	
		
		self:TearDown()
	end	

	function TestPA:test_Runes_BFU_6Ready()
		self:SetUp();
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Runes, 1, {buffname="BFU"});

		aura.runes[1] = 2; -- B
		aura.runes[2] = 2; -- U
		aura.runes[3] = 2; -- F
		aura.runes[4] = 0; -- D
		
		aura.runeEnd[1] = 0; -- B
		aura.runeEnd[2] = 0; -- B
		aura.runeEnd[3] = 0; -- U
		aura.runeEnd[4] = 0; -- U
		aura.runeEnd[5] = 0; -- F
		aura.runeEnd[6] = 0; -- F
			
		--TestPA.Debug = true;
		local show, reason = aura:RunesPresent(true);
		--TestPA.Debug = false;

		assertEquals(show, true , "show");
		assertEquals(reason, "Runes Ready" , "reason");	
		
		self:TearDown()
	end

	function TestPA:test_Runes_BBFFUU_6Ready()
		self:SetUp();
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Runes, 1, {buffname="BBFFUU"});

		aura.runes[1] = 2; -- B
		aura.runes[2] = 2; -- U
		aura.runes[3] = 2; -- F
		aura.runes[4] = 0; -- D
		
		aura.runeEnd[1] = 0; -- B
		aura.runeEnd[2] = 0; -- B
		aura.runeEnd[3] = 0; -- U
		aura.runeEnd[4] = 0; -- U
		aura.runeEnd[5] = 0; -- F
		aura.runeEnd[6] = 0; -- F
			
		--TestPA.Debug = true;
		local show, reason = aura:RunesPresent(true);
		--TestPA.Debug = false;

		assertEquals(show, true , "show");
		assertEquals(reason, "Runes Ready" , "reason");	
		
		self:TearDown()
	end

	function TestPA:test_Runes_BBFFUU_BFUReady()
		self:SetUp();
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Runes, 1, {buffname="BBFFUU", inverse=true, Timer=cPowaTimer(self)});

		aura.runes[1] = 1; -- B
		aura.runes[2] = 1; -- U
		aura.runes[3] = 1; -- F
		aura.runes[4] = 0; -- D
		
		aura.runeEnd[1] = 1; -- B
		aura.runeEnd[2] = 0; -- B
		aura.runeEnd[3] = 2; -- U
		aura.runeEnd[4] = 0; -- U
		aura.runeEnd[5] = 0; -- F
		aura.runeEnd[6] = 3; -- F
			
		--TestPA.Debug = true;
		local show, reason = aura:RunesPresent(true);
		--TestPA.Debug = false;

		assertEquals(show, false , "show");
		assertEquals(reason, "Runes not Ready" , "reason");	
		assertEquals(aura.Timer.DurationInfo, 3 , "DurationInfo");	
		
		self:TearDown()
	end

	function TestPA:test_Runes_BBFF_BFReady1UD()
		self:SetUp();
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Runes, 1, {buffname="BBFF", inverse=true, Timer=cPowaTimer(self)});

		aura.runes[1] = 1; -- B
		aura.runes[2] = 1; -- U
		aura.runes[3] = 1; -- F
		aura.runes[4] = 1; -- D
		
		aura.runeEnd[1] = 1; -- B
		aura.runeEnd[2] = 0; -- B
		aura.runeEnd[3] = 0; -- U
		aura.runeEnd[4] = 0; -- U
		aura.runeEnd[5] = 2; -- F
		aura.runeEnd[6] = 0; -- F
			
		--TestPA.Debug = true;
		local show, reason = aura:RunesPresent(true);
		--TestPA.Debug = false;

		assertEquals(show, false , "show");
		assertEquals(reason, "Runes not Ready" , "reason");	
		assertEquals(aura.Timer.DurationInfo, 1 , "DurationInfo");		
		
		self:TearDown()
	end

	function TestPA:test_Runes_BBFF_0Ready1UD()
		self:SetUp();
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Runes, 1, {buffname="BBFF", inverse=true, Timer=cPowaTimer(self)});

		aura.runes[1] = 0; -- B
		aura.runes[2] = 1; -- U
		aura.runes[3] = 0; -- F
		aura.runes[4] = 1; -- D
		
		aura.runeEnd[1] = 1; -- B
		aura.runeEnd[2] = 2; -- B
		aura.runeEnd[3] = 0; -- U
		aura.runeEnd[4] = 0; -- U
		aura.runeEnd[5] = 3; -- F
		aura.runeEnd[6] = 4; -- F
			
		--TestPA.Debug = true;
		local show, reason = aura:RunesPresent(true);
		--TestPA.Debug = false;

		assertEquals(show, false , "show");
		assertEquals(reason, "Runes not Ready" , "reason");	
		assertEquals(aura.Timer.DurationInfo, 3 , "DurationInfo");		
		
		self:TearDown()
	end

	function TestPA:test_Runes_BB_BReady1UD()
		self:SetUp();
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Runes, 1, {buffname="BB", inverse=true, Timer=cPowaTimer(self)});

		aura.runes[1] = 1; -- B
		aura.runes[2] = 0; -- U
		aura.runes[3] = 0; -- F
		aura.runes[4] = 1; -- D
		
		aura.runeEnd[1] = 1; -- B
		aura.runeEnd[2] = 0; -- B
		aura.runeEnd[3] = 0; -- U
		aura.runeEnd[4] = 0; -- U
		aura.runeEnd[5] = 0; -- F
		aura.runeEnd[6] = 0; -- F
			
		--TestPA.Debug = true;
		local show, reason = aura:RunesPresent(true);
		--TestPA.Debug = false;

		assertEquals(show, true , "show");
		assertEquals(reason, "Runes Ready" , "reason");	
		
		self:TearDown()
	end	
	
	function TestPA:test_Runes_BB_0Ready1UD()
		self:SetUp();
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Runes, 1, {buffname="BB", inverse=true, Timer=cPowaTimer(self)});

		aura.runes[1] = 0; -- B
		aura.runes[2] = 0; -- U
		aura.runes[3] = 0; -- F
		aura.runes[4] = 1; -- D
		
		aura.runeEnd[1] = 1; -- B
		aura.runeEnd[2] = 2; -- B
		aura.runeEnd[3] = 0; -- U
		aura.runeEnd[4] = 0; -- U
		aura.runeEnd[5] = 0; -- F
		aura.runeEnd[6] = 0; -- F
			
		--TestPA.Debug = true;
		local show, reason = aura:RunesPresent(true);
		--TestPA.Debug = false;

		assertEquals(show, false , "show");
		assertEquals(reason, "Runes not Ready" , "reason");	
		assertEquals(aura.Timer.DurationInfo, 1 , "DurationInfo");	
		
		self:TearDown()
	end	
	
	function TestPA:test_Runes_BB_1Ready1BD()
		self:SetUp();
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Runes, 1, {buffname="BB", inverse=true, Timer=cPowaTimer(self)});

		aura.runes[1] = 0; -- B
		aura.runes[2] = 0; -- U
		aura.runes[3] = 0; -- F
		aura.runes[4] = 1; -- D
		
		aura.runeEnd[1] = 1; -- B
		aura.runeEnd[2] = 0; -- B
		aura.runeEnd[3] = 0; -- U
		aura.runeEnd[4] = 0; -- U
		aura.runeEnd[5] = 0; -- F
		aura.runeEnd[6] = 0; -- F
			
		--TestPA.Debug = true;
		local show, reason = aura:RunesPresent(true);
		--TestPA.Debug = false;

		assertEquals(show, false , "show");
		assertEquals(reason, "Runes not Ready" , "reason");	
		assertEquals(aura.Timer.DurationInfo, 1 , "DurationInfo");		
		
		self:TearDown()
	end	
	
	
	function TestPA:test_Runes_BBFFUU_BFUReady1UD()
		self:SetUp();
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Runes, 1, {buffname="BBFFUU", inverse=true, Timer=cPowaTimer(self)});

		aura.runes[1] = 1; -- B
		aura.runes[2] = 0; -- U
		aura.runes[3] = 1; -- F
		aura.runes[4] = 1; -- D
		
		aura.runeEnd[1] = 1; -- B
		aura.runeEnd[2] = 0; -- B
		aura.runeEnd[3] = 2; -- U
		aura.runeEnd[4] = 0; -- U
		aura.runeEnd[5] = 0; -- F
		aura.runeEnd[6] = 3; -- F
			
		--TestPA.Debug = true;
		local show, reason = aura:RunesPresent(true);
		--TestPA.Debug = false;

		assertEquals(show, false , "show");
		assertEquals(reason, "Runes not Ready" , "reason");	
		assertEquals(aura.Timer.DurationInfo, 3 , "DurationInfo");	
		
		self:TearDown()
	end	
