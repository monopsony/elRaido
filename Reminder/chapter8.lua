local eR = elRaidoAddon
eR.reminder = {}

eR.reminder.reminders = {}
--eR.db.reminder = {}
local reminder = eR.reminder

reminder.bigwigs = function()
	local plugin = BigWigs:NewPlugin("elRaidoReminderBigWigs")
	local function startBarHandler(...)
	end
	BigWigsLoader.RegisterMessage(plugin, "BigWigs_StartBar", startBarHandler)
end

eR.reminder.remindersCLEU = {}
reminder.registeredSubevent = {}

setmetatable(eR.reminder.remindersCLEU, {__index=function(table, key) table[key]={}; return table[key] end})

function reminder:addReminderCLEU(subevent, spellName, sourceName, destName, instances, encounter)
	reminder.registeredSubevent[subevent] = true
	local reminders = eR.reminder.remindersCLEU
	reminders[subevent][spellName..sourceName]=true   
	reminders[subevent].instances = {}
	reminders[subevent].counter = {}
	reminders[subevent].instances[spellName..sourceName] = instances
	reminders[subevent].counter[spellName..sourceName] = 0
end

reminder.eventFrame = CreateFrame("frame")
reminder.eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
reminder.eventFrame:SetScript("OnEvent", function(self, event) self:OnEvent(event, CombatLogGetCurrentEventInfo()) end)

function reminder.eventFrame:OnEvent(event,...)
	local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...	
	local subevent = select(2,...)	
	if reminder.registeredSubevent[subevent] then reminder.handlerCLEU[subevent](...) end
end

reminder.handlerCLEU = {}

local handler = reminder.handlerCLEU

handler["SPELL_CAST_START"] = function(...) 
	local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
	local spellId, spellName, spellSchool = select(12, ...)

	local reminders = eR.reminder.remindersCLEU[subevent]
	if reminders[spellName..sourceName] then 
		reminders.counter[spellName..sourceName] = reminders.counter[spellName..sourceName] + 1
		local counter = reminders.counter[spellName..sourceName] 
		local instances = reminders.instances[spellName..sourceName] 
		if instances == false or instances[counter] then print('actiaved'); end
	end	
end

handler["SPELL_CAST_SUCCESS"] = function(...) 

	local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
	local spellId, spellName, spellSchool = select(12, ...)

	local reminders = eR.reminder.remindersCLEU[subevent]
	if reminders[spellName..sourceName] then 
		reminders.counter[spellName..sourceName] = reminders.counter[spellName..sourceName] + 1
		local counter = reminders.counter[spellName..sourceName] 
		local instances = reminders.instances[spellName..sourceName] 
		if instances == false or instances[counter] then print('actiaved'); end
	end
end

handler["SPELL_CAST_FAILED"] = function(...)
	local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
	local spellId, spellName, spellSchool = select(12, ...)
	--stuff
	local reminders = eR.reminder.remindersCLEU[subevent]
	if reminders[spellName..sourceName] then 
		reminders.counter[spellName..sourceName] = reminders.counter[spellName..sourceName] + 1
		local counter = reminders.counter[spellName..sourceName] 
		local instances = reminders.instances[spellName..sourceName] 
		if instances == false or instances[counter] then print('actiaved'); end
	end		
end

local notTrackedHandler=
function()
	return
end

reminder:addReminderCLEU("SPELL_CAST_SUCCESS", "Thunder Clap", "Terriodasto", "", {[2]=true})
reminder:addReminderCLEU("SPELL_CAST_START", "Hearthstone", "Terriodasto", "", {[2]=true})