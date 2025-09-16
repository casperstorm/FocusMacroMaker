FocusMacroMaker_Events = {}

local ADDON_NAME = "FocusMacroMaker"

local frame = CreateFrame("Frame")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:RegisterEvent("READY_CHECK")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

local function OnEvent(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == ADDON_NAME then
            C_Timer.After(0.1, function()
                if FocusMacroMakerDB.autoSelectMarker then
                    FocusMacroMaker_Utilities.UpdateMarker()
                end

                FocusMacroMaker_Utilities.CreateFocusMacro()
                FocusMacroMaker_UI.UpdateUIState()
            end)
        end
    elseif event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ENTERING_WORLD" then
        if FocusMacroMakerDB.autoSelectMarker then
            FocusMacroMaker_Utilities.UpdateMarker()
            FocusMacroMaker_Utilities.CreateFocusMacro()
        end
    elseif event == "READY_CHECK" then
        if FocusMacroMakerDB.announceOnReadyCheck then
            FocusMacroMaker_Utilities.SayFocusMarker()
        end
    end
end

local function InitializeEvents()
    frame:SetScript("OnEvent", OnEvent)
end

FocusMacroMaker_Events.InitializeEvents = InitializeEvents