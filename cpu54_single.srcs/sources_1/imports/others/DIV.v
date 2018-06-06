`timescale 1ns / 1ps

module DIV(
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

    reg [5:0]   count;
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
            count <= 6'b0;
            busy  <= 1'b0;
            busy2 <= 1'b0;
        end else    begin
            busy2 <= busy;
            if(start)   begin
                reg_r  <= 32'b0;
                reg_q  <= dividend[31]?~dividend+1'b1:dividend;
                reg_b  <= divisor[31] ?~divisor+1'b1 :divisor;
                count  <= 6'b0;
                busy   <= 1'b1;
            end else if(busy)   begin
                reg_r <= out;
                reg_q <= {reg_q[30:0], ~sub_add[32]};
                count <= count + 1'b1;
                if(count == 6'h20)  begin
                    reg_r <= dividend[31]?~reg_r+1'b1:reg_r;
                    reg_q <= (dividend[31]^divisor[31])
                        ?~reg_q+1'b1:reg_q;
                    busy  <= 1'b0;   //done
                end
            end   
        end    
    end
    



endmodule