dofile("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Lib\\IMPORT_LIBRARIES.lua")

local giver = nil

function messagesRegistering()
    developer:registerMessage("HaapiShopApiKeyMessage", _HaapiShopApiKeyMessage)
	developer:registerMessage("HaapiConfirmationMessage", _HaapiConfirmationMessage)
end


local function conditionTakeKamas()

    if global:thisAccountController():getAlias():find("Mineur")
    or global:thisAccountController():getAlias():find("Bucheron")
    or global:thisAccountController():getAlias():find("LvlUp") then
        if (getRemainingSubscription(true) > 0 and character:kamas() < 800000)
        and job:level(2) < 5 and job:level(24) < 5 then
            return true
        end
        return false
    end

    return true
end

local function takeKamas(giver)
    debug(giver.character():id())
    global:delay(5000)
    local maxWaitingTime = 120

    if not waitBotIsOnAstrubBank(giver, maxWaitingTime) then
        global:printError("Bot banque n'est toujours pas à astrub après " .. maxWaitingTime .. " secondes, reprise du trajet")
        rerollVar()
        global:editInMemory("retryTimestamp", os.time())
        global:addInMemory("failed", true)
        setBotBankConnected(character:server(), false)
        giver:disconnect()
        return
    end

    if not launchExchangeSafely(giver.character():id(), maxWaitingTime) then
        global:printError("Bot banque ne répond pas après " .. maxWaitingTime .. " secondes, reprise du trajet")
        rerollVar()
        global:editInMemory("retryTimestamp", os.time())
        giver:addInMemory("failed", true)
        giver:disconnect()
        return
    end

    developer:suspendScriptUntil("ExchangeKamaModifiedMessage", 7500, false)
    if global:thisAccountController():getAlias():find("LvlUp") then
        if developer:suspendScriptUntil("ExchangeIsReadyMessage", 40000, true) then
            global:printSuccess("Confirmation ...")
            exchange:ready()
            global:printSuccess("Le dernier échange s'est terminé avec succès !")
        else
            global:printError("Le dernier échange a échoué !")
        end
    else
        global:delay(6000, 7000)
    end
    debug("ok")

    exchange:ready()
    
    developer:suspendScriptUntil("ExchangeLeaveMessage", 5000, false)

    deleteKamasOrder(function(order)
        return order.id == character:id()
    end)
    global:addInMemory("doneTransfert", true)

    if character:kamas() < 500000 then
        global:printSuccess("le bot banque n'a pas pu nous donner les kamas, on retente dans 1h")
        giver:disconnect()
        setBotBankConnected(character:server(), false)
        global:deleteMemory("doneTransfert")
        customReconnect(60)
    else
        global:printSuccess("le bot banque nous a donné les kamas, on continue")
        giver:disconnect()
        setBotBankConnected(character:server(), false)
        if global:thisAccountController():getAlias():find("Combat") then
            global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Combat\\buyStuffSacri200.lua")
        elseif not global:thisAccountController():getAlias():find("Groupe") then
            if character:level() > 140 then
                global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Recolte\\buyStuffRecolte.lua")
            end
            global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\PLAndZaaps\\Zaaps&Stuffs.lua")
        else
            global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\PLAndZaaps\\quete_pandala.lua")
        end
    end
end

