`timescale 1ns / 1ps

module DIVU(
    input [31:0] dividend,   
    input [31:0] divisor,    
    input start,           
    input clock,
    input reset,
    output [31:0] q,       
    output [31:0] r,         
    output reg busy,
    output ready        
);

    reg [4:0]   count;
    reg [31:0]  reg_q;      //reg for dividend
    reg [31:0]  reg_b;      //reg for divisor
    reg [31:0]  reg_r;      //reg for remainder
    reg busy2;
    assign ready = ~busy & busy2;
    wire [32:0] sub_add = {r, q[31]} - {1'b0, reg_b};
    wire [31:0] out = sub_add[32]? 
        {r[30:0], q[31]}: sub_add[31:0];
    assign q = reg_q;
    assign r = reg_r;    
           
    always @ (posedge clock or posedge reset)   begin
        if(reset)   begin
            count <= 5'b0;
            busy  <= 1'b0;
            busy2 <= 1'b0;
        end else    begin
            busy2 <= busy;
            if(start)   begin
                reg_r  <= 32'b0;
                reg_q  <= dividend;
                reg_b  <= divisor;
                count  <= 5'b0;
                busy   <= 1'b1;
            end else if(busy)   begin
                reg_r <= out;
                reg_q <= {reg_q[30:0], ~sub_add[32]};
                count <= count + 1'b1;
                if(count == 5'h1f)
                    busy <= 1'b0;   //done
            end   
        end    
    end
    



endmodule