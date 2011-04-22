-- Create definition.
PowaAuras.UI:Register("BrowserFrame", {
	Init = function(frame, min, max, update)
		-- Set up some values.
		frame.Page = 1;
		-- Setting either max/min to nil will result in no page limits.
		frame.MaxPage = max;
		frame.MinPage = min;
		-- This is supplied in the init function.
		frame.UpdatePage = update;
		-- Set page to 1.
		frame:SetPage(1);
	end,
	SetPage = function(self, page)
		-- Page boundaries.
		if(self.MinPage and page < self.MinPage) then page = self.MinPage; end
		if(self.MaxPage and page > self.MaxPage) then page = self.MaxPage; end
		-- Update page contents.
		self.Page = page;
		self:UpdatePage(page);
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
	NextPage = function(self)
		self:SetPage(self.Page+1);
	end,
	PrevPage = function(self)
		self:SetPage(self.Page-1);
	end,
	FirstPage = function(self)
		self:SetPage(self.MinPage or 1);
	end,
	LastPage = function(self)
		self:SetPage(self.MaxPage or 1);	
	end,
	SetMinPage = function(self, page)
		-- Update page.
		self.MinPage = page;
		self:SetPage(self.Page);
	end,
	SetMaxPage = function(self, page)
		-- Update page.
		self.MaxPage = page;
		self:SetPage(self.Page);
	end
});