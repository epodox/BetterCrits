-- Register the Namespace.
local _, NS = ...;
NS.Options = {};
local Options = NS.Options

-- Globals.
critCommander_variablesLoaded = false;


-- Locals.
local CritCommanderDB_DefaultSoundDelay = .5; -- Half a second.
local CritCommanderDB_DefaultSoundChannel = "Dialog"; -- Master, SFX, Music, Ambience, Dialog.
local CritCommanderDB_DefaultDebug = true; -- Make sure this is set to false for releases.
local NS.Options.Realm = GetCVar("realmName");
local NS.Options.Char = UnitName("player");


-- Backing fucntions.
-- Post messages if debug mode is turned on.
function Options:SendOutput(msg)
	if NS.Debug = true then
		SendSystemMessage(msg);
	end;
end;


-- Creates frame to listen for "VARIABLES_LOADED".
local varListenerFrame = CreateFrame("Frame")
	varListenerFrame:RegisterEvent("VARIABLES_LOADED");
	varListenerFrame:SetScript("OnEvent", function(self, event)
        self:OnEvent(event);
    end);
end;


-- Calls method once "VARIABLES_LOADED" has been confirmed.
local function varListenerFrame:OnEvent(event)
    if (event == "VARIABLES_LOADED") then
		critCommander_VARIABLES_LOADED();
		SendOutput("Crit Commander - Variables loaded.");
	end;
end;


-- Method to load config
local function critCommander_VARIABLES_LOADED()
	-- Initialize our SavedVariable.
	if (not CritCommanderDB) then 
		CritCommanderDB = {};
		SendOutput("Crit Commander - Creating config.");
	end;
	if (not CritCommanderDB[critCommanderRealm]) then 
		CritCommanderDB[critCommanderRealm] = {};
		SendOutput("Crit Commander - Adding realm to config.");
	end;
	if (not CritCommanderDB[critCommanderRealm][critCommanderChar]) then 
		CritCommanderDB[critCommanderRealm][critCommanderChar] = {};
		SendOutput("Crit Commander - Adding character to config.");
    end;
    

	-- load each option, set default if not there.
	if ( not CritCommanderDB[critCommanderRealm][critCommanderChar].SoundDelay ) then 
		CritCommanderDB[critCommanderRealm][critCommanderChar].SoundDelay = CritCommanderDB_DefaultSoundDelay;
	end;
	if ( not CritCommanderDB[critCommanderRealm][critCommanderChar].SoundChannel ) then 
		CritCommanderDB[critCommanderRealm][critCommanderChar].SoundChannel = CritCommanderDB_DefaultSoundChannel;
	end;
	if ( not CritCommanderDB[critCommanderRealm][critCommanderChar].Debug ) then 
		CritCommanderDB[critCommanderRealm][critCommanderChar].Debug = CritCommanderDB_DefaultDebug;
	end;
    

	-- Record that we have been loaded.
    critCommander_variablesLoaded = true;
end


-- Options.lua end.
SendOutput("Crit Commander - Options.lua has been loaded.");