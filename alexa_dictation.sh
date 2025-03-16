#!/bin/bash

# Configuration par défaut
DELAY=5                    # Temps en secondes entre chaque mot (modifiable)
REPEAT=5                   # Nombre de répétitions pour chaque mot (modifiable)
FILE="mots.txt"            # Nom du fichier contenant les mots

if [ "$#" -ge 1 ]; then
    FILE="$1"
fi

if [ ! -f "$FILE" ]; then
    echo "❌ Erreur : fichier '$FILE' introuvable."
    echo "Usage : $0 [fichier.txt]"
    exit 1
fi

if [ -z "$VOICEMONKEY_TOKEN" ]; then
    echo "❌ Erreur : la variable VOICEMONKEY_TOKEN n'est pas définie."
    echo "Veuillez l'exporter avant d'exécuter ce script :"
    echo "export VOICEMONKEY_TOKEN='votre_token'"
    exit 1
fi

send_voicemonkey_message() {
    local phrase="$1"
    local encoded_phrase
    encoded_phrase=$(jq -rn --arg txt "$phrase" '$txt|@uri')
    echo "📢 Alexa dit : $phrase"
    curl -s -X GET "https://api-v2.voicemonkey.io/announcement?token=$VOICEMONKEY_TOKEN&text=$encoded_phrase" > /dev/null
}

send_voicemonkey_message "La dictée va commencer dans 3 secondes !"
sleep 3

while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ -n "$line" ]]; then
        for ((i=1; i<=REPEAT; i++)); do
            send_voicemonkey_message "$line"
            sleep "$DELAY"
        done
    fi
done < "$FILE"

sleep 3
send_voicemonkey_message "Dictée terminée !"
echo "✅ Dictée terminée !"
