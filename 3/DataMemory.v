`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/26 17:04:28
// Design Name: 
// Module Name: DataMemory
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


module DataMemory(
    input reset,
    input clock,
    input [31:0] address,
    input writeEnabled,
    input [31:0] writeInput,
    output reg [31:0] readResult
    );
    
    reg [31:0] data [1023:0]; // 4 KiB 的存储器
    integer i;
    always @(posedge clock) begin
        if (reset) begin
            // 初始化数据存储器（可省略或部分初始化）
            for (i = 0; i < 1024; i = i + 1) 
                data[i] <= 32'b0;
        end
        else if (writeEnabled) begin
            // 写入数据
            data[address[31:2]] <= writeInput;
        end
    end

    // 读取操作（组合逻辑）
    always @(*) begin
        readResult = data[address[31:2]];
    end
    
endmodule
