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
					-- Widget doesn't need to be a table.
					if(type(widget) == "table") then
						-- Check for hooks. All this does is set widget[v] to widget[k] (so imagine: { Show = "__Show" })
						-- This allows you to then specify your own Show function without destroying the initial one.
						if(self.Hooks) then
							for k,v in pairs(self.Hooks) do
								widget[v] = widget[k];
							end
						end
						-- Copy anything we have over automatically...
						for k,v in pairs(self) do
							if(k ~= "Init") then widget[k] = v; end
						end
					end
					-- Run passed ctor.
					return self.Init(widget, ...);
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

-- Most of this was just a test. Ignore 90% of it.

-- -- -- We reuse widgets to cut down on used memory/frames.
-- -- PowaAuras.UIWidgets = {};
-- -- PowaAuras.UIWidgetCount = 0;

-- -- -- Doesn't support constructors like PowaClass, uses a custom __call function for widget creation.
-- -- function PowaAuras:UIWidgetClass(base, widget)
	-- -- local w, mt = {}, {};
	-- -- if(base and type(base) == "table") then
		-- -- for i,v in pairs(base) do
			-- -- w[i] = v;
		-- -- end
	-- -- end
	-- -- if(widget and type(widget) == "table") then
		-- -- for i,v in pairs(widget) do
			-- -- w[i] = v;
		-- -- end
	-- -- end
	-- -- -- Custom constructor function for widget reuse.
	-- -- mt.__call = function(_, ...)
		-- -- -- Try reusing any hidden widgets.
		-- -- local frame;
		-- -- if(not self.UIWidgets[w.Type]) then self.UIWidgets[w.Type] = {}; end
		-- -- if(self.UIWidgets[w.Type][1]) then
			-- -- -- Reuse existing.
			-- -- frame = self.UIWidgets[w.Type][1];
			-- -- tremove(self.UIWidgets[w.Type], 1);
			-- -- frame:Init(true, ...);
		-- -- else
			-- -- -- Make a new widget.
			-- -- self.UIWidgetCount = self.UIWidgetCount + 1;
			-- -- frame = w:Construct(("PowaUI" .. (w.Type or "Widget") .. self.UIWidgetCount));
			-- -- -- Shallow copy of all methods and fields on the widget table.
			-- -- for i,v in pairs(w) do
				-- -- frame[i] = v;
			-- -- end
			-- -- frame:Init(false, ...);
		-- -- end
		-- -- -- Done.
		-- -- return frame;
	-- -- end
	-- -- setmetatable(w, mt);
	-- -- return w;
-- -- end

-- -- cPowaUIWidget = PowaAuras:UIWidgetClass({ __PowaUIWidget = true, Type = "Widget" });

-- -- -- Constructor. This constructs the frame used for the widget. Only called once, must return the created frame.
-- -- -- Do not reference self in here, use the frame object instead.
-- -- function cPowaUIWidget:Construct(name)
	-- -- -- Create the frame.
	-- -- local self = CreateFrame("Frame", name, UIParent);
	-- -- -- Set up some storage variables.
	-- -- self.Name = name;
	-- -- -- Hook some functions.
	-- -- self.__Hide = self.Hide;
	-- -- return self;
-- -- end

-- -- -- Init function. Called whenever the widget is constructed or reused. First param is true if the widget is being reused.
-- -- function cPowaUIWidget:Init(isRecycled, parent, width, height, point, relative, offsetx, offsety)
	-- -- -- Reset positioning/sizing.
	-- -- self:SetParent((parent or UIParent));
	-- -- self:SetPoint((point or "CENTER"), (parent or UIParent), (relative or "CENTER"), (offsetx or 0), (offsety or 0));
	-- -- self:SetWidth((width or 0));
	-- -- self:SetHeight((height or 0));
	-- -- self:Show();	
	
	-- -- print("Initialized widget: (" .. self.Type .. ", " .. self.Name .. ", " .. (isRecycled and "true" or "false") .. ")");
-- -- end

-- -- -- Recycle function. Makes sure the frame allows itself to be reused. Don't call this directly, use Hide();
-- -- function cPowaUIWidget:Recycle()
	-- -- if(self:IsShown() or self:IsVisible()) then
		-- -- -- Recycle is set as the onhide handler, but the frame is still shown. Hide it first.
		-- -- self:Hide();
	-- -- else
		-- -- -- Allow reuse.
		-- -- self:Reset();
		-- -- tinsert(PowaAuras.UIWidgets[self.Type], self);
		-- -- print("Recycled widget: (" .. self.Type .. ", " .. self.Name .. ")");
		-- -- -- Go over our child frames.
		-- -- local children = { self:GetChildren() };
		-- -- for _, child in ipairs(children) do
			-- -- -- Hide them!
			-- -- if(child.__PowaUIWidget) then child:Hide(); end
		-- -- end
	-- -- end
-- -- end

-- -- -- Reset function. Override this if you need to remove additional things like hooks.
-- -- function cPowaUIWidget:Reset()
	-- -- -- Clear any anchors, reset parent to something else. Failing to do so may result in many errors and oddities.
	-- -- self:ClearAllPoints();
	-- -- self:SetParent(UIParent);
-- -- end

