# Read multiline input from user or file
instructions = """
00f00093
ffd00113
0c800193
02208233
022092b3
02312333
0230b3b3
0220c433
0211d4b3
02114533
0230d5b3
0220e633
0211f6b3
02116733
0230f7b3
00000013
00000013
""".strip().splitlines()

# Join with comma and space, and end with semicolon
output = ",\n".join(instructions) + ";"

print(output)
