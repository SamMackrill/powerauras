	
	function TestPA:test_ActionReady_ShouldShow()
		self:SetUp();
		TestPA.Debug = false;
		self:SetupFor("ActionUsable");
		
		self:AuraTest(15,  true, "Action Ready");

		self:TearDown();
	end
