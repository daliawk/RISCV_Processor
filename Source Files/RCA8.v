
module RCA8 #(parameter n=32)(
input  [n-1:0] A,
input  [n-1:0] B,
input   Cin,
output [n-1:0] S,
output Cout
);
wire c[n:0] ;
assign c[0] = Cin;
genvar i;
for (i=0; i<n; i=i+1) begin: loop
    adder u1 (c[i],A[i],B[i],c[i+1],S[i]);
  end
assign Cout = c[n];
endmodule