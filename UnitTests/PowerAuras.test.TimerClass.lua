
	function TestPA:test_ExtractDigits()
		self:SetUp();
		
		local deci, uni = cPowaTimer:ExtractDigits(0, false);
		assertEquals(deci, 0, "0 deci");
		assertEquals(uni, 0, "0 uni");
		
		local deci, uni = cPowaTimer:ExtractDigits(1, false);
		assertEquals(deci, 0, "1 deci");
		assertEquals(uni, 1, "1 uni");
		
		local deci, uni = cPowaTimer:ExtractDigits(20, false);
		assertEquals(deci, 2, "20 deci");
		assertEquals(uni, 0, "20 uni");
		
		local deci, uni = cPowaTimer:ExtractDigits(73, false);
		assertEquals(deci, 7, "73 deci");
		assertEquals(uni, 3, "73 uni");
		
		local deci, uni = cPowaTimer:ExtractDigits(0.5, false);
		assertEquals(deci, 0, "0.5 deci");
		assertEquals(uni, 0, "0.5 uni");
		
		local deci, uni = cPowaTimer:ExtractDigits(0.5, true);
		assertEquals(deci, 0, "0.5 deci up");
		assertEquals(uni, 1, "0.5 uni up");
		
		local deci, uni = cPowaTimer:ExtractDigits(89.99, true);
		assertEquals(deci, 9, "89.99 deci up");
		assertEquals(uni, 0, "89.99 uni up");
		
		self:TearDown()
	end	
