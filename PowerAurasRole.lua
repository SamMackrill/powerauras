
-- Reset if spec changed or slash command
function PowaAuras:ResetTalentScan(unit)
	if (unit == nil) then
		table.wipe(VUHDO_INSPECTED_ROLES);
		table.wipe(VUHDO_FIX_ROLES);
	else
		if (VUHDO_PLAYER_RAID_ID == unit) then
			unit = "player";
		end

		local tInfo = VUHDO_RAID[unit];
		if (tInfo ~= nil) then
			VUHDO_INSPECTED_ROLES[tInfo.name] = nil;
			VUHDO_FIX_ROLES[tInfo.name] = nil;
		end
	end
end


function PowaAuras:TrimInspected()
	for unitName, _ in pairs(VUHDO_INSPECTED_ROLES) do
		if (VUHDO_RAID_NAMES[unitName] == nil) then
			VUHDO_INSPECTED_ROLES[unitName] = nil;
			VUHDO_FIX_ROLES[unitName] = nil;
		end
	end
end



-- If timeout after talen tree server request
function PowaAuras:SetRoleUndefined(unit)
	local tInfo = VUHDO_RAID[unit];
	if (tInfo ~= nil) then
		VUHDO_INSPECTED_ROLES[tInfo.name] = nil;
	end
end



--
local tInfo;
local tClass;
function PowaAuras:ShouldBeInspected(unit)
	if ("focus" == unit) then
		return false;
	end

	tInfo = VUHDO_RAID[unit];
	if (tInfo.isPet or not tInfo.connected) then
		return false;
	end

	tClass = tInfo.classId;
	if (VUHDO_ID_ROGUES == tClass
		or VUHDO_ID_HUNTERS == tClass
		or VUHDO_ID_MAGES == tClass
		or VUHDO_ID_WARLOCKS == tClass
		or VUHDO_ID_DEATH_KNIGHT == tClass) then
		return false;
	end

	if (VUHDO_INSPECTED_ROLES[tInfo.name] ~= nil) then
		return false;
	end

	if (not CheckInteractDistance(unit, 1)) then
		return false;
	end

	return true;
end



--
local tUnit;
function PowaAuras:TryInspectNext()
	for tUnit, _ in pairs(VUHDO_RAID) do
		if (VUHDO_shouldBeInspected(tUnit)) then
			VUHDO_NEXT_INSPECT_TIME_OUT = GetTime() + VUHDO_INSPECT_TIMEOUT;
			VUHDO_NEXT_INSPECT_UNIT = tUnit;
			if ("player" == tUnit) then
				VUHDO_inspectLockRole();
			else
				NotifyInspect(tUnit);
			end

			return;
		end
	end
end



--
local tIcon1, tIcon2, tIcon3;
local tActiveTree;
local tIsInspect;
local tInfo;
function PowaAuras:InspectLockRole()
	tInfo = VUHDO_RAID[VUHDO_NEXT_INSPECT_UNIT];

	if (tInfo == nil) then
		VUHDO_NEXT_INSPECT_UNIT = nil;
		return;
	end

	tIsInspect = "player" ~= tInfo.unit;

	tActiveTree = GetActiveTalentGroup(tIsInspect);
	_, tIcon1, tPoints1, _ = GetTalentTabInfo(1, tIsInspect, false, tActiveTree);
	_, tIcon2, tPoints2, _ = GetTalentTabInfo(2, tIsInspect, false, tActiveTree);
	_, tIcon3, tPoints3, _ = GetTalentTabInfo(3, tIsInspect, false, tActiveTree);

	if (VUHDO_ID_PRIESTS == tInfo.classId) then
		-- 1 = Disc, 2 = Holy, 3 = Shadow
		if (tPoints1 > tPoints3
		or tPoints2 > tPoints3)	 then
			VUHDO_INSPECTED_ROLES[tInfo.name] = VUHDO_ID_RANGED_HEAL;
		else
			VUHDO_INSPECTED_ROLES[tInfo.name] = VUHDO_ID_RANGED_DAMAGE;
		end

	elseif (VUHDO_ID_WARRIORS == tInfo.classId) then
		-- Waffen, Furor, Schutz
		if (tPoints1 > tPoints3
		or tPoints2 > tPoints3)	 then
			VUHDO_INSPECTED_ROLES[tInfo.name] = VUHDO_ID_MELEE_DAMAGE;
		else
			VUHDO_INSPECTED_ROLES[tInfo.name] = VUHDO_ID_MELEE_TANK;
		end

	elseif (VUHDO_ID_DRUIDS == tInfo.classId) then
		-- 1 = Gleichgewicht, 2 = Wilder Kampf, 3 = Wiederherstellung
		if (tPoints1 > tPoints2 and tPoints1 > tPoints3) then
			VUHDO_INSPECTED_ROLES[tInfo.name] = VUHDO_ID_RANGED_DAMAGE;
		elseif(tPoints3 > tPoints2) then
			VUHDO_INSPECTED_ROLES[tInfo.name] = VUHDO_ID_RANGED_HEAL;
		else
			-- "Natürliche Reaktion" geskillt => Wahrsch. Tank?
			_, _, _, _, tRank, _, _, _ = GetTalentInfo(2, 16, tIsInspect, false, tActiveTree);
			if (tRank > 0) then
				VUHDO_INSPECTED_ROLES[tInfo.name] = VUHDO_ID_MELEE_TANK;
			else
				VUHDO_INSPECTED_ROLES[tInfo.name] = VUHDO_ID_MELEE_DAMAGE;
			end
		end

	elseif (VUHDO_ID_PALADINS == tInfo.classId) then
		-- 1 = Heilig, 2 = Schutz, 3 = Vergeltung
		if (tPoints1 > tPoints2 and tPoints1 > tPoints3) then
			VUHDO_INSPECTED_ROLES[tInfo.name] = VUHDO_ID_RANGED_HEAL;
		elseif (tPoints2 > tPoints3) then
			VUHDO_INSPECTED_ROLES[tInfo.name] = VUHDO_ID_MELEE_TANK;
		else
			VUHDO_INSPECTED_ROLES[tInfo.name] = VUHDO_ID_MELEE_DAMAGE;
		end

	elseif (VUHDO_ID_SHAMANS == tInfo.classId) then
	  -- 1 = Elementar, 2 = Verstärker, 3 = Wiederherstellung
		if (tPoints1 > tPoints2 and tPoints1 > tPoints3) then
			VUHDO_INSPECTED_ROLES[tInfo.name] = VUHDO_ID_RANGED_DAMAGE;
		elseif (tPoints2 > tPoints3) then
			VUHDO_INSPECTED_ROLES[tInfo.name] = VUHDO_ID_MELEE_DAMAGE;
		else
			VUHDO_INSPECTED_ROLES[tInfo.name] = VUHDO_ID_RANGED_HEAL;
		end
	end

	ClearInspectPlayer();
	VUHDO_NEXT_INSPECT_UNIT = nil;
	if (sIsRolesConfigured) then
		VUHDO_normalRaidReload();
	else
		VUHDO_refreshRaidMembers();
	end
