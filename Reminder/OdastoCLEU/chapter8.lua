OdastoAddonCLEU=LibStub("AceAddon-3.0"):NewAddon("OdastoCLEU","AceConsole-3.0","AceComm-3.0","AceEvent-3.0","AceSerializer-3.0")

local addon = OdastoAddonCLEU
local addonName = OdastoAddonCLEU.name

local AceConfig=LibStub("AceConfig-3.0")
local AceConfigDialog=LibStub("AceConfigDialog-3.0")

function addon:inventory() --table with all pairs of bag coordinates
    local I = {}
    for bag=0,4 do
            for slot=1,GetContainerNumSlots(bag) do  
            I[#I+1] = {bag, GetContainerNumSlots(bag)-slot+1}
        end
    end  
    return I
end


local defaults = {
 profile = {sortTable = {},
            autoOpen = true,
            hideBlizzard = false,
            hideContainers = false,
            buttonSpacing = 2,
            scale = 1.08,
            hotkey = "B",
            X = 1568,
            Y = 230,
            bag1Size = 16,
            bag1Columns = 4,
            bag1X       = 0,
            bag1Y       = 0.2,
            bag2Size = 30,
            bag2Columns = 4,
            bag2X       = 0,
            bag2Y       = 5.2,
            bag3Size = 30,
            bag3Columns = 4,
            bag3X       = -4.6,
            bag3Y       = 0.2,
            bag4Size = 30,
            bag4Columns = 4,
            bag4X       = -4.6,
            bag4Y       = 9.2,
            bag5Size = 30,
            bag5Columns = 4,
            bag5X       = -9.2,
            bag5Y       = 0.2,
            bag6Size = 0,
            bag6Columns = 0,
            bag6X       = 5,
            bag6Y       = 1,
            bag7Size = 0,
            bag7Columns = 0,
            bag7X       = 5,
            bag7Y       = 1,
            bag8Size = 0,
            bag8Columns = 0,
            bag8X       = 5,
            bag8Y       = 1,
            bag9Size = 0,
            bag9Columns = 0,
            bag9X       = 5,
            bag9Y       = 1,
            bag10Size = 0,
            bag10Columns = 0,
            bag10X       = 5,
            bag10Y       = 1,
            }
}

function addon:OnInitialize()               
    self.db=LibStub("AceDB-3.0"):New("OdastoCLEUDB",defaults,true)  --true sets the default profile to a profile called "Default"
    self.db.RegisterCallback(self, "OnProfileChanged", function() print('|cFFC79C6EOdastoCLEU|r was reset to default profile.') end)
end

addon.registeredEvents = {"BAG_UPDATE", "BAG_UPDATE_COOLDOWN", "ITEM_PUSH", "PLAYER_MONEY"}
addon.event_frame=CreateFrame('Frame','OdastoBagsGlobalEventFrame',UIParent)
addon.event_frame:RegisterEvent("PLAYER_ENTERING_WORLD") 

local function eventHandler(self, event, bag)
    if event == "PLAYER_ENTERING_WORLD" then   
        addon.event_frame:UnregisterEvent("PLAYER_ENTERING_WORLD")

    end    
end

addon.event_frame:SetScript("OnEvent", eventHandler)
