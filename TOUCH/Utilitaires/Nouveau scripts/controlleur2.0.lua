---@diagnostic disable: undefined-global, lowercase-global
--- <init>

local PathConfigEnilvl43 = "C:\\Users\\Administrator\\Desktop\\Script\\leveling\\eni43.xml"
local pathScriptlvlup = "C:\\Users\\Administrator\\Downloads\\ovh snowbot\\TOUCH\\Interactions Bot Banque\\Take_Stuff_Akwadala.lua"

local condition = function(acc)
    return acc:isAccountFullyConnected() and not acc:isScriptPlaying() and (acc:isTeamLeader() or not acc:isItATeam()) 
end

function move()
    global:printSuccess("Checkup des bots")

    for _, acc in ipairs(ankabotController:getLoadedAccounts()) do
        if acc:getAlias():find("GROUPE") and account:isItATeam() == false then
            acc:unloadAccount()
        end
        if condition(acc) then
            acc:reloadScript()
            acc:startScript()
        end

    end
    local TableUsername = {}
    
    for i, Alias in ipairs(ankabotController:getAliasNotLoadedAccounts()) do
        if Alias:find("GROUPE") then
            for j, Username in ipairs(ankabotController:getUsernameNotLoadedAccounts()) do
                if i == j then
                    table.insert(TableUsername, Username)
                end
            end
        end
    end

    if #TableUsername > 3 then 
        accTeam = ankabotController:loadTeamAccount(TableUsername, TableUsername[i], true)
        for _, acc in ipairs(accTeam) do
            while not acc:isAccountFullyConnected() do
                global:delay(2000)
            end
            acc:loadConfig(PathConfigEnilvl43)
            acc:loadScript(pathScriptlvlup)
        end
    end
    global:printSuccess("Checkup terminé, attente de " .. 120 .. " secondes.")

    global:delay(120 * 1000)

    return move()
end