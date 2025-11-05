# Read multiline input from user or file
instructions = """
00500093
00500113
00700193
00000213
00000293
00208663
00000013
00100213
00920213
00309663
00000013
00100293
00728293
00000313
""".strip().splitlines()

# Join with comma and space, and end with semicolon
output = ",\n".join(instructions) + ";"

print(output)
