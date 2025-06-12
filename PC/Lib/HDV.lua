function HdvSell()
    developer:registerMessage("ExchangeStartedBidSellerMessage", _Stack_items_informations)
    local message = developer:createMessage("NpcGenericActionRequestMessage")
    message.npcId = -1
    message.npcActionId = 5
    message.npcMapId = map:currentMapId()
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 2000, false, nil, 50)
end

function HdvSell2()
    developer:registerMessage("ExchangeStartedBidSellerMessage", _StackInfosHdvInJson)
    local message = developer:createMessage("NpcGenericActionRequestMessage")
    message.npcId = -1
    message.npcActionId = 5
    message.npcMapId = map:currentMapId()
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 2000, false, nil, 50)
end

function HdvBuy()
    message = developer:createMessage("NpcGenericActionRequestMessage")
    message.npcId = -1
    message.npcActionId = 6
    message.npcMapId = map:currentMapId()
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 2000, false, nil, 50)
end

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

        local totalItems = 0 
        local totalDifferentsItems = 0

        for _, info in ipairs(object_in_hdv) do
            totalItems = totalItems + info.quantity["1"] * 1 + info.quantity["10"] * 10 + info.quantity["100"] * 100
            totalDifferentsItems = totalDifferentsItems + 1
            if info.id == id then
                informations.quantity["1"] = info.quantity["1"]
                informations.quantity["10"] = info.quantity["10"]
                informations.quantity["100"] = info.quantity["100"]
                informations.total_quantity = info.quantity["1"] * 1 + info.quantity["10"] * 10 + info.quantity["100"] * 100
                informations.total_lots = info.quantity["1"] + info.quantity["10"] + info.quantity["100"]
            end
        end

        if id == 0 then
            return { totalItems = totalItems, totalDifferentsItems = totalDifferentsItems }
        end

        return informations
    else
        global:printError("[INFO] - l'HDV n'a pas été scanné je ne peux donc pas resortir les quantités demandées.")
    end
end

---Fonction qui permet de scanner l'hotel de vente.
function _Stack_items_informations(message)
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

function _StackInfosHdvInJson(message)
    developer:unRegisterMessage("ExchangeStartedBidSellerMessage")
    local listeHdv = {}
    local totalValue = 0

    for _, item in pairs(message.objectsInfos) do
        for _, item2 in ipairs(listeHdv) do
            if item2.Id == item.objectGID then
                may_add_id = false
                break
            end
        end

        if may_add_id then
            local element = {
                Name = inventory:itemNameId(item.objectGID),
                Id = item.objectGID,
                Price = item.objectPrice
            }
            table.insert(listeHdv, element)
        end

        totalValue = totalValue + item.objectPrice

        may_add_id = true
    end

    local data = openFile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\PC\\Craft\\Craft-Resell.json")

    for _, element in ipairs(data) do
        if element.server == character:server() then
            if global:thisAccountController():getAlias():find("Craft2") then
                element.Value2 = totalValue
                element.ItemsInHDV2 = listeHdv
            else
                element.Value1 = totalValue
                element.ItemsInHDV1 = listeHdv
            end
            element.TotalValue = element.Value1 + element.Value2
        end
    end

    -- Convertir la table Lua modifiée en JSON
    local new_content = json.encode(data)

    -- Écrire les modifications dans le fichier JSON
    file = io.open(global:getCurrentScriptDirectory() .. "\\Craft-Resell.json", "w")
    file:write(new_content)
    file:close()
end

