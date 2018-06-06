`timescale 1ns / 1ps

module dmem #(parameter MAX_SIZ = 1024, MAX_BIT = 32)(
    input clk,
    input reset,   
    input ena,
    input wena, 
    input [MAX_BIT - 1'b1:0] addr, 
    input [31:0] data_in, 
    output [31:0] data_out 
    );
    
	reg [31: 0] RAM[MAX_SIZ - 1'b1: 0];
    integer i;
    always@(posedge clk or posedge reset) begin
        if (reset) begin
            for(i = 0; i< MAX_SIZ; i = i + 1)
                RAM[i] <= 32'b0;
        end
        else if(wena & ena)
            RAM[addr] <= data_in; 
    end
        
    assign data_out = (ena&~wena)? RAM[addr]: 32'bz;
        
endmodule