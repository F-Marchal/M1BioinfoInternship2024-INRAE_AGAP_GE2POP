#!/bin/bash

# Initialiser la variable Dossier
Dossier=$1  # "../"
Script=$2   #c"makeSymLink.sh"


# Boucle pour chaque fichier dans le répertoire spécifié
for f in "$Dossier"*; do
  # Obtenir le nom de base du fichier
  f=$(basename "$f")
  
  # Vérifier si le fichier est dans la liste des fichiers à exclure
  if [[ "$f" == "EXCLUDED" || "$f" == "ALL" || "$f" == "Refs" || "$f" == "script" ]]; then
    continue
  fi
  
  # Afficher le nom du fichier
  

  if [[ !  -d "$Dossier/$f" ]]; then
    continue
  fi

  

  bash $Script "$Dossier/$f/" "$Dossier/ALL/"  
  



done
