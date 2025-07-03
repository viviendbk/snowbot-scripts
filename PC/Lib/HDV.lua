ItemList = {}
UIDInHdvBuy = 0

function HdvSell()
    global:printMessage("Ouverture de l'HDV pour vendre")
    local message = developer:createMessage("InteractiveUseRequest")
    message.element_id = HDV_INTERACTIONS_ID[tostring(map:currentMapId())].elementID
    message.specific_instance_id = 0
    message.skill_instance_uid = HDV_INTERACTIONS_ID[tostring(map:currentMapId())].skillInstanceUID
    developer:sendMessage(message)
    if not developer:suspendScriptUntil("ExchangeBidBuyerStartedEvent", 5000, false, nil, 50) then
        global:printError("L'HDV n'a pas pu être ouvert, on déco reco")
        customReconnect(0)
        return
    end
    randomDelay()

    developer:registerMessage("ExchangeStartedBidSellerMessage", _Stack_items_informations)
    local message = developer:createMessage("NpcGenericActionRequestMessage")
    message.npcId = -1
    message.npcActionId = 5
    message.npcMapId = map:currentMapId()
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 2000, false, nil, 50)
end

function fromHdvSellToHdvBuy()
    local message = developer:createMessage("NpcGenericActionRequestMessage")
    message.npcId = -1
    message.npcActionId = 6
    message.npcMapId = map:currentMapId()
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 2000, false, nil, 50)
end

function fromHdvBuyToHdvSell()
    local message = developer:createMessage("NpcGenericActionRequestMessage")
    message.npcId = -1
    message.npcActionId = 5
    message.npcMapId = map:currentMapId()
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 2000, false, nil, 50)
end

function HdvSell2()
    local message = developer:createMessage("InteractiveUseRequest")
    message.element_id = HDV_INTERACTIONS_ID[tostring(map:currentMapId())].elementID
    message.specific_instance_id = 0
    message.skill_instance_uid = HDV_INTERACTIONS_ID[tostring(map:currentMapId())].skillInstanceUID
    developer:sendMessage(message)
    if not developer:suspendScriptUntil("ExchangeBidBuyerStartedEvent", 5000, false, nil, 50) then
        global:printError("L'HDV n'a pas pu être ouvert, on déco reco")
        customReconnect(0)
        return
    end
    randomDelay()

    developer:registerMessage("ExchangeStartedBidSellerMessage", _StackInfosHdvInJson)
    local message = developer:createMessage("NpcGenericActionRequestMessage")
    message.npcId = -1
    message.npcActionId = 5
    message.npcMapId = map:currentMapId()
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 2000, false, nil, 50)
end



function HdvBuy()
    global:printMessage("Ouverture de l'HDV pour acheter")
    local message = developer:createMessage("InteractiveUseRequest")
    message.element_id = HDV_INTERACTIONS_ID[tostring(map:currentMapId())].elementID
    message.specific_instance_id = 0
    message.skill_instance_uid = HDV_INTERACTIONS_ID[tostring(map:currentMapId())].skillInstanceUID
    developer:sendMessage(message)
    if not developer:suspendScriptUntil("ExchangeBidBuyerStartedEvent", 5000, false, nil, 50) then
        global:printError("L'HDV n'a pas pu être ouvert, on déco reco")
        customReconnect(0)
        return
    end
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

    local data = openFile("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Craft\\Craft-Resell.json")

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
        fromHdvBuyToHdvSell()
        finalPrice = sale:getAveragePriceItem(Id, 1)

        local message = developer:createMessage("ExchangeObjectMovePricedMessage")
        message.price = finalPrice
        message.objectUID = UID
        message.quantity = 1
        developer:sendMessage(message)
    
        global:printSuccess("1 lot de [" .. inventory:itemNameId(Id) .. "] à " .. finalPrice .. " kamas")
    end
    if character:kamas() > Price * 0.03 then
        fromHdvBuyToHdvSell()
        finalPrice = math.max(GetPricesItemInHdvSell(Id).Price1 - 1, Price)

        local message = developer:createMessage("ExchangeObjectMovePricedMessage")
        message.price = finalPrice
        message.objectUID = UID
        message.quantity = 1
        developer:sendMessage(message)
    
        global:printSuccess("1 lot de [" .. inventory:itemNameId(Id) .. "] à " .. finalPrice .. " kamas")
    
        if Price < MaxPrice / 3 and MaxPrice ~= 10000000 and MaxPrice > 100000 and global:thisAccountController():getAlias():find("FM") then
            global:printError("Prb prix ( prix max = " .. MaxPrice .. ")")
        end
    else
        global:printError("Pas assez de kamas pour vendre, on réessaie dans 2 heures")
        customReconnect(120)
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
        BestPrice = GetPricesItemInHdvSell(IdToSell).AveragePrice
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
        BestPrice = GetPricesItemInHdvSell(IdToSell).AveragePrice
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
        BestPrice = GetPricesItemInHdvSell(IdToSell).AveragePrice
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

    if not AllItemsInHdv or #AllItemsInHdv == 0 then
        global:printError("Aucun item trouvé en hdv")
        global:leaveDialog()
    end

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
    fromHdvSellToHdvBuy()

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

    FinalSelling(IdToSell, UIDToSell, BestPrice < MaxPrice and BestPrice or MaxPrice, MaxPrice, CraftCost, RuneCost)
    BestPrice = 0
    PourcentageJetPerf_ItemToSell = 0
    fromHdvBuyToHdvSell()
