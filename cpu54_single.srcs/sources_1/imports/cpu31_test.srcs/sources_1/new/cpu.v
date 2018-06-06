`timescale 1ns / 1ps

module cpu(
    input clk,
    input reset,
    input [31:0] inst,
    input [31:0] dmem_data_out, //data out from dmem
    output [31:0] pc,
    output [31:0] aluout,       //addr & result
    output [31:0] dmem_data_in, //data in to dmem
    output dmem_cs,             //dmem ena
    output dmem_wena            //write or read (write:1_data_in | read:0_data_out)
);
    //---------------INITIAL------------
    wire [31:0] pc_out = pc /*- 32'h00400000*/;
    wire [31:0] base = 32'h00400004;

    //-----------DEFINITIONS-----------------
    wire [15:0] imm16 = inst[15:0];
    wire [15:0] offset16 = inst[15:0]; 
    wire [17:0] offset18 = {inst[15:0], 2'b00};        
    wire [4:0] Rs = inst[25:21];
    wire [4:0] Rt = inst[20:16];
    wire [4:0] Rd = inst[15:11];
    wire [4:0] Sa = inst[10:6];
    wire [31:0] Status_out, Cause_out, Epc_out;
    wire [31:0] sta_left = {Status_out[26:0], 5'b0};
    wire [31:0] sta_right = {5'b0, Status_out[31:5]};
    wire [5:0] M_excode_out;
    wire [31:0] Data_LB, Data_LBU, Data_LH, Data_LHU;
    wire [31:0] rdata2_SB, rdata2_SH;
    wire [31:0] S_div, U_div, S_mod, U_mod;
    wire ready, S_ready, busy, S_busy, start, S_start;
    wire is_div, is_divu;
    wire [31:0] alu_out;
    wire [31:0] Hi, Lo;
    
    //------------EXTEND-----------
    wire [31:0] Ext_Sa_out;
    wire [31:0] Ext_imm16_out;
    wire [31:0] S_imm16_out;
    wire [31:0] S_offset16_out;
    wire [31:0] S_offset18_out;
    wire [31:0] Ext_excode_out;

    extend#(16, 32) Ext_imm16(
        .a(imm16),
        .sext(1'b0), //zero extend
        .b(Ext_imm16_out)
    );
    extend#(16, 32) S_imm16(
        .a(imm16),
        .sext(1'b1), //sign extend
        .b(S_imm16_out)
    );
    extend#(5, 32) Ext_Sa(
        .a(Sa),
        .sext(1'b0), //zero extend
        .b(Ext_Sa_out)
    );
    extend#(16, 32) S_offset16(
        .a(offset16),
        .sext(1'b1), //sign extend
        .b(S_offset16_out)
    );
    extend#(18, 32) S_offset18(
        .a(offset18),
        .sext(1'b1), //sign extend
        .b(S_offset18_out)
    );
    extend#(6, 32) Ext_excode(
        .a(M_excode_out),
        .sext(1'b0), //zero extend
        .b(Ext_excode_out)
    );

    //------------OUT--------------
    wire [31:0] M_PC_out;
    wire M_PC_E_out;
    wire [4:0] M_waddr_out;   
    wire [31:0] M_W_out; 
    wire [31:0] M_M_Data_out;      
    wire [31:0] M_A_out, M_B_out;
    wire [31:0] M_ADD_A_out, M_ADD_B_out;
    wire [31:0] M_Lo_out, M_Hi_out;
    wire [31:0] M_DM_addr_out;
    wire [31:0] M_DM_D_out = dmem_data_out;
    wire [31:0] rdata1, rdata2;
    reg [31:0] CP0_out;
    
    //-----------ONE_LINKED----------
 
    dff32#(32'h00400000) PC_inst(
        .CLK(clk),
        .D(M_PC_out),
        .reset(reset),	
        .ready(M_PC_E_out),

        .Q(pc)
    );

    wire [31:0] npc = pc + 32'd4;
    
    wire [31:0] concat = {npc[31:28], inst[25:0], 2'b0};    

    wire [31:0] ADD = M_ADD_A_out + M_ADD_B_out;

    wire we;
    regfile cpu_ref(
        .clk(~clk), //use for test
        //.clk(clk), //use for submit
        .reset(reset), 
        .we(we),  
        .raddr1(Rs), 
        .raddr2(Rt), 
        .waddr(M_waddr_out), 
        .wdata(M_W_out),    

        .rdata1(rdata1), 
        .rdata2(rdata2)
    );

    wire [3:0] aluc;
    alu ALU_inst(
        .a(M_A_out),    		
        .b(M_B_out),    		
        .aluc(aluc), 		
        .r(alu_out)
    );


    DIV DIV_inst(
        .dividend(rdata1),   
        .divisor(rdata2),    
        .start(is_div&~S_busy&~S_ready),    
        .clock(clk),
        .reset(reset),

        .q(S_div),       
        .r(S_mod),         
        .busy(S_busy),
        .ready(S_ready)        
    );

    DIVU DIVU_inst(
        .dividend(rdata1),   
        .divisor(rdata2),    
        .start(is_divu&~busy&~ready),
        .clock(clk),
        .reset(reset),

        .q(U_div),       
        .r(U_mod),         
        .busy(busy), 
        .ready(ready)        
    );

    wire [63:0] MULTU_out = rdata1 * rdata2;
    wire [63:0] MUL_out = $signed(rdata1) * $signed(rdata2);

    //-----------HAVE_MUX-------------
    wire M_PC2, M_PC1, M_PC0;    
    mux32_6_1 M_PC(
        .iC0(concat),
        .iC1(npc),
        .iC2(rdata1),
        .iC3(ADD),
        .iC4(Epc_out),
        .iC5(base),
        .iS2(M_PC2),
        .iS1(M_PC1),
        .iS0(M_PC0),
        .oZ(M_PC_out)
    );

    wire M_PC_E1, M_PC_E0;
    mux1_3_1 M_PC_E(
        .iC0(1'b1),
        .iC1(S_ready),
        .iC2(ready),
        .iS1(M_PC_E1), 
        .iS0(M_PC_E0),
        .oZ(M_PC_E_out)
    );

    wire M_waddr1, M_waddr0;
    mux5_3_1 M_waddr(
        .iC0(Rd),
        .iC1(Rt),
        .iC2(5'd31),
        .iS1(M_waddr1),
        .iS0(M_waddr0),
        .oZ(M_waddr_out)
    );

    wire M_W2, M_W1, M_W0;
    mux32_8_1 M_W(
        .iC0(M_M_Data_out),
        .iC1({imm16,16'b0}),
        .iC2(alu_out),
        .iC3(npc),
        .iC4(MUL_out[31:0]),
        .iC5(Hi),
        .iC6(Lo),
        .iC7(CP0_out),
        .iS2(M_W2), 
        .iS1(M_W1),
        .iS0(M_W0),
        .oZ(M_W_out)
    );

    wire M_M_Data2, M_M_Data1, M_M_Data0;
    mux32_5_1 M_M_Data(
        .iC0(M_DM_D_out),
        .iC1(Data_LB),
        .iC2(Data_LBU),
        .iC3(Data_LH),
        .iC4(Data_LHU),
        .iS2(M_M_Data2), 
        .iS1(M_M_Data1), 
        .iS0(M_M_Data0),
        .oZ(M_M_Data_out)
    );

    reg [7:0] LB;
    reg [15:0] LH;
    always@(*)  begin
        case(ADD[1:0])      
        2'b00: LB <= M_DM_D_out[7:0];
        2'b01: LB <= M_DM_D_out[15:8];
        2'b10: LB <= M_DM_D_out[23:16];
        2'b11: LB <= M_DM_D_out[31:24];
        endcase
    end
    always@(*)  begin
        case(ADD[1])      
        1'b0: LH <= M_DM_D_out[15:0];
        1'b1: LH <= M_DM_D_out[31:16];
        endcase
    end
    extend#(8, 32) S_LB(
        .a(LB),
        .sext(1'b1),
        .b(Data_LB)
    );
    extend#(8, 32) Ext_LBU(
        .a(LB),
        .sext(1'b0),
        .b(Data_LBU)
    );    
    extend#(16, 32) S_LH(
        .a(LH),
        .sext(1'b1),
        .b(Data_LH)
    );
    extend#(16, 32) Ext_LHU(
        .a(LH),
        .sext(1'b0),
        .b(Data_LHU)
    );
  
    wire M_A0;
    assign M_A_out = (M_A0 == 1'b0)? Ext_Sa_out: rdata1;

    wire M_B1, M_B0;
    mux32_3_1 M_B(
        .iC0(rdata2),
        .iC1(Ext_imm16_out),
        .iC2(S_imm16_out),
        .iS1(M_B1), 
        .iS0(M_B0),
        .oZ(M_B_out)
    );

    wire M_ADD_A0;
    assign M_ADD_A_out = (M_ADD_A0 == 1'b0)? S_offset18_out: S_offset16_out;

    wire M_ADD_B0;
    assign M_ADD_B_out = (M_ADD_B0 == 1'b0)? npc: rdata1;

    //------------------CP0-------------------
    wire exc, mtc0, wsta, wcau, wepc;
    wire [31:0] sta_moved = (exc == 1'b0)? sta_right: sta_left;
    wire [31:0] status_fo = (mtc0 == 1'b0)? sta_moved: rdata2;
    wire [31:0] cause_fo = (mtc0 == 1'b0)? Ext_excode_out: rdata2;
    wire [31:0] epc_fo = (mtc0 == 1'b0)? pc: rdata2;

    wire M_excode1, M_excode0;
    mux6_3_1 M_excode(
        .iC0(6'b100000),
        .iC1(6'b100100),
        .iC2(6'b110100),
        .iS1(M_excode1), 
        .iS0(M_excode0),
        .oZ(M_excode_out)
    );
    always@(*)  begin
        case(Rd)
            5'd12:CP0_out <= Status_out;
            5'd13:CP0_out <= Cause_out;
            5'd14:CP0_out <= Epc_out;
            default: CP0_out <= 32'bx;
        endcase
    end
//    assign Status_out = (wsta == 1'b1)? status_fo: Status_out;
//    assign Cause_out = (wcau == 1'b1)? cause_fo: Cause_out;
//    assign Epc_out = (wepc == 1'b1)? epc_fo: Epc_out;
    
    dff32 Status_inst(
        .CLK(clk),
        .D(status_fo),
        .reset(reset),
        .ready(wsta),
        
        .Q(Status_out)
    );  
    
    dff32 Cause_inst(
        .CLK(clk),
        .D(cause_fo),
        .reset(reset),
        .ready(wcau),
        
        .Q(Cause_out)
    );  
    
    dff32 Epc_inst(
        .CLK(clk),
        .D(epc_fo),
        .reset(reset),
        .ready(wepc),
        
        .Q(Epc_out)
    );  
    

    wire M_Lo1, M_Lo0;
    mux32_4_1 M_Lo(
        .iC0(S_div),
        .iC1(U_div),
        .iC2(MULTU_out[31:0]),
        .iC3(rdata1),
        .iS1(M_Lo1), 
        .iS0(M_Lo0),
        .oZ(M_Lo_out)
    );

    wire M_Hi1, M_Hi0;
    mux32_4_1 M_Hi(
        .iC0(S_mod),
        .iC1(U_mod),
        .iC2(MULTU_out[63:32]),
        .iC3(rdata1),
        .iS1(M_Hi1), 
        .iS0(M_Hi0),
        .oZ(M_Hi_out)
    );
    
    wire wena_Hi;
    dff32 Hi_inst(
        .CLK(clk),
        .D(M_Hi_out),
        .reset(reset),    
        .ready(wena_Hi),
        
        .Q(Hi)
    );
    
    wire wena_Lo;
    dff32 Lo_inst(
        .CLK(clk),
        .D(M_Lo_out),
        .reset(reset),    
        .ready(wena_Lo),
        
        .Q(Lo)
    );
    
    //-------------DMEM--------------
    wire M_DM_addr0;
    assign M_DM_addr_out = (M_DM_addr0 == 1'b0)? ADD: alu_out;
    assign aluout = M_DM_addr_out; //----BUG---------
    
    reg [31:0] SB;
    reg [31:0] SH;
    always@(*)  begin
        case(ADD[1:0])      
        2'b00: SB <= rdata2[31:0];
        2'b01: SB <= {rdata2[23:0],8'b0};
        2'b10: SB <= {rdata2[15:0],16'b0};
        2'b11: SB <= {rdata2[7:0],24'b0};
        endcase
    end
    always@(*)  begin
        case(ADD[1])      
        1'b0: SH <= rdata2[31:0];
        1'b1: SH <= {rdata2[15:0],16'b0};
        endcase
    end
    assign rdata2_SB = SB;
    assign rdata2_SH = SH;

    wire M_DM_D1, M_DM_D0;
    mux32_3_1 M_DM_D(
        .iC0(rdata2),
        .iC1(rdata2_SB),
        .iC2(rdata2_SH),
        .iS1(M_DM_D1), 
        .iS0(M_DM_D0),
        .oZ(dmem_data_in) 
    );

    sccpu_control cpu54_simple_control_inst(
        .inst(inst),
        .status(Status_out[4:0]),
        .alu_out(alu_out),
        .rdata1(rdata1), //GPR[Rs] 
        
        .M_PC2(M_PC2), //bit 38
        .M_PC1(M_PC1),
        .M_PC0(M_PC0),
        .M_PC_E1(M_PC_E1),
        .M_PC_E0(M_PC_E0),
        .we(we),
        .M_waddr1(M_waddr1),
        .M_waddr0(M_waddr0),
        .M_W2(M_W2),
        .M_W1(M_W1),
        .M_W0(M_W0),
        .M_M_Data2(M_M_Data2),
        .M_M_Data1(M_M_Data1),
        .M_M_Data0(M_M_Data0),
        .M_A0(M_A0),
        .M_B1(M_B1),
        .M_B0(M_B0),
        .aluc(aluc),
        .dmem_cs(dmem_cs),     
        .dmem_wena(dmem_wena),
        .M_DM_addr0(M_DM_addr0),
        .M_DM_D1(M_DM_D1),
        .M_DM_D0(M_DM_D0),
        .M_ADD_A0(M_ADD_A0),
        .M_ADD_B0(M_ADD_B0),
        .exc(exc),
        .mtc0(mtc0),
        .wsta(wsta),
        .wcau(wcau),
        .wepc(wepc),
        .M_Lo1(M_Lo1),
        .M_Lo0(M_Lo0),
        .M_Hi1(M_Hi1),
        .M_Hi0(M_Hi0), 
        
        .M_excode1(M_excode1),
        .M_excode0(M_excode0), //bit 0
        
        .is_div(is_div),
        .is_divu(is_divu),
        
        .wena_Hi(wena_Hi),
        .wena_Lo(wena_Lo)
    );

endmodule



