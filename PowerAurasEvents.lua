--- Event servicing.
-- servicing methods are named PowaAuras:XXXXX_YYYY(...).
-- Where XXXXX_YYYY matches the actual WoW event.

---
function PowaAuras:VARIABLES_LOADED(...)
	PowaMisc.disabled = nil;

	-- Ensure PowaMisc gets any new values
	for k, v in pairs(PowaAuras.PowaMiscDefault) do
		if (PowaMisc[k]==nil) then PowaMisc[k] = v; end
	end
	-- Remove redundant settings
	for k in pairs(PowaMisc) do
		if (PowaAuras.PowaMiscDefault[k]==nil) then PowaMisc[k] = nil; end
	end
	for k, v in pairs(PowaAuras.PowaGlobalMiscDefault) do
		if (PowaGlobalMisc[k]==nil) then PowaGlobalMisc[k] = v; end
	end
	-- Remove redundant settings
	for k in pairs(PowaGlobalMisc) do
		if (PowaAuras.PowaGlobalMiscDefault[k]==nil) then PowaGlobalMisc[k] = nil; end
	end	
	if (PowaMisc.OverrideMaxTextures) then
		self.MaxTextures = PowaMisc.UserSetMaxTextures;
	else
		self.MaxTextures = PowaAuras.TextureCount;
	end
	
	-- I know this looks silly, but we need to do it so updates are processed properly.
	for k, v in pairs(PowaMisc) do
		self:UpdateSetting(k, v);
	end
	for k, v in pairs(PowaGlobalMisc) do
		self:UpdateSetting(k, v);
	end
	
	local _, _, major, minor = string.find(self.Version, self.VersionPattern);
	self.VersionParts = {Major=tonumber(major), Minor=tonumber(minor), Build=0, Revision=""};
	 _, _, major, minor = string.find(PowaMisc.Version, self.VersionPattern);
	self.PreviousVersionParts = {Major=tonumber(major), Minor=tonumber(minor), Build=0, Revision=""};
	
	self.VersionUpgraded = self:VersionGreater(self.VersionParts, self.PreviousVersionParts);

	if (self.VersionUpgraded) then
		self:Message(self.Colors.Purple.."<Power Auras Classic>|r "..self.Colors.Gold..self.Version.."|r - "..self.Text.welcome);
		PowaMisc.Version = self.Version;
	end

	if (TestPA==nil) then
		PowaState = {};
	end
	
	_, self.playerclass = UnitClass("player");
	
	-- Load class auras.
	local class = UnitClass("player");
	if(not PowaClassListe) then PowaClassListe = {}; end
	if(not PowaClassListe[class]) then
		PowaClassListe[class] = {};
		for i=1,5 do
			PowaClassListe[class][i] = PowaAuras.Text.ListeClass .. i;
		end
	end

	self:LoadAuras();

	for i = 1, 5 do
		getglobal("PowaOptionsList"..i):SetText(PowaPlayerListe[i]);
	end
	for i = 1, 10 do
		getglobal("PowaOptionsList"..i+5):SetText(PowaGlobalListe[i]);
	end
	
	PowaBarAuraTextureSlider:SetMinMaxValues(1, self.MaxTextures);
	PowaBarAuraTextureSliderHigh:SetText(self.MaxTextures);
	PowaAuras:SetLockButtonText();
	
	self:FindAllChildren();
	self:CreateEffectLists();

	if (not PowaMisc.Disabled) then
		self:RegisterEvents(PowaAuras_Frame);
	end
	
	-- UI stuff. Race condition prevention (can it ever actually happen? I don't want to know..)
	if(PowaBrowser.OnVariablesLoaded) then
		PowaBrowser:OnVariablesLoaded();
	end

	self.VariablesLoaded = true;
end

---
function PowaAuras:Setup()
	PowaAuras_Tooltip:SetOwner(UIParent, "ANCHOR_NONE");

	local spellId = self.GCDSpells[PowaAuras.playerclass];
	if (not spellId) then return false; end
	self.GCDSpellName = GetSpellInfo(spellId);
	--self:TraceInfo("GCD spell = ", self.GCDSpellName, "(", spellId, ") CD=", GetSpellCooldown(self.GCDSpellName));

	-- Look-up spells by spellId for debuff types
	self.DebuffCatSpells = {}
	for k, v in pairs(self.DebuffTypeSpellIds) do
		local spellName = GetSpellInfo(k);
		if spellName then
			self.DebuffCatSpells[spellName] = v
		else
			--self:TraceError("Unknown spellId: ", k)
		end
	end	
	
	if UnitIsDeadOrGhost("player") then
		self.WeAreAlive = false;
	end
	
	self.PvPFlagSet = UnitIsPVP("player");
	self:DetermineRole("player");

	self.WeAreInRaid = (GetNumRaidMembers() > 0);
	self.WeAreInParty = (GetNumPartyMembers() > 0);

	self.WeAreMounted = (IsMounted() == 1 and true or self:IsDruidTravelForm());
	self.WeAreInVehicle = (UnitInVehicle("player")~=nil);
	
	self.Comms:Register();

	self.ActiveTalentGroup = GetActiveTalentGroup();
	
	self.Instance = self:GetInstanceType();
	
	self:GetStances();
	
	self:InitialiseAllAuras();
	
	self:MemorizeActions();
	
	self.DoCheck.All = true;
	--self:TraceInfo("DoCheck.All: Setup");

		
	self.SetupDone = true;
end

---
function PowaAuras:GetInstanceType()
	local _, instanceType = IsInInstance();
	if (instanceType=="pvp") then
		instanceType = "Bg";
	elseif (instanceType=="arena") then
		instanceType = "Arena";
	elseif (instanceType=="party" or instanceType=="raid") then
		instanceDifficulty = GetInstanceDifficulty();
		if (instanceType=="party") then
			if (instanceDifficulty==1) then
				instanceType = "5Man";
			else
				instanceType = "5ManHeroic";
			end
		else
			if (instanceDifficulty==1) then
				instanceType = "10Man";
			elseif (instanceDifficulty==2) then
				instanceType = "25Man";
			elseif (instanceDifficulty==3) then
				instanceType = "10ManHeroic";
			else
				instanceType = "25ManHeroic";
			end
		end
	else
		instanceType = "None";
	end
	--self:TraceInfo("Instance type set to "..instanceType);
	return instanceType;
end

---
function PowaAuras:PLAYER_ENTERING_WORLD(...)
	self:Setup();
end

---
function PowaAuras:ACTIVE_TALENT_GROUP_CHANGED(...)
	self.ActiveTalentGroup = GetActiveTalentGroup();
	if (self.ModTest == false) then
		self.PendingRescan = GetTime() + 1;
	end
end

---
function PowaAuras:PLAYER_TALENT_UPDATE(...)
	if (self.ModTest == false) then
		self.PendingRescan = GetTime() + 1;
	end
end
		
---
function PowaAuras:PLAYER_UPDATE_RESTING(...)
	if (self.ModTest == false) then
		self.DoCheck.All = true;
		--self:TraceInfo("DoCheck.All: PLAYER_UPDATE_RESTING");
	end
end

---
function PowaAuras:PARTY_MEMBERS_CHANGED(...)	  
	if (self.ModTest == false) then
		self:MarkAuras("PartyBuffs", "GroupOrSelfBuffs", "PartyHealth", "PartyMana", "UnitMatch");
	end
	local partyCount = GetNumPartyMembers();
	self.WeAreInParty = (partyCount > 0);
	if (GetNumRaidMembers()>0) then return; end
	self:FillGroup("party", partyCount);
end
		
---
function PowaAuras:RAID_ROSTER_UPDATE(...)
	if (self.ModTest == false) then
		self:MarkAuras("RaidBuffs", "GroupOrSelfBuffs", "RaidHealth", "RaidMana", "UnitMatch");
	end
	local raidCount = GetNumRaidMembers();
	self.WeAreInRaid = (raidCount > 0);
	self:FillGroup("raid", raidCount);
end

---
function PowaAuras:FillGroup(group, count)
	wipe(self.GroupUnits);
	wipe(self.GroupNames);
	for i = 1, count do
		local unit = group..i;
		local role, roleType = self:DetermineRole(unit);
		if (group=="raid" and UnitIsUnit(unit, "player")) then
			unit = "player";
		end
		self.GroupUnits[unit] = {Name = UnitName(unit), Class = select(2, UnitClass(unit))};
		self.GroupNames[self.GroupUnits[unit].Name] = true;
		--self:TraceInfo(self.GroupUnits[unit].Name," - ",self.Text.Role[role], " (", roleType, ")");
	end
	PowaAuras:TrimInspected();
end

---
function PowaAuras:INSPECT_TALENT_READY()
	self:InspectRole();
end
	
---
function PowaAuras:UNIT_HEALTH(...)
	local unit = ...;
	self:SetCheckResource("Health", unit);
end
		
---
function PowaAuras:UNIT_MAXHEALTH(...)
	local unit = ...;
	self:SetCheckResource("Health", unit);
end

---
function PowaAuras:UNIT_POWER(...)
	local unit, resourceType = ...;
	self:CheckPower(unit, resourceType);
end

---
function PowaAuras:UNIT_MAXPOWER(...)
	local unit, resourceType = ...;
	self:CheckPower(unit, resourceType);
end

---
function PowaAuras:CheckPower(unit, resourceType)
	if (resourceType=="MANA") then
		self:SetCheckResource("Mana", unit);
	else
		self:SetCheckResource("Power", unit);
	end
end

---
function PowaAuras:SetCheckResource(resourceType, unitType)
	if (self.ModTest == false) then
		if (unitType == "target") then
			self:MarkAuras("Target"..resourceType);
		elseif (unitType == "focus") then             
			self:MarkAuras("Focus"..resourceType);
		elseif ("party" == string.sub(unitType, 1, 5)) then 
			self:MarkAuras("Party"..resourceType, "NamedUnit"..resourceType);
		elseif ("raid" == string.sub(unitType, 1, 4)) then              
			self:MarkAuras("Raid"..resourceType, "NamedUnit"..resourceType);
		elseif (unitType == "pet") then
			self:MarkAuras("NamedUnit"..resourceType);
		elseif (unitType == "player") then
			self:MarkAuras(resourceType);
		end
	end
end

---
function PowaAuras:SpellcastEvent(unit)
	if (self.ModTest == false) then
		--- spell alert handling
		if (self.DebugEvents) then
			self:Debug("SpellcastEvent: ", unit);
		end
		if unit and not UnitIsDead(unit) then
			if UnitIsUnit(unit, "player") then
				self:MarkAuras("PlayerSpells", "GroupOrSelfSpells");
			end
			if UnitIsUnit(unit, "focus") then
				self:MarkAuras("FocusSpells");
			end
			if UnitIsUnit(unit, "target") then
				self:MarkAuras("TargetSpells");
			end
			if (UnitCanAttack(unit, "player")) then
				self:MarkAuras("Spells");
			else
				if (UnitInParty(unit)) then
					self:MarkAuras("PartySpells", "GroupOrSelfSpells");
				end
				if (UnitInRaid(UnitInRaid(unit))) then
					self:MarkAuras("RaidSpells", "GroupOrSelfSpells");
				end
			end
		end
	end
end

---
function PowaAuras:UNIT_SPELLCAST_SUCCEEDED(...)	  
	if (self.ModTest == false) then
		local unit, spell = ...;

		self.ExtraUnitEvent[unit] = spell;	
		self:SpellcastEvent(unit);
	
		if (self.TalentChangeSpells[spell]) then
			self:ResetTalentScan(unit);
			self.DoCheck.All = true;
			--self:TraceInfo("DoCheck.All: Talents changed");
		end
		if (self.DebugEvents) then
			self:Debug("UNIT_SPELLCAST_SUCCEEDED ",unit, " ", spell);
		end
		--- druid shapeshift special case
		if (unit == "player") then
			if ( (spell == self.Spells.DRUID_SHIFT_CAT)
			  or (spell == self.Spells.DRUID_SHIFT_BEAR)
			  or (spell == self.Spells.DRUID_SHIFT_DIREBEAR)
			  or (spell == self.Spells.DRUID_SHIFT_MOONKIN) ) then
				self:MarkAuras("Mana", "Power");
			end			
			for _, auraId in pairs(self.AurasByType.SpellCooldowns) do	
				--self:TraceInfo("Pending set for SpellCooldowns ", auraId);
				self:MarkAuras("SpellCooldowns");
				self.Pending[auraId] = GetTime() + 0.5; -- Allow 0.5 sec for client to update or time may be wrong
			end
		end
	end
end

---
function PowaAuras:UNIT_SPELLCAST_START(...)
	local unit = ...;
	PowaAuras:SpellcastEvent(unit);
end

---
function PowaAuras:UNIT_SPELLCAST_CHANNEL_START(...)
	local unit = ...;
	PowaAuras:SpellcastEvent(unit);
end

---
function PowaAuras:UNIT_SPELLCAST_DELAYED(...)
	local unit = ...;
	PowaAuras:SpellcastEvent(unit);
end

---
function PowaAuras:UNIT_SPELLCAST_CHANNEL_UPDATE(...)
	local unit = ...;
	PowaAuras:SpellcastEvent(unit);
end

---
function PowaAuras:UNIT_SPELLCAST_STOP(...)
	local unit = ...;
	PowaAuras:SpellcastEvent(unit);
end

---
function PowaAuras:UNIT_SPELLCAST_FAILED(...)
	local unit = ...;
	PowaAuras:SpellcastEvent(unit);
end

---
function PowaAuras:UNIT_SPELLCAST_INTERRUPTED(...)
	local unit = ...;
	PowaAuras:SpellcastEvent(unit);
end

---
function PowaAuras:UNIT_SPELLCAST_CHANNEL_STOP(...)
	local unit = ...;
	PowaAuras:SpellcastEvent(unit);
end

---
function PowaAuras:RUNE_POWER_UPDATE(...)
	if (self.ModTest == false) then
		self:MarkAuras("Runes");
	end
end

---
function PowaAuras:RUNE_TYPE_UPDATE(...)
	local runeId = ...;
	if (self.ModTest == false) then
		if (self.DebugEvents) then
			self:Debug("PLAYER_TOTEM_UPDATE slot=", slot);
		end
		self:MarkAuras("Runes");
	end
end
	
---
function PowaAuras:PLAYER_FOCUS_CHANGED(...)	  
	if (self.ModTest == false) then
		self:MarkAuras("FocusBuffs", "FocusHealth", "FocusMana", "FocusPower", "FocusSpells", "StealableFocusSpells", "PurgeableFocusSpells", "UnitMatch");
	end
end

---
function PowaAuras:BuffsChanged(unit)
	if (not self.ModTest) then
		--self:TraceInfo("==>BuffsChanged ", unit, " uip=", UnitIsPlayer(unit));
		--if (unit ~= "player" and UnitIsPlayer(unit)) then
		--	unit = "player";
		--	self:TraceInfo("!!Set to Player!!");
		--end
		self.ChangedUnits.Buffs[unit] = true;
		--self:TraceInfo("ChangedUnits empty=", self:TableEmpty(self.ChangedUnits.Buffs));
		self:MarkAuras("UnitBuffs");
		if (unit == "target") then
			self:MarkAuras("TargetBuffs", "StealableTargetSpells", "PurgeableTargetSpells");
		elseif ("party" == string.sub(unit, 1, 5)) then 
			self:MarkAuras("PartyBuffs", "GroupOrSelfBuffs");
		elseif (unit == "focus") then
			self:MarkAuras("FocusBuffs", "StealableFocusSpells", "PurgeableFocusSpells");
		elseif (string.sub(unit, 1, 4) == "raid") then
			self:MarkAuras("RaidBuffs", "GroupOrSelfBuffs");
		elseif (unit == "player") then
			self:MarkAuras("Buffs", "GroupOrSelfBuffs");
		end
		if (UnitCanAttack(unit, "player")) then
			self:MarkAuras("StealableSpells", "PurgeableSpells");
		end
	end
end

---
function PowaAuras:UNIT_AURA(...)
	local unit = select(1, ...);
	if (self.DebugEvents) then
		self:Debug("UNIT_AURA ", unit);
	end
	self:BuffsChanged(unit);
end

---
function PowaAuras:UNIT_AURASTATE(...)
	local unit = select(1, ...);
	if (self.DebugEvents) then
		self:Debug("UNIT_AURASTATE ", unit);
	end
	self:BuffsChanged(unit);
end

---
function PowaAuras:PLAYER_DEAD(...)
	if (self.ModTest == false) then
		self.DoCheck.All = true;
		--self:TraceInfo("DoCheck.All: PLAYER_DEAD");
	end
	self.WeAreMounted = false;
	self.WeAreInVehicle = false;
	self.WeAreAlive = false;
end
	
---
function PowaAuras:PLAYER_ALIVE(...)
	if not UnitIsDeadOrGhost("player") then
		self.WeAreAlive = true;
		if (self.ModTest == false) then
			self.DoCheck.All = true;
			--self:TraceInfo("DoCheck.All: PLAYER_ALIVE");
		end
	end
end
	
---
function PowaAuras:PLAYER_UNGHOST(...)
	if not UnitIsDeadOrGhost("player") then
		self.WeAreAlive = true;
		if (self.ModTest == false) then
			self.DoCheck.All = true;
			--self:TraceInfo("DoCheck.All: PLAYER_UNGHOST");
		end
	end
end
 
---
function PowaAuras:PLAYER_TARGET_CHANGED(...)
	if (self.ModTest == false) then
		self:MarkAuras("TargetBuffs", "TargetHealth", "TargetMana", "TargetPower", "Actions", "StealableTargetSpells", 
			"PurgeableTargetSpells", "Combo", "UnitMatch");
		self.ResetTargetTimers = true;
	end
end

 
---
function PowaAuras:UNIT_TARGET(...)
	local unit = select(1, ...);
	local target = unit.."target";
	if (self.DebugEvents) then
		self:Debug("UNIT_TARGET ", unit);
	end
	if (self.ModTest == false) then
		self:MarkAuras("UnitMatch");
		for existingTarget in pairs (PowaAuras.ChangedUnits.Targets) do
			if (UnitIsUnit(target, existingTarget)) then
				return;
			end
		end
		self.ChangedUnits.Targets[target] = unit;
		if (UnitCanAttack(target, "player")) then
			self:MarkAuras("StealableSpells", "PurgeableSpells");
		end
	end
end
	 
---
function PowaAuras:PLAYER_REGEN_DISABLED(...)
	self.WeAreInCombat = true;
	if (self.ModTest == false) then
		self.DoCheck.All = true;
		--self:TraceInfo("DoCheck.All: PLAYER_REGEN_DISABLED");
	end	   
end
	   
---
function PowaAuras:PLAYER_REGEN_ENABLED(...)
	self.WeAreInCombat = false;
	if (self.ModTest == false) then
		self.DoCheck.All = true;
		--self:TraceInfo("DoCheck.All: PLAYER_REGEN_ENABLED");
	end
end   


---
function PowaAuras:ZONE_CHANGED_NEW_AREA()
	local instanceType = self:GetInstanceType();
	if (self.Instance == instanceType) then return; end
	self.Instance = instanceType;
	if (self.ModTest == false) then
		if (self.DebugEvents) then
			self:Debug("ZONE_CHANGED_NEW_AREA ", self.InInstance, " - ", self.InstanceType);
		end
		self.DoCheck.All = true;
		--self:TraceInfo("DoCheck.All: ZONE_CHANGED_NEW_AREA");
	end
end

---
function PowaAuras:UNIT_COMBO_POINTS(...)
	local unit = ...;
	if (unit ~= "player") then return; end
	if (self.ModTest == false) then
		self:MarkAuras("Combo");
	end
end

---
function PowaAuras:UNIT_PET(...)
	local unit = ...;
	if (unit ~= "player") then return; end
	if (self.ModTest == false) then
		self:MarkAuras("Pet", "UnitMatch");
	end
end

---
function PowaAuras:PLAYER_TOTEM_UPDATE(...)
	local slot = ...;
	if (self.ModTest == false) then
		if (self.DebugEvents) then
			self:Debug("PLAYER_TOTEM_UPDATE slot=", slot, " class=", self.playerclass);
		end
		if (self.playerclass=="SHAMAN" or self.playerclass=="DRUID") then
			self:MarkAuras("Totems");
		elseif (self.playerclass=="DEATHKNIGHT" and not self.MasterOfGhouls) then
			if (self.DebugEvents) then
				self:Debug("Ghoul (temp version)");
			end
			self:MarkAuras("Pet");
		end
	end
end

---
function PowaAuras:VehicleCheck(unit, entered)
	if unit ~= "player" then return; end
	if (self.ModTest == false) then
		self.DoCheck.All = true;
		--self:TraceInfo("DoCheck.All: VehicleCheck");
	end	
	self.WeAreInVehicle = entered;
end
		
---
function PowaAuras:UNIT_ENTERED_VEHICLE(...)
	local unit = ...;
	self:VehicleCheck(unit, true)
end

---
function PowaAuras:UNIT_EXITED_VEHICLE(...)
	local unit = ...;
	self:VehicleCheck(unit, false)
end
	
---
function PowaAuras:PLAYER_FLAGS_CHANGED(...)
	local unit = ...;
	if (self.DebugEvents) then
		self:Debug("PLAYER_FLAGS_CHANGED unit = ",unit);
	end
	self:FlagsChanged(unit);
end

---
function PowaAuras:UNIT_FACTION(...)
	local unit = ...;
	if (self.DebugEvents) then
		self:Debug("UNIT_FACTION unit = ",unit);
	end
	self:FlagsChanged(unit);
end

---
function PowaAuras:FlagsChanged(unit)
	if (unit == "player") then
		local flag = UnitIsPVP("player");
		if (flag ~= self.PvPFlagSet) then
			self.PvPFlagSet = flag;
			--self:TraceInfo("UNIT_FACTION Player PvP = ",flag);
			if (self.ModTest == false) then
				self.DoCheck.All = true;
				--self:TraceInfo("DoCheck.All: FlagsChanged");
			end
		end
		return;
	end
	if (self.ModTest == false) then
		if (unit == "target") then
			self:MarkAuras("TargetPvP");
		end

		for i=1,GetNumPartyMembers() do
			if (unit == "party"..i) then
				self:MarkAuras("PartyPvP");
				break;
			end
		end
		for i=1, GetNumRaidMembers() do
			if (unit == "raid"..i) then
				self:MarkAuras("RaidPvP");
				break;
			end
		end
	end
end
	
---
function PowaAuras.StringStarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

---
function PowaAuras.StringEnds(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end

---
function PowaAuras:COMBAT_LOG_EVENT_UNFILTERED(...)
	--self:TraceInfo("COMBAT_LOG_EVENT_UNFILTERED");
	if (self.ModTest) then return end
	-- Args.
	local timestamp, event, casterHidden, 
		sourceGUID, sourceName, sourceFlags, sourceFlags2,
		destGUID, destName, destFlags, destFlags2, 
		spellId, spellName, _, spellType = ...;
	if (not spellName) then return end
	--self:TraceInfo("CLEU: ", event, " by me=", sourceGUID==UnitGUID("player"), " on me=", destGUID==UnitGUID("player"), " ", spellName);
	--self:TraceInfo("Player=", UnitGUID("player"), " sourceGUID=", sourceGUID, " destGUID=", destGUID);
	--self:TraceInfo(sourceName, " ", destName);
	--self:TraceInfo(sourceFlags, " ", destFlags);
	--
	--if bit.band(destFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) > 0 then
	--	self:TraceInfo("Dest: a player")
	--end		
	--if bit.band(destFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then
	--	self:TraceInfo("Dest: belongs to me")
	--end
	if (sourceGUID==UnitGUID("player") and event=="SPELL_CAST_SUCCESS") then
		if (self.DebugEvents) then
			self:Debug("COMBAT_LOG_EVENT_UNFILTERED", "-  By Me! ", event);
		end
		self.CastByMe[spellName] = {SpellName=spellName, SpellId=spellId, DestGUID=destGUID, DestName=destName, Hostile=bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE)};
		--self:TraceInfo(sourceName, " ", destName);
		--self:TraceInfo(sourceFlags, " ", destFlags);
		--self:TraceInfo("hostile ", self.CastByMe[spellName].Hostile);
		--if self.CastByMe[spellName].Hostile > 0 then
		--	self:TraceInfo(self.Colors.Red, spellName, " cast by me on ", destName);
		--elseif (destName~=nil) then
		--	self:TraceInfo(self.Colors.Green, spellName, " cast by me on ", destName);
		--else
		--	self:TraceInfo(self.Colors.Green, spellName, " cast by me");
		--end
		self:MarkAuras("PlayerSpells", "GroupOrSelfSpells");
	end
	
	if (destGUID==UnitGUID("player")) then
		if (self.DebugEvents) then
			self:Debug("COMBAT_LOG_EVENT_UNFILTERED", "-  On Me! ", event);
		end
		if (PowaAuras.StringStarts(event,"SPELL_") and sourceName) then
			self.CastOnMe[sourceName] = {SpellName=spellName, SpellId=spellId, SourceGUID=sourceGUID, Hostile=bit.band(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE)};
			self:MarkAuras("Spells");
			--if self.CastOnMe[sourceName].Hostile > 0 then
			--	self:TraceInfo(self.Colors.Red, spellName, " cast on me by ", sourceName);
			--else
			--	self:TraceInfo(self.Colors.Green, spellName, " cast on me by ", sourceName);
			--end
			return;
		end
		if (event == "ENVIRONMENTAL_DAMAGE") then
			--self:TraceInfo("ENVIRONMENTAL_DAMAGE type=", spellId, " size=", spellName);					
			if  (spellId ~= "FALLING") then
				self.AoeAuraAdded[0] = spellId;
				self:MarkAuras("Aoe");
			end
			return;
		end
		if ((event=="SPELL_PERIODIC_DAMAGE"
			  or event=="SPELL_DAMAGE"
			  or ((event=="SPELL_AURA_APPLIED" or event=="SPELL_AURA_APPLIED_DOSE") and spellType=="DEBUFF"))) then
			--self:TraceInfo("SPELL_PERIODIC_DAMAGE ", spellId, " ", spellName);
			self.AoeAuraAdded[spellId] = spellName;
			if (not self.AoeAuraTexture[spellName]) then
				self.AoeAuraTexture[spellId] = select(3, GetSpellInfo(spellId));
			end
			self:MarkAuras("Aoe");
			return;
		end
	end

end

---
function PowaAuras:ACTIONBAR_SLOT_CHANGED(...)
	local actionIndex = ...;
	self:MemorizeActions(actionIndex);
	self:MarkAuras("Actions");
end
	
---
function PowaAuras:UPDATE_SHAPESHIFT_FORMS(...)
	self:GetStances();
	if (self.ModTest) then return; end
	
	self:MarkAuras("Stance");
end

---
function PowaAuras:GetStances()
	if (self.playerclass=="WARLOCK") then -- Fix for Warlock metamorphosis
		self.PowaStance[2] = select(2,GetShapeshiftFormInfo(1));
		return;
	end
	if(self.playerclass == "ROGUE") then -- Fix for shadow dance (which is apparently at index 3).
		self.PowaStance[1] = select(2,GetShapeshiftFormInfo(1));
		self.PowaStance[3] = select(2,GetShapeshiftFormInfo(3));
		return;
	end
	for iForm=1, GetNumShapeshiftForms() do
		self.PowaStance[iForm] = select(2,GetShapeshiftFormInfo(iForm));
	end
end
	
---
function PowaAuras:ACTIONBAR_UPDATE_COOLDOWN(...)
	if (self.ModTest) then return; end
	self:MarkAuras("Stance", "Actions");
end
		
---
function PowaAuras:ACTIONBAR_UPDATE_USABLE(...)
	if (self.ModTest) then return; end
	self:MarkAuras("Stance", "Actions");
end
	
---
function PowaAuras:SPELL_UPDATE_USABLE(...)
	if (self.ModTest) then return; end
	--self:TraceInfo("SPELL_UPDATE_USABLE ", unit);
	self:MarkAuras("SpellCooldowns");
end
		
---
function PowaAuras:UPDATE_SHAPESHIFT_FORM(...)
	if (self.ModTest) then return; end
	self:MarkAuras("Stance", "Actions", "Combo");
end

---
function PowaAuras:UNIT_INVENTORY_CHANGED(...)
	if (self.ModTest == false) then
		local unit = ...;
		if (unit=="player") then
			if (self.DebugEvents) then
				self:Debug("UNIT_INVENTORY_CHANGED ", unit);
			end
			self:MarkAuras("Items", "Slots");
			for _, auraId in pairs(self.AurasByType.Enchants) do
				if (self.DebugEvents) then
					self:Debug("Pending set for Enchants ", auraId);
				end
				self.Pending[auraId] = GetTime() + 0.25; -- Allow time for client to update or timer will be wrong
			end
		end			
	end  
end

---
function PowaAuras:BAG_UPDATE_COOLDOWN()
	if (self.ModTest == false) then
		self:MarkAuras("Items", "Slots");
	end
end

---
function PowaAuras:BAG_UPDATE()
	if (self.ModTest == false) then
		self:MarkAuras("Items", "Slots");
	end
end

---
function PowaAuras:MINIMAP_UPDATE_TRACKING()
	if (self.ModTest == false) then
		self:MarkAuras("Tracking");
	end
end

---
function PowaAuras:UNIT_THREAT_SITUATION_UPDATE(...)
	if (self.ModTest == false) then
		local unit = ...;
		if (self.DebugEvents) then
			self:Debug("UNIT_THREAT_SITUATION_UPDATE ", unit);
		end
		if unit == "player" then
			self:MarkAuras("Aggro");
			return;
		end

		if UnitInParty(unit) then
			self:MarkAuras("PartyAggro");
		end

		if UnitInRaid(unit) then
			self:MarkAuras("RaidAggro");
		end
	end
end

--- Enables the boss1-boss3 units.
function PowaAuras:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	if (self.ModTest == false) then
		self:MarkAuras("UnitMatch");
	end
end

---
function PowaAuras:UNIT_NAME_UPDATE()
	if (self.ModTest == false) then
		self:MarkAuras("UnitMatch");
	end
end
