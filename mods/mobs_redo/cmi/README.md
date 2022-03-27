# Common Mob Interface

Purpose
=======
There are multiple mob frameworks which provide APIs for creating mobs. This is
good since it gives modders a variety of different ways to make mobs, and one
framework might be more suited to making a particular mob than another. But
implicitly they also all provide their own API for "using" mobs: things like
checking if an entity is a mob or doing things on mob death. This is bad because
modders who want to interface with mobs created by other modders need to code to
as many interfaces as there are mob frameworks. CMI is a mod that provides the
"one true mob interface". It is designed to be extensible and easy to integrate.

Usage
=====
Usage documentation is provided as LDoc comments in the source files. To get
nicely-formatted docs, you can run ldoc on init.lua.

Implementing in your mob mod/framework
======================================
Part of the implementation of this interface is in the mods that support it. If
you are a mob framework author or making a mob without a framework, and you want
to support CMI, take a look at IMPLEMENTING.md.