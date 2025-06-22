---@diagnostic disable: undefined-global, lowercase-global

dofile("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Lib\\IMPORT_LIBRARIES.lua")


local totalKamas = 0
local DebutDeScript = true
local cptExportation = 0
local nbMax = NB_COMBAT
local type = "Combat"
local proxyNumber = "2"
local proxyBank = "5"



local function RegisterHLAccounts()
    -- Read the file
    local file = io.open("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Assets\\ComptesAVendre.txt", "r")
    if not file then
      return nil, "Unable to open file"
    end
  
    local lines = {}
    for line in file:lines() do
      table.insert(lines, line)
    end
    file:close()
  
    -- Count occurrences of the third element
    local servers = {
      ["Imagiro"] = {},
      ["Orukam"] = {},
      ["Tal Kasha"] = {},
      ["Hell Mina"] = {},
      ["Tylezia"] = {},
      ["Draconiros"] = {},
      ["Dakal"] = {},
      ["Kourial"] = {},
      ["Mikhal"] = {},
      ["Rafal"] = {},
      ["Salar"] = {},
      ["Brial"] = {}
    }

    for k, v in pairs(servers) do
      for _, line in ipairs(lines) do
        if line:find(k) then
          local infos = line:split(":")
          if not infos[3]:find("200") and not infos[3]:find("199") then
            table.insert(v, {Username = infos[1], Password = infos[2], Alias = infos[3]})
          end
        end
      end
    end

    for k, v in pairs(servers) do
      local nbToInsert = math.min((#v - 10) - (#v - 10) % 2, 6 - #FindInAllAccount(k .. "HL"))
      if nbToInsert > 0 then
        global:printSuccess("Il y a " .. #v .. " comptes hl sur le server " .. k .. " on en met sur le ankabot recolte")
        for i = 1, nbToInsert do
            global:printSuccess("On ajoute " .. v[i].Username .. " : " .. v[i].Password .. " : " .. v[i].Alias)
          snowbotController:registerAccount(v[i].Username, v[i].Password, k .. "HL")
        end
        -- Remove surplus accounts from the servers table
        for i = 1, nbToInsert do
          table.remove(v, i)
        end

      end
    end

    lines = {}
    for k, v in pairs(servers) do
        for _, element in ipairs(v) do
            lines[#lines+1] = element.Username .. ":" .. element.Password .. ":" .. element.Alias
        end
        lines[#lines+1] = "\n"
    end
  
    -- Write the modified content back to the file
    file = io.open("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Assets\\ComptesAVendre.txt", "w")
    if not file then
      return nil, "Unable to open file for writing"
    end
  
    for _, line in ipairs(lines) do
      file:write(line, "\n")
    end
    file:close()
  end
  

local function loadAccounts()
        AccountToLoad = { bank = {}, Groupe = {
            ["Imagiro"] = {}, ["Orukam"] = {}, ["Tylezia"] = {}, ["Hell Mina"] = {}, ["Tal Kasha"] = {}, ["Draconiros"] = {},
                        ["Dakal"] = {}, ["Kourial"] = {}, ["Mikhal"] = {}, ["Rafal"] = {}, ["Salar"] = {}, ["Brial"] = {}

        }, Combat = {}, LvlUp = {}, Bucheron = {}, Mineur = {}}
    
        for i, acc in ipairs(snowbotController:getAliasNotLoadedAccounts()) do
            if acc:find("bank") then
                for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                    if i == j  then
                        table.insert(AccountToLoad.bank, Username)
                    end
                end
            elseif acc:find("Combat") and not acc:find("Next") then
                for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                    if i == j then
                        table.insert(AccountToLoad.Combat, Username)
                    end
                end
            end
            
        end

        snowbotController:loadAnAccount("/", false) -- délimitateur bank
        for _, acc in ipairs(AccountToLoad.bank) do
            snowbotController:assignProxyToAnAccount(acc, PROXIES[proxyBank].ips,  PROXIES[proxyBank].port,  PROXIES[proxyBank].username,  PROXIES[proxyBank].password, (TYPE_PROXY ~= "socks5"), true)
            snowbotController:loadAnAccount(acc, false)
        end

        snowbotController:loadAnAccount("//", false) -- délimitateur Combat
        
        for _, acc in ipairs(AccountToLoad.Combat) do
            snowbotController:assignProxyToAnAccount(acc, PROXIES[proxyNumber].ips,  PROXIES[proxyNumber].port,  PROXIES[proxyNumber].username,  PROXIES[proxyNumber].password, (TYPE_PROXY ~= "socks5"), true)
            snowbotController:loadAnAccount(acc, false)
        end
 

end


function move()

    totalKamas = 0
    global:printMessage("[INFO] : Checkup des bots")

    -- account loading
    resetBotBankAvailability(false)

    if cptExportation == 20 then
        cptExportation = 0
        ExporterComptes("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Assets\\Comptes" .. type .. ".txt")
        -- RegisterHLAccounts()
        resetBotBankAvailability(false)
    end
    
    if DebutDeScript then
        global:printSuccess("Lancement des comptes")

        loadAccounts()

        launchNewAccounts(type, nbMax, 1)

        global:printSuccess("Fin du lancement des comptes")
        -- RegisterHLAccounts()
        global:printSuccess("ok0")
        ExporterComptes("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Assets\\Comptes" .. type .. ".txt")
        global:printSuccess("ok1")
        resetBotBankAvailability(true)
        global:printSuccess("ok2")
        DebutDeScript = false

    end


    -- replace bans et debug
    local LoadedAccounts = snowbotController:getLoadedAccounts()
    for _, acc in ipairs(LoadedAccounts) do
        if (acc:isBanned() or acc:getAlias():find("BAN")) and (acc:getAlias():find("Mineur") or acc:getAlias():find("Bucheron")) then

            global:printSuccess(acc:getAlias())
            local AliasNotLoaded = snowbotController:getAliasNotLoadedAccounts()

            for i, Alias in ipairs(AliasNotLoaded) do
                if IsInTable(SERVERS_MONO, GetServerByAlias(acc:getAlias())) and Alias:find("Next") and (acc:getAlias():find("Mineur") or acc:getAlias():find("Bucheron")) then
                    global:printSuccess("On remplace le compte " .. acc:getAlias())
                    -- snowbotController:deleteAccount(acc:getUsername())
                    -- launchNewAccounts(type, nbMax, 1)
                    break
                elseif IsInTable(SERVERS_MULTI, GetServerByAlias(acc:getAlias())) and Alias == "*" and (acc:getAlias():find("Mineur") or acc:getAlias():find("Bucheron")) then
                    global:printSuccess("On remplace le compte " .. acc:getAlias())
                    -- snowbotController:deleteAccount(acc:getUsername())
                    -- launchNewAccounts(type, nbMax, 1)
                    break
                end
            end
        end


        lines = acc.global():consoleLines()
        if lines ~= nil and #lines > 0 then
            if not isAccountController(acc:getAlias()) and #lines > 100 and LoopBug(lines) then
                global:printSuccess("On débug le bot " .. acc:getAlias() .. " (loop bug)")
                acc.global():clearConsole()
                acc.disconnect()
            end
            -- debug("1")
            local nbZaapsTaken = 0
            for _, ligne in ipairs(lines) do
                if ligne:find("Identifiant ou mot de passe incorrect !") then
                    snowbotController:deleteAccount(acc:getUsername())
                    DebutDeScript = true
                end
                if ligne:find("Vous avez perdu") then
                    nbZaapsTaken = nbZaapsTaken + 1
                end
            end
                        -- debug("2")

            if nbZaapsTaken > 20 then
                acc.global():clearConsole()
                acc:setScriptVariable("NeedToReturnBank", true)
            end

            -- ajouter le check de si le compte est connecté et si ce n'est pas un compte craft
            local lastLog = extractTime(lines[#lines])
            if not lastLog then
                global:printError("impossible de trouver l'heure de reconnexion dans l'alias: " .. acc:getAlias())
            else
                local lastLogPlusX = addMinutes(lastLog, 20)
                -- Vérification si l'heure actuelle dépasse celle de reconnexion + 30 minutes
                local currentTime = os.date("%H:%M:%S")

                if acc:isAccountConnected() and compareHours(currentTime, lastLogPlusX) then
                    debug("[" .. acc:getAlias() .. "] :  lastLog: " .. lastLog .. " | lastLogPlusX: " .. lastLogPlusX .. " | currentTime: " .. currentTime)
                    debug(lines[#lines])
                    acc:disconnect()
                end
            end

        end
        debug("3")
        if not acc.developer():hasScript() and acc:isAccountFullyConnected() and not acc:getAlias():find("Groupe")
        and (job:level(2) > 5 or job:level(24) > 5 or character:level() < 60) then
            acc:loadConfig("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Configs\\Config_PL_1-6X.xml")
            acc:loadScript("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\PLAndZaaps\\PL_1-6X.lua")
            acc:disconnect()
        elseif not acc.developer():hasScript() and acc:getAlias():find("Combat") then

            acc:loadConfig("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Configs\\ConfigCombat.xml")
            acc:loadScript("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Combat\\Combat+Archi.lua")
            acc:disconnect()
        elseif not acc.developer():hasScript() and acc.character():level() > 140 and acc:isAccountFullyConnected() and not acc:getAlias():find("Groupe") then
            acc:loadConfig("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Configs\\ConfigRecolte.xml")
            acc:loadScript("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Utilitaires\\take-kamas.lua")
            acc:disconnect()

        end
        debug("4")
        if conditionStartScript(acc) then
            acc:reloadScript()
            acc:startScript()
        end
        -- debug("5")
        if acc:isAccountFullyConnected() and not acc:isScriptPlaying() and acc:isTeamLeader() then
            local team = acc:getTeamAccounts()
            local ready = true
            for _, acc in ipairs(team) do
                if not acc:isAccountFullyConnected() then
                    ready = false
                end
            end
            if ready then
                acc:reloadScript()
                acc:startScript()
            end
        end
        -- debug("6")
        if acc:getAlias():find("bank") then
            totalKamas = totalKamas + findMKamas(acc:getAlias())
        end
    end

    debug("7")
    connectAccountsWithFailleProxy()


    local LoadedAccounts = snowbotController:getLoadedAccounts()

    -- debug("8")
    for _, acc in ipairs(LoadedAccounts) do
        if acc:isAccountFullyConnected() and not acc:isScriptPlaying() and acc:isTeamLeader() then
            local team = acc:getTeamAccounts()
            local ready = true
            for _, acc in ipairs(team) do
                if not acc:isAccountFullyConnected() then
                    ready = false
                end
            end
            if ready then
                table.insert(team, acc)
                for _, acc in ipairs(team) do
                    if not acc.map:onMap("0,0") then
                        acc.map:changeMap("havenbag")
                    end
                end
                acc:reloadScript()
                acc:startScript()
            end
        end
        -- lines = acc.global():consoleLines()     
        -- if lines and not isAccountController(acc:getAlias()) then
        --     local cptTimeOut = 0
        --     local cptInactifReco = 0
            
        --     for i, ligne in ipairs(lines) do
        --         if ligne:find("Reconnexion automatique dans 5 secondes") then
        --             cptInactifReco = cptInactifReco + 1
        --             if cptInactifReco > 3 and acc:getAlias():find("bank") then
        --                 acc:disconnect()
        --             end
        --         end
        --         if ligne:find("Identifiant ou mot de passe incorrect !") then

        --             snowbotController:deleteAccount(acc:getUsername())
        --             DebutDeScript = true
        --         end

        --         if ligne:find("TimeOut") and not ligne:find("ExchangeStartedBidSellerMessage") then
        --             cptTimeOut = cptTimeOut + 1
        --             global:printSuccess(cptTimeOut)
        --         else
        --             cptTimeOut = 0
        --         end
        --         if cptTimeOut > 4 then
        --             global:printSuccess("Je debug le compte " .. acc:getAlias() ..  " (TimeOut)")
        --             acc.global():clearConsole()
        --             acc:disconnect()
        --             break
        --         end
        --     end
        -- end   
    end


    global:editAlias("Controller : [" .. totalKamas .. "m]", true)

    local waitingTime = math.random(15, 25)
    global:printSuccess("[SUCCESS] : Checkup terminé, attente de " .. waitingTime .. " secondes.")
    global:delay(waitingTime * 1000)
    cptExportation = cptExportation + 1

    return move()
end