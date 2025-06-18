dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Lib\\IMPORT_LIBRARIES.lua")

local function openFile(path, del)
    local fileResult = io.open(path, "r")

    if fileResult then
        local content = fileResult:read("*a")
        fileResult:close()

        if del then os.remove(path) end

        return path:find(".json")
            and json.decode(content)
            or content 
    end
end

local effectsEnum = openFile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Utilitaires\\setup_hiaky\\auto_stuff\\data\\effects_enum.json")
local json = dofile(PATH .. "\\lib\\json.lua")


local function find(tab, callback)
    local value = callback
    
    callback = type(callback) == "function"
        and callback
        or function(element)
            return element == value 
        end

    for k, v in pairs(tab) do
        if callback(v) then
            return v
        end
    end
end



function move()
    local content = inventory:inventoryContent()
    for _, element in ipairs(content) do
        print:table(element.effects)
    end
    GetDices(8265)
end