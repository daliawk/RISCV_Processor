
module n_bit_ALU #(parameter n=32)(
input [n-1:0] A,
input [n-1:0] B,
input [3:0]sel,
output reg [n-1:0] ALUout,
output zFlag,
output reg ofFlag
    );
    wire [n-1:0] anded;
    wire [n-1:0] ored;
    wire [n-1:0] summed;
    wire [n-1:0] subbed;
    wire [n-1:0] modedB;
    
    // anding
    assign anded = A&B;
    
    //oring
    assign ored  = A|B;
    
    //adding or subtracting
    n_bit_2x1_Multiplexer #(n) addsub ( B, ~B,sel[2], modedB);
    RCA8 #(n) addersubber  (A, modedB, sel[2],summed,Cout);
    assign subbed = summed;
    
    
    always@(*)
    begin
    // setting overflow flag
    if((sel == 4'b0010) || (sel == 4'b0110))
    ofFlag = (A[n-1] != B[n-1])? 1'b0:(A[n-1] == subbed[n-1])? 1'b0: 1'b1;
    else
    ofFlag = 1'b0;
    
    //choosing output
        case(sel)
        4'b0010: ALUout = summed;   //adding
        4'b0110: ALUout = subbed;   //subtracting
        4'b0000: ALUout = anded;    // anding
        4'b0001: ALUout = ored;     //oring
        default: ALUout = 0;        // zeros 
        endcase
    end
    
    assign zFlag = !(ALUout);
    
endmodule





/*
= (A[7] != B[7])? 1'b0:
            (A[7] == num[7])? 1'b0: 1'b1;
*/