function move()
    mapDelay()
    -- if (getRemainingSubscription(true) > 0 and not global:thisAccountController():getAlias():find("Draconiros")) 
    -- or (global:thisAccountController():getAlias():find("Draconiros") and character:kamas() > 150000) or character:kamas() > 1200000 then
    --     if not global:thisAccountController():getAlias():find("Groupe") then
    --         global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\PLAndZaaps\\Zaaps&Stuffs.lua")
    --     else
    --         global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\PLAndZaaps\\quete_pandala.lua")
    --     end
    -- end

    global:printSuccess(global:remember("firstDecoReco"))

    if global:remember("firstDecoReco") and getRemainingSubscription(true) <= 0 
    and (global:thisAccountController():getAlias():find("Mineur") or global:thisAccountController():getAlias():find("Bucheron") 
    or global:thisAccountController():getAlias():find("LvlUp"))
    and job:level(2) < 5 and job:level(24) < 5 and character:level() < 70 then
        global:delay(math.random(0, 10000))
        local path = "C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Assets\\NeedAbonnement.txt"
        local entry = tostring(global:username()) .. ":" .. tostring(global:password())
        local content = openFile(path):split("\n")

        printVar(content)
        -- Vérifie si la ligne existe déjà
        local alreadyListed = false
        for _, line in ipairs(content) do
            if line == entry then
                alreadyListed = true
                break
            end
        end

        -- Écrit si nécessaire
        if not alreadyListed then
            table.insert(content, entry)
        end
        printVar(content)
        local toWrite = ""
        for _, line in ipairs(content) do
            toWrite = toWrite .. line .. "\n"
        end 

        f = io.open(path, "w")
        f:write(toWrite)
        f:close()

        global:printMessage("On a besoin d'un abonnement")
        global:editAlias(global:thisAccountController():getAlias() .. " [NEED ABO]", true)
        global:disconnect()
    end

    if not global:thisAccountController():getAlias():find("Combat") and not global:thisAccountController():getAlias():find("Craft")
    and not global:thisAccountController():getAlias():find("Groupe") and not global:remember("firstDecoReco") and getRemainingSubscription(true) <= 0 then
        global:addInMemory("firstDecoReco", true)
        global:printSuccess("On se déco reco pour voir si on est abonné")
        global:disconnect()
        return
    end


    if not global:remember("doneTransfert") and conditionTakeKamas() then
        local submitKamas = 0
        if character:kamas() < 2000000 then

            if global:thisAccountController():getAlias():find("Groupe") then
                global:printSuccess("on demande 3500000")
                submitKamas = IsInTable(SERVERS_MONO, character:server()) and 4500000 or 4000000
            elseif global:thisAccountController():getAlias():find("Combat") or global:thisAccountController():getAlias():find("Craft") then
                global:printSuccess("on demande 10000000")
                submitKamas = 10000000
            elseif IsInTable(SERVERS_MONO, character:server()) then
                submitKamas = 800000
            elseif global:thisAccountController():getAlias():find("LvlUp") then
                submitKamas = 400000
            else
                submitKamas = 300000
            end

            if submitKamas > 0 then
                submitKamasOrder(submitKamas)
            end
        else
            global:addInMemory("doneTransfert", true)
            if not IsInTable(SERVERS_MONO, character:server()) and getRemainingSubscription(true) <= 0 then 
				Abonnement() 
			end
            global:disconnect()
        end


        if not giver then
            while not isBotBankAvailable() do
                global:printError("Le bot bank est connecté sur une autre instance, on attend 10 secondes")
                global:delay(10000)
            end

            giver = connectGiver(120)

            if not giver then
                global:printError("[ERROR] Impossible de connecter le bot banque, nouvelle tentative dans " .. timeToRetry .. " heures.")
                customReconnect(timeToRetry * 60)
            end

            if giver.character():kamas() < submitKamas 
            and (global:thisAccountController():getAlias():find("Mineur") 
            or global:thisAccountController():getAlias():find("Bucheron") 
            or global:thisAccountController():getAlias():find("LvlUp")) then
                if not global:remember("lvlFinish") then
                    global:addInMemory("lvlFinish", character:level() + 1)
                else
                    global:editInMemory("lvlFinish", character:level() + 1)
                end
                setBotBankConnected(character:server(), false)
                giver:disconnect()
                global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\PLAndZaaps\\PL_1-6X.lua")
            end


        end

        return goAstrubBank(function() return takeKamas(giver) end)

    elseif getRemainingSubscription(true) > 0 then
        debug("aa")
        if global:thisAccountController():getAlias():find("Combat") then
            global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Combat\\buyStuffSacri200.lua")
        elseif not global:thisAccountController():getAlias():find("Groupe") then
            if character:level() > 140 then
                global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Recolte\\buyStuffRecolte.lua")
            end
            global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\PLAndZaaps\\Zaaps&Stuffs.lua")
        else
            global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\PLAndZaaps\\quete_pandala.lua")
        end
    else
        global:printSuccess("bug, on réessaye dans 1h")
        global:deleteMemory("doneTransfert")
        customReconnect(60)
    end
end

function bank()
    return move()
end