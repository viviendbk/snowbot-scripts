dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\IMPORT_LIBRARIES.lua")


--Informations :
----Créateur : Insa99
----Date de creation : 01/05/2020
----Version de Dofus : Dofus PC 2.55.6.9

--Condtions :
----Niveau recommandé : 0
----equipements : Aucun
----Kamas necessaire : 0
----Point de depart : Depuis la création d'un personnage

--Recomendation :
----Parametrer le UP des stat sur : UP vitalité
----Désactiver les canaux : Commerce et Recrutement pour profiter plainement des Informations données par le script

AUTO_DELETE = {519,16513}

if not global:remember("ETAPE") then
    global:addInMemory("ETAPE", 0)
end

local chemin1 = true

COMBAT12 = 1
COMBAT13 = 1
COMBAT14 = 1
COMBAT15 = 1
COMBAT17 = 1

DELAY = 2000

---Fonction qui permet de recuperer les nombres de lots d'un item en HDV.
local function get_quantity(id)
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
local function stack_items_informations(message)
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

function messagesRegistering()
    developer:registerMessage("ExchangeStartedBidSellerMessage", stack_items_informations)
end

function launch_hdv_activites()
    --map:door(hdv_door_id)
    message = developer:createMessage("NpcGenericActionRequestMessage")
    message.npcId = -1
    message.npcActionId = 5
    message.npcMapId = map:currentMapId()
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 2000, true)
end

local tableVente = {
    {Name = "viande intangible", Id = 16663, MaxHdv100 = 10, MaxHdv10 = 3, MaxHdv1 = 0},
    {Name = "Laine Celeste", Id = 16511, MaxHdv100 = 0, MaxHdv10 = 3, MaxHdv1 = 0},
    {Name = "Peau de Gloot", Id = 16522, MaxHdv100 = 0, MaxHdv10 = 3, MaxHdv1 = 0},
    {Name = "Cendres Eternelles", Id = 1984, MaxHdv100 = 0, MaxHdv10 = 3, MaxHdv1 = 0},
    {Name = "Reliques d'Incarnam", Id = 16524, MaxHdv100 = 0, MaxHdv10 = 3, MaxHdv1 = 0},
    {Name = "Queue de Chapardam", Id = 16515, MaxHdv100 = 0, MaxHdv10 = 3, MaxHdv1 = 0},
    {Name = "Plume Chimérique", Id = 16512, MaxHdv100 = 0, MaxHdv10 = 2, MaxHdv1 = 5},
}

local function SellViande()

    launch_hdv_activites()

    for i, element in ipairs(tableVente) do
		if inventory:itemCount(element.Id) == 0 then global:printSuccess("on a plus rien à vendre") break end

		cpt = get_quantity(element.Id).quantity["100"]

		local Priceitem1 = sale:getPriceItem(element.Id, 3)
		Priceitem1 = (Priceitem1 == nil or Priceitem1 == 0 or Priceitem1 == 1) and sale:getAveragePriceItem(element.Id, 3) * 1.5 or Priceitem1
    	while (inventory:itemCount(element.Id) >= 100) and (sale:AvailableSpace() > 0) and (cpt < element.MaxHdv100) do 
            sale:SellItem(element.Id, 100, Priceitem1 - 1) 
            global:printSuccess("1 lot de " .. 100 .. " x " .. element.Name .. " à " .. Priceitem1 - 1 .. "kamas")
            cpt = cpt + 1
        end

		cpt = get_quantity(element.Id).quantity["10"]

		local Priceitem2 = sale:getPriceItem(element.Id, 2)
		Priceitem2 = (Priceitem2 == nil or Priceitem2 == 0 or Priceitem2 == 1) and sale:getAveragePriceItem(element.Id, 2) * 1.5 or Priceitem2
        while (inventory:itemCount(element.Id) >= 30) and (sale:AvailableSpace() > 0) and (cpt < element.MaxHdv10) do 
            sale:SellItem(element.Id, 10, Priceitem2 - 1) 
            global:printSuccess("1 lot de " .. 10 .. " x " .. element.Name .. " à " .. Priceitem2 - 1 .. "kamas")
            cpt = cpt + 1
		end

        cpt = get_quantity(element.Id).quantity["1"]

		local Priceitem3 = sale:getPriceItem(element.Id, 1)
		Priceitem3 = (Priceitem3 == nil or Priceitem3 == 0 or Priceitem3 == 1) and sale:getAveragePriceItem(element.Id, 1) * 1.5 or Priceitem3
        while (inventory:itemCount(element.Id) >= 1) and (sale:AvailableSpace() > 0) and (cpt < element.MaxHdv1) do 
            sale:SellItem(element.Id, 1, Priceitem3 - 1) 
            global:printSuccess("1 lot de " .. 1 .. " x " .. element.Name .. " à " .. Priceitem3 - 1 .. "kamas")
            cpt = cpt + 1
		end
    end

    global:leaveDialog()
    global:restartScript(false)
end


