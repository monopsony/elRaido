local eR = elRaidoAddon
local note = eR.note
local bps = note.element_blueprints

bps.rectangle = {}
local el = bps.rectangle

-- attributes on top of the basic element ones
el.extra_attributes = {
	typ = 'rectangle',
}

function el:Init()
	--[[
	Will be called upon creation
	]]--

	self.frame.texture = self.frame:CreateTexture(nil, "BACKGROUND")
	self.frame.texture:SetAllPoints()
end

function el:ApplyAttributes()
	self:SetPoint()
	self:SetSize()
	self:SetColor()	
end

function el:SetColor(r, g, b)
	--[[
	Sets the color of the element. Here: changes color of .texture only.
	If c is given, changes the element attributes and then sets the color. If 
	omitted, the color is set to the color as given by the attribute.

	Args:
		c (table) -- Table containing .r .g .b values.
	]]--

	local att = self.attributes
	if r and g and b then
		att.color_r, att.color_g, att.color_b = r, g, b
	end
	local r, g, b = att.color_r, att.color_g, att.color_b


	self.frame.texture:SetColorTexture(r, b, g)
end
