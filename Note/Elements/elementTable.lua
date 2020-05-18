local eR = elRaidoAddon
local note = eR.note
local bps = note.elementBlueprints
local fEdit, fDisplay = eR.utils.textFormatEdit, eR.utils.textFormatDisplay

bps.table = {}
local el = bps.table

-- attributes on top of the basic element ones
el.extraAttributes = {
	typ = 'table',
	fontsize = 12,
	font = "Fonts\\FRIZQT__.TTF",
	text = '',
	nRows = 4,
	nCols = 4,
	rowHeights = {25, 25, 25, 25},
	colWidths = {50, 50, 50, 50},
	spacing = 2,
	lineR = 0,
	lineG = 0,
	lineB = 0,
	lineA = 1,
	col1 = {},
	col2 = {},
	col3 = {},
	col4 = {},
}

function el:init()
	--[[
	Will be called upon creation
	]]--

	self.frame.bg = self.frame:CreateTexture(nil, "BACKGROUND")
	self.frame.bg:SetAllPoints()
	self.frame:SetClipsChildren(true)

	self.frame.vLines = {}
	self.frame.hLines = {}
	self.cells = {}

	--self.frame.text = CreateFrame("EditBox", nil, self.frame)
	--self.frame.text:SetMultiLine(true)
	--self.frame.text:SetAllPoints()
	--self.frame.text:SetAutoFocus(false)
	--self.frame.text.parent = self

	---- set events
	--local text = self.frame.text
	--text:SetScript('OnEnterPressed', function(text)
	--	local shift = IsShiftKeyDown()
	--	if shift then 
	--		text:Insert('\n')
	--	else
	--		text.parent:setDisplayMode()
	--	end
	--end)

	--text:SetScript('OnEscapePressed', function(text)
	--	-- setDisplayMode will trigger a OnEditFocusLost
	--	-- Which saves the text
	--	-- So you first need to reset it
	--	text:SetText(text.parent.textPrevious)

	--	text.parent:setDisplayMode()
	--end)

	--text:SetScript('OnEditFocusGained', function(text)
	--	text.parent:setEditMode()
	--end)

	--text:SetScript('OnEditFocusLost', function(text)
	--	text.parent:saveText()
	--	text.parent:setDisplayMode()
	--end)
end

function el:createNewLine(vertical)
	local f = CreateFrame("Frame", nil, self.frame)
	if vertical then
		f:SetHeight(10000)
	else
		f:SetWidth(10000)
	end

	f.bg = f:CreateTexture(nil, "BACKGROUND")
	f.bg:SetAllPoints()

	return f
end

function el:createGrid()
	local h, w = self.attributes.rowHeights, self.attributes.colWidths
	local nRows, nCols = self.attributes.nRows, self.attributes.nCols
	local att = self.attributes
	local r, g, b, a = att.lineR, att.lineG, att.lineB, att.lineA

	-- create vertical lines
	local t = self.frame.vLines
	for i = 1, nRows do 
		-- create it if it doesnt exist
		if not t[i] then
			t[i] = self:createNewLine(true)
		end

		if not att.colWidths[i] then att.colWidths[i] = 50 end
		local w, anchor = att.colWidths[i], nil
		t[i]:Show()
		t[i]:ClearAllPoints()
		t[i]:SetWidth(att.spacing)
		t[i].bg:SetColorTexture(r, g, b, a)
		if i == 1 then anchor = self.frame else anchor = t[i-1] end
		t[i]:SetPoint("TOPLEFT", anchor, "TOPLEFT", w, 0)
	end -- end of for nRows


	-- create horizontal lines
	local t = self.frame.hLines
	for i = 1, nCols do 
		-- create it if it doesnt exist
		if not t[i] then
			t[i] = self:createNewLine(false)
		end

		if not att.rowHeights[i] then att.rowHeights[i] = 20 end
		local h, anchor = att.rowHeights[i], nil
		t[i]:Show()
		t[i]:ClearAllPoints()
		t[i]:SetHeight(att.spacing)
		t[i].bg:SetColorTexture(r, g, b, a)
		if i == 1 then anchor = self.frame else anchor = t[i-1] end
		t[i]:SetPoint("TOPLEFT", anchor, "TOPLEFT", 0, -h)
	end -- end of for nRows