function FinalSelling(Id, UID, Price, MaxPrice, CraftCost, RuneCost)
    local finalPrice = 0

    if Price < 2 then
        HdvSell()
        finalPrice = sale:getAveragePriceItem(Id, 1)

        local message = developer:createMessage("ExchangeObjectMovePricedMessage")
        message.price = finalPrice
        message.objectUID = UID
        message.quantity = 1
        developer:sendMessage(message)
    
        global:printSuccess("1 lot de [" .. inventory:itemNameId(Id) .. "] à " .. finalPrice .. " kamas")
        global:leaveDialog()
    end
    if character:kamas() > Price * 0.03 then
        HdvSell()
        finalPrice = math.max(GetPricesItem(Id).Price1 - 1, Price)

        local message = developer:createMessage("ExchangeObjectMovePricedMessage")
        message.price = finalPrice
        message.objectUID = UID
        message.quantity = 1
        developer:sendMessage(message)
    
        global:printSuccess("1 lot de [" .. inventory:itemNameId(Id) .. "] à " .. Price .. " kamas")
    
        if Price < MaxPrice / 3 and MaxPrice ~= 10000000 and MaxPrice > 100000 and global:thisAccountController():getAlias():find("FM") then
            global:printError("Prb prix ( prix max = " .. MaxPrice .. ")")
        end
    
        global:leaveDialog()
    else
        global:printError("Pas assez de kamas pour vendre, on réessaie dans 2 heures")
        global:reconnect(2)
    end

    if finalPrice > 0 and CraftCost then
        local data = {}
        if global:thisAccountController():getAlias():find("FM") then
            data = openFile(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\Craft-FM-Resell-Data.json")
        else
            data = openFile(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\Craft-Resell-Data.json")
        end
    
        for i = #data[2].Historique, 1, -1 do
            if isXDaysLater(data[2].Historique[i].Date, 30) then
                table.remove(data[2].Historique, i)
            end
        end

        if not CraftCost then
            CraftCost = finalPrice
        end
        if not RuneCost then
            RuneCost = 0
        end

        local renta = finalPrice - (CraftCost + RuneCost)
        table.insert(data[2].Historique, {
            Id = Id,
            Name = inventory:itemNameId(Id),
            CraftCost = CraftCost,
            RuneCost = RuneCost,
            ResellPrice = finalPrice,
            Renta = renta,
            Date = getDate()
        })

        if renta < -1000000 then
            global:printError("On a perdu " .. renta .. " kamas (CraftCost : " .. CraftCost .. ", RuneCost : " .. RuneCost .. ", finalPrice : " .. finalPrice .. ")")
            -- global:disconnect()
        end
        
        data[2].nbKamasInvesti = data[2].nbKamasInvesti + CraftCost + RuneCost
        data[2].EstimationKamasGagnes = data[2].EstimationKamasGagnes + finalPrice
        data[2].RentaNet = data[2].RentaNet + renta
        data[2].RentaPercentage = data[2].EstimationKamasGagnes > 0 and data[2].EstimationKamasGagnes / data[2].nbKamasInvesti or 0
        data[1]["Renta du "..  getDate()] = not data[1]["Renta du "..  getDate()] and renta or data[1]["Renta du "..  getDate()] + renta


        local Renta7Jours = 0
        local i = 1
        for k, v in pairs(data[1]) do
            if not k:find("7 jours") and isXDaysLater(k:split(" ")[3], 7) then
                global:printSuccess("On supprime la date " .. k:split(" ")[3])
                data[1][k] = nil
            elseif not k:find("7 jours") then
                Renta7Jours = Renta7Jours + v
            end
            i = i + 1
        end
        
        data[1]["Renta sur 7 jours"] = Renta7Jours

        local new_content = json.encode(data)
        -- Écrire les modifications dans le fichier JSON
        local file = nil
        if global:thisAccountController():getAlias():find("FM") then
            file = io.open(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\Craft-FM-Resell-Data.json", "w")
        else
            file = io.open(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\Craft-Resell-Data.json", "w")
        end
        file:write(new_content)
        file:close()


    end
end

function _GetBestPrice(message)
    developer:unRegisterMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage")

    local toScan = message.itemTypeDescriptions
    local AllItemsInHdv = {}

    for _, data in ipairs(toScan) do
        local element = {
            PourcentageJetPerf = GetQualityItem(data.effects),
            Price = data.prices[1]
        }
        table.insert(AllItemsInHdv, element)
    end

    table.sort(AllItemsInHdv, function (a, b)
        return a.Price < b.Price        
    end)


    for _, element in ipairs(AllItemsInHdv) do
        if PourcentageJetPerf_ItemToSell < element.PourcentageJetPerf then
            BestPrice = (element.Price > 0) and element.Price - 1 or element.Price
            break
        end
    end

    if BestPrice == 0 then
        BestPrice = AllItemsInHdv[1].Price - 1
    end

    global:printSuccess("Meilleur prix trouvé : " .. BestPrice)
end

function _GetBestPriceFM(message)
    BestPrice = 0
    developer:unRegisterMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage")

    local toScan = message.itemTypeDescriptions
    local AllItemsInHdv = {}

    for _, data in ipairs(toScan) do
        local element = {
            Effects = data.effects,
            PourcentageJetPerf = GetQualityItemWithoutException(data.effects),
            Price = data.prices[1]
        }
        table.insert(AllItemsInHdv, element)
    end

    table.sort(AllItemsInHdv, function (a, b)
        return a.Price < b.Price
    end)

    -- on regarde ici quel item en hdv est mieux fm que le notre et on se base sur son rapport qualité prix pour trouver notre prix
    for i, element in ipairs(AllItemsInHdv) do
        if element.PourcentageJetPerf > PourcentageJetPerf_ItemToSell and AllStatsAreAboveMin(element.Effects, IdToSell) and element.Price ~= ActualPrice then
            global:printSuccess("Le plus rentable coute " .. element.Price .. " et a un % de " .. element.PourcentageJetPerf)
            BestPrice = math.floor((element.Price / element.PourcentageJetPerf) * PourcentageJetPerf_ItemToSell)
            if i > 1 then
                BestPrice = BestPrice * 0.95
            end
            break
        end
    end

    if BestPrice == 0 and #AllItemsInHdv > 0 then
        global:printError("On a pas trouvé de meilleur item")
        table.sort(AllItemsInHdv, function (a, b)
            return (PourcentageJetPerf_ItemToSell - a.PourcentageJetPerf) < (PourcentageJetPerf_ItemToSell - b.PourcentageJetPerf)
        end)
        if AllItemsInHdv[1].Price ~= ActualPrice then
            BestPrice = math.floor((AllItemsInHdv[1].Price / AllItemsInHdv[1].PourcentageJetPerf) * PourcentageJetPerf_ItemToSell * (0.95 + (PourcentageJetPerf_ItemToSell - AllItemsInHdv[1].PourcentageJetPerf)))
        else
            BestPrice = 50000000 -- quand le meilleur prix est déjà le prix de notre item en hdv, on fait en sorte de ne pas changer
        end
        elseif BestPrice == 0 then
        global:printSuccess("Il n'y a plus d'items en vente")
        HdvSell()
        BestPrice = GetPricesItem(IdToSell).AveragePrice
        HdvBuy()
    end

    if BestPrice == 0 and #AllItemsInHdv > 0 then
        BestPrice = AllItemsInHdv[1].Price * 1.2
    end

    BestPrice = TraitementPrix(math.floor(BestPrice))

    global:printSuccess("Meilleur prix trouvé (fm1) : " .. BestPrice)
    ActualPrice = 0
end

function _GetBestPriceFM2(message)
    BestPrice = 0
    developer:unRegisterMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage")

    local toScan = message.itemTypeDescriptions
    local AllItemsInHdv = {}

    for _, data in ipairs(toScan) do
        local element = {
            Effects = data.effects,
            PourcentageJetPerf = GetQualityItemWithoutException(data.effects),
            Price = data.prices[1]
        }
        table.insert(AllItemsInHdv, element)
    end

    table.sort(AllItemsInHdv, function (a, b)
        return a.Price < b.Price
    end)

    -- on regarde ici quel item en hdv est mieux fm que le notre et on se base sur son rapport qualité prix pour trouver notre prix
    for i, element in ipairs(AllItemsInHdv) do
        if element.PourcentageJetPerf > PourcentageJetPerf_ItemToSell and ActualPrice ~= element.Price then
            global:printSuccess("Le plus rentable coute " .. element.Price .. " et a un % de " .. element.PourcentageJetPerf)
            BestPrice = math.floor((element.Price / element.PourcentageJetPerf) * PourcentageJetPerf_ItemToSell)
            if i > 1 then
                BestPrice = BestPrice * 0.95
            end
            break
        end
    end

    if BestPrice == 0 and #AllItemsInHdv > 0 then
        global:printError("On a pas trouvé de meilleur item")
        table.sort(AllItemsInHdv, function (a, b)
            return (PourcentageJetPerf_ItemToSell - a.PourcentageJetPerf) < (PourcentageJetPerf_ItemToSell - b.PourcentageJetPerf)
        end)
        if AllItemsInHdv[1].Price ~= ActualPrice then
            BestPrice = math.floor((AllItemsInHdv[1].Price / AllItemsInHdv[1].PourcentageJetPerf) * PourcentageJetPerf_ItemToSell * (0.95 + (PourcentageJetPerf_ItemToSell - AllItemsInHdv[1].PourcentageJetPerf)))
        else
            BestPrice = 50000000 -- quand le meilleur prix est déjà le prix de notre item en hdv, on fait en sorte de ne pas changer
        end
    elseif BestPrice == 0 then
        global:printSuccess("Il n'y a plus d'items en vente")
        HdvSell()
        BestPrice = GetPricesItem(IdToSell).AveragePrice
        HdvBuy()
    end

    if BestPrice == 0 and #AllItemsInHdv > 0 then
        BestPrice = AllItemsInHdv[1].Price * 1.2
    end

    BestPrice = TraitementPrix(math.floor(BestPrice))

    global:printSuccess("Meilleur prix trouvé (fm2) : " .. BestPrice)
    ActualPrice = 0
end

function _GetBestPriceOver(message)
    BestPrice = 0
    developer:unRegisterMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage")

    local toScan = message.itemTypeDescriptions
    local AllItemsInHdv = {}

    for _, data in ipairs(toScan) do
        local element = {
            Effects = data.effects,
            PourcentageJetPerf = GetQualityItemWithoutException(data.effects),
            PoidsOver = GetPoidsOver(data.effects),
            Price = data.prices[1]
        }
        table.insert(AllItemsInHdv, element)
    end

    table.sort(AllItemsInHdv, function (a, b)
        return a.Price < b.Price
    end)

    for _, element in ipairs(AllItemsInHdv) do
        if PoidsOver > 0 and (((element.PourcentageJetPerf / PourcentageJetPerf_ItemToSell) * 1.5 + (element.PoidsOver / PoidsOver) * 0.5) / 2 > 1) and AllStatsAreAboveMin(element.Effects, IdToSell) and element.Price ~= ActualPrice then
            global:printSuccess("Le plus rentable coute " .. element.Price .. " et a un % de " .. element.PourcentageJetPerf)
            BestPrice = math.floor((element.Price / element.PourcentageJetPerf) * PourcentageJetPerf_ItemToSell * 0.95)
            break
        end
    end    

    -- si on a pas trouvé, on regarde quel item se rapproche le plus du notre et on calcul son rapport qualité prix
    -- piste d'amélioration : regarder lequel item a le meilleur rapport qualité prix et se baser dessus pour calculer notre prix idéal
    if BestPrice == 0 and #AllItemsInHdv > 0 then
        global:printError("On a pas trouvé de meilleur item")
        table.sort(AllItemsInHdv, function (a, b)
            return (PourcentageJetPerf_ItemToSell - a.PourcentageJetPerf) < (PourcentageJetPerf_ItemToSell - b.PourcentageJetPerf)
        end)
        if AllItemsInHdv[1].Price ~= ActualPrice then
            BestPrice = math.floor((AllItemsInHdv[1].Price / AllItemsInHdv[1].PourcentageJetPerf) * PourcentageJetPerf_ItemToSell * (0.95 + (PourcentageJetPerf_ItemToSell - AllItemsInHdv[1].PourcentageJetPerf)))
        else
            BestPrice = 50000000 -- quand le meilleur prix est déjà le prix de notre item en hdv, on fait en sorte de ne pas changer
        end
    elseif BestPrice == 0 then
        global:printSuccess("Il n'y a plus d'items en vente")
        HdvSell()
        BestPrice = GetPricesItem(IdToSell).AveragePrice
        HdvBuy()
    end

    if BestPrice == 0 and #AllItemsInHdv > 0 then
        BestPrice = AllItemsInHdv[1].Price * 1.2
    end

    BestPrice = TraitementPrix(BestPrice)
    global:printSuccess("Meilleur prix trouvé (over) : " .. BestPrice)
    ActualPrice = 0
end

function _GetPriceFMItem(message)
    developer:unRegisterMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage")

    local toScan = message.itemTypeDescriptions
    local AllItemsInHdv = {}

    for _, data in ipairs(toScan) do
        local element = {
            PourcentageJetPerf = GetQualityItem(data.effects),
            Price = data.prices[1]
        }
        table.insert(AllItemsInHdv, element)
    end

    table.sort(AllItemsInHdv, function (a, b)
        return a.Price < b.Price        
    end)

    PriceItemFM = 0
    for _, element in ipairs(AllItemsInHdv) do
        if element.PourcentageJetPerf > PercentageSeached then
            PriceItemFM = element.Price * PercentageSeached / element.PourcentageJetPerf
            break
        end
    end

    if PriceItemFM == 0 then
        PriceItemFM = AllItemsInHdv[1].Price * 1.2
    end
end

function GetPriceFMItem(Id, MaxCoef)
    local nbStatProblematique = 0
    local qualityWanted = (((inventory:getLevel(Id) >= 195) and 0.96) or ((inventory:getLevel(Id) > 100) and 0.97) or ((inventory:getLevel(Id) > 80) and 0.98) or 0.99)
    local statsJp = GetDices(Id)
    local statLourde = false

    for _, statJp in ipairs(statsJp) do

        local poidsUnite = PoidsByStat[statJp.name].PoidsUnite
        if poidsUnite > 3 then
            statLourde = true
        end
        local toAdd = ((poidsUnite == 5) and 0.01 or (poidsUnite > 5 and poidsUnite < 30) and 0.0125 or poidsUnite == 4 and 0.0075 or 0)
        if statJp.dice.max > 10 then
            toAdd = toAdd * (statJp.dice.max / 10)
        end
        local toAdd = toAdd + ((poidsUnite == 3 and 0.005) or (poidsUnite == 2 and 0.0025) or 0)

        nbStatProblematique = nbStatProblematique + toAdd
    end

    if not statLourde and inventory:getLevel(Id) > 100 then
        nbStatProblematique = nbStatProblematique + 0.04
    end

    IdToSell = Id
    PercentageSeached = math.min(((inventory:getLevel(Id) > 100) and (qualityWanted - nbStatProblematique) or (inventory:getLevel(Id) > 80) and 0.98 or 0.99) - 0.01, MaxCoef)
    local message = developer:createMessage("ExchangeBidHouseSearchMessage")
    message.objectGID = Id
    message.follow = true
    developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _GetPriceFMItem)
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 5000, false, nil, 20)
    return PriceItemFM
end

function _BuyItemIfLessExpenciveThanCraft(message)
    developer:unRegisterMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage")

    local toScan = message.itemTypeDescriptions
    local AllItemsInHdv = {}

    for _, data in ipairs(toScan) do
        local element = {
            PourcentageJetPerf = GetQualityItem(data.effects, data.objectGID),
            Price = data.prices[1],
            UID = data.objectUID,
            GID = data.objectGID
        }
        table.insert(AllItemsInHdv, element)
    end

    table.sort(AllItemsInHdv, function (a, b)
        return a.Price < b.Price        
    end)

    global:printMessage("On cherche un prix inférieur à " .. Craft_Cost)
    global:printSuccess("le moins cher coute " .. AllItemsInHdv[1].Price .. " et a un coef de " .. AllItemsInHdv[1].PourcentageJetPerf)

    for _, element in ipairs(AllItemsInHdv) do
        if element.Price < Craft_Cost and element.PourcentageJetPerf > 0.8 then
            global:printSuccess("Le cout de craft de " .. inventory:itemNameId(element.GID) .. " est de " .. Craft_Cost .. ", en hdv on le trouve à " .. element.Price)
            local message = developer:createMessage("ExchangeBidHouseBuyMessage")
            message.uid = element.UID
            message.price = element.Price
            message.qty = 1
            developer:sendMessage(message)
            break
        end
    end
    global:leaveDialog()
end

function SellItem(Id, CraftCost, RuneCost, MaxPrice)
    MaxPrice = MaxPrice and TraitementPrix(MaxPrice) or 10000000
    local iContent = inventory:inventoryContent()
    for _, item in ipairs(iContent) do
        if item.objectGID == Id then
            ItemFound = true
            ItemStats = item.effects
            IdToSell = item.objectGID
            UIDToSell = item.objectUID
        end
    end

    if not ItemFound then
        global:printSuccess("L'item n'est pas présent dans l'inventaire, impossible de le vendre")
        return
    else
        ItemFound = false
    end

    PourcentageJetPerf_ItemToSell = GetQualityItemWithoutException(ItemStats) -- - 0.05

    -- if ItemSatisfyConditionsById(Id).Bool and inventory:getLevel(Id) > 120 then
    --     PourcentageJetPerf_ItemToSell = PourcentageJetPerf_ItemToSell + 0.05
    -- end
    global:printSuccess("% JP : " .. PourcentageJetPerf_ItemToSell)
    HdvBuy()

    PoidsOver = GetPoidsOver(ItemStats)

    local message = developer:createMessage("ExchangeBidHouseSearchMessage")
    message.objectGID = Id
    message.follow = true

    if PoidsOver > 0 then
        developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _GetBestPriceOver)
    elseif ItemSatisfyConditionsById(Id).Bool then
        developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _GetBestPriceFM)
    else
        developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _GetBestPriceFM2)
    end

    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 5000, false, nil, 20)

    global:leaveDialog()

    FinalSelling(IdToSell, UIDToSell, BestPrice < MaxPrice and BestPrice or MaxPrice, MaxPrice, CraftCost, RuneCost)
    BestPrice = 0
    PourcentageJetPerf_ItemToSell = 0
