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
        // 初始化输出
        Ctemp = 32'b0;
        Overtemp = 0;
        // 根据 Op 信号选择不同的运算
        case(Op)
            6'b100000: begin  // 有符号数相加-0x20
                Ctemp = sum_result;  // 加法器输出结果
                Overtemp = (A[31] == B[31]) && (Ctemp[31] != A[31]); // 判断溢出
            end
            6'b100001: begin  // 无符号数相加-0x21
                Ctemp = sum_result;
                Overtemp = 0;
            end
            6'b100010: begin  // 有符号数相减-0x22
                Ctemp = sum_sub;
                Overtemp = (A[31] != B[31]) && (Ctemp[31] != A[31]);
            end
            6'b100011: begin  // 无符号数相减-0x23
                Ctemp = sum_sub;
                Overtemp = 0;
            end
            6'b000000: begin  // 逻辑左移-0
                Ctemp = B << A[4:0];  // B左移，A[4:0]表示移位的位数（注意这里最多只移位31位）
                Overtemp = 0;  // 逻辑移位不产生溢出
            end

            6'b000010: begin  // 逻辑右移-2
                Ctemp = B >> A[4:0];  // B右移，A[4:0]表示移位的位数
                Overtemp = 0;  // 逻辑移位不产生溢出
            end
            6'b000011: begin  // 算术右移-3
                if (B[31]==1) begin
                    Ctemp = Bsigned >>> A[4:0];  // B带符号的算术右移，A[4:0]表示移位的位数
                end else begin
                    Ctemp = B >>> A[4:0];  // B算术右移，A[4:0]表示移位的位数
                end
                Overtemp = 0;  // 算术移位不产生溢出
            end

            6'b100100: begin  // 按位与-0x24
                Ctemp = A & B;  // A和B按位与
                Overtemp = 0;  // 按位操作不产生溢
            end
            6'b100101: begin  // 按位或-0x29
                Ctemp = A | B;  // A和B按位或
                Overtemp = 0;  // 按位操作不产生溢出
            end
            6'b100110: begin  // 按位异或-0x26
                Ctemp = A ^ B;  // A和B按位异或
                Overtemp = 0;  // 按位操作不产生溢出
            end
            6'b100111: begin  // 按位或非-0x27
                Ctemp = ~(A | B);  // A和B按位或，然后取反
                Overtemp = 0;  // 按位操作不产生溢出
            end
            default: begin  // 无效操作
                Ctemp = 32'b0;
                Overtemp = 0;
            end
        endcase 
    end
    
    assign C = Ctemp;
    assign Over = Overtemp;
    
endmodule
