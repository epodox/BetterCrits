----------------------------------------
-- Namespace / Locals
----------------------------------------
local _, ns = ...;
ns.Config = {};
local Config = ns.Config;
local UIOptions;




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

	
	-- Initialize our SavedVariable.
	if (not CritCommanderDB) then 
		CritCommanderDB = {};
		SendSystemMessage("Crit Commander - Creating CritCommanderDB");
	end;
	if (not CritCommanderDB[defaults.Data.Realm]) then 
		CritCommanderDB[defaults.Data.Realm] = {};
		SendSystemMessage("Crit Commander - Adding realm to CritCommanderDB");
	end;
	if (not CritCommanderDB[defaults.Data.Realm][defaults.Data.Char]) then 
		CritCommanderDB[defaults.Data.Realm][defaults.Data.Char] = {};
		SendSystemMessage("Crit Commander - Adding character to CritCommanderDB");
    end;
    

	-- load each option, or set default if not there.
	if ( not CritCommanderDB[defaults.Data.Realm][defaults.Data.Char].GUID ) then 
		CritCommanderDB[defaults.Data.Realm][defaults.Data.Char].GUID = defaults.Data.GUID;
	end;
	if ( not CritCommanderDB[defaults.Data.Realm][defaults.Data.Char].SoundDelay ) then 
		CritCommanderDB[defaults.Data.Realm][defaults.Data.Char].SoundDelay = defaults.Settings.SoundDelay;
	end;
	if ( not CritCommanderDB[defaults.Data.Realm][defaults.Data.Char].SoundChannel ) then 
		CritCommanderDB[defaults.Data.Realm][defaults.Data.Char].SoundChannel = defaults.Settings.SoundChannel;
	end;
	if ( not CritCommanderDB[defaults.Data.Realm][defaults.Data.Char].Debug ) then 
		CritCommanderDB[defaults.Data.Realm][defaults.Data.Char].Debug = defaults.Settings.Debug;
	end;
    

	SendSystemMessage("Crit Commander - CritCommanderDB loaded");
end


-- Options.lua end.
SendSystemMessage("Crit Commander - Config.lua has been loaded.");