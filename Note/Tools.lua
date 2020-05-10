local eR=elRaidoAddon
local note = eR.note
local bps = note.element_blueprints
local t_update, t_deepcopy = eR.utils.table_update, eR.utils.table_deepcopy

note.tool_handlers = {}

function note:SetTool(tool)
	if not tool then
		eR.log.error('Tried to equip tool but nil')
		return
	elseif not self.tool_handlers[tool] then
		eR.log.error(('Tried to equip tool but no handler found for %s tool')
			:format(tool))
		return
	end

	note.tool = note.tool_handlers[tool]

	if note.tool.OnEquip then note.tool.OnEquip(note) end
end

function note:GetCursorRelativePos()
	local scale = UIParent:GetScale()
	local x, y = GetCursorPosition()
	x, y = x/scale, y/scale
	local xf, yf = self:GetMainFramePosition()
	local xr, yr = x - xf, y - yf
	return xr, yr
end

function note:Click(button, down)
	local tool = self.tool
	if button == 'RightButton' then
		self:SetTool('selection')
		return
	end
	if not tool then eR.log.error('No tool equipped, how?'); return end

	if self.tool.OnClick and button == 'LeftButton' then 
		self.tool.OnClick(note)
	--elseif self.tool.OnRightClick and button == 'RightButton' then 
	--	self.tool.OnRightClick(note)
	end
end

function note:DoubleClick(button, down)
	local tool = self.tool
	if not tool then eR.log.error('No tool equipped, how?'); return end

	if self.tool.OnDoubleClick and button == 'LeftButton' then
		self.tool.OnDoubleClick(note) 
	end
end

local MouseIsOver = MouseIsOver
function note:FindMouseoverElement()

	for k,v in ipairs(self.active_elements) do
		if MouseIsOver(v.frame) then
			return k,v
		end
	end

	return nil, nil
end

function note:Select(i)
	local i, el = i, nil

	-- is i an index?
	if not (type(i) == "number") then 
		eR.log.error(('Tried selecting element but argument was non int'))
		return 
	end

	el = self.active_elements[i]
	if not el then 
		eR.log.error(('Tried selecting element %i, not found'):format(i))
		return 
	end

	self.selected_index = i

	local sel_frame = self.selection_frame
	sel_frame.selected_index = i
	sel_frame.selected_element = el
	sel_frame:ClearAllPoints()
	sel_frame:SetPoint('TOPLEFT', el.frame, 'TOPLEFT')
	sel_frame:SetPoint('BOTTOMRIGHT', el.frame, 'BOTTOMRIGHT')
end