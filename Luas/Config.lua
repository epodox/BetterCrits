----------------------------------------
-- Namespace / Locals
----------------------------------------
local _, addon = ...;
addon.Config = {};
local Config = addon.Config;
local UIOptions;
local debugValue;
local thisPlayer;
local mainCritCommanderFrame = CreateFrame("Frame")
mainCritCommanderFrame:SetScript("OnEvent", function(self, event, ...)
	return self[event](self, event, ...)
end);




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
		SoundChannel = "Master",	-- Master, SFX, Music, Ambience, Dialog.
		Debug = true,				-- Make sure this is set to false for releases.
	},
};




----------------------------------------
-- Events / Handlers
----------------------------------------
mainCritCommanderFrame:RegisterEvent("PLAYER_LOGIN")
function mainCritCommanderFrame.PLAYER_LOGIN(self, event)
	-- Build SavedVariables database if one has not been created. Also populates defaults.
	CritCommanderDB = CritCommanderDB or {}
	if (not CritCommanderDB[defaults.Data.Realm]) then 
		CritCommanderDB[defaults.Data.Realm] = {};
	end;
	if (not CritCommanderDB[defaults.Data.Realm][defaults.Data.Char]) then 
		CritCommanderDB[defaults.Data.Realm][defaults.Data.Char] = {};
    end;
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

	-- Creates frame for options panel.
	local loader = CreateFrame('Frame', nil, InterfaceOptionsFrame)
	loader:SetScript('OnShow', function(self)
		self:SetScript('OnShow', nil)

		if not mainCritCommanderFrame.optionsPanel then
			mainCritCommanderFrame.optionsPanel = mainCritCommanderFrame:CreateOptionsUI("Crit Commander")
			InterfaceOptions_AddCategory(mainCritCommanderFrame.optionsPanel);
		end
	end)
end




----------------------------------------
-- Functions
----------------------------------------
local uniquealyzerCheckbox = 1;
local uniquealyzerSlider = 1;


-- Makes all the checkboxes.
local function makeCheckbox(parent, x_loc, y_loc, displayText)
	uniquealyzerCheckbox = uniquealyzerCheckbox + 1;
	
	local checkbutton = CreateFrame("CheckButton", "critCommander_optionsCheckbutton_0" .. uniquealyzerCheckbox, parent, "ChatConfigCheckButtonTemplate");
	checkbutton:SetPoint("TOPLEFT", x_loc, y_loc);
	getglobal(checkbutton:GetName() .. 'Text'):SetText(displayText);

	return checkbutton;
end


-- Makes all the sliders.
local function makeSlider(parent, x_loc, y_loc, displayText)
	uniquealyzerSlider = uniquealyzerSlider + 1;
	
	local slider = CreateFrame("Slider", "critCommander_optionsSlider_0" .. uniquealyzerSlider, parent, "OptionsSliderTemplate");
	slider:SetPoint("TOPLEFT", x_loc, y_loc);
	slider:SetObeyStepOnDrag(true)
	getglobal(slider:GetName() .. 'Text'):SetText(displayText);

	return slider;
end


-- Rounds to first decimial
local function roundToFirstDecimal(t)
    return math.round(t*10)*0.1
end


-- Main frame for addon.
function mainCritCommanderFrame:CreateOptionsUI(name, parent)
	-- Create mainCritCommanderFrame options window frame.
	local frame = CreateFrame("Frame", nil, InterfaceOptionsFrame)
	frame:Hide()
	frame.parent = parent
	frame.name = name
	frame:SetScript("OnShow", function(self)
        self.content.optionsDebug:SetChecked(thisPlayer.Debug)
        self.content.optionsSoundDelay:SetValue(thisPlayer.SoundDelay)
    end)

	-- Label for addon options header.
	local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	label:SetPoint("TOPLEFT", 10, -15)
	label:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 10, -45)
	label:SetJustifyH("LEFT")
    label:SetJustifyV("TOP")
	label:SetText(name)

	-- Set content for mainCritCommanderFrame frame.
	local content = CreateFrame("Frame", "CADOptionsContent", frame)
	content:SetPoint("TOPLEFT", 10, -10)
    content:SetPoint("BOTTOMRIGHT", -10, 10)
	frame.content = content
	
	-- Checkbox for debug mode.
	local optionsDebug = makeCheckbox(frame, 10, -60, "  Turn on debug mode")
	content.optionsDebug = optionsDebug
	optionsDebug.tooltip = "Adds extra logging to chat window.";
	optionsDebug:SetScript("OnClick", 
		function()
			thisPlayer.Debug = not thisPlayer.Debug;
		end
	);

	-- Slider for sound delay.
	local optionsSoundDelay = makeSlider(frame, 320, -75, "Sound Delay")
	content.optionsSoundDelay = optionsSoundDelay
	optionsSoundDelay:SetMinMaxValues(0,1)
	optionsSoundDelay:SetValueStep(.1)
	optionsSoundDelay.tooltipText = "Adds a delay from when the crit was registered to when the sound is played. Note this is to help sync with seeing the crit in the combat text and hearing the clip."
	optionsSoundDelay:SetScript("OnValueChanged",
		function(self, value)
			thisPlayer.SoundDelay = value;
			_G[optionsSoundDelay:GetName() .. 'Text']:SetText("Sound Delay: "..tostring(roundToFirstDecimal(value)).." Seconds")
		end
	);

	-- Create the dropdown, and configure its appearance
	local soundChannelLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	soundChannelLabel:SetPoint("TOPLEFT", 315, -161)
	soundChannelLabel:SetJustifyH("LEFT")
    soundChannelLabel:SetJustifyV("TOP")
	soundChannelLabel:SetText("Sound Channel")

	local soundChannelDropDown = CreateFrame("FRAME", "SoundChannelDropDown", frame, "UIDropDownMenuTemplate")
	soundChannelDropDown:SetPoint("TOPLEFT", 295, -175)
	UIDropDownMenu_SetWidth(soundChannelDropDown, 100)
	UIDropDownMenu_SetText(soundChannelDropDown, thisPlayer.SoundChannel)

	-- Implement the function to change the Sound Channel
	function soundChannelDropDown:SetValue(newValue)
		thisPlayer.SoundChannel = newValue
		UIDropDownMenu_SetText(soundChannelDropDown, thisPlayer.SoundChannel)
		CloseDropDownMenus()
	end

	-- Makes each menu item for the drop down.
	function soundChannelDropDown:MakeDropDownItem(name, level)
		local info = UIDropDownMenu_CreateInfo();
		info.text = name;
		info.value = name;
		info.owner = soundChannelDropDown;
		info.func = function() self:SetValue(name); end;
		info.checked = thisPlayer.SoundChannel == info.value;
		UIDropDownMenu_AddButton(info, level); 
	end

	-- Create and bind the initialization function to the dropdown menu
	UIDropDownMenu_Initialize(soundChannelDropDown,	function(self)
		self:MakeDropDownItem("Master", 1)
		self:MakeDropDownItem("SFX", 1)
		self:MakeDropDownItem("Music", 1)
		self:MakeDropDownItem("Ambience", 1)
		self:MakeDropDownItem("Dialog", 1)
	end)

	return frame
end