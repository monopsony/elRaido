local eR=elRaidoAddon
local note = eR.note
local bps = note.elementBlueprints
local tUpdate, tDeepCopy = eR.utils.tableUpdate, eR.utils.tableDeepCopy
local tPop = eR.utils.tablePop

local basicAttributes = {
	x = 0,
	y = 0,
	colorR = 1,
	colorG = 1,
	colorB = 1,
	alpha = 1,
	typ = nil,
	w = 50,
	h = 50,
}

local basicElement = {
}

note.activeElements = {}
note.recycledElements = {}
function note:createElement(typ, att, fromPara)
	if not typ then
		eR.log.error('In createElement: No type given.')
		return 
	end
	if not bps[typ] then
		eR.log.error(('In createElement: type %s not found.'):format(typ))
		return 
	end

	local recycledElement = self:fetchRecycledElement(typ)
	local bp, be = bps[typ], basicElement
	local el
	if recycledElement then
		el = recycledElement
		el.frame:Show()
	else
		el = {}
		el.frame = CreateFrame('Frame', nil, self.mainFrame)
		el.frame:SetMovable(true)
		el.frame:SetResizable(true)

		setmetatable(el, {
			__index = function(self, key)
				if bp[key] then return bp[key] end
				if be[key] then return be[key] end
				eR.log.error(
					('Tried accessing element key %s, none found'):format(key))
				return nil
			end
		}) 

		el:init()
	end

	if fromPara then
		el.attributes = att 
	else
		el.attributes = tDeepCopy(basicAttributes)
		tUpdate(el.attributes, bp.extraAttributes)
		tUpdate(el.attributes, att)
	end

	-- initialise element
	el:applyAttributes()


	note.activeElements[#note.activeElements + 1] = el
	return el 
end

function note:fetchRecycledElement(typ)
	if not typ then return end
	for i, v in ipairs(self.recycledElements) do
		if v.attributes.typ == typ then
			local el = tPop(self.recycledElements, i)
			return el
		end
	end
	return nil
end

function note:saveElement(el)
	if (not el) or (not el.attributes) then return end
	local noteName = self.UI.selectedNote
	if (not noteName) or not self.para.notes[noteName] then return end
	local para = self.para.notes[noteName]

	para[#para + 1] = el.attributes
end

function note:createElementsFromPara(noteName)
	if (not noteName) or not self.para.notes[noteName] then return end
	local para = self.para.notes[noteName]
	for k,v in pairs(para) do 
		local typ = v.typ
		if typ then
			self:createElement(typ, v, true)
		end -- end of if typ then
	end -- end of pairs(para)
end

function note:recycleAllElements()
	local n = #self.activeElements
	for i = n, 1, -1 do
		self:recycleElement(i)
	end
end

function note:deleteSelectedElement()
	local i = self.selectedIndex
	if not i then
		eR.log.error('No element selected that can be deleted')
		return
	end
	local noteName = self.UI.selectedNote
	if (not noteName) or not self.para.notes[noteName] then return end
	local para = self.para.notes[noteName]

	tPop(para, i)
	self:recycleElement(i)

end

function note:recycleElement(i)
	local n = #self.activeElements
	if (not i) or (i > n) then return end

	local el = tPop(note.activeElements, i)

	if i == (self.selectedIndex or -1) then self:deselect() end

	self.recycledElements[#self.recycledElements + 1] = el

	el:recycle()
end

function basicElement:setSize(w, h)
	local att = self.attributes
	if w and h then att.w, att.h = w, h end
	w, h = att.w, att.h

	self.frame:SetSize(w, h)
end

function basicElement:setPoint(x, y)
	local att = self.attributes
	if x and y then att.x, att.y = x, y end
	x, y = att.x, att.y

	self.frame:ClearAllPoints()
	self.frame:SetPoint('CENTER', note.mainFrame, 'TOPLEFT', x, y)
end

function basicElement:setAlpha(a)
	if a then self.attributes.alpha = a end
	a = self.attributes.alpha

	self.frame:SetAlpha(a)
end

function basicElement:updateCurrentPosition()
	local x, y = self.frame:GetCenter()
	local xf, yf = note:getMainFramePosition()

	x, y = x - xf, y - yf
	local w, h = note.para.mainFrameWidth, note.para.mainFrameHeight
	x = ((x > w) and w) or ((x < 0) and 0) or x
	y = ((-y > h) and -h) or ((y > 0) and 0) or y

	self:setPoint(x, y)
end

function basicElement:updateCurrentSize()
	local w, h= self.frame:GetSize()
	local wf, hf = note.para.mainFrameWidth, note.para.mainFrameHeight

	w, h = ((w>wf) and wf - 2) or w, ((h>hf) and hf - 2) or h

	self:setSize(w, h)
end

function basicElement:raise()
	self.frame:SetFrameLevel(note.mainFrameClickHandler:GetFrameLevel() + 2)
end

function basicElement:lower()
	self.frame:SetFrameLevel(note.mainFrame:GetFrameLevel() + 1)
end

function basicElement:prepareResize(direction)
	if not direction then return end

	local w, h = self.frame:GetSize()
	local x, y = self.attributes.x, self.attributes.y
	local f = self.frame
	local oppPoint = eR.constants.OPP_POINTS[direction]
	f:ClearAllPoints()

 	if direction == 'TOPLEFT' then
 		f:SetPoint(oppPoint, note.mainFrame, 'TOPLEFT', x + w/2, y - h/2)
  	elseif direction == 'TOPRIGHT' then
 		f:SetPoint(oppPoint, note.mainFrame, 'TOPLEFT', x - w/2, y - h/2)
 	elseif direction == 'BOTTOMRIGHT' then
 		f:SetPoint(oppPoint, note.mainFrame, 'TOPLEFT', x - w/2, y + h/2)
 	elseif direction == 'BOTTOMLEFT' then
 		f:SetPoint(oppPoint, note.mainFrame, 'TOPLEFT', x + w/2, y + h/2)
 	end

 	self.frame:StartSizing(direction)
end

function basicElement:toggleEdit()
	-- just replace it in the element_file if needed
	-- baseline many elements are not interactible anyways 
end

function basicElement:recycle()
	self.frame:Hide()
end

function basicElement:doubleClick()
	-- this gets called only when the element doesnt overwrite it
	note.mainFrameClickHandler:Click("LeftButton")
end

function basicElement:shiftClick()
	-- this gets called only when the element doesnt overwrite it
	note.mainFrameClickHandler:Click("LeftButton")
end

function basicElement:rightClick()
	-- this gets called only when the element doesnt overwrite it
	note:deselect()
end