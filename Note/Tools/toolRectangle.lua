local eR = elRaidoAddon
local note = eR.note
local th = note.toolHandlers
local bps = note.elementBlueprints

th.Rectangle = {
	name = 'Rectangle',
	element = 'rectangle'
}

local tool = th.Rectangle

function tool.onEquip(note)
	-- pass
end

function tool.onDoubleClick(note)
	return tool.onClick(note)
end

function tool.onClick(note)	
	note:createElementAtMouse('rectangle', true) -- second arg is 'save'(bool)
	note:setTool("Selection")
end


