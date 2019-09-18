-- Creating namespace
local CritCommander, NS = Options


-- Globals
critCommander_variablesLoaded = false;


-- Locals
local critCommanderConfig_DefaultSoundDelay = .5 -- Half a second
local critCommanderConfig_DefaultSoundChannel = "Dialog" -- Master, SFX, Music, Ambience, Dialog


-- for configuration saving
critCommanderRealm = GetCVar("realmName");
critCommanderChar = UnitName("player");


-- Creates frame to listen for "VARIABLES_LOADED"
local critCommanderFrame = CreateFrame("Frame")
    critCommanderFrame:RegisterEvent("VARIABLES_LOADED")
    critCommanderFrame:SetScript("OnEvent", function(self, event)
        self:OnEvent(event)
    end)
end


-- Calls method once "VARIABLES_LOADED" has been confirmed.
local function combatLogFrame:OnEvent(event)
    if (event == "VARIABLES_LOADED") then
        critCommander_VARIABLES_LOADED();
	end
end


-- Method to load config
function critCommander_VARIABLES_LOADED()
	-- initialize our SavedVariable
	if ( not critCommanderConfig ) then 
	 	critCommanderConfig = {}; 
	end
	if ( not critCommanderConfig[critCommanderRealm] ) then 
	 	critCommanderConfig[critCommanderRealm] = {}; 
	end
	if ( not critCommanderConfig[critCommanderRealm][critCommanderChar] ) then 
	 	critCommanderConfig[critCommanderRealm][critCommanderChar] = {}; 
    end
    

	-- load each option, set default if not there
	if ( not critCommanderConfig[critCommanderRealm][critCommanderChar].SoundDelay ) then 
		critCommanderConfig[critCommanderRealm][critCommanderChar].SoundDelay = critCommanderConfig_DefaultSoundDelay; 
	end
	if ( not critCommanderConfig[critCommanderRealm][critCommanderChar].SoundChannel ) then 
		critCommanderConfig[critCommanderRealm][critCommanderChar].SoundChannel = critCommanderConfig_DefaultSoundChannel; 
	end
    

	-- record that we have been loaded
    critCommander_variablesLoaded = true;
 end