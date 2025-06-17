---@diagnostic disable: undefined-global, lowercase-global

dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Lib\\IMPORT_LIBRARIES.lua")
dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\FonctionsArchiMonstre.lua")
-- Generated On Dofus-Map with Drigtime's SwiftPath Script Maker --
-- Nom : 
-- Zone : 
-- Type : 
-- Version : 1.0
-- Auteur : 

GATHER = {}
OPEN_BAGS = true
AUTO_DELETE = {14511, 16836, 16821, 16822, 15073 , 11475, 11257, 11253, 11254, 11250, 11251, 16827, 11255, 13512, 2496, 8481 ,16820 ,2497 ,2486, 2306, 18369, 18370, 18411, 16827, 18366, 2305, 7903, 7904, 13731, 16826, 16830 ,8571, 16831 ,8570 ,2251,2495, 10832 ,16819 ,381,311,2584,16823,16828,1674 ,14017,7423,12132,362,364,643,10967,363,2563,6921 ,371 ,6916 ,6917 ,6918 ,6915 ,16835 ,6919 ,6920 ,6922 ,6914 ,1673,6913 ,6912 ,6911 ,16834 ,300 ,16828, 13435 ,7030 ,2566 ,1676 ,2296, 2664, 16823, 544 ,2585, 417,1635,2295, 6928,6927,6929,6908,6909,6926,6910, 2303,16824 ,2302,8518 ,792 ,2583, 434, 435, 437, 2573, 1690, 464, 2576, 387, 407, 463, 1672, 652,398,1467,1528,679,16825, 2507,1526,1527,1529 ,16832,2508,1771
 }

ALL_ARCHI = {2270,2271,2272,2273,2274,2275,2276,2277,2278,2279,2280,2281,2282,2283,2284,2285,2286,2287,2288,2289,2290,2291,2292,2293,2294,2295,2296,2297,2298,2299,2300,2301,2302,2303,2304,2305,2306,2307,2308,2309,2310,2311,2312,2313,2314,2315,2316,2317,2318,2319,2320,2321,2322,2323,2324,2325,2326,2327,2328,2329,2330,2331,2332,2333,2334,2335,2336,2337,2338,2339,2340,2341,2342,2343,2344,2345,2346,2347,2348,2349,2350,2351,2352,2353,2354,2355,2356,2357,2358,2359,2360,2361,2362,2363,2364,2365,2366,2367,2368,2369,2370,2371,2372,2373,2374,2375,2376,2377,2378,2379,2380,2381,2382,2383,2384,2385,2386,2387,2388,2389,2390,2391,2392,2393,2394,2395,2396,2397,2398,2399,2400,2401,2402,2403,2404,2405,2406,2407,2408,2409,2410,2411,2412,2413,2414,2415,2416,2417,2418,2419,2420,2421,2422,2423,2424,2425,2426,2427,2428,2429,2430,2431,2432,2433,2434,2435,2436,2437,2438,2439,2440,2441,2442,2443,2444,2445,2446,2447,2448,2449,2450,2451,2452,2453,2454,2455,2456,2457,2458,2459,2460,2461,2462,2463,2464,2465,2466,2467,2468,2469,2470,2471,2472,2473,2474,2475,2476,2477,2478,2479,2480,2481,2482,2483,2484,2485,2486,2487,2488,2489,2490,2491,2492,2493,2494,2495,2496,2497,2498,2499,2500,2501,2502,2503,2504,2505,2506,2507,2508,2509,2510,2511,2512,2513,2514,2515,2516,2517,2518,2519,2520,2521,2522,2523,2524,2525,2526,2527,2528,2529,2530,2531,2532,2533,2534,2535,2536,2537,2538,2539,2540,2541,2542,2543,2544,2545,2546,2547,2548,2549,2550,2551,2552,2553,2554,2555,2556,2557,2558,2559,2560,2561,2562,2563,2564,2565,2566,2567,2568,2569,2570,2571,2572,2573,2574,2575,2576,2577,2578,2579,2580,2581,2582,2583,2584,2585,2586,2587,2588,2589,2590,2591,2592,2593,2594,2595,2596,2597,2598,2599,2600,2601,2602,2603,2604,2605,2606,2607,2608,2609,2610,2611,2612,2613,2614,2615,2616}

 
FORBIDDEN_MONSTERS = {375, 450, 2428, 4015, 4622, 4618, 5074, 54, 110, 290, 291, 292, 396, 3239, 3240, 108, 459}

MAX_MONSTERS = 8
MIN_MONSTERS = 3

AMOUNT_MONSTERS = {{3620, 0, 2}, {4619, 0, 2}, {4605 , 0, 1}, {836, 0, 2}, {4539, 0, 1}}

-- if global:thisAccountController():getAlias():find("Combat3")  then
--     PLANNING = {16, 17, 18 , 19, 20, 21, 22, 23, 24, 0}
-- elseif global:thisAccountController():getAlias():find("Combat4") then
--     PLANNING = {16, 17, 18 , 19, 20, 21, 22, 23, 24, 0}

-- elseif global:thisAccountController():getAlias():find("Combat2") then
--     PLANNING = {11, 12, 13, 14, 15, 16, 17}
-- else
--     PLANNING = {13, 14, 15, 16, 17}
-- end




local phrase = nil
for i = 1, NB_COMBAT do
    if global:thisAccountController():getAlias():find("Combat" .. i) then
        phrase = "Combat" .. i .. " " .. character:server()
        break
    end
end


local lancable = 0
local incrementation = 0
local CompteurDeath = 0
local StopAchatGoujon = false
local DDToSell = {}
local cptReconnect = 0



local tableBestSortZone3PA = { }
local tableBestSortZone4PA = { }

local function computePriority(entities, spellType)

	-- global:printSuccess(voie)
	local toReturn = 0
	if #entities > 0 then
		for _, entity in ipairs(entities) do
            toReturn = toReturn + 1
		end
	end
    if fightCharacter:getLifePointsP() < 15 and spellType == "burst" then
        toReturn = toReturn / 3
    elseif fightCharacter:getLifePointsP() < 30 and spellType == "burst" then
        toReturn = toReturn / 2
    elseif fightCharacter:getLifePointsP() >= 30 and spellType == "burst" then
        toReturn = toReturn + 0.5
    end
	-- global:printSuccess("fin " .. voie)
	return toReturn
end

local function computeBestSort()
	tableBestSortZone3PA = {
		{
			func = Decimation,
			entitiesInZone = getEntitiesInZone(fightCharacter:getCellId(), 12731, WeakerMonsterAdjacent(), 1, false),
			spellType = "burst",
		},
		{
			func = Supplice,
			entitiesInZone = getEntitiesInZone(fightCharacter:getCellId(), 12725, WeakerMonsterAdjacent(), 1, false),
			spellType = "regen",
		},
	}	

	tableBestSortZone4PA = {
		{
			func = Entaille,
			spellType = "burst",
			entitiesInZone = fightCharacter:getLevel() > 184 and getEntitiesInZone(fightCharacter:getCellId(), 12751, WeakerMonsterAdjacent(), 1, false) or {},
            level = 185
		},
		{
			func = BainDeSang,
			spellType = "regen",
			entitiesInZone = getEntitiesInZone(fightCharacter:getCellId(), 12732, fightCharacter:getCellId(), 0, false),
		},
	}

	-- Now compute the priority for each entry
	for _, entry in ipairs(tableBestSortZone3PA) do
		entry.priority = computePriority(entry.entitiesInZone, entry.spellType)
	end
	for _, entry in ipairs(tableBestSortZone4PA) do
		entry.priority = computePriority(entry.entitiesInZone, entry.spellType)
	end

	table.sort(tableBestSortZone3PA, function(a,b) 
		if #a.entitiesInZone ~= #b.entitiesInZone then
			return #a.entitiesInZone > #b.entitiesInZone
		else
			return a.priority > b.priority
		end
	end)
	table.sort(tableBestSortZone4PA, function(a,b) 
		if #a.entitiesInZone ~= #b.entitiesInZone then
			return #a.entitiesInZone > #b.entitiesInZone
		else
			return a.priority > b.priority
		end
	end)
end

local function launchBestSort3pa()
	computeBestSort()

	-- for _, element in ipairs(tableBestSortZone3PA) do
	-- 	global:printSuccess(element.voie .. " " .. #element.entitiesInZone .. " " .. element.priority)
	-- end

	for _, element in ipairs(tableBestSortZone3PA) do
		-- global:printSuccess("test lancement " .. _ .. " " .. element.voie)
		if #element.entitiesInZone > 0 then
			element.func()
			break
		end
	end
end

local function launchBestSort4pa()
	computeBestSort()
	for _, element in ipairs(tableBestSortZone4PA) do
		if #element.entitiesInZone == 1 and fightAction:isHandToHand(fightCharacter:getCellId(), WeakerMonsterAdjacent()) then
			if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12741, WeakerMonsterAdjacent()) and (fightAction:getCurrentTurn() > 10 or character:level() < 185) then
                local PA = fightCharacter:getAP()
				Punition(WeakerMonsterAdjacent())
                if PA == fightCharacter:getAP() then
                    element.func()
                end
			else
                global:printSuccess("lancement sort 4 pa")
				element.func()
			end
			break
		elseif #element.entitiesInZone > 1 then
			element.func()
			break
		end
	end
end

local function ObjectSetPositionMessage(uid, position)
    local message = developer:createMessage("ObjectSetPositionMessage")
    message.objectUID = uid
    message.position = 63
    message.quantity = 1

    developer:sendMessage(message)
end

local function venteParchoEtRegenEnergie()
    local tableAchatEnergie = {
        {name = "Pain des champs", id = 1737, Price100 = 0 , Price10 = 0, Price1 = 0},
        {name = "Potion axel raide", id = 16722, Price100 = 0, Price10 = 0, Price1 = 0},
        {name = "Potion Raide rêve", id = 11506, Price100 = 0, Price10 = 0, Price1 = 0},
        {name = "Potion Raide izdaide", id = 16414, Price100 = 0, Price10 = 0, Price1 = 0},
        {name = "Estouffade de Morue", id = 16481, Price100 = 0, Price10 = 0, Price1 = 0},
        {name = "Filet Mignon", id = 17199, Price100 = 0, Price10 = 0, Price1 = 0},
        {name = "Aileron de Requin", id = 1838, Price100 = 0, Price10 = 0, Price1 = 0},
        {name = "Daube aux Epices", id = 17195, Price100 = 0, Price10 = 0, Price1 = 0},
        {name = "Mantou", id = 527, Price100 = 0, Price10 = 0, Price1 = 0},
        {name = "Andouillette de Gibier", id = 17203, Price100 = 0, Price10 = 0, Price1 = 0},
        {name = "Espadon Poellé", id = 16485, Price100 = 0, Price10 = 0, Price1 = 0},
        {name = "Aile de Raie", id = 1814, Price100 = 0, Price10 = 0, Price1 = 0},
    }

    for _, element in ipairs(tableAchatEnergie) do
        while inventory:itemCount(element.id) > 0 and character:maxEnergyPoints() - character:energyPoints() ~= 0 do
            inventory:useItem(element.id)
        end
    end

    npc:npc(385, 5)

    global:printSuccess("Check du meilleur prix")

    for i, element in ipairs(tableAchatEnergie) do
        element.Price100 = (sale:getPriceItem(element.id, 3) == nil or sale:getPriceItem(element.id, 3) == 0) and 10000000 or sale:getPriceItem(element.id, 3)
        element.Price10 = (sale:getPriceItem(element.id, 2) == nil or sale:getPriceItem(element.id, 2) == 0) and 1000000 or sale:getPriceItem(element.id, 2)
        element.Price1 =(sale:getPriceItem(element.id, 1) == nil or sale:getPriceItem(element.id, 1) == 0) and 100000 or sale:getPriceItem(element.id, 1)
    end

    global:printSuccess("achat par 100")
    
    if character:kamas() >= 150000 then
        table.sort(tableAchatEnergie, function(a1, a2) return a1.Price100 < a2.Price100 end)
        for _, element in ipairs(tableAchatEnergie) do
            npc:npc(385,6)
    
            if inventory:itemCount(element.id) <= 100 and character:maxEnergyPoints() - character:energyPoints() > 500 and element.Price100 < 100000 then
                sale:buyItem(element.id, 100, 100000)
            end
    
            global:leaveDialog()
    
            while inventory:itemCount(element.id) > 0 and character:maxEnergyPoints() - character:energyPoints() ~= 0 do
                inventory:useItem(element.id)
            end
        end

    end


    table.sort(tableAchatEnergie, function(a1, a2) return a1.Price10 < a2.Price10 end)

    global:printSuccess("Achat par 10")

    for _, element in ipairs(tableAchatEnergie) do
        npc:npc(385,6)

        if inventory:itemCount(element.id) <= 20 and character:maxEnergyPoints() - character:energyPoints() > 500 and element.Price10 < 20000 then
            sale:buyItem(element.id, 10, 20000)
        end

        global:leaveDialog()

        while inventory:itemCount(element.id) > 0 and character:maxEnergyPoints() - character:energyPoints() ~= 0 do
            inventory:useItem(element.id)
        end
    end
    
    if character:maxEnergyPoints() - character:energyPoints() > 500 then
        table.sort(tableAchatEnergie, function(a1, a2) return a1.Price1 < a2.Price1 end)
        
        global:printSuccess("Achat par 1")
        
        npc:npc(385,6)

        for _, element in ipairs(tableAchatEnergie) do
            if inventory:itemCount(element.id) <= 20 and character:maxEnergyPoints() - character:energyPoints() > 500 and element.Price1 <= 2000 then
                sale:buyItem(element.id, 1, 2000)
                sale:buyItem(element.id, 1, 2000)
                sale:buyItem(element.id, 1, 2000)
                sale:buyItem(element.id, 1, 2000)
            end
    
            global:leaveDialog()
    
            while inventory:itemCount(element.id) > 0 and character:maxEnergyPoints() - character:energyPoints() ~= 0 do
                inventory:useItem(element.id)
            end
        end
    end

    global:printSuccess("Vente de parchos")

	npc:npc(385,5)
	global:delay(500)

    local Priceitem = sale:getPriceItem(678, 3)
    while inventory:itemCount(678) >= 100 and sale:availableSpace() > 0 do 
        Priceitem = (Priceitem == nil or Priceitem == 0 or Priceitem == 1) and sale:getAveragePriceItem(678, 3) * 1.5 or Priceitem
        sale:SellItem(678, 100, Priceitem - 1) 
        global:printSuccess("1 lot de " .. 100 .. " x " .. inventory:itemNameId(678)  .. " à " .. Priceitem - 1 .. "kamas")
    end

    local Priceitem = sale:getPriceItem(680, 2)
    while inventory:itemCount(680) >= 10 and sale:availableSpace() > 0 do 
        Priceitem = (Priceitem == nil or Priceitem == 0 or Priceitem == 1) and sale:getAveragePriceItem(680, 2) * 1.5 or Priceitem
        sale:SellItem(680, 10, Priceitem - 1) 
        global:printSuccess("1 lot de " .. 10 .. " x " .. inventory:itemNameId(680)  .. " à " .. Priceitem - 1 .. "kamas")
    end

	global:delay(500)
	global:leaveDialog()
	map:changeMap("left")
end

local AreaEnergieAndSellParcho = {
	{map = "0,0", path = "zaap(212600323)"},
	{map="212600323", path = "bottom"},
	{map="-31,-55", path = "bottom"},
	{map = "-31,-53", custom = venteParchoEtRegenEnergie}, 
	{map="-31,-54", path = "bottom"},
}


local RatBonta1 = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "212600323", path = "left"},
    {map = "-32,-56", path = "top"},
    {map = "-32,-57", path = "top"},
    {map = "-32,-58", door = "523"},
    {map = "216269574", fight = true, door = "402"},

    {map = "216269572", fight = true, path = "left"},
	{map = "216400644", fight = true, path = "left"},
	{map = "216401668", fight = true, path = "top"},
	{map = "216401670", fight = true, door = "259"},
	{map = "216401672", fight = true, path = "right"},
	{map = "216400648", fight = true, path = "right"},
}

local RatBonta2 = {
    {map = "216269576", fight = true, path = "left"},
    {map = "216400648", fight = true, path = "left"},
    {map = "216401672", fight = true, door = "468"},
    {map = "216269570", fight = true, path = "bottom"},
    {map = "216401668", fight = true, path = "right"},
    {map = "216400644", fight = true, path = "right"},
    {map = "216269572", fight = true, door = "484"},
    {map = "216401670", fight = true, path = "bottom"},
    {map = "216269312", fight = true, path = "left"},
    {map = "216400384", fight = true, path = "left"},
    {map = "216401408", fight = true, door = "520"},
    {map = "216401410", fight = true, door = "215"},
}

