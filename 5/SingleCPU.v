`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/15 14:30:08
// Design Name: 
// Module Name: SingleCPU
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


module SingleCPU(
    input wire clock,                // ʱ���ź�
    input wire reset                 // ��λ�ź�
);
    // -------------------
    // ����ͨ·�źŶ���
    // -------------------

    // Program Counter
    wire [31:0] pc, next_pc;

    // Instruction Memory
    wire [31:0] instruction;

    // Controller Signals
    wire regWrite, memRead, memWrite, aluSrc, jump,jumpr, branch, syscall,jumpj;
    wire [1:0] regDst, memToReg;
    wire [4:0] aluControl;

    // General Purpose Registers
    wire [31:0] regData1, regData2, writeData;
    wire [4:0] writeReg;

    // ALU
    wire [31:0] aluResult;
    wire aluZero;

    // Data Memory
    wire [31:0] memData;

    // Immediate Extension
    wire [31:0] signExtImm;

    // -------------------
    // ģ��ʵ����
    // -------------------

    // 1. Program Counter
    ProgramCounter pc_module (
        .clk(clock),
        .reset(reset),
        .jumpInput(next_pc),
        .jumpEnabled(1'b1),          // ʼ��֧����ת
        .pcValue(pc)
    );

    // 2. Instruction Memory
    InstructionMemory inst_mem (
        .address(pc),
        .instruction(instruction)
    );

    // 3. Controller Unit
    ControllerUnit controller (
        .opcode(instruction[31:26]),
        .funct(instruction[5:0]),
        .regWrite(regWrite),
        .aluSrc(aluSrc),
        .regDst(regDst),
        .memRead(memRead),
        .memWrite(memWrite),
        .memToReg(memToReg),
        .branch(branch),
        .jump(jump),
        .jumpr(jumpr),
        .jumpj(jumpj),
        .syscall(syscall),
        .aluControl(aluControl)
    );

    // 4. General Purpose Registers
    GeneralPurposeRegisters reg_file (
        .clk(clock),
        .reset(reset),
        .regWrite(regWrite),
        .rs(instruction[25:21]),
        .rt(instruction[20:16]),
        .rd(writeReg),
        .writeData(writeData),
        .readData1(regData1),
        .readData2(regData2)
    );

    // 5. Arithmetic Logic Unit (ALU)
    ArithmeticLogicUnit alu (
        .src1(regData1),
        .src2(aluSrc ? signExtImm : regData2),  // �ڶ�����������������Ĵ���ֵ
        .aluControl(aluControl),
        .result(aluResult),
        .zero(aluZero)
    );

    // 6. Data Memory
    DataMemory data_mem (
        .clk(clock),
        .memRead(memRead),
        .memWrite(memWrite),
        .address(aluResult),
        .writeData(regData2),
        .readData(memData)
    );

    // -------------------
    // �ź��������߼�
    // -------------------

    // ������չ������
    assign signExtImm = {{16{instruction[15]}}, instruction[15:0]};

    // ��һ��ָ���ַ����
    assign next_pc = syscall ? 32'b0 :  (jump? ( jumpr?regData1 :{pc[31:28], instruction[25:0], 2'b00} )  :  ( (branch && aluZero)?(pc+4+(signExtImm << 2)):pc + 4 ) )      ;                                    // Ĭ�ϵ���
    
    
    // д��Ĵ���Ŀ��ѡ��
    assign writeReg = (regDst == 2'b00) ? instruction[20:16] :  // rt
                            (regDst == 2'b01) ? instruction[15:11] :  // rd
                                    5'd31;                                   // $ra (jal)

    // д�ؼĴ�������ѡ��
    assign writeData = (memToReg == 2'b00) ? aluResult :        // ALU ���
                                (memToReg == 2'b01) ? memData :          // ���ݴ洢�����
                                        pc + 4;                                  // PC + 4 (jal)
                       
    //������
    integer i;
    initial begin
        #50000;  // ����ʱ�����
        $display("DataMemory Contents from Top Module:");
        for ( i = 0; i < 128; i = i + 1) begin
            //if (data_mem.dataMemory[i] !== 32'b0)  // ֱ�ӷ��ʾֲ�����
                $display("Address %h: %h", i * 4, data_mem.dataMemory[i]);
        end
    end
endmodule
