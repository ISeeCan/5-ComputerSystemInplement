.data
prompt_n:   .asciiz "Enter the length of the array: "   # ��ʾ�������鳤��
prompt_A:   .asciiz "Enter each element of the array: " # ��ʾ��������Ԫ��
trueMsg:    .asciiz "True\n"                            # �����True����Ϣ
falseMsg:   .asciiz "False\n"                           # �����False����Ϣ

    .align 2                                           # ǿ�� 4 �ֽڶ���
A:          .space 400                                 # Ϊ����Ԥ���ռ� (�������100��Ԫ��)

    .text
    .globl main
main:
    # ��ʾ�û��������鳤��
    li $v0, 4
    la $a0, prompt_n
    syscall

    # ��ȡ���鳤�� n
    li $v0, 5
    syscall
    move $t0, $v0                  # $t0 = n (���鳤��)

    # ��ʾ�û���������Ԫ��
    li $v0, 4
    la $a0, prompt_A
    syscall

    # ��ȡ����Ԫ�ص� A ����
    la $t1, A                      # $t1 = A �Ļ���ַ
    move $t2, $t0                  # $t2 = n (��Ϊѭ������)
read_loop:
    beq $t2, 0, check_jump         # ��� $t2 == 0��������Ծ���
    li $v0, 5                      # ϵͳ���ú� 5 (��ȡ����)
    syscall
    sw $v0, 0($t1)                 # ��������������� A ����
    addi $t1, $t1, 4               # �ƶ����������һ��Ԫ��
    subi $t2, $t2, 1               # $t2--
    j read_loop                    # ���ص� read_loop

# ����Ƿ������Ծ�����һ���±�
check_jump:
    li $t3, 0                      # ��Զ����λ�� max_reach = 0
    la $t4, A                      # $t4 = A �Ļ���ַ (���ڱ�������)
    li $t5, 0                      # ��ǰ�±� i = 0
    move $t6, $t0                  # ���鳤�� n

jump_loop:
    # �ж�������i <= max_reach ���� i < n
    bgt $t5, $t3, print_false      # �����ǰ�±� i > max_reach��������� False
    beq $t5, $t6, print_true       # ��� i == n��������� True (�ѵ������һ���±�)

    # ��ȡ��ǰ��Ծֵ A[i]
    lw $t7, 0($t4)                 # $t7 = A[i]

    # ���� max_reach = max(max_reach, i + A[i])
    add $t8, $t5, $t7              # $t8 = i + A[i]
    bgt $t8, $t3, update_max       # ��� i + A[i] > max_reach������� max_reach
    j next_index                   # ��������������һ���±�

update_max:
    move $t3, $t8                  # max_reach = i + A[i]

next_index:
    addi $t5, $t5, 1               # i++
    addi $t4, $t4, 4               # �ƶ��� A ����һ��Ԫ��
    j jump_loop                    # ���ص� jump_loop

# ��� True
print_true:
    li $v0, 4
    la $a0, trueMsg
    syscall
    j exit_program

# ��� False
print_false:
    li $v0, 4
    la $a0, falseMsg
    syscall

# �˳�����
exit_program:
    li $v0, 10
    syscall