local RatBrakmar = {
    {map = "0,0", path = "zaap(212861955)"},
    {map = "-26,37", path = "right"},
    {map = "-25,37", path = "bottom"},
    {map = "-25,38", path = "bottom"},
    {map = "-25,39", door = "233"},
    {map = "216924682", fight = true, path = "right"},
    {map = "216793610", fight = true, path = "right"},
    {map = "216794632", fight = true, door = "262"},
    {map = "216794630", fight = true, path = "right"},
    {map = "216795142", fight = true, path = "top"},
    {map = "216795141", fight = true, path = "left"},
    {map = "216794629", fight = true, path = "top"},
    {map = "216794627", fight = true, path = "top"},
    {map = "216794625", fight = true, path = "left"},
    {map = "216793601", fight = true, path = "left"},
    {map = "216924673", fight = true, door = "466"},
    {map = "219415040", fight = true, path = "left"},
    {map = "216925697", fight = true, path = "left(532)"},
    {map = "216926723", fight = true, door = "534"},
    {map = "216926725", fight = true, path = "bottom"},
    {map = "216926727", fight = true, path = "bottom"},
    {map = "216926729", fight = true, path = "right"},
}

local CanyonSauvage1 = {
    {map = "0,0", path = "zaap(73400320)"},
    {map = "-16,1", path = "bottom"},
    {map = "-16,2", path = "bottom"},
    {map = "-16,3", path = "bottom"},
    {map = "-16,4", path = "bottom"},
    {map = "-16,5", path = "bottom"},
    {map = "-16,6", path = "bottom"},
    {map = "-16,7", path = "left"},
    {map = "-17,7", path = "bottom"},
    {map = "-17,8", path = "bottom"},
    {map = "-17,9", path = "left", fight = true},
    {map = "-18,9", path = "left", fight = true},
    {map = "-19,9", path = "bottom", fight = true},
    {map = "-19,10", path = "bottom", fight = true},
    {map = "-19,11", path = "bottom", fight = true},
    {map = "-19,12", path = "right", fight = true},
    {map = "-18,12", path = "top", fight = true},
    {map = "-18,11", path = "right", fight = true},
    {map = "-17,11", path = "top", fight = true},
    {map = "-17,10", path = "right", fight = true},
    {map = "-16,10", path = "bottom", fight = true},
}

local CanyonSauvage2 = {
    {map = "-16,11", path = "top(4)", fight = true},
}

local Marecages1 = {
    {map = "0,0", path = "zaap(73400320)"},
    {map = "-16,10", path = "left", fight = true},
    {map = "-17,10", path = "bottom", fight = true},
    {map = "-17,11", path = "left", fight = true},
    {map = "-18,11", path = "bottom", fight = true},
    {map = "-18,12", path = "left", fight = true},
    {map = "-19,12", path = "top(6)", fight = true},
    {map = "-19,11", path = "top", fight = true},
    {map = "-19,10", path = "right", fight = true},
    {map = "-18,10", path = "top", fight = true},
    {map = "-18,9", path = "right", fight = true},
    {map = "-17,9", path = "top", fight = true},
    {map = "-17,8", path = "top", fight = true},
    {map = "-17,7", path = "right"},
    {map = "-16,7", path = "top"},
    {map = "-16,3", path = "top"},
    {map = "-16,6", path = "top"},
    {map = "-16,5", path = "top"},
    {map = "-16,4", path = "top"},
    {map = "-16,2", path = "top"},
    {map = "-16,1", path = "right"},
    {map = "-15,1", path = "right"},
    {map = "-14,1", path = "right"},
    {map = "-13,1", path = "right"},
    {map = "-12,1", path = "right"},
    {map = "-11,1", path = "right"},
    {map = "-10,1", path = "top(16)", fight = true},
    {map = "-10,0", path = "top", fight = true},
    {map = "-10,-1", path = "top", fight = true},
    {map = "-10,-2", path = "right", fight = true},
    {map = "-9,-2", path = "top(2)", fight = true},
    {map = "-9,-3", path = "top(21)", fight = true},
    {map = "-9,-4", path = "right", fight = true},
    {map = "-8,-4", path = "right", fight = true},
    {map = "-7,-4", path = "bottom"},
    {map = "-7,-3", path = "right(139)", fight = true},
    {map = "-6,-3", path = "bottom(555)", fight = true},
    {map = "-6,-2", path = "right(139)" , fight = true},
    {map = "-5,-2", path = "top(17)", fight = true},
    {map = "-5,-3", path = "top(8)", fight = true},
    {map = "-5,-4", path = "left", fight = true},
    {map = "-6,-4", path = "top", fight = true},
    {map = "-6,-5", path = "left", fight = true},
    {map = "-7,-5", path = "havenbag", fight = true},
}

local Marecages2 = {
    {map = "-7,-5", path = "right", fight = true},
}

local RouteRoulottes = {
    {map = "0,0", path = "zaap(171967506)"},
    {map = "-25,12", path = "right", fight = true},
    {map = "-24,12", path = "right", fight = true},
    {map = "-23,12", path = "right", fight = true},
    {map = "-22,12", path = "top", fight = true},
    {map = "-22,11", path = "left", fight = true},
    {map = "-23,11", path = "left", fight = true},
    {map = "-25,11", path = "left", fight = true},
    {map = "-24,11", path = "left", fight = true},
    {map = "-26,11", path = "top", fight = true},
    {map = "-26,10", path = "right", fight = true},
    {map = "-25,10", path = "right", fight = true},
    {map = "-24,10", path = "right", fight = true},
    {map = "-23,10", path = "right", fight = true},
}

local PlainesRocheuses = {
    {map = "0,0", path = "zaap(147590153)"},
    {map = "-17,-47", path = "top"},
    {map = "-17,-48", path = "left", fight = true},
    {map = "-18,-48", path = "left", fight = true},
    {map = "-19,-48", path = "left", fight = true},
    {map = "-20,-48", path = "left", fight = true},
    {map = "-21,-48", path = "left", fight = true},
    {map = "-22,-48", path = "left", fight = true},
    {map = "-23,-48", path = "bottom", fight = true},
    {map = "-23,-47", path = "right", fight = true},
    {map = "-22,-47", path = "right", fight = true},
    {map = "-21,-47", path = "right", fight = true},
    {map = "-20,-47", path = "right", fight = true},
    {map = "-19,-47", path = "right", fight = true},
    {map = "-18,-47", path = "bottom", fight = true},
    {map = "-18,-46", path = "left", fight = true},
    {map = "-19,-46", path = "left", fight = true},
    {map = "-20,-46", path = "left", fight = true},
    {map = "-21,-46", path = "bottom", fight = true},
    {map = "-21,-45", path = "right", fight = true},
    {map = "-20,-45", path = "right", fight = true},
    {map = "-19,-45", path = "right", fight = true},
    {map = "-18,-45", path = "right", fight = true},
    {map = "-17,-45", path = "bottom", fight = true},
}

local BoisDeLitneg = {
    {map = "0,0", path = "zaap(147590153)"},
    {map = "-17,-47", path = "right"},
    {map = "-15,-47", path = "top", fight = true},
    {map = "-15,-48", path = "top", fight = true},
    {map = "-15,-49", path = "top", fight = true},
    {map = "-15,-50", path = "top", fight = true},
    {map = "-15,-51", path = "top", fight = true},
    {map = "-15,-52", path = "top", fight = true},
    {map = "-15,-53", path = "top", fight = true},
    {map = "-15,-54", path = "top", fight = true},
    {map = "-15,-55", path = "top", fight = true},
    {map = "-15,-56", path = "top", fight = true},
    {map = "-15,-57", path = "top", fight = true},
    {map = "-15,-58", path = "top", fight = true},
    {map = "-15,-59", path = "right", fight = true},
    {map = "-14,-59", path = "bottom", fight = true},
    {map = "-14,-58", path = "bottom", fight = true},
    {map = "-14,-57", path = "bottom", fight = true},
    {map = "-14,-56", path = "bottom", fight = true},
    {map = "-14,-55", path = "bottom", fight = true},
    {map = "-14,-54", path = "right", fight = true},
    {map = "-13,-54", path = "bottom", fight = true},
    {map = "-13,-53", path = "left", fight = true},
    {map = "-14,-53", path = "bottom", fight = true},
    {map = "-14,-52", path = "bottom", fight = true},
    {map = "-14,-51", path = "bottom", fight = true},
    {map = "-14,-50", path = "bottom", fight = true},
    {map = "-14,-49", path = "bottom", fight = true},
    {map = "-14,-48", path = "bottom", fight = true},
    {map = "-16,-47", path = "bottom"},
    {map = "-16,-46", path = "bottom"},
    {map = "-16,-45", path = "right"},
    {map = "-15,-45", path = "right", fight = true},
    {map = "-14,-46", path = "left", fight = true},
    {map = "-14,-45", path = "top", fight = true},
    {map = "-15,-46", path = "top", fight = true},
    {map = "-14,-47", path = "right", fight = true},
    {map = "-13,-47", path = "right", fight = true},
    {map = "-13,-49", path = "right", fight = true},
    {map = "-13,-51", path = "right", fight = true},
    {map = "-12,-47", path = "top", fight = true},
    {map = "-13,-48", path = "top", fight = true},
    {map = "-12,-49", path = "top", fight = true},
    {map = "-13,-50", path = "top", fight = true},
    {map = "-12,-51", path = "top", fight = true},
    {map = "-12,-48", path = "left", fight = true},
    {map = "-12,-50", path = "left", fight = true},
    {map = "-12,-53", path = "top", fight = true},
    {map = "-12,-52", path = "top", fight = true},
    {map = "-12,-54", path = "top", fight = true},
    {map = "-12,-55", path = "top", fight = true},
    {map = "-12,-56", path = "right", fight = true},
    {map = "-11,-56", path = "top"},
    {map = "-11,-57", path = "left"},
    {map = "-12,-57", path = "top", fight = true},
    {map = "-12,-58", path = "top", fight = true},
    {map = "-12,-59", path = "left", fight = true},
    {map = "-13,-59", path = "bottom", fight = true},
    {map = "-13,-58", path = "bottom", fight = true},
    {map = "-13,-57", path = "bottom", fight = true},
    {map = "-13,-56", path = "bottom", fight = true},
}

local PicsCania = {
    {map = "0,0", path = "zaap(147590153)"},
    {map = "-17,-47", path = "bottom"},
    {map = "-17,-46", path = "bottom"},
    {map = "-17,-45", path = "bottom"},
    {map = "-17,-44", path = "left", fight = true},
    {map = "-18,-44", path = "left", fight = true},
    {map = "-19,-44", path = "left", fight = true},
    {map = "-20,-44", path = "bottom", fight = true},
    {map = "-20,-43", path = "bottom", fight = true},
    {map = "-20,-42", path = "right", fight = true},
    {map = "-19,-42", path = "right", fight = true},
    {map = "-18,-42", path = "right", fight = true},
    {map = "-17,-42", path = "right", fight = true},
    {map = "-16,-42", path = "right", fight = true},
    {map = "-15,-42", path = "bottom", fight = true},
    {map = "-15,-41", path = "left", fight = true},
    {map = "-16,-41", path = "left", fight = true},
    {map = "-17,-41", path = "left", fight = true},
    {map = "-18,-41", path = "bottom", fight = true},
    {map = "-18,-40", path = "right", fight = true},
    {map = "-17,-40", path = "right", fight = true},
    {map = "-16,-40", path = "right", fight = true},
    {map = "-15,-40", path = "bottom", fight = true},
    {map = "-15,-39", path = "left", fight = true},
    {map = "-17,-39", path = "left", fight = true},
    {map = "-16,-39", path = "left", fight = true},
    {map = "-18,-39", path = "left", fight = true},
    {map = "-19,-39", path = "left", fight = true},
    {map = "-20,-39", path = "bottom", fight = true},
    {map = "-20,-38", path = "right", fight = true},
    {map = "-19,-38", path = "right", fight = true},
    {map = "-18,-38", path = "right", fight = true},
    {map = "-17,-38", path = "right", fight = true},
    {map = "-16,-38", path = "right", fight = true},
    {map = "-15,-38", path = "right", fight = true},
    {map = "-14,-38", path = "bottom", fight = true},
    {map = "-14,-37", path = "left", fight = true},
    {map = "-15,-37", path = "left", fight = true},
    {map = "-16,-37", path = "left", fight = true},
    {map = "-17,-37", path = "left", fight = true},
    {map = "-18,-37", path = "left", fight = true},
    {map = "-19,-37", path = "left", fight = true},
    {map = "-20,-37", path = "left", fight = true},
}

local CirqueCania = {
    {map = "0,0", path = "zaap(147590153)"},
    {map = "-17,-47", path = "right"},
    {map = "-16,-47", path = "right"},
    {map = "-15,-47", path = "right"},
    {map = "-14,-47", path = "right"},
    {map = "-13,-47", path = "bottom"},
    {map = "-13,-46", path = "bottom", fight = true},
    {map = "-13,-45", path = "bottom", fight = true},
    {map = "-13,-44", path = "bottom", fight = true},
    {map = "-13,-43", path = "bottom", fight = true},
    {map = "-13,-42", path = "right", fight = true},
    {map = "-12,-42", path = "top", fight = true},
    {map = "-12,-43", path = "top", fight = true},
    {map = "-12,-44", path = "top", fight = true},
    {map = "-12,-45", path = "top", fight = true},
    {map = "-12,-46", path = "right", fight = true},
    {map = "-11,-46", path = "bottom", fight = true},
    {map = "-11,-45", path = "bottom", fight = true},
    {map = "-11,-44", path = "bottom", fight = true},
    {map = "-11,-43", path = "bottom", fight = true},
    {map = "-11,-42", path = "right", fight = true},
    {map = "-10,-42", path = "right(111)", fight = true},
    {map = "-9,-42", path = "top", fight = true},
    {map = "-9,-43", path = "top", fight = true},
    {map = "-9,-44", path = "top", fight = true},
    {map = "-9,-45", path = "top", fight = true},
    {map = "-9,-46", path = "left", fight = true},
    {map = "-10,-46", path = "bottom", fight = true},
}

local LacCania = {
    {map = "0,0", path = "zaap(156240386)"},
    {map = "-5,-23", path = "bottom", fight = true},
    {map = "-3,-42", path = "left"},
    {map = "-4,-42", path = "left", fight = true},
    {map = "-5,-42", path = "left", fight = true},
    {map = "-6,-42", path = "left", fight = true},
    {map = "-7,-43", path = "right", fight = true},
    {map = "-6,-43", path = "right", fight = true},
    {map = "-5,-43", path = "right", fight = true},
    {map = "-4,-43", path = "right", fight = true},
    {map = "-3,-43", path = "right", fight = true},
    {map = "-2,-43", path = "right", fight = true},
    {map = "-1,-43", path = "right", fight = true},
    {map = "0,-43", path = "right", fight = true},
    {map = "1,-43", path = "bottom", fight = true},
    {map = "1,-42", path = "left", fight = true},
    {map = "0,-42", path = "left", fight = true},
    {map = "-1,-42", path = "left", fight = true},
    {map = "-2,-42", path = "bottom", fight = true},
    {map = "-2,-41", path = "left", fight = true},
    {map = "-3,-41", path = "left", fight = true},
    {map = "-4,-41", path = "left", fight = true},
    {map = "-5,-41", path = "left", fight = true},
    {map = "-6,-41", path = "left", fight = true},
    {map = "-8,-42", path = "top", fight = true},
    {map = "-7,-42", path = "left", fight = true},
    {map = "-8,-43", path = "right", fight = true},
    {map = "-7,-41", path = "left", fight = true},
}

local MassifCania = {
    {map = "0,0", path = "zaap(165152263)"},
    {map = "-13,-28", path = "bottom"},
    {map = "-13,-27", path = "bottom", fight = true},
    {map = "-13,-26", path = "bottom", fight = true},
    {map = "-13,-25", path = "bottom"},
    {map = "-13,-24", path = "bottom", fight = true},
    {map = "-13,-23", path = "bottom", fight = true},
    {map = "-13,-22", path = "bottom", fight = true},
    {map = "-13,-21", path = "bottom", fight = true},
    {map = "-13,-20", path = "bottom", fight = true},
    {map = "-13,-19", path = "left", fight = true},
    {map = "-14,-19", path = "left", fight = true},
}

local ChampsCania = {
    {map = "0,0", path = "zaap(142087694)"},
    {map = "-27,-36", path = "left", fight = true},
    {map = "-28,-36", path = "left", fight = true},
    {map = "-29,-36", path = "left", fight = true},
    {map = "-30,-36", path = "left", fight = true},
    {map = "-30,-38", path = "left", fight = true},
    {map = "-31,-39", path = "left", fight = true},
    {map = "-31,-36", path = "top", fight = true},
    {map = "-30,-37", path = "top", fight = true},
    {map = "-31,-38", path = "top"},
    {map = "-31,-37", path = "right", fight = true},
    {map = "-32,-39", path = "left", fight = true},
}

