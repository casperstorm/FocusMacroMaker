FocusMacroMaker_UI = {}

-- UI Elements
local mainFrame
local focusIcon
local sayButton
local readyCheckCheckbox


local function UpdateFocusIcon()
    if focusIcon then
        SetRaidTargetIconTexture(focusIcon, FocusMacroMakerDB.marker)
    end
end

local function CreateUI()
    -- Create main frame
    mainFrame = CreateFrame("Frame", "FocusMacroMakerMainFrame", UIParent, "BasicFrameTemplateWithInset")
    mainFrame:SetSize(350, 200)
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

    mainFrame:SetScript("OnShow", function(self)
        PlaySound(808)
    end)

    mainFrame:SetScript("OnHide", function(self)
        PlaySound(808)
    end)

    mainFrame.mark = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    mainFrame.mark:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 15, -45)
    mainFrame.mark:SetText("Your focus marker")

    focusIcon = mainFrame:CreateTexture(nil, "OVERLAY")
    focusIcon:SetSize(20, 20)
    focusIcon:SetPoint("LEFT", mainFrame.mark, "RIGHT", 5, 0)
    focusIcon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
    SetRaidTargetIconTexture(focusIcon, FocusMacroMakerDB.marker)

    sayButton = CreateFrame("Button", nil, mainFrame, "UIPanelButtonTemplate")
    sayButton:SetSize(150, 30)
    sayButton:SetPoint("TOPLEFT", mainFrame.mark, "BOTTOMLEFT", 0, -10)
    sayButton:SetText("Announce focus mark")

    sayButton:SetScript("OnClick", function(self)
        -- FocusMacroMaker_Utilities.SayFocusMarker()
        -- Create TMM macro if it doesn't exist
        FocusMacroMaker_Utilities.CreateMacroIfMissing()
        FocusMacroMaker_Utilities.EditCreatedMacro()
    end)

    readyCheckCheckbox = CreateFrame("CheckButton", nil, mainFrame, "UICheckButtonTemplate")
    readyCheckCheckbox:SetSize(20, 20)
    readyCheckCheckbox:SetPoint("TOPLEFT", sayButton, "BOTTOMLEFT", 0, -10)

    local readyCheckLabel = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    readyCheckLabel:SetPoint("LEFT", readyCheckCheckbox, "RIGHT", 5, 0)
    readyCheckLabel:SetText("Announce on ready check")

    readyCheckCheckbox:SetScript("OnClick", function(self)
        FocusMacroMakerDB.announceOnReadyCheck = self:GetChecked()
        FocusMacroMaker_Utilities.Print("Ready check announcement " ..
        (FocusMacroMakerDB.announceOnReadyCheck and "enabled" or "disabled"))
    end)

    table.insert(UISpecialFrames, "FocusMacroMakerMainFrame")

    return mainFrame
end

local function GetMainFrame()
    return mainFrame
end

local function GetReadyCheckCheckbox()
    return readyCheckCheckbox
end

FocusMacroMaker_UI.UpdateFocusIcon = UpdateFocusIcon
FocusMacroMaker_UI.CreateUI = CreateUI
FocusMacroMaker_UI.GetMainFrame = GetMainFrame
FocusMacroMaker_UI.GetReadyCheckCheckbox = GetReadyCheckCheckbox
