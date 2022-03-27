--- The Common Mob Interface
-- @module cmi
-- @author raymoo

cmi = {}

--- Types.
-- The various data structures used in the API.
-- @section types

--- Object Identifiers.
-- @string type Either "player" or "mob"
-- @string identifier For players, is a player name. For mobs, is a unique ID.
-- @table Id

--- Punch callbacks.
-- @tparam ObjectRef mob
-- @tparam ?ObjectRef hitter
-- @number time_from_last_punch
-- @tab tool_capabilities
-- @tparam ?vector dir
-- @number damage
-- @tparam ?Id attacker Any indirect owner of the punch, for example a
-- player who fired an arrow.
-- @function PunchCallback

--- Reasons a mob could die.
-- The type field determines what kind of cause a @{DeathCause} is. It can be one
-- of those specified here, or a custom one provided by a mod. For custom types,
-- the fields should be specified by the mod introducing it.
-- @string type The predefined types are "punch" and "environment".
-- @tparam ?ObjectRef puncher If type == "punch", contains the puncher. The
-- puncher can be nil.
-- @tparam ?Id attacker If type == "punch", contains the attacker if it exists
-- and is known.
-- @tparam ?vector pos If type == "environment", is the position of the damaging
-- node.
-- @tparam ?node node If type == "environment", describes the damaging node.
-- @table DeathCause

--- Death callbacks.
-- @tparam ObjectRef mob the dying mob
-- @tparam DeathCause cause cause of death
-- @function DeathCallback

--- Activation callbacks.
-- @tparam ObjectRef mob the mob being activated
-- @number dtime the time since the mob was unloaded
-- @function ActivationCallback

--- Step callbacks.
-- @tparam ObjectRef mob
-- @number dtime
-- @function StepCallback

--- Component definitions.
-- @string name a unique name for the component, prefixed with the mod name
-- @func initialize a function taking no arguments and returning a new instance
-- of the data
-- @func serialize a function taking your component's data as an input and
-- returning it serialized as a string
-- @func deserialize a function taking the serialized form of your data and
-- turning it back into the original data
-- @table ComponentDef

-- Returns a table and the registration callback for it
local function make_callback_table()
	local callbacks = {}
	local function registerer(entry)
		table.insert(callbacks, entry)
	end

	return callbacks, registerer
end

-- Returns a notification function
local function make_notifier(cb_table)
	return function(...)
		for i, cb in ipairs(cb_table) do
			cb(...)
		end
	end
end

--- Callback Registration.
-- Functions for registering mob callbacks.
-- @section callbacks

--- Register a callback to be run when a mob is punched.
-- @tparam PunchCallback func
-- @function register_on_punchmob
local punch_callbacks
punch_callbacks, cmi.register_on_punchmob = make_callback_table()

--- Register a callback to be run when a mob dies.
-- @tparam DeathCallback func
-- @function register_on_diemob
local die_callbacks
die_callbacks, cmi.register_on_diemob = make_callback_table()

--- Register a callback to be run when a mob is activated.
-- @tparam ActivationCallback func
-- @function register_on_activatemob
local activate_callbacks
activate_callbacks, cmi.register_on_activatemob = make_callback_table()

--- Register a callback to be run on mob step.
-- @tparam StepCallback func
-- @function register_on_stepmob
local step_callbacks
step_callbacks, cmi.register_on_stepmob = make_callback_table()

--- Querying.
-- Functions for getting information about mobs.
-- @section misc

-- Wraps an entity-accepting function to accept entities or ObjectRefs.
local function on_entity(name, func)
	return function(object, ...)
		local o_type = type(object)

		-- luaentities are tables
		if o_type == "table" then
			return func(object, ...)
		end
		
		if o_type == "userdata" then
			local ent = object:get_luaentity()
			return ent and func(ent, ...)
		end

		-- If no error, it's still possible that the input was bad.
		error("Non-luaentity Non-ObjectRef input to" .. name)
	end
end

-- Same as on_entity but for ObjectRefs
local function on_object(name, func)
	return on_entity(function(ent, ...)
		return func(ent.object, ...)
	end)
end

--- Checks if an object is a mob.
-- @tparam ObjectRef|luaentity object
-- @treturn bool true if the object is a mob, otherwise returns a falsey value
-- @function is_mob
cmi.is_mob = on_entity("is_mob", function(ent)
	return ent._cmi_is_mob
end)

