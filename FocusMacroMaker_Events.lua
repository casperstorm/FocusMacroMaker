FocusMacroMaker_Events = {}

local frame = CreateFrame("Frame")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:RegisterEvent("READY_CHECK")
frame:RegisterEvent("ADDON_LOADED")

local function OnEvent(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "FocusMacroMaker" then
            -- Set UI state after addon is loaded
            FocusMacroMaker_UI.GetReadyCheckCheckbox():SetChecked(FocusMacroMakerDB.announceOnReadyCheck)
            -- Refresh marker
            FocusMacroMaker.UpdateMarker()
        end
    elseif event == "GROUP_ROSTER_UPDATE" then
        FocusMacroMaker.UpdateMarker()
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