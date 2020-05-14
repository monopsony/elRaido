reminder.bigwigs = function()
	local plugin = BigWigs:NewPlugin("elRaidoReminderBigWigs")
	local function startBarHandler(...)
	end
	BigWigsLoader.RegisterMessage(plugin, "BigWigs_StartBar", startBarHandler)
end