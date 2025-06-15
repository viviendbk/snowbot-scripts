
ALL_ARCHI = {2270,2271,2272,2273,2274,2275,2276,2277,2278,2279,2280,2281,2282,2283,2284,2285,2286,2287,2288,2289,2290,2291,2292,2293,2294,2295,2296,2297,2298,2299,2300,2301,2302,2303,2304,2305,2306,2307,2308,2309,2310,2311,2312,2313,2314,2315,2316,2317,2318,2319,2320,2321,2322,2323,2324,2325,2326,2327,2328,2329,2330,2331,2332,2333,2334,2335,2336,2337,2338,2339,2340,2341,2342,2343,2344,2345,2346,2347,2348,2349,2350,2351,2352,2353,2354,2355,2356,2357,2358,2359,2360,2361,2362,2363,2364,2365,2366,2367,2368,2369,2370,2371,2372,2373,2374,2375,2376,2377,2378,2379,2380,2381,2382,2383,2384,2385,2386,2387,2388,2389,2390,2391,2392,2393,2394,2395,2396,2397,2398,2399,2400,2401,2402,2403,2404,2405,2406,2407,2408,2409,2410,2411,2412,2413,2414,2415,2416,2417,2418,2419,2420,2421,2422,2423,2424,2425,2426,2427,2428,2429,2430,2431,2432,2433,2434,2435,2436,2437,2438,2439,2440,2441,2442,2443,2444,2445,2446,2447,2448,2449,2450,2451,2452,2453,2454,2455,2456,2457,2458,2459,2460,2461,2462,2463,2464,2465,2466,2467,2468,2469,2470,2471,2472,2473,2474,2475,2476,2477,2478,2479,2480,2481,2482,2483,2484,2485,2486,2487,2488,2489,2490,2491,2492,2493,2494,2495,2496,2497,2498,2499,2500,2501,2502,2503,2504,2505,2506,2507,2508,2509,2510,2511,2512,2513,2514,2515,2516,2517,2518,2519,2520,2521,2522,2523,2524,2525,2526,2527,2528,2529,2530,2531,2532,2533,2534,2535,2536,2537,2538,2539,2540,2541,2542,2543,2544,2545,2546,2547,2548,2549,2550,2551,2552,2553,2554,2555,2556,2557,2558,2559,2560,2561,2562,2563,2564,2565,2566,2567,2568,2569,2570,2571,2572,2573,2574,2575,2576,2577,2578,2579,2580,2581,2582,2583,2584,2585,2586,2587,2588,2589,2590,2591,2592,2593,2594,2595,2596,2597,2598,2599,2600,2601,2602,2603,2604,2605,2606,2607,2608,2609,2610,2611,2612,2613,2614,2615,2616}

