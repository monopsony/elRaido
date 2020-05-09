local eR = elRaidoAddon

eR.note = {
	element_blueprints = {},
}

local note = eR.note


-- Create basic note frame (toad)
note.main_frame = CreateFrame('Frame', 'elRaidoNoteMainFrame', UIParent)
note.main_frame:SetSize(500, 500)
note.main_frame:SetPoint('CENTER')
