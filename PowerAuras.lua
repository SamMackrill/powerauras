--- Setup and Control
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--      << Power Auras >>
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--

-- Use this regex to find debug spam before a release!
-- ^\s*[^-\s][^-\s].*:ShowText\(.*$

--- Store default local settings
-- @name PowaAuras.PowaMiscDefault
-- @class table
PowaAuras.PowaMiscDefault = {
	Disabled = false,
	debug = false,
	OnUpdateLimit = 0,
	AnimationLimit = 0,
	Version = GetAddOnMetadata("PowerAuras", "Version"),
	DefaultTimerTexture = "Original",
	DefaultStacksTexture = "Original",
	TimerRoundUp = true,
	AllowInspections = false,
	UseGTFO = nil,
	UserSetMaxTextures = PowaAuras.TextureCount, -- DEPRECATED: No longer needed.
	OverrideMaxTextures = false,                 -- DEPRECATED: No longer needed.
	Locked = true,
	SoundChannel = "Master",
};

--- Store default global settings
-- @name PowaAuras.PowaGlobalMiscDefault
-- @class table
PowaAuras.PowaGlobalMiscDefault = {
	PathToSounds = "Interface\\AddOns\\PowerAuras\\Sounds\\",
	PathToAuras = "Interface\\Addons\\PowerAuras\\Custom\\",
	BlockIncomingAuras = false,
	FixExports = false,
	LastVersion = 10000,
	FirstRun = true,
};

-- Store the actual settings tables without the default suffix.
-- Doesn't matter if it's a reference. These are replaced later on with the actual SV's.
PowaMisc = PowaAuras.PowaMiscDefault;
PowaGlobalMisc = PowaAuras.PowaGlobalMiscDefault;

PowaSet = {};
PowaTimer = {};

PowaGlobalSet = {};
PowaGlobalListe = {};
PowaClassSet = {};
PowaClassListe = {};
PowaPlayerListe = {};

--Default page names
for i = 1, 5 do
	PowaPlayerListe[i] = PowaAuras.Text.ListePlayer.." "..i;
end
for i = 1, 10 do
	PowaGlobalListe[i] = PowaAuras.Text.ListeGlobal.." "..i;
end

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

function PowaAuras:Toggle(enable)
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	--self:ShowText("Toggle Frame=", PowaAuras_Frame);
	if (enable==nil) then
		enable = PowaMisc.Disabled;
	end
	if enable then
		if (not PowaMisc.Disabled) then
			return;
		end
		if PowaAuras_Frame and not PowaAuras_Frame:IsShown() then		
			PowaAuras_Frame:Show(); -- Show Main Options Frame
			self:RegisterEvents(PowaAuras_Frame);
		end
		PowaMisc.Disabled = false;
		self:Setup();
		self:DisplayText("Power Auras "..self.Colors.Green..PowaAuras.Text.Enabled.."|r");
	else
		if (PowaMisc.Disabled) then
			return;
		end
		if PowaAuras_Frame and PowaAuras_Frame:IsShown() then
			PowaAuras_Frame:UnregisterAllEvents();
			PowaAuras_Frame:Hide();
		end
		self:OptionHideAll();
		PowaMisc.Disabled = true;
		self:DisplayText("Power Auras "..self.Colors.Red..ADDON_DISABLED.."|r");
	end
	--self:ShowText("Setting Enabled button to: ", PowaMisc.Disabled~=true);
	PowaEnableButton:SetChecked(PowaMisc.Disabled~=true);
end

function PowaAuras:OnLoad(frame)

	--- Setting up the Import/Export static popups
	self:SetupStaticPopups();

	frame:RegisterEvent("VARIABLES_LOADED");
	frame:RegisterEvent("PLAYER_ENTERING_WORLD");

	--- options init
	SlashCmdList["POWA"] = PowaAuras_CommanLine;
	SLASH_POWA1 = "/powa";
	
	SlashCmdList["POWA2"] = function()
		PowaBrowser:Show();
	end
	SLASH_POWA21 = "/powa2";
end

function PowaAuras:ReregisterEvents(frame)
	PowaAuras_Frame:UnregisterAllEvents();
	self:RegisterEvents(frame);
end

function PowaAuras:RegisterEvents(frame)
	if (self.playerclass=="DRUID") then
		self.Events.UPDATE_SHAPESHIFT_FORM = true;
	end
	for event in pairs(self.Events) do
		if (self[event]) then
			frame:RegisterEvent(event);
		else
			self:DisplayText("Event has no method ", event); --OK
		end
	end
end

function PowaAuras:LoadAuras()
	--self:ShowText("LoadAuras");
	self.Auras = {};
	self.AuraSequence = {};
	self.TriggerIndex = 1;
	
	for k, v in pairs(PowaGlobalSet) do
		--self:UnitTestDebug("PowaGlobalSet",k,v.ValueCheck);
		if (k~=0 and v.is_a == nil or not v:is_a(cPowaAura)) then
			--self:UnitTestDebug(k,v.ValueCheck);
			self:UpdateAura(v, k);
			self.Auras[k] = self:AuraFactory(v.Type, k, v);
		end
	end

	for k, v in pairs(PowaSet) do
		--self:UnitTestDebug("PowaSet",k,v.ValueCheck, self.Auras[k]);
		if (k>0 and k <121 and not self.Auras[k]) then
			--self:UnitTestDebug("is_a=",v.is_a);
			if (v.is_a == nil or not v:is_a(cPowaAura)) then
				--self:ShowText("load aura ", k, " bufftype=",v.Type);
				self:UpdateAura(v, k);
				self.Auras[k] = self:AuraFactory(v.Type, k, v);
				--self:UnitTestDebug("Out=",self.Auras[k].ValueCheck);
			end
		end
	end
	
	local class = select(2, UnitClass("player"));
	if(not PowaClassSet[class]) then
		PowaClassSet[class] = {};
	end
	for k, v in pairs(PowaClassSet[class]) do
		if (k>360 and not self.Auras[k]) then
			--self:UnitTestDebug("is_a=",v.is_a);
			if (v.is_a == nil or not v:is_a(cPowaAura)) then
				--self:ShowText("load aura ", k, " bufftype=",v.Type);
				self:UpdateAura(v, k);
				self.Auras[k] = self:AuraFactory(v.Type, k, v);
				--self:UnitTestDebug("Out=",self.Auras[k].ValueCheck);
			end
		end	
	end
	
	if (self.DebugAura and self.Auras[self.DebugAura]) then
		self.Auras[self.DebugAura].Debug = true;
	end
	
	self:DiscoverLinkedAuras();

	--self:Message("backwards combatiblity");
	--self.Auras[0] = cPowaAura(0, {off=true});
	
	self:CalculateAuraSequence();
	--self:ShowText(#self.AuraSequence," Auras loaded");
	
	self:CreateAllAuraTriggers();
	
	-- Copy to Saved Sets
	PowaSet = self.Auras;
	for i = 121, 360 do
		PowaGlobalSet[i] = self.Auras[i];
	end
	for i=361,480 do
		PowaClassSet[class][i] = self.Auras[i];
	end
	PowaTimer = {};
	
end

function PowaAuras:CreateAllAuraTriggers()
	for i = 1, #self.AuraSequence do
		local aura = self.AuraSequence[i];
		aura:CreateDefaultTriggers();
	end
end

function PowaAuras:CalculateAuraSequence()
	wipe(self.AuraSequence);	
	for id, aura in pairs(self.Auras) do
		if (not aura.Disabled or self.UsedInMultis[id]) then
			--self:ShowText("Adding aura ",id, " to AuraSequence");
			table.insert(self.AuraSequence, aura);
		end
	end
end

function PowaAuras:DiscoverLinkedAuras()
	for i = 1, #self.AuraSequence do
		self:DiscoverLinksForAura(self.AuraSequence[i], true);
	end
	--for id in pairs(self.UsedInMultis) do
	--	self:ShowText("UsedInMultis ",id);
	--end
end

function PowaAuras:DiscoverLinksForAura(aura, ignoreOff)
	--self:ShowText("DiscoverLinksForAura ",aura.id, " multiids=",aura.MultiCheck, " ignoreOff=",ignoreOff);
	if (not aura or (ignoreOff and aura.Disabled) or not aura.MultiCheck or aura.MultiCheck=="" or self.UsedInMultis[aura.id]) then return end
	for pword in string.gmatch(aura.MultiCheck, "[^/]+") do
		if (string.sub(pword, 1, 1) == "!") then
			pword = string.sub(pword, 2);
		end
		local id = tonumber(pword);
		if (id) then
			self.UsedInMultis[id] = true;
			self:DiscoverLinksForAura(self.Auras[id], false);
		end
	end
end

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> EVENTS
function PowaAuras:FindAllChildren()
	--self:ShowText("FindAllChildren");
	for _, aura in pairs(self.Auras) do
		aura.Children = nil;
		self:FindChildren(aura);
	end
	--for _, aura in pairs(self.Auras) do
	--	if (aura.Children) then
	--		self:ShowText("Aura "..aura.id.." Children:");
	--		for childId in pairs(aura.Children) do
	--			self:ShowText("  "..childId);
	--		end
	--	end
	--end
end

function PowaAuras:FindChildren(aura)
	if (not aura.MultiCheck or aura.MultiCheck=="") then return; end
	--self:ShowText(aura.id.." "..aura.MultiCheck);
	for pword in string.gmatch(aura.MultiCheck, "[^/]+") do
		if (string.sub(pword, 1, 1) == "!") then
			pword = string.sub(pword, 2);
		end
		local id = tonumber(pword);
		--self:ShowText(" >>"..id);
		local dependant = self.Auras[id];
		if (dependant) then
			if (not dependant.Children) then
				dependant.Children = {};
			end
			dependant.Children[aura.id] = true;
		end
	end
end

function PowaAuras:CustomTexPath(customname)
	--self:ShowText("CustomTexPath ", customname);
	local texpath;
	if string.find(customname,".", 1, true) then
		texpath = PowaGlobalMisc.PathToAuras .. customname;
	else
		local spellId = select(3, string.find(customname, "%[?(%d+)%]?"));
		if (spellId) then		
			--self:ShowText("spellId ", spellId);
			texpath = select(3, GetSpellInfo(tonumber(spellId)));
		else
			texpath = select(3, GetSpellInfo(customname));
		end
	end
	--self:ShowText("texpath ", texpath);
	if not texpath then texpath = "" end
	return texpath;
end

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

function PowaAuras:CreateEffectLists()
	
	for k in pairs(self.AurasByType) do
		wipe(self.AurasByType[k]);
	end
	
	self.Events = self:CopyTable(self.AlwaysEvents);
	for id, aura in pairs(self.Auras) do
		if (not aura.Disabled or self.UsedInMultis[id]) then
		    --self:ShowText("CreateEffectLists Aura", id);
			aura:AddEffectAndEvents();
		end
	end 

	if (PowaMisc.debug == true) then
		for k in pairs(self.AurasByType) do
			if (#self.AurasByType[k]>0) then
				self:DisplayText(k .. " : " .. #self.AurasByType[k]);
			end
		end
	end

end

function PowaAuras:InitialiseAllAuras()
	for _, aura in pairs(self.Auras) do
		aura:Init();
	end 
end

function PowaAuras:MemorizeActions(actionIndex)
	local imin, imax;
	--self:Debug("---MemorizeActions---");
	if (#self.AurasByType.Actions == 0) then
		return;
	end
	
	--- scan tout ou uniquement le slot qui a change
	if (actionIndex == nil) then
		--self:ShowText("---Scan all Actionbuttons---");
		imin = 1;
		imax = 120;
		--- reset all action positions
		for _, v in pairs(self.AurasByType.Actions) do
			self.Auras[v].slot = nil;
		end
		
	else
		imin = actionIndex;
		imax = actionIndex;
	end

	for i = imin, imax do
		if (HasAction(i)) then
			local type, id, subType, spellID = GetActionInfo(i);
			local name, text;
			if (type=="macro") then
				name = GetMacroInfo(id);
			end
			PowaAction_Tooltip:SetOwner(UIParent, "ANCHOR_NONE");
			PowaAction_Tooltip:SetAction(i);
			text = PowaAction_TooltipTextLeft1:GetText();
			PowaAction_Tooltip:Hide();

			--self:ShowText("---Button",i," Action Found---");
			--self:ShowText("tooltip text=",text);
			--if text and text ~= "" then
			--	self:ShowText("| "..text.." |");
			--end	
			if (text~=nil) then
				for k, v in pairs(self.AurasByType.Actions) do
					local actionAura = self.Auras[v];
					if (actionAura==nil) then
						self.AurasByType.Actions[k] = nil; -- aura deleted
					elseif (not actionAura.slot) then
						--self:ShowText("actionAura",v,actionAura.ValueCheck, actionAura.IgnoreCase);
						if (self:MatchString(name, actionAura.ValueCheck, actionAura.IgnoreCase)
						 or self:MatchString(text, actionAura.ValueCheck, actionAura.IgnoreCase)) then
							actionAura.slot = i; --- remember the slot
							--self:ShowText("========================================");
							--self:ShowText("Name=", name, "Tooltip=", text, " Match=", actionAura.ValueCheck);
							--- remember the texture
							local tempicon;
							if (actionAura.owntex == true) then
								PowaIconTexture:SetTexture(GetActionTexture(i));
								tempicon = PowaIconTexture:GetTexture();
								if (actionAura.IconPath ~= tempicon) then
									actionAura.IconPath = tempicon;
								end
							elseif (actionAura.IconPath == "") then
								PowaIconTexture:SetTexture(GetActionTexture(i));
								actionAura.IconPath = PowaIconTexture:GetTexture();
							end
						end
					end
				end
			end
		end
	end
end


function PowaAuras:AddChildrenToCascade(aura, originalId)
	if (not aura or not aura.Children) then return; end
	for id in pairs(aura.Children) do
		if (not self.Cascade[id] and id~=originalId) then
			--self:ShowText(GetTime()," Cascade from ", aura.id, " adding aura."..id);
			self.Cascade[id] = true;
			self:AddChildrenToCascade(self.Auras[id], originalId or aura.id);
		end
	end
end


--=== Run time ===--

do
	local arg = nil;
	function PowaAuras:MarkAuras(...)
		-- Get first argument.
		arg = select(1, ...);
		if(not arg) then return; end
		-- Mark aura type.
		self.DoCheck[arg] = true;
		self.DoCheck.CheckIt = true;
		-- Recurse.
		self:MarkAuras(select(2, ...));
	end
end

function PowaAuras:OnUpdate(elapsed)
	--self:UnitTestInfo("OnUpdate", elapsed);
	if (self.NextDebugCheck>0 and self.DebugTimer > self.NextDebugCheck) then
		PowaAuras:Message("OnUpdate   Init=", not (self.VariablesLoaded and self.SetupDone)); --OK
	end

	if (not (self.VariablesLoaded and self.SetupDone)) then return; end 
		
	self.ChecksTimer = self.ChecksTimer + elapsed;
	self.TimerUpdateThrottleTimer = self.TimerUpdateThrottleTimer + elapsed;	
	self.ThrottleTimer = self.ThrottleTimer + elapsed;
		
	self.DebugTimer = self.DebugTimer + elapsed;
	self.DebugCycle = false;
	if (self.NextDebugCheck>0 and self.DebugTimer > self.NextDebugCheck) then
		self.DebugTimer = 0;
		PowaAuras:Message("========DebugCycle========"); --OK
		self.DebugCycle = true;
	end

	--[[
	self.ProfileTimer = self.ProfileTimer + elapsed;
	self.UpdateCount = self.UpdateCount + 1;
	if (self.NextProfileCheck>0 and self.ProfileTimer > self.NextProfileCheck) then
		self.ProfileTimer = 0;
		PowaAuras:Message("========ProfileCycle========");
		PowaAuras:Message("UpdateCount=", self.UpdateCount);
		PowaAuras:Message("CheckCount=", self.CheckCount);
		PowaAuras:Message("EffectCount=", self.EffectCount);
		PowaAuras:Message("AuraCheckCount=", self.AuraCheckCount);
		PowaAuras:Message("AuraCheckShowCount=", self.AuraCheckShowCount);
		PowaAuras:Message("BuffUnitSetCount=", self.BuffUnitSetCount);
		PowaAuras:Message("BuffRaidCount=", self.BuffRaidCount);
		PowaAuras:Message("BuffUnitCount=", self.BuffUnitCount);
		PowaAuras:Message("BuffSlotCount=", self.BuffSlotCount);
		for k, v in pairs (self.AuraTypeCount) do
			PowaAuras:Message("AuraTypeCount[",k,"]=", v);
		end
		
		self.UpdateCount = 0;
		self.CheckCount = 0;
		self.EffectCount = 0;
		self.AuraCheckCount = 0;
		self.AuraCheckShowCount = 0;
		self.BuffUnitSetCount = 0;
		self.BuffRaidCount = 0;
		self.BuffUnitCount = 0;
		self.BuffSlotCount = 0;
		self.AuraTypeCount = {};
	end
	]]
	
	self.InGCD = nil;
	if (self.GCDSpellName) then
		local gcdStart = GetSpellCooldown(self.GCDSpellName);
		if (gcdStart) then
			self.InGCD = (gcdStart>0);
		end
	end
	
	local checkAura = false;
	local onUpdateLimit = PowaMisc.OnUpdateLimit;
	if (self.ModTest) then
		onUpdateLimit = 0.5; -- Limit testing updates to every 1/2 second
	end
	if (onUpdateLimit == 0 or self.ThrottleTimer >= onUpdateLimit) then
		checkAura = true;
		self.ThrottleTimer = 0;
	end
			
	if (not self.ModTest and (checkAura or self.DebugCycle)) then

		--self.CheckCount = self.CheckCount + 1;

	    --self:Message("OnUpdate ",elapsedCheck, " ", self.ChecksTimer);
		--self:UnitTestInfo("ChecksTimer", self.ChecksTimer, self.NextCheck);
		if ((self.ChecksTimer > (self.NextCheck + PowaMisc.OnUpdateLimit))) then
			self.ChecksTimer = 0;
			local isMountedNow = (IsMounted() == 1 and true or self:IsDruidTravelForm());
			if (isMountedNow ~= self.WeAreMounted) then
				self.DoCheck.All = true;
				--self:ShowText("DoCheck.All: Mounted");
				self.WeAreMounted = isMountedNow;
			end	
			local isInVehicledNow = (UnitInVehicle("player")~=nil);
			if (isInVehicledNow ~= self.WeAreInVehicle) then
				self.DoCheck.All = true;
				--self:ShowText("DoCheck.All: in Vehicle");
				self.WeAreInVehicle = isInVehicledNow;
			end	
		end

		if (self.PendingRescan and GetTime() >= self.PendingRescan) then	
			self:InitialiseAllAuras();
			self:MemorizeActions();
			self.DoCheck.All = true;
			--self:ShowText("DoCheck.All: PendingRescan");
			self.PendingRescan = nil;
		end
		
		--self:UnitTestInfo("Pending");
		for id, cd in pairs(self.Pending) do	
			--self:ShowText("Pending check for ", id, " cd=", cd, " time=", GetTime());
			if cd and cd >0 then
				--self:ShowText("Pending check for ", id, " cd=", cd, " time=", GetTime());
				if (GetTime() >= cd) then
					self.Pending[id] = nil;
					if (self.Auras[id]) then
						self.Auras[id].CooldownOver = true;
						--self:ShowText("Pending TestThisEffect for ", id);
						self:TestThisEffect(id);
						self.Auras[id].CooldownOver = nil;
					end
				end
			else
				self.Pending[id] = nil;
			end
		end
	

		--self:UnitTestInfo("DoCheck update");
		if (self.DoCheck.CheckIt or self.DoCheck.All) then
			self:CheckAllMarkedAuras();
			self.DoCheck.CheckIt = false;
		end

		--self:UnitTestInfo("Check Cascade auras");
		for k in pairs(self.Cascade) do
			--self:ShowText(GetTime()," Checking Cascade aura."..k);
			self:TestThisEffect(k, false, true);
		end
		wipe(self.Cascade);		
	end
	
	local skipTimerUpdate = false
	local timerElapsed = 0;
	local timerUpdateLimit = PowaMisc.AnimationLimit;
	if (self.ModTest) then
		timerUpdateLimit = 0.5; -- Limit testing updates to every 1/2 second
	end
	if (timerUpdateLimit > 0 and self.TimerUpdateThrottleTimer < timerUpdateLimit) then
		skipTimerUpdate = not self.DebugCycle;
	else
		timerElapsed = self.TimerUpdateThrottleTimer;
		self.TimerUpdateThrottleTimer = 0;
	end
	
	if (PowaMisc.AllowInspections) then
		-- Refresh Inspect, check timeout
		if (self.NextInspectUnit ~= nil) then
			if (GetTime() > self.NextInspectTimeOut) then
				--self:Message("Inspection timeout for ", self.NextInspectUnit);
				self:SetRoleUndefined(self.NextInspectUnit);
				self.NextInspectUnit = nil;
				self.InspectAgain = GetTime() + self.InspectDelay;
			end
		elseif (not self.InspectsDone
				and self.InspectAgain~=nil 
				and not UnitOnTaxi("player")
				and GetTime()>self.InspectAgain) then
			self:TryInspectNext();
			self.InspectAgain = GetTime() + self.InspectDelay;
		end
	end


	-- Update each aura (timers and stacks)
	--self:UnitTestInfo("Aura updates");
	for i = 1, #self.AuraSequence do
		local aura = self.AuraSequence[i];
		--self:Message("UpdateAura Call id=", aura.id, " ", aura);
		if (aura:UpdateAura(self.ModTest)) then

			if (not skipTimerUpdate) then

				if (aura.Stacks and aura.Stacks.enabled) then	
					aura.Stacks:Update(aura, 0, self.ModTest);
				end		
		
				if (aura.Timer) then
					aura.Timer:Update(aura, timerElapsed, self.ModTest);
				end
			end
		
			aura:ProcessTriggerQueue();
			
		end
	end
	
	self.ResetTargetTimers = false;

end

function PowaAuras:IsDruidTravelForm()
	if (self.playerclass~="DRUID") then return false; end
	local nStance = GetShapeshiftForm();
	-- If stance 4 or 6, we're in travel/flight form.
	if(nStance == 4 or nStance == 6) then return true; end
	-- If in stance 5, it's complicated. Moonkin/Tree form take index 5 if learned, but if not learned then flight form is here.
	if(nStance == 5 and select(5, GetTalentInfo(3,21)) == 0 and select(5, GetTalentInfo(1,8)) == 0) then return true; end
	-- Otherwise we're not in it.
	return false;
end

function PowaAuras:CheckAllMarkedAuras()
   	--self:UnitTestInfo("CheckAllMarkedAuras");

	--self:ShowText(GetTime()," CheckAllMarkedAuras");
	--if (self.DoCheck.All) then
	--	self:ShowText(GetTime()," DoCheck.All");
	--end
	for i = 1, #self.AurasByTypeList do
		local auraType = self.AurasByTypeList[i];
		--self:ShowText("Check auraType ",auraType, " OneShotAuras=", self.OneShotAuras[auraType]);
		if ((self.DoCheck[auraType] or (self.DoCheck.All and not self.OneShotAuras[auraType])) and #self.AurasByType[auraType]>0) then
			--self:ShowText("Checking auraType ",auraType, " #", #self.AurasByType[auraType]);
			--if (self.DoCheck.All) then
			--	self:ShowText(GetTime()," TestAuraTypes ",auraType," DoCheck ", self.DoCheck[auraType], " All ", self.DoCheck.All, " #", #self.AurasByType[auraType]);
			--end
			for k, v in pairs(self.AurasByType[auraType]) do
				--self:ShowText(GetTime()," ", k," TestThisEffect ",v);
				if (self.Auras[v] and self.Auras[v].Debug) then
					self:DisplayText("TestThisEffect ",v);
				end
				--if (self.AuraTypeCount[auraType] == nil) then self.AuraTypeCount[auraType] = 0; end
				--self.AuraTypeCount[auraType] = self.AuraTypeCount[auraType] + 1;
				self:TestThisEffect(v);
			end
		end
		self.DoCheck[auraType] = false;
	end

	self.DoCheck.All = false;
	
	wipe(self.AoeAuraAdded);
	wipe(self.ChangedUnits.Buffs);
	wipe(self.ChangedUnits.Targets);
	wipe(self.ExtraUnitEvent);
	wipe(self.CastOnMe);
	wipe(self.CastByMe);

end

function PowaAuras:TestThisEffect(auraId, giveReason, ignoreCascade)
	--self:UnitTestInfo("TestThisEffect", auraId);
	
	--if (ignoreCascade) then
	--	self:ShowText(GetTime()," TestThisEffect (from cascade) ", auraId);
	--	giveReason = true;
	--end

	local aura = self.Auras[auraId];
	if (not aura) then
		--self:ShowText("Aura missing ", auraId);
		return false, self.Text.nomReasonAuraMissing;
	end
	if (aura.Disabled) then
		if (aura.Showing) then
			--self:ShowText("aura:Hide because off", auraId);
			aura:Hide("TestThisEffect off and showing");
		end
		if (not self.UsedInMultis[aura.id]) then
			if (not giveReason) then return false; end
			return false, self.Text.nomReasonAuraOff;
		end
	end
	
	local debugEffectTest = PowaAuras.DebugCycle or aura.Debug;
	--self.EffectCount = self.EffectCount + 1;

	if (debugEffectTest) then
		self:Message("===================================");
		self:Message("Test Aura for Hide/Show = ",auraId);
		self:Message("Active= ", aura.Active);
		self:Message("Showing= ", aura.Showing);
	end
	
	-- Prevent crash if class not set-up properly
	if (not aura.ShouldShow) then
		self:Message("ShouldShow nil! id= ",auraId)
		if (not giveReason) then return false; end
		return false, self.Text.nomReasonAuraBad;
	end
	
	--self:ShowText("Test Aura ",auraId, " for Hide/Show showing=",aura.Showing);
	aura.InactiveDueToMulti = nil;
	local ignoreGCD = false; -- TODO: need to sort this out
	local shouldShow, reason = aura:ShouldShow(giveReason or debugEffectTest or true, false, ignoreGCD); -- TODO: Remove "or true" for live!
	--if (ignoreCascade) then
	--	self:ShowText(GetTime()," Test Aura ", auraId, " for Hide/Show showing=", aura.Showing);
	--	self:ShowText(GetTime()," shouldShow=", shouldShow, " Reason=", reason);
	--end
	
	if (shouldShow == -1) then
		if (debugEffectTest) then
			self:Message("TestThisEffect unchanged");
		end
		return aura.Active, reason;
	end
	
	if (shouldShow==true) then
		shouldShow, reason = self:CheckMultiple(aura, reason, giveReason or debugEffectTest);
		if (not shouldShow) then
			--self:ShowText("InactiveDueToMulti Aura ", aura.ValueCheck, " (",auraId,")");
			aura.InactiveDueToMulti = true;
		end
	elseif (aura.Timer and aura.CanHaveTimerOnInverse) then
		local multiShouldShow = self:CheckMultiple(aura, reason, giveReason or debugEffectTest);
		if (not multiShouldShow) then
			--self:ShowText("InactiveDueToMulti Aura ", aura.ValueCheck, " (",auraId,")");
			aura.InactiveDueToMulti = true;
		end
	end
	
	if (debugEffectTest) then
		self:Message("shouldShow=", shouldShow, " because ", reason);
	end
	
	aura:CheckActive(shouldShow, ignoreCascade);
	
	return shouldShow, reason;
end

function PowaAuras:CheckMultiple(aura, reason, giveReason)
	if (not aura.MultiCheck or aura.MultiCheck == "") then
		if (not giveReason) then return true; end
		return true, reason;
	end
	if string.find(aura.MultiCheck, "[^0-9/!]") then --- invalid input (only numbers and / allowed)
		--self:Debug("Multicheck. Invalid Input. Only numbers and '/' allowed.");
		if (not giveReason) then return true; end
		return true, reason;
	end
	for pword in string.gmatch(aura.MultiCheck, "[^/]+") do
		local reverse;
		if (string.sub(pword, 1, 1) == "!") then
			pword = string.sub(pword, 2);
			reverse = true;
		end
		local k = tonumber(pword);
		local linkedAura = self.Auras[k];
		local state;
		if linkedAura then
			--self:ShowText("Multicheck. Aura ",k);	
			--result, reason = linkedAura:ShouldShow(giveReason, reverse, true);
			if (not linkedAura.Active and not reverse) or (linkedAura.Active and reverse) then
				if (not giveReason) then return false; end
				if (reverse) then
					return false, self:InsertText(self.Text.nomReasonMultiActive, linkedAura.id);				
				else
					return false, self:InsertText(self.Text.nomReasonMultiInactive, linkedAura.id);
				end
			end 				
		else
			--self:Debug("Multicheck. Non-existant Aura ID specified: "..pword);
		end
	end
	if (not giveReason) then return true; end
	return true, self:InsertText(self.Text.nomReasonMulti, aura.MultiCheck);	
end

function PowaAuras:RegisterPremadeAura(premade, classes)

	--premade = {Name=name, Description=description, Code=code};
	for _, class in pairs(classes) do
		self.ClassPremades[class].insert(premade);
	end 

end


-- Drag and Drop functions

local function stopFrameMoving(frame)
	if (frame==nil or not frame.isMoving) then return; end
	frame.isMoving = false;
	--PowaAuras:ShowText("stopMove id=", frame.aura.id);
	frame:StopMovingOrSizing();
	frame.aura.PosX = math.floor(frame:GetLeft() + (frame:GetWidth()  - UIParent:GetWidth())  / 2 + 0.5);
	frame.aura.PosY = math.floor(frame:GetTop()  - (frame:GetHeight() + UIParent:GetHeight()) / 2 + 0.5);
	if (PowaAuras.CurrentAuraId == frame.aura.id and PowaBarConfigFrame:IsVisible()) then
		PowaAuras:UpdateLocation(frame.aura);
	end
end

local function stopMove(frame, button)
	--PowaAuras:ShowText("stopMove button=", button);
	--PowaAuras:ShowText("isMoving=",frame.isMoving);
	if (button ~= "LeftButton") then return end;
	stopFrameMoving(frame);
end


local function startFrameMoving(frame)
	if (frame.isMoving) then return; end
	if (PowaAuras.CurrentAuraId ~= frame.aura.id) then
		--PowaAuras:ShowText("Switching from id=", PowaAuras.CurrentAuraId);
		stopFrameMoving(PowaAuras.Frames[PowaAuras.CurrentAuraId]);
		local i = frame.aura.id - (PowaAuras.CurrentAuraPage-1)*24;
		local icon;
		if (i>0 and i<25) then
			icon = getglobal("PowaIcone"..i);
		end
		PowaAuras:SetCurrent(icon, frame.aura.id);
		--PowaAuras:InitPage(frame.aura); -- This seems to mess things up?
	end
	frame.isMoving = true;
	--PowaAuras:ShowText("startMove id=", frame.aura.id);
	frame:StartMoving();
	frame:StopAnimating();
	local secondaryFrame = frame.aura:GetFrame(true);
	if (secondaryFrame~=nil) then
		secondaryFrame:Hide();
	end
end

local function startMove(frame, button)
	--PowaAuras:ShowText("startMove button=", button, " isMoving=",frame.isMoving);
	if (button ~= "LeftButton") then return end;
	startFrameMoving(frame);
end

local function keyUp(frame, key)
	--PowaAuras:ShowText("keyUp key=", key, " aura=",frame.aura.id);
	if ((key~="UP" and key~="DOWN" and key~="LEFT" and key~="RIGHT") or not frame.mouseIsOver) then return; end
	if (key=="UP") then
		frame.aura.PosY = frame.aura.PosY + 1;
	elseif (key=="DOWN") then
		frame.aura.PosY = frame.aura.PosY - 1;
	elseif (key=="LEFT") then
		frame.aura.PosX = frame.aura.PosX - 1;
	elseif (key=="RIGHT") then
		frame.aura.PosX = frame.aura.PosX + 1;
	end
	if (PowaAuras.CurrentAuraId == frame.aura.id and PowaBarConfigFrame:IsVisible()) then
		PowaAuras:UpdateLocation(frame.aura);
	end
	PowaAuras:RedisplayAura(frame.aura.id, false);
end

local function enterAura(frame)
	--PowaAuras:ShowText("enterAura aura=",frame.aura.id);
	frame.mouseIsOver = true;
	frame:EnableKeyboard(true);
	frame:SetScript("OnKeyUp", keyUp);
	frame:SetScript("OnDragStart", frame.StartMoving);
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing);
	frame:SetScript("OnMouseDown", startMove);
	frame:SetScript("OnMouseUp", stopMove);
end

local function leaveAura(frame)
	--PowaAuras:ShowText("leaveAura aura=",frame.aura.id);
	frame.mouseIsOver = nil;
	stopFrameMoving(frame);
	frame:EnableKeyboard(false);
	frame:SetScript("OnKeyUp", nil);
	frame:SetScript("OnDragStart", nil);
	frame:SetScript("OnDragStop", nil);
	frame:SetScript("OnMouseDown", nil);
	frame:SetScript("OnMouseUp", nil);
	frame:SetScript("OnKeyUp", nil);
end

function PowaAuras:SetForDragging(aura, frame)
	if (frame==nil or aura==nil or frame.SetForDragging) then return; end
	--self:ShowText("Set Dragging ", aura.id, " frame=", frame);
	frame:SetMovable(true);
	frame:EnableMouse(true);
	frame:SetClampedToScreen(false);
	frame:RegisterForDrag("LeftButton");
	frame:SetBackdrop( self.Backdrop);
	frame:SetBackdropColor(0, 0.6, 0, 1);
	--frame:SetScript("OnHide", stopMove);
	frame:SetScript("OnEnter", enterAura);
	frame:SetScript("OnLeave", leaveAura);
	frame.SetForDragging = true;
end

function PowaAuras:ResetDragging(aura, frame)
	if (frame==nil or aura==nil or not frame.SetForDragging) then return; end
	--self:ShowText("Reset Dragging ", aura.id);
	frame:SetMovable(false);
	frame:EnableMouse(false);
	frame:EnableKeyboard(false);
	frame:RegisterForDrag();
	frame:SetBackdrop(nil);
	frame:SetScript("OnDragStart", nil);
	frame:SetScript("OnDragStop", nil);
	frame:SetScript("OnMouseDown", nil);
	frame:SetScript("OnMouseUp", nil);
	frame:SetScript("OnKeyUp", nil);
	frame:SetScript("OnHide", nil);
	frame:SetScript("OnEnter", nil);
	frame:SetScript("OnLeave", nil);
	frame.SetForDragging = nil;
end

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

function PowaAuras:DisplayAura(auraId)
	--self:UnitTestInfo("DisplayAura", auraId);
	--self:ShowText("DisplayAura aura ", auraId);
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end   --- de-actived

	local aura = self.Auras[auraId];
	if (aura==nil or (aura.Disabled and not self.UsedInMultis[id])) then return; end
	
	if (aura.Debug) then
		self:Message("ShowAuraForFirstTime ", aura.id);
	end

	local frame, texture, frame2, texture2 = aura:CreateFrames();	

	--self:ShowText("ShowAuraForFirstTime ", aura.id, " frame=", frame);

	self:InitialiseAuraFrame(aura, frame, texture, aura.Opacity);
	
	if (aura.anim2 == 0) then --- no secondary frame
		if (frame2) then
			frame2:Hide();
		end
		self.SecondaryFrames[aura.id] = nil;
		self.SecondaryTextures[aura.id] = nil;
	else
		self:InitialiseAuraFrame(aura, frame2, texture2, aura.Opacity * 0.5);	
	end

	if (self.ModTest and not PowaMisc.Locked) then
		self:SetForDragging(aura, frame);
	else
		self:ResetDragging(aura, frame);
	end

	aura:Show(self.ModTest);

end

function PowaAuras:GetFrame(auraId, frameSource, frame)
	if (not auraId) then 
		--self:ShowText("GetFrame auraId nil");
		return nil;
	end
	if (not frameSource) then
		--self:ShowText("GetFrame invalid frameSource=", frameSource);
		return nil;
	end
	if (not self[frameSource]) then
		--self:ShowText("GetFrame invalid self[", frameSource, "]=", self[frameSource]);
		return nil;
	end
	if (not self[frameSource][auraId]) then
		--self:ShowText("GetFrame invalid self[", frameSource, "][", auraId, "]=", self[frameSource][auraId]);
		return nil;
	end
	if (frame) then
		if (not self[frameSource][auraId][frame]) then
			--self:ShowText("GetFrame invalid self[", frameSource, "][", auraId, "][", frame, "]=", self[frameSource][auraId][frame]);
			return nil;
		end
		return self[frameSource][auraId][frame];
	end
	return self[frameSource][auraId];
end

function PowaAuras:InitialiseAuraFrame(aura, frame, texture, alpha)
	if (aura.owntex == true) then
		if (aura.IconPath=="") then
			texture:SetTexture("Interface\\Icons\\Inv_Misc_QuestionMark");
		else
			texture:SetTexture(aura.IconPath);
		end
	elseif (aura.wowtex == true) then
		texture:SetTexture(self.WowTextures[aura.texture]);
	elseif (aura.customtex == true) then
		texture:SetTexture(self:CustomTexPath(aura.customname));
	elseif (aura.textaura == true) then
		aura:UpdateText(texture);  	
	else
		texture:SetTexture("Interface\\Addons\\PowerAuras\\Auras\\Aura"..aura.texture..".tga");
	end
  
	if (aura.ColorRandom) then
		texture:SetVertexColor(random(20,100)/100,random(20,100)/100,random(20,100)/100);	
	else
		texture:SetVertexColor(unpack(aura.Color));
	end
  
	if (aura.Glow == 1) then
		if (aura.textaura ~= true) then
			texture:SetBlendMode("ADD");
		else
			texture:SetShadowColor(0.0, 0.0, 0.0, 0.8);
			texture:SetShadowOffset(2,-2);
		end
		frame:SetFrameStrata(aura.Strata);
	else
		if (aura.textaura ~= true) then
			texture:SetBlendMode("DISABLE");
		else
			texture:SetShadowColor(0.0, 0.0, 0.0, 0.0);
			texture:SetShadowOffset(0,0);
		end
		frame:SetFrameStrata("BACKGROUND");
	end

	if (aura.textaura ~= true) then
	  if (aura.Flip == 1) then 
		texture:SetTexCoord(1, 0, 0, 1); --- inverse X
	  elseif (aura.Flip == 2) then 
		texture:SetTexCoord(0, 1, 1, 0); --- inverse Y
	  elseif (aura.Flip == 3) then 
		texture:SetTexCoord(1, 0, 1, 0); --- inverse XY
	  else 
		texture:SetTexCoord(0, 1, 0, 1); 
	  end	
	end

	PowaAuras:SetFrameSize(frame, texture, aura.Scale, aura.Deform, aura.textaura, aura.aurastextfont);

	frame:SetAlpha(math.min(alpha,0.99));
	frame:SetPoint("CENTER",aura.PosX, aura.PosY);
	frame:SetWidth(frame.baseL);
	frame:SetHeight(frame.baseH);
	

end

function PowaAuras:SetFrameSize(frame, texture, size, torsion, textaura, aurastextfont)
	frame.baseH = 256 * size * (2-torsion);
	if (textaura == true) then
		local fontsize = math.min(33, math.max(10, math.floor(frame.baseH / 12.8)));
		local checkfont = texture:SetFont(self.Fonts[aurastextfont], fontsize, "OUTLINE, MONOCHROME");
		if not checkfont then
			texture:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE, MONOCHROME");
		end
		frame.baseL = texture:GetStringWidth() + 5;
	else
		frame.baseL = 256 * size * torsion;
	end
end

function PowaAuras:SetupStaticPopups()
	
	StaticPopupDialogs["POWERAURAS_IMPORT_AURA"] = {
		text = self.Text.aideImport,
		button1 = ACCEPT,
		button2 = CANCEL,
		hasEditBox = 1,
		maxLetters = self.ExportMaxSize,
		--hasWideEditBox = 1,
		editBoxWidth = self.ExportWidth,
		OnAccept = function(self)
			PowaAuras:CreateNewAuraFromImport(PowaAuras.ImportAuraId, self.editBox:GetText());
			self:Hide();
		end,
		OnShow = function(self)
			self.editBox:SetFocus();
		end,
		OnHide = function(self)
			ChatEdit_FocusActiveWindow(); 	
			self.editBox:SetText("");
			PowaAuras:DisplayAura(PowaAuras.CurrentAuraId);
			PowaAuras:UpdateMainOption();
		end,
		EditBoxOnEnterPressed = function(self)
			local parent = self:GetParent();
			PowaAuras:CreateNewAuraFromImport(PowaAuras.ImportAuraId, parent.editBox:GetText());
			parent:Hide();
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide();
		end,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		hideOnEscape = 1
	};
	
	StaticPopupDialogs["POWERAURAS_IMPORT_AURA_SET"] = {
		text = self.Text.aideImportSet,
		button1 = ACCEPT,
		button2 = CANCEL,
		hasEditBox = 1,
		maxLetters = self.ExportMaxSize * 24,
		--hasWideEditBox = 1,
		editBoxWidth = self.ExportWidth,
		OnAccept = function(self)
			PowaAuras:CreateNewAuraSetFromImport(self.editBox:GetText());
			self:Hide();
		end,
		OnShow = function(self)
			self.editBox:SetFocus();
		end,
		OnHide = function(self)
			ChatEdit_FocusActiveWindow(); 
			self.editBox:SetText("");
			PowaAuras:DisplayAura(PowaAuras.CurrentAuraId);
			PowaAuras:UpdateMainOption();
		end,
		EditBoxOnEnterPressed = function(self)
			local parent = self:GetParent();
			PowaAuras:CreateNewAuraSetFromImport(parent.editBox:GetText());
			parent:Hide();
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide();
		end,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		hideOnEscape = 1
	};

end
