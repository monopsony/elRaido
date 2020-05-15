local eR = elRaidoAddon
eR.reminder = {}

function eR.reminder:onInitialize() --this function is not itself you see
	
	local reminder = eR.reminder
	local settings = eR.db.profile.reminder.settings
	reminder.remindersCLEU = eR.db.profile.reminder.remindersCLEU
	reminder.registeredSubevent = eR.db.profile.reminder.registeredSubevent

	setmetatable(eR.reminder.remindersCLEU, {__index=function(table, key) table[key]={}; return table[key] end})



	function reminder:addReminderCLEU(N, subevent, spellName, sourceName, destName, instances, encounter)
		reminder.registeredSubevent[subevent] = true
		local reminders = reminder.remindersCLEU
		print(sourceName or "anySource")
		reminders[subevent][N] = {[spellName] = true, [sourceName or "anySource"]=true, [destName or "anyDestination"]=true, ["instances"]=instances, ['counter']=0}
		settings.numReminders = settings.numReminders + 1
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

		for index, reminder in pairs(reminders) do
			if reminder[spellName] and (reminder[sourceName] or reminder["anySource"]) then 
				local counter = reminder.counter
				local instances = reminder.instances
				reminder.counter = counter + 1
				if not instances or instances[counter] then print('activated') end
			end
		end
	end

	handler["SPELL_CAST_SUCCESS"] = function(...) 

		local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
		local spellId, spellName, spellSchool = select(12, ...)

		local reminders = eR.reminder.remindersCLEU[subevent]

		for index, reminder in pairs(reminders) do
			if reminder[spellName] and (reminder[sourceName] or reminder["anySource"]) then 
				local counter = reminder.counter
				local instances = reminder.instances
				reminder.counter = counter + 1
				if not instances or instances[counter] then print('activated') end
			end
		end
	end

	handler["SPELL_CAST_FAILED"] = function(...)
		local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
		local spellId, spellName, spellSchool = select(12, ...)

		local reminders = eR.reminder.remindersCLEU[subevent]

		for index, reminder in pairs(reminders) do
			if reminder[spellName] and (reminder[sourceName] or reminder["anySource"]) then 
				local counter = reminder.counter
				local instances = reminder.instances
				reminder.counter = counter + 1
				if not instances or instances[counter] then print('activated') end
			end
		end
	end

	local notTrackedHandler=function()
		return
	end
end



