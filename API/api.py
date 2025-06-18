from fastapi import FastAPI, HTTPException
import json
from pathlib import Path

app = FastAPI()

# Exemple de base de données simulée
dice_db = {
    "1": {"sides": 6, "type": "standard"},
    "2": {"sides": 20, "type": "d20"},
    "3": {"sides": 10, "type": "percentile"}
}

@app.get("/dice/{id}")
def get_dice(id: str):
    dice = dice_db.get(id)
    if not dice:
        raise HTTPException(status_code=404, detail="Dice not found")
    return {"id": id, "dice": dice}


def get_possible_effects_by_id(object_id: int):
    base_dir = Path(__file__).resolve().parent
    file_path = base_dir / "assets" / "items.json"

    if not file_path.exists():
        print("Fichier non trouvé :", file_path)
        return None

    with open(file_path, "r", encoding="utf-8") as f:
        # Afficher le nombre de lignes (optionnel)
        lines = f.readlines()
        print(f"Nombre de lignes dans le fichier JSON : {len(lines)}")

    # Charger le contenu JSON (obligatoire pour la suite)
    with open(file_path, "r", encoding="utf-8") as f:
        try:
            items = json.load(f)
        except Exception as e:
            print("Erreur de lecture JSON :", e)
            return None
        
    print("Nombres d'éléments dans le fichier JSON :", len(items))

    first_element = items[0]
    keys = list(first_element.keys())
    print("Clés du premier élément (avec taille de la valeur) :")
    for key in keys:
        value = first_element[key]
        try:
            length = len(value)
        except TypeError:
            length = "N/A"  # valeur sans longueur (ex: int, float, None, bool)
        print(f"- {key} : taille = {length}")

    references = items[0]['references']['RefIds']
    print(f"Type de references : {type(references)}")
    print(f"Nombre d'éléments dans references : {len(references)}")


    for element in references:
        if "data" in element and element["data"].get("id") == object_id:
            print(f"Effets possibles pour l'ID {object_id} : {element.get('possibleEffects', [])}")
            return element.get("possibleEffects", [])

    print(f"Aucun objet trouvé avec l'ID {object_id}")

    return None


get_possible_effects_by_id(2471)