module GeneralPurposeRegisters(
    input wire clk,
    input wire reset,
    input wire regWrite,
    input wire [4:0] rs, rt, rd,
    input wire [31:0] writeData,
    output reg [31:0] readData1, readData2
);
    reg [31:0] registers [31:0];
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
                registers[i] = 32'b0;  // 或者直接写为 0
        end
        readData1 = registers[0];
        readData2 = registers[0];
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            // 重置寄存器
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] = 32'b0;  // 或者直接写为 0
            
            readData1 = registers[0];
            readData2 = registers[0];
            end
        else if (regWrite)
            registers[rd] <= writeData;
    end

    always @(*) begin
        readData1 = registers[rs];
        readData2 = registers[rt];
    end
endmodule
