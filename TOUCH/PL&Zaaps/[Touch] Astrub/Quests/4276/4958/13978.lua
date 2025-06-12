----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
dofile(string.gsub(quest:mainPath(), "main.lua", "headers.lua"))
OBJECTIVE_MAPS = { }
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
function move()

    -- Vérifier si tout est bon
    check()

    -- Mes actions
    return {
        { map = "146276352", custom = func1, path = "451" },
        { map = "145490947", custom = func2 },
        { map = "145490435", path = "right" },
    }
end
function func1()
    if ATTACK_SPELLS[tostring(character:breed())] == -1 then
        inventory:equipItem(18852, 6) -- Coiffe
        global:delay(global:random(300, 500))
        inventory:equipItem(18850, 7) -- Cape
        global:delay(global:random(300, 500))
        inventory:equipItem(18858, 5) -- Bottes
        global:delay(global:random(300, 500))
        inventory:equipItem(18860, 3) -- Ceinture
        global:delay(global:random(300, 500))
        inventory:equipItem(18856, 2) -- Anneau
        global:delay(global:random(300, 500))
        inventory:equipItem(18854, 0) -- Amulette
        global:delay(global:random(300, 500))
        inventory:equipItem(18864, 15) -- Bouclier
        global:delay(global:random(300, 500))
        inventory:equipItem(18862, 1) -- Arme
        global:delay(global:random(300, 500))
    elseif ATTACK_SPELLS[tostring(character:breed())] == -2 then
        inventory:equipItem(18866, 6) -- Coiffe
        global:delay(global:random(300, 500))
        inventory:equipItem(18872, 7) -- Cape
        global:delay(global:random(300, 500))
        inventory:equipItem(18896, 5) -- Bottes
        global:delay(global:random(300, 500))
        inventory:equipItem(18884, 3) -- Ceinture
        global:delay(global:random(300, 500))
        inventory:equipItem(18878, 2) -- Anneau
        global:delay(global:random(300, 500))
        inventory:equipItem(18890, 0) -- Amulette
        global:delay(global:random(300, 500))
        inventory:equipItem(18902, 15) -- Bouclier
        global:delay(global:random(300, 500))
        inventory:equipItem(18908, 1) -- Arme
        global:delay(global:random(300, 500))
    elseif ATTACK_SPELLS[tostring(character:breed())] == -3 then
        inventory:equipItem(18868, 6) -- Coiffe
        global:delay(global:random(300, 500))
        inventory:equipItem(18874, 7) -- Cape
        global:delay(global:random(300, 500))
        inventory:equipItem(18898, 5) -- Bottes
        global:delay(global:random(300, 500))
        inventory:equipItem(18886, 3) -- Ceinture
        global:delay(global:random(300, 500))
        inventory:equipItem(18880, 2) -- Anneau
        global:delay(global:random(300, 500))
        inventory:equipItem(18892, 0) -- Amulette
        global:delay(global:random(300, 500))
        inventory:equipItem(18904, 15) -- Bouclier
        global:delay(global:random(300, 500))
        inventory:equipItem(18910, 1) -- Arme
        global:delay(global:random(300, 500))
    elseif ATTACK_SPELLS[tostring(character:breed())] == -4 then
        inventory:equipItem(18870, 6) -- Coiffe
        global:delay(global:random(300, 500))
        inventory:equipItem(18876, 7) -- Cape
        global:delay(global:random(300, 500))
        inventory:equipItem(18900, 5) -- Bottes
        global:delay(global:random(300, 500))
        inventory:equipItem(18888, 3) -- Ceinture
        global:delay(global:random(300, 500))
        inventory:equipItem(18882, 2) -- Anneau
        global:delay(global:random(300, 500))
        inventory:equipItem(18894, 0) -- Amulette
        global:delay(global:random(300, 500))
        inventory:equipItem(18906, 15) -- Bouclier
        global:delay(global:random(300, 500))
        inventory:equipItem(18912, 1) -- Arme

    end
end
function func2()
    npc:npc(3890, 3)
    npc:reply(-1)
    npc:reply(-1)
    global:loadAndStart(MAIN_SCRIPT_PATH)
end
-- -1 = Terre
-- -2 = Feu
-- -3 = Eau
-- -4 = Air
ATTACK_SPELLS = {
    ["1"] = -2, -- Féca
    ["2"] = -3, -- Osamodas
    ["3"] = -3, -- Enutrof
    ["4"] = -1, -- Sram
    ["5"] = -2, -- Xélor
    ["6"] = -1, -- Ecaflip
    ["7"] = -3, -- Eniripsa
    ["8"] = -4, -- Iop
    ["9"] = -1, -- Crâ
    ["10"] = -1, -- Sadida
    ["11"] = -1, -- Sacrieur
    ["12"] = -1, -- Pandawa
    ["13"] = -2, -- Roublard
    ["14"] = -1, -- Zobal
    ["15"] = -1, -- Steamer
}
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------