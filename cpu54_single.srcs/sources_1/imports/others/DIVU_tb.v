`timescale 1ns / 1ps

module DIVU_tb;
    reg [31:0] dividend;  
    reg [31:0] divisor;    
    reg start;           
    reg clock;
    reg reset;
    wire [31:0] q;       
    wire [31:0] r;         
    wire busy;
        
    
    initial begin
        #0  clock = 1'b0;   reset = 1'b0;   start = 0;  
        repeat(500)
            #1 clock = ~clock;
    end
    
    initial begin
        #5 reset = 1;  start = 0;
        #5 reset = 0;  start = 1;  
            dividend = 32'h0000_0000;   divisor = 32'hFFFF_FFFF;
        #5 start = 0;
        @(negedge busy)
        #5 reset = 1;  start = 0;
        #5 reset = 0;  start = 1;  
            dividend = 32'haaaa_aaaa;   divisor = 32'haaaa_aaaa;
        #5 start = 0;
        @(negedge busy)
        #5 reset = 1;  start = 0;
        #5 reset = 0;  start = 1;  
            dividend = 32'h5555_5555;   divisor = 32'h5555_5554;
        #5 start = 0;
        @(negedge busy)
        #5 reset = 1;  start = 0;
        #5 reset = 0;  start = 1;  
            dividend = 32'h7FFF_FFFF;   divisor = 32'h7FFF_FFFF;
        #5 start = 0;
        @(negedge busy)
        #5 reset = 1;  start = 0;
        #5 reset = 0;  start = 1;  
            dividend = 32'hFFFF_FFFF;   divisor = 32'hFFFF_FFFF;
        #5 start = 0;
    end
    
    DIVU
    DIVU_inst(
        .dividend(dividend),
        .divisor(divisor),
        .start(start),
        .clock(clock),
        .reset(reset),
        .q(q),
        .r(r),
        .busy(busy)
        );
    
endmodule
