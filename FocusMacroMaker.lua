if not FocusMacroMakerDB then
    FocusMacroMakerDB = {}
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

-- Function to print party members
local function PrintPartyMembers()
    if not IsInGroup() then return end

    for i = 1, GetNumSubgroupMembers() do
        local unit = "party" .. i
        if UnitExists(unit) then
            local name = GetUnitName(unit, true)
            PrintDebug(name)
        end
    end
end

local function PrintPlayerCharacter()
    local name, realm = UnitFullName("player")
    PrintDebug(name .. "-" .. realm)
end

-- Event frame for party notifications
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")

-- Event handler for party changes
local function OnPartyEvent(self, event, ...)
    if event == "GROUP_ROSTER_UPDATE" then
        PrintDebug("Party roster updated")
        PrintPartyMembers()
    end
end

eventFrame:SetScript("OnEvent", OnPartyEvent)

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
SetRaidTargetIconTexture(focusIcon, 8) -- 8 = Skull

-- buttons for debugging
local partyButton = CreateFrame("Button", nil, mainFrame, "UIPanelButtonTemplate")
partyButton:SetSize(120, 30)
partyButton:SetPoint("TOPLEFT", mainFrame.playerName, "BOTTOMLEFT", 0, -10)
partyButton:SetText("Print Party [debug]")

partyButton:SetScript("OnClick", function(self)
    PrintPartyMembers()
end)

local characterButton = CreateFrame("Button", nil, mainFrame, "UIPanelButtonTemplate")
characterButton:SetSize(120, 30)
characterButton:SetPoint("TOPLEFT", mainFrame.playerName, "BOTTOMLEFT", 0, -50)
characterButton:SetText("Print Self [debug]")

characterButton:SetScript("OnClick", function(self)
    PrintPlayerCharacter()
end)


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
