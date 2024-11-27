module ControllerUnit(
    input wire [5:0] opcode,         // ������
    input wire [5:0] funct,          // ������ (R ��ָ������)
    output reg [4:0] aluControl,     // ALU �����ź�
    output reg memRead,              // ���ݴ洢����ʹ��
    output reg memWrite,             // ���ݴ洢��дʹ��
    output reg regWrite,             // �Ĵ���дʹ��
    output reg jump,                 // ��ת�ź�
    output reg jumpr,                 // ��ת�ź�
    output reg jumpj,                 // ��ת�ź�
    output reg branch,               // ��֧�ź� (beq)
    output reg syscall,              // ϵͳ����
    output reg aluSrc,               // ALU ������Դѡ��
    output reg [1:0] regDst,         // �Ĵ���Ŀ��ѡ���ź�
    output reg [1:0] memToReg        // д��������Դ�ź�
);
    // ���� ALU ������
    localparam ALU_ADD  = 5'b00000;  // �ӷ�
    localparam ALU_SUB  = 5'b00001;  // ����
    localparam ALU_OR   = 5'b00010;  // ��λ��
    localparam ALU_LUI  = 5'b00011;  // ��������������λ
    
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
        // Ĭ���ź�ֵ
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
            // R ��ָ��
            6'b000000: begin
                case (funct)
                    6'b100001: begin  // addu
                        aluControl = ALU_ADD;
                        regWrite = 1;
                        regDst = 2'b01;   // д�� rd
                        memToReg = 2'b00; // ������Դ��ALU ���
                    end
                    6'b100011: begin  // subu
                        aluControl = ALU_SUB;
                        regWrite = 1;
                        regDst = 2'b01;   // д�� rd
                        memToReg = 2'b00; // ������Դ��ALU ���
                    end
                    6'b001000: begin  // jr Jump Register
                        jump = 1;
                        jumpr = 1;
                    end
                    6'b001100: begin  // syscall
                        syscall = 1;
                    end
                    default: begin
                        // δ����� R �͹�����
                    end
                endcase
            end
            // I ��ָ��
            6'b001101: begin  // ori Or Immediate
                aluControl = ALU_OR;
                regWrite = 1;
                aluSrc = 1;         // �ڶ�������ʹ��������
                regDst = 2'b00;     // д�� rt
                memToReg = 2'b00;   // ������Դ��ALU ���
            end
            6'b100011: begin  // lw
                aluControl = ALU_ADD;  // ��ַ����ʹ�üӷ�
                memRead = 1;
                regWrite = 1;
                aluSrc = 1;         // �ڶ�������ʹ��������
                regDst = 2'b00;     // д�� rt
                memToReg = 2'b01;   // ������Դ���ڴ�
            end
            6'b101011: begin  // sw
                aluControl = ALU_ADD;  // ��ַ����ʹ�üӷ�
                memWrite = 1;
                aluSrc = 1;         // �ڶ�������ʹ��������
            end
            6'b000100: begin  // beq  Branch on Equal Likely
                aluControl = ALU_SUB;  // ʹ�ü����ж����
                branch = 1;
            end
            6'b001111: begin  // lui Load Upper Immediate
                aluControl = ALU_LUI;
                regWrite = 1;
                regDst = 2'b00;     // д�� rt
                aluSrc = 1;         // �ڶ�������ʹ��������
                memToReg = 2'b00;   // ������Դ��ALU ���
            end
            // J ��ָ��
            6'b000011: begin  // jal Jump and Link
                jump = 1;
                regWrite = 1;       // д�� $ra
                regDst = 2'b10;     // д��Ŀ��Ĵ���Ϊ $ra
                memToReg = 2'b10;   // ������Դ��PC + 4
            end
            6'b000010: begin  // jj Jump Register
                        jump = 1;
                        jumpj = 1;
                    end
            default: begin
                // δ����Ĳ�����
            end
        endcase
    end
endmodule
