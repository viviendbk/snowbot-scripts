---@diagnostic disable: undefined-global, lowercase-global
--- <init>

PATH =  "C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\setup_hiaky\\"
scriptName = "controller.lua"
dofile(PATH .. "parameters.lua")
dofile(PATH .. "modules//print.lua")

dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Lib\\Craft.lua")
dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Lib\\DD.lua")
dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Lib\\HDV.lua")
dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Lib\\IA.lua")
dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Lib\\Utils.lua")

--- </init> 
local PathPhenix = {
    {map = "-3,-13", path = "right"},
    {map = "-2,-13", path = "right"},
    {map = "-1,-13", path = "right"},
    {map = "0,-13", path = "right"},
    {map = "1,-13", path = "right"},
    {map = "2,-13", path = "top"},

    {map = "2,-14", custom = function(acc) 
        acc.map:door(313)
        acc.map:changeMap("havenbag")
    end},
    {map = "-68,-43", path = "right"},
    {map = "-67,-43", path = "top"},
    {map = "-67,-44", custom = function(acc) 
        acc.map:door(219)
        acc.map:changeMap("havenbag")
    end},

    {map = "23331073", path = "bottom"},
    {map = "23330816", path = "bottom"},
    {map = "159769", path = "left"},
    {map = "-57,25", path = "left"},
    {map = "-58,24", path = "top"},
    {map = "-58,25", path = "top"},
    {map = "-58,23", path = "top"},
    {map = "-58,22", path = "top"},
    {map = "-58,21", path = "top"},
    {map = "-58,20", path = "top"},
    {map = "-58,19", path = "top"},
    {map = "-58,18", custom = function(acc) 
        acc.map:door(354)
        acc.map:changeMap("havenbag")
    end},
    {map = "37,-43", path = "left"},
    {map = "36,-43", path = "left"},
    {map = "35,-43", path = "bottom"},
    {map = "35,-42", path = "bottom"},
    {map = "35,-41", path = "bottom"},
    {map = "35,-40", custom = function(acc) 
        acc.map:door(306)
        acc.map:changeMap("havenbag")
    end},
    {map = "-9,-54", path = "left"},
    {map = "-10,-54", custom = function (acc)
        acc.map:door(342)
        acc.map:changeMap("havenbag")
    end}

}

local totalKamas = 0
local totalCraftKamas = 0
local DebutDeScript = true
local cptExportation = 0

local DebugTeam = {
    {map = "161351684", custom = function() map:useById(503232, -2) end},
    {map = "162791424", custom = function() map:useById(503232, -2) end},
    {map = "161220622", path = "top"},
    {map = "161220620", path = "right"},
    {map = "161221644", path = "top"},
    {map = "161220618", path = "left"},
    {map = "161219594", path = "top"},
    {map = "161219592", path = "left"},
    {map = "161218568", path = "top"},
    {map = "161350662", path = "top"},
    {map = "161350660", path = "left"},

    {map = "161480704", path = "bottom"},
    {map = "161358084", path = "right"},
    {map = "161357060", path = "right"},
    {map = "161356036", path = "top"},
    {map = "161356038", path = "right"},
    {map = "161355012", path = "bottom"},
    {map = "161355010", path = "right"},
    {map = "161353986", path = "right"},
    {map = "161352704", path = "right"},
    {map = "161351680", path = "bottom"},
    {map = "161350658", path = "right"},
    {map = "161218562", path = "right"},
    {map = "161219586", path = "bottom"},
    {map = "161219588", path = "bottom"},
    {map = "161220614", path = "bottom"},

    {map = "160959747", path = "left"},
    {map = "160959745", path = "left"},
    {map = "160958464", path = "left"},
    {map = "160957952", path = "left"},
    {map = "160957440", path = "left"},
    {map = "160956928", path = "top"},
    {map = "160956416", path = "right"},
    {map = "160956417", path = "right"},
    {map = "160956929", path = "top"},
    {map = "160956930", path = "top"},
    {map = "160956931", path = "top"},
    {map = "160957443", path = "top"},
    {map = "160957442", path = "top"},
    {map = "160957441", path = "top"},
    {map = "160957953", path = "top"},
    {map = "160957954", path = "top"},
    {map = "160957955", path = "top"},
    {map = "160958466", path = "top"},
    {map = "160958465", path = "top"},
    {map = "160957953", path = "top"},
    {map = "160957953", path = "top"},
    {map = "160957953", path = "top"},
    {map = "160957953", path = "top"},
    {map = "160957953", path = "top"},
    {map = "161220608", path = "left"},
}


local condition = function(acc)
    return acc:isAccountFullyConnected() and not acc:isScriptPlaying() and not acc:isItATeam()
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

local function getRemainingSubscription(inDay, acc)
    local accDeveloper = acc and acc.developer or developer

    local endDate = developer:historicalMessage("IdentificationSuccessMessage")[1].subscriptionEndDate 
    local now = os.time(os.date("!*t")) * 1000

    endDate = math.floor((endDate - now) / 3600000)

    return inDay and math.floor(endDate / 24) or endDate
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
    if stringalias:find("Craft") then
        return (tonumber(stringKamas) == nil) and 0 or tonumber(stringKamas)
    end
    return (tonumber(stringKamas) == nil or tonumber(stringKamas) <= 5) and 0 or tonumber(stringKamas) - 5
end

local function GetServerByAlias(Alias)
    local Servers = {"Imagiro", "Orukam", "Tal Kasha", "Hell Mina", "Tylezia", "Draconiros", "Dakal", "Kourial", "Mikhal", "Rafal", "Salar", "Brial"}
    for _, Server in ipairs(Servers) do
        if Alias:lower():find(Server:lower()) then
            return Server
        end
    end
    return nil
end

local function GetServer(account)
    local Servers = {"Imagiro", "Orukam", "Tal Kasha", "Hell Mina", "Tylezia", "Draconiros", "Dakal", "Kourial", "Mikhal", "Rafal", "Salar", "Brial"}
    for _, Server in ipairs(Servers) do
        if account:getAlias():lower():find(Server:lower()) then
            return Server
        end
    end
    return nil
end

local function GetProxy(lineToRead)
    local cpt = 0
    local i = 1

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

local typeProxy = "socks5"
local proxyBank = GetProxy(1)

local proxyCombat2 = GetProxy(4)
local proxyLvlUp12 = GetProxy(6)
local proxyCombat = GetProxy(7)

local proxyGroupe2 = GetProxy(2)
local proxyGroupe3 = GetProxy(3)

-- local proxyCraft = GetProxy(9)
local proxyCraft = GetProxy(2)

-- local proxyCraftFM = GetProxy(11)
local proxyCraftFM = GetProxy(3)


local proxyLvlUp34 = GetProxy(10)

