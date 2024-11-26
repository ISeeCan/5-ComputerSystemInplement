.data
prompt_n:   .asciiz "Enter the length of the array: "   # 提示输入数组长度
prompt_A:   .asciiz "Enter each element of the array: " # 提示输入数组元素
trueMsg:    .asciiz "True\n"                            # 输出“True”消息
falseMsg:   .asciiz "False\n"                           # 输出“False”消息

    .align 2                                           # 强制 4 字节对齐
A:          .space 400                                 # 为数组预留空间 (假设最多100个元素)

    .text
    .globl main
main:
    # 提示用户输入数组长度
    li $v0, 4
    la $a0, prompt_n
    syscall

    # 读取数组长度 n
    li $v0, 5
    syscall
    move $t0, $v0                  # $t0 = n (数组长度)

    # 提示用户输入数组元素
    li $v0, 4
    la $a0, prompt_A
    syscall

    # 读取数组元素到 A 数组
    la $t1, A                      # $t1 = A 的基地址
    move $t2, $t0                  # $t2 = n (作为循环计数)
read_loop:
    beq $t2, 0, check_jump         # 如果 $t2 == 0，跳到跳跃检查
    li $v0, 5                      # 系统调用号 5 (读取整数)
    syscall
    sw $v0, 0($t1)                 # 将输入的整数存入 A 数组
    addi $t1, $t1, 4               # 移动到数组的下一个元素
    subi $t2, $t2, 1               # $t2--
    j read_loop                    # 跳回到 read_loop

# 检查是否可以跳跃到最后一个下标
check_jump:
    li $t3, 0                      # 最远到达位置 max_reach = 0
    la $t4, A                      # $t4 = A 的基地址 (用于遍历数组)
    li $t5, 0                      # 当前下标 i = 0
    move $t6, $t0                  # 数组长度 n

jump_loop:
    # 判断条件：i <= max_reach 并且 i < n
    bgt $t5, $t3, print_false      # 如果当前下标 i > max_reach，跳到输出 False
    beq $t5, $t6, print_true       # 如果 i == n，跳到输出 True (已到达最后一个下标)

    # 读取当前跳跃值 A[i]
    lw $t7, 0($t4)                 # $t7 = A[i]

    # 更新 max_reach = max(max_reach, i + A[i])
    add $t8, $t5, $t7              # $t8 = i + A[i]
    bgt $t8, $t3, update_max       # 如果 i + A[i] > max_reach，则更新 max_reach
    j next_index                   # 否则跳到处理下一个下标

update_max:
    move $t3, $t8                  # max_reach = i + A[i]

next_index:
    addi $t5, $t5, 1               # i++
    addi $t4, $t4, 4               # 移动到 A 的下一个元素
    j jump_loop                    # 跳回到 jump_loop

# 输出 True
print_true:
    li $v0, 4
    la $a0, trueMsg
    syscall
    j exit_program

# 输出 False
print_false:
    li $v0, 4
    la $a0, falseMsg
    syscall

# 退出程序
exit_program:
    li $v0, 10
    syscall