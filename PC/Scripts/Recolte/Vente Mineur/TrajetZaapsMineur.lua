

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

if not global:remember("ETAPE_ZAAP") then
    global:addInMemory("ETAPE_ZAAP", 0)
end

if not global:remember("ExplorationFinished") then
    global:addInMemory("ExplorationFinished", false)
end

local function increment()
    global:editInMemory("ETAPE_ZAAP", global:remember("ETAPE_ZAAP") + 1)
    global:printSuccess("Etape : " .. global:remember("ETAPE_ZAAP"))
end


local function BuyCityPotions()

    npc:npc(318,6)
    global:delay(1000)
    sale:buyItem(6965,1,20000)
    if inventory:itemCount(6965) < 1 then
        sale:buyItem(6965, 10, 20000)
    end
    sale:buyItem(6964,1,20000)
    if inventory:itemCount(6964) < 1 then
        sale:buyItem(6964, 10, 20000)
    end
    global:delay(1000)
    global:leaveDialog()
    
    inventory:useItem(6965)
end

local function getRemainingSubscription(inDay, acc)
    local accDeveloper = acc and acc.developer or developer

    local endDate = developer:historicalMessage("IdentificationSuccessMessage")[1].subscriptionEndDate 
    local now = os.time(os.date("!*t")) * 1000

    endDate = math.floor((endDate - now) / 3600000)

    return inDay and math.floor(endDate / 24) or endDate
end

function messagesRegistering()
	developer:registerMessage("HaapiShopApiKeyMessage", _HaapiShopApiKeyMessage)
	developer:registerMessage("HaapiConfirmationMessage", _HaapiConfirmationMessage)
end

local function GoTo(mapToward, action)
    local toward = mapToward:split(",")
    if not map:onMap(mapToward) then
        if #toward == 2 then
            return map:moveToward(tonumber(toward[1]), tonumber(toward[2]))
        elseif #toward == 1 then
            return map:moveToward(tonumber(toward[1]))
        end
    else
        action()
    end
end

