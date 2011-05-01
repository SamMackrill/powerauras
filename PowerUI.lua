-- Each widget has its own init function, and a shared pool of closures available to all widgets.
-- You can initialize a widget by calling PowaAuras.UI.[widget]().
-- Each definition should be placed it its own lua file.
PowaAuras.UI = {
	-- Turns the definition tables into metatables with constructor-like functionality.
	Register = function(self, name, data)
		-- Simple check...
		if(self[name]) then return PowaAuras:ShowText("Widget type with name ", name, " already exists."); end
		-- -- -- Add a metatable to the widget definition.
		-- -- setmetatable(data, {
			-- -- __call = function(self, _, widget, ...)
				-- -- -- Run pre-init function, it can directly modify or even remove the widget too.
				-- -- widget = (self.PreInit and self:PreInit(widget, ...) or widget);
				-- -- -- You need a widget to continue.
				-- -- if(not widget) then return; end
				-- -- -- Has a parent class?
				-- -- if(self.Base) then
					-- -- self.Base(_, widget, ...);
				-- -- end
				-- -- -- Handle hooks.
				-- -- if(self.Hooks) then
					-- -- for _, hook in ipairs(self.Hooks) do
						-- -- widget["__" .. hook] = widget[hook];
					-- -- end
				-- -- end
				-- -- -- Copy anything we have over automatically...
				-- -- for k,v in pairs(self) do
					-- -- -- Ignore _ prefixed elements, same with preinit/hooks/scripts. Normal init is fine.
					-- -- if(strsub(k, 1, 1) ~= "_" and k ~= "PreInit" and k ~= "Hooks" and k ~= "Scripts") then
						-- -- widget[k] = v;
					-- -- end
				-- -- end
				-- -- -- Script handlers.
				-- -- if(self.Scripts and widget.SetScript) then
					-- -- for _,v in ipairs(self.Scripts) do
						-- -- widget:SetScript(v, widget[v]);
					-- -- end
				-- -- end
				-- -- -- Run widget ctor.
				-- -- if(widget.Init) then
					-- -- widget:Init(...);
				-- -- end
				-- -- -- Done.
				-- -- return widget;
			-- -- end,
		-- -- });
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
		-- Add a metatable to the widget definition.
		setmetatable(data, {
			__call = function(self, _, widget, ...)
				-- Run constructor function. Only run it on the topmost widget.
				widget = (self.Construct and self:Construct(widget, ...) or widget);
				-- Allow nil returns.
				if(not widget) then return; end
				-- Handle hooks.
				if(self.Hooks) then
					for _, hook in ipairs(self.Hooks) do
						widget["__" .. hook] = widget[hook];
					end
				end
				-- Make a table of classes to inherit.
				local classes = { self };
				-- Has a parent class?
				if(self.Base) then
					local base = self.Base;
					repeat
						-- Insert.
						tinsert(classes, base);
						-- Next element.
						base = (base.Base or nil);
					until(not base)
				end
				-- -- Go over them backwards.
				for i=#(classes), 1, -1 do
					-- -- Copy anything we have over automatically...
					for k,v in pairs(classes[i]) do
						-- Ignore _ prefixed elements, same with construct/hooks/scripts. Normal init is fine.
						if(strsub(k, 1, 1) ~= "_" and k ~= "Construct" and k ~= "Hooks" and k ~= "Scripts") then
							widget[k] = v;
						end
					end
				end
				if(self.Base) then
					-- Store base element.
					widget.Base = self.Base;
				end
				-- Script handlers.
				if(self.Scripts and widget.SetScript) then
					for _,v in ipairs(self.Scripts) do
						widget:SetScript(v, widget[v]);
					end
				end
				-- Set parent field.
				if(widget.GetParent and not widget.Parent) then
					widget.Parent = widget:GetParent();
				end
				-- Run widget ctor.
				if(widget.Init) then
					widget:Init(...);
				end
				-- Done.
				return widget;
			end,
		});
		-- Store widget table.
		self[name] = data;
	end,
};

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

-- Todo: Replace widget ctor code with following:
--[[
]]--