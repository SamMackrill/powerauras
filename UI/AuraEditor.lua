-- More definitions, yes please.
PowaAuras.UI:Register("AuraEditor", {
	AdvancedElements = {}, -- It'll reference, but that's no problem. There's only 1 aura editor.
	Scripts = {
		OnHide = true,
		OnShow = true,
	},
	Hooks = {
		"Show",
	},
	Init = function(self)
		-- Hide advanced elements.
		self.Advanced:SetChecked(false);
		self:ToggleAdvanced(false);
		
		-- Close on escape key.
		tinsert(UISpecialFrames, self:GetName());
	end,
	Show = function(self)
		-- Make sure this stuff is correct...
		if(not self:UpdateElements(PowaBrowser:GetSelectedAura())) then
			self:Hide();
		else
			self:__Show();
		end
	end,
	OnHide = function(self)
		PlaySound("igMainMenuClose");
	end,
	OnShow = function(self)
		PlaySound("igCharacterInfoTab");
	end,
	RegisterAdvanced = function(self, element)
		tinsert(self.AdvancedElements, element);
	end,
	ToggleAdvanced = function(self, state)
		for _,v in ipairs(self.AdvancedElements) do
			if(state) then
				v:Show();
			else
				v:Hide();
			end
			if(v:GetParent().UpdateLayout) then v:GetParent():UpdateLayout(); end
		end
	end,
	UpdateElements = function(self, auraID)
		-- Get the aura.
		local aura = PowaAuras.Auras[auraID];
		if(not aura) then
			self.AuraID = nil;
			return;
		end
		-- Update ID.
		self.AuraID = auraID;
		-- Update controls.
		aura:UpdateTriggerTree(PowaEditorActivation.Triggers.Tree);		
		-- Toggle advanced elements.
		self:ToggleAdvanced(self.Advanced:GetChecked());
		-- Update some values.
		-- Force aura showing.
		PowaAuras:ToggleAuraDisplay(auraID, true);
		-- Done.
		return true;
	end,
	AddNewTrigger = function(self)
		PowaAuras:ShowText("Add New Trigger auraId=", PowaBrowser:GetSelectedAura());
	end,
});

PowaAuras.UI:Register("AuraEditor2", {
	Instance = nil,
	Construct = function(class, ui, frame, ...)
		-- Construct or return instance. Yes, this is in theory a singleton. I'm sorry.
		if(class.Instance) then
			return class.Instance;
		end
		-- Construct.
		ui.Construct(class, ui, frame, ...);
		-- Done.
		class.Instance = frame;
		return frame;
	end,
});

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
	},
	Construct = function(class, ui, parent, ...)
		-- Got any items or not?
		local item = nil;
		if(self.Items[1]) then
			-- Yay!
			item = self.ReusableItems[1];
			tremove(self.ReusableItems, 1);
			-- Skip to init.
			item:SetParent(parent);
			item:Init(...);
			return item;
		else
			-- Get making. Create the main header.
			item = CreateFrame("Button", nil, parent);
			item.Textures = {};
			item.Textures.Left = item:CreateTexture(nil, "ARTWORK");
			item.Textures.Middle = item:CreateTexture(nil, "ARTWORK");
			item.Textures.Right = item:CreateTexture(nil, "ARTWORK");
			-- Reuse existing constructor.
			return ui.Construct(class, ui, item, ...);
		end
	end,
	Init = function(self)
		-- Update textures immediately.
		self:UpdateTextures();
	end,
	OnMouseDown = function(self)
		-- Button state doesn't update in time.
		if(self:IsEnabled()) then
			self:SetButtonState("PUSHED");
			self:UpdateTextures();
		end
	end,
	OnMouseUp = function(self)
		-- Button state doesn't update in time.
		if(self:IsEnabled()) then
			self:SetButtonState("NORMAL");
			self:UpdateTextures();
		end
	end,
	Recycle = function(self)
		-- Place in recycle table!
		tinsert(self.ReusableItems, self);
		self:Hide();
	end,
	UpdateTextures = function(self)
		local state = self:GetButtonState();
	end
});

