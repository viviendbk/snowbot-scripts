function ItemSatisfyConditions(item, StatNegliger)
    --[[
        si l'item est lvl 200 et qu'il a PA ou PM, on rajoute dans CoefMiniByCarac all Dommages = 0.95 et les stats pas dans exeption = 0.85
        si il y a plus de 1 stat de base à satisfaire, on regarde si pour chaque stat, current >= min + (max - min) / 2, si non on ajoute cette stat à la première place de statprbmatiques
    ]]
    local nbStatProblematique = 0
    local tableStatPbmatique = {}
    local counterRes = 0
    local counterElemen = 0

    local qualityWanted = (((inventory:getLevel(item.Id) >= 195) and 0.96) or ((inventory:getLevel(item.Id) > 100) and 0.97) or ((inventory:getLevel(item.Id) > 80) and 0.98) or 0.99)
    item.RunesCost = 0
    NbRunesUsed = 0
    for k, v in pairs(item.InfoFm.RunesUsed) do
        item.RunesCost = item.RunesCost + GetPriceRune(tonumber(k)) * v
        NbRunesUsed = NbRunesUsed + v
    end

    if item.RunesCost > item.TotalCost / 1.5 and item.RunesCost > 200000 then
        global:printSuccess("POTENTIEL BUG")
        --global:disconnect()
        qualityWanted = qualityWanted - 0.02
        for k, v in pairs(CoefMiniByCarac) do
            v = v - 0.04
        end
    elseif item.RunesCost > item.TotalCost / 2 and item.RunesCost > 200000 then
        global:printSuccess("POTENTIEL BUG")
        --global:disconnect()
        qualityWanted = qualityWanted - 0.01
        for k, v in pairs(CoefMiniByCarac) do
            v = v - 0.03
        end

    elseif item.RunesCost > item.TotalCost / 3 then
        for k, v in pairs(CoefMiniByCarac) do
            v = v - 0.02
        end
    end

    if StatNegliger then
        local quality = 0
        local poidsTotal = 0
        for k, v in pairs(item.InfoFm.Stats) do
            if not (PoidsByStat[k].PoidsUnite > 30 and v.Current == 1) and k ~= StatNegliger and v.Max > 0 then
                poidsTotal = poidsTotal + PoidsByStat[k].PoidsUnite * v.Max
                quality = quality + PoidsByStat[k].PoidsUnite * v.Current
            end
        end
        quality = quality / poidsTotal

        if quality < qualityWanted then
            return {Bool = false, StatsNeeded = {}}
        end
    end

    for k, v in pairs(item.InfoFm.Stats) do
        counterElemen = counterElemen + (PoidsByStat[k].PoidsUnite == 1 and 1 or 0)
    end        

    if counterElemen > 2 then
        CoefMiniByCarac["Chance"] = CoefMiniByCarac["Chance"] - 0.02
        CoefMiniByCarac["Intelligence"] = CoefMiniByCarac["Intelligence"] - 0.02
        CoefMiniByCarac["Force"] = CoefMiniByCarac["Force"] - 0.02
        CoefMiniByCarac["Agilité"] = CoefMiniByCarac["Agilité"] - 0.02
    end

    local statLourde = false

    for k, v in pairs(item.InfoFm.Stats) do
        if v.Current < v.Min and k ~= "Initiative" and k ~= "Pods" then
            return {Bool = false, StatsNeeded = {}}
        end
        local poidsUnite = PoidsByStat[k].PoidsUnite
        if poidsUnite > 3 then
            statLourde = true
        end
        local toAdd = ((poidsUnite == 5) and 0.01 or (poidsUnite > 5 and poidsUnite < 30) and 0.0125 or poidsUnite == 4 and 0.0075 or 0)
        if v.Max > 10 then
            toAdd = toAdd * (v.Max / 10)
        end
        toAdd = toAdd + ((poidsUnite == 3 and 0.005) or (poidsUnite == 2 and 0.0025) or 0)

        nbStatProblematique = nbStatProblematique + toAdd
        counterRes = counterRes + (k:find("% Resistance") and 1 or 0)
        counterElemen = counterElemen + (PoidsByStat[k].PoidsUnite == 1 and 1 or 0)

        if (CoefMiniByCarac[k] and (v.Current / v.Max) < CoefMiniByCarac[k] and ((k == "Vitalite") and (v.Max - v.Current) > 1 or (k ~= "Vitalite")))
        or (v.Current < v.Min and v.Max > v.Min + 1)
        or k:find("Dommages") and (v.Max - v.Current) > (math.floor(v.Max / 10) > 0 and math.floor(v.Max / 10) or 1)
        --[[or (inventory:getLevel(item.Id) == 200 and ItemHasBigStat(item.Id) and toAdd < 0.065 and v.Max > 0 and (not IsInTable(STATS_TO_IGNORE, k) and (v.Current / v.Max) > (k:find("Dommages ") and 0.92 or 0.85)))]]
        then
        tableStatPbmatique[#tableStatPbmatique + 1] = k
        end
    end

    if #tableStatPbmatique > 1 then
        for k, v in pairs(item.InfoFm.Stats) do
            if v.Current < v.Min + (v.Max - v.Min) / 2 then
                tableStatPbmatique[#tableStatPbmatique + 1] = k
            end
        end
    end

    if not statLourde and inventory:getLevel(item.Id) > 100 then
        nbStatProblematique = nbStatProblematique + 0.04
    end

    if counterRes > 2 then
        for i = #tableStatPbmatique, 1, -1 do
            if tableStatPbmatique[i]:find("% Resistance") then
              table.remove(tableStatPbmatique, i)
            end
        end
    end

    local finalQualityWanted = ((inventory:getLevel(item.Id) > 80) and (qualityWanted - nbStatProblematique) or (inventory:getLevel(item.Id) > 60) and 0.98 or 0.99)
    if item.QualityWanted and item.QualityWanted > finalQualityWanted then
        finalQualityWanted = finalQualityWanted - 0.015
    elseif item.QualityWanted and item.QualityWanted <= finalQualityWanted then
        finalQualityWanted = math.min(item.QualityWanted, finalQualityWanted - 0.015)
    elseif item.LastCoef then
        finalQualityWanted = math.min(item.LastCoef, finalQualityWanted)
    end

    if NbRunesUsed > 350 then
        global:printMessage("On a utilisé plus de 350 runes, on cherche mtn à avoir " .. math.min(finalQualityWanted, MaxCoef - 0.05) .. " de coef")
        finalQualityWanted = math.min(finalQualityWanted, MaxCoef - 0.05)
    elseif NbRunesUsed > 300 then
        global:printMessage("On a utilisé plus de 300 runes, on cherche mtn à avoir " .. math.min(finalQualityWanted, MaxCoef - 0.03) .. " de coef")
        finalQualityWanted = math.min(finalQualityWanted, MaxCoef - 0.03)
    elseif NbRunesUsed > 250 then
        global:printMessage("On a utilisé plus de 250 runes, on cherche mtn à avoir " .. math.min(finalQualityWanted, MaxCoef - 0.03) .. " de coef")
        finalQualityWanted = math.min(finalQualityWanted, MaxCoef - 0.025)
    elseif NbRunesUsed > 200 then
        global:printMessage("On a utilisé plus de 200 runes, on cherche mtn à avoir " .. math.min(finalQualityWanted, MaxCoef - 0.02) .. " de coef")
        finalQualityWanted = math.min(finalQualityWanted, MaxCoef - 0.02)
    end

    if item.InfoFm.Quality < finalQualityWanted then
        return {Bool = false, StatsNeeded = {}}
    end

    if #tableStatPbmatique > 0 then
        return {Bool = false, StatsNeeded = tableStatPbmatique}
    end

    return {Bool = true, StatsNeeded = {}}
end

function ItemHasBigStat(Id)
    local statsJP = GetDices(Id)
    for _, stat in ipairs(statsJP) do
        if PoidsByStat[stat.name].Runes[1].Poids > 80 then
            return true
        end
    end
    return false
end

function ItemSatisfyConditionsById(Id)
    local qualityWanted = (((inventory:getLevel(Id) >= 195) and 0.94) or ((inventory:getLevel(Id) > 100) and 0.95) or ((inventory:getLevel(Id) > 80) and 0.96) or 0.97)

    local nbStatProblematique = 0
    local tableStatPbmatique = {}
    local counterRes = 0
    local quality = 0

    local InfoStats = {}
    local content = inventory:inventoryContent()

    for _, item2 in ipairs(content) do
        if item2.objectGID == Id then
            quality = GetQualityItem(item2.effects, Id)
            local statsJP = GetDices(Id)
            for _, statJp in ipairs(statsJP) do
                for _, stat in ipairs(item2.effects) do
                    if statJp.id == stat.actionId then
                        InfoStats[GetNameCarac(stat.actionId)] = {Min = statJp.dice.min, Current = stat.value, Max = statJp.dice.max}
                    end
                end
                if not InfoStats[GetNameCarac(statJp.id)] then
                    InfoStats[GetNameCarac(statJp.id)] = {Min = statJp.dice.min, Current = 0, Max = statJp.dice.max}
                end
            end
            break
        end
    end

    for k, v in pairs(InfoStats) do
        local poidsUnite = PoidsByStat[k].PoidsUnite
        local toAdd = ((poidsUnite == 5) and 0.01 or (poidsUnite > 5 and poidsUnite < 30) and 0.0125 or poidsUnite == 4 and 0.0075 or 0)
        if v.Max > 10 then
            toAdd = toAdd * (v.Max / 10)
        end
        local toAdd = toAdd + ((poidsUnite == 3 and 0.005) or (poidsUnite == 2 and 0.0025) or 0)

        nbStatProblematique = nbStatProblematique + toAdd
        counterRes = counterRes + (k:find("% Resistance") and 1 or 0)

        if (CoefMiniByCarac[k] and (v.Current / v.Max) < CoefMiniByCarac[k] and ((k == "Vitalite") and (v.Max - v.Current) > 1 or (k ~= "Vitalite"))) or v.Current < v.Min
        or k:find("Dommages") and (v.Max - v.Current) > (math.floor(v.Max / 10) > 0 and math.floor(v.Max / 10) or 1) then
            tableStatPbmatique[#tableStatPbmatique + 1] = k
        end
    end

    if counterRes > 2 then
        for i = #tableStatPbmatique, 1, -1 do
            if tableStatPbmatique[i]:find("% Resistance") then
              table.remove(tableStatPbmatique, i)
            end
        end
    end

    if quality < ((inventory:getLevel(Id) > 100) and (qualityWanted - nbStatProblematique) or (inventory:getLevel(Id) > 80) and 0.96 or 0.97) then
        return {Bool = false, StatsNeeded = {}}
    end

    if #tableStatPbmatique > 0 then
        return {Bool = false, StatsNeeded = tableStatPbmatique}
    end

    return {Bool = true, StatsNeeded = {}}
end

function GetJobIdByType(Type)
    if Type == "Chapeau" or Type == "Cape" or Type == "Sac à dos" then
        return 27
    elseif Type == "Ceinture" or Type == "Bottes" then
        return 15
    elseif Type == "Anneau" or Type == "Amulette" then
        return 16
    elseif Type == "Épée" or Type == "Hache" or Type == "Marteau" or Type == "Dague" or Type == "Pelle" then
        return 11
    elseif Type == "Bâton" or Type == "Baguette" or Type == "Arc" then
        return 13
    elseif Type == "Idole" or Type == "Bouclier" or Type == "Trophet" or Type == "Prysmaradite" then
        return 60
    end
    return 0
end

function GetJobMageIdByType(Type)
    if Type == "Chapeau" or Type == "Cape" or Type == "Sac à dos" then
        return 64
    elseif Type == "Ceinture" or Type == "Bottes" then
        return 62
    elseif Type == "Anneau" or Type == "Amulette" then
        return 63
    elseif Type == "Épée" or Type == "Hache" or Type == "Marteau" or Type == "Dague" or Type == "Pelle" then
        return 44
    elseif Type == "Bâton" or Type == "Baguette" or Type == "Arc" then
        return 48
    end
    return 0
end

function ItemHasTwoOrMoreCarac(Id)
    -- on regarde aussi si l'item a plus de 3 % res 
    local statsJP = GetDices(Id)
    local counter = 0
    for _, statJp in ipairs(statsJP) do
        if statJp.name:find("% Resistance") then
            counter = counter + 1
        end
        if statJp.name == "Renvoie dommages" then
            return false
        end
    end
    if counter > 3 then
        return false
    end
    if #statsJP > 1 then
        return true
    end
    return false
end

function ItemHasAtLeastOneLittleStat(Id)
    local statsJP = GetDices(Id)
    for _, statJp in ipairs(statsJP) do
        if PoidsByStat[statJp.name].PoidsUnite < 5 then
            return true
        end
    end
    return false
end



function CanMerge(id)
    for _, stat in pairs(PoidsByStat) do
        local runes = stat.Runes
        if #runes > 1 then
            if runes[1].Id == id then
                return true
            elseif #runes > 2 and runes[2].Id == id then
                return true
            end
        end
    end
    return false
end

function GetNumberOfMergeAvailable(id)
    for _, stat in pairs(PoidsByStat) do
        local runes = stat.Runes
        for i, runeData in ipairs(runes) do
            if runeData.Id == id then
                return #runes - i
            end
        end
    end
end

function GetUID(Id)
    global:printSuccess("On veut poser la rune [" .. inventory:itemNameId(Id) .. "]")
    local content = inventory:inventoryContent()
    for _, item in ipairs(content) do
        if item.objectGID == Id then
            return item.objectUID
        end
    end
    global:printError("L'uid n'est pas disponible")
    return -1
end

function GetMergedRuneId(id)
    for _, stat in pairs(PoidsByStat) do
        local runes = stat.Runes
        if #runes > 1 then
            if runes[1].Id == id then
                return runes[2].Id
            elseif #runes > 2 and runes[2].Id == id then
                return runes[3].Id
            end
        end
    end
    return 0
end

function GetUnMergedRuneId(id)
    for _, stat in pairs(PoidsByStat) do
        local runes = stat.Runes
        if #runes > 1 then
            if runes[2].Id == id then
                return runes[1].Id
            elseif #runes > 2 and runes[3].Id == id then
                return runes[2].Id
            end
        end
    end
    return 0
end

function GetUnMergedRune(id)
    for _, stat in pairs(PoidsByStat) do
        local runes = stat.Runes
        if #runes > 1 then
            if runes[2].Id == id then
                return runes[1]
            elseif #runes > 2 and runes[3].Id == id then
                return runes[2]
            end
        end
    end
    return nil
end

function GetPoidsRune(id)
    for _, stat in pairs(PoidsByStat) do
        local runes = stat.Runes
        for i, runeData in ipairs(runes) do
            if runeData.Id == id then
                return runeData.Poids
            end
        end
    end
end

function GetPriceRune(id)
    for _, rune in ipairs(RunesTransVita) do
        if rune.Id == id then
            return rune.Prices.AveragePrice and rune.Prices.AveragePrice or 0
        end
    end
    for _, stat in pairs(PoidsByStat) do
        local runes = stat.Runes
        for i, runeData in ipairs(runes) do
            if runeData.Id == id then
                return runeData.Prices.AveragePrice and runeData.Prices.AveragePrice or 0
            end
        end
    end
    return 0
end

function GetValueRune(id)
    for _, stat in pairs(PoidsByStat) do
        local runes = stat.Runes
        for i, runeData in ipairs(runes) do
            if runeData.Id == id then
                return runeData.Value
            end
        end
    end
end

function GetPriceByNumberRune(id)
    for _, stat in pairs(PoidsByStat) do
        local runes = stat.Runes
        for i, runeData in ipairs(runes) do
            if runeData.Id == id then
                return runeData.Prices.AveragePrice / i
            end
        end
    end
end


function GetStatByRune(runeId)
    for key, value in pairs(PoidsByStat) do
        for _, rune in ipairs(value.Runes) do
            if rune.Id == runeId then
                return key
            end
        end
    end
    global:printError("pas trouvé la clé de " .. inventory:itemNameId(runeId) .. " (" .. runeId .. ")")
end

function GetQualityItem(ItemStats, Id)
    Id = Id or IdToSell
    local PoidsItem = 0
    local PoidsMaxItem = 0
    local statsJP = GetDices(Id) -- y'a pas les %dommages et %resistance

    -- vérifier une première fois dans ce sens pour que les stats à 0 soient prises en compte
    for _, statJP in ipairs(statsJP) do
        local found = false
        for _, stat in ipairs(ItemStats) do
            if (tostring(stat) == "SwiftBot.ObjectEffectInteger" or stat.actionId) and stat.actionId == statJP.id and IsActionIdKnown(stat.actionId) and not GetNameCarac(stat.actionId):find("-") then
                found = true
                if stat.value > statJP.dice.max and (PoidsByStat[statJP.name].PoidsUnite < 30) and statJP.name == "Vitalite" then
                    PoidsItem = PoidsItem + (statJP.dice.max + (stat.value - statJP.dice.max) * 3) * PoidsByStat[statJP.name].PoidsUnite
                    PoidsMaxItem = PoidsMaxItem + statJP.dice.max * PoidsByStat[statJP.name].PoidsUnite
                elseif statJP.name == "Vitalite" then
                    PoidsItem = PoidsItem + stat.value * PoidsByStat[statJP.name].PoidsUnite * 2
                    PoidsMaxItem = PoidsMaxItem + statJP.dice.max * PoidsByStat[statJP.name].PoidsUnite * 2
                elseif (PoidsByStat[statJP.name].PoidsUnite < 30) then
                    PoidsItem = PoidsItem + stat.value * PoidsByStat[statJP.name].PoidsUnite
                    PoidsMaxItem = PoidsMaxItem + statJP.dice.max * PoidsByStat[statJP.name].PoidsUnite
                end
                break
            end
        end
        if not found then
            PoidsMaxItem = PoidsMaxItem + statJP.dice.max * PoidsByStat[statJP.name].PoidsUnite
        end
    end

    -- vérifier ensuite la présence d'exo
    for _, stat in ipairs(ItemStats) do
        if tostring(stat) == "SwiftBot.ObjectEffectInteger" and IsActionIdKnown(stat.actionId) and not GetNameCarac(stat.actionId):find("-") then
            local found = false
            for _, statJP in ipairs(statsJP) do
                if statJP.id == stat.actionId then
                    found = true
                end
            end
            if not found then
                PoidsItem = PoidsItem + PoidsByStat[GetNameCarac(stat.actionId)].PoidsUnite * stat.value * 2
            end
        end
    end
    return PoidsMaxItem > 0 and PoidsItem / PoidsMaxItem or 1
end

function GetQualityItemWithoutException(ItemStats, Id)

    debug("ok")
    Id = Id or IdToSell
    local PoidsItem = 0
    local PoidsMaxItem = 0
    local statsJP = GetDices(Id) -- y'a pas les %dommages et %resistance

    debug("ok")
    -- vérifier une première fois dans ce sens pour que les stats à 0 soient prises en compte
    for _, statJP in ipairs(statsJP) do
        local found = false
        for _, stat in ipairs(ItemStats) do
            if (tostring(stat) == "SwiftBot.ObjectEffectInteger" or stat.actionId) and stat.actionId == statJP.id and IsActionIdKnown(stat.actionId) and not GetNameCarac(stat.actionId):find("-") 
            and not IsInTable(STATS_TO_IGNORE, GetNameCarac(stat.actionId)) then
                found = true
                if stat.value > statJP.dice.max and (PoidsByStat[statJP.name].PoidsUnite < 30) and statJP.name == "Vitalite" then
                    PoidsItem = PoidsItem + (statJP.dice.max + (stat.value - statJP.dice.max) * 3) * PoidsByStat[statJP.name].PoidsUnite
                    PoidsMaxItem = PoidsMaxItem + statJP.dice.max * PoidsByStat[statJP.name].PoidsUnite
                elseif statJP.name == "Vitalite" then
                    PoidsItem = PoidsItem + stat.value * PoidsByStat[statJP.name].PoidsUnite * 2
                    PoidsMaxItem = PoidsMaxItem + statJP.dice.max * PoidsByStat[statJP.name].PoidsUnite * 2
                elseif (PoidsByStat[statJP.name].PoidsUnite < 30) then
                    PoidsItem = PoidsItem + stat.value * PoidsByStat[statJP.name].PoidsUnite
                    PoidsMaxItem = PoidsMaxItem + statJP.dice.max * PoidsByStat[statJP.name].PoidsUnite
                end
                break
            end
        end
        if not found and not IsInTable(STATS_TO_IGNORE, statJP.name) then
            PoidsMaxItem = PoidsMaxItem + statJP.dice.max * PoidsByStat[statJP.name].PoidsUnite
        end
    end

    -- vérifier ensuite la présence d'exo
    for _, stat in ipairs(ItemStats) do
        if tostring(stat) == "SwiftBot.ObjectEffectInteger" and IsActionIdKnown(stat.actionId) and not GetNameCarac(stat.actionId):find("-") then
            local found = false
            for _, statJP in ipairs(statsJP) do
                if statJP.id == stat.actionId then
                    found = true
                end
            end
            if not found then
                PoidsItem = PoidsItem + PoidsByStat[GetNameCarac(stat.actionId)].PoidsUnite * stat.value * 2
            end
        end
    end

    return PoidsMaxItem > 0 and PoidsItem / PoidsMaxItem or 1
end

function GetPoidsOver(ItemStats, Id)
    Id = Id or IdToSell
    local statsJp = GetDices(Id)
    local poidsOver = 0

    for i, stat in ipairs(ItemStats) do
        local found = false
        for j, statJP in ipairs(statsJp) do
            if (tostring(stat) == "SwiftBot.ObjectEffectInteger" or stat.actionId) and stat.actionId == statJP.id
            and IsActionIdKnown(stat.actionId) and not GetNameCarac(stat.actionId):find("-") and stat.value > statJP.dice.max then
                found = true
                poidsOver = poidsOver + (stat.value - statJP.dice.max) * PoidsByStat[GetNameCarac(stat.actionId)].PoidsUnite
                break
            end
        end
        -- pour les exo, on verra plus tard
        -- if not found and tostring(stat) == "SwiftBot.ObjectEffectInteger" and IsActionIdKnown(stat.actionId) and not GetNameCarac(stat.actionId):find("-") then
        --     poidsOver = poidsOver + stat.value * PoidsByStat[GetNameCarac(stat.actionId)].PoidsUnite
        -- end
    end   

    return poidsOver
end

function GetPoidsItem(Stats)
    Id = IdToSell
    local toReturn = 0
    local statsJP = GetDices(Id) -- y'a pas les %dommages et %resistance

    for i, stat in ipairs(Stats) do
        local trouvee = false
        for j, statJP in ipairs(statsJP) do
            if tostring(stat) == "SwiftBot.ObjectEffectInteger" and stat.actionId == statJP.id and IsActionIdKnown(stat.actionId) and not GetNameCarac(stat.actionId):find("-") then
                local over = stat.value - statJP.dice.max
                trouvee = true
                if over > 0 then
                    toReturn = toReturn + ((stat.value - over) + over * 2) * PoidsByStat[statJP.name].PoidsUnite
                else
                    toReturn = toReturn + stat.value * PoidsByStat[statJP.name].PoidsUnite
                end
                break
            end
        end
        if not trouvee and tostring(stat) == "SwiftBot.ObjectEffectInteger" and IsActionIdKnown(stat.actionId) and not GetNameCarac(stat.actionId):find("-") then
            toReturn = toReturn + stat.value * PoidsByStat[GetNameCarac(stat.actionId)].PoidsUnite
        end
    end
    return toReturn 
end

function GetPercentageMinimum(Id, CraftCost)
    local statsJP = GetDices(Id) -- y'a pas les %dommages et %resistance
    local focus = GetBestFocusOnJp(Id)
    if not statsJP or not focus then
        return 99999
    end
    local coefLevel = inventory:getLevel(Id) / 72.5
    local PuiTotal = 0
    local estimation = 0
    if focus ~= "No focus" then
        for _, stat in ipairs(statsJP) do
            if stat.name == focus then
                PuiTotal = PuiTotal + stat.dice.max * PoidsByStat[stat.name].PoidsUnite
            else
                PuiTotal = PuiTotal + stat.dice.max * (PoidsByStat[stat.name].PoidsUnite / 2)
            end
        end
        estimation = PuiTotal * PoidsByStat[focus].PrixParPoids * coefLevel
    else
        for _, stat in ipairs(statsJP) do
            local Pui = stat.dice.max * PoidsByStat[stat.name].PoidsUnite
            estimation = estimation + Pui * PoidsByStat[stat.name].PrixParPoids * coefLevel
        end
    end

    return estimation > 0 and 100 * (CraftCost / estimation) * 1.2 or 99999 -- on rajoute 20 % pour ne pas prendre de risque (on est sur du jp)
end

function GetBestFocusOnJp(Id)
    local statsJP = GetDices(Id) -- y'a pas les %dommages et %resistance
    local bestEstimation = 0
    local bestFocus = ""

    for i, statRef in ipairs(statsJP) do
        -- global:printSuccess(statRef.name)
        local PuiTotal = 0
        for _, stat in ipairs(statsJP) do
            if stat.name == statRef.name then
                PuiTotal = PuiTotal + stat.dice.max * PoidsByStat[stat.name].PoidsUnite
            else
                PuiTotal = PuiTotal + stat.dice.max * (PoidsByStat[stat.name].PoidsUnite / 2)
            end
        end
        if PuiTotal * PoidsByStat[statRef.name].PrixParPoids > bestEstimation then
            bestEstimation = PuiTotal * PoidsByStat[statRef.name].PrixParPoids
            -- global:printSuccess("Estimation focus [" .. statRef.name .. "] : " .. bestEstimation .. " k")
            bestFocus = statRef.name
        end
    end

    local estimationNoFocus = 0
    for _, stat in ipairs(statsJP) do
        local Pui = stat.dice.max * PoidsByStat[stat.name].PoidsUnite
        estimationNoFocus = estimationNoFocus + Pui * PoidsByStat[stat.name].PrixParPoids
    end

    if estimationNoFocus * 1.05 >= bestEstimation then -- des fois il y a le no focus est mal estimé
        bestFocus = "No focus"
    end

    return bestFocus
end

function GetBestFocus(ItemStats, Id)
    local statsJP = GetDices(Id) -- y'a pas les %dommages et %resistance
    local PuiTotal = 0
    local bestEstimation = 0
    local bestFocus = ""

    for i, statRef in ipairs(ItemStats) do
        local statName = ""
        for _, stat in ipairs(ItemStats) do
            for _, statJp in ipairs(statsJP) do
                if statJp.id == stat.actionId then
                    statName = statJp.name
                end
            end
            global:printSuccess(statName)
            if stat.actionId == statRef.actionId then
                PuiTotal = PuiTotal + stat.value * PoidsByStat[statName].PoidsUnite
            else
                PuiTotal = PuiTotal + stat.value * (PoidsByStat[statName].PoidsUnite / 2)
            end
        end
        if PuiTotal * PoidsByStat[statName].PrixParPoids > bestEstimation then
            bestEstimation = PuiTotal * PoidsByStat[statName].PrixParPoids
            bestFocus = statName
        end
        global:printSuccess(statName .. " : " .. PuiTotal * PoidsByStat[statName].PrixParPoids .. " k")
    end

    global:printSuccess("le meilleur focus est .. "  .. bestFocus)
    return bestFocus
end

function GetPoidsInfos(Id, StatRecherchee)
    local statsJP = GetDices(Id)
    local poidsTotal = 0
    local poidsStatRecherchee = 0


    for _, statJP in ipairs(statsJP) do
        if statJP.name == StatRecherchee then
            poidsStatRecherchee = statJP.dice.max * PoidsByStat[statJP.name].PoidsUnite
        end
        poidsTotal = poidsTotal + statJP.dice.max * PoidsByStat[statJP.name].PoidsUnite
    end

    return {
        Pourcentage = poidsStatRecherchee / poidsTotal,
        PoidsTotal = poidsTotal
    }
end

function MergeRunes()
    map:useById(521675, -2)
    local content = inventory:inventoryContent()

    for _, element in ipairs(content) do
        debug("Analyse de l'item [" .. inventory:itemNameId(element.objectGID) .. "] (" .. element.objectGID .. ")")
        debug("Type : " .. inventory:itemTypeId(element.objectGID) .. " - Nombre de runes disponibles pour fusion : " .. GetNumberOfMergeAvailable(element.objectGID))
        if inventory:itemTypeId(element.objectGID) == 78 and GetNumberOfMergeAvailable(element.objectGID) == 2 and inventory:itemCount(element.objectGID) > 29 then
            global:printMessage("Analyse des possibles fusions de [" .. inventory:itemNameId(element.objectGID) .. "]")
            local tabPriceByPui = {
                GetPriceByNumberRune(element.objectGID),
                GetPriceByNumberRune(GetMergedRuneId(element.objectGID)),
                GetPriceByNumberRune(GetMergedRuneId(GetMergedRuneId(element.objectGID)))
            }

            local MaxPrice = 0
            local IndexMaxPrice = 0
            for i, price in ipairs(tabPriceByPui) do
                if price > MaxPrice then
                    MaxPrice = price
                    IndexMaxPrice = i
                end
            end
            
            global:printSuccess("Il y a " .. (RunesInBank[tostring(element.objectGID)] and RunesInBank[tostring(element.objectGID)] or 0) .. " " .. inventory:itemNameId(element.objectGID) .. " en banque, on en a " .. inventory:itemCount(element.objectGID) .. " en inventaire")
            local NbToMerge = inventory:itemCount(element.objectGID)
            local NbToKeep =  500 - (RunesInBank[tostring(element.objectGID)] and RunesInBank[tostring(element.objectGID)] or 0)
            if NbToKeep > 0 and global:thisAccountController():getAlias():find("FM") then
                NbToMerge = NbToMerge - NbToKeep
            end

            if IndexMaxPrice == 2 and NbToMerge > 0 then
                global:printSuccess("On fusionne 1 fois")
                local quantity = math.floor(NbToMerge / 3)
                craft:putItem(element.objectGID, 3)
                global:delay(math.random(500, 1500))
                craft:changeQuantityToCraft(quantity)
                global:delay(math.random(500, 1500))
                craft:ready()
            elseif IndexMaxPrice == 3 and NbToMerge > 0 then
                global:printSuccess("On fusionne 2 fois")
                local quantity = math.floor(NbToMerge / 3)
                craft:putItem(element.objectGID, 3)
                global:delay(math.random(500, 1500))
                craft:changeQuantityToCraft(quantity)
                global:delay(math.random(500, 1500))
                craft:ready()
                global:delay(math.random(500, 1500))

                local nbNextRunes = inventory:itemCount(GetMergedRuneId(element.objectGID))
                global:printSuccess("Il y a " .. (RunesInBank[tostring(element.objectGID)] and RunesInBank[tostring(element.objectGID)] or 0) .. " " .. inventory:itemNameId(element.objectGID) .. " en banque, on en a " .. inventory:itemCount(element.objectGID) .. " en inventaire")
                NbToMerge = nbNextRunes
                NbToKeep =  500 - (RunesInBank[tostring(GetMergedRuneId(element.objectGID))] and RunesInBank[tostring(GetMergedRuneId(element.objectGID))] or 0)
                if NbToKeep > 0 then
                    NbToMerge = NbToMerge - NbToKeep
                end
                if NbToMerge > 2 then
                    craft:putItem(GetMergedRuneId(element.objectGID), 3)
                    craft:changeQuantityToCraft(NbToMerge / 3)
                    craft:ready()
                end
            end

        elseif inventory:itemTypeId(element.objectGID) == 78 and GetNumberOfMergeAvailable(element.objectGID) == 1 and inventory:itemCount(element.objectGID) > 29 then
            global:printMessage("Analyse des possibles fusions de [" .. inventory:itemNameId(element.objectGID) .. "]")
            local tabPriceByPui = {
                GetPriceByNumberRune(element.objectGID),
                GetPriceByNumberRune(GetMergedRuneId(element.objectGID)),
            }
            local MaxPrice = 0
            local IndexMaxPrice
            for i, price in ipairs(tabPriceByPui) do
                if price > MaxPrice then
                    MaxPrice = price
                    IndexMaxPrice = i
                end
            end
            
            global:printSuccess("Il y a " .. (RunesInBank[tostring(element.objectGID)] and RunesInBank[tostring(element.objectGID)] or 0) .. " " .. inventory:itemNameId(element.objectGID) .. " en banque, on en a " .. inventory:itemCount(element.objectGID) .. " en inventaire")
            local NbToMerge = inventory:itemCount(element.objectGID)
            local NbToKeep =  500 - (RunesInBank[tostring(element.objectGID)] and RunesInBank[tostring(element.objectGID)] or 0)
            if NbToKeep > 0 and global:thisAccountController():getAlias():find("FM") then
                NbToMerge = NbToMerge - NbToKeep
            end


            if IndexMaxPrice == 2 and NbToMerge > 0 then
                global:printSuccess("On fusionne 1 fois")
                local quantity = math.floor(NbToMerge / 3)
                craft:putItem(element.objectGID, 3)
                global:delay(math.random(500, 1500))
                craft:changeQuantityToCraft(quantity)
                global:delay(math.random(500, 1500))
                craft:ready()
            end

        end
    end
    global:leaveDialog()
end

function GetNameCarac(Id)
    if ID_TO_STAT_NAME[Id] then
        return ID_TO_STAT_NAME[Id]
    end
end

function GetIdCarac(name)
    for id, value in pairs(ID_TO_STAT_NAME) do
        if value == name then
            return id
        end
    end
end

function IsActionIdKnown(actionId)
    if ID_TO_STAT_NAME[actionId] then
        return true
    end
end

function IsItem(TypeId)
    if not TypeId then
        return false
    end
    local Ids = { 16, 17, 11, 10, 1, 9, 82, 151, 7, 19, 8, 6, 5, 2, 3, 4, 217, 248, 151, 178}
    for _, Id in ipairs(Ids) do
        if Id == TypeId then
            return true
        end
    end
    return false
end

function getRecipe(id)

    local recipe = d2data:objectFromD2O("Recipes", id)
    
    local ingredientsTable = {}
    
    if recipe == nil then
    
    else
        local ingredients = recipe.Fields["ingredientIds"]
        local quantities = recipe.Fields["quantities"]
        for i, ingredientId in ipairs(ingredients) do
            local ingredient = d2data:objectFromD2O("Items", ingredientId)
            local ingredientName = d2data:text(ingredient.Fields["nameId"])
            local ingredientQuantity = quantities[i]
            ingredientsTable[i] = { Id = ingredientId, Quantity = ingredientQuantity, Name = ingredientName }
        end
    end
    
    return ingredientsTable
    
end

function _GetResultBreak(message)
    developer:unRegisterMessage("DecraftResultMessage")
    message = message.results
    Pourcentage = math.floor(message[1].bonux_max * 100)
    EstimationGain = 0 

    for i = 1, #message[1].runes do
        for k, v in pairs(PoidsByStat) do
            for _, element in ipairs(v.Runes) do
                if element.Id == message[1].runes[i].quantity_rune_id_one then
                    global:printSuccess("[" .. inventory:itemNameId(message[1].runes[i].quantity_rune_id_one) .. "] : " .. math.min(element.Prices.AveragePrice, element.Prices.TrueAveragePrice) * message[1].runes.quantity_rune_id_two[i] .. " k")
                    EstimationGain = EstimationGain + (math.min(element.Prices.AveragePrice, element.Prices.TrueAveragePrice) * message[1].runesQty[i])
                end
            end
        end
    end

    global:printMessage("Nous avons obtenu " .. Pourcentage .. "% et " .. #message[1].runes ..  " runes différentes estimées à " .. EstimationGain)
end

function CanCraftNow(Id, jsonFile)
    for _, element in ipairs(jsonFile) do
        if element.server == character:server() then
            for _, id in ipairs(element.Temp) do
                if id == Id then
                    return false
                end
            end
            for _, data in ipairs(element.BrisagesEffectues) do
                if data.Id == Id 
                and (not isXDaysLater(data.DateBreak, 8) or (data.CoefMiniNeeded and (data.CoefMiniNeeded / data.CurrentCoef) > 1.5 and not isXDaysLater(data.DateBreak, 12))) then
                    return false
                end
            end
        end
    end
    return true
end

function SetNewTemp(temp, data)
    for _, element in ipairs(data) do
        if element.server == character:server() then
            element.Temp = temp
        end
    end

    -- Convertir la table Lua modifiée en JSON
    local new_content = json.encode(data)

    -- Écrire les modifications dans le fichier JSON
    file = io.open(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\Craft-Resell.json", "w")
    file:write(new_content)
    file:close()
end

function SetNewTempBrisage(temp, data)
    for _, element in ipairs(data) do
        if element.server == character:server() then
            element.Temp = temp
        end
    end

    -- Convertir la table Lua modifiée en JSON
    local new_content = json.encode(data)

    -- Écrire les modifications dans le fichier JSON
    file = io.open(global:getCurrentScriptDirectory() .. "\\Brisage.json", "w")
    file:write(new_content)
    file:close()
end

function CanCraftItem(Id, data)
    for _, element in ipairs(data) do
        if element.server == character:server() then
            for _, id in ipairs(element.Temp) do
                if id == Id then
                    return false
                end
            end
            if global:thisAccountController():getAlias():find("Craft2") then
                for _, item in ipairs(element.ItemsInHDV1) do
                    if item.Id == Id then
                        return false
                    end
                end
            else
                for _, item in ipairs(element.ItemsInHDV2) do
                    if item.Id == Id then
                        return false
                    end
                end
            end
        end
    end
    return true
end

function HasAllRessources(ListIdCraft)
    for _, ressource in ipairs(ListIdCraft) do
        if inventory:itemCount(ressource.Id) < ressource.Quantity then
            return false
        end
    end    
    return true
end

function AllStatsAreAboveMin(Stats, Id)
    local statsJP = GetDices(Id)

    for _, statJP in ipairs(statsJP) do
        for _, stat in ipairs(Stats) do
            if (tostring(stat) == "SwiftBot.ObjectEffectInteger" or stat.actionId) and stat.actionId == statJP.id and IsActionIdKnown(stat.actionId) and not GetNameCarac(stat.actionId):find("-") 
            and ((stat.value < statJP.dice.min) and not IsInTable(STATS_TO_IGNORE, GetNameCarac(stat.actionId))) then
                return false
            end
        end
    end
    return true
end

function GetDices(Id)
    local dices = {}
    local itemData = d2data:objectFromD2O("Items", Id)

    if not itemData then
        global:printError("not item data")

        return {}
    end

    itemData = itemData.FieldUseless

    for k, v in ipairs(itemData.possibleEffects) do
        local data = v.FieldUseless
        local effectName = ID_TO_STAT_NAME[tostring(data.effectId)]

        if effectName and not effectName:find("Degats") then
            table.insert(dices, {
                id = data.effectId,
                name = ID_TO_STAT_NAME[tostring(data.effectId)],
                dice = {
                    min = data.diceNum,
                    max = data.diceSide,
                },
            })
        end
    end

    return dices
end
