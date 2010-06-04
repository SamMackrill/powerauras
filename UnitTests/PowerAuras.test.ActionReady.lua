	
	function TestPA:test_ActionReady_ShouldShow()
		self:SetUp();
		TestPA.Debug = true;
		self:SetupFor("ActionUsable");
		
		self:AuraTest(15,  true, "Action Ready");

		self:TearDown();
	end
