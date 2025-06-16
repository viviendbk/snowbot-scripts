dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\IMPORT_LIBRARIES.lua")


local switchServerMulti =  {
    ["Hell Mina"] = "Imagiro",
    ["Imagiro"] = "Tylezia",
    ["Tylezia"] = "Tal Kasha",
    ["Tal Kasha"] = "Orukam",
    ["Orukam"] = "Brial",
    ["Brial"] = "Rafal",
    ["Rafal"] = "Salar",
    ["Salar"] = "Hell Mina",
}

local switchServerMono =  {
    ["Draconiros"] = "Dakal",
    ["Dakal"] = "Kourial",
    ["Kourial"] = "Mikhal",
    ["Mikhal"] = "Draconiros"
}

local tableItem = {}

local hdvRessourceChecked = false
local hdvEquipChecked = false
local cpt = 0

local function EditJsonRessources(content)
    local jsonMemory = openFile(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\PriceRessources.json")

    if not jsonMemory[1] then
        jsonMemory[1] = {Date = getDate(), Time = getCurrentTime(), Prices = content}
    else
        jsonMemory[1].Date = getDate()
        jsonMemory[1].Time = getCurrentTime()
        jsonMemory[1].Prices = content
    end    

    local new_content = json.encode(jsonMemory)

    local file = io.open(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\PriceRessources.json", "w")

    file:write(new_content)

    file:close()
end

local function EditJsonItems(content)
    local jsonMemory = openFile(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\PriceItems.json")

    if not jsonMemory[1] then
        jsonMemory[1] = {Date = getDate(), Time = getCurrentTime(), Prices = content}
    else
        jsonMemory[1].Date = getDate()
        jsonMemory[1].Time = getCurrentTime()
        jsonMemory[1].Prices = content
    end

    local new_content = json.encode(jsonMemory)

    local file = io.open(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\PriceItems.json", "w")

    file:write(new_content)
    file:close()
end

local goToHdvEquip = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "212599813", path = "zaapi(212600837)"}, -- extérieur atelier bijoutier
    {map = "212599814", path = "zaapi(212600837)"}, -- extérieur atelier taileur
    {map = "212601347", path = "zaapi(212600837)"}, -- extérieur atelier cordonier
    {map = "212601348", path = "zaapi(212600837)"}, -- extérieur atelier forgeron
    {map = "212601860", path = "zaapi(212600837)"}, -- extérieur atelier sculpteur
    {map = "212601350", path = "zaapi(212600837)"}, -- hdv ressources
    {map = "212601859", path = "zaapi(212600837)"}, -- hdv brisage 
    {map = "212600322", path = "zaapi(212600837)"}, -- exterieur banque
    {map = "212601350", path = "zaapi(212600837)"},
    {map = "212600323", path = "bottom"},
    -- map : 212600837
}

local goToHdvRessources = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "212600323", path = "zaapi(212601350)"},
    {map = "212600837", path = "zaapi(212601350)"},
    {map = "212599813", path = "zaapi(212601350)"}, -- extérieur atelier bijoutier
    {map = "212599814", path = "zaapi(212601350)"}, -- extérieur atelier taileur
    {map = "212601347", path = "zaapi(212601350)"}, -- extérieur atelier cordonier
    {map = "212601348", path = "zaapi(212601350)"}, -- extérieur atelier forgeron
    {map = "212601860", path = "zaapi(212601350)"}, -- extérieur atelier sculpteur
    {map = "212600322", path = "zaapi(212601350)"}, -- exterieur banque
    {map = "212600837", path = "zaapi(212601350)"}, -- hdv equipements
    {map = "212601859", path = "zaapi(212601350)"}, -- hdv brisage 

    -- map : 212601350
}

local function GetCraftCost(ListIdCraft)
    local PrixHdvAllRessources = {}

    HdvSell()
    local TotalCost = 0
    local LackRessource = false

    if not ListIdCraft then
        LackRessource = true
    else
        for _, Ressource in ipairs(ListIdCraft) do
            if not PrixHdvAllRessources[Ressource.Id] then
                PrixHdvAllRessources[Ressource.Id] = GetPricesItem(Ressource.Id)
            end
            if not PrixHdvAllRessources[Ressource.Id].TrueAveragePrice or PrixHdvAllRessources[Ressource.Id].TrueAveragePrice == 0 or IsItem(inventory:itemTypeId(Ressource.Id))
            or (Ressource.Quantity > 29 and PrixHdvAllRessources[Ressource.Id].Price100 == 0 and PrixHdvAllRessources[Ressource.Id].Price10 == 0)  then
                LackRessource = true
                break
            end
            TotalCost = TotalCost + PrixHdvAllRessources[Ressource.Id].TrueAveragePrice * Ressource.Quantity
        end
    end

    global:printSuccess("Nouveau prix : " .. TotalCost)
    HdvBuy()
    if LackRessource then
        return TotalCost * 1.5
    else
        return TotalCost
    end 
end

