# Définir le chemin d'accès au fichier TSV
file_path <- "C:/Users/M/Desktop/Bioinformatique/stage/2024_Florent_Marchal/02_results/READ_PER_CONTIG/BAM_SPLITTED/URARTU_TRANS_EX_NIHILO_Tr246_BWA/All"

# Lire les données depuis le fichier TSV
data <- read.delim(file_path, header = TRUE, sep = "\t")

# Vérifier les noms des colonnes pour identifier la colonne d'intérêt
print(colnames(data))

# Vérifier les premières lignes des données pour confirmer que la lecture est correcte
print(head(data))

# Extraire la colonne d'intérêt
valeurs <- data[,2]

# Assurez-vous que la colonne d'intérêt est numérique
print(str(valeurs))

# Calculer la moyenne et l'écart type
mean_val <- mean(valeurs, na.rm = TRUE)
sd_val <- sd(valeurs, na.rm = TRUE)

# Formater le titre du boxplot pour inclure la moyenne et l'écart type
title_text <- sprintf("Boîte à moustache du nombre de reads par contigs\nMoyenne: %.2f, Écart type: %.2f\n(TrEx)", mean_val, sd_val)

# Spécifier le chemin pour enregistrer le fichier PNG avec fond transparent
png_filename <- "boxplot_transparent.png"

# Créer un fichier PNG avec fond transparent
png(filename = png_filename, width = 800, height = 600, bg = "transparent")

# Créer le boxplot avec base R
boxplot(valeurs, 
        log = "y",               # Échelle logarithmique pour l'axe y
        ylim = c(1, 200000),     # Limites de l'axe y
        main = title_text,       # Titre avec moyenne et écart type
        ylab = "Nombre de reads", # Label de l'axe y
        xlab = "",               # Pas de label pour l'axe x
        col = "lightblue",       # Couleur du boxplot
        border = "black")        # Couleur des bordures du boxplot

# Fermer le périphérique graphique pour enregistrer le fichier
dev.off()