end


function sellResource(Id, lot, price)
    
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

function protobufToTable(protoObj)
    local result = {}

    for k, v in pairs(protoObj) do
        -- Si le champ est une sous-structure, on la convertit aussi
        if type(v) == "userdata" then
            if #v > 0 then
                -- Liste (repeated)
                result[k] = {}
                for i, item in ipairs(v) do
                    result[k][i] = type(item) == "userdata" and protobufToTable(item) or item
                end
            else
                -- Table, mais pas une liste (ex: sous-message)
                result[k] = protobufToTable(v)
            end
        else
            result[k] = v
        end
    end

    return result
end


function test(value)
    local a = (value + 1)
    return math.floor(a * 2)
end

function _getPricesHdvSell(message)
    developer:unRegisterMessage("ExchangeBidPriceEvent")
    local messageDeBase = message
    message = message.bid_price_for_seller.minimal_prices

    local AveragePrice = 0
    if message[1] == 0 and message[2] == 0 then
        AveragePrice = message[0]
    elseif message[2] == 0 and message[0] == 0 then
        AveragePrice = message[1] / 10
    elseif message[1] == 0 and message[0] == 0 then
        AveragePrice = message[2] / 100
    elseif message[2] ~= 0 and message[0] ~= 0 and message[1] ~= 0 then
        AveragePrice = (message[2] / 100 + message[1] / 10 + message[0]) / 3
    elseif message[2] == 0 then
        AveragePrice = (message[1] / 10 + message[0]) / 2
    elseif message[1] == 0 then
        AveragePrice = (message[2] / 100 + message[0]) / 2
    elseif message[0] == 0 then
        AveragePrice = (message[2] / 100 + message[1] / 10) / 2
    end

    Prices = {
        Id = messageDeBase.object_gid,
        Price1 = message[0],
        Price10 = message[1],
        Price100 = message[2],
        AveragePrice = messageDeBase.average_price,
        TrueAveragePrice = math.floor(AveragePrice)
    }
end

function GetPricesItemInHdvSell(objectGID)

    Prices = {}
    developer:registerMessage("ExchangeBidPriceEvent", _getPricesHdvSell)

    local message1 = developer:createMessage("ExchangeBidHouseSearchRequest")
    message1.follow = false
    message1.object_gid = objectGID

    local message2 = developer:createMessage("ExchangeBidHouseSearchRequest")
    message2.follow = true
    message2.object_gid = objectGID

    local message3 = developer:createMessage("ExchangeBidHousePriceRequest")
    message3.object_gid = objectGID

    developer:sendMessage(message1)
    developer:sendMessage(message2)
    developer:sendMessage(message3)

    developer:suspendScriptUntil("ExchangeBidPriceMessage", 5000, false, nil, 20)

    if Prices ~= {} and Prices ~= nil then
        return Prices
    else
        global:printSuccess("Impossible de récupérer le prix de " .. inventory:itemNameId(objectGID) .. " (id : " .. objectGID .. ")")
        return {
            Price1 = 0,
            Price10 = 0,
            Price100 = 0,
            TrueAveragePrice = 0,
            AveragePrice = 0
        }
    end
