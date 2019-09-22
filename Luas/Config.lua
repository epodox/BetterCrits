----------------------------------------
-- Namespace / Locals
----------------------------------------
local _, ns = ...;
ns.Config = {};
local Config = ns.Config;
local UIOptions;
local debugValue;



----------------------------------------
-- Defaults
----------------------------------------
local defaults = {
	Data = {
		Realm = GetRealmName(),
		Char = UnitName("player"),
		GUID = UnitGUID("player"),
	},
	Settings = {
		SoundDelay = .5,			-- Half a second.
		SoundChannel = "Dialog",	-- Master, SFX, Music, Ambience, Dialog.
		Debug = true,				-- Make sure this is set to false for releases.
	},
};




----------------------------------------
-- Events / Handlers
----------------------------------------
-- Creates frame to listen for "VARIABLES_LOADED".
local varListenerFrame = CreateFrame("Frame")
varListenerFrame:RegisterEvent("VARIABLES_LOADED");
varListenerFrame:SetScript("OnEvent", function(self, event) self:OnEvent(event) end)


-- Method to load config
function varListenerFrame:OnEvent(event)

	local thisServer = CritCommanderDB[defaults.Data.Realm];
	local thisPlayer = CritCommanderDB[defaults.Data.Realm][defaults.Data.Char];
	
	-- Initialize our SavedVariable.
	if (not CritCommanderDB) then 
		CritCommanderDB = {};
		SendSystemMessage("Crit Commander - Creating CritCommanderDB");
	end;
	if (not thisServer) then 
		thisServer = {};
		SendSystemMessage("Crit Commander - Adding realm to CritCommanderDB");
	end;
	if (not thisPlayer) then 
		thisPlayer = {};
		SendSystemMessage("Crit Commander - Adding character to CritCommanderDB");
    end;
    

	-- load each option, or set default if not there.
	if ( not thisPlayer.GUID ) then 
		thisPlayer.GUID = defaults.Data.GUID;
	end;
	if ( not thisPlayer.SoundDelay ) then 
		thisPlayer.SoundDelay = defaults.Settings.SoundDelay;
	end;
	if ( not thisPlayer.SoundChannel ) then 
		thisPlayer.SoundChannel = defaults.Settings.SoundChannel;
	end;
	if ( not CritCommanderDB[defaults.Data.Realm][defaults.Data.Char].Debug ) then 
		thisPlayer.Debug = defaults.Settings.Debug;
	end;
	
	

	-- Register in the Interface Addon Options GUI
	UIOptions = CreateFrame("Frame", "CritCommanderOptionsPanel", UIParent)
	UIOptions.name = "CritCommander"
	UIOptions.okay = function (self) CritCommanderOptionsPanel_Close()
		thisPlayer.Debug = debugValue
	end
	UIOptions.cancel = function (self)  CritCommanderOptionsPanel_CancelOrLoad()

	end
	InterfaceOptions_AddCategory(UIOptions)


	-- Debug checkbox.
	debugCheckButton = CreateFrame("CheckButton", "debugCheckButton_CritCommander", UIOptions, "ChatConfigCheckButtonTemplate")
	debugCheckButton:SetPoint("TOPLEFT", 200, -65)
	debugCheckButton_CritCommanderText:SetText("Debug")
	debugCheckButton.tooltip = "Debug mode will allow extra logging to the chat window."
	debugCheckButton:SetScript("OnShow",
	function()
		-- debugValue = critCommanderConfig[critCommanderRealm][critCommanderChar].Debug  Prob not needed.
		debugCheckButton:SetChecked(thisPlayer.Debug)
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


	SendSystemMessage("Crit Commander - CritCommanderDB loaded");
end



-- Options.lua end.
SendSystemMessage("Crit Commander - Config.lua has been loaded.");