end

function BuyItemIfLessExpencive(Id, CraftCost)
    HdvBuy()
    Craft_Cost = CraftCost
    local message = developer:createMessage("ExchangeBidHouseSearchMessage")
    message.objectGID = Id
    message.follow = true
    developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _BuyItemIfLessExpenciveThanCraft)

    developer:sendMessage(message)

    developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 5000, false, nil, 20)
    
end

function _GetMessagePrices(message)

    developer:unRegisterMessage("ExchangeBidhouseMinimumItemPriceListMessage")
    local messageDeBase = message
    message = message.minimalPrices


    local AveragePrice = 0
    if message[2] == 0 and message[3] == 0 then
        AveragePrice = message[1]
    elseif message[3] == 0 and message[1] == 0 then
        AveragePrice = message[2] / 10
    elseif message[2] == 0 and message[1] == 0 then
        AveragePrice = message[3] / 100
    elseif message[3] ~= 0 and message[1] ~= 0 and message[2] ~= 0 then
        AveragePrice =(message[3] / 100 + message[2] / 10 + message[1]) / 3
    elseif message[3] == 0 then
        AveragePrice = (message[2] / 10 + message[1]) / 2
    elseif message[2] == 0 then
        AveragePrice = (message[3] / 100 + message[1]) / 2
    elseif message[1] == 0 then
        AveragePrice = (message[3] / 100 + message[2] / 10) / 2
    end

    Prices = {
        Id = messageDeBase.genericId,
        Price1 = message[1],
        Price10 = message[2],
        Price100 = message[3],
        AveragePrice = messageDeBase.averagePrice,
        TrueAveragePrice = math.floor(AveragePrice)
    }
