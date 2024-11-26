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
            pcValue <= 32'h00003000;  // ����ʱ��ʼ��Ϊָ��ֵ
        else if (jumpEnabled) 
            pcValue <= jumpInput;  // ��ת
        else 
            pcValue <= pcValue + 4;  // ���������ÿ������4
    end
    
endmodule
