`timescale 1ns / 1ps

module MULT(
    input clk,//�˷���ʱ���ź�
    input reset,//��λ�ź�
    input [31:0] a,//���뱻����
    input [31:0] b,//�������
    output [63:0] z//�˻����
    );
    //����Ĵ���
    reg [63:0]  temp = 0;
    reg [63:0]  stored0;
    reg [63:0]  stored1;
    reg [63:0]  stored2;
    reg [63:0]  stored3;
    reg [63:0]  stored4;
    reg [63:0]  stored5;
    reg [63:0]  stored6;
    reg [63:0]  stored7;
    reg [63:0]  stored8;
    reg [63:0]  stored9;
    reg [63:0]  stored10;
    reg [63:0]  stored11;
    reg [63:0]  stored12;
    reg [63:0]  stored13;
    reg [63:0]  stored14;
    reg [63:0]  stored15;
    reg [63:0]  stored16;
    reg [63:0]  stored17;
    reg [63:0]  stored18;
    reg [63:0]  stored19;
    reg [63:0]  stored20;
    reg [63:0]  stored21;
    reg [63:0]  stored22;
    reg [63:0]  stored23;
    reg [63:0]  stored24;
    reg [63:0]  stored25;
    reg [63:0]  stored26;
    reg [63:0]  stored27;
    reg [63:0]  stored28;
    reg [63:0]  stored29;
    reg [63:0]  stored30;
    reg [63:0]  stored31;
    reg [63:0] add0_1;
    reg [63:0] add2_3; 
    reg [63:0] add4_5; 
    reg [63:0] add6_7; 
    reg [63:0] add8_9; 
    reg [63:0] add10_11;
    reg [63:0] add12_13; 
    reg [63:0] add14_15; 
    reg [63:0] add16_17; 
    reg [63:0] add18_19;
    reg [63:0] add20_21;
    reg [63:0] add22_23; 
    reg [63:0] add24_25; 
    reg [63:0] add26_27; 
    reg [63:0] add28_29;
    reg [63:0] add30_31;
    reg [63:0] add0t1_2t3;
    reg [63:0] add4t5_6t7;
    reg [63:0] add8t9_10t11;
    reg [63:0] add12t13_14t15;
    reg [63:0] add16t17_18t19;
    reg [63:0] add20t21_22t23;
    reg [63:0] add24t25_26t27;
    reg [63:0] add28t29_30t31;
    reg [63:0] add0t3_4t7;
    reg [63:0] add8t11_12t15;
    reg [63:0] add16t19_20t23;
    reg [63:0] add24t27_28t31;
    reg [63:0] add0t7_8t15;
    reg [63:0] add16t23_24t31;
    
    reg [31:0] aa, bb;
    always@(posedge clk or negedge reset)   begin
        if(~reset)   begin
            stored0 <=0;
            stored1 <=0;
            stored2 <=0;
            stored3 <=0;
            stored4 <=0;
            stored5 <=0;
            stored6 <=0;
            stored7 <=0;
            stored8 <=0;
            stored9 <=0;
            stored10<=0;
            stored11<=0;
            stored12<=0;
            stored13<=0;
            stored14<=0;
            stored15<=0;
            stored16<=0;
            stored17<=0;
            stored18<=0;
            stored19<=0;
            stored20<=0;
            stored21<=0;
            stored22<=0;
            stored23<=0;
            stored24<=0;
            stored25<=0;
            stored26<=0;
            stored27<=0;
            stored28<=0;
            stored29<=0;
            stored30<=0;
            stored31<=0;
            add0_1  <=0;
            add2_3  <=0;
            add4_5  <=0;
            add6_7  <=0;
            add8_9  <=0;
            add10_11<=0;
            add12_13<=0;
            add14_15<=0;
            add16_17<=0;
            add18_19<=0;
            add20_21<=0;
            add22_23<=0;
            add24_25<=0;
            add26_27<=0;
            add28_29<=0;
            add30_31<=0;
            add0t1_2t3    <=0;   
            add4t5_6t7    <=0;   
            add8t9_10t11  <=0;
            add12t13_14t15<=0;
            add16t17_18t19<=0;
            add20t21_22t23<=0;
            add24t25_26t27<=0;
            add28t29_30t31<=0;
            add0t3_4t7    <=0;
            add8t11_12t15 <=0;
            add16t19_20t23<=0;
            add24t27_28t31<=0;
            add0t7_8t15   <=0;
            add16t23_24t31<=0;
            aa            <=0;
            bb            <=0;
            temp          <=0;
        end
        else    begin
            aa       <=a[31]?(~a+1'b1):a;
            bb       <=b[31]?(~b+1'b1):b;
        
            stored0  <=bb[ 0]?{32'b0, aa       }:64'b0;
            stored1  <=bb[ 1]?{31'b0, aa,  1'b0}:64'b0;
            stored2  <=bb[ 2]?{30'b0, aa,  2'b0}:64'b0;
            stored3  <=bb[ 3]?{29'b0, aa,  3'b0}:64'b0;
            stored4  <=bb[ 4]?{28'b0, aa,  4'b0}:64'b0;
            stored5  <=bb[ 5]?{27'b0, aa,  5'b0}:64'b0;
            stored6  <=bb[ 6]?{26'b0, aa,  6'b0}:64'b0;
            stored7  <=bb[ 7]?{25'b0, aa,  7'b0}:64'b0;
            stored8  <=bb[ 8]?{24'b0, aa,  8'b0}:64'b0;
            stored9  <=bb[ 9]?{23'b0, aa,  9'b0}:64'b0;
            stored10 <=bb[10]?{22'b0, aa, 10'b0}:64'b0;
            stored11 <=bb[11]?{21'b0, aa, 11'b0}:64'b0;
            stored12 <=bb[12]?{20'b0, aa, 12'b0}:64'b0;
            stored13 <=bb[13]?{19'b0, aa, 13'b0}:64'b0;
            stored14 <=bb[14]?{18'b0, aa, 14'b0}:64'b0;
            stored15 <=bb[15]?{17'b0, aa, 15'b0}:64'b0;
            stored16 <=bb[16]?{16'b0, aa, 16'b0}:64'b0;
            stored17 <=bb[17]?{15'b0, aa, 17'b0}:64'b0;
            stored18 <=bb[18]?{14'b0, aa, 18'b0}:64'b0;
            stored19 <=bb[19]?{13'b0, aa, 19'b0}:64'b0;
            stored20 <=bb[20]?{12'b0, aa, 20'b0}:64'b0;
            stored21 <=bb[21]?{11'b0, aa, 21'b0}:64'b0;
            stored22 <=bb[22]?{10'b0, aa, 22'b0}:64'b0;
            stored23 <=bb[23]?{ 9'b0, aa, 23'b0}:64'b0;
            stored24 <=bb[24]?{ 8'b0, aa, 24'b0}:64'b0;
            stored25 <=bb[25]?{ 7'b0, aa, 25'b0}:64'b0;
            stored26 <=bb[26]?{ 6'b0, aa, 26'b0}:64'b0;
            stored27 <=bb[27]?{ 5'b0, aa, 27'b0}:64'b0;
            stored28 <=bb[28]?{ 4'b0, aa, 28'b0}:64'b0;
            stored29 <=bb[29]?{ 3'b0, aa, 29'b0}:64'b0;
            stored30 <=bb[30]?{ 2'b0, aa, 30'b0}:64'b0;
            stored31 <=bb[31]?{ 1'b0, aa, 31'b0}:64'b0;     

            add0_1  <= stored0   + stored1   ;
            add2_3  <= stored2   + stored3   ;
            add4_5  <= stored4   + stored5   ;
            add6_7  <= stored6   + stored7   ;
            add8_9  <= stored8   + stored9   ;
            add10_11<= stored10   + stored11   ;
            add12_13<= stored12   + stored13   ;
            add14_15<= stored14   + stored15   ;
            add16_17<= stored16   + stored17   ;
            add18_19<= stored18   + stored19   ;
            add20_21<= stored20   + stored21   ;
            add22_23<= stored22   + stored23   ;
            add24_25<= stored24   + stored25   ;
            add26_27<= stored26   + stored27   ;
            add28_29<= stored28   + stored29   ;
            add30_31<= stored30   + stored31   ;
            
            add0t1_2t3    <= add0_1  + add2_3  ;   
            add4t5_6t7    <= add4_5  + add6_7  ;   
            add8t9_10t11  <= add8_9  + add10_11  ;
            add12t13_14t15<= add12_13  + add14_15  ;
            add16t17_18t19<= add16_17  + add18_19  ;
            add20t21_22t23<= add20_21  + add22_23  ;
            add24t25_26t27<= add24_25  + add26_27  ;
            add28t29_30t31<= add28_29  + add30_31  ;
            add0t3_4t7    <= add0t1_2t3 + add4t5_6t7;
            add8t11_12t15 <= add8t9_10t11 + add12t13_14t15;
            add16t19_20t23<= add16t17_18t19 + add20t21_22t23;
            add24t27_28t31<= add24t25_26t27 + add28t29_30t31;
            add0t7_8t15   <= add0t3_4t7 + add8t11_12t15;
            add16t23_24t31<= add16t19_20t23 + add24t27_28t31;
            
            temp          <= add0t7_8t15 + add16t23_24t31;
        end                 
    end
    
    assign z = (a[31]==b[31])?temp:~temp+1'b1;
    
endmodule
