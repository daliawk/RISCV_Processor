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


module Memory(
     input sclk, 
     input mem_read, 
     input mem_write,
     input [1:0] AU_inst_sel,
     input signed_inst,
     input [7:0] addr, 
     input [31:0] data_in,
     output reg [31:0] data_out
     ); 
    
    reg [7:0] mem [0:200]; //Memory that has 64 slots, each slot 8 bits in width.
    reg [7:0] offset;
    
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
     
//  {mem[3], mem[2], mem[1], mem[0]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//  {mem[7], mem[6], mem[5], mem[4]}=32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)
//  {mem[11], mem[10], mem[9], mem[8]}=32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)
//  {mem[15], mem[14], mem[13], mem[12]}=32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)
//  {mem[19], mem[18], mem[17], mem[16]}=32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2
//  {mem[23], mem[22], mem[21], mem[20]}=32'h00320463;  //beq x4, x3, 4
//  {mem[27], mem[26], mem[25], mem[24]}=32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2
//  {mem[31], mem[30], mem[29], mem[28]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//  {mem[35], mem[34], mem[33], mem[32]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//  {mem[39], mem[38], mem[37], mem[36]}=32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)
//  {mem[43], mem[42], mem[41], mem[40]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//  {mem[47], mem[46], mem[45], mem[44]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//  {mem[51], mem[50], mem[49], mem[48]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//  {mem[55], mem[54], mem[53], mem[52]}=32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2
//  {mem[59], mem[58], mem[57], mem[56]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//  {mem[63], mem[62], mem[61], mem[60]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//  {mem[67], mem[66], mem[65], mem[64]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//  {mem[71], mem[70], mem[69], mem[68]}=32'b0_000001_00011_00100_000_0000_0_1100011; //beq x4, x3, 16
//  {mem[75], mem[74], mem[73], mem[72]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//  {mem[79], mem[78], mem[77], mem[76]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//  {mem[83], mem[82], mem[81], mem[80]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//  {mem[87], mem[86], mem[85], mem[84]}=32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2
//  {mem[91], mem[90], mem[89], mem[88]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//  {mem[95], mem[94], mem[93], mem[92]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//  {mem[99], mem[98], mem[97], mem[96]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0

//     {mem[3], mem[2], mem[1], mem[0]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//  {mem[7], mem[6], mem[5], mem[4]}=32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)
//  {mem[11], mem[10], mem[9], mem[8]}=32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)
//  {mem[15], mem[14], mem[13], mem[12]}=32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)
//  {mem[19], mem[18], mem[17], mem[16]}=32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2
//  {mem[23], mem[22], mem[21], mem[20]}=32'h00320463;  //beq x4, x3, 4
//  {mem[27], mem[26], mem[25], mem[24]}=32'b0000000_00010_00001_000_00011_0110011  ;  //add x3, x1, x2
//  {mem[31], mem[30], mem[29], mem[28]}=32'b0000000_00010_00011_000_00101_0110011  ;  //add x5, x3, x2
//  {mem[35], mem[34], mem[33], mem[32]}=32'b0000000_00101_00000_010_01100_0100011  ;  //sw x5, 12(x0)
//  {mem[39], mem[38], mem[37], mem[36]}=32'b000000001100_00000_010_00110_0000011   ;  //lw x6, 12(x0)
//  {mem[43], mem[42], mem[41], mem[40]}=32'b0000000_00001_00110_111_00111_0110011  ;  //and x7, x6, x1
//  {mem[47], mem[46], mem[45], mem[44]}=32'b0100000_00010_00001_000_01000_0110011 ;  //sub x8, x1, x2
//  {mem[51], mem[50], mem[49], mem[48]}=32'b0000000_00010_00001_000_00000_0110011 ;  //add x0, x1, x2
//  {mem[55], mem[54], mem[53], mem[52]}=32'b0000000_00001_00000_000_01001_0110011 ;  //add x9, x0, x1
//  {mem[59], mem[58], mem[57], mem[56]}=32'b00000000000100000000000001110011; // ebreak
//  {mem[63], mem[62], mem[61], mem[60]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//  {mem[67], mem[66], mem[65], mem[64]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//  {mem[71], mem[70], mem[69], mem[68]}=32'b0_000001_00011_00100_000_0000_0_1100011; //beq x4, x3, 16
//  {mem[75], mem[74], mem[73], mem[72]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//  {mem[79], mem[78], mem[77], mem[76]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//  {mem[83], mem[82], mem[81], mem[80]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//  {mem[87], mem[86], mem[85], mem[84]}=32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2
//  {mem[91], mem[90], mem[89], mem[88]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//  {mem[95], mem[94], mem[93], mem[92]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//  {mem[99], mem[98], mem[97], mem[96]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
     