function move()
    mapDelay()
    if #quest:activeQuests() >= 4 then
        global:deleteMemory("BUG")
        global:addInMemory("BUG", true)    
    end
    if map:onMap(152829952) then
        global:editInMemory("ETAPE", 51)
    end
    if global:remember("BUG") then
        if getCurrentAreaName() == "Astrub" then
            global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\PL&Zaaps\\PL_1-6X.lua") 
        end
        global:printSuccess("BUG")
        return{
            { map = "152829952", forcefight = true },--Salle 1
            { map = "152830976", forcefight = true },--Salle 2
            { map = "152832000", forcefight = true },--Salle 3
            { map = "152833024", forcefight = true },--Salle 4
            { map = "152834048", forcefight = true },--Salle 5
            { map = "152835072", custom = quete23_2 },
            { map = "5,-1", path = "left" },
            { map = "4,-1", path = "bottom" },
            { map = "4,0", path = "left" },
            { map = "3,0", path = "top" },
            { map = "3,-1", path = "top" },
            { map = "3,-2", path = "top" },
            { map = "3,-3", path = "top" },

            { map = "153878787", path = "right" },
            {map = "190843392", path = "top"},
            { map = "153092354", door = 409},
            { map = "153092354", door = 409},
          { map = "152045573", path = "right", gather = false, fight = false }, -- 152045573
          { map = "152043521", path = "right", gather = false, fight = false }, -- 152045573
          { map = "152046597", path = "right", gather = false, fight = false }, -- 152045573
          { map = "153358336", door = "459" },
          {map = "153358338", door = "376" },
          { map = "153879812", path = "bottom" },
          { map = "-2,-3", path = "right" }, -- 154010883
          { map = "-2,-2", path = "top" }, -- 154010882
          { map = "-1,-2", path = "top"}, -- 154010370
          { map = "0,-2", path = "top"}, -- 153878786
          { map = "1,-2", path = "top"}, -- 153879298
          { map = "1,-3", path = "right" }, -- 153879299
          { map = "-1,-3", path = "right"}, -- 154010371
          { map = "-1,-4", path = "bottom"}, -- 154010372
          { map = "0,-4", path = "bottom" }, -- 153878788
          { map = "0,-5", path = "bottom"}, -- 153878789
          { map = "-1,-5", path = "right" }, -- 154010373
          { map = "-2,-5", path = "right"}, -- 154010885
          { map = "-2,-4", path = "bottom"}, -- 154010884
          { map = "2,-3", path = "right"}, -- 153879811
          { map = "3,-3", path = "right"}, -- 153880323
          { map = "4,-3", custom = goToAstrub}, -- 153880323
          { map = "192416776", custom = function() 
            if global:thisAccountController():getAlias():find("Mineur") or global:thisAccountController():getAlias():find("Bucheron") then
                local message = developer:createMessage("TitleSelectedMessage")
                message.titleId = 197
                developer:sendMessage(message)
            end
            global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\PL&Zaaps\\PL_1-6X.lua") 
        end, path = "left"}, -- 192416776
        {map = "6,-19", custom = function ()
            global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\PL&Zaaps\\PL_1-6X.lua") 
        end}
        }
    end

    global:printSuccess(global:remember("ETAPE"))
    if inventory:itemCount(16663) > 100 and global:remember("ETAPE") < 51 then
        if not map:onMap(153879299) then
            map:moveToward(153879299)
        else
            SellViande()
        end
    end

    if global:remember("ETAPE") == 0 then
        if not map:onMap(153092354) then
            if getCurrentAreaName() ~= "Incarnam" and not map:onMap(192416776) then
                map:moveToward(192416776)
            elseif getCurrentAreaName() ~= "Incarnam" then
                map:door(455)
            end
            return {
                {map = "4,-3", path = "left"},
                {map = "3,-3", path = "left"},
                {map = "2,-3", path = "left"},
                {map = "0,-3", path = "left"},
                {map = "-1,-3", path = "left"},
                {map = "3,-2", path = "left"},
                {map = "2,-2", path = "left"},
                {map = "1,-2", path = "left"},
                {map = "3,-1", path = "left"},
                {map = "2,-1", path = "left"},
                {map = "2,0", path = "left"},
                {map = "3,0", path = "left"},
                {map = "1,-1", path = "left"},
                {map = "1,0", path = "left"},
                {map = "1,-4", path = "left"},
                {map = "2,-5", path = "left"},
                {map = "2,-4", path = "left"},
                {map = "3,-5", path = "left"},
                {map = "3,-4", path = "left"},
                {map = "4,-4", path = "left"},
                {map = "-2,0", path = "top"},
                {map = "-2,-1", path = "top"},
                {map = "-2,-2", path = "top"},
                {map = "-1,-1", path = "top"},
                {map = "-1,-2", path = "top"},
                {map = "1,-3", path = "left"},
                {map = "0,0", path = "left"},
                {map = "-1,0", path = "left"},
                {map = "0,1", path = "left"},
                {map = "0,-2", path = "top"},
                {map = "0,-4", path = "bottom"},

                {map = "0,-1", path = "top"},
                {map = "-1,1", path = "top"},
                {map = "1,-5", path = "bottom"},
                {map = "0,-5", path = "bottom"},
                {map = "-1,-5", path = "bottom"},
                {map = "-1,-6", path = "bottom"},
                {map = "-2,-6", path = "bottom"},
                {map = "-3,-6", path = "bottom"},
                {map = "-2,-5", path = "bottom"},
                {map = "-1,-4", path = "bottom"},
                {map = "-2,-4", path = "bottom"},
                {map = "-3,-5", path = "right"},
                {map = "154010883", door = "369"},
                {map = "152045573", custom = function() increment() map:door(262) end},
            }
        end
    elseif global:remember("ETAPE") == 1 then
        return{
            { map = "153092354", custom = quete1_1 },
            { map = "153093380", custom = quete1_2 },
        }
    elseif global:remember("ETAPE") == 2 then
        return {
            { map = "153093380", door = "438"},
            { map = "153092354", custom = quete2_1 },
            { map = "153092356", custom = quete2_2 },
        }
    elseif global:remember("ETAPE") == 3 then
        return {
            { map = "153092356", custom = quete2_3 },
            { map = "153092354", custom = quete2_4 },
            { map = "152044547", custom = quete3_1 },--IOP
            { map = "152043521", custom = quete3_1 },--CRA
            { map = "152045573", custom = quete3_1 },--SACRIEUR
            { map = "152046593", custom = quete3_1 },--ENIRIPSA
            { map = "152046599", custom = quete3_1 },--SRAM
            { map = "152044553", custom = quete3_1 },--OUGINACK
            { map = "152043523", custom = quete3_1 },--OSAMODA
            { map = "152046595", custom = quete3_1 },--ENUTROF
            { map = "152044545", custom = quete3_1 },--ECAFLIP
            { map = "152045575", custom = quete3_1 },--STEAMER
            { map = "152045571", custom = quete3_1 },--FECA
            { map = "152043529", custom = quete3_1 },--HUPPERMAGE
            { map = "152043527", custom = quete3_1 },--ZOBAL
            { map = "152043525", custom = quete3_1 },--PANDAWA
            { map = "152045569", custom = quete3_1 },--ELIOTOPE
            { map = "152046597", custom = quete3_1 },--SADIDA
            { map = "152044549", custom = quete3_1 },--ROUBLARD
            { map = "152044551", custom = quete3_1 },--XELOR

            { map = "154010883", custom = quete3_2 },
            { map = "154010371", custom = quete4_1 },
            { map = "153878787", custom = quete4_2 },
            { map = "153357316", custom = quete4_3 },
        }
    elseif global:remember("ETAPE") == 4 then
        return {
            { map = "153878787", custom = quete4_4 },
            { map = "153879299", custom = quete4_5 },
            { map = "1,-4", path = "left" },
            { map = "153878788", door = "315" },
            { map = "153356294", custom = quete4_6 },
        }
    elseif global:remember("ETAPE") == 5 then
        return {
            { map = "153878788", path = "left" },
            { map = "154010372", path = "bottom" },
            { map = "154010371", custom = quete4_7 },
            { map = "0,-3", path = "right" },
            { map = "1,-3", path = "right" },
            { map = "153879811", door = "285" },
            { map = "153356296", custom = quete4_8 },
        }
    elseif global:remember("ETAPE") == 6 then
        return {
            { map = "153879811", path = "bottom" },
            { map = "2,-2", path = "bottom" },
            { map = "2,-1", custom = quete5_1 },
        }
    elseif global:remember("ETAPE") == 7 then
        return {
            { map = "2,-1", path = "left" },
            { map = "1,-1", path = "top" },
            { map = "1,-2", path = "left" },
            { map = "0,-2", path = "top" },
            { map = "153878787", door = "326" },
            { map = "153357316", custom = quete5_2 },
        }       
    elseif global:remember("ETAPE") == 8 then
        return {
            { map = "153878787", path = "left" },
            { map = "-1,-3", path = "left" },
            { map = "-2,-3", custom = quete5_3 },
        }
    elseif global:remember("ETAPE") == 9 then
        return {
            { map = "-2,-4", path = "right" },
            { map = "-1,-4", path = "right" },
            { map = "0,-4", path = "right" },
            { map = "1,-4", path = "right" },
            { map = "2,-4", path = "bottom" },
            { map = "153879811", door = "285" },
            { map = "153356296", custom = quete5_4 },
        }
    elseif global:remember("ETAPE") == 10 then
        return {
            { map = "153879811", path = "bottom" },
            { map = "2,-2", path = "bottom" },
            { map = "2,-1", path = "bottom" },
            { map = "2,0", path = "right" },
            { map = "3,0", path = "right" },
            { map = "4,0", path = "right" },
            { map = "5,0", path = "top" },
            { map = "5,-1", custom = quete6_1 },
            { map = "153881088", door = "284" },
            { map = "152836096", custom = quete6_2 },
        }
    elseif global:remember("ETAPE") == 11 then
        return {
            { map = "152836096", custom = quete6_3 },
            { map = "5,-1", path = "bottom" },
            { map = "5,0", path = "left" },
            { map = "4,0", path = "left" },
            { map = "3,0", path = "top" },
            { map = "3,-1", path = "left" },
            { map = "2,-1", path = "top" },
            { map = "2,-2", path = "top" },
            { map = "153879811", door = "285" },
            { map = "153356296", custom = quete6_4 },
        }
    elseif global:remember("ETAPE") == 12 then
        return {
            { map = "153879811", path = "right" },
            { map = "3,-3", path = "right" },
            { map = "4,-3", custom = quete7_1 },
        }
    elseif global:remember("ETAPE") == 13 then
        return {
            { map = "192416776", custom = quete7_2 },
            { map = "4,-3", path = "left" },
            { map = "3,-3", path = "left" },
            { map = "2,-3", path = "left" },
            { map = "1,-3", path = "left" },
            { map = "0,-3", path = "left" },
            { map = "-1,-3", custom = quete8_1 },
            { map = "-1,-4", path = "top" },
            { map = "-1,-5", path = "right" },
            { map = "0,-5", path = "right" },
            { map = "1,-5", path = "right" },
            { map = "2,-5", custom = quete8_2 },
        }
    elseif global:remember("ETAPE") == 14 then
        return {
            { map = "1,-5", path = "left" },
            { map = "0,-5", path = "left" },
            { map = "-1,-5", path = "bottom" },
            { map = "-1,-4", path = "bottom" },
            { map = "-1,-3", custom = quete8_3 },
        }
    elseif global:remember("ETAPE") == 15 then
        return {
            { map = "-2,-3", path = "bottom" },
            { map = "-2,-2", custom = quete9_1 },
            { map = "-1,-2", path = "right" },
            { map = "0,-2", path = "bottom" },
            { map = "0,-1", path = "right" },
            { map = "1,-1", custom = quete9_2},
            { map = "1,-2", path = "top" },
            { map = "1,-3", path = "top" },
            { map = "1,-4", path = "top" },
            { map = "1,-5", custom = quete9_3 },
            { map = "0,-5", custom = quete9_4 },
            { map = "0,-4", path = "bottom" },
            { map = "0,-3", custom = quete9_5 },
        }
    elseif global:remember("ETAPE") == 16 then
        return {
            { map = "-1,-3", custom = quete9_6 },
            { map = "-1,-4", path = "top" },
            { map = "-1,-5", path = "top" },
            { map = "-1,-6", custom = quete10_1 },
            { map = "-2,-6", path = "bottom" },
            { map = "-2,-5", path = "bottom" },
            { map = "-2,-4", path = "bottom" },
            { map = "-2,-3", path = "bottom" },
            { map = "-2,-2", path = "bottom" },
            { map = "-2,-1", path = "bottom" },
            { map = "-2,0", path = "right" },
            { map = "-1,0", path = "bottom" },
            { map = "-1,1", custom = quete10_2 },
        }
    elseif global:remember("ETAPE") == 17 then
        return{
            { map = "-1,0", path = "left" }, 
            { map = "-2,0", path = "top" },
            { map = "-2,-1", path = "top" },
            { map = "-2,-2", path = "top" },
            { map = "-2,-3", path = "right" },
            { map = "-1,-3", custom = quete10_3 },
            { map = "-1,-4", path = "right" },
            { map = "153878788", door = "315" },
            { map = "153356294", custom = quete11_1 },
            { map = "153356292", custom = quete11_2 },
        }
    elseif global:remember("ETAPE") == 18 then
        return{
            { map = "153356292", custom = quete11_3 },
            { map = "153356294", custom = quete12_1 },
        }
    elseif global:remember("ETAPE") == 19 then
        if COMBAT12 <= 2 then
            global:printSuccess("Boucle numero " .. COMBAT12)
            return{
                { map = "153878788", path = "left", fight = true },
                { map = "-1,-4", path = "left", fight = true },
                { map = "-2,-4", path = "top", fight = true },
                { map = "-2,-5", path = "left", fight = true },
                { map = "-3,-5", path = "top", fight = true },
                { map = "-3,-6", path = "right", fight = true },
                { map = "-2,-6", path = "right", fight = true },
                { map = "-1,-6", path = "bottom", fight = true },
                { map = "-1,-5", path = "right", fight = true, custom = boucle12 },
                { map = "0,-5", path = "bottom", fight = true },
                {map = "1,-3", path = "left"},
                {map = "0,-3", path = "top"},
            }
        elseif COMBAT12 == 3 then
            return{
                { map = "0,-5", path = "bottom", custom = increment },
            }
        end
    elseif global:remember("ETAPE") == 20 then
        return{
            { map = "153878788", door = "315" },
            { map = "153356294", custom = quete13_1 },
        }
    elseif global:remember("ETAPE") == 21 then
        if COMBAT13 <= 2 then
            global:printSuccess("Boucle numero " .. COMBAT13)
            return{
                { map = "153878788", path = "bottom" },
                {map = "1,-3", path = "left"},
                { map = "0,-3", path = "bottom" },
                { map = "0,-2", path = "left", fight = true },
                { map = "-1,-2", path = "bottom", fight = true },
                { map = "-1,-1", path = "left", fight = true },
                { map = "-2,-1", path = "top", fight = true },
                { map = "-2,-2", path = "right", fight = true, custom = boucle13 },
            }
        elseif COMBAT13 == 3 then
            return{
                { map = "-1,-2", path = "top"},
                { map = "-1,-3", path = "top" },
                { map = "-1,-4", path = "right", custom = increment },
            }
        end
    elseif global:remember("ETAPE") == 22 then
        return{
            { map = "153878788", door = "315" },
            { map = "153356294", custom = quete14_1 },
        }
    elseif global:remember("ETAPE") == 23 then
        if COMBAT14 <= 2 then
            global:printSuccess("Boucle numero " .. COMBAT14)
            return{
                { map = "153878788", path = "right" },
                {map = "1,-3", path = "top"},
                { map = "1,-4", path = "right", fight = true },
                { map = "2,-4", path = "right", fight = true },
                { map = "3,-4", path = "top", fight = true },
                { map = "3,-5", path = "left", fight = true },
                { map = "2,-5", path = "left", fight = true, custom = boucle14 },
                { map = "1,-5", path = "bottom", fight = true },
            }
        elseif COMBAT14 == 3 then
            return {
                { map = "1,-5", path = "left" },
                { map = "0,-5", path = "bottom", custom = increment },
            }
        end
    elseif global:remember("ETAPE") == 24 then
        return{
            { map = "153878788", door = "315" },
            { map = "153356294", custom = quete15_1 },
        }
    elseif global:remember("ETAPE") == 25 then
        if COMBAT15 <= 2 then
            global:printSuccess("Boucle numero " .. COMBAT15)
            return{
                { map = "153878788", path = "bottom" },
                { map = "0,-3", path = "right" },
                { map = "1,-3", path = "bottom" },
                { map = "1,-2", path = "bottom", fight = true },
                { map = "1,-1", path = "bottom", fight = true },
                { map = "1,0", path = "right", fight = true },
                { map = "2,0", path = "top", fight = true },
                { map = "2,-1", path = "right", fight = true },
                { map = "3,-1", path = "top", fight = true },
                { map = "3,-2", path = "left", fight = true, custom = boucle15 },
                { map = "2,-2", path = "left", fight = true },
            }
        elseif COMBAT15 == 3 then
            return{
                { map = "2,-2", path = "top" },
                { map = "2,-3", path = "top" },
                { map = "2,-4", path = "left" },
                { map = "1,-4", path = "left", custom = increment },
            }
        end
    elseif global:remember("ETAPE") == 26 then
        return{
            { map = "153878788", door = "315" },
            { map = "153356294", custom = quete16_1 },
        }
    elseif global:remember("ETAPE") == 27 then
        return{
            { map = "153878788", path = "right" },
            { map = "1,-4", path = "bottom" },
            { map = "1,-3", path = "bottom" },
            { map = "1,-2", path = "bottom" },
            { map = "1,-1", path = "bottom" },
            { map = "1,0", custom = quete16_2 },
        }
    elseif global:remember("ETAPE") == 28 then
        return{
            { map = "1,0", path = "top" },
            { map = "1,-1", path = "top" },
            { map = "1,-2", path = "top" },
            { map = "1,-3", path = "top" },
            { map = "1,-4", path = "left" },
            { map = "153878788", door = "315" },
            { map = "153356294", custom = quete16_3 },
        }
    elseif global:remember("ETAPE") == 29 then
        return{
            { map = "153878788", path = "right" },
            { map = "1,-3", path = "top"},
            { map = "1,-4", path = "right" },
            { map = "2,-4", path = "right" },
            { map = "3,-4", path = "bottom" },
            { map = "3,-3", path = "bottom" },
            { map = "3,-2", path = "bottom" },
            { map = "3,-1", path = "bottom" },
            { map = "3,0", path = "bottom", fight = true },
            { map = "3,1", path = "right", fight = true },
            { map = "153881090", door = "361"},
            { map = "153356288", custom = quete17_1 },
        }
    elseif global:remember("ETAPE") == 30 then
        return{
            {map = "1,-3", path = "bottom"},
            {map = "1,-2", path = "bottom"},
            {map = "1,-1", path = "right"},
            {map = "2,-1", path = "right"},
            {map = "3,-1", path = "bottom"},
            {map = "3,0", path = "right"},

            { map = "153356288", path = "410" },
            { map = "153881090", path = "top", fight = true},
            { map = "153881089", path = "top", fight = true},
            { map = "4,-1", path = "right" },
            { map = "5,-1", path = "bottom" },
            { map = "5,0", path = "left", custom = increment },
        }
    elseif global:remember("ETAPE") == 31 then
        global:printSuccess("Boucle numero " .. COMBAT17)
        if COMBAT17 <= 2 then
            return{
                {map = "1,-3", path = "right"},
                {map = "2,-3", path = "right"},
                {map = "3,-3", path = "bottom"},
                {map = "3,-2", path = "bottom"},
                {map = "3,-1", path = "bottom"},
                { map = "4,0", path = "bottom", fight = true },
                { map = "4,1", path = "left", fight = true },
                { map = "3,1", path = "top", fight = true, custom = boucle17 },
                { map = "3,0", path = "right", fight = true },
            }
        elseif COMBAT17 == 3 then
            return{
                { map = "3,0", path = "top" },
                { map = "3,-1", path = "top" },
                { map = "3,-2", path = "top" },
                { map = "3,-3", path = "top" },
                { map = "3,-4", path = "left" },
                { map = "2,-4", path = "left" },
                { map = "1,-4", path = "left" },
                { map = "153878788", door = "315" },
                { map = "153356294", custom = quete17_2 },
            }
        end
    elseif global:remember("ETAPE") == 32 then
        return{
            { map = "153878788", path = "bottom" },
            { map = "0,-3", custom = quete18_1 },
        }
    elseif global:remember("ETAPE") == 33 then
        if inventory:itemCount(289) < 14 then
            ble()
            return{
                { map = "-1,-3", path = "top", gather = true },
                { map = "-1,-4", path = "top", gather = true },
                { map = "-1,-5", path = "top", gather = true },
                { map = "-1,-6", path = "left", gather = true },
                { map = "-2,-6", path = "left", gather = true },
                { map = "-3,-6", path = "bottom", gather = true },
                { map = "-3,-5", path = "right", gather = true },
                { map = "-2,-5", path = "bottom", gather = true },
                { map = "-2,-4", path = "bottom", gather = true },
                { map = "-2,-3", path = "right", gather = true },
            }
        elseif inventory:itemCount(289) >= 14 then
            return{
                { map = "-3,-6", path = "bottom" },
                { map = "-2,-6", path = "bottom" },
                { map = "-1,-6", path = "bottom" },
                { map = "-1,-5", path = "bottom" },
                { map = "-2,-5", path = "bottom" },
                { map = "-3,-5", path = "right" },
                { map = "-2,-4", path = "right" },
                { map = "-2,-3", path = "top" },
                { map = "-1,-3", path = "top" },
                { map = "154010372", door = "274" },
                { map = "153354242", custom = quete18_2 },
            }
        end
    elseif global:remember("ETAPE") == 34 then
        if inventory:itemCount(421) < 16 then
            ortie()
            return{
                { map = "0,-4", path = "right" },
                { map = "-1,-4", path = "right" },
                { map = "1,-4", path = "right", gather = true },
                { map = "2,-4", path = "right", gather = true },
                { map = "3,-3", path = "left", gather = true },
                { map = "2,-3", path = "left", gather = true },
                { map = "3,-4", path = "bottom", gather = true },
                { map = "1,-3", path = "top", gather = true },
            }
        elseif inventory:itemCount(421) >= 16 then
            return{
                { map = "3,-4", path = "left" },
                { map = "3,-3", path = "left" },
                { map = "2,-4", path = "left" },
                { map = "2,-3", path = "left" },
                { map = "1,-3", path = "left" },
                { map = "1,-4", path = "bottom" },
                { map = "0,-3", path = "left" },
                { map = "-1,-3", path = "left" },
                { map = "-2,-3", path = "bottom" },
                { map = "154010882", door = "186" },
                { map = "153355270", custom = quete18_3 },
            }
        end
    elseif global:remember("ETAPE") == 35 then
        if inventory:itemCount(1782) < 4 then
            goujon()
            return{
                { map = "-2,-2", path = "right|bottom", gather = true },
                { map = "-2,-1", path = "right|top", gather = true },
                { map = "-1,-1", path = "left|top", gather = true },
                { map = "-1,-2", path = "right|left|bottom", gather = true },
                { map = "0,-2", path = "left|bottom", gather = true },
                { map = "0,-1", path = "top", gather = true },
            }
        elseif inventory:itemCount(1782) >= 4 then
            return{
                { map = "-2,-2", path = "right" },
                { map = "-1,-2", path = "right" },
                { map = "-2,-1", path = "right" },
                { map = "-1,-1", path = "top" },
                { map = "0,-2", path = "bottom" },
                { map = "153878785", door = "301" },
                { map = "153354246", custom = quete18_4 },
            }
        end
    elseif global:remember("ETAPE") == 36 then
        return{
            { map = "0,-1", path = "top" },
            { map = "0,-2", path = "top" },
            { map = "0,-3", custom = quete18_5 },
        }
    elseif global:remember("ETAPE") == 37 then
        if inventory:itemCount(303) < 20 then
            frene()
            return{
                { map = "1,-3", path = "bottom" },
                { map = "1,-2", path = "bottom", gather = true },
                { map = "1,-1", path = "bottom", gather = true },
                { map = "2,0", path = "top", gather = true },
                { map = "2,-1", path = "right", gather = true },
                { map = "3,-2", path = "left", gather = true },
                { map = "3,-1", path = "top", gather = true },
                { map = "1,0", path = "right", gather = true },
                { map = "2,-2", path = "left", gather = true },
            }
        elseif inventory:itemCount(303) >= 20 then
            if inventory:itemCount(312) < 17 and chemin1 then
                fer()
                return{
                    { map = "1,-1", path = "right" },
                    { map = "1,0", path = "right" },
                    { map = "1,-2", path = "right" },
                    { map = "3,-1", path = "left" },
                    { map = "3,-2", path = "left" },
                    { map = "2,0", path = "top" },
                    { map = "2,-1", path = "top" },
                    { map = "2,-2", path = "top" },
                    { map = "2,-3", path = "top" },
                    { map = "153879812", door = "198", gather = true },
                    { map = "153358338", custom = function() chemin1 = false chemin2 = true map:door(158) end, gather = true },


                    { map = "153357312", door = "473", gather = true },
                    { map = "153357314", door = "348", gather = true },

                    {map = "153358342", door = "436", gather = true},
                    {map = "153358344", door = "472", gather = true},
                    {map = "153880324", path = "left"},


                    153358344
                }
            elseif inventory:itemCount(312) < 17 and chemin2 then
                fer()
                return{
                    { map = "153358336", door = "459", gather = true },
                    { map = "153358338", door = "491", gather = true },
                    { map = "153357314", custom = function() chemin2 = false chemin3 = true map:door(173) end, gather = true },
                }
            elseif inventory:itemCount(312) < 17 and chemin3 then
                fer()
                return{
                    { map = "153357312", door = "473", gather = true },
                    { map = "153357314", door = "348", gather = true },
                    { map = "153358338", door = "376", gather = true },
                    { map = "153879812", path = "right"},
                    { map = "153880324", door = "155"},
                    { map = "153358344", custom = function() chemin3 = false chemin4 = true map:door(268) end, gather = true },
                }
            elseif inventory:itemCount(312) < 17 and chemin4 then
                fer()
                return{
                    { map = "153357318", door = "444", gather = true },
                    { map = "153358344", custom = function() chemin4 = false chemin1 = true map:door(289) end, gather = true },
                }
            elseif inventory:itemCount(312) >= 17 then
                if not map:onMap(153355264) then
                    map:moveToward(153355264)
                else
                    quete19_1()
                end
            end
        end
    elseif global:remember("ETAPE") == 38 then
        return{
            { map = "153879812", path = "bottom" },
            { map = "2,-3", path = "bottom" },
            { map = "153879810", door = "315" },
            { map = "153355266", custom = quete19_2 },
        }
    elseif global:remember("ETAPE") == 39 then
        return{
            { map = "153879810", path = "top" },
            { map = "2,-3", path = "left" },
            { map = "1,-3", path = "left" },
            { map = "0,-3", custom = quete19_3 },
        }
    elseif global:remember("ETAPE") == 40 then
        return{
            { map = "1,-3", path = "top" },
            { map = "153879300", door = "329" },
            { map = "153355272", custom = quete20_1 },
        }
    elseif global:remember("ETAPE") == 41 then
        return{
            { map = "153879300", path = "bottom" },
            { map = "1,-3", path = "bottom" },
            { map = "1,-2", path = "left" },
            { map = "153878786", door = "315" },
            { map = "153354244", custom = quete20_2 },
        }
    elseif global:remember("ETAPE") == 42 then
        return{
            { map = "153878786", path = "top" },
            { map = "0,-3", custom = quete20_3 },
        }
    elseif global:remember("ETAPE") == 43 then
        return{
            { map = "1,-3", path = "bottom" },
            { map = "153879298", door = "341" },
            { map = "153354248", custom = quete21_1 },
        }
    elseif global:remember("ETAPE") == 44 then
        return{
            { map = "153879298", path = "right" },
            { map = "153879810", door = "315" },
            { map = "153355266", custom = quete21_2 },
        }
    elseif global:remember("ETAPE") == 45 then
        return{
            { map = "153879810", path = "top" },
            { map = "2,-3", path = "top" },
            { map = "153879812", door = "330" },
            { map = "153355264", custom = quete21_3 },
        }
    elseif global:remember("ETAPE") == 46 then
        return{
            { map = "153879812", path = "bottom" },
            { map = "2,-3", path = "left" },
            { map = "1,-3", path = "left" },
            { map = "0,-3", custom = quete21_4 },
        }
    elseif global:remember("ETAPE") == 47 then
        return{
            { map = "1,-3", path = "bottom" },
            { map = "1,-2", custom = quete22_1 },
        }
    elseif global:remember("ETAPE") == 48 then
        return{
            { map = "1,-3", path = "left" },
            { map = "153878787", door = "326" },
            { map = "153357316", custom = quete22_2 },
        }
    elseif global:remember("ETAPE") == 49 then
        return{
            { map = "153878787", path = "left" },
            { map = "-1,-3", path = "top" },
            { map = "154010372", door = "274" },
            { map = "153354242", custom = quete22_3 },
        }
    elseif global:remember("ETAPE") == 50 then
        return{
            { map = "154010372", path = "right" },
            { map = "0,-4", path = "right" },
            { map = "1,-4", path = "bottom" },
            { map = "1,-3", path = "bottom" },
            { map = "1,-2", custom = quete22_4 },
            { map = "2,-2", path = "top" },
            { map = "2,-3", custom = quete22_5 },
        }
    elseif global:remember("ETAPE") == 51 then
        return{
            { map = "2,-2", path = "left" },
            { map = "1,-2", custom = quete22_6 },
            { map = "1,-1", path = "right" },
            { map = "2,-1", path = "right" },
            { map = "3,-1", path = "bottom" },
            { map = "3,0", path = "right" },
            { map = "4,0", path = "top" },
            { map = "4,-1", path = "right" },
            { map = "153881600", custom = quete23_1 },
            { map = "152829952", forcefight = true },--Salle 1
            { map = "152830976", forcefight = true },--Salle 2
            { map = "152832000", forcefight = true },--Salle 3
            { map = "152833024", forcefight = true },--Salle 4
            { map = "152834048", forcefight = true },--Salle 5
            { map = "152835072", custom = quete23_2 },
        }
    elseif global:remember("ETAPE") == 52 then
        return{
            { map = "153881600", path = "bottom" },
            { map = "5,0", path = "left" },
            { map = "4,0", path = "left" },
            { map = "3,0", path = "top" },
            { map = "3,-1", path = "top" },
            { map = "3,-2", path = "top" },
            { map = "3,-3", path = "top" },
            { map = "3,-4", path = "top" },
            { map = "3,-5", custom = quete24_1 },
            { map = "2,-5", path = "bottom" },
            { map = "153879812", custom = increment, door = "198" },
        }
    elseif global:remember("ETAPE") == 53 then
        if inventory:itemCount(16999) < 3 then
            MAX_MONSTERS = 4
            return{
                { map = "153358338", fight = true, door = "158" },
                { map = "153358336", fight = true, door = "459" },
            }
        elseif inventory:itemCount(16999) >= 3 then
            return{
                { map = "153358338", door = "376" },
                { map = "153358336", door = "459" },
                { map = "153879812", path = "top" },
                { map = "2,-5", path = "right" },
                { map = "3,-5", custom = quete24_2 },
            }
        end
    elseif global:remember("ETAPE") == 54 then
        return{
            { map = "3,-4", path = "bottom" },
            { map = "3,-3", path = "left" },
            { map = "2,-3", path = "left" },
            { map = "1,-3", path = "left" },
            { map = "153878787", custom = quete25_1 },
            { map = "153357316", custom = quete25_2 },
            { map = "153358340", custom = quete25_3 },
        }
    elseif global:remember("ETAPE") == 55 then
        return{
            { map = "153358340", door = "313" },
            { map = "153357316", custom = quete25_4 },
            { map = "153878787", path = "right" },
            {map = "190843392", path = "top"},
            { map = "153092354", door = 409},
          { map = "152045573", path = "right", gather = false, fight = false }, -- 152045573
          { map = "152043521", path = "right", gather = false, fight = false }, -- 152045573
          { map = "152046597", path = "right", gather = false, fight = false }, -- 152045573
          { map = "-2,-3", path = "right" }, -- 154010883
          { map = "-2,-2", path = "top" }, -- 154010882
          { map = "-1,-2", path = "top"}, -- 154010370
          { map = "0,-2", path = "top"}, -- 153878786
          { map = "1,-2", path = "top"}, -- 153879298
          { map = "1,-3", path = "right" }, -- 153879299
          { map = "-1,-3", path = "right"}, -- 154010371
          { map = "-1,-4", path = "bottom"}, -- 154010372
          { map = "0,-4", path = "bottom" }, -- 153878788
          { map = "0,-5", path = "bottom"}, -- 153878789
          { map = "-1,-5", path = "right" }, -- 154010373
          { map = "-2,-5", path = "right"}, -- 154010885
          { map = "-2,-4", path = "bottom"}, -- 154010884
          { map = "2,-3", path = "right"}, -- 153879811
          { map = "3,-3", path = "right"}, -- 153880323
          { map = "4,-3", custom = goToAstrub}, -- 153880323
          { map = "192416776", custom = function() 
            -- if global:thisAccountController():getAlias():find("Mineur") or global:thisAccountController():getAlias():find("Bucheron") then
            --     local message = developer:createMessage("TitleSelectedMessage")
            --     message.titleId = 197
            --     developer:sendMessage(message)
            -- end
            global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\PL&Zaaps\\PL_1-6X.lua") 
        end, path = "left"}, -- 192416776
        }
    end
