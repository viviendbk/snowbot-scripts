dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\All_Fonctions.lua")

local goToAtelierCordo = {
    { map = "7,-15", path = "left" },
    { map = "7,-16", path = "left" },
    { map = "7,-17", path = "left" },
    { map = "7,-18", path = "left" },
    { map = "7,-19", path = "left" },
    { map = "7,-20", path = "left" },
    { map = "7,-21", path = "left" },
    { map = "6,-20", path = "left" },
    { map = "6,-21", path = "left" },
    { map = "5,-19", path = "left" },
    { map = "6,-19", path = "left" },
    { map = "6,-18", path = "left" },
    { map = "6,-17", path = "left" },
    { map = "6,-16", path = "left" },
    { map = "6,-15", path = "left" },
    { map = "5,-15", path = "left" },
    { map = "5,-16", path = "left" },
    { map = "5,-17", path = "left" },
    { map = "5,-18", path = "left" },
    { map = "5,-20", path = "left" },
    { map = "5,-22", path = "left" },
    { map = "5,-21", path = "left" },
    { map = "4,-22", path = "left" },
    { map = "4,-21", path = "left" },
    { map = "4,-20", path = "left" },
    { map = "4,-19", path = "left" },
    { map = "4,-18", path = "left" },
    { map = "4,-17", path = "left" },
    { map = "84674566", path = "left" },
    { map = "83887104", path = "396"},
    { map = "4,-15", path = "left" },
    { map = "3,-14", path = "left" },
    { map = "3,-15", path = "left" },
    { map = "3,-16", path = "left" },
    { map = "3,-17", path = "left" },
    { map = "3,-18", path = "left" },
    { map = "3,-19", path = "left" },
    { map = "3,-20", path = "left" },
    { map = "3,-21", path = "left" },
    { map = "3,-22", path = "left" },
    { map = "2,-22", path = "left" },
    { map = "2,-21", path = "left" },
    { map = "2,-20", path = "left" },
    { map = "2,-19", path = "left" },
    { map = "2,-18", path = "left" },
    { map = "2,-17", path = "left" },
    { map = "2,-14", path = "top" },
    { map = "1,-14", path = "top" },
    { map = "0,-14", path = "top" },
    { map = "-1,-15", path = "top" },
    { map = "1,-15", path = "top" },
    { map = "0,-15", path = "top" },
    { map = "2,-15", path = "top" },
    { map = "-1,-14", path = "top" },
    { map = "-1,-16", path = "top" },
    { map = "0,-16", path = "top" },
    { map = "1,-16", path = "top" },
    { map = "2,-16", path = "top" },
    { map = "-1,-17", path = "top" },
    { map = "-1,-18", path = "top" },
    { map = "0,-17", path = "top" },
    { map = "0,-18", path = "top" },
    { map = "0,-19", path = "top" },
    { map = "0,-20", path = "top" },
    { map = "-1,-20", path = "top" },
    { map = "-1,-19", path = "top" },
    { map = "1,-18", path = "top" },
    { map = "1,-19", path = "top" },
    { map = "1,-20", path = "top" },
    { map = "1,-21", path = "left" },
    { map = "1,-22", path = "left" },
    { map = "-1,-21", path = "right" },
    { map = "0,-22", path = "bottom" },
    { map = "1,-17", path = "left" },
    { map = "84672513", door = "315" },
    { map = "83627008", custom = function ()
        npc:npc(597, 3)
        npc:reply(-2)
        npc:reply(-1)
        global:leaveDialog()
        map:moveToCell(325)
    end}
}

