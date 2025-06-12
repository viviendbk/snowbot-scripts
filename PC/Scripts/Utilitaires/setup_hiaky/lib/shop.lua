
--- <messages>

function NpcGenericActionRequestMessage(npcId, actionId, npcMapId)
    local message = developer:createMessage("NpcGenericActionRequestMessage")
    message.npcId = npcId
    message.npcActionId = actionId
    message.npcMapId = npcMapId
    developer:sendMessage(message)
end

--- </messages>


--- <Shop>

local insert, remove, sort = table.insert, table.remove, table.sort
Shop = {}

--- Launch sell bidhouse mode
function Shop:goSellMode()
    NpcGenericActionRequestMessage(-1, 5, map:currentMapId())
end

--- Launch buy bihouse mode
function Shop:goBuyMode()
    NpcGenericActionRequestMessage(-1, 6, map:currentMapId())
end

function Shop:buyItem(uid, qty, price)
    local message = developer:createMessage("ExchangeBidHouseBuyMessage")
    message.uid = uid
    message.qty = qty
    message.price = price

    developer:sendMessage(message)
end

function Shop:getAllItemPrices(itemID)
    local message = developer:createMessage("ExchangeBidHouseSearchMessage")
    message.genId = itemID
    message.follow = true

    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 500, false)
end

--- </Shop>