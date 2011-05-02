-- Create definition.
PowaAuras.UI:Register("BrowserFrame", {
	Init = function(self, min, max, update)
		-- Set up some values.
		self.Page = 1;
		-- Setting either max/min to nil will result in no page limits.
		self.MaxPage = max;
		self.MinPage = min;
		-- This is supplied in the init function.
		self.OnPageChanged = (update or self.OnPageChanged);
		-- Set page to 1.
		self:SetPage(1);
	end,
	FirstPage = function(self)
		self:SetPage(self.MinPage or 1);
	end,
	LastPage = function(self)
		self:SetPage(self.MaxPage or 1);	
	end,
	NextPage = function(self)
		self:SetPage(self.Page+1);
	end,
	OnPageChanged = function(self)
	end,
	PrevPage = function(self)
		self:SetPage(self.Page-1);
	end,
	SetMaxPage = function(self, page)
		-- Update page.
		self.MaxPage = page;
		self:SetPage(self.Page);
	end,
	SetMinPage = function(self, page)
		-- Update page.
		self.MinPage = page;
		self:SetPage(self.Page);
	end,
	SetPage = function(self, page)
		-- Page boundaries.
		if(self.MinPage and page < self.MinPage) then page = self.MinPage; end
		if(self.MaxPage and page > self.MaxPage) then page = self.MaxPage; end
		-- Update page contents.
		self.Page = page;
		self:OnPageChanged(page);
		-- Enable/Disable buttons.
		if(not self.MinPage or self.Page > self.MinPage) then
			self.PrevPageButton:Enable();
		else
			self.PrevPageButton:Disable();		
		end
		if(not self.MaxPage or self.Page < self.MaxPage) then
			self.NextPageButton:Enable();
		else
			self.NextPageButton:Disable();		
		end
		-- Update page editbox.
		if(self.PageBox) then
			self.PageBox:SetText(page);
		end
	end,
});
