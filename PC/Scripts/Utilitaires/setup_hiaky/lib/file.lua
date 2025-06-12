--- <file>

File = {}


function File:openJsonFile(path)
    local file = io.open(path, "r")
    local content = file:read("*a")
    file:close()
    local data = json.decode(content)
    return data
end

function File:openFile(path, JSON)
    local fileResult = io.open(path, "r")
    local content = fileResult:read("*a")
    
    if not content then
        content = {}
    end
    fileResult:close()

    return JSON and json.decode(content) or content
end

function File:writeJsonData(path, data, parse)
    print(path)
    local file = io.open(path, "w")
    file:write(parse and json.encode(data) or data)
    file:close()
end

function File:eraseAndWrite(file, data, parse, verbose)
    if verbose then print("erasing...") end
    io.open(file, "w"):close()

    if verbose then print("writing...") end
    self:writeJsonData(file, data, parse)

    if verbose then print("written") end
end

function File:forceFile(path, limit, json)
    local result, force, loops = nil, nil, 0

    if not tonumber(limit) then
        limit, force = 100, true
    end

    global:delay(rndm(10, 50))
    
    while not result do
        result = Utils:try(function()
            return File:openFile(path, json) 
        end)

        global:delay(1)
        
        loops = plus(loops)

        if loops >= limit then
            if force then
                return self:forceFile(path, limit, json)
            else
                break
            end
        end
    end
    
    return result, status
end


--- </file>