function move()

    
    if global:remember("ETAPE_ZAAP") == 0 then
        if map:currentArea() ~= "Astrub" and not map:onMap("0,0") then
            map:changeMap("havenbag")
        elseif map:currentArea() ~= "Astrub" then
            map:changeMap("zaap(191105026)")
        end
        GoTo("3,-19", function() 
            increment() 
            BuyCityPotions() 
        end)
    elseif global:remember("ETAPE_ZAAP") == 1 then -- bonta 1/2
        return {

            --map equipementoù on achète les stuffs
            --map ressource où on archète les idoles si besoin
            {map = "-32,-57", path = "right"},
            {map = "-31,-57", path = "bottom"},
            {map = "-31,-56", path = "bottom"},
            {map = "-31,-55", custom = function ()
                if global:thisAccountController():getAlias():find("Mineur") or global:thisAccountController():getAlias():find("Bucheron") then
                    BuyStuff()
                else
                    BuyStuff114()
                end 
            end},
            {map = "-30,-55", path = "bottom"},
            {map = "-30,-54", custom = function ()
                if not global:thisAccountController():getAlias():find("Mineur") and not global:thisAccountController():getAlias():find("Bucheron") then
                    BuyIdoles()
                end
                map:changeMap("zaapi(212731651)")
            end},
            {map = "-35,-60", path = "zaapi(212600839)"},
            {map = "-31,-53", custom = function ()
                if global:thisAccountController():getAlias():find("LvlUp") then
                    BuyParhoSasa()
                end
                map:changeMap("zaapi(212599302)")
            end},
            {map = "-35,-60", path = "zaapi(212599302)"},
            {map = "-34,-54", path = "top"},
            {map = "-34,-55", path = "left"},
            {map = "212598789", custom = function()
                increment()
                map:door(89)
            end},
        }
    elseif global:remember("ETAPE_ZAAP") == 2 then -- bonta 2/2 & brakmar 1/3
        return {
            {map = "216401666", door = "390"},
            {map = "212598789", path = "right"},
            {map = "-34,-55", path = "bottom"},
            {map = "-34,-54", path = "zaapi(212601345)"},
            {map = "-30,-59", path = "top"},
            {map = "-30,-60", path = "right"},
            {map = "-29,-61", path = "top"},
            {map = "-29,-62", path = "top"},
            {map = "-29,-63", path = "right"},
            {map = "-28,-63", path = "right"},
            {map = "-27,-63", path = "right"},
            {map = "-26,-63", path = "right"},
            {map = "-25,-63", path = "right"},
            {map = "-24,-63", path = "right"},
            {map = "-23,-63", path = "bottom"},
            {map = "-23,-62", custom = function ()
                inventory:useItem(6964)
            end},
            {map = "216530944", door = "521"},
            {map = "212862464", path = "left"},
            {map = "-26,33", path = "zaapi(212860931)"},
            {map = "-28,36", path = "right"},
            {map = "-26,37", path = "zaapi(212862469)"},
            {map = "-25,38", path = "bottom"},
            {map = "212862470", custom = function()
                increment()
                map:door(233)
            end},
        }
    elseif global:remember("ETAPE_ZAAP") == 3 then -- brakmar 2/3
        return {
            {map = "216924682", door = "233"},
            {map = "212862470", path = "bottom"},
            {map = "-25,40", custom = function ()
                increment()
                map:changeMap("left")
            end},
        }
    elseif global:remember("ETAPE_ZAAP") == 4 then --brakmar 3/3
        return {
            {map = "-26,41", path = "right"},
            {map = "-25,40", path = "top"},
            {map = "-25,39", path = "top"},
            {map = "-25,38", path = "zaapi(212864004)"},
            {map = "-22,37", path = "top"},
            {map = "-22,36", path = "right"},
            {map = "-21,36", path = "right"},
            {map = "-19,37", path = "right"},
            {map = "-18,37", path = "bottom"},
            {map = "-18,38", path = "bottom"},
            {map = "-18,39", path = "right"},
            {map = "-17,39", path = "havenbag"},
            {map = "0,0", custom = function ()
                increment()
                map:changeMap("zaap(191105026)")
            end}
        }
    elseif global:remember("ETAPE_ZAAP") == 5 then
        GoTo("-2,0", function ()
            increment()
            map:changeMap("bottom")
        end)
    elseif global:remember("ETAPE_ZAAP") == 6 then
        GoTo("-1,13", function ()
            increment()
            map:changeMap("bottom")
        end)
    elseif global:remember("ETAPE_ZAAP") == 7 then
        GoTo("-1,24", function ()
            increment()
            map:changeMap("right")
        end)
    elseif global:remember("ETAPE_ZAAP") == 8 then
        GoTo("10,22", function ()
            increment()
            map:changeMap("right")
        end)
    elseif global:remember("ETAPE_ZAAP") == 9 then
        GoTo("5,7", function ()
            increment()
            map:changeMap("top")
        end)
    elseif global:remember("ETAPE_ZAAP") == 10 then
        GoTo("7,-4", function ()
            increment()
            map:changeMap("right")
        end)
    elseif global:remember("ETAPE_ZAAP") == 11 then
        GoTo("12,-6", function ()
            increment()
            npc:npc(3464,3)
            npc:reply(-1)
        end)
    elseif global:remember("ETAPE_ZAAP") == 12 then
        GoTo("15,-58", function ()
            increment()
            map:changeMap("zaap(191105026)")
        end)
    elseif global:remember("ETAPE_ZAAP") == 13 then
        GoTo("-5,-23", function ()
            increment()
            map:changeMap("left")
        end)
    elseif global:remember("ETAPE_ZAAP") == 14 then
        GoTo("-13,-28", function ()
            increment()
            map:changeMap("top")
        end)
    elseif global:remember("ETAPE_ZAAP") == 15 then
        GoTo("-3,-42", function ()
            increment()
            map:changeMap("top")
        end)
    elseif global:remember("ETAPE_ZAAP") == 16 then
        GoTo("-9,-43", function ()
            increment()
            map:changeMap("top")
        end)
    elseif global:remember("ETAPE_ZAAP") == 17 then
        GoTo("0,-56", function ()
            increment()
            map:changeMap("bottom")
        end)
    elseif global:remember("ETAPE_ZAAP") == 18 then
        GoTo("-12,-60", function ()
            increment()
            map:changeMap("left")
        end)
    elseif global:remember("ETAPE_ZAAP") == 19 then
        GoTo("-17,-47", function ()
            increment()
            map:changeMap("left")
        end)
    elseif global:remember("ETAPE_ZAAP") == 20 then
        GoTo("-27,-36", function ()
            increment()
            map:changeMap("right")
        end)
    elseif global:remember("ETAPE_ZAAP") == 21 then
        GoTo("-20,-20", function ()
            increment()
            map:changeMap("bottom")
        end)
    elseif global:remember("ETAPE_ZAAP") == 22 then
        GoTo("-36,-10", function ()
            increment()
            npc:npc(770, 3) 
            npc:reply(-1) 
            npc:reply(-1) 
            npc:reply(-1) 
        end)
    elseif global:remember("ETAPE_ZAAP") == 23 then
        GoTo("152849", function ()
            increment()
            npc:npc(783, 3)
            npc:reply(-1)
        end)
    elseif global:remember("ETAPE_ZAAP") == 24 then
        GoTo("34476296", function ()
            increment()
            map:door(218)
        end)
    elseif global:remember("ETAPE_ZAAP") == 25 then

        return {
            {map = "136316674", door = "402"},
            {map = "34476296", custom = function ()
                npc:npc(783, 3)
                npc:reply(-2)
                npc:reply(-1)
            end},
            {map = "152849", path = "top"},
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
            {map = "-41,-19", path = "left"},
            {map = "-42,-19", path = "left"},
            {map = "-43,-16", custom = function() 
                increment()
                npc:npc(770, 3) 
                npc:reply(-1) 
                npc:reply(-1) 
            end}
        }
    elseif global:remember("ETAPE_ZAAP") == 26 then
        return {
            {map = "-36,-10", path = "right"},
            {map = "-35,-10", path = "right"},
            {map = "-34,-10", path = "right"},
            {map = "-33,-10", path = "right"},
            {map = "-32,-10", path = "top"},
            {map = "-32,-11", path = "top"},
            {map = "-32,-13", path = "top"},
            {map = "-32,-12", path = "top"},
            {map = "-32,-14", path = "top"},
            {map = "-32,-15", path = "left"},
            {map = "-33,-15", path = "left"},
            {map = "167380484",custom = function ()
                npc:npc( 1236,3)
                npc:reply(-1)
                npc:reply(-1)
            end},
			{map ="-46,-25", custom = function ()
                npc:npc( 1236,3)
                npc:reply(-1)
                npc:reply(-1)
                npc:reply(-1)
            end},
			{map ="-65,-21", custom = function ()
                npc:npc( 1236,3)
                npc:reply(-1)
                npc:reply(-1)
            end},
			{map ="-83,-31", custom = function ()
                npc:npc( 1236,3)
                npc:reply(-1)
                npc:reply(-1)
                npc:reply(-1)
            end},
			{map = "-81,-37", custom = function ()
                npc:npc( 1236,3)
                global:leaveDialog()
                map:changeMap("right")
            end},
            {map = "-80,-38", path = "right"},
			{map = "-79,-38", path = "right"},
			{map = "-78,-38", path = "top"},
			{map = "-78,-39", path = "top"},
			{map = "-78,-40", path = "top"},
			{map = "-78,-41", custom = function ()
                increment()
                map:changeMap("zaap(164364304)")
            end},
        }
    elseif global:remember("ETAPE_ZAAP") == 27 then
        GoTo("-25,12", function ()
            increment()
            map:changeMap("zaap(164364304)")
        end)
    elseif global:remember("ETAPE_ZAAP") == 28 then
        GoTo("-16,1", function ()
            increment()
            map:changeMap("zaap(191105026)")
        end)
    elseif global:remember("ETAPE_ZAAP") == 29 then
        global:loadAndStart(global:getCurrentScriptDirectory() .. "\\Zaap_PandalaMineur.lua")
        -- mettez ici le changement de script voulu avec global:loadAndStart()
    end
end
