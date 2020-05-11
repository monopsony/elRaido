local eR=elRaidoAddon
local note = eR.note
local bps = note.elementBlueprints
local tUpdate, tDeepCopy = eR.utils.tableUpdate, eR.utils.tableDeepCopy

note.toolHandlers = {}

function note:setTool(tool)
	if not tool then
		eR.log.error('Tried to equip tool but nil')
		return
	elseif not self.toolHandlers[tool] then
		eR.log.error(('Tried to equip tool but no handler found for %s tool')
			:format(tool))
		return
	end

	note.tool = note.toolHandlers[tool]

	if note.tool.OnEquip then note.tool.OnEquip(note) end
end

function note:getCursorRelativePos()
	local scale = UIParent:GetScale()
	local x, y = GetCursorPosition()
	x, y = x/scale, y/scale
	local xf, yf = self:GetMainFramePosition()
	local xr, yr = x - xf, y - yf
	return xr, yr
end

function note:click(button, down)
	local tool = self.tool
	if button == 'RightButton' then
		self:setTool('selection')
		return
	end
	if not tool then eR.log.error('No tool equipped, how?'); return end

	if self.tool.onClick and button == 'LeftButton' then 
		self.tool.onClick(note)
	--elseif self.tool.OnRightClick and button == 'RightButton' then 
	--	self.tool.OnRightClick(note)
	end
end

function note:doubleClick(button, down)
	local tool = self.tool
	if not tool then eR.log.error('No tool equipped, how?'); return end

	if self.tool.onDoubleClick and button == 'LeftButton' then
		self.tool.onDoubleClick(note) 
	end
end

local MouseIsOver = MouseIsOver
function note:findMouseoverElement()

	for k,v in ipairs(self.activeElements) do
		if MouseIsOver(v.frame) then
			return k,v
		end
	end

	return nil, nil
end

function note:select(i)
	local i, el = i, nil

	-- is i an index?
	if not (type(i) == "number") then 
		eR.log.error(('Tried selecting element but argument was non int'))
		return 
	end

	el = self.activeElements[i]
	if not el then 
		eR.log.error(('Tried selecting element %i, not found'):format(i))
		return 
	end

	self.selectedIndex = i

	local selFrame = self.selectionFrame
	selFrame.selectedIndex = i
	selFrame.selectedElement = el
	selFrame:ClearAllPoints()
	selFrame:SetPoint('TOPLEFT', el.frame, 'TOPLEFT')
	selFrame:SetPoint('BOTTOMRIGHT', el.frame, 'BOTTOMRIGHT')
end

function note:Deselect()
	local selFrame = self.selectionFrame
	selFrame.selectedIndex = nil
	selFrame.selectedElement = nil
	selFrame:ClearAllPoints()
	selFrame:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', -10, 0)
	selFrame:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMLEFT', -10, 0)
	-- puts it out of screen
	-- dont ask me why ClearAllPoints doesnt work on its own
end