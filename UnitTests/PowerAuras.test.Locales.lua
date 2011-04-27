
	function TestPA:test_deDE()
		self:SetUp();
		TestPA:SetupFor("SoloPaladin", "deDE");		
		assertEquals(WoWMock.Output, "|cffB0A0ff<Power Auras Classic>|r |cffffff00v2.6.2F|r - Gib /powa ein, um die Optionen zu öffnen.#");
		self:TearDown()
	end

	function TestPA:test_frFR()
		self:SetUp();
		TestPA:SetupFor("SoloPaladin", "frFR");		
		assertEquals(WoWMock.Output, "|cffB0A0ff<Power Auras Classic>|r |cffffff00v2.6.2F|r - Tapez /powa pour afficher les options.#");
		self:TearDown()
	end

	function TestPA:test_ruRU()
		self:SetUp();
		TestPA:SetupFor("SoloPaladin", "ruRU");		
		assertEquals(WoWMock.Output, "|cffB0A0ff<Power Auras Classic>|r |cffffff00v2.6.2F|r - Для просмотра настроек введите /powa.#");
		self:TearDown()
	end

	function TestPA:test_zhCN()
		self:SetUp();
		TestPA:SetupFor("SoloPaladin", "zhCN");		
		assertEquals(WoWMock.Output, "|cffB0A0ff<Power Auras Classic>|r |cffffff00v2.6.2F|r - 输入 /powa 打开特效编辑器.#");
		self:TearDown()
	end

	function TestPA:test_zhTW()
		self:SetUp();
		TestPA:SetupFor("SoloPaladin", "zhTW");		
		assertEquals(WoWMock.Output, "|cffB0A0ff<Power Auras Classic>|r |cffffff00v2.6.2F|r - 輸入 /powa 打開特效編輯器.#");
		self:TearDown()
	end

	function TestPA:test_koKR()
		self:SetUp();
		TestPA:SetupFor("SoloPaladin", "koKR");		
		assertEquals(WoWMock.Output, "|cffB0A0ff<Power Auras Classic>|r |cffffff00v2.6.2F|r - 옵션을 볼려면 /powa를 입력하십시오.#");
		self:TearDown()
	end




