# Makefile pour supprimer les fichiers de rapport

# Répertoire cible
DIR = ./

# Extensions des fichiers à supprimer
EXTENSIONS = \
  acn acr alg aux bbl bcf blg dlg dvi fdb_latexmk fls glg glo gls idx ilg ind lof log lol lot out pdf run.xml \
  synctex.gz toc dog fog sog ist flg slg

# Cible par défaut
all: Complete

pdf: main.tex
	pdflatex main.tex
	
NoGlo: pdf
	biber main.bcf
	pdflatex main.tex
	pdflatex main.tex
	clean

Glo: pdf
	makeglossaries main
	biber main.bcf
	pdflatex main.tex
	pdflatex main.tex

Complete: pdf
	makeglossaries main
	biber main.bcf
	pdflatex main.tex
	biber main.bcf
	pdflatex main.tex	# Standard procedure after biber
	pdflatex main.tex	# Standard procedure after biber

# Règle pour supprimer les fichiers
clean:
	@for ext in $(EXTENSIONS); do \
		echo "Suppression des fichiers *.$$ext"; \
		rm -f $(DIR)/main.$$ext; \
	done

.PHONY: all clean
