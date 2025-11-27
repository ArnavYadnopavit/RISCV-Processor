###########################################
# CREATE LINKED LIST IN MEMORY
###########################################

    # Node addresses we choose manually:
    # node0 at 0x100
    # node1 at 0x110
    # node2 at 0x120
    # node3 at 0x130

    # x5 = 0x100 (head)
    addi x5, x0, 0x100

    #### Node0: next = node1, value = 10
    addi x6, x0, 0x110   # next ptr
    sd   x6, 0(x5)
    addi x6, x0, 10
    sd   x6, 8(x5)

    #### Node1: next = node2, value = 20
    addi x5, x0, 0x110
    addi x6, x0, 0x120
    sd   x6, 0(x5)
    addi x6, x0, 20
    sd   x6, 8(x5)

    #### Node2: next = node3, value = 30
    addi x5, x0, 0x120
    addi x6, x0, 0x130
    sd   x6, 0(x5)
    addi x6, x0, 30
    sd   x6, 8(x5)

    #### Node3: next = NULL, value = 40
    addi x5, x0, 0x130
    addi x6, x0, 0       # NULL pointer
    sd   x6, 0(x5)
    addi x6, x0, 40
    sd   x6, 8(x5)

###########################################
# TRAVERSE LINKED LIST
###########################################

    # head pointer
    addi x10, x0, 0x100

    # counters
    addi x27, x0, 0     # count
    addi x28, x0, 0     # sum

loop:
    beq  x10, x0, done     # NULL reached → end

    ld   x11, 0(x10)       # load next pointer
    ld   x12, 8(x10)       # load value

    addi x27, x27, 1       # count++
    add  x28, x28, x12     # sum += value

    mv   x10, x11          # move to next node
    j    loop

done:
    j done                 # stop here
