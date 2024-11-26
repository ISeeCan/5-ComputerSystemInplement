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

module tb;  // 激励文件不带端口
    reg clock;
    reg reset;
    reg jumpEnabled;
    reg [31:0] jumpInput;
    wire [31:0] pcValue;

    // 实例化 ProgramCounter 模块
    ProgramCounter pc (
        .clock(clock),
        .reset(reset),
        .jumpEnabled(jumpEnabled),
        .jumpInput(jumpInput),
        .pcValue(pcValue)
    );
    
    reg reset2;  // 声明复位信号
    reg [31:0] address;  // 声明地址信号
    reg writeEnabled;  // 声明写使能信号
    reg [31:0] writeInput;  // 声明写入数据
    wire [31:0] readResult;  // 声明读取结果输出

    // 实例化 DataMemory 模块
    DataMemory dm (
        .reset(reset2),
        .clock(clock),
        .address(address),
        .writeEnabled(writeEnabled),
        .writeInput(writeInput),
        .readResult(readResult)
    );

    // 生成时钟信号
    always #5 clock = ~clock;  // 时钟每5ns翻转一次，对应10ns的周期

    initial begin
        // 初始化输入信号
        clock = 0;
        reset = 1;
        jumpEnabled = 0;
        jumpInput = 32'h00003000;

        // 设置复位信号，持续一个时钟周期后取消
        #10 reset = 0;  // 在10ns后取消复位

        // 检查 PC 自增
        #10 jumpEnabled = 0;

        // 测试跳转
        #20 jumpEnabled = 1;
        jumpInput = 32'h00004000;
        #10 jumpEnabled = 0;
        
        reset2 = 1;  // 激活复位                                             //存储器的测试
        writeEnabled = 0;
        writeInput = 32'h00000000;  // 初始化写入数据
        address = 32'h00000000;  // 初始化地址

        // 设置复位信号，持续一个时钟周期后取消
        #10 reset2 = 0;  // 在10ns后取消复位
        
        // 测试写入操作
        #10 address = 32'h00000004;  // 设置目标地址
        writeInput = 32'hA5A5A5A5;  // 设置写入数据
        writeEnabled = 1;  // 启用写入
        #10 writeEnabled = 0;  // 在10ns后禁用写入

        // 测试读取操作
        #20 writeEnabled = 0;  // 确保写入已禁用
        address = 32'h00000004;  // 设置要读取的地址
        #10;  // 等待一个时钟周期

        // 观察更多周期以确保 PC 正确自增
        #100 $finish;  // 结束仿真
    end
endmodule

