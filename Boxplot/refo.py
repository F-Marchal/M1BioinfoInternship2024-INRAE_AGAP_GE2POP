import os

o_flux = open("All", "w")
for files in os.listdir("Reformated"):
    c_flux = open("Reformated/" + files, "r")


    first=True
    for lines in c_flux:
        split_lines = lines.split("\t")[:2]
        value = split_lines[-1].strip()

        if first:

            first = False
            continue

        if value == "0" or value == 0:
            continue

        line = "\t".join(split_lines)
        if line[-1] != "\n":
            line += "\n"

        o_flux.write(line)

    c_flux.close()
o_flux.close()
