local eR=elRaidoAddon
local LSM=LibStub:GetLibrary("LibSharedMedia-3.0")
local unpack,ipairs,pairs,wipe=unpack,ipairs,pairs,table.wipe


-- DEFINE CONSTANTS HERE 

eR.constants = {}
local const = eR.constants
const.colors={
    ["epic"]={0.64,0.21,0.93},
    ["epic_hex"]="136207",
    ['yellow_hex']=''
}

-- DEFINE UTILITY FUNCTIONS HERE

eR.utils = {}
local utils = eR.utils

function utils.table_deepcopy(ori)
	--[[
	Returns a deep copy of a given table
	From: http://lua-users.org/wiki/CopyTable
	]]--

    local ori_type = type(ori)
    local copy
    if ori_type == 'table' then
        copy = {}
        for ori_key, ori_value in next, ori, nil do
            copy[deepcopy(ori_key)] = deepcopy(ori_value)
        end
        setmetatable(copy, deepcopy(getmetatable(ori)))
    else -- number, string, boolean, etc
        copy = ori
    end
    return copy
end

function utils.table_update(ori, new)
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


-- DEFINE LOG BASED THINGS

eR.log = {}
local log = eR.log

function log.error(s)
	print(('Error: %s'):format(s))
end

local key_messages = {
	help = 'This is the help message',
}

function log.user_message(s)
	if not s then return end
	local msg

	if key_messages[s] then
		msg = key_messages[s]
	else
		msg = s
	end
	print(('elRaido: %s'):format(msg))
end