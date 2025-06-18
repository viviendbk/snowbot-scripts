dofile("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Lib\\IMPORT_LIBRARIES.lua")



function move()
    local content = inventory:inventoryContent()
    for _, element in ipairs(content) do
        print:table(element.effects)
    end
    GetDices(8265)
end