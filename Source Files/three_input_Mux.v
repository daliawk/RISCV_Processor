`timescale 1ns / 1ps
/******************************************************************* * 
* Module:   Control_Unit.v 
* Project:  RISCV_PROCESSOR 
* Author:   Dalia Elnagar - daliawk@aucegypt.edu
*           Kareem A. Mohammed - kareemamr213@aucegypt.edu
*           Kirolos M. Mikhail - kirolosmorcos237@aucegypt.edu
*
* Description: This is the control unit (the brains of the processor) 
* 
* Change history: 10/29/21 – created a three input nbit multiplexer
**********************************************************************/ 



module three_input_Mux_nbit #(parameter n=32)(
input  [1:0] sel,
input  [n-1:0] A,
input  [n-1:0] B,
input  [n-1:0] C,
output reg [n-1:0] out
);

always@(*)
    begin
    case(sel)
        2'b00:
            out = A;
        2'b01:
            out = B;
        2'b10:
            out = C;
        default:
            out = 0;
    endcase
    end

endmodule