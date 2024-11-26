    .data
D:  .space 32      # 为数组 D 分配空间，足够容纳测试数据

    .text
    .globl main
main:
    # 测试初始化，临时赋值 a 和 b
 #   li $s0, 3       # a = 3
 #   li $s1, 2       # b = 2

    # 初始化索引 i = 0
    li $t0, 0

outer_loop:
    # i < a 检查
    bge $t0, $s0, end_outer_loop

    # 初始化索引 j = 0
    li $t1, 0

inner_loop:
    # j < b 检查
    bge $t1, $s1, end_inner_loop

    # 计算 i + j 并存入 D[4*j]
    add $t2, $t0, $t1             # $t2 = i + j
    sll $t3, $t1, 2               # $t3 = 4 * j，计算存储偏移量
    add $t4, $s2, $t3             # $t4 = &D[4*j]
    sw $t2, 0($t4)                # 存储 i + j 到 D[4*j]

    # j++
    addi $t1, $t1, 1
    j inner_loop

end_inner_loop:
    # i++
    addi $t0, $t0, 1
    j outer_loop

end_outer_loop:
    # 程序结束
    li $v0, 10
    syscall
