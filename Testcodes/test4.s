########################################################
# Store 5 numbers into memory starting at 0x010
########################################################

    # Write 9 to 0x010
    li  x5, 0x010
    li  x6, 9
    sw  x6, 0(x5)

    # Write 3 to 0x014
    li  x6, 3
    sw  x6, 4(x5)

    # Write 5 to 0x018
    li  x6, 5
    sw  x6, 8(x5)

    # Write 1 to 0x01C
    li  x6, 1
    sw  x6, 12(x5)

    # Write 7 to 0x020
    li  x6, 7
    sw  x6, 16(x5)

########################################################
# Load numbers into registers x10–x14
########################################################

    lw  x10, 0(x5)
    lw  x11, 4(x5)
    lw  x12, 8(x5)
    lw  x13, 12(x5)
    lw  x14, 16(x5)

########################################################
# Bubble sort (simple, unrolled)
########################################################

sort_pass:

    # compare x10 and x11
    bge x10, x11, swap01
noswap01:
    j next12
swap01:
    mv x15, x10
    mv x10, x11
    mv x11, x15
next12:

    # compare x11 and x12
    bge x11, x12, swap12
noswap12:
    j next23
swap12:
    mv x15, x11
    mv x11, x12
    mv x12, x15
next23:

    # compare x12 and x13
    bge x12, x13, swap23
noswap23:
    j next34
swap23:
    mv x15, x12
    mv x12, x13
    mv x13, x15
next34:

    # compare x13 and x14
    bge x13, x14, swap34
noswap34:
    j endpass
swap34:
    mv x15, x13
    mv x13, x14
    mv x14, x15
endpass:

    # Repeat bubble sort 4 times
    addi x20, x20, 1
    li   x21, 4
    blt  x20, x21, sort_pass

########################################################
# Store sorted numbers to 0x030
########################################################

    li  x7, 0x030
    sw  x10, 0(x7)
    sw  x11, 4(x7)
    sw  x12, 8(x7)
    sw  x13, 12(x7)
    sw  x14, 16(x7)

########################################################
# Load sorted numbers into x27–x31
########################################################

    lw  x27, 0(x7)
    lw  x28, 4(x7)
    lw  x29, 8(x7)
    lw  x30, 12(x7)
    lw  x31, 16(x7)

done:
    j done