-- -- function cPowaUIWidget:Hide(...)
	-- -- -- Call normal hide (we do this hook because OnHide doesn't fire if you hide a hidden frame).
	-- -- self:__Hide(...);
	-- -- -- Recycle frame.
	-- -- self:Recycle();
-- -- end

-- -- -- Attempts to layout all children in a grid. Needs fine-tuning.
-- -- function cPowaUIWidget:LayoutChildren(columns)
	-- -- -- Go over our child frames.
	-- -- local children, i, row, yoffset, nextyoffset, w, c = { self:GetChildren() }, 1, 1, 5, 0, (self:GetWidth()/columns)-10, columns;
	-- -- for _, child in ipairs(children) do
		-- -- if(child.__PowaUIWidget) then
			-- -- -- Have we changed row?
			-- -- if(math.floor(i/c) > row) then
				-- -- row = math.floor(i/c)+1;
				-- -- yoffset = yoffset+nextyoffset+5;
				-- -- nextyoffset = 0;
			-- -- end
			-- -- -- Calculate height of element. If it's larger than our next offset, change it.
			-- -- nextyoffset = (nextyoffset > child:GetHeight() and nextyoffset or child:GetHeight());
			-- -- -- Position element.
			-- -- child:ClearAllPoints();
			-- -- child:SetPoint("TOPLEFT", self, "TOPLEFT", 5+((i-1)*(w+5))-(floor((i-1)/c)*(c*(w+5))), -yoffset);
			-- -- -- Update element width if needed!
			-- -- if(child:GetWidth() > w) then
				-- -- child:SetWidth(w);
			-- -- end
			-- -- -- Next!
			-- -- i = i+1;
		-- -- end
	-- -- end
-- -- end

-- -- cPowaUIFrame = PowaAuras:UIWidgetClass(cPowaUIWidget, { Type = "Frame" });

-- -- function cPowaUIFrame:Construct(name)
	-- -- -- Create the frame.
	-- -- local self = CreateFrame("Frame", name, UIParent, "BasicFrameTemplate");
	-- -- -- Set up some storage variables.
	-- -- self.Name = name;
	-- -- -- Hook some functions.
	-- -- self.__Hide = self.Hide;
	-- -- return self;
-- -- end

-- -- function cPowaUIFrame:Init(isRecycled, parent, width, height, point, relative, offsetx, offsety)
	-- -- -- Reset positioning/sizing.
	-- -- self:SetParent((parent or UIParent));
	-- -- self:SetPoint((point or "CENTER"), (parent or UIParent), (relative or "CENTER"), (offsetx or 0), (offsety or 0));
	-- -- self:SetWidth((width or 0));
	-- -- self:SetHeight((height or 0));
	-- -- self:Show();
	-- -- -- Add child elements (they'll be created or recycled automatically)
	-- -- self.Children = {
		-- -- [1] = cPowaUIChildFrame(self, 200, 100),
		-- -- [2] = cPowaUIChildFrame(self, 200, 100),
		-- -- [3] = cPowaUIChildFrame(self, 200, 100),
		-- -- [4] = cPowaUIChildFrame(self, 200, 100),
		-- -- [5] = cPowaUIChildFrame(self, 200, 100),
		-- -- [6] = cPowaUIChildFrame(self, 200, 100),
		-- -- [7] = cPowaUIChildFrame(self, 200, 100),
		-- -- [8] = cPowaUIChildFrame(self, 200, 100),
		-- -- [9] = cPowaUIChildFrame(self, 200, 100),
		-- -- [10] = cPowaUIChildFrame(self, 200, 100),
		-- -- [11] = cPowaUIChildFrame(self, 200, 100),
		-- -- [12] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [13] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [14] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [15] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [16] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [17] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [18] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [19] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [20] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [21] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [22] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [23] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [24] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [25] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [26] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [27] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [28] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [29] = cPowaUIChildFrame(self, 200, 100),
		-- -- -- -- [30] = cPowaUIChildFrame(self, 200, 100),
	-- -- };
	-- -- self:LayoutChildren(3);
	-- -- -- Show frame.
	-- -- self:Show();
	
	-- -- print("Initialized widget: (" .. self.Type .. ", " .. self.Name .. ", " .. (isRecycled and "true" or "false") .. ")");
-- -- end

-- -- cPowaUIChildFrame = PowaAuras:UIWidgetClass(cPowaUIFrame, { Type = "ChildFrame" });

-- -- function cPowaUIChildFrame:Construct(name)
	-- -- -- Create the frame.
	-- -- local self = CreateFrame("Frame", name, UIParent, "BasicFrameTemplate");
	-- -- -- Set up some storage variables.
	-- -- self.Name = name;
	-- -- -- Hook some functions.
	-- -- self.__Hide = self.Hide;
	-- -- return self;
-- -- end

-- -- function cPowaUIChildFrame:Init(isRecycled, parent, width, height, point, relative, offsetx, offsety)
	-- -- -- Reset positioning/sizing.
	-- -- self:SetParent((parent or UIParent));
	-- -- self:SetPoint((point or "CENTER"), (parent or UIParent), (relative or "CENTER"), (offsetx or 0), (offsety or 0));
	-- -- self:SetWidth((width or 0));
	-- -- self:SetHeight((height or 0));
	-- -- -- Show frame.
	-- -- self:Show();
	
	
	-- -- print("Initialized widget: (" .. self.Type .. ", " .. self.Name .. ", " .. (isRecycled and "true" or "false") .. ")");
-- -- end