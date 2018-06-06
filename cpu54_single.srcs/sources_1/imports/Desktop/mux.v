`timescale 1ns / 1ps

module mux32_8_1(
    input [31: 0]iC0,
    input [31: 0]iC1,
    input [31: 0]iC2,
    input [31: 0]iC3,
    input [31: 0]iC4,
    input [31: 0]iC5,
    input [31: 0]iC6,
    input [31: 0]iC7,
    input iS2, iS1, iS0,
    output reg [31: 0] oZ
);
    always@(*) begin
        case({iS2, iS1, iS0})
        3'b000: oZ <= iC0;
        3'b001: oZ <= iC1;
        3'b010: oZ <= iC2;
        3'b011: oZ <= iC3;
        3'b100: oZ <= iC4;
        3'b101: oZ <= iC5;
        3'b110: oZ <= iC6;
        3'b111: oZ <= iC7;
        default:oZ<= 32'bx;            
        endcase
    end
endmodule

module mux32_6_1(
    input [31: 0]iC0,
    input [31: 0]iC1,
    input [31: 0]iC2,
    input [31: 0]iC3,
    input [31: 0]iC4,
    input [31: 0]iC5,
    input iS2, iS1, iS0,
    output reg [31: 0] oZ
);
    always@(*) begin
        case({iS2, iS1, iS0})
        3'b000: oZ <= iC0;
        3'b001: oZ <= iC1;
        3'b010: oZ <= iC2;
        3'b011: oZ <= iC3;
        3'b100: oZ <= iC4;
        3'b101: oZ <= iC5;
        default:oZ<= 32'bx;            
        endcase
    end
endmodule

module mux32_5_1(
    input [31: 0]iC0,
    input [31: 0]iC1,
    input [31: 0]iC2,
    input [31: 0]iC3,
    input [31: 0]iC4,
    input iS2, iS1, iS0,
    output reg [31: 0] oZ
);
    always@(*) begin
        case({iS2, iS1, iS0})
        3'b000: oZ <= iC0;
        3'b001: oZ <= iC1;
        3'b010: oZ <= iC2;
        3'b011: oZ <= iC3;
        3'b100: oZ <= iC4;
        default:oZ<= 32'bx;            
        endcase
    end
endmodule

module mux32_4_1(
    input [31: 0]iC0,
    input [31: 0]iC1,
    input [31: 0]iC2,
    input [31: 0]iC3,
    input iS1, iS0,
    output reg [31: 0] oZ
);
    always@(*) begin
        case({iS1,iS0})
        2'b00: oZ <= iC0;
        2'b01: oZ <= iC1;
        2'b10: oZ <= iC2;
        2'b11: oZ <= iC3; 
        default:oZ<= 32'bx;            
        endcase
    end
endmodule

module mux32_3_1(
    input [31: 0]iC0,
    input [31: 0]iC1,
    input [31: 0]iC2,
    input iS1, iS0,
    output reg [31: 0] oZ
);
    always@(*) begin
        case({iS1,iS0})
        2'b00: oZ <= iC0;
        2'b01: oZ <= iC1;
        2'b10: oZ <= iC2;
        default:oZ<= 32'bx;            
        endcase
    end
endmodule

module mux6_3_1(
    input [5: 0]iC0,
    input [5: 0]iC1,
    input [5: 0]iC2,
    input iS1, iS0,
    output reg [5: 0] oZ
);
    always@(*) begin
        case({iS1,iS0})
        2'b00: oZ <= iC0;
        2'b01: oZ <= iC1;
        2'b10: oZ <= iC2;
        default:oZ<= 6'bx;            
        endcase
    end
endmodule

module mux5_3_1(
    input [4: 0]iC0,
    input [4: 0]iC1,
    input [4: 0]iC2,
    input iS1, iS0,
    output reg [4: 0] oZ
);
    always@(*) begin
        case({iS1,iS0})
        2'b00: oZ <= iC0;
        2'b01: oZ <= iC1;
        2'b10: oZ <= iC2;
        default:oZ<= 5'bx;            
        endcase
    end
endmodule

module mux1_3_1(
    input iC0,
    input iC1,
    input iC2,
    input iS1, iS0,
    output reg oZ
);
    always@(*) begin
        case({iS1,iS0})
        2'b00: oZ <= iC0;
        2'b01: oZ <= iC1;
        2'b10: oZ <= iC2;
        default:oZ<= 1'bx;            
        endcase
    end
endmodule