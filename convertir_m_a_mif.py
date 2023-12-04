with open('fg.m', 'r') as input_file:
    lines = input_file.readlines()

with open('fg.mif', 'w') as output_file:
    output_file.write("WIDTH=32;\n")
    output_file.write("DEPTH={};\n".format(len(lines)))

    output_file.write("ADDRESS_RADIX=HEX;\n")
    output_file.write("DATA_RADIX=HEX;\n")
    output_file.write("CONTENT BEGIN\n")

    for i, line in enumerate(lines):
        output_file.write("   {}: {};\n".format(hex(i)[2:].zfill(8).upper(), line.strip()))

    output_file.write("END;\n")
