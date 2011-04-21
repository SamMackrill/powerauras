-- Each widget has its own init function, and a shared pool of closures available to all widgets.
-- You can initialize a widget by calling PowaAuras.UI.[widget]().
-- Each definition should be placed it its own lua file.
PowaAuras.UI = {
	-- Turns the definition tables into metatables with constructor-like functionality.
	Register = function(self, name, data)
		-- Simple check...
		if(self[name]) then return PowaAuras:ShowText("Widget type with name ", name, " already exists."); end
		-- Add a metatable to the widget definition.
		setmetatable(data, {
			__call = function(self, _, widget, ...)
				-- Run pre-init function, it can directly modify the widget too.
				widget = (self.PreInit and self:PreInit(widget) or widget);
				-- Has a parent class?
				if(self.Base) then
					self.Base(_, widget, ...);
				end
				-- Handle hooks.
				if(self.Hooks) then
					for _, hook in ipairs(self.Hooks) do
						widget["__" .. hook] = widget[hook];
					end
				end
				-- Copy anything we have over automatically...
				for k,v in pairs(self) do
					-- Ignore _ prefixed elements, same with preinit/hooks/scripts. Normal init is fine.
					if(strsub(k, 1, 1) ~= "_" and k ~= "PreInit" and k ~= "Hooks" and k ~= "Scripts") then
						widget[k] = v;
					end
				end
				-- Script handlers.
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
			end,
		});
		-- Don't fix the base element parent class, as it has no damn parent class!
		if(name ~= "Base") then
			-- Does the data reference a parent class?
			if(not data.Base) then
				-- Well it should always inherit the base class.
				data.Base = "Base";
			end
			-- Turn the base class name into a direct reference.
			if(not self[data.Base]) then
				-- Error!
				return PowaAuras:ShowText("No class named ", data.Base, " could be inherited for class ", name, ".");
			else
				data.Base = self[data.Base];
			end
			-- Copy the scripts from the parent class too, otherwise they won't be set properly.
			-- Don't do hooks as it could get messy really easily.
			if(data.Base.Scripts) then
				-- Need the table dummy!
				if(not data.Scripts) then
					data.Scripts = {};
				end
				-- Copy.
				for _,v in ipairs(data.Base.Scripts) do
					if(not tContains(data.Scripts, v)) then
						tinsert(data.Scripts, v);
					end
				end
			end
		end
		-- Store widget table.
		self[name] = data;
	end,
};

PowaAuras.UI:Register("Base", {
	Init = function(self)
		-- Set the parent key if we can..
		if(not self or not self.GetParent or not self:GetParent()) then return; end
		self.Parent = self:GetParent();
	end,
});

-- General functions.
-- Todo: Rewrite this one a bit.
function PowaAuras:SaveSetting(property, value, auraId)
	local self = PowaAuras;
	auraId = auraId or self.CurrentAuraId;
	if(not auraId or not self.Auras[auraId]) then print("No aura ID!"); return; end
	-- We don't save settings yet, this is just for debugging purposes.
	-- self.Auras[auraId][property] = value;
	-- self:RedisplayAura(auraId);
	print("Saved: ", property, value, auraId);
end