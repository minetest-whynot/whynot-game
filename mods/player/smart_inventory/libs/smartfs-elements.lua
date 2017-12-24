local smartfs = smart_inventory.smartfs
local elements = {}

-----------------------------------------------------
--- Crafting Preview applet
-----------------------------------------------------
-- enhanced / prepared container
-- Additional methods
--    craft_preview:setCraft(craft)
--    craft_preview:onButtonClicked(function(self, itemname, player))
-- if craft=nil, the view will be initialized

local craft_preview = table.copy(smartfs._edef.container)
function craft_preview:onCreate()
	self.data.relative = true
	smartfs._edef.container.onCreate(self)
	for x = 1, 3 do
		for y = 1, 3 do
			local button = self._state:image_button(
					(x-1)*self.data.zoom+self.data.pos.x,
					(y-1)*self.data.zoom+self.data.pos.y,
					self.data.zoom, self.data.zoom,
					"craft:"..x..":"..y,"")
			button:setVisible(false)
			button:onClick(function(self, state, player)
				local parent_element = state.location.containerElement
				if parent_element._button_click then
					parent_element._button_click(parent_element, self.data.item, player)
				end
			end)
		end
	end
	if self.data.recipe then
		self:setCraft(self.data.recipe)
	end
end

function craft_preview:onButtonClicked(func)
	self._button_click = func
end

-- Update fields
function craft_preview:setCraft(craft)
	local width
	if craft then -- adjust width to 1 if the recipe contains just 1 item
		width = craft.width or 3
		if width == 0 then
			width = 3
		end
		if craft.items[1] and next(craft.items, 1) == nil then
			width = 1
		end
	end
	for x = 1, 3 do
		for y = 1, 3 do
			local item = nil
			if craft then
				if width <= 1 then
					if x == 2 then
						item = craft.items[y]
					end
				elseif x <= width then
					item = craft.items[(y-1)*width+x]
				end
			end
			local btn = self._state:get("craft:"..x..":"..y)
			if item then
				if type(item) == "string" then
					btn:setItem(item)
					btn:setTooltip()
					btn:setText("")
				else
					btn:setItem(item.item)
					btn:setTooltip(item.tooltip)
					btn:setText(item.text)
				end
				btn:setVisible(true)
			else
				btn:setVisible(false)
			end
		end
	end
end

-- get the preview as table
function craft_preview:getCraft()
	local grid = {}
	for x = 1, 3 do
		grid[x] = {}
		for y = 1, 3 do
			local button = self._state:get("craft:"..x..":"..y)
			if button:getVisible() then
				grid[x][y] = button:getItem()
			end
		end
	end
	return grid
end

smartfs.element("craft_preview", craft_preview)

function elements:craft_preview(x, y, name, zoom, recipe)
	return self:element("craft_preview", { 
		pos  = {x=x, y=y},
		name = name,
		recipe = recipe,
		zoom = zoom or 1
	})
end


-----------------------------------------------------
--- Pagable grid buttons
-----------------------------------------------------
--[[ enhanced / prepared container
	Additional methods
		buttons_grid:setList(craft)
		buttons_grid:onClick(function(state, index, player)...end)
		buttons_grid:setList(iconlist)
		buttons_grid:getFirstVisible()
		buttons_grid:setFirstVisible(index)

	iconslist is a list of next entries:
		entry = {
				image | item =
				tooltip=
				is_button = true,
				size = {w=,h=}
		}
]]
local buttons_grid = table.copy(smartfs._edef.container)
function buttons_grid:onCreate()
	self.data.relative = true
	assert(self.data.size and self.data.size.w and self.data.size.h, "button needs valid size")
	smartfs._edef.container.onCreate(self)
	if not self.data.cell_size or not self.data.cell_size.w or not self.data.cell_size.h then
		self.data.cell_size = {w=1, h=1}
	end
	self:setSize(self.data.size.w, self.data.size.h) -- view size for background
	self.data.grid_size = {w = math.floor(self.data.size.w/self.data.cell_size.w), h = math.floor(self.data.size.h/self.data.cell_size.h)}
	self.data.list_start = self.data.list_start  or 1
	self.data.list = self.data.list or {}
	for x = 1, self.data.grid_size.w do
		for y=1, self.data.grid_size.h do
			local button = self._state:button(
					self.data.pos.x + (x-1)*self.data.cell_size.w,
					self.data.pos.y + (y-1)*self.data.cell_size.h,
					self.data.cell_size.w,
					self.data.cell_size.h,
					tostring((y-1)*self.data.grid_size.w+x),
					"")
			button:onClick(function(self, state, player)
				local rel = tonumber(self.name)
				local parent_element = state.location.containerElement
				local idx = rel
				if parent_element.data.list_start > 1  then
					idx = parent_element.data.list_start + rel - 2
				end
				if rel == 1 and parent_element.data.list_start > 1 then
					-- page back
					local full_pagesize = parent_element.data.grid_size.w * parent_element.data.grid_size.h
					if parent_element.data.list_start <= full_pagesize then
						parent_element.data.list_start = 1
					else
						--prev page use allways 2x navigation buttons at list_start > 1 and the next page (we navigate from) exists
						parent_element.data.list_start = parent_element.data.list_start - (full_pagesize-2)
					end
					parent_element:update()
				elseif rel == (parent_element.data.grid_size.w * parent_element.data.grid_size.h) and
						parent_element.data.list[parent_element.data.list_start+parent_element.data.pagesize] then
					-- page forward
					parent_element.data.list_start = parent_element.data.list_start+parent_element.data.pagesize
					parent_element:update()
				else
					-- pass call to the button function
					if parent_element._click then
						parent_element:_click(parent_element.root, idx, player)
					end
				end
			end)
			button:setVisible(false)
		end
	end
