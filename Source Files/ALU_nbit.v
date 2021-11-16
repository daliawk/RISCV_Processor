
`timescale 1ns / 1ps
`include "defines.v"
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
*                 11/15/21 - Modified to add Multiplication and Division instructions (M)
**********************************************************************/ 

module ALU_nbit #(parameter n=32)(
input [n-1:0] A,
input [n-1:0] B,
input [4:0]alu_control,
output reg [n-1:0] ALUout,
output Z,
output V,
////////prone to error C is inside always block what happens if not add or sub
output C,
output S
);
    wire [n-1:0] summed;
    wire [n-1:0] subbed;
    wire [n-1:0] modedB;
    wire [(n+n-1):0] mul;
    
    wire cout;
    MUX_2x1_nbit #(n) addsub ( B, ~B,alu_control[0], modedB);
    Ripple_Carry_Adder_nbit #(n) addersubber  (A, modedB, alu_control[0],summed,cout);
    assign subbed = summed;
    assign C = cout;
    
    always@(*)
    begin
        //choosing output
        case(alu_control)
        
            `ALU_ADD: // adding
                ALUout = summed;

            `ALU_SUB: // subtracting
                ALUout = subbed;

            `ALU_AND: // anding
                ALUout = A&B;

            `ALU_OR:  // oring
                ALUout = A|B;
                
            `ALU_XOR: // xoring
                ALUout = A^B;

            `ALU_SRL: // shifting right logically
                ALUout = A>>B;

            `ALU_SRA: // shifting right arithmetically
                ALUout = $signed(A)>>>B;

            `ALU_SRAI:
                ALUout = $signed(A)>>>B[5:0];

            `ALU_SLL: // shifting left
                ALUout = A<<B;

            `ALU_SLT: // setting on less than unsigned 
                begin 
                    if(A[n-1]& !B[n-1])
                        ALUout = {31'b0,1'b1};
                    else 
                    if (A<B)
                        ALUout = {31'b0,1'b1};
                    else
                        ALUout = 32'b0;
                end

            `ALU_SLTU: // set on less than unsigned  
                begin
                    if(A<B)
                        ALUout = {31'b0,1'b1};
                    else
                        ALUout = 32'b0;
                end

            `ALU_MUL: // multiplies rs1 and rs2 and stores the lower 32 bits of the reslt in rd
                ALUout = $signed(A)*$signed(B);

            `ALU_MULH: // multiplies 2 signed operands rs1 and rs2 and stores the upper 32 bits in rd.
                ALUout = ($signed(A) * $signed(B)) >>> 32;

            `ALU_MULHSU: // multiplies signed operand rs1 and unsigned r operands2 and stores the upper 32 bits in rd.
                ALUout = ($signed(A) * B) >>> 32;

            `ALU_MULHU: // multiplies 2 unsigned operands rs1 and rs2 and stores the upper 32 bits in rd.
                ALUout = (A * B) >> 32;

            `ALU_DIV:  // divides two signed operands while taking into account the exceptions
                begin
                    if(B == 32'b0)
                        ALUout = -32'd1;
                    else    
                        begin
                            if(A == -32'd2147483648 && B == -32'd1)
                                ALUout = -32'd2147483648;
                            else
                                ALUout = $signed(A) / $signed(B);
                        end
                end
            `ALU_DIVU: // divides two unsigned operands while taking into account the exceptions
                begin
                    if(B == 32'b0)
                        ALUout = 32'd4294967295;
                    else
                        ALUout = A / B;
                end
            `ALU_REM: // gets the remainder of two signed operands while taking into account the exceptions
                begin
                    if(B == 32'b0)
                        ALUout = A;
                    else
                        begin
                            if(A == -32'd2147483648 && B == -32'd1)
                                ALUout = 32'b0;
                            else 
                                ALUout = $signed(A) % $signed(B);
                        end
                end
            `ALU_REMU: // gets the remainder of two unsigned operands while taking into account the exceptions
                begin
                    if(B == 32'b0)
                        ALUout = A;
                    else
                        ALUout = A % B;
                end
        endcase
    end
    
    assign Z = !(ALUout);

    //assign V = (A[n-1] != B[n-1])? 1'b0:(A[n-1] == ALUout[n-1])? 1'b0: 1'b1;
    assign V =  (A[n-1] ^ (modedB[n-1]) ^ summed[n-1] ^ C);
    
    assign S = ALUout[n-1];
    
endmodule

