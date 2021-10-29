
/********************************************************************* 
* Module: ALU_nbit.v 
* Project: RISV_Processor 
* Author:   Dalia Elnagar - daliawk@aucegypt.edu
*           Kareem A. Mohammed Talaat - kareemamr213@aucegypt.edu
*           Kirolos M. Mikhail - kirolosmorcos237@aucegypt.edu
* 
* Description: The ALU of the whole processor (the heart of it)
*
* Change history: 10/25/21 – Modified file to follow code guidelines 
*                 10/29/21 - Modified to add the rest of the RV32I Instructions
* 
**********************************************************************/ 

module ALU_nbit #(parameter n=32)(
input [n-1:0] A,
input [n-1:0] B,
input [3:0]alu_control,
output reg [n-1:0] ALUout,
output Z,
output V,
////////prone to error C is inside always block what happens if not add or sub
output reg C,
output S
);
    always@(*)
    begin
        //choosing output
        case(alu_control)
            ALU_ADD: // ading
                Ripple_Carry_Adder_nbit #(n) addersubber (A,modedB,0,summed,C);
            ALU_SUB: // subtracting
                Ripple_Carry_Adder_nbit #(n) addersubber (A, ~B, 1,summed,C);
            ALU_AND: // anding
                ALUout = A&B;
            ALU_OR:  // oring
                ALUout = A|B;
            ALU_XOR: // xoring
                ALUout = A^B;
            ALU_SRL: // shifting right logically
                ALUout = {1'b0,A[n-1:1]};
            ALU_SRA: // shifting right arithmetically
                ALUout = {A[n-1],A[n-1:1]};
            ALU_SLL: // shifting left
                ALUout = {A[n-2:0],1'b0};
            ALU_SLT: // setting on less than unsigned 
            begin
                if(A[n-1]!B[n-1]) 
                    ALUout = {31'b0,1;b0};
                else
                    ALUout = 32'b0;
                else if (A<B)
                    ALUout = {31'b0,1;b0};
                else
                    ALUout = 32'b0;
            end
            ALU_SLTU: // set on less than unsigned  
            begin
                if(A<B)
                    ALUout = {31'b0,1;b0}
                else
                    ALUout = 32'b0;
            end
            ALU_PASS: // pass A as it is
                ALUout = A
            default:  // default case gives out zeros
                ALUout = 0;
        endcase
    end
    
    assign Z = !(ALUout);
    ////////////////////// prone to error due to using ALUOUT
    assign V = (A[n-1] != B[n-1])? 1'b0:(A[n-1] == ALUout[n-1])? 1'b0: 1'b1;
    
endmodule

