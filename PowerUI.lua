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
					widget = (self.PreInit and self:PreInit(widget) or widget);
					-- Check for hooks. All this does is set widget[v] to widget[k] (so imagine: { Show = "__Show" })
					-- This allows you to then specify your own Show function without destroying the initial one.
					if(self.Hooks) then
						for k,v in pairs(self.Hooks) do
							widget[v] = widget[k];
						end
					end
					--[[
						Ignore this bit. I was seeing what used less memory, making the frame a metatable or just copying keys and referencing
						functions. It's the latter by about ~20kb.
					--]]
					-- -- -- Blizzard's frames have a metatable already defined.
					-- -- local meta = getmetatable(widget);
					-- -- setmetatable(widget, {
						-- -- __index = function(t,k)
							-- -- if(self[k]) then
								-- -- return self[k];
							-- -- elseif(meta["__index"]) then
								-- -- if(type(meta["__index"]) == "function") then
									-- -- return meta["__index"](t, k);
								-- -- else
									-- -- return meta["__index"][k];
								-- -- end
							-- -- end
						-- -- end
					-- -- });
					-- Copy anything we have over automatically...
					for k,v in pairs(self) do
						-- Ignore _ prefixed elements, same with preinit/hooks/scripts. Normal init is fine.
						if(strsub(k, 1, 1) ~= "_" and key ~= "PreInit" and key ~= "Hooks" and key ~= "Scripts") then
							widget[k] = v;
						end
					end
					-- Easyscript™!
					-- Automatically registers scripts, requires you to supply a function in the widget definition
					-- which matches the script name (eg. OnEnter).
					if(self.Scripts and widget.SetScript) then
						for _,v in ipairs(self.Scripts) do
							widget:SetScript(v, widget[v]);
						end
					end
					-- Run widget ctor.
					if(widget.Init) then
						widget:Init(...);
					end
					-- Done.
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
	if(not auraId or not self.Auras[auraId]) then print("No aura ID!"); return; end
	-- We don't save settings yet, this is just for debugging purposes.
	-- self.Auras[auraId][property] = value;
	-- self:RedisplayAura(auraId);
	print("Saved: ", property, value, auraId);
end