// {mem[3], mem[2], mem[1], mem[0]}=32'h00a00093 ; //addi x1, x0, 10
// {mem[7], mem[6], mem[5], mem[4]}=32'h00a00113 ; //addi x2, x0, 10
// {mem[11], mem[10], mem[9], mem[8]}=32'hff600193 ; //addi x3, x0, -10
// {mem[15], mem[14], mem[13], mem[12]}=32'h00000213 ; //addi x4, x0, 0
// {mem[19], mem[18], mem[17], mem[16]}=32'h00600293 ; //addi x5, x0, 6
// {mem[23], mem[22], mem[21], mem[20]}=32'h00500313;  //addi x6, x0, 5
// {mem[27], mem[26], mem[25], mem[24]}=32'h026183b3 ; //MUL x7, x3, x6
// {mem[31], mem[30], mem[29], mem[28]}=32'h02619433 ; //	MULH x8, x3, x6
// {mem[35], mem[34], mem[33], mem[32]}=32'h0220b4b3 ; //MULHU x9, x1,x2
//   {mem[39], mem[38], mem[37], mem[36]}=32'h0250a533 ; //MULHSU x10, x1, x5
//   {mem[43], mem[42], mem[41], mem[40]}=32'h0211c5b3 ; //DIV x11, x3, x1
//   {mem[47], mem[46], mem[45], mem[44]}=32'h0220d633 ; //DIVU x12, x1, x2
//   {mem[51], mem[50], mem[49], mem[48]}=32'h0240c6b3 ; //DIV x13, x1, x4
//   {mem[55], mem[54], mem[53], mem[52]}=32'h0251e733 ; //REM x14, x3, x5
//   {mem[59], mem[58], mem[57], mem[56]}=32'h025177b3 ; //REMU x15, x2, x5
//   {mem[63], mem[62], mem[61], mem[60]}=32'h0242e833 ; //REM x16, x5, x4
//   {mem[67], mem[66], mem[65], mem[64]}=32'h07002b83 ; //lw x23, 112(x0)
//        {mem[71], mem[70], mem[69], mem[68]}=32'h023baeb3; // mulhsu x29 x23 x3
//        {mem[75], mem[74], mem[73], mem[72]}=32'h0371af33 ; //mulhsu x30 x3 x23
//     {mem[67], mem[66], mem[65], mem[64]}=32'h10900893 ; //addi x17, x0, 265
//     {mem[71], mem[70], mem[69], mem[68]}=32'h10900913; //addi x18, x0, 265
//     {mem[75], mem[74], mem[73], mem[72]}=32'h032889b3 ; //MUL x19, x17, x18
//     {mem[79], mem[78], mem[77], mem[76]}=32'h03289a33 ; //MULH x20, x17, x18
//     {mem[83], mem[82], mem[81], mem[80]}=32'h0200dab3 ; //DIVU x21, x1, x0
//     {mem[87], mem[86], mem[85], mem[84]}=32'h02017b33 ; //REMU x22, x2, x0
     
