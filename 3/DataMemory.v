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
    
    reg [31:0] data [1023:0]; // 4 KiB �Ĵ洢��
    integer i;
    always @(posedge clock) begin
        if (reset) begin
            // ��ʼ�����ݴ洢������ʡ�Ի򲿷ֳ�ʼ����
            for (i = 0; i < 1024; i = i + 1) 
                data[i] <= 32'b0;
        end
        else if (writeEnabled) begin
            // д������
            data[address[31:2]] <= writeInput;
        end
    end

    // ��ȡ����������߼���
    always @(*) begin
        readResult = data[address[31:2]];
    end
    
endmodule
