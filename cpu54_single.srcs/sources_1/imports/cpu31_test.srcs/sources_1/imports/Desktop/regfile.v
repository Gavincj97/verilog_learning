`timescale 1ns / 1ps

module regfile(
    input clk, 
    input reset, 
    input we,  
    input [4:0] raddr1, 
    input [4:0] raddr2, 
    input [4:0] waddr, 
    input [31:0] wdata,     
    output [31:0] rdata1, 
    output [31:0] rdata2 
    );	
	reg [31:0] array_reg [31:0]; //32*32-bit regs
	integer i;
	
	//2 read ports
	assign rdata1 = (raddr1 == 0)? 0: array_reg[raddr1];
	assign rdata2 = (raddr2 == 0)? 0: array_reg[raddr2];

	//1 write port
	always@(posedge clk or posedge reset) begin
		if(reset) begin
			for(i = 0;i < 32; i = i+1)
				array_reg[i] <= 0;
		end 
		else if((waddr != 0) && we)
			array_reg[waddr] <= wdata;
	end
endmodule