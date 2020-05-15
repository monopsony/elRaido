local eR = elRaidoAddon
local note = eR.note
local th = note.toolHandlers

th.Selection = {
	name = 'Selection',
}

local tool = th.Selection

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


th.TEST = {name = "TEST"}