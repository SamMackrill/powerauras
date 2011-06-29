for i = 1, 15 do
	setglobal("PowaOptionsList"..i, {}).SetText = function(self, text) end;
end

setglobal("UIParent", {}).GetHeight = function() return 768; end;
		
setglobal("AuraTexture", CreateTexture("AuraTexture"));
setglobal("PowaIconTexture", CreateTexture("PowaIconTexture"));

setglobal("PowaAuras_Frame", CreateFrame("Frame", "PowaAuras_Frame", "UIParent"));

setglobal("PowaBarAuraTextureSlider", {}).SetMinMaxValues = function(self, text) end;
setglobal("PowaBarAuraTextureSliderHigh", {}).SetText = function(self, text) end;

setglobal("PowaOptionsUpdateSlider", {}).SetValue = function(self, value) end;
setglobal("PowaOptionsAnimationsSlider", {}).SetValue = function(self, value) end;
setglobal("PowaOptionsUpdateSlider2", {}).SetValue = function(self, value) end;
setglobal("PowaOptionsAnimationsSlider2", {}).SetValue = function(self, value) end;
setglobal("PowaOptionsTimerUpdateSlider2", {}).SetValue = function(self, value) end;

setglobal("PowaAllowInspectionsButton", {}).SetChecked = function(self, value) end;

setglobal("PowaEnableButton", {}).SetChecked = function(self, value) end;
setglobal("PowaDebugButton", {}).SetChecked = function(self, value) end;
setglobal("PowaTimerRoundingButton", {}).SetChecked = function(self, value) end;
setglobal("PowaGTFOButton", {}).SetChecked = function(self, value) end;

setglobal("PowaAuras_Tooltip", cWoWMockTooltip("PowaAuras_Tooltip"));
setglobal("PowaAction_Tooltip", cWoWMockTooltip("PowaAction_Tooltip"));
