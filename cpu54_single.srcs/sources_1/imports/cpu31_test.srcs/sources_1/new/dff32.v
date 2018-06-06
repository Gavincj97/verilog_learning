`timescale 1ns / 1ps

module dff32#(parameter Init = 32'b0)(
    input CLK,
    input [31:0] D,
    input reset,	
	input ready,

    output reg [31:0] Q
    );
    
	always @(posedge CLK or posedge reset) begin
		if(reset)
			Q <= Init;
		else if(ready)
			Q <= D;
	end					
endmodule
