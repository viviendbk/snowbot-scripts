LvlDD = nil

function ManageXpMount()
    local myMount = mount:myMount()
    if myMount ~= nil then
        if myMount.level < 100 then
            global:printSuccess("dd level : " .. myMount.level)
            mount:setXpRatio(90)
        else
            mount:setXpRatio(0)
        end
        if not mount:isRiding() then
            mount:toggleRiding()
        end
    end
end

function _AnalyseDD(message)
    developer:unRegisterMessage("MountDataMessage")
    LvlDD = message.mountData.level
    global:leaveDialog()
end

function GetDDInfLvl100()
    local toReturn = {}
    local content = inventory:inventoryContent()

    for _, element in ipairs(content) do
        if inventory:itemTypeId(element.objectGID) == 97 then

            local message = developer:createMessage("MountInformationRequestMessage")
            message.id = element.effects[1].id
            message.time = element.effects[1].expirationDate
            developer:registerMessage("MountDataMessage", _AnalyseDD)
            developer:sendMessage(message)
            developer:suspendScriptUntil("MountDataMessage", 2000, true)
            global:printSuccess(LvlDD)

            if LvlDD < 100 then
                toReturn[#toReturn+1] = {element.objectGID, element.objectUID}
            end
            
        end
    end
    return toReturn
end

function GetNbDD()
    local toReturn = 0
    local content = inventory:inventoryContent()

    for _, element in ipairs(content) do
        if inventory:itemTypeId(element.objectGID) == 97 then
            toReturn = toReturn + 1
        end
    end
    return toReturn
end

function GetDDLvl100()
    local toReturn = {}
    local content = inventory:inventoryContent()

    for _, element in ipairs(content) do
        if inventory:itemTypeId(element.objectGID) == 97 then

            local success, result = pcall(function()
                -- Code that might produce an error
                global:printSuccess(element.effects[1].id)
                return "This will not be reached"
            end)
            
            if success then
                local message = developer:createMessage("MountInformationRequestMessage")
                message.id = element.effects[1].id
                message.time = element.effects[1].expirationDate
    
                developer:registerMessage("MountDataMessage", _AnalyseDD)
                developer:sendMessage(message)
                developer:suspendScriptUntil("MountDataMessage", 2000, true)
    
                if LvlDD == 100 then
                    toReturn[#toReturn+1] = {element.objectGID, element.objectUID}
                end
            else
                global:printSuccess("La dd a un certificat invalide, on la delete")
                local message = developer:createMessage("ObjectDeleteMessage")
                message.objectUID = element.objectUID
                message.quantity = 1
                developer:sendMessage(message)
                developer:suspendScriptUntil("ObjectDeletedMessage", 2000, true)
            end
            
        end
    end
    return toReturn
end


function GetAllDD()
    local toReturn = {}
    local content = inventory:inventoryContent()

    for _, element in ipairs(content) do
        if inventory:itemTypeId(element.objectGID) == 97 then

            local success, result = pcall(function()
                -- Code that might produce an error
                global:printSuccess(element.effects[1].id)
                return "This will not be reached"
            end)
            
            if success then
                local message = developer:createMessage("MountInformationRequestMessage")
                message.id = element.effects[1].id
                message.time = element.effects[1].expirationDate
    
                developer:registerMessage("MountDataMessage", _AnalyseDD)
                developer:sendMessage(message)
                developer:suspendScriptUntil("MountDataMessage", 2000, true)
                toReturn[#toReturn+1] = {element.objectGID, element.objectUID}
            else
                global:printSuccess("La dd a un certificat invalide, on la delete")
                local message = developer:createMessage("ObjectDeleteMessage")
                message.objectUID = element.objectUID
                message.quantity = 1
                developer:sendMessage(message)
                developer:suspendScriptUntil("ObjectDeletedMessage", 2000, true)
            end
            
        end
    end
    return toReturn
end