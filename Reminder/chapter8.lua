local eR = elRaidoAddon
eR.reminder = {}
<<<<<<< Updated upstream
=======
eR.reminder.reminders = {}
--eR.db.reminder = {}
>>>>>>> Stashed changes
local reminder = eR.reminder


reminder.bigwigs = function()
	local plugin = BigWigs:NewPlugin("elRaidoReminderBigWigs")
	local function startBarHandler(...)
	end
	BigWigsLoader.RegisterMessage(plugin, "BigWigs_StartBar", startBarHandler)
end

<<<<<<< Updated upstream
=======
eR.reminder.remindersCLEU = { 
							["SPELL_CAST_START"]   = {},
	                        ["SPELL_CAST_SUCCESS"] = {},
	                        ["SPELL_CAST_FAILED"]  = {},
                            }
setmetatable(eR.reminder.remindersCLEU, {__index=function(table, key) table[key]={}; return table[key] end})

function reminder:addReminderCLEU(subevent, spellName, sourceName, destName)
	local reminders = eR.reminder.remindersCLEU
	reminders[subevent] = {spellName, sourceName, destName}
end

>>>>>>> Stashed changes
reminder.eventFrame = CreateFrame("frame")
reminder.eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
reminder.eventFrame:SetScript("OnEvent", function(self, event) self:OnEvent(event, CombatLogGetCurrentEventInfo()) end)

function reminder.eventFrame:OnEvent(event,...)
<<<<<<< Updated upstream
	local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...	
=======
	local subevent = select(2,...)	
>>>>>>> Stashed changes
	if reminder.registeredSubevent[subevent] then reminder.handlerCLEU[subevent](...) end
end

reminder.handlerCLEU = {}
<<<<<<< Updated upstream
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
=======
reminder.registeredSubevent = {["SPELL_CAST_SUCCESS"]=true}

local handler = reminder.handlerCLEU

local spellCastStartHandler = function(...) 
	local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
	local spellId, spellName, spellSchool = select(12, ...)
	--stuff
end

local spellCastSuccessHandler = function(...) 
	local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
	local spellId, spellName, spellSchool = select(12, ...)
	local reminders = eR.reminder.remindersCLEU.SPELL_CAST_SUCCESS
	if reminders[spellName] and reminders[spellName][sourceName] then print('activated') end
	--stuff
end

local spellCastFailedHandler = function(...)
	local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
>>>>>>> Stashed changes
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

