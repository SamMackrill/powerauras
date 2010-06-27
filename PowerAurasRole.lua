
-- Reset if spec changed or slash command
function PowaAuras:ResetTalentScan(unit)
	if (unit == nil) then
		table.wipe(self.InspectedRoles);
		table.wipe(self.FixRoles);
		return;
	end
	local unitName = UnitName(unit);
	if (unitName == nil) then return; end
	self.InspectedRoles[unitName] = nil;
	self.FixRoles[unitName] = nil;
end

--[[
function PowaAuras:TrimInspected()
	for unitName, _ in pairs(self.InspectedRoles) do
		if (VUHDO_RAID_NAMES[unitName] == nil) then
			self.InspectedRoles[unitName] = nil;
			self.FixRoles[unitName] = nil;
		end
	end
end



-- If timeout after talent tree server request
function PowaAuras:SetRoleUndefined(unit)
	local unitName = UnitName(unit);
	if (unitName == nil) then return; end
	self.InspectedRoles[unitName] = nil;
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
	if (self.Roles.ROGUES == tClass
		or self.Roles.HUNTERS == tClass
		or self.Roles.MAGES == tClass
		or self.Roles.WARLOCKS == tClass
		or self.Roles.DEATH_KNIGHT == tClass) then
		return false;
	end

	if (self.InspectedRoles[unitName] ~= nil) then
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

	if (self.Roles.PRIESTS == tInfo.classId) then
		-- 1 = Disc, 2 = Holy, 3 = Shadow
		if (tPoints1 > tPoints3
		or tPoints2 > tPoints3)	 then
			self.InspectedRoles[unitName] = self.Roles.RANGED_HEAL;
		else
			self.InspectedRoles[unitName] = self.Roles.RANGED_DAMAGE;
		end

	elseif (self.Roles.WARRIORS == tInfo.classId) then
		-- Waffen, Furor, Schutz
		if (tPoints1 > tPoints3
		or tPoints2 > tPoints3)	 then
			self.InspectedRoles[unitName] = self.Roles.MELEE_DAMAGE;
		else
			self.InspectedRoles[unitName] = self.Roles.MELEE_TANK;
		end

	elseif (self.Roles.DRUIDS == tInfo.classId) then
		-- 1 = Gleichgewicht, 2 = Wilder Kampf, 3 = Wiederherstellung
		if (tPoints1 > tPoints2 and tPoints1 > tPoints3) then
			self.InspectedRoles[unitName] = self.Roles.RANGED_DAMAGE;
		elseif(tPoints3 > tPoints2) then
			self.InspectedRoles[unitName] = self.Roles.RANGED_HEAL;
		else
			-- "Natürliche Reaktion" geskillt => Wahrsch. Tank?
			_, _, _, _, tRank, _, _, _ = GetTalentInfo(2, 16, tIsInspect, false, tActiveTree);
			if (tRank > 0) then
				self.InspectedRoles[unitName] = self.Roles.MELEE_TANK;
			else
				self.InspectedRoles[unitName] = self.Roles.MELEE_DAMAGE;
			end
		end

	elseif (self.Roles.PALADINS == tInfo.classId) then
		-- 1 = Heilig, 2 = Schutz, 3 = Vergeltung
		if (tPoints1 > tPoints2 and tPoints1 > tPoints3) then
			self.InspectedRoles[unitName] = self.Roles.RANGED_HEAL;
		elseif (tPoints2 > tPoints3) then
			self.InspectedRoles[unitName] = self.Roles.MELEE_TANK;
		else
			self.InspectedRoles[unitName] = self.Roles.MELEE_DAMAGE;
		end

	elseif (self.Roles.SHAMANS == tInfo.classId) then
	  -- 1 = Elementar, 2 = Verstärker, 3 = Wiederherstellung
		if (tPoints1 > tPoints2 and tPoints1 > tPoints3) then
			self.InspectedRoles[unitName] = self.Roles.RANGED_DAMAGE;
		elseif (tPoints2 > tPoints3) then
			self.InspectedRoles[unitName] = self.Roles.MELEE_DAMAGE;
		else
			self.InspectedRoles[unitName] = self.Roles.RANGED_HEAL;
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
]]

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
		return self.InspectedRoles[unitName];
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
			return self.Roles.RANGED_DAMAGE;
		else
			return self.Roles.RANGED_HEAL;
		end

	elseif (class=="WARRIOR") then
		local defense = select(2, UnitDefense(unit)) / UnitLevel(unit);

		if (defense > 2) then
			return self.Roles.MELEE_TANK;
		end
		return self.Roles.MELEE_DAMAGE;

	elseif (class=="DRUID") then
		local _, powerType = UnitPowerType(unit);
		if (powerType == "MANA") then
			_, _, tBuffExist = UnitBuff(unit, self.Spells.MOONKIN_FORM);
			if (tBuffExist) then
				self.FixRoles[unitName] = self.Roles.RANGED_DAMAGE;
				return self.Roles.RANGED_DAMAGE;
			else
				local _, _, tBuffExist = UnitBuff(unit, self.Spells.TREE_OF_LIFE);
				if (tBuffExist) then
					self.FixRoles[unitName] = self.Roles.RANGED_HEAL;
				end

				return self.Roles.RANGED_HEAL;
			end
		elseif (powerType == "RAGE") then
			self.FixRoles[unitName] = self.Roles.MELEE_TANK;
			return self.Roles.MELEE_TANK;
		elseif (powerType == "ENERGY") then
			self.FixRoles[unitName] = self.Roles.MELEE_DAMAGE;
			return self.Roles.MELEE_DAMAGE;
		end

	elseif (class=="PALADIN") then
		local defense = select(2, UnitDefense(unit)) / UnitLevel(unit);

		if (defense > 2) then
			return self.Roles.MELEE_TANK;
		else
			if (UnitStat(unit, 4) > UnitStat(unit, 1)) then
				return self.Roles.RANGED_HEAL;
			else
				return self.Roles.MELEE_DAMAGE;
			end
		end
		return self.FixRoles[unitName];

	elseif (class=="SHAMAN") then
		if (UnitStat(unit, 2) > UnitStat(unit, 4)) then
			return self.Roles.MELEE_DAMAGE;
		else
			return self.Roles.RANGED_HEAL; -- Can't tell, assume its a healer
		end
	end

	return nil;
end

