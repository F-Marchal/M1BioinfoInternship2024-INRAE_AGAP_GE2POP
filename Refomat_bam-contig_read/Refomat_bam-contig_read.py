
import os
import sys

args_number = len(sys.argv)
if args_number >= 2:
    path = sys.argv[1]
else:
    path = "old_ref/readPerContig20498777.tsv"

if args_number >= 3:
    output = sys.argv[2]
else:
    output = "Reformated_C"

if args_number >= 4:
    ranges = int(sys.argv[3])
else:
    ranges = 10

if not os.path.isdir(output):
    os.mkdir(output)

mono_bam_files = []
bam_list = None
with open(path, "r") as File:
    for lines in File:
        lines = lines.strip()
        if lines == "" or lines == "\n":
            continue

        lines = lines.split("\t")

        # When the first line is reached, generate a file per bam.
        if bam_list is None:
            item_name = lines[0]
            bam_list = lines[1:]

            for new_file_path in bam_list:
                current_file = open(f"{output}/{new_file_path}.{item_name}.tsv", "w")
                current_file.write(f"{item_name}\tNumber\t\n")
                mono_bam_files.append(current_file)

            continue

        contig_name = lines[0]
        for i, value in enumerate(lines[1:]):
            current_file = mono_bam_files[i]
            current_file.write(f"{contig_name}\t{int(value) // ranges}\n")

if mono_bam_files:
    for files in mono_bam_files:
        files.close()


