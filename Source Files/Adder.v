    
module adder(
input Cin,
input A,
input B,
output Cout,
output S
    );
    assign {Cout,S} = A + B + Cin;
endmodule
