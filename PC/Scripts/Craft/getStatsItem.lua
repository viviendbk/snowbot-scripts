dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\IMPORT_LIBRARIES.lua")

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

local function switch(value, cases)
    local rawValue = type(value) == "function"
        and value()
        or value

    local field = nil

    local isBool = function()
        local bools = { "true", "false", "nil" }
        
        local found = find(bools, function(elem)
            return elem == tostring(rawValue)
        end)

        return found
    end

    field = isBool() and tostring(rawValue) or rawValue

    if not field or not cases[field] then
        return cases.default
    end

    local result = type(cases[field]) == "function"
        and cases[field](rawValue)
        or cases[field]

    return result
end

local function getEffect(data)
    local search = switch(type(data), {
        ["number"] = { id = data, name = "" },
        ["string"] = { id = 0, name = data },
        ["table"] = data,
    })

    return find(effectsEnum, function(effect)
        return effect.id == search.id
            or effect.name == search.name
    end)
end

local function clone(tab)
    local result = {}
    for k, v in pairs(tab) do
        local value = v
        if type(v) == "table" then
            value = clone(v)
        end

        result[k] = value
    end

    return result
end

function GetDices(Id)
    local dices = {}
    local itemData = d2data:objectFromD2O("Items", Id)

    if not itemData then
        global:printError("ok")

        return {}
    end

    global:printSuccess("1")
    itemData = itemData.Fields

    for k, v in ipairs(itemData.possibleEffects) do
        local data = v.Fields
        local effect = getEffect(data.effectId)

        if effect then
            effect = clone(effect)

            if not effect.name:find("Degats") then
                local diceSide = data.diceSide == 0
                    and data.diceNum
                    or data.diceSide

                global:printSuccess(diceSide)
                effect.dice = {
                    min = data.diceNum,
                    max = diceSide 
                }

                table.insert(dices, effect)
            end
        end
    end

    return dices
end


function move()
    local content = inventory:inventoryContent()
    for _, element in ipairs(content) do
        print:table(element.effects)
    end
    GetDices(8265)
end