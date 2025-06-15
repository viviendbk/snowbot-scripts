
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



function move()
    -- if (getRemainingSubscription(true) >= 0 and not global:thisAccountController():getAlias():find("Draconiros")) 
    -- or (global:thisAccountController():getAlias():find("Draconiros") and character:kamas() > 150000) or character:kamas() > 1200000 then
    --     if not global:thisAccountController():getAlias():find("Groupe") then
    --         global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\PL&Zaaps\\Zaaps&Stuffs.lua")
    --     else
    --         global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\PL&Zaaps\\quete_pandala.lua")
    --     end
    -- end
    
    if getRemainingSubscription(true) >= 1 or character:kamas() > 2000000 then
        if global:thisAccountController():getAlias():find("Combat") then
            global:deleteMemory("doneTransfert")
            global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Combat\\Combat+Archi.lua")
        elseif global:thisAccountController():getAlias():find("Mineur") then
            global:deleteMemory("doneTransfert")
            global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Recolte\\Mineur_1-150_ULTIME.lua")
        elseif global:thisAccountController():getAlias():find("Bucheron") then
            global:deleteMemory("doneTransfert")
            global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Recolte\\Bucheron_1_200.lua")
        elseif global:thisAccountController():getAlias():find("LvlUp") then
            global:deleteMemory("doneTransfert")
            global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Combat\\PL_6X-114.lua")
        elseif global:thisAccountController():getAlias():find("Request") then
            global:deleteMemory("doneTransfert")
            global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Craft\\GetAllPrices.lua")
        end
    end

    if not global:remember("doneTransfert") then
        
        if map:onMap("0,0") then
            map:changeMap("zaap(191105026)")
        end
        if getRemainingSubscription(true) < 0 and getCurrentAreaName() ~= "Astrub" then
            global:disconnect()
        end
        if getCurrentAreaName() ~= "Astrub" then
            map:changeMap("havenbag")
        end

        Exch:submitKamasOrder(1400000)

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
            global:addInMemory("doneTransfert", true)

            if not global:thisAccountController():getAlias():find("Draconiros") and getRemainingSubscription(true) <= 1 then 
				Abonnement() 
			else
				global:disconnect()
			end

            global:printSuccess("le bot banque n'a pas pu nous donner les kamas, on retente dans 4h")
            global:deleteMemory("doneTransfert")
            customReconnect(4 * 60)

        end)
    elseif getRemainingSubscription(true) >= 0 then
        if global:thisAccountController():getAlias():find("Combat") then
            global:deleteMemory("doneTransfert")
            global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Combat\\Combat+Archi.lua")
        elseif global:thisAccountController():getAlias():find("Mineur") then
            global:deleteMemory("doneTransfert")
            global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Recolte\\Mineur_1-150_ULTIME.lua")
        elseif global:thisAccountController():getAlias():find("Bucheron") then
            global:deleteMemory("doneTransfert")
            global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Recolte\\Bucheron_1_200.lua")
        elseif global:thisAccountController():getAlias():find("LvlUp") then
            global:deleteMemory("doneTransfert")
            global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Combat\\PL_6X-114.lua")
        elseif global:thisAccountController():getAlias():find("Request") then
            global:deleteMemory("doneTransfert")
            global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Craft\\GetAllPrices.lua")
        end
    else
        global:printSuccess("bug, on réessaye dans 1h")
        global:deleteMemory("doneTransfert")
        customReconnect( 60)
    end
end

function bank()
    return move()
end