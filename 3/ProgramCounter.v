`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/26 16:56:08
// Design Name: 
// Module Name: ProgramCounter
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


module ProgramCounter(
    input reset,
    input clock,
    input jumpEnabled,
    input [31:0] jumpInput,
    output reg [31:0] pcValue
    );
    
    always @(posedge clock) begin
        if (reset) 
            pcValue <= 32'h00003000;  // 重置时初始化为指定值
        else if (jumpEnabled) 
            pcValue <= jumpInput;  // 跳转
        else 
            pcValue <= pcValue + 4;  // 正常情况下每次增加4
    end
    
endmodule
