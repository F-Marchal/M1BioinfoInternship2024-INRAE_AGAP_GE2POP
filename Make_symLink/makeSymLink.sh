#!/bin/bash

####################################
#           98 % chatGPT           #
####################################

# Répertoire source contenant les fichiers
source_dir=$1

# Répertoire de destination où les liens symboliques seront créés
destination_dir=$2


# Vérifier si les répertoires source et destination existent
if [[ ! -d "$source_dir" ]]; then
  echo "Le répertoire source n'existe pas: $source_dir"
  exit 1
fi

if [[ ! -d "$destination_dir" ]]; then
  echo "Le répertoire de destination n'existe pas: $destination_dir"
  exit 1
fi

# Boucle pour chaque fichier dans le répertoire source
for file in "$source_dir"/*; do
  # Obtenir le nom du fichier
  filename=$(basename "$file")
  
  # Créer le lien symbolique dans le répertoire de destination
  ln -s "$file" "$destination_dir/$filename"
  
  echo "Lien symbolique créé pour $filename"
done

echo "Tous les liens symboliques ont été créés avec succès."
