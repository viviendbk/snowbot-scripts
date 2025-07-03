dofile("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Lib\\IMPORT_LIBRARIES.lua")


MARTOA = false
SHERPOA = 0
DOUZDOA = 0
PIKDOA = 0
local CompteurDeath = 0

RESSOURCES = {
    { id = 885, quantity = 5 },
    { id = 421, quantity = 50 },
}

local function increment()
    ETAPE_PANDALA = math.floor(tonumber(global:remember("ETAPE_PANDALA")) + 1)
    global:editInMemory("ETAPE_PANDALA", ETAPE_PANDALA)
    AVANCEMENT = math.floor((tonumber(global:remember("ETAPE_PANDALA"))/36)*100)
    global:printSuccess("[INFO] - Avancement du script a ".. AVANCEMENT .."%")
end

local function restat(acc)
    local accDeveloper = acc and acc.developer or developer

    accDeveloper:sendMessage(developer:createMessage("ResetCharacterStatsRequestMessage"))
    developer:suspendScriptUntil("CharacterStatsListMessage", 500, false)
end

local function pandala_1()
    increment()
    global:printSuccess("[INFO] - lancement de la quête : [Le reveil de Pandala]")
    global:resetCountFight()
    npc:npc(5604,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    restat()

    upgradeCharacteristics(150, 0,  0, calculCharacteristicsPointsToSet(character:level() * 5 - 155))

    map:changeMap("bottom")
end

local function pandala_2()
    increment()
    npc:npc(5604,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    if global:thisAccountController():getAlias():find("LvlUp") then
        restat()
        upgradeCharacteristics(0, 0,  character:level() * 5 / 3)

    end
    map:changeMap("left")
end

local function pandala_3()
    increment()
    npc:npc(4334,3)
    npc:reply(-2)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    map:changeMap("right")  
end

local function pandala_4()
    increment()
    npc:npc(4344,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    map:moveToCell(396) 
end

local function pandala_5()
    increment()
    npc:npc(4319,3)
    npc:reply(-2)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    map:changeMap("top")
end

local function pandala_6()
    increment()
    map:door(270)
    craft:putItem(885,5)
    craft:putItem(421,50)
    craft:putItem(23038,1)
    craft:ready()
    global:leaveDialog()
    map:moveToCell(396)
end

local function pandala_7()
    increment()
    npc:npc(4334,3)
    npc:reply(-2)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    map:changeMap("right")  
end

local function pandala_8()
    npc:npc(5605,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:delay(1000)
    inventory:useItem(23043)
end

local function pandala_9()
    npc:npc(5677,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    map:moveToCell(429)
end

local function pandala_10()
    map:saveZaap()
    global:printSuccess("[INFO] - Fin de la quête : [Le réveil de Pandala]")
    global:printSuccess("[INFO] - Les script est terminé, à vous les zaaps !")
	global:delay(2000)
    global:deleteAllMemory()
    if global:thisAccountController():getAlias():find("Bucheron") then
        global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\PLAndZaaps\\zaap_otomai.lua")
    elseif global:thisAccountController():getAlias():find("Mineur") then
        global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Recolte\\Mineur_1-150_ULTIME.lua")
    elseif global:thisAccountController():getAlias():find("Groupe") then
        global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\PLAndZaaps\\zaapArbreHakam.lua")
    else
        global:disconnect()
    end
    global:finishScript()
end

local function count()
    local combat = global:getCountFight() - CompteurDeath
    if combat == 5 then
        MARTOA = true
        SHERPOA = false
    elseif combat == 10 then
        SHERPOA = true
        DOUZDOA = false
    elseif combat == 15 then
        DOUZDOA = true
        PIKDOA = false
    elseif combat == 20 then
        PIKDOA = true
    end
end

local function CheckEndFight(message)
    if not message.results[1].alive then
        CompteurDeath = CompteurDeath + 1
    end
end

function messagesRegistering()
    developer:registerMessage("GameFightEndMessage", CheckEndFight)
end

function buy_ressources()

    HdvBuy()

    while inventory:itemCount(885) < 5 do
        achat(885, 5)
    end

    while inventory:itemCount(421) < 50 do
        achat(421, 50)
    end

    global:leaveDialog()

    for i, item in pairs(RESSOURCES) do
		if inventory:itemCount(item.id) < item.quantity then
			global:printError("[ERREUR] - Vous n'avez pas les kamas necessaires pour acheter les ressources.")
			global:finishScript()
		end
	end
end

local function treatMaps(maps, errorFn)
    errorFn = errorFn or function() map:changeMap("havenbag") end

    local msg = "[Erreur] - Aucune action à réaliser sur la map, on va dans le havre-sac"

    for _, element in ipairs(maps) do
        local condition = map:onMap(element.map) 

        if condition then
            return {element}
        end
    end

    increment()
    return move()
end


function move()
    mapDelay()
    if map:currentMapId() == 192415750 then
        map:moveToCell(409)
    end
    if job:level(24) >= 6 then
        global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Recolte\\Mineur_1-150_ULTIME.lua")
    elseif job:level(2) >= 6 then
        global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Recolte\\Bucheron_1_200.lua")
    elseif global:thisAccountController():isItATeam() and global:isBoss() then
        global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\PLAndZaaps\\zaapArbreHakam.lua")
    end

    if getCurrentAreaName():find("Pandala") then
        if not global:remember("ETAPE_PANDALA") then
            global:addInMemory("ETAPE_PANDALA", 8)
        else
            global:editInMemory("ETAPE_PANDALA", 8)
        end
    end

    if not getCurrentAreaName():find("Astrub") and not getCurrentAreaName():find("Pandala") then
        if map:onMap("0,0") then
            return map:changeMap("zaap(191105026)")
        else
            return map:changeMap("havenbag")
        end
    end


    if global:remember("ETAPE_PANDALA") == nil then
        global:addInMemory("ETAPE_PANDALA", (quest:questCurrentStep(2149) == 2805) and 2 or 1)
    end

    local objectifsDone = quest:questDoneObjectives(2149)

    if objectifsDone and #objectifsDone == 8 then
        global:editInMemory("ETAPE_PANDALA", 7) 
    elseif objectifsDone and #objectifsDone == 9 then
        global:editInMemory("ETAPE_PANDALA", 8) 
    elseif objectifsDone and #objectifsDone == 7 then
        if inventory:itemCount(23038) > 0 then -- si il a l'échantillon de sang pour le serum
            global:editInMemory("ETAPE_PANDALA", 6)
        else
            global:editInMemory("ETAPE_PANDALA", 5) 
        end
    elseif objectifsDone and #objectifsDone == 4 then
        global:editInMemory("ETAPE_PANDALA", 2.5)
    elseif objectifsDone and #objectifsDone == 5 then
        global:editInMemory("ETAPE_PANDALA", 3)
    end

    global:printSuccess(tonumber(global:remember("ETAPE_PANDALA")))

    if tonumber(global:remember("ETAPE_PANDALA")) == 1 then
        return treatMaps({
            { map = "5,-18", path = "left" },
            { map = "4,-18", path = "bottom" },
            { map = "4,-17", custom = buy_ressources, path = "left" },
            { map = "3,-17", path = "156" }, -- anciennement top mais bugué
            { map = "3,-18", path = "top" },
            { map = "3,-19", path = "right" },
            { map = "4,-19", path = "top" },
            { map = "4,-20", path = "right" },
            { map = "5,-20", path = "right" },
            { map = "6,-20", path = "right" },
            { map = "7,-20", path = "right" },
            { map = "8,-20", path = "right" },
            { map = "9,-20", path = "right" },
            { map = "10,-20", path = "right" },
            { map = "11,-20", path = "right" },
            { map = "12,-20", path = "top" },
            { map = "12,-21", custom = pandala_1 },
        })
    elseif tonumber(global:remember("ETAPE_PANDALA")) == 2 then
        count()
        global:printSuccess("ok1")
        local objectifs = quest:questRemainingObjectives(2149)
        local dicoCorrespondances = {["16310"] = 5228, ["16311"] = 5229, ["16312"] = 5230, ["16313"] = 5231}
        global:printSuccess("ok1")

        for _, element in ipairs(objectifs) do
            global:printSuccess(element)
            if dicoCorrespondances[tostring(element)] then
                FORCE_MONSTERS = {dicoCorrespondances[tostring(element)]}
                MIN_MONSTERS = 1
                MAX_MONSTERS = 3
                return{
                    {map = "2,-14", path = "top"},
                    {map = "5,-15", path = "top"},
                    {map = "5,-16", path = "top"},
                    {map = "5,-17", path = "top"},
                    {map = "5,-18", path = "right"},
                    {map = "2,-15", path = "right"},
                    {map = "3,-15", path = "right"},
                    {map = "4,-15", path = "right"},
                    { map = "12,-20", path = "bottom", fight = true },
                    { map = "12,-19", path = "bottom", fight = true },
                    { map = "12,-18", path = "bottom", fight = true },
                    { map = "12,-17", path = "bottom", fight = true },
                    { map = "12,-16", path = "bottom", fight = true },
                    { map = "12,-15", path = "left", fight = true },
                    { map = "11,-15", path = "left", fight = true },
                    { map = "10,-15", path = "left", fight = true },
                    { map = "9,-15", path = "left", fight = true },
                    { map = "8,-15", path = "top", fight = true },
                    { map = "8,-16", path = "right", fight = true },
                    { map = "9,-16", path = "right", fight = true },
                    { map = "10,-16", path = "right", fight = true },
                    { map = "11,-16", path = "top", fight = true },
                    { map = "11,-17", path = "left", fight = true },
                    { map = "10,-17", path = "left", fight = true },
                    { map = "9,-17", path = "left(112)", fight = true },
                    { map = "8,-17", path = "top", fight = true },
                    { map = "8,-18", path = "right", fight = true },
                    { map = "9,-18", path = "right(489)", fight = true },
                    { map = "10,-18", path = "right", fight = true },
                    { map = "11,-18", path = "top", fight = true },
                    { map = "11,-19", path = "top", fight = true },
                    { map = "11,-20", path = "left", fight = true },
                    { map = "10,-20", path = "left", fight = true },
                    { map = "9,-20", path = "left", fight = true },
                    { map = "8,-20", path = "top", fight = true },
                    { map = "8,-21", path = "right", fight = true },
                    { map = "9,-21", path = "right", fight = true },
                    { map = "10,-21", path = "right", fight = true },
                    { map = "11,-21", path = "right", fight = true },
                    { map = "12,-21", path = "bottom", fight = true },
                    { map = "5,-18", path = "right", fight = true },
                    { map = "6,-18", path = "right", fight = true },
                    { map = "7,-18", path = "right", fight = true },
                    { map = "6,-19", path = "bottom", fight = true },
                    { map = "12,-20", path = "bottom", fight = true },
                    { map = "12,-19", path = "bottom", fight = true },
                    { map = "12,-18", path = "bottom", fight = true },
                    { map = "12,-17", path = "bottom", fight = true },
                    { map = "12,-16", path = "bottom", fight = true },
                    { map = "12,-15", path = "left", fight = true },
                    { map = "11,-15", path = "left", fight = true },
                    { map = "10,-15", path = "left", fight = true },
                    { map = "9,-15", path = "left", fight = true },
                    { map = "8,-15", path = "top", fight = true },
                    { map = "8,-16", path = "right", fight = true },
                    { map = "9,-16", path = "right", fight = true },
                    { map = "10,-16", path = "right", fight = true },
                    { map = "11,-16", path = "top", fight = true },
                    { map = "11,-17", path = "left", fight = true },
                    { map = "10,-17", path = "left", fight = true },
                    { map = "9,-17", path = "left(112)", fight = true },
                    { map = "8,-17", path = "top", fight = true },
                    { map = "8,-18", path = "right", fight = true },
                    { map = "9,-18", path = "right(489)", fight = true },
                    { map = "10,-18", path = "right", fight = true },
                    { map = "11,-18", path = "top", fight = true },
                    { map = "11,-19", path = "top", fight = true },
                    { map = "11,-20", path = "left", fight = true },
                    { map = "10,-20", path = "left", fight = true },
                    { map = "9,-20", path = "left", fight = true },
                    { map = "8,-20", path = "top", fight = true },
                    { map = "8,-21", path = "right", fight = true },
                    { map = "9,-21", path = "right", fight = true },
                    { map = "10,-21", path = "right", fight = true },
                    { map = "11,-21", path = "right", fight = true },
                    { map = "12,-21", path = "bottom" },
                    { map = "5,-18", path = "right", fight = true },
                    { map = "6,-18", path = "right", fight = true },
                    { map = "7,-18", path = "right", fight = true },
                    { map = "6,-19", path = "bottom", fight = true },
                }
            end
        end
        global:editInMemory("ETAPE_PANDALA", 2.5)
                return{
            { map = "8,-21", path = "right" },
            { map = "8,-20", path = "right" },
            { map = "8,-18", path = "right" },
            { map = "8,-17", path = "right(83)" },
            { map = "8,-16", path = "right" },
            { map = "8,-15", path = "right" },
            { map = "9,-15", path = "right" },
            { map = "9,-16", path = "right" },
            { map = "9,-17", path = "right" },
            { map = "9,-18", path = "right(489)" },
            { map = "10,-18", path = "right" },
            { map = "10,-17", path = "right" },
            { map = "10,-16", path = "right" },
            { map = "10,-15", path = "right" },
            { map = "11,-15", path = "right" },
            { map = "11,-16", path = "right" },
            { map = "11,-17", path = "right" },
            { map = "11,-18", path = "right" },
            { map = "11,-19", path = "right" },
            { map = "9,-21", path = "right" },
            { map = "9,-20", path = "right" },
            { map = "10,-21", path = "right" },
            { map = "10,-20", path = "right" },
            { map = "11,-21", path = "right" },
            { map = "11,-20", path = "right" },
            { map = "12,-15", path = "top" },
            { map = "12,-16", path = "top" },
            { map = "12,-17", path = "top" },
            { map = "12,-18", path = "top" },
            { map = "12,-19", path = "top" },
            { map = "12,-20", path = "top" },
            { map = "12,-19", path = "top" },
            { map = "12,-21", custom = pandala_2 },
            }  

    elseif tonumber(global:remember("ETAPE_PANDALA")) == 2.5 then
        return{
            { map = "8,-21", path = "right" },
            { map = "8,-20", path = "right" },
            { map = "8,-18", path = "right" },
            { map = "8,-17", path = "right(83)" },
            { map = "8,-16", path = "right" },
            { map = "8,-15", path = "right" },
            { map = "9,-15", path = "right" },
            { map = "9,-16", path = "right" },
            { map = "9,-17", path = "right" },
            { map = "9,-18", path = "right(489)" },
            { map = "10,-18", path = "right" },
            { map = "10,-17", path = "right" },
            { map = "10,-16", path = "right" },
            { map = "10,-15", path = "right" },
            { map = "11,-15", path = "right" },
            { map = "11,-16", path = "right" },
            { map = "11,-17", path = "right" },
            { map = "11,-18", path = "right" },
            { map = "11,-19", path = "right" },
            { map = "9,-21", path = "right" },
            { map = "9,-20", path = "right" },
            { map = "10,-21", path = "right" },
            { map = "10,-20", path = "right" },
            { map = "11,-21", path = "right" },
            { map = "11,-20", path = "right" },
            { map = "12,-15", path = "top" },
            { map = "12,-16", path = "top" },
            { map = "12,-17", path = "top" },
            { map = "12,-18", path = "top" },
            { map = "12,-19", path = "top" },
            { map = "12,-20", path = "top" },
            { map = "12,-19", path = "top" },
            { map = "12,-21", custom = pandala_2 },
            }           
    elseif tonumber(global:remember("ETAPE_PANDALA")) == 3 then
        global:printSuccess("3")
        return{
            { map = "11,-21", path = "left" },
            { map = "10,-21", path = "left" },
            { map = "9,-21", path = "left" },
            { map = "8,-21", path = "left" },
            { map = "7,-21", path = "left" },
            { map = "6,-21", path = "left" },
            { map = "5,-21", path = "left" },
            { map = "4,-21", path = "left" },
            { map = "188744705", door = "198" },
            { map = "192417798", custom = pandala_3 },
        }
    elseif tonumber(global:remember("ETAPE_PANDALA")) == 4 then
        global:printSuccess("4")
        return{
            { map = "188744705", door = "412" },
            { map = "192937988", custom = pandala_4 },
        }
    elseif tonumber(global:remember("ETAPE_PANDALA")) == 5 then
        global:printSuccess("5")
        return{
            { map = "192937988", path = "396"},
            { map = "188744705", path = "right" },
            { map = "4,-21", path = "bottom" },
            { map = "4,-20", path = "bottom" },
            { map = "4,-19", path = "bottom" },
            { map = "4,-18", path = "right(447)" },
            { map = "5,-18", path = "right" },
            { map = "191106050", custom = pandala_5 },
        }
    elseif tonumber(global:remember("ETAPE_PANDALA")) == 6 then
        global:printSuccess("6")
        return{
            { map = "6,-18", path = "left" },
            { map = "5,-18", path = "top" },
            { map = "6,-19", path = "left" },
            { map = "5,-19", path = "left" },
            { map = "4,-19", path = "top" },
            { map = "4,-20", path = "top" },
            { map = "4,-21", path = "left" },
            { map = "188744705", door = "412" },
            { map = "192937988", custom = pandala_6 },
        }
    elseif tonumber(global:remember("ETAPE_PANDALA")) == 7 then
        global:printSuccess("7")
        return{
            { map = "192937988", path = "396"},
            { map = "188744705", door = "198" },
            { map = "192417798", custom = pandala_7 },
        }
    elseif tonumber(global:remember("ETAPE_PANDALA")) == 8 then
        global:printSuccess("8")
        return{
            { map = "188744705", path = "right" },
            { map = "3,-21", path = "right" },
            { map = "4,-21", path = "right" },
            { map = "5,-21", path = "right" },
            { map = "6,-21", path = "right" },
            { map = "7,-21", path = "right" },
            { map = "8,-21", path = "right" },
            { map = "9,-21", path = "right" },
            { map = "10,-21", path = "right" },
            { map = "11,-21", path = "right" },
            { map = "12,-21", path = "right" },
            { map = "16,-24", path = "right" },
            { map = "16,-26", path = "right" },
            { map = "19,-28", custom = pandala_8 },
            { map = "207620100", custom = pandala_9 },
            { map = "207619076", custom = pandala_10 },
        }
    end
end

function bank()
    return move()
end

function phenix()
	return PHENIX
end

function stopped()
    global:editInMemory("ETAPE_PANDALA", global:remember("ETAPE_PANDALA") - 1)
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

lancable = 0
incrementation = 0

function fightManagement()
    -- Je vérifie dans un premier temps que c'est bien à moi de jouer :

        if fightCharacter:isItMyTurn() == true then

            if fightAction:getCurrentTurn()==1 then
                lancable = 0
                incrementation = 0
            end
            
            Deplacement()
            -- lancement mutilation
            if lancable == 0 then 
                if incrementation == 2 then
                    Absorption(WeakerMonsterAdjacent())    
                end

                fightAction:castSpellOnCell(12737, fightCharacter:getCellId())
                incrementation = (incrementation == 0) and 2 or 0
                lancable = lancable + incrementation
            else
                lancable = lancable - 1
            end

            LaunchEpee_Vorace()
            -- lancement bain de sang

            --BainDeSang()			

            -- J'avance vers mon ennemi le plus proche
            Deplacement()


            if fightCharacter:getLifePointsP() < 50 then
                Absorption(WeakerMonsterAdjacent())    
                Deplacement()
                Absorption(WeakerMonsterAdjacent())    
            end

             -- lancement douleur cuisante

            Douleur_Cuisante()
            Deplacement()
            Douleur_Cuisante()

            Hostilite(WeakerMonsterAdjacent())
            
            Deplacement()
    
        end	
end
