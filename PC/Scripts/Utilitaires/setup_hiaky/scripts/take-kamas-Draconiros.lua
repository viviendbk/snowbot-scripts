
--- <init>

PATH =  "C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Utilitaires\\setup_hiaky\\"
scriptName = "take-kamas.lua"
dofile(PATH .. "template.lua")

dofile("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Lib\\IMPORT_LIBRARIES.lua")


local insert = table.insert

configPath = "C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Configs\\configBank.xml"
scriptPath = "C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Utilitaires\\give-kamas.lua"

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
    if character:server() ~= "Draconiros" and getRemainingSubscription(true) > 0 then
        global:thisAccountController():forceServer("Draconiros")
        global:disconnect()
    end
    if not global:remember("doneTransfert") then

        submitKamasOrder(1400000)
        global:printSuccess("on demande " .. 1400000)
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
            Exch:launchExchange(giver.character():id())

            
            developer:suspendScriptUntil("ExchangeKamaModifiedMessage", 7500, false)

            global:delay(6000, 7000)


            exchange:ready()
           
            developer:suspendScriptUntil("ExchangeLeaveMessage", 5000, false)
           
            deleteKamasOrder(function(order)
            return order.id == character:id()
            end)
            
   
            global:addInMemory("doneTransfert", true)

            Abonnement(true)

            local id = giver.character():id()
			giver:loadConfig("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Configs\\configBank.xml")
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
                global:thisAccountController():loadConfigNextConnection("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Configs\\Config_PL_1-6X.xml", true)
            end

            global:printSuccess("Kamas transférés. On crée un compte sur Draconiros")
            giver:disconnect()
        
            global:disconnect()
        end)
    else
        if not global:thisAccountController():getAlias():find("Groupe") then
            global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\PLAndZaaps\\Zaaps&Stuffs.lua")
        else
            global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\PLAndZaaps\\quete_pandala.lua")
        end
    end
end