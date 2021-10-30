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
`include "C:\Users\Kirolos Mikhail\Github\RISCV_Processor\Source Files\defines.v"

module branching_unit(
  input B,            //Branching signal from Control Unit
  input[2:0] funct3,  //Instruction[12:14]
  input Z,            //Zero Flag
  input C,            //Carry Flag
  input V,            //Overflow Flag
  input S,            //Negative Flag
  output reg branch       //Final branching decision
  );
  
  always@(*) begin
    if(B == `ONE) begin
      case(funct3)
        `BR_BEQ: branch = Z;           //BEQ
        `BR_BNE: branch = !Z;          //BNE
        `BR_BLT: branch = (S != V);    //BLT
        `BR_BGE: branch = (S == V);    //BGE
        `BR_BLTU: branch = !C;         //BLTU
        `BR_BGEU: branch = C;          //BGEU
        default: branch = ~B;          //default case: does not branch
      endcase
    end
    else
      branch = B;                   
  end
endmodule