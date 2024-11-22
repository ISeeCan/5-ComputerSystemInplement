`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/27 09:13:57
// Design Name: 
// Module Name: adder
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


module adder (
    input [31:0] a, b,     // 4λ����A��B
    output [31:0] sum     // 4λ�����
);
    wire [3:0] G, P;      // ������λ�ʹ�����λ
    wire [3:1] C;         // ��λ�ź�

    // ������λ�ʹ�����λ�ź�
    assign G = a & b;     // ������λ
    assign P = a ^ b;     // ������λ

    // �����λ
//    assign C[1] = G[0] | (P[0] & 0); = G[0] 
//    assign C[2] = G[1] | (P[1] & C[1]) = G[1] | (P[1] & (G[0] | (P[0] & 0))); = G[1] | P[1] & G[0] 
//    assign C[3] = G[2] | (P[2] & C[2]); = G[2] | G[1] & P[2] | G[0] & P[1] & P[2] 
//    assign Cout = G[3] | (P[3] & C[3]); = G[3] | G[2] & P[3] | G[1] & P[2] & P[3] | G[0] & P[1] & P[2] & P[3]

    assign C[1] = G[0];
    assign C[2] = G[1] | P[1] & G[0];
    assign C[3] = G[2] | G[1] & P[2] | G[0] & P[1] & P[2];
    assign Cout = G[3] | G[2] & P[3] | G[1] & P[2] & P[3] | G[0] & P[1] & P[2] & P[3];
    // �����
    assign sum[0] = P[0] ^ 0;
    assign sum[1] = P[1] ^ C[1];
    assign sum[2] = P[2] ^ C[2];
    assign sum[3] = P[3] ^ C[3];
    assign sum[31:4] = 28'b0;

endmodule