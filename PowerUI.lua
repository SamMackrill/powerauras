-- a3528830@jnxjn.com
-- (Ignore that, just a disposable email I used for a battle.net account for a wow trial)

-- Each widget has its own init function, and a shared pool of closures available to all widgets.
-- You can initialize a widget by calling PowaAuras.UI.[widget]().
-- Each definition should be placed it its own lua file.
PowaAuras.UI = {	
	-- Turns the definition tables into metatables with constructor-like functionality.
	DefineWidget = function(self, widget)
		if(not self[widget]) then PowaAuras:ShowText("No widget definition exists for: ", widget); return; end
		self[widget] = setmetatable(self[widget], { 
				-- Constructor.
				__call = function(self, widget, ...)
					-- Run pre-init function, it can directly modify the widget too.
					widget = (self.PreInit and self:PreInit() or widget);
					-- Check for hooks. All this does is set widget[v] to widget[k] (so imagine: { Show = "__Show" })
					-- This allows you to then specify your own Show function without destroying the initial one.
					if(self.Hooks) then
						for k,v in pairs(self.Hooks) do
							widget[v] = widget[k];
						end
					end
					-- Copy anything we have over automatically...
					for k,v in pairs(self) do
						if(strsub(k, 1, 1) ~= "_") then widget[k] = v; end
					end
					-- Run passed ctor.
					widget:Init(...);
					return widget;
				end
			}
		);
		return true;
	end,
	AdvancedElements = {},
}

-- General functions.
function PowaAuras:SaveSetting(property, value, auraId)
	local self = PowaAuras;
	auraId = auraId or self.CurrentAuraId;
	if(not auraId or not self.Auras[auraId]) then print("No aura ID"); return; end
	-- We don't save settings yet, this is just for debugging purposes.
	-- self.Auras[auraId][property] = value;
	-- self:RedisplayAura(auraId);
	print("Saved: ", property, value, auraId);
end