local eR=elRaidoAddon
local note = eR.note
local bps = note.elementBlueprints
local tUpdate, tDeepCopy = eR.utils.tableUpdate, eR.utils.tableDeepCopy

note.toolHandlers = {}

note.toolParas = {
	colorR = 0,
	colorG = 0,
	colorB = 0,
	alpha = 0.5,
}

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
	self.UI.refreshNotesWindow()
	if tool ~= 'Selection' then self:deselect() end
	if note.tool.onEquip then note.tool.onEquip(note) end
end

function note:getCursorRelativePos()
	local scale = UIParent:GetScale()
	local x, y = GetCursorPosition()
	x, y = x/scale, y/scale
	local xf, yf = self:getMainFramePosition()
	local xr, yr = x - xf, y - yf
	return xr, yr
end

function note:click(button, down)
	local tool = self.tool
	if button == 'RightButton' then
		self:setTool('Selection')
		return
	end
	if not tool then eR.log.error('No tool equipped, how?'); return end


	if self.tool.onClick and button == 'LeftButton' then 
		self.tool.onClick(note)
	--elseif self.tool.OnRightClick and button == 'RightButton' then 
	--	self.tool.OnRightClick(note)
	end
end

function note:shiftClick(button, down)
	local tool = self.tool
	if not tool then eR.log.error('No tool equipped, how?'); return end

	if self.tool.onShiftClick and button == 'LeftButton' then
		self.tool.onShiftClick(note)
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
function note:findMouseoverElement(reverse)

	if reverse then
		local n = #self.activeElements
		for i = n, 1, -1 do
			local v = self.activeElements[i]
			if MouseIsOver(v.frame) then
				return i,v
			end
		end

	else

		for k,v in ipairs(self.activeElements) do
			if MouseIsOver(v.frame) then
				return k,v
			end
		end
	end

	return nil, nil
end

function note:select(i)
	print('selecting element',i)
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
	self.selectedElement = el

	local selFrame = self.selectionFrame
	selFrame.selectedIndex = i
	selFrame.selectedElement = el
	selFrame:ClearAllPoints()
	selFrame:SetPoint('TOPLEFT', el.frame, 'TOPLEFT')
	selFrame:SetPoint('BOTTOMRIGHT', el.frame, 'BOTTOMRIGHT')

	note:applySelectionToToolParas()
end

function note:deselect()
	local selFrame = self.selectionFrame
	if (not self.selectedIndex) or (not self.selectedElement) then return end
	self.selectedIndex = nil
	self.selectedElement = nil
	selFrame.selectedIndex = nil
	selFrame.selectedElement = nil
	selFrame:ClearAllPoints()
	selFrame:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', -10, 0)
	selFrame:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMLEFT', -10, 0)
	-- puts it out of screen
	-- dont ask me why ClearAllPoints doesnt work on its own
end

local tUpdate = eR.utils.tableUpdate
function note:createElementAtMouse(typ, save)
	if (not typ) then return end
	local x, y = self:getCursorRelativePos()
	local att = {x = x, y = y}
	local att2 = note.toolParas
	tUpdate(att, att2)
	local el = self:createElement(typ, att)
	if save then self:saveElement(el) end
end

function note:applySelectionToToolParas()
	local el = self.selectedElement
	if not el then return end
	local att = el.attributes
	local para = self.toolParas

	-- color
	para.colorR, para.colorB, para.colorG = att.colorR, att.colorB, att.colorG
	para.alpha = att.alpha

	self.UI.refreshNotesWindow()
end

function note:applySelectionAttributeChange()
	local el = self.selectedElement
	if not el then return end
	local att = el.attributes
	local para = self.toolParas

	tUpdate(el.attributes, para)
	el:applyAttributes()
end