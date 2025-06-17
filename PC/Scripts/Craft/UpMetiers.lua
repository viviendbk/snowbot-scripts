dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Lib\\IMPORT_LIBRARIES.lua")

local function ProcessCraft(table, cellId, jobId)
    for _, element in ipairs(table) do
        if inventory:itemCount(element.Id) < element.NbToCraft then
            local podsAvailable = (inventory:podsMax() - inventory:pods()) * 0.9

            local PodsNeededToCraft = 0
            for _, element2 in ipairs(element.ListIdCraft) do
                PodsNeededToCraft = PodsNeededToCraft + inventory:itemWeight(element2.Id) * element2.Nb
            end

            local CraftQuantity = math.floor(math.min(podsAvailable / PodsNeededToCraft, element.NbToCraft - inventory:itemCount(element.Id)))

            global:printSuccess("On va craft " .. CraftQuantity .. " x " ..  element.Name)

            for _, element2 in ipairs(element.ListIdCraft) do

                BuyQuantity = CraftQuantity * element2.Nb - inventory:itemCount(element2.Id)
                
                if BuyQuantity > 0 then
                    global:printSuccess("On achète " .. BuyQuantity .. " x " .. inventory:itemNameId(element2.Id))
                    Achat(element2.Id, BuyQuantity)
                    global:delay(500)
                end
            end

            global:delay(500)
            map:useById(TABLE_OUTIL_ATELIER[element.Type].ElementId, TABLE_OUTIL_ATELIER[element.Type].Rep)
            global:delay(500)

            for _, item in ipairs(element.ListIdCraft) do
                craft:putItem(item.Id, item.Nb)
                global:delay(200)
            end
            craft:changeQuantityToCraft(CraftQuantity)
            global:delay(200)
            craft:ready()
            global:printSuccess("Craft effectué !")
            global:leaveDialog()

            global:delay(500)
            return ProcessCraft(table, cellId, jobId)
        end
    end

    map:door(cellId)
end

local goToBankBonta = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "212600323", path = "top"},
    {map = "217058310", path = "zaapi(212600322)"}, -- extérieur atelier bijoutier
    {map = "212599814", path = "zaapi(212600322)"}, -- extérieur atelier taileur
    {map = "212601350", path = "zaapi(212600322)"}, -- hdv ressources
    {map = "212600837", path = "zaapi(212600322)"}, -- hdv equipements
    {map = "212600322", door = "468"},
    -- intérieur 217059328
}

local goToHdvEquip = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "217058310", path = "zaapi(212600837)"}, -- extérieur atelier bijoutier
    {map = "212599814", path = "zaapi(212600837)"}, -- extérieur atelier taileur
    {map = "212601347", path = "zaapi(212600837)"}, -- extérieur atelier cordonier
    {map = "212601350", path = "zaapi(212600837)"}, -- hdv ressources
    {map = "212601350", path = "zaapi(212600837)"},
    {map = "212600323", path = "bottom"},
    -- map : 212600837
}

local goToHdvRessources = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "212601350", path = "zaapi(212601350)"},
    {map = "212600837", path = "zaapi(212601350)"},
    {map = "217058310", path = "zaapi(212601350)"}, -- extérieur atelier bijoutier
    {map = "212599814", path = "zaapi(212601350)"}, -- extérieur atelier taileur
    {map = "212601347", path = "zaapi(212600837)"}, -- extérieur atelier cordonier
    {map = "212600837", path = "zaapi(212601350)"}, -- hdv equipements
    -- map : 212601350
}

local goToAtelierCordoBonta = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "212600323", path = "zaapi(212601347)"},
    {map = "217058310", path = "zaapi(212601347)"}, -- extérieur atelier bijoutier
    {map = "212599814", path = "zaapi(212601347)"}, -- extérieur atelier taileur
    {map = "212601350", path = "zaapi(212601347)"}, -- hdv ressources
    {map = "212600837", path = "zaapi(212601347)"}, -- hdv equipements

    {map = "212601347", door = "231"}, -- extérieur atelier cordonier
}

local goToAtelierBijoutierBonta = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "212600323", path = "zaapi(212599813)"},
    {map = "212599814", path = "zaapi(212599813)"}, -- extérieur atelier taileur
    {map = "212601347", path = "zaapi(212599813)"}, -- extérieur atelier cordonier
    {map = "212601350", path = "zaapi(212599813)"}, -- hdv ressources
    {map = "212600837", path = "zaapi(212599813)"}, -- hdv equipements

    {map = "212599813", door = "343"}, -- extérieur atelier bijoutier
}

