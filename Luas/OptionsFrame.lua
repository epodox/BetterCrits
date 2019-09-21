-- Register the Namespace.
local _, NS = ...;
--NS.Crit = {};
--local Crit = NS.Crit;
--local Config = NS.Config;


-- Locals
local debugValue


-- Register in the Interface Addon Options GUI
CritCommanderOptions = {}
CritCommanderOptions.panel = CreateFrame("Frame", "CritCommanderOptionsPanel", UIParent)


-- Set the name for the Category for the Options Panel
CritCommanderOptions.panel.name = "CritCommander"


-- When the player clicks okay, run this function.
CritCommanderOptions.panel.okay = function (self) CritCommanderOptionsPanel_Close()
    CritCommanderDB[NS.Config.Data.Realm][NS.Config.Data.Char].Debug = debugValue
end


-- When the player clicks cancel, run this function.
CritCommanderOptions.panel.cancel = function (self)  CritCommanderOptionsPanel_CancelOrLoad()

end


-- Add the panel to the Interface Options.
InterfaceOptions_AddCategory(CritCommanderOptions.panel)


-- Debug checkbox.
debugCheckButton = CreateFrame("CheckButton", "debugCheckButton_CritCommander", CritCommanderOptions.panel, "ChatConfigCheckButtonTemplate")
debugCheckButton:SetPoint("TOPLEFT", 200, -65)
debugCheckButton_CritCommanderText:SetText("Debug")
debugCheckButton.tooltip = "Debug mode will allow extra logging to the chat window."
debugCheckButton:SetScript("OnShow",
function()
    -- debugValue = critCommanderConfig[critCommanderRealm][critCommanderChar].Debug  Prob not needed.
    debugCheckButton:SetChecked(CritCommanderDB[NS.Config.Data.Realm][NS.Config.Data.Char].Debug)
end)
debugCheckButton:SetScript("OnClick", 
function() 
    if debugCheckButton:GetChecked() == true then 
        debugCheckButton:SetChecked(false)
        debugValue = false
    else 
        debugCheckButton:SetChecked(true)
        debugValue = true
    end
end)