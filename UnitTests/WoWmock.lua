-- class.lua
-- Compatible with Lua 5.1 (not 5.0).
function MockClass(base,ctor)
	local c = {}     -- a new class instance
	if not ctor and type(base) == 'function' then
      ctor = base
      base = nil
	elseif type(base) == 'table' then
   -- our new class is a shallow copy of the base class!
      for i,v in pairs(base) do
          c[i] = v
      end
      c._base = base
	end
	-- the class will be the metatable for all its objects,
	-- and they will look up their methods in it.
	c.__index = c

	-- expose a ctor which can be called by <classname>(<args>)
	local mt = {}
	mt.__call = function(class_tbl,...)
		local obj = {}
		setmetatable(obj,c)
		if ctor then
			--PowaAuras:ShowText("Call constructor "..tostring(ctor));
			ctor(obj,...)
		end 
		return obj
	end
    
    if ctor then
		c.init = ctor;
    else 
 		if base and base.init then
			c.init = base.init;
			ctor = base.init;
		end
    end
 
	c.is_a = function(self,klass)
      local m = getmetatable(self)
      while m do 
         if m == klass then return true end
         m = m._base
      end
      return false
    end
  setmetatable(c,mt)
  return c
end


PowaState = {};

function getglobal(key)
	return _G[key];
end

function setglobal(key, value) 
	_G[key] = value;
	setfenv(0, _G );
	return _G[key];
end

function seterrorhandler(fun)
end

function TEXT()
end

function LibStub(major, silent)
end

ChatFrame1 = {};
RED_FONT_COLOR = {r=1,g=0,b=0};
NORMAL_FONT_COLOR = {r=1,g=1,b=1};

WoWMock = {};
WoWMock.Output = "";
WoWMock.ControlKeyDown = false;
WoWMock.AltKeyDown = false;
WoWMock.Target = "target";
WoWMock.LastTarget = nil;


function WoWMock:PrintTable(t)
	if (type(t)~="table") then
		print(t, "is not a table");
	end
	print(t);
	for k,v in pairs(t) do
		print(k,v);
	end
end

function WoWMock:table_minmax(tab)
    local min,max=nil,nil
    for k,v in tab do
        local k_num = tonumber(k)
        if ( k_num ) then
            if ( not min or k_num < min ) then
                min = k_num
            end
            if ( not max or k_num > max ) then
                max = k_num
            end
        end
    end
    return min,max
end

function WoWMock:table_first(tab)
    local min = PA:table_minmax(tab)
    if ( min ) then
        return min,tab[min]
    else
        for k,v in tab do
            return k,v
        end
    end
    return nil,nil
end

function WoWMock:TableEmpty(tableList)
	for key, value in tableList do
		return false;
	end
	return true;
end

function WoWMock:RecordOutput(msg)
	self.Output = self.Output..msg.."#";	
	if (LuaUnit.Verbose==true) then
		print(msg);
	end
end

function ChatFrame1.AddMessage (me, msg, r,g,b,a)
	WoWMock:RecordOutput(msg);
end

UIErrorsFrame = ChatFrame1;

function UIDropDownMenu_SetSelectedValue(owner, value)
end

function GetName(self)
	if ( self ) then
		if ( self.name ) then 
			return self.name;
		else
			return "TestProgram";
		end
	end

	return nil;
end

function GetTime()
	return WoWMock:GetState("Time");
end

function GetLocale()
	return WoWMock:GetState("Locale");
end

function WoWMock:GetState(key, default)
	if (PowaState[key]==nil) then
		key = string.lower(key);
		if (PowaState[key]~=nil) then
			return PowaState[key];
		end
		return default;
	end
	return PowaState[key];
end

function GetRealZoneText()	
	return WoWMock:GetState("Zone");
end

function GetRealmName()
	return WoWMock:GetState("Realm");
end

function WoWMock:GetUnit(unit)
	if (unit==nil) then return nil; end
	unit = string.lower(unit);
	local UnitInfo = PowaState[unit];
	if (UnitInfo~=nil) then
		return UnitInfo;
	end
	if (PowaState["Party"]~=nil) then
		UnitInfo = PowaState.Party[unit];
		if (UnitInfo~=nil) then
			return UnitInfo;
		end
	end
	if (PowaState["Raid"]~=nil) then
		UnitInfo = PowaState.Raid[unit];
		if (UnitInfo~=nil) then
			return UnitInfo;
		end
	end
	return nil;
