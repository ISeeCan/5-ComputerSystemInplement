# Mars MIPS Assembly for Fibonacci Sequence
    .data
prompt: .asciiz "Enter a positive integer for Fibonacci: "    #输入输出预设
newline: .asciiz "\n"

    .text
    .globl main                          #准备输出
main:
    # Prompt for input
    li $v0, 4                  # syscall for print_string
    la $a0, prompt
    syscall

    # Read input n                 #处理输入
    li $v0, 5                  # syscall for read_int
    syscall
    move $t0, $v0              # store input in $t0 (n)

    # Handle base cases F(0) = 1 and F(1) = 1
    ble $t0, 1, base_case      # if n <= 1, directly output 1

    # Initialize variables for Fibonacci calculation
    li $t1, 1                  # F(0)
    li $t2, 1                  # F(1)
    li $t3, 2                  # counter = 2

fibonacci_loop:
    # Calculate next Fibonacci number
    add $t4, $t1, $t2          # F(n) = F(n-1) + F(n-2)
    move $t1, $t2              # Update F(n-2) = F(n-1)
    move $t2, $t4              # Update F(n-1) = F(n)
    addi $t3, $t3, 1           # counter++

    # Check if counter has reached n
    bne $t3, $t0, fibonacci_loop

    # Output result
    li $v0, 1                  # syscall for print_int
    move $a0, $t4              # F(n)
    syscall
    j exit

base_case:
    li $v0, 1                  # syscall for print_int
    li $a0, 1                  # output 1
    syscall

exit:
    li $v0, 10                 # syscall for exit
    syscall
