-- Register the Namespace.
local _, NS = ...;
NS.Config = {};
--local Config = NS.Config;




-- Locals.
NS.Config = {
	Data = {
		Realm = GetRealmName(),
		Char = UnitName("player"),
		GUID = UnitGUID("player")
	},
	Settings = {
		Default = {
			SoundDelay = .5,			-- Half a second.
			SoundChannel = "Dialog",	-- Master, SFX, Music, Ambience, Dialog.
			Debug = true				-- Make sure this is set to false for releases.
		}
	}
};


SendSystemMessage(CritCommanderDB[NS.Config.Data.Realm][NS.Config.Data.Char].GUID)

-- Creates frame to listen for "VARIABLES_LOADED".
local varListenerFrame = CreateFrame("Frame")
varListenerFrame:RegisterEvent("VARIABLES_LOADED");
varListenerFrame:SetScript("OnEvent", function(self, event) 
	self:OnEvent(event)
end)



-- Calls method once "VARIABLES_LOADED" has been confirmed.
--local function varListenerFrame:OnEvent(event, ...)
 --   if (event == "VARIABLES_LOADED") then
--		critCommander_VARIABLES_LOADED();
--	end;
--end;




-- Method to load config
function varListenerFrame:OnEvent(event)
	-- Initialize our SavedVariable.
	if (not CritCommanderDB) then 
		CritCommanderDB = {};
		SendSystemMessage("Crit Commander - Creating config.");
	end;
	if (not CritCommanderDB[NS.Config.Data.Realm]) then 
		CritCommanderDB[NS.Config.Data.Realm] = {};
		SendSystemMessage("Crit Commander - Adding realm to config.");
	end;
	if (not CritCommanderDB[NS.Config.Data.Realm][NS.Config.Data.Char]) then 
		CritCommanderDB[NS.Config.Data.Realm][NS.Config.Data.Char] = {};
		SendSystemMessage("Crit Commander - Adding character to config.");
    end;
    

	-- load each option, set default if not there.
	if ( not CritCommanderDB[NS.Config.Data.Realm][NS.Config.Data.Char].GUID ) then 
		CritCommanderDB[NS.Config.Data.Realm][NS.Config.Data.Char].GUID = Config.Data.GUID;
	end;
	if ( not CritCommanderDB[NS.Config.Data.Realm][NS.Config.Data.Char].SoundDelay ) then 
		CritCommanderDB[NS.Config.Data.Realm][NS.Config.Data.Char].SoundDelay = Config.Settings.Default.SoundDelay;
	end;
	if ( not CritCommanderDB[NS.Config.Data.Realm][NS.Config.Data.Char].SoundChannel ) then 
		CritCommanderDB[NS.Config.Data.Realm][NS.Config.Data.Char].SoundChannel = Config.Settings.Default.SoundChannel;
	end;
	if ( not CritCommanderDB[NS.Config.Data.Realm][NS.Config.Data.Char].Debug ) then 
		CritCommanderDB[NS.Config.Data.Realm][NS.Config.Data.Char].Debug = Config.Settings.Default.Debug;
	end;
    

	SendSystemMessage("Crit Commander - Variables loaded.");
end





-- Options.lua end.
SendSystemMessage("Crit Commander - Config.lua has been loaded.");