local eR = elRaidoAddon
local reminder = eR.reminder
local AceConfig=LibStub("AceConfig-3.0")
local AceConfigDialog=LibStub("AceConfigDialog-3.0")

local dropDownTable = {'SPELL_CAST_START','SPELL_CAST_SUCCESS','SPELL_CAST_FAILED'}

local function splitString(s)
  local chunks = {}
  for substring in s:gmatch("%S+") do
     table.insert(chunks, substring)
  end
  return chunks
end

function reminder:addReminder(j)
    local args = reminder.optionsTable.args
    local settings = eR.db.profile.reminder.settings
    --local reminders = eR.reminder.remindersCLEU
    local num = j

    args["reminder"..num] = 

    {
    name = 'reminder'..num, 
    type  = 'group',
    order = num, 
    args = { ["subevent"] = {
                            name='subevent', 
                            type = 'select', 
                            values = dropDownTable, 
                            order=1,
                            set = function(info, val) settings["subevent"..num]=val; end,
                            get = function(info)  return settings["subevent"..num];  end
                            },

            ["unitS"] =     {
                            name='source unit', 
                             type = 'input', 
                             order=2,
                             set = function(info,val) 
                                    settings["unit"..num]=val
                                    if val =="" then settings["unit"..num]=nil end
                                  end,
                            get = function(info) return settings["unit"..num] end
                            },

            ["instances"] = {
                            name='instances', 
                            type = 'input', 
                            order=3,
                            set = function(info,val) 
                                settings["instances"..num]=splitString(val)
                                if val =="" then settings["instances"..num]=nil end
                                settings["instancesText"..num]=val
                            end,
                            get = function(info) return settings["instancesText"..num] end
                            },      

            ["spellname"] = {
                            name='spellName', 
                            type = 'input', 
                            order=4,
                            set = function(info,val) 
                                    local subevent = dropDownTable[settings["subevent"..num]]
                                    local instances = settings["instances"..num]
                                    local unit = settings["unit"..num]
                                    settings["spellName"..num] = val
                                    reminder:addReminderCLEU(num, subevent, val, unit, nil, instances, false) --adds reminder to reminders[subevent][num]
                                    for sevent, reminder in pairs(eR.reminder.remindersCLEU) do --deletes any previous reminder #num
                                      if sevent ~= subevent then reminder[num] = nil end
                                    end
                            end,
                            get = function(info) return settings["spellName"..num] end
                            },
        } --end of args
    }-- end of args["reminder"..num]
end

function reminder:generateOptions()
    local settings = eR.db.profile.reminder.settings
    local num = settings.numReminders
    reminder.optionsTable = 
    { type='group',
        args={ ["addElement"] = {name = 'add element', type = 'execute', func = function() 
                                settings.numReminders=settings.numReminders+1;reminder:addReminder(settings.numReminders);  
                               end}
        
       }
    }
    
AceConfig:RegisterOptionsTable('elRaido',reminder.optionsTable)
end


elRaidoAddon:RegisterChatCommand("cleu", function(...) reminder:generateOptions(); for j=1,eR.db.profile.reminder.settings.numReminders do reminder:addReminder(j) end; LibStub("AceConfigDialog-3.0"):Open('elRaido'); end)

