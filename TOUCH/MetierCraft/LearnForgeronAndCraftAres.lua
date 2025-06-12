dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\All_Fonctions.lua")

local TrajetForgeronAstrub = {
    { map = "5,7", path = "zaap(84674563)" },
    { map = "10,22", path = "zaap(84674563)"},
    { map = "-16,1", path = "zaap(84674563)"},
    { map = "-1,-22", path = "right" },
    { map = "-1,-21", path = "right" },
    { map = "-1,-20", path = "right" },
    { map = "-1,-19", path = "right" },
    { map = "-1,-18", path = "right" },
    { map = "-1,-17", path = "right" },
    { map = "-1,-16", path = "right" },
    { map = "-1,-15", path = "right" },
    { map = "-1,-14", path = "right" },
    { map = "0,-14", path = "right" },
    { map = "1,-14", path = "right" },
    { map = "1,-15", path = "right" },
    { map = "0,-15", path = "right" },
    { map = "0,-16", path = "right" },
    { map = "0,-17", path = "right" },
    { map = "1,-17", path = "right" },
    { map = "1,-16", path = "right" },
    { map = "2,-16", path = "right" },
    { map = "2,-15", path = "right" },
    { map = "2,-14", path = "right" },
    { map = "2,-17", path = "right" },
    { map = "2,-18", path = "right" },
    { map = "1,-18", path = "right" },
    { map = "0,-18", path = "right" },
    { map = "0,-19", path = "right" },
    { map = "1,-19", path = "right" },
    { map = "2,-19", path = "right" },
    { map = "2,-20", path = "right" },
    { map = "0,-20", path = "right" },
    { map = "1,-20", path = "right" },
    { map = "1,-21", path = "right" },
    { map = "0,-21", path = "right" },
    { map = "0,-22", path = "right" },
    { map = "1,-22", path = "right" },
    { map = "2,-22", path = "right" },
    { map = "2,-21", path = "right" },
    { map = "3,-22", path = "right" },
    { map = "3,-21", path = "right" },
    { map = "3,-20", path = "right" },
    { map = "3,-19", path = "right" },
    { map = "3,-18", path = "right" },
    { map = "3,-17", path = "right" },
    { map = "3,-16", path = "right" },
    { map = "3,-15", path = "right" },
    { map = "3,-14", path = "right" },
    { map = "4,-15", path = "right" },
    { map = "4,-16", path = "right" },
    { map = "4,-17", path = "right" },
    { map = "4,-18", path = "right" },
    { map = "4,-19", path = "right" },
    { map = "4,-20", path = "right" },
    { map = "4,-21", path = "right" },
    { map = "4,-22", path = "right" },
    { map = "5,-20", path = "right" },
    { map = "5,-19", path = "right" },
    { map = "5,-18", path = "right" },
    { map = "5,-17", path = "right" },
    { map = "5,-16", path = "right" },
    { map = "5,-15", path = "right" },
    { map = "4,-14", path = "top" },
    { map = "6,-15", path = "top" },
    { map = "6,-16", path = "top" },
    { map = "6,-17", path = "top" },
    { map = "7,-15", path = "left" },
    { map = "7,-16", path = "left" },
    { map = "7,-17", path = "left" },
    { map = "7,-18", path = "left" },
    { map = "7,-19", path = "left" },
    { map = "7,-20", path = "left" },
    { map = "7,-21", path = "left" },
    { map = "5,-22", path = "bottom" },
    { map = "5,-21", path = "right" },
    { map = "6,-21", path = "bottom" },
    { map = "6,-20", path = "bottom" },
    { map = "6,-19", path = "bottom" },
    {map = "84675588", door = "355"},
    { map = "83365888", custom = function ()
        npc:npc(482, 3)
        npc:reply(-2)
        npc:reply(-3)
        npc:reply(-1)
        map:moveToCell(352)
    end}
}

function Achat2(IdItem, qtt)
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
    elseif ((Prices.Price10 == 0) and (Prices.Price1 == 0)) then
        qtt = 100
    elseif Prices.Price1 == 0 and qtt < 10 then
        qtt = 10
    elseif qtt > 10 and qtt < 100 and qtt % 10 * Prices.Price1 > Prices.Price10 then
        qtt = qtt + (10 - qtt % 10)
    elseif qtt < 10 and Prices.Price1 * qtt > Prices.Price10 then
        qtt = 10
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

local CraftForgeron = {
    {Name = "Pelle de Boisaile", Id = 151, ListIdCraft = {{Id = 312, Nb = 3}, {Id = 303, Nb = 1}}, NbToUp = 2000, LvlMaxMetier = 40, delete = true},
    {Name = "Ares", Id = 250, ListIdCraft = {{Id = 313, Nb = 30}, {Id = 446, Nb = 30}, {Id = 2627, Nb = 22}, {Id = 15573, Nb = 1}, {Id = 465, Nb = 5}}, NbToUp = 4, LvlMaxMetier = 200, delete = false},
}