end

function buttons_grid:reset(x, y, w, h, col_size, row_size)
	self._state = nil

	self.data.pos.x = x or self.data.pos.x
	self.data.pos.y = y or self.data.pos.y
	self.data.size.w = w or self.data.size.w
	self.data.size.h = h or self.data.size.h
	self.data.cell_size.w = col_size or self.data.cell_size.w
	self.data.cell_size.h = row_size or self.data.cell_size.h

	self:onCreate()
	self:update()
end

function buttons_grid:onClick(func)
	self._click = func
end
function buttons_grid:getFirstVisible()
	return self.data.list_start
end
function buttons_grid:setFirstVisible(idx)
	self.data.list_start = idx
end
function buttons_grid:setList(iconlist)
	self.data.list = iconlist or {}
	self:update()
end

function buttons_grid:update()
	--init pagesize
	self.data.pagesize = self.data.grid_size.w * self.data.grid_size.h
	--adjust start position
	if self.data.list_start > #self.data.list then
		self.data.list_start = #self.data.list - self.data.pagesize
	end
	if self.data.list_start < 1 then
		self.data.list_start = 1
	end

	local itemindex = self.data.list_start
	for btnid = 1, self.data.grid_size.w * self.data.grid_size.h do
		local button = self._state:get(tostring(btnid))
		if btnid == 1 and self.data.list_start > 1 then
			-- setup back button
			button:setVisible(true)
			button:setImage("left_arrow.png")
			button:setText(tostring(self.data.list_start-1))
			button:setSize(self.data.cell_size.w, self.data.cell_size.h)
			self.data.pagesize = self.data.pagesize - 1
		elseif btnid == self.data.grid_size.w * self.data.grid_size.h and self.data.list[itemindex+1] then
			-- setup next button
			button:setVisible(true)
			button:setImage("right_arrow.png")
			self.data.pagesize = self.data.pagesize - 1
			button:setText(tostring(#self.data.list-self.data.list_start-self.data.pagesize+1))
			button:setSize(self.data.cell_size.w, self.data.cell_size.h)
		else
			-- functional button
			local entry = self.data.list[itemindex]
			if entry then
				if entry.size then
					button:setSize(entry.size.w, entry.size.h)
				else
					button:setSize(self.data.cell_size.w, self.data.cell_size.h)
				end
				if entry.item and entry.is_button == true then
					button:setVisible(true)
					button:setItem(entry.item)
					button:setText(entry.text or "")
					button:setTooltip(nil)
				elseif entry.image and entry.is_button == true then
					button:setVisible(true)
					button:setImage(entry.image)
					button:setText(entry.text or "")
					button:setTooltip(entry.tooltip)
				-- TODO 1: entry.image to display *.png 
				-- TODO 2: entry.text to display label on button
				-- TODO 3,4,5: is_button == false to get just pic or label without button
				end
			else
				button:setVisible(false)
			end
			itemindex = itemindex + 1
		end
	end
end


smartfs.element("buttons_grid", buttons_grid)

function elements:buttons_grid(x, y, w, h, name, col_size, row_size)
	return self:element("buttons_grid", { 
		pos  = {x=x, y=y},
		size = {w=w, h=h},
		cell_size = {w=col_size, h=row_size},
		name = name
	})
end


-------------------------
return elements
