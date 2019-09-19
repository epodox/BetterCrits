-- Register in the Interface Addon Options GUI
CritCommander = {};
CritCommander.panel = CreateFrame("Frame", "CritCommanderOptionsPanel");

-- Set the name for the Category for the Options Panel
CritCommander.panel.name = "CritCommander";

-- When the player clicks okay, run this function.
CritCommander.panel.okay = function (self) CritCommanderOptionsPanel_Close(); end;

-- When the player clicks cancel, run this function.
CritCommander.panel.cancel = function (self)  CritCommanderOptionsPanel_CancelOrLoad();  end;

-- Add the panel to the Interface Options
InterfaceOptions_AddCategory(CritCommander.panel);