function move()
    if character:level() < 35 then
        global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\PL&Zaaps\\PL_1-6X.lua")
    end
    mapDelay()
    if global:thisAccountController():getAlias():find("RequestsMulti") then
        global:editAlias("RequestsMulti", true)
    elseif global:thisAccountController():getAlias():find("RequestsMono") then
        global:editAlias("RequestsMono", true)
    end

    if not getCurrentAreaName() == "Bonta" then
        local lines = global:consoleLines()

        local counterBug = 0
        for _, line in ipairs(lines) do
            if line:find("Téléportation Mapid") then
                counterBug = counterBug + 1
            else
                counterBug = 0
            end
            if counterBug > 3 then
                global:clearConsole()
                global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\PL&Zaaps\\Zaaps&Stuffs.lua")
            end
        end
    end

    if not ScriptStarted then
        if getRemainingSubscription(true) <= 0 then
            global:printSuccess(getRemainingSubscription(true))
            global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\setup_hiaky\\scripts\\take-kamas-for-abo.lua")
        end
        if character:kamas() < 10000 then
            global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\setup_hiaky\\scripts\\take-50k.lua")
        end

        local nbItemsTotal = 0
        for i = 1, 30000 do
            if IsItem(inventory:itemTypeId(i)) then
                table.insert(tableItem, {
                    Id = i,
                    ListIdCraft = getIngredients(i),
                    Type = inventory:getTypeName(i),
                    NbToCraft = 0,
                })
                nbItemsTotal = nbItemsTotal + 1
            end
        end
        global:printSuccess("Remplissage fini!")
        global:printMessage("--------------------")
        global:printSuccess("Nous allons récupérer le prix de " .. #tableItem .. " items et le prix des ressources nécessaire à leur recette")
        global:printMessage("--------------------")
        ScriptStarted = true
    end


    --va hdv ressources pour récupérer le cout de craft des items
    if not map:onMap(212601350) and not hdvRessourceChecked then
        return TreatMaps(goToHdvRessources)
    elseif not hdvRessourceChecked then
        HdvSell()
        global:printMessage("")
        global:printMessage("--------------------------------------")
        global:printMessage("Récupération du prix des ressources...")
        local PrixHdvAllRessources = {}

        if cpt == 0 then
            cpt = cpt +1
            for _, item in ipairs(tableItem) do
                if _ == math.floor(#tableItem / 4) then
                    global:printMessage("25% effectué...")
                elseif _ == math.floor(#tableItem / 2) then
                    global:printMessage("50% effectué...")
                elseif _ == math.floor(#tableItem * 0.75) then
                    global:printMessage("75% effectué...")
                end
                
                if item.ListIdCraft then
                    for _, Ressource in ipairs(item.ListIdCraft) do
                        if not PrixHdvAllRessources[tostring(Ressource.Id)] then
                            PrixHdvAllRessources[tostring(Ressource.Id)] = GetPricesItem(Ressource.Id)
                        end
                    end
                end
            end
        end

        global:delay(2000)

        global:printSuccess("Analyse finie!")
        global:printMessage("--------------------------------------")
        global:printMessage("")

        global:leaveDialog()

        EditJsonRessources(PrixHdvAllRessources)
        hdvRessourceChecked = true
    end

    -- va hdv equipement pour récupérer le prix des items
    if not map:onMap(212600837) and not hdvEquipChecked then
        return TreatMaps(goToHdvEquip)
    elseif not hdvEquipChecked then
        global:printMessage("")
        global:printMessage("--------------------------------------")
        global:printMessage("Récupération du prix des items...")
        HdvSell()
        local priceItems = {}
        for _, item in ipairs(tableItem) do

            if _ == math.floor(#tableItem / 4) then
                global:printMessage("25% effectué...")
            elseif _ == math.floor(#tableItem / 2) then
                global:printMessage("50% effectué...")
                global:leaveDialog()
                map:moveToCell(397)
                HdvSell()
            elseif _ == math.floor(#tableItem * 0.75) then
                global:printMessage("75% effectué...")
            end

            if not priceItems[tostring(item.Id)] then
                priceItems[tostring(item.Id)] = GetPricesItem(item.Id)
            end

            item.PriceHdv = priceItems[tostring(item.Id)]
        end

        global:delay(2000)

        global:printSuccess("Analyse finie!")
        global:printMessage("--------------------------------------")
        global:printMessage("")

        global:leaveDialog()

        EditJsonItems(priceItems)
        hdvEquipChecked = true
    end

    if global:thisAccountController():getAlias():find("RequestsMulti") then
        global:thisAccountController():forceServer(switchServerMulti[character:server()])
        if character:server() == "Salar" then
            customReconnect(100, 200)
        end
        global:disconnect()
    elseif global:thisAccountController():getAlias():find("RequestsMono") then
        global:thisAccountController():forceServer(switchServerMono[character:server()])
        if character:server() == "Mikhal" then
            customReconnect(400, 600)
        end
        global:disconnect()
    else
        global:printError("Alias de l'account controller non reconnu, impossible de changer de serveur.")
    end

end



function banned()
    global:editAlias(global:thisAccountController():getAlias() .. " [BAN]", true)
end