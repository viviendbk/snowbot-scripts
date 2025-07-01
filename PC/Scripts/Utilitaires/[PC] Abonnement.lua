dofile("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Utilitaires\\[PC] Abonnement Previous.lua")
---------------------------------------------------------------------------
-- Script d’abonnement : version « getRequest2 » (remplace dofusRequest) ---
---------------------------------------------------------------------------
-- 📦  Dépendances ---------------------------------------------------------
local JSONFile = "C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Utilitaires\\JSON.lua"
local JSON     = (loadfile(JSONFile))()

-- 🔧  Paramètres ----------------------------------------------------------
local OFFER_MINIMUM = 4500

-- 🌐  Wrapper GET ---------------------------------------------------------
--  Remplace developer:dofusRequest("GET", …) par developer:getRequest2.
--  (getRequest2 gère automatiquement le proxy du compte SwiftBot.)
local function haapiGet(url, key)
    local headersName    = { "apikey" }
    local headersContent = { key }
    return developer:getRequest2(url, headersName, headersContent) -- pas d’upload de body
end

---------------------------------------------------------------------------
-- Variables globales ------------------------------------------------------
---------------------------------------------------------------------------
APIKEY = nil            -- token Haapi
local transaction_token -- token de transaction lors de l’achat
local SERVER_ID

---------------------------------------------------------------------------
-- Point d’entrée ----------------------------------------------------------
---------------------------------------------------------------------------
function Abonnement()
    debug("abonnement")
    -----------------------------------------------------------------------
    -- 1️⃣  Obtention de l’API‑Key Haapi
    -----------------------------------------------------------------------
    APIKEY = nil
    developer:sendMessage(developer:createMessage("HaapiShopApiKeyRequestMessage"))
    developer:sendMessage(developer:createMessage("HaapiBufferListRequestMessage"))
    developer:suspendScriptUntil("HaapiShopApiKeyMessage", 10000, false)

    if not APIKEY then
        global:printError("⛔ abonnement nouveau APIKEY is nil. Cannot continue.")
        return
    end

    -----------------------------------------------------------------------
    -- 2️⃣  Détermination du SERVER_ID courant
    -----------------------------------------------------------------------
    local serverName = character:server()
    local SERVERS = {
        ["Hell Mina"] = 294, ["Tylezia"] = 293, ["Imagiro"] = 291,
        ["Tal Kasha"] = 290, ["Draconiros"] = 295, ["Orukam"] = 292,
        ["Ombre"] = 50, ["Tournois"] = 99,  ["Rafal"] = 350,
        ["Brial"] = 351, ["Salar"] = 352, ["Dakal"] = 353,
        ["Mikhal"] = 354, ["Kourial"] = 355
    }
    SERVER_ID = SERVERS[serverName]
    if not SERVER_ID then
        global:printError("⛔ Serveur non reconnu : " .. tostring(serverName))
        return
    end

    global:printMessage("🔍 SERVER_ID = " .. SERVER_ID)

    -----------------------------------------------------------------------
    -- 3️⃣  Quantité d’ogrines actuelle
    -----------------------------------------------------------------------
    global:printMessage("Récupération de ma quantité d'ogrines …")
    local rawAmount = haapiGet("https://haapi.ankama.com/json/Ankama/v4/Money/OgrinsAmount", APIKEY)
    if not rawAmount or rawAmount:sub(1,1) ~= "{" then
        global:printError("❌ Impossible de récupérer la quantité d’ogrines.")
        return
    end
    local my_ogrines = (JSON:decode(rawAmount) or {}).amount or 0
    global:printSuccess("Je possède maintenant " .. my_ogrines .. " ogrines.")

    -----------------------------------------------------------------------
    -- 4️⃣  Calcul des ogrines nécessaires pour l’abonnement
    -----------------------------------------------------------------------
    local needed_ogrines_target = character:freeMode() and 1500 or 1400
    local needed_ogrines        = math.max(needed_ogrines_target - my_ogrines, 0)
    global:printMessage("Il me faut " .. needed_ogrines .. " ogrines pour s'abonner.")

    if needed_ogrines == 0 then
        subscribe(needed_ogrines_target, 17132)
        return
    end

    -----------------------------------------------------------------------
    -- 5️⃣  Récupération des offres d’ogrines
    -----------------------------------------------------------------------
    global:printMessage("Récupération de la liste des offres d'ogrines …")
    local url = "https://haapi.ankama.com/json/Dofus/v3/Bak/Bid/GetOffersOgrines?order_dir=A&server_id=" .. SERVER_ID .. "&order_by=rate"
    local rawOffers = haapiGet(url, APIKEY)
    if not rawOffers or rawOffers:sub(1,1) ~= "{" then
        global:printError("❌ Réponse invalide lors de la récupération des offres.")
        global:printError("Contenu brut: " .. tostring(rawOffers))
        return
    end

    local offers_array = JSON:decode(rawOffers)
    local offer_rate, offer_amount
    for _, offer in ipairs(offers_array.offers) do
        if offer.ogrine >= 3300 then
            offer_rate, offer_amount = offer.rate, offer.ogrine
            break
        end
    end

    if not offer_rate or not offer_amount then
        global:printError("❌ Impossible de trouver une offre d'ogrines satisfaisante.")
        return
    end

    local needed_kamas = needed_ogrines * offer_rate
    global:printSuccess("Offre choisie : " .. offer_amount .. " ogrines à " .. offer_rate .. " k/ogr. Il faut " .. needed_kamas .. " kamas.")

    if character:kamas() < needed_kamas then
        global:printError("Je n'ai pas assez de kamas : " .. character:kamas() .. " < " .. needed_kamas)
        global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Utilitaires\\take-kamas.lua")
        return
    end

    -----------------------------------------------------------------------
    -- 6️⃣  Transaction Haapi (conserve dofusRequest pour POST/SHOP) -------
    -----------------------------------------------------------------------
    global:printMessage("Transaction en cours …")
    global:delay(5000)

    local confirm = developer:createMessage("HaapiConfirmationRequestMessage")
    confirm.kamas     = needed_kamas
    confirm.ogrines   = needed_ogrines
    confirm.rate      = offer_rate
    confirm.action    = 6
    developer:sendMessage(confirm)

    if not developer:suspendScriptUntil("HaapiConfirmationMessage", 10000, false) then
        global:printError("Impossible d'effectuer la transaction.")
        return
    end

    global:printMessage("Confirmation en cours …")
    local validate = developer:createMessage("HaapiValidationRequestMessage")
    validate.transaction = transaction_token
    developer:sendMessage(validate)

    if not developer:suspendScriptUntil("HaapiBuyValidationMessage", 10000, false) then
        global:printError("Impossible de confirmer l'achat.")
        return
    end

    -----------------------------------------------------------------------
    -- 7️⃣  Vérification finale de la quantité d’ogrines
    -----------------------------------------------------------------------
    local updated = haapiGet("https://haapi.ankama.com/json/Ankama/v4/Money/OgrinsAmount?APIKEY=" .. APIKEY, APIKEY)
    local new_amount = (updated and updated:sub(1,1) == "{" and JSON:decode(updated).amount) or my_ogrines
    global:printSuccess("Je possède maintenant " .. new_amount .. " ogrines.")

    subscribe(needed_ogrines_target, 17132)

    global:disconnect()
