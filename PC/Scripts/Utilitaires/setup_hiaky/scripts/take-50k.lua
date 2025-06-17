
--- <init>

PATH =  "C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\setup_hiaky\\"
scriptName = "take-kamas.lua"
dofile(PATH .. "template.lua")

dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Lib\\IMPORT_LIBRARIES.lua")


local insert = table.insert

configPath = "C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Configs\\configBank.xml"
scriptPath = "C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\setup_hiaky\\scripts\\give-kamas.lua"

function messagesRegistering()
    developer:registerMessage("HaapiShopApiKeyMessage", _HaapiShopApiKeyMessage)
	developer:registerMessage("HaapiConfirmationMessage", _HaapiConfirmationMessage)
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
        if getCurrentAreaName() ~= "Astrub" then
            map:changeMap("havenbag")
        end

        submitKamasOrder(50000)

        global:delay(500)

        if not giver then

            giver = Ctrl:connect2(giverAlias, true)

            if not giver then
                global:printError("[ERROR] Impossible de connecter le bot banque, nouvelle tentative dans " .. timeToRetry .. " heures.")
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

            deleteKamasOrder(function(order)
                return order.id == character:id()
            end)

			global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Craft\\GetAllPrices.lua")

            global:printSuccess("le bot banque n'a pas pu nous donner les kamas, on retente dans 4h")
            global:deleteMemory("doneTransfert")
            customReconnect(4 * 60)

        end)
    else
        global:printSuccess("bug, on réessaye dans 1h")
        global:deleteMemory("doneTransfert")
        customReconnect(60)
    end
end

function bank()
    return move()
end