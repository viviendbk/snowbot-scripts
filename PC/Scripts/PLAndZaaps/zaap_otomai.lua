dofile("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Lib\\IMPORT_LIBRARIES.lua")


go = false
go2 = false
ok = true

AUTO_DELETE = {2549 ,16826, 6926, 6929, 6908, 6928, 792, 16358, 16824, 398, 1672, 16835, 2302, 2303, 464, 16835, 8518, 2583, 463, 437, 1690, 2573, 407, 387, 386, 435, 434, 2576, 16830, 6910, 6909, 652, 6910, 16825, 16825, 2414, 2422, 383 , 2455 , 16819 , 1731 , 6921 , 6920 , 6919 , 6922 , 911 , 2419 ,2428 , 2425 , 2416 , 2411 , 892 ,16832 , 6794 , 6792 , 6796 , 8247,16829,8245,8248,8246,8223,8229,8217,8236,8241, 417, 384, 2858, 679, 16827, 16823, 380, 994, 995, 993, 311, 16833, 2585, 381, 1528, 1529, 1526, 1527, }


local scriptPath = "C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Recolte\\Bucheron_1_200.lua"


local tableEquip = {
	{name = "gelocoiffe", id = 2447, emplacement = 6, equipe = false},
	{name = "amulette blop griotte", id = 9149, emplacement = 0, equipe = false},
	{name = "ceinture blop griotte", id = 9167, emplacement = 3, equipe = false},
	{name = "cape rebelles", id = 27523, emplacement = 7, equipe = false},
	{name = "bottes rebelles", id = 27522, emplacement = 5, equipe = false},
	{name = "arme sasa", id = 478, emplacement = 1, equipe = false},
	{name = "anneau rebelles", id = 27524, emplacement = 2, equipe = false},
	{name = "gelano", id = 2469, emplacement = 4, equipe = false},
	{name = "trophet 1", id = 13748, equipe = false, emplacement = 9},
	{name = "dofus cawotte", id = 972, equipe = false, emplacement = 10},
	{name = "trophet 4", id = 13793, equipe = false, emplacement = 11},
    {name = "dofus argenté", id = 19629, emplacement = 12, equipe = false},
	--{Type = "compagnon", id = 14966, equipe = false, emplacement = 28}
}

function havresac()
    if global:thisAccountController():getAlias():find("LvlUp") and inventory:itemCount(469) > 0 then
        inventory:equipItem(469, 1)
    end
    for _, element in ipairs(AUTO_DELETE) do
        inventory:deleteItem(element, inventory:itemCount(element))
    end
    if map:onMap("-44,21") then
        go2 = true
    end
    ok = false
    map:changeMap("havenbag")
end


function bateau3()
    npc:npc(3464,3)
    npc:reply(-1)
