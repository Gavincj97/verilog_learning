`timescale 1ns / 1ps

module extend #(parameter A = 16, parameter B = 32)( 
    input [A - 1:0] a, 
    input sext, 
    output [B - 1:0] b 
    );
    assign b=sext? {{(B - A){a[A - 1]}},a} : {32'b0, a}; 
endmodule 