-- Lua style definition of frame. Used to demonstrate BuildFrameFromDefinition, which might be used for the editor.
local AuraEditor = {
	Inherits = "PowaGenericFrameTemplate",
	Name = "PowaEditor2",
	Class = "AuraEditor2",
	Size = { 760, 520 },
	Points = {
		[1] = { "CENTER" },
	},
	Children = {
		Tabs = {
			Inherits = "PowaBorderedFrameTemplate",
			Points = {
				[1] = { "TOPLEFT", 15, -60 },
				[2] = { "BOTTOMRIGHT", -15, 15 },
			},
			Children = {
				Display = {
					Points = {
						[1] = { "TOPLEFT", 4, -4 },
						[2] = { "BOTTOMRIGHT", -4, 5 },
					},
					Children = {
						[1] = {
							ParentKey = "Tree",
							Inherits = "PowaTreeViewTemplate",
							Class = "TreeView",
							Points = {
								[1] = { "TOPLEFT", 2, -2 },
								[2] = { "BOTTOMLEFT", 2, 2 },
							},
							OnLoad = function(self)
								self:AddItem(1, PowaAuras.Text["UI_Editor_Aura"]);
								self:AddItem(2, PowaAuras.Text["UI_Editor_Timer"]);
								self:AddItem(3, PowaAuras.Text["UI_Editor_Stacks"]);
							end,
						},
						[2] = {
							ParentKey = "Tabs",
							Inherits = "PowaBorderedFrameTemplate",
							Points = {
								[1] = { "TOPLEFT", 177, -2 },
								[2] = { "BOTTOMRIGHT", -2, 2 },
							},
							Children = {
								[1] = {
									Inherits = "PowaTitledFrameTemplate",
									Points = true,
									OnLoad = function(self)
										self:SetTitle(PowaAuras.Text["UI_Editor_Aura"]);
										self:SetDescription(PowaAuras.Text["UI_Editor_AuraDesc"]);
									end,
								},
								[2] = {
									Inherits = "PowaTitledFrameTemplate",
									Points = true,
									OnLoad = function(self)
										self:SetTitle(PowaAuras.Text["UI_Editor_Timer"]);
									end,
								},
								[3] = {
									Inherits = "PowaTitledFrameTemplate",
									Points = true,
									OnLoad = function(self)
										self:SetTitle(PowaAuras.Text["UI_Editor_Stacks"]);
									end,
								},
							},
							OnLoad = function(self)
								-- Register class manually.
								PowaAuras.UI:TreeControlledTabFrame(self, self:GetParent().Tree);
								-- Add tabs.
								self:AddTab(self[1]);
								self:AddTab(self[2]);
								self:AddTab(self[3]);
								-- Select tab.
								self:SetSelectedTab(1);
							end,
						},
					},
				},
			},
			OnLoad = function(self)
				-- Register class.
				PowaAuras.UI:TabFrame(self, "TabButton");
				-- Add tabs.
				self:AddTab(self.Display, PowaAuras.Text["UI_Editor_TabDisplay"], 
					"Interface\\Minimap\\Tracking\\Reagents");
			end,
		},
	},
	OnLoad = function(self)
		-- Localize title.
		self.Title:SetText(PowaAuras.Text["UI_Editor"]);
	end,
};

--- Builds a frame from a table based definition. This allows you to bypass using XML for frame creation while also
-- handling all of the boring SetPoint/SetSize calls that are otherwise present.
-- @param def The definition to load.
-- @param parent The parent frame of the frame.
local function BuildFrameFromDefinition(def, parent)
	-- Fix type.
	if(not def.Type) then
		def.Type = "Frame";
	end
	-- Frame or something else?
	local frame;
	if(def.Type == "FontString" or def.Type == "Texture") then
		-- Make layered object.
		frame = parent["Create" .. def.Type](parent, def.Name, def.Layer, def.Inherits, def.SubLevel);
	elseif(def.Type ~= "Class") then
		-- Make frame if not Class type. Class type means instantiate the class without a frame.
		frame = CreateFrame(def.Type or "Frame", def.Name, parent, def.Inherits);
	end
	-- Classes.
	if(type(def.Class) == "string") then
		if(def.Type == "Class") then
			frame = PowaAuras.UI[def.Class](PowaAuras.UI, parent, (def.ClassArgs and unpack(def.ClassArgs) or nil));
		else
			PowaAuras.UI[def.Class](PowaAuras.UI, frame, (def.ClassArgs and unpack(def.ClassArgs) or nil));
		end
	elseif(type(def.Class) == "table") then
		for _, class in ipairs(def.Class) do
			PowaAuras.UI[class](PowaAuras.UI, frame, (def.ClassArgs and unpack(def.ClassArgs) or nil));
		end
	end
	-- Size...
	if(def.Size) then
		frame:SetSize(unpack(def.Size));
	end
	-- Position.
	if(def.Points) then
		-- Boolean true = SetAllPoints.
		if(type(def.Points) == "boolean" and def.Points == true) then
			frame:SetAllPoints(parent);
		elseif(type(def.Points) == "table") then
			for _, point in ipairs(def.Points) do
				frame:SetPoint(unpack(point));
			end
		end
	end
	-- Keys.
	if(def.Keys) then
		for key, data in pairs(def.Keys) do
			frame[key] = data;
		end
	end
	-- Children.
	if(def.Children) then
		for key, child in pairs(def.Children) do
			frame[child.ParentKey or key] = BuildFrameFromDefinition(child, frame);
		end
	end
	-- OnLoad func.
	if(def.OnLoad) then
		def.OnLoad(frame);
	end
	-- Done.
	return frame;
end

-- Build editor.
BuildFrameFromDefinition(AuraEditor, UIParent);
-- Nil out the definition to save memory. Garbage collector will pick it up at some point.
AuraEditor = nil;
