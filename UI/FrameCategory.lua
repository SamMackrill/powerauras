-- Create definition.
PowaAuras.UI:Register("FrameCategory", {
	ReusableItems = {},
	Scripts = {
		OnClick = true,
		OnEnter = "UpdateTextures",
		OnLeave = "UpdateTextures",
		OnMouseDown = "UpdateTextures",
		OnMouseUp = "UpdateTextures",
		OnShow = "UpdateTextures",
		OnSizeChanged = true,
	},
	Hooks = {
		"SetChecked",
	},
	Construct = function(class, ui, parent, ...)
		-- Got any items or not?
		local item = nil;
		if(class.ReusableItems[1]) then
			-- Yay!
			item = class.ReusableItems[1];
			tremove(class.ReusableItems, 1);
			-- Skip to init.
			item:SetParent(parent);
			item:Init(...);
			return item;
		else
			-- Get making. Create the main header.
			item = CreateFrame("CheckButton", nil, parent, "PowaFrameCategoryTemplate");
			-- Reuse existing constructor.
			return ui.Construct(class, ui, item, ...);
		end
	end,
	Init = function(self, title)
		-- Update textures immediately.
		self:UpdateTextures();
		-- Keep a list of children.
		self.Children = {};
		-- Initial update.
		self:UpdateChildren();
		-- Title?
		self:SetTitle(title or "");
	end,
	AddChild = function(self, frame)
		-- Add, update.
		tinsert(self.Children, frame);
		self:UpdateChildren();
	end,
	GetTitle = function(self)
		return self.Title:GetText();
	end,
	OnClick = function(self)
		-- Sound effects are cool.
		PlaySound("igMainMenuOptionCheckBoxOn");
		-- Invert checked status (this inverts automatically, no questions why).
		self:UpdateChildren();
	end,
	OnSizeChanged = function(self, width, height)
		-- Updates the insets.
		self:SetHitRectInsets(0, 0, 0, (height > 25 and (height-25) or 0));
	end,
	Recycle = function(self)
		-- Place in recycle table!
		tinsert(self.ReusableItems, self);
		self:Hide();
	end,
	SetChecked = function(self, checked)
		-- Call normal func.
		self:__SetChecked(checked);
		-- Hide/Show children.
		for _, child in pairs(self.Children) do
			child[checked and "Show" or "Hide"](child);
		end
--		local count = self:GetNumChildren();
--		for i=1, count do
--			if(checked) then
--				select(i, self:GetChildren()):Show();
--			else
--				select(i, self:GetChildren()):Hide();
--			end
--		end
--		-- Same for regions, except start at #7 - 1 through 6 are all internal ones.
--		local count = self:GetNumRegions();
--		for i=7, count do
--			if(checked) then
--				select(i, self:GetRegions()):Show();
--			else
--				select(i, self:GetRegions()):Hide();
--			end
--		end
		-- Update.
		if(checked) then
			self:LockHighlight();
--			self:SetHeight((select(4, self:GetBoundsRect())) or 25);
			self:SetHeight(25);
			self.Expand:SetTexCoord(0, 0, 0, 0.6875, 0.9375, 0, 0.9375, 0.6875);
			self.Expand:SetSize(15, 11);
		else
			self:UnlockHighlight();
			self:SetHeight(25);
			self.Expand:SetTexCoord(1, 0, 0.0625, 0, 1, 0.6875, 0.0625, 0.6875);
			self.Expand:SetSize(11, 15);
		end
		-- Layout parent if needed.
		if(self:GetParent().UpdateLayout) then
			self:GetParent():UpdateLayout()
		end
	end,
	SetTitle = function(self, title)
		self.Title:SetText(title);
	end,
	UpdateChildren = function(self)
		-- Pipe call to SetChecked.
		self:SetChecked(self:GetChecked());
	end,
	UpdateTextures = function(self)
		-- Update.
		if(self:IsMouseOver() and IsMouseButtonDown() or not self:IsEnabled()) then
			self.NormalLeft:SetTexCoord(0.00195313, 0.12695313, 0.21875000, 0.41406250);
			self.NormalMiddle:SetTexCoord(0.13085938, 0.63085938, 0.42968750, 0.62500000);
			self.NormalRight:SetTexCoord(0.00195313, 0.12695313, 0.64062500, 0.83593750);
		else
			self.NormalLeft:SetTexCoord(0.00195313, 0.12695313, 0.00781250, 0.20312500);
			self.NormalMiddle:SetTexCoord(0.13085938, 0.63085938, 0.21875000, 0.41406250);
			self.NormalRight:SetTexCoord(0.00195313, 0.12695313, 0.42968750, 0.62500000);
		end
	end
});
