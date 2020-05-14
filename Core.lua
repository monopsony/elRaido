elRaidoAddon=LibStub("AceAddon-3.0"):NewAddon("elRaidoAddon","AceConsole-3.0",
	"AceComm-3.0","AceEvent-3.0","AceSerializer-3.0")
local eR=elRaidoAddon
local unpack, ipairs, pairs, wipe=unpack, ipairs, pairs, table.wipe

eR.version='0.1'

local defaultProfile={
	profile={
		note = {
			mainFrameWidth = 500,
			mainFrameHeight = 500,

			notes = {
				noteTest1 = {
					-- meta info here?
					elements = {

					}, -- end of note.notes.noteTest1.elements
				}, -- end of note.notes.noteTest1


				noteTest2 = {
					-- meta info here?
					elements = {

					}, -- end of note.notes.noteTest2.elements
				}, -- end of note.notes.noteTest2

				noteTest3 = {
					-- meta info here?
					elements = {

					}, -- end of note.notes.noteTest3.elements
				}, -- end of note.notes.noteTest3

			}, -- end of note.notes
		}, -- end of note



	},-- end of profile
}--end of default



function eR:OnInitialize()
	local AceConfig = LibStub("AceConfig-3.0")
	self.db=LibStub("AceDB-3.0"):New("elRaidoAddonDB", defaultProfile, true) 
	--true sets the default profile to a profile called "Default"
	--see https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0
	
	self.para = self.db.profile
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")


	-- note
	AceConfig:RegisterOptionsTable("elRaidoNotes", eR.note.UI.optionsTable)
	self.note.para = self.para.note
	self.note:createMainFrame()
	self.note:createSelectionFrame()
	--self.note:createUI() -- It's AceGUI so you need to do it everytime
end


local chatCommand = {
	["help"] = function(self, msg)
		eR.log.userMessage("help")
	end,

	["notes"] = function(self, msg)
		local UI = eR.note.UI
		if UI.containerFrame and UI.containerFrame:IsShown() then
			eR.note.UI.containerFrame:Hide()
		else
			eR.note.createUI()
		end
	end,

	["metatable"] = {__index=function(self,key) return self["help"] end},
}
setmetatable(chatCommand,chatCommand.metatable)


function eR:chatCommandHandler(msg)
	local key=self:GetArgs(msg,1)
	if (not key) or (key=='metatable') then chatCommand["help"]() 
	else chatCommand[key](self,msg) end
end
eR:RegisterChatCommand("elraido","chatCommandHandler")

function eR:RefreshConfig()
	ReloadUI()
end

function eR:OnEnable()
	-- pass		
end

local eventFrame=CreateFrame('Frame','elRaidoGlobalEventFrame',UIParent)
local registeredEvents={'PLAYER_ENTERING_WORLD'}
for k,v in pairs(registeredEvents) do eventFrame:RegisterEvent(v) end
function eventFrame:handleEvent(event,...)
	-- handle main events here
end
eventFrame:SetScript('OnEvent',eventFrame.handleEvent)

