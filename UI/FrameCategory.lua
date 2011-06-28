-- Create definition.
PowaAuras.UI:Register("FrameCategory", {
	ReusableItems = {},
	Scripts = {
		OnDisable = "UpdateTextures",
		OnEnable = "UpdateTextures",
		OnEnter = "UpdateTextures",
		OnLeave = "UpdateTextures",
		OnMouseDown = true,
		OnMouseUp = true,
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
		-- Title?
		self:SetTitle(title or "");
	end,
	GetTitle = function(self)
		return self.Title:GetText();
	end,
	OnMouseDown = function(self)
		-- Button state doesn't update in time.
		if(self:IsEnabled()) then
			self:SetButtonState("PUSHED");
			self:UpdateTextures();
		end
		-- Sound effects are cool.
		PlaySound("igMainMenuOptionCheckBoxOn");
	end,
	OnMouseUp = function(self)
		-- Button state doesn't update in time.
		if(self:IsEnabled()) then
			self:SetButtonState("NORMAL");
			self:UpdateTextures();
		end
		-- Invert checked status.
		self:SetChecked(not self:GetChecked());
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
		local count = self:GetNumChildren();
		for i=1, count do
			if(checked) then
				select(i, self:GetChildren()):Show();
			else
				select(i, self:GetChildren()):Hide();
			end
		end
		-- Same for regions, except start at #7 - 1 through 6 are all internal ones.
		count = self:GetNumRegions();
		for i=7, count do
			if(checked) then
				select(i, self:GetRegions()):Show();
			else
				select(i, self:GetRegions()):Hide();
			end
		end
		-- Update.
		if(checked) then
			self:LockHighlight();
			self:SetHeight(select(4, self:GetBoundsRect()));
			self.Expand:SetTexCoord(0, 0.9375, 0.6875, 0);
		else
			self:UnlockHighlight();
			self:SetHeight(25);
			self.Expand:SetTexCoord(0, 0.9375, 0, 0.6875);
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
		-- Get state.
		local state = self:GetButtonState();
		if(state == "NORMAL" or state == "DISABLED") then
			self.NormalLeft:SetTexCoord(0.00195313, 0.12695313, 0.00781250, 0.20312500);
			self.NormalMiddle:SetTexCoord(0.13085938, .63085938, 0.21875000, 0.41406250);
			self.NormalRight:SetTexCoord(0.00195313, 0.12695313, 0.42968750, 0.62500000);
		elseif(state == "PUSHED") then
			self.NormalLeft:SetTexCoord(0.00195313, 0.12695313, 0.21875000, 0.41406250);
			self.NormalMiddle:SetTexCoord(0.13085938, 0.63085938, 0.42968750, 0.62500000);
			self.NormalRight:SetTexCoord(0.00195313, 0.12695313, 0.64062500, 0.83593750);
		end
	end
});
