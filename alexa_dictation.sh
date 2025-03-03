#!/bin/bash

# Configuration
DELAY=5                    # Temps en secondes entre chaque mot
REPEAT=5                   # Nombre de répétitions pour chaque mot

# Vérifier si au moins un mot est fourni en argument
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 mot1 [mot2 mot3 ...]"
    exit 1
fi

# Fonction pour demander à Alexa de dicter un mot
dictate_word() {
    local word="$1"
    for ((i=1; i<=REPEAT; i++)); do
        echo "📢 Alexa dit : $word (Répétition $i/$REPEAT)"
        ./alexa_remote_control.sh -e "speak:\"$word\""
        sleep "$DELAY"
    done
}

# Boucle sur tous les mots fournis en argument
for word in "$@"; do
    dictate_word "$word"
done

echo "✅ Dictée terminée !"
