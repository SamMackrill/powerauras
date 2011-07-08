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
		-- Hook browser scripts. Don't call SetScript as we don't want this overwritten.
		PowaBrowser:HookScript("OnSelectedAuraChanged", function(browser, id) self:UpdateElements(id); end);
		-- Close on escape key.
--		tinsert(UISpecialFrames, self:GetName());
		-- When the editor is up, we redisplay the aura a lot - but we don't want to do it too often so we need a
		-- throttle! (We throttle because there's a very tiny memory leak in redisplaying).
		self.IsUpdatePending = false;
		self.IsThrottled = false;
		self.Throttle = 0;
		-- Count the total # of aura textures for Default/WoW.
		self.DefaultCount = 0;
		self.WoWCount = 0;
		local defaultExists, wowExists, texobj, i = true, true, self.Tabs.Display.Tabs[1].Child.TextureDummy.Texture, 1;
		while(defaultExists or wowExists) do
			-- Defaults first.
			texobj:SetTexture(strconcat(PowaAuras.AuraSource, "Aura", i, ".tga"));
			if(texobj:GetTexture()) then
				self.DefaultCount = self.DefaultCount+1;
				defaultExists = true;
			else
				defaultExists = false;
			end
			-- WoW next.
			texobj:SetTexture(PowaAuras.WowTextures[i]);
			if(texobj:GetTexture()) then
				self.WoWCount = self.WoWCount+1;
				wowExists = true;
			else
				wowExists = false;
			end
			-- Next!
			i = i+1;
		end
		-- And how do we know when to update, you ask? Simple, we need a callback too.
		PowaAuras:RegisterSettingCallback(self.OnSettingChanged);
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
	OnSettingChanged = function(key, value, location)
		-- Discard if not an aura setting.
		if(not PowaAuras.ModTest or location ~= PowaAuras.SettingLocations.Aura) then
			return;
		end
		-- Get editor.
		local self = PowaEditor;
		-- Always update the editor, regardless of the throttle.
		self:UpdateAuraPreview();
		-- Throttled or not?
		if(not self.IsThrottled) then
			-- Throttle now.
			self.IsThrottled = true;
			self:SetScript("OnUpdate", self.OnUpdate);
			-- Redisplay aura.
			local aura = PowaBrowser:GetSelectedAura() or -1;
			-- Call twice in no-update mode.
			PowaAuras:ToggleAuraDisplay(aura, false, true);
			PowaAuras:ToggleAuraDisplay(aura, true, true);
		else
			-- We're throttled!
			self.IsUpdatePending = true;
		end
	end,
	OnUpdate = function(self, elapsed)
		-- Cancel script if ModTest is false.
		if(not PowaAuras.ModTest) then
			self:SetScript("OnUpdate", nil);
			self.IsThrottled = false;
			self.IsUpdatePending = false;
			self.Throttle = 0;
		end
		-- Update progress.
		self.Throttle = self.Throttle+elapsed;
		if(self.Throttle < 0.25) then
			return;
		end
		-- No longer throttled.
		self:SetScript("OnUpdate", nil);
		self.IsThrottled = false;
		self.Throttle = 0;
		-- Pending?
		if(self.IsUpdatePending) then
			-- Update forcibly.
			self.IsUpdatePending = false;
			self.OnSettingChanged(nil, nil, PowaAuras.SettingLocations.Aura);
		end
	end,
	UpdateAuraPreview = function(self)
		-- Update the preview based on the source type of the aura.
		local source = PowaAuras:GetSetting("Aura.SourceType");
		local label, texture = self.Tabs.Display.Tabs[1].Child.TextureSource.Default.Label, 
			self.Tabs.Display.Tabs[1].Child.TextureDummy.Texture;
		if(source == PowaAuras.SourceTypes.Default) then
			-- Default texture.
			local num = PowaAuras:GetSetting("Aura.texture");
			label:SetText(PowaAuras.Text("UI_Editor_Aura_SourceNum", num, self.DefaultCount));
			texture:SetTexture(strconcat(PowaAuras.AuraSource, "Aura", num, ".tga"));
		elseif(source == PowaAuras.SourceTypes.WoW) then
			-- WoW texture.
			local num = PowaAuras:GetSetting("Aura.texture");
			label:SetText(PowaAuras.Text("UI_Editor_Aura_SourceNum", num, self.WoWCount));
			texture:SetTexture(PowaAuras.WowTextures[num]);
		end
		-- Style it. Trim its nails and stuff.
		if(PowaAuras:GetSetting("Aura.randomcolor")) then
			texture:SetVertexColor(random(20,100)/100, random(20,100)/100, random(20,100)/100);
		else
			texture:SetVertexColor(PowaAuras:GetSetting("Aura.r"), PowaAuras:GetSetting("Aura.g"), 
				PowaAuras:GetSetting("Aura.b"));
		end
		texture:SetBlendMode(PowaAuras:GetSetting("Aura.texmode") and "ADD" or "DISABLE");
		texture:SetAlpha(min(0.99, PowaAuras:GetSetting("Aura.alpha")));
		-- Rotation, rotation, rotation.
		PowaAuras:RotateTexture(texture, PowaAuras:GetSetting("Aura.Rotate"), PowaAuras:GetFlipTexCoords());
	end,
	UpdateElements = function(self, auraID)
		-- Hide old aura if it exists.
		if(self.AuraID and PowaAuras.Auras[self.AuraID]) then
			PowaAuras:ToggleAuraDisplay(self.AuraID, false);
		end
		-- Get the aura, make sure it exists or bail.
		auraID = auraID or 1;
		local aura = PowaAuras.Auras[auraID];
		if(not aura) then
			self.AuraID = nil;
			self:Hide();
			return;
		end
		-- Update ID.
		self.AuraID = auraID;
		-- Update controls.
		aura:UpdateTriggerTree(self.Tabs.Triggers.Tree);
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
	Size = { 760, 528 },
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
							Inherits = "PowaBorderedFrameTemplate",
							Class = "TreeView",
							Size = { 172, 1 },
							Points = {
								[1] = { "TOPLEFT", 2, -2 },
								[2] = { "BOTTOMLEFT", 2, 2 },
							},
							OnLoad = function(self)
								self:AddItem(1, PowaAuras.Text["UI_Editor_Aura"]);
								self:AddItem(2, PowaAuras.Text["UI_Editor_Timer"]);
								self:AddItem(3, PowaAuras.Text["UI_Editor_Stacks"]);
								self:AddItem(4, PowaAuras.Text["UI_Editor_Text"]);
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
									Class = "ScrollFrame",
									Points = {
										[1] = { "TOPLEFT", 4, -4 },
										[2] = { "BOTTOMRIGHT", -4, 4 },
									},
									Children = {
										Child = {
											Inherits = "PowaTitledFrameTemplate",
											Class = "LayoutFrame",
											Size = { 350, 1 },
											Points = {
												[1] = { "TOPLEFT", 0, 0 },
											},
											Children = {
												TextureDummy = {
													Size = { 1, 128 },
													Children = {
														Texture = {
															Type = "Texture",
															Layer = "ARTWORK",
															Size = { 128, 128 },
															Points = {
																[1] = { "CENTER", 0, 0 },
															},
															OnLoad = function(self)
																self:SetTexture(0, 1, 0);
															end,
														},
													},
												},
												TextureSource = {
													Size = { 1, 128 },
													Children = {
														Source = {
															Type = "Button",
															Inherits = "PowaLabelledDropdownTemplate",
															Class = "Dropdown",
															ClassArgs = { 
																"Aura.SourceType", true, "UI_Editor_Aura_Source" },
															Points = {
																[1] = { "TOPLEFT", 4, -17 },
															},
															OnLoad = function(self)
																-- Add necessary items.
																for k, v in pairs(PowaAuras.Text["UI_Sources"]) do
																	self:AddItem(k, v);
																end
																-- Scrollframe fix.
																self:SetScript("OnDropdownMenuPosition", function(self)
																	-- Normal position.
																	self.Menu:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 
																		0, 0);
																	self.Menu:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 
																		0, 0);
																	-- Update.
																	self:UpdateText(self:GetSetting());
																	-- Parent to scrollframe.
																	self.Menu:SetParent(
																		self:GetParent():GetParent():GetParent());
																end);
															end,
														},
														Default = {
															Points = {
																[1] = { "TOPLEFT", 4, -43 },
																[2] = { "BOTTOMRIGHT", -4, 0 },
															},
															Children = {
																Prev = {
																	Type = "Button",
																	Size = { 32, 32 },
																	Points = {
																		[1] = { "BOTTOMLEFT", 0, 0 }
																	},
																	OnLoad = function(self)
																		self:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up");
																		self:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down");
																		self:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled");
																		self:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD");
																		-- OnClicky.
																		self:SetScript("OnClick", function(self)
																			PowaAuras:SaveSetting("Aura.texture", 
																				max(1, PowaAuras:GetSetting("Aura.texture")-1));
																		end);
																	end,
																},
																Label = {
																	Type = "FontString",
																	Inherits = "PowaFontHighlight",
																	RelativeAnchor = true,
																	Points = {
																		[1] = { "TOPLEFT", "BOTTOMLEFT", 36, 32 },
																		[2] = { "BOTTOMRIGHT", -36, 16 },
																	},
																},
																Error = {
																	Type = "FontString",
																	Inherits = "PowaFontHighlight",
																	RelativeAnchor = true,
																	Points = {
																		[1] = { "TOPLEFT", "BOTTOMLEFT", 36, 16 },
																		[2] = { "BOTTOMRIGHT", -36, 0 },
																	},
																	Text = PowaAuras.Text["UI_Editor_Aura_SourceErr"],
																},
																Next = {
																	Type = "Button",
																	Size = { 32, 32 },
																	Points = {
																		[1] = { "BOTTOMRIGHT", 0, 0 }
																	},
																	OnLoad = function(self)
																		self:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up");
																		self:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down");
																		self:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled");
																		self:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD");
																		-- OnClicky.
																		self:SetScript("OnClick", function(self)
																			PowaAuras:SaveSetting("Aura.texture", 
																				PowaAuras:GetSetting("Aura.texture")+1);
																		end);
																	end,
																},
															},
														},
														WoW = {
															Points = {
																[1] = { "TOPLEFT", 4, -43 },
																[2] = { "BOTTOMRIGHT", -4, 0 },
															},
															Children = {
																Prev = {
																	Type = "Button",
																	Size = { 32, 32 },
																	Points = {
																		[1] = { "BOTTOMLEFT", 0, 0 }
																	},
																	OnLoad = function(self)
																		self:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up");
																		self:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down");
																		self:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled");
																		self:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD");
																		-- OnClicky.
																		self:SetScript("OnClick", function(self)
																			PowaAuras:SaveSetting("Aura.texture", 
																				max(1, PowaAuras:GetSetting("Aura.texture")-1));
																		end);
																	end,
																},
																Label = {
																	Type = "FontString",
																	Inherits = "PowaFontHighlight",
																	RelativeAnchor = true,
																	Points = {
																		[1] = { "TOPLEFT", "BOTTOMLEFT", 36, 32 },
																		[2] = { "BOTTOMRIGHT", -36, 16 },
																	},
																},
																Error = {
																	Type = "FontString",
																	Inherits = "PowaFontHighlight",
																	RelativeAnchor = true,
																	Points = {
																		[1] = { "TOPLEFT", "BOTTOMLEFT", 36, 16 },
																		[2] = { "BOTTOMRIGHT", -36, 0 },
																	},
																	Text = PowaAuras.Text["UI_Editor_Aura_SourceErr"],
																},
																Next = {
																	Type = "Button",
																	Size = { 32, 32 },
																	Points = {
																		[1] = { "BOTTOMRIGHT", 0, 0 }
																	},
																	OnLoad = function(self)
																		self:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up");
																		self:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down");
																		self:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled");
																		self:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD");
																		-- OnClicky.
																		self:SetScript("OnClick", function(self)
																			PowaAuras:SaveSetting("Aura.texture", 
																				PowaAuras:GetSetting("Aura.texture")+1);
																		end);
																	end,
																},
															},
														},
														Custom = {
															Type = "Texture",
															Points = {
																[1] = { "TOPLEFT", 4, -43 },
																[2] = { "BOTTOMRIGHT", -4, 0 },
															},
															Layer = "BACKGROUND",
															Texture = { 0.75, 0, 0.75 },
														},
														Text = {},
														Icon = {}, -- Blank frame for icon.
													},
													OnLoad = function(self)
														-- I am tab frame, the framiest of the tabs. Behold my glory.
														PowaAuras.UI:SourceControlledTabFrame(self, self.Source, 
															"OnDropdownItemSelected");
														-- Add tabs.
														self:AddTab(self.Default);
														self:AddTab(self.WoW);
														self:AddTab(self.Custom);
														self:AddTab(self.Text);
														self:AddTab(self.Icon);
														-- Update selection.
														self:SetSelectedTab(self.Source:GetSelectedKey());
													end,
												},
												CatStyle = {
													Type = "Class",
													Class = "FrameCategory",
													ClassArgs = PowaAuras.Text["UI_Editor_Aura_CatStyle"],
												},
												StyleOpacity = {
													Type = "Slider",
													Inherits = "PowaSliderTemplate",
													OnLoad = function(self)
														-- Set min/max.
														self:SetMinMaxValues(0, 1);
														self:SetValueStep(0.01);
														-- Slider, go!
														PowaAuras.UI:Slider(self, "UI_Editor_Aura_Opacity", 
															"Aura.alpha");
														-- Helper method to make this easier.
														self:SetFormat("%.2f");
													end,
												},
												StyleRotate = {
													Type = "Slider",
													Inherits = "PowaSliderTemplate",
													OnLoad = function(self)
														-- Set min/max.
														self:SetMinMaxValues(0, 360);
														self:SetValueStep(1);
														-- Slider, go!
														PowaAuras.UI:Slider(self, "UI_Editor_Aura_Rotate", 
															"Aura.Rotate");
													end,
												},
												StyleColor = {
													Type = "CheckButton",
													Inherits = "PowaColorPickerTemplate",
													Class = "AuraColorPicker",
													Text = "UI_Editor_Aura_Color",
												},
												StyleRndColor = {
													Type = "CheckButton",
													Inherits = "PowaCheckboxTemplate",
													Class = "Checkbox",
													ClassArgs = "Aura.randomcolor",
													Text = "UI_Editor_Aura_RndColor",
												},
												StyleGlow = {
													Type = "CheckButton",
													Inherits = "PowaCheckboxTemplate",
													Class = "Checkbox",
													ClassArgs = "Aura.texmode",
													Text = "UI_Editor_Aura_Glow",
												},
												CatSize = {
													Type = "Class",
													Class = "FrameCategory",
													ClassArgs = PowaAuras.Text["UI_Editor_Aura_CatSize"],
												},
												SizeSizeX = {
													Type = "Slider",
													Inherits = "PowaSliderTemplate",
													OnLoad = function(self)
														-- Set min/max.
														self:SetMinMaxValues(16, 512);
														self:SetValueStep(1);
														-- Slider, go!
														PowaAuras.UI:Slider(self, "UI_Editor_Aura_SizeX", "Aura.SizeX");
													end,
												},
												SizeSizeY = {
													Type = "Slider",
													Inherits = "PowaSliderTemplate",
													OnLoad = function(self)
														-- Set min/max.
														self:SetMinMaxValues(16, 512);
														self:SetValueStep(1);
														-- Slider, go!
														PowaAuras.UI:Slider(self, "UI_Editor_Aura_SizeY", "Aura.SizeY");
													end,
												},
												SizeScale = {
													Type = "Slider",
													Inherits = "PowaSliderTemplate",
													OnLoad = function(self)
														-- Set min/max.
														self:SetMinMaxValues(0.01, 5);
														self:SetValueStep(0.01);
														-- Slider, go!
														PowaAuras.UI:Slider(self, "UI_Editor_Aura_Scale", "Aura.size");
														-- Helper method to make this easier.
														self:SetFormat("%.2f");
													end,
												},
												SizePosX = {
													Type = "EditBox",
													Inherits = "PowaLabelledEditBoxTemplate",
													Class = "NumericSettingsEditBox",
													ClassArgs = { "UI_Editor_Aura_PosX", "Aura.x", 0 },
												},
												SizePosY = {
													Type = "EditBox",
													Inherits = "PowaLabelledEditBoxTemplate",
													Class = "NumericSettingsEditBox",
													ClassArgs = { "UI_Editor_Aura_PosY", "Aura.y", 0 },
												},
												-- Do dropdowns last to prevent the child frame strata bug.
												StyleFlip = {
													Type = "Button",
													Inherits = "PowaLabelledDropdownTemplate",
													Class = "Dropdown",
													ClassArgs = { "Aura.symetrie", true, "UI_Editor_Aura_Flip" },
													OnLoad = function(self)
														-- Add necessary items.
														for i=0, 3 do
															self:AddItem(i, PowaAuras.Text["UI_FlipTypes"][i]);
														end
														-- Update.
														self:UpdateText(self:GetSetting());
														self:SetScript("OnDropdownMenuPosition", function(self)
															-- Normal position.
															self.Menu:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, 0);
															self.Menu:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, 0);
															-- Parent to scrollframe.
															self.Menu:SetParent(self:GetParent():GetParent());
														end);
													end,
												},
												SizeStrata = {
													Type = "Button",
													Inherits = "PowaLabelledDropdownTemplate",
													Class = "Dropdown",
													ClassArgs = { "Aura.strata", true, "UI_Editor_Aura_Strata" },
													OnLoad = function(self)
														-- Add necessary items.
														local levels = PowaAuras.Text["UI_StrataLevels"];
														self:AddItem("BACKGROUND", levels[1]);
														self:AddItem("LOW", levels[2]);
														self:AddItem("MEDIUM", levels[3]);
														self:AddItem("HIGH", levels[4]);
														-- Update.
														self:UpdateText(self:GetSetting());
														self:SetScript("OnDropdownMenuPosition", function(self)
															-- Normal position.
															self.Menu:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, 0);
															self.Menu:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, 0);
															-- Parent to scrollframe.
															self.Menu:SetParent(self:GetParent():GetParent());
														end);
													end,
												},
											},
											OnLoad = function(self)
												-- Set title.
												self:SetTitle(PowaAuras.Text["UI_Editor_Aura"]);
												self:SetDescription(PowaAuras.Text("UI_Editor_CatSuffix", 
													PowaAuras.Text["UI_Editor_AuraDesc"]));
												-- Add elements to their separators.
												self.CatStyle:AddChild(self.StyleOpacity);
												self.CatStyle:AddChild(self.StyleRotate);
												self.CatStyle:AddChild(self.StyleFlip);
												self.CatStyle:AddChild(self.StyleColor);
												self.CatStyle:AddChild(self.StyleRndColor);
												self.CatStyle:AddChild(self.StyleGlow);
												self.CatSize:AddChild(self.SizeSizeX);
												self.CatSize:AddChild(self.SizeSizeY);
												self.CatSize:AddChild(self.SizeScale);
												self.CatSize:AddChild(self.SizePosX);
												self.CatSize:AddChild(self.SizePosY);
												self.CatSize:AddChild(self.SizeStrata);
												-- Add columns. Use 6 columns because we can then split into 2/3 nicely.
												self:LockLayout();
												self:AddColumn((1/6), 5, 5);
												self:AddColumn((1/6), 5, 5);
												self:AddColumn((1/6), 5, 5);
												self:AddColumn((1/6), 5, 5);
												self:AddColumn((1/6), 5, 5);
												self:AddColumn((1/6), 5, 5);
												-- Boundaries.
												self:SetBounds(15, 15, 70);
												self:SetRowSpacing(12);
												-- Add elements.
												-- I actually used GIMP to make sure these were pixel perfect.
												self:AddChild(self.TextureDummy, 2, false, 0);
												self:AddChild(self.TextureSource, 4, false, 0);
												self:AddChild(self.CatStyle, 6, true);
												self:AddChild(self.StyleOpacity, 2, false, 14, 22);
												self:AddChild(self.StyleRotate, 2, false, 14, 22);
												self:AddChild(self.StyleFlip, 2, false, 17, 0);
												self:AddChild(self.StyleColor, 2, true, 0, 0);
												self:AddChild(self.StyleRndColor, 2, false, 0, 0);
												self:AddChild(self.StyleGlow, 2, false, 0, 0);
												self:AddChild(self.CatSize, 6, true);
												self:AddChild(self.SizeSizeX, 2, false, 14, 22);
												self:AddChild(self.SizeSizeY, 2, false, 14, 22);
												self:AddChild(self.SizeScale, 2, false, 14, 22);
												self:AddChild(self.SizePosX, 2, false, 20, 0);
												self:AddChild(self.SizePosY, 2, false, 20, 0);
												self:AddChild(self.SizeStrata, 2, false, 20, 0);
												self:UnlockLayout();
											end,
										},
									},
									OnLoad = function(self)
										-- Set scroll child.
										self:SetScrollChild(self.Child);
										-- Easy update, bro.
										self:ScrollUpdate();
									end,
								},
								[2] = {
									Type = "ScrollFrame",
									Class = "ScrollFrame",
									Points = {
										[1] = { "TOPLEFT", 4, -4 },
										[2] = { "BOTTOMRIGHT", -4, 4 },
									},
									Children = {

										Child = {
											Inherits = "PowaTitledFrameTemplate",
											Class = "LayoutFrame",
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
									Class = "ScrollFrame",
									Points = {
										[1] = { "TOPLEFT", 4, -4 },
										[2] = { "BOTTOMRIGHT", -4, 4 },
									},
									Children = {
										Child = {
											Inherits = "PowaTitledFrameTemplate",
											Class = "LayoutFrame",
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
										self:ScrollUpdate();
									end,
								},
							},
							OnLoad = function(self)
								-- Register class manually.
								PowaAuras.UI:SourceControlledTabFrame(self, self:GetParent().Tree);
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
							Inherits = "PowaBorderedFrameTemplate",
							Class = "TreeView",
							Size = { 172, 1 },
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
									Inherits = "PowaTitledFrameTemplate",
									Size = { 419, 1 },
									Points = {
										[1] = { "TOPLEFT", 4, -4 },
										[2] = { "BOTTOMRIGHT", -4, 4 },
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
												-- Initialise as dropdown. No settings, though.
												PowaAuras.UI:LabelledDropdown(self);
												-- Add all possible types.
												for k, v in pairs(PowaAuras.BuffTypes) do
													self:AddItem(v, PowaAuras.Text["AuraType"][v], 
														PowaAuras.Text["AuraTypeDesc"][v]);
												end
												-- Sort.
												self:SortItems();
												self:UpdateText(PowaAuras:GetSetting("Aura.bufftype"));
												-- Register callback script.
												self:SetScript("OnDropdownItemSelected", function(self, key)
													-- Change selected aura type.
													local id = PowaBrowser:GetSelectedAura() or 0;
													if(PowaAuras.Auras[id]) then
														PowaAuras:ChangeAuraType(id, key);
														PowaAuras:ToggleAuraDisplay(id, true);
														PowaAuras:UpdateSetting("Aura.bufftype", key);
													end
												end);
											end,
										},
									},
									OnLoad = function(self)
										-- Set title.
										self:SetTitle(PowaAuras.Text["UI_Editor_Activation"]);
										self:SetDescription(PowaAuras.Text["UI_Editor_ActivationDesc"]);
										-- Register setting callback for activation type.
										PowaAuras:RegisterSettingCallback(function(key, value)
											-- Buff type?
											if(key ~= "Aura.bufftype") then
												return;
											end
											-- Update dropdown text.
											self.Type:UpdateText(value);
											-- Get edited aura.
											local aura = PowaAuras.Auras[(PowaBrowser:GetSelectedAura() or 0)];
											if(not aura) then return; end
											-- Hide existing UI.
											if(self.Editor) then
												self.Editor:ClearAllPoints();
												self.Editor:Hide();
												self.Editor:SetParent(nil);
												self.Editor = nil;
											end
											-- Show the correct editor UI this type.
											self.Editor = aura:GetActivationUI(self);
											-- Position and show.
											self.Editor:SetParent(self);
											self.Editor:SetPoint("TOPLEFT", 15, -125);
											self.Editor:SetPoint("BOTTOMRIGHT", -15, 15);
											self.Editor:Show();
										end);
									end,
								},
								[2] = {
									Type = "ScrollFrame",
									Class = "ScrollFrame",
									Points = {
										[1] = { "TOPLEFT", 4, -4 },
										[2] = { "BOTTOMRIGHT", -4, 4 },
									},
									Children = {
										Child = {
											Inherits = "PowaTitledFrameTemplate",
											Class = "LayoutFrame",
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
										self:ScrollUpdate();
									end,
								},
							},
							OnLoad = function(self)
								-- Register class manually.
								PowaAuras.UI:SourceControlledTabFrame(self, self:GetParent().Tree);
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
							Inherits = "PowaBorderedFrameTemplate",
							Class = "TreeView",
							Size = { 172, 1 },
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
		-- Do class now.
		PowaAuras.UI:AuraEditor(self);
		-- Localize title.
		self.Title:SetText(PowaAuras.Text["UI_Editor"]);
	end,
};


-- Build editor.

PowaAuras.UI:BuildFrameFromDefinition(AuraEditor, UIParent);
-- Nil out the definition to save memory. Garbage collector will pick it up at some point.
AuraEditor = nil;
