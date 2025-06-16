dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\TablesStuff&Runes.lua")
json = dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\json.lua")


local Quality_ItemToSell = 0
local IdToSell = 0
local UIDToSell = 0
local BestPrice = 0
local Stats = {}

string.split = function(self, sep, rawSep)
    local insert, result = table.insert, {}
    if not sep then
        sep = "."
        rawSep = true
    end
    if sep == "%s" then
        rawSep = nil
    end

    local rawSep = rawSep and sep or "([^" .. sep .. "]+)"

    for match in self:gmatch(rawSep) do
        insert(result, match)
    end

    return result
end

local rndm, print = math.random, {}

local charController = global:thisAccountController()

local function try(fn, catch)
    local status, result = pcall(fn)

    if not status then
        return catch and catch(status, result)
    else
        return result
    end
end

setmetatable(print, print)

local function getPrint(message, info)
    if info then message = "[Info] - " .. message end

    return message
end

print.__call = function(self, message, info)
    global:printMessage(getPrint(message, info))
end

print.success = function(self, message, info)
    global:printSuccess(getPrint(message, info))
end

print.error = function(self, message)
    global:printError(getPrint(message, info))
end

print.color = function(self, message, color)
    if not color then color = "#4d8fbe" end

    global:printColor(color, message)
end

print.void = function(self)
    self:color("", "#343434")
end

print.sep = function(self, color)
    if color == nil then
        self("--------------------------")
    else
        if color == true then
            self:success("--------------------------")
        else
            self:error("--------------------------")
        end
    end
end


function GetQualityItem(ItemStats, Id)
    Id = Id or IdToSell
    local toReturn = 0

    for _, stat in ipairs(ItemStats) do
        if IsActionIdKnown(stat.actionId) and not GetNameCarac(stat.actionId):find("-") then
            toReturn = toReturn + stat.value * PoidsByStat[GetNameCarac(stat.actionId)].PoidsUnite
        end
    end
    return toReturn
end

function FinalSelling(Id, UID, Price)
    if Price < 2 then
        local TotalCost = 0

        npc:npcSale()

        for _, item in ipairs(TableStuffs) do
            if item.Id == Id then
                for _, Ressource in ipairs(item.ListIdCraft) do
                    local Prices = GetPricesItem(Ressource.Id)
                    TotalCost = TotalCost + Prices.AveragePrice * Ressource.Nb
                end
                break
            end
        end
        Price = math.floor(TotalCost * 1.5)
        if Price == 0 then
            Price = sale:getPriceItem(Id, 1)
        end
        global:leaveDialog()
    end
    if Price == 0 then
        return false
    end
    if character:kamas() > Price * 0.03 then
        npc:npcSale()

        local obj = {}
        obj["call"] = "sendMessage"
        obj["data"] = {
            ["type"] = "ExchangeObjectMovePricedMessage",
            ["data"] = {
                ["objectUID"] = UID,
                ["quantity"] = 1,
                ["price"] = Price,
            }
        }
    
        local msg = developer:fromObject(obj)
    
        developer:sendMessage(msg)
    
        global:printSuccess("1 lot de [" .. inventory:itemNameId(Id) .. "] à " .. Price .. " kamas")
    
        global:leaveDialog()
    else
        global:printError("Pas assez de kamas pour vendre, on réessaie dans 2 heures")
        global:reconnect(2)
    end
end

function _GetBestPrice(message)
    developer:unRegisterMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage")
    local message = developer:toObject(message)
    local toScan = message.itemTypeDescriptions
    local AllItemsInHdv = {}

    for _, data in ipairs(toScan) do
        local element = {
            Quality = GetQualityItem(data.effects),
            Price = data.prices[1]
        }
        table.insert(AllItemsInHdv, element)
    end

    table.sort(AllItemsInHdv, function (a, b)
        return a.Price < b.Price        
    end)


    for _, element in ipairs(AllItemsInHdv) do
        if Quality_ItemToSell < element.Quality then
            BestPrice = (element.Price > 0) and element.Price - 1 or element.Price
            break
        end
    end

    global:printSuccess("Meilleur prix trouvé : " .. BestPrice)
end

