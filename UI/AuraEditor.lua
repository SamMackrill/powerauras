-- More definitions, yes please.
PowaAuras.UI:Register("AuraEditor", {
	Instance = nil,
	Scripts = {
		OnHide = true,
		OnShow = true,
	},
	Hooks = {
		"Show",
	},
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
	Init = function(self)		
		-- Close on escape key.
--		tinsert(UISpecialFrames, self:GetName());
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
	UpdateElements = function(self, auraID)
		-- Get the aura.
		auraID = auraID or 1;
		local aura = PowaAuras.Auras[auraID];
		if(not aura) then
			self.AuraID = nil;
			return;
		end
		-- Update ID.
		self.AuraID = auraID;
		-- Update controls.
		aura:UpdateTriggerTree(self.Tabs.Triggers.Tree);
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

--- Lua style definition of frame. Used to demonstrate BuildFrameFromDefinition, which might be used for the editor.
local AuraEditor = {
	Inherits = "PowaGenericFrameTemplate",
	Name = "PowaEditor",
	Class = "AuraEditor",
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
										Child = {
											Inherits = "PowaTitledFrameTemplate",
											Class = "EditorScrollChild",
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
											end,
										},
									},
									OnLoad = function(self)
										-- Set scroll child.
										self:SetScrollChild(self.Child);
										PowaAuras.UI:ScrollFrame(self);
									end,
								},
								[2] = {
									Type = "ScrollFrame",
									Inherits = "PowaScrollFrameTemplate",
									Points = {
										[1] = { "TOPLEFT", 4, -4 },
										[2] = { "BOTTOMRIGHT", -4, 4 },
									},
									Children = {
										Child = {
											Inherits = "PowaTitledFrameTemplate",
											Class = "EditorScrollChild",
											Size = { 419, 1 },
											Points = {
												[1] = { "TOPLEFT", 0, 0 },
											},
											OnLoad = function(self)
												-- Set title.
												self:SetTitle(PowaAuras.Text["UI_Editor_Timer"]);
												self:SetDescription(PowaAuras.Text("UI_Editor_CatSuffix", 
													PowaAuras.Text["UI_Editor_TimerDesc"]));
											end,
										},
									},
									OnLoad = function(self)
										-- Set scroll child.
										self:SetScrollChild(self.Child);
										PowaAuras.UI:ScrollFrame(self);
									end,
								},
								[3] = {
									Type = "ScrollFrame",
									Inherits = "PowaScrollFrameTemplate",
									Points = {
										[1] = { "TOPLEFT", 4, -4 },
										[2] = { "BOTTOMRIGHT", -4, 4 },
									},
									Children = {
										Child = {
											Inherits = "PowaTitledFrameTemplate",
											Class = "EditorScrollChild",
											Size = { 419, 1 },
											Points = {
												[1] = { "TOPLEFT", 0, 0 },
											},
											OnLoad = function(self)
												-- Set title.
												self:SetTitle(PowaAuras.Text["UI_Editor_Stacks"]);
												self:SetDescription(PowaAuras.Text("UI_Editor_CatSuffix", 
													PowaAuras.Text["UI_Editor_StacksDesc"]));
											end,
										},
									},
									OnLoad = function(self)
										-- Set scroll child.
										self:SetScrollChild(self.Child);
										PowaAuras.UI:ScrollFrame(self);
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
				Activation = {
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
								self:AddItem(1, PowaAuras.Text["UI_Editor_Activation"]);
								self:AddItem(2, PowaAuras.Text["UI_Editor_Rules"]);
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
--									Type = "ScrollFrame",
--									Inherits = "PowaScrollFrameTemplate",
--									Points = {
--										[1] = { "TOPLEFT", 4, -4 },
--										[2] = { "BOTTOMRIGHT", -4, 4 },
--									},
--									Children = {
--										Child = {
											Inherits = "PowaTitledFrameTemplate",
--											Class = "EditorScrollChild",
											Size = { 419, 1 },
											Points = {
												[1] = { "TOPLEFT", 0, 0 },
												[3] = { "BOTTOMRIGHT", 0, 0 },
											},
											Children = {
												Type = {
													Type = "Button",
													Inherits = "PowaLabelledDropdownTemplate",
													Points = {
														[1] = { "TOPLEFT", 15, -90 },
													},
													OnLoad = function(self)
														-- Set localized title.
														self:SetText("UI_Editor_Type");
														-- Initialise as dropdown, no settings/non-standard stuff.
														PowaAuras.UI:Dropdown(self);
														-- Add all possible types.
														for k, v in pairs(PowaAuras.BuffTypes) do
															self:AddItem(v, PowaAuras.Text["AuraType"][v], k);
														end
														-- Sort.
														self:SortItems();
													end,
												},
											},
											OnLoad = function(self)
												-- Set title.
												self:SetTitle(PowaAuras.Text["UI_Editor_Activation"]);
												self:SetDescription(PowaAuras.Text["UI_Editor_ActivationDesc"]);
											end,
--										},
--									},
--									OnLoad = function(self)
--										-- Set scroll child.
--										self:SetScrollChild(self.Child);
--										PowaAuras.UI:ScrollFrame(self);
--									end,
								},
								[2] = {
									Type = "ScrollFrame",
									Inherits = "PowaScrollFrameTemplate",
									Points = {
										[1] = { "TOPLEFT", 4, -4 },
										[2] = { "BOTTOMRIGHT", -4, 4 },
									},
									Children = {
										Child = {
											Inherits = "PowaTitledFrameTemplate",
											Class = "EditorScrollChild",
											Size = { 419, 1 },
											Points = {
												[1] = { "TOPLEFT", 0, 0 },
											},
											OnLoad = function(self)
												-- Set title.
												self:SetTitle(PowaAuras.Text["UI_Editor_Rules"]);
												self:SetDescription(PowaAuras.Text["UI_Editor_RulesDesc"]);
											end,
										},
									},
									OnLoad = function(self)
										-- Set scroll child.
										self:SetScrollChild(self.Child);
										PowaAuras.UI:ScrollFrame(self);
									end,
								},
							},
							OnLoad = function(self)
								-- Register class manually.
								PowaAuras.UI:TreeControlledTabFrame(self, self:GetParent().Tree);
								-- Add tabs.
								self:AddTab(self[1]);
								self:AddTab(self[2]);
								-- Select tab.
								self:SetSelectedTab(1);
							end,
						},
					},
				},
				Triggers = {
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
							end,
						},
						[2] = {
							ParentKey = "Tabs",
							Inherits = "PowaBorderedFrameTemplate",
							Points = {
								[1] = { "TOPLEFT", 177, -2 },
								[2] = { "BOTTOMRIGHT", -2, 2 },
							},
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
				self:AddTab(self.Activation, PowaAuras.Text["UI_Editor_TabActivation"], 
					"Interface\\Minimap\\Tracking\\Reagents");
				self:AddTab(self.Triggers, PowaAuras.Text["UI_Editor_TabTriggers"], 
					"Interface\\Minimap\\Tracking\\Reagents");
			end,
		},
	},
	OnLoad = function(self)
		-- Localize title.
		self.Title:SetText(PowaAuras.Text["UI_Editor"]);
	end,
};


-- Build editor.
PowaAuras.UI:BuildFrameFromDefinition(AuraEditor, UIParent);
-- Nil out the definition to save memory. Garbage collector will pick it up at some point.
AuraEditor = nil;
