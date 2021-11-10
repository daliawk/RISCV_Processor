/*******************************************************************
*
* Module: branching_unit.v
* Project: RISCV_Processor
* Author: Dalia Elnagar (daliawk@aucegypt.edu)
* Description: This unit decides whether to branch or not based on the
*              Branching control signal, funct3 from the Instruction
*              and the ALU flags
*
* Change history: 10/29/21 – Created file 
*
**********************************************************************/

`timescale 1ns/1ns
`include "defines.v"

module branching_unit(
  input B,            //Branching signal from Control Unit
  input jump,
  input[2:0] funct3,  //Instruction[12:14]
  input [31:0] data1,
  input [31:0] data2,
  output reg [1:0] decision       //Final branching decision
  );
  
  always@(*) begin
    if(B == `ONE) begin
      if(jump) decision = 2'b01;
      else
      case(funct3)
        `BR_BEQ: decision = {1'b0,(data1 == data2)};           //BEQ
        `BR_BNE: decision = {1'b0,!(data1 == data2)};          //BNE
        `BR_BLT: decision = {1'b0,$signed(data1 < data2)};    //BLT
        `BR_BGE: decision = {1'b0,$signed(data1 >= data2)};    //BGE
        `BR_BLTU: decision = {1'b0,$unsigned(data1 < data2)};         //BLTU
        `BR_BGEU: decision = {1'b0,$unsigned(data1 >= data2)};          //BGEU
        default: decision = 1'b00;          //default case: does not branch
      endcase
    end
    else
      decision = (jump)? 2'b10: 2'b00;                   
  end
endmodule