end

function increment()
    global:editInMemory("ETAPE", global:remember("ETAPE") + 1)
    global:printMessage("ETAPE ".. global:remember("ETAPE") .." !")
end

function goToAstrub()
	npc:npc(4398,3)
	npc:reply(-1)
	npc:reply(-1)
    global:leaveDialog()
    global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\PL&Zaaps\\PL_1-6X.lua")
end

function boucle12()
    COMBAT12 = COMBAT12 + 1
end

function boucle13()
    COMBAT13 = COMBAT13 + 1
end

function boucle14()
    COMBAT14 = COMBAT14 + 1
end

function boucle15()
    COMBAT15 = COMBAT15 + 1
end

function boucle17()
    COMBAT17 = COMBAT17 + 1
end

function ble()
    GATHER = {38} 
end

function ortie()
    GATHER = {254} 
end

function goujon()
    GATHER = {75} 
end

function frene()
    GATHER = {1} 
end

function fer()
    GATHER = {17} 
end


local function Bug(ActivesQuest)
    for _, element in ipairs(ActivesQuest) do
        if element == 1 then
            return false
        end
    end
    return true
end

function quete1_1()
    npc:npc(2897,3)
    global:delay(math.random(300, 700))
    npc:reply(-1)
    global:leaveDialog()
    global:delay(math.random(300, 700))
    map:door(276)
    global:delay(2000)
    global:deleteMemory("BUG")
    global:addInMemory("BUG", true)
    map:door(409)
