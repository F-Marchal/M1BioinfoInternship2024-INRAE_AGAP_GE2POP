import re

# Variables used inside the codeml wrapper
method = 'BEB'
method_full = "Bayes"
nsites = 663 #221
rst = open("./rst_copy")
text  = rst.read()
reg = []

# ------------ catch lnL ------------
reg.append('(?:^lnL = (.*))?$')
reg.append('')
# ------------ --------- ------------

# OLD :    '^{0} Empirical Bayes \({0[0]}EB\) probabilities for (\d+) classes( \(class\))?( & postmean_w)?( & P\(w>1\))?'.format(method_full)
reg.append('^{0} Empirical Bayes \({0[0]}EB\) probabilities for (\d+) classes( \(class\))?( & postmean_w)?'.format(method_full))
reg.append('\(amino acids refer to 1st sequence: seq-1\)')
reg.append('')

#  ------------ catch sites ------------
# OLD :
#    for i in range(nsites):
#       reg.append('\s+{0}\s+[A-Z-].+'.format(i+1))
#       if i == 0:
#           reg[-1] = "(" + reg[-1]
#     reg[-1] += ")

researched_patern = r"\s+[0-9]+\s+[A-Z-].+" # Capture All sites in one command
reg.append(rf'((?:{researched_patern})+)')

#  ------------ ----------- ------------



#  ------------ Identify next title ------------
reg.append('')
reg.append('Positively selected sites')
reg.append('')
reg.append(r"\tProb\(w>1\).*mean w")
reg.append('')
#  ------------ ------------------- ------------


#  ------------ Catch positively selected sites ------------
researched_patern = r"\s+[0-9]+\s+[A-Z-].*"
reg.append(rf'((?:{researched_patern})*)')
#  ------------ ------------------------------- ------------

# Test regex
reg = '\n'.join(reg)

mo = re.search(reg, text , re.MULTILINE)
# print(mo.group())
# print("------------------")
print(mo.group(6))


# Groups :
# 1 lnL
# 2 number of classes
# 3 "(class)"
# 4 test type (& postmean_w)
# 5 All sites
# 6 All positively selected sites


rst.close()