function GetNameCarac(Id)
    for _, element in ipairs(IdWithCaracName) do
        if element.Id == Id then
            return element.Name
        end
    end
end

function IsActionIdKnown(actionId)
    for _, element in ipairs(IdWithCaracName) do
        if element.Id == actionId then
            return true
        end
    end
    return false
end

function SellItem(Id, MinPrice, MaxPrice)
    MinPrice = MinPrice or 0
    MaxPrice = MaxPrice or 100000000
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

    Quality_ItemToSell = GetQualityItem(ItemStats) - 0.05
    global:printSuccess("Poids de l'item " .. inventory:itemNameId(Id) .. " : " .. Quality_ItemToSell)
    npc:npcBuy()

    local obj = {}
    obj["call"] = "sendMessage"
    obj["data"] = {
        ["type"] = "ExchangeBidHouseTypeMessage",
        ["data"] = {
            ["type"] = inventory:itemTypeId(Id),
        }
    }

    local msg = developer:fromObject(obj)
    developer:sendMessage(msg)

    developer:suspendScriptUntil("ExchangeTypesExchangerDescriptionForUserMessage", 5000, false, nil, 20)

    local obj = {}
    obj["call"] = "sendMessage"
    obj["data"] = {
        ["type"] = "ExchangeBidHouseListMessage",
        ["data"] = {
            ["id"] = Id,
        }
    }

    local msg = developer:fromObject(obj)

    developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _GetBestPrice)

    developer:sendMessage(msg)

    developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 5000, false, nil, 20)
    
    global:leaveDialog()

    if BestPrice > MaxPrice then
        return FinalSelling(IdToSell, UIDToSell, MaxPrice)
    elseif BestPrice < MinPrice then
        return FinalSelling(IdToSell, UIDToSell, MinPrice)
    else
        return FinalSelling(IdToSell, UIDToSell, BestPrice)
    end
    BestPrice = 0
    Quality_ItemToSell = 0
    return true
end

function printVar(variable, name, indent)
    name = name or "Variable"
    indent = indent or ""
    if type(variable) == "table" then
        global:printSuccess(indent .. name .. " = {")
        for k, v in pairs(variable) do
            printVar(v, k, indent .. "  ")
        end
        global:printSuccess(indent .. "}")
    else
        global:printSuccess(indent .. name .. " = " .. tostring(variable))
    end
  end

function _GetMessagePrices(message)
    TablePrice = {}
    developer:unRegisterMessage("ExchangeBidhouseMinimumItemPriceListMessage")
    local message = developer:toObject(message)

    local AveragePrice = 0

    if message.prices[2] == 0 and message.prices[3] == 0 then
        AveragePrice = message.prices[1]
    elseif message.prices[3] == 0 and message.prices[1] == 0 then
        AveragePrice = message.prices[2] / 10
    elseif message.prices[2] == 0 and message.prices[1] == 0 then
        AveragePrice = message.prices[3] / 100
    elseif message.prices[3] ~= 0 and message.prices[1] ~= 0 and message.prices[2] ~= 0 then
        AveragePrice =(message.prices[3] / 100 + message.prices[2] / 10 + message.prices[1]) / 3
    elseif message.prices[3] == 0 then
        AveragePrice = (message.prices[2] / 10 + message.prices[1]) / 2
    elseif message.prices[2] == 0 then
        AveragePrice = (message.prices[3] / 100 + message.prices[1]) / 2
    elseif message.prices[1] == 0 then
        AveragePrice = (message.prices[3] / 100 + message.prices[2] / 10) / 2
    end

    local element = {
        Id = message.objectGID,
        Price1 = message.prices[1],
        Price10 = message.prices[2],
        Price100 = message.prices[3],
        AveragePrice = math.floor(AveragePrice)
    }
    table.insert(TablePrice, element)
end

function GetPricesItem(Id)
    developer:registerMessage("ExchangeBidhouseMinimumItemPriceListMessage", _GetMessagePrices)
    local obj = {}
    obj["call"] = "sendMessage"
    obj["data"] = {
        ["type"] = "ExchangeBidHouseListMessage",
        ["data"] = {
            ["id"] = Id,
        }
    }
    local msg = developer:fromObject(obj)
    developer:sendMessage(msg)

    developer:suspendScriptUntil("ExchangeBidhouseMinimumItemPriceListMessage", 5000, false, nil, 20)

    for _, item in ipairs(TablePrice) do
        if Id == item.Id then
            return item
        end
    end