end

function GetSpellInfo(id)
	if (not PowaState["SpellInfo"] or not PowaState["SpellInfo"][id]) then
		return nil;
	end
	return PowaState["SpellInfo"][id].Name,
     	   PowaState["SpellInfo"][id].Rank, 
		   PowaState["SpellInfo"][id].Icon, 
		   PowaState["SpellInfo"][id].Cost, 
		   PowaState["SpellInfo"][id].IsFunnel, 
		   PowaState["SpellInfo"][id].PowerType, 
		   PowaState["SpellInfo"][id].CastTime, 
		   PowaState["SpellInfo"][id].MinRange, 
		   PowaState["SpellInfo"][id].MaxRange;
end

function GetRuneCooldown(id)
	if (not PowaState["RuneCooldown"] or not PowaState["RuneCooldown"][id]) then
		return nil;
	end
	return PowaState["RuneCooldown"][id].Start, PowaState["RuneCooldown"][id].Duration, PowaState["RuneCooldown"][id].RuneReady;
end
function GetRuneType(id)
	if (not PowaState["RuneType"]) then
		return nil;
	end
	return PowaState["RuneType"][id];
end

function GetTotemInfo(slot)
	if (not PowaState["Totem"] or not PowaState.Totem[slot]) then
		return nil;
	end
	return PowaState.Totem[slot].HaveTotem, PowaState.Totem[slot].Name, PowaState.Totem[slot].StartTime, PowaState.Totem[slot].Duration, PowaState.Totem[slot].Icon;
end

function GetInventorySlotInfo(slot)
	if (not PowaState["InventorySlot"] or not PowaState.InventorySlot[slot]) then
		return nil;
	end
	return PowaState.InventorySlot[slot].Id, PowaState.InventorySlot[slot].EmptyTexture;
end


function GetNumTrackingTypes()
	return PowaState.NumTrackingTypes or 0;
end


function GetTrackingInfo(i)
	if (not PowaState["Tracking"] or not PowaState.Tracking[i]) then
		return nil;
	end
	return PowaState.Tracking[i].Name, PowaState.Tracking[i].Texture, PowaState.Tracking[i].Active, PowaState.Tracking[i].Category;
end

function GetItemInfo(item)
	--local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item);
end

function UnitExists(unit)
	local Player = WoWMock:GetUnit(unit);
	return (Player~=nil);
end

