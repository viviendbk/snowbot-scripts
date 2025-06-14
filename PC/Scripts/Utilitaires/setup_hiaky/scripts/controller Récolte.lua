---@diagnostic disable: undefined-global, lowercase-global
--- <init>

PATH =  "C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\setup_hiaky\\"
scriptName = "controller.lua"
dofile(PATH .. "parameters.lua")
dofile(PATH .. "modules//print.lua")
--- </init>

dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Lib\\Craft.lua")
dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Lib\\DD.lua")
dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Lib\\HDV.lua")
dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Lib\\IA.lua")
dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Lib\\Utils.lua")

local totalKamas = 0
local DebutDeScript = true
local cptExportation = 0
local ipproxy = "193.252.210.41"

local serversMulti = {
    "Imagiro", "Orukam", "Tal Kasha", "Hell Mina", "Tylezia", "Draconiros", "Dakal", "Kourial", "Mikhal", "Rafal", "Salar", "Brial"
}

local serversMono = {
    "Draconiros", "Dakal", "Kourial", "Mikhal"
}


local proxies = {
    ["1"] = {
        ips = ipproxy .. "#SOCKS5_" .. ipproxy .. "#",
        port = "5001#5002",
        username = "proxy#proxy",
        password = "proxy123#proxy123"
    },
    ["2"] = {
        ips = ipproxy .. "#SOCKS5_" .. ipproxy .. "#",
        port = "5001#5003",
        username = "proxy#proxy",
        password = "proxy123#proxy123"
    },  
    ["3"] = {
        ips = ipproxy .. "#SOCKS5_" .. ipproxy .. "#",
        port = "5001#5004",
        username = "proxy#proxy",
        password = "proxy123#proxy123"
    },
    ["4"] = {
        ips = ipproxy .. "#SOCKS5_" .. ipproxy .. "#",
        port = "5001#5005",
        username = "proxy#proxy",
        password = "proxy123#proxy123"
    }, 
    ["5"] = {
        ips = ipproxy .. "#SOCKS5_" .. ipproxy .. "#",
        port = "5001#5006",
        username = "proxy#proxy",
        password = "proxy123#proxy123"
    },
}


local allServers = merge(serversMulti, serversMono)

local condition = function(acc)
    return acc:isAccountFullyConnected() and not acc:isScriptPlaying() and (acc:isTeamLeader() or not acc:isItATeam())
end

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

function join(tab, sep)
    local result = ''
    for k, v in ipairs(tab) do
        result = sep
            and result .. v .. sep
            or result .. v
    end

    return result
end

local function findMKamas(stringalias)
    local stringKamas = { }
    local tabstring = stringalias:split()

    for index, element in ipairs(tabstring) do
        if tabstring[index] == "[" then
            for i = 1, 3 do
                if tabstring[i + index] ~= "m" then
                    stringKamas[i] = tabstring[i + index]
                end
            end
        end
    end
    stringKamas = join(stringKamas)
    return (tonumber(stringKamas) == nil or tonumber(stringKamas) <= 5) and 0 or tonumber(stringKamas) - 5
end

local function GetServerByAlias(Alias)
    for _, Server in ipairs(allServers) do
        if Alias:lower():find(Server:lower()) then
            return Server
        end
    end
    return nil
end

local function GetServer(account)
    for _, Server in ipairs(allServers) do
        if account:getAlias():find(Server) then
            return Server
        end
    end
    return nil
end