end



function Achat(IdItem, qtt)
    --[[
        Amelioratioons :

    ]]
    npc:npcSale()

    local Quantite = qtt
    local NbDeBdase = inventory:itemCount(IdItem)

    local Prices = GetPricesItem(IdItem)

    global:printSuccess("Prix par 100 : " .. Prices.Price100)
    global:printSuccess("Prix par 10 : " .. Prices.Price10)
    global:printSuccess("Prix par 1 : " .. Prices.Price1)

    global:leaveDialog()


    if (Prices.Price100 == 0) and (Prices.Price10 == 0) and (Prices.Price1 == 0) then
        global:printSuccess("L'item n'est plus disponible en hdv")
        global:restartScript(true)
        return false
    elseif Prices.Price10 == 0 and Prices.Price100 == 0 and qtt < 21 then
        qtt = 1
    elseif ((Prices.Price10 == 0) and (Prices.Price1 == 0)) or ((qtt > 10) and Prices.Price10 * qtt / 10 > Prices.Price100 and Prices.Price100 > 0) or (Prices.Price10 == 0 and qtt > 9 and qtt < 100 ) then
        qtt = 100
    elseif Prices.Price1 == 0 and qtt < 10 then
        qtt = 10
    elseif qtt > 10 and qtt < 100 and qtt % 10 * Prices.Price1 > Prices.Price10 then
        qtt = qtt + (10 - qtt % 10)
    elseif qtt < 10 and Prices.Price1 * qtt > Prices.Price10 then
        qtt = 10
    elseif (Prices.Price100 ~= 0) and (Prices.Price10 ~= 0) then
        qtt = ((((qtt < 100) and (qtt > 10)) and (Prices.Price100 * 1.3 < Prices.Price10 * 10)) and (inventory:itemWeight(IdItem) * 100) < (inventory:podsMax() - inventory:pods())) and 100
        or ((qtt < 10) and (Prices.Price10 * 1.3 < Prices.Price1 * 10)) and 10
        or qtt
    end

    npc:npcBuy()

    while qtt > 0 do           
        if qtt >= 100 then
            if character:kamas() < Prices.Price100 then
                global:printSuccess("Plus assez de kamas, on retente dans 2h")
                global:reconnect(2)
            end
            if ((Prices.Price10 * 1.2 < Prices.Price100 / 10) and Prices.Price10 ~= 0) or Prices.Price100 == 0 then
                for i = 1, 10 do
                    sale:buyItem(IdItem, 10, 2000000)
                end
                local nbRessourceManquante = NbDeBdase + Quantite - inventory:itemCount(IdItem) -- 50 de base 50 acheter
                return Achat(IdItem, nbRessourceManquante)
            elseif Prices.Price100 == 0 and Prices.Price10 == 0 then
                for i = 1, 10 do
                    sale:buyItem(IdItem, 1, 2000000)
                end
                local nbRessourceManquante = NbDeBdase + Quantite - inventory:itemCount(IdItem) -- 50 de base 50 acheter
                return Achat(IdItem, nbRessourceManquante)
            else
                sale:buyItem(IdItem, 100, 100000000)
                qtt = qtt - 100             
            end
        elseif qtt >= 10 and qtt < 100 then
            if character:kamas() < Prices.Price10 then
                global:printSuccess("Plus assez de kamas, on retente dans 2h")
                global:reconnect(2)
            end
            if ((Prices.Price1 * 1.2 < Prices.Price10 / 10) and Prices.Price1 ~= 0) or Prices.Price10 == 0 then
                for i = 1, 10 do
                    sale:buyItem(IdItem, 1, 2000000)
                end
                local nbRessourceManquante = NbDeBdase + Quantite - inventory:itemCount(IdItem) -- 50 de base 50 acheter
                return Achat(IdItem, nbRessourceManquante)
            else
                sale:buyItem(IdItem, 10, 10000000)
                qtt = qtt - 10
            end
        elseif qtt >= 1 and qtt < 10 then
            if character:kamas() < Prices.Price1 then
                global:printSuccess("Plus assez de kamas, on retente dans 2h")
                global:reconnect(2)
            end
            sale:buyItem(IdItem, 1, 1500000)
            qtt = qtt - 1 
        end
    end

    global:leaveDialog()

    local nbRessourceManquante = NbDeBdase + Quantite - inventory:itemCount(IdItem)
    if nbRessourceManquante > 0 then
        Achat(IdItem, nbRessourceManquante)
    end
    global:printSuccess("Fin achat")
    return true
