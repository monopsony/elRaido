local eR = elRaidoAddon
local note = eR.note
local bps = note.elementBlueprints

bps.text = {}
local el = bps.text

-- attributes on top of the basic element ones
el.extraAttributes = {
	typ = 'text',
	fontsize = 12,
	font = "Fonts\\FRIZQT__.TTF",
	text = '',
}

function el:init()
	--[[
	Will be called upon creation
	]]--

	self.frame.bg = self.frame:CreateTexture(nil, "BACKGROUND")
	self.frame.bg:SetAllPoints()

	self.frame.text = CreateFrame("EditBox", nil, self.frame)
	self.frame.text:SetMultiLine(true)
	self.frame.text:SetAllPoints()
	self.frame.text:SetAutoFocus(false)
	self.frame.text.parent = self

	-- set events
	local text = self.frame.text
	text:SetScript('OnEnterPressed', function(text)
		local shift = IsShiftKeyDown()
		if shift then 
			text:Insert('\n')
		else
			text.parent:setDisplayMode()
		end
	end)

	text:SetScript('OnEscapePressed', function(text)
		-- setDisplayMode will trigger a OnEditFocusLost
		-- Which saves the text
		-- So you first need to reset it
		text:SetText(text.parent.textPrevious)

		text.parent:setDisplayMode()
	end)

	text:SetScript('OnEditFocusGained', function(text)
		text.parent:setEditMode()
	end)

	text:SetScript('OnEditFocusLost', function(text)
		text.parent:saveText()
		text.parent:setDisplayMode()
	end)
end

function el:clearFocus()
	self.frame.text:ClearFocus()
end

function el:applyAttributes()
	self:setPoint()
	self:setSize()
	self:setFont()
	self:setText()
	self:applyBackgroundColor()
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

function el:saveText()
	local t = self.frame.text:GetText()
	self.attributes.text = t:gsub('||', '|')
end

function el:setDisplayMode()
	self:clearFocus()
	self:setText()
	self:lower()
end

function el:setEditMode()
	local text = self.attributes.text
	self.textPrevious = text
	self.frame.text:SetText(text:gsub('|', '||'))
	self.frame.text:SetFocus()
	self:raise()
end

function el:toggleEdit(boo)
	self.frame.text:EnableMouse(boo)
end

function el:setText(s)
	if s then self.attributes.text = s end
	s = self.attributes.text 
	self.frame.text:SetText(s)
end

function el:click()
	-- pass
end

function el:doubleClick()
	self:setEditMode()
end


