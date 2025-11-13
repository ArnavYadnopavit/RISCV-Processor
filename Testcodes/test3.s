#M extension test
# ===================================================
# RISC-V M Extension Test
# Exercises: mul, mulh, mulhsu, mulhu, div, divu, rem, remu
# ===================================================

        addi x1, x0, 15        # x1 = +15
        addi x2, x0, -3        # x2 = -3  (two's complement)
        addi x3, x0, 200       # x3 = 200 (unsigned test value)

# ---------- MULTIPLY TESTS ----------
        mul    x4,  x1, x2     # 15 * -3 = -45
        mulh   x5,  x1, x2     # upper 64 bits of signed product (should be all 1s)
        mulhsu x6,  x2, x3     # signed * unsigned (-3 * 200) → -600
        mulhu  x7,  x1, x3     # unsigned * unsigned (15 * 200 = 3000, upper bits 0)

# ---------- DIVIDE TESTS ----------
        div    x8,  x1, x2     # 15 / -3 = -5
        divu   x9,  x3, x1     # 200 / 15 = 13 (unsigned)
        div    x10, x2, x1     # -3 / 15 = 0 (trunc toward zero)
        divu   x11, x1, x3     # 15 / 200 = 0

# ---------- REMAINDER TESTS ----------
        rem    x12, x1, x2     # 15 % -3 = 0
        remu   x13, x3, x1     # 200 % 15 = 5
        rem    x14, x2, x1     # -3 % 15 = -3
        remu   x15, x1, x3     # 15 % 200 = 15

# Stop simulation (depends on environment)
        nop
        nop
