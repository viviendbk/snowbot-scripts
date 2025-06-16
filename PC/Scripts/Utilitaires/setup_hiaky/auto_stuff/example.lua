
--- <init>

-- chemin vers le dossier "autostuff"
-- /!\ dossiers séparés par des \\ /!\
PATH = "D:\\tmp_on_dev\\lua\\advanced\\auto_stuff"
-- /!\ A mettre aussi dans le fichier "buyer.lua" /!\

local Buyer = dofile(PATH .. "\\classes\\buyer.lua")


---- /!\ --- /!\ --- /!\ --- /!\ ---
---  /!\ ------ À LIRE ----- /!\ ---
---- /!\ --- /!\ --- /!\ --- /!\ ---

-- Pour acheter un item, il est indispensable d'avoir
--  configuré les conditions d'achats dans le
--  fichier "items_config.json"

-- modèle (format json) :
--[[
    {
        -- requis
        "id": 8463,

        -- optionnel
        "name": "Abracaska Ancestral",

        -- optionnel
        "maxPrice": 250000,

        -- optionnel
        "minQuality": 60,
        
        -- optionnel
        "ignore": [ "Prospection" ],

        -- optionnel
        --  /!\ fonctionne pour les exos /!\
        "over": {
            "name": "Vitalite",
            "min": 240
        },

        -- optionnel
        "jets": [
            {

                -- /!\ --- /!\ -- /!\

                Nom de caractéristique :
                    - majuscule à la première lettre
                    - aucun accent

                -- /!\ --- /!\ -- /!\

                "name": "Vitalite",
                "min": 161
            },
            {
                "name": "Force",
                "min": 26
            },
            {
                "name": "Sagesse",
                "min": 10
            },
            {
                "name": "Dommages",
                "min": 5
            }
        ]
    }
]] 

--- /!\ --- /!\ --- /!\ --- /!\ ---
--- /!\ --- /!\ --- /!\ --- /!\ ---
--- /!\ --- /!\ --- /!\ --- /!\ ---



function example()

    -------------------------------
    ------- ACHETER UN ITEM -------
    -------------------------------

    local function buyAnItem()
        local item = {

            -- id de l'item
            id = 8463,

            -- écart maximal de prix entre le
            --  meilleur item vanilla et
            --  le meilleur over
            maxPriceDiff = 100000,
            
            -- over demandé (optionnel)
            wantedOver = "Vitalite"
        }

        -- création d'une instance de la class Buyer
        local buyerInstance = Buyer:new(item)
        
        -- processus d'achat
        --  => la méthode retourne true/false selon
        --   le succès ou l'échec
        return buyerInstance:process()
    end

    -------------------------------
    -------------------------------


    -------------------------------
    --- ACHETER PLUSIEURS ITEMS ---
    -------------------------------

    local function buyManyItems()
        local items = {
            {
                id = 8463,
                maxPriceDiff = 100000,
                wantedOver = "Vitalite"
            },
            {
                id = 8464,
                maxPriceDiff = 150000,
                wantedOver = "Vitalite"
            }
        }

        -- processus d'achat de plusieurs items
        --  /!\ méthode statique (ne pas appeler via instance) /!\
        return buyWorthItem(items)
        --  => retourne une table ipairs :
            --[[
                {
                    { id = <id de l'item>, success = <true/false> }
                }
            ]]
    end

    -------------------------------
    -------------------------------
end