`timescale 1ns / 1ps

module sccpu_control(
    input [31:0] inst,
    input [4:0] status,
    input [31:0] alu_out,
    input [31:0] rdata1, //GPR[Rs]

    output M_PC2, //bit 38
    output M_PC1,
    output M_PC0,
    output M_PC_E1,
    output M_PC_E0,
    output we,
    output M_waddr1,
    output M_waddr0,
    output M_W2,
    output M_W1,
    output M_W0,
    output M_M_Data2,
    output M_M_Data1,
    output M_M_Data0,
    output M_A0,
    output M_B1,
    output M_B0,
    output [3:0] aluc,
    output dmem_cs,     
    output dmem_wena,
    output M_DM_addr0,
    output M_DM_D1,
    output M_DM_D0,
    output M_ADD_A0,
    output M_ADD_B0,
    output exc,
    output mtc0,
    output wsta,
    output wcau,
    output wepc,
    output M_Lo1,
    output M_Lo0,
    output M_Hi1,
    output M_Hi0, 

    output M_excode1,
    output M_excode0, //bit 0
    
    output is_div,
    output is_divu,
    
    output wena_Hi,
    output wena_Lo
);

    wire [5:0] op_num = inst[31:26];
    wire [4:0] IMEM2521 = inst[25:21];
    wire [5:0] func = inst[5:0];
    wire [4:0] rd = inst[15:11];

    wire he = (rdata1[31] == 1'b0)? 1'b1: 1'b0;
    wire eq = (alu_out == 32'b0)? 1'b1: 1'b0;
    wire ne = ~eq;
    reg [38:0] sign_stream; //total 39 bits
    
    always@(*)    begin
        casex({op_num,IMEM2521,func})
            17'b000000xxxxx100000:    sign_stream = 39'b00100100010xxx10000000xxxxxxxxxxxxxxxxx; //ADD
            17'b000000xxxxx100001:    sign_stream = 39'b00100100010xxx10000010xxxxxxxxxxxxxxxxx; //ADDU
            17'b000000xxxxx100010:    sign_stream = 39'b00100100010xxx10000100xxxxxxxxxxxxxxxxx; //SUB
            17'b000000xxxxx100011:    sign_stream = 39'b00100100010xxx10000110xxxxxxxxxxxxxxxxx; //SUBU
            17'b000000xxxxx100100:    sign_stream = 39'b00100100010xxx10001000xxxxxxxxxxxxxxxxx; //AND
            17'b000000xxxxx100101:    sign_stream = 39'b00100100010xxx10001010xxxxxxxxxxxxxxxxx; //OR
            17'b000000xxxxx100110:    sign_stream = 39'b00100100010xxx10001100xxxxxxxxxxxxxxxxx; //XOR
            17'b000000xxxxx100111:    sign_stream = 39'b00100100010xxx10001110xxxxxxxxxxxxxxxxx; //NOR
            17'b000000xxxxx101010:    sign_stream = 39'b00100100010xxx10010000xxxxxxxxxxxxxxxxx; //SLT
            17'b000000xxxxx101011:    sign_stream = 39'b00100100010xxx10010010xxxxxxxxxxxxxxxxx; //SLTU
            17'b000000xxxxx000000:    sign_stream = 39'b00100100010xxx00010100xxxxxxxxxxxxxxxxx; //SLL
            17'b000000xxxxx000010:    sign_stream = 39'b00100100010xxx00010110xxxxxxxxxxxxxxxxx; //SRL
            17'b000000xxxxx000011:    sign_stream = 39'b00100100010xxx00011000xxxxxxxxxxxxxxxxx; //SRA
            17'b000000xxxxx000100:    sign_stream = 39'b00100100010xxx10010100xxxxxxxxxxxxxxxxx; //SLLV
            17'b000000xxxxx000110:    sign_stream = 39'b00100100010xxx10010110xxxxxxxxxxxxxxxxx; //SRLV
            17'b000000xxxxx000111:    sign_stream = 39'b00100100010xxx10011000xxxxxxxxxxxxxxxxx; //SRAV
            17'b000000xxxxx001000:    sign_stream = 39'b010000xxxxxxxxxxxxxxx0xxxxxxxxxxxxxxxxx; //JR
            17'b001000xxxxxxxxxxx:    sign_stream = 39'b00100101010xxx11000000xxxxxxxxxxxxxxxxx; //ADDI
            17'b001001xxxxxxxxxxx:    sign_stream = 39'b00100101010xxx11000010xxxxxxxxxxxxxxxxx; //ADDIU
            17'b001100xxxxxxxxxxx:    sign_stream = 39'b00100101010xxx10101000xxxxxxxxxxxxxxxxx; //ANDI
            17'b001101xxxxxxxxxxx:    sign_stream = 39'b00100101010xxx10101010xxxxxxxxxxxxxxxxx; //ORI
            17'b001110xxxxxxxxxxx:    sign_stream = 39'b00100101010xxx10101100xxxxxxxxxxxxxxxxx; //XORI
            17'b100011xxxxxxxxxxx:    sign_stream = 39'b001001010000001100000100xxxxxxxxxxxxxxx; //LW
            17'b101011xxxxxxxxxxx:    sign_stream = 39'b001000xxxxxxxx110000011000xxxxxxxxxxxxx; //SW
            17'b000100xxxxxxxxxxx:    sign_stream = {1'b0, eq, 37'b1000xxxxxxxx10000100xxxx00xxxxxxxxxxx}; //BEQ
            17'b000101xxxxxxxxxxx:    sign_stream = {1'b0, ne, 37'b1000xxxxxxxx10000100xxxx00xxxxxxxxxxx}; //BNE
            17'b001010xxxxxxxxxxx:    sign_stream = 39'b00100101010xxx11010000xxxxxxxxxxxxxxxxx; //SLTI
            17'b001011xxxxxxxxxxx:    sign_stream = 39'b00100101010xxx11010010xxxxxxxxxxxxxxxxx; //SLTIU
            17'b001111xxxxxxxxxxx:    sign_stream = 39'b00100101001xxxxxxxxxx0xxxxxxxxxxxxxxxxx; //LUI
            17'b000010xxxxxxxxxxx:    sign_stream = 39'b000000xxxxxxxxxxxxxxx0xxxxxxxxxxxxxxxxx; //J
            17'b000011xxxxxxxxxxx:    sign_stream = 39'b00000110011xxxxxxxxxx0xxxxxxxxxxxxxxxxx; //JAL
            17'b011100xxxxx100000:    sign_stream = 39'b00100100010xxx1xx11010xxxxxxxxxxxxxxxxx; //CLZ
            17'b000000xxxxx011010:    sign_stream = 39'b001010xxxxxxxxxxxxxxx0xxxxxxxxxxx0000xx; //DIV
            17'b000000xxxxx011011:    sign_stream = 39'b001100xxxxxxxxxxxxxxx0xxxxxxxxxxx0101xx; //DIVU
            17'b011100xxxxx000010:    sign_stream = 39'b00100100100xxxxxxxxxx0xxxxxxxxxxxxxxxxx; //MUL
            17'b000000xxxxx011001:    sign_stream = 39'b001000xxxxxxxxxxxxxxx0xxxxxxxxxxx1010xx; //MULTU
            17'b000001xxxxxxxxxxx:    sign_stream = {1'b0, he, 37'b1000xxxxxxxxxxxxxxx0xxxx00xxxxxxxxxxx}; //BGEZ
            17'b00000000000010000:    sign_stream = 39'b00100100101xxxxxxxxxx0xxxxxxxxxxxxxxxxx; //MFHi
            17'b00000000000010010:    sign_stream = 39'b00100100110xxxxxxxxxx0xxxxxxxxxxxxxxxxx; //MFLo
            17'b000000xxxxx010001:    sign_stream = 39'b001000xxxxxxxxxxxxxxx0xxxxxxxxxxxxx11xx; //MTHi
            17'b000000xxxxx010011:    sign_stream = 39'b001000xxxxxxxxxxxxxxx0xxxxxxxxxxx11xxxx; //MTLo
            17'b000000xxxxx001001:    sign_stream = 39'b01000100011xxxxxxxxxx0xxxxxxxxxxxxxxxxx; //JALR
            17'b100000xxxxxxxxxxx:    sign_stream = 39'b00100101000001xxxxxxx101xx11xxxxxxxxxxx; //LB
            17'b100100xxxxxxxxxxx:    sign_stream = 39'b00100101000010xxxxxxx101xx11xxxxxxxxxxx; //LBU
            17'b100001xxxxxxxxxxx:    sign_stream = 39'b00100101000011xxxxxxx101xx11xxxxxxxxxxx; //LH
            17'b100101xxxxxxxxxxx:    sign_stream = 39'b00100101000100xxxxxxx101xx11xxxxxxxxxxx; //LHU
            17'b101000xxxxxxxxxxx:    sign_stream = 39'b001000xxxxxxxxxxxxxxx1110111xxxxxxxxxxx; //SB
            17'b101001xxxxxxxxxxx:    sign_stream = 39'b001000xxxxxxxxxxxxxxx1111011xxxxxxxxxxx; //SH
            17'b01000000000xxxxxx:    sign_stream = 39'b00100101111xxxxxxxxxx0xxxxxxxx000xxxxxx; //mfc0

            17'b01000000100xxxxxx:   begin    //mtc0
                    case (rd)
                               12:    sign_stream = 39'b001000xxxxxxxxxxxxxxx0xxxxxxx1100xxxxxx; // status
                               13:    sign_stream = 39'b001000xxxxxxxxxxxxxxx0xxxxxxx1010xxxxxx; // cause
                               14:    sign_stream = 39'b001000xxxxxxxxxxxxxxx0xxxxxxx1001xxxxxx; // epc
                          default:    sign_stream = 39'b001000xxxxxxxxxxxxxxx0xxxxxxx1000xxxxxx; 
                    endcase
                end

            17'b000000xxxxx001100:  begin //syscall
                    casex(status)
                        5'bxxx11:     sign_stream = 39'b101000xxxxxxxxxxxxxxx0xxxxxx10111xxxx00; //syscall
                        default:      sign_stream = 39'b001000xxxxxxxxxxxxxxx0xxxxxxxx000xxxxxx; //---else
                    endcase
                end
                
            17'b000000xxxxx001101:  begin //break
                    casex(status)
                        5'bxx1x1:     sign_stream = 39'b101000xxxxxxxxxxxxxxx0xxxxxx10111xxxx01; //break
                        default:      sign_stream = 39'b001000xxxxxxxxxxxxxxx0xxxxxxxx000xxxxxx; //--else
                    endcase 
                end 

            17'b000000xxxxx110100:  begin //teq
                    casex(status)
                        5'bx1xx1:     sign_stream = {eq, 29'b01000xxxxxxxx10000100xxxxxx10,eq,eq,eq,6'bxxxx10}; //teq
                        default:      sign_stream = 39'b001000xxxxxxxxxxxxxxx0xxxxxxxx000xxxxxx; //-else
                    endcase
                end
            17'b01000010000011000:    sign_stream = 39'b100000xxxxxxxxxxxxxxx0xxxxxx00100xxxxxx; //eret

            default  :    sign_stream = 39'bx;                                              //default
        endcase
    end
    
    reg [1:0] is_dstr;
    always@(*)begin
        casex({op_num,IMEM2521,func})
            17'b000000xxxxx011010: is_dstr = 2'b10; //div
            17'b000000xxxxx011011: is_dstr = 2'b01; //divu
            default: is_dstr = 2'b00;
        endcase
    end
    
    reg [1:0] LoHi_wstr;
    always@(*)begin
        casex({op_num,IMEM2521,func})
            17'b000000xxxxx011010: LoHi_wstr = 2'b11; //div
            17'b000000xxxxx011011: LoHi_wstr = 2'b11; //divu
            17'b000000xxxxx011001: LoHi_wstr = 2'b11; //multu
            17'b000000xxxxx010001: LoHi_wstr = 2'b01; //mthi
            17'b000000xxxxx010011: LoHi_wstr = 2'b10; //mtlo
            default: LoHi_wstr = 2'b00;
        endcase
    end    
    
    assign {
        M_PC2, //bit 38
        M_PC1,
        M_PC0,
        M_PC_E1,
        M_PC_E0,
        we,
        M_waddr1,
        M_waddr0,
        M_W2,
        M_W1,
        M_W0,
        M_M_Data2,
        M_M_Data1,
        M_M_Data0,
        M_A0,
        M_B1,
        M_B0,
        aluc[3:0],
        dmem_cs,     
        dmem_wena,
        M_DM_addr0,
        M_DM_D1,
        M_DM_D0,
        M_ADD_A0,
        M_ADD_B0,
        exc,
        mtc0,
        wsta,
        wcau,
        wepc,
        M_Lo1,
        M_Lo0,
        M_Hi1,
        M_Hi0, 
        M_excode1,
        M_excode0 //bit 0
    } = sign_stream;    
    assign {is_div, is_divu} = is_dstr;
    assign {wena_Lo, wena_Hi} = LoHi_wstr;
endmodule