end

---------------------------------------------------------------------------
-- Abonnement en ogrines (⚠️ garde dofusRequest "SHOP" pour POST JSON) ----
---------------------------------------------------------------------------
local function shopRequest(url, token, body)
    -- getRequest2 ne gérant pas le POST, on conserve dofusRequest pour cette partie
    return developer:dofusRequest("SHOP", url, token, body)
end

function subscribe(amount, article_id)
    global:printMessage("Abonnement en cours …")
    global:delay(5000)

    -- 1. Récupération du token boutique
    local tokenResp = JSON:decode(haapiGet("https://haapi.ankama.com/json/Ankama/v5/Account/GetAccessTokenFromAnkamaApiKey", APIKEY) or "{}")
    local shopToken = tokenResp.token
    if not shopToken then
        global:printError("[1] Échec — impossible de récupérer le token boutique.")
        return
    end
    global:printSuccess("[1] Token boutique OK")

    -- 2. Création du panier
    local cartBody = '{"cart_details":[{"discriminator":"CartDetailClassicRequest","cart_detail_classic_request":{"article_id":"' .. article_id .. '","quantity":1,"chosen_references":[{"reference_id":"10","line_number":0,"quantity":7},{"reference_id":"18273","line_number":1,"quantity":7}]}}]}'
    local carts = JSON:decode(shopRequest("https://shop-api.ankama.com/fr/shops/DOFUS_UNITY_INGAME/carts", shopToken, cartBody) or "{}")
    if not carts.id then
        global:printError("[2] Échec — création du panier.")
        return
    end
    global:printSuccess("[2] Panier créé : " .. carts.id)

    -- 3. Création de la commande
    local orderBody = '{"account_id":"' .. character:accountId() .. '","payment":{"discriminator":"VIRTUAL","virtual_payment_request":{"payment_mode_id":"OG","currency":"OGR","amount":' .. amount .. '.0}},"options":[]}'
    local orders = JSON:decode(shopRequest("https://shop-api.ankama.com/fr/shops/DOFUS_UNITY_INGAME/carts/" .. carts.id .. "/orders", shopToken, orderBody) or "{}")
    if not orders.id then
        global:printError("[3] Échec — création de la commande.")
        AbonnementPrevious()
        return
    end
    global:printSuccess("[3] OrderID : " .. orders.id)

    -- 4. Paiement
    local paymentBody = '{"order_id":"' .. orders.id .. '"}'
    local payment = JSON:decode(shopRequest("https://shop-api.ankama.com/fr/shops/DOFUS_UNITY_INGAME/payment/providers/ankama/types/ogrine:create-payment", "", paymentBody) or "{}")
    if payment.payment_id then
        global:printSuccess("Abonnement effectué avec succès !")
        global:disconnect()
    else
        global:printError("Échec du paiement !")
    end

    
end

---------------------------------------------------------------------------
-- Écoute des messages réseaux --------------------------------------------
---------------------------------------------------------------------------
-- function messagesRegistering()
--     developer:registerMessage("HaapiShopApiKeyMessage", function(msg) APIKEY = msg.token end)
--     developer:registerMessage("HaapiConfirmationMessage", function(msg) transaction_token = msg.transaction end)
-- end

function _HaapiShopApiKeyMessage(msg)
    APIKEY = msg.token
end

function _HaapiConfirmationMessage(msg)
    transaction_token = msg.transaction
end