end

function quete1_2()
  increment()
  npc:npc(2895,3)
  global:delay(math.random(300, 700))
  npc:reply(-1)
  global:delay(math.random(300, 700))
  npc:reply(-1)
  global:leaveDialog()
  map:door(395)
  map:door(340)
  map:door(297)
  map:door(258)
  map:door(303)
  global:delay(math.random(300, 700))
  map:door(442)
  craft:putItem(421,1)
  craft:putItem(303,1)
  craft:putItem(312,1)
  craft:putItem(289,1)
  craft:putItem(1782,1)
  craft:ready()
  global:leaveDialog()
  npc:npc(2895,3)
  npc:reply(-1)
  global:delay(math.random(300, 700))
  map:door(438)
end

function quete2_1()
    npc:npc(2897,3)
    global:delay(math.random(300, 700))
    npc:reply(-1)
    global:leaveDialog()
    global:delay(math.random(300, 700))
    map:door(189)
end

function quete2_2()
    increment()
    npc:npc(2896,3)
    global:delay(math.random(300, 700))
    npc:reply(-1)
    global:leaveDialog()
    global:delay(math.random(300, 700))
    npc:npc(2930,3)
    npc:reply(-1)
end

function quete2_3()
    npc:npc(2896,3)
    global:delay(math.random(300, 700))
    npc:reply(-1)
    global:leaveDialog()
    global:delay(math.random(300, 700))
    map:door(396)