--- Gets a player-readable mob name.
-- @tparam ObjectRef|luaentity object
-- @treturn string
-- @function get_mob_description
cmi.get_mob_description = on_entity("get_mob_description", function(mob)
	local desc = mob.description
	if desc then return desc end

	local name = mob.name
	local colon_pos = string.find(name, ":")
	if colon_pos then
		return string.sub(name, colon_pos + 1)
	else
		return name
	end
end)

--- Health-related.
-- Functions related to hurting or healing mobs.
-- @section health

--- Attack a mob.
-- Functions like the punch method of ObjectRef, but takes an additional optional
-- argument for an indirect attacker. Also works on non-mob entities that define
-- an appropriate _cmi_attack method.
-- @tparam ObjectRef|luaentity mob
-- @tparam ObjectRef puncher
-- @number time_from_last_punch
-- @tab tool_capabilities
-- @tparam vector direction
-- @tparam ?Id attacker An indirect owner of the punch. For example, the player
-- who fired an arrow that punches the mob.
-- @function attack
local function attack_ent(mob, puncher, time_from_last_punch, tool_capabilities,
	direction, attacker)

	-- It's a method in the mob but I don't want to index it twice
	local atk = mob._cmi_attack
	if not atk then mob.object:punch(puncher, time_from_last_punch,
				tool_capabilities, direction)
	else
		atk(mob, puncher, time_from_last_punch, tool_capabilities,
			direction, attacker)
	end
end
cmi.attack = on_entity("attack", attack_ent)

local function bound(x, minb, maxb)
	if x < minb then
		return minb
	elseif x > maxb then
		return maxb
	else
		return x
	end
end

--- Punch damage calculator.
-- By default, this just calculates damage in the vanilla way. Switch it out for
-- something else to change the default damage mechanism for mobs.
-- @tparam ObjectRef mob
-- @tparam ?ObjectRef puncher
-- @tparam number time_from_last_punch
-- @tparam table tool_capabilities
-- @tparam ?vector direction
-- @tparam ?Id attacker
-- @treturn number The calculated damage
function cmi.damage_calculator(mob, puncher, tflp, caps, direction, attacker)
	local a_groups = mob:get_armor_groups() or {}
	local full_punch_interval = caps.full_punch_interval or 1.4
	local time_prorate = bound(tflp / full_punch_interval, 0, 1)

	local damage = 0
	for group, damage_rating in pairs(caps.damage_groups or {}) do
		local armor_rating = a_groups[group] or 0
		damage = damage + damage_rating * (armor_rating / 100)
	end

	return math.floor(damage * time_prorate)
end

--- Components.
-- Components are data stored in a mob, that every mob is guaranteed to contain.
-- You can use them in conjunction with callbacks to extend mobs with new
-- functionality, without explicit support from mob mods.
-- @section components

--- Register a mob component.
-- @tparam ComponentDef component_def
-- @function register_component
local component_defs
component_defs, cmi.register_component = make_callback_table()

--- Get a component from a mob.
-- @tparam mob ObjectRef|luaentity mob
-- @string component_name
-- @return The requested component, or nil if it doesn't exist
-- @function get_mob_component
cmi.get_mob_component = on_entity("get_mob_component", function(mob, c_name)
	return mob._cmi_components.components[c_name]
end)

--- Set a component in a mob.
-- @tparam mob ObjectRef|luaentity mob
-- @string component_name
-- @param new_value
-- @function set_mob_component
cmi.set_mob_component = on_entity("set_mob_component", function(mob, c_name, new)
	mob._cmi_components.components[c_name] = new
end)

--- Unique Ids.
-- Every mob gets a unique ID when they are created. This feature is implemented
-- as a component, so you can use it as an example.
-- @section uids

local function show_hex(str)
	local len = #str
	local results = {}
	for i = 1, len do
		table.insert(results, string.format("%x", str:byte(i)))
	end

	return table.concat(results)
end

-- This is an ID that will be (probabilistically) unique to this session.
local session_id = SecureRandom() and show_hex(SecureRandom():next_bytes(16))

