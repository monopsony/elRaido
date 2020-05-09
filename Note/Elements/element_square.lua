local eR = elRaidoAddon
local note = eR.note
local bps = note.element_blueprints

bps.square = {}
local el = bps.square

-- attributes on top of the basic element ones
el.extra_attributes = {

}

function el:init()
	--[[
	Will be called upon creation
	]]--

	-- self.texture = self:CreateTexture(nil, "BACKGROUND")
	-- self.texture:SetAllPoints()
end


function el:SetColor(c)
	--[[
	Sets the color of the element. Here: changes color of .texture only.
	If c is given, changes the element attributes and then sets the color. If 
	omitted, the color is set to the color as given by the attribute.

	Args:
		c (table) -- Table containing .r .g .b values.
	]]--


	if c then self.attributes.c = c end

	local c = self.attributes.c
	local r, b, g, a = c.r, c.b, c.g, c.a or 1
	self:SetColorTexture(r, b, g, a)
end