//     {mem[91], mem[90], mem[89], mem[88]}=32'h07002b83 ; //lw x23, 112(x0)
//     {mem[95], mem[94], mem[93], mem[92]}=32'h023baeb3;  // mulhsu x29 x23 x3
//     {mem[99], mem[98], mem[97], mem[96]}=32'h0371af33 ; //mulhsu x30 x3 x23
//     {mem[95], mem[94], mem[93], mem[92]}=32'hfff00c13 ; //addi x24, x0, -1
//     {mem[99], mem[98], mem[97], mem[96]}=32'h038bccb3 ; //DIV x25, x23, x24
//     {mem[103], mem[102], mem[101], mem[100]}=32'h038bed33; //REM x26, x23, x24
//     {mem[107], mem[106], mem[105], mem[104]}=32'h038bddb3; //DIVU x27, x23, x24
//     {mem[111], mem[110], mem[109], mem[108]}=32'h038bfe33; //REMU x28, x23, x24
     // Test case 4
//     inst_mem[0]=32'h00800083; // lb x1 8(x0)
//     inst_mem[1]=32'h0805103; // lhu x2 8(x0)
//     inst_mem[2]=32'h000a193; // slti x3 x1 0
//     inst_mem[3]=32'h000b193; // sltiu x3 x1 0
//     inst_mem[4]=32'h020e863; // bltu x1 x2 16
//     inst_mem[5]=32'h0117663; // bgeu x2 x1 12
//     inst_mem[6]=32'h010c093; // xori x1 x1 1
//     inst_mem[7]=32'h0000073; // ecall
//     inst_mem[8]=32'h0000033; // add x0 x0 x0

//     mem[100]=8'd17; 
//     mem[101]=8'd0; 
//     mem[102]=8'd0; 
//     mem[103]=8'd0; 
//     mem[104]=8'd9;
//     mem[105]=8'd0; 
//     mem[106]=8'd0; 
//     mem[107]=8'd0; 
//     mem[108]=8'd25;
//     mem[109]=8'd0; 
//     mem[110]=8'd0; 
//     // Test case 4
////     inst_mem[0]=32'h00800083; // lb x1 8(x0)
////     inst_mem[1]=32'h0805103; // lhu x2 8(x0)
////     inst_mem[2]=32'h000a193; // slti x3 x1 0
////     inst_mem[3]=32'h000b193; // sltiu x3 x1 0
////     inst_mem[4]=32'h020e863; // bltu x1 x2 16
////     inst_mem[5]=32'h0117663; // bgeu x2 x1 12
////     inst_mem[6]=32'h010c093; // xori x1 x1 1
////     inst_mem[7]=32'h0000073; // ecall
////     inst_mem[8]=32'h0000033; // add x0 x0 x0

