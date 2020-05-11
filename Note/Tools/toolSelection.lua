local eR = elRaidoAddon
local note = eR.note
local th = note.toolHandlers

th.selection = {
	name = 'selection',
}

local tool = th.selection

function tool.onEquip(note)
	print('tool equip')
end

function tool.onDoubleClick(note)
	return tool.onClick(note)
end

function tool.onClick(note)
	local index, el = note:findMouseoverElement()
	if (not index) then return end

	note:select(index)
end