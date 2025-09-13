FocusMacroMaker = {}

-- State
if not FocusMacroMakerDB then
    FocusMacroMakerDB = {
        marker = 1, -- Default to marker 1 (Star)
        announceOnReadyCheck = false
    }
end
-- Initialize UI
FocusMacroMaker_UI.CreateUI()

-- Function to update the marker
function FocusMacroMaker.UpdateMarker()
    local player = FocusMacroMaker_Utilities.PlayerName();
    local names = FocusMacroMaker_Utilities.SortPartyMembers()
    local playerIndex = FocusMacroMaker_Utilities.IndexOf(names, player)

    FocusMacroMakerDB.marker = playerIndex
    FocusMacroMaker_UI.UpdateFocusIcon()
end

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

