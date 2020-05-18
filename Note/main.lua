local eR = elRaidoAddon

eR.note = {
	elementBlueprints = {},
	UI = {},
	shownNote = nil,
}

local note = eR.note
local frameBackdrop  = {
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true, tileSize = 16, edgeSize = 16,
	insets = { left = 3, right = 3, top = 5, bottom = 3 }
}

function note:createMainFrame()
	-- Create basic note frame (toad)
	note.mainFrame = CreateFrame('Frame', 'elRaidoNoteMainFrame', UIParent)


	note.mainFrame:SetSize(self.para.mainFrameWidth, self.para.mainFrameHeight)
	note.mainFrame:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 250, 500)
	note.mainFrame:SetClipsChildren(true)

	local mf = note.mainFrame
	mf.texture = mf:CreateTexture(nil, "BACKGROUND")
	mf.texture:SetColorTexture(0, 0, 0, 0.2)
	mf.texture:SetAllPoints()


	-- add clicker 
	note.mainFrameClickHandler = CreateFrame('Button', 
		'elRaidoMainFrameClickHandler', note.mainFrame)
	local ch = note.mainFrameClickHandler
	ch:SetAllPoints()
	ch:SetFrameLevel(note.mainFrame:GetFrameLevel() + 10)
	ch:SetScript('OnClick', function(ch, ...) 
		if IsShiftKeyDown() then
			note:shiftClick(...)
		else
			note:click(...) 
		end
	end)
	ch:SetScript('OnDoubleClick', function(ch, ...) note:doubleClick(...) end)

	ch:RegisterForClicks("AnyUp")

	mf.border = CreateFrame('Frame', 'elRaidoNoteMainFrameBorder', mf)
	mf.border:SetAllPoints()
	mf.border:SetBackdrop(frameBackdrop)
	mf.border:Hide()

	--note:createToolbox()
end

function note:getMainFramePosition()
	local x, y = self.mainFrame:GetLeft(), self.mainFrame:GetTop()
	return x, y
end

local function sizerOnDragStart(sizer)
	local direction = sizer.direction
	local sf = sizer.parent

	local el = sf.selectedElement
	el:prepareResize(direction)
end

local function sizerOnDragStop(sizer)
	local direction = sizer.direction
	local sf = sizer.parent

	local el = sf.selectedElement
	el.frame:StopMovingOrSizing()
	el:updateCurrentPosition()
	el:updateCurrentSize()
end

function note:showNote(noteName)
	self.shownNote = noteName
	self:recycleAllElements()

	if self.shownNote then
		self:createElementsFromPara(noteName)
	end
end

function note:createSelectionFrame()
	self.selectionFrame = CreateFrame(
		"Button", 'elRaidoNoteSelectionFrame', self.mainFrame)

	local sf = self.selectionFrame
	sf:SetFrameLevel(note.mainFrameClickHandler:GetFrameLevel() + 1)
	eR.utils.applyBorderToFrame(sf)

	sf:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	sf:RegisterForDrag("LeftButton")
	sf:SetScript("OnDragStart", function(sf) 
		sf.selectedElement.frame:StartMoving() 
	end)
	sf:SetScript("OnDragStop", function(sf) 
		sf.selectedElement.frame:StopMovingOrSizing()
		sf.selectedElement:updateCurrentPosition()
	end)
	sf:SetScript('OnClick', function(sf, button,a,b,c)
		local el = sf.selectedElement
		if not el then return end

		if button == 'RightButton' then 
			if el.rightClick then el.rightClick() end
			return
		elseif button == 'LeftButton' then
			if IsShiftKeyDown() and el.shiftClick then 
				el.shiftClick()
			elseif el.doubleClick then 
				el:doubleClick() 
			end
			return	
		end

	end)


	-- SIZERS
	sf.sizers = {}

	for k,v in ipairs(eR.constants.POINTS) do
		local name = ('elRaidoNoteSelectionFrame%ssizer'):format(v)
		sf.sizers[v] = CreateFrame('Frame', name, sf)
		local sizer = sf.sizers[v]
		sizer:SetPoint(v)
		sizer:SetSize(5, 5)
		sizer:RegisterForDrag("LeftButton")
		sizer:EnableMouse(true)
		sizer.parent = sf
		sizer.direction = v

		-- sizer texture
		sizer.texture = sizer:CreateTexture(nil, "OVERLAY")
		sizer.texture:SetAllPoints()
		sizer.texture:SetColorTexture(1,1,1)

		sizer:SetScript("OnDragStart", sizerOnDragStart)
		sizer:SetScript("OnDragStop", sizerOnDragStop)
	end
end

function note:disableEdit()
	note.mainFrameClickHandler:Hide()
	for k,v in pairs(note.activeElements) do
		if v.toggleEdit then v:toggleEdit(false) end
	end

	note:deselect()
	note.mainFrame.border:Hide()
	-- makes sure there's no selection frame left 
end

function note:enableEdit()
	note.mainFrameClickHandler:Show()
	for k,v in pairs(note.activeElements) do
		if v.toggleEdit then v:toggleEdit(true) end
	end

	note.selectionFrame:Show()
	note.mainFrame.border:Show()
	note:attachToOptionsFrame()
end

function note:resetPosition()
	note.mainFrame:ClearAllPoints()
	-- toad
end

function note:attachToOptionsFrame()
	if note.UI.optionsFrame then 
		note.mainFrame:ClearAllPoints()
		local frame = note.UI.optionsFrame.frame
		note.mainFrame:SetPoint("TOPLEFT", frame, "TOPRIGHT")
	end
end