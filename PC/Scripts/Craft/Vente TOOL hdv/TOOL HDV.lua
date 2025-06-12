


---Fonction qui permet de recuperer les nombres de lots d'un item en HDV.
function get_quantity(id)
    if object_in_hdv then
        local informations = {
            id = id,
            quantity = {
                ["1"] = 0,
                ["10"] = 0,
                ["100"] = 0
            },
            total_quantity = 0,
            total_lots = 0,
        }

        for _, info in ipairs(object_in_hdv) do
            if info.id == id then
                informations.quantity["1"] = info.quantity["1"]
                informations.quantity["10"] = info.quantity["10"]
                informations.quantity["100"] = info.quantity["100"]
                informations.total_quantity = info.quantity["1"] * 1 + info.quantity["10"] * 10 + info.quantity["100"] * 100
                informations.total_lots = info.quantity["1"] + info.quantity["10"] + info.quantity["100"]
            end
        end

        return informations
    else
        global:printError("[INFO] - l'HDV n'a pas été scanné je ne peux donc pas resortir les quantités demandées.")
    end
end

---Fonction qui permet de scanner l'hotel de vente.
function stack_items_informations(message)
    developer:unRegisterMessage("ExchangeStartedBidSellerMessage")
    object_in_hdv = {}
    may_add_id = true

    for _, item in pairs(message.objectsInfos) do
        for _, info in ipairs(object_in_hdv) do
            if info.id == item.objectGID then
                may_add_id = false

                break
            end
        end

        if may_add_id then
            table.insert(object_in_hdv,{ id = item.objectGID, quantity = {["1"] = 0, ["10"] = 0, ["100"] = 0}})
        end

        may_add_id = true
    end

    for _, item in pairs(message.objectsInfos) do
        for _, info in ipairs(object_in_hdv) do
            if info.id == item.objectGID then
                info.quantity[tostring(item.quantity)] = info.quantity[tostring(item.quantity)] + 1
            end
        end
    end
end

function HdvSell()
    developer:registerMessage("ExchangeStartedBidSellerMessage", stack_items_informations)
    local message = developer:createMessage("NpcGenericActionRequestMessage")
    message.npcId = -1
    message.npcActionId = 5
    message.npcMapId = map:currentMapId()
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 2000, true)
end


function SellTable(Table)
    table.sort(Table, function(a, b) return inventory:itemCount(a.Id) > inventory:itemCount(b.Id) end)

    HdvSell()
    global:delay(math.random(1000, 4000))
    for i, element in ipairs(Table) do
        if inventory:itemCount(element.Id) == 0 then 
            global:printSuccess("on a plus rien à vendre") 
            break 
        end
        local Priceitem = GetPricesItem(element.Id)

        local cpt = get_quantity(element.Id).quantity["100"]
        Priceitem3 = ((Priceitem.Price100 == nil) or (Priceitem.Price100 == 0) or (Priceitem.Price100 == 1)) and sale:getAveragePriceItem(element.Id, 3) * 1.5 or Priceitem.Price100
        while (inventory:itemCount(element.Id) >= 100) and (sale:availableSpace() > 0) and (cpt < element.MaxHdv100) do 
            sale:sellItem(element.Id, 100, Priceitem3 - 1) 
            global:printSuccess("1 lot de " .. 100 .. " x " .. inventory:itemNameId(element.Id)  .. " à " .. Priceitem3 - 1 .. "kamas")
            cpt = cpt + 1
        end

        cpt = get_quantity(element.Id).quantity["10"]
        local Priceitem2 = ((Priceitem.Price10 == nil) or (Priceitem.Price10 == 0) or (Priceitem.Price10 == 1)) and sale:getAveragePriceItem(element.Id, 2) * 1.5 or Priceitem.Price10
        while (inventory:itemCount(element.Id) >= 10) and (sale:availableSpace() > 0) and (cpt < element.MaxHdv10) do 
            sale:sellItem(element.Id, 10, Priceitem2 - 1) 
            global:printSuccess("1 lot de " .. 10 .. " x " .. inventory:itemNameId(element.Id) .. " à " .. Priceitem2 - 1 .. "kamas")
            cpt = cpt + 1
        end

        cpt = get_quantity(element.Id).quantity["1"]
        local Priceitem1 = ((Priceitem.Price1 == nil) or (Priceitem.Price1 == 0) or (Priceitem.Price1 == 1)) and sale:getAveragePriceItem(element.Id, 1) * 1.5 or Priceitem.Price1
        while (inventory:itemCount(element.Id) >= 1) and (sale:availableSpace() > 0) and (cpt < element.MaxHdv1) do 
            sale:sellItem(element.Id, 1, Priceitem1 - 1) 
            global:printSuccess("1 lot de " .. 1 .. " x " .. inventory:itemNameId(element.Id)  .. " à " .. Priceitem1 - 1 .. "kamas")
            cpt = cpt + 1
        end
        global:delay(math.random(1000, 4000))

        global:leaveDialog()
    end
end