local goToAtelierTailleurBonta = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "212600323", path = "zaapi(212599814)"},
    {map = "217058310", path = "zaapi(212599814)"}, -- extérieur atelier bijoutier
    {map = "212601347", path = "zaapi(212599814)"}, -- extérieur atelier cordonier
    {map = "212601350", path = "zaapi(212599814)"}, -- hdv ressources
    {map = "212600837", path = "zaapi(212599814)"}, -- hdv equipements

    {map = "212599814", door = "496"}, -- extérieur atelier tailleur
}

local CraftCordonier = {
    {Name = "Bottes du Boufton", Id = 890, Type = "Bottes", ListIdCraft = {{Id = 303, Nb = 1}, {Id = 421, Nb = 1}}, PodsNeededToCraft = 6, NbToUp = 2443, LvlMaxMetier = 40}, --540 crafts pour up lvl20
}

local CraftBijoutier = {
    {Name = "Petite Amulette de l'Ours", Id = 74 , Type = "Amulette", ListIdCraft = {{Id = 473, Nb = 1}, {Id = 421, Nb = 1}}, PodsNeededToCraft = 6, NbToUp = 2443, LvlMaxMetier = 40}, 
}

local CraftTailleur = {
    {Name = "Bandeau Komintot", Id = 941, Type = "Chapeau", ListIdCraft = {{Id = 421, Nb = 2}, {Id = 289, Nb = 3}}, PodsNeededToCraft = 8, NbToUp = 2443, LvlMaxMetier = 40},
}



local function ProcessCraft(table, cellId, jobId)
    for _, element in ipairs(table) do
        if job:level(jobId) < element.LvlMaxMetier then
            local podsAvailable = (inventory:podsMax() - inventory:pods()) * 0.9

            local CraftQuantity = math.floor(math.min(podsAvailable / element.PodsNeededToCraft, element.NbToUp))
            element.NbToUp = element.NbToUp - CraftQuantity

            global:printSuccess("go Craft " .. CraftQuantity .. " x " ..  element.Name)

            for _, element2 in ipairs(element.ListIdCraft) do

                BuyQuantity = CraftQuantity * element2.Nb - inventory:itemCount(element2.Id)
                
                if BuyQuantity > 0 then
                    global:printSuccess("On achète " .. BuyQuantity .. " item d'id " .. element2.Id)
                    Achat(element2.Id, BuyQuantity)
                    global:delay(500)
                end
            end

            global:delay(500)
            map:useById(TABLE_OUTIL_ATELIER[element.Type].ElementId, -1)
            global:delay(500)

            for _, item in ipairs(element.ListIdCraft) do
                craft:putItem(item.Id, item.Nb)
                global:delay(200)
            end
            craft:changeQuantityToCraft(CraftQuantity)
            global:delay(200)
            craft:ready()
            global:leaveDialog()
            while inventory:itemCount(element.Id) > 0 do
                inventory:deleteItem(element.Id, inventory:itemCount(element.Id))
            end
            global:delay(500)
            return ProcessCraft(table, cellId, jobId)
        end
    end

    map:moveToCell(cellId)
end



function move()
    mapDelay()
    -- vérifie qu'il est bien abonné        
    if getRemainingSubscription(true) <= 0 and character:kamas() > (character:server() == "Draconiros"  and 550000 or 1000000) then
        global:printSuccess("il reste " .. getRemainingSubscription(true) .. "jours d'abonnement, on tente de s'abonner à nouveau")
        Abonnement()
    elseif getRemainingSubscription(true) < 0 then
        Abonnement()
    end
    --- <Apprentissage des métiers>

    --- <Up des métiers>

    if job:level(15) < 40 then -- cordonier
        if not map:onMap(217055238) then
            return treatMaps(goToAtelierCordoBonta)
        else
            ProcessCraft(CraftCordonier, 360, 15)
        end
    elseif job:level(16) < 40 then
        if not map:onMap(217058310) then
            return treatMaps(goToAtelierBijoutierBonta)
        else
            ProcessCraft(CraftBijoutier, 485, 16)
        end
    elseif job:level(27) < 40 then
        if not map:onMap(217056260) then
            return treatMaps(goToAtelierTailleurBonta)
        else
            ProcessCraft(CraftTailleur, 520, 27)
        end
    end
    --- <Up des métiers>
end

function bank()
    mapDelay()
    return move()
end
