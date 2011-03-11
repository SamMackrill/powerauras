--[[
	cPowaUIWidget
	Base widget class. All widgets should extend this class which contains methods used by most child classes.
--]]
cPowaUIWidget = PowaClass(function(widget, name, parent, ...)
	-- Make widget.
	if(not widget.Type or not name) then
		PowaAuras:ShowText("Attempted to construct UI Widget without type or name.");
		return false;
	else
		PowaAuras:ShowText("Constructing UI Widget (", widget.Type, ", ", name, ")");
	end	
	-- Can the frame support a layout and children?
	if(widget.HasLayout == true) then
		-- Add a children widget table.
		widget.Children = {};
		widget.Columns = (widget.Columns or 2);
	end
	-- Store the UI element in this.
	widget.Element = nil;
	widget.Name = name;
	-- Set widget parent.
	widget:SetParent(parent);
	-- Initialize the widget.
	widget:Init(...);
end);

function cPowaUIWidget:Init(...)
	-- Do your widget init code here (making ui frames, etc).
	widget.Element = nil;
end

function cPowaUIWidget:AddChild(widget, name, hasInitialized)
	-- Needs to support layout.
	if(not self.HasLayout) then PowaAuras:ShowText("Cannot add child elements to widget which has no layout."); return false; end
	-- Add the child, only initialize a new class if needed.
	self.Children[name] = (not hasInitialized and widget() or widget);
	-- Trigger layout update.
	self:UpdateLayout();
	return true;
end

function cPowaUIWidget:RemoveChild(name)
	-- Needs to support layout.
	if(not self.HasLayout) then PowaAuras:ShowText("Cannot remove child elements from widget which has no layout."); return false; end
	-- Remove child if exists.
	if(not self.Children[name]) then return false; end
	wipe(self.Children[name]);
	-- Trigger layout update.
	self:UpdateLayout();
	return true;
end

function cPowaUIWidget:UpdateLayout()
	-- Needs to support layout.
	if(not self.HasLayout) then PowaAuras:ShowText("Cannot update layout of child elements in widget which has no layout."); return false; end
end

function cPowaUIWidget:SetParent(parent)
	-- UIParent is the default.
	if(not parent) then parent = UIParent; end
	-- Decouple from existing parent.
	if(self.Parent and self.Parent.HasLayout) then
		self.Parent:RemoveChild(self.Name);
	end
	-- Does the new parent have a layout?
	if(parent.HasLayout) then
		parent:AddChild(widget, name, true);
	end
	-- Set parent.
	self.Parent = parent;
end

function cPowaUIWidget:SetColumns(columns)
	if(not self.HasLayout) then PowaAuras:ShowText("Cannot set columns for frame with no layout."); return false; end
	self.Columns = columns or 1;
end

function cPowaUIWidget:Hide()
	if(not self.Element) then return false; end
	if(self.Reusable) then self:Destroy(); else self.Element:Hide(); end
end

function cPowaUIWidget:Show()
	if(self.Element) then self.Element:Show(); end
end

-- Removes an element and places it in a table for future reuse. Not yet implemented.
function cPowaUIWidget:Destroy()
	self.Element:Hide();
end

--[[
	cPowaUIHost
	Base frame class which allows drawing and displaying a frame directly.
	
	Has layout (Columns: 1).
--]]
cPowaUIHost = PowaClass(cPowaUIWidget, { Type = "Host", HasLayout = true, Columns = 1 });

function cPowaUIHost:Init(template, ...)
	-- Create the frame with a template.
	self.Element = CreateFrame("Frame", self.Name, self.Parent, template or "");
	self:SetPoint(...);
end

-- Only the Host frame allows for positioning/explicit sizing. Rest of widgets are automatically positioned in parents
-- with HasLayout support.
function cPowaUIHost:SetPoint(point, relative, x, y)
	self.Element:SetPoint(point, self.Parent, relative, x, y);
end

function cPowaUIHost:ClearAllPoints()
	self.Element:ClearAllPoints();
end

function cPowaUIHost:SetWidth(width)
	self.Element:SetWidth(width);	
end

function cPowaUIHost:SetHeight(height)
	self.Element:SetHeight(height);
end