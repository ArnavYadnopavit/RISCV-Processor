# ============================================================
# RISC-V CPU FUNCTIONALITY & FORWARDING TEST (for Ripes)
# ============================================================

# --------------------------
# Initialize registers
# --------------------------
addi x1, x0, 5       # x1 = 5
addi x2, x0, 7       # x2 = 7
addi x3, x0, -3      # x3 = -3
addi x4, x0, 2       # x4 = 2
addi x5, x0, 8       # x5 = 8

# --------------------------
# ALU basic ops
# --------------------------
add  x6, x0, x2       # x6 = 0 + 7 = 7
sub  x7, x2, x1       # x7 = 7 - 5 = 2
and  x8, x1, x2       # x8 = 5 & 7 = 5
or   x9, x1, x2       # x9 = 5 | 7 = 7
xor  x10, x1, x2      # x10 = 5 ^ 7 = 2

# --------------------------
# Shift ops
# --------------------------
sll  x11, x1, x4      # 5 << 2 = 20
srl  x12, x5, x4      # 8 >> 2 = 2
sra  x13, x3, x4      # -3 >> 2 = -1 (arithmetic shift)

# --------------------------
# Immediate ops
# --------------------------
addi x14, x1, 10      # 5 + 10 = 15
andi x15, x1, 3       # 5 & 3 = 1
ori  x16, x1, 8       # 5 | 8 = 13
xori x17, x1, 12      # 5 ^ 12 = 9

# --------------------------
# Forwarding / RAW hazard tests
# --------------------------
add  x20, x1, x2       # x20 = 12
add  x21, x20, x2      # x21 = 19 (depends on x20)
add  x22, x21, x1      # x22 = 24 (depends on x21)

# --------------------------
# Load/Store + load-use hazard
# --------------------------
# Use address 100 in memory for simplicity
addi x30, x0, 0x100
sw   x5, 0(x30)        # MEM[100] = 0x0F
lw   x23, 0(x30)       # x23 = MEM[100] = 0x08
add  x24, x23, x2      # hazard: x23 just loaded -> x24 = 0x0F

# --------------------------
# Branch and control hazards
# --------------------------
# Branch based on previous computation (should use forwarded value)
add  x25, x1, x2       # x25 = 0x0C
beq  x25, x6, equal_label   # should not take (15!=7)
addi x26, x0, 0        # skipped if branch taken
j    branch_done

equal_label:
addi x26, x0, 1        # executed if branch taken

branch_done:
# Next branch not taken
bne  x1, x1, not_taken
addi x27, x0, 2        # should execute
j    after_branch
not_taken:
addi x27, x0, 0
after_branch:

# --------------------------
# JAL / JALR check
# --------------------------
jal  x28, jump_target   # x28 gets return address
addi x29, x0, 0         # skipped
jump_target:
addi x29, x0, 9         # executed

# --------------------------
# End: keep looping
# --------------------------
loop:
j loop
