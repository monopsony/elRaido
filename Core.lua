elRaidoAddon=LibStub("AceAddon-3.0"):NewAddon("elRaidoAddon","AceConsole-3.0",
	"AceComm-3.0","AceEvent-3.0","AceSerializer-3.0")
local eR=elRaidoAddon
local unpack, ipairs, pairs, wipe=unpack, ipairs, pairs, table.wipe

eR.version='0.1'

local default_profile={
	profile={
		note = {
			main_frame_w = 500,
			main_frame_h = 500,
		},

	},-- end of profile
}--end of default



function eR:OnInitialize()
	self.db=LibStub("AceDB-3.0"):New("elRaidoAddonDB", default_profile, true) 
	--true sets the default profile to a profile called "Default"
	--see https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0
	
	self.para = self.db.profile
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")


	-- note
	self.note.para = self.para.note
	self.note:create_main_frame()
	self.note:create_selection_frame()
end


local chat_commands={
	["help"]=function(self, msg)
		eR.log.user_message("help")
	end,

	["metatable"]={__index=function(self,key) return self["help"] end},
}
setmetatable(chat_commands,chat_commands.metatable)


function eR:chat_command_handler(msg)
	local key=self:GetArgs(msg,1)
	if (not key) or (key=='metatable') then chat_commands["help"]() 
	else chat_commands[key](self,msg) end
end
eR:RegisterChatCommand("elraido","chat_command_handler")

function eR:RefreshConfig()
	ReloadUI()
end

function eR:OnEnable()
	-- pass		
end

local event_frame=CreateFrame('Frame','elRaidoGlobalEventFrame',UIParent)
local registered_events={'PLAYER_ENTERING_WORLD'}
for k,v in pairs(registered_events) do event_frame:RegisterEvent(v) end
function event_frame:handle_event(event,...)
	-- handle main events here
end
event_frame:SetScript('OnEvent',event_frame.handle_event)

