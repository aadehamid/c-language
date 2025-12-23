_start:
    addi t0, zero, 10      # t0 = 0 + 10
    addi t1, zero, 12      # t1 = 0 + 12
    add  t2, t0, t1       # t2 = t0 + t1
    j _start              # jump back to start
