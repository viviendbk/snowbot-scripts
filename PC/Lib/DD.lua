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
    LvlDD = message.mount_data.level
    global:leaveDialog()
end

function GetDDInfLvl100()

    local toReturn = {}
    local content = inventory:inventoryContent()
    printVar(content)
    for _, element in ipairs(content) do
        if inventory:itemTypeId(element.objectGID) == 97 then
            printVar(element.effects[1])
            debug(element.effects[1].expirationDate)
        end
    end

    for _, element in ipairs(content) do
        if inventory:itemTypeId(element.objectGID) == 97 then

            local message = developer:createMessage("MountInformationRequest")
            message.mount_id = element.objectGID
            message.time = element.effects[1].expirationDate
            developer:registerMessage("MountDataEvent", _AnalyseDD)
            developer:sendMessage(message)
            developer:suspendScriptUntil("MountDataEvent", 2000, true)
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
                local message = developer:createMessage("MountInformationRequest")
                message.mount_id = element.effects[1].id
                message.time = element.effects[1].expirationDate
    
                developer:registerMessage("MountDataEvent", _AnalyseDD)
                developer:sendMessage(message)
                developer:suspendScriptUntil("MountDataEvent", 2000, true)
    
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
                local message = developer:createMessage("MountInformationRequest")
                message.mount_id = element.effects[1].id
                message.time = element.effects[1].expirationDate
    
                developer:registerMessage("MountDataEvent", _AnalyseDD)
                developer:sendMessage(message)
                developer:suspendScriptUntil("MountDataEvent", 2000, true)
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

function getUIDOfDD()
    local content = inventory:inventoryContent()
    for _, element in ipairs(content) do
        if inventory:itemTypeId(element.objectGID) == 97 then
            return element.objectUID
        end
    end
    return nil
end

function equipDD(objectUID)
    map:moveToCell(332)
    map:door(357)
    local message = developer:createMessage("ExchangeHandleMountsRequest")
    if message then
        message.rides_id:Add(objectUID)
        message.action_type = 14 -- 12 pour déséquiper, 14 pour équiper
        developer:sendMessage(message)
        developer:suspendScriptUntil("MountEquippedEvent", 2000, true)
        global:printSuccess("DD équipée")
    else
        global:printError("Impossible d'équiper la DD")
    end
    randomDelay()
    global:leaveDialog()
end

function buyAndfeedDD()
    local index = 0
    local minPrice = 500000000
    local TableAchat = {
        {Name = "Poisson Pané", Id = 1750},
        {Name = "Crabe Sourimi", Id = 1757},
        {Name = "Goujon", Id = 1782},
        {Name = "Brochet", Id = 1847},
        {Name = "Sardine Brillante", Id = 1805},
        {Name = "Cuisse de Boufton", Id = 1911},
        {Name = "Cuisse de Bouftou **", Id = 1912},
        {Name = "Poisson-Chaton", Id = 603},
        {Name = "Bar Rikain", Id = 1779},
    }
    
    for _, element in ipairs(TableAchat) do
        if inventory:itemCount(element.Id) > 0 then
            global:printSuccess("On a déjà de la nourriture pour la DD : " .. element.Name .. "on la nourri")
            mount:feedMount(element.Id, inventory:itemCount(element.Id))
            if inventory:itemCount(element.Id) > 0 then
                return
            end 
        end
    end
    debug("ok")
    HdvSell()

    global:printSuccess("Check du meilleur prix")

    for i, element in ipairs(TableAchat) do
        local Price = GetPricesItem(element.Id).Price100
        if Price ~= nil and Price ~= 0 and Price < minPrice then
            minPrice = Price
            index = i
        end
    end

    global:leaveDialog()

    global:delay(500)

    if minPrice < 6000 then
        HdvBuy()
        sale:buyItem(TableAchat[index].Id, 100, 10000)
        global:leaveDialog()
        mount:feedMount(TableAchat[index].Id, 100)
        global:printSuccess("DD nourrie")

        if inventory:itemCount(TableAchat[index].Id) == 0 then
            global:printError("la dd a bien mangé, on retente de la nourrir")
            buyAndfeedDD()
        end
    else
        global:printSuccess("les prix sont trop cher, on a pas pu acheter")
    end
end