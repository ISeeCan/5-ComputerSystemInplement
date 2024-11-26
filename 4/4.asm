    .data
D:  .space 32      # Ϊ���� D ����ռ䣬�㹻���ɲ�������

    .text
    .globl main
main:
    # ���Գ�ʼ������ʱ��ֵ a �� b
 #   li $s0, 3       # a = 3
 #   li $s1, 2       # b = 2

    # ��ʼ������ i = 0
    li $t0, 0

outer_loop:
    # i < a ���
    bge $t0, $s0, end_outer_loop

    # ��ʼ������ j = 0
    li $t1, 0

inner_loop:
    # j < b ���
    bge $t1, $s1, end_inner_loop

    # ���� i + j ������ D[4*j]
    add $t2, $t0, $t1             # $t2 = i + j
    sll $t3, $t1, 2               # $t3 = 4 * j������洢ƫ����
    add $t4, $s2, $t3             # $t4 = &D[4*j]
    sw $t2, 0($t4)                # �洢 i + j �� D[4*j]

    # j++
    addi $t1, $t1, 1
    j inner_loop

end_inner_loop:
    # i++
    addi $t0, $t0, 1
    j outer_loop

end_outer_loop:
    # �������
    li $v0, 10
    syscall
