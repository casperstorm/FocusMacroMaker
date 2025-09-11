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

mainFrame.playerName = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
mainFrame.playerName:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 15, -35)
mainFrame.playerName:SetText("Your focus marker")

-- Create marker buttons row
local markerButtons = {}
local buttonSize = 32
local buttonSpacing = 5
local startX = 15
local startY = -60

for i = 1, 8 do
    local button = CreateFrame("Button", nil, mainFrame, "UIPanelButtonTemplate")
    button:SetSize(buttonSize, buttonSize)
    button:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", startX + (i - 1) * (buttonSize + buttonSpacing), startY)

    -- Set the raid target icon
    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints()
    icon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
    SetRaidTargetIconTexture(icon, i)

    -- Add tooltip
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(TARGET_MARKERS[i], 1, 1, 1)
        GameTooltip:Show()
    end)
 
    button:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    -- Add click functionality
    button:SetScript("OnClick", function(self)
        -- Save to db?
    end)
    
    markerButtons[i] = button
end

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