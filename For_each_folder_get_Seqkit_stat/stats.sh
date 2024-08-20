#!/bin/bash
#SBATCH --partition=agap_normal
#SBATCH --job-name=seqKit_stat
#SBATCH --output=seqKit_stat_%j.out

mkdir -p SEQKIT_STATS

# Boucle pour chaque fichier dans le répertoire actuel
for file in *; do
  # Obtenir le nom de base du fichier
  f=$(basename "$file")
  
  # Vérifier si le fichier est dans la liste des fichiers à exclure
  if [[ "$f" == "EXCLUDED" || "$f" == "ALL" || "$f" == "Refs" || "$f" == "script" || "$f" == "SEQKIT_STATS" ]]; then
    continue
  fi
  
  # Afficher le nom du fichier
  echo "File -> $f"
  
  # Executer seqkit stat pour chaque fichier dans le dossier $f
  echo "Srun -> $f"
  seqkit stat "$f"/* > "SEQKIT_STATS/$f.stats"


done
