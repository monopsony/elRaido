local eR = elRaidoAddon
local note = eR.note
local bps = note.element_blueprints

bps.text = {}
local el = bps.text

-- attributes on top of the basic element ones
el.extra_attributes = {
	typ = 'text',
	fontsize = 12,
	font = "Fonts\\FRIZQT__.TTF",
	text = '',
}

function el:Init()
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
			text.parent:SetDisplayMode()
		end
	end)

	text:SetScript('OnEscapePressed', function(text)
		-- SetDisplayMode will trigger a OnEditFocusLost
		-- Which saves the text
		-- So you first need to reset it
		text:SetText(text.parent.text_previous)

		text.parent:SetDisplayMode()
	end)

	text:SetScript('OnEditFocusGained', function(text)
		text.parent:SetEditMode()
	end)

	text:SetScript('OnEditFocusLost', function(text)
		text.parent:SaveText()
		text.parent:SetDisplayMode()
	end)
end

function el:ClearFocus()
	self.frame.text:ClearFocus()
end

function el:ApplyAttributes()
	self:SetPoint()
	self:SetSize()
	self:SetFont()
	self:SetText()
	self:_ApplyBackgroundColor()
end

function el:SetFont(font, size)
	local att = self.attributes
	if font and size then 
		att.font, att.fontsize = font, size
	end
	font, size = att.font, att.fontsize

	self.frame.text:SetFont(font, size)
end

function el:SetColor(r, g, b, a)
	local att = self.attributes
	if r and g and b then
		att.color_r = r
		att.color_g = g
		att.color_b = b
	end

	self:_ApplyBackgroundColor()
end

function el:_ApplyBackgroundColor()
	local att = self.attributes
	local r = att.color_r
	local g = att.color_g
	local b = att.color_b
	local a = att.alpha
	self.frame.bg:SetColorTexture(r, g, b, a)
end

function el:SetAlpha(a)
	if a then self.attributes.alpha = a end
	self:_ApplyBackgroundColor()
end

function el:SaveText()
	local t = self.frame.text:GetText()
	self.attributes.text = t:gsub('||', '|')
end

function el:SetDisplayMode()
	self:ClearFocus()
	self:SetText()
	self:Lower()
end

function el:SetEditMode()
	local text = self.attributes.text
	self.text_previous = text
	self.frame.text:SetText(text:gsub('|', '||'))
	self.frame.text:SetFocus()
	self:Raise()
end

function el:SetText(s)
	if s then self.attributes.text = s end
	s = self.attributes.text 
	self.frame.text:SetText(s)
end

function el:Click()
	-- pass
end


function el:DoubleClick()
	self:SetEditMode()
end


