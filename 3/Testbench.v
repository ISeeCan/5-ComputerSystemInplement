`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 11:48:51
// Design Name: 
// Module Name: Testbench
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

module tb;  // �����ļ������˿�
    reg clock;
    reg reset;
    reg jumpEnabled;
    reg [31:0] jumpInput;
    wire [31:0] pcValue;

    // ʵ���� ProgramCounter ģ��
    ProgramCounter pc (
        .clock(clock),
        .reset(reset),
        .jumpEnabled(jumpEnabled),
        .jumpInput(jumpInput),
        .pcValue(pcValue)
    );
    
    reg reset2;  // ������λ�ź�
    reg [31:0] address;  // ������ַ�ź�
    reg writeEnabled;  // ����дʹ���ź�
    reg [31:0] writeInput;  // ����д������
    wire [31:0] readResult;  // ������ȡ������

    // ʵ���� DataMemory ģ��
    DataMemory dm (
        .reset(reset2),
        .clock(clock),
        .address(address),
        .writeEnabled(writeEnabled),
        .writeInput(writeInput),
        .readResult(readResult)
    );

    // ����ʱ���ź�
    always #5 clock = ~clock;  // ʱ��ÿ5ns��תһ�Σ���Ӧ10ns������

    initial begin
        // ��ʼ�������ź�
        clock = 0;
        reset = 1;
        jumpEnabled = 0;
        jumpInput = 32'h00003000;

        // ���ø�λ�źţ�����һ��ʱ�����ں�ȡ��
        #10 reset = 0;  // ��10ns��ȡ����λ

        // ��� PC ����
        #10 jumpEnabled = 0;

        // ������ת
        #20 jumpEnabled = 1;
        jumpInput = 32'h00004000;
        #10 jumpEnabled = 0;
        
        reset2 = 1;  // ���λ                                             //�洢���Ĳ���
        writeEnabled = 0;
        writeInput = 32'h00000000;  // ��ʼ��д������
        address = 32'h00000000;  // ��ʼ����ַ

        // ���ø�λ�źţ�����һ��ʱ�����ں�ȡ��
        #10 reset2 = 0;  // ��10ns��ȡ����λ
        
        // ����д�����
        #10 address = 32'h00000004;  // ����Ŀ���ַ
        writeInput = 32'hA5A5A5A5;  // ����д������
        writeEnabled = 1;  // ����д��
        #10 writeEnabled = 0;  // ��10ns�����д��

        // ���Զ�ȡ����
        #20 writeEnabled = 0;  // ȷ��д���ѽ���
        address = 32'h00000004;  // ����Ҫ��ȡ�ĵ�ַ
        #10;  // �ȴ�һ��ʱ������

        // �۲����������ȷ�� PC ��ȷ����
        #100 $finish;  // ��������
    end
endmodule

