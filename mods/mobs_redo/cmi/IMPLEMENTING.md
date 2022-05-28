This document explains how to implement the common mob interface in your mob mod.
It also serves as a reference for developing the interface itself.

luaentity fields
================
CMI requires mobs to add some fields to their luaentities.

Required
--------
#### _cmi_is_mob
This must be a single boolean field set to `true` at all times.

#### _cmi_components
This must contain active component data. See the components section.

Optional
--------
#### description
If implemented, this must be  a string field with a player-readable mob name,
like "chicken" or "zombie". If absent, CMI will use the part of the entity name
after the colon.

#### _cmi_attack
If implemented, this must be a method like punch, except taking another parameter
for an Attacker (see the usage documentation). Note that since this is a method
of the luaentity and not of the ObjectRef, the first argument will be a
luaentity, not an ObjectRef. This method must handle nil attackers. If absent,
CMI will default to using ordinary entity punches, throwing away the attacker
information.

Event Notification
==================
CMI requires mobs to notify it when certain things happen to the mob.

Required
--------
#### Punches
When your mob is punched, it must call notify_punch to signal that it got
punched (see the usage documentation). If attacker information is available, it
should be passed as the appropriate parameter. To be clear, attacker information
is always "indirect" attacker information. Generally you should only pass it when
it is passed through the optional attack method described earlier. If
notify_punch returns true, it means the punch was handled specially and you
should abort punch handling. You should notify_punch after damage calculation,
but before doing anything else.

#### Death
When your mob dies, it must call notify_die to signal that it died (see the usage
documentation). A cause of death should be passed if known.

#### Activation
When your mob is activated, it must call notify_activate. You should call it
after any other mob initialization that may change the mob's state.

#### Step
Your mob's on_step must call notify_step exactly once. It is suggested you call
it before or after all other processing, to avoid logic errors caused by
callbacks handling the same state as your other on_step processing.

Components
==========
CMI includes mob components, which are sort of like attributes, except there is
a fixed set of them and they are guaranteed to be present on every mob.
Implementing this part of the interface just involves doing some serialization
and deserialization.

Deserialization
---------------
In your mob's on_activate, you must call activate_components (see the usage
documentation) on serialized data (see below) if available, or else with no
arguments. Put the result in your mob's luaentity's _cmi_components field.

Serialization
-------------
In your mob's get_staticdata, you must call serialize_components (see the usage
documentation) on your mob's luaentity's _cmi_components field, and store the
result somewhere where it can be retrieved the next time the mob is activated.

Other
=====
Stuff I couldn't think of a category for.

Punch Damage Calculation
------------------------
CMI allows modders to switch out the damage calculation mechanism used for
punching mobs. When calculating the "default" damage, use calculate_damage from
CMI instead. This, along with punchplayer callbacks, allows modders to introduce
new damage systems to the game.