local IleMinotoror1 = {
    {map = "0,0", path = "zaap(164364304)"},
    {map = "-20,-20", path = "bottom"},
    {map = "-20,-19", path = "bottom"},
    {map = "-20,-18", path = "bottom"},
    {map = "-20,-17", path = "bottom"},
    {map = "-20,-16", path = "bottom"},
    {map = "-20,-15", path = "bottom"},
    {map = "-20,-14", path = "bottom"},
    {map = "-20,-13", path = "bottom"},
    {map = "-20,-12", path = "bottom"},
    {map = "-20,-11", path = "left"},
    {map = "-21,-11", path = "left"},
    {map = "-22,-11", path = "left"},
    {map = "-23,-11", path = "left"},
    {map = "-24,-11", path = "left"},
    {map = "-25,-11", path = "left"},
    {map = "-26,-11", path = "left"},
    {map = "-27,-11", path = "left"},
    {map = "-28,-11", path = "left"},
    {map = "-29,-11", path = "top"},
    {map = "-29,-12", path = "left"},
    {map = "-30,-12", path = "bottom"},
    {map = "-30,-11", path = "left"},
    {map = "-31,-11", path = "left"},
    {map = "-32,-11", path = "left"},
    {map = "-33,-11", path = "left"},
    {map = "-34,-10", path = "left"},
    {map = "-35,-10", path = "left"},
    {map = "-34,-11", path = "bottom"},
    {map = "-36,-10", custom = function() npc:npc(770, 3) npc:reply(-1) npc:reply(-1) npc:reply(-1) end},
        
    {map = "34476296", custom = function() npc:npc(783, 3) npc:reply(-2) npc:reply(-1) end},
    {map = "-43,-16", path = "right", fight = true},
    {map = "-42,-16", path = "right", fight = true},
    {map = "-41,-16", path = "right", fight = true},
    {map = "-40,-16", path = "top", fight = true},
    {map = "-40,-18", path = "top", fight = true},
    {map = "-40,-17", path = "top", fight = true},
    {map = "-40,-19", path = "left", fight = true},
    {map = "-41,-19", path = "left", fight = true},
    {map = "-42,-19", path = "left", fight = true},
    {map = "-43,-19", path = "bottom", fight = true},
    {map = "-43,-18", path = "right", fight = true},
    {map = "-42,-18", path = "right", fight = true},
    {map = "-41,-18", path = "bottom", fight = true},
    {map = "152337", path = "left", fight = true},
}

local IleMinotoror2 = {
    {map = "-42,-17", path = "top", fight = true},
    {map = "-42,-18", path = "left", fight = true},
    {map = "-43,-18", path = "bottom", fight = true},
    {map = "-43,-17", path = "bottom", fight = true},
    {map = "-43,-16", custom = function() npc:npc(770, 3) npc:reply(-1) npc:reply(-1) end}
}

local Saharach = {
    {map = "0,0", path = "zaap(173278210)"},
    {map = "15,-58", path = "left"},
    {map = "14,-58", path = "left", fight = true},
    {map = "13,-58", path = "top", fight = true},
    {map = "13,-59", path = "top", fight = true},
    {map = "13,-60", path = "right", fight = true},
    {map = "14,-60", path = "bottom", fight = true},
    {map = "14,-59", path = "right", fight = true},
    {map = "15,-60", path = "right", fight = true},
    {map = "16,-59", path = "right", fight = true},
    {map = "15,-59", path = "top", fight = true},
    {map = "173278720", path = "right", fight = true},
    {map = "173939200", door = "519"},
    {map = "17,-59", path = "top", fight = true},
    {map = "17,-60", path = "top", fight = true},
    {map = "17,-61", path = "right", fight = true},
    {map = "18,-61", path = "bottom", fight = true},
    {map = "18,-60", path = "right", fight = true},
    {map = "19,-60", path = "top", fight = true},
}

local SaharachHl1 = {
    {map = "0,0", path = "zaap(173278210)"},
    {map = "20,-61", path = "left"},
    {map = "19,-60", path = "left"},
    {map = "19,-61", path = "left"},
    {map = "18,-61", path = "left"},
    {map = "18,-60", path = "left"},
    {map = "18,-59", path = "left"},
    {map = "17,-59", path = "left"},
    {map = "17,-60", path = "left"},
    {map = "17,-58", path = "left"},
    {map = "17,-57", path = "left"},
    {map = "16,-60", path = "left"},
    {map = "16,-59", path = "left"},
    {map = "16,-58", path = "left"},
    {map = "16,-57", path = "left"},
    {map = "16,-56", path = "left"},
    {map = "14,-56", path = "top"},
    {map = "14,-57", path = "top"},
    {map = "14,-58", path = "top"},
    {map = "14,-59", path = "top"},
    {map = "14,-60", path = "top"},
    {map = "15,-60", path = "left"},
    {map = "15,-59", path = "left"},
    {map = "15,-58", custom = function() 
        local inv = inventory:inventoryContent()
        for k, v in ipairs(inv) do
            if v.position == 28 then
                global:printSuccess(v.objectGID)
                ObjectSetPositionMessage(v.objectUID, 63)
            end
        end        
        map:changeMap("left") end},
    {map = "15,-57", path = "left"},
    {map = "15,-56", path = "left"},
    {map = "13,-60", path = "right"},
    {map = "13,-59", path = "right"},
    {map = "13,-58", path = "right"},
    {map = "14,-61", path = "right", fight = true},
    {map = "15,-61", path = "right", fight = true},
    {map = "16,-61", path = "top", fight = true},
    {map = "16,-62", path = "right", fight = true},
    {map = "17,-62", path = "right", fight = true},
    {map = "18,-62", path = "right", fight = true},
}

local SaharachHl2 = {
    {map = "19,-62", path = "left", fight = true},
    {map = "18,-62", path = "top", fight = true},
    {map = "18,-63", path = "left", fight = true},
    {map = "17,-63", path = "left", fight = true},
    {map = "16,-63", path = "top", fight = true},
}

local SaharachHl3 = {
    {map = "16,-64", path = "bottom", fight = true},
    {map = "16,-63", path = "left", fight = true},
    {map = "15,-63", path = "left", fight = true},
    {map = "14,-63", path = "left", fight = true},
    {map = "13,-63", path = "left", fight = true},
    {map = "12,-63", path = "top", fight = true},
    {map = "12,-64", path = "top", fight = true},
    {map = "12,-65", path = "right", fight = true},
    {map = "13,-65", path = "right", fight = true},
}

local SaharachHl4 = {
    {map = "14,-65", path = "left", fight = true},
    {map = "13,-65", path = "bottom", fight = true},
    {map = "13,-64", path = "right", fight = true},
    {map = "14,-64", path = "right", fight = true},
    {map = "15,-64", custom = function() inventory:equipItem(14966, 28) map:changeMap("top") end, fight = true},
}

local Arakne = {
    {map = "0,0", path = "zaap(88082704)"},
    {map = "5,7", path = "top"},
    {map = "5,6", path = "top"},
    {map = "5,5", path = "top"},
    {map = "5,4", path = "right", fight = true},
    {map = "5,2", path = "right", fight = true},
    {map = "6,3", path = "left", fight = true},
    {map = "6,4", path = "top", fight = true},
    {map = "5,3", path = "top", fight = true},
    {map = "6,2", path = "right", fight = true},
    {map = "7,2", path = "right", fight = true},
    {map = "8,2", path = "right", fight = true},
    {map = "9,2", path = "right", fight = true},
    {map = "10,2", path = "top(5)"},
    {map = "10,1", path = "left(420)"},
    {map = "9,1", path = "left", fight = true},
    {map = "8,1", path = "left", fight = true},
    {map = "7,1", path = "top", fight = true},
    {map = "7,0", path = "left", fight = true},
    {map = "6,0", path = "bottom", fight = true},
}

local Champa = {
    {map = "0,0", path = "zaap(88082704)"},
    {map = "5,7", path = "bottom"},
    {map = "5,8", path = "bottom"},
    {map = "5,9", path = "right"},
    {map = "6,9", path = "right"},
    {map = "7,9", path = "right"},
    {map = "8,9", path = "right"},
    {map = "9,9", path = "right"},
    {map = "10,9", path = "right", fight = true},
    {map = "11,9", path = "bottom", fight = true},
    {map = "11,10", path = "right", fight = true},
    {map = "12,10", path = "bottom", fight = true},
    {map = "12,11", path = "left", fight = true},
    {map = "11,11", path = "left", fight = true},
    {map = "10,10", path = "left", fight = true},
    {map = "9,11", path = "left", fight = true},
    {map = "10,11", path = "top", fight = true},
    {map = "8,11", path = "top", fight = true},
    {map = "9,10", path = "bottom", fight = true},
    {map = "8,10", path = "bottom", fight = true},
}

local EgoutsAmakna = {
    {map = "0,0", path = "zaap(68419587)"},
    {map = "68419587", door = "183"},
    {map = "101715481", path = "234", fight = true},
    {map = "101715479", path = "227", fight = true},
    {map = "101715477", path = "170", fight = true},
    {map = "101715475", path = "234", fight = true},
    {map = "101715473", path = "157", fight = true},
    {map = "101715471", path = "391", fight = true},
    {map = "101716495", path = "285", fight = true},
    {map = "101716493", path = "394", fight = true},
    {map = "101715469", path = "211", fight = true},
    {map = "101715467", path = "406", fight = true},
    {map = "101714443", path = "241", fight = true},
    {map = "101713419", path = "477", fight = true},
    {map = "101713421", path = "421", fight = true},
    {map = "101713423", path = "543", fight = true},
}

local Rivage = {
    {map = "0,0", path = "zaap(88085249)"},
    {map = "10,22", path = "right", fight = true},
    {map = "11,22", path = "right", fight = true},
    {map = "12,22", path = "right", fight = true},
    {map = "13,22", path = "right", fight = true},
    {map = "14,22", path = "top", fight = true},
    {map = "14,21", path = "left"},
    {map = "13,21", path = "left"},
    {map = "12,21", path = "left"},
    {map = "11,21", path = "left"},
    {map = "10,21", path = "left"},
    {map = "9,21", path = "bottom"},
    {map = "9,22", path = "left", fight = true},
    {map = "8,22", path = "left", fight = true},
    {map = "7,22", path = "bottom", fight = true},
    {map = "7,23", path = "left", fight = true},
    {map = "6,22", path = "left", fight = true},
    {map = "5,23", path = "left", fight = true},
    {map = "6,23", path = "top", fight = true},
    {map = "5,22", path = "bottom", fight = true},
    {map = "4,23", path ="bottom", fight = true},
    {map = "4,24", path = "bottom", fight = true},
    {map = "4,25", path ="bottom", fight = true},
    {map = "4,26", path = "right"},
    {map = "5,26", path = "bottom", fight = true},
    {map = "5,27", path = "bottom", fight = true},
    {map = "5,28", path = "right"},
    {map = "6,28", path = "right", fight = true},
    {map = "7,28", path = "bottom", fight = true},
}

local Kartonpat = {
    {map = "0,0", path = "zaap(88085249)"},
    {map = "10,22", path = "right"},
    {map = "11,22", path = "right"},
    {map = "12,22", path = "right"},
    {map = "13,22", path = "right"},
    {map = "14,22", path = "top"},
    {map = "14,21", path = "top"},
    {map = "14,20", path = "top"},
    {map = "14,19", path = "top"},
    {map = "14,18", path = "top"},
    {map = "14,17", path = "top"},
    {map = "14,16", path = "top"},
    {map = "14,15", path = "top"},
    {map = "88087305", door = "403"},
    {map = "117440512", door = "222"},
    {map = "117441536", door = "167"},
    {map = "117442560", door = "488"},
    {map = "117443584", door = "221"},
    {map = "117440514", door = "293"},
    {map = "117441538", door = "251"},
    {map = "117442562", door = "262"},
    {map = "117443586", door = "329"},
    {map = "117444610", door = "303"},
    {map = "118096384", path = "right", fight = true},
    {map = "21,8", path = "right", fight = true},
    {map = "22,8", path = "top", fight = true},
    {map = "22,7", path = "top", fight = true},
    {map = "22,6", path = "left", fight = true},
    {map = "21,6", path = "bottom", fight = true},
}


local TableArea = {
    {Zone = {
        {RatBonta1, "216269576", false}, {RatBonta2, "212599815", false}
    }, MaxMonster = 6, MinMonster = 3, ListeVenteId = {25761, 25767, 25759, 25758, 17142}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {RatBrakmar, "216925706", false}
    }, MaxMonster = 6, MinMonster = 3, ListeVenteId = {25762, 25757, 25756, 25760, 17142}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {CanyonSauvage1, "-16,11", false}, {CanyonSauvage2, "-16,10", false}
    }, MaxMonster = 8, MinMonster = 3, ListeVenteId = {8075, 8002, 8077, 8060, 8059, 8062, 8061, 8055, 8054, 8086, 17136, 17140}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {Marecages1, "-7,-5", false}, {Marecages2, "-6,-5", false}
    }, MaxMonster = 8, MinMonster = 3, ListeVenteId = {1613, 1664, 1663, 6738, 17134, 17126, 17130}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {RouteRoulottes, "-22,10", false}
    }, MaxMonster = 8, MinMonster = 3, ListeVenteId = {1610, 6740, 2316, 6739, 1611, 1682, 1614, 2281, 17138}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {PlainesRocheuses, "-17,-44", false}
    }, MaxMonster = 8, MinMonster = 3, ListeVenteId = {2504, 2304, 447, 543, 17134}, Farmer = false, PourcentageHdv = 0, Stop = false},
    -- {Zone = {
    --     {BoisDeLitneg, "-13,-55", false}
    -- }, MaxMonster = 5, MinMonster = 1, ListeVenteId = {2559, 2562, 8322, 1694, 18209, 2560, 18198, 2561, 17144}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {PicsCania, "-21,-37", false}
    }, MaxMonster = 5, MinMonster = 2, ListeVenteId = {2273, 3209, 2647, 3002, 2271, 17138}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {CirqueCania, "-10,-45", false}
    }, MaxMonster = 5, MinMonster = 1, ListeVenteId = {15074, 15075, 15076, 15069, 15070, 15071, 15072, 17146}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {LacCania, "-8,-41", false}
    }, MaxMonster = 8, MinMonster = 3, ListeVenteId = {1770, 1772, 1773, 1774, 1775, 1776, 1777, 1778, 17132}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {MassifCania, "-15,-19", false}
    }, MaxMonster = 8, MinMonster = 3, ListeVenteId = {2483, 2482, 6476, 480, 2481, 2479, 2555, 17132}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {ChampsCania, "-33,-39", false}
    }, MaxMonster = 8, MinMonster = 3, ListeVenteId = {1891, 648, 2509, 2506, 650, 17132}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {IleMinotoror1, "-42,-17", false}, {IleMinotoror2, "-36,-10", false}
    }, MaxMonster = 6, MinMonster = 3, ListeVenteId = {8315, 14948, 8312, 14949, 8309, 14952, 17144}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {Saharach, "19,-61", false}
    }, MaxMonster = 8, MinMonster = 1, ListeVenteId = {18368, 17136}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {SaharachHl1, "19,-62", false}, {SaharachHl2, "16,-64", false}, {SaharachHl3, "14,-65", false}, {SaharachHl4, "15,-65", false}
    }, MaxMonster = 4, MinMonster = 1, ListeVenteId = {18359, 18357, 18361, 18362, 18363, 17146}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {Arakne, "6,0", false}
    }, MaxMonster = 8, MinMonster = 3, ListeVenteId = {377, 307, 378, 16487, 365, 17124}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {Champa, "8,11", false}
    }, MaxMonster = 8, MinMonster = 2, ListeVenteId = {16166, 16165, 16168, 16167, 17128}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {EgoutsAmakna, "101714447", false}
    }, MaxMonster = 7, MinMonster = 2, ListeVenteId = {8483, 8482, 17132}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {Rivage, "7,29", false}
    }, MaxMonster = 8, MinMonster = 3, ListeVenteId = {379, 13728, 8681, 386, 17130}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {Kartonpat, "21,7", false},
    }, MaxMonster = 7, MinMonster = 2, ListeVenteId = {14509, 14510, 14512, 14514, 14513, 14515, 14516, 17140}, Farmer = false, PourcentageHdv = 0, Stop = false},
    -- Prq pas rajouter feudala -> nouvelle viande et pas mal de rentabilité (faut monter chasseur lvl 140)
}

