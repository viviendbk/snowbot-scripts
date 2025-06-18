dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\All_Fonctions.lua")

local TrajetSculpteurAstrub = {
    { map = "5,7", path = "zaap(84674563)" },
    { map = "10,22", path = "zaap(84674563)"},
    { map = "-16,1", path = "zaap(84674563)"},
    { map = "-1,-15", path = "right" },
    { map = "-1,-14", path = "right" },
    { map = "-1,-16", path = "right" },
    { map = "-1,-17", path = "right" },
    { map = "-1,-18", path = "right" },
    { map = "-1,-19", path = "right" },
    { map = "-1,-20", path = "right" },
    { map = "-1,-21", path = "right" },
    { map = "0,-22", path = "right" },
    { map = "0,-21", path = "right" },
    { map = "0,-20", path = "right" },
    { map = "0,-19", path = "right" },
    { map = "0,-18", path = "right" },
    { map = "0,-17", path = "right" },
    { map = "0,-16", path = "right" },
    { map = "0,-15", path = "right" },
    { map = "0,-14", path = "right" },
    { map = "1,-14", path = "right" },
    { map = "1,-15", path = "right" },
    { map = "1,-16", path = "right" },
    { map = "1,-17", path = "right" },
    { map = "1,-18", path = "right" },
    { map = "1,-19", path = "right" },
    { map = "1,-21", path = "right" },
    { map = "1,-22", path = "right" },
    { map = "1,-20", path = "right" },
    { map = "2,-22", path = "right" },
    { map = "2,-21", path = "right" },
    { map = "2,-20", path = "right" },
    { map = "2,-19", path = "right" },
    { map = "2,-17", path = "right" },
    { map = "2,-18", path = "right" },
    { map = "2,-16", path = "right" },
    { map = "2,-14", path = "right" },
    { map = "2,-15", path = "right" },
    { map = "7,-15", path = "left" },
    { map = "7,-16", path = "left" },
    { map = "7,-17", path = "left" },
    { map = "7,-18", path = "left" },
    { map = "7,-19", path = "left" },
    { map = "7,-20", path = "left" },
    { map = "7,-21", path = "left" },
    { map = "6,-15", path = "top" },
    { map = "6,-17", path = "top" },
    { map = "6,-16", path = "top" },
    { map = "5,-15", path = "top" },
    { map = "5,-16", path = "top" },
    { map = "5,-17", path = "top" },
    { map = "5,-18", path = "top" },
    { map = "5,-19", path = "top" },
    { map = "4,-15", path = "top" },
    { map = "4,-16", path = "top" },
    { map = "4,-17", path = "top" },
    { map = "4,-18", path = "top" },
    { map = "4,-19", path = "top" },
    { map = "4,-14", path = "top" },
    { map = "3,-14", path = "top" },
    { map = "3,-15", path = "top" },
    { map = "3,-16", path = "top" },
    { map = "3,-17", path = "top" },
    { map = "3,-18", path = "top" },
    { map = "3,-19", path = "top" },
    { map = "3,-22", path = "bottom" },
    { map = "3,-21", path = "bottom" },
    { map = "4,-22", path = "bottom" },
    { map = "4,-21", path = "bottom" },
    { map = "5,-22", path = "bottom" },
    { map = "5,-21", path = "bottom" },
    { map = "6,-21", path = "bottom" },
    { map = "6,-20", path = "left" },
    { map = "5,-20", path = "left" },
    { map = "4,-20", path = "left" },
    { map = "3,-20", custom = function ()
        npc:npc(503, 3)
        npc:reply(-2)
        npc:reply(-1)
        npc:reply(-1)
        map:changeMap("left")
    end}
}


local CraftSculpteur = {
    {Name = "Bâton de Boisaille", Id = 138, ListIdCraft = {{Id = 289, Nb = 3}, {Id = 303, Nb = 3}}, NbToUp = 128, LvlMaxMetier = 10, delete = true},
    {Name = "Bâton Cornu", Id = 742, ListIdCraft = {{Id = 441, Nb = 10}, {Id = 460, Nb = 10}, {Id = 13728, Nb = 5}}, NbToUp = 1, LvlMaxMetier = 200, delete = false},
}

