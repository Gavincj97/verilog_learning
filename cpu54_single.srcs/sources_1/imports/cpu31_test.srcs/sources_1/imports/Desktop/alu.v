`timescale 1ns / 1ps

module alu(
    input [31:0] a,    		
    input [31:0] b,    		
    input [3:0] aluc, 		
    output reg [31:0] r	
);
	always@(*) begin
		case(aluc)
		4'b0000://add
				r <= a + b;//overflow
		4'b0001://addu
				r <= a + b;
		4'b0010://sub
				r <= a - b;//overflow
		4'b0011://subu
				r <= a - b;

		4'b0100://and
				r <= a & b;
		4'b0101://or
				r <= a | b;
		4'b0110://xor
				r <= a ^ b;
		4'b0111://nor
				r <= ~(a | b);

		4'b1000://slt
				r <= ($signed(a) < $signed(b))? 1: 0;
		4'b1001://sltu
				r <= (a < b)? 1: 0;
		4'b1010://sll
				r <= b << a;
		4'b1011://srl
				r <= b >> a;

		4'b1100://sra
				r <= $signed(b) >>> a;
		4'b1101://clz
            begin
                if(a[31] == 1'b1) r <= 32'd0;
                else if(a[30] == 1'b1)  r <= 32'd1;
                else if(a[29] == 1'b1)  r <= 32'd2;
                else if(a[28] == 1'b1)  r <= 32'd3;
                else if(a[27] == 1'b1)  r <= 32'd4;
                else if(a[26] == 1'b1)  r <= 32'd5;
                else if(a[25] == 1'b1)  r <= 32'd6;
                else if(a[24] == 1'b1)  r <= 32'd7;
                else if(a[23] == 1'b1)  r <= 32'd8;
                else if(a[22] == 1'b1)  r <= 32'd9;
                else if(a[21] == 1'b1)  r <= 32'd10;
                else if(a[20] == 1'b1)  r <= 32'd11;
                else if(a[19] == 1'b1)  r <= 32'd12;
                else if(a[18] == 1'b1)  r <= 32'd13;
                else if(a[17] == 1'b1)  r <= 32'd14;
                else if(a[16] == 1'b1)  r <= 32'd15;
                else if(a[15] == 1'b1)  r <= 32'd16;
                else if(a[14] == 1'b1)  r <= 32'd17;
                else if(a[13] == 1'b1)  r <= 32'd18;
                else if(a[12] == 1'b1)  r <= 32'd19;
                else if(a[11] == 1'b1)  r <= 32'd20;
                else if(a[10] == 1'b1)  r <= 32'd21;
                else if(a[9] == 1'b1)  r <= 32'd22;
                else if(a[8] == 1'b1)  r <= 32'd23;
                else if(a[7] == 1'b1)  r <= 32'd24;
                else if(a[6] == 1'b1)  r <= 32'd25;
                else if(a[5] == 1'b1)  r <= 32'd26;
                else if(a[4] == 1'b1)  r <= 32'd27;
                else if(a[3] == 1'b1)  r <= 32'd28;
                else if(a[2] == 1'b1)  r <= 32'd29;
                else if(a[1] == 1'b1)  r <= 32'd30;
                else if(a[0] == 1'b1)  r <= 32'd31;
                else r <= 32'd32;
            end
		default:r <= 32'bx; 
		// 4'b1110:
		// 4'b1111:
		endcase	
	end
endmodule