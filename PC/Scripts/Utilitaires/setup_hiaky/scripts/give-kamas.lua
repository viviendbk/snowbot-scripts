
--- <init>

PATH =  "C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\setup_hiaky\\"
scriptName = "give-kamas.lua"
dofile(PATH .. "template.lua")
dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\IMPORT_LIBRARIES.lua")
local enEchange = false

function truncate(nbr, size)
    if not nbr then return 0 end
    if not size then size = 2 end
    if size == 0 then size = -1 end
    
    nbr = tostring(nbr) 
    return nbr:sub(1, nbr:find("%p") + size)
end

function truncKamas(amount)
    amount = tonumber(amount) or character:kamas()
    amount = amount / 1000000

    return truncate(amount, 0)
end

-- function messagesRegistering()
--     for _, message in ipairs(developerMessages) do
--         developer:registerMessage(message, messageHandler)
--     end
-- end

--- </init>

createMessageInstance("ExchangeRequestedTradeMessage")
function ExchangeRequestedTradeMessage:receive(message)
    global:printSuccess("ok")
    if Utils:isInTable(Exch.whitelist, message.source) then
        global:printSuccess("11")
        global:delay(100, 250)
        Exch:accept()
        global:printSuccess("22")

        Exch.inTrade = message.source
    else Exch:refuse() end
end

function _handleTradeRequest(message)
    global:printSuccess("echange reçu")
    if isAccountKnown(message.source) then
        global:printSuccess("on connait le personnage, echange accepté")
        developer:sendMessage(developer:createMessage("ExchangeAcceptMessage"))
    else
        global:printError("on ne connait pas le personnage, echange refusé")
        global:leaveDialog()
    end
    enEchange = true
end


function giveKamas()
    global:printSuccess("dac1")

    local counter = 0
    local thisOrder = nil

    developer:registerMessage("ExchangeRequestedTradeMessage", _handleTradeRequest)
    developer:suspendScriptUntil("ExchangeRequestedTradeMessage", 20000, false)


    while not enEchange and counter < 30 do
        debug("a")

        developer:suspendScriptUntil("ExchangeRequestedTradeMessage", 1000, false)
        counter = counter + 1
    end

    if counter >= 30 then
        return
    end
    
    global:printSuccess("dac2")

    if not enEchange then return self:giveKamas() end
    global:printSuccess("dac3")

    for _, order in ipairs(self.orders) do
        if enEchange == order.id then thisOrder = order break end
    end
    global:printSuccess(thisOrder.kAmount)

    if character:kamas() < thisOrder.kAmount then

        local orderer = Ctrl:getControllerBy(function(acc)
            return acc.character():id() == thisOrder.id
        end)

        if orderer then orderer:disconnect() end
        global:disconnect()
    end
    global:printSuccess("dac5")

    global:printSuccess("on envoie " .. thisOrder.kAmount .. " kamas")
    exchange:putKamas(thisOrder.kAmount)

    global:delay(math.random(2000, 4000))

    exchange:ready()
end

function isAccountKnown(id)
    local accounts = snowbotcontroller:getLoadedAccounts()
    for _, account in ipairs(accounts) do
        if account:getId() == id then
            return true
        end
    end
    return false
end


function move()
    mapDelay()
    global:editAlias("bank_" .. character:server():lower() .. " : [" .. truncKamas() .. "m]", true)
    return Moving:goAstrubBank(function() 
        setBotBankConnected(character:server(), true)
        Exch:giveKamas()
        global:delay(40000)
        setBotBankConnected(character:server(), false)
        global:disconnect()
    end)
end