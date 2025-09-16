FocusMacroMaker_UI = {}

local NUM_MARKERS = 6
local BUTTON_SPACING = 30

-- UI Elements
local mainFrame
local readyCheckCheckbox
local autoSelectMarkerCheckbox
local markerRadioButtons = {}


local function UpdateFocusIcon()
    for i = 1, NUM_MARKERS do
        if markerRadioButtons[i] then
            markerRadioButtons[i]:SetChecked(i == FocusMacroMakerDB.marker)
        end
    end
end

local function CreateUI()
    -- Create main frame
    mainFrame = CreateFrame("Frame", "FocusMacroMakerMainFrame", UIParent, "BasicFrameTemplateWithInset")
    mainFrame:SetSize(350, 210)
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
    mainFrame.mark:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 15, -35)
    mainFrame.mark:SetText("Your focus marker")

    for i = 1, NUM_MARKERS do
        local radioButton = CreateFrame("CheckButton", nil, mainFrame, "UIRadioButtonTemplate")
        radioButton:SetSize(20, 20)
        radioButton:SetPoint("TOPLEFT", mainFrame.mark, "BOTTOMLEFT", (i-1) * BUTTON_SPACING, -10)
        
        local markerIcon = radioButton:CreateTexture(nil, "OVERLAY")
        markerIcon:SetSize(16, 16)
        markerIcon:SetPoint("TOPLEFT", radioButton, "BOTTOMLEFT", 2, -2)
        markerIcon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
        SetRaidTargetIconTexture(markerIcon, i)
        
        radioButton:SetScript("OnClick", function(self)
            if self:GetChecked() then
                FocusMacroMakerDB.marker = i
                UpdateFocusIcon()
                
                autoSelectMarkerCheckbox:SetChecked(false)
                FocusMacroMakerDB.autoSelectMarker = false

                FocusMacroMaker_Utilities.CreateFocusMacro()
            end
        end)
        
        markerRadioButtons[i] = radioButton
    end

    autoSelectMarkerCheckbox = CreateFrame("CheckButton", nil, mainFrame, "UICheckButtonTemplate")
    autoSelectMarkerCheckbox:SetSize(20, 20)
    autoSelectMarkerCheckbox:SetPoint("TOPLEFT", mainFrame.mark, "BOTTOMLEFT", 0, -60)

    local autoSelectMarkerLabel = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    autoSelectMarkerLabel:SetPoint("LEFT", autoSelectMarkerCheckbox, "RIGHT", 5, 0)
    autoSelectMarkerLabel:SetText("Automatically select unique marker")

    autoSelectMarkerCheckbox:SetScript("OnClick", function(self)
        FocusMacroMakerDB.autoSelectMarker = self:GetChecked()

        if FocusMacroMakerDB.autoSelectMarker then
            FocusMacroMaker_Utilities.UpdateMarker()
            FocusMacroMaker_Utilities.CreateFocusMacro()
            FocusMacroMaker_UI.UpdateUIState()
        end
    end)

    readyCheckCheckbox = CreateFrame("CheckButton", nil, mainFrame, "UICheckButtonTemplate")
    readyCheckCheckbox:SetSize(20, 20)
    readyCheckCheckbox:SetPoint("TOPLEFT", autoSelectMarkerCheckbox, "BOTTOMLEFT", 0, -5)

    local readyCheckLabel = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    readyCheckLabel:SetPoint("LEFT", readyCheckCheckbox, "RIGHT", 5, 0)
    readyCheckLabel:SetText("Announce mark on ready check")

    readyCheckCheckbox:SetScript("OnClick", function(self)
        FocusMacroMakerDB.announceOnReadyCheck = self:GetChecked()
    end)

    table.insert(UISpecialFrames, "FocusMacroMakerMainFrame")

    return mainFrame
end

local function GetMainFrame()
    return mainFrame
end

local function UpdateUIState()
    UpdateFocusIcon()
    
    if autoSelectMarkerCheckbox then
        autoSelectMarkerCheckbox:SetChecked(FocusMacroMakerDB.autoSelectMarker)
    end
    
    if readyCheckCheckbox then
        readyCheckCheckbox:SetChecked(FocusMacroMakerDB.announceOnReadyCheck)
    end
end

FocusMacroMaker_UI.UpdateFocusIcon = UpdateFocusIcon
FocusMacroMaker_UI.CreateUI = CreateUI
FocusMacroMaker_UI.GetMainFrame = GetMainFrame
FocusMacroMaker_UI.UpdateUIState = UpdateUIState