local function GetProxy(lineToRead)
    local cpt = 0
    local i = 1
    local f = io.open("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\proxy.txt", "r")

    local toReturn = {proxy = {}, port = {}, username = {}, password = {}}

    for line in io.lines("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\proxy.txt") do 
        if i == lineToRead then
            tabline = line:split()
            for index, element in ipairs(tabline) do
                if element == ":" then
                    cpt = cpt + 1
                end
                if cpt == 0 then
                    toReturn.proxy[index] = element
                elseif cpt == 1 and element ~= ":" then
                    toReturn.port[index - #toReturn.proxy - 1] = element
                elseif cpt == 2 and element ~= ":" then
                    toReturn.username[index - (#toReturn.proxy + #toReturn.port) - 2] = element
                elseif cpt == 3 and element ~= ":" then
                    toReturn.password[index - (#toReturn.proxy + #toReturn.port + #toReturn.username) - 3] = element
                end
            end
        end
        i = i + 1
    end
    toReturn.proxy = join(toReturn.proxy)
    toReturn.port = join(toReturn.port)
    toReturn.username = join(toReturn.username)
    toReturn.password = join(toReturn.password)

    return toReturn
end


local function WithdrawTime(lines)
    -- printVar(lines)
    local toReturn = {}
    if lines then
        for _, element in ipairs(lines) do
            local parts = element:split(" ")  -- faire le split une seule fois
            local newElement = {}
            for i = 2, #parts do
                table.insert(newElement, parts[i])
            end
            if #newElement > 0 then
                table.insert(toReturn, join(newElement))
            end
        end
    end
    return toReturn
end

local function find_repeated_patterns(strings, x, y)
    local n = #strings
    local counts = {}
    local lastPattern = nil
    if strings then
        for i = 1, n - x + 1, x do
            local pattern = table.concat(strings, "", i, i + x - 1)
            if lastPattern and pattern ~= lastPattern then
              counts = {}
            end
            counts[pattern] = (counts[pattern] or 0) + 1
            if counts[pattern] == y then
                global:printMessage("pattern : " .. pattern .. "\nRépété " .. x .. " fois")
              return true
            end
            lastPattern = pattern
          end
    end

    return false
  end

local function LoopBug(lines)
    if lines then
        global:printSuccess("loopbug1")
        lines = WithdrawTime(lines)
        global:printSuccess("loopbug1.5")
        for i = 2, 15 do
            if find_repeated_patterns(lines, i, math.floor(#lines / math.floor(i * 2))) then
                global:printSuccess("loopbug2")
                return true
            end
        end
    end
    global:printSuccess("loopbug3")
    return false
end

local typeProxy = "socks5"
local proxyBank = GetProxy(1)
local proxyBucheron2_Mineur = GetProxy(3)
local proxyMineur2_3 = GetProxy(5)
local proxyBucheron_Mineur4 = GetProxy(2)
-- local proxyMineur = GetProxy(3)
local proxyMineur2 = GetProxy(5)
local proxyMineur3 = GetProxy(5) -- 11 avant
local proxyMineur5_Bucheron3 = GetProxy(11)
-- proxy normalement pas ici
-- local proxyMineur4 = GetProxy(7)
-- local proxyBucheron = GetProxy(2)
-- local proxyBucheron2 = GetProxy(8)

local function WhichServer()
    for _, acc in ipairs(snowbotController:getLoadedAccounts()) do
        if findMKamas(acc:getAlias()) > 2 and not acc:getAlias():lower():find("Draconiros") and not isAccountController(acc:getAlias()) and acc:getAlias():find("bank") then
            global:printSuccess("on tente de connecter : " .. acc:getAlias())
            acc:connect()
            local cannotConnect = false
            local safetyCount = 0
            while not acc:isAccountFullyConnected() and not cannotConnect do
                safetyCount = safetyCount + 1
    
                if safetyCount == 1 then
                    global:printMessage("Attente de la connexion du bot banque (" .. 120 .. " secondes max)")
                end
    
                global:delay(1000)
    
                if safetyCount >= 120 then
                    global:printError("Bot banque non-connecté après " .. 120 .. " secondes, on tente le suivant")
                    cannotConnect = true
                end
            end
            if cannotConnect then
                acc:disconnect()
            else
                acc:disconnect()
                return GetServerByAlias(acc:getAlias())
            end
        end
    end
    return nil
end

local function ExporterComptes()
    global:printSuccess("Exportation des comptes ...")

    AccountToLoad = { bank = {}, Combat = {}, LvlUp = {}, Bucheron = {}, Mineur = {}, Reste = {}}
    local all_alias = merge(snowbotController:getAliasNotLoadedAccounts(), snowbotController:getAliasLoadedAccounts())
    local all_usernames = merge(snowbotController:getUsernameNotLoadedAccounts(), snowbotController:getUsernameLoadedAccounts())
    debug("ok")
    for i, Alias in ipairs(all_alias) do
        if Alias:find("bank") then
            for j, Username in ipairs(all_usernames) do
                if i == j  then
                    global:printSuccess(Alias .. ":" .. Username)
                    table.insert(AccountToLoad.bank, Username)
                end
            end
        elseif Alias:find("Combat ") or Alias:find("Combat2") then
            for j, Username in ipairs(all_usernames) do
                if i == j then
                    table.insert(AccountToLoad.Combat, Username)
                end
            end
        elseif Alias:find("Combat3") or Alias:find("Combat4") then
            for j, Username in ipairs(all_usernames) do
                if i == j then
                    table.insert(AccountToLoad.Combat2, Username)
                end
            end
        elseif Alias:find("LvlUp1") or Alias:find("LvlUp2") then
            for j, Username in ipairs(all_usernames) do
                if i == j then
                    table.insert(AccountToLoad.LvlUp12, Username)
                end
            end
        elseif Alias:find("LvlUp3") or Alias:find("LvlUp4") then
            for j, Username in ipairs(all_usernames) do
                if i == j then
                    table.insert(AccountToLoad.LvlUp34, Username)
                end
            end
        elseif Alias:find("Bucheron") then
            for j, Username in ipairs(all_usernames) do
                if i == j then
                    table.insert(AccountToLoad.Bucheron, Username)
                end
            end
        elseif Alias:find("Mineur") then
            for j, Username in ipairs(all_usernames) do
                if i == j then
                    table.insert(AccountToLoad.Mineur, Username)
                end
            end
        elseif Alias:find("Groupe") then
            for j, Username in ipairs(all_usernames) do
                if i == j then
                    table.insert(AccountToLoad.Groupe, Username)
                end
            end
        elseif Alias:find("Craft") then
            for j, Username in ipairs(all_usernames) do
                if i == j then
                    table.insert(AccountToLoad.Craft, Username)
                end
            end
        elseif not Alias:find("-") then
            for j, Username in ipairs(all_usernames) do
                if i == j then
                    table.insert(AccountToLoad.Reste, Username)
                end
            end
        end
    end

    global:delay(5000)

    content = "/:" .. snowbotController:getPassword("/") .. ":---------- BOT BANQUE ----------" -- délimitateur bank

    for _, Username in ipairs(AccountToLoad.bank) do
        content = content .. "\n" .. Username .. ":" .. snowbotController:getPassword(Username) .. ":" .. snowbotController:getAlias(Username)
    end

    if #AccountToLoad.Combat > 0 then
        content = content .. "\n//:" .. snowbotController:getPassword("//") .. ":---------- COMBAT ----------" -- délimitateur Combat
    end

    for _, Username in ipairs(AccountToLoad.Combat) do
        content = content .. "\n" .. Username .. ":" .. snowbotController:getPassword(Username) .. ":" .. snowbotController:getAlias(Username)
    end

    if #AccountToLoad.Combat > 0 then
        content = content .. "\n///:" .. snowbotController:getPassword("///") .. ":---------- LVLUP ----------"-- délimitateur LvlUp
    else
        content = content .. "\n///:" .. snowbotController:getPassword("///") .. ":---------- BUCHERON ----------"-- délimitateur Bucheron
    end

    for _, Username in ipairs(AccountToLoad.Bucheron) do
        content = content .. "\n" .. Username .. ":" .. snowbotController:getPassword(Username) .. ":" .. snowbotController:getAlias(Username)
    end

    for _, Username in ipairs(AccountToLoad.LvlUp) do
        content = content .. "\n" .. Username .. ":" .. snowbotController:getPassword(Username) .. ":" .. snowbotController:getAlias(Username)
    end

    content = content .. "\n////:" .. snowbotController:getPassword("////") .. ":---------- MINEUR ----------" -- délimitateur Mineur

    for _, Username in ipairs(AccountToLoad.Mineur) do
        content = content .. "\n" .. Username .. ":" .. snowbotController:getPassword(Username) .. ":" .. snowbotController:getAlias(Username)
    end   

    for _, Username in ipairs(AccountToLoad.Reste) do
        content = content .. "\n" .. Username .. ":" .. snowbotController:getPassword(Username) .. ":" .. snowbotController:getAlias(Username)
    end   

    if #AccountToLoad.Combat > 0 then
        f = io.open("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\ComptesCombat.txt", "w")
    else
        global:printSuccess("aaaaaa")
        f = io.open("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\ComptesRecolte.txt", "w")
    end

    f:write(content)
    f:close()
    global:printSuccess("Exportation finie !")
end


local function FindInAllAccount(AliasToFind)
    local AllAlias = merge(snowbotController:getAliasNotLoadedAccounts(), snowbotController:getAliasLoadedAccounts())
    local AllUsernames = merge(snowbotController:getUsernameLoadedAccounts(), snowbotController:getUsernameNotLoadedAccounts())

    local Accs = {}

    for i, Alias in ipairs(AllAlias) do
        if Alias:find(AliasToFind) then
            table.insert(Accs, {Username = AllUsernames[i], Alias = Alias})
        end
    end
    return Accs
end

local function launchNewAccounts()
    -- mettre lancer les comptes HL avant s'il y en a
    local AliasAllAccount = merge(snowbotController:getAliasNotLoadedAccounts(), snowbotController:getAliasLoadedAccounts())


    for _, server in ipairs(allServers) do

        global:printSuccess(server)
        mineursPresents = {}

        for i = 1, 5 do
            for _, Alias in ipairs(AliasAllAccount) do
                if Alias:find("Mineur" .. i) and GetServerByAlias(Alias):find(server) then
                    global:printSuccess("On a trouvé un compte Mineur " .. i .. " sur " .. server)
                    mineursPresents[i] = true
                    break
                else
                    mineursPresents[i] = false
                end
            end
        end

        for _, canLoadNewAccount in ipairs(mineursPresents) do
            if not canLoadNewAccount then

                global:printSuccess("On peut créer un nouveau compte Mineur" .. _ .. " " .. server)
                local AliasNotLoaded = snowbotController:getAliasNotLoadedAccounts()
                for i, Alias in ipairs(AliasNotLoaded) do

                    if IsInTable(serversMono, server) and Alias:find("Next") then

                        local ServerToTake = WhichServer()
                        global:printSuccess("on crée le personnage sur " .. ServerToTake)
                        local UsernameNotLoaded = snowbotController:getUsernameNotLoadedAccounts()
                        for j, username in ipairs(UsernameNotLoaded) do
                            if i == j then
                                snowbotController:createCharacter(username, "", 11, false, server, "#f2c07d", "#000000", "#000000", "#ffffff", "#400000", "#400000")
                                snowbotController:assignProxyToAnAccount(username, proxies["1"].ips,  proxies["1"].port,  proxies["1"].username,  proxies["1"].password, (typeProxy ~= "socks5"), true)
                                
                                snowbotController:loadAnAccount(username, false)
                                local acc = snowbotController:getAccount(username)

                                acc.global():editAlias("Mineur" .. _ .. " " .. server, true)
                                break

                            end
                        end
                        break

                    elseif Alias == "*" and IsInTable(serversMulti, server) then
                        local UsernameNotLoaded = snowbotController:getUsernameNotLoadedAccounts()
                        for j, username in ipairs(UsernameNotLoaded) do
                            if i == j then

                                snowbotController:createCharacter(username, "", 11, false, server, "#f2c07d", "#000000", "#000000", "#ffffff", "#400000", "#400000")
                                snowbotController:assignProxyToAnAccount(username, proxies["1"].ips,  proxies["1"].port,  proxies["1"].username,  proxies["1"].password, (typeProxy ~= "socks5"), true)

                                snowbotController:loadAnAccount(username, false)
                                local acc = snowbotController:getAccount(username)

                                acc.global():editAlias("Mineur" .. _ .. " " .. server, true)
                                break

                            end
                        end
                        break

                    end
                end
            end
        end
    end
end


function connectAccountsWithFailleProxy()
    local loadedAccounts = snowbotController:getLoadedAccounts()
        local accountsToConnectByServer =  {
                   ["Imagiro"] = {}, ["Orukam"] = {}, ["Tylezia"] = {}, ["Hell Mina"] = {}, ["Tal Kasha"] = {}, ["Draconiros"] = {},
                        ["Dakal"] = {}, ["Kourial"] = {}, ["Mikhal"] = {}, ["Rafal"] = {}, ["Salar"] = {}, ["Brial"] = {}
    }
    
    for _, server in ipairs(allServers) do
        for _, acc in ipairs(loadedAccounts) do
            if acc:getAlias():find(server) and acc:getAlias():find("Mineur") and not acc:isAccountConnected() then
                table.insert(accountsToConnectByServer[server], acc)
            end
        end
    end

    local nbVagues = 0
    for _, accounts in pairs(accountsToConnectByServer) do
        if #accounts > nbVagues then
            nbVagues = #accounts
        end
    end

    global:printSuccess("Il y a " .. nbVagues .. " vagues de connexion à faire")

    -- 4. Connexion par vague
    for i = 1, nbVagues do
        global:printSuccess("----- Vague de connexion " .. i .. " -----")
        local ipDeBase = developer:getRequest("http://api.ipify.org", {}, {}, ipproxy .. ":5001:proxy:proxy123")
        global:printMessage("IP de base : " .. ipDeBase)
        developer:getRequest("http://" .. ipproxy .. "/reset?proxy=p:5001")
        local nouvelleIp = developer:getRequest("http://api.ipify.org", {}, {}, ipproxy .. ":5001:proxy:proxy123")

        if ipDeBase ~= nouvelleIp then
            global:printMessage("Nouvelle IP : " .. nouvelleIp)
        else
            global:printError("L'IP n'a pas changé, on retente dans 1 minutes")
            global:delay(60000) -- Attendre 1 minute avant de retenter
            return connectAccountsWithFailleProxy() -- Retenter la connexion
        end
        for server, accountList in pairs(accountsToConnectByServer) do
            local acc = accountList[i] -- on prend le i-ème compte si dispo
            if acc then
                global:printSuccess("Connexion de " .. acc:getAlias() .. " sur " .. server)
                acc:connect()
            end
        end

        global:delay(20000) -- 20000 ms = 2 secondes
    end


    -- for _, acc in ipairs(loadedAccounts) do
    --     if acc:getAlias():find("Mineur") and not acc:isAccountConnected()  then

    --         local ipDeBase = developer:getRequest("https//api.ipify.org", {}, {}, ipproxy .. ":5001:proxy:proxy123")
    --         global:printMessage("IP de base : " .. ipDeBase)
    --         developer:getRequest("http://" .. ipproxy .. "/reset?proxy=p:5001")
    --         local nouvelleIp = developer:getRequest("http://api.ipify.org", {}, {}, ipproxy .. ":5001:proxy:proxy123")

    --         if ipDeBase ~= nouvelleIp then
    --             global:printMessage("Nouvelle IP : " .. nouvelleIp)
    --             global:printSuccess("On connecte le compte : " .. acc:getAlias())
    --             acc:connect()
    --             global:delay(10000)
    --         else
    --             global:printError("L'IP n'a pas changé, on retente dans 1 minutes")
    --             global:delay(60000) -- Attendre 1 minute avant de retenter
    --             return connectAccountsWithFailleProxy() -- Retenter la connexion
    --         end

    --     end
    -- end
end

local function RegisterHLAccounts()
    -- Read the file
    local file = io.open("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\ComptesAVendre.txt", "r")
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
    file = io.open("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\ComptesAVendre.txt", "w")
    if not file then
      return nil, "Unable to open file for writing"
    end
  
    for _, line in ipairs(lines) do
      file:write(line, "\n")
    end
    file:close()
  end
  

function move()

    totalKamas = 0
    print:info("Checkup des bots")

    -- account loading
    resetBotBankAvailability(false)

    if cptExportation == 20 then
        cptExportation = 0
        ExporterComptes()
        RegisterHLAccounts()
        resetBotBankAvailability(false)
    end
    
    if DebutDeScript then
        global:printSuccess("Lancement des comptes")

        AccountToLoad = { bank = {}, Groupe = {
            ["Imagiro"] = {}, ["Orukam"] = {}, ["Tylezia"] = {}, ["Hell Mina"] = {}, ["Tal Kasha"] = {}, ["Draconiros"] = {},
                        ["Dakal"] = {}, ["Kourial"] = {}, ["Mikhal"] = {}, ["Rafal"] = {}, ["Salar"] = {}, ["Brial"] = {}

        }, Combat = {}, LvlUp = {}, Bucheron = {}, Bucheron2 = {}, Bucheron3 = {}, Mineur = {}, Mineur2 = {}, Mineur3 = {}, Mineur4 = {}, Mineur5 = {}}
    
        for i, acc in ipairs(snowbotController:getAliasNotLoadedAccounts()) do
            if acc:find("bank") then
                for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                    if i == j  then
                        table.insert(AccountToLoad.bank, Username)
                    end
                end
            elseif acc:find("LvlUp") and not acc:find("Next") then
                for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                    if i == j then
                        table.insert(AccountToLoad.LvlUp, Username)
                    end
                end
            elseif acc:find("Bucheron ") and not acc:find("Next") then
                for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                    if i == j then
                        table.insert(AccountToLoad.Bucheron, Username)
                    end
                end
            elseif acc:find("Bucheron2") and not acc:find("Next") then
                for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                    if i == j then
                        table.insert(AccountToLoad.Bucheron2, Username)
                    end
                end
            -- elseif acc:find("Bucheron3") and not acc:find("Next") then
            --     for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
            --         if i == j then
            --             table.insert(AccountToLoad.Bucheron3, Username)
            --         end
            --     end
            elseif acc:find("Mineur ") and not acc:find("Next") then
                for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                    if i == j then
                        table.insert(AccountToLoad.Mineur, Username)
                    end
                end
            elseif acc:find("Mineur2") and not acc:find("Next") then
                for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                    if i == j then
                        table.insert(AccountToLoad.Mineur2, Username)
                    end
                end
            elseif acc:find("Mineur3") and not acc:find("Next") then
                for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                    if i == j then
                        table.insert(AccountToLoad.Mineur3, Username)
                    end
                end
            elseif acc:find("Mineur4") and not acc:find("Next") then
                for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                    if i == j then
                        table.insert(AccountToLoad.Mineur4, Username)
                    end
                end
            -- elseif acc:find("Mineur5") and not acc:find("Next") then
            --     for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
            --         if i == j then
            --             table.insert(AccountToLoad.Mineur5, Username)
            --         end
            --     end
            end
            
        end


        DebutDeScript = false
        snowbotController:loadAnAccount("/", false) -- délimitateur bank
        for _, acc in ipairs(AccountToLoad.bank) do
            snowbotController:assignProxyToAnAccount(acc, proxies["1"].ips,  proxies["1"].port,  proxies["1"].username,  proxies["1"].password, (typeProxy ~= "socks5"), true)
            snowbotController:loadAnAccount(acc, false)
        end
        snowbotController:loadAnAccount("//", false) -- délimitateur Combat


        -- snowbotController:loadAnAccount("///", false) -- délimitateur Bucheron / LvlUp
        -- for _, acc in ipairs(AccountToLoad.Bucheron) do
        --     local proxy = proxyBucheron_Mineur4
        --     snowbotController:assignProxyToAnAccount(acc, proxy.proxy, tonumber(proxy.port), proxy.username, proxy.password, (typeProxy ~= "socks5"), true)
        --     snowbotController:loadAnAccount(acc, true)
        -- end
        -- for _, acc in ipairs(AccountToLoad.Bucheron2) do
        --     -- local proxy = proxyBucheron2_Mineur
        --     local proxy = proxyBucheron2_Mineur
        --     snowbotController:assignProxyToAnAccount(acc, proxy.proxy, tonumber(proxy.port), proxy.username, proxy.password, (typeProxy ~= "socks5"), true)
        --     snowbotController:loadAnAccount(acc, true)
        -- end
        -- for _, acc in ipairs(AccountToLoad.Bucheron3) do
        --     -- local proxy = proxyBucheron2_Mineur
        --     local proxy = proxyMineur5_Bucheron3
        --     snowbotController:assignProxyToAnAccount(acc, proxy.proxy, tonumber(proxy.port), proxy.username, proxy.password, (typeProxy ~= "socks5"), true)
        --     snowbotController:loadAnAccount(acc, true)
        -- end
        -- for _, acc in ipairs(AccountToLoad.Bucheron3) do
        --     local proxy = proxyMineur2_3
        --     snowbotController:assignProxyToAnAccount(acc, proxy.proxy, tonumber(proxy.port), proxy.username, proxy.password, (typeProxy ~= "socks5"), true)
        --     snowbotController:loadAnAccount(acc, true)
        -- end
        snowbotController:loadAnAccount("////", false) -- délimitateur Mineur
        for _, acc in ipairs(AccountToLoad.Mineur) do
            -- local proxy = proxyBucheron2_Mineur
            local proxy = proxyBucheron2_Mineur
            snowbotController:assignProxyToAnAccount(acc, proxies["1"].ips,  proxies["1"].port,  proxies["1"].username,  proxies["1"].password, (typeProxy ~= "socks5"), true)
            snowbotController:loadAnAccount(acc, false)
        end    
        for _, acc in ipairs(AccountToLoad.Mineur2) do
            -- local proxy = proxyMineur2_3
            local proxy = proxyMineur2
            snowbotController:assignProxyToAnAccount(acc, proxies["1"].ips,  proxies["1"].port,  proxies["1"].username,  proxies["1"].password, (typeProxy ~= "socks5"), true)
            snowbotController:loadAnAccount(acc, false)
        end
        for _, acc in ipairs(AccountToLoad.Mineur3) do
            -- local proxy = proxyMineur2_3
            local proxy = proxyMineur3
            snowbotController:assignProxyToAnAccount(acc, proxies["1"].ips,  proxies["1"].port,  proxies["1"].username,  proxies["1"].password, (typeProxy ~= "socks5"), true)
            snowbotController:loadAnAccount(acc, false)
        end 
        for _, acc in ipairs(AccountToLoad.Mineur4) do
            -- local proxy = proxyBucheron_Mineur4
            local proxy = proxyBucheron_Mineur4
            snowbotController:assignProxyToAnAccount(acc, proxies["1"].ips,  proxies["1"].port,  proxies["1"].username,  proxies["1"].password, (typeProxy ~= "socks5"), true)
            snowbotController:loadAnAccount(acc, false)
        end 

        for _, acc in ipairs(AccountToLoad.Mineur5) do
            local proxy = proxyMineur5_Bucheron3
            snowbotController:assignProxyToAnAccount(acc, proxies["1"].ips,  proxies["1"].port,  proxies["1"].username,  proxies["1"].password, (typeProxy ~= "socks5"), true)
            snowbotController:loadAnAccount(acc, false)
        end 

        --launchNewAccounts()

        global:printSuccess("Fin du lancement des comptes")
        RegisterHLAccounts()
        global:printSuccess("ok0")
        ExporterComptes()
        global:printSuccess("ok1")
        resetBotBankAvailability(true)
        global:printSuccess("ok2")

    end


    -- replace bans et debug
    local LoadedAccounts = snowbotController:getLoadedAccounts()
    for _, acc in ipairs(LoadedAccounts) do
        if (acc:isBanned() or acc:getAlias():find("BAN")) and (acc:getAlias():find("Mineur") or acc:getAlias():find("Bucheron")) then

            global:printSuccess(acc:getAlias())
            local AliasNotLoaded = snowbotController:getAliasNotLoadedAccounts()

            for i, Alias in ipairs(AliasNotLoaded) do
                if IsInTable(serversMono, GetServerByAlias(acc:getAlias())) and Alias:find("Next") and (acc:getAlias():find("Mineur") or acc:getAlias():find("Bucheron")) then
                    global:printSuccess("On remparte le compte " .. acc:getAlias())
                    snowbotController:deleteAccount(acc:getUsername())
                    launchNewAccounts()
                    break
                elseif IsInTable(serversMulti, GetServerByAlias(acc:getAlias())) and Alias == "*" and (acc:getAlias():find("Mineur") or acc:getAlias():find("Bucheron")) then
                    global:printSuccess("On remparte le compte " .. acc:getAlias())
                    snowbotController:deleteAccount(acc:getUsername())
                    launchNewAccounts()
                    break
                end
            end
        end


        lines = acc.global():consoleLines()
        if lines ~= nil then
            if not isAccountController(acc:getAlias()) and #lines > 100 and LoopBug(lines) then
                global:printSuccess("On débug le bot " .. acc:getAlias() .. " (loop bug)")
                acc.global():clearConsole()
                acc.global():reconnect(0)
            end

            local nbDjBlSuccess = 0
            local nbZaapsTaken = 0
            for _, ligne in ipairs(lines) do
                if ligne:find("Identifiant ou mot de passe incorrect !") then
                    snowbotController:deleteAccount(acc:getUsername())
                    DebutDeScript = true
                end
                if ligne:find("Trajet : Dj_Bl_Success lancé !") then
                    nbDjBlSuccess = nbDjBlSuccess + 1
                end
                if ligne:find("Vous avez perdu") then
                    nbZaapsTaken = nbZaapsTaken + 1
                end
            end
            if nbZaapsTaken > 20 then
                acc.global():clearConsole()
                acc:setScriptVariable("NeedToReturnBank", true)
            end
            if nbDjBlSuccess > 10 then
                acc.global():clearConsole()
                acc.global():loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\PL&Zaaps\\quete_pandala.lua")
            end

        end

        if not acc.developer():hasScript() and acc.character():level() < 10 and acc:isAccountFullyConnected() and not acc:getAlias():find("Groupe") then
            acc:loadConfig("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Configs\\Config_PL_1-6X.xml")
            acc:loadScript("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\PL&Zaaps\\PL_1-6X.lua")
            acc:disconnect()
            acc:connect()
        elseif not acc.developer():hasScript() and acc.character():level() > 140 and acc:isAccountFullyConnected() and not acc:getAlias():find("Groupe") then
            acc:loadConfig("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Configs\\ConfigRecolte.xml")
            acc:loadScript("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\setup_hiaky\\scripts\\take-kamas.lua")
            acc:disconnect()
            acc:connect()
        end

        if condition(acc) then
            acc:reloadScript()
            acc:startScript()
        end
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
        if acc:getAlias():find("bank") then
            totalKamas = totalKamas + findMKamas(acc:getAlias())
        end
    end


    connectAccountsWithFailleProxy()


    local LoadedAccounts = snowbotController:getLoadedAccounts()


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
        lines = acc.global():consoleLines()     
        if lines and not isAccountController(acc:getAlias()) then
            local cptTimeOut = 0
            local cptInactifReco = 0
            
            for i, ligne in ipairs(lines) do
                if ligne:find("Reconnexion automatique dans 5 secondes") then
                    cptInactifReco = cptInactifReco + 1
                    if cptInactifReco > 3 and acc:getAlias():find("bank") then
                        acc:disconnect()
                    end
                end
                if ligne:find("Identifiant ou mot de passe incorrect !") then

                    snowbotController:deleteAccount(acc:getUsername())
                    DebutDeScript = true
                end

                if ligne:find("TimeOut") and not ligne:find("ExchangeStartedBidSellerMessage") then
                    cptTimeOut = cptTimeOut + 1
                    global:printSuccess(cptTimeOut)
                else
                    cptTimeOut = 0
                end
                if cptTimeOut > 4 then
                    global:printSuccess("Je debug le compte " .. acc:getAlias() ..  " (TimeOut)")
                    acc.global():clearConsole()
                    acc:disconnect()
                    acc:connect()
                    break
                end
            end
        end   
    end


    global:editAlias("Controller : [" .. totalKamas .. "m]", true)

    local waitingTime = math.random(15, 25)
    print:successInfo("Checkup terminé, attente de " .. waitingTime .. " secondes.")
    global:delay(waitingTime * 1000)
    cptExportation = cptExportation + 1

    return move()
end