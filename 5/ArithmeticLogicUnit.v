module ArithmeticLogicUnit(
    input wire [31:0] src1,          // ��һ��������
    input wire [31:0] src2,          // �ڶ���������
    input wire [4:0] aluControl,     // ALU �����ź�
    output reg [31:0] result,        // ������
    output reg zero                  // ���־�����ڷ�֧�ж�
);

    initial begin
        result = 32'b0;
        zero = 0;
    end
    
    always @(*) begin
        // Ĭ��ֵ (����δ֪״̬)
        result = 32'b0;
        zero = 0;

        // ���� aluControl ִ�в���
        case (aluControl)
            5'b00000: result = src1 + src2;           // �ӷ� (addu, lw, sw)
            5'b00001: result = src1 - src2;           // ���� (subu, beq)
            5'b00010: result = src1 | src2;           // ��λ�� (ori)
            5'b00011: result = {src2[15:0], 16'b0};   // ��������������λ (lui)
            default: result = 32'b0;                  // δ�����������0
        endcase

        // �������־ (������ beq)
        if (result == 32'b0)
            zero = 1;
    end
endmodule
