
	function TestPA:test_SetStacks()
		self:SetUp();
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="nonsuch"});
		PowaAuras.Auras[aura.id] = aura;
		
		aura:SetStacks("=0");
		assertEquals(aura.stacksOperator, "=", "=0 =");
		assertEquals(aura.stacks, 0, "=0 0");
		assertEquals(aura.stacksLower, 0, "=0 0");
		
		aura:SetStacks(">9");
		assertEquals(aura.stacksOperator, ">", ">9 >");
		assertEquals(aura.stacks, 9, ">9 9");
		assertEquals(aura.stacksLower, 0, "=0 0");
		
		aura:SetStacks(">101");
		assertEquals(aura.stacksOperator, ">", ">101 >");
		assertEquals(aura.stacks, 0, ">101 0");
		assertEquals(aura.stacksLower, 0, ">101 0");
		
		aura:SetStacks(">");
		assertEquals(aura.stacksOperator, ">", "> >");
		assertEquals(aura.stacks, 0, "> 0");
		assertEquals(aura.stacksLower, 0, "=0 0");
		
		aura:SetStacks(">=15");
		assertEquals(aura.stacksOperator, ">=", ">=15 >=");
		assertEquals(aura.stacks, 15, ">=15 15");
		assertEquals(aura.stacksLower, 0, "=15 0");
		
		aura:SetStacks("<=4");
		assertEquals(aura.stacksOperator, "<=", "<=4 <=");
		assertEquals(aura.stacks, 4, "<=4 4");
		assertEquals(aura.stacksLower, 0, "<=4 0");
		
		aura:SetStacks("!34");
		assertEquals(aura.stacksOperator, "!", "!34 !");
		assertEquals(aura.stacks, 34, "!34 34");
		assertEquals(aura.stacksLower, 0, "!34 0");
		
		aura:SetStacks("3-5");
		assertEquals(aura.stacksOperator, "-", "3-5 -");
		assertEquals(aura.stacks, 5, "3-5 upper");
		assertEquals(aura.stacksLower, 3, "3-5 lower");
		
		aura:SetStacks("67-8");
		assertEquals(aura.stacksOperator, "-", "67-8 -");
		assertEquals(aura.stacks, 8, "67-8 upper");
		assertEquals(aura.stacksLower, 0, "67-8 lower");
			
		self:TearDown()
	end	
