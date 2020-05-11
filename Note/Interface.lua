local AceGUI = LibStub("AceGUI-3.0")
local eR = elRaidoAddon
local note = eR.note
local UI = note.UI

local frameBackdrop  = {
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true, tileSize = 16, edgeSize = 16,
	insets = { left = 3, right = 3, top = 5, bottom = 3 }
}

--local f = CreateFrame("Frame")
--f:SetSize(500, 500)
--f:SetBackdrop(PaneBackdrop)

--f:SetPoint("CENTER")

function note:createUI()
	UI.containerFrame = AceGUI:Create("Frame")
  
end

