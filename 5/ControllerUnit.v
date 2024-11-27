module ControllerUnit(
    input wire [5:0] opcode,         // 操作码
    input wire [5:0] funct,          // 功能码 (R 型指令特有)
    output reg [4:0] aluControl,     // ALU 控制信号
    output reg memRead,              // 数据存储器读使能
    output reg memWrite,             // 数据存储器写使能
    output reg regWrite,             // 寄存器写使能
    output reg jump,                 // 跳转信号
    output reg jumpr,                 // 跳转信号
    output reg jumpj,                 // 跳转信号
    output reg branch,               // 分支信号 (beq)
    output reg syscall,              // 系统调用
    output reg aluSrc,               // ALU 输入来源选择
    output reg [1:0] regDst,         // 寄存器目标选择信号
    output reg [1:0] memToReg        // 写回数据来源信号
);
    // 定义 ALU 操作码
    localparam ALU_ADD  = 5'b00000;  // 加法
    localparam ALU_SUB  = 5'b00001;  // 减法
    localparam ALU_OR   = 5'b00010;  // 按位或
    localparam ALU_LUI  = 5'b00011;  // 加载立即数到高位
    
    initial begin
        aluControl = 5'b00000;
        memRead = 0;
        memWrite = 0;
        regWrite = 0;
        jump = 0;
        jumpr = 0;
        jumpj = 0;
        branch = 0;
        syscall = 0;
        aluSrc = 0;
        regDst = 2'b00;
        memToReg = 2'b00;
    end
    
    always @(*) begin
        // 默认信号值
        aluControl = 5'b00000;
        memRead = 0;
        memWrite = 0;
        regWrite = 0;
        jump = 0;
        jumpr = 0;
        jumpj = 0;
        branch = 0;
        syscall = 0;
        aluSrc = 0;
        regDst = 2'b00;
        memToReg = 2'b00;

        case (opcode)
            // R 型指令
            6'b000000: begin
                case (funct)
                    6'b100001: begin  // addu
                        aluControl = ALU_ADD;
                        regWrite = 1;
                        regDst = 2'b01;   // 写入 rd
                        memToReg = 2'b00; // 数据来源：ALU 结果
                    end
                    6'b100011: begin  // subu
                        aluControl = ALU_SUB;
                        regWrite = 1;
                        regDst = 2'b01;   // 写入 rd
                        memToReg = 2'b00; // 数据来源：ALU 结果
                    end
                    6'b001000: begin  // jr Jump Register
                        jump = 1;
                        jumpr = 1;
                    end
                    6'b001100: begin  // syscall
                        syscall = 1;
                    end
                    default: begin
                        // 未定义的 R 型功能码
                    end
                endcase
            end
            // I 型指令
            6'b001101: begin  // ori Or Immediate
                aluControl = ALU_OR;
                regWrite = 1;
                aluSrc = 1;         // 第二操作数使用立即数
                regDst = 2'b00;     // 写入 rt
                memToReg = 2'b00;   // 数据来源：ALU 结果
            end
            6'b100011: begin  // lw
                aluControl = ALU_ADD;  // 地址计算使用加法
                memRead = 1;
                regWrite = 1;
                aluSrc = 1;         // 第二操作数使用立即数
                regDst = 2'b00;     // 写入 rt
                memToReg = 2'b01;   // 数据来源：内存
            end
            6'b101011: begin  // sw
                aluControl = ALU_ADD;  // 地址计算使用加法
                memWrite = 1;
                aluSrc = 1;         // 第二操作数使用立即数
            end
            6'b000100: begin  // beq  Branch on Equal Likely
                aluControl = ALU_SUB;  // 使用减法判断相等
                branch = 1;
            end
            6'b001111: begin  // lui Load Upper Immediate
                aluControl = ALU_LUI;
                regWrite = 1;
                regDst = 2'b00;     // 写入 rt
                aluSrc = 1;         // 第二操作数使用立即数
                memToReg = 2'b00;   // 数据来源：ALU 结果
            end
            // J 型指令
            6'b000011: begin  // jal Jump and Link
                jump = 1;
                regWrite = 1;       // 写入 $ra
                regDst = 2'b10;     // 写入目标寄存器为 $ra
                memToReg = 2'b10;   // 数据来源：PC + 4
            end
            6'b000010: begin  // jj Jump Register
                        jump = 1;
                        jumpj = 1;
                    end
            default: begin
                // 未定义的操作码
            end
        endcase
    end
endmodule
