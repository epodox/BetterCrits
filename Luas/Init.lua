----------------------------------------
-- Namespace / Locals
----------------------------------------
local _, ns = ...;




----------------------------------------
-- Functions
----------------------------------------
function ns:Print(...)
    local hex = select(4, self.Config:GetThemeColor());
    local prefix = string.format("|cff%s%s|r", hex:upper(), "Crit Commander:");	
    DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, ...));
end


function ns:Init(event, name)
	if (name ~= "CritCommander") then return end 

	
	----------------------------------
	-- Register Slash Commands!
	----------------------------------
	SLASH_RELOADUI1 = "/rl"; -- new slash command for reloading UI
	SlashCmdList.RELOADUI = ReloadUI;

	SLASH_FRAMESTK1 = "/fs"; -- new slash command for showing framestack tool
	SlashCmdList.FRAMESTK = function()
		LoadAddOn("Blizzard_DebugTools");
		FrameStackTooltip_Toggle();
	end

	
	ns.Crit.StartListening
	
	
	ns:Print("Welcome back", UnitName("player").."!");
end

local events = CreateFrame("Frame");
events:RegisterEvent("ADDON_LOADED");
events:SetScript("OnEvent", ns.Init);