local eR = elRaidoAddon
eR.reminder = {}
local reminder = eR.reminder


reminder.bigwigs = function()
	local plugin = BigWigs:NewPlugin("elRaidoReminderBigWigs")
	local function startBarHandler(...)
	end
	BigWigsLoader.RegisterMessage(plugin, "BigWigs_StartBar", startBarHandler)
end

reminder.eventFrame = CreateFrame("frame")
reminder.eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
reminder.eventFrame:SetScript("OnEvent", function(self, event) self:OnEvent(event, CombatLogGetCurrentEventInfo()) end)

function reminder.eventFrame:OnEvent(event,...)
	local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...	
	if reminder.registeredSubevent[subevent] then reminder.handlerCLEU[subevent](...) end
end

reminder.handlerCLEU = {}
reminder.registeredSubevent = {}

local handler = reminder.handlerCLEU

local spellCastStartHandler = 
function(...) 
	local spellId, spellName, spellSchool = select(12, ...)
	--stuff
end
local spellCastSuccessHandler = 
function(...) 
	local spellId, spellName, spellSchool = select(12, ...)
	--stuff
end
local spellCastFailedHandler = 
function(...) 
	local spellId, spellName, spellSchool = select(12, ...)
	--stuff
end

handler["SPELL_CAST_START"]   = spellCastStartHandler
handler["SPELL_CAST_SUCCESS"] = spellCastSuccessHandler
handler["SPELL_CAST_FAILED"]  = spellCastFailedHandler

local notTrackedHandler=
function()
	return
end

setmetatable(handler, {__index = function() return notTrackedHandler end})

