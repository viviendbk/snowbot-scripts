
--- <init>

PATH =  "C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\setup_hiaky\\"
scriptName = "take-kamas.lua"
dofile(PATH .. "template.lua")

dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\IMPORT_LIBRARIES.lua")


local insert = table.insert

configPath = "C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Configs\\configBank.xml"
scriptPath = "C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\setup_hiaky\\scripts\\give-kamas.lua"

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
    if character:server() ~= "Draconiros" and getRemainingSubscription(true) > 0 then
        global:thisAccountController():forceServer("Draconiros")
        global:reconnect(0)
    end
    if not global:remember("doneTransfert") then

        Exch:submitKamasOrder(1400000)
        global:printSuccess("on demande " .. 1400000)
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
            Exch:launchExchange(giver.character():id())

            
            developer:suspendScriptUntil("ExchangeKamaModifiedMessage", 7500, false)

            global:delay(6000, 7000)


            exchange:ready()
           
            developer:suspendScriptUntil("ExchangeLeaveMessage", 5000, false)
           
            Exch:deleteKamasOrder(function(order)
            return order.id == character:id()
            end)
            
   
            global:addInMemory("doneTransfert", true)

            Abonnement(true)

            local id = giver.character():id()
			giver:loadConfig("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Configs\\configBank.xml")
            giver:startScript()

            global:printSuccess("Lancement de l'échange avec le bot d'ID " .. id)
        
            while not exchange:launchExchangeWithPlayer(id) do
                global:printMessage("Attente de l'acceptation de l'échange (5 secondes)")
                global:delay(5000)
            end
        
            exchange:putKamas(character:kamas())
            exchange:ready()
        
            global:delay(3000)

            global:thisAccountController():forceDelete(character:name())
            if not global:thisAccountController():getAlias():find("Groupe") then
                snowbotController:createCharacter(global:thisAccountController():getUsername(), "Draconiros", 11, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
                global:thisAccountController():loadConfigNextConnection("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Configs\\Config_PL_1-6X.xml", true)
            end

            global:printSuccess("Kamas transférés. On crée un compte sur Draconiros")
            giver:disconnect()
        
            global:reconnect(0)
        end)
    else
        if not global:thisAccountController():getAlias():find("Groupe") then
            global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\PL&Zaaps\\Zaaps&Stuffs.lua")
        else
            global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\PL&Zaaps\\quete_pandala.lua")
        end
    end
end