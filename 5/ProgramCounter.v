module ProgramCounter(
    input wire clk,
    input wire reset,
    input wire [31:0] jumpInput,      // 跳转目标地址
    input wire jumpEnabled,          // 跳转使能信号
    output reg [31:0] pcValue        // 当前PC值
);

    // PC初始化地址
    localparam INIT_PC = 32'h00003000;
    initial begin
        pcValue <= INIT_PC;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // 初始化PC值
            pcValue <= INIT_PC;
        end else if (jumpEnabled) begin
            // 跳转时使用对齐地址
            pcValue <= {jumpInput[31:2], 2'b00};  // 确保地址对齐到4字节
        end else begin
            // 默认情况下，PC自增
            pcValue <= pcValue + 4;
        end
    end
endmodule
