--- Contains functions for registering UI widgets and initialising them to work with frames.

PowaAuras.UI = {};
--- Builds a frame from a table based definition. This allows you to bypass using XML for frame creation while also
-- handling all of the boring SetPoint/SetSize calls that are otherwise present.
-- @param def The definition to load.
-- @param parent The parent frame of the frame.
function PowaAuras.UI:BuildFrameFromDefinition(def, parent)
	-- Fix type.
	if(not def.Type) then
		def.Type = "Frame";
	end
	-- Frame or something else?
	local frame;
	if(def.Type == "FontString" or def.Type == "Texture") then
		-- Make layered object.
		frame = parent["Create" .. def.Type](parent, def.Name, def.Layer, def.Inherits, def.SubLevel);
	elseif(def.Type ~= "Class") then
		-- Make frame if not Class type. Class type means instantiate the class without a frame.
		frame = CreateFrame(def.Type or "Frame", def.Name, parent, def.Inherits);
	end
	-- Classes.
	if(type(def.Class) == "string" and self[def.Class]) then
		if(def.Type == "Class") then
			if(def.ClassArgs and type(def.ClassArgs) == "table") then
				frame = self[def.Class](self, parent, unpack(def.ClassArgs));
			else
				frame = self[def.Class](self, parent, (def.ClassArgs and tostring(def.ClassArgs) or nil));
			end
		else
			-- Need to handle unpack like this.
			if(def.ClassArgs and type(def.ClassArgs) == "table") then
				self[def.Class](self, frame, unpack(def.ClassArgs));
			else
				self[def.Class](self, frame, (def.ClassArgs and tostring(def.ClassArgs) or nil));
			end
		end
	elseif(type(def.Class) == "table") then
		for _, class in ipairs(def.Class) do
			if(def.ClassArgs and type(def.ClassArgs) == "table") then
				self[class](self, frame, unpack(def.ClassArgs));
			else
				self[class](self, frame, (def.ClassArgs and tostring(def.ClassArgs) or nil));
			end
		end
	end
	-- Additional values.
	if(def.Values) then
		for key, data in pairs(def.Values) do
			frame[key] = data;
		end
	end
	-- Size...
	if(def.Size) then
		frame:SetSize(unpack(def.Size));
	end
	-- Position.
	if(def.Points) then
		-- Convert the relative anchor into something useful.
		if(def.RelativeAnchor) then
			def.RelativeAnchor = ((type(def.RelativeAnchor) == "table" and def.RelativeAnchor) 
				or (def.RelativeAnchor == true and parent) or parent[def.RelativeAnchor] or _G[def.RelativeAnchor] 
				or nil);
		end
		-- Boolean true = SetAllPoints.
		if(type(def.Points) == "boolean" and def.Points == true) then
			frame:SetAllPoints(def.RelativeAnchor or parent);
		elseif(type(def.Points) == "table") then
			for _, point in ipairs(def.Points) do
				if(not def.RelativeAnchor) then
					frame:SetPoint(unpack(point));
				else
					frame:SetPoint(point[1], def.RelativeAnchor, unpack(point, 2));
				end
			end
		end
	end
	-- Children.
	if(def.Children) then
		for key, child in pairs(def.Children) do
			frame[child.ParentKey or key] = self:BuildFrameFromDefinition(child, frame);
		end
	end
	-- OnLoad func.
	if(def.OnLoad) then
		-- Allow a string function name.
		if(type(def.OnLoad) == "string") then
			frame[def.OnLoad](frame);
		else
			def.OnLoad(frame);
		end
	end
	-- Done.
	return frame;
end
--- Generic constructor function for all UI widgets. Performs the mundane functions of copying the Hooks and values
-- from the class definitions, registering scripts and initialising the widget.
-- @param ui The PowaAuras.UI table.
-- @param widget The frame to be constructed with a class.
-- @param ... Arguments to be passed to the Init function of the class, if it exists.
function PowaAuras.UI:Construct(ui, widget, ...)
	-- Allow nil returns.
	if(not widget) then return; end
	-- Handle hooks.
	if(self.Hooks) then
		for _, hook in ipairs(self.Hooks) do
			widget["__" .. hook] = widget[hook];
		end
	end
	-- Copy anything we have over automatically, don't use metatables because they increase the memory usage a lot.
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
end
--- Turns a widget definition table into metatables with constructor-like functionality.
-- @param name The name of the widget class to define.
-- @param data The table of data to use when defining the class.
-- @param isAnonymous Defaults to false, if set to true then the name of the class is not checked and it will not be
-- registered with the UI table.
function PowaAuras.UI:Register(name, data, isAnonymous)
	-- Simple check...
	if(not isAnonymous and self[name]) then
		return PowaAuras:GlobalDebug("Widget type with name ", name, " already exists.");
	end
	-- Does the data reference a parent class?
	if(data.Base) then
		-- Turn the base class name into a direct reference.
		if(not self[data.Base]) then
			-- Error!
			return PowaAuras:Message("No class named ", data.Base, " could be inherited for class ", name, ".");
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
			if(data[k] == nil and k ~= "Base" and k ~= "Hooks" and k ~= "Scripts") then
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
	if(not isAnonymous) then
		self[name] = data;
	end
	-- Done.
	return data;
end
--- Initialises a frame with an anonymous widget class, which extends a class on the fly to create a class tailored to
-- specific needs at runtime. The class is then immediately constructed afterwards.
-- @param class The name of the class to extend.
-- @param data The data table of the class to merge in.
-- @param ... Any arguments to pass to the constructor and init functions.
function PowaAuras.UI:AnonymousWidget(class, data, ...)
	-- Extend base.
	if(not data.Base) then
		data.Base = class;
	end
	-- Make class, construct, done.
	local class = self:Register(nil, data, true);
	class(self, ...);
end

-- Accepted definition keys:
-- 
-- Type (string): Represents the type of frame to create via the CreateFrame call, defaults to "Frame" if not given.
-- "FontString" and "Texture" are handled specially, along with "Class" which will not create a frame and instead relies
-- on the Class definition key to create a frame.
--
-- Inherits (string): Used to determine what frame template to inherit. Only valid if Type is not "Class".
--
-- Name (string): Global frame name, only valid if Type is not "Class".
--
-- Class (string, table): Specifies the main UI Widget class to inherit for the frame. If Type is set to "Class" then 
-- this key must be present as a string, and the class you are inheriting must return a frame via the constructor.
-- Accepts a table of classes to inherit.
--
-- ClassArgs (string, table): Passes these values as additional arguments to all Class initialiser functions.
--
-- Size (table): The size of the frame in width, height format.
--
-- Points (boolean, table[]): The points to set to the frame. If the value is a boolean representing "true", then 
-- SetAllPoints is called, otherwise each element in the table is unpacked and passed to a SetPoint call in turn.
--
-- RelativeAnchor (string): Allows you to set the relative anchor for all your points to another frame in the current
-- parent by naming its key.
--
-- Children (table[]): Table of child frame definitions, following this same format. Keys can either be numeric to 
-- assure ordered creation of frames, or string values which will represent the ParentKey attribute for this frame.
--
-- ParentKey (string): Defines the key to assign this frame to in the parent. Can be implied implicitly.
--
-- OnLoad (function): Optional function to be called after the frame has been created.
