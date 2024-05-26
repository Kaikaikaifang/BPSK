// ************************************************************
// Engineer: kaikai
//
// Create Date: 2024/05/26
// Design Name: BPSK
// Module Name: mux.v
// Tool versions: VsCode
// Description: 多路复用器
// Parameter:
// 1. 
// Input:
// 1. 
// Output:
// 1. 
// ************************************************************
module mux #(
    parameter WIDTH = 16
) (
    input                   sel,
    input       [WIDTH-1:0] in_1,
    input       [WIDTH-1:0] in_2,
    output wire [WIDTH-1:0] out
);
    assign out = sel ? in_1 : in_2;
endmodule
