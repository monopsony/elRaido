local AceGUI = LibStub("AceGUI-3.0")
local eR = elRaidoAddon
local note = eR.note
local UI = note.UI
local ipairs, pairs, unpack = ipairs, pairs, unpack

local frameBackdrop  = {
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true, tileSize = 16, edgeSize = 16,
	insets = { left = 3, right = 3, top = 5, bottom = 3 }
}

--local f = CreateFrame("Frame")
--f:SetSize(500, 500)
--f:SetBackdrop(PaneBackdrop)

--f:SetPoint("CENTER")
UI.selectedNote = nil
UI.treeInfo = {
	tree = {},
	functions = {},
}
local info = UI.treeInfo

function note:createUI()
	UI.containerFrame = AceGUI:Create("Frame")
	local cf = UI.containerFrame 

	cf:SetTitle("elRaido Notes")
	cf:SetCallback("OnClose", function(w) AceGUI:Release(w) end)
	cf:SetLayout("Fill")

	UI.selectionTree = AceGUI:Create("TreeGroup")
	local st = UI.selectionTree
	st:SetLayout("Flow")
	st:SetTree(UI.treeInfo.tree)

	st:SetCallback("OnGroupSelected", function(container, event, group)
		container:ReleaseChildren()
		if not UI.treeInfo.functions[group] then
			eR.log.error(('Tried selection %s tab in note tree, not found')
				:format(group))
		else
			UI.treeInfo.functions[group](container)
		end
	end)

	cf:AddChild(st)
end


-- NOTES MAIN THING
local function noteSelect(button)
	local noteName = button.noteName
	UI.selectedNote = noteName

	if UI.selectionTree then
		UI.selectionTree:SelectByValue("Notes")
	end

	print( ('Selecting note called %s'):format(noteName) )
end

info.tree[#info.tree + 1] = {
	value = "Notes",
	text = "Notes",
	icon = "Interface\\Icons\\INV_Drink_05",
}

info.functions["Notes"] = function(container)
	local notes, tree = note.para.notes, {}
	local selectedNote = UI.selectedNote

	for k,v in pairs(notes) do 
		local b = AceGUI:Create("InteractiveLabel")
		b:SetCallback("OnClick", noteSelect)
		container:AddChild(b)
		b.noteName = k
		b:SetFullWidth(true)
		--b:SetFont("Fonts\\FRIZQT__.TTF", 12)
		
		b:SetJustifyV("CENTER")

		local icon = ''
		if selectedNote and selectedNote == k then
			icon = eR.constants.TEXTURES.NOTE_FULL_YELLOW
			b:SetColor(unpack(eR.constants.COLORS.PALE_YELLOW))
		else
			icon = eR.constants.TEXTURES.NOTE_FULL_GREY
		end
		b:SetHighlight(eR.constants.TEXTURES.ACE_GUI_HIGHLIGHT)


		b.highlight:SetVertexColor(unpack(eR.constants.COLORS.BLUE_HIGHLIGHT))
		b:SetText( ('|T%s:30|t %s'):format(icon, k))

	end
end

