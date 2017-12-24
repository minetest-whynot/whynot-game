local txt_usage = minetest.setting_getbool("smart_inventory_friendly_group_names") --or true
if txt_usage == false then
	return false
end

local modpath = minetest.get_modpath(minetest.get_current_modname()).."/locale"

local LANG = minetest.setting_get("language")
if not (LANG and (LANG ~= "")) then LANG = os.getenv("LANG") end
if not (LANG and (LANG ~= "")) then LANG = "en" end
local pofile = modpath.."/groups_"..LANG:sub(1,2)..".po"

local f=io.open(pofile,"r")
--fallback to en
if not f then
	pofile = modpath.."/groups_en.po"
	f=io.open(pofile,"r")
end

local texttab = {}

local msgid
local msgstr

for line in f:lines() do
	if line:sub(1,5) == 'msgid' then -- msgid ""
		msgid = line:sub(8, line:len()-1)
	elseif line:sub(1,6) == 'msgstr' then -- msgstr ""
		msgstr = line:sub(9, line:len()-1)
	end
	if msgid and msgstr then
		if msgid ~= "" and msgstr ~= "" then
			texttab[msgid] = msgstr
		end
		msgid = nil
		msgstr = nil
	end
end

io.close(f)
return texttab