end


function _AnalyseItemsOnSale(message)
    developer:unRegisterMessage("ExchangeStartedBidSellerMessage")
    message = developer:toObject(message)
    local ItemsOnSale = {}
    local RessourcesOnSale = {}
    local toScan = message.objectsInfos

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

    npc:npcBuy()

    for _, item in ipairs(ItemsOnSale) do
        IdToSell = item.Id
        item.Quality = GetQualityItem(item.Effects, item.Id) - 0.05
        Quality_ItemToSell = item.Quality

        global:printSuccess("Qualité de " .. inventory:itemNameId(item.Id) .. " : " .. item.Quality)
        global:printSuccess("Prix actuel : " .. item.Price)
        local obj = {}
        obj["call"] = "sendMessage"
        obj["data"] = {
            ["type"] = "ExchangeBidHouseTypeMessage",
            ["data"] = {
                ["type"] = inventory:itemTypeId(item.Id),
            }
        }

        local msg = developer:fromObject(obj)
        developer:sendMessage(msg)
    
        developer:suspendScriptUntil("ExchangeTypesExchangerDescriptionForUserMessage", 5000, false, nil, 20)
    
        local obj = {}
        obj["call"] = "sendMessage"
        obj["data"] = {
            ["type"] = "ExchangeBidHouseListMessage",
            ["data"] = {
                ["id"] = item.Id,
            }
        }

        local msg = developer:fromObject(obj)
    
        developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _GetBestPrice)
    
        developer:sendMessage(msg)

        developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 5000, false, nil, 20)

        item.CurrentBestPrice = BestPrice
    end

    global:leaveDialog()

    global:printMessage("----------ACTUALISATION----------")
    npc:npcSale()

    for _, item in ipairs(ItemsOnSale) do
        if ((item.Price - item.CurrentBestPrice) > 2000) then
            global:printSuccess("[" .. inventory:itemNameId(item.Id) .. "] : ancien prix : " .. item.Price .. ", nouveau prix : " .. item.CurrentBestPrice - 1)
            sale:editPrice(item.UID, item.CurrentBestPrice - 1, 1)
        end
    end
    global:leaveDialog()

    global:printMessage("----------ACTUALISATION FINIE----------")

    npc:npcBuy()

    for _, ressource in ipairs(RessourcesOnSale) do
        local Prices = GetPricesItem(ressource.Id)
        ressource.CurrentBestPrice = Prices
    end

    global:leaveDialog()

    npc:npcSale()

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
end

function UpdateAllItemOpti()
    developer:registerMessage("ExchangeStartedBidSellerMessage", _AnalyseItemsOnSale)
    npc:npcSale()
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 5000, false, nil, 20)
end

function PopoRappel()
    if inventory:itemCount(548) == 0 then
        npc:npcBuy()
        global:delay(500)
        sale:buyItem(548, 1, 1000)
        if inventory:itemCount(548) == 0 then
            sale:buyItem(548, 10, 10000)
        end
        global:delay(500)
        global:leaveDialog()
        global:delay(500)
    end
    inventory:useItem(548)
end

function PopoBonta()
    if map:currentArea() ~= "Bonta" then
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
end
function PopoBrakmar()
    if map:currentArea() ~= "Brakmar" then
        if inventory:itemCount(6964) == 0 then
            npc:npcBuy()
            global:delay(500)
            sale:buyItem(6964, 1, 1000)
            if inventory:itemCount(6964) == 0 then
                sale:buyItem(6964, 10, 10000)
            end
            global:delay(500)
            global:leaveDialog()
            global:delay(500)
        end
        inventory:useItem(6964)
    end
