local eR = elRaidoAddon
local note = eR.note
local th = note.toolHandlers
local bps = note.elementBlueprints

th.Text = {
	name = 'Text',
	element = 'text'
}

local tool = th.Text

function tool.onEquip(note)
	-- pass
end

function tool.onDoubleClick(note)
	return tool.onClick(note)
end

function tool.onClick(note)	
	note:createElementAtMouse('text', true) -- second arg is 'save'(bool)
	note:setTool("Selection")
end