end

function GetPricesItem(Id)
    Prices = {}
    developer:registerMessage("ExchangeBidPriceForSellerMessage", _GetMessagePrices)

    local message = developer:createMessage("ExchangeBidHousePriceMessage")
    message.objectGID = Id
    developer:sendMessage(message)
    
    developer:suspendScriptUntil("ExchangeBidPriceForSellerMessage", 5000, false, nil, 20)

    if Prices ~= {} and Prices ~= nil then
        return Prices
    else
        global:printSuccess("Impossible de récupérer le prix de " .. inventory:itemNameId(Id))
        return {
            Price1 = 0,
            Price10 = 0,
            Price100 = 0,
            TrueAveragePrice = 0,
            AveragePrice = 0
        }
    end
end

function Achat(IdItem, qtt)
    if inventory:itemCount(IdItem) > 20000 then -- protection car un miment ça a acheté 460k d'une ressoruce
        return false
    end
    --[[
        Amelioratioons :

    ]]
    local message = developer:createMessage("NpcGenericActionRequestMessage")
    message.npcId = -1
    message.npcActionId = 5
    message.npcMapId = map:currentMapId()
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 1000, false, nil, 50)

    local Quantite = qtt
    local NbDeBdase = inventory:itemCount(IdItem)

    local Prices = GetPricesItem(IdItem)
    if not Prices then
        global:delay(2000)
        Prices = GetPricesItem(IdItem)
    end

    global:printSuccess("Prix par 100 : " .. Prices.Price100)
    global:printSuccess("Prix par 10 : " .. Prices.Price10)
    global:printSuccess("Prix par 1 : " .. Prices.Price1)

    global:leaveDialog()

    if (Prices.Price100 == 0) and (Prices.Price10 == 0) and (Prices.Price1 == 0) then
        global:printError("L'item n'est plus disponible en hdv")
        return false
    elseif Prices.Price10 == 0 and Prices.Price100 == 0 and qtt < 30 then
        qtt = 1
    elseif Prices.Price10 == 0 and Prices.Price100 == 0 and Prices.AveragePrice * 1.5 > Prices.Price1 then
        qtt = 1
    elseif Prices.Price10 == 0 and Prices.Price100 == 0 and Prices.AveragePrice * 1.5 < Prices.Price1 then
        global:printError("la ressource a un prix unitaire trop élevé")
        return false
    elseif ((Prices.Price10 == 0) and (Prices.Price1 == 0)) or ((qtt > 10) and Prices.Price10 * qtt / 10 > Prices.Price100 and Prices.Price100 > 0) or (Prices.Price10 == 0 and qtt > 9 and qtt < 100 ) then
        qtt = 100
    elseif Prices.Price1 == 0 and qtt < 10 then
        qtt = 10
    elseif qtt > 10 and qtt < 100 and qtt % 10 * Prices.Price1 > Prices.Price10 then
        qtt = qtt + (10 - qtt % 10)
    elseif qtt < 10 and Prices.Price1 * qtt > Prices.Price10 and Prices.Price10 > 0 then
        qtt = 10
    elseif (Prices.Price100 ~= 0) and (Prices.Price10 ~= 0) then
        qtt = ((((qtt < 100) and (qtt > 10)) and (Prices.Price100 * 1.3 < Prices.Price10 * 10)) and (inventory:itemWeight(IdItem) * 100) < (inventory:podsMax() - inventory:pods())) and 100
        or ((qtt < 10) and (Prices.Price10 * 1.3 < Prices.Price1 * 10)) and 10
        or qtt
    end

    message = developer:createMessage("NpcGenericActionRequestMessage")
    message.npcId = -1
    message.npcActionId = 6
    message.npcMapId = map:currentMapId()
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 1000, true, nil, 20)

    while qtt > 0 do           
        if qtt >= 100 then
            if character:kamas() < Prices.Price100 then
                global:printSuccess("Plus assez de kamas, on retente dans 2h")
                global:reconnect(2)
            end
            if ((Prices.Price10 * 1.2 < Prices.Price100 / 10) and Prices.Price10 ~= 0) or Prices.Price100 == 0 then
                for i = 1, 10 do
                    sale:buyItem(IdItem, 10, Prices.Price10 * 2)
                end
                local nbRessourceManquante = NbDeBdase + Quantite - inventory:itemCount(IdItem) -- 50 de base 50 acheter
                return Achat(IdItem, nbRessourceManquante)
            elseif Prices.Price100 == 0 and Prices.Price10 == 0 then
                for i = 1, 10 do
                    sale:buyItem(IdItem, 1, Prices.Price1 * 2)
                end
                local nbRessourceManquante = NbDeBdase + Quantite - inventory:itemCount(IdItem) -- 50 de base 50 acheter
                return Achat(IdItem, nbRessourceManquante)
            else
                sale:buyItem(IdItem, 100, Prices.Price100 * 2)
                qtt = qtt - 100             
            end
        elseif qtt >= 10 and qtt < 100 then
            if character:kamas() < Prices.Price10 then
                global:printSuccess("Plus assez de kamas, on retente dans 2h")
                global:reconnect(2)
            end
            if ((Prices.Price1 * 1.2 < Prices.Price10 / 10) and Prices.Price1 ~= 0) or Prices.Price10 == 0 then
                for i = 1, 10 do
                    sale:buyItem(IdItem, 1, Prices.Price1 * 2)
                end
                local nbRessourceManquante = NbDeBdase + Quantite - inventory:itemCount(IdItem) -- 50 de base 50 acheter
                return Achat(IdItem, nbRessourceManquante)
            else
                sale:buyItem(IdItem, 10, Prices.Price10 * 2)
                qtt = qtt - 10
            end
        elseif qtt >= 1 and qtt < 10 then
            if character:kamas() < Prices.Price1 then
                global:printSuccess("Plus assez de kamas, on retente dans 2h")
                global:reconnect(2)
            end
            sale:buyItem(IdItem, 1, Prices.Price1 * 2)
            qtt = qtt - 1 
        end
    end

    global:leaveDialog()

    local nbRessourceManquante = NbDeBdase + Quantite - inventory:itemCount(IdItem)
    if nbRessourceManquante > 0 then
        return Achat(IdItem, nbRessourceManquante)
    end
    return true