//Comprehensive Test Case
 {mem[3], mem[2], mem[1], mem[0]}=32'h00000033 ; //add x0, x0, x0
 {mem[7], mem[6], mem[5], mem[4]}=32'hffe08113 ; //addi x2, x1, -2
 {mem[11], mem[10], mem[9], mem[8]}=32'h00a10113 ; //addi x2 x2 10
 {mem[15], mem[14], mem[13], mem[12]}=32'h00100093 ; //addi x1, x0, 1
 {mem[19], mem[18], mem[17], mem[16]}=32'h00100023 ; //sb x1 0(x0)
 {mem[23], mem[22], mem[21], mem[20]}=32'h00809093;  //slli x1 x1 8
 {mem[27], mem[26], mem[25], mem[24]}=32'h001000a3 ; //sb x1, 1(x0)
 {mem[31], mem[30], mem[29], mem[28]}=32'h00101123 ; //	sh x1 2(x0)
 {mem[35], mem[34], mem[33], mem[32]}=32'h00809093 ; //slli x1, x1, 8
   {mem[39], mem[38], mem[37], mem[36]}=32'h00101223 ; //sh x1, 4(x0)
   {mem[43], mem[42], mem[41], mem[40]}=32'h00102323 ; //sw x1, 6(x0)
   {mem[47], mem[46], mem[45], mem[44]}=32'h00000103 ; //lb x2, 0(x0)
   {mem[51], mem[50], mem[49], mem[48]}=32'h00100183 ; //lb x3, 1(x0)
   {mem[55], mem[54], mem[53], mem[52]}=32'h00201103 ; //lh x2, 2(x0)
   {mem[59], mem[58], mem[57], mem[56]}=32'h00401183 ; //lh x3, 4(x0)
   {mem[63], mem[62], mem[61], mem[60]}=32'h00602183 ; //lw x3, 6(x0)
   {mem[67], mem[66], mem[65], mem[64]}=32'hfff00093 ; //addi x1, x0, -1
    {mem[71], mem[70], mem[69], mem[68]}=32'h00102523; // sw x1, 10(x0)
    {mem[75], mem[74], mem[73], mem[72]}=32'h00a00103 ; //lb x2, 10(x0)
     {mem[67], mem[66], mem[65], mem[64]}=32'h00a04183 ; //lbu x3, 10(x0)
     {mem[71], mem[70], mem[69], mem[68]}=32'h00a01203; //lh x4, 10(x0)
     {mem[75], mem[74], mem[73], mem[72]}=32'h00a05203 ; //lhu x4, 10(x0)
    
         {mem[79],mem[78],mem[77],mem[76]} = 32'h000010b7; // lui x1 1
         {mem[83],mem[82],mem[81],mem[80]} = 32'h00002117; // auipc x2 2	
         {mem[87],mem[86],mem[85],mem[84]} = 32'h12c0016f; // jal x2 300	
         {mem[91],mem[90],mem[89],mem[88]} = 32'h12010663; // beq x2 x0 300	
         {mem[95],mem[94],mem[93],mem[92]} = 32'h00210463; // beq x2 x2 8	
         {mem[99],mem[98],mem[97],mem[96]} = 32'h00000073; // ecall	
     {mem[103],mem[102],mem[101],mem[100]} = 32'h12211063; // bne x2 x2 288	
     {mem[107],mem[106],mem[105],mem[104]} = 32'h00011463; // bne x2 x0 8	
     {mem[111],mem[110],mem[109],mem[108]} = 32'h00000073; // ecall	
     {mem[115],mem[114],mem[113],mem[112]} = 32'h10014a63; // blt x2 x0 276	
     {mem[119],mem[118],mem[117],mem[116]} = 32'h10004863; // blt x0 x0 272	
     {mem[123],mem[122],mem[121],mem[120]} = 32'h10016663; // bltu x2 x0 268	
     {mem[127],mem[126],mem[125],mem[124]} = 32'h10006463; // bltu x0 x0 264	
     {mem[131],mem[130],mem[129],mem[128]} = 32'h00204463; // blt x0 x2 8	
     {mem[135],mem[134],mem[133],mem[132]} = 32'h00000073; // ecall	
     {mem[139],mem[138],mem[137],mem[136]} = 32'h00206463; // bltu x0 x2 8	
     {mem[143],mem[142],mem[141],mem[140]} = 32'h00000073; // ecall	
     {mem[147],mem[146],mem[145],mem[144]} = 32'hfff00093; // addi x1 x0 -1	
     {mem[151],mem[150],mem[149],mem[148]} = 32'h0e00e863; // bltu x1 x0 240	
     {mem[155],mem[154],mem[153],mem[152]} = 32'h0000c463; // blt x1 x0 8	
     {mem[159],mem[158],mem[157],mem[156]} = 32'h00000073; // ecall	
     {mem[163],mem[162],mem[161],mem[160]} = 32'h0e205263; // bge x0 x2 228	
     {mem[167],mem[166],mem[165],mem[164]} = 32'h0e207063; // bgeu x0 x2 224	
     {mem[171],mem[170],mem[169],mem[168]} = 32'h00015463; // bge x2 x0 8	
     {mem[175],mem[174],mem[173],mem[172]} = 32'h00000073; // ecall
     {mem[179],mem[178],mem[177],mem[176]} = 32'h00017463; // bgeu x2 x0 8	
     {mem[183],mem[182],mem[181],mem[180]} = 32'h00000073; // ecall
     {mem[187],mem[186],mem[185],mem[184]} = 32'h0c107663; // bgeu x0 x1 204	
     {mem[191],mem[190],mem[189],mem[188]} = 32'h00105463; // bge x0 x1 8	
     {mem[195],mem[194],mem[193],mem[192]} = 32'h00000073; // ecall
     {mem[199],mem[198],mem[197],mem[196]} = 32'h00005463; // bge x0 x0 8	
     {mem[203],mem[202],mem[201],mem[200]} = 32'h00000073; // ecall
     {mem[207],mem[206],mem[205],mem[204]} = 32'h00007463; // bgeu x0 x0 8	
     {mem[211],mem[210],mem[209],mem[208]} = 32'h00000073; // ecall
     {mem[215],mem[214],mem[213],mem[212]} = 32'hfff00093; // addi x1 x0 -1	
     {mem[219],mem[218],mem[217],mem[216]} = 32'h0010a193; // slti x3 x1 1	
     {mem[223],mem[222],mem[221],mem[220]} = 32'h0010b213; // sltiu x4 x1 1	
     {mem[227],mem[226],mem[225],mem[224]} = 32'h00222193; // slti x3 x4 2	
     {mem[231],mem[230],mem[229],mem[228]} = 32'h00223213; // sltiu x4 x4 2	
     {mem[235],mem[234],mem[233],mem[232]} = 32'h0030a2b3; // slt x5 x1 x3	 
     {mem[239],mem[238],mem[237],mem[236]} = 32'h0030b333; // sltu x6 x1 x3	
     {mem[243],mem[242],mem[241],mem[240]} = 32'h0011a2b3; // slt x5 x3 x1	
     {mem[247],mem[246],mem[245],mem[244]} = 32'h0011b333; // sltu x6 x3 x1	
     {mem[251],mem[250],mem[249],mem[248]} = 32'h00200113; // addi x2 x0 2	
     {mem[255],mem[254],mem[253],mem[252]} = 32'h00116193; // ori x3 x2 1	
     {mem[259],mem[258],mem[257],mem[256]} = 32'h0061c213; // xori x4 x3 6	
     {mem[263],mem[262],mem[261],mem[260]} = 32'h0061f293; // andi x5 x3 6	
     {mem[267],mem[266],mem[265],mem[264]} = 32'h00500093; // addi x1 x0 5	 
     {mem[271],mem[270],mem[269],mem[268]} = 32'h00209113; // slli x2 x1 2	
     {mem[275],mem[274],mem[273],mem[272]} = 32'h00215193; // srli x3 x2 2	
     {mem[279],mem[278],mem[277],mem[276]} = 32'h40215213; // srai x4 x2 2	
     {mem[283],mem[282],mem[281],mem[280]} = 32'hff800293; // addi x5 x0 -8	
     {mem[287],mem[286],mem[285],mem[284]} = 32'h4012d193; // srai x3 x5 1	
     {mem[291],mem[290],mem[289],mem[288]} = 32'h0012d313; // srli x6 x5 1	
     {mem[295],mem[294],mem[293],mem[292]} = 32'h00100093; // addi x1 x0 1	
     {mem[299],mem[298],mem[297],mem[296]} = 32'h00200113; // addi x2 x0 2	
     {mem[303],mem[302],mem[301],mem[300]} = 32'h001111b3; // sll x3 x2 x1	
     {mem[307],mem[306],mem[305],mem[304]} = 32'h4011d233; // sra x4 x3 x1	
     {mem[311],mem[310],mem[309],mem[308]} = 32'h4012d333; // sra x6 x5 x1	
     {mem[315],mem[314],mem[313],mem[312]} = 32'h0012d3b3; // srl x7 x5 x1	
     {mem[319],mem[318],mem[317],mem[316]} = 32'h00500093; // addi x1 x0 5	
     {mem[323],mem[322],mem[321],mem[320]} = 32'hffb00113; // addi x2 x0 -5	
     {mem[327],mem[326],mem[325],mem[324]} = 32'h002081b3; // add x3 x1 x2	
     {mem[331],mem[330],mem[329],mem[328]} = 32'h00108233; // add x4 x1 x1	
     {mem[335],mem[334],mem[333],mem[332]} = 32'h402082b3; // sub x5 x1 x2	
     {mem[339],mem[338],mem[337],mem[336]} = 32'h40110333; // sub x6 x2 x1	
     {mem[343],mem[342],mem[341],mem[340]} = 32'h402103b3; // sub x7 x2 x2	
     {mem[347],mem[346],mem[345],mem[344]} = 32'h40108433; // sub x8 x1 x1	
     {mem[351],mem[350],mem[349],mem[348]} = 32'h0000a083; // lw x1 0(x1)	
     {mem[355],mem[354],mem[353],mem[352]} = 32'h001080b3; // add x1 x1 x1	
     {mem[359],mem[358],mem[357],mem[356]} = 32'h00100093; // addi x1 x0 1	
     {mem[363],mem[362],mem[361],mem[360]} = 32'h00200113; // addi x2 x0 2	
     {mem[367],mem[366],mem[365],mem[364]} = 32'h00116193; // ori x3 x2 1	
     {mem[371],mem[370],mem[369],mem[368]} = 32'h00600313; // addi x6 x0 6	
     {mem[375],mem[374],mem[373],mem[372]} = 32'h0061c233; // xor x4 x3 x6	
     {mem[379],mem[378],mem[377],mem[376]} = 32'h0061f2b3; // and x5 x3 x6	
     {mem[383],mem[382],mem[381],mem[380]} = 32'h00000073; // ecall
     {mem[387],mem[386],mem[385],mem[384]} = 32'h00010167; // jalr x2 x2 0	
     {mem[391],mem[390],mem[389],mem[388]} = 32'h00000073; // ecall

     mem[100]=8'd17; 
     mem[101]=8'd0; 
     mem[102]=8'd0; 
     mem[103]=8'd0; 
     mem[104]=8'd9;
     mem[105]=8'd0; 
     mem[106]=8'd0; 
     mem[107]=8'd0; 
     mem[108]=8'd25;
     mem[109]=8'd0; 
     mem[110]=8'd0; 
     mem[111]=8'd0;  
     mem[112]=8'd0; 
     
     mem[112]=8'd0;
     mem[113] = 8'd0;
     mem[114] = 8'd0;
     mem[115] = 8'b10000000;
     
     offset = 8'd100;
   
   
   
   
   
