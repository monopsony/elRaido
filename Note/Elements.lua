local eR=elRaidoAddon
local note = eR.note
local bps = note.element_blueprints

local basic_attributes = {
	X = 0,
	Y = 0,
	c = {r = 1, g = 1, b = 1},
	typ = nil,
}

local basic_element = {

}

local t_update, t_deepcopy = eR.utils.table_update, eR.utils.table_deepcopy
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
	local el = CreateFrame('Frame', nil, self.main_frame)
	el.attributes = t_deepcopy(basic_attributes)
	t_update(el.attributes, bp.extra_attributes)
	 
	setmetatable(el, {
		__index=function(self, key)
			if bp[key] then return bp[key] end
			if be[key] then return be[key] end
			eR.log.error(
				('Tried accessing element key {key}, none found'):format(key))
			return nil
		end
	})

	-- apply attributes given as arg
	if att then t_update(el.attributes, att) end

	return el 
end