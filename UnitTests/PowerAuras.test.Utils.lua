
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

	function TestPA:test_MergeTables()
		self:SetUp();
		--TestPA.Debug = true;
		local data  = {a="a", b="b", c={d="d", e="e"}};
		local extra = {a="A", c={d="D", f="f"}};
		PowaAuras:MergeTables(data, extra);
		assertEquals(data.a, "A", "A");
		assertEquals(data.b, "b", "b");
		assertEquals(data.c.d, "D", "c.d");
		assertEquals(data.c.e, "e", "c.e");
		assertEquals(data.c.f, "f", "c.f");
		self:TearDown()
	end