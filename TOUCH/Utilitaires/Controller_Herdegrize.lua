dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\All_Fonctions.lua")

local condition = function(acc)
    return acc:isAccountFullyConnected() and not acc:isScriptPlaying() and not acc:isItATeam() --[[and not acc:getAlias():find("bank")]]
end

local cptExportation = 20
local serverController = "Herdegrize"

local PathPhenix = {
    { map = "-16,1", path = "right" },
    { map = "-15,1", path = "right" },
    { map = "-14,1", path = "right" },
    { map = "-13,1", path = "right" },
    { map = "-12,1", path = "right" },
    { map = "-11,1", path = "top" },
    { map = "-11,0", path = "top" },
    { map = "-11,-1", path = "top" },
    { map = "-11,-2", path = "top" },
    { map = "-11,-3", path = "top" },
    { map = "-11,-4", path = "top" },
    { map = "-11,-5", path = "top" },
    { map = "-11,-6", path = "right" },
    { map = "-8,-5", path = "left" },
    { map = "-9,-5", path = "left" },
    { map = "-10,-5", path = "left" },
    {map = "-10,-6", custom = function(acc) 
        acc.map:door(185)
        acc:callScriptFunction("PopoRappel")
    end},

        
    { map = "32,11", path = "top" },
    { map = "32,10", path = "top" },
    { map = "32,9", path = "top" },
    { map = "32,8", path = "top" },
    { map = "33,7", path = "top" },
    { map = "34,6", path = "top" },
    { map = "32,7", path = "right" },
    { map = "33,6", path = "right" },
    { map = "34,5", path = "right" },
    { map = "34,6", path = "right" },
    { map = "35,5", path = "right" },
    {map = "36,5", custom = function (acc)
        acc.map:door(327)
        acc:callScriptFunction("PopoRappel")
    end},


    { map = "-1,25", path = "left" },
    { map = "-2,25", path = "left" },
    { map = "-3,25", path = "left" },
    { map = "-4,25", path = "left" },
    { map = "-5,25", path = "left(84)" },
    { map = "-6,25", path = "left" },
    { map = "-14,26", path = "bottom" },
    { map = "-14,27", path = "bottom" },
    { map = "-14,29", path = "bottom" },
    { map = "-14,28", path = "bottom" },
    { map = "-7,25", path = "bottom" },
    { map = "-7,26", path = "left" },
    { map = "-8,26", path = "left" },
    { map = "-9,26", path = "left" },
    { map = "-11,26", path = "left" },
    { map = "-10,26", path = "left" },
    { map = "-12,26", path = "left" },
    { map = "-13,26", path = "left" },
    {map = "-14,30", path = "bottom"},
    {map = "-13,30", path = "left"},
    {map = "-13,31", path = "left"},
    {map = "-13,32", path = "left"},
    {map = "-15,32", path = "right"},
    {map = "-14,32", path = "top"},
    {map = "-14,31", custom = function (acc)
        acc.map:door(243)
        acc:callScriptFunction("PopoRappel")
    end},
    {map = "-18,-57", custom = function (acc)
        acc.map:door(172)
        acc:callScriptFunction("PopoRappel")
    end},
    {map = "-11,16", path = "top"},
    {map = "-11,15", path = "top"},
    {map = "-11,14", path = "top"},
    {map = "-11,13", path = "right"},
    {map = "-13,13", path = "right"},
    {map = "-12,13", path = "right"},
    {map = "64489222", custom = function (acc)
        acc.map:door(354)
        acc.mount:toggleRiding()
        acc.map:door(218)
    end},

    { map = "8,16", path = "right" },
    {map = "9,16", path = "right"},
    {map = "10,16", path = "right"},
    {map = "11,16", path = "right"},
    {map = "12,16", path = "right"},
    {map = "13,16", path = "top"},
    {map = "13,15", path = "top"},
    {map = "13,14", path = "top"},
    {map = "13,13", path = "top"},
    {map = "13,12", path = "left"},
    {map = "10,12", path = "right"},
    {map = "11,12", path = "right"},
    {map = "12,12", custom = function(acc) 
        acc.map:door(184)
        acc:callScriptFunction("PopoRappel")
    end},
}

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


local function GetTeamNumberAndServer(Alias)
    local toReturn = {
        TeamNumber = 0,
        Server = "",
    }
    Alias = Alias:split(" ")

    for i, string in ipairs(Alias) do
        if i == 2 then
            toReturn.TeamNumber = string
        elseif i == 3 then
            toReturn.Server = string
        end
    end
    toReturn.Server = toReturn.Server:split()
    for i = 1, #toReturn.Server do
        if toReturn.Server[i] == "," then
            toReturn.Server[i] = ""
        end
    end
    toReturn.Server = join(toReturn.Server)
    return toReturn
end