local function WhichServer()
    for _, acc in ipairs(snowbotController:getLoadedAccounts()) do
        if findMKamas(acc:getAlias()) > 2 and not acc:getAlias():lower():find("Draconiros") and not acc:getAlias():find("Controller") then
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
    AccountToLoad = { bank = {}, Combat = {}, Combat2 = {}, LvlUp12 = {}, LvlUp34 = {}, Bucheron = {}, Mineur = {}, Craft = {}, Groupe = {}, Reste = {}}
    local all_alias = merge(snowbotController:getAliasNotLoadedAccounts(), snowbotController:getAliasLoadedAccounts())
    local all_usernames = merge(snowbotController:getUsernameLoadedAccounts(), snowbotController:getUsernameNotLoadedAccounts())

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
    for _, Username in ipairs(AccountToLoad.Combat2) do
        content = content .. "\n" .. Username .. ":" .. snowbotController:getPassword(Username) .. ":" .. snowbotController:getAlias(Username)
    end

    if #AccountToLoad.LvlUp12 > 0 or #AccountToLoad.LvlUp34 > 0 then
        content = content .. "\n///:" .. snowbotController:getPassword("///") .. ":---------- LvlUp ----------"-- délimitateur LvlUp
    elseif #AccountToLoad.Bucheron > 0 then
        content = content .. "\n///:" .. snowbotController:getPassword("///") .. ":---------- BUCHERON ----------"-- délimitateur Bucheron
    end

    for _, Username in ipairs(AccountToLoad.Bucheron) do
        content = content .. "\n" .. Username .. ":" .. snowbotController:getPassword(Username) .. ":" .. snowbotController:getAlias(Username)
    end

    for _, Username in ipairs(AccountToLoad.LvlUp12) do
        content = content .. "\n" .. Username .. ":" .. snowbotController:getPassword(Username) .. ":" .. snowbotController:getAlias(Username)
    end
    for _, Username in ipairs(AccountToLoad.LvlUp34) do
        content = content .. "\n" .. Username .. ":" .. snowbotController:getPassword(Username) .. ":" .. snowbotController:getAlias(Username)
    end

    if #AccountToLoad.Mineur > 0 then
        content = content .. "\n////:" .. snowbotController:getPassword("////") .. ":---------- MINEUR ----------" -- délimitateur Mineur
    end

    for _, Username in ipairs(AccountToLoad.Mineur) do
        content = content .. "\n" .. Username .. ":" .. snowbotController:getPassword(Username) .. ":" .. snowbotController:getAlias(Username)
    end  

    if #AccountToLoad.Groupe > 0 then
        content = content .. "\n////:" .. snowbotController:getPassword("////") .. ":---------- GROUPE ----------" -- délimitateur Mineur
    end
    for _, Username in ipairs(AccountToLoad.Groupe) do
        content = content .. "\n" .. Username .. ":" .. snowbotController:getPassword(Username) .. ":" .. snowbotController:getAlias(Username)
    end   

    if #AccountToLoad.Craft > 0 then
        content = content .. "\n////:" .. snowbotController:getPassword("////") .. ":---------- CRAFT ----------" -- délimitateur Mineur
    end
    for _, Username in ipairs(AccountToLoad.Craft) do
        content = content .. "\n" .. Username .. ":" .. snowbotController:getPassword(Username) .. ":" .. snowbotController:getAlias(Username)
    end   

    for _, Username in ipairs(AccountToLoad.Reste) do
        content = content .. "\n" .. Username .. ":" .. snowbotController:getPassword(Username) .. ":" .. snowbotController:getAlias(Username)
    end   


    global:printSuccess(content)

    if #AccountToLoad.Combat > 0 then
        f = io.open("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\ComptesCombat.txt", "w")
    elseif #AccountToLoad.LvlUp12 > 0 or #AccountToLoad.LvlUp34 > 0 then
        f = io.open("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\ComptesLvlUp.txt", "w")
    elseif #AccountToLoad.Groupe > 0 then
        f = io.open("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\ComptesGroupe.txt", "w")
    elseif #AccountToLoad.Craft > 0 then
        f = io.open("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\ComptesCraft.txt", "w")
    end

    f:write(content)
    f:close()

end

local function GetCurrentHourInMinutes()
    local current_time = os.date("*t")  -- Get the current time
    local hours = current_time.hour      -- Get the current hour
    local minutes = current_time.min     -- Get the current minute

    local total_minutes = (hours * 60) + minutes -- Convert hours to minutes and add the current minutes
    return total_minutes
end