//   // compressed instruction test case
   
   
//  {mem[3], mem[2],mem[1], mem[0]} = 32'b0000000_00000_00000_000_00000_0110011 ;   // add  x0, x0, x0     zeroing x0
   
//   {mem[5], mem[4]} = 16'b010_000_000_00_010_00;    // lw   x2, 0(x0)      loading 16 to x2
//   {mem[7], mem[6]} = 16'b010_000_000_10_011_00;    // lw   x3, 4(x0)     loading 5 in x3
   
   
//   {mem[9], mem[8]} = 16'b001_00000000110_01;    // jal  L1
//   {mem[13], mem[12],mem[11], mem[10]} = 32'b0000000_00000_00010_000_10110_1100011;    // beq  x2, x0, L2     shouldn't initially branch
//       // L1: 
//   {mem[15], mem[14]} = 16'b000_1_00010_11110_01;    // addi x2, x2, -2       should have 14 in x2
//   {mem[17], mem[16]} = 16'b100_0_00_011_00001_01;   // srli x3, x3, 1     should have 2 in x3
//   {mem[19], mem[18]} = 16'b000_0_00011_00010_10;    // slli x3, x3, 2     should have 8 in x3
//   {mem[21], mem[20]} = 16'b100_0_01_011_00001_01;    // srai x3, x3, 1        should have 4 in x3
   
