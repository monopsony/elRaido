local eR = elRaidoAddon

eR.note = {
	element_blueprints = {},
}

local note = eR.note

function note:create_main_frame()
	-- Create basic note frame (toad)
	note.main_frame = CreateFrame('Frame', 'elRaidoNoteMainFrame', UIParent)


	note.main_frame:SetSize(self.para.main_frame_w, self.para.main_frame_h)
	note.main_frame:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 250, 500)
	note.main_frame:SetClipsChildren(true)

	local mf = note.main_frame
	mf.texture = mf:CreateTexture(nil, "BACKGROUND")
	mf.texture:SetColorTexture(0, 0, 0, 0.2)
	mf.texture:SetAllPoints()


	-- add clicker 
	note.main_frame_click_handler = CreateFrame('Button', 
		'elRaidoMainFrameClickHandler', note.main_frame)
	local ch = note.main_frame_click_handler
	ch:SetAllPoints()
	ch:SetFrameLevel(note.main_frame:GetFrameLevel() + 10)
	ch:SetScript('OnClick', function(ch, ...) note:Click(...) end)
	ch:SetScript('OnDoubleClick', function(ch, ...) note:DoubleClick(...) end)

	ch:RegisterForClicks("AnyUp")
end


function note:GetMainFramePosition()
	local x, y = self.main_frame:GetLeft(), self.main_frame:GetBottom()
	return x, y
end

local function sizer_OnDragStart(sizer)
	local direction = sizer.direction
	local sf = sizer.parent

	local el = sf.selected_element
	el:PrepareResize(direction)
end

local function sizer_OnDragStop(sizer)
	local direction = sizer.direction
	local sf = sizer.parent

	local el = sf.selected_element
	el.frame:StopMovingOrSizing()
	el:UpdateCurrentPosition()
	el:UpdateCurrentSize()
end


function note:create_selection_frame()
	self.selection_frame = CreateFrame(
		"Button", 'elRaidoNoteSelectionFrame', self.main_frame)

	local sf = self.selection_frame
	sf:SetFrameLevel(note.main_frame_click_handler:GetFrameLevel() + 1)
	eR.utils.apply_border_to_frame(sf)

	sf:RegisterForDrag("LeftButton")
	sf:SetScript("OnDragStart", function(sf) 
		sf.selected_element.frame:StartMoving() 
	end)
	sf:SetScript("OnDragStop", function(sf) 
		sf.selected_element.frame:StopMovingOrSizing()
		sf.selected_element:UpdateCurrentPosition()
	end)
	sf:SetScript('OnClick', function(sf)
		local el = sf.selected_element
		if not el then return end
		if el.DoubleClick then el:DoubleClick() end
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

		sizer:SetScript("OnDragStart", sizer_OnDragStart)
		sizer:SetScript("OnDragStop", sizer_OnDragStop)
	end

end