end

function _getPricesHdvBuy(message)
    developer:unRegisterMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage")
    local messageDeBase = message
    if not message.itemTypeDescriptions or #message.itemTypeDescriptions == 0 then -- arrive quand il n'y a plus de cet item en hdv
        Prices = nil
        return
    end
    message = message.itemTypeDescriptions[1].prices

    Prices = {
        Id = messageDeBase.objectGID,
        UID = messageDeBase.itemTypeDescriptions[1].objectUID,
        Price1 = message[1],
        Price10 = message[2],
        Price100 = message[3],
        Prices1000 = message[4],
    }
end

function GetPricesItemInHdvBuy(objectGID)
    Prices = {}
    developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _getPricesHdvBuy)

    local message = developer:createMessage("ExchangeBidHouseTypeRequest")
    message.follow = true
    message.type_id = inventory:itemTypeId(objectGID)

    local message2 = developer:createMessage("ExchangeBidHouseSearchRequest")
    message2.follow = true
    message2.object_gid = objectGID

    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeTypesExchangerDescriptionForUserEvent", 5000, false, nil, 20)

    developer:sendMessage(message2)
    
    developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 5000, false, nil, 20)

    if Prices and Prices.Price1 then
        return Prices
    else
        global:printSuccess("Impossible de récupérer le prix de " .. inventory:itemNameId(objectGID) .. " (id : " .. objectGID .. ")")
        return {
            Id = objectGID,
            UID = 0,
            Price1 = 0,
            Price10 = 0,
            Price100 = 0,
            Prices1000 = 0
        }
    end
end



