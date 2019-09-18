-- Creating namespace
local CritCommander, NS = Crit


-- Setting defaults for locals
local soundDelay = .5
local soundChannel = "Dialog"


local function register()
    local playerGUID = UnitGUID("player")
    
    local combatLogFrame = CreateFrame("Frame")
    combatLogFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    combatLogFrame:SetScript("OnEvent", function(self, event) 
        self:OnEvent(event, CombatLogGetCurrentEventInfo())
    end)
    
    SendSystemMessage("Crit Commander has been loaded.")
end


local function combatLogFrame:OnEvent(event, ...)
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
	
	if critical and sourceGUID == playerGUID then
		C_Timer.After(soundDelay, playSound)
	end
end


local function playSound()
	PlaySoundFile("Interface\\AddOns\\CritCommander\\Sounds\\wow1.mp3", soundChannel)
end


-- Adding to the namespace
NS.Crit.Register = register
NS.Crit.SoundDelay = soundDelay
NS.Crit.SoundChannel = soundChannel