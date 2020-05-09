local eR = elRaidoAddon

eR.note = {
	element_blueprints = {},
}

local note = eR.note


-- Create basic note frame (toad)
note.main_frame = CreateFrame('Frame', 'elRaidoNoteMainFrame', UIParent)
note.main_frame:SetSize(500, 500)
note.main_frame:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', 250, -250)

local mf = note.main_frame
mf.texture = mf:CreateTexture(nil, "BACKGROUND")
mf.texture:SetColorTexture(0, 0, 0, 0.2)
mf.texture:SetAllPoints()

mf:Show()