local function ProcessCraft(table, cellId, delete)
    for _, element in ipairs(table) do

        if inventory:itemCount(element.Id) < element.NbToUp and element.LvlMaxMetier > job:level(20) then
            local podsAvailable = (inventory:podsMax() - inventory:pods()) * 0.8

            local PodsNeededToCraft = 0
            for _, element2 in ipairs(element.ListIdCraft) do
                PodsNeededToCraft = PodsNeededToCraft + inventory:itemWeight(element2.Id) * element2.Nb
            end

            local CraftQuantity = math.floor(math.min(podsAvailable / PodsNeededToCraft, element.NbToUp))

            --element.NbToUp = element.NbToUp - CraftQuantity

            global:printSuccess("go Craft " .. CraftQuantity .. " x " ..  element.Name)

            for _, element2 in ipairs(element.ListIdCraft) do

                BuyQuantity = CraftQuantity * element2.Nb - inventory:itemCount(element2.Id)
                
                if BuyQuantity > 0 and element.Id ~= 250 then
                    global:printSuccess("On achète " .. BuyQuantity .. " x " .. inventory:itemNameId(element2.Id))
                    Achat(element2.Id, BuyQuantity)
                    global:delay(500)
                elseif BuyQuantity > 0 then
                    global:printSuccess("On achète " .. BuyQuantity .. " x " .. inventory:itemNameId(element2.Id))
                    Achat2(element2.Id, BuyQuantity)
                    global:delay(500)
                end
            end

            global:delay(500)
            map:useById(476381, -1)
            global:delay(500)

            for _, item in ipairs(element.ListIdCraft) do
                craft:putItem(item.Id, item.Nb)
                global:delay(200)
            end
            craft:changeQuantityToCraft(CraftQuantity)
            global:delay(200)
            CraftReady()
            global:printSuccess("Craft effectué !")
            global:leaveDialog()

            global:delay(500)
            if element.delete then
                global:printSuccess("Suppression de l'item")
                while inventory:itemCount(element.Id) > 0 do
                    inventory:deleteItem(element.Id, inventory:itemCount(element.Id))
                end
            else
                inventory:equipItem(element.Id, 1)
            end

            global:delay(500)
            return ProcessCraft(table, cellId, delete)
        end
    end


    map:moveToCell(cellId)
end

local TrajetUpForgeron = {
    { map = "5,7", path = "zaap(84674563)" },
    { map = "10,22", path = "zaap(84674563)"},
    { map = "-16,1", path = "zaap(84674563)"},
    { map = "-1,-22", path = "right" },
    { map = "-1,-21", path = "right" },
    { map = "-1,-20", path = "right" },
    { map = "-1,-19", path = "right" },
    { map = "-1,-18", path = "right" },
    { map = "-1,-17", path = "right" },
    { map = "-1,-16", path = "right" },
    { map = "-1,-15", path = "right" },
    { map = "-1,-14", path = "right" },
    { map = "0,-14", path = "right" },
    { map = "1,-14", path = "right" },
    { map = "1,-15", path = "right" },
    { map = "0,-15", path = "right" },
    { map = "0,-16", path = "right" },
    { map = "0,-17", path = "right" },
    { map = "1,-17", path = "right" },
    { map = "1,-16", path = "right" },
    { map = "2,-16", path = "right" },
    { map = "2,-15", path = "right" },
    { map = "2,-14", path = "right" },
    { map = "2,-17", path = "right" },
    { map = "2,-18", path = "right" },
    { map = "1,-18", path = "right" },
    { map = "0,-18", path = "right" },
    { map = "0,-19", path = "right" },
    { map = "1,-19", path = "right" },
    { map = "2,-19", path = "right" },
    { map = "2,-20", path = "right" },
    { map = "0,-20", path = "right" },
    { map = "1,-20", path = "right" },
    { map = "1,-21", path = "right" },
    { map = "0,-21", path = "right" },
    { map = "0,-22", path = "right" },
    { map = "1,-22", path = "right" },
    { map = "2,-22", path = "right" },
    { map = "2,-21", path = "right" },
    { map = "3,-22", path = "right" },
    { map = "3,-21", path = "right" },
    { map = "3,-20", path = "right" },
    { map = "3,-19", path = "right" },
    { map = "3,-18", path = "right" },
    { map = "3,-17", path = "right" },
    { map = "3,-16", path = "right" },
    { map = "3,-15", path = "right" },
    { map = "3,-14", path = "right" },
    { map = "4,-15", path = "right" },
    { map = "4,-16", path = "right" },
    { map = "4,-17", path = "right" },
    { map = "4,-18", path = "right" },
    { map = "4,-19", path = "right" },
    { map = "4,-20", path = "right" },
    { map = "4,-21", path = "right" },
    { map = "4,-22", path = "right" },
    { map = "5,-20", path = "right" },
    { map = "5,-19", path = "right" },
    { map = "5,-18", path = "right" },
    { map = "5,-17", path = "right" },
    { map = "5,-16", path = "right" },
    { map = "5,-15", path = "right" },
    { map = "4,-14", path = "top" },
    { map = "6,-15", path = "top" },
    { map = "6,-16", path = "top" },
    { map = "6,-17", path = "top" },
    { map = "6,-18", path = "top" },
    { map = "6,-19", path = "top" },
    { map = "6,-20", path = "top" },
    { map = "7,-15", path = "left" },
    { map = "7,-16", path = "left" },
    { map = "7,-17", path = "left" },
    { map = "7,-18", path = "left" },
    { map = "7,-19", path = "left" },
    { map = "7,-20", path = "left" },
    { map = "7,-21", path = "left" },
    { map = "5,-22", path = "bottom" },
    { map = "5,-21", path = "right" },
    { map = "84675585", door = "286"},
    { map = "83624962", custom = function()
        ProcessCraft(CraftForgeron, 355, true)
    end}
}