function achat(objectGID, qtt)
    if inventory:itemCount(objectGID) > 20000 then -- protection car un miment ça a acheté 460k d'une ressoruce
        return false
    end
    local theoricalNbInInventoryAfterBuy = inventory:itemCount(objectGID) + qtt

    PricesForBuy = GetPricesItemInHdvBuy(objectGID)
    UIDInHdvBuy = PricesForBuy.UID

    if not PricesForBuy then
        global:printError("Impossible de récupérer les prix, j’abandonne")
        return false
    end

    -- boucle d’achat avec recalcul dynamique des prix
    while qtt > 0 do
        -- 1) récupérer à chaque fois les nouveaux prix

        global:printMessage("Prix | [100] : " .. PricesForBuy.Price100 .. ", [10] : " .. PricesForBuy.Price10 .. ", [1] : " .. PricesForBuy.Price1)

        -- 3) déterminer le lot à acheter
        local buySize, buyPrice
        local inSell = false

        if (PricesForBuy.Price100 == 0) and (PricesForBuy.Price10 == 0) and (PricesForBuy.Price1 == 0) then
            global:printError("L'item n'est plus disponible en hdv")
            return false

        elseif (PricesForBuy.Price10 == 0 and PricesForBuy.Price100 == 0)
        or (PricesForBuy.Price10 == 0 and PricesForBuy.Price1 == 0) 
        or (PricesForBuy.Price100 == 0 and PricesForBuy.Price1 == 0) then

            if not PricesForBuy.AveragePrice then
                inSell = true
                fromHdvBuyToHdvSell()
                PricesForBuy.AveragePrice = GetPricesItemInHdvSell(objectGID).AveragePrice
            end

            if (PricesForBuy.Price10 == 0 and PricesForBuy.Price100 == 0 and PricesForBuy.AveragePrice * 2 < PricesForBuy.Price1) 
            or (PricesForBuy.Price10 == 0 and PricesForBuy.Price1 == 0 and PricesForBuy.AveragePrice * 2 < PricesForBuy.Price100 / 100) 
            or (PricesForBuy.Price100 == 0 and PricesForBuy.Price1 == 0 and PricesForBuy.AveragePrice * 2 < PricesForBuy.Price10 / 10)  
            
                    -- nouveau : lot 10 et lot 100 dispo et tous deux trop chers
            or (PricesForBuy.Price10  > 0
                and PricesForBuy.Price100 > 0 and PricesForBuy.Price1 == 0
                and (PricesForBuy.Price10  / 10  > PricesForBuy.AveragePrice * 2)
                and (PricesForBuy.Price100 / 100 > PricesForBuy.AveragePrice * 2))

            -- nouveau : lot 1 et lot 10 dispo et tous deux trop chers
            or (PricesForBuy.Price1   > 0
                and PricesForBuy.Price10  > 0 and PricesForBuy.Price100 == 0
                and (PricesForBuy.Price1        > PricesForBuy.AveragePrice * 2)
                and (PricesForBuy.Price10  / 10  > PricesForBuy.AveragePrice * 2))

            -- nouveau : lot 1 et lot 100 dispo et tous deux trop chers
            or (PricesForBuy.Price1   > 0
                and PricesForBuy.Price100 > 0 and PricesForBuy.Price10 == 0
                and (PricesForBuy.Price1        > PricesForBuy.AveragePrice * 2)
                and (PricesForBuy.Price100 / 100 > PricesForBuy.AveragePrice * 2))
            
            then
                global:printError("la ressource a un prix unitaire trop élevé (AveragePrice : " .. PricesForBuy.AveragePrice)
                if inSell then
                    inSell = false
                    fromHdvSellToHdvBuy()
                end
                return false

            elseif PricesForBuy.Price10 == 0 and PricesForBuy.Price100 == 0 and qtt < 30  -- si y'a plus que les lots de 1 et qu'il est pas trop élevé
            and (PricesForBuy.AveragePrice * 3 >= PricesForBuy.Price1 or PricesForBuy.Price1 < 5000) then
                buySize, buyPrice = 1, PricesForBuy.Price1 * 2
            elseif PricesForBuy.Price10 == 0 and PricesForBuy.Price100 == 0 and PricesForBuy.AveragePrice * 2 >= PricesForBuy.Price1 then
                buySize, buyPrice = 1, PricesForBuy.Price1 * 2

            elseif PricesForBuy.Price1 == 0 and PricesForBuy.Price100 == 0 and PricesForBuy.Price10 > 0 
            and PricesForBuy.AveragePrice * 2 >= PricesForBuy.Price10 / 10 then
                buySize, buyPrice = 10, PricesForBuy.Price10 * 2
            
            end

            if inSell then
                debug("on était en sell, on passe en buy")
                inSell = false
                fromHdvSellToHdvBuy()
                GetPricesItemInHdvBuy(objectGID) -- nécessaire pour être devant l'item dans l'interface
            end

        elseif (((PricesForBuy.Price10 == 0) and (PricesForBuy.Price1 == 0)) or ((qtt > 10) and PricesForBuy.Price10 * qtt / 10 > PricesForBuy.Price100) 
        or (PricesForBuy.Price10 == 0 and qtt > 9 and qtt < 100 )) and PricesForBuy.Price100 > 0 then
            buySize, buyPrice = 100, PricesForBuy.Price100 * 2

        elseif PricesForBuy.Price1 == 0 and qtt < 10 and PricesForBuy.Price10 > 0 then
            buySize, buyPrice = 10, PricesForBuy.Price10 * 2

        elseif qtt > 10 and qtt < 100 and (qtt % 10) * PricesForBuy.Price1 > PricesForBuy.Price10 and PricesForBuy.Price10 > 0 then
            buySize, buyPrice = 10, PricesForBuy.Price10 * 2

        elseif qtt < 10 and PricesForBuy.Price1 * qtt * 1.2 > PricesForBuy.Price10 and PricesForBuy.Price10 > 0 then
            buySize, buyPrice = 10, PricesForBuy.Price10 * 2

        elseif qtt < 15 and PricesForBuy.Price1 * 12 < PricesForBuy.Price10 and PricesForBuy.Price10 > 0 and PricesForBuy.Price1 > 0 then
            buySize, buyPrice = 1, PricesForBuy.Price1 * 2

        elseif (PricesForBuy.Price100 > 0) and (PricesForBuy.Price10 > 0) 
        and qtt < 100 and qtt > 10 
                and PricesForBuy.Price100 / (PricesForBuy.Price10 / 10) * qtt < 1.5
                and (inventory:itemWeight(objectGID) * 100) < (inventory:podsMax() - inventory:pods())  then

            buySize, buyPrice = 100, PricesForBuy.Price100 * 2


        elseif qtt < 100 and PricesForBuy.Price1 * 1.2 < PricesForBuy.Price10 / 10 
        or (PricesForBuy.Price1 * 2 < (PricesForBuy.Price100 / 100 + PricesForBuy.Price10 / 10) / 2) and PricesForBuy.Price1 > 0 then
            buySize, buyPrice = 1, PricesForBuy.Price1 * 2

        elseif (qtt > 40 and PricesForBuy.Price100 / 100 * 1.2 < PricesForBuy.Price10 / 10 
        or PricesForBuy.Price100 / 100 * 1.5 < PricesForBuy.Price10 / 10) and PricesForBuy.Price100 > 0  then
            buySize, buyPrice = 100, PricesForBuy.Price100 * 2

        else
            if qtt >= 100 and PricesForBuy.Price100 > 0 then
                buySize, buyPrice = 100, PricesForBuy.Price100 * 2
            elseif qtt >= 10 and PricesForBuy.Price10 > 0 then
                buySize, buyPrice = 10, PricesForBuy.Price10 * 2
            elseif qtt >= 1 and PricesForBuy.Price1 > 0 then
                buySize, buyPrice = 1, PricesForBuy.Price1 * 2
            end
        end


        -- 4) vérification kamas
        if character:kamas() < buyPrice then
            global:printSuccess("Plus assez de kamas pour lot de " .. buySize .. ", je retente dans 2h")
            customReconnect(120)
        end

        -- 5) exécution de l’achat
        developer:registerMessage("ExchangeBidHouseInListUpdatedEvent", _updatePrices)
 
        local message = developer:createMessage("ExchangeBidHouseBuyRequest")
        message.object_uid = PricesForBuy.UID
        message.price = buyPrice / 2
        message.quantity = buySize
        developer:sendMessage(message)

        global:printMessage("Achat de " .. buySize .. " de " .. inventory:itemNameId(objectGID) .. " pour " .. buyPrice / 2 .. " kamas")

        if not developer:suspendScriptUntil("ExchangeBidHouseInListUpdatedEvent", 5000, false, nil, 20) then
            global:printError("L'item n'est plus présent en hdv, je quitte")
            return false
        end
        global:delay(math.random(100, 600))
        -- faire l'achat
        qtt = qtt - buySize
    end

    
    if inventory:itemCount(objectGID) < theoricalNbInInventoryAfterBuy then
        global:printError("Achat de " .. inventory:itemNameId(objectGID) .. " échoué, il en manque " .. theoricalNbInInventoryAfterBuy - inventory:itemCount(objectGID))
        return achat(objectGID, theoricalNbInInventoryAfterBuy - inventory:itemCount(objectGID))
    end

    return true
