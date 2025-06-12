--- [TOUCH] -> Easy Landes V0.3 <- ---

-----------------------------------------------------------
-- This script was made with love in morocco by BLACKLISTER°#8367 -- In this version i used a optimized 200 team IA so i didn't really needed the phoenix fonction but dm me on discord i'll be happy to help you through it.

-----------------------------------------------------------

---------------------------------------------
-- Nom :       Easy Landes
-- Zone :      Landes de sidimotes
-- Type :      Combats
--------------------------------------------------------------------------------------Depot----------------
banque = false  -- retour banque à la banque si banque = true
echange = true -- retour banque sur un bot banque alors = true
vendre = false  -- true pour vendre une fois full, false pour aller stocker en banque
------------------------------------------------------------------------------------------------------------
file = io.open("accountndc.txt", "r")
if file then
	file:close()
	for line in io.lines ("accountndc.txt") do
		global:printMessage("Bonjour " .. line .. " !")
	end
end

global:printMessage("[Info] Trajet créé par BLACKLISTER°#8367")

function debug_info()
	global:printSuccess("- Placez vous au zaap route sombre et sauvegarder le en cas de fail")
end

debug_info()

AUTO_DELETE = {}         -- Add the identifiers of the objects you want to delete 
GATHER = {254;38;1;75}              -- Add the identifiers of the resources you want to harvest 
MIN_MONSTERS = 2         -- Change the minimum number of monsters the bot will fight
MAX_MONSTERS = 4         -- Change the maximum number of monsters the bot will fight
OPEN_BAGS = true        -- Change the parameter to true to automatically open the harvest bags
FORBIDDEN_MONSTERS = {}  -- You can define the banned monsters in a group to fight. 
FORCE_MONSTERS = {301}      -- You can define the mandatory monsters in a group to fight.
------------------------------------------------------------------------------------------------------------
function echangeoubanque()
if echange then
  chat:sendPrivateMessage("mdp", "pseudo") ---> Premier paramètre : Mdp, Deuxième paramètre : Pseudo.
  global:delay(2000)
  exchange:launchExchangeWithPlayer(iddubotbanque) -----> ID du Player (/id pseudo dans la console SnowBot)
  global:delay(2000)
  if exchange:isInDialog() then
    exchange:putAllItemsExchange()
    kamas = exchange:storageKamas()
    exchange:putKamas(kamas)                                       
    exchange:ready()                   
  else
  	global:printError("Problème lors de l'échange ! 30s avant nouvelle tentative")
    global:delay(30000)
    echangeoubanque()
  end 

elseif banque then
npc:npcBank(-1)
    global:delay(400)
    exchange:putAllItemsExchange()
    global:delay(400)
    kamas = exchange:storageKamas()
    exchange:getKamas(kamas) 
    global:printSuccess("[Banque] : " .. kamas .. " Kamas. On les prend et on reprend la route")
    npc:leaveDialog()
    global:delay(300)
end

end
function tpbrakmar()
    npc:npcBuy()
    sale:buyItem(6964, 1, 300)
    global:printSuccess("Popo brak")
    global:leaveDialog()
    global:delay(400)
    inventory:useItem(6964)
    global:printSuccess("utilisée")
