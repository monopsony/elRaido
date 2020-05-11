local eR = elRaidoAddon

eR.note = {
	elementBlueprints = {},
	UI = {},
}

local note = eR.note

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
	ch:SetScript('OnClick', function(ch, ...) note:click(...) end)
	ch:SetScript('OnDoubleClick', function(ch, ...) note:doubleClick(...) end)

	ch:RegisterForClicks("AnyUp")
end

function note:GetMainFramePosition()
	local x, y = self.mainFrame:GetLeft(), self.mainFrame:GetBottom()
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


function note:createSelectionFrame()
	self.selectionFrame = CreateFrame(
		"Button", 'elRaidoNoteSelectionFrame', self.mainFrame)

	local sf = self.selectionFrame
	sf:SetFrameLevel(note.mainFrameClickHandler:GetFrameLevel() + 1)
	eR.utils.applyBorderToFrame(sf)

	sf:RegisterForDrag("LeftButton")
	sf:SetScript("OnDragStart", function(sf) 
		sf.selectedElement.frame:StartMoving() 
	end)
	sf:SetScript("OnDragStop", function(sf) 
		sf.selectedElement.frame:StopMovingOrSizing()
		sf.selectedElement:updateCurrentPosition()
	end)
	sf:SetScript('OnClick', function(sf)
		local el = sf.selectedElement
		if not el then return end
		if el.doubleClick then el:doubleClick() end
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

function note:DisableEdit()
	note.mainFrameClickHandler:Hide()
	for k,v in pairs(note.activeElements) do
		if v.toggleEdit then v:toggleEdit(false) end
	end

	note:Deselect()
	-- makes sure there's no selection frame left 
end

function note:EnableEdit()
	note.mainFrameClickHandler:Show()
	for k,v in pairs(note.activeElements) do
		if v.toggleEdit then v:toggleEdit(true) end
	end

	note.selectionFrame:Show()
end