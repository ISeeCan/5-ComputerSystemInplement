//`timescale 1ns / 1ps
//changed to BELOW to be faster
`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/14 14:30:27
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu(
    input [31:0] A,
    input [31:0] B,
    input [5:0] Op,
    output [31:0] C,
    output Over
    );
    
    reg [31:0] Ctemp;
    reg Overtemp;
    reg signed [31:0] Bsigned;
    wire [31:0] adderout;
    wire [31:0] subberout;
    wire [31:0] sum_result, sum_sub;
    wire [31:0] bOp;
    assign bOp=~B+1;
    adder cla0 (.a(A), .b(B), .sum(sum_result), .cout(adderout));
    adder cla1 (.a(A), .b(bOp), .sum(sum_sub), .cout(subberout));
    
    always @(*) begin
        Bsigned = B;
        // ��ʼ�����
        Ctemp = 32'b0;
        Overtemp = 0;
        // ���� Op �ź�ѡ��ͬ������
        case(Op)
            6'b100000: begin  // �з��������-0x20
                Ctemp = sum_result;  // �ӷ���������
                Overtemp = (A[31] == B[31]) && (Ctemp[31] != A[31]); // �ж����
            end
            6'b100001: begin  // �޷��������-0x21
                Ctemp = sum_result;
                Overtemp = 0;
            end
            6'b100010: begin  // �з��������-0x22
                Ctemp = sum_sub;
                Overtemp = (A[31] != B[31]) && (Ctemp[31] != A[31]);
            end
            6'b100011: begin  // �޷��������-0x23
                Ctemp = sum_sub;
                Overtemp = 0;
            end
            6'b000000: begin  // �߼�����-0
                Ctemp = B << A[4:0];  // B���ƣ�A[4:0]��ʾ��λ��λ����ע���������ֻ��λ31λ��
                Overtemp = 0;  // �߼���λ���������
            end

            6'b000010: begin  // �߼�����-2
                Ctemp = B >> A[4:0];  // B���ƣ�A[4:0]��ʾ��λ��λ��
                Overtemp = 0;  // �߼���λ���������
            end
            6'b000011: begin  // ��������-3
                if (B[31]==1) begin
                    Ctemp = Bsigned >>> A[4:0];  // B�����ŵ��������ƣ�A[4:0]��ʾ��λ��λ��
                end else begin
                    Ctemp = B >>> A[4:0];  // B�������ƣ�A[4:0]��ʾ��λ��λ��
                end
                Overtemp = 0;  // ������λ���������
            end

            6'b100100: begin  // ��λ��-0x24
                Ctemp = A & B;  // A��B��λ��
                Overtemp = 0;  // ��λ������������
            end
            6'b100101: begin  // ��λ��-0x29
                Ctemp = A | B;  // A��B��λ��
                Overtemp = 0;  // ��λ�������������
            end
            6'b100110: begin  // ��λ���-0x26
                Ctemp = A ^ B;  // A��B��λ���
                Overtemp = 0;  // ��λ�������������
            end
            6'b100111: begin  // ��λ���-0x27
                Ctemp = ~(A | B);  // A��B��λ��Ȼ��ȡ��
                Overtemp = 0;  // ��λ�������������
            end
            default: begin  // ��Ч����
                Ctemp = 32'b0;
                Overtemp = 0;
            end
        endcase 
    end
    
    assign C = Ctemp;
    assign Over = Overtemp;
    
endmodule
