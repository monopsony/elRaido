local eR = elRaidoAddon
eR.reminder = {}

function aliceInWonderland() --this function is not itself you see
	
	local reminder = eR.reminder
	reminder.remindersCLEU = eR.db.profile.reminder.remindersCLEU
	reminder.registeredSubevent = eR.db.profile.reminder.registeredSubevent

	setmetatable(eR.reminder.remindersCLEU, {__index=function(table, key) table[key]={}; return table[key] end})

	function reminder:addReminderCLEU(N, subevent, spellName, sourceName, destName, instances, encounter)
		reminder.registeredSubevent[subevent] = true
		local reminders = reminder.remindersCLEU
		reminders[subevent][N] = {[spellName] = true, [sourceName or "anySource"]=true, [destName or "anyDestination"]=true, ["instances"]=instances, ['counter']=0}
		reminders.numReminders = reminders.numReminders + 1
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

		for index, reminder in ipairs(reminders) do
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

		for index, reminder in ipairs(reminders) do
			if reminder[spellName] and (reminder[sourceName] or reminder["anySource"]) then 
				local counter = reminder.counter
				local instances = reminder.instances
				counter = counter + 1
				if not instances or instances[counter] then print('activated') end
			end
		end
	end

	handler["SPELL_CAST_FAILED"] = function(...)
		local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
		local spellId, spellName, spellSchool = select(12, ...)

		local reminders = eR.reminder.remindersCLEU[subevent]

		for index, reminder in ipairs(reminders) do
			if reminder[spellName] and (reminder[sourceName] or reminder["anySource"]) then 
				local counter = reminder.counter
				local instances = reminder.instances
				counter = counter + 1
				if not instances or instances[counter] then print('activated') end
			end
		end	
	end

	local notTrackedHandler=function()
		return
	end
end

local f = CreateFrame("frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon) if addon == "elRaido" then 
														aliceInWonderland() 
													end 
						end)