
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/26 10:38:14
// Design Name: 
// Module Name: MyAdder32
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

module adder_4bit (
    input [3:0] A, B,     // 4位输入A和B
    input Cin,            // 输入的进位
    output [3:0] sum,     // 4位输出和
    output Cout           // 输出的进位
);
    wire [3:0] G, P;      // 产生进位和传播进位
    wire [3:1] C;         // 进位信号

    // 产生进位和传播进位信号
    assign G = A & B;     // 产生进位
    assign P = A ^ B;     // 传播进位

    // 计算进位
//    assign C[1] = G[0] | (P[0] & Cin);
//    assign C[2] = G[1] | (P[1] & C[1]) 
//    assign C[3] = G[2] | (P[2] & C[2]); 
//    assign Cout = G[3] | (P[3] & C[3]); 

    assign C[1] = G[0] | (P[0] & Cin);
    assign C[2] = G[1] | P[1] & G[0] | P[1] & P[0] & Cin;
    assign C[3] = G[2] | G[1] & P[2] | G[0] & P[1] & P[2] | P[0] & P[1] & P[2] & Cin;
    assign Cout = G[3] | G[2] & P[3] | G[1] & P[2] & P[3] | G[0] & P[1] & P[2] & P[3] | P[0] & P[1] & P[2] & P[3] & Cin;
    // 计算和
    assign sum[0] = P[0] ^ Cin;
    assign sum[1] = P[1] ^ C[1];
    assign sum[2] = P[2] ^ C[2];
    assign sum[3] = P[3] ^ C[3];
endmodule


module adder(input [31:0] a,input[31:0] b,output[31:0] sum
    );
     wire [7:0] C;        // 进位信号
    // 实例化8个4位CLA模块
    adder_4bit cla0 (a[3:0],   b[3:0],   0,    sum[3:0],   C[0]);
    adder_4bit cla1 (a[7:4],   b[7:4],   C[0],   sum[7:4],   C[1]);
    adder_4bit cla2 (a[11:8],  b[11:8],  C[1],   sum[11:8],  C[2]);
    adder_4bit cla3 (a[15:12], b[15:12], C[2],   sum[15:12], C[3]);
    adder_4bit cla4 (a[19:16], b[19:16], C[3],   sum[19:16], C[4]);
    adder_4bit cla5 (a[23:20], b[23:20], C[4],   sum[23:20], C[5]);
    adder_4bit cla6 (a[27:24], b[27:24], C[5],   sum[27:24], C[6]);
    adder_4bit cla7 (a[31:28], b[31:28], C[6],   sum[31:28], Cout);
endmodule