end


function _AnalyseItemsOnSale(message)
    developer:unRegisterMessage("ExchangeStartedBidSellerMessage")
    local ItemsOnSale = {}
    local RessourcesOnSale = {}
    local toScan = message.objectsInfos

    local jsonPrice = openFile(global:getCurrentScriptDirectory() .. "\\".. character:server() .. "\\PriceItems.json")

    for _, data in ipairs(toScan) do
        if data.quantity == 1 and IsItem(inventory:itemTypeId(data.objectGID)) then
            global:printSuccess(_ .. "ème item : " .. inventory:itemNameId(data.objectGID))
            local element = {
                Id = data.objectGID,
                UID = data.objectUID,
                Effects = data.effects,
                Price = data.objectPrice,
                Quality = 0,
                CurrentBestPrice = 0,
                AveragePrice = jsonPrice[1].Prices[tostring(data.objectGID)].AveragePrice
            }
            table.insert(ItemsOnSale, element)
        else
            local element = {
                Id = data.objectGID,
                Price = data.objectPrice,
                Lot = data.quantity,
                CurrentBestPrice = 0
            }
            table.insert(RessourcesOnSale, element)
        end
    end

    global:leaveDialog()

    HdvBuy()

    for _, item in ipairs(ItemsOnSale) do
        IdToSell = item.Id
        ActualPrice = item.Price
        item.Quality = GetQualityItemWithoutException(item.Effects, item.Id) -- - 0.05

        PourcentageJetPerf_ItemToSell = item.Quality

        local message = developer:createMessage("ExchangeBidHouseSearchMessage")
        message.objectGID = item.Id
        message.follow = true

        PoidsOver = GetPoidsOver(item.Effects)

        if PoidsOver > 0 then
            developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _GetBestPriceOver)
        elseif ItemSatisfyConditionsById(IdToSell).Bool then
            developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _GetBestPriceFM)
        else
            developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _GetBestPriceFM2)
        end
    
        developer:sendMessage(message)
    
        while not developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 5000, false, nil, 20) do
            global:leaveDialog()
            HdvBuy()
            developer:sendMessage(message)
        end

        global:printSuccess("Qualité de " .. inventory:itemNameId(item.Id) .. " : " .. item.Quality)
        global:printSuccess("Prix actuel : " .. item.Price .. ", Meilleur Prix : " .. BestPrice)
        item.CurrentBestPrice = BestPrice
        global:delay(math.random(300, 600))
    end

    global:leaveDialog()

    global:printMessage("----------ACTUALISATION----------")
    
    HdvSell()

    for _, item in ipairs(ItemsOnSale) do
        global:printSuccess("AveragePrice de " .. inventory:itemNameId(item.Id) .. " : " .. item.AveragePrice)
        if ((item.Price - item.CurrentBestPrice) > 3000) and (item.Price / item.CurrentBestPrice) > 1.05 
        and (((item.CurrentBestPrice / item.Price) > 0.5) or (item.CurrentBestPrice > (item.AveragePrice * 0.25))) then -- permets d'éviter de mettre moins cher qu'un prix fail
            global:printMessage("Prix actuel : " .. item.Price)
            global:printMessage("Ancien meilleur prix : " .. item.CurrentBestPrice)
            item.CurrentBestPrice = math.max(GetPricesItem(item.Id).Price1 - 1, item.CurrentBestPrice)
            global:printMessage("Nouveau meilleur prix : " .. item.CurrentBestPrice)
            if ((item.Price - item.CurrentBestPrice) > 3000) and (item.Price / item.CurrentBestPrice) > 1.05 then
                global:printSuccess("[" .. inventory:itemNameId(item.Id) .. "] : ancien prix : " .. item.Price .. ", nouveau prix : " .. item.CurrentBestPrice - 1)
                sale:editPrice(item.UID, TraitementPrix(item.CurrentBestPrice), 1)
            end
        end
    end
    global:leaveDialog()

    global:printMessage("----------ACTUALISATION FINIE----------")

    HdvBuy()

    for _, ressource in ipairs(RessourcesOnSale) do
        local Prices = GetPricesItem(ressource.Id)
        ressource.CurrentBestPrice = Prices
    end

    global:leaveDialog()

    HdvSell()

    for _, ressource in ipairs(RessourcesOnSale) do
        local Lot = ressource.Lot
        if Lot == 100 then
            if ressource.CurrentBestPrice.Price100 < ressource.Price then
                global:printSuccess("Actualisation du lot de 100 [" .. inventory:itemNameId(ressource.Id) .. "], nouveau prix : " .. ressource.CurrentBestPrice - 1)
                sale:editPriceByGID(ressource.Id, ressource.CurrentBestPrice - 1, 100)
            end
        elseif Lot == 10 then
            if ressource.CurrentBestPrice.Price10 < ressource.Price then
                global:printSuccess("Actualisation du lot de 10 [" .. inventory:itemNameId(ressource.Id) .. "], nouveau prix : " .. ressource.CurrentBestPrice - 1)
                sale:editPriceByGID(ressource.Id, ressource.CurrentBestPrice - 1, 10)
            end
        elseif Lot == 1 then
            if ressource.CurrentBestPrice.Price1 < ressource.Price then
                global:printSuccess("Actualisation du lot de 1 [" .. inventory:itemNameId(ressource.Id) .. "], nouveau prix : " .. ressource.CurrentBestPrice - 1)
                sale:editPriceByGID(ressource.Id, ressource.CurrentBestPrice - 1, 1)
            end
        end
    end
    global:printSuccess("Fin fonction actualisation")