local function ProcessCraft(table, cellId, delete)
    for _, element in ipairs(table) do

        if inventory:itemCount(element.Id) < element.NbToUp and element.LvlMaxMetier > job:level(18) then
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
                
                if BuyQuantity > 0 then
                    global:printSuccess("On achète " .. BuyQuantity .. " x " .. inventory:itemNameId(element2.Id))
                    Achat(element2.Id, BuyQuantity)
                    global:delay(500)
                end
            end

            global:delay(500)
            map:useById(476350, -1)
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

local TrajetUpSculpteur = {
    { map = "5,7", path = "zaap(84674563)" },
    { map = "10,22", path = "zaap(84674563)"},
    { map = "-16,1", path = "zaap(84674563)"},
    { map = "-1,-15", path = "right" },
    { map = "-1,-14", path = "right" },
    { map = "-1,-16", path = "right" },
    { map = "-1,-17", path = "right" },
    { map = "-1,-18", path = "right" },
    { map = "-1,-19", path = "right" },
    { map = "-1,-20", path = "right" },
    { map = "-1,-21", path = "right" },
    { map = "0,-22", path = "right" },
    { map = "0,-21", path = "right" },
    { map = "0,-20", path = "right" },
    { map = "0,-19", path = "right" },
    { map = "0,-18", path = "right" },
    { map = "0,-17", path = "right" },
    { map = "0,-16", path = "right" },
    { map = "0,-15", path = "right" },
    { map = "0,-14", path = "right" },
    { map = "1,-14", path = "right" },
    { map = "1,-15", path = "right" },
    { map = "1,-16", path = "right" },
    { map = "1,-17", path = "right" },
    { map = "1,-18", path = "right" },
    { map = "1,-19", path = "right" },
    { map = "1,-21", path = "right" },
    { map = "1,-22", path = "right" },
    { map = "1,-20", path = "right" },
    { map = "2,-22", path = "right" },
    { map = "2,-19", path = "right" },
    { map = "2,-17", path = "right" },
    { map = "2,-18", path = "right" },
    { map = "2,-16", path = "right" },
    { map = "2,-14", path = "right" },
    { map = "2,-15", path = "right" },
    { map = "7,-15", path = "left" },
    { map = "7,-16", path = "left" },
    { map = "7,-17", path = "left" },
    { map = "7,-18", path = "left" },
    { map = "7,-19", path = "left" },
    { map = "7,-20", path = "left" },
    { map = "7,-21", path = "left" },
    { map = "6,-15", path = "top" },
    { map = "6,-17", path = "top" },
    { map = "6,-16", path = "top" },
    { map = "5,-15", path = "top" },
    { map = "5,-16", path = "top" },
    { map = "5,-17", path = "top" },
    { map = "5,-18", path = "top" },
    { map = "5,-19", path = "top" },
    { map = "4,-15", path = "top" },
    { map = "4,-16", path = "top" },
    { map = "4,-17", path = "top" },
    { map = "4,-18", path = "top" },
    { map = "4,-19", path = "top" },
    { map = "4,-14", path = "top" },
    { map = "3,-14", path = "top" },
    { map = "3,-15", path = "top" },
    { map = "3,-16", path = "top" },
    { map = "3,-17", path = "top" },
    { map = "3,-18", path = "top" },
    { map = "3,-19", path = "top" },
    { map = "3,-22", path = "bottom" },
    { map = "3,-21", path = "bottom" },
    { map = "4,-22", path = "bottom" },
    { map = "4,-21", path = "bottom" },
    { map = "5,-22", path = "bottom" },
    { map = "5,-21", path = "bottom" },
    { map = "6,-21", path = "bottom" },
    { map = "6,-20", path = "left" },
    { map = "5,-20", path = "left" },
    { map = "4,-20", path = "left" },
    { map = "3,-20", path = "left" },
    { map = "2,-20", path = "top" },
    { map = "84673537", door = "369"},
    { map = "83623936", custom = function()
        ProcessCraft(CraftSculpteur, 341, true)
    end}
}

