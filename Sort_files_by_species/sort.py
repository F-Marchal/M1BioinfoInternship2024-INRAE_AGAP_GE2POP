import os
import sys


def split_name(name: str):
    split_ = name.split("_")
    left, *right = split_[-1].split(".")
    split_[-1] = left
    split_.append(".".join(right))
    return split_



def move_in_correct_folder(dir, passport_path, begin_with_column, value_column, sep=";"):
    data = {}

    with open(passport_path) as file_flux:
        for lines in file_flux:
            lines = lines.split(sep)

            begin_with = lines[begin_with_column]
            value = lines[value_column]
            data[begin_with] = value

    for files in os.listdir(dir):
        split_ = split_name(files)
        if split_[0] not in data:
            continue
        new_folder = data[split_[0]].upper().replace(" ", "_")
        new_folder = f"{dir}/{new_folder}/"
        if not os.path.exists(new_folder):
            os.mkdir(new_folder)

        os.rename(f"{dir}/{files}", f"{new_folder}{files}")


def generate_temp_file():
    for i in range(0, 10):
        with open(f"{i}_PlouPlout_Temp_R1.txt", "a") as F:
            pass

passeport_accessions_Triticeae = sys.argv[2]
COMPLTETE_passeport_accessions_Triticeae = sys.argv[3]

move_in_correct_folder(sys.argv[1], "passeport_accessions_Triticeae", 2,5, "\t")
move_in_correct_folder(sys.argv[1], "COMPLTETE_passeport_accessions_Triticeae", 2,5, "\t")

