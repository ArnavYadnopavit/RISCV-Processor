# Read multiline input from user or file
instructions = """
00000113
020000ef
00000013
00110113
020000ef
00000013
00110113
0000006f
00000013
00110113
00008067
00000013
00110113
00008067
00000013
""".strip().splitlines()

# Join with comma and space, and end with semicolon
output = ",\n".join(instructions) + ";"

print(output)