end



--

function PowaAuras:DetermineRole(unit)
	local _, class = UnitClass(unit);

	if (class=="ROGUE") then
		return self.Roles.MELEE_DAMAGE;
	elseif (class=="HUNTER") then
		return self.Roles.RANGED_DAMAGE;
	elseif (class=="MAGE") then
		return self.Roles.RANGED_DAMAGE;
	elseif (class=="WARLOCK") then
		return self.Roles.RANGED_DAMAGE;
	end

	local unitName = UnitName(unit);
	if (self.InspectedRoles[unitName] ~= nil) then
		return InspectedRoles[unitName];
	end

	if (self.FixRoles[unitName] ~= nil) then
		return self.FixRoles[unitName];
	end

	if (class=="DEATHKNIGHT") then
		local _, _, buffExist = UnitBuff(unit, self.Spells.BUFF_FROST_PRESENCE);
		if (buffExist) then
			self.FixRoles[unitName] = self.Roles.MELEE_TANK;
		else
			self.FixRoles[unitName] = self.Roles.MELEE_DAMAGE;
		end
		return self.FixRoles[unitName];
	elseif (class=="PRIEST") then
		local _, _, buffExist = UnitBuff(unit, self.Spells.SHADOWFORM);
		if (buffExist) then
			self.FixRoles[unitName] = self.Roles.RANGED_DAMAGE;
		else
			self.FixRoles[unitName] = self.Roles.RANGED_HEAL;
		end
		return self.FixRoles[unitName];

	elseif (class=="WARRIOR") then
		local defense = select(2, UnitDefense(unit)) / UnitLevel(unit);

		if (defense > 2) then
			self.FixRoles[unitName] = self.Roles.MELEE_TANK;
		else
			self.FixRoles[unitName] = self.Roles.MELEE_DAMAGE;
		end
		return self.FixRoles[unitName];

	elseif (class=="DRUID") then
		local _, powerType = UnitPowerType(unit);
		if (powerType == "MANA") then
			_, _, tBuffExist = UnitBuff(unit, VUHDO_SPELL_ID_MOONKIN_FORM);
			if (tBuffExist) then
				VUHDO_FIX_ROLES[tInfo.name] = VUHDO_ID_RANGED_DAMAGE;
				return VUHDO_ID_RANGED_DAMAGE;
			else
				_, _, tBuffExist = UnitBuff(unit, VUHDO_SPELL_ID_TREE_OF_LIFE);
				if (tBuffExist) then
					VUHDO_FIX_ROLES[tInfo.name] = VUHDO_ID_RANGED_HEAL;
				end

				return VUHDO_ID_RANGED_HEAL;
			end
		elseif (VUHDO_UNIT_POWER_RAGE == tPowerType) then
			VUHDO_FIX_ROLES[tInfo.name] = VUHDO_ID_MELEE_TANK;
			return VUHDO_ID_MELEE_TANK;
		elseif (VUHDO_UNIT_POWER_ENERGY == tPowerType) then
			VUHDO_FIX_ROLES[tInfo.name] = VUHDO_ID_MELEE_DAMAGE;
			return VUHDO_ID_MELEE_DAMAGE;
		end

	elseif (class=="PALADIN") then
		local defense = select(2, UnitDefense(unit)) / UnitLevel(unit);

		if (defense > 2) then
			return VUHDO_ID_MELEE_TANK;
		else
			tIntellect = UnitStat(unit, 4);
			tStrength = UnitStat(unit, 1);

			if (tIntellect > tStrength) then
				return VUHDO_ID_RANGED_HEAL;
			else
				return VUHDO_ID_MELEE_DAMAGE;
			end
		end
		return self.FixRoles[unitName];

	elseif (class=="SHAMAN") then
		tIntellect = UnitStat(unit, 4);
		tAgility = UnitStat(unit, 2);

		if (tAgility > tIntellect) then
			return VUHDO_ID_MELEE_DAMAGE;
		else
			return VUHDO_ID_RANGED_HEAL; -- Can't tell, assume its a healer
		end
	end

	return nil;
end