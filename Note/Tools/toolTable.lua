local eR = elRaidoAddon
local note = eR.note
local th = note.toolHandlers
local bps = note.elementBlueprints

th.Table = {
	name = 'Table',
	element = 'table'
}

local tool = th.Table

function tool.onEquip(note)
	-- pass
end

function tool.onDoubleClick(note)
	return tool.onClick(note)
end

function tool.onClick(note)	
	note:createElementAtMouse('table', true) -- second arg is 'save'(bool)
	note:setTool("Selection")
end


