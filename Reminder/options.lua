local eR = elRaidoAddon
local reminder = eR.reminder
local AceConfig=LibStub("AceConfig-3.0")
local AceConfigDialog=LibStub("AceConfigDialog-3.0")

function reminder:addReminder()
    local args = reminder.optionsTable.args
    local N = #args+1
    args["reminder"..N] = {  name = 'reminder'..N, 
                             type  = 'group', 
                             args = { ["subevent"] = {name='subevent', type = 'select', values = {'chicken'}, order=1},
                                      ["spellname"] = {name='spellName', type = 'input', order=2}
                            }
                          }
end

function reminder:generateOptions()
    reminder.optionsTable = 
    { type='group',
        --childGroups='tree',
        args={
        
       }
    }
    
AceConfig:RegisterOptionsTable('elRaido',reminder.optionsTable)
--AceConfigDialog:AddToBlizOptions('OdastoCLEU','OdastoCLEU')
elRaidoAddon:RegisterChatCommand("cleu", function(...) LibStub("AceConfigDialog-3.0"):Open('elRaido'); end)


end

reminder:generateOptions()
reminder:addReminder()