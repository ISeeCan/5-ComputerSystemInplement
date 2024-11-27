module ProgramCounter(
    input wire clk,
    input wire reset,
    input wire [31:0] jumpInput,      // ��תĿ���ַ
    input wire jumpEnabled,          // ��תʹ���ź�
    output reg [31:0] pcValue        // ��ǰPCֵ
);

    // PC��ʼ����ַ
    localparam INIT_PC = 32'h00003000;
    initial begin
        pcValue <= INIT_PC;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // ��ʼ��PCֵ
            pcValue <= INIT_PC;
        end else if (jumpEnabled) begin
            // ��תʱʹ�ö����ַ
            pcValue <= {jumpInput[31:2], 2'b00};  // ȷ����ַ���뵽4�ֽ�
        end else begin
            // Ĭ������£�PC����
            pcValue <= pcValue + 4;
        end
    end
endmodule
