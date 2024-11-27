module InstructionMemory(
    input wire [31:0] address,       // 输入指令地址
    output reg [31:0] instruction    // 输出指令
);
    reg [31:0] instructionMemory [1023:0];  // 指令存储空间

    // 在初始化时加载文件内容
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            instructionMemory[i] = 32'h00000000;  // 将所有指令初始化为 0
        end
        $readmemh("C:\\YOUR-PATH-TO-CODE\\code.txt", instructionMemory);
        for (i = 0; i < 64; i = i + 1) begin //本身应该到1024，但是因为示例压根没那么长，就不输出那么多了
            $display("instructionMemory[%0d] = %h", i, instructionMemory[i]);
        end
    end
    
    localparam INIT_PC = 32'h00003000;
    // 根据地址取指令
    always @(*) begin
        if (address >= INIT_PC) begin
            instruction = instructionMemory[(address - INIT_PC) >> 2];  // 减去基地址并对齐
        end else begin
            instruction = 32'h00000000;  // 非法地址，返回空指令
        end
    end
endmodule
