-- Vars

local function setting_get(name, default)
	return minetest.settings:get(name) or default
end

local speed         = tonumber(setting_get("sprint_speed", "1.3"))
local jump          = tonumber(setting_get("sprint_jump", "1.1"))
local dir           = minetest.is_yes(setting_get("sprint_forward_only", "false"))
local particles     = tonumber(setting_get("sprint_particles", "2"))
local stamina       = minetest.is_yes(setting_get("sprint_stamina", "true"))
local stamina_drain = tonumber(setting_get("sprint_stamina_drain", "2"))
local stamina_heal  = tonumber(setting_get("sprint_stamina_heal", "2"))
local standing      = tonumber(setting_get("sprint_stamina_standing", "2.5"))
local replenish     = tonumber(setting_get("sprint_stamina_replenish", "2"))
local starve        = minetest.is_yes(setting_get("sprint_starve", "true"))
local starve_drain  = tonumber(setting_get("sprint_starve_drain", "0.5"))
local starve_limit  = tonumber(setting_get("sprint_starve_limit", "6"))
local breath        = minetest.is_yes(setting_get("sprint_breath", "true"))
local breath_drain  = tonumber(setting_get("sprint_breath_drain", "1"))
local autohide      = minetest.is_yes(setting_get("hudbars_autohide_stamina", "true"))

local sprint_timer_step = 0.5
local sprint_timer = 0
local sprinting = {}
local stamina_timer = {}
local breath_timer = {}

local mod_hudbars = minetest.get_modpath("hudbars") ~= nil
local mod_player_monoids = minetest.get_modpath("player_monoids") ~= nil
local mod_playerphysics = minetest.get_modpath("playerphysics") ~= nil

if starve then
  if minetest.get_modpath("hbhunger") then
    starve = "hbhunger"
  elseif minetest.get_modpath("hunger_ng") then
    starve = "hunger_ng"
  else
    starve = false
  end
end
if minetest.settings:get_bool("creative_mode") then
  starve = false
end

-- Functions

local function start_sprint(player)
  local name = player:get_player_name()
  if not sprinting[name] then
    if mod_player_monoids then
      player_monoids.speed:add_change(player, speed, "hbsprint:speed")
      player_monoids.jump:add_change(player, jump, "hbsprint:jump")
    elseif mod_playerphysics then
      playerphysics.add_physics_factor(player, "speed", "hbsprint:speed", speed)
      playerphysics.add_physics_factor(player, "jump", "hbsprint:jump", jump)
    else
      player:set_physics_override({speed = speed, jump = jump})
    end
    sprinting[name] = true
  end
end

local function stop_sprint(player)
  local name = player:get_player_name()
  if sprinting[name] then
    if mod_player_monoids then
      player_monoids.speed:del_change(player, "hbsprint:speed")
      player_monoids.jump:del_change(player, "hbsprint:jump")
    elseif mod_playerphysics then
      playerphysics.remove_physics_factor(player, "speed", "hbsprint:speed")
      playerphysics.remove_physics_factor(player, "jump", "hbsprint:jump")
    else
      player:set_physics_override({speed = 1, jump = 1})
    end
    sprinting[name] = false
  end
end

local function drain_stamina(player)
  local player_stamina = player:get_meta():get_float("hbsprint:stamina")
  if player_stamina > 0 then
    player_stamina = math.max(0, player_stamina - stamina_drain)
    player:get_meta():set_float("hbsprint:stamina", player_stamina)
  end
  if mod_hudbars then
    if autohide and player_stamina < 20 then hb.unhide_hudbar(player, "stamina") end
    hb.change_hudbar(player, "stamina", player_stamina)
  end
end

local function replenish_stamina(player)
  local player_stamina = player:get_meta():get_float("hbsprint:stamina")
  local ctrl = player:get_player_control()
  if player_stamina < 20 and not ctrl.jump then
    if not ctrl.right and not ctrl.left and not ctrl.down and not ctrl.up and not ctrl.LMB and not ctrl.RMB then
      player_stamina = math.min(20, player_stamina + standing)
    else
      player_stamina = math.min(20, player_stamina + stamina_heal)
    end
    player:get_meta():set_float("hbsprint:stamina", player_stamina)
  end
  if mod_hudbars then
    hb.change_hudbar(player, "stamina", player_stamina)
    if autohide and player_stamina >= 20 then hb.hide_hudbar(player, "stamina") end
  end
end

