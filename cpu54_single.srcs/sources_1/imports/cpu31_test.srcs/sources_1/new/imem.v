`timescale 1ns / 1ps

module imem #(parameter MAX_SIZ = 1024, MAX_BIT = 11)(
    input [MAX_BIT - 1'b1:0] addr,
    output [31:0] inst
);
    reg [31: 0] RAM[0: MAX_SIZ - 1'b1];
    initial begin
        $readmemh("infile.dat", RAM);
    end
    
    assign inst = RAM[addr];
endmodule