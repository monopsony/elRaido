local AceGUI = LibStub("AceGUI-3.0")
local eR = elRaidoAddon
local note = eR.note
local UI = note.UI
local ipairs, pairs, unpack = ipairs, pairs, unpack

local AceConfigDialog = LibStub("AceConfigDialog-3.0")

function note:createUI()
	if UI.optionsFrame then 
		UI.optionsFrame:Hide()
		return
	end

	UI.optionsFrame = AceGUI:Create("Frame")
	UI.optionsFrame:SetCallback("OnClose", function(w)
		AceGUI:Release(w)
		UI.optionsFrame = nil
		note:disableEdit()
	end)

	UI.refreshNotesWindow(true)
end

UI.optionsTable = {
	type = "group",
	childGroups = "tab",
	args = {
		notes = {
			name = "Notes",
			type = "group",
			args = {
			},
		}, -- end of notes

		temp = {
			name = "Temp",
			type = "group",
			args = {
				aasdasda = {
					type = 'description',
					hidden = function(self)
						for k,v in pairs(self) do print(k,v) end
					end,
					name = 'yo',
				},
			},			
		}, -- end of temp

	}
}

function UI.refreshNotesWindow(refreshNotes)
	print('Manually refresing')
	if refreshNotes then note.UI.fillNotes() end
	AceConfigDialog:Open("elRaidoNotes", UI.optionsFrame)
end

function UI.applySelectedNote(noteName)
	print("Applying selected noteName", noteName)
	if noteName then UI.selectedNote = noteName end
	local noteName = noteName or UI.optionsTable

	note:showNote(noteName)
end

UI.selectedNote = nil
UI.noteArg = {
	invisible = {
		type = "description",
		order = 0,
		name = "invisible",
		hidden = function(self)
			local selected = self[#self - 1]
			note:enableEdit()
			if selected 
				and (not UI.selectedNote or UI.selectedNote~=selected) 
			then
				UI.applySelectedNote(selected)
			end
			return true
		end,
	},

	test = {
		type = 'description',
		order = 1,
		name = function()
			return UI.selectedNote
		end,
	},
}

local wipe = wipe
function UI.fillNotes()
	local args = UI.optionsTable.args.notes.args

	wipe(args)
	for k,v in pairs(note.para.notes) do 
		args[k] = {
			type = "group",
			name = k,
			args = UI.noteArg,
		}
	end
end

---------------------------
------- notes.notes -------
---------------------------

local args = UI.noteArg

args['toolSelect'] = {
	name = "Tool",
	type = "select",
	style = "dropdown",
	order = 2,
	values = function()
		local a = {}
		local th = note.toolHandlers
		for k,v in pairs(th) do 
			a[k] = k
		end
		return a
	end,

	set = function(self, value)

		note:setTool(value)
	end,

	get = function(self)
		local tool = note.tool
		if not tool then return end
		return tool.name
	end,
}

args['heading1'] = {
	type = 'header',
	name = '',
	order = 10,
}

-- note.toolParas
args['color'] = {
	order = 11,
	type = 'color',
	name = 'Color',
	hasAlpha = true,
	get = function()
		local p = note.toolParas
		local r, g, b, a = p.colorR, p.colorG, p.colorB, p.alpha
		return r, g, b, a
	end,
	set = function(_, r, g, b, a)
		local p = note.toolParas
		p.colorR, p.colorG, p.colorB, p.alpha = r, g, b, a or p.alpha
		note:applySelectionAttributeChange()
	end,

}