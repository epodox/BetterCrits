----------------------------------------
-- Namespace / Locals
----------------------------------------
local _, addon = ...;
addon.Config = {};
local Config = addon.Config;
local UIOptions;
local debugValue;
local thisServer
local thisPlayer
local main = CreateFrame("Frame")
main:SetScript("OnEvent", function(self, event, ...)
	return self[event](self, event, ...)
end)



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
main:RegisterEvent("PLAYER_LOGIN")
function main.PLAYER_LOGIN(self, event)

	CritCommanderDB = CritCommanderDB or {}
	if (not CritCommanderDB[defaults.Data.Realm]) then 
		CritCommanderDB[defaults.Data.Realm] = {};
	end;
	if (not CritCommanderDB[defaults.Data.Realm][defaults.Data.Char]) then 
		CritCommanderDB[defaults.Data.Realm][defaults.Data.Char] = {};
    end;
	
	thisServer = CritCommanderDB[defaults.Data.Realm];
	thisPlayer = CritCommanderDB[defaults.Data.Realm][defaults.Data.Char];
	
	-- load each option, or set default if not there.
	if ( not thisPlayer.GUID == nil ) then 
		thisPlayer.GUID = defaults.Data.GUID;
	end;
	if ( not thisPlayer.SoundDelay == nil ) then 
		thisPlayer.SoundDelay = defaults.Settings.SoundDelay;
	end;
	if ( thisPlayer.SoundChannel == nil ) then 
		thisPlayer.SoundChannel = defaults.Settings.SoundChannel;
	end;
	if ( thisPlayer.Debug == nil ) then 
		thisPlayer.Debug = defaults.Settings.Debug;
	end;


	local loader = CreateFrame('Frame', nil, InterfaceOptionsFrame)
	loader:SetScript('OnShow', function(self)
		self:SetScript('OnShow', nil)

		if not main.optionsPanel then
			main.optionsPanel = main:CreateOptionsUI("Crit Commander")
			InterfaceOptions_AddCategory(main.optionsPanel);
		end
	end)
end


local function MakeCheckbox(name, parent)
    local cb = CreateFrame("CheckButton", name, parent, "UICheckButtonTemplate")
    cb:SetWidth(25)
    cb:SetHeight(25)
    cb:Show()

    local cblabel = cb:CreateFontString(nil, "OVERLAY")
    cblabel:SetFontObject("GameFontHighlight")
    cblabel:SetPoint("LEFT", cb,"RIGHT", 5,0)
    cb.label = cblabel
    return cb
end


local tooltipOnEnter = function(self, event)
    GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
    GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, false);
    GameTooltip:Show();
end


local tooltipOnLeave = function(self, event)
    GameTooltip:Hide();
end


local function AddTooltip(widget, tooltipText)
    widget.tooltipText = tooltipText
    widget:SetScript("OnEnter", tooltipOnEnter)
    widget:SetScript("OnLeave", tooltipOnLeave)
end


function main:CreateOptionsUI(name, parent)
	local frame = CreateFrame("Frame", nil, InterfaceOptionsFrame)
	frame:Hide()

	frame.parent = parent
	frame.name = name

	frame:SetScript("OnShow", function(self)
		SendSystemMessage(tostring(thisPlayer.Debug))
        self.content.addonDebug:SetChecked(thisPlayer.Debug)
    end)

	local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	label:SetPoint("TOPLEFT", 10, -15)
	label:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 10, -45)
	label:SetJustifyH("LEFT")
    label:SetJustifyV("TOP")
	label:SetText(name)

	local content = CreateFrame("Frame", "CADOptionsContent", frame)
	content:SetPoint("TOPLEFT", 10, -10)
    content:SetPoint("BOTTOMRIGHT", -10, 10)
	frame.content = content
	
	local adg = MakeCheckbox(nil, content)
    adg.label:SetText("Turn on debug mode")
    adg:SetPoint("TOPLEFT", 10, -60)
    content.addonDebug = adg
    adg:SetScript("OnClick",function(self,button)
        thisPlayer.Debug = not thisPlayer.Debug
    end)
    AddTooltip(adg, "Adds extra logging to chat window.")

	return frame
end


-- Options.lua end.
SendSystemMessage("Crit Commander - Config.lua has been loaded.");