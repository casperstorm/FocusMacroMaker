FocusMacroMaker = {}

local DEFAULT_MARKER = 1 -- Star

-- Initialize saved variables
if not FocusMacroMakerDB then
    FocusMacroMakerDB = {
        marker = DEFAULT_MARKER,
        announceOnReadyCheck = true,
        autoSelectMarker = true
    }
end
-- Initialize UI
FocusMacroMaker_UI.CreateUI()

-- Initialize events
FocusMacroMaker_Events.InitializeEvents()

-- Slash commands
SLASH_FOCUSMACROMAKER1 = "/focusmacromaker"
SLASH_FOCUSMACROMAKER2 = "/fmm"
SlashCmdList["FOCUSMACROMAKER"] = function()
    local frame = FocusMacroMaker_UI.GetMainFrame()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
    end
end

