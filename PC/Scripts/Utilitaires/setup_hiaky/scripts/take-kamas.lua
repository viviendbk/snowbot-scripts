
--- <init>

PATH =  "C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\PC\\Scripts\\Utilitaires\\setup_hiaky\\"
scriptName = "take-kamas.lua"
dofile(PATH .. "template.lua")

dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\PC\\Scripts\\Utilitaires\\IMPORT_LIBRARIES.lua")


local insert = table.insert

configPath = "C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\PC\\Configs\\configBank.xml"
scriptPath = "C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\PC\\Scripts\\Utilitaires\\setup_hiaky\\scripts\\give-kamas.lua"

function messagesRegistering()
    developer:registerMessage("HaapiShopApiKeyMessage", _HaapiShopApiKeyMessage)
	developer:registerMessage("HaapiConfirmationMessage", _HaapiConfirmationMessage)
end

function getRemainingSubscription(inDay, acc)
    local accDeveloper = acc and acc.developer or developer

    local endDate = developer:historicalMessage("IdentificationSuccessMessage")[1].subscriptionEndDate 
    local now = os.time(os.date("!*t")) * 1000

    endDate = math.floor((endDate - now) / 3600000)

    return inDay and math.floor(endDate / 24) or endDate
end

local function mapDelay()
	local random = math.random()
	if random < 0.05 then
		global:delay(math.random(10000, 15000))
	elseif random < 0.25 then
		global:delay(math.random(4500, 7000))
	elseif random < 0.5 then
		global:delay(math.random(2000, 4000))
	else
		global:delay(math.random(1000, 2500))
	end
end

function move()
    mapDelay()
    -- if (getRemainingSubscription(true) >= 0 and not global:thisAccountController():getAlias():find("Draconiros")) 
    -- or (global:thisAccountController():getAlias():find("Draconiros") and character:kamas() > 150000) or character:kamas() > 1200000 then
    --     if not global:thisAccountController():getAlias():find("Groupe") then
    --         global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\PC\\Scripts\\PL&Zaaps\\Zaaps&Stuffs.lua")
    --     else
    --         global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\PC\\Scripts\\PL&Zaaps\\quete_pandala.lua")
    --     end
    -- end

    if not global:remember("doneTransfert") then
        local submitKamas = 0
        if character:kamas() < 2000000 then
            if global:thisAccountController():getAlias():find("Groupe") then
                global:printSuccess("on demande 3500000")
                Exch:submitKamasOrder((character:server() == "Draconiros") and 4500000 or 4000000)
            elseif global:thisAccountController():getAlias():find("Combat") or global:thisAccountController():getAlias():find("Craft") then
                global:printSuccess("on demande 10000000")
                Exch:submitKamasOrder(10000000)
            elseif character:server() == "Draconiros" then
                Exch:submitKamasOrder(600000)
                submitKamas = 600000
            elseif global:thisAccountController():getAlias():find("LvlUp") then
                Exch:submitKamasOrder(1800000)
                submitKamas = 1800000
            else
                Exch:submitKamasOrder(1600000)
                submitKamas = 1600000
            end
        else
            global:addInMemory("doneTransfert", true)
            if not global:thisAccountController():getAlias():find("Draconiros") and getRemainingSubscription(true) <= 0 then 
				Abonnement() 
			end
            global:reconnect(0)
        end

        global:delay(500)

        if not giver then
            while not isBotBankAvailable() do
                global:printError("Le bot bank est connecté sur une autre instance, on attend 10 secondes")
                global:delay(10000)
            end
            giver = Ctrl:connect2(giverAlias, true)

            if not giver then
                print:errorInfo("Impossible de connecter le bot banque, nouvelle tentative dans " .. timeToRetry .. " heures.")
                global:reconnect(timeToRetry)
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
                giver:disconnect()
                global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\PC\\Scripts\\PL&Zaaps\\PL_1-6X.lua")
            end

            giver:exchangeListen(true)
            giver.global():setPrivate(false)
            myController:exchangeListen(false)
            global:setPrivate(false)

            giver:loadConfig(configPath)
			if global:thisAccountController():getAlias():find("LvlUp") then
				giver:loadScript("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\PC\\Scripts\\Utilitaires\\setup_hiaky\\scripts\\give-kamas-and-stuff.lua")
			else
				giver:loadScript(scriptPath)
            end
			giver:startScript()
        end

        return Moving:goAstrubBank(function()
			global:delay(10000)
            Exch:launchExchange(giver.character():id())

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

            exchange:ready()
           
            developer:suspendScriptUntil("ExchangeLeaveMessage", 5000, false)

            Exch:deleteKamasOrder(function(order)
                return order.id == character:id()
            end)
            global:addInMemory("doneTransfert", true)

            if character:kamas() < 500000 then
                global:printSuccess("le bot banque n'a pas pu nous donner les kamas, on retente dans 1h")
                global:deleteMemory("doneTransfert")
                global:reconnect(1)
            end

            if not global:thisAccountController():getAlias():find("Draconiros") and getRemainingSubscription(true) <= 0 then 
				Abonnement() 
			else
				global:reconnect(0)
			end

            global:printSuccess("le bot banque n'a pas pu nous donner les kamas, on retente dans 4h")
            global:deleteMemory("doneTransfert")
            global:reconnect(4)

        end)
    elseif getRemainingSubscription(true) >= 0 then
        if global:thisAccountController():getAlias():find("Combat") then
            global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\PC\\Scripts\\Combat\\buyStuffSacri200.lua")
        elseif not global:thisAccountController():getAlias():find("Groupe") then
            if character:level() > 140 then
                global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\PC\\Scripts\\Recolte\\buyStuffRecolte.lua")
            end
            global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\PC\\Scripts\\PL&Zaaps\\Zaaps&Stuffs.lua")
        else
            global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\PC\\Scripts\\PL&Zaaps\\quete_pandala.lua")
        end
    else
        global:printSuccess("bug, on réessaye dans 1h")
        global:deleteMemory("doneTransfert")
        global:reconnect(1)
    end
end

function bank()
    return move()
end