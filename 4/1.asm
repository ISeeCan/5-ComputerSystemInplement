# Mars MIPS Assembly for Volume and Surface Area Calculation
    .data
prompt: .asciiz "Enter length, width, height: "     #输入输出预设
error_msg: .asciiz "Illegal Input\n"
newline: .asciiz "\n"

    .text
    .globl main
main:                          #准备输出
    li $v0, 4                  # syscall for print_string
    la $a0, prompt             # load prompt address
    syscall

input_length:                  #处理输入
    li $v0, 5                  # syscall for read_int
    syscall
    move $t0, $v0              # store input as length

    li $v0, 5
    syscall
    move $t1, $v0              # store input as width

    li $v0, 5
    syscall
    move $t2, $v0              # store input as height

    # Check for illegal input (<= 0)
    blt $t0, 1, illegal_input
    blt $t1, 1, illegal_input
    blt $t2, 1, illegal_input
    #计算部分
    # Volume calculation: volume = length * width * height
    mul $t3, $t0, $t1          # t3 = length * width
    mul $t3, $t3, $t2          # t3 = volume

    # Surface area calculation: area = 2 * (length*width + width*height + height*length)
    mul $t4, $t0, $t1          # temp1 = length * width
    mul $t5, $t1, $t2          # temp2 = width * height
    mul $t6, $t2, $t0          # temp3 = height * length
    add $t7, $t4, $t5          # temp1 + temp2
    add $t7, $t7, $t6          # temp1 + temp2 + temp3
    sll $t7, $t7, 1            # area = 2 * (temp1 + temp2 + temp3)
    #输出结果
    # Output volume
    li $v0, 1                  # syscall for print_int
    move $a0, $t3              # load volume
    syscall
    li $v0, 4                  # print newline
    la $a0, newline
    syscall

    # Output surface area
    li $v0, 1
    move $a0, $t7              # load surface area
    syscall
    j exit

illegal_input:
    li $v0, 4                  # print error message
    la $a0, error_msg
    syscall
    j main                     # restart input

exit:
    li $v0, 10                 # syscall for exit
    syscall
