-- Register the Namespace.
local CritCommander, NS = ...


-- Globals.
critCommander_variablesLoaded = false;


-- Locals.
local critCommanderConfig_DefaultSoundDelay = .5 -- Half a second.
local critCommanderConfig_DefaultSoundChannel = "Dialog" -- Master, SFX, Music, Ambience, Dialog.
local critCommanderConfig_DefaultDebug = true -- Make sure this is set to false for releases.
local NS.critCommanderRealm = GetCVar("realmName")
local NS.critCommanderChar = UnitName("player")


-- Creates frame to listen for "VARIABLES_LOADED".
local critCommanderFrame = CreateFrame("Frame")
    critCommanderFrame:RegisterEvent("VARIABLES_LOADED")
    critCommanderFrame:SetScript("OnEvent", function(self, event)
        self:OnEvent(event)
    end)
end


-- Calls method once "VARIABLES_LOADED" has been confirmed.
local function combatLogFrame:OnEvent(event)
    if (event == "VARIABLES_LOADED") then
		critCommander_VARIABLES_LOADED()
		SendOutput("Crit Commander - Variables loaded.")
	end
end


-- Method to load config
local function critCommander_VARIABLES_LOADED()
	-- Initialize our SavedVariable.
	if (not critCommanderConfig) then 
		critCommanderConfig = {}
		SendOutput("Crit Commander - Creating config.")
	end
	if (not critCommanderConfig[critCommanderRealm]) then 
		critCommanderConfig[critCommanderRealm] = {}
		SendOutput("Crit Commander - Adding realm to config.")
	end
	if (not critCommanderConfig[critCommanderRealm][critCommanderChar]) then 
		critCommanderConfig[critCommanderRealm][critCommanderChar] = {}
		SendOutput("Crit Commander - Adding character to config.") 
    end
    

	-- load each option, set default if not there.
	if ( not critCommanderConfig[critCommanderRealm][critCommanderChar].SoundDelay ) then 
		critCommanderConfig[critCommanderRealm][critCommanderChar].SoundDelay = critCommanderConfig_DefaultSoundDelay
	end
	if ( not critCommanderConfig[critCommanderRealm][critCommanderChar].SoundChannel ) then 
		critCommanderConfig[critCommanderRealm][critCommanderChar].SoundChannel = critCommanderConfig_DefaultSoundChannel
	end
	if ( not critCommanderConfig[critCommanderRealm][critCommanderChar].Debug ) then 
		critCommanderConfig[critCommanderRealm][critCommanderChar].Debug = critCommanderConfig_DefaultDebug
	end
    

	-- Record that we have been loaded.
    critCommander_variablesLoaded = true
end


-- Post messages if debug mode is turned on.
function SendOutput(msg)
	if NS.Debug = true then
		SendSystemMessage(msg)
	end
end


-- Options.lua end.
SendOutput("Crit Commander - Options.lua has been loaded.")