end

function UpdateAllItemOpti()
    developer:registerMessage("ExchangeStartedBidSellerMessage", _AnalyseItemsOnSale)
    HdvSell()
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 5000, false, nil, 20)
end

function TraitementPrix(n)
    local nombre = tostring(n)
    local longueur = #nombre
    
    if longueur % 2 == 0 then
        local moitie = longueur / 2
        local partieDroite = tonumber(nombre:sub(-moitie))
        
        if partieDroite == 0 then
            return n -- Pas de chiffres non nuls à droite, pas de modification nécessaire
        else
            local chiffre = tonumber(nombre:sub(-1, -1))
            if chiffre ~= 9 then
                return n - partieDroite - 1
            else
                return n -- Tous les chiffres à droite sont des 9, pas de modification nécessaire
            end
        end
    else
        local moitie = math.floor(longueur / 2)
        local partieDroite = tonumber(nombre:sub(-moitie))
        
        if partieDroite == 0 then
            return n -- Pas de chiffres non nuls à droite, pas de modification nécessaire
        else
            local chiffre = tonumber(nombre:sub(-1, -1))
            if chiffre ~= 9 then
                return n - partieDroite - 1
            else
                return n -- Tous les chiffres à droite sont des 9, pas de modification nécessaire
            end
        end
    end