end
function LoadAndConnectBotBanque(trajetBotBank)
    global:printSuccess("Connexion du bot banque")

    local All_Alias = ankabotController:getAliasAllRegistredAccounts()
    local All_Username = ankabotController:getUsernameAllRegistredAccounts()

    for i, Alias in ipairs(All_Alias) do
        if Alias:find("bank_" .. character:serverName():lower()) then
            for j, Username in ipairs(All_Username) do
                if i == j then
                    while ankabotController:accountIsLoaded(Username) do
                        global:printMessage("On attend que le bot se décharge")
                        if not ankabotController:getAccount(Username):isAccountConnected() then
                            global:delay(10000)
                            if not ankabotController:getAccount(Username):isAccountConnected() then
                                ankabotController:getAccount(Username):unloadAccount()
                            end
                        else
                            if ConsoleRead(global:thisAccountController(), "Le serveur a coupé la connexion inopinément") and not ankabotController:getAccount(Username):isScriptPlaying() then
                                global:clearConsole()
                                ankabotController:getAccount(Username):unloadAccount()
                                return LoadAndConnectBotBanque(trajetBotBank)
                            end
                        end
                        global:delay(5000)
                    end

                    global:printSuccess("On charge le compte!")
                    local acc = ankabotController:loadAccount(Username, true)

                    local WaitingTime = 0
                    while not acc:isAccountFullyConnected() do
                        global:printMessage("Attente de la connexion du bot")
                        global:delay(5000)
                        WaitingTime = WaitingTime + 5
                        if WaitingTime > 120 then
                            global:restartScript(true)
                        end
                    end

                    acc:loadScript(trajetBotBank)

                    if acc.map:currentArea() ~= "Astrub" then
                        acc:callScriptFunction("PopoRappel")
                        global:delay(5000)
                    end
                    acc:startScript()
                    while not acc.map:onMap(map:currentMapId()) do
                        global:printSuccess("On attend que le bot banque nous rejoigne")
                        global:delay(5000)
                    end
                    global:delay(2000)
                    return acc
                end
            end
        end
    end
end

