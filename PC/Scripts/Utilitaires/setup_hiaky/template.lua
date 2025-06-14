
--- <routes>

CONFIG_PATH = PATH .. "configs\\"
TEMP_PATH = PATH .. "temp\\"
LIB_PATH = PATH .. "lib\\"
DATA_PATH = PATH .. "data\\"
SCRIPTS_PATH = PATH .. "script\\"

dofile(PATH .. "env.lua")
dofile(PATH .. "modules\\print.lua")
json = dofile(PATH .. "modules\\json.lua")

dofile(LIB_PATH .. "char.lua")
dofile(LIB_PATH .. "ctrl.lua")
dofile(LIB_PATH .. "err-string.lua")
dofile(LIB_PATH .. "exch.lua")
dofile(LIB_PATH .. "file.lua")
dofile(LIB_PATH .. "items.lua")
dofile(LIB_PATH .. "misc.lua")
dofile(LIB_PATH .. "moving.lua")
dofile(LIB_PATH .. "shop.lua")
dofile(LIB_PATH .. "utils.lua")
--- </routes>


--- <variables>

local insert, remove, sort = table.insert, table.remove, table.sort

files, import = global:getAllFilesNameInDirectory(LIB_PATH, ".lua"), {}
setmetatable(import, import)

--- </variables>


--- <import>

local importBlacklist = {
    "banking",
    "char",
    "debug",
    "shop"
}

-- for _, element in ipairs(files) do
--     insert(importBlacklist, element)
-- end

verbose = nil

for _, element in ipairs(files) do
    import[element:match("%a+")] = function()
        if verbose or verb then print:info(element) end

        local noImport = nil

        for k, v in ipairs(importBlacklist) do
            if v == element then noImport = true end
        end

        if not noImport then  dofile(LIB_PATH .. "\\" .. element) end
    end
end

import.__call = function(self)
    if myController:isTeamLeader() then
        if verbose then print:successInfo("Import de la librairie...") end
    end
    for _, element in pairs(self) do
        if element ~= self.__call and element ~= self.setVerbose then
            element()
        end
    end
    if myController:isTeamLeader() then
        if verbose then print:successInfo("Librairie importée.") print:void() end
    end
end

--- </import>


--- <mode dev>

import()

developerTypes, developerMessages = {}, {}

function createMessageInstance(messageName)
    if not _G[messageName] then
        _G[messageName] = {}
        insert(developerMessages, messageName)
    end
end

function messageHandler(message)
    if not developer:isScriptPlaying() then return end
    
    local messageName = developer:typeOf(message)
    local messageInstance = _G[messageName]

    if not messageInstance then
        global:printError("La méthode du message " .. messageName .. " n'existe pas")
        return
    else
        messageInstance.came = true
    end
    
    if not messageInstance.receive then
        global:printError("La méthode receive du message " .. messageName .. " n'existe pas")
        return
    end

    messageInstance:receive(message)
    messageInstance.came, messageInstance.result = nil, nil
end


dofile(PATH .. "parameters.lua")

TEMP_BY_SERVER_PATH = TEMP_PATH .. character:server()
server = character:server()

--- </mode dev>

--- <misc>