end
------------------------------------------------------------------------------------------------------------
function move()
 if global:maximumNumberFightsOfDay() == true then
    global:printError("[Info] Nombre de combat maximum atteint,reconnexion dans 4h ")
    global:reconnect(4)
  end
    return {
   	--[[-24,12]]   { map = "143372", path = "bottom(537)", done = false },
	--[[-24,13]]   { map = "143373", fight = true, path = "bottom(537)", done = false },
	--[[-24,14]]   { map = "143374", fight = true, path = "bottom(550)", done = false },
	--[[-24,15]]   { map = "143375", fight = true, path = "right(223)", done = false },
	--[[-23,15]]   { map = "142863", fight = true, path = "right(223)", done = false },
	--[[-22,15]]   { map = "142351", fight = true, path = "right(223)", done = false },
	--[[-21,15]]   { map = "141839", fight = true, path = "right(251)", done = false },
	--[[-20,15]]   { map = "141327", fight = true, path = "bottom(538)", done = false },
	--[[-20,16]]   { map = "141328", fight = true, path = "left(168)", done = false },
	--[[-21,16]]   { map = "141840", path = "left(168)", done = false },
	--[[-22,16]]   { map = "142352", fight = true, path = "left(196)", done = false },
	--[[-23,16]]   { map = "142864", fight = true, path = "left(224)", done = false },
	--[[-24,16]]   { map = "143376", fight = true, path = "left(196)", done = false },
	--[[-25,16]]   { map = "143888", fight = true, path = "left(196)", done = false },
	--[[-26,16]]   { map = "144400", fight = true, path = "left(224)", done = false },
	--[[-27,16]]   { map = "144912", fight = true, path = "left(224)", done = false },
	--[[-28,16]]   { map = "145424", fight = true, path = "bottom(544)", done = false },
	--[[-28,17]]   { map = "145425", fight = true, path = "right(167)", done = false },
	--[[-27,17]]   { map = "144913", fight = true, path = "right(139)", done = false },
	--[[-26,17]]   { map = "144401", fight = true, path = "right(195)", done = false },
	--[[-25,17]]   { map = "143889", fight = true, path = "right(195)", done = false },
	--[[-24,17]]   { map = "143377", fight = true, path = "right(195)", done = false },
	--[[-23,17]]   { map = "142865", fight = true, path = "right(251)", done = false },
	--[[-22,17]]   { map = "142353", fight = true, path = "right(279)", done = false },
	--[[-21,17]]   { map = "141841", path = "right(307)", done = false },
	--[[-20,17]]   { map = "141329", path = "bottom(537)", done = false },
	--[[-20,18]]   { map = "141330", fight = true, path = "left(308)", done = false },
	--[[-21,18]]   { map = "141842", fight = true, path = "left(280)", done = false },
	--[[-22,18]]   { map = "142354", fight = true, path = "left(308)", done = false },
	--[[-23,18]]   { map = "142866", fight = true, path = "left(280)", done = false },
	--[[-24,18]]   { map = "143378", fight = true, path = "left(280)", done = false },
	--[[-25,18]]   { map = "143890", fight = true, path = "left(280)", done = false },
	--[[-26,18]]   { map = "144402", fight = true, path = "left(280)", done = false },
	--[[-27,18]]   { map = "144914", fight = true, path = "bottom(539)", done = false },
	--[[-27,19]]   { map = "144915", fight = true, path = "right(139)", done = false },
	--[[-26,19]]   { map = "144403", fight = true, path = "right(209)", done = false },
	--[[-25,19]]   { map = "143891", fight = true, path = "right(223)", done = false },
	--[[-24,19]]   { map = "143379", fight = true, path = "right(251)", done = false },
	--[[-23,19]]   { map = "142867", fight = true, path = "right(279)", done = false },
	--[[-22,19]]   { map = "142355", fight = true, path = "right(307)", done = false },
	--[[-21,19]]   { map = "141843", fight = true, path = "right(321)", done = false },
	--[[-20,19]]   { map = "141331", fight = true, path = "bottom(534)", done = false },
	--[[-20,20]]   { map = "141332", fight = true, path = "left(28)", done = false },
	--[[-21,20]]   { map = "141844", fight = true, path = "left(70)", done = false },
	--[[-22,20]]   { map = "142356", fight = true, path = "left(98)", done = false },
	--[[-23,20]]   { map = "142868", fight = true, path = "left(42)", done = false },
	--[[-24,20]]   { map = "143380", fight = true, path = "left(42)", done = false },
	--[[-25,20]]   { map = "143892", fight = true, path = "left(28)", done = false },
	--[[-26,20]]   { map = "144404", fight = true, path = "left(14)", done = false },
	--[[-27,20]]   { map = "144916", fight = true, path = "left(28)", done = false },
	--[[-28,20]]   { map = "145428", fight = true, path = "left(70)", done = false },
	--[[-29,20]]   { map = "145940", fight = true, path = "left(56)", done = false },
	--[[-30,20]]   { map = "146452", fight = true, path = "bottom(542)", done = false },
	--[[-30,21]]   { map = "146453", fight = true, path = "right(97)", done = false },
	--[[-29,21]]   { map = "145941", fight = true, path = "right(111)", done = false },
	--[[-28,21]]   { map = "145429", fight = true, path = "right(139)", done = false },
	--[[-27,21]]   { map = "144917", fight = true, path = "right(167)", done = false },
	--[[-26,21]]   { map = "144405", fight = true, path = "right(125)", done = false },
	--[[-25,21]]   { map = "143893", fight = true, path = "right(13)", done = false },
	--[[-24,21]]   { map = "143381", fight = true, path = "right(13)", done = false },
	--[[-23,21]]   { map = "142869", done = false },
	--[[-23,21]]   { map = "142869", done = false },
	--[[-23,21]]   { map = "142869", path = "right(83)", done = false },
	--[[-22,21]]   { map = "142357", fight = true, path = "right(55)", done = false },
	--[[-21,21]]   { map = "141845", fight = true, path = "right(41)", done = false },
	--[[-20,21]]   { map = "141333", fight = true, path = "bottom(547)", done = false },
	--[[-20,22]]   { map = "141334", fight = true, path = "left(98)", done = false },
	--[[-21,22]]   { map = "141846", fight = true, path = "left(140)", done = false },
	--[[-22,22]]   { map = "142358", fight = true, path = "left(98)", done = false },
	--[[-23,22]]   { map = "142870", fight = true, path = "left(14)", done = false },
	--[[-24,22]]   { map = "143382", fight = true, path = "left(28)", done = false },
	--[[-25,22]]   { map = "143894", fight = true, path = "left(112)", done = false },
	--[[-26,22]]   { map = "144406", fight = true, path = "left(98)", done = false },
	--[[-27,22]]   { map = "144918", fight = true, path = "left(112)", done = false },
	--[[-28,22]]   { map = "145430", fight = true, path = "left(98)", done = false },
	--[[-29,22]]   { map = "145942", fight = true, path = "left(42)", done = false },
	--[[-30,22]]   { map = "146454", fight = true, path = "bottom(543)", done = false },
	--[[-30,23]]   { map = "146455", fight = true, path = "right(13)", done = false },
	--[[-29,23]]   { map = "145943", fight = true, path = "right(27)", done = false },
	--[[-28,23]]   { map = "145431", fight = true, path = "right(83)", done = false },
	--[[-27,23]]   { map = "144919", fight = true, path = "right(83)", done = false },
	--[[-26,23]]   { map = "144407", fight = true, path = "right(55)", done = false },
	--[[-25,23]]   { map = "143895", fight = true, path = "right(13)", done = false },
	--[[-24,23]]   { map = "143383", fight = true, path = "right(125)", done = false },
	--[[-23,23]]   { map = "142871", fight = true, path = "right(139)", done = false },
	--[[-22,23]]   { map = "142359", fight = true, path = "right(69)", done = false },
	--[[-21,23]]   { map = "141847", fight = true, path = "right(83)", done = false },
	--[[-20,23]]   { map = "141335", fight = true, path = "bottom(547)", done = false },
	--[[-20,24]]   { map = "141336", fight = true, path = "left(70)", done = false },
	--[[-21,24]]   { map = "141848", fight = true, path = "left(98)", done = false },
	--[[-22,24]]   { map = "142360", fight = true, path = "left(154)", done = false },
	--[[-23,24]]   { map = "142872", fight = true, path = "left(238)", done = false },
	--[[-24,24]]   { map = "143384", fight = true, path = "left(182)", done = false },
	--[[-25,24]]   { map = "143896", fight = true, path = "left(224)", done = false },
	--[[-26,24]]   { map = "144408", fight = true, path = "left(126)", done = false },
	--[[-27,24]]   { map = "144920", fight = true, path = "left(98)", done = false },
	--[[-28,24]]   { map = "145432", fight = true, path = "left(70)", done = false },
	--[[-29,24]]   { map = "145944", fight = true, path = "left(70)", done = false },
	--[[-30,24]]   { map = "146456", fight = true, path = "bottom(557)", done = false },
	--[[-30,25]]   { map = "146457", path = "right(27)", done = false },
	--[[-29,25]]   { map = "145945", fight = true, path = "right(83)", done = false },
	--[[-28,25]]   { map = "145433", fight = true, path = "right(83)", done = false },
	--[[-27,25]]   { map = "144921", fight = true, path = "right(55)", done = false },
	--[[-26,25]]   { map = "144409", fight = true, path = "right(27)", done = false },
	--[[-25,25]]   { map = "143897", fight = true, path = "right(41)", done = false },
	--[[-24,25]]   { map = "143385", fight = true, path = "right(97)", done = false },
	--[[-23,25]]   { map = "142873", fight = true, path = "right(69)", done = false },
	--[[-22,25]]   { map = "142361", fight = true, path = "right(83)", done = false },
	--[[-21,25]]   { map = "141849", fight = true, path = "right(111)", done = false },
	--[[-20,25]]   { map = "141337", fight = true, path = "bottom(548)", done = false },
	--[[-20,26]]   { map = "141338", fight = true, path = "left(42)", done = false },
	--[[-21,26]]   { map = "141850", fight = true, path = "left(84)", done = false },
	--[[-22,26]]   { map = "142362", fight = true, path = "left(112)", done = false },
	--[[-23,26]]   { map = "142874", fight = true, path = "left(140)", done = false },
	--[[-24,26]]   { map = "143386", fight = true, path = "left(154)", done = false },
	--[[-25,26]]   { map = "143898", fight = true, path = "left(70)", done = false },
	--[[-26,26]]   { map = "144410", fight = true, path = "left(42)", done = false },
	--[[-27,26]]   { map = "144922", fight = true, path = "left(28)", done = false },
	--[[-28,26]]   { map = "145434", fight = true, path = "left(28)", done = false },
	--[[-29,26]]   { map = "145946", fight = true, path = "left(28)", done = false },
	--[[-30,26]]   { map = "146458", fight = true, path = "bottom(555)", done = false },
	--[[-30,27]]   { map = "146459", fight = true, path = "right(111)", done = false },
	--[[-29,27]]   { map = "145947", fight = true, path = "right(153)", done = false },
	--[[-28,27]]   { map = "145435", fight = true, path = "right(69)", done = false },
	--[[-27,27]]   { map = "144923", fight = true, path = "right(41)", done = false },
	--[[-26,27]]   { map = "144411", fight = true, path = "right(41)", done = false },
	--[[-25,27]]   { map = "143899", fight = true, path = "right(41)", done = false },
	--[[-24,27]]   { map = "143387", fight = true, path = "right(83)", done = false },
	--[[-23,27]]   { map = "142875", fight = true, path = "right(97)", done = false },
	--[[-22,27]]   { map = "142363", fight = true, path = "right(83)", done = false },
	--[[-21,27]]   { map = "141851", fight = true, path = "right(41)", done = false },
	--[[-20,27]]   { map = "141339", fight = true, path = "bottom(534)", done = false },
	--[[-20,28]]   { map = "141340", fight = true, path = "left(112)", done = false },
	--[[-21,28]]   { map = "141852", fight = true, path = "left(126)", done = false },
	--[[-22,28]]   { map = "142364", fight = true, path = "left(140)", done = false },
	--[[-23,28]]   { map = "142876", fight = true, path = "left(126)", done = false },
	--[[-24,28]]   { map = "143388", fight = true, path = "left(140)", done = false },
	--[[-25,28]]   { map = "143900", fight = true, path = "left(126)", done = false },
	--[[-26,28]]   { map = "144412", fight = true, path = "left(98)", done = false },
	--[[-27,28]]   { map = "144924", fight = true, path = "left(42)", done = false },
	--[[-28,28]]   { map = "145436", fight = true, path = "left(42)", done = false },
	--[[-29,28]]   { map = "145948", fight = true, path = "left(28)", done = false },
	--[[-30,28]]   { map = "146460", fight = true, path = "left(98)", done = false },
	--[[-31,28]]   { map = "146972", fight = true, path = "top(25)", done = false },
   }
end


function bank()
    return {
 	--[[-1,24]]    { map = "88212481", custom = tpbrakmar },
	--[[-26,36]]   { map = "13631488", path = "490", done = false },
	--[[-26,36]]   { map = "144420", path = "top(6)", done = false },
	--[[-27,36]]   { map = "-27,36", path = "left", done = false },
   { map = "144931", door = "218" },  
   { map = "8913935",custom = echangeoubanque },  
   }
end

function phenix()
    return {
   }
end