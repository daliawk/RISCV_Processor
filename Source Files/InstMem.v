`timescale 1ns / 1ps
/*******************************************************************
*
* Module: InstMem.v
* Project: RISCV_Processor
* Author:   Dalia Elnagar - daliawk@aucegypt.edu
*           Kareem A. Mohammed Talaat - kareemamr213@aucegypt.edu
*           Kirolos M. Mikhail - kirolosmorcos237@aucegypt.edu
* Description: This is a module of the instruction memory
*
* Change history: 10/29/21 – Applied coding guidelines
*
**********************************************************************/


module InstMem(input [5:0] addr, output [31:0] data_out); 
    
    reg [31:0] mem [0:63]; 
    
    initial begin
//     mem[0]=32'b000000000000_00000_010_00001_0000011   ;  //lw x1, 0(x0)
//     mem[1]=32'b000000000100_00000_010_00010_0000011   ;  //lw x2, 4(x0)
//     mem[2]=32'b000000001000_00000_010_00011_0000011   ;  //lw x3, 8(x0)
//     mem[3]=32'b0000000_00010_00001_110_00100_0110011  ;  //or x4, x1, x2
//     mem[4]=32'b0_000000_00011_00100_000_0100_0_1100011;  //beq x4, x3, 4
//     mem[5]=32'b0000000_00010_00001_000_00011_0110011  ;  //add x3, x1, x2
//     mem[6]=32'b0000000_00010_00011_000_00101_0110011  ;  //add x5, x3, x2
//     mem[7]=32'b0000000_00101_00000_010_01100_0100011  ;  //sw x5, 12(x0)
//     mem[8]=32'b000000001100_00000_010_00110_0000011   ;  //lw x6, 12(x0)
//     mem[9]=32'b0000000_00001_00110_111_00111_0110011  ;  //and x7, x6, x1
//     mem[10]=32'b0100000_00010_00001_000_01000_0110011 ;  //sub x8, x1, x2
//     mem[11]=32'b0000000_00010_00001_000_00000_0110011 ;  //add x0, x1, x2
//     mem[12]=32'b0000000_00001_00000_000_01001_0110011 ;  //add x9, x0, x1
     
     // Test Case 1
//     mem[0]=32'b00000000000000000000000010110011;           // add x1, x0, x0
//     mem[1]=32'b00000000000000000010000100000011;           // lw  x2, 0(x0)
//     mem[2]=32'b00000000001000001110000110110011;           // or  x3, x1, x2
//     mem[3]=32'b00000000010000000010000010000011;           // lw  x1, 4(x0)
//     mem[4]=32'b01000000001000001000000010110011;           // sub x1, x1, x2
//     mem[5]=32'b00000000000000001000010001100011;           // beq x1, x0, 8
//     mem[6]=32'b11111110000000000000110011100011;           // beq x0, x0, -8
//     mem[7]=32'b00000000001000001111000110110011;           // and x3, x1, x2
//     mem[8]=32'hffb10193;                                   // addi x3,x2,5
//     mem[9]=32'h00219193;                                   // slli x3 x3 2
//     mem[10]=32'h00000073;                                  // ecall

//     // Test Case 2
//     mem[0]=32'h00400083;           // lb x1 4(x0)
//     mem[1]=32'h00001103;           // lh x2 0(x0)
//     mem[2]=32'h018001ef;           // jal x3 24
//     mem[3]=32'h002081b3;           // add x3 x1 x2
//     mem[4]=32'h00004203;           // lbu x4 0(x0)
//     mem[5]=32'h40415133;           // sra x2 x2 x4
//     mem[6]=32'hfe011ee3;           // bne x2 x0 -4
//     mem[7]=32'b00000000000000000000000000001111;           // fence
//     mem[8]=32'h0010d093;           // srli x1 x1 1
//     mem[9]=32'h40215113;                                   // srai x2 x2 2
//     mem[10]=32'h00202423;                                   // sw x2 8(x0)
//     mem[11]=32'h00201623;                                  // sh x2 12(x0)
//     mem[12]=32'h00200823;                                  // sb x2 16(x0)
//     mem[13]=32'h000181e7;                                  // jalr x3 x3 0
     
     // Test case 3
//     mem[0]=32'h000010b7; // lui x1 1
//     mem[1]=32'h00002117; //auipc x2 2
//     mem[2]=32'h00005203; // lhu x4 0(x0)
//     mem[3]=32'h00411133; // sll x2 x2 x4
//     mem[4]=32'h00415133; // srl x2 x2 x4	
//     mem[5]=32'hfe115ee3; // bge x2 x1 -4	
//     mem[6]=32'h001121b3; // slt x3 x2 x1	
//     mem[7]=32'h0020b1b3; // sltu x3 x1 x2	
//     mem[8]=32'h0021e193; // ori x3 x3 2	
//     mem[9]=32'hfff18193; // addi x3 x3 -1	
//     mem[10]=32'hfe304ee3;// blt x0 x3 -4	
//     mem[11]=32'h001141b3;// xor x3 x2 x1	
//     mem[12]=32'b00000000000100000000000001110011; // ebreak
     
     // Test case 4
//     mem[0]=32'h00800083; // lb x1 8(x0)
//     mem[1]=32'h0805103; // lhu x2 8(x0)
//     mem[2]=32'h000a193; // slti x3 x1 0
//     mem[3]=32'h000b193; // sltiu x3 x1 0
//     mem[4]=32'h020e863; // bltu x1 x2 16
//     mem[5]=32'h0117663; // bgeu x2 x1 12
//     mem[6]=32'h010c093; // xori x1 x1 1
//     mem[7]=32'h0000073; // ecall
//     mem[8]=32'h0000033; // add x0 x0 x0

mem[0]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//added to be skipped since PC starts with 4 after reset
mem[1]=32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)
mem[2]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[3]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[4]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[5]=32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)
mem[6]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[7]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[8]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[9]=32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)
mem[10]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[11]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[12]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[13]=32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2
mem[14]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[15]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[16]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[17]=32'b0_000001_00011_00100_000_0000_0_1100011; //beq x4, x3, 16
mem[18]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[19]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[20]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[21]=32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2
mem[22]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[23]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[24]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[25]=32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2
mem[26]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[27]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[28]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[29]=32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)
mem[30]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[31]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[32]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[33]=32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)
mem[34]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[35]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[36]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[37]=32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1
mem[38]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[39]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[40]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[41]=32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2
mem[42]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[43]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[44]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[45]=32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2
mem[46]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[47]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[48]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[49]=32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1
mem[50]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[51]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
mem[52]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
   
     
    end    
    
    assign data_out = mem[addr];
endmodule