local TableAreaDeBase = {
    {Zone = {
        {RatBonta1, "216269576", false}, {RatBonta2, "212599815", false}
    }, MaxMonster = 6, MinMonster = 3, ListeVenteId = {25761, 25767, 25759, 25758, 17142}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {RatBrakmar, "216925706", false}
    }, MaxMonster = 6, MinMonster = 3, ListeVenteId = {25762, 25757, 25756, 25760, 17142}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {CanyonSauvage1, "-16,11", false}, {CanyonSauvage2, "-16,10", false}
    }, MaxMonster = 8, MinMonster = 3, ListeVenteId = {8075, 8002, 8077, 8060, 8059, 8062, 8061, 8055, 8054, 8086, 17136, 17140}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {Marecages1, "-7,-5", false}, {Marecages2, "-6,-5", false}
    }, MaxMonster = 8, MinMonster = 3, ListeVenteId = {1613, 1664, 1663, 6738, 17134, 17126, 17130}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {RouteRoulottes, "-22,10", false}
    }, MaxMonster = 8, MinMonster = 3, ListeVenteId = {1610, 6740, 2316, 6739, 1611, 1682, 1614, 2281, 17138}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {PlainesRocheuses, "-17,-44", false}
    }, MaxMonster = 8, MinMonster = 3, ListeVenteId = {2504, 2304, 447, 543, 17134}, Farmer = false, PourcentageHdv = 0, Stop = false},
    -- {Zone = {
    --     {BoisDeLitneg, "-13,-55", false}
    -- }, MaxMonster = 5, MinMonster = 1, ListeVenteId = {2559, 2562, 8322, 1694, 18209, 2560, 18198, 2561, 17144}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {PicsCania, "-21,-37", false}
    }, MaxMonster = 5, MinMonster = 2, ListeVenteId = {2273, 3209, 2647, 3002, 2271, 17138}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {CirqueCania, "-10,-45", false}
    }, MaxMonster = 5, MinMonster = 1, ListeVenteId = {15074, 15075, 15076, 15069, 15070, 15071, 15072, 17146}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {LacCania, "-8,-41", false}
    }, MaxMonster = 8, MinMonster = 3, ListeVenteId = {1770, 1772, 1773, 1774, 1775, 1776, 1777, 1778, 17132}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {MassifCania, "-15,-19", false}
    }, MaxMonster = 8, MinMonster = 3, ListeVenteId = {2483, 2482, 6476, 480, 2481, 2479, 2555, 17132}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {ChampsCania, "-33,-39", false}
    }, MaxMonster = 8, MinMonster = 3, ListeVenteId = {1891, 648, 2509, 2506, 650, 17132}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {IleMinotoror1, "-42,-17", false}, {IleMinotoror2, "-36,-10", false}
    }, MaxMonster = 6, MinMonster = 3, ListeVenteId = {8315, 14948, 8312, 14949, 8309, 14952, 17144}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {Saharach, "19,-61", false}
    }, MaxMonster = 8, MinMonster = 1, ListeVenteId = {18368, 17136}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {SaharachHl1, "19,-62", false}, {SaharachHl2, "16,-64", false}, {SaharachHl3, "14,-65", false}, {SaharachHl4, "15,-65", false}
    }, MaxMonster = 4, MinMonster = 1, ListeVenteId = {18359, 18357, 18361, 18362, 18363, 17146}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {Arakne, "6,0", false}
    }, MaxMonster = 8, MinMonster = 3, ListeVenteId = {377, 307, 378, 16487, 365, 17124}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {Champa, "8,11", false}
    }, MaxMonster = 8, MinMonster = 2, ListeVenteId = {16166, 16165, 16168, 16167, 17128}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {EgoutsAmakna, "101714447", false}
    }, MaxMonster = 7, MinMonster = 2, ListeVenteId = {8483, 8482, 17132}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {Rivage, "7,29", false}
    }, MaxMonster = 8, MinMonster = 3, ListeVenteId = {379, 13728, 8681, 386, 17130}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = {
        {Kartonpat, "21,7", false},
    }, MaxMonster = 7, MinMonster = 2, ListeVenteId = {14509, 14510, 14512, 14514, 14513, 14515, 14516, 17140}, Farmer = false, PourcentageHdv = 0, Stop = false},
    -- Prq pas rajouter feudala -> nouvelle viande et pas mal de rentabilité (faut monter chasseur lvl 140)
}

--- </init>

local TableVente = {}
local TableValeurVente = {}