end
function otomai_1()
    global:printSuccess("[INFO] - Lancement de la quête : [Le nouveau monde].")
    npc:npc(925,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:delay(2000)
    npc:npc(925,3)
    npc:reply(-1)
    global:leaveDialog()
    global:delay(2000)
    npc:npc(925,3)
    npc:reply(-1)
end

function otomai_2()
    npc:npc(925,3)
    npc:reply(-1)    
end

function otomai_3()
	go = true
    global:printSuccess("LANCEMENT DE LA QUÊTES : L'ÎLE DES NAUFRAGÉS")
    npc:npc(925,3)
	
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    map:changeMap("left")
end

function otomai_4()
   go2 = true
    npc:npc(925,3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()
    npc:npc(925,3)
    npc:reply(-1)
end

function buy_ressources()
    npc:npc(-1,6)

    while inventory:itemCount(429) < 2 do
        global:printSuccess("1")
        --Point de chafer d'elite
        sale:buyItem(429,1,10000000)
		if(inventory:itemCount(429) < 2) then
			sale:buyItem(429,10,10000000)
		end
    end

    while inventory:itemCount(2553) < 1 do
        global:printSuccess("2")

        --Gros boulet
        sale:buyItem(2553,1,10000000)
    end

    while inventory:itemCount(2551) < 1 do
        global:printSuccess("3")

        --Oreille de Foufayteur
        sale:buyItem(2551,1,20000000)
		if(inventory:itemCount(2551) < 1) then
			sale:buyItem(2551,10,10000000)
		end
    end

    while inventory:itemCount(399) < 1 do
        global:printSuccess("4")

        --Huile de sésame
        sale:buyItem(399,1,10000000)
		if(inventory:itemCount(399) < 1) then
			sale:buyItem(399,10,10000000)
		end
    end

    while inventory:itemCount(1002) < 1 do
        global:printSuccess("5")

        --Tronc de kokoko
        sale:buyItem(1002,1,10000000)
		if(inventory:itemCount(1002) < 1) then
			sale:buyItem(1002,10,10000000)
		end
    end

    while inventory:itemCount(8759) < 1 do
        global:printSuccess("6")

        --Coffret maudit du Flib
        sale:buyItem(8759,1,10000000)
		if(inventory:itemCount(8759) < 1) then
			sale:buyItem(8759,10,10000000)
		end
    end

    while inventory:itemCount(2618) < 1 do
        global:printSuccess("7")

        --Kokopaille
        sale:buyItem(2618,1,10000000)
		if(inventory:itemCount(2618) < 1) then
			sale:buyItem(2618,10,10000000)
		end
    end

    while inventory:itemCount(2617) < 1 do
        global:printSuccess("8")

        --Tranche de nodkoko
        sale:buyItem(2617,1,10000000)
		if(inventory:itemCount(2617) < 1) then
			sale:buyItem(2617,10,10000000)
		end
    end

    global:leaveDialog()

end

function pnjastrub()
    npc:npc(4398, 3)
    npc:reply(-1)
    npc:reply(-1)
end

function bateau1()
    npc:npc(134,3)
    npc:reply(-1)
    npc:reply(-1)
end

function bateau2()
    npc:npc(136,3)
    npc:reply(-1)
end

function switch()
    global:printSuccess("on change de script")
    if global:thisAccountController():getAlias():find("LvlUp") then
        global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Combat\\PL_6X-114.lua")
    else
        global:loadAndStart(scriptPath)
    end
end

local function equiper()
	for _, element in ipairs(tableEquip) do
		if not element.equipe and inventory:itemCount(element.id) >= 1 then
			inventory:equipItem(element.id, element.emplacement)
			element.equipe = true
		end
	end
 -- Amulette 0 Arme 1 Anneau (gauche) 2 Ceinture 3 Anneau (droite) 4 Bottes 5 Chapeau 6 cape 7
end


function move()
    mapDelay()
	if not equipFait then
		equiper()
		equipFait = true
	end


		-- if job:level(2) >= 10 then
		-- 	global:loadAndStart(scriptPath)
        -- elseif character:level() >= 190 and not global:thisAccountController():getAlias():find("Groupe") then
        --     global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Combat\\PL_6X-114.lua")
        -- end
		if ok == true then havresac()
		end
		
		if go2 == true then
		return {
            { map = "-44,21", path = "left" },
            { map = "-45,21", path = "top" },
            { map = "-45,20", path = "left" },
            { map = "-46,20", path = "top" },
            { map = "-46,19", path = "top" },
            { map = "-46,18", custom = switch },
			}
		end
			if inventory:itemCount(1002) >= 1 and inventory:itemCount(8759) >= 1 and inventory:itemCount(2618) >= 1 and inventory:itemCount(2617) >= 1  and go == true then
            return{
                { map = "-44,2", path = "right" },
                { map = "153090", custom = otomai_4 },
            }
			end
        return{
			{ map = "0,0", path = "zaap(88085249)" },
            { map = "5,-18", path = "bottom" },
            { map = "5,-17", path = "bottom" },
            { map = "5,-16", path = "bottom" },
            { map = "5,-15", path = "bottom" },
            { map = "5,-14", path = "bottom" },
            { map = "5,-13", path = "bottom" },
            { map = "5,-12", path = "bottom" },
            { map = "5,-11", path = "bottom" },
            { map = "5,-10", path = "bottom" },
            { map = "5,-9", path = "left" },
            { map = "4,-9", path = "bottom" },
            { map = "4,-8", path = "bottom" },
            { map = "4,-7", path = "bottom" },
            { map = "4,-6", path = "bottom" },
            { map = "4,-5", path = "bottom" },
            { map = "4,-4", path = "bottom" },
            { map = "4,-3", path = "bottom" },
            { map = "4,-2", path = "right" },
            { map = "5,-2", path = "right" },
            { map = "6,-2", path = "right" },
            { map = "15,-58", path = "bottom" },
            { map = "15,-57", path = "bottom" },
            { map = "15,-56", path = "left" },
            { map = "14,-56", path = "bottom" },
            { map = "14,-55", custom = bateau3 },
            { map = "12,-6", path = "left" },
            { map = "11,-6", path = "bottom" },
            { map = "11,-5", path = "left" },
            { map = "10,-5", path = "left" },
            { map = "9,-5", path = "bottom" },
            { map = "9,-4", path = "bottom" },
            { map = "9,-3", path = "left" },
            { map = "8,-3", path = "left" },
            { map = "7,-3", path = "bottom" },
            { map = "7,-2", path = "bottom" },
            { map = "7,-1", path = "bottom" },
            { map = "7,0", path = "bottom" },
            { map = "7,1", path = "bottom" },
            { map = "7,2", path = "bottom" },
            { map = "7,3", path = "bottom" },
            { map = "7,4", path = "bottom" },
            { map = "7,5", path = "bottom" },
            { map = "7,6", path = "bottom" },
            { map = "7,7", path = "bottom" },
            { map = "7,8", path = "bottom" },
            { map = "7,9", path = "bottom" },
            { map = "7,10", path = "bottom" },
            { map = "7,11", path = "bottom" },
            { map = "7,12", path = "bottom" },
            { map = "7,13", path = "bottom" },
            { map = "7,14", path = "bottom" },
            { map = "7,15", path = "bottom" },
            { map = "7,16", path = "bottom" },
            { map = "7,17", path = "bottom" },
            { map = "7,18", path = "bottom" },
            { map = "7,19", path = "bottom" },
            { map = "7,20", path = "bottom" },
            { map = "7,21", path = "bottom" },
            { map = "7,22", path = "right" },
            { map = "8,22", path = "right" },
            { map = "9,22", path = "right" },
            { map = "10,22", path = "right" },
            { map = "11,22", path = "right" },
            { map = "12,22", path = "right" },
            { map = "13,22", path = "right" },
            { map = "14,22", path = "right" },
            { map = "15,22", path = "right" },
            { map = "16,22", path = "bottom" },
            { map = "16,23", path = "left" },
            { map = "15,23", path = "bottom" },
            { map = "15,24", path = "right" },
            { map = "16,24", path = "right" },
            { map = "17,24", path = "right" },
            { map = "18,24", path = "right" },
            { map = "19,24", path = "right" },
            { map = "20,24", path = "right" },
            { map = "21,24", path = "top" },
            { map = "21,23", custom = buy_ressources, path = "right" },
            { map = "22,23", path = "zaapi(90703364)" },
            { map = "12,29", path = "right" },
            { map = "13,29", path = "right" },
            { map = "14,29", path = "top" },
            { map = "14,28", path = "right" },
            { map = "15,28", custom = otomai_1 },
            { map = "26214400", forcefight = true },
            { map = "26215424", forcefight = true },
            { map = "26216448", forcefight = true },
            { map = "26217472", custom = otomai_2 },
            { map = "153090", custom = otomai_3 },
			}
end

function stopped()
    global:finishScript()
end

function bank()
    return move()
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
                if incrementation == 1 then
                    Absorption(WeakerMonsterAdjacent())
					if fightCharacter:getAP() > 4 then
                        Absorption(WeakerMonsterAdjacent())
					end
                end

                fightAction:castSpellOnCell(12737,fightCharacter:getCellId())
                incrementation = (incrementation == 0) and 1 or 0
                lancable = lancable + incrementation
            else
                lancable = lancable - 1
            end

            LaunchEpee_Vorace()

            -- J'avance vers mon ennemi le plus proche
            Deplacement()


            Absorption(WeakerMonsterAdjacent())
            Absorption(WeakerMonsterAdjacent())

             -- lancement douleur cuisante

            Hemmoragie()

            Hostilite(WeakerMonsterAdjacent())
            
            Deplacement()

        end	
end
