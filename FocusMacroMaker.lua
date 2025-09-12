if not FocusMacroMakerDB then
    FocusMacroMakerDB = {
        marker = 1 -- Default to marker 1 (Star)
    }
end

-- Target marker constants
local TARGET_MARKERS = {
    [1] = "Star",
    [2] = "Circle",
    [3] = "Diamond",
    [4] = "Triangle",
    [5] = "Moon",
    [6] = "Square",
    [7] = "Cross",
    [8] = "Skull"
}

-- Function to print debug information
local function PrintDebug(message)
    print("|cFF00FF00[FocusMacroMaker]|r " .. message)
end

local function indexOf(t, value)
    for i, v in ipairs(t) do if v == value then return i end end
end

local function PlayerName()
    local playerName, playerRealm = UnitFullName("player")
    return (playerName .. "-" .. playerRealm)
end

local function SortPartyMembers()
    local names = {}

    -- Add player's own name
    table.insert(names, PlayerName())

    -- Add party members
    for i = 1, GetNumSubgroupMembers() do
        local unit = "party" .. i
        if UnitExists(unit) then
            local name = GetUnitName(unit, true)
            if name then
                table.insert(names, name)
            end
        end
    end

    -- Sort the array
    table.sort(names)

    return names
end

-- Main window creation
local mainFrame = CreateFrame("Frame", "FocusMacroMakerMainFrame", UIParent, "BasicFrameTemplateWithInset")
mainFrame:SetSize(500, 350)
mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
mainFrame.TitleBg:SetHeight(30)
mainFrame.title = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
mainFrame.title:SetPoint("TOPLEFT", mainFrame.TitleBg, "TOPLEFT", 5, -3)
mainFrame.title:SetText("Focus Macro Maker")
mainFrame:Hide() -- initially hidden.

mainFrame:EnableMouse(true)
mainFrame:SetMovable(true)
mainFrame:RegisterForDrag("LeftButton")
mainFrame:SetScript("OnDragStart", function(self)
    self:StartMoving()
end)
mainFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
end)

mainFrame:SetScript("OnShow", function()
    PlaySound(808)
end)

mainFrame:SetScript("OnHide", function()
    PlaySound(808)
end)

-- Text and button on same row
mainFrame.playerName = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
mainFrame.playerName:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 15, -45)
mainFrame.playerName:SetText("Your focus marker")

-- focus icon (hardcoded for now)
local focusIcon = mainFrame:CreateTexture(nil, "OVERLAY")
focusIcon:SetSize(32, 32)
focusIcon:SetPoint("LEFT", mainFrame.playerName, "RIGHT", 10, 0)
focusIcon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
SetRaidTargetIconTexture(focusIcon, FocusMacroMakerDB.marker)

-- Function to update the focus icon
local function UpdateFocusIcon()
    SetRaidTargetIconTexture(focusIcon, FocusMacroMakerDB.marker)
end

-- Event frame for party notifications
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")

-- Event handler for party changes
local function OnPartyEvent(self, event, ...)
    if event == "GROUP_ROSTER_UPDATE" then
        local player = PlayerName();
        local names = SortPartyMembers()
        PrintDebug("Player: " .. player)
        PrintDebug("Names: " .. table.concat(names, ", "))
        local playerIndex = indexOf(names, player)
        PrintDebug("Player index: " .. playerIndex)
        FocusMacroMakerDB.marker = playerIndex
        UpdateFocusIcon()
    end
end

eventFrame:SetScript("OnEvent", OnPartyEvent)

PrintDebug("FocusMacroMaker loaded.")


-- Slash commands
SLASH_FOCUSMACROMAKER1 = "/focusmacromaker"
SLASH_FOCUSMACROMAKER2 = "/fmm"
SlashCmdList["FOCUSMACROMAKER"] = function()
    if mainFrame:IsShown() then
        mainFrame:Hide()
    else
        mainFrame:Show()
    end
end

table.insert(UISpecialFrames, "FocusMacroMakerMainFrame")
