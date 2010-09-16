
	function TestPA:test_ClassShouldShow()
		self:SetUp();
		local BuffTypeNames = PowaAuras:ReverseTable(PowaAuras.BuffTypes);
		for bufftype,paClass in pairs(PowaAuras.AuraClasses) do
		    local aura = PowaAuras:AuraFactory(bufftype, 1, {buffname=BuffTypeNames[bufftype]});
			PowaAuras.Auras[aura.id] = aura;
			--TestPA.Debug = true;
			local result, reason = aura:ShouldShow(true);
			if (bufftype==PowaAuras.BuffTypes.Combo) then
				assertEquals(result, nil, BuffTypeNames[bufftype] .. "(" ..bufftype..")");
			elseif (bufftype==PowaAuras.BuffTypes.Static) then
				assertEquals(result, true, BuffTypeNames[bufftype] .. "(" ..bufftype..")");
			else
				assertEquals(result, false, BuffTypeNames[bufftype] .. "(" ..bufftype..")");
			end
		end
		self:TearDown();
	end

	
	function TestPA:test_SoloPaladinInitialAuras_ShouldShow()
		self:SetUp();
		--TestPA.Debug = true;
		self:SetupFor("SoloPaladin");
		
		self:AuraTest(1,  false, "player doesn't have buff Seal of Command");
		self:AuraTest(2,  false, "Not in combat");
		self:AuraTest(3,  false, "player Health not low enough");
		self:AuraTest(4,  false, "player Mana not low enough");
		self:AuraTest(5,  false, "player doesn't have buff Sacred Shield");
		self:AuraTest(6,  true,  "Action Ready");
		self:AuraTest(7,  false, "Not Mounted");
		self:AuraTest(8,  true,  "Action Ready");
		self:AuraTest(9,  false, "player doesn't have buff Sacred Shield");
		self:AuraTest(10, false, "Not in combat");
		
		self:AuraTest(25, false, "player doesn't have buff Infusion of Light");
		self:AuraTest(26, false, "player doesn't have buff Light's Grace");
		self:AuraTest(27, true,  "player has buff Seal of Wisdom");
		self:AuraTest(28, false, "player doesn't have buff Beacon");
		self:AuraTest(29, false, "player doesn't have buff Judgements of the Pure");
		
		self:AuraTest(50, false, "player doesn't have buff Vengeance");
		self:AuraTest(51, false, "player doesn't have buff Seal of the Martyr");
		self:TearDown();
	end
	
	function TestPA:EffectTest(auraId, expected, expectedReason)
		local aura= PowaAuras.Auras[auraId];
		if (aura==nil) then return; end;
		
		local BuffTypeNames = PowaAuras:ReverseTable(PowaAuras.BuffTypes);
        PowaAuras:UnitTestDebug("==================================");	
        PowaAuras:UnitTestDebug("TestingEffect aura",auraId,BuffTypeNames[aura.bufftype],aura.buffname);
		local result, reason = PowaAuras:TestThisEffect(auraId, true);
		assertEquals(result, expected, aura.id.." (" ..tostring(aura.buffname)..")");
		if (expectedReason) then
			assertEquals(reason, expectedReason, "Reason "..aura.id.." (" ..tostring(aura.buffname)..")");
		end
	end

	function TestPA:test_SoloPaladinInitialAuras_Effect()
		self:SetUp();
		self:SetupFor("SoloPaladin");
		
		self:EffectTest(1, false, "player doesn't have buff Seal of Command");
		self:EffectTest(2, false, "Not in combat");
		self:EffectTest(3, false, "player Health not low enough");
		self:EffectTest(4, false, "player Mana not low enough");
		self:EffectTest(5, false, "player doesn't have buff Sacred Shield");
		self:EffectTest(6, false, "Not in combat");
		--TestPA.Debug = true;
		self:EffectTest(7, false, "Not Mounted");
		self:EffectTest(8, false, "player Mana not low enough");
		self:EffectTest(9, false, "player doesn't have buff Sacred Shield");
		self:EffectTest(10, false, "Not in combat");
		
		self:EffectTest(25, false, "player doesn't have buff Infusion of Light");
		self:EffectTest(26, false, "player doesn't have buff Light's Grace");
		self:EffectTest(27, true,  "player has buff Seal of Wisdom");
		self:EffectTest(28, false, "player doesn't have buff Beacon");
		self:EffectTest(29, false, "player doesn't have buff Judgements of the Pure");
		
		self:EffectTest(50, false, "player doesn't have buff Vengeance");
		self:EffectTest(51, false, "player doesn't have buff Seal of the Martyr");
			
		self:TearDown();
	end
	

	function TestPA:test_SoloDruidGermanInitialAuras_Effect()
		self:SetUp();
		self:SetupFor("DruidGerman");
		
		self:EffectTest(1, false, "nicht im Kampf");
		self:EffectTest(2, false, "target hat nicht debuff Wirbelsturm");
		self:EffectTest(3, false, "target hat nicht debuff Wucherwurzeln");
		self:EffectTest(4, false, "target hat nicht debuff Demoralisierendes Gebrüll");
		--TestPA.Debug = true;
		self:EffectTest(5, true,  "target hat debuff Feenfeuer");
		self:EffectTest(6, false, "player hat nicht buff ???");
		self:EffectTest(7, false, "nicht im Kampf");
		self:EffectTest(8, false, "player hat nicht buff Berserker");
		self:EffectTest(9, false, "nicht im Kampf");
		self:EffectTest(10, false, "player hat nicht buff Wildes Brüllen");
		self:EffectTest(11, false, "player hat nicht buff Freizaubern");
		self:EffectTest(12, false, "player hat nicht buff Wilde Verteidigung");
		
		self:TearDown();
	end

	-- Buff
	
	function TestPA:test_Aura_Buff_Self_BuffMissing()
		self:SetUp();
		self:SetupFor("SoloPaladin");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="nonsuch"});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.buffname);
		assertEquals(reason, "player doesn't have buff nonsuch", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Buff_Self_BuffExists()
		self:SetUp();
		self:SetupFor("SoloPaladin");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="Wyrmrest Champion"});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "player has buff Wyrmrest Champion", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Buff_Self_BuffExists_MatchEnd()
		self:SetUp();
		self:SetupFor("SoloPaladin");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="Aura"});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "player has buff Aura", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	
	
	function TestPA:test_Aura_Buff_Self_BuffExists_ViaTexture()
		self:SetUp();
		self:SetupFor("SoloPaladin");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="INV_Misc_Head_Dragon_Red"});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "player has buff INV_Misc_Head_Dragon_Red", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Buff_Self_GroupOrSelf_BuffMissing()
		self:SetUp();
		self:SetupFor("SoloPaladin");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="nonsuch", groupOrSelf=true});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.buffname);
		assertEquals(reason, "player doesn't have buff nonsuch", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Buff_Self_GroupOrSelf_BuffExists()
		self:SetUp();
		self:SetupFor("SoloPaladin");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="Wyrmrest Champion", groupOrSelf=true});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "player has buff Wyrmrest Champion", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Buff_Party_BuffMissing()
		self:SetUp();
		self:SetupFor("Party");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="nonesuch", party=true,stacksOperator=">"});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.buffname);
		assertEquals(reason, "No one in party has buff nonesuch", "Reason "..aura.buffname);

		self:TearDown()
	end

	function TestPA:test_Aura_Buff_Party_BuffExists()
		self:SetUp();
		self:SetupFor("Party");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="Greater Blessing of Kings", party=true, stacksOperator=">="});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "party1 has buff Greater Blessing of Kings", "Reason "..aura.buffname);

		self:TearDown()
	end

	function TestPA:test_Aura_Buff_Party_BuffExistsOnAll()
		self:SetUp();
		self:SetupFor("Party");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="Greater Blessing of Kings", party=true, groupany=false, stacksOperator=">="});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "All in party have buff Greater Blessing of Kings", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Buff_Raid_BuffMissing()
		self:SetUp();
		self:SetupFor("BG1");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="nonesuch", raid=true,stacksOperator=">="});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.buffname);
		assertEquals(reason, "No one in raid has buff nonesuch", "Reason "..aura.buffname);

		self:TearDown()
	end

	function TestPA:test_Aura_Buff_Raid_BuffExists()
		self:SetUp();
		self:SetupFor("BG1");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="Retribution Aura", raid=true, stacksOperator=">="});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "raid2 has buff Retribution Aura", "Reason "..aura.buffname);

		self:TearDown()
	end

	function TestPA:test_Aura_Buff_Raid_BuffExistsOnAll()
		self:SetUp();
		self:SetupFor("BG1");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="Leader of the Pack", raid=true, groupany=false, stacksOperator=">="});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "All in raid have buff Leader of the Pack", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Buff_GroupOrSelfRaid_BuffMissing()
		self:SetUp();
		self:SetupFor("BG1");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="nonesuch", groupOrSelf=true,stacksOperator=">="});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.buffname);
		assertEquals(reason, "No one in raid has buff nonesuch", "Reason "..aura.buffname);

		self:TearDown()
	end

	function TestPA:test_Aura_Buff_GroupOrSelfRaid_BuffExists()
		self:SetUp();
		self:SetupFor("BG1");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="Retribution Aura", groupOrSelf=true, stacksOperator=">="});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "raid2 has buff Retribution Aura", "Reason "..aura.buffname);

		self:TearDown()
	end

	function TestPA:test_Aura_Buff_GroupOrSelfRaid_BuffExistsMultiple()
		self:SetUp();
		self:SetupFor("BG1");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="nonesuch/rubbish/Retribution Aura", groupOrSelf=true, stacksOperator=">="});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "raid2 has buff nonesuch/rubbish/Retribution Aura", "Reason "..aura.buffname);

		self:TearDown()
	end

	function TestPA:test_Aura_Buff_GroupOrSelfRaid_BuffExistsOnAll()
		self:SetUp();
		self:SetupFor("BG1");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="Leader of the Pack", groupOrSelf=true, groupany=false, stacksOperator=">="});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "All in raid have buff Leader of the Pack", "Reason "..aura.buffname);

		self:TearDown()
	end


	function TestPA:test_Aura_Buff_GroupOrSelfParty_BuffMissing()
		self:SetUp();
		self:SetupFor("Party");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="nonesuch", groupOrSelf=true,stacksOperator=">="});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.buffname);
		assertEquals(reason, "No one in party has buff nonesuch", "Reason "..aura.buffname);

		self:TearDown()
	end

	function TestPA:test_Aura_Buff_GroupOrSelfParty_BuffExists()
		self:SetUp();
		self:SetupFor("Party");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="Greater Blessing of Kings", groupOrSelf=true, stacksOperator=">="});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "player has buff Greater Blessing of Kings", "Reason "..aura.buffname);

		self:TearDown()
	end

	function TestPA:test_Aura_Buff_Solo_Defend()
		self:SetUp();
		self:SetupFor("Defend");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="Defend", inVehicle=true});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "player has buff Defend", "Reason "..aura.buffname);

		self:TearDown()
	end

	function TestPA:test_Aura_Buff_GroupOrSelfParty_BuffExistsOnAll()
		self:SetUp();
		self:SetupFor("Party");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 1, {buffname="Greater Blessing of Kings", groupOrSelf=true, groupany=false, stacksOperator=">="});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "All in party have buff Greater Blessing of Kings", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	-- Debuff
	
	function TestPA:test_Aura_Buff_Self_DebuffMissing()
		self:SetUp();
		self:SetupFor("SoloPaladin");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Debuff, 1, {buffname="nonsuch"});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.buffname);
		assertEquals(reason, "player doesn't have debuff nonsuch", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Buff_Self_DebuffExists()
		self:SetUp();
		self:SetupFor("BGDebuff");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Debuff, 1, {buffname="Crippling Poison"});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "player has debuff Crippling Poison", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Buff_Party_DebuffExists()
		self:SetUp();
		self:SetupFor("BGDebuff");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Debuff, 1, {buffname="Crippling Poison", party=true});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "party1 has debuff Crippling Poison", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Buff_Party_DebuffMissing()
		self:SetUp();
		self:SetupFor("BGDebuff");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Debuff, 1, {buffname="nonsuch", party=true});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.buffname);
		assertEquals(reason, "No one in party has debuff nonsuch", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Buff_Raid_DebuffExists()
		self:SetUp();
		self:SetupFor("BGDebuff");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Debuff, 1, {buffname="Frost Fever", raid=true});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "raid34 has debuff Frost Fever", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Buff_Raid_DebuffMissing()
		self:SetUp();
		self:SetupFor("BGDebuff");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Debuff, 1, {buffname="Nonsuch", raid=true});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.buffname);
		assertEquals(reason, "No one in raid has debuff Nonsuch", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	
	-- Type of Debuff
	
	function TestPA:test_Aura_Buff_Self_TypeDebuffMissing()
		self:SetUp();
		self:SetupFor("SoloPaladin");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.TypeDebuff, 1, {buffname="nonsuch"});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.buffname);
		assertEquals(reason, "player doesn't have debuff type nonsuch", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Buff_Self_TypeDebuffExists()
		self:SetUp();
		self:SetupFor("BGDebuff");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.TypeDebuff, 1, {buffname="Poison"});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "player has debuff type Poison", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Buff_Self_TypeDebuffExistsMultiple()
		self:SetUp();
		self:SetupFor("BGDebuff");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.TypeDebuff, 1, {buffname="Curse/Poison"});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "player has debuff type Curse/Poison", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Buff_Self_TypeDebuffExistsMultiple2()
		self:SetUp();
		self:SetupFor("BGDebuff");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.TypeDebuff, 1, {buffname="Poison/Curse"});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "player has debuff type Poison/Curse", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	
	function TestPA:test_Aura_Buff_Self_TypeDebuffDispellable()
		self:SetUp();
		self:SetupFor("Forbearance");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.TypeDebuff, 1, {buffname="*", mine=true});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.buffname);
		assertEquals(reason, "player doesn't have debuff type *", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	-- PvP
	function TestPA:test_Aura_Buff_Self_PvP_Yes()
		self:SetUp();
		self:SetupFor("BGDebuff");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.PvP, 1);
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.bufftype);
		assertEquals(reason, "player PvP flag set", "Reason "..aura.bufftype);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Buff_Self_PvP_No()
		self:SetUp();
		self:SetupFor("SoloPaladin");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.PvP, 1);
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.bufftype);
		assertEquals(reason, "player PvP flag not set", "Reason "..aura.bufftype);

		self:TearDown()
	end
	
	-- Health
	function TestPA:test_Aura_Buff_Self_Health_OK()
		self:SetUp();
		self:SetupFor("SoloPaladin");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Health, 1, {threshold=80});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.bufftype);
		assertEquals(reason, "player Health not low enough", "Reason "..aura.bufftype);

		self:TearDown()
	end
	function TestPA:test_Aura_Buff_Self_Health_Low()
		self:SetUp();
		self:SetupFor("BGDebuff");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Health, 1, {threshold=90});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.bufftype);
		assertEquals(reason, "player Health low", "Reason "..aura.bufftype);

		self:TearDown()
	end
	function TestPA:test_Aura_Buff_Self_Health_Low_Invert()
		self:SetUp();
		self:SetupFor("BGDebuff");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Health, 1, {threshold=90, thresholdinvert=true});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.bufftype);
		assertEquals(reason, "player Health not low enough", "Reason "..aura.bufftype);

		self:TearDown()
	end

	-- Mana
	function TestPA:test_Aura_Mana_OK_Self()
		self:SetUp();
		self:SetupFor("SoloPaladin");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Mana, 1, {threshold=80});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.bufftype);
		assertEquals(reason, "player Mana not low enough", "Reason "..aura.bufftype);

		self:TearDown()
	end
	function TestPA:test_Aura_Mana_Low_Self()
		self:SetUp();
		self:SetupFor("BGDebuff");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Mana, 1, {threshold=90});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.bufftype);
		assertEquals(reason, "player Mana low", "Reason "..aura.bufftype);

		self:TearDown()
	end
	function TestPA:test_Aura_Mana_Low_Self_Invert()
		self:SetUp();
		self:SetupFor("BGDebuff");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Mana, 1, {threshold=90, thresholdinvert=true});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.bufftype);
		assertEquals(reason, "player Mana not low enough", "Reason "..aura.bufftype);

		self:TearDown()
	end
	function TestPA:test_Aura_Mana_Low_Self_DoubleInvert()
		self:SetUp();
		self:SetupFor("BGDebuff");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Mana, 1, {threshold=90, thresholdinvert=true, invert=true});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.bufftype);
		assertEquals(reason, "player Mana not low enough", "Reason "..aura.bufftype);

		self:TearDown()
	end

	function TestPA:test_Aura_Buff_Self_Tooltip()
		self:SetUp();
		self:SetupFor("TooltipBuff");
		
		--TestPA.Debug = true;
		self:AuraTest(5, true, "player has buff Sacred Shield");
		self:AuraTest(9, false, "player doesn't have buff Sacred Shield");

		self:TearDown()
	end
	
	function TestPA:test_Aura_WeaponEnchant()
		self:SetUp();
		self:SetupFor("WeaponEnchant");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Enchant, 1, {buffname="rockbiter"});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "Main Hand rockbiter enchant found", "Reason "..aura.buffname);

		self:TearDown()
	end

	function TestPA:test_Aura_ActionReady()
		self:SetUp();
		self:SetupFor("SoloPaladin");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.ActionReady, 1, {buffname="Divine Plea"});
		aura.slot = 15;
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "Action Ready", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Aggro_Self_Missing()
		self:SetUp();
		self:SetupFor("SoloPaladin");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Aggro, 1);
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.bufftype);
		assertEquals(reason, "player does not have aggro", "Reason "..aura.bufftype);

		self:TearDown()
	end	
	
	function TestPA:test_Aura_Aggro_Self_Got()
		self:SetUp();
		self:SetupFor("Aggro");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Aggro, 1);
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.bufftype);
		assertEquals(reason, "player has aggro", "Reason "..aura.bufftype);

		self:TearDown()
	end

	function TestPA:test_Aura_Stance_Self()
		self:SetUp();
		self:SetupFor("SoloPaladin");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Stance, 1, {stance=7});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.bufftype);
		assertEquals(reason, "Current Stance 7, matches 7", "Reason "..aura.bufftype);

		self:TearDown()
	end

	function TestPA:test_Aura_SpellAlert_Casting()
		self:SetUp();
		self:SetupFor("SpellAlert");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.SpellAlert, 1, {buffname="Shadow Bolt", groupOrSelf=true, target=true});
		aura.target = true;
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "target casting Shadow Bolt", "Reason "..aura.buffname);

		self:TearDown()
	end

	function TestPA:test_Aura_SpellAlert_NoTarget()
		self:SetUp();
		self:SetupFor("SoloPaladin");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.SpellAlert, 1, {buffname="Shadow Bolt", groupOrSelf=true, target=true});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.buffname);
		assertEquals(reason, "groupOrSelftarget not casting Shadow Bolt", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	function TestPA:test_Aura_SpellAlert_CastingOther()
		self:SetUp();
		self:SetupFor("SpellAlert");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.SpellAlert, 1, {buffname="Fire Bolt", groupOrSelf=true, target=true});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.buffname);
		assertEquals(reason, "groupOrSelftarget not casting Fire Bolt", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Combo_TooLow()
		self:SetUp();
		self:SetupFor("Rogue");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Combo, 1, {buffname="2"});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.buffname);
		assertEquals(reason, "Combo points 1 no match with 2", "Reason "..aura.buffname);

		self:TearDown();
	end
	
	function TestPA:test_Aura_Combo_Upgrade()
		self:SetUp();
		
		PowaSet = {};
		PowaSet[1] = {id=1, bufftype=PowaAuras.BuffTypes.Combo, buffname="023"};
		--TestPA.Debug = true;
		PowaAuras:VARIABLES_LOADED()
		--TestPA.Debug = false;		
		assertEquals(PowaAuras.Auras[1].buffname, "0/2/3", "Combo Upgrade");

		self:TearDown();
	end
	
	function TestPA:test_Aura_Combo_JustRight()
		self:SetUp();
		self:SetupFor("Rogue");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Combo, 1, {buffname="1"});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.buffname);
		assertEquals(reason, "Combo points 1 match 1", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Combo_TooHigh()
		self:SetUp();
		self:SetupFor("Rogue");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Combo, 1, {buffname="0"});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.buffname);
		assertEquals(reason, "Combo points 1 no match with 0", "Reason "..aura.buffname);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Energy_OK()
		self:SetUp();
		self:SetupFor("Rogue");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.EnergyRagePower, 1, {threshold=90});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.bufftype);
		assertEquals(reason, "player Power low", "Reason "..aura.bufftype);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Energy_Low()
		self:SetUp();
		self:SetupFor("Rogue");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.EnergyRagePower, 1, {threshold=50});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.bufftype);
		assertEquals(reason, "player Power not low enough", "Reason "..aura.bufftype);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Energy_OK_Inverse()
		self:SetUp();
		self:SetupFor("Rogue");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.EnergyRagePower, 1, {threshold=90, thresholdinvert=true});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.bufftype);
		assertEquals(reason, "player Power not low enough", "Reason "..aura.bufftype);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Energy_Low_Inverse()
		self:SetUp();
		self:SetupFor("Rogue");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.EnergyRagePower, 1, {threshold=50, thresholdinvert=true});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.bufftype);
		assertEquals(reason, "player Power low", "Reason "..aura.bufftype);

		self:TearDown()
	end

	function TestPA:test_Aura_Rage_OK()
		self:SetUp();
		self:SetupFor("Warrior");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.EnergyRagePower, 1, {threshold=90});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.bufftype);
		assertEquals(reason, "player Power low", "Reason "..aura.bufftype);

		self:TearDown()
	end
	
	function TestPA:test_Aura_Rage_Low()
		self:SetUp();
		self:SetupFor("Warrior");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.EnergyRagePower, 1, {threshold=30});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.bufftype);
		assertEquals(reason, "player Power not low enough", "Reason "..aura.bufftype);

		self:TearDown()
	end

	function TestPA:test_Aura_RunicPower_OK()
		self:SetUp();
		self:SetupFor("DK");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.EnergyRagePower, 1, {threshold=90});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, true, aura.bufftype);
		assertEquals(reason, "player Power low", "Reason "..aura.bufftype);

		self:TearDown()
	end
	
	function TestPA:test_Aura_RunicPower_Low()
		self:SetUp();
		self:SetupFor("DK");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.EnergyRagePower, 1, {threshold=10});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.bufftype);
		assertEquals(reason, "player Power not low enough", "Reason "..aura.bufftype);

		self:TearDown()
	end	

	function TestPA:test_Aura_TypeDebuff_BossPlain()
		self:SetUp();
		self:SetupFor("DebuffOnBoss");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.TypeDebuff, 1, {buffname="Magic/Poison/Disease"});
		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.bufftype);
		assertEquals(reason, "player doesn't have debuff type Magic/Poison/Disease", "Reason "..aura.bufftype);

		self:TearDown()
	end	
	
	function TestPA:test_Aura_TypeDebuff_Boss()
		self:SetUp();
		self:SetupFor("DebuffOnBoss");
		
		local aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.TypeDebuff, 120, PowaSet[120]);

		PowaAuras.Auras[aura.id] = aura;
		--TestPA.Debug = true;
		local result, reason = aura:ShouldShow(true);			
		--TestPA.Debug = false;		
		assertEquals(result, false, aura.bufftype);
		assertEquals(reason, "No one in party has debuff type Magic/Disease/Poison", "Reason "..aura.bufftype);

		self:TearDown()
	end	