-- Fallback to math.rand with a warning
if not session_id then
	minetest.log("warning",
		"[cmi] SecureRandom() failed, falling back to math.random for unique IDs")
	-- Generate 16 1-byte numbers, stringify them, then join them together
	local id_pieces = {}
	for i=1, 16 do
		table.insert(id_pieces, tostring(math.rand(0, 255)))
	end
	session_id = table.concat(id_pieces, "-")
end

-- A unique ID is generated by appending a counter to the session ID.
local counter = 0
local function generate_id()
	counter = counter + 1
	return session_id .. "-" .. counter
end

cmi.register_component({
	name = "cmi:uid",
	initialize = generate_id,
	serialize = function (x) return x end,
	deserialize = function (x) return x end,
})

--- Get the unique ID of a mob.
-- @tparam ObjectRef|luaentity mob
-- @treturn string
function cmi.get_uid(mob)
	return cmi.get_mob_component(mob, "cmi:uid")
end

--- Implementation: event notification.
-- Functions used to notify CMI when things happen to your mob. Only necessary
-- when you are implementing the interface.
-- @section impl_events

--- Notify CMI that your mob has been punched.
-- Call this before doing any punch handling that is not "read-only".
-- @tparam ObjectRef mob
-- @tparam ?ObjectRef hitter
-- @number time_from_last_punch
-- @tab tool_capabilities
-- @tparam ?vector dir
-- @number damage
-- @tparam ?Id attacker
-- unknown.
-- @return Returns true if punch handling should be aborted.
-- @function notify_punch
cmi.notify_punch = make_notifier(punch_callbacks)

--- Notify CMI that your mob has died.
-- Call this right before calling remove.
-- @tparam ObjectRef mob the dying mob
-- @tparam DeathCause cause cause of death
-- @function notify_die
cmi.notify_die = make_notifier(die_callbacks)

--- Notify CMI that your mob has been activated.
-- Call this after all other mob initialization.
-- @tparam ObjectRef mob the mob being activated
-- @number dtime the time since the mob was unloaded
-- @function notify_activate
cmi.notify_activate = make_notifier(activate_callbacks)

--- Notify CMI that your mob is taking a step.
-- Call this on every step. It is suggested to call it before or after all other
-- processing, to avoid logic errors caused by callbacks handling the same state
-- as your entity's normal step logic.
-- @tparam ObjectRef mob
-- @number dtime
-- @function notify_step
cmi.notify_step = make_notifier(step_callbacks)

--- Implementation: components.
-- Functions related to implementing entity components. Only necessary when you
-- are implementing the interface.
-- @section impl_components

--- Activates component data.
-- On mob activation, call this and put the result in the _cmi_components field of
-- its luaentity.
-- @tparam ?string serialized_data the serialized form of the string, if
-- available. If the mob has never had component data, do not pass this argument.
-- @return component data
function cmi.activate_components(serialized_data)
	local serial_table = serialized_data and minetest.parse_json(serialized_data) or {}

	local components = {}
	for i = 1, #component_defs do
		local def = component_defs[i]
		local name = def.name
		local serialized = serial_table[name]
		components[name] = serialized
			and def.deserialize(serialized)
			or def.initialize()
	end

	return {
		components = components,
		old_serialization = serial_table,
	}
end

--- Serialized component data.
-- When serializing your mob data, call this and put the result somewhere safe,
-- where it can be retrieved on activation to be passed to
-- #{activate_components}.
-- @param component_data
-- @treturn string
function cmi.serialize_components(component_data)
	local serial_table = component_data.old_serialization
	local components = component_data.components

	for i = 1, #component_defs do
		local def = component_defs[i]
		local name = def.name
		local component = components[name]
		serial_table[name] = def.serialize(component)
	end

	return minetest.write_json(serial_table)
end

--- Implementation: health.
-- Functions related to health that are needed for implementation of the
-- interface. Only necessary if you are implementing the interface.
-- @section impl_damage

--- Calculate damage.
-- Use this function when you want to calculate the "default" damage. If you
-- are a modder who wants to switch out the damage mechanism, do not replace
-- this function. Replace #{damage_calculator} instead.
-- @tparam ObjectRef mob
-- @tparam ?ObjectRef puncher
-- @tparam number time_from_last_punch
-- @tparam table tool_capabilities
-- @tparam ?vector direction
-- @tparam ?Id attacker
-- @treturn number
function cmi.calculate_damage(...)
	return cmi.damage_calculator(...)
end
