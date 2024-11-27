module DataMemory(
    input wire clk,
    input wire memRead, memWrite,
    input wire [31:0] address, writeData,
    output reg [31:0] readData
);
    reg [31:0] dataMemory [1023:0];  // 4 KiB ´æ´¢
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1)
            dataMemory[i] = 32'b0;  // ³õÊ¼»¯Îª 0
    end
    always @(posedge clk) begin
        if (memWrite)
            dataMemory[address[11:2]] <= writeData;
    end

    always @(*) begin
        if (memRead)
            readData = dataMemory[address[11:2]];
        else
            readData = 32'b0;
    end
    
endmodule
