-- Locals
local debugValue


-- Register in the Interface Addon Options GUI
CritCommander = {}
CritCommander.panel = CreateFrame("Frame", "CritCommanderOptionsPanel")


-- Set the name for the Category for the Options Panel
CritCommander.panel.name = "CritCommander"


-- When the player clicks okay, run this function.
CritCommander.panel.okay = function (self) CritCommanderOptionsPanel_Close()
    critCommanderConfig[critCommanderRealm][critCommanderChar].Debug = debugValue
end


-- When the player clicks cancel, run this function.
CritCommander.panel.cancel = function (self)  CritCommanderOptionsPanel_CancelOrLoad()

end


-- Add the panel to the Interface Options.
InterfaceOptions_AddCategory(CritCommander.panel)


-- Debug checkbox.
debugCheckButton = CreateFrame("CheckButton", "debugCheckButton_CritCommander", UIParent, "ChatConfigCheckButtonTemplate")
debugCheckButton:SetPoint("TOPLEFT", 200, -65)
debugCheckButton_CritCommanderText:SetText("Debug")
debugCheckButton.tooltip = "Debug mode will allow extra logging to the chat window."
debugCheckButton:SetScript("OnShow",
function()
    -- debugValue = critCommanderConfig[critCommanderRealm][critCommanderChar].Debug  Prob not needed.
    debugCheckButton:SetChecked(critCommanderConfig[critCommanderRealm][critCommanderChar].Debug)
end)
debugCheckButton:SetScript("OnClick", 
function() 
    if debugCheckButton:GetChecked() then 
        debugCheckButton:SetChecked(false)
        debugValue = false
    else 
        debugCheckButton:SetChecked(true)
        debugValue = true
    end
end)