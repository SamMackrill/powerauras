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
		local count = select("#", self:GetChildren());
		for i=1, count do
			if(checked) then
				select(i, self:GetChildren()):Show();
			else
				select(i, self:GetChildren()):Hide();
			end
		end
		-- Same for regions, except start at #6 - 1 through 5 are all internal ones.
		count = select("#", self:GetRegions());
		for i=6, count do
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
		else
			self:UnlockHighlight();
			self:SetHeight(25);
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

--- Lua style definition of frame. Used to demonstrate BuildFrameFromDefinition, which might be used for the editor.
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
									Type = "ScrollFrame",
									Inherits = "PowaScrollFrameTemplate",
									Points = {
										[1] = { "TOPLEFT", 4, -4 },
										[2] = { "BOTTOMRIGHT", -4, 4 },
									},
									Children = {
										ScrollChild = {
											Inherits = "PowaTitledFrameTemplate",
											Size = { 419, 1 },
											Points = {
												[1] = { "TOPLEFT", 0, 0 },
											},
											Children = {
												[1] = {
													ParentKey = "Texture",
													Type = "Class",
													Class = "FrameCategory",
													ClassArgs = PowaAuras.Text["UI_Editor_Aura_CatTexture"],
													Points = {
														[1] = { "TOPLEFT", 15, -70 },
														[2] = { "TOPRIGHT", -15, -70 },
													},
													OnLoad = function(self)
														for i=1, 3 do
															for j=0, 1, 0.01 do
																local tex = self:CreateTexture(nil, "OVERLAY");
																tex:SetPoint("TOPLEFT", (i-1)*64, -25-(j*100)*3);
																tex:SetSize(64, 3);
																if(i == 1) then
																	tex:SetTexture(j, 0, 0);
																elseif(i == 2) then
																	tex:SetTexture(0, j, 0);
																elseif(i == 3) then
																	tex:SetTexture(0, 0, j);
																end
															end
														end
														-- Status fix.
														self:UpdateChildren();
													end,
												},
												[2] = {
													ParentKey = "Style",
													Type = "Class",
													Class = "FrameCategory",
													ClassArgs = PowaAuras.Text["UI_Editor_Aura_CatStyle"],
													RelativeAnchor = "Texture",
													Points = {
														[1] = { "TOPLEFT", "BOTTOMLEFT", 0, -8 },
														[2] = { "TOPRIGHT", "BOTTOMRIGHT", 0, -8 },
													},
												},
												[3] = {
													ParentKey = "Size",
													Type = "Class",
													Class = "FrameCategory",
													ClassArgs = PowaAuras.Text["UI_Editor_Aura_CatSize"],
													RelativeAnchor = "Style",
													Points = {
														[1] = { "TOPLEFT", "BOTTOMLEFT", 0, -8 },
														[2] = { "TOPRIGHT", "BOTTOMRIGHT", 0, -8 },
													},
												},
											},
											OnLoad = function(self)
												-- Set title.
												self:SetTitle(PowaAuras.Text["UI_Editor_Aura"]);
												self:SetDescription(PowaAuras.Text("UI_Editor_CatSuffix", 
													PowaAuras.Text["UI_Editor_AuraDesc"]));
												-- Add UpdateLayout function.
												self.UpdateLayout = function(self)
													-- Calculate the height to display...
													-- Do not use GetBoundsRect to update the height - It will always 
													-- apply a scrollbar since it chains to all children.
													local height = 70; -- 70 (Height of title area) + 15 (Padding).
													-- Add height of child elements.
													local count = self:GetNumChildren();
													for i=1, count do
														-- +8 for the spacing between elements.
														height = height+select(i, self:GetChildren()):GetHeight()+8;
													end
													-- Update.
													self:SetHeight(height);
												end
												-- Call it.
												self:UpdateLayout();
											end,
										},
									},
									OnLoad = function(self)
										-- Set scroll child.
										self:SetScrollChild(self.ScrollChild);
										PowaAuras.UI:ScrollFrame(self);
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
			frame = PowaAuras.UI[def.Class](PowaAuras.UI, parent, 
				(def.ClassArgs and 
				(type(def.ClassArgs) == "table" and unpack(def.ClassArgs) or tostring(def.ClassArgs)) or nil));
		else
			PowaAuras.UI[def.Class](PowaAuras.UI, frame, 
				(def.ClassArgs and 
				(type(def.ClassArgs) == "table" and unpack(def.ClassArgs) or tostring(def.ClassArgs)) or nil));
		end
	elseif(type(def.Class) == "table") then
		for _, class in ipairs(def.Class) do
			PowaAuras.UI[class](PowaAuras.UI, frame, 
				(def.ClassArgs and 
				(type(def.ClassArgs) == "table" and unpack(def.ClassArgs) or tostring(def.ClassArgs)) or nil));
		end
	end
	-- Additional values.
	if(def.Values) then
		for key, data in pairs(def.Values) do
			frame[key] = data;
		end
	end
	-- Size...
	if(def.Size) then
		frame:SetSize(unpack(def.Size));
	end
	-- Position.
	if(def.Points) then
		-- Convert the relative anchor into something useful.
		if(def.RelativeAnchor) then
			def.RelativeAnchor = parent[def.RelativeAnchor] or _G[def.RelativeAnchor] or nil;
		end
		-- Boolean true = SetAllPoints.
		if(type(def.Points) == "boolean" and def.Points == true) then
			frame:SetAllPoints(def.RelativeAnchor or parent);
		elseif(type(def.Points) == "table") then
			for _, point in ipairs(def.Points) do
				if(not def.RelativeAnchor) then
					print(def.RelativeAnchor);
					frame:SetPoint(unpack(point));
				else
					frame:SetPoint(point[1], def.RelativeAnchor, unpack(point, 2));
				end
			end
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

-- Accepted definition keys:
-- 
-- Type (string): Represents the type of frame to create via the CreateFrame call, defaults to "Frame" if not given.
-- "FontString" and "Texture" are handled specially, along with "Class" which will not create a frame and instead relies
-- on the Class definition key to create a frame.
--
-- Inherits (string): Used to determine what frame template to inherit. Only valid if Type is not "Class".
--
-- Name (string): Global frame name, only valid if Type is not "Class".
--
-- Class (string, table): Specifies the main UI Widget class to inherit for the frame. If Type is set to "Class" then 
-- this key must be present as a string, and the class you are inheriting must return a frame via the constructor.
-- Accepts a table of classes to inherit.
--
-- ClassArgs (string, table): Passes these values as additional arguments to all Class initialiser functions.
--
-- Size (table): The size of the frame in width, height format.
--
-- Points (boolean, table[]): The points to set to the frame. If the value is a boolean representing "true", then 
-- SetAllPoints is called, otherwise each element in the table is unpacked and passed to a SetPoint call in turn.
--
-- RelativeAnchor (string): Allows you to set the relative anchor for all your points to another frame in the current
-- parent by naming its key.
--
-- Children (table[]): Table of child frame definitions, following this same format. Keys can either be numeric to 
-- assure ordered creation of frames, or string values which will represent the ParentKey attribute for this frame.
--
-- ParentKey (string): Defines the key to assign this frame to in the parent. Can be implied implicitly.
--
-- OnLoad (function): Optional function to be called after the frame has been created.
