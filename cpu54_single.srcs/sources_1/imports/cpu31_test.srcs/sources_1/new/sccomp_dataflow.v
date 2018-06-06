`timescale 1ns / 1ps

module sccomp_dataflow(
    input  clk_in,
    input  reset,
    output [31:0] inst,     //instruction
    output [31:0] pc,       //program counter
    output [31:0] addr      //aluout?
    );
    
    wire [31:0] dmem_data_in, dmem_data_out;
    wire dmem_cs, dmem_wena;
//    wire clk;
    wire [31:0] pc_out = pc - 32'h00400000;
//    clk_div myclk(clk_in, ~reset, clk);
    
    cpu sccpu(
        .clk(clk_in),   //clk
        .reset(reset),
        .inst(inst),
        .dmem_data_out(dmem_data_out),  //data out from dmem
        
        .pc(pc),
        .aluout(addr),                  //addr & result
        .dmem_data_in(dmem_data_in),    //data in to dmem
        .dmem_cs(dmem_cs),              //dmem ena
        .dmem_wena(dmem_wena)           //write or read (write:1_data_in | read:0_data_out)
    );
    
//    dist_mem_gen_0 scimem (
//      .a(pc_out[12:2]),      // input wire [10 : 0] a
//      .spo(inst)  // output wire [31 : 0] spo
//    );
    
    imem scimem(
        .addr(pc_out[12:2]), 
        .inst(inst)
    );

    dmem scdmem(
        .clk(~clk_in),  //clk 
        .reset(reset),
        .ena(dmem_cs),
        .wena(dmem_wena),
        .addr(addr - 32'h10010000),//  ? 
        .data_in(dmem_data_in), 
        
        .data_out(dmem_data_out) 
    );

    
endmodule