local function GetProxy(lineToRead)
    local i = 1

    local toReturn = {proxy = {}, port = {}, username = {}, password = {}}

    for line in io.lines("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\proxy.txt") do
        if i == tonumber(lineToRead) then
            local tabline = line:split(":")
            toReturn.proxy = tabline[1]
            toReturn.port = tabline[2]
            toReturn.username = tabline[3]
            toReturn.password = tabline[4]
        end
        i = i + 1
    end

    return toReturn
end

local function DeleteInAlias(acc, toDelete)
    local AliasSplit = acc:getAlias():split(" ")
    for i = 1, #AliasSplit do
        if AliasSplit[i]:find(toDelete)  then
            global:printSuccess("On le delete")
            AliasSplit[i] = ""
        end
    end
    acc.global:editAlias(join(AliasSplit, " "), true)
end

local function ManageTeams(acc)

    if acc:getAlias():find("Need1") and acc:isTeamLeader() then
        local Team = acc:getTeamAccounts()
        local Usernames = {}

        for _, account in ipairs(Team) do
            if account:getAlias():find("Need1") then
                DeleteInAlias(account, "Need")
                table.insert(Usernames, account:getUsername())
            end
        end
        DeleteInAlias(acc, "Need")
        table.insert(Usernames, 1, acc:getUsername())

        acc:unloadAccount()

        global:delay(1000)
        for _, Username in ipairs(Usernames) do
            ankabotController:loadAccount(Username, true)
            global:delay(500)
        end
    elseif acc:getAlias():find("Need2") then
        if (acc:isTeamLeader() and #acc:getTeamAccounts() ~= 1) or not acc:isTeamLeader() then
            acc:unloadAccount()
            global:delay(500)
        end
    elseif  acc:getAlias():find("Need3") then
        if (acc:isTeamLeader() and #acc:getTeamAccounts() ~= 2) or not acc:isTeamLeader() then
            acc:unloadAccount()
            global:delay(500)
        end
    elseif  acc:getAlias():find("Need4") then
        if (acc:isTeamLeader() and #acc:getTeamAccounts() ~= 3) or not acc:isTeamLeader() then
            acc:unloadAccount()
            global:delay(500)
        end
    end

    -- Check des teams qu'on peut créer

    local servers = {"Herdegrize", "Oshimo", "Terra_Cogita", "Dodge", "Brutas", "Grandapan"}

    local AliasNotloadedAccounts = ankabotController:getAliasNotLoadedAccounts()
    local UsernamesNotloadedAccounts = ankabotController:getUsernameNotLoadedAccounts()
    local Team2 = {}
    local Team3 = {}
    local Team4 = {}

    for _, server in ipairs(servers) do
        Team2[server] = {}
        Team3[server] = {}
        Team4[server] = {}

        for w = 1, 10 do
            Team2[server][w] = {}
            Team3[server][w] = {}
            Team4[server][w] = {}
            for i, Alias in ipairs(AliasNotloadedAccounts) do
                if Alias:find("Need2") and Alias:find(server) and Alias:find(" " .. w .. " ") then
                    for j, Username in ipairs(UsernamesNotloadedAccounts) do
                        if i == j then
                            table.insert(Team2[server][w], Username)
                        end
                    end
                end
                if Alias:find("Need3") and Alias:find(server) and Alias:find(" " .. w .. " ") then
                    for j, Username in ipairs(UsernamesNotloadedAccounts) do
                        if i == j then
                            table.insert(Team3[server][w], Username)
                        end
                    end
                end
                if Alias:find("Need4") and Alias:find(server) and Alias:find(" " .. w .. " ") then
                    for j, Username in ipairs(UsernamesNotloadedAccounts) do
                        if i == j then
                            table.insert(Team4[server][w], Username)
                        end
                    end
                end
            end
        end
    end

    for _, server in ipairs(servers) do
        for i = 1, 10 do
            if Team2[server][i] ~= nil and #Team2[server][i] == 1 and Team4[server][i] ~= nil and (#Team4[server][i] == 1 or #Team4[server][i] == 3) then
                TeamAcc = ankabotController:loadTeamAccount({Team2[server][i][1], Team4[server][i][1]}, Team4[server][i][1], true)
                global:delay(500)
                for _, account in ipairs(TeamAcc) do
                    DeleteInAlias(account, "Need")
                    DeleteInAlias(account, "CanGiveToBotBank")
                    global:delay(500)
                end
            end
            if Team2[server][i] ~= nil and #Team2[server][i] == 2 then
                TeamAcc = ankabotController:loadTeamAccount(Team2[server][i], Team2[server][i][1], true)
                global:delay(500)
                for _, account in ipairs(TeamAcc) do
                    DeleteInAlias(account, "Need")
                    DeleteInAlias(account, "CanGiveToBotBank")
                    global:delay(500)
                end
            end
            if Team2[server][i] ~= nil and #Team2[server][i] == 3 then
                TeamAcc = ankabotController:loadTeamAccount({Team2[server][i][1], Team2[server][i][2]}, Team2[server][i][1], true)
                global:delay(500)
                for _, account in ipairs(TeamAcc) do
                    DeleteInAlias(account, "Need")
                    DeleteInAlias(account, "CanGiveToBotBank")
                    global:delay(500)
                end
            end
            if Team2[server][i] ~= nil and #Team2[server][i] == 4 then
                TeamAcc = ankabotController:loadTeamAccount({Team2[server][i][1], Team2[server][i][2]}, Team2[server][i][1], true)
                global:delay(500)
                for _, account in ipairs(TeamAcc) do
                    DeleteInAlias(account, "Need")
                    DeleteInAlias(account, "CanGiveToBotBank")
                    global:delay(500)
                end
                TeamAcc = ankabotController:loadTeamAccount({Team2[server][i][3], Team2[server][i][4]}, Team2[server][i][3], true)
                global:delay(500)
                for _, account in ipairs(TeamAcc) do
                    DeleteInAlias(account, "Need")
                    DeleteInAlias(account, "CanGiveToBotBank")
                    global:delay(500)
                end
            end
            if Team3[server][i] ~= nil and #Team3[server][i] == 3 then
                TeamAcc = ankabotController:loadTeamAccount(Team3[server][i], Team3[server][i][1], true)
                global:delay(500)
                for _, account in ipairs(TeamAcc) do
                    DeleteInAlias(account, "Need")
                    DeleteInAlias(account, "CanGiveToBotBank")
                    global:delay(500)
                end
            end
            if Team4[server][i] ~= nil and #Team4[server][i] == 4 then
                TeamAcc = ankabotController:loadTeamAccount(Team4[server][i], Team4[server][i][1], true)
                global:delay(500)
                for _, account in ipairs(TeamAcc) do
                    DeleteInAlias(account, "Need")
                    DeleteInAlias(account, "CanGiveToBotBank")
                    global:delay(500)
                end
            end
        end
    end
end

local function DebugDeathTeam(acc)
    if acc:isTeamLeader() and acc:isAccountFullyConnected() then
        local Team = acc:getTeamAccounts()
        table.insert(Team, 1, acc)
        local NbDeath = 0
        local UsePopoRappel = false
        for _, account in ipairs(Team) do
            if account:isAccountFullyConnected() and account.character:energyPoints() == 0 then
                NbDeath = NbDeath + 1
            end
        end
        while NbDeath > 0 and NbDeath < 4 do
            UsePopoRappel = true
            NbDeath = 0
            for _, account in ipairs(Team) do
                if account:isAccountFullyConnected() and account.character:energyPoints() == 0 and not acc:isBanned() then
                    global:printSuccess("Appel de la fonction phenix pour le bot " .. account:getAlias())
                    NbDeath = NbDeath + 1
                    for _, element in ipairs(PathPhenix) do
                        if account.map:onMap(element.map) then
                            if element.path then
                                account.map:changeMap(element.path)
                            else
                                element.custom(account)
                            end
                            global:delay(2000)
                            if account.map:onMap(element.map) then
                                global:printSuccess("bug, on déco reco le compte")
                                account.global:reconnect(0)
                                while not account:isAccountFullyConnected() do
                                    global:delay(1000)
                                end
                                global:delay(2000)
                            end
                        end
                    end
                end
            end   
        end
        if UsePopoRappel then
            for _, account in ipairs(Team) do
                account:callScriptFunction("PopoRappel")
            end
        end
    end
end

local function PopoRappelTeam(acc)
    local Team = acc:getTeamAccounts()
    if acc:isTeamLeader() and acc.character:energyPoints() > 0 then
        for i = 1, #Team do
            Team[i]:callScriptFunction("PopoRappel")
        end

        -- for i = 1, #Team do
        --     local consoleLines = Team[i].global:consoleLines()
        --     for i, ligne in ipairs(consoleLines) do
        --         if ligne:find("System.NullReferenceException: Object reference not set to an instance of an object.") then
        --             global:printSuccess("le perso a bug, on le déco reco")
        --             Team[i].global:clearConsole()
        --             Team[i].global:reconnect(0)
        --             while not Team[i]:isAccountFullyConnected() do
        --                 global:delay(2000)
        --             end
        --             Team[i]:callScriptFunction("PopoRappel")
        --         end
        --     end
        -- end
    end
end


local function IsTeamAtTheSameMap(acc)
    local isLeader = acc:isTeamLeader() and acc.character:energyPoints() > 0
    local sameMap = true
    local Team = acc:getTeamAccounts()
    local i = 1
    while sameMap and i <= #Team do
        sameMap = (Team[i].map:currentMapId() == acc.map:currentMapId())
        i = i + 1
    end
    return isLeader and sameMap
end

local function DebugLostTeam(acc)
    if acc:isTeamLeader() and acc.character:energyPoints() > 0 then
        local RappelTeam = false
        local Team = acc:getTeamAccounts()
        for _, account in ipairs(Team) do
            if account:isAccountFullyConnected() and account.character:energyPoints() == 0 then
                return
            end
        end
        for _, account in ipairs(Team) do
            local lines = account.global:consoleLines()
            if lines ~= nil then
                for i, ligne in ipairs(lines) do
                    if ligne:find("Erreur dans le script : Echec lors de l'utilisation d'un Zaap/Zaapi") and not account:isBanned() and account:isAccountFullyConnected() then
                        global:printSuccess("Debug de " .. account:getAlias() .. "(bug zaap)")
                        account.global:clearConsole()
                        if not IsTeamAtTheSameMap(acc) then
                            acc:callScriptFunction("PopoRappel")
                            account:callScriptFunction("PopoRappel")
                            account.map:changeMap("zaap(" .. acc.map:currentMapId() .. ")")
                        end
                    end
                    if (ligne:find("Impossible de trouver une cellule pour") or ligne:find("Je ne sais pas quelle direction prendre pour rejoindre le chef")) and not account:isBanned() and account:isAccountFullyConnected() then
                        global:printSuccess("Debug de " .. account:getAlias() .. "(bug bot perdu)")
                        account.global:clearConsole()
                        if not IsTeamAtTheSameMap(acc) then
                            RappelTeam = true                        
                        end
                    end
                end
            end
            if account:isBanned() then
                RappelTeam = false
                break
            end
        end
        if RappelTeam then
            global:printSuccess("On rassemble la Team de " .. acc:getAlias())
            local Team = acc:getTeamAccounts()
            table.insert(Team, 1, acc)
            for i = 1, #Team do
                Team[i]:disconnect()
                Team[i]:connect()
            end
            for i = 1, #Team do
                local x = 0
                while not Team[i]:isAccountFullyConnected() do
                    if Team[i]:isBanned() then
                        return move()
                    end
                    global:delay(2000)
                    x = x + 1
                end
                if x >= 120 then
                    x = 0
                    Team[i]:disconnect()
                    Team[i]:connect()
                end
            end
            global:printSuccess("On fait prendre la popo rappel")

            PopoRappelTeam(acc)
            -- on regarde s'ils sont bien arrivés au même zaap
            for _, account in ipairs(Team) do
                if account.map:currentMapId() ~= acc.map:currentMapId() then
                    if not rappelChef then
                        rappelChef = true
                        acc:callScriptFunction("PopoRappel")
                    end
                    account.map:changeMap("zaap(" .. acc.map:currentMapId() .. ")")
                end
            end
        end
    end
end

local function ManageBans2(acc)
    if acc:isBanned() and not acc:getAlias():find("BAN") then
        global:printSuccess(acc:getAlias())
        DeleteInAlias(acc, "BAN")
        global:printSuccess("1")
        global:printSuccess(acc:getAlias())
        global:printSuccess("2")

        DeleteInAlias(acc, "Need")
        global:delay(200)
        global:printSuccess("3")
        global:printSuccess(acc:getAlias())

        acc.global:editAlias(acc:getAlias() .. GetTypeBan(acc), true)
        global:delay(200)
    end
end

local function ManageBans(acc)
    local toReturn = 0

    if acc:isBanned() and not acc:isItATeam() then
        global:printSuccess(acc:getAlias() .. " est ban, on le décharge")
        DeleteInAlias(acc, "BAN")
        DeleteInAlias(acc, "Need")
        global:delay(200)
        acc.global:editAlias(acc:getAlias() .. GetTypeBan(acc), true)
        global:delay(200)
        acc:unloadAccount()
        global:delay(500)
        toReturn = toReturn + 1
    elseif acc:isBanned() and acc:isItATeam() and acc:isTeamLeader() then
        local Team = acc:getTeamAccounts()
        table.insert(Team, 1, acc)
        global:delay(20000)
        for _, account in ipairs(Team) do
            if account:isBanned() then
                global:printSuccess(account:getAlias() .. " est ban, on le décharge")
                DeleteInAlias(account, "BAN")
                DeleteInAlias(account, "Need")
                global:delay(200)
                account.global:editAlias(account:getAlias() .. GetTypeBan(account), true)
                global:delay(200)
                toReturn = toReturn + 1
            else
                account.global:editAlias(account:getAlias() .. " Need" .. #Team, true)
            end
        end
    elseif not acc:isBanned() and acc:isItATeam() and acc:isTeamLeader() then
        local Team = acc:getTeamAccounts()
        for _, account in ipairs(Team) do
            if account:isBanned() then
                global:printSuccess(account:getAlias() .. " est ban, on le décharge")
                DeleteInAlias(account, "BAN")
                DeleteInAlias(account, "Need")
                global:delay(200)
                account.global:editAlias(account:getAlias() .. GetTypeBan(account), true)
                global:delay(200)
                toReturn = toReturn + 1
            end
        end
    end
    if toReturn > 0 then
        local Team = acc:getTeamAccounts()
        for _, account in ipairs(Team) do
            if not account:isBanned() then
                DeleteInAlias(account, "Need")
                account.global:editAlias(account:getAlias() .. " Need" .. #Team + 1 , true)
            end
        end
        acc:unloadAccount()
        global:delay(500)
    end
    return toReturn
end

local function GetTotalHeureByMinute(ligne)
    tabligne = ligne:split(":")
    
    local stringHeures = tabligne[1]:split()
    local stringMinutes = tabligne[2]:split()
    local stringSecondes = tabligne[3]:split()

    local heures = tonumber(stringHeures[#stringHeures - 1] .. "" .. stringHeures[#stringHeures])
    local minutes = tonumber(stringMinutes[1] .. "" .. stringMinutes[2])
    local secondes = tonumber(stringSecondes[1] .. "" .. stringSecondes[2])

    local toReturn = (heures * 60) + minutes + (secondes / 60)
    return toReturn
end

local function FindInAllAccount(AliasToFind)
    local AllAlias = ankabotController:getAliasAllRegistredAccounts()
    local AllUsernames = ankabotController:getUsernameAllRegistredAccounts()
    local Accs = {}

    for i, Alias in ipairs(AllAlias) do
        if Alias:find(AliasToFind) then
            table.insert(Accs, {Username = AllUsernames[i], Alias = Alias})
        end
    end
    return Accs
end

local function FindInUnloadedAccounts(AliasToFind)
    local AllAlias = ankabotController:getAliasNotLoadedAccounts()
    local AllUsernames = ankabotController:getUsernameNotLoadedAccounts()
    local Accs = {}

    for i, Alias in ipairs(AllAlias) do
        if Alias:find(AliasToFind) then
            table.insert(Accs, {Username = AllUsernames[i], Alias = Alias})
        end
    end
    return Accs
end

local function FindInLoadedAccount(AliasToFind)
    local AllAlias = ankabotController:getAliasLoadedAccounts()
    local AllUsernames = ankabotController:getUsernameLoadedAccounts()
    local Accs = {}

    for i, Alias in ipairs(AllAlias) do
        if Alias:find(AliasToFind) then
            table.insert(Accs, {Username = AllUsernames[i], Alias = Alias})
        end
    end
    return Accs
end

local function ProcessReplaceBan(accToReplace)
    local AllAlias = ankabotController:getAliasAllRegistredAccounts()
    local AllUsernames = ankabotController:getUsernameAllRegistredAccounts()

    global:printSuccess("Remplacement de " .. accToReplace.Alias .. " : " .. accToReplace.Username)
    for i, Alias in ipairs(AllAlias) do
        if Alias:find("Next " .. serverController) and not accToReplace.Alias:find("Next") then
            global:printSuccess("Remplacement de " .. accToReplace.Alias)
            global:printSuccess("ouiddd")

            local TeamNumber = GetTeamNumberAndServer(accToReplace.Alias).TeamNumber
            local Server = GetTeamNumberAndServer(accToReplace.Alias).Server
            local toUnload = FindInAllAccount("Team " .. TeamNumber .. " " .. Server)

            if toUnload then
                for _, acc in ipairs(toUnload) do
                    if ankabotController:accountIsLoaded(acc.Username) then
                        ankabotController:unloadAccountByUsername(acc.Username)
                    end
                end
            end
            global:printSuccess("ouiddd")

            local proxy = GetProxy(TeamNumber * 4 - 2)
            global:printSuccess(AllUsernames[i] .. " : " .. Alias)

            ankabotController:assignProxyToAnAccount(AllUsernames[i], proxy.proxy, tonumber(proxy.port), proxy.username, proxy.password, true, true)
            global:printSuccess("ouiddd4")

            local newAccount = ankabotController:loadAccount(AllUsernames[i], true)
            global:delay(500)
            global:printSuccess("ouiddd5")

            newAccount.global:editAlias("Team " .. TeamNumber .. " " .. Server, true)
            global:delay(500)
            
            ankabotController:deleteAccount(accToReplace.Username)
            while not newAccount:isAccountFullyConnected() and not newAccount:isBanned() do
                global:delay(1000)
            end

            global:printSuccess("Le bot est connecté, on le décharge")

            local toUnload = FindInAllAccount("Team " .. TeamNumber .. " " .. Server)

            if toUnload then
                AccountLaunched = false
                for _, acc in ipairs(toUnload) do
                    global:printSuccess(acc.Alias)
                    global:printSuccess(ankabotController:accountIsLoaded(acc.Username))
                    if ankabotController:accountIsLoaded(acc.Username) then
                        ankabotController:unloadAccountByUsername(acc.Username)
                    end
                end
            end
            break
        elseif Alias:find("*") and accToReplace.Alias:find("Next") then
            global:printSuccess("aa")
            global:printSuccess("Remplacement de " .. accToReplace.Alias)

            local waintingAccountsLoaded = FindInLoadedAccount("Next " .. serverController)
            local proxy = GetProxy(10)
            for i, acc in ipairs(waintingAccountsLoaded) do
                if acc.Username == accToReplace.Username and i > 2 then
                    proxy = GetProxy(11)
                end
            end
            global:printSuccess("aa")

            ankabotController:createCharacter(AllUsernames[i], serverController, 7, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})

            ankabotController:assignProxyToAnAccount(AllUsernames[i], proxy.proxy, tonumber(proxy.port), proxy.username, proxy.password, true, true)
            global:printSuccess("On load " .. AllUsernames[i])
            local newAccount = ankabotController:loadAccount(AllUsernames[i], true)
            global:printSuccess("aa")
            global:delay(500)
            
            newAccount.global:editAlias("Next " .. serverController, true)
            global:delay(500)
            
            ankabotController:deleteAccount(accToReplace.Username)
            while not newAccount:isAccountFullyConnected() and not newAccount:isBanned() do
                global:delay(1000)
            end
        end
    end
end

 
local function ReplaceBans()
    AccsToReplace = {}
    local AllAlias = ankabotController:getAliasAllRegistredAccounts()
    local AllUsernames = ankabotController:getUsernameAllRegistredAccounts()
    for i, Alias in ipairs(AllAlias) do
        local acc = ankabotController:getAccount(AllUsernames[i])
        if (Alias:find("BAN") or (acc and acc:isBanned())) and not Alias:find("Need") and not Alias:find("CanGiveToBotBank") and not Alias:find("bank") then
            global:printSuccess(Alias)
            table.insert(AccsToReplace, {Username = AllUsernames[i], Alias = Alias})
        end
    end
    if AccsToReplace ~= nil and #AccsToReplace > 0 then
        global:printSuccess("il y a " .. #AccsToReplace .. " comptes à remplacer")
    end

    local NbAccountsAvailable = FindInAllAccount("Next " .. serverController)
    if #NbAccountsAvailable >= #AccsToReplace or #NbAccountsAvailable >= 4 then
        for _, accToReplace in ipairs(AccsToReplace) do
            ProcessReplaceBan(accToReplace)
            global:delay(500)
       end
    end
end


local function LaunchAllAccounts2()
    local aliasAccounts = ankabotController:getAliasAllRegistredAccounts()
    local usernameAccounts = ankabotController:getUsernameAllRegistredAccounts()

    local dicoTeam = {}
    local cptWaitingAccounts = 0

    for i, Alias in ipairs(aliasAccounts) do
        if Alias:find("bank") then
            local proxy = GetProxy(1)
            ankabotController:assignProxyToAnAccount(usernameAccounts[i], proxy.proxy, tonumber(proxy.port), proxy.username, proxy.password, true, true)
            ankabotController:loadAccount(usernameAccounts[i], false)
        end
        if Alias:find("Team") then
            local infoTeam = GetTeamNumberAndServer(Alias)
            -- each bot has its own proxy
            dicoTeam[tostring(infoTeam.Server) .. " " .. tostring(infoTeam.TeamNumber)] = not dicoTeam[tostring(infoTeam.Server) .. " " .. tostring(infoTeam.TeamNumber)] and 1 or dicoTeam[tostring(infoTeam.Server) .. " " .. tostring(infoTeam.TeamNumber)] + 1
            local proxy = GetProxy(infoTeam.TeamNumber * 4 + (dicoTeam[tostring(infoTeam.Server) .. " " .. tostring(infoTeam.TeamNumber)] - 3))
            ankabotController:assignProxyToAnAccount(usernameAccounts[i], proxy.proxy, tonumber(proxy.port), proxy.username, proxy.password, true, true)
        end
        if Alias:find("Next " .. serverController) and not Alias:find("Done") then

            local proxy = GetProxy(cptWaitingAccounts < 2 and 10 or 11)
            ankabotController:assignProxyToAnAccount(usernameAccounts[i], proxy.proxy, tonumber(proxy.port), proxy.username, proxy.password, true, true)
            ankabotController:loadAccount(usernameAccounts[i], true)
            cptWaitingAccounts = cptWaitingAccounts + 1
        end
        if Alias ~= "*" and not Alias:find("BAN") and not Alias:find("Need") and not Alias:find("bank") and not Alias:find("Done") and not ankabotController:accountIsLoaded(usernameAccounts[i]) then
            ankabotController:loadAccount(usernameAccounts[i], true)
        end
    end
end

local function CanLaunchAnotherTeam(Server)
    local chasseurs = {
        Alone = {},
        Group2 = {},
        Group4 = {},
    }
    for i = 1, 5 do
        local Team = FindInAllAccount("Team " .. i .. " " .. Server)
        for _, acc in ipairs(Team) do
            if acc.Alias:find("Chasseur lvl") then
                local lvl_chasseur = tonumber(acc.Alias:split(" ")[6])
                if lvl_chasseur < 30 then
                    table.insert(chasseurs.Alone, acc)
                elseif lvl_chasseur < 40 then
                    table.insert(chasseurs.Group2, acc)
                elseif lvl_chasseur >= 40 then
                    table.insert(chasseurs.Group4, acc)
                elseif not acc.Alias:find("Need") then
                    table.insert(chasseurs.Alone, acc)
                end
            elseif not acc.Alias:find("Combat") then
                table.insert(chasseurs.Alone, acc)
            end
        end
    end
    return #chasseurs.Alone == 0
end

local function LaunchNewAccounts2()
    local servers = {serverController}
    for i = 1, 2 do
        for _, server in ipairs(servers) do
            local nbNeeded = 4 - #FindInAllAccount("Team " .. i .. " " .. server)
            if nbNeeded > 0 and (#FindInUnloadedAccounts("Next " .. serverController .. " Done") + #FindInUnloadedAccounts("*")) >= nbNeeded--[[and CanLaunchAnotherTeam(server) ]]then
                global:printSuccess("On peut créer une nouvelle team " .. i .. " sur le server " .. server)
                for j = 1, nbNeeded do
                    NewAccs = FindInUnloadedAccounts("Next " .. serverController .. " Done")
                    if NewAccs ~= nil and #NewAccs > (nbNeeded - j) then

                        -- ankabotController:createCharacter(NewAccs[1].Username, server, 7, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
                        local proxy = GetProxy(i * 4 + (j - nbNeeded))
                        ankabotController:assignProxyToAnAccount(NewAccs[1].Username, proxy.proxy, tonumber(proxy.port), proxy.username, proxy.password, true, true)

                        local newAccount = ankabotController:loadAccount(NewAccs[1].Username, true)
                        global:delay(500)
                        newAccount.global:editAlias("Team " .. i .. " " .. server, true)      
                        global:printSuccess("Compte lancé!")                    
                    end
                end

                local nbNeeded = 4 - #FindInAllAccount("Team " .. i .. " " .. server)
                if nbNeeded > 0 and #FindInUnloadedAccounts("*") >= nbNeeded then
                    global:printSuccess("On peut créer une nouvelle team " .. i .. " sur le server " .. server)
                    for j = 1, nbNeeded do
                        NewAccs = FindInUnloadedAccounts("*")
                        if NewAccs ~= nil and #NewAccs > (nbNeeded - j) then
    
                            ankabotController:createCharacter(NewAccs[1].Username, server, 7, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
                            local proxy = GetProxy(i * 4 + (j - nbNeeded))
                            ankabotController:assignProxyToAnAccount(NewAccs[1].Username, proxy.proxy, tonumber(proxy.port), proxy.username, proxy.password, true, true)
    
                            local newAccount = ankabotController:loadAccount(NewAccs[1].Username, true)
                            global:delay(500)
                            newAccount.global:editAlias("Team " .. i .. " " .. server, true)      
                            global:printSuccess("Compte lancé!")                    
                        end
                    end
                end
            end
        end
    end
end


local function ManageWaitingAccounts()
    local neededWaitingAccounts = 30 - #FindInAllAccount("Next " .. serverController)
    local waitingAccountLoaded = FindInLoadedAccount("Next " .. serverController)
    global:printSuccess(#waitingAccountLoaded)

    if neededWaitingAccounts > 0 and #waitingAccountLoaded < 4 then
        local newAccs = FindInAllAccount("*")
        for _, acc in ipairs(newAccs) do
            if #waitingAccountLoaded < 4 then
                ankabotController:createCharacter(acc.Username, serverController, 7, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
                local proxy = GetProxy(#waitingAccountLoaded < 2 and 10 or 11)
                ankabotController:assignProxyToAnAccount(acc.Username, proxy.proxy, tonumber(proxy.port), proxy.username, proxy.password, true, true)
    
                local newAccount = ankabotController:loadAccount(acc.Username, true)
                global:delay(500)
                newAccount.global:editAlias("Next " .. serverController, true)      
                global:printSuccess("Compte waiting lancé!")   
                waitingAccountLoaded = FindInLoadedAccount("Next " .. serverController)
            end
        end
    end

    for _, account in ipairs(waitingAccountLoaded) do
        local acc = ankabotController:getAccount(account.Username)
        if acc:getAlias():find("Done") then
            -- si il est pas connecté, on le retire des comtpes chargés
            acc:unloadAccount()
        end
    end
end

local function ExporterComptes()
    AccountToLoad = { bank = {}, Team = {}, Waiting = {}, Reste = {}}

    for i, Alias in ipairs(ankabotController:getAliasAllRegistredAccounts()) do
        if Alias:find("bank") then
            for j, Username in ipairs(ankabotController:getUsernameAllRegistredAccounts()) do
                if i == j  then
                    table.insert(AccountToLoad.bank, Username)
                end
            end
        elseif Alias:find("Team") then
            for j, Username in ipairs(ankabotController:getUsernameAllRegistredAccounts()) do
                if i == j then
                    table.insert(AccountToLoad.Team, Username)
                end
            end
        elseif Alias:find("Next") then
            for j, Username in ipairs(ankabotController:getUsernameAllRegistredAccounts()) do
                if i == j then
                    table.insert(AccountToLoad.Waiting, Username)
                end
            end
        elseif not Alias:find("-") then
            for j, Username in ipairs(ankabotController:getUsernameAllRegistredAccounts()) do
                if i == j then
                    table.insert(AccountToLoad.Reste, Username)
                end
            end
        end
    end

    global:delay(5000)

    local content = ""
    for _, Username in ipairs(AccountToLoad.bank) do
        content = content .. "\n" .. Username .. ":" .. ankabotController:getPassword(Username) .. ":" .. ankabotController:getAlias(Username)
    end

    for _, Username in ipairs(AccountToLoad.Team) do
        content = content .. "\n" .. Username .. ":" .. ankabotController:getPassword(Username) .. ":" .. ankabotController:getAlias(Username)
    end  

    for _, Username in ipairs(AccountToLoad.Waiting) do
        content = content .. "\n" .. Username .. ":" .. ankabotController:getPassword(Username) .. ":" .. ankabotController:getAlias(Username)
    end  

    for _, Username in ipairs(AccountToLoad.Reste) do
        content = content .. "\n" .. Username .. ":" .. ankabotController:getPassword(Username) .. ":" .. ankabotController:getAlias(Username)
    end   


    f = io.open("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Comptes" .. serverController .. ".txt", "w")

    f:write(content)
    f:close()

end

function move()
    global:printSuccess("Check des bots...")

    if cptExportation == 20 then
        cptExportation = 0
        ExporterComptes()
    end
    cptExportation = cptExportation + 1
    ReplaceBans()

    if not AccountLaunched then
        AccountLaunched = true
        LaunchAllAccounts2()
    end
    global:printSuccess("ok")
    LaunchNewAccounts2()
    global:printSuccess("ok1")

    ManageWaitingAccounts()
    global:printSuccess("ok2")

    local LoadedAccount = ankabotController:getLoadedAccounts()

    for _, acc in ipairs(LoadedAccount) do
        global:printSuccess("Check du " .. _ .. "ème compte")

        -- ManageBans(acc)
        ManageBans2(acc)
        
        ManageTeams(acc)

        DebugDeathTeam(acc)

        DebugLostTeam(acc)

        if ConsoleRead(acc, "Action annulée pour cause de surcharge") then
            global:printSuccess("Debug de " .. acc:getAlias() .. "(surchage)")
            acc.global:clearConsole()
            acc:reloadScript()
            acc:startScript()
            global:delay(200)
        end

        if not acc:hasScript() and acc.character:level() < 10 and acc:isAccountFullyConnected() and not acc:isItATeam() then
            acc:loadConfig("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PLAndZaaps\\[Touch] Astrub\\main.xml") -- mettre la config pour la quete
            acc:loadScript("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PLAndZaaps\\[Touch] Astrub\\main.lua") -- mettre le script quete
            acc:disconnect()
            acc:connect()
        end
        if not acc:hasScript() and not acc:isItATeam() and acc:isAccountFullyConnected() and acc:getAlias():find("Chasseur") then
            acc:loadScript("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PLAndZaaps\\PL_Chasseur_Team.lua")
            acc:startScript()
        end
        if condition(acc) then
            acc:reloadScript()
            acc:startScript()
            global:delay(200)
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
                global:delay(200)
            end
        end

        if acc:getAlias():find("bank") then
            local lines = acc.global:consoleLines()
            local cnt = 0
            for _, ligne in ipairs(lines) do
                if ligne:find("Trajet : Bot_Bank lancé !") then
                    cnt = cnt + 1
                end
            end
            if cnt > 10 then
                acc.global:clearConsole()
                acc:disconnect()
            end
        end

        -- local lines = acc.global:consoleLines()

        -- if lines ~= nil and #lines == 202 and not acc:isController() then
        --     for i, ligne in ipairs(lines) do
        --         if ligne:find("Lancement du combat ") then
        --             global:printSuccess("ok")
        --             local heure = GetTotalHeureByMinute(ligne)
        --             global:printSuccess("ok2")
        --             for j = i, #lines do
        --                 if lines[j]:find("Fin du combat ") then
        --                     break
        --                 else
        --                     global:printSuccess("ok3")
        --                     if lines[j] then
        --                         local heureNextLine = GetTotalHeureByMinute(lines[j])

        --                         if (heureNextLine - heure) > 15 then
        
        --                             acc.global:clearConsole()
        --                             acc.global:printSuccess("Reonnection demandée par le controller")
        --                             acc.global:reconnect(0)
        
        --                             break
        --                         end
        --                     end
        --                     global:printSuccess("ok4")
        
        --                 end
        --             end
        --         end
        --     end
        -- end
    end


    local waitingTime = math.random(25, 40)
    global:printSuccess("Checkup terminé, attente de " .. waitingTime .. " secondes.")

    global:delay(waitingTime * 1000)
    return move()
end