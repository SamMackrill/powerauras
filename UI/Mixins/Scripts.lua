-- Create definition.
PowaAuras.UI:Register("Scripts", {
	Construct = function(class, _, frame)
		-- Prevent multiple instantiations clearing handlers list.
		if(frame.__ScriptHandlers) then return; end
		-- Store custom scripts in this.
		frame.__ScriptHandlers = {};
		-- Hook these functions.
		frame.__GetScript = frame.GetScript;
		frame.__HookScript = frame.HookScript;
		frame.__SetScript = frame.SetScript;
		-- Replace.
		frame.GetScript = class.GetScript;
		frame.HookScript = class.HookScript;
		frame.SetScript = class.SetScript;
		-- Add a CallScript function.
		frame.CallScript = class.CallScript;
	end,
	CallScript = function(self, script, ...)
		-- Do we not own this script?
		if(not self.__ScriptHandlers[script]) then return false; end
		-- We do, call the functions.
		for key, func in pairs(self.__ScriptHandlers[script]) do
			func(self, ...);
		end
	end,
	GetScript = function(self, script)
		-- Can the frame handle it?
		if(self:HasScript(script)) then
			-- Yes.
			return self:__GetScript(script, func);
		elseif(self.__ScriptHandlers[script]) then
			return self.__ScriptHandlers[script][1];
		else
			return nil;
		end		
	end,
	HookScript = function(self, script, func)
		-- Can the frame handle it?
		if(self:HasScript(script)) then
			-- Yes.
			return self:__HookScript(script, func);
		else
			-- Hook it ourselves.
			if(not self.__ScriptHandlers[script]) then
				self.__ScriptHandlers[script] = {};
			end
			tinsert(self.__ScriptHandlers[script], 2, func);
			return true;
		end
	end,
	SetScript = function(self, script, func)
		-- Can the frame handle it?
		if(self:HasScript(script)) then
			-- Yes.
			return self:__SetScript(script, func);
		else
			-- Register it ourselves.
			if(not self.__ScriptHandlers[script]) then
				self.__ScriptHandlers[script] = {};
			end
			self.__ScriptHandlers[script][1] = func or function() return; end;
			return true;
		end
	end,
});
