local eR=elRaidoAddon
local LSM=LibStub:GetLibrary("LibSharedMedia-3.0")
local unpack,ipairs,pairs,wipe=unpack,ipairs,pairs,table.wipe


-- DEFINE CONSTANTS HERE 

eR.constants = {}
local const = eR.constants
const.COLORS = {
	PALE_YELLOW = {1, .96, .41},
	BLUE_HIGHLIGHT = {0.2, 0.4, 0.8},
}

const.TEXTURES = {
	GREY_HIGHLIGHT = "Interface\\Buttons\\UI-Listbox-Highlight2",
	YELLOW_HIGHLIGHT = "Interface\\Buttons\\UI-Listbox-Highlight",
	BLUE_MOUSE_HIGHLIGHT = "Interface\\Buttons\\UI-Common-MouseHilight",
	THIN_BLUE_HIGHLIGHT = "Interface\\Buttons\\UI-SILVER-BUTTON-HIGHLIGHT",

	ACE_GUI_HIGHLIGHT = "Interface\\QUESTFRAME\\UI-QuestLogTitleHighlight",

	BLUE_GRADIENT_FADED = "Interface\\Buttons\\BlueGrad64_faded",
	BLUE_GRADIENT = "Interface\\Buttons\\BLUEGRAD64",	

	NOTE_FULL_YELLOW = "Interface\\Buttons\\UI-GuildButton-PublicNote-Up",
	NOTE_FULL_GREY = "Interface\\Buttons\\UI-GuildButton-PublicNote-Disabled",
}

const.POINTS = {
	"RIGHT",
	"TOPRIGHT",
	"TOP",
	"TOPLEFT",
	"LEFT",
	"BOTTOMLEFT",
	"BOTTOM",
	"BOTTOMRIGHT"
}

const.OPP_POINTS = {
	RIGHT = "LEFT",
	TOPRIGHT = "BOTTOMLEFT",
	TOP = "BOTTOM",
	TOPLEFT = "BOTTOMRIGHT",
	LEFT = "RIGHT",
	BOTTOMLEFT = "TOPRIGHT",
	BOTTOM = "TOP",
	BOTTOMRIGHT = "TOPLEFT"
}
-- DEFINE UTILITY FUNCTIONS HERE

eR.utils = {}
local utils = eR.utils

function utils.tableDeepCopy(ori)
	--[[
	Returns a deep copy of a given table
	From: http://lua-users.org/wiki/CopyTable
	]]--

	local oriType = type(ori)
	local copy
	if oriType == 'table' then
		copy = {}
		for oriKey, oriValue in next, ori, nil do
			copy[utils.tableDeepCopy(oriKey)] = utils.tableDeepCopy(oriValue)
		end
		
	else -- number, string, boolean, etc
		copy = ori
	end
	return copy
end

function utils.tableUpdate(ori, new)
	--[[
	Adds all non-table elements of table 'new' to table 'ori' 
	Function works inplace but also returns ori for simplicity
	]]--

	for k,v in pairs(new) do
		if not (type(v) == 'table') then
			ori[k] = v
		end
	end

	return ori
end

function utils.applyBorderToFrame(frame, width, r, g, b)
	if not frame then return end
	local w, r, g, b = width or 2, r or 1, g or 1, b or 1
	local new = false
	if not frame.borders then new = true end

	frame.borders = frame.borders or {}
	local bos = frame.borders

	if new then bos['RIGHT'] = frame:CreateTexture(nil, "BACKGROUND")
	else bos['RIGHT']:ClearAllPoints() end
	bos['RIGHT']:SetPoint('BOTTOMLEFT', frame, 'BOTTOMRIGHT')
	bos['RIGHT']:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', w, w)


	if new then bos['TOP'] = frame:CreateTexture(nil, "BACKGROUND")
	else bos['TOP']:ClearAllPoints() end	
	bos['TOP']:SetPoint('BOTTOMRIGHT', frame, 'TOPRIGHT')
	bos['TOP']:SetPoint('TOPLEFT', frame, 'TOPLEFT', -w, w)


	if new then bos['LEFT'] = frame:CreateTexture(nil, "BACKGROUND")
	else bos['LEFT']:ClearAllPoints() end	
	bos['LEFT']:SetPoint('TOPRIGHT', frame, 'TOPLEFT')
	bos['LEFT']:SetPoint('BOTTOMLEFT', frame, 'BOTTOMLEFT', -w, -w)


	if new then bos['BOTTOM'] = frame:CreateTexture(nil, "BACKGROUND")
	else bos['BOTTOM']:ClearAllPoints() end	
	bos['BOTTOM']:SetPoint('TOPLEFT', frame, 'BOTTOMLEFT')
	bos['BOTTOM']:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', w, -w)

	for k,v in pairs(bos) do
		v:SetColorTexture(r, g, b)
	end

	frame.showHideBorder = utils.showHideBorder
	print('finished applying')
end	

function utils:showHideBorder(boo)
	if not self.borders then return end
	for k,v in pairs(self.borders) do
		if boo then v:Show() else v:Hide() end
	end
end

function utils.tablePop(tbl, i)
	if (not tbl) then return end
	local n = #tbl
	if i > n then return end

	local el = tbl[i]

	for j = i+1, n do
		tbl[j-1] = tbl[j]
	end
	tbl[n] = nil

	return el
end

-- DEFINE LOG BASED THINGS

eR.log = {}
local log = eR.log

function log.error(s)
	print(('Error: %s'):format(s))
end

local keyMessages = {
	help = 'This is the help message',
}

function log.userMessage(s)
	if not s then return end
	local msg

	if keyMessages[s] then
		msg = keyMessages[s]
	else
		msg = s
	end
	print(('elRaido: %s'):format(msg))
end

