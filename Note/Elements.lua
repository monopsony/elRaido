local eR=elRaidoAddon
local note = eR.note
local bps = note.element_blueprints
local t_update, t_deepcopy = eR.utils.table_update, eR.utils.table_deepcopy

local basic_attributes = {
	x = 0,
	y = 0,
	color_r = 1,
	color_g = 1,
	color_b = 1,
	alpha = 1,
	typ = nil,
	w = 20,
	h = 20,
}

local basic_element = {
}

function note:create_element(typ, att)
	if not typ then
		eR.log.error('In create_element: No type given.')
		return 
	end
	if not bps[typ] then
		eR.log.error(('In create_element: type %s not found.'):format(typ))
		return 
	end

	local bp, be = bps[typ], basic_element
	local el = {}
	el.frame = CreateFrame('Frame', nil, self.main_frame)
	el.attributes = t_deepcopy(basic_attributes)
	t_update(el.attributes, bp.extra_attributes)

	setmetatable(el, {
		__index = function(self, key)
			if bp[key] then return bp[key] end
			if be[key] then return be[key] end
			eR.log.error(
				('Tried accessing element key %s, none found'):format(key))
			return nil
		end
	})

	-- fill in attributes given as arg
	if att then t_update(el.attributes, att) end

	-- initialise element
	el:Init()
	el:ApplyAttributes()

	return el 
end


function basic_element:SetSize(w, h)
	local att = self.attributes
	if w and h then att.w, att.h = w, h end
	w, h = att.w, att.h

	self.frame:SetSize(w, h)
end


function basic_element:SetPoint(x, y)
	local att = self.attributes
	if x and y then att.x, att.y = x, y end
	x, y = att.x, att.y

	self.frame:ClearAllPoints()
	self.frame:SetPoint('CENTER', note.main_frame, 'BOTTOMLEFT', x, y)
end