local eR = elRaidoAddon
local note = eR.note
local th = note.tool_handlers

th.selection = {
	name = 'selection',
}

local tool = th.selection

function tool.OnEquip(note)
	print('tool equip')
end

function tool.OnDoubleClick(note)
	return tool.OnClick(note)
end

function tool.OnClick(note)
	local index, el = note:FindMouseoverElement()
	if (not index) then return end

	note:Select(index)
end