local TrajetCraftPelle = {
    { map = "5,7", path = "zaap(84674563)" },
    { map = "10,22", path = "zaap(84674563)"},
    { map = "-16,1", path = "zaap(84674563)"},
    { map = "-1,-15", path = "right" },
    { map = "-1,-14", path = "right" },
    { map = "-1,-16", path = "right" },
    { map = "-1,-17", path = "right" },
    { map = "-1,-18", path = "right" },
    { map = "-1,-19", path = "right" },
    { map = "-1,-20", path = "right" },
    { map = "-1,-21", path = "right" },
    { map = "0,-22", path = "right" },
    { map = "0,-21", path = "right" },
    { map = "0,-20", path = "right" },
    { map = "0,-19", path = "right" },
    { map = "0,-18", path = "right" },
    { map = "0,-17", path = "right" },
    { map = "0,-16", path = "right" },
    { map = "0,-15", path = "right" },
    { map = "0,-14", path = "right" },
    { map = "1,-14", path = "right" },
    { map = "1,-15", path = "right" },
    { map = "1,-16", path = "right" },
    { map = "1,-17", path = "right" },
    { map = "1,-18", path = "right" },
    { map = "1,-19", path = "right" },
    { map = "1,-21", path = "right" },
    { map = "1,-22", path = "right" },
    { map = "1,-20", path = "right" },
    { map = "2,-22", path = "right" },
    { map = "2,-19", path = "right" },
    { map = "2,-17", path = "right" },
    { map = "2,-18", path = "right" },
    { map = "2,-16", path = "right" },
    { map = "2,-14", path = "right" },
    { map = "2,-15", path = "right" },
    { map = "7,-15", path = "left" },
    { map = "7,-16", path = "left" },
    { map = "7,-17", path = "left" },
    { map = "7,-18", path = "left" },
    { map = "7,-19", path = "left" },
    { map = "7,-20", path = "left" },
    { map = "7,-21", path = "left" },
    { map = "6,-15", path = "top" },
    { map = "6,-17", path = "top" },
    { map = "6,-16", path = "top" },
    { map = "5,-15", path = "top" },
    { map = "5,-16", path = "top" },
    { map = "5,-17", path = "top" },
    { map = "5,-18", path = "top" },
    { map = "5,-19", path = "top" },
    { map = "4,-15", path = "top" },
    { map = "4,-16", path = "top" },
    { map = "4,-17", path = "top" },
    { map = "4,-18", path = "top" },
    { map = "4,-19", path = "top" },
    { map = "4,-14", path = "top" },
    { map = "3,-14", path = "top" },
    { map = "3,-15", path = "top" },
    { map = "3,-16", path = "top" },
    { map = "3,-17", path = "top" },
    { map = "3,-18", path = "top" },
    { map = "3,-19", path = "top" },
    { map = "3,-22", path = "bottom" },
    { map = "3,-21", path = "bottom" },
    { map = "4,-22", path = "bottom" },
    { map = "4,-21", path = "bottom" },
    { map = "5,-22", path = "bottom" },
    { map = "5,-21", path = "bottom" },
    { map = "6,-21", path = "bottom" },
    { map = "6,-20", path = "left" },
    { map = "5,-20", path = "left" },
    { map = "4,-20", path = "left" },
    { map = "3,-20", path = "left" },
    { map = "2,-20", path = "top" },
    { map = "84673537", door = "369"},
    { map = "83623936", custom = function()
        ProcessCraft(CraftSculpteur, 341, false)
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
    if job:level(18) == -1 then
        return TreatMapsAstrub(TrajetSculpteurAstrub)
    end
    if job:level(18) < 10 then
        return TreatMapsAstrub(TrajetUpSculpteur)
    end
    if job:level(18) >= 10 and inventory:itemCount(742) == 0 then
        return TreatMapsAstrub(TrajetCraftPelle)
    end
    global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PLAndZaaps\\PL_Chasseur_Team.lua")
end

function bank()
    return move()
end