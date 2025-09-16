FocusMacroMaker_Utilities = {}

local macroName = "FocusMacroMaker"

local function Print(message)    
    print("|cFF00FF00[FocusMacroMaker]|r " .. message)
end

local function IndexOf(t, value)
    for i, v in ipairs(t) do if v == value then return i end end
end

local function PlayerName()
    local playerName, playerRealm = UnitFullName("player")
    return (playerName .. "-" .. playerRealm)
end

local function SayFocusMarker()
    local text = "My focus mark is {rt" .. FocusMacroMakerDB.marker .. "}"
    C_ChatInfo.SendChatMessage(text, "SAY")
end

local function SortPartyMembers()
    local names = {}

    table.insert(names, PlayerName())

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

local function UpdateMarker()
    local player = FocusMacroMaker_Utilities.PlayerName()
    local names = FocusMacroMaker_Utilities.SortPartyMembers()
    local playerIndex = FocusMacroMaker_Utilities.IndexOf(names, player)

    FocusMacroMakerDB.marker = playerIndex
    FocusMacroMaker_UI.UpdateFocusIcon()
end

local function CreateFocusMacro()
    if not GetMacroInfo(macroName) then
        local success = CreateMacro(macroName, "INV_Misc_QuestionMark", "", false)
        if not success then
            Print("Failed to create macro: " .. macroName)
            return
        end
    end

    local content = "/focus [@mouseover,exists,nodead][exists]\n/run if not GetRaidTargetIndex(\"focus\") then SetRaidTarget(\"focus\"," .. FocusMacroMakerDB.marker .. ") end"
    EditMacro(macroName, macroName, nil, content)
end


FocusMacroMaker_Utilities.Print = Print
FocusMacroMaker_Utilities.IndexOf = IndexOf
FocusMacroMaker_Utilities.PlayerName = PlayerName
FocusMacroMaker_Utilities.SayFocusMarker = SayFocusMarker
FocusMacroMaker_Utilities.SortPartyMembers = SortPartyMembers
FocusMacroMaker_Utilities.CreateFocusMacro = CreateFocusMacro
FocusMacroMaker_Utilities.UpdateMarker = UpdateMarker