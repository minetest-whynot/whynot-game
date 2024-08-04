--[[
License for code: LGPL 3.0
see at: https://www.gnu.org/licenses/lgpl-3.0.txt

This code was adapted from signs_lib from VanessaE
the original lib can be found at: https://content.minetest.net/packages/mt-mods/signs_lib/
]]--

-- CONSTANTS

-- Path to the textures.
local TP = signs_lib.path .. "/textures"
-- Font file formatter
local CHAR_FILE = "%s_%02x.png"
-- Fonts path
local CHAR_PATH = TP .. "/" .. CHAR_FILE
local max_lenght = 20

-- Initialize character texture cache
local ctexcache = {}

local function fill_line(x, y, w, c, font_size, colorbgw)
	c = c or "0"
	local tex = { }
	for xx = 0, math.max(0, w), colorbgw do
		table.insert(tex, (":%d,%d=signs_lib_color_"..font_size.."px_%s.png"):format(x + xx, y, c))
	end
	return table.concat(tex)
end

local function clamp_characters(text, max_lenght)
    text = text or ""
    max_lenght = max_lenght or 20
    local control_chars = {"##","#0","#1","#2","#3","#4","#5","#6","#7","#8","#9","#a","#b","#c","#d","#e","#f"}
    local control_order = {}
    local new_string = text

    --first creates a memory of each control code
    for i = 1, #new_string do
        local c = new_string:sub(i,i+1)
        for i, item in pairs(control_chars) do
            if c == item then
                table.insert(control_order, item)
                break
            end
        end
    end

    --create control spaces (the order was saved in "control_order"
    local control_char = "\001"
    for i, item in pairs(control_chars) do
        new_string = string.gsub(new_string, item, control_char)
    end

    --now make another string counting it outside and breaking when reachs 20
    local count = 0
    local curr_index = 0
    local c = ""
    for i = 1, #new_string, 1 do
        c = string.sub(new_string,i,i)
        if not (c == control_char) then
            count = count + 1
        end
        curr_index = i
        if count == max_lenght then break end
    end
    local cutstring = string.sub(new_string,1,curr_index)
    
    --now reconstruct the string
    local outputstring = ""
    local control_order_curr_intex = 0
    for i = 1, #cutstring, 1 do
        c = string.sub(cutstring,i,i)
        if not (c == control_char) then
            outputstring = outputstring .. (c or "")
        else
            control_order_curr_intex = control_order_curr_intex + 1
            outputstring = outputstring .. (control_order[control_order_curr_intex] or "")
        end
    end

    return outputstring, count
end

-- check if a file does exist
-- to avoid reopening file after checking again
-- pass TRUE as second argument
local function file_exists(name, return_handle, mode)
	mode = mode or "r";
	local f = io.open(name, mode)
	if f ~= nil then
		if (return_handle) then
			return f
		end
		io.close(f) 
		return true 
	else 
		return false 
	end
end

-- make char texture file name
-- if texture file does not exist use fallback texture instead
local function char_tex(font_name, ch)
	if ctexcache[font_name..ch] then
		return ctexcache[font_name..ch], true
	else
		local c = ch:byte()
		local exists, tex = file_exists(CHAR_PATH:format(font_name, c))
		if exists and c ~= 14 then
			tex = CHAR_FILE:format(font_name, c)
		else
			tex = CHAR_FILE:format(font_name, 0x0)
		end
		ctexcache[font_name..ch] = tex
		return tex, exists
	end
end

local function make_text_texture(text, default_color, line_width, line_height, cwidth_tab, font_size, colorbgw)
    local split = signs_lib.split_lines_and_words
	local width = 0
	local maxw = 0
	local font_name = "signs_lib_font_"..font_size.."px"
    local text_ansi = signs_lib.Utf8ToAnsi(text)
    local text_splited = split(text_ansi)[1]

	local words = { }
	default_color = default_color or 0

	local cur_color = tonumber(default_color, 16)

	-- We check which chars are available here.
	for word_i, word in ipairs(text_splited) do
		local chars = { }
		local ch_offs = 0
		word = string.gsub(word, "%^[12345678abcdefgh]", {
			["^1"] = string.char(0x81),
			["^2"] = string.char(0x82),
			["^3"] = string.char(0x83),
			["^4"] = string.char(0x84),
			["^5"] = string.char(0x85),
			["^6"] = string.char(0x86),
			["^7"] = string.char(0x87),
			["^8"] = string.char(0x88),
			["^a"] = string.char(0x8a),
			["^b"] = string.char(0x8b),
			["^c"] = string.char(0x8c),
			["^d"] = string.char(0x8d),
			["^e"] = string.char(0x8e),
			["^f"] = string.char(0x8f),
			["^g"] = string.char(0x90),
			["^h"] = string.char(0x91)
		})
		local word_l = #word
		local i = 1
		while i <= word_l  do
			local c = word:sub(i, i)
			if c == "#" then
				local cc = tonumber(word:sub(i+1, i+1), 16)
				if cc then
					i = i + 1
					cur_color = cc
				end
			else
				local w = cwidth_tab[c]
				if w then
					width = width + w + 1
					if width >= (line_width - cwidth_tab[" "]) then
						width = 0
					else
						maxw = math.max(width, maxw)
					end
                    local max_input_chars = max_lenght
					if #chars < max_input_chars then
						table.insert(chars, {
							off = ch_offs,
							tex = char_tex(font_name, c),
							col = ("%X"):format(cur_color),
						})
					end
					ch_offs = ch_offs + w
				end
			end
			i = i + 1
		end
		width = width + cwidth_tab[" "] + 1
		maxw = math.max(width, maxw)
		table.insert(words, { chars=chars, w=ch_offs })
	end

	-- Okay, we actually build the "line texture" here.

	local texture = { }

	local start_xpos = math.floor((line_width - maxw) / 2)

	local xpos = start_xpos
	local ypos = line_height
    if line_height == signs_lib.lineheight32 then ypos = line_height/4 end

	cur_color = nil

	for word_i, word in ipairs(words) do
		local xoffs = (xpos - start_xpos)
		if (xoffs > 0) and ((xoffs + word.w) > maxw) then
			table.insert(texture, fill_line(xpos, ypos, maxw, "n", font_size, colorbgw))
			xpos = start_xpos
			ypos = ypos + line_height
			table.insert(texture, fill_line(xpos, ypos, maxw, cur_color, font_size, colorbgw))
		end
		for ch_i, ch in ipairs(word.chars) do
			if ch.col ~= cur_color then
				cur_color = ch.col
				table.insert(texture, fill_line(xpos + ch.off, ypos, maxw, cur_color, font_size, colorbgw))
			end
			table.insert(texture, (":%d,%d=%s"):format(xpos + ch.off, ypos, ch.tex))
		end
		table.insert(
			texture, 
			(":%d,%d="):format(xpos + word.w, ypos) .. char_tex(font_name, " ")
		)
		xpos = xpos + word.w + cwidth_tab[" "]
		if xpos >= (line_width + cwidth_tab[" "]) then break end
	end

	table.insert(texture, fill_line(xpos, ypos, maxw, "n", font_size, colorbgw))
	table.insert(texture, fill_line(start_xpos, ypos + line_height, maxw, "n", font_size, colorbgw))

	return table.concat(texture)
end

function airutils.convert_text_to_texture(text, default_color, horizontal_aligment)
    text = text or ""
    default_color = default_color or 0
    horizontal_aligment = horizontal_aligment or 3
    if not signs_lib then return "" end
	local font_size = 16
	local line_width = 1
	local line_height = 1
	local char_width = 1
	local colorbgw = ""
    local chars_per_line = 21
	local widemult = 0.5
    local count = 0
    --text = string.sub(text,1,max_lenght)
    text, count = clamp_characters(text, max_lenght)

    if count <= 10 then
        if signs_lib.avgwidth32 then
            widemult = 0.75
	        font_size = 32
            chars_per_line = 10
	        line_width = math.floor(signs_lib.avgwidth32 * chars_per_line) * (horizontal_aligment * widemult)
	        line_height = signs_lib.lineheight32
	        char_width = signs_lib.charwidth32
	        colorbgw = signs_lib.colorbgw32
        else
            return ""
        end
    else
        if signs_lib.avgwidth16 then
            widemult = 0.5
	        font_size = 16
            chars_per_line = 21
	        line_width = math.floor(signs_lib.avgwidth16 * chars_per_line) * (horizontal_aligment * widemult)
	        line_height = signs_lib.lineheight16
	        char_width = signs_lib.charwidth16
	        colorbgw = signs_lib.colorbgw16
        else
            return ""
        end
    end

	local texture = { ("[combine:%dx%d"):format(line_width, line_height) }
	local linetex = make_text_texture(text, default_color, line_width, line_height, char_width, font_size, colorbgw)
    table.insert(texture, linetex)
	table.insert(texture, "^[makealpha:0,0,0")
	return table.concat(texture, "")
end
