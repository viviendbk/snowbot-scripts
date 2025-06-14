 -- Read in JSON
 JSONFile = global:getCurrentScriptDirectory() .. "\\JSON.lua"
 JSON = (loadfile(JSONFile))()
 
 -- ServerID
 SERVER_ID_HISTORY = developer:historicalMessage("SelectedServerDataExtendedMessage")
 if SERVER_ID_HISTORY == nil or #SERVER_ID_HISTORY == 0 then
	 SERVER_ID_HISTORY = developer:historicalMessage("SelectedServerDataMessage")
 end
 SERVER_ID = SERVER_ID_HISTORY[1].serverId
 
 -- Minimum
 OFFER_MINIMUM = 4000
 
 function getRemainingSubscription(inDay, acc)
	 local accDeveloper = acc and acc.developer or developer
 
	 local endDate = developer:historicalMessage("IdentificationSuccessMessage")[1].subscriptionEndDate 
	 local now = os.time(os.date("!*t")) * 1000
 
	 endDate = math.floor((endDate - now) / 3600000)
 
	 return inDay and math.floor(endDate / 24) or endDate
 end
 
 -- Entry point
 
 function Abonnement(boolReconnect)
	 developer:sendMessage(developer:createMessage("HaapiShopApiKeyRequestMessage"))
	 developer:sendMessage(developer:createMessage("HaapiBufferListRequestMessage"))
	 if developer:suspendScriptUntil("HaapiShopApiKeyMessage", 10000, false) then
		 -------------------------------------------------------------------------------------------------------------------------------------------
		 global:printMessage("Récupération de ma quantité d'ogrines ...")
		 local result_OgrinsAmount = developer:dofusRequest("GET", "https://haapi.ankama.com/json/Ankama/v4/Money/OgrinsAmount?APIKEY="..APIKEY, APIKEY)
		 local my_ogrines = JSON:decode(result_OgrinsAmount).amount
		 global:printSuccess("Je possèdes maintenant "..my_ogrines.." ogrines.")
		 -------------------------------------------------------------------------------------------------------------------------------------------
		 local needed_ogrines = 1100
		 if not character:freeMode() then
			 needed_ogrines = 1000
		 end
		 needed_ogrines = math.max(needed_ogrines - my_ogrines, 0)
		 global:printMessage("Il me faut "..needed_ogrines.." pour s'abonner.")
		 if needed_ogrines == 0 then
			 subscribe()
			 return
		 end
		 -------------------------------------------------------------------------------------------------------------------------------------------
		 global:printMessage("Récupération de la liste des offres d'ogrines ...")
		 local result_GetOffersOgrines = developer:dofusRequest("GET", "https://haapi.ankama.com/json/Dofus/v3/Bak/Bid/GetOffersOgrines?order_dir=A&server_id="..SERVER_ID.."&order_by=rate&APIKEY="..APIKEY, APIKEY)
		 local offers_array = JSON:decode(result_GetOffersOgrines)
		 local offer_rate = nil
		 local offer_amount = nil
		 for _, offer in ipairs(offers_array.offers) do
			 if offer.ogrine >= OFFER_MINIMUM then
				 offer_rate = offer.rate
				 offer_amount = offer.ogrine
				 break
			 end
		 end
		 if offer_rate ~= nil and offer_amount ~= nil then
			 local needed_kamas = needed_ogrines * offer_rate
			 global:printSuccess("Offre choisie : "..offer_amount.." ogrines pour "..offer_rate.."/ogrine - Il me faut "..needed_ogrines.." ogrines pour "..needed_kamas.." kamas.")
			 if character:kamas() >= needed_kamas then
				 global:printMessage("Transaction en cours ...")
				 local HaapiConfirmationRequestMessage = developer:createMessage("HaapiConfirmationRequestMessage")
				 HaapiConfirmationRequestMessage.kamas = needed_kamas
				 HaapiConfirmationRequestMessage.ogrines = needed_ogrines
				 HaapiConfirmationRequestMessage.rate = offer_rate
				 HaapiConfirmationRequestMessage.action = 6
				 developer:sendMessage(HaapiConfirmationRequestMessage)
				 if developer:suspendScriptUntil("HaapiConfirmationMessage", 10000, false) then
					 global:printMessage("Confirmation en cours ...")
					 local HaapiValidationRequestMessage = developer:createMessage("HaapiValidationRequestMessage")
					 HaapiValidationRequestMessage.transaction = transaction_token
					 developer:sendMessage(HaapiValidationRequestMessage)
					 if developer:suspendScriptUntil("HaapiBuyValidationMessage", 10000, false) then
						 global:printMessage("Récupération de ma nouvelle quantité d'ogrines ...")
						 local result_OgrinsAmount = developer:dofusRequest("GET", "https://haapi.ankama.com/json/Ankama/v4/Money/OgrinsAmount?APIKEY="..APIKEY, APIKEY)
						 local my_ogrines = JSON:decode(result_OgrinsAmount).amount
						 global:printSuccess("Je possèdes maintenant "..my_ogrines.." ogrines.")
						 subscribe(boolReconnect)
						 return
					 else
						 global:printError("Impossible d'effectuer la confirmation.")
					 end
				 else
					 global:printError("Impossible d'effectuer la transaction.")
				 end
			 else
				 global:printError("Je n'ai pas suffisamment de kamas : "..character():kamas().." < "..needed_kamas)
			 end
		 else
			 global:printError("Impossible de trouver une offre d'ogrines, pensez à ajuster la valeur de OFFER_MINIMUM.")
		 end
	 else
		 global:printError("Impossible de récupérer APIKEY.")
	 end
 end
 
 -- Subscription
 function subscribe(boolReconnect)
	 global:printMessage("Abonnement en cours ...")
	 developer:dofusRequest("GET", "https://haapi.ankama.com/json/Ankama/v4/Shop/SimpleBuy?quantity=1&amount=0&currency=OGR&article_id=11020&APIKEY="..APIKEY, APIKEY)
	 global:printSuccess("Abonnement effectué !")
	 if not boolReconnect then
		 global:disconnect()
	 end
 end
 
 -- Message listening
 function messagesRegistering()
	 developer:registerMessage("HaapiShopApiKeyMessage", _HaapiShopApiKeyMessage)
	 developer:registerMessage("HaapiConfirmationMessage", _HaapiConfirmationMessage)
 end
 
 
 function _HaapiShopApiKeyMessage(message)
	 APIKEY = message.token
 end
 function _HaapiConfirmationMessage(message)
	 transaction_token = message.transaction
 end