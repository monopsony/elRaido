local eR = elRaidoAddon
local note = eR.note
local bps = note.elementBlueprints

bps.rectangle = {}
local el = bps.rectangle

-- attributes on top of the basic element ones
el.extraAttributes = {
	typ = 'rectangle',
}

function el:init()
	--[[
	Will be called upon creation
	]]--

	self.frame.texture = self.frame:CreateTexture(nil, "BACKGROUND")
	self.frame.texture:SetAllPoints()
end

function el:applyAttributes()
	self:setPoint()
	self:setSize()
	self:setColor()	
	self:setAlpha()

	
end

function el:setColor(r, g, b)
	--[[
	Sets the color of the element. Here: changes color of .texture only.
	If c is given, changes the element attributes and then sets the color. If 
	omitted, the color is set to the color as given by the attribute.

	Args:
		c (table) -- Table containing .r .g .b values.
	]]--

	local att = self.attributes
	if r and g and b then
		att.colorR, att.colorG, att.colorB = r, g, b
	end
	local r, g, b = att.colorR, att.colorG, att.colorB


	self.frame.texture:SetColorTexture(r, g, b)
end

