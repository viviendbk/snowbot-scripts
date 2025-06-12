
local mounts = {}
local Price = 0

local function ScanMount(message)
    local message = developer:toObject(message)

    for i = 1, #mounts do
        if mounts[i].Level == 0 then
            mounts[i].Level = message.mountData.level
            mounts[i].Id = message.mountData.id
            mounts[i].IsRidable = message.mountData.isRideable
        end
    end
end

local function ScanHDV(message)
    developer:unRegisterMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage")
    
    local message = developer:toObject(message)
    local toScan = message.itemTypeDescriptions

    RECONNECT_ON_TIMEOUT = false

    global:printSuccess("SCAN DE L'HDV ...")
    
    for _, element in ipairs(toScan) do
        if element.effects[1].date ~= nil then
            Price = element.prices[1]
            local data = {
                UID = element.objectUID,
                Id = 0,
                Level = 0,
                IsRidable = false,
                Price = element.prices[1]
            }
            table.insert(mounts, data)

            local obj = {}
            obj["call"] = "sendMessage"
            obj["data"] = {
                ["type"] = "MountInformationRequestMessage",
                ["data"] = {
                    ["id"] = math.floor(element.effects[1].mountId),
                    ["time"] = math.floor(element.effects[1].date)
                }
            }

            local msg = developer:fromObject(obj)

            developer:registerMessage("MountDataMessage", ScanMount)

            developer:sendMessage(msg)

            developer:suspendScriptUntil("MountDataMessage", 5000, true, nil, 20)
            developer:unRegisterMessage("MountDataMessage")

        end
    end

    global:printSuccess("SCAN TERMINE!")

    table.sort(mounts, function(a, b)
    return a.Price < b.Price
    end)
    
    global:printSuccess("----------")
    for _, element in ipairs(mounts) do
        if element.IsRidable then
            global:printSuccess("La dd la moins chère montable est lvl " .. element.Level .. " et coute " .. element.Price .. " UID " .. element.UID)

            global:leaveDialog()
            global:delay(500)
            npc:npcBuy()
            global:delay(500)

            local obj = {}
            obj["call"] = "sendMessage"
            obj["data"] = {
                ["type"] = "ExchangeBidHouseBuyMessage",
                ["data"] = {
                    ["uid"] = math.floor(element.UID),
                    ["qty"] = 1,
                    ["price"] = math.floor(element.Price)
                }
            }
            local msg = developer:fromObject(obj)

            developer:sendMessage(msg)            

            developer:suspendScriptUntil("ObjectAddedMessage", 2000, true, nil, 20)
            break
        end
    end
    global:printSuccess("----------")

    RECONNECT_ON_TIMEOUT = true

    global:leaveDialog()

    EquipMount()
    
end

function getUIDOfDD()
    local iContent = inventory:inventoryContent()
    for _, item in ipairs(iContent) do
        if item.objectGID == 7814 then
            return item.objectUID
        end
    end
end

local function AchatDragodinde()
    npc:npcBuy()
    global:delay(2000)
    developer:sendMessage('{"call":"sendMessage","data":{"type":"ExchangeBidHouseTypeMessage","data":{"type":97}}}')
    developer:suspendScriptUntil("ExchangeTypesExchangerDescriptionForUserMessage", 5000, true)
    developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", ScanHDV)
    developer:sendMessage('{"call":"sendMessage","data":{"type":"ExchangeBidHouseListMessage","data":{"id":7814}}}')
end

function EquipMount()
    map:useById(416494, -1)
    local obj = {}
    obj["call"] = "sendMessage"
    obj["data"] = {
        ["type"] = "ExchangeHandleMountStableMessage",
        ["data"] = {
            ["actionType"] = 15,
            ["rideId"] = getUIDOfDD(),
        }
    }
    local msg = developer:fromObject(obj)

    developer:sendMessage(msg)    

    developer:suspendScriptUntil("ObjectDeletedMessage", 2000, true, nil, 20)

    global:leaveDialog()

    mount:toggleRiding()

    if not mount:hasMount() then
        return AchatDragodinde()
    end

    if global:thisAccountController():getAlias():find("Chasseur") then
        global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PL&Zaaps\\PL_Chasseur_Team.lua")
    else
        global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PL&Zaaps\\PL_Team.lua")
    end
end

function GoToBonta()
    if inventory:itemCount(6965) == 0 then
        npc:npcBuy()
        global:delay(500)
        sale:buyItem(6965, 1, 1000)
        if inventory:itemCount(6965) == 0 then
            sale:buyItem(6965, 10, 10000)
        end
        global:delay(500)
        global:leaveDialog()
        global:delay(500)
    end
    inventory:useItem(6965)
end



function move()

    if not map:onMap(149816) and not map:onMap(5506048) and not map:onMap(147764) and not map:onMap(150328) then
        GoToBonta()
    end
    if not map:onMap(150328) then
        return {
            {map = "4720135", door = "326"},
            {map = "4719111", path = "409"},
            {map = "147764", path = "zaapi(149816)"},
            {map = "5506048", path = "zaapi(149816)"},
            {map = "149816", path = "left"},
        }
    else
        AchatDragodinde()   
    end
end

