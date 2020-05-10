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

note.active_elements = {}
note.binned_elements = {}
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
	el.frame:SetMovable(true)
	el.frame:SetResizable(true)
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

	note.active_elements[#note.active_elements + 1] = el

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

function basic_element:SetAlpha(a)
	if a then self.attributes.alpha = a end
	a = self.attributes.alpha

	self.frame:SetAlpha(a)
end

function basic_element:UpdateCurrentPosition()
	local x, y = self.frame:GetCenter()
	local xf, yf = note:GetMainFramePosition()

	x, y = x - xf, y - yf
	local w, h = note.para.main_frame_w, note.para.main_frame_h
	x = ((x > w) and w) or ((x < 0) and 0) or x
	y = ((y > h) and h) or ((y < 0) and 0) or y

	self:SetPoint(x, y)
end

function basic_element:UpdateCurrentSize()
	local w, h= self.frame:GetSize()
	local wf, hf = note.para.main_frame_w, note.para.main_frame_h

	w, h = ((w>wf) and wf - 2) or w, ((h>hf) and hf - 2) or h

	self:SetSize(w, h)
end

function basic_element:Raise()
	self.frame:SetFrameLevel(note.main_frame_click_handler:GetFrameLevel() + 2)
end

function basic_element:Lower()
	self.frame:SetFrameLevel(note.main_frame:GetFrameLevel() + 1)
end

function basic_element:PrepareResize(direction)
	if not direction then return end

	local w, h = self.frame:GetSize()
	local x, y = self.attributes.x, self.attributes.y
	local f = self.frame
	local opp_point = eR.constants.OPP_POINTS[direction]
	f:ClearAllPoints()

 	if direction == 'TOPLEFT' then
 		f:SetPoint(opp_point, note.main_frame, 'BOTTOMLEFT', x + w/2, y - h/2)
  	elseif direction == 'TOPRIGHT' then
 		f:SetPoint(opp_point, note.main_frame, 'BOTTOMLEFT', x - w/2, y - h/2)
 	elseif direction == 'BOTTOMRIGHT' then
 		f:SetPoint(opp_point, note.main_frame, 'BOTTOMLEFT', x - w/2, y + h/2)
 	elseif direction == 'BOTTOMLEFT' then
 		f:SetPoint(opp_point, note.main_frame, 'BOTTOMLEFT', x + w/2, y + h/2)
 	end

 	self.frame:StartSizing(direction)
end

