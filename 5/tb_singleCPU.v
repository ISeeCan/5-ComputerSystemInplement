`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/22 09:49:14
// Design Name: 
// Module Name: tb_singleCPU
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


module tb_SingleCPU;
    reg clock;
    reg reset;

// Change the TopLevel module's name to yours
SingleCPU topLevel(.reset(reset), .clock(clock));

integer k;
initial begin
    // posedge clock

    // Hold reset for one cycle
    reset = 1;
    clock = 0; #1;
    clock = 1; #1;
    clock = 0; #1;
    reset = 0; #1;
    
    //$stop; // Comment this line if you don't need per-cycle debugging
    
    #1;
    
    for (k = 0; k < 50000; k = k + 1) begin // 5000 clocks
        clock = 1; #5;
        clock = 0; #5;
        
        
        //我额外增加的
        if(k<128) begin
        $display("--Line: %d | PC: %h | Instruction: %h | Time: %t | Clock: %b | Next_PC:: %h", 
             k, topLevel.pc, topLevel.instruction,$time, clock, topLevel.next_pc);
        $display(" AluCtrl: %b | AluSRC1: %h | AluSRC2: %h  | ALU Result: %h | aluSrc:%b ? Im : reg | inst_mem：%h | readInc:%h", 
             topLevel.aluControl, topLevel.alu.src1, topLevel.alu.src2, topLevel.aluResult, topLevel.aluSrc,topLevel.inst_mem.address,(topLevel.inst_mem.address - 32'h00003000) >> 2);
        $display("  memR:%b | memW:%b |  Jump:%b | branch:%b | aluZero:%b | sExtIm:%h", 
              topLevel.memRead,topLevel.memWrite, topLevel.jump, topLevel.branch, topLevel.aluZero, topLevel.signExtImm);
        $display("  memADD:%h | memRdata:%h | memWdata:%h\n", 
              topLevel.aluResult,topLevel.memData, topLevel.regData2);
        end
        
        // 检查 `syscall` 信号
        if (topLevel.syscall) begin
            $display("Simulation ended due to syscall.");
            $finish;
        end
        
    end

    // Please finish with `syscall`, finishes here may mean the clocks are not enough
    $finish;
end
endmodule

