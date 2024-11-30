-- Function to extract textures from a node definition
local function getTexturesFromNode(node)
    local textures = {}

    if node.tiles then
        if type(node.tiles) == "string" then
            table.insert(textures, node.tiles)
        elseif type(node.tiles) == "table" then
            for _, tile in pairs(node.tiles) do
                if type(tile) == "string" then
                    table.insert(textures, tile)
                end
            end
        end
    end

    return textures
end

-- Function to extract textures from an entity definition
local function getTexturesFromEntity(entityDef)
    local textures = {}

    if entityDef.textures then
        if type(entityDef.textures) == "string" then
            table.insert(textures, entityDef.textures)
        elseif type(entityDef.textures) == "table" then
            for _, texture in pairs(entityDef.textures) do
                if type(texture) == "string" then
                    table.insert(textures, texture)
                end
            end
        end
    end

    return textures
end

-- Function to extract textures from an item definition
local function getTexturesFromItem(itemDef)
    local textures = {}

    if itemDef.inventory_image then
        table.insert(textures, itemDef.inventory_image)
    end

    return textures
end

--function to remove duplicates and invalid for textlist
local function filter_texture_names(list_to_test)
    local hash = {}
    local result = {}
    for _,v in ipairs(list_to_test) do
        if not string.find(v, ",") then
           if (not hash[v]) then
               result[#result+1] = v
               hash[v] = true
           end
        end
    end
    return result
end

-- Function to list all loaded textures
local function listLoadedTextures()
    local loadedTextures = {}

    --nodes
    for name, node in pairs(minetest.registered_nodes) do
        local textures = getTexturesFromNode(node)

        for _, texture in pairs(textures) do
            table.insert(loadedTextures, texture)
        end
    end
    airutils.all_game_textures = filter_texture_names(loadedTextures)

    --entities
    loadedTextures = {}
    for name, entityDef in pairs(minetest.registered_entities) do
        local textures = getTexturesFromEntity(entityDef)

        for _, texture in pairs(textures) do
            table.insert(loadedTextures, texture)
        end
    end
    airutils.all_entities_textures = filter_texture_names(loadedTextures)

    --items
    loadedTextures = {}
    for name, itemDef in pairs(minetest.registered_items) do
        local textures = getTexturesFromItem(itemDef)

        for _, texture in pairs(textures) do
            table.insert(loadedTextures, texture)
        end
    end

    if airutils.is_minetest then
        table.insert(loadedTextures,'bubble.png')
        table.insert(loadedTextures,'heart.png')
    end
    airutils.all_items_textures = filter_texture_names(loadedTextures)
end

-- Function to check if a texture is in the list of loaded textures
function airutils.isTextureLoaded(textureToFind)
    if not airutils.all_game_textures then
        listLoadedTextures()
    end
    local textures = airutils.all_game_textures

    for _, texture in pairs(textures) do
        if texture == textureToFind then
            return true
        end
    end

    textures = airutils.all_entities_textures

    for _, texture in pairs(textures) do
        if texture == textureToFind then
            return true
        end
    end

    textures = airutils.all_items_textures

    for _, texture in pairs(textures) do
        if texture == textureToFind then
            return true
        end
    end

    return false
end