local function drain_hunger(player, name)
  if starve == "hbhunger" then
    local hunger = tonumber(hbhunger.hunger[name]) - starve_drain
    hbhunger.hunger[name] = math.max(0, hunger)
    hbhunger.set_hunger_raw(player)
  elseif starve == "hunger_ng" then
    hunger_ng.alter_hunger(name, -starve_drain, "Sprinting")
  end
end

local function drain_breath(player)
  local player_breath = player:get_breath()
  if player_breath < player:get_properties().breath_max then
    player_breath = math.max(0, player_breath - breath_drain)
    player:set_breath(player_breath)
  end
end

local function is_walkable(ground)
  local ground_def = minetest.registered_nodes[ground.name]
  return ground_def and (ground_def.walkable and ground_def.liquidtype == "none")
end

local function create_particles(player, name, ground)
  local def = minetest.registered_nodes[ground.name] or {}
  local tile = def.tiles and def.tiles[1] or def.inventory_image
  if type(tile) == "table" then
    tile = tile.name
  end
  if not tile then
    return
  end

  local pos = player:get_pos()
  local rand = function() return math.random(-1,1) * math.random() / 2 end
  for i = 1, particles do
    minetest.add_particle({
      pos = {x = pos.x + rand(), y = pos.y + 0.1, z = pos.z + rand()},
      velocity = {x = 0, y = 5, z = 0},
      acceleration = {x = 0, y = -13, z = 0},
      expirationtime = math.random(),
      size = math.random() + 0.5,
      vertical = false,
      texture = tile,
    })
  end
end

-- Registrations

if mod_hudbars and stamina then
  hb.register_hudbar(
    "stamina",
    0xFFFFFF,
    "Stamina",
    {
      bar = "sprint_stamina_bar.png",
      icon = "sprint_stamina_icon.png",
      bgicon = "sprint_stamina_bgicon.png"
    },
    20,
    20,
    autohide)
end

minetest.register_on_joinplayer(function(player)
  if stamina then
    if mod_hudbars then
      hb.init_hudbar(player, "stamina", 20, 20, autohide)
    end
    player:get_meta():set_float("hbsprint:stamina", 20)
  end
end)

local function sprint_step(player, dtime)
  local name = player:get_player_name()
  local fast = minetest.get_player_privs(name).fast

  if not fast then
    if stamina then
      stamina_timer[name] = (stamina_timer[name] or 0) + dtime
    end
    if breath then
      breath_timer[name] = (breath_timer[name] or 0) + dtime
    end
  end

  local ctrl = player:get_player_control()
  local key_press
  if dir then
    key_press = ctrl.aux1 and ctrl.up and not ctrl.left and not ctrl.right
  else
    key_press = ctrl.aux1 and (ctrl.up or ctrl.left or ctrl.right or ctrl.down)
  end

  if not key_press then
    stop_sprint(player)
    if stamina and not fast and stamina_timer[name] >= replenish then
      replenish_stamina(player)
      stamina_timer[name] = 0
    end
    return
  end

  local ground_pos = player:get_pos()
  ground_pos.y = math.floor(ground_pos.y)
  -- check if player is reasonably near a walkable node
  local ground
  for _, y_off in ipairs({0, -1, -2}) do
    local testpos = vector.add(ground_pos, {x=0, y=y_off, z=0})
    local testnode = minetest.get_node_or_nil(testpos)
    if testnode ~= nil and is_walkable(testnode) then
      ground = testnode
      break
    end
  end

  local player_stamina = 1
  if stamina then
    player_stamina = player:get_meta():get_float("hbsprint:stamina")
  end
  local hunger = 30
  if starve == "hbhunger" then
    hunger = tonumber(hbhunger.hunger[name])
  elseif starve == "hunger_ng" then
    hunger = hunger_ng.get_hunger_information(name).hunger.exact
  end

  if (player_stamina > 0 and hunger > starve_limit and ground) or fast then
    start_sprint(player)
    if stamina and not fast then drain_stamina(player) end
    if starve and not fast then drain_hunger(player, name) end
    if breath and not fast and breath_timer[name] >= 2 then
      drain_breath(player)
      breath_timer[name] = 0
    end
    if particles and ground then
      create_particles(player, name, ground)
    end
  else
    stop_sprint(player)
  end
end

minetest.register_globalstep(function(dtime)
  sprint_timer = sprint_timer + dtime
  if sprint_timer >= sprint_timer_step then
    for _, player in ipairs(minetest.get_connected_players()) do
      sprint_step(player, sprint_timer)
    end
    sprint_timer = 0
  end
end)
