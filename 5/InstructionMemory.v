module InstructionMemory(
    input wire [31:0] address,       // ����ָ���ַ
    output reg [31:0] instruction    // ���ָ��
);
    reg [31:0] instructionMemory [1023:0];  // ָ��洢�ռ�

    // �ڳ�ʼ��ʱ�����ļ�����
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            instructionMemory[i] = 32'h00000000;  // ������ָ���ʼ��Ϊ 0
        end
        $readmemh("C:\\YOUR-PATH-TO-CODE\\code.txt", instructionMemory);
        for (i = 0; i < 64; i = i + 1) begin //����Ӧ�õ�1024��������Ϊʾ��ѹ��û��ô�����Ͳ������ô����
            $display("instructionMemory[%0d] = %h", i, instructionMemory[i]);
        end
    end
    
    localparam INIT_PC = 32'h00003000;
    // ���ݵ�ַȡָ��
    always @(*) begin
        if (address >= INIT_PC) begin
            instruction = instructionMemory[(address - INIT_PC) >> 2];  // ��ȥ����ַ������
        end else begin
            instruction = 32'h00000000;  // �Ƿ���ַ�����ؿ�ָ��
        end
    end
endmodule