local goToAtelierBijoutier = {
    { map = "-1,-22", path = "right" },
    { map = "-1,-20", path = "right" },
    { map = "-1,-21", path = "right" },
    { map = "-1,-19", path = "right" },
    { map = "-1,-18", path = "right" },
    { map = "-1,-17", path = "right" },
    { map = "-1,-15", path = "right" },
    { map = "-1,-14", path = "right" },
    { map = "0,-14", path = "right" },
    { map = "0,-19", path = "right" },
    { map = "0,-21", path = "right" },
    { map = "0,-22", path = "right" },
    { map = "0,-20", path = "right" },
    { map = "0,-17", path = "right" },
    { map = "0,-18", path = "right" },
    { map = "-1,-16", path = "right" },
    { map = "0,-16", path = "right" },
    { map = "0,-15", path = "right" },
    { map = "1,-15", path = "right" },
    { map = "2,-15", path = "right" },
    { map = "2,-14", path = "right" },
    { map = "1,-14", path = "right" },
    { map = "1,-16", path = "right" },
    { map = "2,-16", path = "right" },
    { map = "3,-16", path = "right" },
    { map = "2,-17", path = "right" },
    { map = "1,-18", path = "right" },
    { map = "1,-20", path = "right" },
    { map = "1,-21", path = "right" },
    { map = "1,-22", path = "right" },
    { map = "2,-22", path = "right" },
    { map = "2,-20", path = "right" },
    { map = "2,-21", path = "right" },
    { map = "2,-18", path = "right" },
    { map = "2,-19", path = "right" },
    { map = "1,-19", path = "right" },
    { map = "1,-17", path = "right" },
    { map = "3,-17", path = "right" },
    { map = "3,-18", path = "right" },
    { map = "3,-19", path = "right" },
    { map = "3,-20", path = "right" },
    { map = "3,-21", path = "right" },
    { map = "3,-22", path = "right" },
    { map = "3,-15", path = "right" },
    { map = "3,-14", path = "right" },
    { map = "4,-22", path = "bottom" },
    { map = "5,-22", path = "bottom" },
    { map = "5,-21", path = "bottom" },
    { map = "6,-21", path = "bottom" },
    { map = "7,-21", path = "bottom" },
    { map = "4,-21", path = "bottom" },
    { map = "4,-20", path = "bottom" },
    { map = "5,-20", path = "bottom" },
    { map = "6,-20", path = "bottom" },
    { map = "7,-20", path = "bottom" },
    { map = "7,-19", path = "bottom" },
    { map = "6,-19", path = "bottom" },
    { map = "5,-19", path = "bottom" },
    { map = "4,-19", path = "bottom" },
    { map = "4,-18", path = "bottom" },
    { map = "5,-18", path = "bottom" },
    { map = "6,-18", path = "bottom" },
    { map = "7,-18", path = "bottom" },
    { map = "5,-17", path = "bottom" },
    { map = "6,-17", path = "bottom" },
    { map = "7,-17", path = "bottom" },
    { map = "4,-17", path = "bottom" },
    { map = "4,-15", path = "right" },
    { map = "4,-16", path = "right" },
    { map = "5,-15", path = "top" },
    { map = "6,-15", path = "top" },
    { map = "7,-15", path = "top" },
    { map = "7,-16", path = "left" },
    { map = "6,-16", path = "left" },
    { map = "84675078", door = "371" },
    { map = "83625986", custom = function ()
        npc:npc(462, 3)
        npc:reply(-3)
        npc:reply(-1)
        npc:reply(-1)
        npc:reply(-1)
        global:leaveDialog()
        map:moveToCell(397)
    end },
}

local CraftCordonier = {
    {Name = "Bottes du Boufton", Id = 890, Type = "Bottes", ListIdCraft = {{Id = 303, Nb = 1}, {Id = 421, Nb = 1}}, PodsNeededToCraft = 6, NbToUp = 8000, LvlMaxMetier = 60}, --540 crafts pour up lvl20
}

local CraftBijoutier = {
    {Name = "Petite Amulette de l'Ours", Id = 74 , Type = "Amulette", ListIdCraft = {{Id = 473, Nb = 1}, {Id = 421, Nb = 1}}, PodsNeededToCraft = 6, NbToUp = 8000, LvlMaxMetier = 60}, 
}

