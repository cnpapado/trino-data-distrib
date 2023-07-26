# from pathlib2 import Path
import os

BOLD = '\033[1m'
RESET = '\033[0m'

def replacetext(filepath, search_text, replace_text):
	file = open(filepath, 'r', encoding = "latin-1")
	lines = file.readlines()
	moded_lines = []
	for line in lines:
		line = line.replace(search_text, replace_text)
		if line[-2] == "|":
			line = list(line)
			line[-2] = ""
			line = "".join(line) 
		else:
			pass
			# print("No | character found in the end of row")
		moded_lines.append(line)
	file.close()

	file = open(filepath, 'w')
	for line in moded_lines:
		file.write(line)
	file.close()


search_text = "\\N"
replace_text = "null"

path = "../data/"
data_files = os.listdir(path)

print(BOLD + "----Formatting .dat files----" + RESET)
for data_file in data_files:
    filepath = path+data_file
    print(filepath)
    replacetext(filepath, search_text, replace_text)
print()