end

function  _GetBestPriceDDLvl100(message)
    BestPrice = 0
    local dd = message.itemTypeDescriptions

    table.sort(dd, function (a, b)
        return a.prices[1] < b.prices[1]
    end)

    for _, element in ipairs(dd) do
        if #element.effects > 0 and developer:typeOf(element.effects[1]) == "ObjectEffectMount" and element.effects[1].level == 100 and element.effects[1].isRideable then
            BestPrice = element.prices[1] - 1
            break
        end
    end

end

function SellDD(Id, UID)
    HdvBuy()
    local message = developer:createMessage("ExchangeBidHouseSearchMessage")
    message.objectGID = Id
    message.follow = true
    developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _GetBestPriceDDLvl100)
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 2000, true)

    HdvSell()
    BestPrice = (BestPrice == 0) and GetPricesItem(Id).AveragePrice * 2 or BestPrice

    local message = developer:createMessage("ExchangeObjectMovePricedMessage")
    message.price = BestPrice
    message.objectUID = UID
    message.quantity = 1
    developer:sendMessage(message)
    developer:suspendScriptUntil("InventoryWeightMessage", 2000, true)

    global:printSuccess("1 lot de " .. inventory:itemNameId(Id) .. " à " .. BestPrice .. " kamas")
    global:leaveDialog()
end



function  _GetBestPriceDDLvl1And100(message)
    developer:unRegisterMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage")
    BestPrice100 = 0
    BestPrice1 = 0
    local dd = message.itemTypeDescriptions

    table.sort(dd, function (a, b)
        return a.prices[1] < b.prices[1]
    end)

    for _, element in ipairs(dd) do
        if #element.effects > 0 and developer:typeOf(element.effects[1]) == "ObjectEffectMount" and element.effects[1].level == 100 and element.effects[1].isRideable then
            BestPrice100 = element.prices[1] - 1
            break
        end
    end
    for _, element in ipairs(dd) do
        if #element.effects > 0 and developer:typeOf(element.effects[1]) == "ObjectEffectMount" and element.effects[1].isRideable then
            BestPrice1 = element.prices[1] - 1
            break
        end
    end
end

function  _BuyCheapestDD(message)
    developer:unRegisterMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage")
    local dd = message.itemTypeDescriptions

    table.sort(dd, function (a, b)
        return a.prices[1] < b.prices[1]
    end)
    for _, element in ipairs(dd) do
        if #element.effects > 0 and developer:typeOf(element.effects[1]) == "ObjectEffectMount" and element.effects[1].isRideable then
            message = developer:createMessage("ExchangeBidHouseBuyMessage")
            message.uid = element.objectUID
            message.qty = 1
            message.price = element.prices[1]

            developer:sendMessage(message)
            developer:suspendScriptUntil("ExchangeBidHouseBuyResultMessage", 2000, true)
            global:leaveDialog()
            break
        end
    end
end

function  _BuyCheapestDD100(message)
    developer:unRegisterMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage")
    local dd = message.itemTypeDescriptions

    table.sort(dd, function (a, b)
        return a.prices[1] < b.prices[1]
    end)
    for _, element in ipairs(dd) do
        if #element.effects > 0 and developer:typeOf(element.effects[1]) == "ObjectEffectMount" and element.effects[1].isRideable and element.effects[1].level == 100 then
            message = developer:createMessage("ExchangeBidHouseBuyMessage")
            message.uid = element.objectUID
            message.qty = 1
            message.price = element.prices[1]

            developer:sendMessage(message)
            developer:suspendScriptUntil("ExchangeBidHouseBuyResultMessage", 2000, true)
            global:leaveDialog()
            break
        end
    end
end

