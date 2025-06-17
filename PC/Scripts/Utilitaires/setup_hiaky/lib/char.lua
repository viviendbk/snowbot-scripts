
local insert, remove, sort = table.insert, table.remove, table.sort

--- <Char>

Char = {}

--- </Char>


function Char:restat(acc)
    local accDeveloper = acc and acc.developer or developer

    accDeveloper:sendMessage(developer:createMessage("ResetCharacterStatsRequestMessage"))
    developer:suspendScriptUntil("CharacterStatsListMessage", 500, false)
end

function Char:getAccountTag(acc)
    local accDeveloper = acc and acc.developer or developer
    local accountTag = accDeveloper:historicalMessage("IdentificationSuccessMessage")[1].accountTag

    return {
        nickname = accountTag.nickname,
        tag = accountTag.tagdouble,
        formated = accountTag.nickname .. "#" .. accountTag.tagdouble
    }
end

function Char:getRemainingSubscription(inDay, acc)
    local accDeveloper = acc and acc.developer or developer

    local endDate = developer:historicalMessage("IdentificationSuccessMessage")[1].subscriptionEndDate 
    local now = os.time(os.date("!*t")) * 1000

    endDate = math.floor((endDate - now) / 3600000)

    if verbose then global:printMessage("[INFO] : Temps d'abonnement restant : " .. endDate) end
    return inDay and math.floor(endDate / 24) or endDate
end


function Char:setOrnament(ornamentID, acc)
    local accDeveloper = acc and acc.developer or developer

    local message = accDeveloper:createMessage("OrnamentSelectRequestMessage")
    message.ornamentId = ornamentID

    accDeveloper:sendMessage(message)
end


--- </Char>