end

function _updatePrices(message)
    if message.object_uid == UIDInHdvBuy then
        developer:unRegisterMessage("ExchangeBidHouseInListUpdatedEvent")
        local prices = message.prices
        PricesForBuy.Price1 = prices[0]
        PricesForBuy.Price10 = prices[1]
        PricesForBuy.Price100 = prices[2]
    end
end

function _AnalyseItemsOnSale(message)
    developer:unRegisterMessage("ExchangeStartedBidSellerMessage")
    local ItemsOnSale = {}
    local RessourcesOnSale = {}
    local toScan = message.objectsInfos

    local jsonPrice = openFile(global:getCurrentScriptDirectory() .. "\\".. character:server() .. "\\PriceItems.json")

    for _, data in ipairs(toScan) do
        if data.quantity == 1 and IsItem(inventory:itemTypeId(data.objectGID)) then
            local averagePrice = jsonPrice[1].Prices[tostring(data.objectGID)] and jsonPrice[1].Prices[tostring(data.objectGID)].AveragePrice or GetPricesItemInHdvSell(data.objectGID).AveragePrice
            local element = {
                Id = data.objectGID,
                UID = data.objectUID,
                Effects = data.effects,
                Price = data.objectPrice,
                Quality = 0,
                CurrentBestPrice = 0,
                AveragePrice = averagePrice
            }
            table.insert(ItemsOnSale, element)
        else
            local element = {
                Id = data.objectGID,
                UID = data.objectUID,
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

    global:printMessage("----------ACTUALISATION DES ITEMS ----------")
    
    HdvSell()

    for _, item in ipairs(ItemsOnSale) do
        global:printSuccess("AveragePrice de " .. inventory:itemNameId(item.Id) .. " : " .. item.AveragePrice)
        if ((item.Price - item.CurrentBestPrice) > 3000) and (item.Price / item.CurrentBestPrice) > 1.05 
        and (((item.CurrentBestPrice / item.Price) > 0.5) or (item.CurrentBestPrice > (item.AveragePrice * 0.25))) then -- permets d'éviter de mettre moins cher qu'un prix fail
            global:printMessage("Prix actuel : " .. item.Price)
            global:printMessage("Ancien meilleur prix : " .. item.CurrentBestPrice)
            item.CurrentBestPrice = math.max(GetPricesItemInHdvSell(item.Id).Price1 - 1, item.CurrentBestPrice)
            global:printMessage("Nouveau meilleur prix : " .. item.CurrentBestPrice)
            if ((item.Price - item.CurrentBestPrice) > 3000) and (item.Price / item.CurrentBestPrice) > 1.05 then
                global:printSuccess("[" .. inventory:itemNameId(item.Id) .. "] : ancien prix : " .. item.Price .. ", nouveau prix : " .. item.CurrentBestPrice - 1)
                sale:editPrice(item.UID, TraitementPrix(item.CurrentBestPrice), 1)
            end
        end
    end
    global:leaveDialog()

    global:printMessage("----------ACTUALISATION FINIE----------")


    global:printMessage("----------ACTUALISATION DES RESSOURCES ----------")

    HdvSell()

    local dicoNewPrices = {}
    local counter = 1
    for _, ressource in ipairs(RessourcesOnSale) do
        local idStr = tostring(ressource.Id)
        local lot   = ressource.Lot

        ressource.CurrentBestPrice = GetPricesItemInHdvSell(ressource.Id)
        dicoNewPrices[idStr] = dicoNewPrices[idStr] or {}
        -- Détermine la clé du prix en fonction du lot
        local keyName
        if lot == 100 then
            keyName = "Price100"
        elseif lot == 10 then
            keyName = "Price10"
        elseif lot == 1 then
            keyName = "Price1"
        end

        -- Essaie de récupérer le nouveau prix déjà calculé
        local newPrice = dicoNewPrices[idStr][keyName]

        -- S'il n'est pas encore calculé, on va le calculer "à la volée"
        if newPrice == nil then
            -- Récupère le meilleur prix actuel pour cet item
            local currentPrices = GetPricesItemInHdvSell(ressource.Id)

            -- Sélectionne le champ correspondant
            local bestPrice
            if lot == 100 then
                bestPrice = currentPrices.Price100
            elseif lot == 10 then
                bestPrice = currentPrices.Price10
            elseif lot == 1 then
                bestPrice = currentPrices.Price1
            end

            -- Si on peut baisser le prix, on stocke newPrice
            if bestPrice and bestPrice < ressource.Price then
                newPrice = bestPrice - 1
                dicoNewPrices[idStr][keyName] = newPrice
            end
        end

        -- Si on a bien un newPrice à appliquer, on met à jour
        if newPrice then
            global:printSuccess(
                "Actualisation " .. counter .. " [" .. lot ..
                "] x [" .. inventory:itemNameId(ressource.Id) ..
                "] : " .. ressource.Price ..
                " -> " .. newPrice .. " kamas"
            )
            sale:editPrice(ressource.UID, newPrice, lot)
            counter = counter + 1
        end
    end

    global:printSuccess("Fin fonction actualisation")
end

function openHdvAndUpdateItems()
    global:printMessage("Ouverture de l'HDV pour vendre (actualiser)")
    local message = developer:createMessage("InteractiveUseRequest")
    message.element_id = HDV_INTERACTIONS_ID[tostring(map:currentMapId())].elementID
    message.specific_instance_id = 0
    message.skill_instance_uid = HDV_INTERACTIONS_ID[tostring(map:currentMapId())].skillInstanceUID
    developer:sendMessage(message)
    if not developer:suspendScriptUntil("ExchangeBidBuyerStartedEvent", 5000, false, nil, 50) then
        global:printError("L'HDV n'a pas pu être ouvert, on déco reco")
        customReconnect(0)
        return
    end
    randomDelay()
    
    developer:registerMessage("ExchangeStartedBidSellerMessage", _AnalyseItemsOnSale)
    local message = developer:createMessage("NpcGenericActionRequestMessage")
    message.npcId = -1
    message.npcActionId = 5
    message.npcMapId = map:currentMapId()
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 2000, false, nil, 50)
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
        if #element.effects > 0 and tostring(element.effects[1]) == "SwiftBot.ObjectEffectInteger" and element.effects[1].level == 100 and element.effects[1].isRideable then
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

    global:leaveDialog()

    HdvSell()
    BestPrice = (BestPrice == 0) and GetPricesItemInHdvSell(Id).AveragePrice * 2 or BestPrice

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
        if #element.effects > 0 and tostring(element.effects[1]) == "SwiftBot.ObjectEffectMount" and element.effects[1].level == 100 and element.effects[1].isRideable then
            BestPrice100 = element.prices[1] - 1
            break
        end
    end
    for _, element in ipairs(dd) do
        if #element.effects > 0 and tostring(element.effects[1]) == "SwiftBot.ObjectEffectMount" and element.effects[1].isRideable then
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
        if #element.effects > 0 and tostring(element.effects[1]) == "SwiftBot.ObjectEffectInteger" and element.effects[1].isRideable then
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
        if #element.effects > 0 and tostring(element.effects[1]) == "SwiftBot.ObjectEffectInteger" and element.effects[1].isRideable and element.effects[1].level == 100 then
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
            item.CurrentBestPrice = math.max(GetPricesItemInHdvSell(item.Id).Price1 - 1, item.CurrentBestPrice)
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