//   {mem[23], mem[22]} = 16'b100_0_11_010_00_011_01;    // sub  x2, x2, x3     should have 10 in x2
//   {mem[25], mem[24]} = 16'b100_0_10_010_00010_01;    // andi x2, x2, 2     should have 2 in x2
//   {mem[27], mem[26]} = 16'b100_0_11_010_01_010_01;    // xor  x2, x2, x2      should have 0 in x2
//   {mem[29], mem[28]} = 16'b100_1_00001_00000_10;    // jalr x1         should jump back to beq
   
//   {mem[31], mem[30]} = 16'b000_0_00010_00101_01;    // addi x2, x2, 5       should have 5 in x2
   
//       // L2:
//   {mem[33], mem[32]} = 16'b100_0_11_011_10_000_01;    // or   x3, x3, x0     should have 4 in x3
//   {mem[35], mem[34]} = 16'b100_0_11_011_11_000_01;    // and  x3, x3, x0     should have 0 in x3
//   {mem[37], mem[36]} = 16'b011_0_00011_00001_01;  // lui  x3, x3, 1     should have 4096 in x3
//   {mem[39], mem[38]} = 16'b110_001_011_10_000_00;    // sw   x3, 12(x0)     should have 4096 in memory at offset 12
//   {mem[41], mem[40]} = 16'b100_1_00000_00000_10;    //ecall
   
   
   
   
   
   
   
   
   
    end    
    
    wire [7:0] addr_w_offset;
    assign addr_w_offset = addr + offset;

    always@(*)begin
         if(sclk) data_out = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
          else if (mem_read == 1)
                case(AU_inst_sel) 
                    // LW case
                    2'b00 : data_out = {mem[addr_w_offset+3], mem[addr_w_offset+2], mem[addr_w_offset+1], mem[addr_w_offset]};
                    // LH, LHU cases
                    2'b01 : 
                    begin
                        case(signed_inst)
                            // LHU case (unsigned)
                            1'b0 : data_out = {16'b0, mem[addr_w_offset+1], mem[addr_w_offset]};
                            // LH case (signed)
                            1'b1 : data_out = {{16{mem[addr_w_offset+1][3]}}, mem[addr_w_offset+1], mem[addr_w_offset]};
                            // Default case if there is an error
                            default : data_out = 32'b0;
                        endcase
                    end
                    // LB, LBU cases
                    2'b10 : 
                    begin
                        case(signed_inst)
                            // LBU case (unsigned)
                            1'b0 : data_out = {24'b0, mem[addr_w_offset]};
                            // LB case (signed)
                            1'b1 : data_out = {{24{mem[addr_w_offset][3]}}, mem[addr_w_offset]};
                            // Default case if there is an error
                            default : data_out = 32'b0;
                        endcase
                    end
                    // Default case if there is an error
                    default : data_out = 32'b0;
                endcase
            else
                begin
                    data_out = 32'b0;
                end 
        end

    always @(*) begin
          if (~sclk && mem_write == 1)
            case(AU_inst_sel) 
                // SW case
                2'b00 : {mem[addr_w_offset+3], mem[addr_w_offset+2], mem[addr_w_offset+1], mem[addr_w_offset]} = data_in;
                // SH case
                2'b01 : { mem[addr_w_offset+1], mem[addr_w_offset] } = data_in[15:0];
                // SB case
                2'b10 : mem[addr_w_offset] = data_in[7:0];
                // Default case if there is an error
                default : mem[addr_w_offset] = mem[addr_w_offset];
             endcase
        else
            begin
                mem[addr_w_offset] = mem[addr_w_offset];
            end 
    end
endmodule