local CraftTailleur = {
    {Name = "Bandeau Komintot", Id = 941, Type = "Chapeau", ListIdCraft = {{Id = 421, Nb = 2}, {Id = 289, Nb = 3}}, PodsNeededToCraft = 8, NbToUp = 8000, LvlMaxMetier = 60},
}

local Tablestuffs = {
    {Name = "Chapeau Akwadala", Id = 7226, Type = "Chapeau", ListIdCraft = {{Id = 9940, Nb = 4}, {Id = 17100, Nb = 1}, {Id = 17990, Nb = 4}, {Id = 17062, Nb = 15}}, PodsNeededToCraft = 24},
    {Name = "Cape Akwadala", Id = 7230, Type = "Cape", ListIdCraft = {{Id = 1778, Nb = 16}, {Id = 378, Nb = 12}, {Id = 380 , Nb = 30}, {Id = 6897, Nb = 10}}, PodsNeededToCraft = 68},
    {Name = "Ceinture Akwadala", Id = 7238, Type = "Ceinture", ListIdCraft = {{Id = 288, Nb = 10}, {Id = 1891, Nb = 12}, {Id = 2613, Nb = 12}, {Id = 417, Nb = 12}}, PodsNeededToCraft = 58},
    {Name = "Geta Akwadala", Id = 7242, Type = "Bottes", ListIdCraft = {{Id = 1778, Nb = 15}, {Id = 476, Nb = 30}, {Id = 13728, Nb = 14}, }, PodsNeededToCraft = 179},
    {Name = "Alliance Akwadala", Id = 7246, Type = "Anneau", ListIdCraft = {{Id = 1778, Nb = 16}, {Id = 6897, Nb = 12}, {Id = 747, Nb = 3}, {Id = 2358, Nb = 12}}, PodsNeededToCraft = 103},
    {Name = "Amulette Akwadala", Id = 7250, Type = "Amulette", ListIdCraft = {{Id = 7013, Nb = 22}, {Id = 367, Nb = 5}, {Id = 1455, Nb = 19}, {Id = 13502, Nb = 17}}, PodsNeededToCraft = 170},

    {Name = "Caracoiffe", Id = 2531, Type = "Chapeau", ListIdCraft = {{Id = 997, Nb = 6}, {Id = 17092, Nb = 15}, {Id = 2624, Nb = 25}, {Id = 15572, Nb = 1}}, PodsNeededToCraft = 65},
    {Name = "Caracape", Id = 2532, Type = "Cape", ListIdCraft = {{Id = 13489, Nb = 10}, {Id = 17104, Nb = 1}, {Id = 2618 , Nb = 20}, {Id = 7059, Nb = 30}}, PodsNeededToCraft = 61},
    {Name = "Ceinture Tortue Bleue", Id = 2683, Type = "Ceinture", ListIdCraft = {{Id = 1002, Nb = 18}, {Id = 997, Nb = 4}, {Id = 2624, Nb = 13}, {Id = 2613, Nb = 20}}, PodsNeededToCraft = 79},
    {Name = "Boufbamu", Id = 10836, Type = "Amulette", ListIdCraft = {{Id = 385, Nb = 6}, {Id = 887, Nb = 18}, {Id = 1777, Nb = 19}, {Id = 15573, Nb = 1}}, PodsNeededToCraft = 44},
    {Name = "Gelano", Id = 2469, Type = "Anneau", ListIdCraft = {{Id = 2437, Nb = 2}, {Id = 757, Nb = 20}, {Id = 9940, Nb = 6}, {Id = 15585, Nb = 1}, {Id = 2242, Nb = 2}}, PodsNeededToCraft = 31},
    {Name = "Abranneau Mou", Id = 1559, Type = "Anneau", ListIdCraft = {{Id = 401, Nb = 30}, {Id = 463, Nb = 6}, {Id = 435, Nb = 15}, {Id = 432, Nb = 12}}, PodsNeededToCraft = 111},
    {Name = "Bottes de l'Eleveur de Bouftous", Id = 6470, Type = "Bottes", ListIdCraft = {{Id = 460, Nb = 20}, {Id = 1777, Nb = 22}, {Id = 9940, Nb = 5}, {Id = 15573, Nb = 1}, {Id = 1771, Nb = 26} }, PodsNeededToCraft = 180},

    {Name = "Abracaska", Id = 2410, Type = "Chapeau", ListIdCraft = {{Id = 1694, Nb = 7}, {Id = 11253, Nb = 36}, {Id = 15259, Nb = 2}, {Id = 2267, Nb = 30}, {Id = 437, Nb = 30}, {Id = 15565, Nb = 1}}, PodsNeededToCraft = 201},
    {Name = "Abracapa Ancestrale", Id = 8464, Type = "Cape", ListIdCraft = {{Id = 13492, Nb = 12}, {Id = 15565, Nb = 1}, {Id = 15259 , Nb = 3}, {Id = 7016, Nb = 45}, {Id = 8249, Nb = 36}, {Id = 13698, Nb = 30}}, PodsNeededToCraft = 310},
    {Name = "Torque Ancestral", Id = 8465, Type = "Amulette", ListIdCraft = {{Id = 15743, Nb = 9}, {Id = 1612, Nb = 36}, {Id = 15565, Nb = 1}, {Id = 15259, Nb = 3}, {Id = 13528, Nb = 32}, {Id = 7655, Nb = 10}}, PodsNeededToCraft = 193},
    {Name = "Anneau Ancestral", Id = 8466, Type = "Anneau", ListIdCraft = {{Id = 1694, Nb = 12}, {Id = 15565, Nb = 1}, {Id = 15259, Nb = 2}, {Id = 8066, Nb = 36}, {Id = 13724, Nb = 32}, {Id = 2267, Nb = 25}}, PodsNeededToCraft = 31},
    {Name = "Protège-Tibias Ancestraux", Id = 8467, Type = "Bottes", ListIdCraft = {{Id = 8250, Nb = 34}, {Id = 13366, Nb = 2}, {Id = 1612, Nb = 32}, {Id = 470, Nb = 10}, {Id = 15565, Nb = 1}, {Id = 8765, Nb = 10} }, PodsNeededToCraft = 147},
    {Name = "Abrature Ancestrale", Id = 8468, Type = "Ceinture", ListIdCraft = {{Id = 15259, Nb = 2}, {Id = 8055, Nb = 30}, {Id = 17082, Nb = 8}, {Id = 1660, Nb = 35}}, {Id = 1612, Nb = 35}, {Id = 15565, Nb = 1}, PodsNeededToCraft = 148},


}