function UnitIsConnected(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.Connected;
	end
	return nil;
end

function UnitIsDead(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.Dead;
	end
	return nil;
end

function UnitIsGhost(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.Ghost;
	end
	return nil;
end

function UnitIsDeadOrGhost(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.DeadOrGhost;
	end
	return nil;
end

function UnitIsVisible(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.Ghost;
	end
	return nil;
end

function UnitIsCorpse(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.Corpse;
	end
	return nil;
end

function UnitIsVisible(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.Visible;
	end
	return nil;
end

function UnitIsPVP(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.PVP;
	end
	return nil;
end

function UnitThreatSituation(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.ThreatSituation;
	end
	return nil;
end

function GetActionInfo(index)
--local type, id, subType, spellID = GetActionInfo(i);
	return nil;
end

function GetPlayerMapPosition(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil and Player.Pos~=nil) then
		return Player.Pos.X, Player.Pos.Y;
	end
	return nil, nil;
end

function UnitIsEnemy(unit, player)
	-- Can only do UnitIsEnemy(unit, "player")
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.Enemy;
	end
	return nil;
end

function UnitCanAttack(unit, player)
	-- Can only do UnitCanAttack(unit, "player")
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.CanAttack;
	end
	return nil;
end

function UnitCanCooperate(player, unit)
	-- Can only do UnitCanCooperate("player", unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.CanCooperate;
	end
	return nil;
end

function UnitIsFriend(unit1, unit2)
	-- Can only do UnitIsFriend(unit, "player") or UnitIsFriend("player", unit)
	local unit = unit1
	if (string.lower(unit1)=="player") then
		unit = unit2;
	end
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return (Player.Friend); 
	end
	return nil;
end

function UnitName(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.Name;
	end
	return nil;
end

function UnitInVehicle(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.InVehicle;
	end
	return nil;
end

function UnitCastingInfo(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil and Player.CastingInfo~=nil) then
		return  Player.CastingInfo.Spell,
				Player.CastingInfo.Rank,
				Player.CastingInfo.DisplayName,
				Player.CastingInfo.Icon,
				Player.CastingInfo.StartTime,
				Player.CastingInfo.EndTime,
				Player.CastingInfo.IsTradeSkill;
	end
	return nil;
end

function UnitChannelInfo(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil and Player.ChannelInfo~=nil) then
		return  Player.ChannelInfo.Spell,
				Player.ChannelInfo.Rank,
				Player.ChannelInfo.DisplayName,
				Player.ChannelInfo.Icon,
				Player.ChannelInfo.StartTime,
				Player.ChannelInfo.EndTime,
				Player.ChannelInfo.IsTradeSkill;
	end
	return nil;
end

function UnitHealth(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.Health;
	end
	return nil;
end

function UnitHealthMax(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.HealthMax;
	end
	return nil;
end

function UnitMana(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.Mana;
	end
	return nil;
end

function UnitManaMax(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.ManaMax;
	end
	return nil;
end

function UnitPower(unit, powerType)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil and Player.Power~=nil) then
		if (powerType~=nil) then
			return Player.Power[powerType];
		end
		return Player.Power.Default;
	end
	return nil;
end

function UnitPowerMax(unit, powerType)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil and Player.PowerMax~=nil) then
		if (powerType~=nil) then
			return Player.PowerMax[powerType];
		end
		return Player.PowerMax.Default;
	end
	return nil;
end

function GetShapeshiftForm(arg1)
	return WoWMock:GetState("ShapeshiftForm", 0);
end

function GetNumShapeshiftForms()
	return WoWMock:GetState("NumShapeshiftForms", 1);
end

function GetShapeshiftFormInfo(arg1)
	if (not PowaState["ShapeshiftFormInfo"] or not PowaState["ShapeshiftFormInfo"][arg1]) then
		return nil;
	end
	return PowaState["ShapeshiftFormInfo"][arg1].Icon, PowaState["ShapeshiftFormInfo"][arg1].Name, PowaState["ShapeshiftFormInfo"][arg1].Active, PowaState["ShapeshiftFormInfo"][arg1].Castable;
end

function UnitAura(unit, index, auraType)
	if (auraType=="HELPFUL") then
		return UnitBuff(unit, index);
	end
	return  UnitDebuff(unit, index);
end

function UnitDebuff(unit, index, removeable)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil and Player.Debuffs~=nil and Player.Debuffs[index]~=nil) then
		local debuff = Player.Debuffs[index];
		if (removeable) then
			debuff = Player.RemoveableDebuffs[index];
		end
		return debuff.Name, debuff.Rank, debuff.Icon, debuff.Applications, debuff.Type, debuff.Duration, debuff.Expires, debuff.Source, debuff.Stealable; 
	end
	return nil;
end

function UnitBuff(unit, index)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil and Player.Buffs~=nil and Player.Buffs[index]~=nil) then
		local buff = Player.Buffs[index];
		return buff.Name, buff.Rank, buff.Icon, buff.Applications, buff.Type, buff.Duration, buff.Expires, buff.Source, buff.Stealable; 
	end
	return nil;
end

function UnitClass(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.LocClass, Player.Class;
	end
	return nil, nil;
end

function UnitSex(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.Sex;
	end
	return nil;
end

function UnitPowerType(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.PowerType, Player.PowerTypeString;
	end
	return nil;
end

function UnitLevel(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.Level;
	end
	return nil;
end

function UnitInParty(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.InParty;
	end
	return nil;
end

function UnitInRaid(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.InRaid;
	end
	return nil;
end
function UnitInRaid(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.InRaid;
	end
	return nil;
end

function UnitHasVehicleUI(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		return Player.UnitHasVehicleUI;
	end
	return nil;
end


function UnitIsUnit(unit1, unit2)
	local Player1 = WoWMock:GetUnit(unit1);
	local Player2 = WoWMock:GetUnit(unit2);
	if (Player1==nil or Player2==nil) then
		return false;
	end
	return (Player1.Name==Player2.Name);
end

function IsRaidLeader()
	return PowaState["RaidLeader"];
end

function IsMounted()
	return PowaState["IsMounted"];
end

function IsInInstance()
	return PowaState["IsInInstance"];
end

function IsFlying()
	return PowaState["IsFlying"];
end

function IsResting()
	return PowaState["IsResting"];
end

function GetWeaponEnchantInfo()
	if (PowaState.WeaponEnchant~=nil) then
		return  PowaState.WeaponEnchant.hasMainHandEnchant,
				PowaState.WeaponEnchant.mainHandExpiration,
				PowaState.WeaponEnchant.mainHandCharges,
				PowaState.WeaponEnchant.hasOffHandEnchant,
				PowaState.WeaponEnchant.offHandExpiration,
				PowaState.WeaponEnchant.offHandCharges;
	else
		return nil;
	end
end

function GetInventoryItemTexture(unit, slot)
	if (string.lower(unit)=="player" and PowaState.Inventory~=nil and PowaState.Inventory.Slot ~=nil and PowaState.Inventory.Slot[i]~=nil) then
		return PowaState.Inventory.Slot[i].Texture;
	end
	return nil;
end

function GetNumPartyMembers()
	if (PowaState["Party"]~=nil) then
		return PowaState.Party.Count or 0;
	end
	return 0;
end

function GetNumRaidMembers()
	if (PowaState["Raid"]~=nil) then
		return PowaState.Raid.Count or 0;
	end
	return 0;
end

function GetPartyLeaderIndex()
	if (PowaState["PartyLeaderIndex"]~=nil) then
		return PowaState["PartyLeaderIndex"];
	end
	return 0;
end

function GetRaidRosterInfo(i)
	local Roster = PowaState.Raid.Roster[i];
	return Roster.Name, Roster.Rank, Roster.Subgroup, Roster.Level, Roster.Classloc, Roster.Class, Roster.Zone, Roster.Online, Roster.IsDead;
end

function GetComboPoints(unit)
	if ((PowaState.ComboPoints~=nil) and (PowaState.ComboPoints[unit]~=nil)) then
		return PowaState.ComboPoints[unit];
	end
	return 0;
end

function SendChatMessage(msg, system, language, target)
	WoWMock:RecordOutput(msg);
end

function IsControlKeyDown()
	return WoWMock.ControlKeyDown;
end

function IsAltKeyDown()
	return WoWMock.AltKeyDown;
end

function gsub(text, match, replace, count)
	return string.gsub(text, match, replace, count);
end

function format(patten, ...)
	return string.format(patten, unpack(arg));
end

function getn(collection)
	return table.getn(collection);
end

function sort(collection)
	return table.sort(collection);
end

function floor(num)
	return math.floor(num);
end

function strlower(text)
	return string.lower(text);
end

--Frames

DEFAULT_CHAT_FRAME = {};

function DEFAULT_CHAT_FRAME:AddMessage(text, n1, n2, n3)
	WoWMock:RecordOutput(text);	
end


cWoWMockFrame = MockClass(function(frame, frameType, frameName, parentFrame, inheritsFrame)
	frame.Type = frameType;
	frame.Name = frameName;
	frame.Parent = parentFrame;
	frame.InheritsFrame = inheritsFrame;
	frame.Width = 100;
	frame.Height = 100;
	frame.Alpha = 1.0;
	frame.x = 0;
	frame.y = 0;
	frame.Anchor = "UNKNOWN";
end);

function cWoWMockFrame:SetFrameStrata(strata)
	self.Strata = strata;
end
function cWoWMockFrame:Hide()
	self.Hidden = true;
end	 
function cWoWMockFrame:Show()
	self.Hidden = false;
end
function cWoWMockFrame:RegisterEvent(event)
end	 
function cWoWMockFrame:SetPoint(anchor, x, y)
	self.Anchor = anchor;
	self.x = x;
	self.y = y;
end
function cWoWMockFrame:GetPoint(n)
	return self.Anchor, nil, self.Anchor, self.x, self.y;
end
function cWoWMockFrame:SetWidth(x)
	self.Width = x;
end
function cWoWMockFrame:SetHeight(x)
	self.Height = x;
end
function cWoWMockFrame:SetAlpha(x)
	self.Alpha = x;
end
function cWoWMockFrame:GetWidth(x)
	return self.Width;
end
function cWoWMockFrame:GetHeight(x)
	return self.Height;
end
function cWoWMockFrame:GetAlpha(x)
	return self.Alpha;
end

function cWoWMockFrame:IsVisible()
	return not self.Hidden;
end

function cWoWMockFrame:CreateFontString(name, layer)
	return CreateFontString(name, layer);
end	 
function cWoWMockFrame:CreateTexture(name, layer)
	return CreateTexture(name, layer);
end	
function cWoWMockFrame:CreateAnimationGroup(name, inheritsFrom)
	return CreateAnimationGroup(name, inheritsFrom);
end	

function CreateFrame(frameType, frameName, parentFrame, inheritsFrame)
	return cWoWMockFrame(frameType, frameName, parentFrame, inheritsFrame);
end

--AnimationGroup
cWoWMockAnimationGroup = MockClass(function(animationGroup, name, inheritsFrom)
	animationGroup.Name = name;
	animationGroup.InheritsFrom = inheritsFrom;
	animationGroup.scripts = {};
end);
function cWoWMockAnimationGroup:SetScript(event, script)
	self.scripts[event] = script;
end	
function cWoWMockAnimationGroup:CreateAnimation(animationType, name)
	return cWoWMockAnimation(animationType, name);
end	
function cWoWMockAnimationGroup:Play()
end

function CreateAnimationGroup(name, inheritsFrom)
	return cWoWMockAnimationGroup(name, inheritsFrom);
end

--Animation
cWoWMockAnimation = MockClass(function(animation, animationType, name)
	animation.Name = name;
	animation.Type = animationType;
	animation.scripts = {};
end);
function cWoWMockAnimation:SetScript(event, script)
	self.scripts[event] = script;
end	
function cWoWMockAnimation:SetOrder(order)
	self.order = order;
end	
function cWoWMockAnimation:SetDuration(duration)
	self.duration = duration;
end	
function cWoWMockAnimation:SetMaxFramerate(fps)
	self.fps = fps;
end
function cWoWMockAnimation:SetScale(xscaleTo, yscaleTo)
	self.xscaleTo = xscaleTo;
	self.yscaleTo = yscaleTo;
end
function cWoWMockAnimation:SetChange(change)
	self.change = change;
end


--Textures
cWoWMockTexture = MockClass(function(texture, textureName, layer, inheritsFrom)
	texture.Name = frameName;
	texture.Layer = layer;
	texture.InheritsFrom = inheritsFrom;
end);
function cWoWMockTexture:SetBlendMode(mode)
	self.BlendMode = mode;
end	
function cWoWMockTexture:SetAllPoints(frame)
end
function cWoWMockTexture:SetTexture(texture)
	self.Texture = texture;
	return 1;
end	
function cWoWMockTexture:GetTexture()
	return self.Texture;
end	

function cWoWMockTexture:GetObjectType()
	return "Texture";
end
function CreateTexture(textureName, layer, inheritsFrom)
	return cWoWMockTexture(textureName, layer, inheritsFrom);
end

function cWoWMockTexture:SetVertexColor()
end

function cWoWMockTexture:SetBlendMode()
end

function cWoWMockTexture:SetShadowColor()
end

function cWoWMockTexture:SetShadowOffset()
end

function cWoWMockTexture:SetTexCoord()
end

-- FontString
cWoWMockFontString = MockClass(function(fontString, name, layer, inheritsFrom)
	fontString.Name = name;
	fontString.Layer = layer;
	fontString.InheritsFrom = inheritsFrom;
end);
function cWoWMockFontString:ClearAllPoints()
end	
function cWoWMockFontString:SetPoint(pos, frame)
end	
function cWoWMockFontString:SetTextColor(r,g,b)
	self.r = r;
	self.g = g;
	self.b = b;
end
function cWoWMockFontString:SetJustifyH(just)
	self.JustifyH = just;
end

function cWoWMockFontString:GetObjectType()
	return "FontString";
end

function CreateFontString(name, layer, inheritsFrom)
	return cWoWMockFontString(name, layer, inheritsFrom);
end


MAX_SKILLLINE_TABS = 8;
NUM_BAG_FRAMES = 4;
MAX_BATTLEFIELD_QUEUES = 3;

function GetSpellTabInfo(i)
	if (PowaState.SpellTabs==nil or PowaState.SpellTabs[i]==nil) then
		return nil, nil, nil, nil;
	end
	return PowaState.SpellTabs[i].Name, PowaState.SpellTabs[i].Texture, PowaState.SpellTabs[i].Offset, PowaState.SpellTabs[i].Count;
end
				
function GetSpellName(i, bookType)
	if (PowaState.SpellBook==nil or PowaState.SpellBook[i]==nil) then
		return nil, nil;
	end
	return PowaState.SpellBook[i].Name, PowaState.SpellBook[i].Rank;
end

function GetSpellTexture(i, bookType)
	if (PowaState.SpellBook==nil or PowaState.SpellBook[i]==nil) then
		return nil;
	end
	return PowaState.SpellBook[i].Texture;
end

function GetSpellCooldown(i, bookType)
	if (PowaState.SpellBook==nil or PowaState.SpellBook[i]==nil or PowaState.SpellBook[i].Cooldown==nil) then
		return 0, 0, 0; 
	end
	return PowaState.SpellBook[i].Cooldown.StartTime, PowaState.SpellBook[i].Cooldown.Duration, PowaState.SpellBook[i].Cooldown.Enabled;
end

function IsUsableSpell(i, bookType)
	if (PowaState.SpellBook==nil or PowaState.SpellBook[i]==nil) then
		return nil; 
	end
	return PowaState.SpellBook[i].UsableSpell;
end

function HasAction(i)
	if (PowaState.ActionSlots==nil or PowaState.ActionSlots[i]==nil) then
		return false;
	end
	return PowaState.ActionSlots[i].HasAction;
end

function IsUsableAction(i)
	if (PowaState.ActionSlots==nil or PowaState.ActionSlots[i]==nil) then
		return false;
	end
	return PowaState.ActionSlots[i].UsableAction;
end

function IsUsableAction(i)
	if (PowaState.ActionSlots==nil or PowaState.ActionSlots[i]==nil) then
		return false;
	end
	return PowaState.ActionSlots[i].UsableAction;
end

function IsActionInRange(i)
	if (PowaState.ActionSlots==nil or PowaState.ActionSlots[i]==nil) then
		return false;
	end
	return PowaState.ActionSlots[i].InRange;
end

function ActionHasRange(i)
	if (PowaState.ActionSlots==nil or PowaState.ActionSlots[i]==nil) then
		return false;
	end
	return PowaState.ActionSlots[i].HasRange;
end

function IsCurrentAction(i)
	if (PowaState.ActionSlots==nil or PowaState.ActionSlots[i]==nil) then
		return false;
	end
	return PowaState.ActionSlots[i].CurrentAction;
end

function IsAutoRepeatAction(i)
	if (PowaState.ActionSlots==nil or PowaState.ActionSlots[i]==nil) then
		return false;
	end
	return PowaState.ActionSlots[i].AutoRepeatAction;
end

function IsAttackAction(i)
	if (PowaState.ActionSlots==nil or PowaState.ActionSlots[i]==nil) then
		return false;
	end
	return PowaState.ActionSlots[i].AttackAction;
end

function GetActionTexture(i)
	if (PowaState.ActionSlots[i]==nil) then
		return nil;
	end
	return PowaState.ActionSlots[i].Texture;
end

function GetActionCount(i)
	if (PowaState.ActionSlots==nil or PowaState.ActionSlots[i]==nil or PowaState.ActionSlots[i].Count==nil) then
		return 0;
	end
	return PowaState.ActionSlots[i].Count;
end

function GetActionCooldown(i)
	if (PowaState.ActionSlots==nil or PowaState.ActionSlots[i]==nil or PowaState.ActionSlots[i].Cooldown==nil) then
		return 0, 0, 0;
	end
	return PowaState.ActionSlots[i].Cooldown.Start, PowaState.ActionSlots[i].Cooldown.Duration, PowaState.ActionSlots[i].Cooldown.Enabled;
end

function GetActionText(i)
	if (PowaState.ActionSlots==nil or PowaState.ActionSlots[i]==nil) then
		return nil;
	end
	return PowaState.ActionSlots[i].ActionText;
end

function GetMacroInfo(i)
	if (PowaState.Macros==nil or PowaState.Macros[i]==nil) then
		return nil, nil, nil;
	end
	return PowaState.Macros[i].Name, PowaState.Macros[i].Texture, WoWMock:Unescape(PowaState.Macros[i].Body);
end

function GetMacroIndexByName(ActionText)
	for key, value in PowaState.Macros do
		if (value.Name==ActionText) then
			return key;
		end
	end
	return nil;
end

function GetContainerNumSlots(bag)
	if (PowaState.Bags[bag]==nil) then
		return nil;
	end
	return tonumber(PowaState.Bags[bag].Slots);
end

function GetContainerItemLink(bag, slot)
	if (PowaState.Bags[bag]==nil or PowaState.Bags[bag][slot]==nil) then
		return nil;
	end
	return PowaState.Bags[bag][slot].Name;
end

function GetContainerItemInfo(bag, slot)
	if (PowaState.Bags[bag]==nil or PowaState.Bags[bag][slot]==nil) then
		return nil, nil;
	end
	return PowaState.Bags[bag][slot].Texture, tonumber(PowaState.Bags[bag][slot].Count);
end

function GetBattlefieldStatus(i)
	if (PowaState.Battlefields[i]==nil) then
		return nil, nil, nil;
	end
	return PowaState.Battlefields[i].Status, PowaState.Battlefields[i].Name, PowaState.Battlefields[i].Id;
end

function CheckInteractDistance(unit, i)
	local Player = WoWMock:GetUnit(unit);
	if (Player==nil) then
		return nil;
	end
	if (Player["InteractDistance"]==nil) then
		return nil;
	end
	return Player.InteractDistance[i];
end

function GetAddOnMetadata(addon, property)
	return "V2.6.2";
end
function CastSpellByName(spell)
	WoWMock:RecordOutput("CastSpellByName>>"..spell);
end

function ClearTarget()
	WoWMock:RecordOutput("ClearTarget");
	WoWMock.LastTarget = WoWMock.Target;
	WoWMock.Target = nil;
end

function TargetUnit(unit)
	WoWMock:RecordOutput("TargetUnit");
	WoWMock.LastTarget = WoWMock.Target;
	WoWMock.Target = unit;
end

function SpellTargetUnit(unit)
	WoWMock:RecordOutput("SpellTargetUnit>>"..unit);
	WoWMock.LastTarget = WoWMock.Target;
	WoWMock.Target = unit;
end

function SpellIsTargeting()
	local Result = false
	--if (WoWMock.Target~=nil) then
	--	Result = (WoWMock:GetUnit(WoWMock.Target)~=nil);
	--end
	WoWMock:RecordOutput("SpellIsTargeting>>"..tostring(Result));
	return Result;
end

function SpellStopTargeting()
	WoWMock:RecordOutput("SpellStopTargeting");
end

function TargetLastTarget()
	WoWMock:RecordOutput("TargetLastTarget");
	WoWMock.Target = WoWMock.LastTarget;
end

function EditMacro()
end

function GetBuildInfo110()
	if (PowaState.BuildInfo~=nil) then
		return PowaState.BuildInfo.Version, PowaState.BuildInfo.BuildNum, PowaState.BuildInfo.BuildDate;
	end
	return nil, nil, nil;
end	

function GetActiveTalentGroup(isInspect,isPet)
	if (PowaState.ActiveTalentGroup==nil) then
		return 1;
	end
	return PowaState.ActiveTalentGroup;
end	

function WoWMock:Unescape(text)
	if (text==nil) then
		return nil;
	end
	return string.gsub(string.gsub(text, "<LF>", "\n"), "<CR>", "\r");
end

--Text
cWoWMockText = MockClass(function(text, position, tooltip)
	text.Position = position;
	text.Tooltip = tooltip
end);
function cWoWMockText:GetText()
	--print("GetText tooltip=", self.Tooltip, "pos=", self.Position);
	return WoWMock:GetTooltip(self.Tooltip, self.Position);
end
function cWoWMockText:SetText()
end
function cWoWMockText:IsShown()
	return self.Tooltip.Shown;
end

--Tooltips
cWoWMockTooltip = MockClass(function(tooltip, name, owner)
	tooltip.Owner = owner;
	tooltip.Shown = false;
	for i = 1, 9 do
		setglobal(name.."TextLeft"..i, cWoWMockText("Left"..i, tooltip));
		setglobal(name.."TextRight"..i, cWoWMockText("Right"..i, tooltip));
	end
end);
function cWoWMockTooltip:NumLines()
	return CurTooltip.NumLines or 0;
end

function cWoWMockTooltip:SetSpell(i, bookType)
	if ( PowaState.SpellBook[i]==nil) then
		CurTooltip = {};
	else
		self.Shown = true;
		CurTooltip = PowaState.SpellBook[i].Tooltip;
	end
end
function cWoWMockTooltip:SetAction(i)
	if ( PowaState.ActionSlots[i]==nil) then
		CurTooltip = {};
	else
		self.Shown = true;
		CurTooltip = PowaState.ActionSlots[i].Tooltip;
	end
end
function cWoWMockTooltip:SetUnit(unit)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil) then
		CurTooltip = Player.Tooltip;
		self.Shown = true;
		return;
	end
	CurTooltip = {};
end
function cWoWMockTooltip:SetUnitDebuff(unit, i)
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil and Player.Debuffs~=nil and Player.Debuffs[i]~=nil) then
		CurTooltip = Player.Debuffs[i].Tooltip;
		self.Shown = true;
		return;
	end
	CurTooltip = {};
end
function cWoWMockTooltip:SetUnitBuff(unit, i)
	--print("SetUnitBuff",unit, i);
	local Player = WoWMock:GetUnit(unit);
	if (Player~=nil and Player.Buffs~=nil and Player.Buffs[i]~=nil) then
		CurTooltip = Player.Buffs[i].Tooltip;
		--WoWMock:PrintTable(CurTooltip);
		self.Shown = true;
		return;
	end
	CurTooltip = {};
end

function cWoWMockTooltip:SetUnitAura(unit, index, filter)
	--print("SetUnitAura",unit, index, filter);
	if (filter=="HELPFUL") then
		self:SetUnitBuff(unit, index);
	else
		self:SetUnitDebuff(unit, index);
	end
end

function cWoWMockTooltip:SetInventoryItem(unit, i)
	--print("SetUnitBuff",unit, i);
	if (string.lower(unit)=="player" and PowaState.Inventory~=nil and PowaState.Inventory.Slot ~=nil and PowaState.Inventory.Slot[i]~=nil) then
		CurTooltip = PowaState.Inventory.Slot[i].Tooltip;
		--WoWMock:PrintTable(CurTooltip);
		self.Shown = true;
		return;
	end
	CurTooltip = {};
end
function cWoWMockTooltip:SetOwner(owner, anchor)
	--print("SetOwner",owner, anchor);
	self.Owner = owner;
	self.Anchor = anchor;
end
function cWoWMockTooltip:Hide()
	self.Shown = false;
end
function cWoWMockTooltip:Show()
	self.Shown = true;
end
function cWoWMockTooltip:IsShown()
	return self.Shown;
end

function WoWMock:GetTooltip(tooltip, pos)
	--print("GetTooltip",tooltip, pos, tooltip.Owner);
	if (CurTooltip==nil or tooltip.Owner==nil) then
		return nil;
	end
	return WoWMock:Unescape(CurTooltip[pos]);
end


GameTooltip = cWoWMockTooltip("GameTooltip");

SlashCmdList = {};
StaticPopupDialogs = {};