local TrajetCraftPelle = {
    { map = "5,7", path = "zaap(84674563)" },
    { map = "10,22", path = "zaap(84674563)"},
    { map = "-16,1", path = "zaap(84674563)"},
    { map = "-1,-22", path = "right" },
    { map = "-1,-21", path = "right" },
    { map = "-1,-20", path = "right" },
    { map = "-1,-19", path = "right" },
    { map = "-1,-18", path = "right" },
    { map = "-1,-17", path = "right" },
    { map = "-1,-16", path = "right" },
    { map = "-1,-15", path = "right" },
    { map = "-1,-14", path = "right" },
    { map = "0,-14", path = "right" },
    { map = "1,-14", path = "right" },
    { map = "1,-15", path = "right" },
    { map = "0,-15", path = "right" },
    { map = "0,-16", path = "right" },
    { map = "0,-17", path = "right" },
    { map = "1,-17", path = "right" },
    { map = "1,-16", path = "right" },
    { map = "2,-16", path = "right" },
    { map = "2,-15", path = "right" },
    { map = "2,-14", path = "right" },
    { map = "2,-17", path = "right" },
    { map = "2,-18", path = "right" },
    { map = "1,-18", path = "right" },
    { map = "0,-18", path = "right" },
    { map = "0,-19", path = "right" },
    { map = "1,-19", path = "right" },
    { map = "2,-19", path = "right" },
    { map = "2,-20", path = "right" },
    { map = "0,-20", path = "right" },
    { map = "1,-20", path = "right" },
    { map = "1,-21", path = "right" },
    { map = "0,-21", path = "right" },
    { map = "0,-22", path = "right" },
    { map = "1,-22", path = "right" },
    { map = "2,-22", path = "right" },
    { map = "2,-21", path = "right" },
    { map = "3,-22", path = "right" },
    { map = "3,-21", path = "right" },
    { map = "3,-20", path = "right" },
    { map = "3,-19", path = "right" },
    { map = "3,-18", path = "right" },
    { map = "3,-17", path = "right" },
    { map = "3,-16", path = "right" },
    { map = "3,-15", path = "right" },
    { map = "3,-14", path = "right" },
    { map = "4,-15", path = "right" },
    { map = "4,-16", path = "right" },
    { map = "4,-17", path = "right" },
    { map = "4,-18", path = "right" },
    { map = "4,-19", path = "right" },
    { map = "4,-20", path = "right" },
    { map = "4,-21", path = "right" },
    { map = "4,-22", path = "right" },
    { map = "5,-20", path = "right" },
    { map = "5,-19", path = "right" },
    { map = "5,-18", path = "right" },
    { map = "5,-17", path = "right" },
    { map = "5,-16", path = "right" },
    { map = "5,-15", path = "right" },
    { map = "4,-14", path = "top" },
    { map = "6,-15", path = "top" },
    { map = "6,-16", path = "top" },
    { map = "6,-17", path = "top" },
    { map = "6,-18", path = "top" },
    { map = "6,-19", path = "top" },
    { map = "6,-20", path = "top" },
    { map = "7,-15", path = "left" },
    { map = "7,-16", path = "left" },
    { map = "7,-17", path = "left" },
    { map = "7,-18", path = "left" },
    { map = "7,-19", path = "left" },
    { map = "7,-20", path = "left" },
    { map = "7,-21", path = "left" },
    { map = "5,-22", path = "bottom" },
    { map = "5,-21", path = "right" },
    { map = "84675585", door = "286"},
    { map = "83624962", custom = function()
        ProcessCraft(CraftForgeron, 355, false)
    end}
}

local function TreatMapsAstrub(maps)

    for _, element in ipairs(maps) do
        if map:onMap(element.map) then
            return maps
        end
    end
    PopoRappel()
end

function move()
    if job:level(20) == -1 then
        return TreatMapsAstrub(TrajetForgeronAstrub)
    end
    if job:level(20) < 40 then
        return TreatMapsAstrub(TrajetUpForgeron)
    end
    if job:level(20) >= 40 and inventory:itemCount(250) == 0 then
        return TreatMapsAstrub(TrajetCraftPelle)
    end
    --global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PL&Zaaps\\PL_Chasseur_Team.lua")
end

function bank()
    return move()
end