if global:thisAccountController():getAlias():find("Combat2") then
    TableVente = {

        {Name = "champa marron", id = 16166, maxHdv100 = 2, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "champa bleu", id = 16165, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "champa vert", id = 16168, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "champa rouge", id = 16167, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "Viande Minérale", id = 17128, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "épine du champ champ", id = 377, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "ailes de moskito", id = 307, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "sporme du champ champ", id = 378, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "bois vermoulu", id = 16487, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "patte d'arakne", id = 365, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Viande Faisandée", id = 17124, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "tissu pourpre", id = 2273, maxHdv100 = 5, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "scalp de bizarbwork", id = 3209, maxHdv100 = 5, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "oreille de médibwork", id = 2647, maxHdv100 = 5, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "botte trouée du mégabwork", id = 3002, maxHdv100 = 5, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "cuir violet de médibwork", id = 2271, maxHdv100 = 5, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "Viande Rassie", id = 17138, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "écaille de chef crocodaille", id = 1613, maxHdv100 = 5, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "dent de crocodaille", id = 1664, maxHdv100 = 5, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "écaille de crocodaille", id = 1663, maxHdv100 = 5, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "crâne de chef crocoaille", id = 6738, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Viande Avariée", id = 17134, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
        {Name = "Viande Frelatée", id = 17126, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
        {Name = "Viande Tendre", id = 17130, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "peau de serpentin", id = 1891, maxHdv100 = 5, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "ailes de boudard", id = 648, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "dent de larve", id = 2509, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "grelot", id = 2506, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 8, canSell = true},
        {Name = "duvet de boudard", id = 650, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 8, canSell = true},
        {Name = "Viande Ladre", id = 17132, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "pince de crabe", id = 379, maxHdv100 = 5, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "paupière d'étoile", id = 13728, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "peau de raulmops", id = 8681, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Groin de Sanglier", id = 386, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Tendre", id = 17130, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "langue de craquelope", id = 2504, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "fragment de pierre polie", id = 2304, maxHdv100 = 2, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "charbon", id = 447, maxHdv100 = 5, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "pierre de diamant", id = 543, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Avariée", id = 17134, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "ouvrage magique d'aloeve rate", id = 25761, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "collier de chack rat", id = 25767, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "lance de chika rat", id = 25759, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "lance pierre de scelle rate", id = 25758, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Viande Sechée", id = 17142, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "oreille de rat plapla", id = 25762, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "tuyau rouillé de rate iboise", id = 25757, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "crâne magique de rate atine", id = 25756, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "vieux bouquin de rat li", id = 25760, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Sechée", id = 17142, maxHdv100 = 3, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "écaille d'ourobulos", id = 18368, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Viande Sanguinolente", id = 17136, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "étoffe de dok alako", id = 8002, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "boomrang de dok alako", id = 8075, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "boomrang de warko marron", id = 8077, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "poils de koalak coco", id = 8060, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "poils de koalak grioote", id = 8059, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "poils de koalak indigo", id = 8062, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "poils de koalak reinette", id = 8061, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "os de mama koalak", id = 8055, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "peau de drakoalak", id = 8054, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "coiffe déchirée de drakoalak", id = 8086, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Viande Sanguinolente", id = 17136, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
        {Name = "Viande Exustative", id = 17140, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "dentier de malle outillée", id = 2483, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "charnière cassée", id = 2482, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "griffe de robionicle", id = 6476, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "minerai étrange", id = 480, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "chaine de robot fléeau", id = 2481, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "fléau de robot fléeau", id = 2479, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "courroie en cuir", id = 2555, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Ladre", id = 17132, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "peau de ramane d'égoutant", id = 8483, maxHdv100 = 2, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "peau de rat", id = 8482, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Ladre", id = 17132, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "roue de tivelo", id = 1610, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "peau de tivelo", id = 6740, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "couteau de roukouteau", id = 2316, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "peau de roukouteau", id = 6739, maxHdv100 = 1, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
        {Name = "bourgeon de pirolienne", id = 1611, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "ecorce de liroye merline", id = 1682, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "bombe de graboule", id = 1614, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "tissu de graboule", id = 2281, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Rassie", id = 17138, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "glandes de truchtine", id = 15074, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "duvet de truchon", id = 15075, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "bec de truchon", id = 15076, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "croupion de truchmuche", id = 15069, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "langue de truchmuche", id = 15070, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "plume de truchideur", id = 15071, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "morpion de truchideur", id = 15072, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Viande Persillée", id = 17146, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "parchemin de cacatana", id = 18359, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "jus de cacaterre", id = 18357, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "fleur de cactiflore", id = 18361, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "moustaches de cactoblongo", id = 18362, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "string de pampactus", id = 18363, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Persillée", id = 17146, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "peau de krameleon", id = 8314, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "langue de krameleon", id = 14950, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "peau de mandrine", id = 8315, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 4, canSell = true},
        {Name = "oeil de mandrine", id = 14948, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 4, canSell = true},
        {Name = "peau de minoskito", id = 8312, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "trompe de minoskito", id = 14949, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "plume de serpiplume", id = 8309, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "pierre de serpiplume", id = 14952, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Viande Saignante", id = 17144, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
     
        {Name = "Crinière de Troollaraj", id = 2559, maxHdv100 = 2, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Slip de Troollaraj", id = 2562, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 8, canSell = true},
        {Name = "Poil de Troolléolé", id = 8322, maxHdv100 = 2, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Laine du Trooll Furieux", id = 1694, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "Gratrooll", id = 18209, maxHdv100 = 2, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Épaulette de Troolligark", id = 2560, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "Gâtrool", id = 18198, maxHdv100 = 2, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Bracelet de Force de Trooll", id = 2561, maxHdv100 = 1, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Saignante", id = 17144, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "Bout de Blop Coco", id = 1770, maxHdv100 = 2, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Fleur de Blop Coco", id = 1772, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Bout de Blop Reinette", id = 1773, maxHdv100 = 2, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Fleur de Blop Reinette", id = 1774, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Bout de Blop Griotte", id = 1775, maxHdv100 = 2, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Fleur de Blop Griotte", id = 1776, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Bout de Blop Indigo", id = 1777, maxHdv100 = 2, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Fleur de Blop Indigo", id = 1778, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Ladre", id = 17132, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "Oreille de Bouledogre", id = 14509, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Patte de Bouledogre", id = 14510, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Plume de Gobvious", id = 14512, maxHdv100 = 4, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "Dent de Molette", id = 14514, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Échasse de Molette", id = 14513, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Corne de Rhinoféroce", id = 14515, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "Oreille de Rhinoféroce", id = 14516, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Exustative", id = 17140, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
    }
    TableValeurVente = {

        {Name = "champa marron", id = 16166, maxHdv100 = 2, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "champa bleu", id = 16165, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "champa vert", id = 16168, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "champa rouge", id = 16167, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "Viande Minérale", id = 17128, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "épine du champ champ", id = 377, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "ailes de moskito", id = 307, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "sporme du champ champ", id = 378, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "bois vermoulu", id = 16487, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "patte d'arakne", id = 365, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Viande Faisandée", id = 17124, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "tissu pourpre", id = 2273, maxHdv100 = 5, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "scalp de bizarbwork", id = 3209, maxHdv100 = 5, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "oreille de médibwork", id = 2647, maxHdv100 = 5, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "botte trouée du mégabwork", id = 3002, maxHdv100 = 5, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "cuir violet de médibwork", id = 2271, maxHdv100 = 5, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "Viande Rassie", id = 17138, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "écaille de chef crocodaille", id = 1613, maxHdv100 = 5, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "dent de crocodaille", id = 1664, maxHdv100 = 5, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "écaille de crocodaille", id = 1663, maxHdv100 = 5, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "crâne de chef crocoaille", id = 6738, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Viande Avariée", id = 17134, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
        {Name = "Viande Frelatée", id = 17126, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
        {Name = "Viande Tendre", id = 17130, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "peau de serpentin", id = 1891, maxHdv100 = 5, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "ailes de boudard", id = 648, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "dent de larve", id = 2509, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "grelot", id = 2506, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 8, canSell = true},
        {Name = "duvet de boudard", id = 650, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 8, canSell = true},
        {Name = "Viande Ladre", id = 17132, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "pince de crabe", id = 379, maxHdv100 = 5, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "paupière d'étoile", id = 13728, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "peau de raulmops", id = 8681, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Groin de Sanglier", id = 386, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Tendre", id = 17130, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "langue de craquelope", id = 2504, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "fragment de pierre polie", id = 2304, maxHdv100 = 2, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "charbon", id = 447, maxHdv100 = 5, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "pierre de diamant", id = 543, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Avariée", id = 17134, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "ouvrage magique d'aloeve rate", id = 25761, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "collier de chack rat", id = 25767, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "lance de chika rat", id = 25759, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "lance pierre de scelle rate", id = 25758, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Viande Sechée", id = 17142, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "oreille de rat plapla", id = 25762, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "tuyau rouillé de rate iboise", id = 25757, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "crâne magique de rate atine", id = 25756, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "vieux bouquin de rat li", id = 25760, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Sechée", id = 17142, maxHdv100 = 3, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "écaille d'ourobulos", id = 18368, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Viande Sanguinolente", id = 17136, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "étoffe de dok alako", id = 8002, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "boomrang de dok alako", id = 8075, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "boomrang de warko marron", id = 8077, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "poils de koalak coco", id = 8060, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "poils de koalak grioote", id = 8059, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "poils de koalak indigo", id = 8062, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "poils de koalak reinette", id = 8061, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "os de mama koalak", id = 8055, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "peau de drakoalak", id = 8054, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "coiffe déchirée de drakoalak", id = 8086, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Viande Sanguinolente", id = 17136, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
        {Name = "Viande Exustative", id = 17140, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "dentier de malle outillée", id = 2483, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "charnière cassée", id = 2482, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "griffe de robionicle", id = 6476, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "minerai étrange", id = 480, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "chaine de robot fléeau", id = 2481, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "fléau de robot fléeau", id = 2479, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "courroie en cuir", id = 2555, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Ladre", id = 17132, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "peau de ramane d'égoutant", id = 8483, maxHdv100 = 2, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "peau de rat", id = 8482, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Ladre", id = 17132, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "roue de tivelo", id = 1610, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "peau de tivelo", id = 6740, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "couteau de roukouteau", id = 2316, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "peau de roukouteau", id = 6739, maxHdv100 = 1, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
        {Name = "bourgeon de pirolienne", id = 1611, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "ecorce de liroye merline", id = 1682, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "bombe de graboule", id = 1614, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "tissu de graboule", id = 2281, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Rassie", id = 17138, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "glandes de truchtine", id = 15074, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "duvet de truchon", id = 15075, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "bec de truchon", id = 15076, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "croupion de truchmuche", id = 15069, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "langue de truchmuche", id = 15070, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "plume de truchideur", id = 15071, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "morpion de truchideur", id = 15072, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Viande Persillée", id = 17146, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "parchemin de cacatana", id = 18359, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "jus de cacaterre", id = 18357, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "fleur de cactiflore", id = 18361, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "moustaches de cactoblongo", id = 18362, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "string de pampactus", id = 18363, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Persillée", id = 17146, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "peau de krameleon", id = 8314, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "langue de krameleon", id = 14950, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "peau de mandrine", id = 8315, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 4, canSell = true},
        {Name = "oeil de mandrine", id = 14948, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 4, canSell = true},
        {Name = "peau de minoskito", id = 8312, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "trompe de minoskito", id = 14949, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "plume de serpiplume", id = 8309, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "pierre de serpiplume", id = 14952, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Viande Saignante", id = 17144, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
     
        {Name = "Crinière de Troollaraj", id = 2559, maxHdv100 = 2, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Slip de Troollaraj", id = 2562, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 8, canSell = true},
        {Name = "Poil de Troolléolé", id = 8322, maxHdv100 = 2, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Laine du Trooll Furieux", id = 1694, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "Gratrooll", id = 18209, maxHdv100 = 2, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Épaulette de Troolligark", id = 2560, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "Gâtrool", id = 18198, maxHdv100 = 2, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Bracelet de Force de Trooll", id = 2561, maxHdv100 = 1, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Saignante", id = 17144, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "Bout de Blop Coco", id = 1770, maxHdv100 = 2, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Fleur de Blop Coco", id = 1772, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Bout de Blop Reinette", id = 1773, maxHdv100 = 2, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Fleur de Blop Reinette", id = 1774, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Bout de Blop Griotte", id = 1775, maxHdv100 = 2, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Fleur de Blop Griotte", id = 1776, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Bout de Blop Indigo", id = 1777, maxHdv100 = 2, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Fleur de Blop Indigo", id = 1778, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Ladre", id = 17132, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "Oreille de Bouledogre", id = 14509, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Patte de Bouledogre", id = 14510, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Plume de Gobvious", id = 14512, maxHdv100 = 4, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "Dent de Molette", id = 14514, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Échasse de Molette", id = 14513, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Corne de Rhinoféroce", id = 14515, maxHdv100 = 3, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        {Name = "Oreille de Rhinoféroce", id = 14516, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Exustative", id = 17140, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
    }
else
    TableVente = {

        {Name = "champa marron", id = 16166, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "champa bleu", id = 16165, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "champa vert", id = 16168, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "champa rouge", id = 16167, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "Viande Minérale", id = 17128, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "épine du champ champ", id = 377, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "ailes de moskito", id = 307, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "sporme du champ champ", id = 378, maxHdv100 = 1, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "bois vermoulu", id = 16487, maxHdv100 = 1, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "patte d'arakne", id = 365, maxHdv100 = 3, maxHdv10 = 10, maxHdv1 = 2, canSell = true},
        {Name = "Viande Faisandée", id = 17124, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "tissu pourpre", id = 2273, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 2, canSell = true},
        {Name = "scalp de bizarbwork", id = 3209, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 2, canSell = true},
        {Name = "oreille de médibwork", id = 2647, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 2, canSell = true},
        {Name = "botte trouée du mégabwork", id = 3002, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 2, canSell = true},
        {Name = "cuir violet de médibwork", id = 2271, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 2, canSell = true},
        {Name = "Viande Rassie", id = 17138, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "écaille de chef crocodaille", id = 1613, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 2, canSell = true},
        {Name = "dent de crocodaille", id = 1664, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 2, canSell = true},
        {Name = "écaille de crocodaille", id = 1663, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 2, canSell = true},
        {Name = "crâne de chef crocoaille", id = 6738, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 3, canSell = true},
        {Name = "Viande Avariée", id = 17134, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
        {Name = "Viande Frelatée", id = 17126, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
        {Name = "Viande Tendre", id = 17130, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "peau de serpentin", id = 1891, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 2, canSell = true},
        {Name = "ailes de boudard", id = 648, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "dent de larve", id = 2509, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "grelot", id = 2506, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 8, canSell = true},
        {Name = "duvet de boudard", id = 650, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 8, canSell = true},
        {Name = "Viande Ladre", id = 17132, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "pince de crabe", id = 379, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 2, canSell = true},
        {Name = "paupière d'étoile", id = 13728, maxHdv100 = 3, maxHdv10 = 6, maxHdv1 = 2, canSell = true},
        {Name = "peau de raulmops", id = 8681, maxHdv100 = 3, maxHdv10 = 6, maxHdv1 = 2, canSell = true},
        {Name = "Groin de Sanglier", id = 386, maxHdv100 = 3, maxHdv10 = 6, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Tendre", id = 17130, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "langue de craquelope", id = 2504, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
        {Name = "fragment de pierre polie", id = 2304, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "charbon", id = 447, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 2, canSell = true},
        {Name = "pierre de diamant", id = 543, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
        --{Name = "Viande Avariée", id = 17134, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "ouvrage magique d'aloeve rate", id = 25761, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "collier de chack rat", id = 25767, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "lance de chika rat", id = 25759, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "lance pierre de scelle rate", id = 25758, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "Viande Sechée", id = 17142, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "oreille de rat plapla", id = 25762, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "tuyau rouillé de rate iboise", id = 25757, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "crâne magique de rate atine", id = 25756, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "vieux bouquin de rat li", id = 25760, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Sechée", id = 17142, maxHdv100 = 3, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "écaille d'ourobulos", id = 18368, maxHdv100 = 3, maxHdv10 = 10, maxHdv1 = 5, canSell = true},
        {Name = "Viande Sanguinolente", id = 17136, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "étoffe de dok alako", id = 8002, maxHdv100 = 3, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
        {Name = "boomrang de dok alako", id = 8075, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 5, canSell = true},
        {Name = "boomrang de warko marron", id = 8077, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 5, canSell = true},
        {Name = "poils de koalak coco", id = 8060, maxHdv100 = 2, maxHdv10 = 7, maxHdv1 = 5, canSell = true},
        {Name = "poils de koalak grioote", id = 8059, maxHdv100 = 2, maxHdv10 = 7, maxHdv1 = 5, canSell = true},
        {Name = "poils de koalak indigo", id = 8062, maxHdv100 = 2, maxHdv10 = 7, maxHdv1 = 5, canSell = true},
        {Name = "poils de koalak reinette", id = 8061, maxHdv100 = 2, maxHdv10 = 7, maxHdv1 = 5, canSell = true},
        {Name = "os de mama koalak", id = 8055, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 5, canSell = true},
        {Name = "peau de drakoalak", id = 8054, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "coiffe déchirée de drakoalak", id = 8086, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "Viande Sanguinolente", id = 17136, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
        {Name = "Viande Exustative", id = 17140, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "dentier de malle outillée", id = 2483, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "charnière cassée", id = 2482, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "griffe de robionicle", id = 6476, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "minerai étrange", id = 480, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "chaine de robot fléeau", id = 2481, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "fléau de robot fléeau", id = 2479, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "courroie en cuir", id = 2555, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        --{Name = "Viande Ladre", id = 17132, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "peau de ramane d'égoutant", id = 8483, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "peau de rat", id = 8482, maxHdv100 = 3, maxHdv10 = 8, maxHdv1 = 7, canSell = true},
        --{Name = "Viande Ladre", id = 17132, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "roue de tivelo", id = 1610, maxHdv100 = 3, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
        {Name = "peau de tivelo", id = 6740, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "couteau de roukouteau", id = 2316, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "peau de roukouteau", id = 6739, maxHdv100 = 1, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
        {Name = "bourgeon de pirolienne", id = 1611, maxHdv100 = 3, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "ecorce de liroye merline", id = 1682, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "bombe de graboule", id = 1614, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 3, canSell = true},
        {Name = "tissu de graboule", id = 2281, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        --{Name = "Viande Rassie", id = 17138, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "glandes de truchtine", id = 15074, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "duvet de truchon", id = 15075, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 2, canSell = true},
        {Name = "bec de truchon", id = 15076, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "croupion de truchmuche", id = 15069, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 2, canSell = true},
        {Name = "langue de truchmuche", id = 15070, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "plume de truchideur", id = 15071, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 2, canSell = true},
        {Name = "morpion de truchideur", id = 15072, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "Viande Persillée", id = 17146, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "parchemin de cacatana", id = 18359, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 2, canSell = true},
        {Name = "jus de cacaterre", id = 18357, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "fleur de cactiflore", id = 18361, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 2, canSell = true},
        {Name = "moustaches de cactoblongo", id = 18362, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 2, canSell = true},
        {Name = "string de pampactus", id = 18363, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Persillée", id = 17146, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "peau de krameleon", id = 8314, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 2, canSell = true},
        {Name = "langue de krameleon", id = 14950, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "peau de mandrine", id = 8315, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 4, canSell = true},
        {Name = "oeil de mandrine", id = 14948, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 4, canSell = true},
        {Name = "peau de minoskito", id = 8312, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 2, canSell = true},
        {Name = "trompe de minoskito", id = 14949, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "plume de serpiplume", id = 8309, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 2, canSell = true},
        {Name = "pierre de serpiplume", id = 14952, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "Viande Saignante", id = 17144, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
     
        {Name = "Crinière de Troollaraj", id = 2559, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "Slip de Troollaraj", id = 2562, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 8, canSell = true},
        {Name = "Poil de Troolléolé", id = 8322, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "Laine du Trooll Furieux", id = 1694, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 5, canSell = true},
        {Name = "Gratrooll", id = 18209, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "Épaulette de Troolligark", id = 2560, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 5, canSell = true},
        {Name = "Gâtrool", id = 18198, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "Bracelet de Force de Trooll", id = 2561, maxHdv100 = 1, maxHdv10 = 2, maxHdv1 = 5, canSell = true},
        --{Name = "Viande Saignante", id = 17144, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "Bout de Blop Coco", id = 1770, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "Fleur de Blop Coco", id = 1772, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Bout de Blop Reinette", id = 1773, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "Fleur de Blop Reinette", id = 1774, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Bout de Blop Griotte", id = 1775, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "Fleur de Blop Griotte", id = 1776, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Bout de Blop Indigo", id = 1777, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "Fleur de Blop Indigo", id = 1778, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Ladre", id = 17132, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "Oreille de Bouledogre", id = 14509, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 5, canSell = true},
        {Name = "Patte de Bouledogre", id = 14510, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 3, canSell = true},
        {Name = "Plume de Gobvious", id = 14512, maxHdv100 = 4, maxHdv10 = 7, maxHdv1 = 5, canSell = true},
        {Name = "Dent de Molette", id = 14514, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 3, canSell = true},
        {Name = "Échasse de Molette", id = 14513, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 5, canSell = true},
        {Name = "Corne de Rhinoféroce", id = 14515, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 5, canSell = true},
        {Name = "Oreille de Rhinoféroce", id = 14516, maxHdv100 = 1, maxHdv10 = 7, maxHdv1 = 7, canSell = true},
        --{Name = "Viande Exustative", id = 17140, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
    }
    TableValeurVente = {
        {Name = "champa marron", id = 16166, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "champa bleu", id = 16165, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "champa vert", id = 16168, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "champa rouge", id = 16167, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "Viande Minérale", id = 17128, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "épine du champ champ", id = 377, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "ailes de moskito", id = 307, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "sporme du champ champ", id = 378, maxHdv100 = 1, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "bois vermoulu", id = 16487, maxHdv100 = 1, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "patte d'arakne", id = 365, maxHdv100 = 3, maxHdv10 = 10, maxHdv1 = 2, canSell = true},
        {Name = "Viande Faisandée", id = 17124, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "tissu pourpre", id = 2273, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 2, canSell = true},
        {Name = "scalp de bizarbwork", id = 3209, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 2, canSell = true},
        {Name = "oreille de médibwork", id = 2647, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 2, canSell = true},
        {Name = "botte trouée du mégabwork", id = 3002, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 2, canSell = true},
        {Name = "cuir violet de médibwork", id = 2271, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 2, canSell = true},
        {Name = "Viande Rassie", id = 17138, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "écaille de chef crocodaille", id = 1613, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 2, canSell = true},
        {Name = "dent de crocodaille", id = 1664, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 2, canSell = true},
        {Name = "écaille de crocodaille", id = 1663, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 2, canSell = true},
        {Name = "crâne de chef crocoaille", id = 6738, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 3, canSell = true},
        {Name = "Viande Avariée", id = 17134, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
        {Name = "Viande Frelatée", id = 17126, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
        {Name = "Viande Tendre", id = 17130, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "peau de serpentin", id = 1891, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 2, canSell = true},
        {Name = "ailes de boudard", id = 648, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "dent de larve", id = 2509, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "grelot", id = 2506, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 8, canSell = true},
        {Name = "duvet de boudard", id = 650, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 8, canSell = true},
        {Name = "Viande Ladre", id = 17132, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "pince de crabe", id = 379, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 2, canSell = true},
        {Name = "paupière d'étoile", id = 13728, maxHdv100 = 3, maxHdv10 = 6, maxHdv1 = 2, canSell = true},
        {Name = "peau de raulmops", id = 8681, maxHdv100 = 3, maxHdv10 = 6, maxHdv1 = 2, canSell = true},
        {Name = "Groin de Sanglier", id = 386, maxHdv100 = 3, maxHdv10 = 6, maxHdv1 = 2, canSell = true},
        {Name = "Viande Tendre", id = 17130, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "langue de craquelope", id = 2504, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
        {Name = "fragment de pierre polie", id = 2304, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "charbon", id = 447, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 2, canSell = true},
        {Name = "pierre de diamant", id = 543, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
        {Name = "Viande Avariée", id = 17134, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "ouvrage magique d'aloeve rate", id = 25761, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "collier de chack rat", id = 25767, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "lance de chika rat", id = 25759, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "lance pierre de scelle rate", id = 25758, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "Viande Sechée", id = 17142, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "oreille de rat plapla", id = 25762, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "tuyau rouillé de rate iboise", id = 25757, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "crâne magique de rate atine", id = 25756, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "vieux bouquin de rat li", id = 25760, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "Viande Sechée", id = 17142, maxHdv100 = 3, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "écaille d'ourobulos", id = 18368, maxHdv100 = 3, maxHdv10 = 10, maxHdv1 = 5, canSell = true},
        {Name = "Viande Sanguinolente", id = 17136, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "étoffe de dok alako", id = 8002, maxHdv100 = 3, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
        {Name = "boomrang de dok alako", id = 8075, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 5, canSell = true},
        {Name = "boomrang de warko marron", id = 8077, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 5, canSell = true},
        {Name = "poils de koalak coco", id = 8060, maxHdv100 = 2, maxHdv10 = 7, maxHdv1 = 5, canSell = true},
        {Name = "poils de koalak grioote", id = 8059, maxHdv100 = 2, maxHdv10 = 7, maxHdv1 = 5, canSell = true},
        {Name = "poils de koalak indigo", id = 8062, maxHdv100 = 2, maxHdv10 = 7, maxHdv1 = 5, canSell = true},
        {Name = "poils de koalak reinette", id = 8061, maxHdv100 = 2, maxHdv10 = 7, maxHdv1 = 5, canSell = true},
        {Name = "os de mama koalak", id = 8055, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 5, canSell = true},
        {Name = "peau de drakoalak", id = 8054, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "coiffe déchirée de drakoalak", id = 8086, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "Viande Sanguinolente", id = 17136, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
        {Name = "Viande Exustative", id = 17140, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "dentier de malle outillée", id = 2483, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "charnière cassée", id = 2482, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "griffe de robionicle", id = 6476, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "minerai étrange", id = 480, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "chaine de robot fléeau", id = 2481, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "fléau de robot fléeau", id = 2479, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "courroie en cuir", id = 2555, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        --{Name = "Viande Ladre", id = 17132, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "peau de ramane d'égoutant", id = 8483, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "peau de rat", id = 8482, maxHdv100 = 3, maxHdv10 = 8, maxHdv1 = 7, canSell = true},
        --{Name = "Viande Ladre", id = 17132, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "roue de tivelo", id = 1610, maxHdv100 = 3, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
        {Name = "peau de tivelo", id = 6740, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "couteau de roukouteau", id = 2316, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "peau de roukouteau", id = 6739, maxHdv100 = 1, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
        {Name = "bourgeon de pirolienne", id = 1611, maxHdv100 = 3, maxHdv10 = 8, maxHdv1 = 3, canSell = true},
        {Name = "ecorce de liroye merline", id = 1682, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "bombe de graboule", id = 1614, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 3, canSell = true},
        {Name = "tissu de graboule", id = 2281, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "Viande Rassie", id = 17138, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "glandes de truchtine", id = 15074, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "duvet de truchon", id = 15075, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 2, canSell = true},
        {Name = "bec de truchon", id = 15076, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "croupion de truchmuche", id = 15069, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 2, canSell = true},
        {Name = "langue de truchmuche", id = 15070, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "plume de truchideur", id = 15071, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 2, canSell = true},
        {Name = "morpion de truchideur", id = 15072, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "Viande Persillée", id = 17146, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "parchemin de cacatana", id = 18359, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 2, canSell = true},
        {Name = "jus de cacaterre", id = 18357, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "fleur de cactiflore", id = 18361, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 2, canSell = true},
        {Name = "moustaches de cactoblongo", id = 18362, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 2, canSell = true},
        {Name = "string de pampactus", id = 18363, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 2, canSell = true},
        {Name = "Viande Persillée", id = 17146, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "peau de krameleon", id = 8314, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 2, canSell = true},
        {Name = "langue de krameleon", id = 14950, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "peau de mandrine", id = 8315, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 4, canSell = true},
        {Name = "oeil de mandrine", id = 14948, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 4, canSell = true},
        {Name = "peau de minoskito", id = 8312, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 2, canSell = true},
        {Name = "trompe de minoskito", id = 14949, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "plume de serpiplume", id = 8309, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 2, canSell = true},
        {Name = "pierre de serpiplume", id = 14952, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "Viande Saignante", id = 17144, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
     
        {Name = "Crinière de Troollaraj", id = 2559, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "Slip de Troollaraj", id = 2562, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 8, canSell = true},
        {Name = "Poil de Troolléolé", id = 8322, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "Laine du Trooll Furieux", id = 1694, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 5, canSell = true},
        {Name = "Gratrooll", id = 18209, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "Épaulette de Troolligark", id = 2560, maxHdv100 = 1, maxHdv10 = 4, maxHdv1 = 5, canSell = true},
        {Name = "Gâtrool", id = 18198, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
        {Name = "Bracelet de Force de Trooll", id = 2561, maxHdv100 = 1, maxHdv10 = 2, maxHdv1 = 5, canSell = true},
        {Name = "Viande Saignante", id = 17144, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "Bout de Blop Coco", id = 1770, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "Fleur de Blop Coco", id = 1772, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Bout de Blop Reinette", id = 1773, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "Fleur de Blop Reinette", id = 1774, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Bout de Blop Griotte", id = 1775, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "Fleur de Blop Griotte", id = 1776, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        {Name = "Bout de Blop Indigo", id = 1777, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 2, canSell = true},
        {Name = "Fleur de Blop Indigo", id = 1778, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, canSell = true},
        --{Name = "Viande Ladre", id = 17132, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    
        {Name = "Oreille de Bouledogre", id = 14509, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 5, canSell = true},
        {Name = "Patte de Bouledogre", id = 14510, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 3, canSell = true},
        {Name = "Plume de Gobvious", id = 14512, maxHdv100 = 4, maxHdv10 = 7, maxHdv1 = 5, canSell = true},
        {Name = "Dent de Molette", id = 14514, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 3, canSell = true},
        {Name = "Échasse de Molette", id = 14513, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 5, canSell = true},
        {Name = "Corne de Rhinoféroce", id = 14515, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 5, canSell = true},
        {Name = "Oreille de Rhinoféroce", id = 14516, maxHdv100 = 1, maxHdv10 = 7, maxHdv1 = 7, canSell = true},
        --{Name = "Viande Exustative", id = 17140, maxHdv100 = 4, maxHdv10 = 2, maxHdv1 = 2, canSell = true},
    }
end

local NeedToReturnBank = false
local NeedToSell = false

local cptActualiser = 1
local hdvActualise = false


local hdvFull = false
local checkHdv = false
local DebutDuScript = true


local function IncrementTable(i, Taille)
    local toReturn = (i + 1) % (Taille + 1)
    return (toReturn > 0) and toReturn or (toReturn == 0) and 1
end


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



local function CheckEndFight(message)
    local tableAchatEnergie = {
        {name = "Pain des champs", id = 1737, Price100 = 0 , Price10 = 0, Price1 = 0},
        {name = "Potion axel raide", id = 16722, Price100 = 0, Price10 = 0, Price1 = 0},
        {name = "Potion Raide rêve", id = 11506, Price100 = 0, Price10 = 0, Price1 = 0},
        {name = "Potion Raide izdaide", id = 16414, Price100 = 0, Price10 = 0, Price1 = 0},
        {name = "Estouffade de Morue", id = 16481, Price100 = 0, Price10 = 0, Price1 = 0},
        {name = "Filet Mignon", id = 17199, Price100 = 0, Price10 = 0, Price1 = 0},
        {name = "Aileron de Requin", id = 1838, Price100 = 0, Price10 = 0, Price1 = 0},
        {name = "Daube aux Epices", id = 17195, Price100 = 0, Price10 = 0, Price1 = 0},
        {name = "Mantou", id = 527, Price100 = 0, Price10 = 0, Price1 = 0},
        {name = "Andouillette de Gibier", id = 17203, Price100 = 0, Price10 = 0, Price1 = 0},
        {name = "Espadon Poellé", id = 16485, Price100 = 0, Price10 = 0, Price1 = 0},
        {name = "Aile de Raie", id = 1814, Price100 = 0, Price10 = 0, Price1 = 0},
    }
    if not message.results[1].alive then

        CompteurDeath = CompteurDeath + 1

        for i, element in ipairs(TableArea) do
            if element.Farmer then
                if CompteurDeath < 2 then
                    global:printSuccess(CompteurDeath .. " ème fois qu'on perd un combat dans cette zone, on continue de la farm")
                    for index, element2 in ipairs(element.Zone) do
                        element2[3] = (index == 1)
                    end
                    for _, element in ipairs(tableAchatEnergie) do
                        while inventory:itemCount(element.id) > 0 and character:maxEnergyPoints() - character:energyPoints() ~= 0 do
                            inventory:useItem(element.id)
                        end
                    end
                else
                    global:printSuccess(CompteurDeath .. " ème fois qu'on perd un combat dans cette zone, on farm la suivante")
                    inventory:equipItem(14966, 28)
                    for index, element2 in ipairs(TableArea) do
                        if not TableArea[IncrementTable(i + index - 1, #TableArea)].Stop then
                            global:printSuccess(IncrementTable(i + index - 1, #TableArea) .. " ème zone")
                            element.Farmer = false
                            TableArea[IncrementTable(i + index - 1, #TableArea)].Farmer = true
                            for index2, element3 in ipairs(TableArea[IncrementTable(i + index - 1, #TableArea)].Zone) do
                                element3[3] = (index2 == 1)
                            end
                            break
                        end
                    end
                    for _, element in ipairs(tableAchatEnergie) do
                        while inventory:itemCount(element.id) > 0 and character:maxEnergyPoints() - character:energyPoints() ~= 0 do
                            inventory:useItem(element.id)
                        end
                    end
                    CompteurDeath = 0
                end
                break
            end
        end
    end
end

function messagesRegistering()
	developer:registerMessage("HaapiShopApiKeyMessage", _HaapiShopApiKeyMessage)
	developer:registerMessage("HaapiConfirmationMessage", _HaapiConfirmationMessage)
    developer:registerMessage("GameFightEndMessage", CheckEndFight)
    developer:registerMessage("GameMapNoMovementMessage", function() PersoBloque = true end)
end

local function antiModo()
    -- if global:isModeratorPresent(30) then
	-- 	timerdisconnect = math.random(30000, 36000) 
    --     if not map:onMap("0,0") then
    --         map:changeMap("havenbag")
    --     end
    --     global:printError("Modérateur présent. On attend " .. timerdisconnect / 1000 .. " secondes")

    --     if global:thisAccountController():getAlias():find("Combat2") then
    --         global:editAlias("Combat2 " .. character:server() .. " [MODO]", true)
    --     elseif global:thisAccountController():getAlias():find("Combat3") then
    --         global:editAlias("Combat3 " .. character:server() .. " [MODO]", true)
    --     elseif global:thisAccountController():getAlias():find("Combat4") then
    --         global:editAlias("Combat4 " .. character:server() .. " [MODO]", true)
    --     else
    --         global:editAlias("Combat " .. character:server() .. " [MODO]", true)
    --     end

    --     global:delay(timerdisconnect)
    --     customReconnect(timerdisconnect / 1000)
	-- end
end

local function settOrnament(ornamentID)
    message = developer:createMessage("OrnamentSelectRequestMessage")
    message.ornamentId = ornamentID
    developer:sendMessage(message)
end

local function CheckOrnement()

    local TableOrnementLvl ={
        {Lvl = 525, Id = 120},
        {Lvl = 475, Id = 119},
        {Lvl = 450, Id = 118},
        {Lvl = 425, Id = 117},
        {Lvl = 375, Id = 116},
        {Lvl = 350, Id = 115},
        {Lvl = 325, Id = 114},
        {Lvl = 275, Id = 113},
        {Lvl = 250, Id = 112},
        {Lvl = 225, Id = 111},
    }

    for _, element in ipairs(TableOrnementLvl) do
        if character:level() >= element.Lvl then
            settOrnament(element.Id)
            break
        end
    end
end

local function ProcessSell()
    NeedToSell = false
    if not DebutDuScript then
        NeedToReturnBank = true
    end

    if mount:hasMount() and not StopAchatGoujon then
        buyAndfeedDD()

        if not mount:isRiding() then
            mount:toggleRiding()
        end
    end
        
    if not DebutDuScript then

        table.sort(TableVente, function(a, b) return inventory:itemCount(a.id) > inventory:itemCount(b.id) end)
        table.sort(TableValeurVente, function(a, b) return inventory:itemCount(a.id) > inventory:itemCount(b.id) end)

        HdvSell()

        local indexSuivant = 0

	    for i, element in ipairs(TableVente) do
            if inventory:itemCount(element.id) == 0 then 
                indexSuivant = i
                global:printSuccess("on a plus rien à vendre") 
                break 
            end
            local Priceitem = GetPricesItem(element.id)
            local itemSold = false

		    cpt = get_quantity(element.id).quantity["100"]
            Priceitem3 = math.floor(((Priceitem.Price100 == nil) or (Priceitem.Price100 == 0) or (Priceitem.Price100 == 1)) and sale:getAveragePriceItem(element.id, 3) * 1.5 or Priceitem.Price100)
            element.maxHdv100 = ((sale:availableSpace() > 50) or (Priceitem3 > 20000)) and TableValeurVente[i].maxHdv100 or 0
            element.remaining100 = element.maxHdv100 - cpt
    	    while (inventory:itemCount(element.id) >= 100) and (sale:availableSpace() > 0) and (cpt < element.maxHdv100) and (sale:availableSpace() > 50 or Priceitem3 > 20000) do 
                sale:sellItem(element.id, 100, Priceitem3 - 1) 
                global:printSuccess("1 lot de " .. 100 .. " x " .. inventory:itemNameId(element.id)  .. " à " .. Priceitem3 - 1 .. "kamas")
                cpt = cpt + 1
                itemSold = true
            end


		    cpt = get_quantity(element.id).quantity["10"]
            local Priceitem2 = math.floor(((Priceitem.Price10 == nil) or (Priceitem.Price10 == 0) or (Priceitem.Price10 == 1)) and sale:getAveragePriceItem(element.id, 2) * 1.5 or Priceitem.Price10)
            if Priceitem2 < 4000 then
                element.maxHdv10 = ((sale:availableSpace() > 50) or (Priceitem2 > 8000)) and math.min(TableValeurVente[i].maxHdv10 / 2, 5) or 0 
            elseif Priceitem2 < 8000 then
                element.maxHdv10 = ((sale:availableSpace() > 50) or (Priceitem2 > 8000)) and math.max(TableValeurVente[i].maxHdv10 / 2, 8) or 0
            else
                element.maxHdv10 = ((sale:availableSpace() > 50) or (Priceitem2 > 8000)) and TableValeurVente[i].maxHdv10 or 0
            end
            element.remaining10 = element.maxHdv10 - cpt
            while (inventory:itemCount(element.id) >= 10) and (sale:availableSpace() > 0) and (cpt < element.maxHdv10) and (sale:availableSpace() > 50 or Priceitem2 > 8000) do 
                sale:sellItem(element.id, 10, Priceitem2 - 1) 
                global:printSuccess("1 lot de " .. 10 .. " x " .. inventory:itemNameId(element.id) .. " à " .. Priceitem2 - 1 .. "kamas")
                cpt = cpt + 1
                itemSold = true
		    end

            cpt = get_quantity(element.id).quantity["1"]
            local Priceitem1 = math.floor(((Priceitem.Price1 == nil) or (Priceitem.Price1 == 0) or (Priceitem.Price1 == 1)) and sale:getAveragePriceItem(element.id, 1) * 1.5 or Priceitem.Price1)
            if Priceitem1 < 500 then
                element.maxHdv1 = ((sale:availableSpace() > 50) or (Priceitem1 > 4000)) and math.min(TableValeurVente[i].maxHdv1, 3) or 0
            elseif Priceitem1 < 800 then
                element.maxHdv1 = ((sale:availableSpace() > 50) or (Priceitem1 > 4000)) and math.max(TableValeurVente[i].maxHdv1 / 2, 5) or 0
            else
                element.maxHdv1 = ((sale:availableSpace() > 50) or (Priceitem1 > 4000)) and TableValeurVente[i].maxHdv1 or 0
            end
            element.remaining1 = element.maxHdv1 - cpt
            while (inventory:itemCount(element.id) >= 1) and (sale:availableSpace() > 0) and ((cpt < element.maxHdv1) and Priceitem1 > 500) and (sale:availableSpace() > 50 or Priceitem1 > 4000) do 
                sale:sellItem(element.id, 1, Priceitem1 - 1) 
                global:printSuccess("1 lot de " .. 1 .. " x " .. inventory:itemNameId(element.id)  .. " à " .. Priceitem1 - 1 .. "kamas")
                cpt = cpt + 1
                itemSold = true
            end

            if itemSold then
                randomDelay()
            end

        end

        for i = indexSuivant, #TableVente do
            TableVente[i].remaining100 = TableVente[i].maxHdv100 - get_quantity(TableVente[i].id).quantity["100"]
            TableVente[i].remaining10 = TableVente[i].maxHdv10 - get_quantity(TableVente[i].id).quantity["10"]
            TableVente[i].remaining1 = TableVente[i].maxHdv1 - get_quantity(TableVente[i].id).quantity["1"]
        end

	    if cptActualiser >= 3 and not hdvActualise and character:kamas() > 150000 then
		    global:printSuccess("Actualisation des prix")
            hdvActualise = true
		    cptActualiser = 0
		    sale:updateAllItems()
            global:leaveDialog()
            global:delay(500)
            HdvSell()
        else
		    cptActualiser = cptActualiser + 1
	    end

        if sale:availableSpace() == 0 then 
            hdvFull = true 
            global:printError("l'hdv est plein") 
        else
            hdvFull = false
        end

	    global:leaveDialog()
	    global:delay(500)
    else
        inventory:equipItem(14966, 28)
        local tableIdSorts = {{Id = 12751, Lvl = 185}, {Id = 12731, Lvl = 150}, {Id = 12728, Lvl = 150}, {Id = 12725, Lvl = 150}, {Id = 12763, Lvl = 150}}
        for _, element in ipairs(tableIdSorts) do
            if character:level() >= element.Lvl then
                message = developer:createMessage("SpellVariantActivationRequestMessage")
                message.spellId = element.Id
                developer:sendMessage(message)
                global:delay(math.random(1000, 2500))
            end
        end
    end

    TableArea = TableAreaDeBase

    HdvSell()

	-- check de l'hdv pour voir si le maximum de cette ressource a été atteinte
	for _, element in ipairs(TableVente) do
        if get_quantity(element.id).quantity["100"] >= element.maxHdv100 and get_quantity(element.id).quantity["10"] >= element.maxHdv10 and get_quantity(element.id).quantity["1"] >= element.maxHdv1 then
            element.canSell = false
        else
            element.canSell = true
        end
	end


    for i, element in ipairs(TableArea) do
        global:printSuccess(i)
        local compteur = 0
        local totalPrice = 0
        for j, element2 in ipairs(element.ListeVenteId) do
            local priceHdv = GetPricesItem(element2).TrueAveragePrice
            totalPrice = totalPrice + ((priceHdv ~= 0 and priceHdv ~= nil) and priceHdv or sale:getAveragePriceItem(element2, 1))

            for _, element3 in ipairs(TableVente) do -- trouve l'id dans la tableVente
                if element2 == element3.id then

                    compteur = compteur + 1

                    if element3.maxHdv100 == 0 and element3.maxHdv10 == 0 and element3.maxHdv1 == 0 then
                        element.PourcentageHdv = element.PourcentageHdv + 1

                    elseif element3.maxHdv10 == 0 and element3.maxHdv1 == 0 then
                        element.PourcentageHdv = element.PourcentageHdv + (get_quantity(element2).quantity["100"] / (element3.maxHdv100)) < 1 and (get_quantity(element2).quantity["100"] / (element3.maxHdv100)) or 1

                    elseif element3.maxHdv100 == 0 and element3.maxHdv1 == 0 then
                        element.PourcentageHdv = element.PourcentageHdv + (get_quantity(element2).quantity["10"] / (element3.maxHdv10)) < 1 and (get_quantity(element2).quantity["10"] / (element3.maxHdv10)) or 1

                    elseif element3.maxHdv100 == 0 and element3.maxHdv10 == 0 then
                        element.PourcentageHdv = element.PourcentageHdv + (get_quantity(element2).quantity["1"] / (element3.maxHdv1)) < 1 and (get_quantity(element2).quantity["1"] / (element3.maxHdv1)) or 1

                    elseif element3.maxHdv1 == 0 then
                        element.PourcentageHdv = element.PourcentageHdv + (get_quantity(element2).quantity["100"] + get_quantity(element2).quantity["10"]) / (element3.maxHdv100 + element3.maxHdv10) < 1 
                                                                        and (get_quantity(element2).quantity["100"] + get_quantity(element2).quantity["10"]) / (element3.maxHdv100 + element3.maxHdv10) or 1

                    elseif element3.maxHdv10 == 0 then
                        element.PourcentageHdv = element.PourcentageHdv + (get_quantity(element2).quantity["100"] + get_quantity(element2).quantity["1"]) / (element3.maxHdv100 + element3.maxHdv1) < 1
                                                                        and (get_quantity(element2).quantity["100"] + get_quantity(element2).quantity["1"]) / (element3.maxHdv100 + element3.maxHdv1) or 1

                    elseif element3.maxHdv100 == 0 then
                        element.PourcentageHdv = element.PourcentageHdv + (get_quantity(element2).quantity["10"] + get_quantity(element2).quantity["1"]) / (element3.maxHdv10 + element3.maxHdv1) < 1
                                                                        and (get_quantity(element2).quantity["10"] + get_quantity(element2).quantity["1"]) / (element3.maxHdv10 + element3.maxHdv1) or 1

                    else
                        element.PourcentageHdv = element.PourcentageHdv + (get_quantity(element2).total_lots / (element3.maxHdv100 + element3.maxHdv10 + element3.maxHdv1)) < 1
                                                                        and (get_quantity(element2).total_lots / (element3.maxHdv100 + element3.maxHdv10 + element3.maxHdv1)) or 1

                    end

                end
            end
        end

        element.TotalPrice = totalPrice
        global:printSuccess(#element.ListeVenteId .. " ressources vendables sur cette zone pour un total de prix unitaire de " .. totalPrice)
        element.PourcentageHdv = math.floor(element.PourcentageHdv * 100 / compteur)		
        global:printSuccess("% in Hdv : " .. element.PourcentageHdv)
        if not global:thisAccountController():getAlias():find("Combat4") then
            element.Stop = element.PourcentageHdv >= 90 or (totalPrice / #element.ListeVenteId) < 350
        end
        global:printSuccess(element.Stop)
    end

    -- check si il a plus de 5 zones farmables, si non : on va farmer toutes les zones 
    local compteur = 0
    for _, element in ipairs(TableArea) do
        compteur = compteur + (element.Stop and 0 or 1)
    end
    if compteur < 5 then
        for _, element in ipairs(TableArea) do
            element.Stop = false
        end
    end

	global:leaveDialog()

    if global:thisAccountController():getAlias():find("Combat3") then
        local moitie = 0
        for _, element in ipairs(TableArea) do
            moitie = moitie + (not element.Stop and 1 or 0) 
        end
        moitie = moitie / 2
        for i = moitie + 1, #TableArea do
            table.remove(TableArea, moitie + 1)
        end
        table.sort(TableArea, function(a1, a2) return a1.PourcentageHdv < a2.PourcentageHdv end)
    elseif global:thisAccountController():getAlias():find("Combat1") or global:thisAccountController():getAlias():find("Combat2") or global:thisAccountController():getAlias():find("Combat4") then
        table.sort(TableArea, function(a1, a2) return a1.PourcentageHdv < a2.PourcentageHdv end)
    end

    DebutDuScript = false
    global:printSuccess("okkk")

    for _, element in ipairs(TableArea) do
        element.Farmer = false
        for _, element2 in ipairs(element.Zone) do
            element2[3] = false
        end
        element.PourcentageHdv = 0
    end
    for _, element in ipairs(TableArea) do
        if not element.Stop or global:thisAccountController():getAlias():find("Combat4") then
            element.Farmer = true
            element.Zone[1][3] = true
            break
        end
    end

    global:printSuccess("Actualisaton de l'ornement")
    global:delay(500)
    CheckOrnement()
    global:delay(500)

    DDToSell = GetDDLvl100()
	map:changeMap("top")
end


local function ProcessBank()
	NeedToReturnBank = false

    npc:npcBank(-1)
    global:delay(500) 

	if exchange:storageKamas() > 0 then
        exchange:getKamas(0)
		global:delay(500)
	elseif exchange:storageKamas() == 0 then
		global:delay(500)
	end	

    if hdvFull then
		exchange:putAllItemsExcept({9686, 9687, 9688, 10418, 16881, 16960, 16864, 10418})
    else
        for _, element in ipairs(TableVente) do
            if inventory:itemCount(element.id) > 0 then
                exchange:putItem(element.id, inventory:itemCount(element.id))
            end
        end
    end
    if not hdvFull then
        local cpt = 0
        for _, element in ipairs(TableVente) do
            local podsAvailable = inventory:podsMax() - inventory:pods()
            local TotalMax = element.remaining100 * 100 + element.remaining10 * 10 + element.remaining1
            local QuantiteAPrendre = math.min(exchange:storageItemQuantity(element.id), TotalMax, math.floor(podsAvailable * 0.95 / inventory:itemWeight(element.id)))
            if ((element.remaining100 > 0 and QuantiteAPrendre >= 100) or (element.remaining10 > 0 and QuantiteAPrendre >= 10)) and element.canSell then
                StopAchatGoujon = true
                exchange:getItem(element.id, QuantiteAPrendre)
                cpt = cpt + 1
            end
        end
        NeedToSell = cpt > 5
    end
    
    if exchange:storageItemQuantity(14966) > 0 then
        exchange:getItem(14966, 1)
        equipCompagnon = true
    end
    -- prendre les archi monstre pas vendus
    if exchange:storageItemQuantity(10418) > 0 then
        exchange:getItem(10418, exchange:storageItemQuantity(10418))
    end

    -- on récupère les archi en banque
    local storage = exchange:storageItems()
    for _, element in ipairs(storage) do
        if inventory:itemTypeId(element) == 97 then
            exchange:getItem(element, 1)
        end
    end
    hdvFull = false

	global:leaveDialog()
    
    if equipCompagnon then inventory:equipItem(14966, 28) end

    -- if not NeedToSell and (global:thisAccountController():getAlias():find("Combat3") or global:thisAccountController():getAlias():find("Combat4")) then
    --     cptReconnect = cptReconnect + 1
    --     if cptReconnect > 0 then
    --         global:reconnectBis(math.random(200, 600))
    --     end
    -- end
	return map:door(518)
end


local function WhichArea()
    hdvActualise = false
    for i in ipairs(TableArea) do
        local Zone = TableArea[i].Zone
        for j in ipairs(Zone) do

            if map:onMap(Zone[j][2]) and Zone[j][3] and TableArea[i].Farmer and (j + 1) <= #Zone then
                -- si on arrive à la map de changement de sous zone
                MAX_MONSTERS = TableArea[i].MaxMonster
                MIN_MONSTERS = TableArea[i].MinMonster
                Zone[j][3] = false
                Zone[j + 1][3] = true
                return treatMaps(Zone[j + 1][1], function() map:changeMap("havenbag") end)

            elseif map:onMap(Zone[j][2]) and Zone[j][3] and TableArea[i].Farmer and (j + 1) > #Zone then
                global:printSuccess(i .. " ème zone")
                CompteurDeath = 0
                -- si on arrive à la map de changement de sous zone et à la fin de la table
                Zone[j][3] = false
                TableArea[i].Farmer = false

                for index, element in ipairs(TableArea) do -- on regarde la prochaine qu'on peut farmer
                    local ZoneSuivante = TableArea[IncrementTable(i + index - 1, #TableArea)]
                    
                    if not ZoneSuivante.Stop or global:thisAccountController():getAlias():find("Combat4") then

                        MAX_MONSTERS = ZoneSuivante.MaxMonster
                        MIN_MONSTERS = ZoneSuivante.MinMonster

                        ZoneSuivante.Farmer = true
                        ZoneSuivante.Zone[1][3] = true
                        return treatMaps(ZoneSuivante.Zone[1][1], function() map:changeMap("havenbag") end)

                    end

                end
                -- si on a pas trouvé d'autre zone, on refarm la même

                return treatMaps(Zone[1][1], function() map:changeMap("havenbag") end)

            elseif Zone[j][3] and TableArea[i].Farmer then
                MAX_MONSTERS = TableArea[i].MaxMonster
                MIN_MONSTERS = TableArea[i].MinMonster

                return treatMaps(Zone[j][1], function() map:changeMap("havenbag") end)

            end
        end 
    end
end


function move()
    handleDisconnection()
    mapDelay()

    if global:thisAccountController():getAlias():find("Draconiros") and character:server() ~= "Draconiros" then
        global:thisAccountController():forceServer("Draconiros")
        global:disconnect()
    end
    StopAchatGoujon = false
    archionmap()

    if global:afterFight() then
        ManageXpMount()
    end

    -- si il y a une  dd à vendre, on y va
    if #DDToSell > 0 and character:level() > 250 then
        global:printSuccess("on va vendre la dd")
        if not map:onMap("-30,-59") then
            return treatMaps({
                {map = "0,0", path = "zaap(212600323)"},
                {map = "-31,-56", path = "zaapi(212601345)"},
                {map = "-30,-58", path = "top"},
            }, function() map:changeMap("havenbag") end)
        else
            if not map:onMap(212601350) then
                for _, element in ipairs(DDToSell) do
                    SellDD(element[1], element[2])
                end
                UpdatePriceDD()
                DDToSell = GetDDLvl100()
            end
        end
    end

    if character:level() > 250 and not global:thisAccountController():getAlias():find("Combat3") then
        local myMount = mount:myMount()
        if myMount ~= nil then
            if myMount.energy < 100 then
                global:printSuccess("la dd n'a plus d'énergie, on va la remettre au max")
                return treatMaps({
                    {map ="0,0", path = "zaap(212600323)"},				
                    {map = "212600322", path = "bottom(552)"}, -- Map extérieure de la banque de bonta
                    {map = "-31,-56", path = "bottom"},
                    {map = "-31,-55", path = "bottom"},
                    {map = "-31,-54", path = "right"},
                    {map = "212601350", custom = ProcessSell}, -- Map HDV ressources bonta
                }, function() map:changeMap("havenbag") end)
            end
            if myMount.level == 100 then
                global:printSuccess("dd level 100, on la remets en certificat")
                if not map:onMap("212601346") then
                    return treatMaps({
                        {map = "0,0", path = "zaap(212600323)"},
                        {map = "-31,-56", path = "zaapi(212601345)"},
                        {map = "-30,-59", path = "bottom"},
                    }, function() map:changeMap("havenbag") end)
                else
                    map:moveToCell(332)
                    map:door(357)
                    developer:suspendScriptUntil("ExchangeStartOkMountWithOutPaddockMessage", 5000, true)
                    local message = developer:createMessage("ExchangeHandleMountsMessage")
                    message.actionType = 13
                    message.ridesId = {myMount.id}
                    developer:sendMessage(message)
                    developer:suspendScriptUntil("InventoryWeightMessage", 2000, true)
                    global:delay(math.random(500, 1500))
                    global:leaveDialog()
                    global:delay(math.random(500, 1500))
                    DDToSell = GetDDLvl100()  
                end
            end
        elseif not myMount then
            local ddEquipables = GetDDInfLvl100()
            if #ddEquipables > 0 then
                -- si on peut équiper une dd, on va l'équiper
                global:printSuccess("on va équiper la dd")
                if not map:onMap("212601346") then
                    return treatMaps({
                        {map = "0,0", path = "zaap(212600323)"},
                        {map = "-31,-56", path = "zaapi(212601345)"},
                        {map = "-30,-59", path = "bottom"},
                    }, function() map:changeMap("havenbag") end)
                else
                    map:moveToCell(332)
                    map:door(357)
                    developer:suspendScriptUntil("ExchangeStartOkMountWithOutPaddockMessage", 5000, true)
                    local message = developer:createMessage("ExchangeHandleMountsMessage")
                    message.actionType = 15
                    message.ridesId = {ddEquipables[1][2]}
                    developer:sendMessage(message)
                    developer:suspendScriptUntil("InventoryWeightMessage", 2000, true)
                    global:delay(math.random(500, 1500))
                    global:leaveDialog()
                    global:delay(math.random(500, 1500))
                    ManageXpMount()
                end
            elseif character:kamas() > 7000000 then
                global:printSuccess("On va acheter une nouvelle dd")
                if not map:onMap("-30,-59") then
                    return treatMaps({
                        {map = "0,0", path = "zaap(212600323)"},
                        {map = "-31,-56", path = "zaapi(212601345)"},
                        {map = "-30,-58", path = "top"},
                    }, function() map:changeMap("havenbag") end)
                else
                    AchatMostProfitableDD()
                end
                if GetNbDD() > 5 then
                    global:printError("BUG DD")
                    global:disconnect()
                end
            end
    
        end
    elseif character:level() < 251 and not mount:hasMount() then
        local ddEquipables = GetDDLvl100()
        if #ddEquipables > 0 then
            -- si on peut équiper une dd, on va l'équiper
            global:printSuccess("on va équiper la dd")
            if not map:onMap("212601346") then
                return treatMaps({
                    {map = "0,0", path = "zaap(212600323)"},
                    {map = "-31,-56", path = "zaapi(212601345)"},
                    {map = "-30,-59", path = "bottom"},
                }, function() map:changeMap("havenbag") end)
            else
                map:moveToCell(332)
                map:door(357)
                developer:suspendScriptUntil("ExchangeStartOkMountWithOutPaddockMessage", 5000, true)
                local message = developer:createMessage("ExchangeHandleMountsMessage")
                message.actionType = 15
                message.ridesId = {ddEquipables[1][2]}
                developer:sendMessage(message)
                developer:suspendScriptUntil("InventoryWeightMessage", 2000, true)
                global:delay(math.random(500, 1500))
                global:leaveDialog()
                global:delay(math.random(500, 1500))
                ManageXpMount()
            end
        else
            global:printSuccess("On va acheter une nouvelle dd")
            if not map:onMap("-30,-59") then
                return treatMaps({
                    {map = "0,0", path = "zaap(212600323)"},
                    {map = "-31,-56", path = "zaapi(212601345)"},
                    {map = "-30,-58", path = "top"},
                }, function() map:changeMap("havenbag") end)
            else
                global:printSuccess("dac")
                BuyDDTurquoise100()
                global:printSuccess("dac2")
                if GetNbDD() > 2 then
                    global:printError("BUG DD")
                    global:disconnect()
                end
            end
        end
    end

    for i = 1, NB_COMBAT do
        if not global:thisAccountController():getAlias():find("Combat" .. i) then
            global:editAlias("Combat" .. i .. " " .. character:server() .. " " .. getRemainingSubscription(true), true)
        end
    end

    if getRemainingSubscription(true) <= 0 and (character:kamas() > ((character:server() == "Draconiros") and 600000 or 1100000)) then
        Abonnement()
    elseif getRemainingHoursSubscription() < 4 and character:server() == "Draconiros" then
        Abonnement()
    elseif getRemainingSubscription(true) < 0 then
        Abonnement()
    end

    if NeedToSell then
		return {
			{map ="0,0", path = "zaap(212600323)"},				
			{map = "212600322", path = "bottom(552)"}, -- Map extérieure de la banque de bonta
			{map = "-31,-56", path = "bottom"},
			{map = "-31,-55", path = "bottom"},
			{map = "-31,-54", path = "right"},
			{map = "212601350", custom = ProcessSell}, -- Map HDV ressources bonta
		}
	end

    if NeedToReturnBank then
        return {
            {map = "-30,-55", path = "top"},
			{map = "-30,-56", door = "437"},
			{map = "-31,-56", path = "top"},
            {map = "212600322", door = "512"}, -- Map extérieure de la banque de bonta
            {map = "217060352", custom = ProcessBank}, -- Dépôt de l'inventaire et sortie de la banque
        }
    end

    minKamas = (getRemainingSubscription(true) == 0) and 1700000 or 300000

    forwardKamasBotBankIfNeeded(2500000, minKamas, 120, 6)
    
    antiModo()

    if inventory:itemCount(678) >= 200 or inventory:itemCount(680) >= 20 or character:energyPoints() < 5000 then
		return treatMaps(AreaEnergieAndSellParcho, function() map:changeMap("havenbag") end)
    end

    if DebutDuScript then
        if map:currentSubArea() == "Canyon sauvage" then
            return
            {
                {map = "-16,11", path = "top"},
                {map = "-16,10", path = "left"},
                {map = "-17,10", path = "bottom"},
                {map = "-17,11", path = "left"},
                {map = "-18,11", path = "bottom"},
                {map = "-18,12", path = "left"},
                {map = "-19,12", path = "top(6)"},
                {map = "-19,11", path = "top"},
                {map = "-19,10", path = "right"},
                {map = "-18,10", path = "top"},
                {map = "-18,9", path = "right"},
                {map = "-19,9", path = "right"},
                {map = "-17,9", path = "top"},
                {map = "-17,8", path = "top"},
            }
        elseif getCurrentAreaName() == "Île du Minotoror" then 
            return
            {
                {map = "34476296", custom = function() npc:npc(783, 3) npc:reply(-2) npc:reply(-1) end},
                {map = "-43,-17", path = "bottom"},
                {map = "-43,-18", path = "bottom"},
                {map = "-43,-19", path = "bottom"},
                {map = "-40,-19", path = "bottom"},
                {map = "-40,-18", path = "bottom"},
                {map = "-40,-17", path = "bottom"},
                {map = "-40,-16", path = "left"},
                {map = "-41,-16", path = "left"},
                {map = "-42,-16", path = "left"},
                {map = "-41,-17", path = "left"},
                {map = "-41,-18", path = "left"},
                {map = "-42,-18", path = "left"},
                {map = "-42,-17", path = "top"},
                {map = "-41,-19", path = "left"},
                {map = "-42,-19", path = "left"},
                {map = "-43,-16", custom = function() npc:npc(770, 3) npc:reply(-1) npc:reply(-1) end}
            } 
        elseif map:onMap("11,10") then
            map:changeMap("left")
        end
        if not map:onMap("0,0") and not map:onMap("212600323") and not map:onMap("212600838") and not map:onMap("212600837") and not map:onMap("212601350") then
            map:changeMap("havenbag")
        end
        if inventory:itemCount(14966) == 0 and not ombreChecked and character:kamas() > 1000000 then
            return {
                {map = "0,0", path = "zaap(212600323)"},
                {map = "212600323", path = "bottom"},
                {map = "-31,-55", custom = function()
                    if (inventory:itemCount(14966) == 0) then
                        HdvBuy()
                        sale:buyItem(14966, 1, 1000000)
                        global:leaveDialog()
                        if inventory:itemCount(14966) > 0 then
                            inventory:equipItem(14966, 28)
                        end
                        ombreChecked = true
                        map:changeMap("right")
                    end
                end}
            }
        end
        return {
            {map = "212600323", path = "bottom"},
            {map = "212600837", path = "bottom"},
            {map = "212600838", path = "right"},
            {map = "0,0", path = "zaap(212600323)"},
            {map = "212601350", custom = ProcessSell}, -- Map HDV ressources bonta
        }
    end

    return WhichArea()
end


function banned()
    global:editAlias(global:thisAccountController():getAlias() .. " [BAN]", true)
end


function bank()
    mapDelay()
    -- si il y a une  dd à vendre, on y va
    if #DDToSell > 0 and character:level() > 250 then
        global:printSuccess("on va vendre la dd")
        if not map:onMap("-30,-59") then
            return treatMaps({
                {map = "0,0", path = "zaap(212600323)"},
                {map = "-31,-56", path = "zaapi(212601345)"},
                {map = "-30,-58", path = "top"},
            }, function() map:changeMap("havenbag") end)
        else
            for _, element in ipairs(DDToSell) do
                SellDD(element[1], element[2])
            end
            DDToSell = GetDDLvl100()
        end
    end

    if NeedToSell then
		return {
			{map ="0,0", path = "zaap(212600323)"},				
			{map = "212600322", path = "bottom(552)"}, -- Map extérieure de la banque de bonta
			{map = "-31,-56", path = "bottom"},
			{map = "-31,-55", path = "bottom"},
			{map = "-31,-54", path = "right"},
            {map = "220200961", path = "zaapi(212601350)"},
			{map = "212601350", custom = ProcessSell}, -- Map HDV ressources bonta
		}
	end

    if NeedToReturnBank then
        return {
            {map = "-30,-55", path = "top"},
			{map = "-30,-56", door = "437"},
			{map = "-31,-56", path = "top"},
            {map = "220200961", path = "zaapi(212600322)"},
            {map = "212600322", door = "512"}, -- Map extérieure de la banque de bonta
            {map = "217060352", custom = ProcessBank}, -- Dépôt de l'inventaire et sortie de la banque
        }
    end

    if map:currentSubArea() == "Canyon sauvage" then
        return
        {
            {map = "-16,11", path = "top"},
            {map = "-16,10", path = "left"},
            {map = "-17,10", path = "bottom"},
            {map = "-17,11", path = "left"},
            {map = "-18,11", path = "bottom"},
            {map = "-18,12", path = "left"},
            {map = "-19,12", path = "top(6)"},
            {map = "-19,11", path = "top"},
            {map = "-19,10", path = "right"},
            {map = "-18,10", path = "top"},
            {map = "-18,9", path = "right"},
            {map = "-19,9", path = "right"},
            {map = "-17,9", path = "top"},
            {map = "-17,8", path = "top"},
        }
    elseif map:currentSubArea() == "Île du Minotoror" then 
        return
        {
            {map = "-43,-17", path = "bottom"},
            {map = "-43,-18", path = "bottom"},
            {map = "-43,-19", path = "bottom"},
            {map = "-40,-19", path = "bottom"},
            {map = "-40,-18", path = "bottom"},
            {map = "-40,-17", path = "bottom"},
            {map = "-40,-16", path = "left"},
            {map = "-41,-16", path = "left"},
            {map = "-42,-16", path = "left"},
            {map = "-41,-17", path = "left"},
            {map = "-41,-18", path = "left"},
            {map = "-42,-18", path = "left"},
            {map = "-42,-17", path = "top"},
            {map = "-41,-19", path = "left"},
            {map = "-42,-19", path = "left"},
            {map = "-43,-16", custom = function() npc:npc(770, 3) npc:reply(-1) npc:reply(-1) end}
        } 
    end

    
	if map:currentMap() == "11,10" then map:changeMap("right") end
	
    if not map:onMap("0,0") and not map:onMap("212600323") and not map:onMap("212600838") and not map:onMap("212600837") and not map:onMap("212601350")
        and not map:onMap("220200961") then
        map:changeMap("havenbag")
    end

    Pierre_Ames_Pleines = CheckPierreAme()

    if (Pierre_Ames_Pleines ~= nil and #Pierre_Ames_Pleines > 0) or inventory:itemCount(9686) == 0 or inventory:itemCount(9687) == 0 or inventory:itemCount(9688) == 0 then
        return {
            {map = "0,0", path = "zaap(212600323)"},
            {map = "-31,-56", path = "zaapi(220200961)"},
            {map = "220200961", custom = function()
                OpenInterface()
                SendPresetOne()
                SendPresetTwo()
            end}
        }
	end

    return {
        {map = "212600323", path = "bottom"},
        {map = "212600837", path = "bottom"},
        {map = "212600838", path = "right"},
        {map = "220200961", path = "zaapi(212601350)"},
        {map = "0,0", path = "zaap(212600323)"},
        {map = "212601350", custom = ProcessSell}, -- Map HDV ressources bonta
    }
end

function banned()
    global:editAlias(phrase .. " [BAN]", true)
end

function PHENIX()
	return PHENIX
end

function stopped()
    map:changeMap("havenbag")
end


function prefightManagement(challengers, defenders)
	local DistanceEmplacement = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	local cellIdOmbre = 0
	local CellulesWithDistance = { }

	local i = 1
	for cell1, id1 in pairs(challengers) do
		if not fightAction:isFreeCell(cell1) and (id1 == -1) then
			cellIdOmbre = cell1
		end
		for cell2, id2 in pairs(defenders) do
			if id2 ~= -1 then
				DistanceEmplacement[i] = DistanceEmplacement[i] + map:cellDistance(cell1, cell2)
			end
		end

		local element = {
			Cellid = cell1,
			DistanceTotale = DistanceEmplacement[i]
		}
		table.insert(CellulesWithDistance, element)
		i = i + 1
	end

	table.sort(CellulesWithDistance, function(a, b) return a.DistanceTotale < b.DistanceTotale end)

	for i = 1, 11 do
		if not fightAction:isFreeCell(CellulesWithDistance[i].Cellid) and (CellulesWithDistance[i].CellId == cellIdOmbre) then
			local message = developer:createMessage("GameFightPlacementPositionRequestMessage")
			message.cellId = CellulesWithDistance[i + 1].Cellid
			developer.sendMessage(message)

			message = developer:createMessage("GameFightPlacementSwapPositionsRequestMessage")
			message.requestedId = -1
			message.cellId = cellIdOmbre
			developer.sendMessage(message)

			break
		end
		if fightAction:isFreeCell(CellulesWithDistance[i].Cellid) then
			local message = developer:createMessage("GameFightPlacementPositionRequestMessage")
			message.cellId = CellulesWithDistance[i + 1].Cellid
			developer.sendMessage(message)

			if cellIdOmbre ~= 0 then
				message = developer:createMessage("GameFightPlacementSwapPositionsRequestMessage")
				message.requestedId = -1
				message.cellId = cellIdOmbre
				developer.sendMessage(message)

				message = developer:createMessage("GameFightPlacementPositionRequestMessage")
				message.cellId = CellulesWithDistance[i].Cellid
				developer.sendMessage(message)
			end
			break
		end
	end
end


function chooseChallenge(challengeId, i)
	global:delay(global:random(500, 1000))
	local ChallengeSelectionMessage = developer:createMessage("ChallengeSelectionMessage")
	ChallengeSelectionMessage.challengeId = challengeId
	developer:sendMessage(ChallengeSelectionMessage)
	global:printMessage("Le challenge ("..fightChallenge:challengeName(challengeId)..") a été choisi pour le slot N°"..tostring(i)..".")
	return challengeId
end

function challengeManagement(challengeCount, isMule)

	-- Choix le type de bonus
	-- 0 = XP
	-- 1 = DROP
	local challengeBonus = 1

	-- Choix du mode des challenges
	-- 0 = Manuel
	-- 1 = Aléatoire
	local challengeMod = 1
	-------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------

	-- Texte variables
	local challengeBonusText = { "XP", "DROP" }
	local challengeModText = { "Manuel", "Aléatoire" }

	-- Choix le type de bonus
	local ChallengeBonusChoiceMessage = developer:createMessage("ChallengeBonusChoiceMessage")
	ChallengeBonusChoiceMessage.challengeBonus = challengeBonus
	developer:sendMessage(ChallengeBonusChoiceMessage)

	-- Choix du mode des challenges
	local ChallengeModSelectMessage = developer:createMessage("ChallengeModSelectMessage")
	ChallengeModSelectMessage.challengeMod = challengeMod
	developer:sendMessage(ChallengeModSelectMessage)

	-- Message
	if not isMule then
		global:printSuccess("Challenges: "..challengeModText[challengeMod + 1].." - Bonus: "..challengeBonusText[challengeBonus + 1])
	else
		global:printSuccess("[MULE] Bonus: "..challengeBonusText[challengeBonus + 1])
		return
	end
end

function fightManagement()
    -- Je vérifie dans un premier temps que c'est bien à moi de jouer :
        
    if fightCharacter:isItMyTurn() == true then
        if fightAction:getCurrentTurn() == 1 then
            passTurnForOmbre = false
            lancable = 0
            incrementation = 0
        elseif fightAction:getCurrentTurn() > (map:currentSubArea() == "Bois de Litneg" and 150 or 100) then
            Abandon()
        end

        delayFightStartTurn()
        
        global:printSuccess("1")
        -- J'avance vers mon ennemi le plus proche
        local enemies = GetAllEnemiesFromTheNearest()

        global:printSuccess("1.5")

        if enemies ~= nil and #enemies > 0 then
            for _, entity in ipairs(enemies) do
                local PM = fightCharacter:getMP()
                if PM > 0 and not IsHandToHandEnemy() and entity.CellId then
                    local cellId = fightCharacter:getCellId()
                    MoveInLineOf(entity.CellId, 6)
                    if cellId == fightCharacter:getCellId() then
                        MoveInLineOf(entity.CellId, 9)
                    end
                    if PM ~= fightCharacter:getMP() then
                        break
                    end
                end
            end
        end
        global:printSuccess("2")

        local Hp = fightCharacter:getLifePoints()

        -- lancement mutilation
        if lancable == 0 then 
            if incrementation == 1 then
                if fightAction:getCurrentTurn() < 5 and map:currentSubArea() ~= "Territoire Cacterre" and map:currentSubArea() ~= "Canaux méphitiques" and map:currentSubArea() ~= "Entrailes de Brâkmar" and map:currentSubArea() ~= "Pics de Cania" then
                    Berserk()
                elseif fightCharacter:getLifePointsP() < 35 and map:currentSubArea() ~= "Canaux méphitiques" and map:currentSubArea() ~= "Entrailes de Brâkmar" and map:currentSubArea() ~= "Pics de Cania" then
                    Libation()
                end
                Hp = fightCharacter:getLifePoints()
                if fightCharacter:getAP() >= 6  then
                    launchBestSort4pa()
                    Deplacement()
                end
                if fightCharacter:getAP() >= 5 and fightCharacter:getLifePoints() >= Hp then
                    launchBestSort3pa()
                    Deplacement()
                end
                if fightCharacter:getAP() >= 6 and fightCharacter:getLifePoints() >= Hp then
                    launchBestSort4pa()
                    Deplacement()
                end
                if fightCharacter:getAP() >= 6 and fightCharacter:getLifePoints() >= Hp then
                    launchBestSort4pa()
                    Deplacement()
                end
                if fightCharacter:getAP() >= 4 and fightCharacter:getLifePoints() >= Hp then
                    Afflux()
                end
            end
            fightAction:castSpellOnCell(12737, fightCharacter:getCellId())

            if fightCharacter:getLifePoints() < Hp and incrementation == 1 and map:currentSubArea() == "Territoire Cacterre" then
                incrementation = (incrementation == 0) and 1 or 0
                lancable = lancable + incrementation
                passTurnForOmbre = true
                global:printSuccess("cactana a son passif, on passe notre tour (1)")
                Deplacement()
                LaunchEpee_Vorace()
                Courrone_Epine()
                return -- Je passe mon tour
            else
                incrementation = (incrementation == 0) and 1 or 0
                lancable = lancable + incrementation
            end

        else
            lancable = lancable - 1
        end

        Hp = fightCharacter:getLifePoints()

        if fightCharacter:getLifePointsP() < 10 then
            Courrone_Epine()
        end

        if capturer then
            capture()
        end

        launchBestSort3pa()
        if fightCharacter:getLifePoints() < Hp and map:currentSubArea() == "Territoire Cacterre" then
            passTurnForOmbre = true
            global:printSuccess("cactana a son passif, on passe notre tour (2)")
            MoveInLineOf(fightAction:getNearestEnemy(), 6)
            LaunchEpee_Vorace()
            Courrone_Epine()
            return -- Je passe mon tour
        end

        MoveInLineOf(fightAction:getNearestEnemy(), 6)

        if fightCharacter:getAP() == 7 or fightCharacter:getAP() == 5 then
            launchBestSort3pa()
        end

        if PersoBloque then
            global:printSuccess("Perso bloqué")
            BainDeSang2()
            BainDeSang2()
            PersoBloque = false
        end

        launchBestSort4pa()
        MoveInLineOf(fightAction:getNearestEnemy(), 6)

        launchBestSort4pa()
        MoveInLineOf(fightAction:getNearestEnemy(), 6)

        launchBestSort3pa()

        Ravage(WeakerMonsterAdjacent())

        Hp = fightCharacter:getLifePoints()

        launchBestSort4pa()
        MoveInLineOf(fightAction:getNearestEnemy(), 6)

        if fightCharacter:getLifePoints() < Hp and map:currentSubArea() == "Territoire Cacterre" then
            passTurnForOmbre = true
            global:printSuccess("cactana a son passif, on passe notre tour (3)")
            MoveInLineOf(fightAction:getNearestEnemy(), 6)
            LaunchEpee_Vorace()
            Courrone_Epine()
            return -- Je passe mon tour
        end
        launchBestSort4pa()
        MoveInLineOf(fightAction:getNearestEnemy(), 6)

        launchBestSort3pa()

        Ravage(WeakerMonsterAdjacent())
        
        launchBestSort3pa()

        MoveInLineOf(fightAction:getNearestEnemy(), 6)

        if NbMontresAdjacents(fightCharacter:getCellId()) == 0 and map:currentSubArea() == "Territoire Cacterre" then
            Attirance(fightAction:getNearestEnemy())
            if NbMontresAdjacents(fightCharacter:getCellId()) == 0 then
                Fluctuation()
                MoveInLineOf(fightAction:getNearestEnemy(), 6)
            end
        end

        launchBestSort4pa()
        MoveInLineOf(fightAction:getNearestEnemy(), 6)
        launchBestSort4pa()
        MoveInLineOf(fightAction:getNearestEnemy(), 6)
        launchBestSort3pa()
        MoveInLineOf(fightAction:getNearestEnemy(), 6)


        Ravage(WeakerMonsterAdjacent())
        Cac(fightAction:getNearestEnemy())
        Courrone_Epine()

        DeplacementProche()
        Afflux()
        Afflux()
        LaunchEpee_Vorace()
        Stase()
        Stase()

        BainDeSang2()
        BainDeSang2()
        Afflux2()
        MoveInLineOf(fightAction:getNearestEnemy(), 6)

        fightAction:passTurn()
    else
        delayFightStartTurn()
        global:printSuccess("Ombre")

        MoveInLineOfForSlave(fightSlave:getNearestEnemy(), 6)

        if passTurnForOmbre then
            global:printSuccess("Pass Turn For Ombre")
            passTurnForOmbre = false
            fightAction:passTurn()
        end

        Colere_Noire()

        Vengeance_Nocturne()

        MoveInLineOfForSlave(fightSlave:getNearestEnemy(), 6)


        local nearestEnnemi = fightSlave:getNearestEnemy()
        Diabolo_Chiste(nearestEnnemi)

        local entities = fightAction:getAllEntities()
        local AdjCases = fightAction:getAdjacentCells(fightSlave:cellId())
        local newEnnemi = nil

        for _, cellId in ipairs(AdjCases) do
            for _, entity in ipairs(entities) do
                if (entity.CellId == cellId) and entity.Team and (entity.CellId ~= nearestEnnemi) then
                    newEnnemi = entity.CellId
                end
            end
        end
        if newEnnemi == nil then
            newEnnemi = fightSlave:getNearestEnemy()
        end
        if newEnnemi ~= nearestEnnemi then
            Diabolo_Chiste(newEnnemi)
        end


        DeplacementProcheSlave()

        Cartilage(fightSlave:getNearestEnemy())

        DeplacementSlave()
        Ombrolingo(fightSlave:getNearestEnemy())
        DeplacementSlave()
        Ombrolingo(fightSlave:getNearestEnemy())

        nearestEnnemi = fightSlave:getNearestEnemy()
        Crepuscule(nearestEnnemi)
        DeplacementSlave()

        if fightSlave:getNearestEnemy() ~= nearestEnnemi then
            Crepuscule(fightSlave:getNearestEnemy())
        end

        Vengeance_Nocturne2()
        
        if fightSlave:entity().MP > 0 then
            local entities = fightAction:getAllEntities()
            for _, element in ipairs(entities) do
                -- on cherche le sacrieur
                if not element.Team and not element.Companion then
                    local zone = fightAction:getCells_square(element.CellId, 1, 1)
                    for _, cellId in ipairs(zone) do
                        -- on regarde si on se trouve dans sa zone bain de sang
                        if fightSlave:cellId() == cellId then
                            -- si c'est le cas on regarde pour finir son tour dans sa case adjacente la plus éloignée du sacrieur
                            local cellWhereMove = fightAction:getCells_lozenge(fightSlave:cellId(), 1, 2)
                            table.sort(cellWhereMove, function(a, b) return fightAction:getDistance(a, element.CellId) > fightAction:getDistance(b, element.CellId) end)
                            fightSlave:moveTowardCell(cellWhereMove[1])
                            break
                        end
                    end
                    break
                end
            end
        end
        global:printSuccess("Fin Ombre")

        fightAction:passTurn()

    end
end
