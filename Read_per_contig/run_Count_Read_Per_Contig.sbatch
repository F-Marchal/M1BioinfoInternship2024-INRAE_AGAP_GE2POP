#!/bin/bash
#SBATCH --job-name=Count_read_per_contig   # Job name
#SBATCH --partition=agap_long              # Partition
#SBATCH --time=48:00:00                    # Max execution time (HH:MM:SS)
#SBATCH --mem=1G                           # Memory per node allocated
#SBATCH --output=Count_read_per_contig_%j.out  # Output file name
#SBATCH --error=Count_read_per_contig_%j.err   # Error file name

set -e  # Exit on error

# Load necessary modules here
# module load <module_name>

# Input arguments
REFERENCE=$1
BamFolder=$2
bam_files=("$BamFolder"/*.bam)
SAMTOOLS_OPTIONS=${@:3}  # Capture all arguments from the third one onwards
OUTPUT_FILE="./readPerContig${SLURM_JOB_ID}.tsv"
echo $OUTPUT_FILE

# Check if arguments are provided
if [[ -z "$REFERENCE" || -z "$BamFolder" ]]; then
    echo "Error: REFERENCE and/or BamFolder arguments are not specified."
    exit 1
fi

# Temporary file for seqkit output
TEMP_FILE=$(mktemp)

# Commands to execute
echo "Starting Count_read_per_contig script"
echo "Reference: $REFERENCE"
echo "BAM Folder: $BamFolder"
echo "Samtools Options: $SAMTOOLS_OPTIONS"

# Use seqkit to get sequence names from REFERENCE and output to temporary file
seqkit seq -n $REFERENCE > $TEMP_FILE
contig_number=$(wc -l < "$TEMP_FILE")
echo "${contig_number} contigs"

# Check if seqkit successfully generated the temporary file
if [[ ! -s $TEMP_FILE ]]; then
    echo "Error: Temporary file $TEMP_FILE is empty or not correctly created."
    exit 1
fi

# Add a tabulation at the beginning of the output file
echo -e "\t" > $OUTPUT_FILE



# Transform newlines to tabs in TEMP_FILE and append to OUTPUT_FILE
# tr '\n' '\t' < $TEMP_FILE >> $OUTPUT_FILE
echo -en "Contig\t" >> $OUTPUT_FILE
for BAM_FILE in "${bam_files[@]}"; do
    echo -en "$(basename "$BAM_FILE")\t" >> $OUTPUT_FILE

        if [[ -f "${BAM_FILE}.bai" ]]; then
            continue

        else
            echo "Generating BAM index $BAM_FILE"
            samtools index $BAM_FILE
        fi


done


echo "" >> $OUTPUT_FILE  # Add a blank line for readabbility
contig_counter=0
i=0
while IFS= read -r CONTIG_NAME; do
    i=$((i+1))
    echo "Processing contig: $CONTIG_NAME"

    # Initialisez une ligne vide pour le contig dans le fichier de sortie
    echo -en "$CONTIG_NAME\t" >> $OUTPUT_FILE
    
 
    # Maintenant, itérer à travers chaque fichier BAM
    for BAM_FILE in "$BamFolder"/*.bam; do
        BAM_HAS_INDEX="false"

        # Traitement du fichier BAM
        echo "Processing BAM file: $BAM_FILE"

        if [[ -f "${BAM_FILE}.bai" ]]; then
            BAM_HAS_INDEX="true"
        else
            echo "Generating BAM index "
            samtools index $BAM_FILE
        fi

        # Compter les lectures pour le contig actuel dans le fichier BAM
        number_of_reads=$(samtools view -c $SAMTOOLS_OPTIONS $BAM_FILE $CONTIG_NAME) || { echo "Error: samtools view failed for $CONTIG_NAME in $BAM_FILE."; exit 5; }

        # Ajouter le nombre de lectures au fichier de sortie
        echo -en "${number_of_reads}\t" >> $OUTPUT_FILE

        if [[ "$BAM_HAS_INDEX" == "false" ]]; then
            rm "${BAM_FILE}.bai"
        fi

    done
    echo "${i} / ${contig_number}"

    # Mise à jour du compteur de contigs traités
    echo "" >> $OUTPUT_FILE  # Ajouter une nouvelle ligne après avoir traité tous les fichiers BAM pour le contig

done < "$TEMP_FILE"




echo "Output file with seqkit content: $OUTPUT_FILE"

# Clean up temporary file
rm $TEMP_FILE

echo "Count_read_per_contig script completed"
