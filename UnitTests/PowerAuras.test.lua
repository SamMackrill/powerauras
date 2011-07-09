package.path = "?;?.lua;..\\?;..\\?.lua";
require("luacov")
require("luaunit")
-- WowWAPI mocking
require("WoWmock")
-- Addon specific Mocking code
require("PowerAurasUIMock")
--Addon code
-- TODO Update required files to match new paths.
require("PowerAurasBase")
require("localisation")
require("localisation_frFR")
require("localisation_deDE")
require("localisation_ruRU")
require("localisation_zhCN")
require("localisation_zhTW")
require("localisation_koKR")
require("PowerAurasRole")
require("PowerAurasDump")
require("PowerAurasDecoratorClasses")
require("PowerAurasAuraClasses")
require("PowerAurasAnimations")
require("PowerAuras")
require("PowerAurasEvents")
require("PowerOptions")


function PowaAuras:UnitTestDebug(...)
	if (TestPA.Debug) then
		print(...);		
	end
end

function PowaAuras:UnitTestInfo(...)
	for k,v in pairs({...}) do
		TestPA.Output = TestPA.Output .. tostring(v) .. " ";
	end
	TestPA.Output = TestPA.Output .. "#";
end
	
TestPA = {Debug = false;} --aura

	function TestPA:ClassSetUp()

		this = {};
		this.GetName = GetName;
		
	end

	function TestPA:ClassTearDown()
		-- do nothing
	end

	function TestPA:SetUp()
		self.Debug = false;
		WoWMock.AltKeyDown = false;
		WoWMock.ControlKeyDown = false;
		_Paladin_is_Ready = false;
		WoWMock.Output = "";
		WoWMock.Target = "target";
		GameTooltip:SetOwner(nil);
		PowaSet = {};
		PowaGlobalSet = {};
		Timers = {};
		PowaAuras.Auras = {};
		self.Output = "";
	end

	function TestPA:TearDown()
		-- LuaUnit:SetVerbose(false);
	end
	
	function TestPA:SetupFor(dump, locale)
		dofile("dumps/"..dump..".lua"); -- to get the locale
		if (locale) then
			PowaState.Locale = locale;
		end
		dofile("GlobalStrings/"..PowaState.Locale..".lua");
		dofile("../PowerAurasBase.lua");
		dofile("../localisation.lua");
		dofile("../localisation_frFR.lua")
		dofile("../localisation_deDE.lua")
		dofile("../localisation_ruRU.lua")
		dofile("../localisation_zhCN.lua")
		dofile("../localisation_zhTW.lua")
		dofile("../localisation_koKR.lua")
		dofile("../PowerAurasRole.lua");
		dofile("../PowerAurasDump.lua");
		dofile("../PowerAurasDecoratorClasses.lua");
		dofile("../PowerAurasAuraClasses.lua");
		dofile("../PowerAurasAnimations.lua");
		dofile("../PowerAuras.lua");
		dofile("../PowerAurasEvents.lua");
		dofile("../PowerOptions.lua");

		dofile("dumps/"..dump..".lua"); -- to restore the settings
		
		PowaAuras.UnitTestDebug =
		function(self, ...)
			if (TestPA.Debug) then
				print(...);		
			end
		end
				
		PowaAuras.UnitTestInfo =
		function(self, ...)
			for k,v in pairs({...}) do
				TestPA.Output = TestPA.Output .. tostring(v) .. " ";
			end
			TestPA.Output = TestPA.Output .. "#";
		end
		
		if (locale) then
			PowaState.Locale = locale;
		end
 		for k,v in pairs(PowaState.Powa) do
			if (type(v)~="table") then
				PowaAuras[k] = v;
			end
		end
		PowaAuras:VARIABLES_LOADED();
		PowaAuras:PLAYER_ENTERING_WORLD();
	end
	

	function TestPA:AuraTest(auraId, expected, expectedReason)
		local BuffTypeNames = PowaAuras:ReverseTable(PowaAuras.BuffTypes);
		local aura = PowaAuras.Auras[auraId];
        PowaAuras:UnitTestDebug("============================");	
		PowaAuras:UnitTestDebug(auraId,"  Aura count", #PowaAuras.Auras, auraId);
        PowaAuras:UnitTestDebug("Testing aura",auraId,BuffTypeNames[aura.bufftype],aura.buffname);
		local result, reason = aura:ShouldShow(true);
		TestPA.Debug = false;
		assertEquals(result, expected, aura.id.." (" ..tostring(aura.buffname)..")");
		if (expectedReason) then
			assertEquals(reason, expectedReason, "Reason "..aura.id.." (" ..tostring(aura.buffname)..")");
		end
	end
	
--====TESTS START HERE ====


	function TestPA:test_WelcomeMessage()
		self:SetUp();
		TestPA:SetupFor("SoloPaladin");		
		assertEquals(WoWMock.Output, "|cffB0A0ff<Power Auras Classic>|r |cffffff00v2.6.2F|r - Type /powa to view the options.#", "Set-up");
		self:TearDown()
	end

	dofile("PowerAuras.test.Utils.lua");
	dofile("PowerAuras.test.TimerClass.lua");
	dofile("PowerAuras.test.AuraClass.lua");
	dofile("PowerAuras.test.Locales.lua");
	dofile("PowerAuras.test.ShouldShow.lua");
	dofile("PowerAuras.test.ActionReady.lua");
	dofile("PowerAuras.test.DisplayAndAnimate.lua");
	dofile("PowerAuras.test.Runes.lua");

LuaUnit.result.verbosity = 0;
LuaUnit:run();
