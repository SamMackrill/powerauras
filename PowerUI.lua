-- Each widget has its own init function, and a shared pool of closures available to all widgets.
-- You can initialize a widget by calling PowaAuras.UI:[widget]().
-- Each definition should be placed in its own lua file.
PowaAuras.UI = {
	-- Generic constructor for all elements.
	Construct = function(self, _, widget, ...)
		-- Allow nil returns.
		if(not widget) then return; end
		-- Handle hooks.
		if(self.Hooks) then
			for _, hook in ipairs(self.Hooks) do
				widget["__" .. hook] = widget[hook];
			end
		end
		-- Copy anything we have over automatically...
		for k,v in pairs(self) do
			-- Ignore these elements, they're reserved.
			if(k ~= "Base" and k ~= "Construct" and k ~= "Hooks" and k ~= "Scripts") then
				widget[k] = v;
			end
		end
		-- Script handlers.
		if(self.Scripts and widget.SetScript) then
			for script, func in pairs(self.Scripts) do
				-- Does this frame support the script?
				if(not widget.CallScript and not widget:HasScript(script)) then
					-- Use the scripts mixin.
					PowaAuras.UI:Scripts(widget);
				end
				-- Register script.
				widget:SetScript(script, (type(func) == "boolean" and widget[script] or widget[func]));
			end
		end
		-- Run widget ctor.
		if(widget.Init) then
			widget:Init(...);
		end
		-- Done.
		return widget;
	end,
	-- Turns the definition tables into metatables with constructor-like functionality.
	Register = function(self, name, data)
		-- Simple check...
		if(self[name]) then return PowaAuras:ShowText("Widget type with name ", name, " already exists."); end
		-- Does the data reference a parent class?
		if(data.Base) then
			-- Turn the base class name into a direct reference.
			if(not self[data.Base]) then
				-- Error!
				return PowaAuras:ShowText("No class named ", data.Base, " could be inherited for class ", name, ".");
			else
				data.Base = self[data.Base];
			end
			-- Copy the scripts from the parent class too, otherwise they won't be set properly.
			if(data.Base.Scripts) then
				-- Need the table dummy!
				if(not data.Scripts) then
					data.Scripts = {};
				end
				-- Copy.
				for script, func in pairs(data.Base.Scripts) do
					if(not data.Scripts[script]) then
						data.Scripts[script] = func;
					end
				end
			end
			-- Hooks too.
			if(data.Base.Hooks) then
				-- Need the table dummy!
				if(not data.Hooks) then
					data.Hooks = {};
				end
				-- Copy.
				for _,v in ipairs(data.Base.Hooks) do
					if(not tContains(data.Hooks, v)) then
						tinsert(data.Hooks, v);
					end
				end
			end
			-- Copy non-important things from parent too.
			for k, v in pairs(data.Base) do
				-- Ignore these elements, they're reserved.
				if(not data[k] and k ~= "Base" and k ~= "Hooks" and k ~= "Scripts") then
					data[k] = v;
				end
			end
			-- And now remove data.Base.
			data.Base = nil;
		end
		-- Add constructor.
		if(not data.Construct) then
			data.Construct = self.Construct;
		end
		-- Add a metatable to the widget definition.
		setmetatable(data, { __call = data.Construct });
		-- Store widget table.
		self[name] = data;
	end,
};

-- General functions.
-- Todo: Rewrite this one a bit.
function PowaAuras:SaveSetting(...)
	print("|cFF527FCCDEBUG (PowerUI): |rDeprecated function call: PowaAuras:SaveSetting(", ..., ")");
	-- -- local self = PowaAuras;
	-- -- auraId = auraId or self.CurrentAuraId;
	-- -- if(not auraId or not self.Auras[auraId]) then print("No aura ID!"); return; end
	-- -- -- We don't save settings yet, this is just for debugging purposes.
	-- -- -- self.Auras[auraId][property] = value;
	-- -- -- self:RedisplayAura(auraId);
	-- -- print("Saved: ", property, value, auraId);
end