local TableOutilAtelier = {
    ["Cape"] = {ElementId = 455865, Rep = -1},
    ["Sac à dos"] = {ElementId = 455865, Rep = -2},
    ["Chapeau"] = {ElementId = 455866, Rep = -1},
    ["Amulette"] = {ElementId = 455835, Rep = -2},
    ["Anneau"] = {ElementId = 455835, Rep = -1},
    ["Bottes"] = {ElementId = 455863, Rep = -2},
    ["Ceinture"] = {ElementId = 455863, Rep = -1},
    ["Dague"] = {ElementId = 455861, Rep = -1},
    ["Marteau"] = {ElementId = 455861, Rep = -2},
    ["Epee"] = {ElementId = 455861, Rep = -3},
    ["Pelle"] = {ElementId = 455861, Rep = -4},
    ["Hache"] = {ElementId = 455861, Rep = -5},
    ["Baton"] = {ElementId = 455854, Rep = -1},
    ["Baguette"] = {ElementId = 455854, Rep = -2},
    ["Arc"] = {ElementId = 455854, Rep = -3},
    ["Potion"] = {ElementId = 455659, Rep = -1},
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
            map:useById(TableOutilAtelier[element.Type].ElementId, TableOutilAtelier[element.Type].Rep)
            global:delay(500)

            for _, item in ipairs(element.ListIdCraft) do
                craft:putItem(item.Id, item.Nb)
                global:delay(200)
            end
            craft:changeQuantityToCraft(CraftQuantity)
            global:delay(200)
            CraftReady()
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

local goToAtelierCordoBonta = {
    { map = "-33,-56", path = "zaapi(146234)" },
    { map = "-34,-61", path = "zaapi(146234)" },
    { map = "-29,-56", path = "zaapi(146234)" },
    { map = "-28,-55", path = "zaapi(146234)" },
    { map = "-28,-61", path = "zaapi(146234)" },
    { map = "-29,-53", path = "zaapi(146234)" },
    { map = "-32,-56", path = "zaapi(146234)" },
    { map = "146234", door = "352" },
}

local goToAtelierBijoutierBonta = {
    { map = "-33,-56", path = "zaapi(146234)" },
    { map = "-29,-56", path = "zaapi(148797)" },
    { map = "-29,-58", path = "zaapi(148797)" },
    { map = "-28,-55", path = "zaapi(148797)" },
    { map = "-28,-61", path = "zaapi(148797)" },
    { map = "-29,-53", path = "zaapi(148797)" },
    { map = "-32,-56", path = "zaapi(148797)" },
    { map = "148797", door = "510" },
}

local goToAtelierTailleurBonta = {
    { map = "-33,-56", path = "zaapi(146234)" },
    { map = "-34,-61", path = "zaapi(146232)" },
    { map = "-29,-58", path = "zaapi(146232)" },
    { map = "-28,-55", path = "zaapi(146232)" },
    { map = "-28,-61", path = "zaapi(146232)" },
    { map = "-29,-53", path = "zaapi(146232)" },
    { map = "-32,-56", path = "zaapi(146232)" },
    { map = "146232", door = "329" },
}


local function TreatMapsAstrub(maps)

    for _, element in ipairs(maps) do
        if map:onMap(element.map) then
            return maps
        end
    end
    if map:currentArea() ~= "Astrub" and not PopoUsed then
        PopoUsed = true
        PopoRappel()
    elseif map:currentArea() ~= "Astrub" and PopoUsed then
        PopoUsed = false
        return {
            { map = "5,7", path = "zaap(84674563)" },
            { map = "10,22", path = "zaap(84674563)"},
        }
    end 
    
end

local function TreatMapBonta(maps)

    for _, element in ipairs(maps) do
        if map:onMap(element.map) then
            return maps
        end
    end
    PopoBonta()
end

function move()

    if character:bonusPackExpiration() == 0 then
		character:getBonusPack(1)
        global:reconnect(0)
	end
    --- <Apprentissage des métiers>

    if job:level(15) == -1 then -- cordonier
        return TreatMapsAstrub(goToAtelierCordo)
    elseif job:level(16) == -1 then -- bijoutier
        return TreatMapsAstrub(goToAtelierBijoutier)
    elseif job:level(27) == -1 then -- tailleur
        Achat(966, 1)
        global:delay(500)
        inventory:useItem(966)
    end

    --- <Apprentissage des métiers>

    --- <Up des métiers>

    if job:level(15) < 60 then -- cordonier
        if not map:onMap(7864328) then
            return TreatMapBonta(goToAtelierCordoBonta)
        else
            ProcessCraft(CraftCordonier, 424, 15)
        end
    elseif job:level(16) < 60 then
        if not map:onMap(3145733) then
            return TreatMapBonta(goToAtelierBijoutierBonta)
        else
            ProcessCraft(CraftBijoutier, 396, 16)
        end
    elseif job:level(27) < 60 then
        if not map:onMap(7864327) then
            return TreatMapBonta(goToAtelierTailleurBonta)
        else
            ProcessCraft(CraftTailleur, 396, 27)
        end
    end
    --- <Up des métiers>

end

function bank()
    return move()
end
