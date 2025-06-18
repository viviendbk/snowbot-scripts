dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\All_Fonctions.lua")

local condition = function(acc)
    return acc:isAccountFullyConnected() and not acc:isScriptPlaying() and not acc:isItATeam() and not acc:getAlias():find("bank")
end

local PathPhenix = {
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

    for line in io.lines("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\proxy.txt") do
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
        if AliasSplit[i]:find(toDelete) then
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
                if account:isAccountFullyConnected() and account.character:energyPoints() == 0 then
                    global:printSuccess("Appel de la fonction phenix pour le bot " .. account:getAlias())
                    NbDeath = NbDeath + 1
                    for _, element in ipairs(PathPhenix) do
                        if account.map:onMap(element.map) then
                            if element.path then
                                account.map:changeMap(element.path)
                            else
                                element.custom(account)
                            end
                            if account.map:onMap(element.map) then
                                global:printSuccess("bug, on déco reco le compte")
                                account.global:reconnect(0)
                                while not account:isAccountFullyConnected() do
                                    global:delay(1000)
                                end
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
    if acc:isTeamLeader() and acc.character:energyPoints() > 0 then
        local Team = acc:getTeamAccounts()
        table.insert(Team, 1, acc)
        for _, account in ipairs(Team) do
            account:callScriptFunction("PopoRappel")
        end
    end
end

local function IsTeamAtTheSameMap(acc)
    if acc:isTeamLeader() and acc.character:energyPoints() > 0 then
        local Team = acc:getTeamAccounts()
        for _, account in ipairs(Team) do
            if account.map:currentMapId() ~= acc.map:currentMapId() then
                return false
            end
        end
        return true
    end
end

local function DebugLostTeam(acc)
    if acc:isTeamLeader() and acc.character:energyPoints() > 0 then
        local RappelTeam = false
        local Team = acc:getTeamAccounts()
        for _, account in ipairs(Team) do
            local lines = account.global:consoleLines()
            if lines ~= nil then
                for i, ligne in ipairs(lines) do
                    if (ligne:find("Impossible de trouver une cellule pour") or ligne:find("Je ne sais pas quelle direction prendre pour rejoindre le chef")) and not IsTeamAtTheSameMap(acc) then
                        account.global:clearConsole()
                        RappelTeam = true
                    end
                end
            end
        end
        if RappelTeam then
            global:printSuccess("On rassemble la Team de " .. acc:getAlias())
            PopoRappelTeam(acc)
            -- on regarde s'ils sont bien arrivés au même zaap
            for _, account in ipairs(Team) do
                if account.map:currentMapId() ~= acc.map:currentMapId() then
                    account.map:changeMap("zaap(" .. acc.map:currentMapId() .. ")")
                end
            end
        end
    end
end

local function ManageBans(acc)
    local toReturn = 0

    if acc:isBanned() and not acc:isItATeam() then
        global:printSuccess(acc:getAlias() .. " est ban, on le décharge")
        DeleteInAlias(acc, "[BAN]")
        DeleteInAlias(acc, "Need")
        global:delay(200)
        acc.global:editAlias(acc:getAlias() .. "[BAN]", true)
        global:delay(200)
        acc:unloadAccount()
        toReturn = toReturn + 1
    elseif acc:isBanned() and acc:isItATeam() and acc:isTeamLeader() then
        local Team = acc:getTeamAccounts()
        table.insert(Team, 1, acc)
        global:delay(20000)
        for _, account in ipairs(Team) do
            if account:isBanned() then
                global:printSuccess(account:getAlias() .. " est ban, on le décharge")
                DeleteInAlias(account, "[BAN]")
                DeleteInAlias(account, "Need")
                global:delay(200)
                account.global:editAlias(account:getAlias() .. "[BAN]", true)
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
                DeleteInAlias(account, "[BAN]")
                DeleteInAlias(account, "Need")
                global:delay(200)
                account.global:editAlias(account:getAlias() .. "[BAN]", true)
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
    end
    return toReturn
end

local function ProcessReplaceBan(accToReplace)
    local AllAlias = ankabotController:getAliasAllRegistredAccounts()
    local AllUsernames = ankabotController:getUsernameAllRegistredAccounts()

    for i, Alias in ipairs(AllAlias) do
        if Alias:find("*") then
            for j, Username in ipairs(AllUsernames) do
                if i == j then

                    global:printSuccess("Remplacement de " .. accToReplace.Alias)

                    local TeamNumber = GetTeamNumberAndServer(accToReplace.Alias).TeamNumber
                    global:printSuccess("ok1")
                    local Server = GetTeamNumberAndServer(accToReplace.Alias).Server
                    global:printSuccess("ok2")

                    ankabotController:createCharacter(Username, Server, 7, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
                    global:printSuccess("ok3")
                    ankabotController:assignProxyToAnAccount(Username, GetProxy(TeamNumber).proxy, tonumber(GetProxy(TeamNumber).port), GetProxy(TeamNumber).username, GetProxy(TeamNumber).password)
                    global:printSuccess("ok4")

                    local newAccount = ankabotController:loadAccount(Username, true)
                    global:delay(500)
                    
                    newAccount.global:editAlias("Team " .. TeamNumber .. " " .. Server, true)
                    global:delay(500)
                    
                    ankabotController:deleteAccount(accToReplace.Username)
                end
            end
            break
        end
    end
end

local function ReplaceBans()
    AccsToReplace = {}
    local AllAlias = ankabotController:getAliasAllRegistredAccounts()
    local AllUsernames = ankabotController:getUsernameAllRegistredAccounts()
    for i, Alias in ipairs(AllAlias) do
        if Alias:find("[BAN]") and not Alias:find("Need") and not Alias:find("CanGiveToBotBank") then
            global:printSuccess(Alias)
            for j, Username in ipairs(AllUsernames) do
                if i == j then
                    table.insert(AccsToReplace, {Username = Username, Alias = Alias})
                end
            end
        end
    end
    if AccsToReplace ~= nil and #AccsToReplace > 0 then
        global:printSuccess("il y a " .. #AccsToReplace .. " comptes à remplacer")
    end

    for _, accToReplace in ipairs(AccsToReplace) do
         ProcessReplaceBan(accToReplace)
         global:delay(500)
    end
end

local function FindInAllAccount(AliasToFind)
    local AllAlias = ankabotController:getAliasAllRegistredAccounts()
    local AllUsernames = ankabotController:getUsernameAllRegistredAccounts()
    local Accs = {}

    for i, Alias in ipairs(AllAlias) do
        if Alias:find(AliasToFind) then
            for j, Username in ipairs(AllUsernames) do
                if i == j then
                    table.insert(Accs, {Username = Username, Alias = Alias})
                end
            end
        end
    end
    return Accs
end

local function LaunchAllAccounts()
    local servers = {"Herdegrize", "Oshimo", "Terra_Cogita"}

    for i = 1, 5 do
        for _, server in ipairs(servers) do
            local chasseurs = {
                Alone = {},
                Group2 = {},
                Group4 = {},
            }
            local Combat = {
                BL = {},
                HL = {}
            }
            local Team = FindInAllAccount("Team " .. i .. " " .. server)


            if Team then
                for _, acc in ipairs(Team) do
                    ankabotController:assignProxyToAnAccount(acc.Username, GetProxy(i).proxy, tonumber(GetProxy(i).port), GetProxy(i).username, GetProxy(i).password)
                    -- global:printSuccess(acc.Alias:find("Bot"))

                    -- if acc.Alias:find("CanGiveToBotBank") and not acc:accountIsLoaded() then
                    --     DeleteInAlias("CanGiveToBotBank")
                    -- end
                    if acc.Alias:find("CombatBL") and not acc.Alias:find("Need") and not acc.Alias:find("[BAN]") then
                        table.insert(Combat.BL, acc)
                    elseif acc.Alias:find("CombatBL") and not acc.Alias:find("Need") and not acc.Alias:find("[BAN]") then
                        table.insert(Combat.HL, acc)
                    elseif acc.Alias:find("Chasseur lvl") and not acc.Alias:find("Need") and not acc.Alias:find("[BAN]") then
                        local lvl_chasseur = tonumber(acc.Alias:split(" ")[6])
                        if lvl_chasseur < 30 then
                            table.insert(chasseurs.Alone, acc)
                        elseif lvl_chasseur < 40 then
                            table.insert(chasseurs.Group2, acc)
                        elseif lvl_chasseur >= 40 then
                            table.insert(chasseurs.Group4, acc)
                        end
                    elseif (not acc.Alias:find("Need") or acc.Alias:find("Need1")) and not acc.Alias:find("[BAN]") then
                        table.insert(chasseurs.Alone, acc)
                    end
                end

                if #Combat.BL == 4 then
                    ankabotController:loadTeamAccount({Combat.BL[1].Username, Combat.BL[2].Username, Combat.BL[3].Username, Combat.BL[4].Username}, Combat.BL[1].Username, true)
                elseif #Combat.BL == 1 or #Combat.BL == 2 or #Combat.BL == 3 then
                    for _, acc in ipairs(Combat.BL) do
                        if not ankabotController:accountIsLoaded(acc.Username) then
                            local acc = ankabotController:loadAccount(acc.Username, false)
                            global:delay(200)
                            DeleteInAlias(acc, "Need")
                            acc.global:editAlias(acc:getAlias() .. " Need4", true)
                            global:delay(100)
                            acc:unloadAccount()
                        end
                    end
                end
                if #Combat.HL == 4 then
                    ankabotController:loadTeamAccount({Combat.HL[1].Username, Combat.HL[2].Username, Combat.HL[3].Username, Combat.HL[4].Username}, Combat.HL[1].Username, true)
                elseif #Combat.HL == 1 or #Combat.HL == 2 or #Combat.HL == 3 then
                    for _, acc in ipairs(Combat.HL) do
                        if not ankabotController:accountIsLoaded(acc.Username) then
                            local acc = ankabotController:loadAccount(acc.Username, false)
                            global:delay(200)
                            DeleteInAlias(acc, "Need")
                            acc.global:editAlias(acc:getAlias() .. " Need4", true)
                            global:delay(100)
                            acc:unloadAccount()
                        end
                    end
                end
                if #chasseurs.Alone > 0 then
                    for _, acc in ipairs(chasseurs.Alone) do
                        ankabotController:loadAccount(acc.Username, true)
                        global:delay(100)
                    end
                end
                if #chasseurs.Group2 == 2 then

                    ankabotController:loadTeamAccount({chasseurs.Group2[1].Username, chasseurs.Group2[2].Username}, chasseurs.Group2[1].Username, true)
                    global:delay(100)
                elseif #chasseurs.Group2 == 4 then
                    ankabotController:loadTeamAccount({chasseurs.Group2[1].Username, chasseurs.Group2[2].Username}, chasseurs.Group2[1].Username, true)
                    global:delay(100)
                    ankabotController:loadTeamAccount({chasseurs.Group2[3].Username, chasseurs.Group2[4].Username}, chasseurs.Group2[3].Username, true)
                    global:delay(100)
                elseif #chasseurs.Group2 == 3 or #chasseurs.Group2 == 1 then
                    for _, acc in ipairs(chasseurs.Group2) do
                        if not ankabotController:accountIsLoaded(acc.Username) then
                            local acc = ankabotController:loadAccount(acc.Username, false)
                            global:delay(200)
                            DeleteInAlias(acc, "Need")
                            acc.global:editAlias(acc:getAlias() .. "Need2", true)
                            global:delay(100)
                            acc:unloadAccount()
                        end
                    end
                end
                if #chasseurs.Group4 == 4 then
                    ankabotController:loadTeamAccount({chasseurs.Group4[1].Username, chasseurs.Group4[2].Username, chasseurs.Group4[3].Username, chasseurs.Group4[4].Username}, chasseurs.Group4[1].Username, true)
                    global:delay(100)
                elseif #chasseurs.Group4 == 3 or #chasseurs.Group4 == 2 or #chasseurs.Group4 == 1 then
                    for _, acc in ipairs(chasseurs.Group4) do
                        if not ankabotController:accountIsLoaded(acc.Username) then
                            local acc = ankabotController:loadAccount(acc.Username, false)
                            global:delay(200)
                            DeleteInAlias(acc, "Need")
                            acc.global:editAlias(acc:getAlias() .. "Need4", true)
                            global:delay(100)
                            acc:unloadAccount()
                        end
                    end
                end
            end
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

local function LaunchNewAccounts()
    local servers = {"Herdegrize", "Oshimo", "Terra_Cogita"}
    for i = 1, 5 do
        for _, server in ipairs(servers) do

            local Team = FindInAllAccount("Team " .. i .. " " .. server)
            if #Team < 4 and #Team > 0 then -- completer les teams 
                local AccountLacking = 4 - #Team
                global:printSuccess("On peut lancer " .. AccountLacking .. " x Compte Team " .. i .. " " .. server)

                for j = 1, AccountLacking do
                    NewAccs = FindInAllAccount("*")
                    if NewAccs ~= nil and #NewAccs > 0 then
                        global:printSuccess("ok1")

                        ankabotController:createCharacter(NewAccs[1].Username, server, 7, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
                        global:printSuccess("ok2")

                        ankabotController:assignProxyToAnAccount(NewAccs[1].Username, GetProxy(i).proxy, tonumber(GetProxy(i).port), GetProxy(i).username, GetProxy(i).password)
                        global:printSuccess("ok3")

                        local newAccount = ankabotController:loadAccount(NewAccs[1].Username, true)
                        global:delay(500)
                        newAccount.global:editAlias("Team " .. i .. " " .. server, true)    
                        global:printSuccess("Compte lancé!")               
                    end
                end
            end
        end
    end
    for i = 1, 5 do
        for _, server in ipairs(servers) do
            local Team = FindInAllAccount("Team " .. i .. " " .. server)
            if #Team == 0 and CanLaunchAnotherTeam(server) then
                global:printSuccess("On peut créer une nouvelle team " .. i .. " sur le server " .. server)
                for j = 1, 4 do
                    NewAccs = FindInAllAccount("*")
                    if NewAccs ~= nil and #NewAccs > (4 - j) then
                        global:printSuccess("ok1")
                        ankabotController:createCharacter(NewAccs[1].Username, server, 7, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
                        global:printSuccess("ok2")
                        ankabotController:assignProxyToAnAccount(NewAccs[1].Username, GetProxy(i).proxy, tonumber(GetProxy(i).port), GetProxy(i).username, GetProxy(i).password)
                        global:printSuccess("ok3")

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

function move()
    global:printSuccess("Check des bots...")

    if not AccountLaunched then
        AccountLaunched = true
        LaunchAllAccounts()
    end

    LaunchNewAccounts()

    local LoadedAccount = ankabotController:getLoadedAccounts()

    for _, acc in ipairs(LoadedAccount) do
        global:printSuccess("Check du " .. _ .. "ème compte")

        ManageBans(acc)

        ManageTeams(acc)

        DebugDeathTeam(acc)

        DebugLostTeam(acc)

        if ConsoleRead(acc, "Action annulée pour cause de surcharge") then
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
    end

    ReplaceBans()

    local waitingTime = math.random(25, 40)
    global:printSuccess("Checkup terminé, attente de " .. waitingTime .. " secondes.")
    global:delay(waitingTime * 1000)
    return move()
end