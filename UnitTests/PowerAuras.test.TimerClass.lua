
	function TestPA:test_ExtractDigits()
		self:SetUp();
		
		local deci, uni = cPowaTimer:ExtractDigits(0);
		assertEquals(deci, 0, "0 deci");
		assertEquals(uni, 0, "0 uni");
		
		local deci, uni = cPowaTimer:ExtractDigits(1);
		assertEquals(deci, 0, "1 deci");
		assertEquals(uni, 1, "1 uni");
		
		local deci, uni = cPowaTimer:ExtractDigits(20);
		assertEquals(deci, 2, "20 deci");
		assertEquals(uni, 0, "20 uni");
		
		local deci, uni = cPowaTimer:ExtractDigits(73);
		assertEquals(deci, 7, "73 deci");
		assertEquals(uni, 3, "73 uni");
		
		local deci, uni = cPowaTimer:ExtractDigits(0.5);
		assertEquals(deci, 0, "0.5 deci");
		assertEquals(uni, 0, "0.5 uni");
		
		local deci, uni = cPowaTimer:ExtractDigits(89.99);
		assertEquals(deci, 8, "89.99 deci up");
		assertEquals(uni, 9, "89.99 uni up");
		
		self:TearDown()
	end	