function checkmap(message)
    developer:unRegisterMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage")
	global:printError("ANALYSE DE L'HDV EN COURS... MERCI DE PATIENTER... !")
    local countotal = 0
    local count = 0
    RECONNECT_ON_TIMEOUT = false
    for _, element in ipairs(Pierre_Ames_Pleines) do
        for i=1,#message.itemTypeDescriptions do
            for j = 1, message.itemTypeDescriptions[i].prices[1] < element.Price and (#message.itemTypeDescriptions[i].effects) or 0 do
                if tostring(message.itemTypeDescriptions[i].effects[j]) == "Swiftbot.ObjectEffectDice" and message.itemTypeDescriptions[i].effects[j].diceConst == element.IdArchi then
					global:printSuccess("----------------------------------------------")
					global:printSuccess("ID ARCHI :  ".. message.itemTypeDescriptions[i].effects[j].diceConst)

					element.Price = message.itemTypeDescriptions[i].prices[1]

					global:printSuccess("PRIX :  "..message.itemTypeDescriptions[i].prices[1])
					global:printSuccess("MEILLEUR PRIX TROUVE POUR L'INSTANT " .. element.Price)
					count = count + 1
				end
            end
        end
        countotal = countotal + 1
        global:leaveDialog()
        local cellAvailables = {327, 328, 329, 331}
        map:moveToCell(cellAvailables[math.random(1, #cellAvailables)])
        SendPresetOne()

        global:printMessage("J'envoie les rêquetes au serveur [2/2]")
        monMessage = developer:createMessage("ExchangeBidHouseSearchMessage")
        monMessage.objectGID = 10418
        monMessage.follow = true
        developer:sendMessage(monMessage)
        developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 5000, true)

    end
	global:printSuccess("Checking terminé, On passe à la vente !")

    global:leaveDialog()

    RECONNECT_ON_TIMEOUT = true

    local message = developer:createMessage("NpcGenericActionRequestMessage")
    message.npcId = -1
    message.npcActionId = 5
    message.npcMapId = map:currentMapId()
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 2000, true)

    for _, element in ipairs(Pierre_Ames_Pleines) do
        local message = developer:createMessage("ExchangeObjectMovePricedMessage")
        message.price = element.Price - 1
        message.objectUID = element.UID
        message.quantity = 1
        developer:sendMessage(message)
        global:printSuccess("1 lot de Pierre d'âme d'archi monstre à " .. message.price .. " kamas")
        developer:suspendScriptUntil("ExchangeBidHouseInListAddedMessage", 2000, true, 20)
    end
    global:leaveDialog()

    map:changeMap("zaapi(212600323)")
end

function OpenInterface()
	global:printMessage("J'ouvre l'hdv")
    npc:npc(145, 6)

    if inventory:itemCount(9686) == 0 then
        for i = 1, character:kamas() > 800000 and 5 or 2 do
            sale:buyItem(9686, 1, 300000)
        end
        if inventory:itemCount(9686) == 0 then
            sale:buyItem(9686, 10, 3000000)
        end
    end
    if inventory:itemCount(9687) == 0 then
        for i = 1, character:kamas() > 800000 and 5 or 2 do
            sale:buyItem(9687, 1, 300000)
        end
        if inventory:itemCount(9686) == 0 then
            sale:buyItem(9687, 10, 3000000)
        end
    end
    if inventory:itemCount(9688) == 0 then
        for i = 1, character:kamas() > 800000 and 5 or 2 do
            sale:buyItem(9688, 1, 300000)
        end
        if inventory:itemCount(9686) == 0 then
            sale:buyItem(9688, 10, 3000000)
        end
    end
    global:delay(500)

    global:leaveDialog()
    global:delay(500)

    npc:npc(145, 5)

end

function SendPresetOne()
	global:printMessage("J'envoie les rêquetes au serveur [1/2]")	
	monMessage = developer:createMessage("ExchangeBidHouseTypeMessage")
	monMessage.type = 65
	monMessage.follow = true
	developer:sendMessage(monMessage)
	global:delay(2000)
end

function SendPresetTwo()
	global:printMessage("J'envoie les rêquetes au serveur [2/2]")
	monMessage = developer:createMessage("ExchangeBidHouseSearchMessage")
	monMessage.objectGID = 10418
	monMessage.follow = true
    developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", checkmap)
	developer:sendMessage(monMessage)
    developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 5000, true)
end

function IsArchiMonstre(Id)
    for _, element in ipairs(ALL_ARCHI) do
        if Id == element then
            return true
        end
    end
    return false
end

function CheckPierreAme()
    local Content = inventory:inventoryContent()
    local toReturn = {}
    for _, item in ipairs(Content) do
        if item.objectGID == 10418 and #item.effects > 0 then
            local element = {
                UID = item.objectUID,
                IdArchi = 0,
				Price = 400000
            }
            for _, data in ipairs(item.effects) do                
                if tostring(data) == "SwiftBot.ObjectEffectDice" and IsArchiMonstre(data.diceConst) then
                    element.IdArchi = data.diceConst
					table.insert(toReturn, element)
                end
            end
        end
    end
    return toReturn
end


function archionmap()
	if (inventory:itemPosition(17681) == 63 or inventory:itemPosition(8827) == 63) and global:afterFight() then
    	global:printSuccess("Fin du combat, je remets mon CAC")
        if inventory:itemCount(17681) > 0 and character:level() > 199 then
            inventory:equipItem(17681, 1)
        elseif inventory:itemCount(8827) > 0 then
            inventory:equipItem(8827, 1)
        else
            inventory:equipItem(1934, 1)
        end
	end
	
	if map:containsArchi() and character:energyPoints() > 0 then
        local ArchiOnMap = map:getArchiMonsters()
        for _, archi in ipairs(ArchiOnMap) do
            global:printSuccess(archi)
        end
        FORCE_MONSTERS = {ArchiOnMap[1]}
        global:printSuccess(FORCE_MONSTERS[1])
        local tablePierres = {
            Lvl50 = 9686,
            Lvl100 = 9687,
            Lvl150 = 9688,
        }

        local groups = map:monsterGroups()
        local LvlMax = 200
        for i, group in ipairs(groups) do
            for _, monster in ipairs(group.monsters) do
                if monster.level < LvlMax then
                    LvlMax = monster.level
                end
            end
        end

        if LvlMax < 50 and inventory:itemCount(tablePierres.Lvl50) > 0 then
            inventory:equipItem(tablePierres.Lvl50, 1)
            global:delay(500)
            capturer = true
            MIN_MONSTERS = 0
            MAX_MONSTERS = 8
            map:fight() -- FORCE_MONSTERS = ALL ARCHI

        elseif LvlMax < 100 and inventory:itemCount(tablePierres.Lvl100) > 0  then
            inventory:equipItem(tablePierres.Lvl100, 1)
            global:delay(500)
            capturer = true
            MIN_MONSTERS = 0
            MAX_MONSTERS = 8
            map:fight() -- FORCE_MONSTERS = ALL ARCHI 

        elseif LvlMax < 150 and inventory:itemCount(tablePierres.Lvl150) > 0 then
            inventory:equipItem(tablePierres.Lvl150, 1)
            global:delay(500)
            capturer = true
            MIN_MONSTERS = 0
            MAX_MONSTERS = 8
            map:fight() -- FORCE_MONSTERS = ALL ARCHI 

        end
    else
        capturer = false
        FORCE_MONSTERS = {}
    end
end


function capture() -- Mettre dans ton IA
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 413, fightCharacter:getCellId()) == 0 or fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 413, fightCharacter:getCellId()) == 12 then
		global:printSuccess("[LOG] je lance le sort capture")
		fightAction:castSpellOnCell(413, fightCharacter:getCellId())
	else
		global:printSuccess("[LOG] Je ne peux pas lancer le sort capture actuellement")
	end
end
