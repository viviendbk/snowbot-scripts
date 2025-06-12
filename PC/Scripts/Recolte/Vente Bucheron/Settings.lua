-- remplacer nil par le numéro qui est écrit dans le noms du fichier du script principal
NumeroScript = nil
-- liste des consommable que le bot tenta d'acheter pour remonter son énergie s'il en a moins de 50% 
tableAchatEnergie = {
    {name = "Pain des champs", id = 1737},
    {name = "Potion axel raide", id = 16722},
    {name = "Potion Raide izdaide", id = 16414},
    {name = "Estouffade de Morue", id = 16481},
    {name = "Filet Mignon", id = 17199},
    {name = "Aileron de Requin", id = 1838},
    {name = "Daube aux Epices", id = 17195},
    {name = "Mantou", id = 527},
    {name = "Andouillette de Gibier", id = 17203},
    {name = "Espadon Poellé", id = 16485},
    {name = "Espadon Poellé", id = 16485},
    {name = "Aile de Raie", id = 1814},
}

-- si vous voulez que la fonction EditAlias soit appelée à chaque changement de map, mettez true (vous êtes libre de changer la fonction comme vovus le souhaitez)
EDIT_ALIAS = false
function EditAlias()
    global:editAlias("Bucheron " .. character:server() .. " [" .. job:level(2) .. "]", true)
end

--- PARTIE INTERACTION BOT BANK ---

-- activer l'interation bot bank?
BANK_ACTIVATED = false

-- L'alias du bot bot doit être de la forme bank_[nom du server en minuscule] ex : bank_imagiro. Vous etes libre de changer le mot clé "bank"
receiverAlias = "bank"

-- trajet vers la config à lancer sur le bot bank (nil = pas de config à mettre dessus)
CONFIG_BANK = nil

-- trajet vers le script à mettre sur le bot bank (nil = pas de script à mettre dessus)
SCRIPT_BANK = nil 

-- lancer le script sur le bot bank?
LAUNCH = false

-- Montant de kamas que le bot farm devra garder 
minKamas = 250000

-- Montant de kamas qui déclenchera le transfert au bot bank
givingTriggerValue = 2000000

-- Temps d'attente maximal de la connexion du bot bank (en secondes)
maxWaitingTime = 120

-- Temps d'attente avant de réessayer de connecter le bot bank (en heures)
minRetryHours = 6

--- PARTIE RETOUR BANK ---


--- PARTIE ABONNEMENT ---
-- chemin du script abonnement (remplacer nil par le chemin)
PATH = nil
if PATH then
    dofile(PATH)
end

-- nb de jours d'abonnement restants à partir duquel le script essaie de s'abonner
NbJoursRestantsTrigger = 1
-- nb de kamas nécessaire à partir duquel le script essaie de s'abonner (en prenant en compte la variable d'au dessus)
NbKamasMiniToTryAbonnement = 1200000

--- PARTIE ABONNEMENT ---