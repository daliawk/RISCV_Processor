module nbitsll #(parameter n = 8)(
input [n-1:0] A,
output [n-1:0] B);

assign B = {A[n-2:0],1'b0};

endmodule