end

function quete2_4()
    npc:npc(2897,3)
    global:delay(math.random(300, 700))
    npc:reply(-1)
end

function quete3_1()
    npc:npc(2897,3)
    global:delay(math.random(300, 700))
    npc:reply(-1)
    global:leaveDialog()
    global:delay(math.random(300, 700))
    map:door(230)
    global:leaveDialog()
    map:door(438)
    global:leaveDialog()
    map:door(362)
    global:leaveDialog()
    global:delay(math.random(300, 700))
    npc:npc(2897,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
end

function quete3_2()
    npc:npc(2892,3)
    global:delay(math.random(300, 700))
    npc:reply(-1)
    global:delay(math.random(300, 700))
    npc:reply(-1)
    global:delay(math.random(300, 700))
    npc:reply(-1)
    global:leaveDialog()
    map:changeMap("right")
end

function quete4_1()
    npc:npc(2905,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:changeMap("right")
end

function quete4_2()
    npc:npc(2899,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:door(326)
end

function quete4_3()
    increment()
    global:delay(math.random(300, 700))
    npc:npc(2885,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:moveToCell(411)
end

function quete4_4()
    --
    map:changeMap("right")
end

function quete4_5()
    npc:npc(2910,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:changeMap("top")
end

function quete4_6()
    increment()
    npc:npc(2880,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:moveToCell(452)
end

function quete4_7()
    npc:npc(2905,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:changeMap("right")
end

function quete4_8()
    increment()
    npc:npc(1515,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:door(426)
    global:leaveDialog()
    npc:npc(1515,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:moveToCell(401)
end

function quete5_1()
    increment()
    npc:npc(2904,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
end

function quete5_2()
    increment()
    npc:npc(2909,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:moveToCell(411)
end

function quete5_3()
    increment()
    npc:npc(2892,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-2)
    npc:reply(-1)
    npc:reply(-2)
    npc:reply(-2)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:changeMap("top")
end

function quete5_4()
    increment()
    npc:npc(1515,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:moveToCell(401)
end

function quete6_1()
    npc:npc(2907,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:changeMap("left")
end

function quete6_2()
    increment()
    npc:npc(2911,3)
    npc:reply(-1)
    global:leaveDialog()
end

function quete6_3()
    npc:npc(2898,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
end

function quete6_4()
    increment()
    npc:npc(1515,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:moveToCell(401)
end

function quete7_1()
    increment()
    npc:npc(4360,3)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    global:delay(math.random(300, 700))
    npc:npc(4398,3)
end

function quete7_2()
    global:leaveDialog()
    npc:npc(4355,3)
    npc:reply(-1)
    global:leaveDialog()
    global:delay(math.random(300, 700))
    map:door(455)
end

function quete8_1()
    npc:npc(2905,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:changeMap("top")
end

function quete8_2()
    increment()
    npc:npc(2882,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    global:delay(math.random(300, 700))
    map:door(303)
    npc:reply(-1)
    global:leaveDialog()
    global:delay(math.random(300, 700))
    map:changeMap("left")
end

function quete8_3()
    increment()
    npc:npc(2905,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:changeMap("left")
end

function quete9_1()
    map:door(471)
    global:leaveDialog()
    map:changeMap("right")
end

function quete9_2()
    map:door(415)
    global:leaveDialog()
    map:changeMap("top")
end

function quete9_3()
    map:door(344)
    global:leaveDialog()
    map:changeMap("left")
end

function quete9_4()
    map:door(286)
    global:leaveDialog()
    map:changeMap("bottom")
end

function quete9_5()
    increment()
    map:door(485)
    global:leaveDialog()
    map:changeMap("left")
end

function quete9_6()
    npc:npc(2905,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:changeMap("top")
end

function quete10_1()
    npc:npc(2887,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    global:delay(math.random(300, 700))
    map:door(234)
    global:delay(math.random(300, 700))
    global:leaveDialog()
    map:changeMap("left")
end

function quete10_2()
    increment()
    npc:npc(2906,3)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    global:delay(math.random(300, 700))
    map:door(369)
    global:delay(math.random(300, 700))
    global:leaveDialog()
    map:changeMap("top")
end

function quete10_3()
    npc:npc(2905,3)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:changeMap("top")
end

function quete11_1()
    npc:npc(2880,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    global:delay(math.random(300, 700))
    map:door(215)
end

function quete11_2()
    increment()
    npc:npc(2894,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
end

function quete11_3()
    npc:npc(2894,3)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:door(374)
end

function quete12_1()
    increment()
    npc:npc(2880,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:moveToCell(452)
end

function quete13_1()
    increment()
    npc:npc(2880,3)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:moveToCell(452)
end

function quete14_1()
    increment()
    npc:npc(2880,3)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:moveToCell(452)
end

function quete15_1()
    increment()
    npc:npc(2880,3)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:moveToCell(452)
end

function quete16_1()
    increment()
    npc:npc(2880,3)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:moveToCell(452)
end

function quete16_2()
    increment()
    npc:npc(2908,3)
    npc:reply(-1)
    global:leaveDialog()
end

function quete16_3()
    increment()
    npc:npc(2880,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:moveToCell(452)
end

function quete17_1()
    increment()
    map:door(343)
    npc:npc(2938,3)
    npc:reply(-1)
    global:leaveDialog()
end

function quete17_2()
    increment()
    npc:npc(2880,3)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:moveToCell(452)
end

function quete18_1()
    increment()
    npc:npc(2899,3)
    npc:reply(-1)
    npc:reply(-2)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:changeMap("left")
end

function quete18_2()
    increment()
    map:door(285)
    craft:putItem(289,4)
    craft:ready()
    global:leaveDialog()
    map:moveToCell(424)
end

function quete18_3()
    increment()
    map:door(230)
    craft:putItem(421,4)
    craft:ready()
    global:leaveDialog()
    map:moveToCell(415)
end

function quete18_4()
    increment()
    map:door(285)
    craft:putItem(1782,4)
    craft:ready()
    global:leaveDialog()
    map:moveToCell(397)
end

function quete18_5()
    increment()
    npc:npc(2899,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:changeMap("right")
end

function quete19_1()
    increment()
    map:door(245)
    craft:putItem(303,10)
    craft:putItem(312,6)
    craft:ready()
    global:leaveDialog()
    map:moveToCell(313)
end

function quete19_2()
    increment()
    map:door(342)
    craft:putItem(312,4)
    craft:putItem(303,6)
    craft:ready()
    global:leaveDialog()
    map:moveToCell(385)
end

function quete19_3()
    increment()
    npc:npc(2899,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:changeMap("right")
end

function quete20_1()
    increment()
    map:door(372)
    craft:putItem(16512,2)
    craft:putItem(303,2)
    craft:ready()
    global:leaveDialog()
    map:door(372)
    craft:putItem(16518,2)
    craft:putItem(312,1) 
    craft:ready()   
    global:leaveDialog()
    map:moveToCell(382)
end

function quete20_2()
    increment()
    map:door(384)
    craft:putItem(16513,2)
    craft:putItem(303,2)
    craft:ready()
    global:leaveDialog()
    map:door(384)
    craft:putItem(16522,2)
    craft:putItem(421,2)
    craft:ready()    
    global:leaveDialog()
    map:door(312)
    craft:putItem(1984,2)
    craft:putItem(312,1)
    craft:ready()
    global:leaveDialog()
    map:door(312)
    craft:putItem(16511,2)
    craft:putItem(421,2)
    craft:ready()    
    global:leaveDialog()
    map:moveToCell(410)
end

function quete20_3()
    increment()
    npc:npc(2899,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:changeMap("right")
end

function quete21_1()
    increment()
    map:door(286)
    craft:putItem(16524,3)
    craft:putItem(1984,5)
    craft:ready()
    global:leaveDialog()
    map:door(328)
end

function quete21_2()
    increment()
    map:door(353)
    craft:putItem(16513,3)
    craft:putItem(16511,3)
    craft:ready()
    global:leaveDialog()
    map:moveToCell(385)
end

function quete21_3()
    increment()
    map:door(317)
    craft:putItem(312,1)
    craft:putItem(16511,5)
    craft:ready()
    global:leaveDialog()
    map:moveToCell(313)
end

function quete21_4()
    increment()
    npc:npc(2899,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:changeMap("right")
end

function quete22_1()
    increment()
    npc:npc(2886,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    global:delay(math.random(300, 700))
    inventory:useItem(16517)
    global:leaveDialog()
    map:changeMap("top")    
end

function quete22_2()
    increment()
    npc:npc(2885,3)
    npc:reply(-1)
    npc:reply(-2)
    map:moveToCell(411)
end

function quete22_3()
    increment()
    map:door(285)
    craft:putItem(289,10)
    craft:putItem(519,4)
    craft:putItem(367,2)
    craft:putItem(6765,1)
    craft:putItem(385,4)
    craft:putItem(1984,4)
    craft:ready()
    global:leaveDialog()
    map:moveToCell(424)
end

function quete22_4()
    npc:npc(2886,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:changeMap("right") 
end

function quete22_5()
    increment()
    npc:npc(2881,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:changeMap("bottom") 
end

function quete22_6()
    npc:npc(2886,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:changeMap("bottom") 
end

function quete23_1()
    npc:npc(2907,3)
    npc:reply(-2)
    npc:reply(-1)
    global:leaveDialog()
end

function quete23_2()
    increment()
    npc:npc(2936,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
end

function quete24_1()
    npc:npc(2888,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:changeMap("left")
end

function quete24_2()
    increment()
    npc:npc(2888,3)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:changeMap("bottom")
end

FINAL = 0

function quete25_1()
	    global:printMessage("IL FAUT MAINTENANT APPUYER SUR :")
	    global:printMessage("L'AFFICHE A DROITE DE LA TAVERNE")
	    global:printMessage("PUIS")
	    global:printMessage("Accepter l'offre d'emploi")
	    global:printMessage("ET ENFIN")
	    global:printMessage("ET CLIQUER SUR LA PORTE DE LA TAVERNE :)")

        map:door(361)
        local message = developer:createMessage("QuestStartRequestMessage")
        message.questId = 1633
        developer:sendMessage(message)
        global:leaveDialog()
        map:door(326)
end

function quete25_2()
    npc:npc(2885,3)
    npc:reply(-1)
    npc:reply(-1)
    global:delay(math.random(300, 700))
    npc:npc(2885,3)
    npc:reply(-2)
    npc:reply(-1)
    global:leaveDialog()
    map:door(387)  
end

function quete25_3()
    increment()
    map:door(328)
    map:moveToCell(354)
    global:delay(math.random(300, 700))
    map:door(328)
    global:delay(math.random(300, 700))
    npc:npc(2912,3)
    npc:reply(-1)
    global:leaveDialog()
end

function quete25_4()
    npc:npc(2885,3)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    inventory:equipItem(12660, 15)
    map:moveToCell(411)
end


function bank()
    local itemDelete = {16503, 16505, 2478, 310, 311, 8239, 8234, 8248, 8235, 8230, 8230, 8232, 8237, 8227, 8233, 8219 }
    for _, element in ipairs(itemDelete) do
        if inventory:itemCount(element) > 0 then
            inventory:deleteItem(element, inventory:itemCount(element))
        end
    end
    if global:remember("ETAPE") == 53 then
        global:deleteMemory("BUG")
        global:addInMemory("BUG", true)
    end
    return move()
end


local function BestChoiceForZone(cellIdLauncher, spellId, nearestEnnemi, poMax, canHurtAllies)
	local entities = fightAction:getAllEntities()
	local spellZone = fightAction:getSpellZone(spellId, nearestEnnemi)
	local nbMonsterInZone = { }
	for i = 1, #spellZone do
		table.insert(nbMonsterInZone, 0)
	end

	-- calcul du nombre d'ennemi dans la zone
	for i, cellId in ipairs(spellZone) do
		newAdjCases = ((fightAction:getDistance(cellId, cellIdLauncher) < (poMax + 1)) 
						and (fightAction:getDistance(cellId, cellIdLauncher) > 1)
						and fightAction:inLineOfSight(cellIdLauncher, cellId)
						and fightAction:isWalkable(cellId))
						and fightAction:getSpellZone(spellId, cellId) or { }

		for _, element2 in ipairs(newAdjCases) do
			for _, element3 in ipairs(entities) do
				if (element2 == element3.CellId) and element3.Team and not iStop then
					nbMonsterInZone[i] = nbMonsterInZone[i] + 1
				end
				if not canHurtAllies and (element2 == element3.CellId) and not element3.Team then
					nbMonsterInZone[i] = 0
					iStop = true
				end
			end
		end
		iStop = false
	end

	local i = 1
	local nbMinMonter = 0
	for j = 1, #nbMonsterInZone do
		if nbMonsterInZone[j] > nbMinMonter then
			nbMinMonter = nbMonsterInZone[j]
			i = j
		end
	end


	if (nbMonsterInZone[i] == 1) and (fightAction:canCastSpellOnCell(cellIdLauncher, spellId, nearestEnnemi) == 0) then
        cellid = nearestEnnemi
	elseif i ~= 1 then
		cellid = spellZone[i]
	elseif (i == 1) and (nbMonsterInZone[i] ~= 0) then
		cellid = nil
	end

	return cellid
end

local function WeakerMonsterAdjacent()
    local entities = fightAction:getAllEntities()
    local cellulesAdj = fightAction:getAdjacentCells(fightCharacter:getCellId())
    local minPv = nil
    local CellToReturn = nil
    for i, element in ipairs(entities) do
        for _, element2 in ipairs(cellulesAdj) do
            if element2 ~= nil and element.Id == 4619 and element.CellId == element2 and element.Team then 
                CellToReturn = element.CellId
                break
            end
            if element2 ~= nil and element.CellId == element2 and (minPv == nil or element.LifePoints < minPv) and element.Team then
                minPv = element.LifePoints
                CellToReturn = element.CellId
            end
        end
    end
    return (CellToReturn ~= nil) and CellToReturn or fightAction:getNearestEnemy()
end

local function Attirance(cellid)
    if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12735, cellid) == 0 then 
		fightAction:castSpellOnCell(12735, cellid)
	end
end

local function Hemmoragie(cellid)
    if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12748, cellid) == 0 then 
		fightAction:castSpellOnCell(12748, cellid)
	end
end


local function Douleur_Cuisante()
	if fightCharacter:getAP() > 2 then
		cellid = BestChoiceForZone(fightCharacter:getCellId(), 12730, WeakerMonsterAdjacent(), 5, false)
		if cellid ~= nil and fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12730, cellid) == 0 then 
			fightAction:castSpellOnCell(12730, cellid)
		end
	end
end

local function Assaut()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12733, fightAction:getNearestEnemy()) == 0 then 
		fightAction:castSpellOnCell(12745, fightAction:getNearestEnemy())
	end
end

local function Ravage()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12746, fightAction:getNearestEnemy()) == 0 then 
		fightAction:castSpellOnCell(12745, fightAction:getNearestEnemy())
	end
end

local function Hostilite()			
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12756, fightAction:getNearestEnemy()) == 0 then 
		fightAction:castSpellOnCell(12756, fightAction:getNearestEnemy())
	end	
end

local function Courrone_Epine()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12761, fightCharacter:getCellId()) == 0 then 
		fightAction:castSpellOnCell(12761, fightCharacter:getCellId())
	end	
end

local function BainDeSang()
	if fightCharacter:getAP() > 3 then
		local canLaunch = false
		local idCellTouched = fightAction:getCells_square(fightCharacter:getCellId(), 0, 1)
		local entities = fightAction:getAllEntities()
		for _, entity in ipairs(entities) do
			for _, cellid in ipairs(idCellTouched) do
				if entity.CellId == cellid and entity.Team then
					canLaunch = true
					break
				end
			end
		end
		if canLaunch and fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12732, fightCharacter:getCellId()) == 0 then 
			fightAction:castSpellOnCell(12732, fightCharacter:getCellId())
		end	
	end
end

local function Deplacement()
	if fightAction:isHandToHand(fightCharacter:getCellId(), fightAction:getNearestEnemy()) == false and fightCharacter:getMP() > 0 then
		fightAction:moveTowardCell(fightAction:getNearestEnemy())
	end
end


local function Epee_Vorace(cellid)
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12744, cellid) == 0 then 
		fightAction:castSpellOnCell(12744, cellid)
	end
end

local function LaunchEpee_Vorace()
    local cellid = fightAction:getCells_cross(fightCharacter:getCellId(), 1, 3)
    table.sort(cellid, function(a, b) return fightAction:getDistance(a, fightAction:getNearestEnemy()) < fightAction:getDistance(b, fightAction:getNearestEnemy()) end)

    for i = 1, (fightCharacter:getAP() >= 3) and #cellid or 0 do
        if cellid[i] ~= nil and fightCharacter:getAP() >= 3 and fightAction:isWalkable(cellid[i]) and fightAction:isFreeCell(cellid[i]) then
            Epee_Vorace(cellid[i])
        end
    end
end

local function GetEntitiesAdjacents()
    local toReturn = 0
    local idCellTouched = fightAction:getCells_cross(fightCharacter:getCellId(), 1, 1)
    local entities = fightAction:getAllEntities()
    for _, entity in ipairs(entities) do
        for _, cellid in ipairs(idCellTouched) do
            if entity.CellId == cellid and entity.Team then
                toReturn = toReturn + 1
                break
            end

        end
    end
    return toReturn
end

local function Abandon()
    global:printSuccess("abandon")
    local message = developer:createMessage("GameContextQuitMessage")
    developer:sendMessage(message)
end

function prefightManagement(challengers, defenders)
	local DistanceEmplacement = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

	local i = 1
	for cell1, id1 in pairs(challengers) do
		for cell2, id2 in pairs(defenders) do
			if id2 ~= -1 then
				DistanceEmplacement[i] = DistanceEmplacement[i] + map:cellDistance(cell1, cell2)
			end
		end
		i = i + 1
	end

	local IndexMinimale = 0
	local distanceMinimale = 10000

	for index, element in ipairs(DistanceEmplacement) do
		if element < distanceMinimale then
			distanceMinimale = DistanceEmplacement[index]
			IndexMinimale = index
		end
	end
	i = 1
	for cell, id in pairs(challengers) do
    	if i == IndexMinimale then
    	    fightAction:chooseCell(cell)
			break
    	end
		i = i + 1
	end
end

function fightManagement()
		-- Je vérifie dans un premier temps que c'est bien à moi de jouer :
			local cellId = fightCharacter:getCellId()

		if fightCharacter:getLevel()>=10 then

			if  fightCharacter:isItMyTurn() == true then
				
				
				if fightAction:getCurrentTurn() == 1 then
					lancable = 0
					incrementation = 0
				elseif fightAction:getCurrentTurn() > 100 then
					Abandon()
				end

				-- J'avance vers mon ennemi le plus proche
				Deplacement()
				-- lancement mutilation
				
				cellId = fightCharacter:getCellId()
				local mutilation = 12737
				
				if lancable == 0  then 
					if incrementation == 1 then
						if fightCharacter:getAP() > 5 then
							BainDeSang()
						end
						if fightCharacter:getAP() > 4 and fightCharacter:getLevel() >= 22 then
							Ravage()
						end
					end
					fightAction:castSpellOnCell(mutilation,cellId)
					incrementation = (incrementation == 0) and 1 or 0
					lancable = lancable + incrementation
				else
					lancable = lancable - 1
				end
				
				if fightCharacter:getLevel() > 14 then
					if fightCharacter:getAP() > 5 and fightCharacter:getLevel() >= 22 then
						Ravage()
					end
					LaunchEpee_Vorace()
				end
				-- lancement bain de sang

				BainDeSang()	
				
				if (fightCharacter:getLifePointsP() < 40) and (GetEntitiesAdjacents() > 0) and (fightCharacter:getLevel() > 44) then
					Courrone_Epine()
				end
				
				-- J'avance vers mon ennemi le plus proche
				Deplacement()
				
				-- lancement ravage
				if fightCharacter:getLevel() >= 22 then
					Ravage()
				end

				if (fightCharacter:getLifePointsP() < 40) and (GetEntitiesAdjacents() > 0) and (fightCharacter:getLevel() > 44) then
					Courrone_Epine()
				end
				
				-- lancement douleur cuisante
				
				Douleur_Cuisante()
				Douleur_Cuisante()

				-- lancement assaut
				if fightCharacter:getLevel() > 39 then
					Hostilite()
				elseif fightCharacter:getLevel() > 25 then
					local entities = fightAction:getAllEntities()
					local cpt = 0
					for _,entity in ipairs(entities) do
						if fightAction:isHandToHand(fightCharacter:getCellId(), entity.CellId) then
							cpt = cpt + 1
						end
					end
					if cpt <= 2 then
						Assaut()
					end	
				end
				
				Hemmoragie(fightAction:getNearestEnemy())

				Deplacement()
			end			
		else
			if (fightCharacter:isItMyTurn() == true) then
				-- J'avance vers mon ennemi le plus proche
				Deplacement()

					
				Hemmoragie(fightAction:getNearestEnemy())
				Deplacement()
				Hemmoragie(fightAction:getNearestEnemy())

				if fightCharacter:getLevel() > 5 then
					Douleur_Cuisante()
					Douleur_Cuisante()
				end
				Attirance(fightAction:getNearestEnemy())

				Hemmoragie(fightAction:getNearestEnemy())
				Deplacement()
				Hemmoragie(fightAction:getNearestEnemy())

			end
		end	
end


