module ArithmeticLogicUnit(
    input wire [31:0] src1,          // 第一个操作数
    input wire [31:0] src2,          // 第二个操作数
    input wire [4:0] aluControl,     // ALU 控制信号
    output reg [31:0] result,        // 运算结果
    output reg zero                  // 零标志，用于分支判断
);

    initial begin
        result = 32'b0;
        zero = 0;
    end
    
    always @(*) begin
        // 默认值 (避免未知状态)
        result = 32'b0;
        zero = 0;

        // 根据 aluControl 执行操作
        case (aluControl)
            5'b00000: result = src1 + src2;           // 加法 (addu, lw, sw)
            5'b00001: result = src1 - src2;           // 减法 (subu, beq)
            5'b00010: result = src1 | src2;           // 按位或 (ori)
            5'b00011: result = {src2[15:0], 16'b0};   // 加载立即数到高位 (lui)
            default: result = 32'b0;                  // 未定义操作返回0
        endcase

        // 设置零标志 (适用于 beq)
        if (result == 32'b0)
            zero = 1;
    end
endmodule
