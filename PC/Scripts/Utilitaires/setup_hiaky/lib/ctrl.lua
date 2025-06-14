

Ctrl = {}



function Ctrl:connect(aliasTag, disconnectOnError)
    for _, acc in ipairs(snowbotController:getLoadedAccounts()) do
        if acc:getAlias():find(aliasTag .. "_" .. server) then
            if not acc:isAccountConnected() then
                acc:connect()
                local safetyCount = 0
                while not acc:isAccountFullyConnected() do
                    safetyCount = safetyCount + 1

                    if safetyCount == 1 then
                        global:printMessage("Attente de la connexion du bot banque (" .. maxWaitingTime .. " secondes max)")
                    end

                    global:delay(1000)

                    if safetyCount >= maxWaitingTime then
                        cannotConnect = true

                        if disconnectOnError then
                            if notifications then
                                Network:notify("Impossible de connecter le giver bot " .. aliasTag .. "\n\nNouvelle tentative dans " .. timeToRetry .. " heures.\nDéconnexion.")
                                print:errorInfo("Impossible de connecter le bot d'alias " .. aliasTag .. ".")
                                print:errorInfo("Nouvelle tentative dans " .. timeToRetry .. " heures.")
                            end

                            acc:disconnect()
                            customReconnect(timeToRetry)

                            return
                        else
                            return acc
                        end
                    end
                end
                return acc
            else
                return acc
            end
        end
    end
end

function Ctrl:connect2(aliasTag, disconnectOnError)
    for _, acc in ipairs(snowbotController:getLoadedAccounts()) do
        if acc:getAlias():find(aliasTag .. "_" .. server) then
            if not acc:isAccountConnected() then
                acc:connect()
                local safetyCount = 0
                while not acc:isAccountFullyConnected() do
                    safetyCount = safetyCount + 1

                    if safetyCount == 1 then
                        global:printMessage("Attente de la connexion du bot banque (" .. maxWaitingTime .. " secondes max)")
                    end

                    global:delay(1000)

                    if safetyCount >= maxWaitingTime then
                        cannotConnect = true

                        if disconnectOnError then
                            if notifications then
                                Network:notify("Impossible de connecter le giver bot " .. aliasTag .. "\n\nNouvelle tentative dans " .. timeToRetry .. " heures.\nDéconnexion.")
                                print:errorInfo("Impossible de connecter le bot d'alias " .. aliasTag .. ".")
                                print:errorInfo("Nouvelle tentative dans " .. timeToRetry .. " heures.")
                            end

                            acc:disconnect()
                            customReconnect(timeToRetry)

                            return
                        else
                            return acc
                        end
                    end
                end
                return acc
            else
                global:printSuccess("bot déjà connecté, on attend 5 secondes")
                global:delay(5000)
                return Ctrl:connect2(aliasTag, disconnectOnError)
            end
        end
    end
end