function _fetchItemsInHDV(message)
    developer:unRegisterMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage")
    ItemList = {}
    debug(tostring(message))
    local items = message.itemTypeDescriptions
    if not items or #items == 0 then
        global:printError("Aucun item trouvé dans l'HDV pour l'ID " .. message.type_id)
        return ItemList
    end
    

    for _, item in ipairs(items) do
        if item.objectGID > 0 then
            table.insert(ItemList, {
                objectGID = item.objectGID,
                objectUID = item.objectUID,
                price = item.prices[1],
                effects = item.effects,
                quality = GetQualityItemWithoutException(item.effects, item.objectGID)
            })
        end
    end
end

function fetchItemsInHDV(objectGID)
    developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _fetchItemsInHDV)

    local message = developer:createMessage("ExchangeBidHouseTypeRequest")
    message.follow = true
    message.type_id = inventory:itemTypeId(objectGID)

    local message2 = developer:createMessage("ExchangeBidHouseSearchRequest")
    message2.follow = true
    message2.object_gid = objectGID

    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeTypesExchangerDescriptionForUserEvent", 5000, false, nil, 20)

    developer:sendMessage(message2)
    
    developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 5000, false, nil, 20)

    return ItemList
end

function buyWorthItem(objectGID)
    HdvBuy()

    local items = fetchItemsInHDV(objectGID)

    table.sort(items, function(a, b)
        -- 1) premières les qualités > 0.8
        local a_high = a.quality > 0.8
        local b_high = b.quality > 0.8
        if a_high ~= b_high then
            return a_high 
        end

        return (a.price / a.quality) < (b.price / b.quality)
    end)

    global:printSuccess("Achat de " .. inventory:itemNameId(objectGID) .. " pour " .. items[1].price .. " kamas avec un jet de " .. items[1].quality)

    local message = developer:createMessage("ExchangeBidHouseBuyRequest")
    message.object_uid = items[1].objectUID
    message.price = items[1].price
    message.quantity = 1
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeBidHouseBuyResultMessage", 5000, false, nil, 20)

    global:leaveDialog()
end