end


function el:createCells()
	local nRows, nCols = self.attributes.nRows, self.attributes.nCols

	for i = 1, nRows do 
		if not self.cells[i] then self.cells[i] = {} end

		for j = 1, nCols do 
			if not self.cells[i][j] then el:createCell(i, j) end
			local c = self.cells[i][j]

		end
	end
	-- 
end

local function raise(self)

	self:SetFrameLevel(note.mainFrameClickHandler:GetFrameLevel() + 2)
end

local function lower(self)

	self:SetFrameLevel(note.mainFrame:GetFrameLevel() + 1)
end

local function clearFocus(self)
	-- pass
	self:ClearFocus()
end

local function setEditMode(self)
	local text = self.attributes.text
	self.textPrevious = text or ''
	self.frame.text:SetText(fEdit(text))
	self.frame.text:SetFocus()
	self:raise()
end

local function setDisplayMode(self)
	self:clearFocus()
	self.parent:updateCell(self.i, self.j)
	self:lower()
end

function el:createCell(i, j)
	local f = CreateFrame("EditBox", nil, self.frame)
	f:SetMultiLine(true)
	f:SetAutoFocus(false)
	f.parent = self
	f.i = i
	f.j = j
	f.raise = raise
	f.lower = lower
	f.clearFocus = clearFocus
	f.setEditMode = setEditMode
	f.setDisplayMode = setDisplayMode

	-- set events
	f:SetScript('OnEnterPressed', function(f)
		local shift = IsShiftKeyDown()
		if shift then 
			f:Insert('\n')
		else
			f:setDisplayMode()
		end
	end)

	f:SetScript('OnEscapePressed', function(f)
		-- setDisplayMode will trigger a OnEditFocusLost
		-- Which saves the text
		-- So you first need to reset it
		f:SetText(f.textPrevious)

		f:setDisplayMode()
	end)

	f:SetScript('OnEditFocusGained', function(f)
		f:setEditMode()
	end)

	f:SetScript('OnEditFocusLost', function(f)
		local i, j = f.i, f.j
		f:saveCell()
		f:setDisplayMode()
	end)	

end

function el:updateCell(i, j)
	local cell = self.cells[i][j]
	local col = ('col%s'):format(j)
	local s = self.attributes[col][i]
	cell:SetText(s)
end

function el:saveCell(i, j)
	local cell = self.cells[i][j]
	local col = ('col%s'):format(j)
	local s = cell:GetText()
	self.attributes[col][i] = fDisplay(t)
end

function el:clearFocus()
	self.frame.text:ClearFocus()
end

function el:applyAttributes()
	self:setPoint()
	self:setSize()
	self:applyBackgroundColor()
	self:createGrid()
	self:createCells()
end

function el:setFont(font, size)
	local att = self.attributes
	if font and size then 
		att.font, att.fontsize = font, size
	end
	font, size = att.font, att.fontsize

	self.frame.text:SetFont(font, size)
end

function el:setColor(r, g, b, a)
	local att = self.attributes
	if r and g and b then
		att.colorR = r
		att.colorG = g
		att.colorB = b
	end

	self:applyBackgroundColor()
end

function el:applyBackgroundColor()
	local att = self.attributes
	local r = att.colorR
	local g = att.colorG
	local b = att.colorB
	local a = att.alpha
	self.frame.bg:SetColorTexture(r, g, b, a)
end

function el:setAlpha(a)
	if a then self.attributes.alpha = a end
	self:applyBackgroundColor()
end


function el:setDisplayMode()
	print('table set display mode')
end

function el:setEditMode()
	print('table set edit mode')
end

function el:toggleEdit(boo)
	-- pass
end

function el:click()
	-- pass
end

function el:doubleClick()
	-- pass
end


