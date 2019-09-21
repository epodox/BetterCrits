----------------------------------------
-- Namespace / Locals
----------------------------------------
local _, ns = ...;




----------------------------------------
-- Events / Handlers
----------------------------------------
-- Subscribes to combat event.
local combatLogFrame = CreateFrame("Frame")
combatLogFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
combatLogFrame:SetScript("OnEvent", function(self, event) self:OnEvent(event, CombatLogGetCurrentEventInfo()) end)


-- Parses event, plays sound if its a crit.
function combatLogFrame:OnEvent(event, ...)
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

	
	if critical and sourceGUID == mGuid then
		C_Timer.After(CritCommanderDB[ns.Config.Data.Realm][ns.Config.Data.Char].SoundDelay, playSound)
	end
end




----------------------------------------
-- Functions
----------------------------------------
-- Fucntion to play sound file.
local function playSound()
	PlaySoundFile("wow1.mp3")
end


-- Backing function to play the sound files.
local function backingPlaySound(soundFileName)
	PlaySoundFile("Interface\\AddOns\\CritCommander\\Sounds\\" .. soundFileName, CritCommanderDB[critCommanderRealm][critCommanderChar].SoundChannel)
end


-- Crit.lua end.
SendSystemMessage("Crit Commander - Crit.lua has been loaded.")