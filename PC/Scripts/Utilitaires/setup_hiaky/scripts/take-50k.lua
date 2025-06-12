
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
    if not global:remember("doneTransfert") then
        
        if map:onMap("0,0") then
            map:changeMap("zaap(191105026)")
        end
        if map:currentArea() ~= "Astrub" then
            map:changeMap("havenbag")
        end

        Exch:submitKamasOrder(50000)

        global:delay(500)

        if not giver then

            giver = Ctrl:connect2(giverAlias, true)

            if not giver then
                print:errorInfo("Impossible de connecter le bot banque, nouvelle tentative dans " .. timeToRetry .. " heures.")
                global:reconnect(timeToRetry)
            end

            giver:exchangeListen(true)
            giver.global():setPrivate(false)
            myController:exchangeListen(false)
            global:setPrivate(false)

            giver:loadConfig(configPath)

			giver:loadScript(scriptPath)
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

			global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\PC\\Scripts\\Craft\\GetAllPrices.lua")

            global:printSuccess("le bot banque n'a pas pu nous donner les kamas, on retente dans 4h")
            global:deleteMemory("doneTransfert")
            global:reconnect(4)

        end)
    else
        global:printSuccess("bug, on réessaye dans 1h")
        global:deleteMemory("doneTransfert")
        global:reconnect(1)
    end
end

function bank()
    return move()
end