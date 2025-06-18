const express = require('express');
const fs = require('fs');
const path = require('path');
const app = express();
const PORT = 3000;

app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

const dataFile = path.join(__dirname, 'data.json');

// 📂 Chargement des données existantes
let stats = {};
if (fs.existsSync(dataFile)) {
  try {
    stats = JSON.parse(fs.readFileSync(dataFile));
  } catch (err) {
    console.error("[ERREUR] Chargement JSON:", err);
  }
}

// 💾 Sauvegarde dans le fichier
function save() {
  fs.writeFileSync(dataFile, JSON.stringify(stats, null, 2));
}

// 📥 Route de réception des kamas
app.post('/api/kamas', (req, res) => {
  const { date, pseudo, serveur, kamas } = req.body;
  if (!date || !pseudo || !serveur || kamas == null)
    return res.status(400).send("Requête invalide");

  if (!stats[date]) stats[date] = {};
  if (!stats[date][serveur]) stats[date][serveur] = {};
  if (!stats[date][serveur][pseudo]) stats[date][serveur][pseudo] = {};

  const joueur = stats[date][serveur][pseudo];
  if (!joueur.kamas) {
    joueur.kamas = { lastTotal: kamas, gain: 0 };
  } else {
    const diff = kamas - joueur.kamas.lastTotal;
    if (diff > 0) joueur.kamas.gain += diff;
    joueur.kamas.lastTotal = kamas;
  }

  joueur.lastSeen = Date.now();
  save();
  console.log(`[OK] ${pseudo} (${serveur}) : +${kamas} kamas`);
  res.send("Enregistré");
});

// 📥 Route de réception des roses
app.post('/api/roses', (req, res) => {
  const { date, pseudo, serveur, roses } = req.body;
  if (!date || !pseudo || !serveur || roses == null)
    return res.status(400).send("Requête invalide");

  if (!stats[date]) stats[date] = {};
  if (!stats[date][serveur]) stats[date][serveur] = {};
  if (!stats[date][serveur][pseudo]) stats[date][serveur][pseudo] = {};

  const joueur = stats[date][serveur][pseudo];
  if (!joueur.roses) {
    joueur.roses = { lastTotal: roses, gain: 0 };
  } else {
    const diff = roses - joueur.roses.lastTotal;
    if (diff > 0) joueur.roses.gain += diff;
    joueur.roses.lastTotal = roses;
  }

  joueur.lastSeen = Date.now();
  save();
  console.log(`[OK] ${pseudo} (${serveur}) : +${roses} roses`);
  res.send("Enregistré");
});

// 📥 Route de réception des kolizetons
app.post('/api/kolizetons', (req, res) => {
  const { date, pseudo, serveur, kolizetons } = req.body;
  if (!date || !pseudo || !serveur || kolizetons == null)
    return res.status(400).send("Requête invalide");

  if (!stats[date]) stats[date] = {};
  if (!stats[date][serveur]) stats[date][serveur] = {};
  if (!stats[date][serveur][pseudo]) stats[date][serveur][pseudo] = {};

  const joueur = stats[date][serveur][pseudo];
  if (!joueur.kolizetons) {
    joueur.kolizetons = { lastTotal: kolizetons, gain: 0 };
  } else {
    const diff = kolizetons - joueur.kolizetons.lastTotal;
    if (diff > 0) joueur.kolizetons.gain += diff;
    joueur.kolizetons.lastTotal = kolizetons;
  }

  joueur.lastSeen = Date.now();
  save();
  console.log(`[OK] ${pseudo} (${serveur}) : +${kolizetons} kolizetons`);
  res.send("Enregistré");
});

// 📥 Route de réception du profil
app.post('/api/bots', (req, res) => {
  const { date, pseudo, serveur, classe, niveau, identifiant, motDePasse } = req.body;
  if (!date || !pseudo || !serveur || !classe || !niveau || !identifiant)
    return res.status(400).send("Requête invalide");

  if (!stats[date]) stats[date] = {};
  if (!stats[date][serveur]) stats[date][serveur] = {};
  if (!stats[date][serveur][pseudo]) stats[date][serveur][pseudo] = {};

  stats[date][serveur][pseudo].profil = {
    classe,
    niveau,
    identifiant,
    motDePasse: motDePasse || null
  };

  stats[date][serveur][pseudo].lastSeen = Date.now();
  save();
  console.log(`[BOT] Profil reçu : ${pseudo} (${serveur}) niveau ${niveau} (${classe})`);
  res.send("Profil enregistré");
});

// 📤 Route de récupération des données
app.get('/api/kamas', (req, res) => {
  const response = {};
  for (const date in stats) {
    response[date] = {};
    for (const serveur in stats[date]) {
      response[date][serveur] = {};
      for (const pseudo in stats[date][serveur]) {
        const joueur = stats[date][serveur][pseudo];
        response[date][serveur][pseudo] = {
          kamas: joueur.kamas?.gain || 0,
          roses: joueur.roses?.gain || 0,
          kolizetons: joueur.kolizetons?.gain || 0,
          profil: joueur.profil || null,
          lastSeen: joueur.lastSeen || null
        };
      }
    }
  }
  res.json(response);
});

// 🚀 Lancement du serveur
app.listen(PORT, () => {
  console.log(`✅ Serveur de statistiques sur http://localhost:${PORT}`);
});
