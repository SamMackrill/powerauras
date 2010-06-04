
	function TestPA:test_CopyTable()
		self:SetUp();
		local PB = {};
		local PAStore = {};
		PB["Data"] = {a="a", b="b", c={d="d", e="e"}};
		PAStore["Data"] = PowaAuras:CopyTable(PB["Data"]);
		PB.Data.a = "Z";
		assertEquals(PAStore.Data.a, "a", "a");
		assertEquals(PAStore.Data.b, "b", "b");
		assertEquals(PAStore.Data.c.e, "e", "c.e");
		assertEquals(PAStore.Data.c.f, nil, "c.f");
		self:TearDown()
	end

	function TestPA:test_OperatorCollection()
		self:SetUp();
		assertEquals(PowaAuras.allowedOperators["="], true, "=");
		assertEquals(PowaAuras.allowedOperators["!"], true, "!");
		assertEquals(PowaAuras.allowedOperators[">"], true, ">");
		assertEquals(PowaAuras.allowedOperators["<"], true, "<");
		assertEquals(PowaAuras.allowedOperators[">="], true, ">=");
		assertEquals(PowaAuras.allowedOperators["<="], true, "<=");
		assertEquals(PowaAuras.allowedOperators["-"], true, "-");
		assertEquals(PowaAuras.allowedOperators["a"], nil, "a");
		assertEquals(PowaAuras.allowedOperators[""], nil, "blank");
		self:TearDown()
	end
