local addon = OdastoAddonCLEU
local addonName = OdastoAddonCLEU.name
local AceConfig=LibStub("AceConfig-3.0")
local AceConfigDialog=LibStub("AceConfigDialog-3.0")


function addon:generateOptions()
    addon.optionsTable = 
    {	type='group',
        --childGroups='tree',
        args={
        
       }
    }
    
    
    
    AceConfig:RegisterOptionsTable('OdastoCLEU',addon.optionsTable)
    AceConfigDialog:AddToBlizOptions('OdastoCLEU','OdastoCLEU')
    addon:RegisterChatCommand("cleu", function(...) LibStub("AceConfigDialog-3.0"):Open('OdastoCLEU'); end)
end

addon:generateOptions()

local args = addon.optionsTable.args
args["reminder1"] = {name='reminder1',
              type='group',
              order=1,
              args={}
              }
args["reminder2"] = {name='reminder2',
              type='group',
              order=1,
              args={}
              }
args["reminder3"] = {name='reminder3',
              type='group',
              order=1,
              args={}
              }              
              
args["general2"] = {name='Add Reminder',
      type = "input",
      set = function(info,val) end,
      get = function(info) return end
              
              }              
              
              
local args = addon.optionsTable.args.reminder1.args 

args["who"] = {
                name = 'who',
                type = 'select',
                set = function(info,val) end,
                get = function(info) return end,
                order=1,
                values = {'by raider', 'by role', 'not vulperas'},
}              


args["what"] = {
                name = 'what',
                type = 'select',
                set = function(info,val) end,
                get = function(info) return 'scary mechanic' end,
                order=2,
                values = {'scary mechanic'},
} 

args["how"] = {
                name = 'how',
                type = 'select',
                set = function(info,val) end,
                get = function(info) return 'dancing chicken' end,
                order=3,
                values = {'dancing chicken'},
} 

