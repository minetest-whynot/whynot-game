
--
-- entity
--

supercub.vector_up = vector.new(0, 1, 0)

minetest.register_entity('supercub:wheels',{
initial_properties = {
	physical = false,
	collide_with_objects=false,
	pointable=false,
	visual = "mesh",
    backface_culling = false,
	mesh = "supercub_wheels.b3d",
	textures = {
        "supercub_painting.png", -- pintura
        "airutils_black.png", --pneus traseiros
        "airutils_metal.png", --rodas traseiras
        },
	},
	
    on_activate = function(self,std)
	    self.sdata = minetest.deserialize(std) or {}
	    if self.sdata.remove then self.object:remove() end
    end,
	    
    get_staticdata=function(self)
      self.sdata.remove=true
      return minetest.serialize(self.sdata)
    end,
	
})

minetest.register_entity('supercub:supercub',
    airutils.properties_copy(supercub.plane_properties)
)