function BuyDDTurquoise100()
    local dd_pp = {{Id = 7814}, {Id = 7863}}

    HdvSell()
    global:delay(math.random(500, 1500))
    local cpt = 0
    global:printSuccess("ok0")
    for _, dd in ipairs(dd_pp) do
        if cpt % 5 == 0 then
            global:leaveDialog()
            HdvBuy()
        end
        cpt = cpt + 1
        local message = developer:createMessage("ExchangeBidHouseSearchMessage")
        message.objectGID = dd.Id
        message.follow = true
        developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _GetBestPriceDDLvl1And100)
        developer:sendMessage(message)
        developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 2000, true)
        dd.Price100 = BestPrice100
    end
    global:leaveDialog()

    table.sort(dd_pp, function (a, b)
        return a.Price100 < b.Price100 
    end)

    global:printSuccess("ok1")
    local IdDDToBuy = 0
    for _, dd in ipairs(dd_pp) do
        if dd.Price100 > 0 then
            global:printSuccess("dd la plus rentable : " .. inventory:itemNameId(dd.Id) .. " : " .. dd.Price100 .. " kamas")
            IdDDToBuy = dd.Id
            break
        end
    end
    global:printSuccess("ok2")
    if IdDDToBuy > 0 then
        HdvBuy()
        local message = developer:createMessage("ExchangeBidHouseSearchMessage")
        message.objectGID = IdDDToBuy
        message.follow = true
        developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _BuyCheapestDD100)
        developer:sendMessage(message)
        developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 2000, true)
    else
        global:printSuccess("BUG ACHAT DD")
    end
end

function AchatMostProfitableDD()
    local all_DD = {}
    for i = 1, 10000 do
        if inventory:itemTypeId(i) == 97 then
            all_DD[#all_DD+1] = {Id = i}
        end
    end
    global:printSuccess("Il y a " .. #all_DD .. " dd à analyser")

    HdvSell()
    global:delay(math.random(500, 1500))
    local cpt = 0
    for _, dd in ipairs(all_DD) do
        global:printSuccess("ok1")
        if cpt % 5 == 0 then
            global:leaveDialog()
            HdvBuy()
        end
        cpt = cpt + 1
        local message = developer:createMessage("ExchangeBidHouseSearchMessage")
        message.objectGID = dd.Id
        message.follow = true
        developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _GetBestPriceDDLvl1And100)
        developer:sendMessage(message)
        developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 2000, true)
        dd.Profitability = BestPrice100 - BestPrice1
        dd.NbInHdv = get_quantity(dd.Id).total_lots
    end
    global:leaveDialog()

    table.sort(all_DD, function (a, b)
        if a.NbInHdv < b.NbInHdv then
            return true
        elseif a.NbInHdv > b.NbInHdv then
            return false
        end
        return a.Profitability > b.Profitability
    end)

    local IdDDToBuy = 0
    for _, dd in ipairs(all_DD) do
        if dd.Profitability > 0 then
            global:printSuccess("dd la plus rentable : " .. inventory:itemNameId(dd.Id) .. " : " .. dd.Profitability .. " kamas")
            IdDDToBuy = dd.Id
            break
        end
    end
    if IdDDToBuy > 0 then
        global:printSuccess("ok2")
        HdvBuy()
        local message = developer:createMessage("ExchangeBidHouseSearchMessage")
        message.objectGID = IdDDToBuy
        message.follow = true
        developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _BuyCheapestDD)
        developer:sendMessage(message)
        developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 2000, true)
    end

    -- on a maintenant l'id de la dd qu'il nous faut acheter
end

function _AnalyseDDOnSale(message)
    developer:unRegisterMessage("ExchangeStartedBidSellerMessage")
    local ddOnSale = {}
    local toScan = message.objectsInfos

    for _, data in ipairs(toScan) do
        global:printSuccess(_ .. "ème dd : " .. inventory:itemNameId(data.objectGID))
        local element = {
            Id = data.objectGID,
            UID = data.objectUID,
            Effects = data.effects,
            Price = data.objectPrice,
            CurrentBestPrice = 0,
        }
        table.insert(ddOnSale, element)
    end

    global:leaveDialog()

    HdvBuy()

    local cpt = 0
    for _, dd in ipairs(ddOnSale) do
        if cpt % 5 == 0 then
            global:leaveDialog()
            HdvBuy()
        end
        cpt = cpt + 1
        local message = developer:createMessage("ExchangeBidHouseSearchMessage")
        message.objectGID = dd.Id
        message.follow = true
        developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _GetBestPriceDDLvl1And100)
        developer:sendMessage(message)
        developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 2000, true)

        dd.CurrentBestPrice = BestPrice100
        global:printSuccess("mapId : " .. map:currentMapId())
        global:printSuccess(inventory:itemNameId(dd.Id) .. " Prix actuel : " .. dd.Price .. ", Meilleur Prix : " .. BestPrice100)

    end
    global:leaveDialog()

    global:printMessage("----------ACTUALISATION----------")

    local message = developer:createMessage("NpcGenericActionRequestMessage")
    message.npcId = -1
    message.npcActionId = 5
    message.npcMapId = map:currentMapId()
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 5000, false, nil, 20)

    for _, item in ipairs(ddOnSale) do
        global:printSuccess(_)
        if ((item.Price - item.CurrentBestPrice) > 3000) then
            item.CurrentBestPrice = math.max(GetPricesItem(item.Id).Price1 - 1, item.CurrentBestPrice)
            if ((item.Price - item.CurrentBestPrice) > 3000) then
                global:printSuccess("AAAA")
                global:printSuccess("[" .. inventory:itemNameId(item.Id) .. "] : ancien prix : " .. item.Price .. ", nouveau prix : " .. item.CurrentBestPrice - 1)
                sale:editPrice(item.UID, item.CurrentBestPrice - 1, 1)
            end
        end
    end
    global:leaveDialog()

    global:printMessage("----------ACTUALISATION FINIE----------")

end

function UpdatePriceDD()
    developer:registerMessage("ExchangeStartedBidSellerMessage", _AnalyseDDOnSale)
    local message = developer:createMessage("NpcGenericActionRequestMessage")
    message.npcId = -1
    message.npcActionId = 5
    message.npcMapId = map:currentMapId()
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 5000, false, nil, 20)
end