---Fonction qui permet de recuperer les nombres de lots d'un item en HDV.
function get_quantity(id)
    if object_in_hdv then
        informations = {
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
    message = developer:toObject(message)
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

function CraftReady()
    developer:sendMessage('{"call":"sendMessage","data":{"type":"ExchangeReadyMessage","data":{"ready":true,"step":2}}}')
    developer:suspendScriptUntil("ExchangeCraftResultWithObjectDescMessage", 5000, false, nil, 20)
end

function ManageMount()
    local myMount = mount:myMount()

    if myMount ~= nil then
        if not myMount.isRideable then
            global:printSuccess("Ma dd n'est pas montable, on la libère")
            developer:sendMessage('{"call":"sendMessage","data":{"type":"MountReleaseRequestMessage"}}')
        end
        if not mount:isRiding() then
            mount:toggleRiding()
        end
        if myMount.level < 100 and character:level() > 75 then
            global:printSuccess("dd level : " .. myMount.level)
            mount:setXpRatio(90)
        else
            mount:setXpRatio(0)
        end
    
        if (myMount.energyMax - myMount.energy) > 1000 and character:kamas() > 10000 and character:energyPoints() > 0 and (inventory:podsMax() - inventory:pods()) > 300 then
            global:printSuccess("ProcessAchat nourriture pour dragodinde...")
            -- mettre l'achat de nourriture pour monture
            local TableAchat = {
                {Name = "Poisson Pané", Id = 1750, Price = 999999},
                {Name = "Crabe Sourimi", Id = 1757, Price = 999999},
                {Name = "Goujon", Id = 1782, Price = 999999},
                {Name = "Brochet", Id = 1847, Price = 999999},
                {Name = "Sardine Brillante", Id = 1805, Price = 999999},
                {Name = "Cuisse de Boufton", Id = 1911, Price = 999999},
                {Name = "Cuisse de Bouftou **", Id = 1912, Price = 999999},
                {Name = "Poisson-Chaton", Id = 603, Price = 999999},
                {Name = "Bar Rikain", Id = 1779, Price = 999999},
            }
        
            npc:npcSale()

            for _, element in ipairs(TableAchat) do
                element.Price = GetPricesItem(element.Id).Price100
            end
    
            table.sort(TableAchat, function (a, b)
                return a.Price < b.Price
            end)

            global:leaveDialog()

            global:delay(500)

            npc:npcBuy()
            global:delay(500)

            for i, element in ipairs(TableAchat) do
                if element.Price > 0 then
                    index = i
                    sale:buyItem(element.Id, 100, element.Price + 1)
                    break
                end
            end

            global:delay(500)
            global:leaveDialog()

            mount:feedMount(TableAchat[index].Id, 100)
            if not mount:isRiding() then
                mount:toggleRiding()
            end
        end
    end
end

function AllTeamHavePanneau70()
    local Stuff70 = {
        {Type = "Coiffe", Id = 2531, Position = 6},
        {Type = "Cape", Id = 2532, Position = 7},
        {Type = "Ceinture", Id = 2683, Position = 3},
        {Type = "Amulette", Id = 10836, Position = 0},
        {Type = "AnneauGauche", Id = 2469, Position = 4},
        {Type = "AnneauDroit", Id = 1559, Position = 2},
        {Type = "Bottes", Id = 6470, Position = 5},
    }

   local team = global:thisAccountController():getTeamAccounts()
   table.insert(team, global:thisAccountController()) 
   for _, acc in ipairs(team) do
        for _, item in ipairs(Stuff70) do
            if acc.inventory:itemCount(item.Id) == 0 then
                return false
            end
        end
   end
   return true
end

function ConsoleRead(acc, string)
    local lines = acc.global:consoleLines() or {}
    local found = false
    if lines then
        for i = 1, #lines do
            found = found or (lines[i]:find(string) ~= nil)
        end
    end
    return found
end

-- function GoTo(mapToward, action)
--     local toward = mapToward:split(",")
--     if not map:onMap(mapToward) then
--         if #toward == 2 then
--             return map:moveToward(tonumber(toward[1]), tonumber(toward[2]))
--         elseif #toward == 1 then
--             return map:moveToward(tonumber(toward[1]))
--         end
--     else
--         action()
--     end
-- end

function GoTo(mapToward, action)
    local toward = mapToward:split(",")
    local onMap = map:onMap(mapToward)
    local num1, num2 = tonumber(toward[1]), tonumber(toward[2])
    return (not onMap and (#toward == 2 and map:moveToward(num1, num2) or #toward == 1 and map:moveToward(num1))) or action()
end

function TakeBonusPackForTeam()
    if not global:remember("WaitingTimeToBuyBonusPack") then
        global:addInMemory("WaitingTimeToBuyBonusPack", 0)
    end
    if ((os.time() - global:remember("WaitingTimeToBuyBonusPack")) / 60 / 60) >= 2 then
        global:editInMemory("WaitingTimeToBuyBonusPack", 0)
    end
    if global:isBoss() and global:remember("WaitingTimeToBuyBonusPack") == 0 then
        local TeamAcount = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(TeamAcount) do
            if acc.character:bonusPackExpiration() == 0 then
                acc.inventory:openBank()
                if acc.exchange:storageKamas() > 0 then
                    acc.global:printSuccess("Il y a " .. acc.exchange:storageKamas() .. " kamas en banque, on les prend")
                    acc.exchange:getKamas(0)
                    acc.global:delay(500)
                elseif acc.exchange:storageKamas() == 0 then
                    acc.global:printError("Il n'y a pas de kamas en banque")
                    acc.global:delay(500)
                end
                acc.global:leaveDialog()
                if acc.character:kamas() > 50000 then
                    acc.character:getBonusPack(1)
                    acc.global:reconnect(0)
                else
                    global:editInMemory("WaitingTimeToBuyBonusPack", os.time())
                    acc.global:printError("Pas assez de kamas pour acheter le bonue pack")
                end
            end
        end
        if character:bonusPackExpiration() == 0 then
            inventory:openBank()
            if exchange:storageKamas() > 0 then
                global:printSuccess("Il y a " .. exchange:storageKamas() .. " kamas en banque, on les prend")
                exchange:getKamas(0)
                global:delay(500)
            elseif exchange:storageKamas() == 0 then
                global:printError("Il n'y a pas de kamas en banque")
                global:delay(500)
            end
            global:leaveDialog()
            if character:kamas() > 50000 then
                character:getBonusPack(1)
                global:reconnect(0)
            else
                global:printError("Pas assez de kamas pour acheter le bonue pack")
                global:editInMemory("WaitingTimeToBuyBonusPack", os.time())
            end
        end
    end
end

function GetTypeBan(acc)
    local modoban = ConsoleRead(acc, "vient de vous bannir")
    local defban = ConsoleRead(acc, "banni définitivement")
    return (modoban and "[BAN MODO]") or (defban and "[BAN DEF]") or "[BAN JSP]"
end


function bank()
    return move()
end

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

function openFile(path, del)
    local fileResult = io.open(path, "r")

    if fileResult then
        local content = fileResult:read("*a")
        fileResult:close()

        if del then os.remove(path) end

        return path:find(".json")
            and json.decode(content)
            or content 
    end
end

function writeFile(path, data)
    local file = io.open(path, "w")

    file:write(path:find(".json") and json.encode(data) or data)
    file:close()
end

AllRecipes = openFile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\MetierCraft\\id_to_recipe.json")


function get_recipe(id)

    local ingredientsTable = {}
    local tableToAnalyse = AllRecipes[tostring(id)]

    if tableToAnalyse then
        local ingredients = AllRecipes[tostring(id)]["ingredient"]
        local quantities = AllRecipes[tostring(id)]["quantity"]
    
        if ingredients then
            for i, ingredientId in ipairs(ingredients) do
                local ingredientQuantity = quantities[i]
                ingredientsTable[i] = { Id = ingredientId, Quantity = ingredientQuantity }
            end
        end
    else
        return nil
    end


    return ingredientsTable
end

function get_level_craft_item(recipe)

    if not recipe then
        return 101
    end
    return not recipe and 0 
        or #recipe == 1 and 1
        or #recipe == 2 and 1 
        or #recipe == 3 and 10
        or #recipe == 4 and 20
        or #recipe == 5 and 40
        or #recipe == 6 and 60
        or #recipe == 7 and 80
        or #recipe == 8 and 100
end


function IsItem(TypeId)
    local Ids = { 16, 17, 11, 10, 1, 9, 82, 151, 7, 19, 8, 6, 5, 2, 3, 4, 81}
    for _, Id in ipairs(Ids) do
        if Id == TypeId then
            return true
        end
    end
    return false
end

function get_type_name(id)
    local typeId = inventory:itemTypeId(id)
    local tableId = {
        ["16"] = "Coiffe",
        ["17"] = "Cape",
        ["10"] = "Ceinture",
        ["1"] = "Amulette",
        ["9"] = "Anneau",
        ["11"] = "Bottes",
        ["81"] = "Sac à Dos"
    }
    return tableId[tostring(typeId)]
end

function _GetMeanDice(message)
    developer:unRegisterMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage")
    Stats = {}
    local message = developer:toObject(message)
    local toScan = message.itemTypeDescriptions
    local AllItemsInHdv = {}
    local dicoStats = {}

    for _, data in ipairs(toScan) do
        table.insert(AllItemsInHdv, data.effects)
    end

    for _, element in ipairs(AllItemsInHdv) do
        for _, stat in ipairs(element) do
            dicoStats[tostring(stat.actionId)] = not dicoStats[tostring(stat.actionId)] and stat.value or dicoStats[tostring(stat.actionId)] + stat.value
            dicoStats["nb" .. tostring(stat.actionId)] = not dicoStats["nb" .. tostring(stat.actionId)] and 1 or dicoStats["nb" .. tostring(stat.actionId)] + 1
        end
    end

    for k, v in pairs(dicoStats) do
        if not k:find("nb") and dicoStats["nb" .. k] > #AllItemsInHdv / 2 then
            table.insert(Stats, {
                actionId = tonumber(k),
                value = math.ceil(v / dicoStats["nb" .. k])
            })
        end
    end
end

function GetDice(Id)

    local obj = {}
    obj["call"] = "sendMessage"
    obj["data"] = {
        ["type"] = "ExchangeBidHouseTypeMessage",
        ["data"] = {
            ["type"] = inventory:itemTypeId(Id),
        }
    }

    local msg = developer:fromObject(obj)
    developer:sendMessage(msg)

    developer:suspendScriptUntil("ExchangeTypesExchangerDescriptionForUserMessage", 5000, false, nil, 20)

    local obj = {}
    obj["call"] = "sendMessage"
    obj["data"] = {
        ["type"] = "ExchangeBidHouseListMessage",
        ["data"] = {
            ["id"] = Id,
        }
    }

    local msg = developer:fromObject(obj)

    developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _GetMeanDice)

    developer:sendMessage(msg)

    developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 5000, false, nil, 20)

    return Stats
end

function GetEstimationEarnsOnBreak(dice)
    local toReturn = 0

    for _, stat in ipairs(dice) do
        if stat.actionId == 111 or stat.actionId == 128 or stat.actionId == 117 or stat.actionId == 182 then
            local percentage = math.min(1.5 * ((inventory:getLevel(Id)^2) / PoidsByStat[GetNameCarac(stat.actionId)].PoidsUnite^(5/4)), 67)
            toReturn = toReturn + (percentage / 100) *PoidsByStat[GetNameCarac(stat.actionId)].Runes[1].Prices.AveragePrice
            --global:printSuccess("Il y a " .. percentage .."% de chance d'obtenir une rune " .. GetNameCarac(stat.actionId))
        elseif IsActionIdKnown(stat.actionId) and not GetNameCarac(stat.actionId):find("-") then

            --global:printSuccess(GetNameCarac(stat.actionId) .. " : " .. stat.value)
            local poidsStat = stat.value * PoidsByStat[GetNameCarac(stat.actionId)].PoidsUnite
            local minPoids = poidsStat * (2/3) * 0.9
            local maxPoids = poidsStat * (2/3) * 1.1

            local infoRunes = PoidsByStat[GetNameCarac(stat.actionId)].Runes
            local poidsRunes = {}
            local pwdRunes = {}

            local nbRunesObtenuesMax = {}
            local nbRunesObtenuesMin = {}

            for i = 1, 3 do
                poidsRunes[i] = not infoRunes[i] and 9999999 or infoRunes[i].Poids
            end
            pwdRunes[1] = poidsRunes[1]
            pwdRunes[2] = 2 * poidsRunes[1] + poidsRunes[2]
            pwdRunes[3] = 4 * poidsRunes[1] + 2 * poidsRunes[2] + poidsRunes[3]

            local reste = minPoids
            for i = 1, 3 do
                nbRunesObtenuesMin[i] = math.floor(reste / pwdRunes[4-i])
                reste = reste - nbRunesObtenuesMin[i] * poidsRunes[4-i]
            end
            nbRunesObtenuesMin[3] = nbRunesObtenuesMin[3] + reste

            reste = maxPoids
            for i = 1, 3 do
                nbRunesObtenuesMax[i] = math.floor(reste / pwdRunes[4-i])
                reste = reste - nbRunesObtenuesMax[i] * poidsRunes[4-i]
            end
            nbRunesObtenuesMax[3] = nbRunesObtenuesMax[3] + reste

            local earnsMini = 0
            local earnsMax = 0
            for i = 1, #PoidsByStat[GetNameCarac(stat.actionId)].Runes do
                earnsMini = earnsMini + nbRunesObtenuesMin[i] * PoidsByStat[GetNameCarac(stat.actionId)].Runes[#PoidsByStat[GetNameCarac(stat.actionId)].Runes + 1 - i].Prices.AveragePrice
                earnsMax = earnsMax + nbRunesObtenuesMax[i] * PoidsByStat[GetNameCarac(stat.actionId)].Runes[#PoidsByStat[GetNameCarac(stat.actionId)].Runes + 1 - i].Prices.AveragePrice
            end
            toReturn = toReturn + (earnsMini + earnsMax) / 2

        end
    end

    return math.floor(toReturn)
end