local function GetTotalHeureByMinute(ligne)

    tabligne = ligne:split(":")

    if #tabligne < 3 then
        return nil
    end

    local stringHeures = tabligne[1]:split()
    local stringMinutes = tabligne[2]:split()
    local stringSecondes = tabligne[3]:split()
    global:printSuccess(stringHeures[#stringHeures - 1])
    global:printSuccess(stringHeures[#stringHeures])
    global:printSuccess(stringMinutes[1])
    global:printSuccess(stringMinutes[2])
    global:printSuccess(stringSecondes[1])
    global:printSuccess(stringSecondes[2])

    local heures = tonumber(stringHeures[#stringHeures - 1] .. "" .. stringHeures[#stringHeures])
    local minutes = tonumber(stringMinutes[1] .. "" .. stringMinutes[2])
    local secondes = tonumber(stringSecondes[1] .. "" .. stringSecondes[2])
    if heures and minutes and secondes then
        local toReturn = (heures * 60) + minutes + (secondes / 60)
        return toReturn
    end
end

local function ConsoleRead(acc, string)
    local lines = acc.global():consoleLines() or {}
    for _, line in ipairs(lines) do
        if line:find(string) then
            return true
        end
    end
    return false
end

local function PutTeamInHavenbag(acc)
    while acc.map:currentArea() == "Ecaflipus" do
        global:printSuccess("Appel2 de la fonction debug pour le bot " .. acc:getAlias())
        for _, element in ipairs(DebugTeam) do
            if acc.map:onMap(element.map) then
                if element.map == "161351684" or element.map == "162791424" then
                    acc.map:useById(503232, -2)
                end
                if element.path then
                    acc.map:changeMap(element.path)
                end
            end
        end

        local console_lines = acc.global():consoleLines()

        for _, line in ipairs(console_lines) do
            if line:find("Impossible d'aller vers") or line:find("Erreur dans le script : Impossible d'utiliser l'élément interactif") then
                global:printSuccess("bug du bot, on le déco reco")
                acc.global():clearConsole()
                acc:disconnect()
                acc:connect()
                while not acc:isAccountFullyConnected() do
                    global:delay(2000)
                end
                acc:startScript()
                break
            end
            if line:find("Téléportation vers un Havre-Sac impossible depuis cette carte.") then
                global:printSuccess("1Debug bot can't go to havresac")
                acc.global():clearConsole()
                local random = math.random(1, 4)
                if random == 1 then
                    acc.map:changeMap("top")
                elseif random == 2 then
                    acc.map:changeMap("bottom")
                elseif random == 3 then
                    acc.map:changeMap("left")
                elseif random == 4 then
                    acc.map:changeMap("right")
                end
            end
        end
    end

    if acc:isTeamLeader() and acc.character():energyPoints() > 0 then
        local reloadFunction = false
        acc:reloadScript()
        acc:startScript()
        local Team = acc:getTeamAccounts()
        table.insert(Team, 1, acc)
        for _, account in ipairs(Team) do
            if account:isAccountFullyConnected() then
                while account.map:currentArea() == "Ecaflipus" do
                    global:printSuccess("Appel1 de la fonction debug pour le bot " .. account:getAlias())
                    for _, element in ipairs(DebugTeam) do
                        if account.map:onMap(element.map) then
                            if element.map == "161351684" or element.map == "162791424" then
                                account.map:useById(503232, -2)
                            end
                            if element.path then
                                account.map:changeMap(element.path)
                            end
                        end
                    end
                    local console_lines = account.global():consoleLines()
                    for _, line in ipairs(console_lines) do
                        if line:find("Impossible d'aller vers") or line:find("Erreur dans le script : Impossible d'utiliser l'élément interactif") or line:find("impossible de") then
                            global:printSuccess("bug du bot, on le déco reco")
                            account.global():clearConsole()
                            account.global():reconnect(0)
                            while not account:isAccountFullyConnected() do
                                global:delay(2000)
                            end
                            break
                        end
                    end
                end
                if not account.map:onMap("0,0") and account.character():energyPoints() > 0 then
                    global:printSuccess("On mets " .. account:getAlias() .. " dans le havresac")
                    account.map:changeMap("havenbag")
                end
                global:delay(500)
            end
        end
        for _, account in ipairs(Team) do
            if ConsoleRead(account, "impossible depuis cette carte.") then
                global:printSuccess("2Debug bot can't go to havresac")
                account.global():clearConsole()
                local random = math.random(1, 4)
                if random == 1 then
                    account.map:changeMap("top")
                elseif random == 2 then
                    account.map:changeMap("bottom")
                elseif random == 3 then
                    account.map:changeMap("left")
                elseif random == 4 then
                    account.map:changeMap("right")
                end
                account.map:changeMap("havenbag")
            end
            if account.map:onMap("0,0") then
                global:printSuccess("le bot est maintenant dans le havresac")
            end
            if not account.map:onMap("0,0") and account.character():energyPoints() > 0 then
                reloadFunction = true
                global:printSuccess(account:getAlias() .. " bug, on le deco reco 5")
                account.global():reconnect(0)
            end
        end
        global:printSuccess("On attend que les bots se reco")
        for _, account in ipairs(Team) do
            local timeCounter = 0
            while not account:isAccountFullyConnected() and timeCounter < 30 do
                timeCounter = timeCounter + 1
                global:delay(1000)
            end
        end
        if reloadFunction then
            return PutTeamInHavenbag(acc)
        end
    end
end

local function IsTeamAtTheSameMap(acc)
    if acc:isTeamLeader() and acc.character():energyPoints() > 0 then
        local Team = acc:getTeamAccounts()
        for _, account in ipairs(Team) do
            if not acc.map:onMap(account.map:currentMapId()) then
                return false
            end
        end
        return true
    end
end

local function DebugDeathTeam(acc)
    if acc:isTeamLeader() and acc:isAccountFullyConnected() then
        local Team = acc:getTeamAccounts()
        table.insert(Team, 1, acc)
        local NbDeath = 0
        local UsePopoRappel = false
        
        for _, account in ipairs(Team) do
            if account:isAccountFullyConnected() and account.character():energyPoints() == 0 then
                NbDeath = NbDeath + 1
            end
        end

        local MapTrouvee = true

        while NbDeath > 0 and NbDeath < #Team and MapTrouvee do
            UsePopoRappel = true
            NbDeath = 0
            for _, account in ipairs(Team) do
                if account:isAccountFullyConnected() and account.character():energyPoints() == 0 and not acc:isBanned() then
                    global:printSuccess("Appel de la fonction phenix pour le bot " .. account:getAlias() .. " (" .. account:getUsername()  .. ")")
                    MapTrouvee = false
                    NbDeath = NbDeath + 1
                    for _, element in ipairs(PathPhenix) do
                        if account.map:onMap(element.map) then
                            MapTrouvee = true
                            if element.path then
                                account.map:changeMap(element.path)
                            else
                                element.custom(account)
                            end
                            global:delay(500)
                            if account.map:onMap(element.map) then
                                global:printSuccess("bug, on déco reco le compte")
                                account.global():reconnect(0)
                                while not account:isAccountFullyConnected() do
                                    global:delay(1000)
                                end
                                global:delay(2000)
                            end
                        end
                    end
                    if not MapTrouvee and account.map:currentArea() == "Île d'Otomaï" and not account.map:onMap("-58,18") then
                        account.map:moveToward(-58, 18)
                    end
                end
            end   
        end
        if UsePopoRappel then
            for _, account in ipairs(Team) do
                account.map:changeMap("havenbag")
            end
        end
    end
end

local function isTeamBugged(acc)
    local lines = acc.global():consoleLines()

    local botbugged = false
    local lastHour = 0
    for _, line in ipairs(lines) do
        if line:find("Vérification que tous les bots du groupe sont connectés") then
            botbugged = true
            lastHour = GetTotalHeureByMinute(line)
        elseif line:find("Vérification terminée !") or line:find("Téléportation") then
            botbugged = false
        end
    end
    return botbugged and (GetCurrentHourInMinutes() - lastHour) > 1
end

local function DebugLostTeam(acc)
    if acc:isTeamLeader() and acc.character():energyPoints() > 0 and not acc.character():isInFight() and acc:isAccountFullyConnected() and not acc.character():freeMode() then
        local HavresacTeam = false
        -- si il y a plus de 5 "le serveur a coupé la connexion, on décharge recharge les bots
        local lines = acc.global():consoleLines()
        local counter = 0
        
        for _, line in ipairs(lines) do
            if line:find("Le serveur a coupé la connexion !") then
                counter = counter + 1
            end
        end

        local forceReload = false
        local team = acc:getTeamAccounts()

        for _, bot in ipairs(team) do
            local lines = bot.global():consoleLines()
            for _, line in ipairs(lines) do
                if line:find("Je suis arrivé à la carte du chef !") then
                    forceReload = true
                end
            end
        end
        if counter > 4 or forceReload then
            global:printSuccess("On reload la team de " .. acc:getAlias())
            -- on unload reload une team
            local team = acc:getTeamAccounts()
            local fullTeam = {}
            fullTeam[#fullTeam+1] = acc
            for _, bot in ipairs(team) do
                fullTeam[#fullTeam+1] = bot
            end
            for _, bot in ipairs(fullTeam) do
                bot.global():clearConsole()
                bot:disconnect()
            end
            global:delay(5000)
            for _, bot in ipairs(fullTeam) do
                bot:connect()
            end
            for _, bot in ipairs(fullTeam) do
                while not bot:isAccountFullyConnected() do
                    global:delay(2000)
                end
            end

            -- acc:unloadAnAccount()
            -- global:delay(5000)
            -- snowbotController:loadTeamAccount(allUsernames, allUsernames[1], true)
            -- global:delay(1000)
            return move()
        end
        if not acc:isScriptPlaying() and IsTeamAtTheSameMap(acc) then
            acc:startScript()
            global:delay(500)
        end
        if (not acc:isScriptPlaying() or isTeamBugged(acc)) and acc:isAccountFullyConnected() then
            global:printSuccess("ouiii")
            local Team = acc:getTeamAccounts()
            local stoop = false
            for _, account in ipairs(Team) do
                if not account:isAccountFullyConnected() or account.character():energyPoints() == 0 or account.character():isInFight() then
                    global:printSuccess("noooon")
                    stoop = true
                end
            end
            if not stoop then
                HavresacTeam = true
            end
        end

        local Team = acc:getTeamAccounts()
        table.insert(Team, acc)
        for _, account in ipairs(Team) do
            lines = account.global():consoleLines()
            if lines ~= nil then
                for i, ligne in ipairs(lines) do
                    if ligne:find("Impossible de trouver un chemin pour rejoindre le chef") and not IsTeamAtTheSameMap(acc) and account.character():energyPoints() > 0 then
                        while account.map:currentArea() == "Ecaflipus" do
                            global:printSuccess("Appel3 de la fonction debug pour le bot " .. account:getAlias())
                            for _, element in ipairs(DebugTeam) do
                                if account.map:onMap(element.map) then 
                                    if element.map == "161351684" or element.map == "162791424" then
                                        account.map:useById(503232, -2)
                                    end
                                    if element.path then
                                        account.map:changeMap(element.path)
                                    end
                                end
                            end
                            local console_lines = account.global():consoleLines()
                            for _, line in ipairs(console_lines) do
                                if line:find("Impossible d'aller vers") or line:find("Erreur dans le script : Impossible d'utiliser l'élément interactif") or line:find("le serveur n'a pas répondu dans les temps impartis") then
                                    global:printSuccess("bug du bot, on le déco reco")
                                    account.global():clearConsole()
                                    account.global():reconnect(0)
                                    while not account:isAccountFullyConnected() do
                                        global:delay(2000)
                                    end
                                    break
                                end
                            end
                        end
                        account.global():clearConsole()
                        HavresacTeam = true
                    end
                    if ligne:find("Téléportation vers un Havre-Sac impossible depuis cette carte.") then
                        HavresacTeam = true
                    end
                end
            end
            -- if account.character():freeMode() and account.character():kamas() > 1000000 and not account.character():isInFight() and account:isAccountFullyConnected() then
            --     global:printSuccess("on tente d'abonner le compte " .. account:getAlias())
            --     account:callScriptFunction("Abonnement")
            -- end
        end
        if acc:isTeamLeader() and acc.map:currentArea() == "Ecaflipus" then
            for _, account in ipairs(Team) do
                if account.map:onMap("0,0") and account.map:currentArea() ~= "Ecaflipus" then
                    global:printSuccess("Appel2 de la fonction debug pour le bot " .. acc:getAlias())
                    for _, element in ipairs(DebugTeam) do
                        if acc.map:onMap(element.map) then
                            if element.map == "161351684" or element.map == "162791424" then
                                acc.map:useById(503232, -2)
                            end
                            if element.path then
                                acc.map:changeMap(element.path)
                            end
                        end
                    end
                end
            end
        end
        if acc:isTeamLeader() and acc.map:onMap("0,0") and acc.map:currentArea() ~= "Ecaflipus" then
            for _, account in ipairs(Team) do
                if account.map:currentArea() == "Ecaflipus" then
                    global:printSuccess("Appel3 de la fonction debug pour le bot " .. account:getAlias())
                    for _, element in ipairs(DebugTeam) do
                        if account.map:onMap(element.map) then
                            if element.map == "161351684" or element.map == "162791424" then
                                account.map:useById(503232, -2)
                            end
                            if element.path then
                                account.map:changeMap(element.path)
                            end
                        end
                    end
                end
            end
        end
        for _, account in ipairs(Team) do
            if account.character():freeMode() then
                HavresacTeam = false
            end
        end
        if HavresacTeam then
            global:printSuccess("On rassemble la Team de " .. acc:getAlias())
            PutTeamInHavenbag(acc)
        end
    end
end


local function WithDrawTime(lines)
    local toReturn = {}
    if lines then
        for _, element in ipairs(lines) do
            local newElement = {}
            for i = 2, #element do
                table.insert(newElement, element:split(" ")[i])
            end
            if newElement and #newElement > 0 then
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
        global:printSuccess("ok1")
        lines = WithDrawTime(lines)
        for i = 2, 15 do
            if find_repeated_patterns(lines, i, math.floor(#lines / math.floor(i * 2))) then
                global:printSuccess("ok2")
                return true
            end
        end
    end
    global:printSuccess("ok2")
    return false
end


local function DeleteAccountUp(acc)
    if not acc:isAccountConnected() and not acc:getAlias():find("MODO") and acc:getAlias():find("LvlUp") then
        local lines = acc.global():consoleLines()
        for _, line in ipairs(lines) do
            if line:find("Kamas transférés. Reprise du trajet") then
                global:printSuccess("AAAAAAAAAAAAAA")
                acc:connect()
                while not acc:isAccountFullyConnected() and not acc:isBanned() do
                    global:delay(2000)
                end

                if acc:isBanned() or ((acc.character():kamas() <= 10000) and acc.character():level() > 140) then
                    global:printSuccess("On supprme le compte " .. acc:getAlias() .. " car il est up")
                    snowbotController:deleteAccount(acc:getUsername())
                else
                    acc.global():editAlias(acc:getAlias() .. " MODO")
                end
            end
        end
    end
end


function move()
--             snowbotController:loadAnAccount("/", false) -- délimitateur bank
-- global:finishScript()
    totalKamas = 0
    totalCraftKamas = 0
    print:info("Checkup des bots")

    -- account loading

    if cptExportation == 20 then
        cptExportation = 0
        ExporterComptes()
        resetBotBankAvailability(false)
    end

    if DebutDeScript then
        DebutDeScript = false
        AccountToLoad = { bank = {}, Groupe = {
            ["Imagiro"] = {}, ["Orukam"] = {}, ["Tylezia"] = {}, ["Hell Mina"] = {}, ["Tal Kasha"] = {}, ["Draconiros"] = {}, 
            ["Dakal"] = {}, ["Kourial"] = {}, ["Mikhal"] = {}, ["Rafal"] = {}, ["Salar"] = {}, ["Brial"] = {}
        },
        Groupe2 = {
            ["Imagiro"] = {}, ["Orukam"] = {}, ["Tylezia"] = {}, ["Hell Mina"] = {}, ["Tal Kasha"] = {}, ["Draconiros"] = {},
            ["Dakal"] = {}, ["Kourial"] = {}, ["Mikhal"] = {}, ["Rafal"] = {}, ["Salar"] = {}, ["Brial"] = {}
        },
        Groupe3 = {
            ["Imagiro"] = {}, ["Orukam"] = {}, ["Tylezia"] = {}, ["Hell Mina"] = {}, ["Tal Kasha"] = {}, ["Draconiros"] = {},
            ["Dakal"] = {}, ["Kourial"] = {}, ["Mikhal"] = {}, ["Rafal"] = {}, ["Salar"] = {}, ["Brial"] = {}
        }, Combat = {}, Combat2 = {}, LvlUp12 = {}, LvlUp34 = {}, Bucheron = {}, Mineur = {}, Craft = {}, CraftFM = {}, Requests = {}}
    
        local AliasNotLoaded = snowbotController:getAliasNotLoadedAccounts()
        for i, acc in ipairs(AliasNotLoaded) do
            if acc:find("bank") then
                for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                    if i == j  then
                        table.insert(AccountToLoad.bank, Username)
                    end
                end
            elseif acc:find("Groupe ") then
                for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                    if i == j then
                        table.insert(AccountToLoad.Groupe[GetServerByAlias(acc)], Username)
                    end
                end
            elseif acc:find("Groupe2") then
                global:printSuccess(acc)
                for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                    if i == j then
                        table.insert(AccountToLoad.Groupe2[GetServerByAlias(acc)], Username)
                    end
                end
            elseif acc:find("Groupe3") then
                for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                    if i == j then
                        table.insert(AccountToLoad.Groupe3[GetServerByAlias(acc)], Username)
                    end
                end
            elseif acc:find("Combat ") or acc:find("Combat2") then
                for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                    if i == j then
                        table.insert(AccountToLoad.Combat, {Username, acc})
                    end
                end
            elseif acc:find("Combat3") or acc:find("Combat4") then
                for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                    if i == j then
                        table.insert(AccountToLoad.Combat2, {Username, acc})
                    end
                end
            elseif (acc:find("LvlUp ") or acc:find("LvlUp2")) and not acc:find("Next") then
                for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                    if i == j then
                        table.insert(AccountToLoad.LvlUp12, {Username, acc})
                    end
                end
            elseif (acc:find("LvlUp3") or acc:find("LvlUp4")) and not acc:find("Next") then
                for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                    if i == j then
                        table.insert(AccountToLoad.LvlUp34, {Username, acc})
                    end
                end
            elseif acc:find("Bucheron") and not acc:find("Next") then
                for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                    if i == j then
                        table.insert(AccountToLoad.Bucheron, Username)
                    end
                end
            elseif acc:find("Mineur") and not acc:find("Next") then
                for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                    if i == j then
                        table.insert(AccountToLoad.Mineur, Username)
                    end
                end
            elseif acc:find("Craft ") and not acc:find("Next") then
                for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                    if i == j then
                        table.insert(AccountToLoad.Craft, {Username, acc})
                    end
                end
            elseif acc:find("CraftFM") and not acc:find("Next") then
                for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                    if i == j then
                        table.insert(AccountToLoad.CraftFM, {Username, acc})
                    end
                end
            elseif acc:find("Requests") and not acc:find("Next") then
                for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                    if i == j then
                        table.insert(AccountToLoad.Requests, {Username, acc})
                    end
                end
            end
        end

        snowbotController:loadAnAccount("/", false) -- délimitateur bank
        for _, acc in ipairs(AccountToLoad.bank) do
            snowbotController:assignProxyToAnAccount(acc, proxyBank.proxy, tonumber(proxyBank.port), proxyBank.username, proxyBank.password, (typeProxy ~= "socks5"), true)
            snowbotController:loadAnAccount(acc, false)
        end
        snowbotController:loadAnAccount("//", false) -- délimitateur Combat

        local Servers = {"Imagiro", "Orukam", "Tal Kasha", "Hell Mina", "Tylezia", "Draconiros", "Dakal", "Kourial", "Mikhal", "Rafal", "Salar", "Brial"}

        for _, server in ipairs(Servers) do

            local team = AccountToLoad.Groupe[server]
            for _, acc in ipairs(team) do
                snowbotController:assignProxyToAnAccount(acc, proxyCraftFM.proxy, tonumber(proxyCraftFM.port), proxyCraftFM.username, proxyCraftFM.password, (typeProxy ~= "socks5"), true)
            end
            if #team >= 2 then
                snowbotController:loadTeamAccount(team, team[1], true)
            end
        end

        for _, server in ipairs(Servers) do
            local team = AccountToLoad.Groupe2[server]
            for _, acc in ipairs(team) do
                global:printSuccess(acc)
                snowbotController:assignProxyToAnAccount(acc, proxyGroupe2.proxy, tonumber(proxyGroupe2.port), proxyGroupe2.username, proxyGroupe2.password, (typeProxy ~= "socks5"), true)
            end
            if #team >= 2 then
                snowbotController:loadTeamAccount(team, team[1], true)
            end
        end

        for _, server in ipairs(Servers) do
            local team = AccountToLoad.Groupe3[server]
            for _, acc in ipairs(team) do
                snowbotController:assignProxyToAnAccount(acc, proxyGroupe3.proxy, tonumber(proxyGroupe3.port), proxyGroupe3.username, proxyGroupe3.password, (typeProxy ~= "socks5"), true)
            end
            if #team >= 2 then
                snowbotController:loadTeamAccount(team, team[1], true)
            end
        end

        for _, server in ipairs(Servers) do
            for _, acc in ipairs(AccountToLoad.Combat) do
                if acc[2]:find(server) then
                    snowbotController:assignProxyToAnAccount(acc[1], proxyCombat.proxy, tonumber(proxyCombat.port), proxyCombat.username, proxyCombat.password, (typeProxy ~= "socks5"), true)
                    snowbotController:loadAnAccount(acc[1], true)
                end
            end
            for _, acc in ipairs(AccountToLoad.Combat2) do
                if acc[2]:find(server) then
                    snowbotController:assignProxyToAnAccount(acc[1], proxyCombat2.proxy, tonumber(proxyCombat2.port), proxyCombat2.username, proxyCombat2.password, (typeProxy ~= "socks5"), true)
                    snowbotController:loadAnAccount(acc[1], true)
                end
            end
        end 

        snowbotController:loadAnAccount("///", false) -- délimitateur Bucheron / LvlUp12 / Craft

        local Servers = {"Imagiro", "Orukam", "Tal Kasha", "Hell Mina", "Tylezia", "Draconiros", "Dakal", "Kourial", "Mikhal", "Rafal", "Salar", "Brial"}

        for _, server in ipairs(Servers) do
            for _, acc in ipairs(AccountToLoad.LvlUp12) do
                if acc[2]:find(server) then
                    snowbotController:assignProxyToAnAccount(acc[1], proxyLvlUp12.proxy, tonumber(proxyLvlUp12.port), proxyLvlUp12.username, proxyLvlUp12.password, (typeProxy ~= "socks5"), true)
                    snowbotController:loadAnAccount(acc[1], true)
                end
            end
            for _, acc in ipairs(AccountToLoad.LvlUp34) do
                if acc[2]:find(server) then
                    snowbotController:assignProxyToAnAccount(acc[1], proxyLvlUp34.proxy, tonumber(proxyLvlUp34.port), proxyLvlUp34.username, proxyLvlUp34.password, (typeProxy ~= "socks5"), true)
                    snowbotController:loadAnAccount(acc[1], true)
                end
            end
        end    
        snowbotController:loadAnAccount("////", false) -- délimitateur Craft

        local Servers = {"Imagiro", "Orukam", "Tal Kasha", "Hell Mina", "Tylezia", "Draconiros", "Dakal", "Kourial", "Mikhal", "Rafal", "Salar", "Brial"}

        for _, acc in ipairs(AccountToLoad.Requests) do
            local proxy = proxyBank
            snowbotController:assignProxyToAnAccount(acc[1], proxy.proxy, tonumber(proxy.port), proxy.username, proxy.password, (typeProxy ~= "socks5"), true)
            snowbotController:loadAnAccount(acc[1], true)
        end

        for _, server in ipairs(Servers) do
            for _, acc in ipairs(AccountToLoad.CraftFM) do
                if acc[2]:find(server) then
                    local proxy = proxyCraft
                    snowbotController:assignProxyToAnAccount(acc[1], proxy.proxy, tonumber(proxy.port), proxy.username, proxy.password, (typeProxy ~= "socks5"), true)
                    snowbotController:loadAnAccount(acc[1], true)
                end
            end
            for _, acc in ipairs(AccountToLoad.Craft) do
                if acc[2]:find(server) then
                    local proxy = proxyCraftFM
                    snowbotController:assignProxyToAnAccount(acc[1], proxy.proxy, tonumber(proxy.port), proxy.username, proxy.password, (typeProxy ~= "socks5"), true)
                    snowbotController:loadAnAccount(acc[1], true)
                end
            end
        end    

        local Servers = {"Imagiro", "Orukam", "Tal Kasha", "Hell Mina", "Tylezia", "Draconiros", "Dakal", "Kourial", "Mikhal", "Rafal", "Salar", "Brial"}
        local AliasAllAccount = snowbotController:getAliasLoadedAccounts()

        for _, server in ipairs(Servers) do
            global:printSuccess(_)
            for _, Alias in ipairs(AliasAllAccount) do
                if Alias:find("LvlUp ") and Alias:find(server) then
                    boolLvlUp = true
                elseif Alias:find("LvlUp2") and Alias:find(server) then
                    boolLvlUp2 = true
                elseif Alias:find("LvlUp3") and Alias:find(server) then
                    boolLvlUp3 = true
                elseif Alias:find("LvlUp4") and Alias:find(server) then
                    boolLvlUp4 = true
                end
            end


            if not boolLvlUp then
                global:printSuccess("Pas de lvlup sur le server " .. server)
                local AliasNotLoaded = snowbotController:getAliasNotLoadedAccounts()
                for i, Alias in ipairs(AliasNotLoaded) do
                    if server == "Draconiros" and Alias:find("Next") and not Alias:find("Groupe") then
                        local ServerToTake = WhichServer()
                        global:printSuccess("on crée le personnage sur " .. ServerToTake)
                        local UsernameNotLoaded = snowbotController:getUsernameNotLoadedAccounts()
                        for j, username in ipairs(UsernameNotLoaded) do
                            if i == j then
                                snowbotController:createCharacter(username, ServerToTake, 11, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
                                snowbotController:assignProxyToAnAccount(username, proxyLvlUp12.proxy, tonumber(proxyLvlUp12.port), proxyLvlUp12.username, proxyLvlUp12.password, (typeProxy ~= "socks5"), true)
                                local acc = snowbotController:loadAnAccount(username, true)
                                acc.global():editAlias("LvlUp " .. server, true)
                                break
                            end
                        end
                        break
                    elseif Alias == "*" and server ~= "Draconiros" then
                        local UsernameNotLoaded = snowbotController:getUsernameNotLoadedAccounts()
                        for j, username in ipairs(UsernameNotLoaded) do
                            if i == j then
                                snowbotController:createCharacter(username, server, 11, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
                                snowbotController:assignProxyToAnAccount(username, proxyLvlUp12.proxy, tonumber(proxyLvlUp12.port), proxyLvlUp12.username, proxyLvlUp12.password, (typeProxy ~= "socks5"), true)
                                local acc = snowbotController:loadAnAccount(username, true)
                                acc.global():editAlias("LvlUp " .. server, true)
                                break
                            end
                        end
                        break
                    end
                end
            end

            -- if not boolLvlUp2 then
            --     local AliasNotLoaded = snowbotController:getAliasNotLoadedAccounts()
            --     for i, Alias in ipairs(AliasNotLoaded) do
            --         if server == "Draconiros" and Alias:find("Next") and not Alias:find("Groupe") then
            --             local ServerToTake = WhichServer()
            --             global:printSuccess("on crée le personnage sur " .. ServerToTake)
            --             local UsernameNotLoaded = snowbotController:getUsernameNotLoadedAccounts()
            --             for j, username in ipairs(UsernameNotLoaded) do
            --                 if i == j then
            --                     snowbotController:createCharacter(username, ServerToTake, 11, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
            --                     snowbotController:assignProxyToAnAccount(username, proxyLvlUp12.proxy, tonumber(proxyLvlUp12.port), proxyLvlUp12.username, proxyLvlUp12.password, (typeProxy ~= "socks5"), true)
            --                     local acc = snowbotController:loadAnAccount(username, true)
            --                     acc.global():editAlias("LvlUp2 " .. server, true)
            --                     break
            --                 end
            --             end
            --             break
            --         elseif Alias == "*" and server ~= "Draconiros" then
            --             local UsernameNotLoaded = snowbotController:getUsernameNotLoadedAccounts()
            --             for j, username in ipairs(UsernameNotLoaded) do
            --                 if i == j then
            --                     snowbotController:createCharacter(username, server, 11, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
            --                     snowbotController:assignProxyToAnAccount(username, proxyLvlUp12.proxy, tonumber(proxyLvlUp12.port), proxyLvlUp12.username, proxyLvlUp12.password, (typeProxy ~= "socks5"), true)
            --                     local acc = snowbotController:loadAnAccount(username, true)
            --                     acc.global():editAlias("LvlUp2 " .. server, true)
            --                     break
            --                 end
            --             end
            --             break
            --         end
            --     end
            -- end

            if not boolLvlUp3 then
                local AliasNotLoaded = snowbotController:getAliasNotLoadedAccounts()
                for i, Alias in ipairs(AliasNotLoaded) do
                    if server == "Draconiros" and Alias:find("Next") and not Alias:find("Groupe") then
                        local ServerToTake = WhichServer()
                        global:printSuccess("on crée le personnage sur " .. ServerToTake)
                        local UsernameNotLoaded = snowbotController:getUsernameNotLoadedAccounts()
                        for j, username in ipairs(UsernameNotLoaded) do
                            if i == j then
                                snowbotController:createCharacter(username, ServerToTake, 11, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
                                snowbotController:assignProxyToAnAccount(username, proxyLvlUp34.proxy, tonumber(proxyLvlUp34.port), proxyLvlUp34.username, proxyLvlUp34.password, (typeProxy ~= "socks5"), true)
                                local acc = snowbotController:loadAnAccount(username, true)
                                acc.global():editAlias("LvlUp3 " .. server, true)
                                break
                            end
                        end
                        break
                    elseif Alias == "*" and server ~= "Draconiros" then
                        local UsernameNotLoaded = snowbotController:getUsernameNotLoadedAccounts()
                        for j, username in ipairs(UsernameNotLoaded) do
                            if i == j then
                                snowbotController:createCharacter(username, server, 11, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
                                snowbotController:assignProxyToAnAccount(username, proxyLvlUp34.proxy, tonumber(proxyLvlUp34.port), proxyLvlUp34.username, proxyLvlUp34.password, (typeProxy ~= "socks5"), true)
                                local acc = snowbotController:loadAnAccount(username, true)
                                acc.global():editAlias("LvlUp3 " .. server, true)
                                break
                            end
                        end
                        break
                    end
                end
            end

            -- if not boolLvlUp4 then
            --     local AliasNotLoaded = snowbotController:getAliasNotLoadedAccounts()
            --     for i, Alias in ipairs(AliasNotLoaded) do
            --         if server == "Draconiros" and Alias:find("Next") and not Alias:find("Groupe") then
            --             local ServerToTake = WhichServer()
            --             global:printSuccess("on crée le personnage sur " .. ServerToTake)
            --             local UsernameNotLoaded = snowbotController:getUsernameNotLoadedAccounts()
            --             for j, username in ipairs(UsernameNotLoaded) do
            --                 if i == j then
            --                     snowbotController:createCharacter(username, ServerToTake, 11, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
            --                     snowbotController:assignProxyToAnAccount(username, proxyLvlUp34.proxy, tonumber(proxyLvlUp34.port), proxyLvlUp34.username, proxyLvlUp34.password, (typeProxy ~= "socks5"), true)
            --                     local acc = snowbotController:loadAnAccount(username, true)
            --                     acc.global():editAlias("LvlUp4 " .. server, true)
            --                     break
            --                 end
            --             end
            --             break
            --         elseif Alias == "*" and server ~= "Draconiros" then
            --             local UsernameNotLoaded = snowbotController:getUsernameNotLoadedAccounts()
            --             for j, username in ipairs(UsernameNotLoaded) do
            --                 if i == j then
            --                     snowbotController:createCharacter(username, server, 11, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
            --                     snowbotController:assignProxyToAnAccount(username, proxyLvlUp34.proxy, tonumber(proxyLvlUp34.port), proxyLvlUp34.username, proxyLvlUp34.password, (typeProxy ~= "socks5"), true)
            --                     local acc = snowbotController:loadAnAccount(username, true)
            --                     acc.global():editAlias("LvlUp4 " .. server, true)
            --                     break
            --                 end
            --             end
            --             break
            --         end
            --     end
            -- end

            boolLvlUp = false
            boolLvlUp2 = false
            boolLvlUp3 = false
            boolLvlUp4 = false

        end


        ExporterComptes()
        resetBotBankAvailability(true)
    end
   
    local LoadedAccount = snowbotController:getLoadedAccounts()
    for _, acc in ipairs(LoadedAccount) do
        if (acc:isBanned() or acc:getAlias():find("BAN")) and (acc:getAlias():find("LvlUp")) then
            global:printSuccess(acc:getAlias())
            for i, Alias in ipairs(snowbotController:getAliasNotLoadedAccounts()) do
                if acc:getAlias():find("Draconiros") and Alias:find("Next") then
                    ServerToTake = WhichServer()
                    global:printSuccess("on crée le personnage sur " .. ServerToTake)
                    local UsernameNotLoaded = snowbotController:getUsernameNotLoadedAccounts()
                    for j, Username in ipairs(UsernameNotLoaded) do
                        if i == j then

                            if acc:getAlias():find("LvlUp ") then
                                -- recherche du nombre de lvlup par serveur
                                local AliasAllAccount = snowbotController:getAliasLoadedAccounts()
                                local cpt = 0

                                for i, Alias in ipairs(AliasAllAccount) do
                                    if Alias:find("LvlUp ") and Alias:find(GetServer(acc)) then
                                        cpt = cpt + 1
                                        break
                                    end
                                end
                                global:printSuccess(cpt)
                                if cpt == 1 then
                                    snowbotController:createCharacter(Username, ServerToTake, 11, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
                                    snowbotController:assignProxyToAnAccount(Username, proxyLvlUp12.proxy, tonumber(proxyLvlUp12.port), proxyLvlUp12.username, proxyLvlUp12.password, (typeProxy ~= "socks5"), true)
                                    accToLoad = snowbotController:loadAnAccount(Username, true)
                                    accToLoad.global():editAlias("LvlUp " .. GetServer(acc), true)
                                end
                            elseif acc:getAlias():find("LvlUp2") then
                                -- recherche du nombre de lvlup par serveur
                                local AliasAllAccount = snowbotController:getAliasLoadedAccounts()
                                local cpt = 0

                                for i, Alias in ipairs(AliasAllAccount) do
                                    if Alias:find("LvlUp2") and Alias:find(GetServer(acc)) then
                                        cpt = cpt + 1
                                        break
                                    end
                                end
                                global:printSuccess(cpt)
                                if cpt == 1 then
                                    snowbotController:createCharacter(Username, ServerToTake, 11, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
                                    snowbotController:assignProxyToAnAccount(Username, proxyLvlUp12.proxy, tonumber(proxyLvlUp12.port), proxyLvlUp12.username, proxyLvlUp12.password, (typeProxy ~= "socks5"), true)
                                    accToLoad = snowbotController:loadAnAccount(Username, true)
                                    accToLoad.global():editAlias("LvlUp2 " .. GetServer(acc), true)
                                end
                            elseif acc:getAlias():find("LvlUp3") then
                                -- recherche du nombre de lvlup par serveur
                                local AliasAllAccount = snowbotController:getAliasLoadedAccounts()
                                local cpt = 0

                                for i, Alias in ipairs(AliasAllAccount) do
                                    if Alias:find("LvlUp3") and Alias:find(GetServer(acc)) then
                                        cpt = cpt + 1
                                        break
                                    end
                                end
                                global:printSuccess(cpt)
                                if cpt == 1 then
                                    snowbotController:createCharacter(Username, ServerToTake, 11, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
                                    snowbotController:assignProxyToAnAccount(Username, proxyLvlUp34.proxy, tonumber(proxyLvlUp34.port), proxyLvlUp34.username, proxyLvlUp34.password, (typeProxy ~= "socks5"), true)
                                    accToLoad = snowbotController:loadAnAccount(Username, true)
                                    accToLoad.global():editAlias("LvlUp3 " .. GetServer(acc), true)
                                end
                            elseif acc:getAlias():find("LvlUp4") then
                                -- recherche du nombre de lvlup par serveur
                                local AliasAllAccount = snowbotController:getAliasLoadedAccounts()
                                local cpt = 0

                                for i, Alias in ipairs(AliasAllAccount) do
                                    if Alias:find("LvlUp4") and Alias:find(GetServer(acc)) then
                                        cpt = cpt + 1
                                        break
                                    end
                                end
                                global:printSuccess(cpt)
                                if cpt == 1 then
                                    snowbotController:createCharacter(Username, ServerToTake, 11, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
                                    snowbotController:assignProxyToAnAccount(Username, proxyLvlUp34.proxy, tonumber(proxyLvlUp34.port), proxyLvlUp34.username, proxyLvlUp34.password, (typeProxy ~= "socks5"), true)
                                    accToLoad = snowbotController:loadAnAccount(Username, true)
                                    accToLoad.global():editAlias("LvlUp4 " .. GetServer(acc), true)
                                end
                            end
                            snowbotController:deleteAccount(acc:getUsername())
                            break
                        end
                    end
                    break
                elseif Alias == "*" and not acc:getAlias():find("Draconiros") then
                    for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
                        if i == j then
                            server = GetServer(acc)
                            global:printSuccess(server)

                            if acc:getAlias():find("LvlUp ") then
                                        -- recherche du nombre de lvlup par serveur
                                local AliasAllAccount = snowbotController:getAliasLoadedAccounts()
                                local cpt = 0
                                
                                for i, Alias in ipairs(AliasAllAccount) do
                                    for j, Username in ipairs(snowbotController:getUsernameLoadedAccounts()) do
                                        if i == j then
                                            if Alias:find("LvlUp ") and Alias:find(server) then
                                                cpt = cpt + 1
                                                break
                                            end
                                        end
                                    end
                                end
                                global:printSuccess(cpt)
                                if cpt == 1 then
                                    snowbotController:createCharacter(Username, GetServer(acc), 11, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
                                    snowbotController:assignProxyToAnAccount(Username, proxyLvlUp12.proxy, tonumber(proxyLvlUp12.port), proxyLvlUp12.username, proxyLvlUp12.password, (typeProxy ~= "socks5"), true)
                                    accToLoad = snowbotController:loadAnAccount(Username, true)
                                    accToLoad.global():editAlias("LvlUp " .. GetServer(acc), true)
                                end
                            elseif acc:getAlias():find("LvlUp2") then
                                local AliasAllAccount = snowbotController:getAliasLoadedAccounts()
                                local cpt = 0
                                
                                for i, Alias in ipairs(AliasAllAccount) do
                                    for j, Username in ipairs(snowbotController:getUsernameLoadedAccounts()) do
                                        if i == j then
                                            if Alias:find("LvlUp2") and Alias:find(server) then
                                                cpt = cpt + 1
                                                break
                                            end
                                        end
                                    end
                                end
                                global:printSuccess(cpt)
                                if cpt == 1 then
                                    snowbotController:createCharacter(Username, GetServer(acc), 11, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
                                    snowbotController:assignProxyToAnAccount(Username, proxyLvlUp12.proxy, tonumber(proxyLvlUp12.port), proxyLvlUp12.username, proxyLvlUp12.password, (typeProxy ~= "socks5"), true)
                                    accToLoad = snowbotController:loadAnAccount(Username, true)
                                    accToLoad.global():editAlias("LvlUp2 " .. GetServer(acc), true)
                                end
                            elseif acc:getAlias():find("LvlUp3") then
                                local AliasAllAccount = snowbotController:getAliasLoadedAccounts()
                                local cpt = 0
                                
                                for i, Alias in ipairs(AliasAllAccount) do
                                    for j, Username in ipairs(snowbotController:getUsernameLoadedAccounts()) do
                                        if i == j then
                                            if Alias:find("LvlUp3") and Alias:find(server) then
                                                cpt = cpt + 1
                                                break
                                            end
                                        end
                                    end
                                end
                                global:printSuccess(cpt)
                                if cpt == 1 then
                                    snowbotController:createCharacter(Username, GetServer(acc), 11, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
                                    snowbotController:assignProxyToAnAccount(Username, proxyLvlUp34.proxy, tonumber(proxyLvlUp34.port), proxyLvlUp34.username, proxyLvlUp34.password, (typeProxy ~= "socks5"), true)
                                    accToLoad = snowbotController:loadAnAccount(Username, true)
                                    accToLoad.global():editAlias("LvlUp3 " .. GetServer(acc), true)
                                end
                            elseif acc:getAlias():find("LvlUp4") then
                                local AliasAllAccount = snowbotController:getAliasLoadedAccounts()
                                local cpt = 0
                                
                                for i, Alias in ipairs(AliasAllAccount) do
                                    for j, Username in ipairs(snowbotController:getUsernameLoadedAccounts()) do
                                        if i == j then
                                            if Alias:find("LvlUp4") and Alias:find(server) then
                                                cpt = cpt + 1
                                                break
                                            end
                                        end
                                    end
                                end
                                global:printSuccess(cpt)
                                if cpt == 1 then
                                    snowbotController:createCharacter(Username, GetServer(acc), 11, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
                                    snowbotController:assignProxyToAnAccount(Username, proxyLvlUp34.proxy, tonumber(proxyLvlUp34.port), proxyLvlUp34.username, proxyLvlUp34.password, (typeProxy ~= "socks5"), true)
                                    accToLoad = snowbotController:loadAnAccount(Username, true)
                                    accToLoad.global():editAlias("LvlUp4 " .. GetServer(acc), true)
                                end
                            
                            end
                            snowbotController:deleteAccount(acc:getUsername())
                            break
                        end
                    end
                    break
                end
            end
        end


        if acc.global():thisAccountController():getAlias():find("Draconiros") and acc:isAccountFullyConnected() and acc.character():server() ~= "Draconiros" 
        and not acc.global():thisAccountController():getAlias():find("LvlUp") then
            global:printSuccess("On débug un bot draconiros")
            acc.global():thisAccountController():forceServer("Draconiros")
            acc.global():reconnect(0)
        end

        lines = acc.global():consoleLines()

        global:printSuccess(acc:getAlias())
        DebugLostTeam(acc)

        if lines ~= nil and not acc:isController() then

            if acc:getAlias():find("Craft") and #lines > 100 and LoopBug(lines) then
                global:printSuccess("On débug le bot " .. acc:getAlias() .. " (loop bug)")
                acc.global():clearConsole()
                acc.global():reconnect(0)
            end
            local cptTimeOut = 0
            local cptStuckHavresac = 0
            local cptStuckExchange = 0
            local cptInactifReco = 0

            global:printSuccess("2")
            for i, ligne in ipairs(lines) do
                if ligne:find("Reconnexion automatique dans 5 secondes") then
                    cptInactifReco = cptInactifReco + 1
                    if cptInactifReco > 3 and acc:getAlias():find("bank") then
                        acc:disconnect()
                    end
                end
                if ligne:find("Téléportation vers un Havre-Sac impossible depuis cette carte.") and acc.map:currentArea() ~= "Ecaflipus" then
                    global:printSuccess("3Debug bot can't go to havresac")
                    acc.global():clearConsole()
                    local random = math.random(1, 4)
                    if random == 1 then 
                        acc.map:changeMap("top")
                    elseif random == 2 then
                        acc.map:changeMap("bottom")
                    elseif random == 3 then
                        acc.map:changeMap("left")
                    elseif random == 4 then
                        acc.map:changeMap("right")
                    end
                    acc.map:changeMap("havenbag")
                end
                if ligne:find("Le chef est dans l'havre sac !") then
                    cptStuckHavresac = cptStuckHavresac + 1
                end
                if ligne:find("Attente de l'acceptation de l'échange") then
                    cptStuckExchange = cptStuckExchange + 1
                end
                if cptStuckExchange > 10 then
                    global:printSuccess("debug " .. acc:getAlias() .. " exchange bug")
                    acc.global():clearConsole()
                    acc.global():reconnect(0)
                    break
                end
                if cptStuckHavresac > 10 and acc.map:currentArea() ~= "Ecaflipus" then
                    global:printSuccess("4Debug bot can't go to havresac")
                    acc.global():clearConsole()
                    local random = math.random(1, 4)
                    if random == 1 then
                        acc.map:changeMap("top")
                    elseif random == 2 then
                        acc.map:changeMap("bottom")
                    elseif random == 3 then
                        acc.map:changeMap("left")
                    elseif random == 4 then
                        acc.map:changeMap("right")
                    end
                    acc.map:changeMap("havenbag")
                    if not acc.map:onMap("havenbag") then
                        return move()
                    end
                    break
                end
                if ligne:find("Echec lors de l'utilisation d'un Zaap/Zaapi") or ligne:find("Le serveur refuse le déplacement, nouvelle tentative dans 2 secondes") then
                    global:printSuccess("Debut du compte " .. acc:getAlias() .. " (zaap bug) ou perso bloqué")
                    acc.global():clearConsole()
                    acc.global():reconnect(0)
                end
                -- if ligne:find("banni définitivement") and (acc:getAlias():find("Combat") or acc:getAlias():find("Groupe")) then
                --     global:printSuccess(acc:getAlias() .. " est banni définitivement")
                --     global:printError("Detection d'un ban def, on déco tout le monde")
                --     DecoAllComptes()
                -- end
                if ligne:find("Identifiant ou mot de passe incorrect !") then

                    -- snowbotController:deleteAccount(acc:getUsername())
                    DebutDeScript = true
                end
                if ligne:find("Ombre") and not ligne:find("Fin") and not acc:getAlias():find("bank") and not acc:getAlias():find("Ombre") then
                    heureOmbre = GetTotalHeureByMinute(ligne)

                    for j = i, #lines do
                        if lines[j]:find("Fin") or lines[j]:find("Fin du combat ") then
                            break
                        else
                            if lines[j] then
                                local heureNextLine = GetTotalHeureByMinute(lines[j])
    
                                if heureNextLine and heureOmbre and (heureNextLine - heureOmbre) > 5 then
    
                                    acc.global():clearConsole()
                                    acc.global():printSuccess("Reonnection demandée par le controller")
                                    acc.global():reconnect(0)
    
                                    break
                                end
                            end

                        end
                    end
                end
                if ligne:find("Aucune action à réaliser sur la map.") then
                    local j = i
                    local cpt = 0
                    while j < #lines do
                        if lines[j]:find("Aucune action à réaliser sur la map.") then
                            cpt = cpt + 1
                        else
                            break
                        end
                        if cpt > 5 then
                            acc.global():clearConsole()
                            acc:reloadScript()
                            acc:startScript()
                            break
                        end
                        j = j + 2
                    end
                end
                if ligne:find("la valeur de retour est ") and not acc:isScriptPlaying() then
                    global:printSuccess("ok3")
                    acc:startScript()
                    global:delay(2000)
                    break
                end
                if ligne:find("Action annulée pour cause de surcharge") then
                    global:printSuccess("Je debug le compte " .. acc:getAlias() ..  " (surcharge)")
                    acc.global():clearConsole()
                    acc:reloadScript()
                    acc:startScript()
                    global:delay(2000)
                    break
                end
                if cptTimeOut > 4 then
                    global:printSuccess("Je debug le compte " .. acc:getAlias() ..  " (TimeOuts)")
                    acc.global():clearConsole()
                    acc:disconnect()
                    acc:connect()
                    break
                end
                if ligne:find("TimeOut") and not ligne:find("ExchangeStartedBidSellerMessage") then
                    cptTimeOut = cptTimeOut + 1
                elseif not ligne:find("Ombre") and not ligne:find("introuvable") and not ligne:find("chargé") then
                    cptTimeOut = 0
                end
            end
        end        

        global:printSuccess("3")

        DebugDeathTeam(acc)
        DeleteAccountUp(acc)

        global:printSuccess("ok")

        if not acc:hasScript() and acc.character():level() < 10 and acc:isAccountFullyConnected() and not acc:getAlias():find("Groupe") then
            acc:loadConfig("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Configs\\Config_PL_1-6X.xml")
            acc:loadScript("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\PL&Zaaps\\PL_1-6X.lua")
            acc:disconnect()
            acc:connect()
            acc:startScript()
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
        if acc:getAlias():find("bank") and not acc:isController() then
            totalKamas = totalKamas + findMKamas(acc:getAlias())
        end
        if acc:getAlias():find("Craft") and not acc:isController() then
            totalCraftKamas = totalCraftKamas + findMKamas(acc:getAlias())
        end
    end

        --     -- recherche du nombre de mineurs par serveur
        --     local Servers = {"Imagiro", "Orukam", "Tal Kasha", "Hell Mina", "Tylezia", "Draconiros"}
        --     local AliasAllAccount = snowbotController:getAliasLoadedAccounts()
        --     local TotalLvlUp150ByServ = {["Imagiro"] = 0, ["Orukam"] = 0, ["Hell Mina"] = 0, ["Tal Kasha"] = 0, ["Tylezia"] = 0, ["Draconiros"] = 0}
        --     local TotalLvlUpByServ = {["Imagiro"] = 0, ["Orukam"] = 0, ["Hell Mina"] = 0, ["Tal Kasha"] = 0, ["Tylezia"] = 0, ["Draconiros"] = 0}
            
        --     for _, server in ipairs(Servers) do
        --         for i, Alias in ipairs(AliasAllAccount) do
        --             for j, Username in ipairs(snowbotController:getUsernameLoadedAccounts()) do
        --                 if i == j then
        --                     acc = snowbotController:getAccount(Username)
        --                     if Alias:find("LvlUp ") and Alias:find(server) and (acc.character():level() > 50) then
        --                         TotalLvlUp150ByServ[server] = TotalLvlUp150ByServ[server] + 1
        --                         TotalLvlUpByServ[server] = TotalLvlUpByServ[server] + 1
        --                         break
        --                     elseif (Alias:find("LvlUp ") or Alias:find("LvlUp2")) and Alias:find(server) then
        --                         TotalLvlUpByServ[server] = TotalLvlUpByServ[server] + 1
        --                     end
        --                 end
        --             end
        --         end
        --     end
    
        -- -- account loading
        -- for _, server in ipairs(Servers) do
        --     if TotalLvlUp150ByServ[server] == 1 and TotalLvlUpByServ[server] == 1 then
        --         global:printSuccess("On tente de créer un nouveau LvlUp sur " .. server)
        --         local AliasNotLoaded = snowbotController:getAliasNotLoadedAccounts()
        --         for i, Alias in ipairs(AliasNotLoaded) do
        --             if Alias == "*" and server ~= "Draconiros" then
        --                 local UsernameNotLoaded = snowbotController:getUsernameNotLoadedAccounts()
        --                 for j, username in ipairs(UsernameNotLoaded) do
        --                     if i == j then
        --                         snowbotController:createCharacter(username, server, 11, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
        --                         snowbotController:assignProxyToAnAccount(username, proxyLvlUp12.proxy, tonumber(proxyLvlUp12.port), proxyLvlUp12.username, proxyLvlUp12.password, (typeProxy ~= "socks5"), true)
        --                         local acc = snowbotController:loadAnAccount(username, true)
        --                         acc.global():editAlias("LvlUp2 " .. server, true)
        --                         break
        --                     end
        --                 end
        --                 break
        --             elseif server == "Draconiros" and Alias:find("Next") and not Alias:find("Groupe") then
        --                 local ServerToTake = WhichServer()
        --                 global:printSuccess("on crée le personnage sur " .. ServerToTake)
        --                 local UsernameNotLoaded = snowbotController:getUsernameNotLoadedAccounts()
        --                 for j, username in ipairs(UsernameNotLoaded) do
        --                     if i == j then
        --                         snowbotController:createCharacter(username, ServerToTake, 11, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
        --                         snowbotController:assignProxyToAnAccount(username, proxyLvlUp12.proxy, tonumber(proxyLvlUp12.port), proxyLvlUp12.username, proxyLvlUp12.password, (typeProxy ~= "socks5"), true)
        --                         local acc = snowbotController:loadAnAccount(username, true)
        --                         acc.global():editAlias("LvlUp2 " .. server, true)
        --                         break
        --                     end
        --                 end
        --                 break
        --             end
        --         end
        --     end
        -- end
    
    --[[local LoadedAccount = snowbotController:getLoadedAccounts()
    for _, acc in ipairs(LoadedAccount) do
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
    end]]

    --checkAFK()

    if totalCraftKamas > 0 then
        global:editAlias("banks : [" .. totalKamas .. "m], Crafts : [" .. totalCraftKamas .. "m]", true)
    else
        global:editAlias("Controller : [" .. totalKamas .. "m]", true)
    end

    local waitingTime = math.random(30, 60)
    print:successInfo("Checkup terminé, attente de " .. waitingTime .. " secondes.")
    global:delay(waitingTime * 1000)
    cptExportation = cptExportation + 1
    return move()
end


function stopped()
    global:restartScript(true)
end