local eR = elRaidoAddon
local note = eR.note
local th = note.toolHandlers
local bps = note.elementBlueprints

th.Selection = {
	name = 'Selection',
}

local tool = th.Selection


function tool.onEquip(note)

end

function tool.onClick(note)
	local index, el = note:findMouseoverElement()
	if (not index) then note:deselect(); return end
	note:select(index)
end

function tool.onShiftClick(note)
	local index, el = note:findMouseoverElement(true)
	if (not index) then note:deselect(); return end
	note:select(index)
end
