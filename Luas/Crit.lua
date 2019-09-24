----------------------------------------
-- Namespace / Locals
----------------------------------------
local _, addon = ...;
addon.Crit = {}; -- adds Crit table to addon namespace
local Crit = addon.Crit;
local critListener = CreateFrame("Frame");




----------------------------------------
-- Functions
----------------------------------------
-- Backing function to play the sound files.
local function _playSound(soundFileName)
	PlaySoundFile("Interface\\AddOns\\CritCommander\\Sounds\\" .. soundFileName, CritCommanderDB[GetRealmName()][UnitName("player")].SoundChannel)
end


-- Fucntion to play sound file.
local function playSound()
	_playSound("wow"..math.random(1)..".mp3")
end




----------------------------------------
-- Events / Handlers
----------------------------------------
-- Subscribes to combat event.
function Crit:StartListening()
	critListener:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	critListener:SetScript("OnEvent", function(self, event) self:OnEvent(event, CombatLogGetCurrentEventInfo()) end);
end


-- Parses event, plays sound if its a crit.
function critListener:OnEvent(event, ...)
	local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
	local spellId, spellName, spellSchool
	local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand

	if subevent == "SWING_DAMAGE" then
		amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
	elseif subevent == "SPELL_DAMAGE" then
		spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
    elseif subevent == "RANGE_DAMAGE" then
		spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
    end

		if critical and sourceGUID == CritCommanderDB[GetRealmName()][UnitName("player")].GUID then
		C_Timer.After(CritCommanderDB[GetRealmName()][UnitName("player")].SoundDelay, playSound)
	end
end