`timescale 1ns / 1ps

module MULT_tb;
    reg clk;
    reg reset;
    reg [31:0]  a;
    reg [31:0]  b;
    wire [63:0]  z;

    initial begin
        #0  clk = 0;        reset = 1'b0;        a = 32'b0;  b = 32'b0;
        repeat(30)
            #5 clk = ~clk;      
    end
    
    initial begin
        #10 reset = 1'b1;  a = 32'hFFFF_FFFF;  b = 32'h0000_0001;
   //#10 reset = 1'b1;  a = 32'h0000_FFFF;  b = 32'hFFFF_0000;
   //#10 reset = 1'b1;  a = 32'hFFFF_FFFF;  b = 32'h0000_FFFF;
   //#10 reset = 1'b1;  a = 32'h0000_FFFF;  b = 32'h0000_0001;
   //#10 reset = 1'b1;  a = 32'hFFFF_0000;  b = 32'hFFFF_FFFF;
   //#10 reset = 1'b1;  a = 32'h0000_0001;  b = 32'h00FF_FF01;
   //#10 reset = 1'b1;  a = 32'h1111_1111;  b = 32'h0000_0002;
   //#10 reset = 1'b1;  a = 32'h0000_0002;  b = 32'h1111_1111;
   //#10 reset = 1'b1;  a = 32'h0000_0000;  b = 32'h0000_0000;

    end
    
    MULT
    MULT_inst(
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .z(z)
        );
     
endmodule
